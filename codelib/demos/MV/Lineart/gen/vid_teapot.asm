teapotframecount equ 18 ; number of animations
teapotframetotal equ 256 ; total number of frames in animation 
; index table 
teapotframetab        fdb teapotframe0
       fdb teapotframe1
       fdb teapotframe2
       fdb teapotframe3
       fdb teapotframe4
       fdb teapotframe5
       fdb teapotframe6
       fdb teapotframe7
       fdb teapotframe8
       fdb teapotframe9
       fdb teapotframe10
       fdb teapotframe11
       fdb teapotframe12
       fdb teapotframe13
       fdb teapotframe14
       fdb teapotframe15
       fdb teapotframe16
       fdb teapotframe17

; Animation 0
teapotframe0:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-9,4)->(6,4)
       fcb 0 ; drawmode 
       fcb -4,-9 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:0|rel:0)
; node # 1 D(48,13)->(56,12)
       fcb 2 ; drawmode 
       fcb -9,57 ; starx/y relative to previous node
       fdb 17,-120 ; dx/dy. dx(abs:136|rel:-120) dy(abs:17|rel:17)
; node # 2 D(30,38)->(37,37)
       fcb 2 ; drawmode 
       fcb -25,-18 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:119|rel:-17) dy(abs:17|rel:0)
; node # 3 D(-10,33)->(1,33)
       fcb 2 ; drawmode 
       fcb 5,-40 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:187|rel:68) dy(abs:0|rel:-17)
; node # 4 D(-9,4)->(6,4)
       fcb 2 ; drawmode 
       fcb 29,1 ; starx/y relative to previous node
       fdb 0,69 ; dx/dy. dx(abs:256|rel:69) dy(abs:0|rel:0)
; node # 5 D(-5,-24)->(9,-24)
       fcb 2 ; drawmode 
       fcb 28,4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:238|rel:-18) dy(abs:0|rel:0)
; node # 6 D(49,-13)->(55,-13)
       fcb 2 ; drawmode 
       fcb -11,54 ; starx/y relative to previous node
       fdb 0,-136 ; dx/dy. dx(abs:102|rel:-136) dy(abs:0|rel:0)
; node # 7 D(44,-56)->(48,-55)
       fcb 2 ; drawmode 
       fcb 43,-5 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:68|rel:-34) dy(abs:-17|rel:-17)
; node # 8 D(56,-43)->(53,-42)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-51|rel:-119) dy(abs:-17|rel:0)
; node # 9 D(39,-37)->(32,-35)
       fcb 2 ; drawmode 
       fcb -6,-17 ; starx/y relative to previous node
       fdb -17,-68 ; dx/dy. dx(abs:-119|rel:-68) dy(abs:-34|rel:-17)
; node # 10 D(41,0)->(34,-1)
       fcb 2 ; drawmode 
       fcb -37,2 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:17|rel:51)
; node # 11 D(41,19)->(33,18)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:17|rel:0)
; node # 12 D(29,37)->(23,37)
       fcb 2 ; drawmode 
       fcb -18,-12 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:0|rel:-17)
; node # 13 D(-1,33)->(-7,34)
       fcb 2 ; drawmode 
       fcb 4,-30 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:-17|rel:-17)
; node # 14 D(2,15)->(-6,15)
       fcb 2 ; drawmode 
       fcb 18,3 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:0|rel:17)
; node # 15 D(4,-3)->(-4,-3)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 16 D(41,0)->(34,0)
       fcb 2 ; drawmode 
       fcb -3,37 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 17 D(64,-3)->(61,-4)
       fcb 2 ; drawmode 
       fcb 3,23 ; starx/y relative to previous node
       fdb 17,68 ; dx/dy. dx(abs:-51|rel:68) dy(abs:17|rel:17)
; node # 18 D(56,-43)->(53,-42)
       fcb 2 ; drawmode 
       fcb 40,-8 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:-17|rel:-34)
; node # 19 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb 11,-49 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:0|rel:17)
; node # 20 D(39,-37)->(32,-35)
       fcb 2 ; drawmode 
       fcb -17,32 ; starx/y relative to previous node
       fdb -34,-85 ; dx/dy. dx(abs:-119|rel:-85) dy(abs:-34|rel:-34)
; node # 21 D(8,-37)->(0,-36)
       fcb 2 ; drawmode 
       fcb 0,-31 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:-17|rel:17)
; node # 22 D(4,-3)->(-4,-3)
       fcb 2 ; drawmode 
       fcb -34,-4 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:17)
; node # 23 D(-32,-9)->(-40,-10)
       fcb 2 ; drawmode 
       fcb 6,-36 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:17|rel:17)
; node # 24 D(-37,9)->(-44,9)
       fcb 2 ; drawmode 
       fcb -18,-5 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:-17)
; node # 25 D(2,15)->(-6,15)
       fcb 2 ; drawmode 
       fcb -6,39 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 26 D(41,19)->(33,18)
       fcb 2 ; drawmode 
       fcb -4,39 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:17|rel:17)
; node # 27 D(65,19)->(62,18)
       fcb 2 ; drawmode 
       fcb 0,24 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:17|rel:0)
; node # 28 D(64,-3)->(61,-4)
       fcb 2 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:17|rel:0)
; node # 29 D(49,-13)->(55,-13)
       fcb 2 ; drawmode 
       fcb 10,-15 ; starx/y relative to previous node
       fdb -17,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:0|rel:-17)
; node # 30 D(48,13)->(56,12)
       fcb 2 ; drawmode 
       fcb -26,-1 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:136|rel:34) dy(abs:17|rel:17)
; node # 31 D(65,19)->(62,18)
       fcb 2 ; drawmode 
       fcb -6,17 ; starx/y relative to previous node
       fdb 0,-187 ; dx/dy. dx(abs:-51|rel:-187) dy(abs:17|rel:0)
; node # 32 D(44,39)->(44,38)
       fcb 2 ; drawmode 
       fcb -20,-21 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:17|rel:0)
; node # 33 D(30,38)->(37,37)
       fcb 2 ; drawmode 
       fcb 1,-14 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:119|rel:119) dy(abs:17|rel:0)
; node # 34 M(29,37)->(23,37)
       fcb 0 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -17,-221 ; dx/dy. dx(abs:-102|rel:-221) dy(abs:0|rel:-17)
; node # 35 D(44,39)->(44,38)
       fcb 2 ; drawmode 
       fcb -2,15 ; starx/y relative to previous node
       fdb 17,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:17|rel:17)
; node # 36 M(48,13)->(56,12)
       fcb 0 ; drawmode 
       fcb 26,4 ; starx/y relative to previous node
       fdb 0,136 ; dx/dy. dx(abs:136|rel:136) dy(abs:17|rel:0)
; node # 37 D(75,-28)->(84,-27)
       fcb 2 ; drawmode 
       fcb 41,27 ; starx/y relative to previous node
       fdb -34,17 ; dx/dy. dx(abs:153|rel:17) dy(abs:-17|rel:-34)
; node # 38 D(104,-54)->(114,-50)
       fcb 2 ; drawmode 
       fcb 26,29 ; starx/y relative to previous node
       fdb -51,17 ; dx/dy. dx(abs:170|rel:17) dy(abs:-68|rel:-51)
; node # 39 D(91,-49)->(98,-46)
       fcb 2 ; drawmode 
       fcb -5,-13 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:119|rel:-51) dy(abs:-51|rel:17)
; node # 40 D(51,-17)->(57,-17)
       fcb 2 ; drawmode 
       fcb -32,-40 ; starx/y relative to previous node
       fdb 51,-17 ; dx/dy. dx(abs:102|rel:-17) dy(abs:0|rel:51)
; node # 41 D(48,13)->(56,12)
       fcb 2 ; drawmode 
       fcb -30,-3 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:136|rel:34) dy(abs:17|rel:17)
; node # 42 D(43,-20)->(50,-20)
       fcb 2 ; drawmode 
       fcb 33,-5 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:119|rel:-17) dy(abs:0|rel:-17)
; node # 43 D(51,-17)->(57,-17)
       fcb 2 ; drawmode 
       fcb -3,8 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:102|rel:-17) dy(abs:0|rel:0)
; node # 44 M(84,-53)->(93,-50)
       fcb 0 ; drawmode 
       fcb 36,33 ; starx/y relative to previous node
       fdb -51,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-51|rel:-51)
; node # 45 D(91,-49)->(98,-46)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:119|rel:-34) dy(abs:-51|rel:0)
; node # 46 M(104,-54)->(113,-50)
       fcb 0 ; drawmode 
       fcb 5,13 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:153|rel:34) dy(abs:-68|rel:-17)
; node # 47 D(84,-53)->(93,-50)
       fcb 2 ; drawmode 
       fcb -1,-20 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-51|rel:17)
; node # 48 D(43,-20)->(50,-20)
       fcb 2 ; drawmode 
       fcb -33,-41 ; starx/y relative to previous node
       fdb 51,-34 ; dx/dy. dx(abs:119|rel:-34) dy(abs:0|rel:51)
; node # 49 M(44,-56)->(48,-55)
       fcb 0 ; drawmode 
       fcb 36,1 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:68|rel:-51) dy(abs:-17|rel:-17)
; node # 50 D(2,-67)->(12,-66)
       fcb 2 ; drawmode 
       fcb 11,-42 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:170|rel:102) dy(abs:-17|rel:0)
; node # 51 D(-5,-24)->(9,-24)
       fcb 2 ; drawmode 
       fcb -43,-7 ; starx/y relative to previous node
       fdb 17,68 ; dx/dy. dx(abs:238|rel:68) dy(abs:0|rel:17)
; node # 52 D(-52,-25)->(-45,-26)
       fcb 2 ; drawmode 
       fcb 1,-47 ; starx/y relative to previous node
       fdb 17,-119 ; dx/dy. dx(abs:119|rel:-119) dy(abs:17|rel:17)
; node # 53 D(-35,-65)->(-30,-66)
       fcb 2 ; drawmode 
       fcb 40,17 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:85|rel:-34) dy(abs:17|rel:0)
; node # 54 D(2,-67)->(12,-66)
       fcb 2 ; drawmode 
       fcb 2,37 ; starx/y relative to previous node
       fdb -34,85 ; dx/dy. dx(abs:170|rel:85) dy(abs:-17|rel:-34)
; node # 55 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -13,5 ; starx/y relative to previous node
       fdb 17,-204 ; dx/dy. dx(abs:-34|rel:-204) dy(abs:0|rel:17)
; node # 56 D(0,-63)->(-1,-63)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-17|rel:17) dy(abs:0|rel:0)
; node # 57 D(8,-65)->(7,-64)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:-17|rel:-17)
; node # 58 D(15,-61)->(14,-60)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:-17|rel:0)
; node # 59 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -7,-8 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:0|rel:17)
; node # 60 D(-35,-65)->(-30,-66)
       fcb 2 ; drawmode 
       fcb 11,-42 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:85|rel:119) dy(abs:17|rel:17)
; node # 61 D(-42,-54)->(-44,-55)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-34|rel:-119) dy(abs:17|rel:0)
; node # 62 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb 0,49 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-34|rel:0) dy(abs:0|rel:-17)
; node # 63 D(8,-37)->(0,-36)
       fcb 2 ; drawmode 
       fcb -17,1 ; starx/y relative to previous node
       fdb -17,-102 ; dx/dy. dx(abs:-136|rel:-102) dy(abs:-17|rel:-17)
; node # 64 D(-22,-43)->(-29,-44)
       fcb 2 ; drawmode 
       fcb 6,-30 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:17|rel:34)
; node # 65 D(-32,-9)->(-40,-10)
       fcb 2 ; drawmode 
       fcb -34,-10 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:17|rel:0)
; node # 66 D(-59,-18)->(-62,-19)
       fcb 2 ; drawmode 
       fcb 9,-27 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:17|rel:0)
; node # 67 D(-65,2)->(-68,2)
       fcb 2 ; drawmode 
       fcb -20,-6 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:0|rel:-17)
; node # 68 D(-37,9)->(-44,9)
       fcb 2 ; drawmode 
       fcb -7,28 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-119|rel:-68) dy(abs:0|rel:0)
; node # 69 D(-31,29)->(-37,30)
       fcb 2 ; drawmode 
       fcb -20,6 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:-17|rel:-17)
; node # 70 D(-52,26)->(-53,28)
       fcb 2 ; drawmode 
       fcb 3,-21 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:-17|rel:85) dy(abs:-34|rel:-17)
; node # 71 D(-65,2)->(-68,2)
       fcb 2 ; drawmode 
       fcb 24,-13 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:-51|rel:-34) dy(abs:0|rel:34)
; node # 72 D(-58,-1)->(-51,0)
       fcb 2 ; drawmode 
       fcb 3,7 ; starx/y relative to previous node
       fdb -17,170 ; dx/dy. dx(abs:119|rel:170) dy(abs:-17|rel:-17)
; node # 73 D(-46,28)->(-40,28)
       fcb 2 ; drawmode 
       fcb -29,12 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:102|rel:-17) dy(abs:0|rel:17)
; node # 74 D(-10,33)->(1,33)
       fcb 2 ; drawmode 
       fcb -5,36 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:187|rel:85) dy(abs:0|rel:0)
; node # 75 M(-1,33)->(-7,34)
       fcb 0 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb -17,-289 ; dx/dy. dx(abs:-102|rel:-289) dy(abs:-17|rel:-17)
; node # 76 D(-31,29)->(-37,30)
       fcb 2 ; drawmode 
       fcb 4,-30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:-17|rel:0)
; node # 77 M(-46,28)->(-40,28)
       fcb 0 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 17,204 ; dx/dy. dx(abs:102|rel:204) dy(abs:0|rel:17)
; node # 78 D(-52,26)->(-53,28)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb -34,-119 ; dx/dy. dx(abs:-17|rel:-119) dy(abs:-34|rel:-34)
; node # 79 M(-58,-1)->(-51,0)
       fcb 0 ; drawmode 
       fcb 27,-6 ; starx/y relative to previous node
       fdb 17,136 ; dx/dy. dx(abs:119|rel:136) dy(abs:-17|rel:17)
; node # 80 D(-52,-25)->(-45,-26)
       fcb 2 ; drawmode 
       fcb 24,6 ; starx/y relative to previous node
       fdb 34,0 ; dx/dy. dx(abs:119|rel:0) dy(abs:17|rel:34)
; node # 81 D(-59,-18)->(-62,-19)
       fcb 2 ; drawmode 
       fcb -7,-7 ; starx/y relative to previous node
       fdb 0,-170 ; dx/dy. dx(abs:-51|rel:-170) dy(abs:17|rel:0)
; node # 82 D(-42,-54)->(-44,-55)
       fcb 2 ; drawmode 
       fcb 36,17 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:17|rel:0)
; node # 83 D(-22,-43)->(-29,-44)
       fcb 2 ; drawmode 
       fcb -11,20 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-119|rel:-85) dy(abs:17|rel:0)
; node # 84 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb 11,29 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:-34|rel:85) dy(abs:0|rel:-17)
; node # 85 M(0,-63)->(-1,-63)
       fcb 0 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-17|rel:17) dy(abs:0|rel:0)
; node # 86 D(8,-59)->(6,-59)
       fcb 2 ; drawmode 
       fcb -4,8 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:0|rel:0)
; node # 87 D(15,-61)->(14,-60)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-17|rel:17) dy(abs:-17|rel:-17)
; node # 88 M(8,-65)->(7,-64)
       fcb 0 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:-17|rel:0)
; node # 89 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -11,-1 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:0|rel:17)
; node # 90 D(44,-56)->(47,-55)
       fcb 2 ; drawmode 
       fcb 2,37 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:51|rel:85) dy(abs:-17|rel:-17)
; node # 91 M(8,-59)->(6,-59)
       fcb 0 ; drawmode 
       fcb 3,-36 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-34|rel:-85) dy(abs:0|rel:17)
; node # 92 D(7,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-34|rel:0) dy(abs:0|rel:0)
; node # 93 M(-28,-30)->(-36,-30)
       fcb 0 ; drawmode 
       fcb -24,-35 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-136|rel:-102) dy(abs:0|rel:0)
; node # 94 D(-46,-28)->(-57,-28)
       fcb 2 ; drawmode 
       fcb -2,-18 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-187|rel:-51) dy(abs:0|rel:0)
; node # 95 D(-48,-14)->(-58,-14)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-170|rel:17) dy(abs:0|rel:0)
; node # 96 D(-39,1)->(-45,2)
       fcb 2 ; drawmode 
       fcb -15,9 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:-102|rel:68) dy(abs:-17|rel:-17)
; node # 97 D(-31,2)->(-38,3)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:-17|rel:0)
; node # 98 D(-40,-12)->(-51,-13)
       fcb 2 ; drawmode 
       fcb 14,-9 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:-187|rel:-68) dy(abs:17|rel:34)
; node # 99 D(-38,-25)->(-50,-26)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:17|rel:0)
; node # 100 D(-22,-27)->(-29,-28)
       fcb 2 ; drawmode 
       fcb 2,16 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-119|rel:85) dy(abs:17|rel:0)
; node # 101 D(-29,-30)->(-36,-30)
       fcb 2 ; drawmode 
       fcb 3,-7 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:-17)
; node # 102 D(-25,-33)->(-32,-34)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:17|rel:17)
; node # 103 D(-44,-30)->(-56,-32)
       fcb 2 ; drawmode 
       fcb -3,-19 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-204|rel:-85) dy(abs:34|rel:17)
; node # 104 D(-47,-9)->(-59,-9)
       fcb 2 ; drawmode 
       fcb -21,-3 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:-34)
; node # 105 D(-37,9)->(-44,9)
       fcb 2 ; drawmode 
       fcb -18,10 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-119|rel:85) dy(abs:0|rel:0)
; node # 106 D(-39,1)->(-45,2)
       fcb 2 ; drawmode 
       fcb 8,-2 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:-17|rel:-17)
; node # 107 M(-58,-1)->(-51,0)
       fcb 0 ; drawmode 
       fcb 2,-19 ; starx/y relative to previous node
       fdb 0,221 ; dx/dy. dx(abs:119|rel:221) dy(abs:-17|rel:0)
; node # 108 D(-9,4)->(6,4)
       fcb 2 ; drawmode 
       fcb -5,49 ; starx/y relative to previous node
       fdb 17,137 ; dx/dy. dx(abs:256|rel:137) dy(abs:0|rel:17)
; node # 109 M(-31,2)->(-38,3)
       fcb 0 ; drawmode 
       fcb 2,-22 ; starx/y relative to previous node
       fdb -17,-375 ; dx/dy. dx(abs:-119|rel:-375) dy(abs:-17|rel:-17)
; node # 110 D(-37,9)->(-44,9)
       fcb 2 ; drawmode 
       fcb -7,-6 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:17)
; node # 111 M(-39,1)->(-45,2)
       fcb 0 ; drawmode 
       fcb 8,-2 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:-17|rel:-17)
; node # 112 D(-31,2)->(-38,3)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:-17|rel:0)
; node # 113 M(-40,-12)->(-51,-13)
       fcb 0 ; drawmode 
       fcb 14,-9 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:-187|rel:-68) dy(abs:17|rel:34)
; node # 114 D(-47,-9)->(-59,-9)
       fcb 2 ; drawmode 
       fcb -3,-7 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:0|rel:-17)
; node # 115 D(-48,-14)->(-58,-14)
       fcb 2 ; drawmode 
       fcb 5,-1 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-170|rel:34) dy(abs:0|rel:0)
; node # 116 D(-40,-12)->(-51,-13)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-187|rel:-17) dy(abs:17|rel:17)
; node # 117 M(-38,-25)->(-50,-26)
       fcb 0 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:17|rel:0)
; node # 118 D(-46,-28)->(-56,-28)
       fcb 2 ; drawmode 
       fcb 3,-8 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-170|rel:34) dy(abs:0|rel:-17)
; node # 119 M(-38,-25)->(-50,-26)
       fcb 0 ; drawmode 
       fcb -3,8 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-204|rel:-34) dy(abs:17|rel:17)
; node # 120 D(-44,-30)->(-56,-32)
       fcb 2 ; drawmode 
       fcb 5,-6 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:34|rel:17)
; node # 121 M(-22,-27)->(-29,-28)
       fcb 0 ; drawmode 
       fcb -3,22 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:-119|rel:85) dy(abs:17|rel:-17)
; node # 122 D(-25,-33)->(-32,-34)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:17|rel:0)
       fcb  1  ; end of anim
; Animation 1
teapotframe1:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(6,4)->(21,4)
       fcb 0 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb 0,274 ; dx/dy. dx(abs:274|rel:274) dy(abs:0|rel:0)
; node # 1 D(56,12)->(62,11)
       fcb 2 ; drawmode 
       fcb -8,50 ; starx/y relative to previous node
       fdb 18,-165 ; dx/dy. dx(abs:109|rel:-165) dy(abs:18|rel:18)
; node # 2 D(37,37)->(38,36)
       fcb 2 ; drawmode 
       fcb -25,-19 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:18|rel:-91) dy(abs:18|rel:0)
; node # 3 D(1,33)->(12,32)
       fcb 2 ; drawmode 
       fcb 4,-36 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:201|rel:183) dy(abs:18|rel:0)
; node # 4 D(6,4)->(21,4)
       fcb 2 ; drawmode 
       fcb 29,5 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:274|rel:73) dy(abs:0|rel:-18)
; node # 5 D(9,-24)->(22,-24)
       fcb 2 ; drawmode 
       fcb 28,3 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:237|rel:-37) dy(abs:0|rel:0)
; node # 6 D(55,-13)->(60,-13)
       fcb 2 ; drawmode 
       fcb -11,46 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:91|rel:-146) dy(abs:0|rel:0)
; node # 7 D(48,-55)->(50,-53)
       fcb 2 ; drawmode 
       fcb 42,-7 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:36|rel:-55) dy(abs:-36|rel:-36)
; node # 8 D(53,-42)->(49,-41)
       fcb 2 ; drawmode 
       fcb -13,5 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:-18|rel:18)
; node # 9 D(32,-35)->(24,-35)
       fcb 2 ; drawmode 
       fcb -7,-21 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:0|rel:18)
; node # 10 D(34,-1)->(25,-1)
       fcb 2 ; drawmode 
       fcb -34,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 11 D(33,18)->(24,18)
       fcb 2 ; drawmode 
       fcb -19,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 12 D(23,37)->(18,36)
       fcb 2 ; drawmode 
       fcb -19,-10 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:18|rel:18)
; node # 13 D(-7,34)->(-14,34)
       fcb 2 ; drawmode 
       fcb 3,-30 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:-18)
; node # 14 D(-6,15)->(-15,15)
       fcb 2 ; drawmode 
       fcb 19,1 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 15 D(-4,-3)->(-13,-3)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 16 D(34,0)->(25,-1)
       fcb 2 ; drawmode 
       fcb -3,38 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:18)
; node # 17 D(61,-4)->(61,-4)
       fcb 2 ; drawmode 
       fcb 4,27 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:-18)
; node # 18 D(53,-42)->(49,-41)
       fcb 2 ; drawmode 
       fcb 38,-8 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-73|rel:-73) dy(abs:-18|rel:-18)
; node # 19 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb 12,-48 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:0|rel:73) dy(abs:0|rel:18)
; node # 20 D(32,-35)->(24,-35)
       fcb 2 ; drawmode 
       fcb -19,27 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:0)
; node # 21 D(0,-36)->(-8,-37)
       fcb 2 ; drawmode 
       fcb 1,-32 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 22 D(-4,-3)->(-13,-3)
       fcb 2 ; drawmode 
       fcb -33,-4 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:-18)
; node # 23 D(-40,-10)->(-47,-10)
       fcb 2 ; drawmode 
       fcb 7,-36 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 24 D(-44,9)->(-51,10)
       fcb 2 ; drawmode 
       fcb -19,-4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:-18)
; node # 25 D(-6,15)->(-15,15)
       fcb 2 ; drawmode 
       fcb -6,38 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:18)
; node # 26 D(33,18)->(24,18)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 27 D(62,18)->(58,18)
       fcb 2 ; drawmode 
       fcb 0,29 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-73|rel:91) dy(abs:0|rel:0)
; node # 28 D(61,-4)->(61,-4)
       fcb 2 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:0|rel:73) dy(abs:0|rel:0)
; node # 29 D(55,-13)->(60,-13)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:91|rel:91) dy(abs:0|rel:0)
; node # 30 D(56,12)->(62,11)
       fcb 2 ; drawmode 
       fcb -25,1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:109|rel:18) dy(abs:18|rel:18)
; node # 31 D(62,18)->(58,18)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb -18,-182 ; dx/dy. dx(abs:-73|rel:-182) dy(abs:0|rel:-18)
; node # 32 D(44,38)->(41,37)
       fcb 2 ; drawmode 
       fcb -20,-18 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:18|rel:18)
; node # 33 D(37,37)->(38,36)
       fcb 2 ; drawmode 
       fcb 1,-7 ; starx/y relative to previous node
       fdb 0,72 ; dx/dy. dx(abs:18|rel:72) dy(abs:18|rel:0)
; node # 34 M(23,37)->(18,36)
       fcb 0 ; drawmode 
       fcb 0,-14 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-91|rel:-109) dy(abs:18|rel:0)
; node # 35 D(44,38)->(41,37)
       fcb 2 ; drawmode 
       fcb -1,21 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:18|rel:0)
; node # 36 M(56,12)->(62,11)
       fcb 0 ; drawmode 
       fcb 26,12 ; starx/y relative to previous node
       fdb 0,163 ; dx/dy. dx(abs:109|rel:163) dy(abs:18|rel:0)
; node # 37 D(84,-27)->(88,-25)
       fcb 2 ; drawmode 
       fcb 39,28 ; starx/y relative to previous node
       fdb -54,-36 ; dx/dy. dx(abs:73|rel:-36) dy(abs:-36|rel:-54)
; node # 38 D(114,-50)->(117,-47)
       fcb 2 ; drawmode 
       fcb 23,30 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:54|rel:-19) dy(abs:-54|rel:-18)
; node # 39 D(98,-46)->(102,-43)
       fcb 2 ; drawmode 
       fcb -4,-16 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:-54|rel:0)
; node # 40 D(57,-17)->(57,-15)
       fcb 2 ; drawmode 
       fcb -29,-41 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:0|rel:-73) dy(abs:-36|rel:18)
; node # 41 D(56,12)->(62,11)
       fcb 2 ; drawmode 
       fcb -29,-1 ; starx/y relative to previous node
       fdb 54,109 ; dx/dy. dx(abs:109|rel:109) dy(abs:18|rel:54)
; node # 42 D(50,-20)->(55,-19)
       fcb 2 ; drawmode 
       fcb 32,-6 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:91|rel:-18) dy(abs:-18|rel:-36)
; node # 43 D(57,-17)->(57,-15)
       fcb 2 ; drawmode 
       fcb -3,7 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:0|rel:-91) dy(abs:-36|rel:-18)
; node # 44 M(93,-50)->(99,-47)
       fcb 0 ; drawmode 
       fcb 33,36 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:109|rel:109) dy(abs:-54|rel:-18)
; node # 45 D(98,-46)->(102,-43)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:73|rel:-36) dy(abs:-54|rel:0)
; node # 46 M(113,-50)->(117,-47)
       fcb 0 ; drawmode 
       fcb 4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:73|rel:0) dy(abs:-54|rel:0)
; node # 47 D(93,-50)->(99,-47)
       fcb 2 ; drawmode 
       fcb 0,-20 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:109|rel:36) dy(abs:-54|rel:0)
; node # 48 D(50,-20)->(55,-19)
       fcb 2 ; drawmode 
       fcb -30,-43 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:91|rel:-18) dy(abs:-18|rel:36)
; node # 49 M(48,-55)->(50,-53)
       fcb 0 ; drawmode 
       fcb 35,-2 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:36|rel:-55) dy(abs:-36|rel:-18)
; node # 50 D(12,-66)->(21,-65)
       fcb 2 ; drawmode 
       fcb 11,-36 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:164|rel:128) dy(abs:-18|rel:18)
; node # 51 D(9,-24)->(22,-24)
       fcb 2 ; drawmode 
       fcb -42,-3 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:237|rel:73) dy(abs:0|rel:18)
; node # 52 D(-45,-26)->(-36,-27)
       fcb 2 ; drawmode 
       fcb 2,-54 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:164|rel:-73) dy(abs:18|rel:18)
; node # 53 D(-30,-66)->(-23,-67)
       fcb 2 ; drawmode 
       fcb 40,15 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:18|rel:0)
; node # 54 D(12,-66)->(21,-65)
       fcb 2 ; drawmode 
       fcb 0,42 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:164|rel:36) dy(abs:-18|rel:-36)
; node # 55 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -12,-7 ; starx/y relative to previous node
       fdb 18,-164 ; dx/dy. dx(abs:0|rel:-164) dy(abs:0|rel:18)
; node # 56 D(-1,-63)->(-2,-63)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 57 D(7,-64)->(7,-64)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 58 D(14,-60)->(12,-60)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 59 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -6,-9 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 60 D(-30,-66)->(-23,-67)
       fcb 2 ; drawmode 
       fcb 12,-35 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:18|rel:18)
; node # 61 D(-44,-55)->(-45,-58)
       fcb 2 ; drawmode 
       fcb -11,-14 ; starx/y relative to previous node
       fdb 36,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:54|rel:36)
; node # 62 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -1,49 ; starx/y relative to previous node
       fdb -54,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:-54)
; node # 63 D(0,-36)->(-8,-37)
       fcb 2 ; drawmode 
       fcb -18,-5 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:18|rel:18)
; node # 64 D(-29,-44)->(-35,-45)
       fcb 2 ; drawmode 
       fcb 8,-29 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:0)
; node # 65 D(-40,-10)->(-47,-10)
       fcb 2 ; drawmode 
       fcb -34,-11 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:-18)
; node # 66 D(-62,-19)->(-62,-20)
       fcb 2 ; drawmode 
       fcb 9,-22 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:18|rel:18)
; node # 67 D(-68,2)->(-69,2)
       fcb 2 ; drawmode 
       fcb -21,-6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:-18)
; node # 68 D(-44,9)->(-51,10)
       fcb 2 ; drawmode 
       fcb -7,24 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:-18|rel:-18)
; node # 69 D(-37,30)->(-41,31)
       fcb 2 ; drawmode 
       fcb -21,7 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:-18|rel:0)
; node # 70 D(-53,28)->(-53,28)
       fcb 2 ; drawmode 
       fcb 2,-16 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:0|rel:73) dy(abs:0|rel:18)
; node # 71 D(-68,2)->(-69,2)
       fcb 2 ; drawmode 
       fcb 26,-15 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 72 D(-51,0)->(-41,0)
       fcb 2 ; drawmode 
       fcb 2,17 ; starx/y relative to previous node
       fdb 0,200 ; dx/dy. dx(abs:182|rel:200) dy(abs:0|rel:0)
; node # 73 D(-40,28)->(-31,29)
       fcb 2 ; drawmode 
       fcb -28,11 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:-18|rel:-18)
; node # 74 D(1,33)->(12,32)
       fcb 2 ; drawmode 
       fcb -5,41 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:201|rel:37) dy(abs:18|rel:36)
; node # 75 M(-7,34)->(-14,34)
       fcb 0 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -18,-329 ; dx/dy. dx(abs:-128|rel:-329) dy(abs:0|rel:-18)
; node # 76 D(-37,30)->(-41,31)
       fcb 2 ; drawmode 
       fcb 4,-30 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:-18|rel:-18)
; node # 77 M(-40,28)->(-31,29)
       fcb 0 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,237 ; dx/dy. dx(abs:164|rel:237) dy(abs:-18|rel:0)
; node # 78 D(-53,28)->(-53,28)
       fcb 2 ; drawmode 
       fcb 0,-13 ; starx/y relative to previous node
       fdb 18,-164 ; dx/dy. dx(abs:0|rel:-164) dy(abs:0|rel:18)
; node # 79 M(-51,0)->(-41,0)
       fcb 0 ; drawmode 
       fcb 28,2 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:182|rel:182) dy(abs:0|rel:0)
; node # 80 D(-45,-26)->(-36,-27)
       fcb 2 ; drawmode 
       fcb 26,6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:18|rel:18)
; node # 81 D(-62,-19)->(-62,-20)
       fcb 2 ; drawmode 
       fcb -7,-17 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:0|rel:-164) dy(abs:18|rel:0)
; node # 82 D(-44,-55)->(-45,-58)
       fcb 2 ; drawmode 
       fcb 36,18 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:54|rel:36)
; node # 83 D(-29,-44)->(-35,-45)
       fcb 2 ; drawmode 
       fcb -11,15 ; starx/y relative to previous node
       fdb -36,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:18|rel:-36)
; node # 84 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb 10,34 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:-18)
; node # 85 M(-1,-63)->(-2,-63)
       fcb 0 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 86 D(6,-59)->(4,-59)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 87 D(14,-60)->(12,-60)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 88 M(7,-64)->(7,-64)
       fcb 0 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 89 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -10,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 D(47,-55)->(50,-53)
       fcb 2 ; drawmode 
       fcb 1,42 ; starx/y relative to previous node
       fdb -36,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:-36|rel:-36)
; node # 91 M(6,-59)->(4,-59)
       fcb 0 ; drawmode 
       fcb 4,-41 ; starx/y relative to previous node
       fdb 36,-90 ; dx/dy. dx(abs:-36|rel:-90) dy(abs:0|rel:36)
; node # 92 D(5,-54)->(5,-54)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 93 M(-36,-30)->(-42,-32)
       fcb 0 ; drawmode 
       fcb -24,-41 ; starx/y relative to previous node
       fdb 36,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:36|rel:36)
; node # 94 D(-57,-28)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -2,-21 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-182|rel:-73) dy(abs:36|rel:0)
; node # 95 D(-58,-14)->(-69,-15)
       fcb 2 ; drawmode 
       fcb -14,-1 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:18|rel:-18)
; node # 96 D(-45,2)->(-52,2)
       fcb 2 ; drawmode 
       fcb -16,13 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:0|rel:-18)
; node # 97 D(-38,3)->(-46,2)
       fcb 2 ; drawmode 
       fcb -1,7 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:18|rel:18)
; node # 98 D(-51,-13)->(-63,-13)
       fcb 2 ; drawmode 
       fcb 16,-13 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:-18)
; node # 99 D(-50,-26)->(-61,-27)
       fcb 2 ; drawmode 
       fcb 13,1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:18|rel:18)
; node # 100 D(-29,-28)->(-36,-28)
       fcb 2 ; drawmode 
       fcb 2,21 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:0|rel:-18)
; node # 101 D(-36,-30)->(-42,-32)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:36|rel:36)
; node # 102 D(-32,-34)->(-38,-35)
       fcb 2 ; drawmode 
       fcb 4,4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:18|rel:-18)
; node # 103 D(-56,-32)->(-66,-32)
       fcb 2 ; drawmode 
       fcb -2,-24 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-182|rel:-73) dy(abs:0|rel:-18)
; node # 104 D(-59,-9)->(-69,-9)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:0|rel:0)
; node # 105 D(-44,9)->(-51,10)
       fcb 2 ; drawmode 
       fcb -18,15 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:-128|rel:54) dy(abs:-18|rel:-18)
; node # 106 D(-45,2)->(-52,2)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
; node # 107 M(-51,0)->(-41,0)
       fcb 0 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 0,310 ; dx/dy. dx(abs:182|rel:310) dy(abs:0|rel:0)
; node # 108 D(6,4)->(21,4)
       fcb 2 ; drawmode 
       fcb -4,57 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:274|rel:92) dy(abs:0|rel:0)
; node # 109 M(-38,3)->(-46,2)
       fcb 0 ; drawmode 
       fcb 1,-44 ; starx/y relative to previous node
       fdb 18,-420 ; dx/dy. dx(abs:-146|rel:-420) dy(abs:18|rel:18)
; node # 110 D(-44,9)->(-51,10)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-18|rel:-36)
; node # 111 M(-45,2)->(-52,2)
       fcb 0 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
; node # 112 D(-38,3)->(-46,2)
       fcb 2 ; drawmode 
       fcb -1,7 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:18|rel:18)
; node # 113 M(-51,-13)->(-63,-13)
       fcb 0 ; drawmode 
       fcb 16,-13 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:-18)
; node # 114 D(-59,-9)->(-69,-9)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-182|rel:37) dy(abs:0|rel:0)
; node # 115 D(-58,-14)->(-69,-15)
       fcb 2 ; drawmode 
       fcb 5,1 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:18|rel:18)
; node # 116 D(-51,-13)->(-63,-13)
       fcb 2 ; drawmode 
       fcb -1,7 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:-18)
; node # 117 M(-50,-26)->(-61,-27)
       fcb 0 ; drawmode 
       fcb 13,1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:18|rel:18)
; node # 118 D(-56,-28)->(-67,-30)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:36|rel:18)
; node # 119 M(-50,-26)->(-61,-27)
       fcb 0 ; drawmode 
       fcb -2,6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:18|rel:-18)
; node # 120 D(-56,-32)->(-66,-32)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-182|rel:19) dy(abs:0|rel:-18)
; node # 121 M(-29,-28)->(-36,-28)
       fcb 0 ; drawmode 
       fcb -4,27 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:-128|rel:54) dy(abs:0|rel:0)
; node # 122 D(-32,-34)->(-38,-35)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
       fcb  1  ; end of anim
; Animation 2
teapotframe2:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(21,4)->(35,3)
       fcb 0 ; drawmode 
       fcb -4,21 ; starx/y relative to previous node
       fdb 18,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:18|rel:18)
; node # 1 D(62,11)->(65,11)
       fcb 2 ; drawmode 
       fcb -7,41 ; starx/y relative to previous node
       fdb -18,-202 ; dx/dy. dx(abs:54|rel:-202) dy(abs:0|rel:-18)
; node # 2 D(38,36)->(45,36)
       fcb 2 ; drawmode 
       fcb -25,-24 ; starx/y relative to previous node
       fdb 0,74 ; dx/dy. dx(abs:128|rel:74) dy(abs:0|rel:0)
; node # 3 D(12,32)->(22,32)
       fcb 2 ; drawmode 
       fcb 4,-26 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:182|rel:54) dy(abs:0|rel:0)
; node # 4 D(21,4)->(35,3)
       fcb 2 ; drawmode 
       fcb 28,9 ; starx/y relative to previous node
       fdb 18,74 ; dx/dy. dx(abs:256|rel:74) dy(abs:18|rel:18)
; node # 5 D(22,-24)->(34,-23)
       fcb 2 ; drawmode 
       fcb 28,1 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:-18|rel:-36)
; node # 6 D(60,-13)->(63,-11)
       fcb 2 ; drawmode 
       fcb -11,38 ; starx/y relative to previous node
       fdb -18,-165 ; dx/dy. dx(abs:54|rel:-165) dy(abs:-36|rel:-18)
; node # 7 D(50,-53)->(51,-51)
       fcb 2 ; drawmode 
       fcb 40,-10 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:-36|rel:0)
; node # 8 D(49,-41)->(43,-40)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:-18|rel:18)
; node # 9 D(24,-35)->(16,-35)
       fcb 2 ; drawmode 
       fcb -6,-25 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:18)
; node # 10 D(25,-1)->(17,0)
       fcb 2 ; drawmode 
       fcb -34,1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-18|rel:-18)
; node # 11 D(24,18)->(17,17)
       fcb 2 ; drawmode 
       fcb -19,-1 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:36)
; node # 12 D(18,36)->(12,36)
       fcb 2 ; drawmode 
       fcb -18,-6 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:0|rel:-18)
; node # 13 D(-14,34)->(-19,34)
       fcb 2 ; drawmode 
       fcb 2,-32 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:0)
; node # 14 D(-15,15)->(-24,15)
       fcb 2 ; drawmode 
       fcb 19,-1 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:0)
; node # 15 D(-13,-3)->(-22,-3)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 16 D(25,-1)->(17,0)
       fcb 2 ; drawmode 
       fcb -2,38 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:-18|rel:-18)
; node # 17 D(61,-4)->(51,-3)
       fcb 2 ; drawmode 
       fcb 3,36 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-182|rel:-36) dy(abs:-18|rel:0)
; node # 18 D(49,-41)->(43,-40)
       fcb 2 ; drawmode 
       fcb 37,-12 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:-18|rel:0)
; node # 19 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb 13,-44 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:0|rel:18)
; node # 20 D(24,-35)->(16,-35)
       fcb 2 ; drawmode 
       fcb -19,19 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-146|rel:-110) dy(abs:0|rel:0)
; node # 21 D(-8,-37)->(-15,-37)
       fcb 2 ; drawmode 
       fcb 2,-32 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 22 D(-13,-3)->(-22,-3)
       fcb 2 ; drawmode 
       fcb -34,-5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 23 D(-47,-10)->(-53,-10)
       fcb 2 ; drawmode 
       fcb 7,-34 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 24 D(-51,10)->(-57,10)
       fcb 2 ; drawmode 
       fcb -20,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 25 D(-15,15)->(-24,15)
       fcb 2 ; drawmode 
       fcb -5,36 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 26 D(24,18)->(17,17)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:18|rel:18)
; node # 27 D(58,18)->(53,17)
       fcb 2 ; drawmode 
       fcb 0,34 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:18|rel:0)
; node # 28 D(61,-4)->(51,-3)
       fcb 2 ; drawmode 
       fcb 22,3 ; starx/y relative to previous node
       fdb -36,-91 ; dx/dy. dx(abs:-182|rel:-91) dy(abs:-18|rel:-36)
; node # 29 D(60,-13)->(63,-11)
       fcb 2 ; drawmode 
       fcb 9,-1 ; starx/y relative to previous node
       fdb -18,236 ; dx/dy. dx(abs:54|rel:236) dy(abs:-36|rel:-18)
; node # 30 D(62,11)->(65,11)
       fcb 2 ; drawmode 
       fcb -24,2 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:36)
; node # 31 D(58,18)->(53,17)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb 18,-145 ; dx/dy. dx(abs:-91|rel:-145) dy(abs:18|rel:18)
; node # 32 D(41,37)->(39,37)
       fcb 2 ; drawmode 
       fcb -19,-17 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:0|rel:-18)
; node # 33 D(38,36)->(45,36)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:0|rel:0)
; node # 34 M(18,36)->(12,36)
       fcb 0 ; drawmode 
       fcb 0,-20 ; starx/y relative to previous node
       fdb 0,-237 ; dx/dy. dx(abs:-109|rel:-237) dy(abs:0|rel:0)
; node # 35 D(41,37)->(39,37)
       fcb 2 ; drawmode 
       fcb -1,23 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:0|rel:0)
; node # 36 M(62,11)->(65,11)
       fcb 0 ; drawmode 
       fcb 26,21 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:54|rel:90) dy(abs:0|rel:0)
; node # 37 D(88,-25)->(91,-24)
       fcb 2 ; drawmode 
       fcb 36,26 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:-18|rel:-18)
; node # 38 D(117,-47)->(117,-43)
       fcb 2 ; drawmode 
       fcb 22,29 ; starx/y relative to previous node
       fdb -55,-54 ; dx/dy. dx(abs:0|rel:-54) dy(abs:-73|rel:-55)
; node # 39 D(102,-43)->(102,-41)
       fcb 2 ; drawmode 
       fcb -4,-15 ; starx/y relative to previous node
       fdb 37,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-36|rel:37)
; node # 40 D(57,-15)->(60,-15)
       fcb 2 ; drawmode 
       fcb -28,-45 ; starx/y relative to previous node
       fdb 36,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:0|rel:36)
; node # 41 D(62,11)->(65,11)
       fcb 2 ; drawmode 
       fcb -26,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:0)
; node # 42 D(55,-19)->(58,-18)
       fcb 2 ; drawmode 
       fcb 30,-7 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:-18|rel:-18)
; node # 43 D(57,-15)->(60,-15)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:18)
; node # 44 M(99,-47)->(100,-45)
       fcb 0 ; drawmode 
       fcb 32,42 ; starx/y relative to previous node
       fdb -36,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:-36|rel:-36)
; node # 45 D(102,-43)->(102,-41)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-36|rel:0)
; node # 46 M(116,-47)->(117,-43)
       fcb 0 ; drawmode 
       fcb 4,14 ; starx/y relative to previous node
       fdb -37,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-73|rel:-37)
; node # 47 D(99,-47)->(100,-45)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb 37,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-36|rel:37)
; node # 48 D(55,-19)->(58,-18)
       fcb 2 ; drawmode 
       fcb -28,-44 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:-18|rel:18)
; node # 49 M(50,-53)->(51,-51)
       fcb 0 ; drawmode 
       fcb 34,-5 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:-36|rel:-18)
; node # 50 D(21,-65)->(28,-65)
       fcb 2 ; drawmode 
       fcb 12,-29 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:128|rel:110) dy(abs:0|rel:36)
; node # 51 D(22,-24)->(34,-23)
       fcb 2 ; drawmode 
       fcb -41,1 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:219|rel:91) dy(abs:-18|rel:-18)
; node # 52 D(-36,-27)->(-25,-27)
       fcb 2 ; drawmode 
       fcb 3,-58 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:18)
; node # 53 D(-23,-67)->(-16,-68)
       fcb 2 ; drawmode 
       fcb 40,13 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:128|rel:-73) dy(abs:18|rel:18)
; node # 54 D(21,-65)->(28,-65)
       fcb 2 ; drawmode 
       fcb -2,44 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:0|rel:-18)
; node # 55 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb -11,-16 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-36|rel:-164) dy(abs:0|rel:0)
; node # 56 D(-2,-63)->(-3,-63)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:0)
; node # 57 D(7,-64)->(7,-64)
       fcb 2 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 58 D(12,-60)->(10,-60)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 59 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 60 D(-23,-67)->(-16,-68)
       fcb 2 ; drawmode 
       fcb 13,-28 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:18|rel:18)
; node # 61 D(-45,-58)->(-45,-59)
       fcb 2 ; drawmode 
       fcb -9,-22 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:18|rel:0)
; node # 62 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb -4,50 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:-18)
; node # 63 D(-8,-37)->(-15,-37)
       fcb 2 ; drawmode 
       fcb -17,-13 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:0|rel:0)
; node # 64 D(-35,-45)->(-41,-45)
       fcb 2 ; drawmode 
       fcb 8,-27 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:0|rel:0)
; node # 65 D(-47,-10)->(-53,-10)
       fcb 2 ; drawmode 
       fcb -35,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 66 D(-62,-20)->(-62,-20)
       fcb 2 ; drawmode 
       fcb 10,-15 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:0)
; node # 67 D(-69,2)->(-67,3)
       fcb 2 ; drawmode 
       fcb -22,-7 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:-18|rel:-18)
; node # 68 D(-51,10)->(-57,10)
       fcb 2 ; drawmode 
       fcb -8,18 ; starx/y relative to previous node
       fdb 18,-145 ; dx/dy. dx(abs:-109|rel:-145) dy(abs:0|rel:18)
; node # 69 D(-41,31)->(-45,31)
       fcb 2 ; drawmode 
       fcb -21,10 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:0)
; node # 70 D(-53,28)->(-51,28)
       fcb 2 ; drawmode 
       fcb 3,-12 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:0|rel:0)
; node # 71 D(-69,2)->(-67,3)
       fcb 2 ; drawmode 
       fcb 26,-16 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-18|rel:-18)
; node # 72 D(-41,0)->(-29,-1)
       fcb 2 ; drawmode 
       fcb 2,28 ; starx/y relative to previous node
       fdb 36,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:18|rel:36)
; node # 73 D(-31,29)->(-22,29)
       fcb 2 ; drawmode 
       fcb -29,10 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:164|rel:-55) dy(abs:0|rel:-18)
; node # 74 D(12,32)->(22,32)
       fcb 2 ; drawmode 
       fcb -3,43 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:0|rel:0)
; node # 75 M(-14,34)->(-19,34)
       fcb 0 ; drawmode 
       fcb -2,-26 ; starx/y relative to previous node
       fdb 0,-273 ; dx/dy. dx(abs:-91|rel:-273) dy(abs:0|rel:0)
; node # 76 D(-41,31)->(-45,31)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:0|rel:0)
; node # 77 M(-31,29)->(-22,29)
       fcb 0 ; drawmode 
       fcb 2,10 ; starx/y relative to previous node
       fdb 0,237 ; dx/dy. dx(abs:164|rel:237) dy(abs:0|rel:0)
; node # 78 D(-53,28)->(-51,28)
       fcb 2 ; drawmode 
       fcb 1,-22 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:36|rel:-128) dy(abs:0|rel:0)
; node # 79 M(-41,0)->(-29,-1)
       fcb 0 ; drawmode 
       fcb 28,12 ; starx/y relative to previous node
       fdb 18,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:18|rel:18)
; node # 80 D(-36,-27)->(-25,-27)
       fcb 2 ; drawmode 
       fcb 27,5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:-18)
; node # 81 D(-62,-20)->(-62,-20)
       fcb 2 ; drawmode 
       fcb -7,-26 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:0|rel:-201) dy(abs:0|rel:0)
; node # 82 D(-45,-58)->(-45,-59)
       fcb 2 ; drawmode 
       fcb 38,17 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:18)
; node # 83 D(-35,-45)->(-41,-45)
       fcb 2 ; drawmode 
       fcb -13,10 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:0|rel:-18)
; node # 84 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb 9,40 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:0|rel:0)
; node # 85 M(-2,-63)->(-3,-63)
       fcb 0 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:0)
; node # 86 D(4,-59)->(0,-59)
       fcb 2 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-73|rel:-55) dy(abs:0|rel:0)
; node # 87 D(12,-60)->(10,-60)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:0|rel:0)
; node # 88 M(7,-64)->(7,-64)
       fcb 0 ; drawmode 
       fcb 4,-5 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 89 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb -10,-2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 90 D(50,-53)->(51,-51)
       fcb 2 ; drawmode 
       fcb -1,45 ; starx/y relative to previous node
       fdb -36,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:-36|rel:-36)
; node # 91 M(4,-59)->(0,-59)
       fcb 0 ; drawmode 
       fcb 6,-46 ; starx/y relative to previous node
       fdb 36,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:0|rel:36)
; node # 92 D(5,-54)->(3,-54)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:0|rel:0)
; node # 93 M(-42,-32)->(-47,-32)
       fcb 0 ; drawmode 
       fcb -22,-47 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-91|rel:-55) dy(abs:0|rel:0)
; node # 94 D(-67,-30)->(-75,-31)
       fcb 2 ; drawmode 
       fcb -2,-25 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:18|rel:18)
; node # 95 D(-69,-15)->(-76,-15)
       fcb 2 ; drawmode 
       fcb -15,-2 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:-18)
; node # 96 D(-52,2)->(-57,1)
       fcb 2 ; drawmode 
       fcb -17,17 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:18|rel:18)
; node # 97 D(-46,2)->(-52,2)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:-18)
; node # 98 D(-63,-13)->(-71,-14)
       fcb 2 ; drawmode 
       fcb 15,-17 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:18|rel:18)
; node # 99 D(-61,-27)->(-70,-28)
       fcb 2 ; drawmode 
       fcb 14,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:18|rel:0)
; node # 100 D(-36,-28)->(-42,-29)
       fcb 2 ; drawmode 
       fcb 1,25 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:18|rel:0)
; node # 101 D(-42,-32)->(-47,-32)
       fcb 2 ; drawmode 
       fcb 4,-6 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:-18)
; node # 102 D(-38,-35)->(-45,-35)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 103 D(-66,-32)->(-77,-34)
       fcb 2 ; drawmode 
       fcb -3,-28 ; starx/y relative to previous node
       fdb 36,-73 ; dx/dy. dx(abs:-201|rel:-73) dy(abs:36|rel:36)
; node # 104 D(-69,-9)->(-79,-10)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-182|rel:19) dy(abs:18|rel:-18)
; node # 105 D(-51,10)->(-57,10)
       fcb 2 ; drawmode 
       fcb -19,18 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:0|rel:-18)
; node # 106 D(-52,2)->(-57,1)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:18)
; node # 107 M(-41,0)->(-29,-1)
       fcb 0 ; drawmode 
       fcb 2,11 ; starx/y relative to previous node
       fdb 0,310 ; dx/dy. dx(abs:219|rel:310) dy(abs:18|rel:0)
; node # 108 D(21,4)->(35,3)
       fcb 2 ; drawmode 
       fcb -4,62 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:256|rel:37) dy(abs:18|rel:0)
; node # 109 M(-46,2)->(-52,2)
       fcb 0 ; drawmode 
       fcb 2,-67 ; starx/y relative to previous node
       fdb -18,-365 ; dx/dy. dx(abs:-109|rel:-365) dy(abs:0|rel:-18)
; node # 110 D(-51,10)->(-57,10)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 111 M(-52,2)->(-57,1)
       fcb 0 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:18)
; node # 112 D(-46,2)->(-52,2)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:-18)
; node # 113 M(-63,-13)->(-71,-14)
       fcb 0 ; drawmode 
       fcb 15,-17 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:18|rel:18)
; node # 114 D(-69,-9)->(-79,-10)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-182|rel:-36) dy(abs:18|rel:0)
; node # 115 D(-69,-15)->(-76,-15)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:-128|rel:54) dy(abs:0|rel:-18)
; node # 116 D(-63,-13)->(-71,-14)
       fcb 2 ; drawmode 
       fcb -2,6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:18|rel:18)
; node # 117 M(-61,-27)->(-70,-28)
       fcb 0 ; drawmode 
       fcb 14,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:18|rel:0)
; node # 118 D(-67,-30)->(-75,-31)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:0)
; node # 119 M(-61,-27)->(-70,-28)
       fcb 0 ; drawmode 
       fcb -3,6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:18|rel:0)
; node # 120 D(-66,-32)->(-77,-34)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:36|rel:18)
; node # 121 M(-36,-28)->(-42,-29)
       fcb 0 ; drawmode 
       fcb -4,30 ; starx/y relative to previous node
       fdb -18,92 ; dx/dy. dx(abs:-109|rel:92) dy(abs:18|rel:-18)
; node # 122 D(-38,-35)->(-44,-35)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:-18)
       fcb  1  ; end of anim
; Animation 3
teapotframe3:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(35,3)->(45,3)
       fcb 0 ; drawmode 
       fcb -3,35 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:182|rel:182) dy(abs:0|rel:0)
; node # 1 D(65,11)->(65,11)
       fcb 2 ; drawmode 
       fcb -8,30 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:0|rel:0)
; node # 2 D(45,36)->(48,34)
       fcb 2 ; drawmode 
       fcb -25,-20 ; starx/y relative to previous node
       fdb 36,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:36|rel:36)
; node # 3 D(22,32)->(31,32)
       fcb 2 ; drawmode 
       fcb 4,-23 ; starx/y relative to previous node
       fdb -36,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:0|rel:-36)
; node # 4 D(35,3)->(46,3)
       fcb 2 ; drawmode 
       fcb 29,13 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:201|rel:37) dy(abs:0|rel:0)
; node # 5 D(34,-23)->(44,-23)
       fcb 2 ; drawmode 
       fcb 26,-1 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:182|rel:-19) dy(abs:0|rel:0)
; node # 6 D(63,-11)->(63,-11)
       fcb 2 ; drawmode 
       fcb -12,29 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:0|rel:0)
; node # 7 D(51,-51)->(50,-50)
       fcb 2 ; drawmode 
       fcb 40,-12 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-18|rel:-18)
; node # 8 D(43,-40)->(37,-38)
       fcb 2 ; drawmode 
       fcb -11,-8 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:-36|rel:-18)
; node # 9 D(16,-35)->(8,-34)
       fcb 2 ; drawmode 
       fcb -5,-27 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:-18|rel:18)
; node # 10 D(17,0)->(8,0)
       fcb 2 ; drawmode 
       fcb -35,1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:18)
; node # 11 D(17,17)->(8,17)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 12 D(12,36)->(5,36)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 13 D(-19,34)->(-27,34)
       fcb 2 ; drawmode 
       fcb 2,-31 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 14 D(-24,15)->(-32,15)
       fcb 2 ; drawmode 
       fcb 19,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 15 D(-22,-3)->(-31,-3)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 16 D(17,0)->(8,0)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 17 D(51,-3)->(45,-3)
       fcb 2 ; drawmode 
       fcb 3,34 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 18 D(43,-40)->(37,-38)
       fcb 2 ; drawmode 
       fcb 37,-8 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-36|rel:-36)
; node # 19 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb 14,-40 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:-18|rel:18)
; node # 20 D(16,-35)->(8,-34)
       fcb 2 ; drawmode 
       fcb -19,13 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-146|rel:-110) dy(abs:-18|rel:0)
; node # 21 D(-15,-37)->(-24,-37)
       fcb 2 ; drawmode 
       fcb 2,-31 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:18)
; node # 22 D(-22,-3)->(-31,-3)
       fcb 2 ; drawmode 
       fcb -34,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 23 D(-53,-10)->(-58,-11)
       fcb 2 ; drawmode 
       fcb 7,-31 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:18|rel:18)
; node # 24 D(-57,10)->(-61,10)
       fcb 2 ; drawmode 
       fcb -20,-4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:0|rel:-18)
; node # 25 D(-24,15)->(-32,15)
       fcb 2 ; drawmode 
       fcb -5,33 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:0|rel:0)
; node # 26 D(17,17)->(8,17)
       fcb 2 ; drawmode 
       fcb -2,41 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 27 D(53,17)->(47,16)
       fcb 2 ; drawmode 
       fcb 0,36 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:18|rel:18)
; node # 28 D(51,-3)->(45,-3)
       fcb 2 ; drawmode 
       fcb 20,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:-18)
; node # 29 D(63,-11)->(63,-11)
       fcb 2 ; drawmode 
       fcb 8,12 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:0)
; node # 30 D(65,11)->(65,11)
       fcb 2 ; drawmode 
       fcb -22,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(53,17)->(47,16)
       fcb 2 ; drawmode 
       fcb -6,-12 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:18|rel:18)
; node # 32 D(39,37)->(36,35)
       fcb 2 ; drawmode 
       fcb -20,-14 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:36|rel:18)
; node # 33 D(45,36)->(48,34)
       fcb 2 ; drawmode 
       fcb 1,6 ; starx/y relative to previous node
       fdb 0,108 ; dx/dy. dx(abs:54|rel:108) dy(abs:36|rel:0)
; node # 34 M(12,36)->(5,36)
       fcb 0 ; drawmode 
       fcb 0,-33 ; starx/y relative to previous node
       fdb -36,-182 ; dx/dy. dx(abs:-128|rel:-182) dy(abs:0|rel:-36)
; node # 35 D(39,37)->(36,35)
       fcb 2 ; drawmode 
       fcb -1,27 ; starx/y relative to previous node
       fdb 36,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:36|rel:36)
; node # 36 M(65,11)->(65,11)
       fcb 0 ; drawmode 
       fcb 26,26 ; starx/y relative to previous node
       fdb -36,54 ; dx/dy. dx(abs:0|rel:54) dy(abs:0|rel:-36)
; node # 37 D(91,-24)->(89,-22)
       fcb 2 ; drawmode 
       fcb 35,26 ; starx/y relative to previous node
       fdb -36,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:-36|rel:-36)
; node # 38 D(117,-43)->(113,-40)
       fcb 2 ; drawmode 
       fcb 19,26 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:-54|rel:-18)
; node # 39 D(102,-41)->(97,-39)
       fcb 2 ; drawmode 
       fcb -2,-15 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:-36|rel:18)
; node # 40 D(60,-15)->(61,-15)
       fcb 2 ; drawmode 
       fcb -26,-42 ; starx/y relative to previous node
       fdb 36,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:0|rel:36)
; node # 41 D(65,11)->(65,11)
       fcb 2 ; drawmode 
       fcb -26,5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 42 D(58,-18)->(59,-17)
       fcb 2 ; drawmode 
       fcb 29,-7 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:-18)
; node # 43 D(60,-15)->(61,-15)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:18)
; node # 44 M(100,-45)->(99,-42)
       fcb 0 ; drawmode 
       fcb 30,40 ; starx/y relative to previous node
       fdb -54,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-54|rel:-54)
; node # 45 D(102,-41)->(97,-39)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:-36|rel:18)
; node # 46 M(117,-43)->(113,-40)
       fcb 0 ; drawmode 
       fcb 2,15 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:-54|rel:-18)
; node # 47 D(100,-45)->(99,-42)
       fcb 2 ; drawmode 
       fcb 2,-17 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:-54|rel:0)
; node # 48 D(58,-18)->(59,-17)
       fcb 2 ; drawmode 
       fcb -27,-42 ; starx/y relative to previous node
       fdb 36,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:-18|rel:36)
; node # 49 M(51,-51)->(50,-50)
       fcb 0 ; drawmode 
       fcb 33,-7 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-18|rel:0)
; node # 50 D(28,-65)->(34,-63)
       fcb 2 ; drawmode 
       fcb 14,-23 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:109|rel:127) dy(abs:-36|rel:-18)
; node # 51 D(34,-23)->(44,-23)
       fcb 2 ; drawmode 
       fcb -42,6 ; starx/y relative to previous node
       fdb 36,73 ; dx/dy. dx(abs:182|rel:73) dy(abs:0|rel:36)
; node # 52 D(-25,-27)->(-13,-28)
       fcb 2 ; drawmode 
       fcb 4,-59 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:18|rel:18)
; node # 53 D(-16,-68)->(-8,-69)
       fcb 2 ; drawmode 
       fcb 41,9 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:18|rel:0)
; node # 54 D(28,-65)->(34,-63)
       fcb 2 ; drawmode 
       fcb -3,44 ; starx/y relative to previous node
       fdb -54,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:-36|rel:-54)
; node # 55 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 18,-145 ; dx/dy. dx(abs:-36|rel:-145) dy(abs:-18|rel:18)
; node # 56 D(-3,-63)->(-3,-63)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:18)
; node # 57 D(7,-64)->(6,-63)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-18|rel:-18)
; node # 58 D(10,-60)->(8,-60)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:18)
; node # 59 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:-18|rel:-18)
; node # 60 D(-16,-68)->(-8,-69)
       fcb 2 ; drawmode 
       fcb 14,-19 ; starx/y relative to previous node
       fdb 36,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:18|rel:36)
; node # 61 D(-45,-59)->(-43,-60)
       fcb 2 ; drawmode 
       fcb -9,-29 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:36|rel:-110) dy(abs:18|rel:0)
; node # 62 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb -5,48 ; starx/y relative to previous node
       fdb -36,-72 ; dx/dy. dx(abs:-36|rel:-72) dy(abs:-18|rel:-36)
; node # 63 D(-15,-37)->(-24,-37)
       fcb 2 ; drawmode 
       fcb -17,-18 ; starx/y relative to previous node
       fdb 18,-128 ; dx/dy. dx(abs:-164|rel:-128) dy(abs:0|rel:18)
; node # 64 D(-41,-45)->(-45,-47)
       fcb 2 ; drawmode 
       fcb 8,-26 ; starx/y relative to previous node
       fdb 36,91 ; dx/dy. dx(abs:-73|rel:91) dy(abs:36|rel:36)
; node # 65 D(-53,-10)->(-58,-11)
       fcb 2 ; drawmode 
       fcb -35,-12 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:18|rel:-18)
; node # 66 D(-62,-20)->(-58,-22)
       fcb 2 ; drawmode 
       fcb 10,-9 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:73|rel:164) dy(abs:36|rel:18)
; node # 67 D(-67,3)->(-63,2)
       fcb 2 ; drawmode 
       fcb -23,-5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:73|rel:0) dy(abs:18|rel:-18)
; node # 68 D(-57,10)->(-61,10)
       fcb 2 ; drawmode 
       fcb -7,10 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:-73|rel:-146) dy(abs:0|rel:-18)
; node # 69 D(-45,31)->(-48,32)
       fcb 2 ; drawmode 
       fcb -21,12 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:-18|rel:-18)
; node # 70 D(-51,28)->(-45,30)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb -18,163 ; dx/dy. dx(abs:109|rel:163) dy(abs:-36|rel:-18)
; node # 71 D(-67,3)->(-63,2)
       fcb 2 ; drawmode 
       fcb 25,-16 ; starx/y relative to previous node
       fdb 54,-36 ; dx/dy. dx(abs:73|rel:-36) dy(abs:18|rel:54)
; node # 72 D(-29,-1)->(-15,0)
       fcb 2 ; drawmode 
       fcb 4,38 ; starx/y relative to previous node
       fdb -36,183 ; dx/dy. dx(abs:256|rel:183) dy(abs:-18|rel:-36)
; node # 73 D(-22,29)->(-11,30)
       fcb 2 ; drawmode 
       fcb -30,7 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:201|rel:-55) dy(abs:-18|rel:0)
; node # 74 D(22,32)->(31,32)
       fcb 2 ; drawmode 
       fcb -3,44 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:0|rel:18)
; node # 75 M(-19,34)->(-26,34)
       fcb 0 ; drawmode 
       fcb -2,-41 ; starx/y relative to previous node
       fdb 0,-292 ; dx/dy. dx(abs:-128|rel:-292) dy(abs:0|rel:0)
; node # 76 D(-45,31)->(-48,32)
       fcb 2 ; drawmode 
       fcb 3,-26 ; starx/y relative to previous node
       fdb -18,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:-18|rel:-18)
; node # 77 M(-22,29)->(-11,30)
       fcb 0 ; drawmode 
       fcb 2,23 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:201|rel:255) dy(abs:-18|rel:0)
; node # 78 D(-51,28)->(-45,30)
       fcb 2 ; drawmode 
       fcb 1,-29 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:109|rel:-92) dy(abs:-36|rel:-18)
; node # 79 M(-29,-1)->(-15,0)
       fcb 0 ; drawmode 
       fcb 29,22 ; starx/y relative to previous node
       fdb 18,147 ; dx/dy. dx(abs:256|rel:147) dy(abs:-18|rel:18)
; node # 80 D(-25,-27)->(-13,-28)
       fcb 2 ; drawmode 
       fcb 26,4 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:18|rel:36)
; node # 81 D(-62,-20)->(-58,-22)
       fcb 2 ; drawmode 
       fcb -7,-37 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:73|rel:-146) dy(abs:36|rel:18)
; node # 82 D(-45,-59)->(-43,-60)
       fcb 2 ; drawmode 
       fcb 39,17 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:36|rel:-37) dy(abs:18|rel:-18)
; node # 83 D(-41,-45)->(-45,-47)
       fcb 2 ; drawmode 
       fcb -14,4 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:36|rel:18)
; node # 84 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb 9,44 ; starx/y relative to previous node
       fdb -54,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:-18|rel:-54)
; node # 85 M(-3,-63)->(-3,-63)
       fcb 0 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:18)
; node # 86 D(0,-59)->(0,-59)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 D(10,-60)->(8,-60)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 88 M(7,-64)->(6,-63)
       fcb 0 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-18|rel:-18)
; node # 89 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:-18|rel:0)
; node # 90 D(51,-51)->(50,-50)
       fcb 2 ; drawmode 
       fcb -3,48 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-18|rel:0)
; node # 91 M(0,-59)->(0,-59)
       fcb 0 ; drawmode 
       fcb 8,-51 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:18)
; node # 92 D(3,-54)->(1,-53)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:-18|rel:-18)
; node # 93 M(-47,-32)->(-51,-33)
       fcb 0 ; drawmode 
       fcb -22,-50 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:18|rel:36)
; node # 94 D(-75,-31)->(-83,-32)
       fcb 2 ; drawmode 
       fcb -1,-28 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:18|rel:0)
; node # 95 D(-76,-15)->(-85,-16)
       fcb 2 ; drawmode 
       fcb -16,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:18|rel:0)
; node # 96 D(-57,1)->(-61,2)
       fcb 2 ; drawmode 
       fcb -16,19 ; starx/y relative to previous node
       fdb -36,91 ; dx/dy. dx(abs:-73|rel:91) dy(abs:-18|rel:-36)
; node # 97 D(-52,2)->(-58,2)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:18)
; node # 98 D(-71,-14)->(-80,-14)
       fcb 2 ; drawmode 
       fcb 16,-19 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 99 D(-70,-28)->(-78,-29)
       fcb 2 ; drawmode 
       fcb 14,1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 100 D(-42,-29)->(-47,-30)
       fcb 2 ; drawmode 
       fcb 1,28 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:0)
; node # 101 D(-47,-32)->(-51,-33)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:18|rel:0)
; node # 102 D(-45,-35)->(-49,-37)
       fcb 2 ; drawmode 
       fcb 3,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:36|rel:18)
; node # 103 D(-77,-34)->(-85,-36)
       fcb 2 ; drawmode 
       fcb -1,-32 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:36|rel:0)
; node # 104 D(-79,-10)->(-88,-11)
       fcb 2 ; drawmode 
       fcb -24,-2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:18|rel:-18)
; node # 105 D(-57,10)->(-61,10)
       fcb 2 ; drawmode 
       fcb -20,22 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:-73|rel:91) dy(abs:0|rel:-18)
; node # 106 D(-57,1)->(-61,2)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:-18|rel:-18)
; node # 107 M(-29,-1)->(-15,0)
       fcb 0 ; drawmode 
       fcb 2,28 ; starx/y relative to previous node
       fdb 0,329 ; dx/dy. dx(abs:256|rel:329) dy(abs:-18|rel:0)
; node # 108 D(35,3)->(46,3)
       fcb 2 ; drawmode 
       fcb -4,64 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:201|rel:-55) dy(abs:0|rel:18)
; node # 109 M(7,-11)->(23,-12)
       fcb 0 ; drawmode 
       fcb 14,-28 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:292|rel:91) dy(abs:18|rel:18)
; node # 110 M(-75,-31)->(-83,-32)
       fcb 0 ; drawmode 
       fcb 20,-82 ; starx/y relative to previous node
       fdb 0,-438 ; dx/dy. dx(abs:-146|rel:-438) dy(abs:18|rel:0)
; node # 111 D(-77,-34)->(-85,-36)
       fcb 2 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:36|rel:18)
; node # 112 M(-57,10)->(-61,10)
       fcb 0 ; drawmode 
       fcb -44,20 ; starx/y relative to previous node
       fdb -36,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:0|rel:-36)
; node # 113 D(-52,2)->(-58,2)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:0)
; node # 114 M(-71,-14)->(-80,-14)
       fcb 0 ; drawmode 
       fcb 16,-19 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 115 D(-79,-10)->(-88,-11)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:18)
; node # 116 D(-76,-15)->(-85,-16)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:0)
; node # 117 D(-71,-14)->(-80,-14)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:-18)
; node # 118 M(-70,-28)->(-78,-29)
       fcb 0 ; drawmode 
       fcb 14,1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 119 D(-75,-31)->(-83,-32)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:0)
; node # 120 M(-70,-28)->(-78,-29)
       fcb 0 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:0)
; node # 121 D(-77,-34)->(-85,-36)
       fcb 2 ; drawmode 
       fcb 6,-7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:36|rel:18)
; node # 122 M(-42,-29)->(-47,-30)
       fcb 0 ; drawmode 
       fcb -5,35 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:-18)
; node # 123 D(-44,-35)->(-49,-37)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:36|rel:18)
       fcb  1  ; end of anim
; Animation 4
teapotframe4:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(45,3)->(55,3)
       fcb 0 ; drawmode 
       fcb -3,45 ; starx/y relative to previous node
       fdb 0,170 ; dx/dy. dx(abs:170|rel:170) dy(abs:0|rel:0)
; node # 1 D(65,11)->(64,10)
       fcb 2 ; drawmode 
       fcb -8,20 ; starx/y relative to previous node
       fdb 17,-187 ; dx/dy. dx(abs:-17|rel:-187) dy(abs:17|rel:17)
; node # 2 D(48,34)->(48,34)
       fcb 2 ; drawmode 
       fcb -23,-17 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:0|rel:17) dy(abs:0|rel:-17)
; node # 3 D(31,32)->(40,31)
       fcb 2 ; drawmode 
       fcb 2,-17 ; starx/y relative to previous node
       fdb 17,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:17|rel:17)
; node # 4 D(46,3)->(55,3)
       fcb 2 ; drawmode 
       fcb 29,15 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:0|rel:-17)
; node # 5 D(44,-23)->(51,-22)
       fcb 2 ; drawmode 
       fcb 26,-2 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:119|rel:-34) dy(abs:-17|rel:-17)
; node # 6 D(63,-11)->(60,-11)
       fcb 2 ; drawmode 
       fcb -12,19 ; starx/y relative to previous node
       fdb 17,-170 ; dx/dy. dx(abs:-51|rel:-170) dy(abs:0|rel:17)
; node # 7 D(50,-50)->(48,-48)
       fcb 2 ; drawmode 
       fcb 39,-13 ; starx/y relative to previous node
       fdb -34,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:-34|rel:-34)
; node # 8 D(37,-38)->(30,-38)
       fcb 2 ; drawmode 
       fcb -12,-13 ; starx/y relative to previous node
       fdb 34,-85 ; dx/dy. dx(abs:-119|rel:-85) dy(abs:0|rel:34)
; node # 9 D(8,-34)->(0,-34)
       fcb 2 ; drawmode 
       fcb -4,-29 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 10 D(8,0)->(0,0)
       fcb 2 ; drawmode 
       fcb -34,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 11 D(8,17)->(0,17)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 12 D(5,36)->(0,36)
       fcb 2 ; drawmode 
       fcb -19,-3 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-85|rel:51) dy(abs:0|rel:0)
; node # 13 D(-27,34)->(-32,35)
       fcb 2 ; drawmode 
       fcb 2,-32 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-85|rel:0) dy(abs:-17|rel:-17)
; node # 14 D(-32,15)->(-40,16)
       fcb 2 ; drawmode 
       fcb 19,-5 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-136|rel:-51) dy(abs:-17|rel:0)
; node # 15 D(-31,-3)->(-39,-3)
       fcb 2 ; drawmode 
       fcb 18,1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:17)
; node # 16 D(8,0)->(0,0)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 17 D(45,-3)->(37,-3)
       fcb 2 ; drawmode 
       fcb 3,37 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 18 D(37,-38)->(30,-38)
       fcb 2 ; drawmode 
       fcb 35,-8 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 19 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb 15,-36 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:-17|rel:102) dy(abs:0|rel:0)
; node # 20 D(8,-34)->(0,-34)
       fcb 2 ; drawmode 
       fcb -19,7 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-136|rel:-119) dy(abs:0|rel:0)
; node # 21 D(-24,-37)->(-31,-38)
       fcb 2 ; drawmode 
       fcb 3,-32 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:17|rel:17)
; node # 22 D(-31,-3)->(-39,-3)
       fcb 2 ; drawmode 
       fcb -34,-7 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:-17)
; node # 23 D(-58,-11)->(-61,-11)
       fcb 2 ; drawmode 
       fcb 8,-27 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:0|rel:0)
; node # 24 D(-61,10)->(-64,11)
       fcb 2 ; drawmode 
       fcb -21,-3 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:-17|rel:-17)
; node # 25 D(-32,15)->(-40,16)
       fcb 2 ; drawmode 
       fcb -5,29 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-136|rel:-85) dy(abs:-17|rel:0)
; node # 26 D(8,17)->(0,17)
       fcb 2 ; drawmode 
       fcb -2,40 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:17)
; node # 27 D(47,16)->(40,16)
       fcb 2 ; drawmode 
       fcb 1,39 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 28 D(45,-3)->(37,-3)
       fcb 2 ; drawmode 
       fcb 19,-2 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 29 D(63,-11)->(60,-11)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:0|rel:0)
; node # 30 D(65,11)->(64,10)
       fcb 2 ; drawmode 
       fcb -22,2 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:17|rel:17)
; node # 31 D(47,16)->(40,16)
       fcb 2 ; drawmode 
       fcb -5,-18 ; starx/y relative to previous node
       fdb -17,-102 ; dx/dy. dx(abs:-119|rel:-102) dy(abs:0|rel:-17)
; node # 32 D(36,35)->(30,35)
       fcb 2 ; drawmode 
       fcb -19,-11 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:0|rel:0)
; node # 33 D(48,34)->(48,34)
       fcb 2 ; drawmode 
       fcb 1,12 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:0)
; node # 34 M(5,36)->(0,36)
       fcb 0 ; drawmode 
       fcb -2,-43 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-85|rel:-85) dy(abs:0|rel:0)
; node # 35 D(36,35)->(30,35)
       fcb 2 ; drawmode 
       fcb 1,31 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-102|rel:-17) dy(abs:0|rel:0)
; node # 36 M(65,11)->(64,10)
       fcb 0 ; drawmode 
       fcb 24,29 ; starx/y relative to previous node
       fdb 17,85 ; dx/dy. dx(abs:-17|rel:85) dy(abs:17|rel:17)
; node # 37 D(89,-22)->(85,-22)
       fcb 2 ; drawmode 
       fcb 33,24 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:-68|rel:-51) dy(abs:0|rel:-17)
; node # 38 D(113,-40)->(106,-38)
       fcb 2 ; drawmode 
       fcb 18,24 ; starx/y relative to previous node
       fdb -34,-51 ; dx/dy. dx(abs:-119|rel:-51) dy(abs:-34|rel:-34)
; node # 39 D(97,-39)->(89,-36)
       fcb 2 ; drawmode 
       fcb -1,-16 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:-51|rel:-17)
; node # 40 D(61,-15)->(58,-14)
       fcb 2 ; drawmode 
       fcb -24,-36 ; starx/y relative to previous node
       fdb 34,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:-17|rel:34)
; node # 41 D(65,11)->(64,10)
       fcb 2 ; drawmode 
       fcb -26,4 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:17|rel:34)
; node # 42 D(59,-17)->(56,-15)
       fcb 2 ; drawmode 
       fcb 28,-6 ; starx/y relative to previous node
       fdb -51,-34 ; dx/dy. dx(abs:-51|rel:-34) dy(abs:-34|rel:-51)
; node # 43 D(61,-15)->(58,-14)
       fcb 2 ; drawmode 
       fcb -2,2 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:-17|rel:17)
; node # 44 M(99,-42)->(94,-39)
       fcb 0 ; drawmode 
       fcb 27,38 ; starx/y relative to previous node
       fdb -34,-34 ; dx/dy. dx(abs:-85|rel:-34) dy(abs:-51|rel:-34)
; node # 45 D(97,-39)->(89,-36)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-136|rel:-51) dy(abs:-51|rel:0)
; node # 46 M(113,-40)->(105,-38)
       fcb 0 ; drawmode 
       fcb 1,16 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:-34|rel:17)
; node # 47 D(99,-42)->(94,-39)
       fcb 2 ; drawmode 
       fcb 2,-14 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:-85|rel:51) dy(abs:-51|rel:-17)
; node # 48 D(59,-17)->(56,-15)
       fcb 2 ; drawmode 
       fcb -25,-40 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-51|rel:34) dy(abs:-34|rel:17)
; node # 49 M(50,-50)->(48,-48)
       fcb 0 ; drawmode 
       fcb 33,-9 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:-34|rel:0)
; node # 50 D(34,-63)->(39,-62)
       fcb 2 ; drawmode 
       fcb 13,-16 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:85|rel:119) dy(abs:-17|rel:17)
; node # 51 D(44,-23)->(51,-22)
       fcb 2 ; drawmode 
       fcb -40,10 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:119|rel:34) dy(abs:-17|rel:0)
; node # 52 D(-13,-28)->(0,-27)
       fcb 2 ; drawmode 
       fcb 5,-57 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:221|rel:102) dy(abs:-17|rel:0)
; node # 53 D(-8,-69)->(0,-68)
       fcb 2 ; drawmode 
       fcb 41,5 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:136|rel:-85) dy(abs:-17|rel:0)
; node # 54 D(34,-63)->(39,-62)
       fcb 2 ; drawmode 
       fcb -6,42 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:85|rel:-51) dy(abs:-17|rel:0)
; node # 55 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb -10,-33 ; starx/y relative to previous node
       fdb 17,-102 ; dx/dy. dx(abs:-17|rel:-102) dy(abs:0|rel:17)
; node # 56 D(-3,-63)->(-5,-63)
       fcb 2 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:0|rel:0)
; node # 57 D(6,-63)->(4,-63)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-34|rel:0) dy(abs:0|rel:0)
; node # 58 D(8,-60)->(5,-59)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-51|rel:-17) dy(abs:-17|rel:-17)
; node # 59 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb -7,-7 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:0|rel:17)
; node # 60 D(-8,-69)->(0,-68)
       fcb 2 ; drawmode 
       fcb 16,-9 ; starx/y relative to previous node
       fdb -17,153 ; dx/dy. dx(abs:136|rel:153) dy(abs:-17|rel:-17)
; node # 61 D(-43,-60)->(-40,-62)
       fcb 2 ; drawmode 
       fcb -9,-35 ; starx/y relative to previous node
       fdb 51,-85 ; dx/dy. dx(abs:51|rel:-85) dy(abs:34|rel:51)
; node # 62 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb -7,44 ; starx/y relative to previous node
       fdb -34,-68 ; dx/dy. dx(abs:-17|rel:-68) dy(abs:0|rel:-34)
; node # 63 D(-24,-37)->(-31,-38)
       fcb 2 ; drawmode 
       fcb -16,-25 ; starx/y relative to previous node
       fdb 17,-102 ; dx/dy. dx(abs:-119|rel:-102) dy(abs:17|rel:17)
; node # 64 D(-45,-47)->(-49,-48)
       fcb 2 ; drawmode 
       fcb 10,-21 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-68|rel:51) dy(abs:17|rel:0)
; node # 65 D(-58,-11)->(-61,-11)
       fcb 2 ; drawmode 
       fcb -36,-13 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-51|rel:17) dy(abs:0|rel:-17)
; node # 66 D(-58,-22)->(-52,-22)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:0|rel:0)
; node # 67 D(-63,2)->(-56,3)
       fcb 2 ; drawmode 
       fcb -24,-5 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:119|rel:17) dy(abs:-17|rel:-17)
; node # 68 D(-61,10)->(-64,11)
       fcb 2 ; drawmode 
       fcb -8,2 ; starx/y relative to previous node
       fdb 0,-170 ; dx/dy. dx(abs:-51|rel:-170) dy(abs:-17|rel:0)
; node # 69 D(-48,32)->(-49,34)
       fcb 2 ; drawmode 
       fcb -22,13 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:-34|rel:-17)
; node # 70 D(-45,30)->(-41,31)
       fcb 2 ; drawmode 
       fcb 2,3 ; starx/y relative to previous node
       fdb 17,85 ; dx/dy. dx(abs:68|rel:85) dy(abs:-17|rel:17)
; node # 71 D(-63,2)->(-56,3)
       fcb 2 ; drawmode 
       fcb 28,-18 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:119|rel:51) dy(abs:-17|rel:0)
; node # 72 D(-15,0)->(0,0)
       fcb 2 ; drawmode 
       fcb 2,48 ; starx/y relative to previous node
       fdb 17,137 ; dx/dy. dx(abs:256|rel:137) dy(abs:0|rel:17)
; node # 73 D(-11,30)->(0,30)
       fcb 2 ; drawmode 
       fcb -30,4 ; starx/y relative to previous node
       fdb 0,-69 ; dx/dy. dx(abs:187|rel:-69) dy(abs:0|rel:0)
; node # 74 D(31,32)->(40,31)
       fcb 2 ; drawmode 
       fcb -2,42 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:153|rel:-34) dy(abs:17|rel:17)
; node # 75 M(-26,34)->(-32,35)
       fcb 0 ; drawmode 
       fcb -2,-57 ; starx/y relative to previous node
       fdb -34,-255 ; dx/dy. dx(abs:-102|rel:-255) dy(abs:-17|rel:-34)
; node # 76 D(-48,32)->(-49,34)
       fcb 2 ; drawmode 
       fcb 2,-22 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:-17|rel:85) dy(abs:-34|rel:-17)
; node # 77 M(-11,30)->(0,30)
       fcb 0 ; drawmode 
       fcb 2,37 ; starx/y relative to previous node
       fdb 34,204 ; dx/dy. dx(abs:187|rel:204) dy(abs:0|rel:34)
; node # 78 D(-45,30)->(-41,31)
       fcb 2 ; drawmode 
       fcb 0,-34 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:68|rel:-119) dy(abs:-17|rel:-17)
; node # 79 M(-15,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 30,30 ; starx/y relative to previous node
       fdb 17,188 ; dx/dy. dx(abs:256|rel:188) dy(abs:0|rel:17)
; node # 80 D(-13,-28)->(0,-27)
       fcb 2 ; drawmode 
       fcb 28,2 ; starx/y relative to previous node
       fdb -17,-35 ; dx/dy. dx(abs:221|rel:-35) dy(abs:-17|rel:-17)
; node # 81 D(-58,-22)->(-52,-22)
       fcb 2 ; drawmode 
       fcb -6,-45 ; starx/y relative to previous node
       fdb 17,-119 ; dx/dy. dx(abs:102|rel:-119) dy(abs:0|rel:17)
; node # 82 D(-43,-60)->(-40,-62)
       fcb 2 ; drawmode 
       fcb 38,15 ; starx/y relative to previous node
       fdb 34,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:34|rel:34)
; node # 83 D(-45,-47)->(-49,-48)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:-68|rel:-119) dy(abs:17|rel:-17)
; node # 84 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb 6,46 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:-17|rel:51) dy(abs:0|rel:-17)
; node # 85 M(-3,-63)->(-5,-63)
       fcb 0 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:0|rel:0)
; node # 86 D(0,-59)->(-5,-59)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-85|rel:-51) dy(abs:0|rel:0)
; node # 87 D(8,-60)->(5,-59)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-51|rel:34) dy(abs:-17|rel:-17)
; node # 88 M(6,-63)->(4,-63)
       fcb 0 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:0|rel:17)
; node # 89 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-17|rel:17) dy(abs:0|rel:0)
; node # 90 D(50,-50)->(48,-48)
       fcb 2 ; drawmode 
       fcb -3,49 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:-34|rel:-34)
; node # 91 M(0,-59)->(-5,-59)
       fcb 0 ; drawmode 
       fcb 9,-50 ; starx/y relative to previous node
       fdb 34,-51 ; dx/dy. dx(abs:-85|rel:-51) dy(abs:0|rel:34)
; node # 92 D(1,-53)->(0,-53)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:-17|rel:68) dy(abs:0|rel:0)
; node # 93 M(-51,-33)->(-54,-34)
       fcb 0 ; drawmode 
       fcb -20,-52 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-51|rel:-34) dy(abs:17|rel:17)
; node # 94 D(-83,-32)->(-89,-34)
       fcb 2 ; drawmode 
       fcb -1,-32 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:-102|rel:-51) dy(abs:34|rel:17)
; node # 95 D(-85,-16)->(-90,-17)
       fcb 2 ; drawmode 
       fcb -16,-2 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-85|rel:17) dy(abs:17|rel:-17)
; node # 96 D(-61,2)->(-61,3)
       fcb 2 ; drawmode 
       fcb -18,24 ; starx/y relative to previous node
       fdb -34,85 ; dx/dy. dx(abs:0|rel:85) dy(abs:-17|rel:-34)
; node # 97 D(-58,2)->(-63,3)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-85|rel:-85) dy(abs:-17|rel:0)
; node # 98 D(-80,-14)->(-87,-15)
       fcb 2 ; drawmode 
       fcb 16,-22 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:-119|rel:-34) dy(abs:17|rel:34)
; node # 99 D(-78,-29)->(-86,-31)
       fcb 2 ; drawmode 
       fcb 15,2 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:34|rel:17)
; node # 100 D(-47,-30)->(-52,-31)
       fcb 2 ; drawmode 
       fcb 1,31 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:-85|rel:51) dy(abs:17|rel:-17)
; node # 101 D(-51,-33)->(-54,-34)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-51|rel:34) dy(abs:17|rel:0)
; node # 102 D(-49,-37)->(-52,-38)
       fcb 2 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:17|rel:0)
; node # 103 D(-85,-36)->(-93,-38)
       fcb 2 ; drawmode 
       fcb -1,-36 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-136|rel:-85) dy(abs:34|rel:17)
; node # 104 D(-88,-11)->(-95,-11)
       fcb 2 ; drawmode 
       fcb -25,-3 ; starx/y relative to previous node
       fdb -34,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:-34)
; node # 105 D(-61,10)->(-64,11)
       fcb 2 ; drawmode 
       fcb -21,27 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:-51|rel:68) dy(abs:-17|rel:-17)
; node # 106 D(-58,2)->(-63,3)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-85|rel:-34) dy(abs:-17|rel:0)
; node # 107 M(-15,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 2,43 ; starx/y relative to previous node
       fdb 17,341 ; dx/dy. dx(abs:256|rel:341) dy(abs:0|rel:17)
; node # 108 D(46,3)->(55,3)
       fcb 2 ; drawmode 
       fcb -3,61 ; starx/y relative to previous node
       fdb 0,-103 ; dx/dy. dx(abs:153|rel:-103) dy(abs:0|rel:0)
; node # 109 M(20,-10)->(10,-10)
       fcb 0 ; drawmode 
       fcb 13,-26 ; starx/y relative to previous node
       fdb 0,-323 ; dx/dy. dx(abs:-170|rel:-323) dy(abs:0|rel:0)
; node # 110 M(-83,-32)->(-89,-34)
       fcb 0 ; drawmode 
       fcb 22,-103 ; starx/y relative to previous node
       fdb 34,68 ; dx/dy. dx(abs:-102|rel:68) dy(abs:34|rel:34)
; node # 111 D(-85,-36)->(-93,-38)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:34|rel:0)
; node # 112 M(-61,10)->(-64,11)
       fcb 0 ; drawmode 
       fcb -46,24 ; starx/y relative to previous node
       fdb -51,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:-17|rel:-51)
; node # 113 D(-61,2)->(-61,3)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-17|rel:0)
; node # 114 M(-80,-14)->(-87,-15)
       fcb 0 ; drawmode 
       fcb 16,-19 ; starx/y relative to previous node
       fdb 34,-119 ; dx/dy. dx(abs:-119|rel:-119) dy(abs:17|rel:34)
; node # 115 D(-88,-11)->(-95,-11)
       fcb 2 ; drawmode 
       fcb -3,-8 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:-17)
; node # 116 D(-85,-16)->(-90,-17)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:17|rel:17)
; node # 117 D(-80,-14)->(-87,-15)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-119|rel:-34) dy(abs:17|rel:0)
; node # 118 M(-78,-29)->(-86,-31)
       fcb 0 ; drawmode 
       fcb 15,2 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:34|rel:17)
; node # 119 D(-83,-32)->(-89,-34)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:34|rel:0)
; node # 120 M(-78,-29)->(-86,-31)
       fcb 0 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:34|rel:0)
; node # 121 D(-85,-36)->(-93,-38)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:34|rel:0)
; node # 122 M(-47,-30)->(-52,-31)
       fcb 0 ; drawmode 
       fcb -6,38 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:-85|rel:51) dy(abs:17|rel:-17)
; node # 123 D(-49,-37)->(-52,-38)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-51|rel:34) dy(abs:17|rel:0)
       fcb  1  ; end of anim
; Animation 5
teapotframe5:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(55,3)->(62,3)
       fcb 0 ; drawmode 
       fcb -3,55 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:0|rel:0)
; node # 1 D(64,10)->(60,10)
       fcb 2 ; drawmode 
       fcb -7,9 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:-73|rel:-201) dy(abs:0|rel:0)
; node # 2 D(48,34)->(48,32)
       fcb 2 ; drawmode 
       fcb -24,-16 ; starx/y relative to previous node
       fdb 36,73 ; dx/dy. dx(abs:0|rel:73) dy(abs:36|rel:36)
; node # 3 D(40,31)->(46,30)
       fcb 2 ; drawmode 
       fcb 3,-8 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:109|rel:109) dy(abs:18|rel:-18)
; node # 4 D(55,3)->(62,3)
       fcb 2 ; drawmode 
       fcb 28,15 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:128|rel:19) dy(abs:0|rel:-18)
; node # 5 D(51,-22)->(57,-21)
       fcb 2 ; drawmode 
       fcb 25,-4 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:109|rel:-19) dy(abs:-18|rel:-18)
; node # 6 D(60,-11)->(56,-10)
       fcb 2 ; drawmode 
       fcb -11,9 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-73|rel:-182) dy(abs:-18|rel:0)
; node # 7 D(48,-48)->(44,-47)
       fcb 2 ; drawmode 
       fcb 37,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:-18|rel:0)
; node # 8 D(30,-38)->(23,-37)
       fcb 2 ; drawmode 
       fcb -10,-18 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:-18|rel:0)
; node # 9 D(0,-34)->(-9,-34)
       fcb 2 ; drawmode 
       fcb -4,-30 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:18)
; node # 10 D(0,0)->(-9,0)
       fcb 2 ; drawmode 
       fcb -34,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 11 D(0,17)->(-9,18)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:-18)
; node # 12 D(0,36)->(-6,36)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:18)
; node # 13 D(-32,35)->(-36,35)
       fcb 2 ; drawmode 
       fcb 1,-32 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:0)
; node # 14 D(-40,16)->(-47,17)
       fcb 2 ; drawmode 
       fcb 19,-8 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:-18|rel:-18)
; node # 15 D(-39,-3)->(-46,-3)
       fcb 2 ; drawmode 
       fcb 19,1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
; node # 16 D(0,0)->(-9,0)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 17 D(37,-3)->(29,-3)
       fcb 2 ; drawmode 
       fcb 3,37 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 18 D(30,-38)->(23,-37)
       fcb 2 ; drawmode 
       fcb 35,-7 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-18|rel:-18)
; node # 19 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb 15,-30 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:0|rel:18)
; node # 20 D(0,-34)->(-9,-34)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-164|rel:-128) dy(abs:0|rel:0)
; node # 21 D(-31,-38)->(-38,-38)
       fcb 2 ; drawmode 
       fcb 4,-31 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 22 D(-39,-3)->(-46,-3)
       fcb 2 ; drawmode 
       fcb -35,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 23 D(-61,-11)->(-63,-11)
       fcb 2 ; drawmode 
       fcb 8,-22 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:0|rel:0)
; node # 24 D(-64,11)->(-66,11)
       fcb 2 ; drawmode 
       fcb -22,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 25 D(-40,16)->(-47,17)
       fcb 2 ; drawmode 
       fcb -5,24 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:-18|rel:-18)
; node # 26 D(0,17)->(-9,18)
       fcb 2 ; drawmode 
       fcb -1,40 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:0)
; node # 27 D(40,16)->(32,15)
       fcb 2 ; drawmode 
       fcb 1,40 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:36)
; node # 28 D(37,-3)->(29,-3)
       fcb 2 ; drawmode 
       fcb 19,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:-18)
; node # 29 D(60,-11)->(56,-10)
       fcb 2 ; drawmode 
       fcb 8,23 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:-18|rel:-18)
; node # 30 D(64,10)->(60,10)
       fcb 2 ; drawmode 
       fcb -21,4 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:0|rel:18)
; node # 31 D(40,16)->(32,15)
       fcb 2 ; drawmode 
       fcb -6,-24 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:18|rel:18)
; node # 32 D(30,35)->(24,35)
       fcb 2 ; drawmode 
       fcb -19,-10 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:-18)
; node # 33 D(48,34)->(48,32)
       fcb 2 ; drawmode 
       fcb 1,18 ; starx/y relative to previous node
       fdb 36,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:36|rel:36)
; node # 34 M(0,36)->(-6,36)
       fcb 0 ; drawmode 
       fcb -2,-48 ; starx/y relative to previous node
       fdb -36,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:0|rel:-36)
; node # 35 D(30,35)->(24,35)
       fcb 2 ; drawmode 
       fcb 1,30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 36 M(64,10)->(60,10)
       fcb 0 ; drawmode 
       fcb 25,34 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:0)
; node # 37 D(85,-22)->(78,-20)
       fcb 2 ; drawmode 
       fcb 32,21 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:-36|rel:-36)
; node # 38 D(106,-38)->(96,-35)
       fcb 2 ; drawmode 
       fcb 16,21 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:-182|rel:-54) dy(abs:-54|rel:-18)
; node # 39 D(89,-36)->(83,-34)
       fcb 2 ; drawmode 
       fcb -2,-17 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:-36|rel:18)
; node # 40 D(58,-14)->(52,-14)
       fcb 2 ; drawmode 
       fcb -22,-31 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:36)
; node # 41 D(64,10)->(60,10)
       fcb 2 ; drawmode 
       fcb -24,6 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:0)
; node # 42 D(56,-15)->(55,-14)
       fcb 2 ; drawmode 
       fcb 25,-8 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:-18|rel:-18)
; node # 43 D(58,-14)->(52,-14)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:0|rel:18)
; node # 44 M(94,-39)->(87,-36)
       fcb 0 ; drawmode 
       fcb 25,36 ; starx/y relative to previous node
       fdb -54,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:-54|rel:-54)
; node # 45 D(89,-36)->(83,-34)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-36|rel:18)
; node # 46 M(105,-38)->(96,-35)
       fcb 0 ; drawmode 
       fcb 2,16 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-54|rel:-18)
; node # 47 D(94,-39)->(87,-36)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-54|rel:0)
; node # 48 D(56,-15)->(55,-14)
       fcb 2 ; drawmode 
       fcb -24,-38 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:-18|rel:36)
; node # 49 M(48,-48)->(44,-47)
       fcb 0 ; drawmode 
       fcb 33,-8 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-73|rel:-55) dy(abs:-18|rel:0)
; node # 50 D(39,-62)->(42,-60)
       fcb 2 ; drawmode 
       fcb 14,-9 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:-36|rel:-18)
; node # 51 D(51,-22)->(57,-21)
       fcb 2 ; drawmode 
       fcb -40,12 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:109|rel:55) dy(abs:-18|rel:18)
; node # 52 D(0,-27)->(12,-27)
       fcb 2 ; drawmode 
       fcb 5,-51 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:219|rel:110) dy(abs:0|rel:18)
; node # 53 D(0,-68)->(8,-68)
       fcb 2 ; drawmode 
       fcb 41,0 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:0|rel:0)
; node # 54 D(39,-62)->(42,-60)
       fcb 2 ; drawmode 
       fcb -6,39 ; starx/y relative to previous node
       fdb -36,-92 ; dx/dy. dx(abs:54|rel:-92) dy(abs:-36|rel:-36)
; node # 55 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb -9,-39 ; starx/y relative to previous node
       fdb 36,-90 ; dx/dy. dx(abs:-36|rel:-90) dy(abs:0|rel:36)
; node # 56 D(-5,-63)->(-6,-63)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:0)
; node # 57 D(4,-63)->(4,-63)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 58 D(5,-59)->(2,-59)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-54|rel:-54) dy(abs:0|rel:0)
; node # 59 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:0|rel:0)
; node # 60 D(0,-68)->(8,-68)
       fcb 2 ; drawmode 
       fcb 15,0 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:0|rel:0)
; node # 61 D(-40,-62)->(-35,-63)
       fcb 2 ; drawmode 
       fcb -6,-40 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:91|rel:-55) dy(abs:18|rel:18)
; node # 62 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb -9,40 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-36|rel:-127) dy(abs:0|rel:-18)
; node # 63 D(-31,-38)->(-38,-38)
       fcb 2 ; drawmode 
       fcb -15,-31 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:0|rel:0)
; node # 64 D(-49,-48)->(-51,-50)
       fcb 2 ; drawmode 
       fcb 10,-18 ; starx/y relative to previous node
       fdb 36,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:36|rel:36)
; node # 65 D(-61,-11)->(-63,-11)
       fcb 2 ; drawmode 
       fcb -37,-12 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:-36)
; node # 66 D(-52,-22)->(-44,-23)
       fcb 2 ; drawmode 
       fcb 11,9 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:18|rel:18)
; node # 67 D(-56,3)->(-46,2)
       fcb 2 ; drawmode 
       fcb -25,-4 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:182|rel:36) dy(abs:18|rel:0)
; node # 68 D(-64,11)->(-66,11)
       fcb 2 ; drawmode 
       fcb -8,-8 ; starx/y relative to previous node
       fdb -18,-218 ; dx/dy. dx(abs:-36|rel:-218) dy(abs:0|rel:-18)
; node # 69 D(-49,34)->(-49,34)
       fcb 2 ; drawmode 
       fcb -23,15 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 70 D(-41,31)->(-32,32)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:164|rel:164) dy(abs:-18|rel:-18)
; node # 71 D(-56,3)->(-46,2)
       fcb 2 ; drawmode 
       fcb 28,-15 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:18|rel:36)
; node # 72 D(0,0)->(14,-1)
       fcb 2 ; drawmode 
       fcb 3,56 ; starx/y relative to previous node
       fdb 0,74 ; dx/dy. dx(abs:256|rel:74) dy(abs:18|rel:0)
; node # 73 D(0,30)->(10,30)
       fcb 2 ; drawmode 
       fcb -30,0 ; starx/y relative to previous node
       fdb -18,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:0|rel:-18)
; node # 74 D(40,31)->(46,30)
       fcb 2 ; drawmode 
       fcb -1,40 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:109|rel:-73) dy(abs:18|rel:18)
; node # 75 M(-32,35)->(-36,35)
       fcb 0 ; drawmode 
       fcb -4,-72 ; starx/y relative to previous node
       fdb -18,-182 ; dx/dy. dx(abs:-73|rel:-182) dy(abs:0|rel:-18)
; node # 76 D(-49,34)->(-48,34)
       fcb 2 ; drawmode 
       fcb 1,-17 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:0|rel:0)
; node # 77 M(0,30)->(10,30)
       fcb 0 ; drawmode 
       fcb 4,49 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:182|rel:164) dy(abs:0|rel:0)
; node # 78 D(-41,31)->(-32,32)
       fcb 2 ; drawmode 
       fcb -1,-41 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:-18|rel:-18)
; node # 79 M(0,0)->(14,-1)
       fcb 0 ; drawmode 
       fcb 31,41 ; starx/y relative to previous node
       fdb 36,92 ; dx/dy. dx(abs:256|rel:92) dy(abs:18|rel:36)
; node # 80 D(0,-27)->(12,-27)
       fcb 2 ; drawmode 
       fcb 27,0 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:0|rel:-18)
; node # 81 D(-52,-22)->(-44,-23)
       fcb 2 ; drawmode 
       fcb -5,-52 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:18|rel:18)
; node # 82 D(-40,-62)->(-35,-63)
       fcb 2 ; drawmode 
       fcb 40,12 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:91|rel:-55) dy(abs:18|rel:0)
; node # 83 D(-49,-48)->(-51,-50)
       fcb 2 ; drawmode 
       fcb -14,-9 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-36|rel:-127) dy(abs:36|rel:18)
; node # 84 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb 5,49 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:-36)
; node # 85 M(-5,-63)->(-6,-63)
       fcb 0 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:0)
; node # 86 D(-5,-59)->(-7,-59)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 87 D(5,-59)->(2,-59)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:0|rel:0)
; node # 88 M(4,-63)->(4,-63)
       fcb 0 ; drawmode 
       fcb 4,-1 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:0|rel:54) dy(abs:0|rel:0)
; node # 89 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 90 D(48,-48)->(44,-47)
       fcb 2 ; drawmode 
       fcb -5,48 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:-18|rel:-18)
; node # 91 M(-5,-59)->(-7,-59)
       fcb 0 ; drawmode 
       fcb 11,-53 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:0|rel:18)
; node # 92 D(0,-53)->(-2,-53)
       fcb 2 ; drawmode 
       fcb -6,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 93 M(-54,-34)->(-55,-35)
       fcb 0 ; drawmode 
       fcb -19,-54 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:18)
; node # 94 D(-89,-34)->(-93,-36)
       fcb 2 ; drawmode 
       fcb 0,-35 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-73|rel:-55) dy(abs:36|rel:18)
; node # 95 D(-90,-17)->(-94,-18)
       fcb 2 ; drawmode 
       fcb -17,-1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:18|rel:-18)
; node # 96 D(-61,3)->(-62,3)
       fcb 2 ; drawmode 
       fcb -20,29 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:0|rel:-18)
; node # 97 D(-63,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 98 D(-87,-15)->(-93,-16)
       fcb 2 ; drawmode 
       fcb 18,-24 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:18|rel:18)
; node # 99 D(-86,-31)->(-92,-33)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:36|rel:18)
; node # 100 D(-52,-31)->(-55,-32)
       fcb 2 ; drawmode 
       fcb 0,34 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:18|rel:-18)
; node # 101 D(-54,-34)->(-55,-35)
       fcb 2 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:18|rel:0)
; node # 102 D(-52,-38)->(-54,-39)
       fcb 2 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:18|rel:0)
; node # 103 D(-93,-38)->(-98,-40)
       fcb 2 ; drawmode 
       fcb 0,-41 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-91|rel:-55) dy(abs:36|rel:18)
; node # 104 D(-95,-11)->(-100,-12)
       fcb 2 ; drawmode 
       fcb -27,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:18|rel:-18)
; node # 105 D(-64,11)->(-66,11)
       fcb 2 ; drawmode 
       fcb -22,31 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:0|rel:-18)
; node # 106 D(-61,3)->(-62,3)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:0)
; node # 107 M(0,0)->(14,-1)
       fcb 0 ; drawmode 
       fcb 3,61 ; starx/y relative to previous node
       fdb 18,274 ; dx/dy. dx(abs:256|rel:274) dy(abs:18|rel:18)
; node # 108 D(55,3)->(62,3)
       fcb 2 ; drawmode 
       fcb -3,55 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:128|rel:-128) dy(abs:0|rel:-18)
; node # 109 M(9,-11)->(18,-8)
       fcb 0 ; drawmode 
       fcb 14,-46 ; starx/y relative to previous node
       fdb -54,36 ; dx/dy. dx(abs:164|rel:36) dy(abs:-54|rel:-54)
; node # 110 M(-89,-34)->(-93,-36)
       fcb 0 ; drawmode 
       fcb 23,-98 ; starx/y relative to previous node
       fdb 90,-237 ; dx/dy. dx(abs:-73|rel:-237) dy(abs:36|rel:90)
; node # 111 D(-93,-38)->(-98,-40)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:36|rel:0)
; node # 112 M(-64,11)->(-66,11)
       fcb 0 ; drawmode 
       fcb -49,29 ; starx/y relative to previous node
       fdb -36,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:0|rel:-36)
; node # 113 D(-63,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 114 M(-87,-15)->(-93,-16)
       fcb 0 ; drawmode 
       fcb 18,-24 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:18|rel:18)
; node # 115 D(-95,-11)->(-100,-12)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:0)
; node # 116 D(-90,-17)->(-94,-18)
       fcb 2 ; drawmode 
       fcb 6,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:18|rel:0)
; node # 117 D(-87,-15)->(-93,-16)
       fcb 2 ; drawmode 
       fcb -2,3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:18|rel:0)
; node # 118 M(-86,-31)->(-92,-33)
       fcb 0 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:36|rel:18)
; node # 119 D(-89,-34)->(-93,-36)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:36|rel:0)
; node # 120 M(-86,-31)->(-92,-33)
       fcb 0 ; drawmode 
       fcb -3,3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:36|rel:0)
; node # 121 D(-93,-38)->(-98,-40)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:36|rel:0)
; node # 122 M(-52,-31)->(-55,-32)
       fcb 0 ; drawmode 
       fcb -7,41 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:18|rel:-18)
; node # 123 D(-52,-38)->(-54,-39)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:18|rel:0)
       fcb  1  ; end of anim
; Animation 6
teapotframe6:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(60,10)->(57,10)
       fcb 0 ; drawmode 
       fcb -10,60 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-54|rel:-54) dy(abs:0|rel:0)
; node # 1 D(62,3)->(67,3)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:91|rel:145) dy(abs:0|rel:0)
; node # 2 D(46,30)->(49,30)
       fcb 2 ; drawmode 
       fcb -27,-16 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:0|rel:0)
; node # 3 D(48,32)->(45,31)
       fcb 2 ; drawmode 
       fcb -2,2 ; starx/y relative to previous node
       fdb 18,-108 ; dx/dy. dx(abs:-54|rel:-108) dy(abs:18|rel:18)
; node # 4 D(60,10)->(57,10)
       fcb 2 ; drawmode 
       fcb 22,12 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-54|rel:0) dy(abs:0|rel:-18)
; node # 5 D(62,3)->(67,3)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:91|rel:145) dy(abs:0|rel:0)
; node # 6 D(57,-21)->(60,-21)
       fcb 2 ; drawmode 
       fcb 24,-5 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:0|rel:0)
; node # 7 D(56,-10)->(53,-10)
       fcb 2 ; drawmode 
       fcb -11,-1 ; starx/y relative to previous node
       fdb 0,-108 ; dx/dy. dx(abs:-54|rel:-108) dy(abs:0|rel:0)
; node # 8 D(44,-47)->(40,-45)
       fcb 2 ; drawmode 
       fcb 37,-12 ; starx/y relative to previous node
       fdb -36,-19 ; dx/dy. dx(abs:-73|rel:-19) dy(abs:-36|rel:-36)
; node # 9 D(23,-37)->(15,-36)
       fcb 2 ; drawmode 
       fcb -10,-21 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:-18|rel:18)
; node # 10 D(-9,-34)->(-17,-35)
       fcb 2 ; drawmode 
       fcb -3,-32 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:36)
; node # 11 D(-9,0)->(-18,0)
       fcb 2 ; drawmode 
       fcb -34,0 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:-18)
; node # 12 D(-9,18)->(-17,18)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 13 D(-6,36)->(-12,36)
       fcb 2 ; drawmode 
       fcb -18,3 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 14 D(-36,35)->(-40,37)
       fcb 2 ; drawmode 
       fcb 1,-30 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-36|rel:-36)
; node # 15 D(-47,17)->(-54,17)
       fcb 2 ; drawmode 
       fcb 18,-11 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:36)
; node # 16 D(-46,-3)->(-52,-3)
       fcb 2 ; drawmode 
       fcb 20,1 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:0|rel:0)
; node # 17 D(-9,0)->(-18,0)
       fcb 2 ; drawmode 
       fcb -3,37 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 18 D(29,-3)->(21,-3)
       fcb 2 ; drawmode 
       fcb 3,38 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 19 D(23,-37)->(15,-36)
       fcb 2 ; drawmode 
       fcb 34,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-18|rel:-18)
; node # 20 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb 16,-25 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:0|rel:18)
; node # 21 D(-9,-34)->(-17,-35)
       fcb 2 ; drawmode 
       fcb -19,-7 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:-146|rel:-110) dy(abs:18|rel:18)
; node # 22 D(-38,-38)->(-44,-39)
       fcb 2 ; drawmode 
       fcb 4,-29 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:0)
; node # 23 D(-46,-3)->(-52,-3)
       fcb 2 ; drawmode 
       fcb -35,-8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:-18)
; node # 24 D(-63,-11)->(-63,-12)
       fcb 2 ; drawmode 
       fcb 8,-17 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:18|rel:18)
; node # 25 D(-66,11)->(-66,11)
       fcb 2 ; drawmode 
       fcb -22,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-18)
; node # 26 D(-47,17)->(-54,17)
       fcb 2 ; drawmode 
       fcb -6,19 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 27 D(-9,18)->(-17,18)
       fcb 2 ; drawmode 
       fcb -1,38 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 28 D(32,15)->(24,15)
       fcb 2 ; drawmode 
       fcb 3,41 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 29 D(29,-3)->(21,-3)
       fcb 2 ; drawmode 
       fcb 18,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 30 D(56,-10)->(53,-10)
       fcb 2 ; drawmode 
       fcb 7,27 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-54|rel:92) dy(abs:0|rel:0)
; node # 31 D(60,10)->(57,10)
       fcb 2 ; drawmode 
       fcb -20,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-54|rel:0) dy(abs:0|rel:0)
; node # 32 D(32,15)->(24,15)
       fcb 2 ; drawmode 
       fcb -5,-28 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-146|rel:-92) dy(abs:0|rel:0)
; node # 33 D(24,35)->(19,34)
       fcb 2 ; drawmode 
       fcb -20,-8 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:18)
; node # 34 D(48,32)->(45,31)
       fcb 2 ; drawmode 
       fcb 3,24 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:18|rel:0)
; node # 35 M(-6,36)->(-12,36)
       fcb 0 ; drawmode 
       fcb -4,-54 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:0|rel:-18)
; node # 36 D(24,35)->(19,34)
       fcb 2 ; drawmode 
       fcb 1,30 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:18)
; node # 37 M(60,10)->(57,10)
       fcb 0 ; drawmode 
       fcb 25,36 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:0|rel:-18)
; node # 38 D(78,-20)->(71,-20)
       fcb 2 ; drawmode 
       fcb 30,18 ; starx/y relative to previous node
       fdb 0,-74 ; dx/dy. dx(abs:-128|rel:-74) dy(abs:0|rel:0)
; node # 39 D(96,-35)->(86,-33)
       fcb 2 ; drawmode 
       fcb 15,18 ; starx/y relative to previous node
       fdb -36,-54 ; dx/dy. dx(abs:-182|rel:-54) dy(abs:-36|rel:-36)
; node # 40 D(83,-34)->(72,-33)
       fcb 2 ; drawmode 
       fcb -1,-13 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:-18|rel:18)
; node # 41 D(52,-14)->(47,-14)
       fcb 2 ; drawmode 
       fcb -20,-31 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:-91|rel:110) dy(abs:0|rel:18)
; node # 42 D(60,10)->(57,10)
       fcb 2 ; drawmode 
       fcb -24,8 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:0|rel:0)
; node # 43 D(55,-14)->(52,-15)
       fcb 2 ; drawmode 
       fcb 24,-5 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-54|rel:0) dy(abs:18|rel:18)
; node # 44 D(52,-14)->(47,-14)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:0|rel:-18)
; node # 45 M(87,-36)->(78,-35)
       fcb 0 ; drawmode 
       fcb 22,35 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:-18|rel:-18)
; node # 46 D(83,-34)->(72,-33)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:-18|rel:0)
; node # 47 M(96,-35)->(86,-33)
       fcb 0 ; drawmode 
       fcb 1,13 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-182|rel:19) dy(abs:-36|rel:-18)
; node # 48 D(87,-36)->(78,-35)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-164|rel:18) dy(abs:-18|rel:18)
; node # 49 D(55,-14)->(52,-15)
       fcb 2 ; drawmode 
       fcb -22,-32 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:-54|rel:110) dy(abs:18|rel:36)
; node # 50 M(44,-47)->(40,-45)
       fcb 0 ; drawmode 
       fcb 33,-11 ; starx/y relative to previous node
       fdb -54,-19 ; dx/dy. dx(abs:-73|rel:-19) dy(abs:-36|rel:-54)
; node # 51 D(42,-60)->(44,-59)
       fcb 2 ; drawmode 
       fcb 13,-2 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:-18|rel:18)
; node # 52 D(57,-21)->(60,-21)
       fcb 2 ; drawmode 
       fcb -39,15 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:0|rel:18)
; node # 53 D(12,-27)->(25,-27)
       fcb 2 ; drawmode 
       fcb 6,-45 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:237|rel:183) dy(abs:0|rel:0)
; node # 54 D(8,-68)->(16,-68)
       fcb 2 ; drawmode 
       fcb 41,-4 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:146|rel:-91) dy(abs:0|rel:0)
; node # 55 D(42,-60)->(44,-59)
       fcb 2 ; drawmode 
       fcb -8,34 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:36|rel:-110) dy(abs:-18|rel:-18)
; node # 56 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb -7,-44 ; starx/y relative to previous node
       fdb 18,-72 ; dx/dy. dx(abs:-36|rel:-72) dy(abs:0|rel:18)
; node # 57 D(-6,-63)->(-7,-64)
       fcb 2 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:18)
; node # 58 D(4,-63)->(2,-63)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:-18)
; node # 59 D(2,-59)->(0,-59)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 60 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb -6,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 61 D(8,-68)->(16,-68)
       fcb 2 ; drawmode 
       fcb 15,10 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:0|rel:0)
; node # 62 D(-35,-63)->(-28,-65)
       fcb 2 ; drawmode 
       fcb -5,-43 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:36|rel:36)
; node # 63 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb -10,33 ; starx/y relative to previous node
       fdb -36,-164 ; dx/dy. dx(abs:-36|rel:-164) dy(abs:0|rel:-36)
; node # 64 D(-38,-38)->(-44,-39)
       fcb 2 ; drawmode 
       fcb -15,-36 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:18|rel:18)
; node # 65 D(-51,-50)->(-53,-51)
       fcb 2 ; drawmode 
       fcb 12,-13 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:18|rel:0)
; node # 66 D(-63,-11)->(-63,-12)
       fcb 2 ; drawmode 
       fcb -39,-12 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:18|rel:0)
; node # 67 D(-44,-23)->(-34,-24)
       fcb 2 ; drawmode 
       fcb 12,19 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:182|rel:182) dy(abs:18|rel:0)
; node # 68 D(-46,2)->(-35,3)
       fcb 2 ; drawmode 
       fcb -25,-2 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:201|rel:19) dy(abs:-18|rel:-36)
; node # 69 D(-66,11)->(-66,11)
       fcb 2 ; drawmode 
       fcb -9,-20 ; starx/y relative to previous node
       fdb 18,-201 ; dx/dy. dx(abs:0|rel:-201) dy(abs:0|rel:18)
; node # 70 D(-49,34)->(-46,35)
       fcb 2 ; drawmode 
       fcb -23,17 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:-18|rel:-18)
; node # 71 D(-32,32)->(-23,32)
       fcb 2 ; drawmode 
       fcb 2,17 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:0|rel:18)
; node # 72 D(-46,2)->(-35,3)
       fcb 2 ; drawmode 
       fcb 30,-14 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:201|rel:37) dy(abs:-18|rel:-18)
; node # 73 D(14,-1)->(28,0)
       fcb 2 ; drawmode 
       fcb 3,60 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:256|rel:55) dy(abs:-18|rel:0)
; node # 74 D(10,30)->(21,29)
       fcb 2 ; drawmode 
       fcb -31,-4 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:201|rel:-55) dy(abs:18|rel:36)
; node # 75 D(46,30)->(49,30)
       fcb 2 ; drawmode 
       fcb 0,36 ; starx/y relative to previous node
       fdb -18,-147 ; dx/dy. dx(abs:54|rel:-147) dy(abs:0|rel:-18)
; node # 76 M(-36,35)->(-40,37)
       fcb 0 ; drawmode 
       fcb -5,-82 ; starx/y relative to previous node
       fdb -36,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:-36|rel:-36)
; node # 77 D(-48,34)->(-46,35)
       fcb 2 ; drawmode 
       fcb 1,-12 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:-18|rel:18)
; node # 78 M(10,30)->(21,29)
       fcb 0 ; drawmode 
       fcb 4,58 ; starx/y relative to previous node
       fdb 36,165 ; dx/dy. dx(abs:201|rel:165) dy(abs:18|rel:36)
; node # 79 D(-32,32)->(-23,32)
       fcb 2 ; drawmode 
       fcb -2,-42 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:0|rel:-18)
; node # 80 M(14,-1)->(28,0)
       fcb 0 ; drawmode 
       fcb 33,46 ; starx/y relative to previous node
       fdb -18,92 ; dx/dy. dx(abs:256|rel:92) dy(abs:-18|rel:-18)
; node # 81 D(12,-27)->(25,-27)
       fcb 2 ; drawmode 
       fcb 26,-2 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:237|rel:-19) dy(abs:0|rel:18)
; node # 82 D(-44,-23)->(-34,-24)
       fcb 2 ; drawmode 
       fcb -4,-56 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:182|rel:-55) dy(abs:18|rel:18)
; node # 83 D(-35,-63)->(-28,-65)
       fcb 2 ; drawmode 
       fcb 40,9 ; starx/y relative to previous node
       fdb 18,-54 ; dx/dy. dx(abs:128|rel:-54) dy(abs:36|rel:18)
; node # 84 D(-51,-50)->(-53,-51)
       fcb 2 ; drawmode 
       fcb -13,-16 ; starx/y relative to previous node
       fdb -18,-164 ; dx/dy. dx(abs:-36|rel:-164) dy(abs:18|rel:-18)
; node # 85 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb 3,49 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:-18)
; node # 86 M(-6,-63)->(-7,-64)
       fcb 0 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:18)
; node # 87 D(-7,-59)->(-10,-60)
       fcb 2 ; drawmode 
       fcb -4,-1 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-54|rel:-36) dy(abs:18|rel:0)
; node # 88 D(2,-59)->(0,-59)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:0|rel:-18)
; node # 89 M(4,-63)->(2,-63)
       fcb 0 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 90 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb -10,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 91 D(44,-47)->(40,-45)
       fcb 2 ; drawmode 
       fcb -6,46 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:-36|rel:-36)
; node # 92 M(-7,-59)->(-10,-60)
       fcb 0 ; drawmode 
       fcb 12,-51 ; starx/y relative to previous node
       fdb 54,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:18|rel:54)
; node # 93 D(-2,-53)->(-4,-53)
       fcb 2 ; drawmode 
       fcb -6,5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:0|rel:-18)
; node # 94 M(-55,-35)->(-54,-36)
       fcb 0 ; drawmode 
       fcb -18,-53 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:18|rel:18)
; node # 95 D(-93,-36)->(-95,-38)
       fcb 2 ; drawmode 
       fcb 1,-38 ; starx/y relative to previous node
       fdb 18,-54 ; dx/dy. dx(abs:-36|rel:-54) dy(abs:36|rel:18)
; node # 96 D(-94,-18)->(-94,-20)
       fcb 2 ; drawmode 
       fcb -18,-1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:36|rel:0)
; node # 97 D(-62,3)->(-62,2)
       fcb 2 ; drawmode 
       fcb -21,32 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:-18)
; node # 98 D(-65,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-18)
; node # 99 D(-93,-16)->(-95,-17)
       fcb 2 ; drawmode 
       fcb 19,-28 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:18)
; node # 100 D(-92,-33)->(-95,-35)
       fcb 2 ; drawmode 
       fcb 17,1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:36|rel:18)
; node # 101 D(-55,-32)->(-55,-33)
       fcb 2 ; drawmode 
       fcb -1,37 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:0|rel:54) dy(abs:18|rel:-18)
; node # 102 D(-55,-35)->(-54,-36)
       fcb 2 ; drawmode 
       fcb 3,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:0)
; node # 103 D(-54,-39)->(-55,-40)
       fcb 2 ; drawmode 
       fcb 4,1 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:18|rel:0)
; node # 104 D(-98,-40)->(-101,-43)
       fcb 2 ; drawmode 
       fcb 1,-44 ; starx/y relative to previous node
       fdb 36,-36 ; dx/dy. dx(abs:-54|rel:-36) dy(abs:54|rel:36)
; node # 105 D(-100,-12)->(-101,-12)
       fcb 2 ; drawmode 
       fcb -28,-2 ; starx/y relative to previous node
       fdb -54,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:0|rel:-54)
; node # 106 D(-66,11)->(-66,11)
       fcb 2 ; drawmode 
       fcb -23,34 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 107 D(-62,3)->(-62,2)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:18)
; node # 108 M(14,-1)->(28,0)
       fcb 0 ; drawmode 
       fcb 4,76 ; starx/y relative to previous node
       fdb -36,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-18|rel:-36)
; node # 109 D(62,3)->(67,3)
       fcb 2 ; drawmode 
       fcb -4,48 ; starx/y relative to previous node
       fdb 18,-165 ; dx/dy. dx(abs:91|rel:-165) dy(abs:0|rel:18)
; node # 110 M(9,-5)->(-4,-5)
       fcb 0 ; drawmode 
       fcb 8,-53 ; starx/y relative to previous node
       fdb 0,-328 ; dx/dy. dx(abs:-237|rel:-328) dy(abs:0|rel:0)
; node # 111 M(-92,-33)->(-95,-35)
       fcb 0 ; drawmode 
       fcb 28,-101 ; starx/y relative to previous node
       fdb 36,183 ; dx/dy. dx(abs:-54|rel:183) dy(abs:36|rel:36)
; node # 112 D(-98,-40)->(-101,-43)
       fcb 2 ; drawmode 
       fcb 7,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-54|rel:0) dy(abs:54|rel:18)
; node # 113 M(-66,11)->(-66,11)
       fcb 0 ; drawmode 
       fcb -51,32 ; starx/y relative to previous node
       fdb -54,54 ; dx/dy. dx(abs:0|rel:54) dy(abs:0|rel:-54)
; node # 114 D(-65,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 115 M(-93,-16)->(-95,-17)
       fcb 0 ; drawmode 
       fcb 19,-28 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:18)
; node # 116 D(-100,-12)->(-101,-12)
       fcb 2 ; drawmode 
       fcb -4,-7 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:-18)
; node # 117 D(-94,-18)->(-94,-20)
       fcb 2 ; drawmode 
       fcb 6,6 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:36|rel:36)
; node # 118 D(-93,-16)->(-95,-17)
       fcb 2 ; drawmode 
       fcb -2,1 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:-18)
; node # 119 M(-92,-33)->(-95,-35)
       fcb 0 ; drawmode 
       fcb 17,1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:36|rel:18)
; node # 120 D(-93,-36)->(-95,-38)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:36|rel:0)
; node # 121 M(-93,-36)->(-95,-38)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:36|rel:0)
; node # 122 D(-98,-40)->(-101,-43)
       fcb 2 ; drawmode 
       fcb 4,-5 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:54|rel:18)
; node # 123 M(-55,-32)->(-55,-33)
       fcb 0 ; drawmode 
       fcb -8,43 ; starx/y relative to previous node
       fdb -36,54 ; dx/dy. dx(abs:0|rel:54) dy(abs:18|rel:-36)
; node # 124 D(-54,-39)->(-55,-40)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:0)
       fcb  1  ; end of anim
; Animation 7
teapotframe7:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(67,3)->(68,2)
       fcb 0 ; drawmode 
       fcb -3,67 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 1 D(57,10)->(51,9)
       fcb 2 ; drawmode 
       fcb -7,-10 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:18|rel:0)
; node # 2 D(45,31)->(41,31)
       fcb 2 ; drawmode 
       fcb -21,-12 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:-18)
; node # 3 D(49,30)->(52,29)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb 18,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:18|rel:18)
; node # 4 D(67,3)->(68,2)
       fcb 2 ; drawmode 
       fcb 27,18 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:18|rel:0)
; node # 5 D(60,-21)->(61,-19)
       fcb 2 ; drawmode 
       fcb 24,-7 ; starx/y relative to previous node
       fdb -54,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-36|rel:-54)
; node # 6 D(53,-10)->(46,-10)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 36,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:0|rel:36)
; node # 7 D(40,-45)->(35,-44)
       fcb 2 ; drawmode 
       fcb 35,-13 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:-18|rel:-18)
; node # 8 D(15,-36)->(7,-36)
       fcb 2 ; drawmode 
       fcb -9,-25 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:18)
; node # 9 D(-17,-35)->(-25,-35)
       fcb 2 ; drawmode 
       fcb -1,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 10 D(-18,0)->(-26,0)
       fcb 2 ; drawmode 
       fcb -35,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 11 D(-17,18)->(-26,18)
       fcb 2 ; drawmode 
       fcb -18,1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 12 D(-12,36)->(-18,36)
       fcb 2 ; drawmode 
       fcb -18,5 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 13 D(-40,37)->(-42,38)
       fcb 2 ; drawmode 
       fcb -1,-28 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:-18|rel:-18)
; node # 14 D(-54,17)->(-59,18)
       fcb 2 ; drawmode 
       fcb 20,-14 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-91|rel:-55) dy(abs:-18|rel:0)
; node # 15 D(-52,-3)->(-58,-3)
       fcb 2 ; drawmode 
       fcb 20,2 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:18)
; node # 16 D(-18,0)->(-26,0)
       fcb 2 ; drawmode 
       fcb -3,34 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:0)
; node # 17 D(21,-3)->(13,-3)
       fcb 2 ; drawmode 
       fcb 3,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 18 D(15,-36)->(7,-36)
       fcb 2 ; drawmode 
       fcb 33,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 19 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb 17,-19 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:-18|rel:128) dy(abs:18|rel:18)
; node # 20 D(-17,-35)->(-25,-35)
       fcb 2 ; drawmode 
       fcb -18,-13 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:-146|rel:-128) dy(abs:0|rel:-18)
; node # 21 D(-44,-39)->(-49,-40)
       fcb 2 ; drawmode 
       fcb 4,-27 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:18)
; node # 22 D(-52,-3)->(-58,-3)
       fcb 2 ; drawmode 
       fcb -36,-8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:-18)
; node # 23 D(-63,-12)->(-61,-12)
       fcb 2 ; drawmode 
       fcb 9,-11 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:0|rel:0)
; node # 24 D(-66,11)->(-62,12)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:73|rel:37) dy(abs:-18|rel:-18)
; node # 25 D(-54,17)->(-59,18)
       fcb 2 ; drawmode 
       fcb -6,12 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-91|rel:-164) dy(abs:-18|rel:0)
; node # 26 D(-17,18)->(-26,18)
       fcb 2 ; drawmode 
       fcb -1,37 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:18)
; node # 27 D(24,15)->(14,15)
       fcb 2 ; drawmode 
       fcb 3,41 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:0|rel:0)
; node # 28 D(21,-3)->(13,-3)
       fcb 2 ; drawmode 
       fcb 18,-3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 29 D(53,-10)->(46,-10)
       fcb 2 ; drawmode 
       fcb 7,32 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 30 D(57,10)->(51,9)
       fcb 2 ; drawmode 
       fcb -20,4 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
; node # 31 D(24,15)->(14,15)
       fcb 2 ; drawmode 
       fcb -5,-33 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-182|rel:-73) dy(abs:0|rel:-18)
; node # 32 D(19,34)->(13,34)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:0|rel:0)
; node # 33 D(45,31)->(41,31)
       fcb 2 ; drawmode 
       fcb 3,26 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:0)
; node # 34 M(-12,36)->(-18,36)
       fcb 0 ; drawmode 
       fcb -5,-57 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:0)
; node # 35 D(19,34)->(13,34)
       fcb 2 ; drawmode 
       fcb 2,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 36 M(57,10)->(51,9)
       fcb 0 ; drawmode 
       fcb 24,38 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:18|rel:18)
; node # 37 D(71,-20)->(62,-19)
       fcb 2 ; drawmode 
       fcb 30,14 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-18|rel:-36)
; node # 38 D(86,-33)->(74,-32)
       fcb 2 ; drawmode 
       fcb 13,15 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:-18|rel:0)
; node # 39 D(72,-33)->(62,-31)
       fcb 2 ; drawmode 
       fcb 0,-14 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-182|rel:37) dy(abs:-36|rel:-18)
; node # 40 D(47,-14)->(41,-13)
       fcb 2 ; drawmode 
       fcb -19,-25 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:-18|rel:18)
; node # 41 D(57,10)->(51,9)
       fcb 2 ; drawmode 
       fcb -24,10 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:18|rel:36)
; node # 42 D(52,-15)->(47,-15)
       fcb 2 ; drawmode 
       fcb 25,-5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:-18)
; node # 43 D(47,-14)->(41,-13)
       fcb 2 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:-18|rel:-18)
; node # 44 M(78,-35)->(69,-34)
       fcb 0 ; drawmode 
       fcb 21,31 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-18|rel:0)
; node # 45 D(72,-33)->(62,-31)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:-36|rel:-18)
; node # 46 M(86,-33)->(74,-32)
       fcb 0 ; drawmode 
       fcb 0,14 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-219|rel:-37) dy(abs:-18|rel:18)
; node # 47 D(78,-35)->(69,-34)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:-18|rel:0)
; node # 48 D(52,-15)->(47,-15)
       fcb 2 ; drawmode 
       fcb -20,-26 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:18)
; node # 49 M(40,-45)->(35,-44)
       fcb 0 ; drawmode 
       fcb 30,-12 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:-18|rel:-18)
; node # 50 D(44,-59)->(44,-57)
       fcb 2 ; drawmode 
       fcb 14,4 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:-36|rel:-18)
; node # 51 D(60,-21)->(61,-19)
       fcb 2 ; drawmode 
       fcb -38,16 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-36|rel:0)
; node # 52 D(25,-27)->(35,-27)
       fcb 2 ; drawmode 
       fcb 6,-35 ; starx/y relative to previous node
       fdb 36,164 ; dx/dy. dx(abs:182|rel:164) dy(abs:0|rel:36)
; node # 53 D(16,-68)->(23,-67)
       fcb 2 ; drawmode 
       fcb 41,-9 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:128|rel:-54) dy(abs:-18|rel:-18)
; node # 54 D(44,-59)->(44,-57)
       fcb 2 ; drawmode 
       fcb -9,28 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:-36|rel:-18)
; node # 55 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb -6,-48 ; starx/y relative to previous node
       fdb 54,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:54)
; node # 56 D(-7,-64)->(-8,-64)
       fcb 2 ; drawmode 
       fcb 11,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:-18)
; node # 57 D(2,-63)->(1,-63)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:0)
; node # 58 D(0,-59)->(-3,-59)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-54|rel:-36) dy(abs:0|rel:0)
; node # 59 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb -6,-4 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:18|rel:18)
; node # 60 D(16,-68)->(23,-67)
       fcb 2 ; drawmode 
       fcb 15,20 ; starx/y relative to previous node
       fdb -36,146 ; dx/dy. dx(abs:128|rel:146) dy(abs:-18|rel:-36)
; node # 61 D(-28,-65)->(-21,-65)
       fcb 2 ; drawmode 
       fcb -3,-44 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:0|rel:18)
; node # 62 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb -12,24 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:18|rel:18)
; node # 63 D(-44,-39)->(-49,-40)
       fcb 2 ; drawmode 
       fcb -14,-40 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:18|rel:0)
; node # 64 D(-53,-51)->(-51,-53)
       fcb 2 ; drawmode 
       fcb 12,-9 ; starx/y relative to previous node
       fdb 18,127 ; dx/dy. dx(abs:36|rel:127) dy(abs:36|rel:18)
; node # 65 D(-63,-12)->(-61,-12)
       fcb 2 ; drawmode 
       fcb -39,-10 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:0|rel:-36)
; node # 66 D(-34,-24)->(-22,-24)
       fcb 2 ; drawmode 
       fcb 12,29 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:0|rel:0)
; node # 67 D(-35,3)->(-21,3)
       fcb 2 ; drawmode 
       fcb -27,-1 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:256|rel:37) dy(abs:0|rel:0)
; node # 68 D(-66,11)->(-62,12)
       fcb 2 ; drawmode 
       fcb -8,-31 ; starx/y relative to previous node
       fdb -18,-183 ; dx/dy. dx(abs:73|rel:-183) dy(abs:-18|rel:-18)
; node # 69 D(-46,35)->(-43,36)
       fcb 2 ; drawmode 
       fcb -24,20 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:54|rel:-19) dy(abs:-18|rel:0)
; node # 70 D(-23,32)->(-13,32)
       fcb 2 ; drawmode 
       fcb 3,23 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:182|rel:128) dy(abs:0|rel:18)
; node # 71 D(-35,3)->(-21,3)
       fcb 2 ; drawmode 
       fcb 29,-12 ; starx/y relative to previous node
       fdb 0,74 ; dx/dy. dx(abs:256|rel:74) dy(abs:0|rel:0)
; node # 72 D(28,0)->(40,0)
       fcb 2 ; drawmode 
       fcb 3,63 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:0|rel:0)
; node # 73 D(21,29)->(31,29)
       fcb 2 ; drawmode 
       fcb -29,-7 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:0|rel:0)
; node # 74 D(49,30)->(52,29)
       fcb 2 ; drawmode 
       fcb -1,28 ; starx/y relative to previous node
       fdb 18,-128 ; dx/dy. dx(abs:54|rel:-128) dy(abs:18|rel:18)
; node # 75 M(-40,37)->(-42,38)
       fcb 0 ; drawmode 
       fcb -7,-89 ; starx/y relative to previous node
       fdb -36,-90 ; dx/dy. dx(abs:-36|rel:-90) dy(abs:-18|rel:-36)
; node # 76 D(-46,35)->(-43,36)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:54|rel:90) dy(abs:-18|rel:0)
; node # 77 M(21,29)->(31,29)
       fcb 0 ; drawmode 
       fcb 6,67 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:182|rel:128) dy(abs:0|rel:18)
; node # 78 D(-23,32)->(-13,32)
       fcb 2 ; drawmode 
       fcb -3,-44 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:0|rel:0)
; node # 79 M(28,0)->(40,0)
       fcb 0 ; drawmode 
       fcb 32,51 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:0|rel:0)
; node # 80 D(25,-27)->(35,-27)
       fcb 2 ; drawmode 
       fcb 27,-3 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:0|rel:0)
; node # 81 D(-34,-24)->(-22,-24)
       fcb 2 ; drawmode 
       fcb -3,-59 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:0|rel:0)
; node # 82 D(-28,-65)->(-21,-65)
       fcb 2 ; drawmode 
       fcb 41,6 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:128|rel:-91) dy(abs:0|rel:0)
; node # 83 D(-53,-51)->(-51,-53)
       fcb 2 ; drawmode 
       fcb -14,-25 ; starx/y relative to previous node
       fdb 36,-92 ; dx/dy. dx(abs:36|rel:-92) dy(abs:36|rel:36)
; node # 84 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb 2,49 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:-18|rel:-54) dy(abs:18|rel:-18)
; node # 85 M(-7,-64)->(-8,-64)
       fcb 0 ; drawmode 
       fcb 11,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:-18)
; node # 86 D(-10,-60)->(-13,-60)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-54|rel:-36) dy(abs:0|rel:0)
; node # 87 D(0,-59)->(-3,-59)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-54|rel:0) dy(abs:0|rel:0)
; node # 88 M(2,-63)->(1,-63)
       fcb 0 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:0|rel:0)
; node # 89 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb -10,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:18|rel:18)
; node # 90 D(40,-45)->(35,-44)
       fcb 2 ; drawmode 
       fcb -8,44 ; starx/y relative to previous node
       fdb -36,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:-18|rel:-36)
; node # 91 M(-10,-60)->(-13,-60)
       fcb 0 ; drawmode 
       fcb 15,-50 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:0|rel:18)
; node # 92 D(-4,-53)->(-5,-54)
       fcb 2 ; drawmode 
       fcb -7,6 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:18|rel:18)
; node # 93 M(-54,-36)->(-52,-38)
       fcb 0 ; drawmode 
       fcb -17,-50 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:36|rel:18)
; node # 94 D(-95,-38)->(-92,-41)
       fcb 2 ; drawmode 
       fcb 2,-41 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:54|rel:18)
; node # 95 D(-94,-20)->(-91,-21)
       fcb 2 ; drawmode 
       fcb -18,1 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:18|rel:-36)
; node # 96 D(-62,2)->(-58,2)
       fcb 2 ; drawmode 
       fcb -22,32 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:0|rel:-18)
; node # 97 D(-65,3)->(-62,3)
       fcb 2 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:54|rel:-19) dy(abs:0|rel:0)
; node # 98 D(-95,-17)->(-94,-18)
       fcb 2 ; drawmode 
       fcb 20,-30 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:18|rel:18)
; node # 99 D(-95,-35)->(-95,-37)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:36|rel:18)
; node # 100 D(-55,-33)->(-56,-34)
       fcb 2 ; drawmode 
       fcb -2,40 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:-18)
; node # 101 D(-54,-36)->(-52,-38)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:36|rel:18)
; node # 102 D(-55,-40)->(-53,-42)
       fcb 2 ; drawmode 
       fcb 4,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:36|rel:0)
; node # 103 D(-101,-43)->(-101,-45)
       fcb 2 ; drawmode 
       fcb 3,-46 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:36|rel:0)
; node # 104 D(-101,-12)->(-99,-13)
       fcb 2 ; drawmode 
       fcb -31,0 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:18|rel:-18)
; node # 105 D(-66,11)->(-62,12)
       fcb 2 ; drawmode 
       fcb -23,35 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:73|rel:37) dy(abs:-18|rel:-36)
; node # 106 D(-62,2)->(-62,3)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:0|rel:-73) dy(abs:-18|rel:0)
; node # 107 M(28,0)->(40,0)
       fcb 0 ; drawmode 
       fcb 2,90 ; starx/y relative to previous node
       fdb 18,219 ; dx/dy. dx(abs:219|rel:219) dy(abs:0|rel:18)
; node # 108 D(67,3)->(68,2)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb 18,-201 ; dx/dy. dx(abs:18|rel:-201) dy(abs:18|rel:18)
; node # 109 M(1,-5)->(1,7)
       fcb 0 ; drawmode 
       fcb 8,-66 ; starx/y relative to previous node
       fdb -237,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-219|rel:-237)
; node # 110 M(-95,-35)->(-95,-37)
       fcb 0 ; drawmode 
       fcb 30,-96 ; starx/y relative to previous node
       fdb 255,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:36|rel:255)
; node # 111 D(-101,-43)->(-101,-45)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:36|rel:0)
; node # 112 M(-66,11)->(-62,12)
       fcb 0 ; drawmode 
       fcb -54,35 ; starx/y relative to previous node
       fdb -54,73 ; dx/dy. dx(abs:73|rel:73) dy(abs:-18|rel:-54)
; node # 113 D(-65,3)->(-58,2)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 36,55 ; dx/dy. dx(abs:128|rel:55) dy(abs:18|rel:36)
; node # 114 M(-94,-20)->(-94,-18)
       fcb 0 ; drawmode 
       fcb 23,-29 ; starx/y relative to previous node
       fdb -54,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:-36|rel:-54)
; node # 115 D(-101,-12)->(-99,-14)
       fcb 2 ; drawmode 
       fcb -8,-7 ; starx/y relative to previous node
       fdb 72,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:36|rel:72)
; node # 116 D(-95,-17)->(-94,-18)
       fcb 2 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:18|rel:-18)
; node # 117 D(-94,-20)->(-91,-21)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:18|rel:0)
; node # 118 M(-95,-35)->(-95,-37)
       fcb 0 ; drawmode 
       fcb 15,-1 ; starx/y relative to previous node
       fdb 18,-54 ; dx/dy. dx(abs:0|rel:-54) dy(abs:36|rel:18)
; node # 119 D(-95,-38)->(-92,-41)
       fcb 2 ; drawmode 
       fcb 3,0 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:54|rel:18)
; node # 120 M(-95,-38)->(-92,-41)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:54|rel:0)
; node # 121 D(-101,-43)->(-101,-45)
       fcb 2 ; drawmode 
       fcb 5,-6 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:0|rel:-54) dy(abs:36|rel:-18)
; node # 122 M(-55,-33)->(-56,-34)
       fcb 0 ; drawmode 
       fcb -10,46 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:-18)
; node # 123 D(-55,-40)->(-53,-42)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:36|rel:18)
       fcb  1  ; end of anim
; Animation 8
teapotframe8:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(68,2)->(67,2)
       fcb 0 ; drawmode 
       fcb -2,68 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-17|rel:-17) dy(abs:0|rel:0)
; node # 1 D(50,10)->(44,9)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-102|rel:-85) dy(abs:17|rel:17)
; node # 2 D(41,31)->(36,30)
       fcb 2 ; drawmode 
       fcb -21,-9 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-85|rel:17) dy(abs:17|rel:0)
; node # 3 D(52,29)->(52,28)
       fcb 2 ; drawmode 
       fcb 2,11 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:0|rel:85) dy(abs:17|rel:0)
; node # 4 D(68,2)->(67,2)
       fcb 2 ; drawmode 
       fcb 27,16 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-17|rel:-17) dy(abs:0|rel:-17)
; node # 5 D(61,-19)->(61,-19)
       fcb 2 ; drawmode 
       fcb 21,-7 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:0|rel:17) dy(abs:0|rel:0)
; node # 6 D(46,-10)->(39,-10)
       fcb 2 ; drawmode 
       fcb -9,-15 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-119|rel:-119) dy(abs:0|rel:0)
; node # 7 D(35,-44)->(28,-44)
       fcb 2 ; drawmode 
       fcb 34,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:0)
; node # 8 D(7,-36)->(-1,-36)
       fcb 2 ; drawmode 
       fcb -8,-28 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 9 D(-25,-35)->(-32,-35)
       fcb 2 ; drawmode 
       fcb -1,-32 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 10 D(-26,0)->(-34,0)
       fcb 2 ; drawmode 
       fcb -35,-1 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 11 D(-26,18)->(-34,19)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:-17|rel:-17)
; node # 12 D(-18,36)->(-24,37)
       fcb 2 ; drawmode 
       fcb -18,8 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:-17|rel:0)
; node # 13 D(-42,38)->(-44,39)
       fcb 2 ; drawmode 
       fcb -2,-24 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:-34|rel:68) dy(abs:-17|rel:0)
; node # 14 D(-59,18)->(-63,19)
       fcb 2 ; drawmode 
       fcb 20,-17 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-68|rel:-34) dy(abs:-17|rel:0)
; node # 15 D(-58,-3)->(-62,-3)
       fcb 2 ; drawmode 
       fcb 21,1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-68|rel:0) dy(abs:0|rel:17)
; node # 16 D(-26,0)->(-34,0)
       fcb 2 ; drawmode 
       fcb -3,32 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-136|rel:-68) dy(abs:0|rel:0)
; node # 17 D(13,-3)->(4,-3)
       fcb 2 ; drawmode 
       fcb 3,39 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:0)
; node # 18 D(7,-36)->(-1,-36)
       fcb 2 ; drawmode 
       fcb 33,-6 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:0)
; node # 19 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb 18,-12 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:-17|rel:119) dy(abs:0|rel:0)
; node # 20 D(-25,-35)->(-32,-35)
       fcb 2 ; drawmode 
       fcb -19,-20 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-119|rel:-102) dy(abs:0|rel:0)
; node # 21 D(-49,-40)->(-54,-42)
       fcb 2 ; drawmode 
       fcb 5,-24 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:34|rel:34)
; node # 22 D(-58,-3)->(-62,-3)
       fcb 2 ; drawmode 
       fcb -37,-9 ; starx/y relative to previous node
       fdb -34,17 ; dx/dy. dx(abs:-68|rel:17) dy(abs:0|rel:-34)
; node # 23 D(-61,-12)->(-56,-13)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb 17,153 ; dx/dy. dx(abs:85|rel:153) dy(abs:17|rel:17)
; node # 24 D(-62,12)->(-57,13)
       fcb 2 ; drawmode 
       fcb -24,-1 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:85|rel:0) dy(abs:-17|rel:-34)
; node # 25 D(-59,18)->(-63,19)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-68|rel:-153) dy(abs:-17|rel:0)
; node # 26 D(-26,18)->(-34,19)
       fcb 2 ; drawmode 
       fcb 0,33 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-136|rel:-68) dy(abs:-17|rel:0)
; node # 27 D(14,15)->(5,15)
       fcb 2 ; drawmode 
       fcb 3,40 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:17)
; node # 28 D(13,-3)->(4,-3)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 29 D(46,-10)->(39,-10)
       fcb 2 ; drawmode 
       fcb 7,33 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
; node # 30 D(51,10)->(44,9)
       fcb 2 ; drawmode 
       fcb -20,5 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:17|rel:17)
; node # 31 D(14,15)->(5,15)
       fcb 2 ; drawmode 
       fcb -5,-37 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:0|rel:-17)
; node # 32 D(13,34)->(6,34)
       fcb 2 ; drawmode 
       fcb -19,-1 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
; node # 33 D(41,31)->(36,30)
       fcb 2 ; drawmode 
       fcb 3,28 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:17|rel:17)
; node # 34 M(-18,36)->(-24,37)
       fcb 0 ; drawmode 
       fcb -5,-59 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:-102|rel:-17) dy(abs:-17|rel:-34)
; node # 35 D(13,34)->(6,34)
       fcb 2 ; drawmode 
       fcb 2,31 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:0|rel:17)
; node # 36 M(51,10)->(44,9)
       fcb 0 ; drawmode 
       fcb 24,38 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:17|rel:17)
; node # 37 D(62,-19)->(53,-18)
       fcb 2 ; drawmode 
       fcb 29,11 ; starx/y relative to previous node
       fdb -34,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:-17|rel:-34)
; node # 38 D(74,-32)->(62,-30)
       fcb 2 ; drawmode 
       fcb 13,12 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:-204|rel:-51) dy(abs:-34|rel:-17)
; node # 39 D(62,-31)->(51,-30)
       fcb 2 ; drawmode 
       fcb -1,-12 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-187|rel:17) dy(abs:-17|rel:17)
; node # 40 D(41,-13)->(34,-13)
       fcb 2 ; drawmode 
       fcb -18,-21 ; starx/y relative to previous node
       fdb 17,68 ; dx/dy. dx(abs:-119|rel:68) dy(abs:0|rel:17)
; node # 41 D(51,9)->(44,9)
       fcb 2 ; drawmode 
       fcb -22,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:0)
; node # 42 D(47,-15)->(41,-15)
       fcb 2 ; drawmode 
       fcb 24,-4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:0|rel:0)
; node # 43 D(41,-13)->(34,-13)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:0|rel:0)
; node # 44 M(69,-34)->(58,-32)
       fcb 0 ; drawmode 
       fcb 21,28 ; starx/y relative to previous node
       fdb -34,-68 ; dx/dy. dx(abs:-187|rel:-68) dy(abs:-34|rel:-34)
; node # 45 D(62,-31)->(51,-30)
       fcb 2 ; drawmode 
       fcb -3,-7 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-187|rel:0) dy(abs:-17|rel:17)
; node # 46 M(74,-32)->(62,-30)
       fcb 0 ; drawmode 
       fcb 1,12 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:-34|rel:-17)
; node # 47 D(69,-34)->(58,-32)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-187|rel:17) dy(abs:-34|rel:0)
; node # 48 D(47,-15)->(41,-15)
       fcb 2 ; drawmode 
       fcb -19,-22 ; starx/y relative to previous node
       fdb 34,85 ; dx/dy. dx(abs:-102|rel:85) dy(abs:0|rel:34)
; node # 49 M(35,-44)->(28,-44)
       fcb 0 ; drawmode 
       fcb 29,-12 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:0|rel:0)
; node # 50 D(44,-57)->(44,-55)
       fcb 2 ; drawmode 
       fcb 13,9 ; starx/y relative to previous node
       fdb -34,119 ; dx/dy. dx(abs:0|rel:119) dy(abs:-34|rel:-34)
; node # 51 D(61,-19)->(61,-19)
       fcb 2 ; drawmode 
       fcb -38,17 ; starx/y relative to previous node
       fdb 34,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:34)
; node # 52 D(35,-27)->(44,-26)
       fcb 2 ; drawmode 
       fcb 8,-26 ; starx/y relative to previous node
       fdb -17,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-17|rel:-17)
; node # 53 D(23,-67)->(29,-66)
       fcb 2 ; drawmode 
       fcb 40,-12 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:102|rel:-51) dy(abs:-17|rel:0)
; node # 54 D(44,-57)->(44,-55)
       fcb 2 ; drawmode 
       fcb -10,21 ; starx/y relative to previous node
       fdb -17,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-34|rel:-17)
; node # 55 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb -3,-49 ; starx/y relative to previous node
       fdb 34,-17 ; dx/dy. dx(abs:-17|rel:-17) dy(abs:0|rel:34)
; node # 56 D(-8,-64)->(-8,-64)
       fcb 2 ; drawmode 
       fcb 10,-3 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:0|rel:17) dy(abs:0|rel:0)
; node # 57 D(1,-63)->(0,-63)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-17|rel:-17) dy(abs:0|rel:0)
; node # 58 D(-3,-59)->(-6,-59)
       fcb 2 ; drawmode 
       fcb -4,-4 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-51|rel:-34) dy(abs:0|rel:0)
; node # 59 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:0|rel:0)
; node # 60 D(23,-67)->(29,-66)
       fcb 2 ; drawmode 
       fcb 13,28 ; starx/y relative to previous node
       fdb -17,119 ; dx/dy. dx(abs:102|rel:119) dy(abs:-17|rel:-17)
; node # 61 D(-21,-65)->(-12,-67)
       fcb 2 ; drawmode 
       fcb -2,-44 ; starx/y relative to previous node
       fdb 51,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:34|rel:51)
; node # 62 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb -11,16 ; starx/y relative to previous node
       fdb -34,-170 ; dx/dy. dx(abs:-17|rel:-170) dy(abs:0|rel:-34)
; node # 63 D(-49,-40)->(-54,-42)
       fcb 2 ; drawmode 
       fcb -14,-44 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:-85|rel:-68) dy(abs:34|rel:34)
; node # 64 D(-51,-53)->(-49,-55)
       fcb 2 ; drawmode 
       fcb 13,-2 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:34|rel:119) dy(abs:34|rel:0)
; node # 65 D(-61,-12)->(-56,-13)
       fcb 2 ; drawmode 
       fcb -41,-10 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:85|rel:51) dy(abs:17|rel:-17)
; node # 66 D(-22,-24)->(-9,-24)
       fcb 2 ; drawmode 
       fcb 12,39 ; starx/y relative to previous node
       fdb -17,136 ; dx/dy. dx(abs:221|rel:136) dy(abs:0|rel:-17)
; node # 67 D(-21,3)->(-6,4)
       fcb 2 ; drawmode 
       fcb -27,1 ; starx/y relative to previous node
       fdb -17,35 ; dx/dy. dx(abs:256|rel:35) dy(abs:-17|rel:-17)
; node # 68 D(-62,12)->(-57,13)
       fcb 2 ; drawmode 
       fcb -9,-41 ; starx/y relative to previous node
       fdb 0,-171 ; dx/dy. dx(abs:85|rel:-171) dy(abs:-17|rel:0)
; node # 69 D(-43,36)->(-37,38)
       fcb 2 ; drawmode 
       fcb -24,19 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:102|rel:17) dy(abs:-34|rel:-17)
; node # 70 D(-13,32)->(-1,33)
       fcb 2 ; drawmode 
       fcb 4,30 ; starx/y relative to previous node
       fdb 17,102 ; dx/dy. dx(abs:204|rel:102) dy(abs:-17|rel:17)
; node # 71 D(-21,3)->(-6,4)
       fcb 2 ; drawmode 
       fcb 29,-8 ; starx/y relative to previous node
       fdb 0,52 ; dx/dy. dx(abs:256|rel:52) dy(abs:-17|rel:0)
; node # 72 D(40,0)->(50,0)
       fcb 2 ; drawmode 
       fcb 3,61 ; starx/y relative to previous node
       fdb 17,-86 ; dx/dy. dx(abs:170|rel:-86) dy(abs:0|rel:17)
; node # 73 D(31,29)->(39,29)
       fcb 2 ; drawmode 
       fcb -29,-9 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:136|rel:-34) dy(abs:0|rel:0)
; node # 74 D(52,29)->(52,28)
       fcb 2 ; drawmode 
       fcb 0,21 ; starx/y relative to previous node
       fdb 17,-136 ; dx/dy. dx(abs:0|rel:-136) dy(abs:17|rel:17)
; node # 75 M(-42,38)->(-44,39)
       fcb 0 ; drawmode 
       fcb -9,-94 ; starx/y relative to previous node
       fdb -34,-34 ; dx/dy. dx(abs:-34|rel:-34) dy(abs:-17|rel:-34)
; node # 76 D(-43,36)->(-37,38)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb -17,136 ; dx/dy. dx(abs:102|rel:136) dy(abs:-34|rel:-17)
; node # 77 M(31,29)->(39,29)
       fcb 0 ; drawmode 
       fcb 7,74 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:136|rel:34) dy(abs:0|rel:34)
; node # 78 D(-13,32)->(-1,33)
       fcb 2 ; drawmode 
       fcb -3,-44 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:204|rel:68) dy(abs:-17|rel:-17)
; node # 79 M(40,0)->(50,0)
       fcb 0 ; drawmode 
       fcb 32,53 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:170|rel:-34) dy(abs:0|rel:17)
; node # 80 D(35,-27)->(44,-26)
       fcb 2 ; drawmode 
       fcb 27,-5 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:153|rel:-17) dy(abs:-17|rel:-17)
; node # 81 D(-22,-24)->(-9,-24)
       fcb 2 ; drawmode 
       fcb -3,-57 ; starx/y relative to previous node
       fdb 17,68 ; dx/dy. dx(abs:221|rel:68) dy(abs:0|rel:17)
; node # 82 D(-21,-65)->(-12,-67)
       fcb 2 ; drawmode 
       fcb 41,1 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:153|rel:-68) dy(abs:34|rel:34)
; node # 83 D(-51,-53)->(-49,-55)
       fcb 2 ; drawmode 
       fcb -12,-30 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:34|rel:-119) dy(abs:34|rel:0)
; node # 84 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb 1,46 ; starx/y relative to previous node
       fdb -34,-51 ; dx/dy. dx(abs:-17|rel:-51) dy(abs:0|rel:-34)
; node # 85 M(-8,-64)->(-8,-64)
       fcb 0 ; drawmode 
       fcb 10,-3 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:0|rel:17) dy(abs:0|rel:0)
; node # 86 D(-13,-60)->(-15,-60)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-34|rel:-34) dy(abs:0|rel:0)
; node # 87 D(-3,-59)->(-6,-59)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-51|rel:-17) dy(abs:0|rel:0)
; node # 88 M(1,-63)->(0,-63)
       fcb 0 ; drawmode 
       fcb 4,4 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:0|rel:0)
; node # 89 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:0|rel:0)
; node # 90 D(35,-44)->(28,-44)
       fcb 2 ; drawmode 
       fcb -10,40 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-119|rel:-102) dy(abs:0|rel:0)
; node # 91 M(-13,-60)->(-15,-60)
       fcb 0 ; drawmode 
       fcb 16,-48 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-34|rel:85) dy(abs:0|rel:0)
; node # 92 D(-5,-54)->(-6,-54)
       fcb 2 ; drawmode 
       fcb -6,8 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-17|rel:17) dy(abs:0|rel:0)
; node # 93 M(-52,-38)->(-48,-39)
       fcb 0 ; drawmode 
       fcb -16,-47 ; starx/y relative to previous node
       fdb 17,85 ; dx/dy. dx(abs:68|rel:85) dy(abs:17|rel:17)
; node # 94 D(-92,-41)->(-87,-43)
       fcb 2 ; drawmode 
       fcb 3,-40 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:85|rel:17) dy(abs:34|rel:17)
; node # 95 D(-92,-21)->(-85,-22)
       fcb 2 ; drawmode 
       fcb -20,0 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:119|rel:34) dy(abs:17|rel:-17)
; node # 96 D(-58,2)->(-52,2)
       fcb 2 ; drawmode 
       fcb -23,34 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:102|rel:-17) dy(abs:0|rel:-17)
; node # 97 D(-62,3)->(-58,4)
       fcb 2 ; drawmode 
       fcb -1,-4 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:68|rel:-34) dy(abs:-17|rel:-17)
; node # 98 D(-94,-18)->(-91,-19)
       fcb 2 ; drawmode 
       fcb 21,-32 ; starx/y relative to previous node
       fdb 34,-17 ; dx/dy. dx(abs:51|rel:-17) dy(abs:17|rel:34)
; node # 99 D(-95,-37)->(-92,-39)
       fcb 2 ; drawmode 
       fcb 19,-1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:34|rel:17)
; node # 100 D(-56,-34)->(-53,-35)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:17|rel:-17)
; node # 101 D(-52,-38)->(-48,-39)
       fcb 2 ; drawmode 
       fcb 4,4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:68|rel:17) dy(abs:17|rel:0)
; node # 102 D(-53,-42)->(-50,-43)
       fcb 2 ; drawmode 
       fcb 4,-1 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:51|rel:-17) dy(abs:17|rel:0)
; node # 103 D(-101,-45)->(-97,-48)
       fcb 2 ; drawmode 
       fcb 3,-48 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:68|rel:17) dy(abs:51|rel:34)
; node # 104 D(-99,-13)->(-94,-14)
       fcb 2 ; drawmode 
       fcb -32,2 ; starx/y relative to previous node
       fdb -34,17 ; dx/dy. dx(abs:85|rel:17) dy(abs:17|rel:-34)
; node # 105 D(-62,12)->(-57,13)
       fcb 2 ; drawmode 
       fcb -25,37 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:85|rel:0) dy(abs:-17|rel:-34)
; node # 106 D(-62,3)->(-58,4)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:68|rel:-17) dy(abs:-17|rel:0)
; node # 107 M(40,0)->(50,0)
       fcb 0 ; drawmode 
       fcb 3,102 ; starx/y relative to previous node
       fdb 17,102 ; dx/dy. dx(abs:170|rel:102) dy(abs:0|rel:17)
; node # 108 D(68,2)->(67,2)
       fcb 2 ; drawmode 
       fcb -2,28 ; starx/y relative to previous node
       fdb 0,-187 ; dx/dy. dx(abs:-17|rel:-187) dy(abs:0|rel:0)
; node # 109 M(5,4)->(33,6)
       fcb 0 ; drawmode 
       fcb -2,-63 ; starx/y relative to previous node
       fdb -34,494 ; dx/dy. dx(abs:477|rel:494) dy(abs:-34|rel:-34)
; node # 110 M(-95,-37)->(-92,-39)
       fcb 0 ; drawmode 
       fcb 41,-100 ; starx/y relative to previous node
       fdb 68,-426 ; dx/dy. dx(abs:51|rel:-426) dy(abs:34|rel:68)
; node # 111 D(-101,-45)->(-97,-48)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:68|rel:17) dy(abs:51|rel:17)
; node # 112 M(-62,12)->(-57,13)
       fcb 0 ; drawmode 
       fcb -57,39 ; starx/y relative to previous node
       fdb -68,17 ; dx/dy. dx(abs:85|rel:17) dy(abs:-17|rel:-68)
; node # 113 D(-58,2)->(-52,2)
       fcb 2 ; drawmode 
       fcb 10,4 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:102|rel:17) dy(abs:0|rel:17)
; node # 114 M(-94,-18)->(-91,-19)
       fcb 0 ; drawmode 
       fcb 20,-36 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:17|rel:17)
; node # 115 D(-99,-14)->(-94,-14)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:85|rel:34) dy(abs:0|rel:-17)
; node # 116 D(-92,-21)->(-85,-22)
       fcb 2 ; drawmode 
       fcb 7,7 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:119|rel:34) dy(abs:17|rel:17)
; node # 117 D(-94,-18)->(-91,-19)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:51|rel:-68) dy(abs:17|rel:0)
; node # 118 M(-95,-37)->(-92,-39)
       fcb 0 ; drawmode 
       fcb 19,-1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:34|rel:17)
; node # 119 D(-92,-41)->(-87,-43)
       fcb 2 ; drawmode 
       fcb 4,3 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:85|rel:34) dy(abs:34|rel:0)
; node # 120 M(-92,-41)->(-87,-43)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:85|rel:0) dy(abs:34|rel:0)
; node # 121 D(-101,-45)->(-97,-48)
       fcb 2 ; drawmode 
       fcb 4,-9 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:68|rel:-17) dy(abs:51|rel:17)
; node # 122 M(-56,-34)->(-53,-35)
       fcb 0 ; drawmode 
       fcb -11,45 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:51|rel:-17) dy(abs:17|rel:-34)
; node # 123 D(-53,-42)->(-50,-43)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:17|rel:0)
       fcb  1  ; end of anim
; Animation 9
teapotframe9:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(67,2)->(65,2)
       fcb 0 ; drawmode 
       fcb -2,67 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 1 D(44,9)->(36,9)
       fcb 2 ; drawmode 
       fcb -7,-23 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-146|rel:-110) dy(abs:0|rel:0)
; node # 2 D(36,30)->(31,29)
       fcb 2 ; drawmode 
       fcb -21,-8 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:18)
; node # 3 D(52,28)->(52,26)
       fcb 2 ; drawmode 
       fcb 2,16 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:36|rel:18)
; node # 4 D(67,2)->(65,2)
       fcb 2 ; drawmode 
       fcb 26,15 ; starx/y relative to previous node
       fdb -36,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:-36)
; node # 5 D(61,-19)->(59,-18)
       fcb 2 ; drawmode 
       fcb 21,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:-18|rel:-18)
; node # 6 D(39,-10)->(32,-9)
       fcb 2 ; drawmode 
       fcb -9,-22 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:-18|rel:0)
; node # 7 D(28,-44)->(21,-43)
       fcb 2 ; drawmode 
       fcb 34,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:0)
; node # 8 D(-1,-36)->(-9,-36)
       fcb 2 ; drawmode 
       fcb -8,-29 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:18)
; node # 9 D(-32,-35)->(-39,-36)
       fcb 2 ; drawmode 
       fcb -1,-31 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:18)
; node # 10 D(-34,0)->(-42,0)
       fcb 2 ; drawmode 
       fcb -35,-2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:-18)
; node # 11 D(-34,19)->(-41,19)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 12 D(-24,37)->(-29,37)
       fcb 2 ; drawmode 
       fcb -18,10 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:0|rel:0)
; node # 13 D(-44,39)->(-45,40)
       fcb 2 ; drawmode 
       fcb -2,-20 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-18|rel:73) dy(abs:-18|rel:-18)
; node # 14 D(-63,19)->(-65,19)
       fcb 2 ; drawmode 
       fcb 20,-19 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:18)
; node # 15 D(-62,-3)->(-64,-4)
       fcb 2 ; drawmode 
       fcb 22,1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:18|rel:18)
; node # 16 D(-34,0)->(-42,0)
       fcb 2 ; drawmode 
       fcb -3,28 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:-146|rel:-110) dy(abs:0|rel:-18)
; node # 17 D(4,-3)->(-5,-3)
       fcb 2 ; drawmode 
       fcb 3,38 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 18 D(-1,-36)->(-9,-36)
       fcb 2 ; drawmode 
       fcb 33,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 19 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb 18,-5 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-18|rel:128) dy(abs:0|rel:0)
; node # 20 D(-32,-35)->(-39,-36)
       fcb 2 ; drawmode 
       fcb -19,-26 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:18|rel:18)
; node # 21 D(-54,-42)->(-56,-44)
       fcb 2 ; drawmode 
       fcb 7,-22 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:36|rel:18)
; node # 22 D(-62,-3)->(-64,-4)
       fcb 2 ; drawmode 
       fcb -39,-8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:18|rel:-18)
; node # 23 D(-56,-13)->(-49,-13)
       fcb 2 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:0|rel:-18)
; node # 24 D(-57,13)->(-49,13)
       fcb 2 ; drawmode 
       fcb -26,-1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:146|rel:18) dy(abs:0|rel:0)
; node # 25 D(-63,19)->(-65,19)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-36|rel:-182) dy(abs:0|rel:0)
; node # 26 D(-34,19)->(-41,19)
       fcb 2 ; drawmode 
       fcb 0,29 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:0|rel:0)
; node # 27 D(5,15)->(-3,15)
       fcb 2 ; drawmode 
       fcb 4,39 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 28 D(4,-3)->(-5,-3)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 29 D(39,-10)->(32,-9)
       fcb 2 ; drawmode 
       fcb 7,35 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-18|rel:-18)
; node # 30 D(44,9)->(36,9)
       fcb 2 ; drawmode 
       fcb -19,5 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:18)
; node # 31 D(5,15)->(-3,15)
       fcb 2 ; drawmode 
       fcb -6,-39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 32 D(6,34)->(0,33)
       fcb 2 ; drawmode 
       fcb -19,1 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:18)
; node # 33 D(36,30)->(31,29)
       fcb 2 ; drawmode 
       fcb 4,30 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:0)
; node # 34 M(-24,37)->(-29,37)
       fcb 0 ; drawmode 
       fcb -7,-60 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:0|rel:-18)
; node # 35 D(6,34)->(0,33)
       fcb 2 ; drawmode 
       fcb 3,30 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:18|rel:18)
; node # 36 M(44,9)->(36,9)
       fcb 0 ; drawmode 
       fcb 25,38 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-18)
; node # 37 D(53,-18)->(42,-17)
       fcb 2 ; drawmode 
       fcb 27,9 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:-18|rel:-18)
; node # 38 D(62,-30)->(49,-29)
       fcb 2 ; drawmode 
       fcb 12,9 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-237|rel:-36) dy(abs:-18|rel:0)
; node # 39 D(51,-30)->(39,-29)
       fcb 2 ; drawmode 
       fcb 0,-11 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:-18|rel:0)
; node # 40 D(34,-13)->(26,-13)
       fcb 2 ; drawmode 
       fcb -17,-17 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:18)
; node # 41 D(44,9)->(36,9)
       fcb 2 ; drawmode 
       fcb -22,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 42 D(41,-15)->(34,-14)
       fcb 2 ; drawmode 
       fcb 24,-3 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-18|rel:-18)
; node # 43 D(34,-13)->(26,-13)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:18)
; node # 44 M(58,-32)->(47,-31)
       fcb 0 ; drawmode 
       fcb 19,24 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:-18|rel:-18)
; node # 45 D(51,-30)->(39,-29)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:-18|rel:0)
; node # 46 M(62,-30)->(49,-29)
       fcb 0 ; drawmode 
       fcb 0,11 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:-18|rel:0)
; node # 47 D(58,-32)->(47,-31)
       fcb 2 ; drawmode 
       fcb 2,-4 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-201|rel:36) dy(abs:-18|rel:0)
; node # 48 D(41,-15)->(34,-14)
       fcb 2 ; drawmode 
       fcb -17,-17 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:-18|rel:0)
; node # 49 M(28,-44)->(21,-43)
       fcb 0 ; drawmode 
       fcb 29,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:0)
; node # 50 D(44,-55)->(41,-54)
       fcb 2 ; drawmode 
       fcb 11,16 ; starx/y relative to previous node
       fdb 0,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:-18|rel:0)
; node # 51 D(61,-19)->(59,-18)
       fcb 2 ; drawmode 
       fcb -36,17 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:-18|rel:0)
; node # 52 D(44,-26)->(51,-25)
       fcb 2 ; drawmode 
       fcb 7,-17 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:-18|rel:0)
; node # 53 D(29,-66)->(34,-64)
       fcb 2 ; drawmode 
       fcb 40,-15 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:-36|rel:-18)
; node # 54 D(44,-55)->(41,-54)
       fcb 2 ; drawmode 
       fcb -11,15 ; starx/y relative to previous node
       fdb 18,-145 ; dx/dy. dx(abs:-54|rel:-145) dy(abs:-18|rel:18)
; node # 55 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb -1,-50 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:0|rel:18)
; node # 56 D(-8,-64)->(-8,-65)
       fcb 2 ; drawmode 
       fcb 10,-2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:18)
; node # 57 D(0,-63)->(-1,-63)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:-18)
; node # 58 D(-6,-59)->(-9,-59)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-54|rel:-36) dy(abs:0|rel:0)
; node # 59 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:0|rel:0)
; node # 60 D(29,-66)->(34,-64)
       fcb 2 ; drawmode 
       fcb 12,35 ; starx/y relative to previous node
       fdb -36,109 ; dx/dy. dx(abs:91|rel:109) dy(abs:-36|rel:-36)
; node # 61 D(-12,-67)->(-3,-66)
       fcb 2 ; drawmode 
       fcb 1,-41 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:164|rel:73) dy(abs:-18|rel:18)
; node # 62 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb -13,6 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:-18|rel:-182) dy(abs:0|rel:18)
; node # 63 D(-54,-42)->(-56,-44)
       fcb 2 ; drawmode 
       fcb -12,-48 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:36|rel:36)
; node # 64 D(-49,-55)->(-44,-56)
       fcb 2 ; drawmode 
       fcb 13,5 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:91|rel:127) dy(abs:18|rel:-18)
; node # 65 D(-56,-13)->(-49,-13)
       fcb 2 ; drawmode 
       fcb -42,-7 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:128|rel:37) dy(abs:0|rel:-18)
; node # 66 D(-9,-24)->(4,-24)
       fcb 2 ; drawmode 
       fcb 11,47 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:237|rel:109) dy(abs:0|rel:0)
; node # 67 D(-6,4)->(8,4)
       fcb 2 ; drawmode 
       fcb -28,3 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:0|rel:0)
; node # 68 D(-57,13)->(-49,13)
       fcb 2 ; drawmode 
       fcb -9,-51 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:146|rel:-110) dy(abs:0|rel:0)
; node # 69 D(-37,38)->(-31,38)
       fcb 2 ; drawmode 
       fcb -25,20 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:0|rel:0)
; node # 70 D(-1,33)->(10,33)
       fcb 2 ; drawmode 
       fcb 5,36 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:201|rel:92) dy(abs:0|rel:0)
; node # 71 D(-6,4)->(8,4)
       fcb 2 ; drawmode 
       fcb 29,-5 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:256|rel:55) dy(abs:0|rel:0)
; node # 72 D(50,0)->(58,0)
       fcb 2 ; drawmode 
       fcb 4,56 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:146|rel:-110) dy(abs:0|rel:0)
; node # 73 D(39,29)->(46,28)
       fcb 2 ; drawmode 
       fcb -29,-11 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:18|rel:18)
; node # 74 D(52,28)->(52,26)
       fcb 2 ; drawmode 
       fcb 1,13 ; starx/y relative to previous node
       fdb 18,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:36|rel:18)
; node # 75 M(-37,38)->(-31,38)
       fcb 0 ; drawmode 
       fcb -10,-89 ; starx/y relative to previous node
       fdb -36,109 ; dx/dy. dx(abs:109|rel:109) dy(abs:0|rel:-36)
; node # 76 D(-44,39)->(-45,40)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-18|rel:-127) dy(abs:-18|rel:-18)
; node # 77 M(39,29)->(46,28)
       fcb 0 ; drawmode 
       fcb 10,83 ; starx/y relative to previous node
       fdb 36,146 ; dx/dy. dx(abs:128|rel:146) dy(abs:18|rel:36)
; node # 78 D(-1,33)->(10,33)
       fcb 2 ; drawmode 
       fcb -4,-40 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:201|rel:73) dy(abs:0|rel:-18)
; node # 79 M(50,0)->(58,0)
       fcb 0 ; drawmode 
       fcb 33,51 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:146|rel:-55) dy(abs:0|rel:0)
; node # 80 D(44,-26)->(51,-25)
       fcb 2 ; drawmode 
       fcb 26,-6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:-18|rel:-18)
; node # 81 D(-9,-24)->(4,-24)
       fcb 2 ; drawmode 
       fcb -2,-53 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:237|rel:109) dy(abs:0|rel:18)
; node # 82 D(-12,-67)->(-3,-66)
       fcb 2 ; drawmode 
       fcb 43,-3 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:164|rel:-73) dy(abs:-18|rel:-18)
; node # 83 D(-49,-55)->(-44,-56)
       fcb 2 ; drawmode 
       fcb -12,-37 ; starx/y relative to previous node
       fdb 36,-73 ; dx/dy. dx(abs:91|rel:-73) dy(abs:18|rel:36)
; node # 84 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb -1,43 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:-18|rel:-109) dy(abs:0|rel:-18)
; node # 85 M(-8,-64)->(-8,-65)
       fcb 0 ; drawmode 
       fcb 10,-2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:18)
; node # 86 D(-15,-60)->(-17,-61)
       fcb 2 ; drawmode 
       fcb -4,-7 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:0)
; node # 87 D(-6,-59)->(-9,-59)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:0|rel:-18)
; node # 88 M(0,-63)->(-1,-63)
       fcb 0 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:0|rel:0)
; node # 89 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:0)
; node # 90 D(28,-44)->(21,-43)
       fcb 2 ; drawmode 
       fcb -10,34 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:-18|rel:-18)
; node # 91 M(-15,-60)->(-17,-61)
       fcb 0 ; drawmode 
       fcb 16,-43 ; starx/y relative to previous node
       fdb 36,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:18|rel:36)
; node # 92 D(-6,-54)->(-7,-54)
       fcb 2 ; drawmode 
       fcb -6,9 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:-18)
; node # 93 M(-48,-39)->(-41,-40)
       fcb 0 ; drawmode 
       fcb -15,-42 ; starx/y relative to previous node
       fdb 18,146 ; dx/dy. dx(abs:128|rel:146) dy(abs:18|rel:18)
; node # 94 D(-87,-43)->(-77,-45)
       fcb 2 ; drawmode 
       fcb 4,-39 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:182|rel:54) dy(abs:36|rel:18)
; node # 95 D(-85,-22)->(-74,-23)
       fcb 2 ; drawmode 
       fcb -21,2 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:201|rel:19) dy(abs:18|rel:-18)
; node # 96 D(-52,2)->(-43,2)
       fcb 2 ; drawmode 
       fcb -24,33 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:0|rel:-18)
; node # 97 D(-58,4)->(-52,4)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:0|rel:0)
; node # 98 D(-91,-19)->(-83,-20)
       fcb 2 ; drawmode 
       fcb 23,-33 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:18|rel:18)
; node # 99 D(-92,-39)->(-85,-41)
       fcb 2 ; drawmode 
       fcb 20,-1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:36|rel:18)
; node # 100 D(-53,-35)->(-49,-37)
       fcb 2 ; drawmode 
       fcb -4,39 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:73|rel:-55) dy(abs:36|rel:0)
; node # 101 D(-48,-39)->(-41,-40)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:128|rel:55) dy(abs:18|rel:-18)
; node # 102 D(-50,-43)->(-45,-44)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:18|rel:0)
; node # 103 D(-97,-48)->(-88,-51)
       fcb 2 ; drawmode 
       fcb 5,-47 ; starx/y relative to previous node
       fdb 36,73 ; dx/dy. dx(abs:164|rel:73) dy(abs:54|rel:36)
; node # 104 D(-94,-14)->(-84,-15)
       fcb 2 ; drawmode 
       fcb -34,3 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:18|rel:-36)
; node # 105 D(-57,13)->(-49,13)
       fcb 2 ; drawmode 
       fcb -27,37 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:146|rel:-36) dy(abs:0|rel:-18)
; node # 106 D(-58,4)->(-52,4)
       fcb 2 ; drawmode 
       fcb 9,-1 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:0|rel:0)
; node # 107 M(50,0)->(58,0)
       fcb 0 ; drawmode 
       fcb 4,108 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:0|rel:0)
; node # 108 D(67,2)->(65,2)
       fcb 2 ; drawmode 
       fcb -2,17 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-36|rel:-182) dy(abs:0|rel:0)
; node # 109 M(14,-2)->(33,6)
       fcb 0 ; drawmode 
       fcb 4,-53 ; starx/y relative to previous node
       fdb -146,383 ; dx/dy. dx(abs:347|rel:383) dy(abs:-146|rel:-146)
; node # 110 M(-97,-48)->(-88,-51)
       fcb 0 ; drawmode 
       fcb 46,-111 ; starx/y relative to previous node
       fdb 200,-183 ; dx/dy. dx(abs:164|rel:-183) dy(abs:54|rel:200)
; node # 111 D(-92,-39)->(-85,-41)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:36|rel:-18)
; node # 112 M(-57,13)->(-49,13)
       fcb 0 ; drawmode 
       fcb -52,35 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:146|rel:18) dy(abs:0|rel:-36)
; node # 113 D(-52,2)->(-43,2)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:164|rel:18) dy(abs:0|rel:0)
; node # 114 M(-85,-22)->(-74,-23)
       fcb 0 ; drawmode 
       fcb 24,-33 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:201|rel:37) dy(abs:18|rel:18)
; node # 115 D(-94,-14)->(-84,-15)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:182|rel:-19) dy(abs:18|rel:0)
; node # 116 D(-91,-19)->(-83,-20)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:146|rel:-36) dy(abs:18|rel:0)
; node # 117 D(-85,-22)->(-74,-23)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:201|rel:55) dy(abs:18|rel:0)
; node # 118 M(-92,-39)->(-85,-41)
       fcb 0 ; drawmode 
       fcb 17,-7 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:128|rel:-73) dy(abs:36|rel:18)
; node # 119 D(-87,-43)->(-77,-45)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:182|rel:54) dy(abs:36|rel:0)
; node # 120 M(-87,-43)->(-77,-45)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:36|rel:0)
; node # 121 D(-97,-48)->(-88,-51)
       fcb 2 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:54|rel:18)
; node # 122 M(-53,-35)->(-49,-37)
       fcb 0 ; drawmode 
       fcb -13,44 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:73|rel:-91) dy(abs:36|rel:-18)
; node # 123 D(-50,-43)->(-45,-44)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:91|rel:18) dy(abs:18|rel:-18)
       fcb  1  ; end of anim
; Animation 10
teapotframe10:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(65,2)->(59,3)
       fcb 0 ; drawmode 
       fcb -2,65 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:-18|rel:-18)
; node # 1 D(36,9)->(28,9)
       fcb 2 ; drawmode 
       fcb -7,-29 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:18)
; node # 2 D(31,29)->(25,28)
       fcb 2 ; drawmode 
       fcb -20,-5 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:18)
; node # 3 D(52,26)->(49,25)
       fcb 2 ; drawmode 
       fcb 3,21 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:18|rel:0)
; node # 4 D(65,2)->(59,3)
       fcb 2 ; drawmode 
       fcb 24,13 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:-18|rel:-36)
; node # 5 D(59,-18)->(54,-18)
       fcb 2 ; drawmode 
       fcb 20,-6 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:18)
; node # 6 D(32,-9)->(24,-9)
       fcb 2 ; drawmode 
       fcb -9,-27 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:0)
; node # 7 D(21,-43)->(14,-42)
       fcb 2 ; drawmode 
       fcb 34,-11 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-18|rel:-18)
; node # 8 D(-9,-36)->(-17,-37)
       fcb 2 ; drawmode 
       fcb -7,-30 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:18|rel:36)
; node # 9 D(-39,-36)->(-46,-37)
       fcb 2 ; drawmode 
       fcb 0,-30 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:0)
; node # 10 D(-42,0)->(-49,0)
       fcb 2 ; drawmode 
       fcb -36,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:-18)
; node # 11 D(-41,19)->(-48,19)
       fcb 2 ; drawmode 
       fcb -19,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 12 D(-29,37)->(-33,38)
       fcb 2 ; drawmode 
       fcb -18,12 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:-18|rel:-18)
; node # 13 D(-45,40)->(-44,41)
       fcb 2 ; drawmode 
       fcb -3,-16 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:-18|rel:0)
; node # 14 D(-65,19)->(-65,20)
       fcb 2 ; drawmode 
       fcb 21,-20 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-18|rel:0)
; node # 15 D(-64,-4)->(-65,-5)
       fcb 2 ; drawmode 
       fcb 23,1 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:36)
; node # 16 D(-42,0)->(-48,0)
       fcb 2 ; drawmode 
       fcb -4,22 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:0|rel:-18)
; node # 17 D(-5,-3)->(-14,-3)
       fcb 2 ; drawmode 
       fcb 3,37 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 18 D(-9,-36)->(-17,-37)
       fcb 2 ; drawmode 
       fcb 33,-4 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 19 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:0|rel:-18)
; node # 20 D(-39,-36)->(-46,-37)
       fcb 2 ; drawmode 
       fcb -18,-32 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:18|rel:18)
; node # 21 D(-56,-44)->(-57,-45)
       fcb 2 ; drawmode 
       fcb 8,-17 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:18|rel:0)
; node # 22 D(-64,-4)->(-65,-5)
       fcb 2 ; drawmode 
       fcb -40,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:18|rel:0)
; node # 23 D(-49,-13)->(-40,-14)
       fcb 2 ; drawmode 
       fcb 9,15 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:164|rel:182) dy(abs:18|rel:0)
; node # 24 D(-49,13)->(-38,14)
       fcb 2 ; drawmode 
       fcb -26,0 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:201|rel:37) dy(abs:-18|rel:-36)
; node # 25 D(-65,19)->(-65,20)
       fcb 2 ; drawmode 
       fcb -6,-16 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:0|rel:-201) dy(abs:-18|rel:0)
; node # 26 D(-41,19)->(-47,19)
       fcb 2 ; drawmode 
       fcb 0,24 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:0|rel:18)
; node # 27 D(-3,15)->(-12,15)
       fcb 2 ; drawmode 
       fcb 4,38 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 28 D(-5,-3)->(-14,-3)
       fcb 2 ; drawmode 
       fcb 18,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 29 D(32,-9)->(24,-9)
       fcb 2 ; drawmode 
       fcb 6,37 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 30 D(36,9)->(28,9)
       fcb 2 ; drawmode 
       fcb -18,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 31 D(-3,15)->(-12,15)
       fcb 2 ; drawmode 
       fcb -6,-39 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 32 D(0,33)->(-7,33)
       fcb 2 ; drawmode 
       fcb -18,3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 33 D(31,29)->(25,28)
       fcb 2 ; drawmode 
       fcb 4,31 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
; node # 34 M(-29,37)->(-33,38)
       fcb 0 ; drawmode 
       fcb -8,-60 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-18|rel:-36)
; node # 35 D(0,33)->(-7,33)
       fcb 2 ; drawmode 
       fcb 4,29 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:18)
; node # 36 M(36,9)->(28,9)
       fcb 0 ; drawmode 
       fcb 24,36 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 37 D(42,-17)->(30,-15)
       fcb 2 ; drawmode 
       fcb 26,6 ; starx/y relative to previous node
       fdb -36,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:-36|rel:-36)
; node # 38 D(49,-29)->(35,-29)
       fcb 2 ; drawmode 
       fcb 12,7 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:-256|rel:-37) dy(abs:0|rel:36)
; node # 39 D(39,-29)->(27,-29)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-219|rel:37) dy(abs:0|rel:0)
; node # 40 D(26,-13)->(18,-13)
       fcb 2 ; drawmode 
       fcb -16,-13 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:0)
; node # 41 D(36,9)->(28,9)
       fcb 2 ; drawmode 
       fcb -22,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 42 D(34,-14)->(26,-13)
       fcb 2 ; drawmode 
       fcb 23,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-18|rel:-18)
; node # 43 D(26,-13)->(18,-13)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:18)
; node # 44 M(47,-31)->(35,-31)
       fcb 0 ; drawmode 
       fcb 18,21 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:0)
; node # 45 D(39,-29)->(27,-29)
       fcb 2 ; drawmode 
       fcb -2,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 46 M(49,-29)->(35,-29)
       fcb 0 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-256|rel:-37) dy(abs:0|rel:0)
; node # 47 D(47,-31)->(35,-31)
       fcb 2 ; drawmode 
       fcb 2,-2 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-219|rel:37) dy(abs:0|rel:0)
; node # 48 D(34,-14)->(26,-13)
       fcb 2 ; drawmode 
       fcb -17,-13 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:-18|rel:-18)
; node # 49 M(21,-43)->(14,-42)
       fcb 0 ; drawmode 
       fcb 29,-13 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-18|rel:0)
; node # 50 D(41,-54)->(38,-53)
       fcb 2 ; drawmode 
       fcb 11,20 ; starx/y relative to previous node
       fdb 0,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:-18|rel:0)
; node # 51 D(59,-18)->(54,-18)
       fcb 2 ; drawmode 
       fcb -36,18 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:0|rel:18)
; node # 52 D(51,-25)->(56,-25)
       fcb 2 ; drawmode 
       fcb 7,-8 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:91|rel:182) dy(abs:0|rel:0)
; node # 53 D(34,-64)->(37,-63)
       fcb 2 ; drawmode 
       fcb 39,-17 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:-18|rel:-18)
; node # 54 D(41,-54)->(38,-53)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb 0,-108 ; dx/dy. dx(abs:-54|rel:-108) dy(abs:-18|rel:0)
; node # 55 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb 0,-48 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:0|rel:18)
; node # 56 D(-8,-65)->(-8,-65)
       fcb 2 ; drawmode 
       fcb 11,-1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 57 D(-1,-63)->(-2,-63)
       fcb 2 ; drawmode 
       fcb -2,7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 58 D(-9,-59)->(-11,-60)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:18|rel:18)
; node # 59 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb -5,2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:-18)
; node # 60 D(34,-64)->(37,-63)
       fcb 2 ; drawmode 
       fcb 10,41 ; starx/y relative to previous node
       fdb -18,90 ; dx/dy. dx(abs:54|rel:90) dy(abs:-18|rel:-18)
; node # 61 D(-3,-66)->(5,-66)
       fcb 2 ; drawmode 
       fcb 2,-37 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:146|rel:92) dy(abs:0|rel:18)
; node # 62 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb -12,-4 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-36|rel:-182) dy(abs:0|rel:0)
; node # 63 D(-56,-44)->(-57,-45)
       fcb 2 ; drawmode 
       fcb -10,-49 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:18)
; node # 64 D(-44,-56)->(-38,-58)
       fcb 2 ; drawmode 
       fcb 12,12 ; starx/y relative to previous node
       fdb 18,127 ; dx/dy. dx(abs:109|rel:127) dy(abs:36|rel:18)
; node # 65 D(-49,-13)->(-40,-14)
       fcb 2 ; drawmode 
       fcb -43,-5 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:164|rel:55) dy(abs:18|rel:-18)
; node # 66 D(4,-24)->(17,-24)
       fcb 2 ; drawmode 
       fcb 11,53 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:237|rel:73) dy(abs:0|rel:-18)
; node # 67 D(8,4)->(23,4)
       fcb 2 ; drawmode 
       fcb -28,4 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:274|rel:37) dy(abs:0|rel:0)
; node # 68 D(-49,13)->(-38,14)
       fcb 2 ; drawmode 
       fcb -9,-57 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:201|rel:-73) dy(abs:-18|rel:-18)
; node # 69 D(-31,38)->(-23,39)
       fcb 2 ; drawmode 
       fcb -25,18 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:146|rel:-55) dy(abs:-18|rel:0)
; node # 70 D(10,33)->(21,32)
       fcb 2 ; drawmode 
       fcb 5,41 ; starx/y relative to previous node
       fdb 36,55 ; dx/dy. dx(abs:201|rel:55) dy(abs:18|rel:36)
; node # 71 D(8,4)->(23,4)
       fcb 2 ; drawmode 
       fcb 29,-2 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:274|rel:73) dy(abs:0|rel:-18)
; node # 72 D(58,0)->(63,0)
       fcb 2 ; drawmode 
       fcb 4,50 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:91|rel:-183) dy(abs:0|rel:0)
; node # 73 D(46,28)->(50,27)
       fcb 2 ; drawmode 
       fcb -28,-12 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:18|rel:18)
; node # 74 D(52,26)->(49,25)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-54|rel:-127) dy(abs:18|rel:0)
; node # 75 M(-31,38)->(-23,39)
       fcb 0 ; drawmode 
       fcb -12,-83 ; starx/y relative to previous node
       fdb -36,200 ; dx/dy. dx(abs:146|rel:200) dy(abs:-18|rel:-36)
; node # 76 D(-45,40)->(-44,41)
       fcb 2 ; drawmode 
       fcb -2,-14 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:18|rel:-128) dy(abs:-18|rel:0)
; node # 77 M(46,28)->(50,27)
       fcb 0 ; drawmode 
       fcb 12,91 ; starx/y relative to previous node
       fdb 36,55 ; dx/dy. dx(abs:73|rel:55) dy(abs:18|rel:36)
; node # 78 D(10,33)->(21,32)
       fcb 2 ; drawmode 
       fcb -5,-36 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:201|rel:128) dy(abs:18|rel:0)
; node # 79 M(58,0)->(63,0)
       fcb 0 ; drawmode 
       fcb 33,48 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:91|rel:-110) dy(abs:0|rel:-18)
; node # 80 D(51,-25)->(56,-25)
       fcb 2 ; drawmode 
       fcb 25,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:0|rel:0)
; node # 81 D(4,-24)->(17,-24)
       fcb 2 ; drawmode 
       fcb -1,-47 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:237|rel:146) dy(abs:0|rel:0)
; node # 82 D(-3,-66)->(5,-66)
       fcb 2 ; drawmode 
       fcb 42,-7 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:146|rel:-91) dy(abs:0|rel:0)
; node # 83 D(-44,-56)->(-38,-58)
       fcb 2 ; drawmode 
       fcb -10,-41 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:36|rel:36)
; node # 84 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb -2,37 ; starx/y relative to previous node
       fdb -36,-145 ; dx/dy. dx(abs:-36|rel:-145) dy(abs:0|rel:-36)
; node # 85 M(-8,-65)->(-8,-65)
       fcb 0 ; drawmode 
       fcb 11,-1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 86 D(-17,-61)->(-17,-62)
       fcb 2 ; drawmode 
       fcb -4,-9 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:18)
; node # 87 D(-9,-59)->(-11,-60)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:0)
; node # 88 M(-1,-63)->(-2,-63)
       fcb 0 ; drawmode 
       fcb 4,8 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:-18)
; node # 89 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 90 D(21,-43)->(14,-42)
       fcb 2 ; drawmode 
       fcb -11,28 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:-18|rel:-18)
; node # 91 M(-17,-61)->(-17,-62)
       fcb 0 ; drawmode 
       fcb 18,-38 ; starx/y relative to previous node
       fdb 36,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:18|rel:36)
; node # 92 D(-7,-54)->(-9,-54)
       fcb 2 ; drawmode 
       fcb -7,10 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:-18)
; node # 93 M(-41,-40)->(-34,-41)
       fcb 0 ; drawmode 
       fcb -14,-34 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:18|rel:18)
; node # 94 D(-77,-45)->(-62,-47)
       fcb 2 ; drawmode 
       fcb 5,-36 ; starx/y relative to previous node
       fdb 18,146 ; dx/dy. dx(abs:274|rel:146) dy(abs:36|rel:18)
; node # 95 D(-74,-23)->(-59,-24)
       fcb 2 ; drawmode 
       fcb -22,3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:274|rel:0) dy(abs:18|rel:-18)
; node # 96 D(-43,2)->(-32,1)
       fcb 2 ; drawmode 
       fcb -25,31 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:201|rel:-73) dy(abs:18|rel:0)
; node # 97 D(-52,4)->(-43,4)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:0|rel:-18)
; node # 98 D(-83,-20)->(-71,-21)
       fcb 2 ; drawmode 
       fcb 24,-31 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:219|rel:55) dy(abs:18|rel:18)
; node # 99 D(-85,-41)->(-74,-43)
       fcb 2 ; drawmode 
       fcb 21,-2 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:36|rel:18)
; node # 100 D(-49,-37)->(-43,-38)
       fcb 2 ; drawmode 
       fcb -4,36 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:109|rel:-92) dy(abs:18|rel:-18)
; node # 101 D(-41,-40)->(-34,-41)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:128|rel:19) dy(abs:18|rel:0)
; node # 102 D(-45,-44)->(-39,-46)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:109|rel:-19) dy(abs:36|rel:18)
; node # 103 D(-88,-51)->(-75,-54)
       fcb 2 ; drawmode 
       fcb 7,-43 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:237|rel:128) dy(abs:54|rel:18)
; node # 104 D(-84,-15)->(-70,-16)
       fcb 2 ; drawmode 
       fcb -36,4 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:18|rel:-36)
; node # 105 D(-49,13)->(-38,14)
       fcb 2 ; drawmode 
       fcb -28,35 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:201|rel:-55) dy(abs:-18|rel:-36)
; node # 106 D(-52,4)->(-43,4)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:0|rel:18)
; node # 107 M(58,0)->(63,0)
       fcb 0 ; drawmode 
       fcb 4,110 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:91|rel:-73) dy(abs:0|rel:0)
; node # 108 D(65,2)->(59,3)
       fcb 2 ; drawmode 
       fcb -2,7 ; starx/y relative to previous node
       fdb -18,-200 ; dx/dy. dx(abs:-109|rel:-200) dy(abs:-18|rel:-18)
; node # 109 M(33,6)->(33,6)
       fcb 0 ; drawmode 
       fcb -4,-32 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:18)
; node # 110 M(-88,-51)->(-75,-54)
       fcb 0 ; drawmode 
       fcb 57,-121 ; starx/y relative to previous node
       fdb 54,237 ; dx/dy. dx(abs:237|rel:237) dy(abs:54|rel:54)
; node # 111 D(-85,-41)->(-74,-43)
       fcb 2 ; drawmode 
       fcb -10,3 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:201|rel:-36) dy(abs:36|rel:-18)
; node # 112 M(-49,13)->(-38,14)
       fcb 0 ; drawmode 
       fcb -54,36 ; starx/y relative to previous node
       fdb -54,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:-18|rel:-54)
; node # 113 D(-43,2)->(-32,1)
       fcb 2 ; drawmode 
       fcb 11,6 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:18|rel:36)
; node # 114 M(-74,-23)->(-59,-24)
       fcb 0 ; drawmode 
       fcb 25,-31 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:274|rel:73) dy(abs:18|rel:0)
; node # 115 D(-84,-15)->(-70,-16)
       fcb 2 ; drawmode 
       fcb -8,-10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:256|rel:-18) dy(abs:18|rel:0)
; node # 116 D(-83,-20)->(-71,-21)
       fcb 2 ; drawmode 
       fcb 5,1 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:18|rel:0)
; node # 117 D(-74,-23)->(-59,-24)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:274|rel:55) dy(abs:18|rel:0)
; node # 118 M(-85,-41)->(-74,-43)
       fcb 0 ; drawmode 
       fcb 18,-11 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:201|rel:-73) dy(abs:36|rel:18)
; node # 119 D(-77,-45)->(-62,-47)
       fcb 2 ; drawmode 
       fcb 4,8 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:274|rel:73) dy(abs:36|rel:0)
; node # 120 M(-77,-45)->(-62,-47)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:274|rel:0) dy(abs:36|rel:0)
; node # 121 D(-88,-51)->(-75,-54)
       fcb 2 ; drawmode 
       fcb 6,-11 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:237|rel:-37) dy(abs:54|rel:18)
; node # 122 M(-49,-37)->(-43,-38)
       fcb 0 ; drawmode 
       fcb -14,39 ; starx/y relative to previous node
       fdb -36,-128 ; dx/dy. dx(abs:109|rel:-128) dy(abs:18|rel:-36)
; node # 123 D(-45,-44)->(-39,-46)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:109|rel:0) dy(abs:36|rel:18)
       fcb  1  ; end of anim
; Animation 11
teapotframe11:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(59,3)->(55,2)
       fcb 0 ; drawmode 
       fcb -3,59 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-73|rel:-73) dy(abs:18|rel:18)
; node # 1 D(28,9)->(19,9)
       fcb 2 ; drawmode 
       fcb -6,-31 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-164|rel:-91) dy(abs:0|rel:-18)
; node # 2 D(25,28)->(18,28)
       fcb 2 ; drawmode 
       fcb -19,-3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 3 D(49,25)->(45,25)
       fcb 2 ; drawmode 
       fcb 3,24 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:0|rel:0)
; node # 4 D(59,3)->(55,2)
       fcb 2 ; drawmode 
       fcb 22,10 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:18|rel:18)
; node # 5 D(54,-18)->(49,-17)
       fcb 2 ; drawmode 
       fcb 21,-5 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:-18|rel:-36)
; node # 6 D(24,-9)->(15,-9)
       fcb 2 ; drawmode 
       fcb -9,-30 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:18)
; node # 7 D(14,-42)->(7,-42)
       fcb 2 ; drawmode 
       fcb 33,-10 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 8 D(-17,-37)->(-25,-37)
       fcb 2 ; drawmode 
       fcb -5,-31 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 9 D(-46,-37)->(-50,-38)
       fcb 2 ; drawmode 
       fcb 0,-29 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:18|rel:18)
; node # 10 D(-49,0)->(-55,0)
       fcb 2 ; drawmode 
       fcb -37,-3 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:-18)
; node # 11 D(-48,19)->(-54,20)
       fcb 2 ; drawmode 
       fcb -19,1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-18|rel:-18)
; node # 12 D(-33,38)->(-37,39)
       fcb 2 ; drawmode 
       fcb -19,15 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-18|rel:0)
; node # 13 D(-44,41)->(-41,42)
       fcb 2 ; drawmode 
       fcb -3,-11 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:-18|rel:0)
; node # 14 D(-65,20)->(-64,21)
       fcb 2 ; drawmode 
       fcb 21,-21 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:-18|rel:0)
; node # 15 D(-65,-5)->(-64,-4)
       fcb 2 ; drawmode 
       fcb 25,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-18|rel:0)
; node # 16 D(-48,0)->(-55,0)
       fcb 2 ; drawmode 
       fcb -5,17 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:0|rel:18)
; node # 17 D(-14,-3)->(-23,-3)
       fcb 2 ; drawmode 
       fcb 3,34 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 18 D(-17,-37)->(-25,-37)
       fcb 2 ; drawmode 
       fcb 34,-3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 19 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 17,8 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:-18|rel:128) dy(abs:18|rel:18)
; node # 20 D(-46,-37)->(-50,-38)
       fcb 2 ; drawmode 
       fcb -17,-37 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-73|rel:-55) dy(abs:18|rel:0)
; node # 21 D(-57,-45)->(-58,-46)
       fcb 2 ; drawmode 
       fcb 8,-11 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:18|rel:0)
; node # 22 D(-65,-5)->(-64,-4)
       fcb 2 ; drawmode 
       fcb -40,-8 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:-18|rel:-36)
; node # 23 D(-40,-14)->(-29,-14)
       fcb 2 ; drawmode 
       fcb 9,25 ; starx/y relative to previous node
       fdb 18,183 ; dx/dy. dx(abs:201|rel:183) dy(abs:0|rel:18)
; node # 24 D(-38,14)->(-26,14)
       fcb 2 ; drawmode 
       fcb -28,2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:0|rel:0)
; node # 25 D(-65,20)->(-64,21)
       fcb 2 ; drawmode 
       fcb -6,-27 ; starx/y relative to previous node
       fdb -18,-201 ; dx/dy. dx(abs:18|rel:-201) dy(abs:-18|rel:-18)
; node # 26 D(-47,19)->(-54,20)
       fcb 2 ; drawmode 
       fcb 1,18 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:-18|rel:0)
; node # 27 D(-12,15)->(-21,16)
       fcb 2 ; drawmode 
       fcb 4,35 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:0)
; node # 28 D(-14,-3)->(-23,-3)
       fcb 2 ; drawmode 
       fcb 18,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:18)
; node # 29 D(24,-9)->(15,-9)
       fcb 2 ; drawmode 
       fcb 6,38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 30 D(28,9)->(19,9)
       fcb 2 ; drawmode 
       fcb -18,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 31 D(-12,15)->(-21,16)
       fcb 2 ; drawmode 
       fcb -6,-40 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:-18)
; node # 32 D(-7,33)->(-13,33)
       fcb 2 ; drawmode 
       fcb -18,5 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:18)
; node # 33 D(25,28)->(18,28)
       fcb 2 ; drawmode 
       fcb 5,32 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 34 M(-33,38)->(-37,39)
       fcb 0 ; drawmode 
       fcb -10,-58 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:-18|rel:-18)
; node # 35 D(-7,33)->(-12,33)
       fcb 2 ; drawmode 
       fcb 5,26 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:0|rel:18)
; node # 36 M(28,9)->(19,9)
       fcb 0 ; drawmode 
       fcb 24,35 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:0)
; node # 37 D(30,-15)->(19,-15)
       fcb 2 ; drawmode 
       fcb 24,2 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:0|rel:0)
; node # 38 D(35,-29)->(22,-29)
       fcb 2 ; drawmode 
       fcb 14,5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-237|rel:-36) dy(abs:0|rel:0)
; node # 39 D(27,-29)->(15,-28)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:-18|rel:-18)
; node # 40 D(18,-13)->(9,-12)
       fcb 2 ; drawmode 
       fcb -16,-9 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:-18|rel:0)
; node # 41 D(28,9)->(19,9)
       fcb 2 ; drawmode 
       fcb -22,10 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:18)
; node # 42 D(26,-13)->(18,-13)
       fcb 2 ; drawmode 
       fcb 22,-2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 43 D(18,-13)->(9,-12)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:-18|rel:-18)
; node # 44 M(35,-31)->(22,-30)
       fcb 0 ; drawmode 
       fcb 18,17 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-237|rel:-73) dy(abs:-18|rel:0)
; node # 45 D(27,-29)->(15,-28)
       fcb 2 ; drawmode 
       fcb -2,-8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:-18|rel:0)
; node # 46 M(35,-29)->(22,-29)
       fcb 0 ; drawmode 
       fcb 0,8 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:0|rel:18)
; node # 47 D(35,-31)->(22,-30)
       fcb 2 ; drawmode 
       fcb 2,0 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-237|rel:0) dy(abs:-18|rel:-18)
; node # 48 D(26,-13)->(18,-13)
       fcb 2 ; drawmode 
       fcb -18,-9 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:-146|rel:91) dy(abs:0|rel:18)
; node # 49 M(14,-42)->(7,-42)
       fcb 0 ; drawmode 
       fcb 29,-12 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 50 D(38,-53)->(33,-51)
       fcb 2 ; drawmode 
       fcb 11,24 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:-36|rel:-36)
; node # 51 D(54,-18)->(49,-17)
       fcb 2 ; drawmode 
       fcb -35,16 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:-18|rel:18)
; node # 52 D(56,-25)->(59,-23)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb -18,145 ; dx/dy. dx(abs:54|rel:145) dy(abs:-36|rel:-18)
; node # 53 D(37,-63)->(40,-61)
       fcb 2 ; drawmode 
       fcb 38,-19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:-36|rel:0)
; node # 54 D(38,-53)->(33,-51)
       fcb 2 ; drawmode 
       fcb -10,1 ; starx/y relative to previous node
       fdb 0,-145 ; dx/dy. dx(abs:-91|rel:-145) dy(abs:-36|rel:0)
; node # 55 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 1,-47 ; starx/y relative to previous node
       fdb 54,73 ; dx/dy. dx(abs:-18|rel:73) dy(abs:18|rel:54)
; node # 56 D(-8,-65)->(-8,-65)
       fcb 2 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:-18)
; node # 57 D(-2,-63)->(-3,-63)
       fcb 2 ; drawmode 
       fcb -2,6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 58 D(-11,-60)->(-13,-61)
       fcb 2 ; drawmode 
       fcb -3,-9 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:18|rel:18)
; node # 59 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:0)
; node # 60 D(37,-63)->(40,-61)
       fcb 2 ; drawmode 
       fcb 9,46 ; starx/y relative to previous node
       fdb -54,72 ; dx/dy. dx(abs:54|rel:72) dy(abs:-36|rel:-54)
; node # 61 D(5,-66)->(14,-66)
       fcb 2 ; drawmode 
       fcb 3,-32 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:0|rel:36)
; node # 62 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -12,-14 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:-18|rel:-182) dy(abs:18|rel:18)
; node # 63 D(-57,-45)->(-58,-46)
       fcb 2 ; drawmode 
       fcb -9,-48 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:18|rel:0)
; node # 64 D(-38,-58)->(-31,-59)
       fcb 2 ; drawmode 
       fcb 13,19 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:128|rel:146) dy(abs:18|rel:0)
; node # 65 D(-40,-14)->(-29,-14)
       fcb 2 ; drawmode 
       fcb -44,-2 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:201|rel:73) dy(abs:0|rel:-18)
; node # 66 D(17,-24)->(29,-24)
       fcb 2 ; drawmode 
       fcb 10,57 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:0|rel:0)
; node # 67 D(23,4)->(36,4)
       fcb 2 ; drawmode 
       fcb -28,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 68 D(-38,14)->(-26,14)
       fcb 2 ; drawmode 
       fcb -10,-61 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:0)
; node # 69 D(-23,39)->(-13,39)
       fcb 2 ; drawmode 
       fcb -25,15 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:0|rel:0)
; node # 70 D(21,32)->(30,32)
       fcb 2 ; drawmode 
       fcb 7,44 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:0|rel:0)
; node # 71 D(23,4)->(36,4)
       fcb 2 ; drawmode 
       fcb 28,2 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:237|rel:73) dy(abs:0|rel:0)
; node # 72 D(63,0)->(66,0)
       fcb 2 ; drawmode 
       fcb 4,40 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:54|rel:-183) dy(abs:0|rel:0)
; node # 73 D(50,27)->(53,26)
       fcb 2 ; drawmode 
       fcb -27,-13 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:18|rel:18)
; node # 74 D(49,25)->(45,25)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:0|rel:-18)
; node # 75 M(-23,39)->(-13,39)
       fcb 0 ; drawmode 
       fcb -14,-72 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:182|rel:255) dy(abs:0|rel:0)
; node # 76 D(-44,41)->(-41,42)
       fcb 2 ; drawmode 
       fcb -2,-21 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:54|rel:-128) dy(abs:-18|rel:-18)
; node # 77 M(50,27)->(53,26)
       fcb 0 ; drawmode 
       fcb 14,94 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:18|rel:36)
; node # 78 D(21,32)->(30,32)
       fcb 2 ; drawmode 
       fcb -5,-29 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:0|rel:-18)
; node # 79 M(63,0)->(66,0)
       fcb 0 ; drawmode 
       fcb 32,42 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:54|rel:-110) dy(abs:0|rel:0)
; node # 80 D(56,-25)->(59,-23)
       fcb 2 ; drawmode 
       fcb 25,-7 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:-36|rel:-36)
; node # 81 D(17,-24)->(29,-24)
       fcb 2 ; drawmode 
       fcb -1,-39 ; starx/y relative to previous node
       fdb 36,165 ; dx/dy. dx(abs:219|rel:165) dy(abs:0|rel:36)
; node # 82 D(5,-66)->(14,-66)
       fcb 2 ; drawmode 
       fcb 42,-12 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:164|rel:-55) dy(abs:0|rel:0)
; node # 83 D(-38,-58)->(-31,-59)
       fcb 2 ; drawmode 
       fcb -8,-43 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:18|rel:18)
; node # 84 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -4,29 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:18|rel:0)
; node # 85 M(-8,-65)->(-8,-65)
       fcb 0 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:-18)
; node # 86 D(-17,-62)->(-18,-63)
       fcb 2 ; drawmode 
       fcb -3,-9 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:18)
; node # 87 D(-11,-60)->(-13,-61)
       fcb 2 ; drawmode 
       fcb -2,6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:18|rel:0)
; node # 88 M(-2,-63)->(-3,-63)
       fcb 0 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:-18)
; node # 89 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -9,-7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:18|rel:18)
; node # 90 D(14,-42)->(7,-42)
       fcb 2 ; drawmode 
       fcb -12,23 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:0|rel:-18)
; node # 91 M(-17,-62)->(-18,-63)
       fcb 0 ; drawmode 
       fcb 20,-31 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:18|rel:18)
; node # 92 D(-9,-54)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -8,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:18|rel:0)
; node # 93 M(-34,-41)->(-24,-42)
       fcb 0 ; drawmode 
       fcb -13,-25 ; starx/y relative to previous node
       fdb 0,200 ; dx/dy. dx(abs:182|rel:200) dy(abs:18|rel:0)
; node # 94 D(-62,-47)->(-46,-49)
       fcb 2 ; drawmode 
       fcb 6,-28 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:292|rel:110) dy(abs:36|rel:18)
; node # 95 D(-59,-24)->(-41,-25)
       fcb 2 ; drawmode 
       fcb -23,3 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:329|rel:37) dy(abs:18|rel:-18)
; node # 96 D(-32,1)->(-20,2)
       fcb 2 ; drawmode 
       fcb -25,27 ; starx/y relative to previous node
       fdb -36,-110 ; dx/dy. dx(abs:219|rel:-110) dy(abs:-18|rel:-36)
; node # 97 D(-43,4)->(-32,4)
       fcb 2 ; drawmode 
       fcb -3,-11 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:18)
; node # 98 D(-71,-21)->(-54,-22)
       fcb 2 ; drawmode 
       fcb 25,-28 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:310|rel:109) dy(abs:18|rel:18)
; node # 99 D(-74,-43)->(-58,-46)
       fcb 2 ; drawmode 
       fcb 22,-3 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:292|rel:-18) dy(abs:54|rel:36)
; node # 100 D(-43,-38)->(-35,-39)
       fcb 2 ; drawmode 
       fcb -5,31 ; starx/y relative to previous node
       fdb -36,-146 ; dx/dy. dx(abs:146|rel:-146) dy(abs:18|rel:-36)
; node # 101 D(-34,-41)->(-24,-42)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:182|rel:36) dy(abs:18|rel:0)
; node # 102 D(-39,-46)->(-30,-47)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:18|rel:0)
; node # 103 D(-75,-54)->(-57,-56)
       fcb 2 ; drawmode 
       fcb 8,-36 ; starx/y relative to previous node
       fdb 18,165 ; dx/dy. dx(abs:329|rel:165) dy(abs:36|rel:18)
; node # 104 D(-70,-16)->(-50,-17)
       fcb 2 ; drawmode 
       fcb -38,5 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:365|rel:36) dy(abs:18|rel:-18)
; node # 105 D(-38,14)->(-26,14)
       fcb 2 ; drawmode 
       fcb -30,32 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:219|rel:-146) dy(abs:0|rel:-18)
; node # 106 D(-43,4)->(-33,4)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:0|rel:0)
; node # 107 M(63,0)->(66,0)
       fcb 0 ; drawmode 
       fcb 4,106 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:54|rel:-128) dy(abs:0|rel:0)
; node # 108 D(59,3)->(55,2)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:18|rel:18)
; node # 109 M(33,6)->(33,6)
       fcb 0 ; drawmode 
       fcb -3,-26 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:0|rel:73) dy(abs:0|rel:-18)
; node # 110 M(-74,-43)->(-58,-46)
       fcb 0 ; drawmode 
       fcb 49,-107 ; starx/y relative to previous node
       fdb 54,292 ; dx/dy. dx(abs:292|rel:292) dy(abs:54|rel:54)
; node # 111 D(-75,-54)->(-57,-56)
       fcb 2 ; drawmode 
       fcb 11,-1 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:329|rel:37) dy(abs:36|rel:-18)
; node # 112 M(-38,14)->(-26,14)
       fcb 0 ; drawmode 
       fcb -68,37 ; starx/y relative to previous node
       fdb -36,-110 ; dx/dy. dx(abs:219|rel:-110) dy(abs:0|rel:-36)
; node # 113 D(-32,1)->(-20,2)
       fcb 2 ; drawmode 
       fcb 13,6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:-18|rel:-18)
; node # 114 M(-59,-24)->(-41,-25)
       fcb 0 ; drawmode 
       fcb 25,-27 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:329|rel:110) dy(abs:18|rel:36)
; node # 115 D(-70,-16)->(-50,-17)
       fcb 2 ; drawmode 
       fcb -8,-11 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:365|rel:36) dy(abs:18|rel:0)
; node # 116 D(-71,-21)->(-54,-22)
       fcb 2 ; drawmode 
       fcb 5,-1 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:310|rel:-55) dy(abs:18|rel:0)
; node # 117 D(-59,-24)->(-41,-25)
       fcb 2 ; drawmode 
       fcb 3,12 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:329|rel:19) dy(abs:18|rel:0)
; node # 118 M(-74,-43)->(-58,-46)
       fcb 0 ; drawmode 
       fcb 19,-15 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:292|rel:-37) dy(abs:54|rel:36)
; node # 119 D(-62,-47)->(-46,-49)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:292|rel:0) dy(abs:36|rel:-18)
; node # 120 M(-62,-47)->(-46,-49)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:292|rel:0) dy(abs:36|rel:0)
; node # 121 D(-75,-54)->(-57,-56)
       fcb 2 ; drawmode 
       fcb 7,-13 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:329|rel:37) dy(abs:36|rel:0)
; node # 122 M(-43,-38)->(-35,-39)
       fcb 0 ; drawmode 
       fcb -16,32 ; starx/y relative to previous node
       fdb -18,-183 ; dx/dy. dx(abs:146|rel:-183) dy(abs:18|rel:-18)
; node # 123 D(-39,-46)->(-30,-47)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:164|rel:18) dy(abs:18|rel:0)
       fcb  1  ; end of anim
; Animation 12
teapotframe12:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(54,2)->(48,2)
       fcb 0 ; drawmode 
       fcb -2,54 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:0|rel:0)
; node # 1 D(19,9)->(10,8)
       fcb 2 ; drawmode 
       fcb -7,-35 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:-153|rel:-51) dy(abs:17|rel:17)
; node # 2 D(18,28)->(11,28)
       fcb 2 ; drawmode 
       fcb -19,-1 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:-17)
; node # 3 D(45,25)->(40,25)
       fcb 2 ; drawmode 
       fcb 3,27 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:0|rel:0)
; node # 4 D(55,1)->(48,3)
       fcb 2 ; drawmode 
       fcb 24,10 ; starx/y relative to previous node
       fdb -34,-34 ; dx/dy. dx(abs:-119|rel:-34) dy(abs:-34|rel:-34)
; node # 5 D(49,-17)->(43,-17)
       fcb 2 ; drawmode 
       fcb 18,-6 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:0|rel:34)
; node # 6 D(15,-9)->(6,-9)
       fcb 2 ; drawmode 
       fcb -8,-34 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-153|rel:-51) dy(abs:0|rel:0)
; node # 7 D(7,-42)->(0,-42)
       fcb 2 ; drawmode 
       fcb 33,-8 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
; node # 8 D(-25,-37)->(-32,-38)
       fcb 2 ; drawmode 
       fcb -5,-32 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:17|rel:17)
; node # 9 D(-50,-38)->(-55,-39)
       fcb 2 ; drawmode 
       fcb 1,-25 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:17|rel:0)
; node # 10 D(-55,0)->(-59,0)
       fcb 2 ; drawmode 
       fcb -38,-5 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-68|rel:17) dy(abs:0|rel:-17)
; node # 11 D(-54,20)->(-58,21)
       fcb 2 ; drawmode 
       fcb -20,1 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-68|rel:0) dy(abs:-17|rel:-17)
; node # 12 D(-37,39)->(-39,40)
       fcb 2 ; drawmode 
       fcb -19,17 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-34|rel:34) dy(abs:-17|rel:0)
; node # 13 D(-41,42)->(-38,43)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:51|rel:85) dy(abs:-17|rel:0)
; node # 14 D(-64,21)->(-60,21)
       fcb 2 ; drawmode 
       fcb 21,-23 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:68|rel:17) dy(abs:0|rel:17)
; node # 15 D(-64,-4)->(-61,-4)
       fcb 2 ; drawmode 
       fcb 25,0 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:51|rel:-17) dy(abs:0|rel:0)
; node # 16 D(-55,0)->(-59,0)
       fcb 2 ; drawmode 
       fcb -4,9 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-68|rel:-119) dy(abs:0|rel:0)
; node # 17 D(-23,-3)->(-32,-3)
       fcb 2 ; drawmode 
       fcb 3,32 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-153|rel:-85) dy(abs:0|rel:0)
; node # 18 D(-25,-37)->(-32,-38)
       fcb 2 ; drawmode 
       fcb 34,-2 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:17|rel:17)
; node # 19 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 18,15 ; starx/y relative to previous node
       fdb -17,119 ; dx/dy. dx(abs:0|rel:119) dy(abs:0|rel:-17)
; node # 20 D(-50,-38)->(-55,-39)
       fcb 2 ; drawmode 
       fcb -17,-40 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-85|rel:-85) dy(abs:17|rel:17)
; node # 21 D(-58,-46)->(-55,-48)
       fcb 2 ; drawmode 
       fcb 8,-8 ; starx/y relative to previous node
       fdb 17,136 ; dx/dy. dx(abs:51|rel:136) dy(abs:34|rel:17)
; node # 22 D(-64,-4)->(-61,-4)
       fcb 2 ; drawmode 
       fcb -42,-6 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:0|rel:-34)
; node # 23 D(-29,-14)->(-16,-15)
       fcb 2 ; drawmode 
       fcb 10,35 ; starx/y relative to previous node
       fdb 17,170 ; dx/dy. dx(abs:221|rel:170) dy(abs:17|rel:17)
; node # 24 D(-26,14)->(-12,14)
       fcb 2 ; drawmode 
       fcb -28,3 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:238|rel:17) dy(abs:0|rel:-17)
; node # 25 D(-64,21)->(-59,21)
       fcb 2 ; drawmode 
       fcb -7,-38 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:85|rel:-153) dy(abs:0|rel:0)
; node # 26 D(-54,20)->(-58,21)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb -17,-153 ; dx/dy. dx(abs:-68|rel:-153) dy(abs:-17|rel:-17)
; node # 27 D(-21,16)->(-29,15)
       fcb 2 ; drawmode 
       fcb 4,33 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:-136|rel:-68) dy(abs:17|rel:34)
; node # 28 D(-23,-3)->(-32,-3)
       fcb 2 ; drawmode 
       fcb 19,-2 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:-17)
; node # 29 D(15,-9)->(6,-9)
       fcb 2 ; drawmode 
       fcb 6,38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 30 D(19,9)->(10,8)
       fcb 2 ; drawmode 
       fcb -18,4 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:17|rel:17)
; node # 31 D(-21,16)->(-29,15)
       fcb 2 ; drawmode 
       fcb -7,-40 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:17|rel:0)
; node # 32 D(-13,33)->(-19,34)
       fcb 2 ; drawmode 
       fcb -17,8 ; starx/y relative to previous node
       fdb -34,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:-17|rel:-34)
; node # 33 D(18,28)->(11,28)
       fcb 2 ; drawmode 
       fcb 5,31 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:0|rel:17)
; node # 34 M(-37,39)->(-39,40)
       fcb 0 ; drawmode 
       fcb -11,-55 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:-34|rel:85) dy(abs:-17|rel:-17)
; node # 35 D(-12,33)->(-19,34)
       fcb 2 ; drawmode 
       fcb 6,25 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-119|rel:-85) dy(abs:-17|rel:0)
; node # 36 M(19,9)->(10,8)
       fcb 0 ; drawmode 
       fcb 24,31 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:17|rel:34)
; node # 37 D(19,-15)->(10,-14)
       fcb 2 ; drawmode 
       fcb 24,0 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:-17|rel:-34)
; node # 38 D(22,-29)->(11,-30)
       fcb 2 ; drawmode 
       fcb 14,3 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:-187|rel:-34) dy(abs:17|rel:34)
; node # 39 D(15,-28)->(2,-28)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-221|rel:-34) dy(abs:0|rel:-17)
; node # 40 D(9,-12)->(1,-12)
       fcb 2 ; drawmode 
       fcb -16,-6 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-136|rel:85) dy(abs:0|rel:0)
; node # 41 D(19,9)->(10,8)
       fcb 2 ; drawmode 
       fcb -21,10 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:17|rel:17)
; node # 42 D(18,-13)->(8,-13)
       fcb 2 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-170|rel:-17) dy(abs:0|rel:-17)
; node # 43 D(9,-12)->(1,-12)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-136|rel:34) dy(abs:0|rel:0)
; node # 44 M(22,-30)->(8,-28)
       fcb 0 ; drawmode 
       fcb 18,13 ; starx/y relative to previous node
       fdb -34,-102 ; dx/dy. dx(abs:-238|rel:-102) dy(abs:-34|rel:-34)
; node # 45 D(15,-28)->(2,-28)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:-221|rel:17) dy(abs:0|rel:34)
; node # 46 M(22,-29)->(11,-30)
       fcb 0 ; drawmode 
       fcb 1,7 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-187|rel:34) dy(abs:17|rel:17)
; node # 47 D(22,-30)->(8,-28)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb -51,-51 ; dx/dy. dx(abs:-238|rel:-51) dy(abs:-34|rel:-51)
; node # 48 D(18,-13)->(8,-13)
       fcb 2 ; drawmode 
       fcb -17,-4 ; starx/y relative to previous node
       fdb 34,68 ; dx/dy. dx(abs:-170|rel:68) dy(abs:0|rel:34)
; node # 49 M(7,-42)->(0,-42)
       fcb 0 ; drawmode 
       fcb 29,-11 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-119|rel:51) dy(abs:0|rel:0)
; node # 50 D(33,-51)->(28,-51)
       fcb 2 ; drawmode 
       fcb 9,26 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:0|rel:0)
; node # 51 D(49,-17)->(43,-17)
       fcb 2 ; drawmode 
       fcb -34,16 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-102|rel:-17) dy(abs:0|rel:0)
; node # 52 D(59,-23)->(59,-23)
       fcb 2 ; drawmode 
       fcb 6,10 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:0)
; node # 53 D(40,-61)->(40,-60)
       fcb 2 ; drawmode 
       fcb 38,-19 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-17|rel:-17)
; node # 54 D(33,-51)->(28,-51)
       fcb 2 ; drawmode 
       fcb -10,-7 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-85|rel:-85) dy(abs:0|rel:17)
; node # 55 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 4,-43 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:0|rel:85) dy(abs:0|rel:0)
; node # 56 D(-8,-65)->(-7,-65)
       fcb 2 ; drawmode 
       fcb 10,2 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:0|rel:0)
; node # 57 D(-3,-63)->(-5,-62)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:-34|rel:-51) dy(abs:-17|rel:-17)
; node # 58 D(-13,-61)->(-13,-61)
       fcb 2 ; drawmode 
       fcb -2,-10 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:0|rel:34) dy(abs:0|rel:17)
; node # 59 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(40,-61)->(40,-60)
       fcb 2 ; drawmode 
       fcb 6,50 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-17|rel:-17)
; node # 61 D(14,-66)->(22,-65)
       fcb 2 ; drawmode 
       fcb 5,-26 ; starx/y relative to previous node
       fdb 0,136 ; dx/dy. dx(abs:136|rel:136) dy(abs:-17|rel:0)
; node # 62 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -11,-24 ; starx/y relative to previous node
       fdb 17,-136 ; dx/dy. dx(abs:0|rel:-136) dy(abs:0|rel:17)
; node # 63 D(-58,-46)->(-55,-48)
       fcb 2 ; drawmode 
       fcb -9,-48 ; starx/y relative to previous node
       fdb 34,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:34|rel:34)
; node # 64 D(-31,-59)->(-21,-60)
       fcb 2 ; drawmode 
       fcb 13,27 ; starx/y relative to previous node
       fdb -17,119 ; dx/dy. dx(abs:170|rel:119) dy(abs:17|rel:-17)
; node # 65 D(-29,-14)->(-16,-15)
       fcb 2 ; drawmode 
       fcb -45,2 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:221|rel:51) dy(abs:17|rel:0)
; node # 66 D(29,-24)->(40,-23)
       fcb 2 ; drawmode 
       fcb 10,58 ; starx/y relative to previous node
       fdb -34,-34 ; dx/dy. dx(abs:187|rel:-34) dy(abs:-17|rel:-34)
; node # 67 D(36,4)->(48,3)
       fcb 2 ; drawmode 
       fcb -28,7 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:204|rel:17) dy(abs:17|rel:34)
; node # 68 D(-26,14)->(-12,14)
       fcb 2 ; drawmode 
       fcb -10,-62 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:238|rel:34) dy(abs:0|rel:-17)
; node # 69 D(-13,39)->(-3,40)
       fcb 2 ; drawmode 
       fcb -25,13 ; starx/y relative to previous node
       fdb -17,-68 ; dx/dy. dx(abs:170|rel:-68) dy(abs:-17|rel:-17)
; node # 70 D(30,32)->(38,31)
       fcb 2 ; drawmode 
       fcb 7,43 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:136|rel:-34) dy(abs:17|rel:34)
; node # 71 D(36,4)->(48,3)
       fcb 2 ; drawmode 
       fcb 28,6 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:204|rel:68) dy(abs:17|rel:0)
; node # 72 D(66,0)->(67,0)
       fcb 2 ; drawmode 
       fcb 4,30 ; starx/y relative to previous node
       fdb -17,-187 ; dx/dy. dx(abs:17|rel:-187) dy(abs:0|rel:-17)
; node # 73 D(53,26)->(53,26)
       fcb 2 ; drawmode 
       fcb -26,-13 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:0|rel:0)
; node # 74 D(45,25)->(40,25)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-85|rel:-85) dy(abs:0|rel:0)
; node # 75 M(-13,39)->(-3,40)
       fcb 0 ; drawmode 
       fcb -14,-58 ; starx/y relative to previous node
       fdb -17,255 ; dx/dy. dx(abs:170|rel:255) dy(abs:-17|rel:-17)
; node # 76 D(-41,42)->(-38,43)
       fcb 2 ; drawmode 
       fcb -3,-28 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:51|rel:-119) dy(abs:-17|rel:0)
; node # 77 M(53,26)->(53,26)
       fcb 0 ; drawmode 
       fcb 16,94 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:0|rel:17)
; node # 78 D(30,32)->(38,31)
       fcb 2 ; drawmode 
       fcb -6,-23 ; starx/y relative to previous node
       fdb 17,136 ; dx/dy. dx(abs:136|rel:136) dy(abs:17|rel:17)
; node # 79 M(66,0)->(67,0)
       fcb 0 ; drawmode 
       fcb 32,36 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:17|rel:-119) dy(abs:0|rel:-17)
; node # 80 D(59,-23)->(59,-23)
       fcb 2 ; drawmode 
       fcb 23,-7 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:0|rel:0)
; node # 81 D(29,-24)->(40,-23)
       fcb 2 ; drawmode 
       fcb 1,-30 ; starx/y relative to previous node
       fdb -17,187 ; dx/dy. dx(abs:187|rel:187) dy(abs:-17|rel:-17)
; node # 82 D(14,-66)->(22,-65)
       fcb 2 ; drawmode 
       fcb 42,-15 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:136|rel:-51) dy(abs:-17|rel:0)
; node # 83 D(-31,-59)->(-21,-60)
       fcb 2 ; drawmode 
       fcb -7,-45 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:170|rel:34) dy(abs:17|rel:34)
; node # 84 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -4,21 ; starx/y relative to previous node
       fdb -17,-170 ; dx/dy. dx(abs:0|rel:-170) dy(abs:0|rel:-17)
; node # 85 M(-8,-65)->(-7,-65)
       fcb 0 ; drawmode 
       fcb 10,2 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:0|rel:0)
; node # 86 D(-18,-63)->(-18,-64)
       fcb 2 ; drawmode 
       fcb -2,-10 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:17|rel:17)
; node # 87 D(-13,-61)->(-13,-61)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-17)
; node # 88 M(-3,-63)->(-5,-62)
       fcb 0 ; drawmode 
       fcb 2,10 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-34|rel:-34) dy(abs:-17|rel:-17)
; node # 89 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -8,-7 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:0|rel:34) dy(abs:0|rel:17)
; node # 90 D(7,-42)->(0,-42)
       fcb 2 ; drawmode 
       fcb -13,17 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-119|rel:-119) dy(abs:0|rel:0)
; node # 91 M(-18,-63)->(-18,-64)
       fcb 0 ; drawmode 
       fcb 21,-25 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:0|rel:119) dy(abs:17|rel:17)
; node # 92 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -8,8 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-17)
; node # 93 M(-24,-42)->(-12,-42)
       fcb 0 ; drawmode 
       fcb -13,-14 ; starx/y relative to previous node
       fdb 0,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:0|rel:0)
; node # 94 D(-46,-49)->(-23,-50)
       fcb 2 ; drawmode 
       fcb 7,-22 ; starx/y relative to previous node
       fdb 17,188 ; dx/dy. dx(abs:392|rel:188) dy(abs:17|rel:17)
; node # 95 D(-41,-25)->(-19,-26)
       fcb 2 ; drawmode 
       fcb -24,5 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:375|rel:-17) dy(abs:17|rel:0)
; node # 96 D(-20,2)->(-6,2)
       fcb 2 ; drawmode 
       fcb -27,21 ; starx/y relative to previous node
       fdb -17,-137 ; dx/dy. dx(abs:238|rel:-137) dy(abs:0|rel:-17)
; node # 97 D(-32,4)->(-20,4)
       fcb 2 ; drawmode 
       fcb -2,-12 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:204|rel:-34) dy(abs:0|rel:0)
; node # 98 D(-54,-22)->(-35,-23)
       fcb 2 ; drawmode 
       fcb 26,-22 ; starx/y relative to previous node
       fdb 17,120 ; dx/dy. dx(abs:324|rel:120) dy(abs:17|rel:17)
; node # 99 D(-58,-46)->(-39,-47)
       fcb 2 ; drawmode 
       fcb 24,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:324|rel:0) dy(abs:17|rel:0)
; node # 100 D(-35,-39)->(-26,-40)
       fcb 2 ; drawmode 
       fcb -7,23 ; starx/y relative to previous node
       fdb 0,-171 ; dx/dy. dx(abs:153|rel:-171) dy(abs:17|rel:0)
; node # 101 D(-24,-42)->(-12,-42)
       fcb 2 ; drawmode 
       fcb 3,11 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:204|rel:51) dy(abs:0|rel:-17)
; node # 102 D(-30,-47)->(-23,-50)
       fcb 2 ; drawmode 
       fcb 5,-6 ; starx/y relative to previous node
       fdb 51,-85 ; dx/dy. dx(abs:119|rel:-85) dy(abs:51|rel:51)
; node # 103 D(-57,-56)->(-35,-57)
       fcb 2 ; drawmode 
       fcb 9,-27 ; starx/y relative to previous node
       fdb -34,256 ; dx/dy. dx(abs:375|rel:256) dy(abs:17|rel:-34)
; node # 104 D(-50,-17)->(-27,-17)
       fcb 2 ; drawmode 
       fcb -39,7 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:392|rel:17) dy(abs:0|rel:-17)
; node # 105 D(-26,14)->(-12,14)
       fcb 2 ; drawmode 
       fcb -31,24 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:238|rel:-154) dy(abs:0|rel:0)
; node # 106 D(-33,4)->(-20,4)
       fcb 2 ; drawmode 
       fcb 10,-7 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:221|rel:-17) dy(abs:0|rel:0)
; node # 107 M(66,0)->(67,0)
       fcb 0 ; drawmode 
       fcb 4,99 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:17|rel:-204) dy(abs:0|rel:0)
; node # 108 D(54,2)->(48,2)
       fcb 2 ; drawmode 
       fcb -2,-12 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-102|rel:-119) dy(abs:0|rel:0)
; node # 109 M(33,6)->(33,6)
       fcb 0 ; drawmode 
       fcb -4,-21 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:0)
; node # 110 M(-58,-46)->(-39,-47)
       fcb 0 ; drawmode 
       fcb 52,-91 ; starx/y relative to previous node
       fdb 17,324 ; dx/dy. dx(abs:324|rel:324) dy(abs:17|rel:17)
; node # 111 D(-57,-56)->(-35,-57)
       fcb 2 ; drawmode 
       fcb 10,1 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:375|rel:51) dy(abs:17|rel:0)
; node # 112 M(-26,14)->(-12,14)
       fcb 0 ; drawmode 
       fcb -70,31 ; starx/y relative to previous node
       fdb -17,-137 ; dx/dy. dx(abs:238|rel:-137) dy(abs:0|rel:-17)
; node # 113 D(-20,2)->(-6,2)
       fcb 2 ; drawmode 
       fcb 12,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:238|rel:0) dy(abs:0|rel:0)
; node # 114 M(-41,-25)->(-19,-26)
       fcb 0 ; drawmode 
       fcb 27,-21 ; starx/y relative to previous node
       fdb 17,137 ; dx/dy. dx(abs:375|rel:137) dy(abs:17|rel:17)
; node # 115 D(-50,-17)->(-27,-17)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:392|rel:17) dy(abs:0|rel:-17)
; node # 116 D(-54,-22)->(-35,-23)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 17,-68 ; dx/dy. dx(abs:324|rel:-68) dy(abs:17|rel:17)
; node # 117 D(-41,-25)->(-19,-26)
       fcb 2 ; drawmode 
       fcb 3,13 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:375|rel:51) dy(abs:17|rel:0)
; node # 118 M(-58,-46)->(-39,-47)
       fcb 0 ; drawmode 
       fcb 21,-17 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:324|rel:-51) dy(abs:17|rel:0)
; node # 119 D(-46,-49)->(-23,-50)
       fcb 2 ; drawmode 
       fcb 3,12 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:392|rel:68) dy(abs:17|rel:0)
; node # 120 M(-46,-49)->(-23,-50)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:392|rel:0) dy(abs:17|rel:0)
; node # 121 D(-57,-56)->(-35,-57)
       fcb 2 ; drawmode 
       fcb 7,-11 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:375|rel:-17) dy(abs:17|rel:0)
; node # 122 M(-35,-39)->(-26,-40)
       fcb 0 ; drawmode 
       fcb -17,22 ; starx/y relative to previous node
       fdb 0,-222 ; dx/dy. dx(abs:153|rel:-222) dy(abs:17|rel:0)
; node # 123 D(-30,-47)->(-23,-50)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:119|rel:-34) dy(abs:51|rel:34)
       fcb  1  ; end of anim
; Animation 13
teapotframe13:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(48,2)->(40,2)
       fcb 0 ; drawmode 
       fcb -2,48 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:0)
; node # 1 D(10,8)->(1,9)
       fcb 2 ; drawmode 
       fcb -6,-38 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:-18|rel:-18)
; node # 2 D(11,28)->(4,28)
       fcb 2 ; drawmode 
       fcb -20,1 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:18)
; node # 3 D(40,25)->(34,23)
       fcb 2 ; drawmode 
       fcb 3,29 ; starx/y relative to previous node
       fdb 36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:36|rel:36)
; node # 4 D(48,2)->(40,2)
       fcb 2 ; drawmode 
       fcb 23,8 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-36)
; node # 5 D(43,-17)->(35,-16)
       fcb 2 ; drawmode 
       fcb 19,-5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-18|rel:-18)
; node # 6 D(6,-9)->(-1,-9)
       fcb 2 ; drawmode 
       fcb -8,-37 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:18)
; node # 7 D(0,-42)->(-7,-42)
       fcb 2 ; drawmode 
       fcb 33,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 8 D(-32,-38)->(-39,-38)
       fcb 2 ; drawmode 
       fcb -4,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 9 D(-55,-39)->(-58,-41)
       fcb 2 ; drawmode 
       fcb 1,-23 ; starx/y relative to previous node
       fdb 36,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:36|rel:36)
; node # 10 D(-59,0)->(-63,0)
       fcb 2 ; drawmode 
       fcb -39,-4 ; starx/y relative to previous node
       fdb -36,-19 ; dx/dy. dx(abs:-73|rel:-19) dy(abs:0|rel:-36)
; node # 11 D(-58,21)->(-61,22)
       fcb 2 ; drawmode 
       fcb -21,1 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:-18|rel:-18)
; node # 12 D(-39,40)->(-41,41)
       fcb 2 ; drawmode 
       fcb -19,19 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:-18|rel:0)
; node # 13 D(-38,43)->(-32,44)
       fcb 2 ; drawmode 
       fcb -3,1 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:109|rel:145) dy(abs:-18|rel:0)
; node # 14 D(-60,21)->(-52,23)
       fcb 2 ; drawmode 
       fcb 22,-22 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:-36|rel:-18)
; node # 15 D(-61,-4)->(-55,-4)
       fcb 2 ; drawmode 
       fcb 25,-1 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:0|rel:36)
; node # 16 D(-59,0)->(-63,0)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-73|rel:-182) dy(abs:0|rel:0)
; node # 17 D(-32,-3)->(-40,-3)
       fcb 2 ; drawmode 
       fcb 3,27 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:0|rel:0)
; node # 18 D(-32,-38)->(-39,-38)
       fcb 2 ; drawmode 
       fcb 35,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 19 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 17,22 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 20 D(-55,-39)->(-58,-41)
       fcb 2 ; drawmode 
       fcb -16,-45 ; starx/y relative to previous node
       fdb 36,-54 ; dx/dy. dx(abs:-54|rel:-54) dy(abs:36|rel:36)
; node # 21 D(-55,-48)->(-51,-50)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:73|rel:127) dy(abs:36|rel:0)
; node # 22 D(-61,-4)->(-55,-4)
       fcb 2 ; drawmode 
       fcb -44,-6 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:109|rel:36) dy(abs:0|rel:-36)
; node # 23 D(-16,-15)->(-2,-14)
       fcb 2 ; drawmode 
       fcb 11,45 ; starx/y relative to previous node
       fdb -18,147 ; dx/dy. dx(abs:256|rel:147) dy(abs:-18|rel:-18)
; node # 24 D(-12,14)->(2,14)
       fcb 2 ; drawmode 
       fcb -29,4 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:0|rel:18)
; node # 25 D(-59,21)->(-52,23)
       fcb 2 ; drawmode 
       fcb -7,-47 ; starx/y relative to previous node
       fdb -36,-128 ; dx/dy. dx(abs:128|rel:-128) dy(abs:-36|rel:-36)
; node # 26 D(-58,21)->(-61,22)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:-54|rel:-182) dy(abs:-18|rel:18)
; node # 27 D(-29,15)->(-38,16)
       fcb 2 ; drawmode 
       fcb 6,29 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-164|rel:-110) dy(abs:-18|rel:0)
; node # 28 D(-32,-3)->(-40,-3)
       fcb 2 ; drawmode 
       fcb 18,-3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:18)
; node # 29 D(6,-9)->(-1,-9)
       fcb 2 ; drawmode 
       fcb 6,38 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 30 D(10,8)->(1,9)
       fcb 2 ; drawmode 
       fcb -17,4 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:-18)
; node # 31 D(-29,15)->(-38,16)
       fcb 2 ; drawmode 
       fcb -7,-39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:0)
; node # 32 D(-19,34)->(-25,35)
       fcb 2 ; drawmode 
       fcb -19,10 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:-18|rel:0)
; node # 33 D(11,28)->(4,28)
       fcb 2 ; drawmode 
       fcb 6,30 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:18)
; node # 34 M(-39,40)->(-41,41)
       fcb 0 ; drawmode 
       fcb -12,-50 ; starx/y relative to previous node
       fdb -18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:-18|rel:-18)
; node # 35 D(-19,34)->(-25,35)
       fcb 2 ; drawmode 
       fcb 6,20 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:-18|rel:0)
; node # 36 M(10,8)->(1,9)
       fcb 0 ; drawmode 
       fcb 26,29 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-18|rel:0)
; node # 37 D(10,-14)->(-2,-14)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:0|rel:18)
; node # 38 D(11,-30)->(-4,-28)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-274|rel:-55) dy(abs:-36|rel:-36)
; node # 39 D(2,-28)->(-9,-28)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb 36,73 ; dx/dy. dx(abs:-201|rel:73) dy(abs:0|rel:36)
; node # 40 D(1,-12)->(-7,-12)
       fcb 2 ; drawmode 
       fcb -16,-1 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-146|rel:55) dy(abs:0|rel:0)
; node # 41 D(10,8)->(1,9)
       fcb 2 ; drawmode 
       fcb -20,9 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:-18|rel:-18)
; node # 42 D(8,-13)->(2,-14)
       fcb 2 ; drawmode 
       fcb 21,-2 ; starx/y relative to previous node
       fdb 36,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:18|rel:36)
; node # 43 D(1,-12)->(-7,-12)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-18)
; node # 44 M(8,-28)->(-1,-30)
       fcb 0 ; drawmode 
       fcb 16,7 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:36|rel:36)
; node # 45 D(2,-28)->(-9,-28)
       fcb 2 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:0|rel:-36)
; node # 46 M(11,-30)->(-4,-28)
       fcb 0 ; drawmode 
       fcb 2,9 ; starx/y relative to previous node
       fdb -36,-73 ; dx/dy. dx(abs:-274|rel:-73) dy(abs:-36|rel:-36)
; node # 47 D(8,-28)->(-1,-30)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 72,110 ; dx/dy. dx(abs:-164|rel:110) dy(abs:36|rel:72)
; node # 48 D(8,-13)->(2,-14)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:18|rel:-18)
; node # 49 M(0,-42)->(-7,-42)
       fcb 0 ; drawmode 
       fcb 29,-8 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:-18)
; node # 50 D(28,-51)->(23,-50)
       fcb 2 ; drawmode 
       fcb 9,28 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:-18|rel:-18)
; node # 51 D(43,-17)->(35,-16)
       fcb 2 ; drawmode 
       fcb -34,15 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:-18|rel:0)
; node # 52 D(59,-23)->(58,-22)
       fcb 2 ; drawmode 
       fcb 6,16 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-18|rel:128) dy(abs:-18|rel:0)
; node # 53 D(40,-60)->(41,-58)
       fcb 2 ; drawmode 
       fcb 37,-19 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:-36|rel:-18)
; node # 54 D(28,-51)->(23,-50)
       fcb 2 ; drawmode 
       fcb -9,-12 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-91|rel:-109) dy(abs:-18|rel:18)
; node # 55 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 4,-38 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:0|rel:18)
; node # 56 D(-7,-65)->(-6,-66)
       fcb 2 ; drawmode 
       fcb 10,3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 57 D(-5,-62)->(-6,-63)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:18|rel:0)
; node # 58 D(-13,-61)->(-15,-62)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:18|rel:0)
; node # 59 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:-18)
; node # 60 D(40,-60)->(41,-58)
       fcb 2 ; drawmode 
       fcb 5,50 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-36|rel:-36)
; node # 61 D(22,-65)->(30,-65)
       fcb 2 ; drawmode 
       fcb 5,-18 ; starx/y relative to previous node
       fdb 36,128 ; dx/dy. dx(abs:146|rel:128) dy(abs:0|rel:36)
; node # 62 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -10,-32 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:0|rel:-146) dy(abs:0|rel:0)
; node # 63 D(-55,-48)->(-51,-50)
       fcb 2 ; drawmode 
       fcb -7,-45 ; starx/y relative to previous node
       fdb 36,73 ; dx/dy. dx(abs:73|rel:73) dy(abs:36|rel:36)
; node # 64 D(-21,-60)->(-11,-61)
       fcb 2 ; drawmode 
       fcb 12,34 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:182|rel:109) dy(abs:18|rel:-18)
; node # 65 D(-16,-15)->(-2,-14)
       fcb 2 ; drawmode 
       fcb -45,5 ; starx/y relative to previous node
       fdb -36,74 ; dx/dy. dx(abs:256|rel:74) dy(abs:-18|rel:-36)
; node # 66 D(40,-23)->(49,-23)
       fcb 2 ; drawmode 
       fcb 8,56 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:164|rel:-92) dy(abs:0|rel:18)
; node # 67 D(48,3)->(56,3)
       fcb 2 ; drawmode 
       fcb -26,8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:146|rel:-18) dy(abs:0|rel:0)
; node # 68 D(-12,14)->(2,14)
       fcb 2 ; drawmode 
       fcb -11,-60 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:256|rel:110) dy(abs:0|rel:0)
; node # 69 D(-3,40)->(6,40)
       fcb 2 ; drawmode 
       fcb -26,9 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:164|rel:-92) dy(abs:0|rel:0)
; node # 70 D(38,31)->(44,31)
       fcb 2 ; drawmode 
       fcb 9,41 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:0|rel:0)
; node # 71 D(48,3)->(56,3)
       fcb 2 ; drawmode 
       fcb 28,10 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:0|rel:0)
; node # 72 D(67,0)->(65,0)
       fcb 2 ; drawmode 
       fcb 3,19 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-36|rel:-182) dy(abs:0|rel:0)
; node # 73 D(53,26)->(52,24)
       fcb 2 ; drawmode 
       fcb -26,-14 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:36|rel:36)
; node # 74 D(40,25)->(34,23)
       fcb 2 ; drawmode 
       fcb 1,-13 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:36|rel:0)
; node # 75 M(-3,40)->(6,40)
       fcb 0 ; drawmode 
       fcb -15,-43 ; starx/y relative to previous node
       fdb -36,273 ; dx/dy. dx(abs:164|rel:273) dy(abs:0|rel:-36)
; node # 76 D(-38,43)->(-32,44)
       fcb 2 ; drawmode 
       fcb -3,-35 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:-18|rel:-18)
; node # 77 M(53,26)->(52,24)
       fcb 0 ; drawmode 
       fcb 17,91 ; starx/y relative to previous node
       fdb 54,-127 ; dx/dy. dx(abs:-18|rel:-127) dy(abs:36|rel:54)
; node # 78 D(38,31)->(44,31)
       fcb 2 ; drawmode 
       fcb -5,-15 ; starx/y relative to previous node
       fdb -36,127 ; dx/dy. dx(abs:109|rel:127) dy(abs:0|rel:-36)
; node # 79 M(67,0)->(65,0)
       fcb 0 ; drawmode 
       fcb 31,29 ; starx/y relative to previous node
       fdb 0,-145 ; dx/dy. dx(abs:-36|rel:-145) dy(abs:0|rel:0)
; node # 80 D(59,-23)->(58,-22)
       fcb 2 ; drawmode 
       fcb 23,-8 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-18|rel:-18)
; node # 81 D(40,-23)->(49,-23)
       fcb 2 ; drawmode 
       fcb 0,-19 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:164|rel:182) dy(abs:0|rel:18)
; node # 82 D(22,-65)->(30,-65)
       fcb 2 ; drawmode 
       fcb 42,-18 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:146|rel:-18) dy(abs:0|rel:0)
; node # 83 D(-21,-60)->(-11,-61)
       fcb 2 ; drawmode 
       fcb -5,-43 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:182|rel:36) dy(abs:18|rel:18)
; node # 84 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -5,11 ; starx/y relative to previous node
       fdb -18,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:0|rel:-18)
; node # 85 M(-7,-65)->(-6,-66)
       fcb 0 ; drawmode 
       fcb 10,3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 86 D(-18,-64)->(-18,-64)
       fcb 2 ; drawmode 
       fcb -1,-11 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:-18)
; node # 87 D(-13,-61)->(-15,-62)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:18)
; node # 88 M(-5,-62)->(-6,-63)
       fcb 0 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:0)
; node # 89 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:-18)
; node # 90 D(0,-42)->(-7,-42)
       fcb 2 ; drawmode 
       fcb -13,10 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 91 M(-18,-64)->(-18,-64)
       fcb 0 ; drawmode 
       fcb 22,-18 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 92 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -9,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 M(-12,-42)->(0,-42)
       fcb 0 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 0,219 ; dx/dy. dx(abs:219|rel:219) dy(abs:0|rel:0)
; node # 94 D(-23,-50)->(0,-50)
       fcb 2 ; drawmode 
       fcb 8,-11 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:420|rel:201) dy(abs:0|rel:0)
; node # 95 D(-19,-26)->(4,-26)
       fcb 2 ; drawmode 
       fcb -24,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:420|rel:0) dy(abs:0|rel:0)
; node # 96 D(-6,2)->(7,2)
       fcb 2 ; drawmode 
       fcb -28,13 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:237|rel:-183) dy(abs:0|rel:0)
; node # 97 D(-20,4)->(-7,4)
       fcb 2 ; drawmode 
       fcb -2,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:237|rel:0) dy(abs:0|rel:0)
; node # 98 D(-35,-23)->(-12,-23)
       fcb 2 ; drawmode 
       fcb 27,-15 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:420|rel:183) dy(abs:0|rel:0)
; node # 99 D(-39,-47)->(-17,-48)
       fcb 2 ; drawmode 
       fcb 24,-4 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:402|rel:-18) dy(abs:18|rel:18)
; node # 100 D(-26,-40)->(-14,-40)
       fcb 2 ; drawmode 
       fcb -7,13 ; starx/y relative to previous node
       fdb -18,-183 ; dx/dy. dx(abs:219|rel:-183) dy(abs:0|rel:-18)
; node # 101 D(-12,-42)->(0,-42)
       fcb 2 ; drawmode 
       fcb 2,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:0|rel:0)
; node # 102 D(-23,-50)->(-8,-49)
       fcb 2 ; drawmode 
       fcb 8,-11 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:274|rel:55) dy(abs:-18|rel:-18)
; node # 103 D(-35,-57)->(-10,-58)
       fcb 2 ; drawmode 
       fcb 7,-12 ; starx/y relative to previous node
       fdb 36,183 ; dx/dy. dx(abs:457|rel:183) dy(abs:18|rel:36)
; node # 104 D(-27,-17)->(-3,-17)
       fcb 2 ; drawmode 
       fcb -40,8 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:438|rel:-19) dy(abs:0|rel:-18)
; node # 105 D(-12,14)->(2,14)
       fcb 2 ; drawmode 
       fcb -31,15 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:256|rel:-182) dy(abs:0|rel:0)
; node # 106 D(-20,4)->(-7,4)
       fcb 2 ; drawmode 
       fcb 10,-8 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:237|rel:-19) dy(abs:0|rel:0)
; node # 107 M(67,0)->(65,0)
       fcb 0 ; drawmode 
       fcb 4,87 ; starx/y relative to previous node
       fdb 0,-273 ; dx/dy. dx(abs:-36|rel:-273) dy(abs:0|rel:0)
; node # 108 D(48,2)->(40,2)
       fcb 2 ; drawmode 
       fcb -2,-19 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-146|rel:-110) dy(abs:0|rel:0)
; node # 109 M(33,6)->(32,3)
       fcb 0 ; drawmode 
       fcb -4,-15 ; starx/y relative to previous node
       fdb 54,128 ; dx/dy. dx(abs:-18|rel:128) dy(abs:54|rel:54)
; node # 110 M(-35,-57)->(-10,-58)
       fcb 0 ; drawmode 
       fcb 63,-68 ; starx/y relative to previous node
       fdb -36,475 ; dx/dy. dx(abs:457|rel:475) dy(abs:18|rel:-36)
; node # 111 D(-39,-47)->(-17,-48)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:402|rel:-55) dy(abs:18|rel:0)
; node # 112 M(-12,14)->(2,14)
       fcb 0 ; drawmode 
       fcb -61,27 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:256|rel:-146) dy(abs:0|rel:-18)
; node # 113 D(-6,2)->(7,2)
       fcb 2 ; drawmode 
       fcb 12,6 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:237|rel:-19) dy(abs:0|rel:0)
; node # 114 M(-19,-26)->(4,-26)
       fcb 0 ; drawmode 
       fcb 28,-13 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:420|rel:183) dy(abs:0|rel:0)
; node # 115 D(-27,-17)->(-3,-17)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:438|rel:18) dy(abs:0|rel:0)
; node # 116 D(-35,-23)->(-12,-23)
       fcb 2 ; drawmode 
       fcb 6,-8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:420|rel:-18) dy(abs:0|rel:0)
; node # 117 D(-19,-26)->(4,-26)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:420|rel:0) dy(abs:0|rel:0)
; node # 118 M(-39,-47)->(-17,-48)
       fcb 0 ; drawmode 
       fcb 21,-20 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:402|rel:-18) dy(abs:18|rel:18)
; node # 119 D(-23,-50)->(0,-50)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:420|rel:18) dy(abs:0|rel:-18)
; node # 120 M(-23,-50)->(0,-50)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:420|rel:0) dy(abs:0|rel:0)
; node # 121 D(-35,-57)->(-10,-58)
       fcb 2 ; drawmode 
       fcb 7,-12 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:457|rel:37) dy(abs:18|rel:18)
; node # 122 M(-26,-40)->(-14,-40)
       fcb 0 ; drawmode 
       fcb -17,9 ; starx/y relative to previous node
       fdb -18,-238 ; dx/dy. dx(abs:219|rel:-238) dy(abs:0|rel:-18)
; node # 123 D(-23,-50)->(-8,-49)
       fcb 2 ; drawmode 
       fcb 10,3 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:274|rel:55) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
; Animation 14
teapotframe14:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(40,2)->(32,2)
       fcb 0 ; drawmode 
       fcb -2,40 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:0)
; node # 1 D(1,9)->(-8,9)
       fcb 2 ; drawmode 
       fcb -7,-39 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 2 D(4,28)->(-2,28)
       fcb 2 ; drawmode 
       fcb -19,3 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 3 D(34,23)->(29,23)
       fcb 2 ; drawmode 
       fcb 5,30 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:0)
; node # 4 D(40,2)->(32,2)
       fcb 2 ; drawmode 
       fcb 21,6 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:0)
; node # 5 D(35,-16)->(28,-16)
       fcb 2 ; drawmode 
       fcb 18,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 6 D(-1,-9)->(-10,-9)
       fcb 2 ; drawmode 
       fcb -7,-36 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 7 D(-7,-42)->(-15,-42)
       fcb 2 ; drawmode 
       fcb 33,-6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 8 D(-39,-38)->(-45,-40)
       fcb 2 ; drawmode 
       fcb -4,-32 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:36|rel:36)
; node # 9 D(-58,-41)->(-60,-42)
       fcb 2 ; drawmode 
       fcb 3,-19 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:18|rel:-18)
; node # 10 D(-63,0)->(-64,0)
       fcb 2 ; drawmode 
       fcb -41,-5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:-18)
; node # 11 D(-61,22)->(-63,23)
       fcb 2 ; drawmode 
       fcb -22,2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:-18|rel:-18)
; node # 12 D(-41,41)->(-41,42)
       fcb 2 ; drawmode 
       fcb -19,20 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:-18|rel:0)
; node # 13 D(-32,44)->(-25,45)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-18|rel:0)
; node # 14 D(-52,23)->(-43,23)
       fcb 2 ; drawmode 
       fcb 21,-20 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:164|rel:36) dy(abs:0|rel:18)
; node # 15 D(-55,-4)->(-46,-4)
       fcb 2 ; drawmode 
       fcb 27,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:164|rel:0) dy(abs:0|rel:0)
; node # 16 D(-63,0)->(-64,0)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-18|rel:-182) dy(abs:0|rel:0)
; node # 17 D(-40,-3)->(-47,-3)
       fcb 2 ; drawmode 
       fcb 3,23 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:0|rel:0)
; node # 18 D(-39,-38)->(-45,-40)
       fcb 2 ; drawmode 
       fcb 35,1 ; starx/y relative to previous node
       fdb 36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:36|rel:36)
; node # 19 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 17,29 ; starx/y relative to previous node
       fdb -36,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:-36)
; node # 20 D(-58,-41)->(-60,-42)
       fcb 2 ; drawmode 
       fcb -14,-48 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:18)
; node # 21 D(-51,-50)->(-44,-51)
       fcb 2 ; drawmode 
       fcb 9,7 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:18|rel:0)
; node # 22 D(-55,-4)->(-46,-4)
       fcb 2 ; drawmode 
       fcb -46,-4 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:164|rel:36) dy(abs:0|rel:-18)
; node # 23 D(-2,-14)->(11,-14)
       fcb 2 ; drawmode 
       fcb 10,53 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:237|rel:73) dy(abs:0|rel:0)
; node # 24 D(2,14)->(17,14)
       fcb 2 ; drawmode 
       fcb -28,4 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:274|rel:37) dy(abs:0|rel:0)
; node # 25 D(-52,23)->(-43,23)
       fcb 2 ; drawmode 
       fcb -9,-54 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:164|rel:-110) dy(abs:0|rel:0)
; node # 26 D(-61,22)->(-63,23)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb -18,-200 ; dx/dy. dx(abs:-36|rel:-200) dy(abs:-18|rel:-18)
; node # 27 D(-38,16)->(-45,16)
       fcb 2 ; drawmode 
       fcb 6,23 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:0|rel:18)
; node # 28 D(-40,-3)->(-47,-3)
       fcb 2 ; drawmode 
       fcb 19,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 29 D(-1,-9)->(-10,-9)
       fcb 2 ; drawmode 
       fcb 6,39 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 30 D(1,9)->(-8,9)
       fcb 2 ; drawmode 
       fcb -18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 31 D(-38,16)->(-45,16)
       fcb 2 ; drawmode 
       fcb -7,-39 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 32 D(-25,35)->(-30,35)
       fcb 2 ; drawmode 
       fcb -19,13 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:0|rel:0)
; node # 33 D(4,28)->(-2,28)
       fcb 2 ; drawmode 
       fcb 7,29 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:0)
; node # 34 M(-41,41)->(-41,42)
       fcb 0 ; drawmode 
       fcb -13,-45 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:-18|rel:-18)
; node # 35 D(-25,35)->(-30,35)
       fcb 2 ; drawmode 
       fcb 6,16 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-91|rel:-91) dy(abs:0|rel:18)
; node # 36 M(1,9)->(-8,9)
       fcb 0 ; drawmode 
       fcb 26,26 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:0)
; node # 37 D(-2,-14)->(-12,-9)
       fcb 2 ; drawmode 
       fcb 23,-3 ; starx/y relative to previous node
       fdb -91,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:-91|rel:-91)
; node # 38 D(-4,-28)->(-18,-27)
       fcb 2 ; drawmode 
       fcb 14,-2 ; starx/y relative to previous node
       fdb 73,-74 ; dx/dy. dx(abs:-256|rel:-74) dy(abs:-18|rel:73)
; node # 39 D(-9,-28)->(-22,-29)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 36,19 ; dx/dy. dx(abs:-237|rel:19) dy(abs:18|rel:36)
; node # 40 D(-7,-12)->(-15,-12)
       fcb 2 ; drawmode 
       fcb -16,2 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:-146|rel:91) dy(abs:0|rel:-18)
; node # 41 D(1,9)->(-8,9)
       fcb 2 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 42 D(2,-14)->(-6,-14)
       fcb 2 ; drawmode 
       fcb 23,1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 43 D(-7,-12)->(-15,-12)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 44 M(-1,-30)->(-13,-30)
       fcb 0 ; drawmode 
       fcb 18,6 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:0)
; node # 45 D(-9,-28)->(-22,-29)
       fcb 2 ; drawmode 
       fcb -2,-8 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:18|rel:18)
; node # 46 M(-4,-28)->(-18,-27)
       fcb 0 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb -36,-19 ; dx/dy. dx(abs:-256|rel:-19) dy(abs:-18|rel:-36)
; node # 47 D(-1,-30)->(-13,-30)
       fcb 2 ; drawmode 
       fcb 2,3 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-219|rel:37) dy(abs:0|rel:18)
; node # 48 D(2,-14)->(-6,-14)
       fcb 2 ; drawmode 
       fcb -16,3 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:0)
; node # 49 M(-7,-42)->(-15,-42)
       fcb 0 ; drawmode 
       fcb 28,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 50 D(23,-50)->(17,-49)
       fcb 2 ; drawmode 
       fcb 8,30 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:-18|rel:-18)
; node # 51 D(35,-16)->(28,-16)
       fcb 2 ; drawmode 
       fcb -34,12 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:18)
; node # 52 D(58,-22)->(56,-21)
       fcb 2 ; drawmode 
       fcb 6,23 ; starx/y relative to previous node
       fdb -18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:-18|rel:-18)
; node # 53 D(41,-58)->(39,-57)
       fcb 2 ; drawmode 
       fcb 36,-17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:-18|rel:0)
; node # 54 D(23,-50)->(17,-49)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:-18|rel:0)
; node # 55 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb 5,-33 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:18)
; node # 56 D(-6,-66)->(-5,-66)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 57 D(-6,-63)->(-6,-64)
       fcb 2 ; drawmode 
       fcb -3,0 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:18|rel:18)
; node # 58 D(-15,-62)->(-17,-62)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:-18)
; node # 59 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 60 D(41,-58)->(39,-57)
       fcb 2 ; drawmode 
       fcb 3,51 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:-18|rel:-18)
; node # 61 D(30,-65)->(36,-63)
       fcb 2 ; drawmode 
       fcb 7,-11 ; starx/y relative to previous node
       fdb -18,145 ; dx/dy. dx(abs:109|rel:145) dy(abs:-36|rel:-18)
; node # 62 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -10,-40 ; starx/y relative to previous node
       fdb 36,-109 ; dx/dy. dx(abs:0|rel:-109) dy(abs:0|rel:36)
; node # 63 D(-51,-50)->(-44,-51)
       fcb 2 ; drawmode 
       fcb -5,-41 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:18|rel:18)
; node # 64 D(-11,-61)->(0,-61)
       fcb 2 ; drawmode 
       fcb 11,40 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:201|rel:73) dy(abs:0|rel:-18)
; node # 65 D(-2,-14)->(11,-14)
       fcb 2 ; drawmode 
       fcb -47,9 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 66 D(49,-23)->(55,-22)
       fcb 2 ; drawmode 
       fcb 9,51 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:109|rel:-128) dy(abs:-18|rel:-18)
; node # 67 D(56,3)->(63,3)
       fcb 2 ; drawmode 
       fcb -26,7 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:128|rel:19) dy(abs:0|rel:18)
; node # 68 D(2,14)->(17,14)
       fcb 2 ; drawmode 
       fcb -11,-54 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:274|rel:146) dy(abs:0|rel:0)
; node # 69 D(6,40)->(16,39)
       fcb 2 ; drawmode 
       fcb -26,4 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:182|rel:-92) dy(abs:18|rel:18)
; node # 70 D(44,31)->(50,29)
       fcb 2 ; drawmode 
       fcb 9,38 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:109|rel:-73) dy(abs:36|rel:18)
; node # 71 D(56,3)->(63,3)
       fcb 2 ; drawmode 
       fcb 28,12 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:128|rel:19) dy(abs:0|rel:-36)
; node # 72 D(65,0)->(62,0)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:-54|rel:-182) dy(abs:0|rel:0)
; node # 73 D(52,24)->(50,24)
       fcb 2 ; drawmode 
       fcb -24,-13 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:0|rel:0)
; node # 74 D(34,23)->(29,23)
       fcb 2 ; drawmode 
       fcb 1,-18 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-91|rel:-55) dy(abs:0|rel:0)
; node # 75 M(6,40)->(16,39)
       fcb 0 ; drawmode 
       fcb -17,-28 ; starx/y relative to previous node
       fdb 18,273 ; dx/dy. dx(abs:182|rel:273) dy(abs:18|rel:18)
; node # 76 D(-32,44)->(-25,45)
       fcb 2 ; drawmode 
       fcb -4,-38 ; starx/y relative to previous node
       fdb -36,-54 ; dx/dy. dx(abs:128|rel:-54) dy(abs:-18|rel:-36)
; node # 77 M(52,24)->(50,24)
       fcb 0 ; drawmode 
       fcb 20,84 ; starx/y relative to previous node
       fdb 18,-164 ; dx/dy. dx(abs:-36|rel:-164) dy(abs:0|rel:18)
; node # 78 D(44,31)->(50,29)
       fcb 2 ; drawmode 
       fcb -7,-8 ; starx/y relative to previous node
       fdb 36,145 ; dx/dy. dx(abs:109|rel:145) dy(abs:36|rel:36)
; node # 79 M(65,0)->(62,0)
       fcb 0 ; drawmode 
       fcb 31,21 ; starx/y relative to previous node
       fdb -36,-163 ; dx/dy. dx(abs:-54|rel:-163) dy(abs:0|rel:-36)
; node # 80 D(58,-22)->(56,-21)
       fcb 2 ; drawmode 
       fcb 22,-7 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:-18|rel:-18)
; node # 81 D(49,-23)->(55,-22)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:109|rel:145) dy(abs:-18|rel:0)
; node # 82 D(30,-65)->(36,-63)
       fcb 2 ; drawmode 
       fcb 42,-19 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:109|rel:0) dy(abs:-36|rel:-18)
; node # 83 D(-11,-61)->(0,-61)
       fcb 2 ; drawmode 
       fcb -4,-41 ; starx/y relative to previous node
       fdb 36,92 ; dx/dy. dx(abs:201|rel:92) dy(abs:0|rel:36)
; node # 84 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:0|rel:-201) dy(abs:0|rel:0)
; node # 85 M(-6,-66)->(-5,-66)
       fcb 0 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 86 D(-18,-64)->(-16,-64)
       fcb 2 ; drawmode 
       fcb -2,-12 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 87 D(-15,-62)->(-17,-62)
       fcb 2 ; drawmode 
       fcb -2,3 ; starx/y relative to previous node
       fdb 0,-72 ; dx/dy. dx(abs:-36|rel:-72) dy(abs:0|rel:0)
; node # 88 M(-6,-63)->(-6,-64)
       fcb 0 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:18|rel:18)
; node # 89 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -8,-4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-18)
; node # 90 D(-7,-42)->(-15,-42)
       fcb 2 ; drawmode 
       fcb -13,3 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:0)
; node # 91 M(-18,-64)->(-16,-64)
       fcb 0 ; drawmode 
       fcb 22,-11 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:36|rel:182) dy(abs:0|rel:0)
; node # 92 D(-10,-55)->(-10,-55)
       fcb 2 ; drawmode 
       fcb -9,8 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:0)
; node # 93 M(0,-42)->(11,-42)
       fcb 0 ; drawmode 
       fcb -13,10 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:201|rel:201) dy(abs:0|rel:0)
; node # 94 D(0,-50)->(22,-50)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:402|rel:201) dy(abs:0|rel:0)
; node # 95 D(4,-26)->(26,-26)
       fcb 2 ; drawmode 
       fcb -24,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:402|rel:0) dy(abs:0|rel:0)
; node # 96 D(7,2)->(21,2)
       fcb 2 ; drawmode 
       fcb -28,3 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:256|rel:-146) dy(abs:0|rel:0)
; node # 97 D(-7,4)->(7,4)
       fcb 2 ; drawmode 
       fcb -2,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:0|rel:0)
; node # 98 D(-12,-23)->(10,-23)
       fcb 2 ; drawmode 
       fcb 27,-5 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:402|rel:146) dy(abs:0|rel:0)
; node # 99 D(-17,-48)->(6,-47)
       fcb 2 ; drawmode 
       fcb 25,-5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:420|rel:18) dy(abs:-18|rel:-18)
; node # 100 D(-14,-40)->(-2,-40)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb 18,-201 ; dx/dy. dx(abs:219|rel:-201) dy(abs:0|rel:18)
; node # 101 D(0,-42)->(11,-42)
       fcb 2 ; drawmode 
       fcb 2,14 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:0)
; node # 102 D(-8,-49)->(2,-48)
       fcb 2 ; drawmode 
       fcb 7,-8 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:182|rel:-19) dy(abs:-18|rel:-18)
; node # 103 D(-10,-58)->(15,-58)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb 18,275 ; dx/dy. dx(abs:457|rel:275) dy(abs:0|rel:18)
; node # 104 D(-3,-17)->(22,-17)
       fcb 2 ; drawmode 
       fcb -41,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:457|rel:0) dy(abs:0|rel:0)
; node # 105 D(2,14)->(17,14)
       fcb 2 ; drawmode 
       fcb -31,5 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:274|rel:-183) dy(abs:0|rel:0)
; node # 106 D(-7,4)->(7,4)
       fcb 2 ; drawmode 
       fcb 10,-9 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:256|rel:-18) dy(abs:0|rel:0)
; node # 107 M(65,0)->(62,0)
       fcb 0 ; drawmode 
       fcb 4,72 ; starx/y relative to previous node
       fdb 0,-310 ; dx/dy. dx(abs:-54|rel:-310) dy(abs:0|rel:0)
; node # 108 D(40,2)->(32,2)
       fcb 2 ; drawmode 
       fcb -2,-25 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-146|rel:-92) dy(abs:0|rel:0)
; node # 109 M(32,3)->(32,2)
       fcb 0 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 18,146 ; dx/dy. dx(abs:0|rel:146) dy(abs:18|rel:18)
; node # 110 M(-17,-48)->(6,-47)
       fcb 0 ; drawmode 
       fcb 51,-49 ; starx/y relative to previous node
       fdb -36,420 ; dx/dy. dx(abs:420|rel:420) dy(abs:-18|rel:-36)
; node # 111 D(-10,-58)->(15,-58)
       fcb 2 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:457|rel:37) dy(abs:0|rel:18)
; node # 112 M(2,14)->(17,13)
       fcb 0 ; drawmode 
       fcb -72,12 ; starx/y relative to previous node
       fdb 18,-183 ; dx/dy. dx(abs:274|rel:-183) dy(abs:18|rel:18)
; node # 113 D(7,2)->(21,2)
       fcb 2 ; drawmode 
       fcb 12,5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:256|rel:-18) dy(abs:0|rel:-18)
; node # 114 M(4,-26)->(26,-26)
       fcb 0 ; drawmode 
       fcb 28,-3 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:402|rel:146) dy(abs:0|rel:0)
; node # 115 D(-3,-17)->(22,-17)
       fcb 2 ; drawmode 
       fcb -9,-7 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:457|rel:55) dy(abs:0|rel:0)
; node # 116 D(-12,-23)->(10,-23)
       fcb 2 ; drawmode 
       fcb 6,-9 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:402|rel:-55) dy(abs:0|rel:0)
; node # 117 D(4,-26)->(26,-26)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:402|rel:0) dy(abs:0|rel:0)
; node # 118 M(-17,-48)->(6,-47)
       fcb 0 ; drawmode 
       fcb 22,-21 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:420|rel:18) dy(abs:-18|rel:-18)
; node # 119 D(0,-50)->(22,-50)
       fcb 2 ; drawmode 
       fcb 2,17 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:402|rel:-18) dy(abs:0|rel:18)
; node # 120 M(0,-50)->(22,-50)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:402|rel:0) dy(abs:0|rel:0)
; node # 121 D(-10,-58)->(15,-58)
       fcb 2 ; drawmode 
       fcb 8,-10 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:457|rel:55) dy(abs:0|rel:0)
; node # 122 M(-14,-40)->(-2,-40)
       fcb 0 ; drawmode 
       fcb -18,-4 ; starx/y relative to previous node
       fdb 0,-238 ; dx/dy. dx(abs:219|rel:-238) dy(abs:0|rel:0)
; node # 123 D(-8,-49)->(2,-48)
       fcb 2 ; drawmode 
       fcb 9,6 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
; Animation 15
teapotframe15:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(32,2)->(23,2)
       fcb 0 ; drawmode 
       fcb -2,32 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:0|rel:0)
; node # 1 D(-8,9)->(-17,8)
       fcb 2 ; drawmode 
       fcb -7,-40 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:18)
; node # 2 D(-2,28)->(-9,28)
       fcb 2 ; drawmode 
       fcb -19,6 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:-18)
; node # 3 D(29,23)->(22,23)
       fcb 2 ; drawmode 
       fcb 5,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 4 D(32,2)->(23,2)
       fcb 2 ; drawmode 
       fcb 21,3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 5 D(28,-16)->(19,-16)
       fcb 2 ; drawmode 
       fcb 18,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 6 D(-10,-9)->(-19,-10)
       fcb 2 ; drawmode 
       fcb -7,-38 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:18)
; node # 7 D(-15,-42)->(-22,-43)
       fcb 2 ; drawmode 
       fcb 33,-5 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:18|rel:0)
; node # 8 D(-45,-40)->(-50,-41)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:18|rel:0)
; node # 9 D(-60,-42)->(-59,-44)
       fcb 2 ; drawmode 
       fcb 2,-15 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:36|rel:18)
; node # 10 D(-64,0)->(-64,0)
       fcb 2 ; drawmode 
       fcb -42,-4 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:-36)
; node # 11 D(-63,23)->(-62,24)
       fcb 2 ; drawmode 
       fcb -23,1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:-18)
; node # 12 D(-41,42)->(-41,43)
       fcb 2 ; drawmode 
       fcb -19,22 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-18|rel:0)
; node # 13 D(-25,45)->(-17,46)
       fcb 2 ; drawmode 
       fcb -3,16 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:146|rel:146) dy(abs:-18|rel:0)
; node # 14 D(-43,23)->(-31,24)
       fcb 2 ; drawmode 
       fcb 22,-18 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:219|rel:73) dy(abs:-18|rel:0)
; node # 15 D(-46,-4)->(-35,-4)
       fcb 2 ; drawmode 
       fcb 27,-3 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:18)
; node # 16 D(-64,0)->(-64,0)
       fcb 2 ; drawmode 
       fcb -4,-18 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:0|rel:-201) dy(abs:0|rel:0)
; node # 17 D(-47,-3)->(-53,-4)
       fcb 2 ; drawmode 
       fcb 3,17 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:18|rel:18)
; node # 18 D(-45,-40)->(-50,-41)
       fcb 2 ; drawmode 
       fcb 37,2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:0)
; node # 19 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb 15,35 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:18|rel:0)
; node # 20 D(-60,-42)->(-59,-44)
       fcb 2 ; drawmode 
       fcb -13,-50 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:36|rel:18)
; node # 21 D(-44,-51)->(-35,-53)
       fcb 2 ; drawmode 
       fcb 9,16 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:164|rel:146) dy(abs:36|rel:0)
; node # 22 D(-46,-4)->(-35,-4)
       fcb 2 ; drawmode 
       fcb -47,-2 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:201|rel:37) dy(abs:0|rel:-36)
; node # 23 D(11,-14)->(24,-14)
       fcb 2 ; drawmode 
       fcb 10,57 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 24 D(17,14)->(30,14)
       fcb 2 ; drawmode 
       fcb -28,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:237|rel:0) dy(abs:0|rel:0)
; node # 25 D(-43,23)->(-31,24)
       fcb 2 ; drawmode 
       fcb -9,-60 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:-18|rel:-18)
; node # 26 D(-63,23)->(-62,24)
       fcb 2 ; drawmode 
       fcb 0,-20 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:18|rel:-201) dy(abs:-18|rel:0)
; node # 27 D(-45,16)->(-52,17)
       fcb 2 ; drawmode 
       fcb 7,18 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:-18|rel:0)
; node # 28 D(-47,-3)->(-53,-4)
       fcb 2 ; drawmode 
       fcb 19,-2 ; starx/y relative to previous node
       fdb 36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:36)
; node # 29 D(-10,-9)->(-19,-10)
       fcb 2 ; drawmode 
       fcb 6,37 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:18|rel:0)
; node # 30 D(-8,9)->(-17,8)
       fcb 2 ; drawmode 
       fcb -18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:0)
; node # 31 D(-45,16)->(-52,17)
       fcb 2 ; drawmode 
       fcb -7,-37 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-18|rel:-36)
; node # 32 D(-30,35)->(-35,35)
       fcb 2 ; drawmode 
       fcb -19,15 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:0|rel:18)
; node # 33 D(-2,28)->(-9,28)
       fcb 2 ; drawmode 
       fcb 7,28 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 34 M(-41,42)->(-41,43)
       fcb 0 ; drawmode 
       fcb -14,-39 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:-18|rel:-18)
; node # 35 D(-30,35)->(-35,35)
       fcb 2 ; drawmode 
       fcb 7,11 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-91|rel:-91) dy(abs:0|rel:18)
; node # 36 M(-8,9)->(-17,8)
       fcb 0 ; drawmode 
       fcb 26,22 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:18|rel:18)
; node # 37 D(-12,-9)->(-24,-15)
       fcb 2 ; drawmode 
       fcb 18,-4 ; starx/y relative to previous node
       fdb 91,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:109|rel:91)
; node # 38 D(-18,-27)->(-32,-28)
       fcb 2 ; drawmode 
       fcb 18,-6 ; starx/y relative to previous node
       fdb -91,-37 ; dx/dy. dx(abs:-256|rel:-37) dy(abs:18|rel:-91)
; node # 39 D(-22,-29)->(-34,-29)
       fcb 2 ; drawmode 
       fcb 2,-4 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-219|rel:37) dy(abs:0|rel:-18)
; node # 40 D(-15,-12)->(-24,-12)
       fcb 2 ; drawmode 
       fcb -17,7 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:0)
; node # 41 D(-8,9)->(-17,8)
       fcb 2 ; drawmode 
       fcb -21,7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:18)
; node # 42 D(-6,-14)->(-15,-14)
       fcb 2 ; drawmode 
       fcb 23,2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:-18)
; node # 43 D(-15,-12)->(-24,-12)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 44 M(-13,-30)->(-26,-30)
       fcb 0 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-237|rel:-73) dy(abs:0|rel:0)
; node # 45 D(-22,-29)->(-34,-29)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:0|rel:0)
; node # 46 M(-18,-27)->(-32,-28)
       fcb 0 ; drawmode 
       fcb -2,4 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-256|rel:-37) dy(abs:18|rel:18)
; node # 47 D(-13,-30)->(-26,-30)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-237|rel:19) dy(abs:0|rel:-18)
; node # 48 D(-6,-14)->(-15,-14)
       fcb 2 ; drawmode 
       fcb -16,7 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-164|rel:73) dy(abs:0|rel:0)
; node # 49 M(-15,-42)->(-22,-43)
       fcb 0 ; drawmode 
       fcb 28,-9 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:18|rel:18)
; node # 50 D(17,-49)->(11,-48)
       fcb 2 ; drawmode 
       fcb 7,32 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:-36)
; node # 51 D(28,-16)->(19,-16)
       fcb 2 ; drawmode 
       fcb -33,11 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:18)
; node # 52 D(56,-21)->(51,-21)
       fcb 2 ; drawmode 
       fcb 5,28 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:0)
; node # 53 D(39,-57)->(36,-56)
       fcb 2 ; drawmode 
       fcb 36,-17 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:-18|rel:-18)
; node # 54 D(17,-49)->(11,-48)
       fcb 2 ; drawmode 
       fcb -8,-22 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:-18|rel:0)
; node # 55 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb 6,-27 ; starx/y relative to previous node
       fdb 36,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:18|rel:36)
; node # 56 D(-5,-66)->(-4,-66)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:-18)
; node # 57 D(-6,-64)->(-7,-64)
       fcb 2 ; drawmode 
       fcb -2,-1 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:0|rel:0)
; node # 58 D(-17,-62)->(-18,-63)
       fcb 2 ; drawmode 
       fcb -2,-11 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:18|rel:18)
; node # 59 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb -7,7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:0)
; node # 60 D(39,-57)->(36,-56)
       fcb 2 ; drawmode 
       fcb 2,49 ; starx/y relative to previous node
       fdb -36,-54 ; dx/dy. dx(abs:-54|rel:-54) dy(abs:-18|rel:-36)
; node # 61 D(36,-63)->(41,-61)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -18,145 ; dx/dy. dx(abs:91|rel:145) dy(abs:-36|rel:-18)
; node # 62 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb -8,-46 ; starx/y relative to previous node
       fdb 54,-91 ; dx/dy. dx(abs:0|rel:-91) dy(abs:18|rel:54)
; node # 63 D(-44,-51)->(-35,-53)
       fcb 2 ; drawmode 
       fcb -4,-34 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:164|rel:164) dy(abs:36|rel:18)
; node # 64 D(0,-61)->(10,-61)
       fcb 2 ; drawmode 
       fcb 10,44 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:0|rel:-36)
; node # 65 D(11,-14)->(24,-14)
       fcb 2 ; drawmode 
       fcb -47,11 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:237|rel:55) dy(abs:0|rel:0)
; node # 66 D(55,-22)->(60,-21)
       fcb 2 ; drawmode 
       fcb 8,44 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:91|rel:-146) dy(abs:-18|rel:-18)
; node # 67 D(63,3)->(67,3)
       fcb 2 ; drawmode 
       fcb -25,8 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:0|rel:18)
; node # 68 D(17,14)->(30,14)
       fcb 2 ; drawmode 
       fcb -11,-46 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:237|rel:164) dy(abs:0|rel:0)
; node # 69 D(16,39)->(25,39)
       fcb 2 ; drawmode 
       fcb -25,-1 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:164|rel:-73) dy(abs:0|rel:0)
; node # 70 D(50,29)->(52,29)
       fcb 2 ; drawmode 
       fcb 10,34 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:36|rel:-128) dy(abs:0|rel:0)
; node # 71 D(63,3)->(67,3)
       fcb 2 ; drawmode 
       fcb 26,13 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:73|rel:37) dy(abs:0|rel:0)
; node # 72 D(62,0)->(57,0)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-91|rel:-164) dy(abs:0|rel:0)
; node # 73 D(50,24)->(46,23)
       fcb 2 ; drawmode 
       fcb -24,-12 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:18|rel:18)
; node # 74 D(29,23)->(22,23)
       fcb 2 ; drawmode 
       fcb 1,-21 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:-18)
; node # 75 M(16,39)->(25,39)
       fcb 0 ; drawmode 
       fcb -16,-13 ; starx/y relative to previous node
       fdb 0,292 ; dx/dy. dx(abs:164|rel:292) dy(abs:0|rel:0)
; node # 76 D(-25,45)->(-17,46)
       fcb 2 ; drawmode 
       fcb -6,-41 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:146|rel:-18) dy(abs:-18|rel:-18)
; node # 77 M(50,24)->(46,23)
       fcb 0 ; drawmode 
       fcb 21,75 ; starx/y relative to previous node
       fdb 36,-219 ; dx/dy. dx(abs:-73|rel:-219) dy(abs:18|rel:36)
; node # 78 D(50,29)->(52,29)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:0|rel:-18)
; node # 79 M(62,0)->(57,0)
       fcb 0 ; drawmode 
       fcb 29,12 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:0|rel:0)
; node # 80 D(56,-21)->(51,-21)
       fcb 2 ; drawmode 
       fcb 21,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:0|rel:0)
; node # 81 D(55,-22)->(60,-21)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:91|rel:182) dy(abs:-18|rel:-18)
; node # 82 D(36,-63)->(41,-61)
       fcb 2 ; drawmode 
       fcb 41,-19 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:-36|rel:-18)
; node # 83 D(0,-61)->(10,-61)
       fcb 2 ; drawmode 
       fcb -2,-36 ; starx/y relative to previous node
       fdb 36,91 ; dx/dy. dx(abs:182|rel:91) dy(abs:0|rel:36)
; node # 84 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb -6,-10 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:18|rel:18)
; node # 85 M(-5,-66)->(-4,-66)
       fcb 0 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:-18)
; node # 86 D(-16,-64)->(-14,-65)
       fcb 2 ; drawmode 
       fcb -2,-11 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:18|rel:18)
; node # 87 D(-17,-62)->(-18,-63)
       fcb 2 ; drawmode 
       fcb -2,-1 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-18|rel:-54) dy(abs:18|rel:0)
; node # 88 M(-6,-64)->(-7,-64)
       fcb 0 ; drawmode 
       fcb 2,11 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:-18)
; node # 89 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb -9,-4 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:18)
; node # 90 D(-15,-42)->(-22,-43)
       fcb 2 ; drawmode 
       fcb -13,-5 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:18|rel:0)
; node # 91 M(-16,-64)->(-14,-65)
       fcb 0 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:36|rel:164) dy(abs:18|rel:0)
; node # 92 D(-10,-55)->(-10,-56)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:18|rel:0)
; node # 93 M(11,-42)->(21,-42)
       fcb 0 ; drawmode 
       fcb -13,21 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:182|rel:182) dy(abs:0|rel:-18)
; node # 94 D(22,-50)->(43,-49)
       fcb 2 ; drawmode 
       fcb 8,11 ; starx/y relative to previous node
       fdb -18,202 ; dx/dy. dx(abs:384|rel:202) dy(abs:-18|rel:-18)
; node # 95 D(26,-26)->(46,-25)
       fcb 2 ; drawmode 
       fcb -24,4 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:365|rel:-19) dy(abs:-18|rel:0)
; node # 96 D(21,2)->(33,2)
       fcb 2 ; drawmode 
       fcb -28,-5 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:219|rel:-146) dy(abs:0|rel:18)
; node # 97 D(7,4)->(20,4)
       fcb 2 ; drawmode 
       fcb -2,-14 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 98 D(10,-23)->(32,-23)
       fcb 2 ; drawmode 
       fcb 27,3 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:402|rel:165) dy(abs:0|rel:0)
; node # 99 D(6,-47)->(29,-47)
       fcb 2 ; drawmode 
       fcb 24,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:420|rel:18) dy(abs:0|rel:0)
; node # 100 D(-2,-40)->(9,-40)
       fcb 2 ; drawmode 
       fcb -7,-8 ; starx/y relative to previous node
       fdb 0,-219 ; dx/dy. dx(abs:201|rel:-219) dy(abs:0|rel:0)
; node # 101 D(11,-42)->(21,-42)
       fcb 2 ; drawmode 
       fcb 2,13 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:182|rel:-19) dy(abs:0|rel:0)
; node # 102 D(2,-48)->(14,-47)
       fcb 2 ; drawmode 
       fcb 6,-9 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:-18|rel:-18)
; node # 103 D(15,-58)->(38,-57)
       fcb 2 ; drawmode 
       fcb 10,13 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:420|rel:201) dy(abs:-18|rel:0)
; node # 104 D(22,-17)->(45,-17)
       fcb 2 ; drawmode 
       fcb -41,7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:420|rel:0) dy(abs:0|rel:18)
; node # 105 D(17,14)->(30,14)
       fcb 2 ; drawmode 
       fcb -31,-5 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:237|rel:-183) dy(abs:0|rel:0)
; node # 106 D(7,4)->(20,4)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:237|rel:0) dy(abs:0|rel:0)
; node # 107 M(62,0)->(57,0)
       fcb 0 ; drawmode 
       fcb 4,55 ; starx/y relative to previous node
       fdb 0,-328 ; dx/dy. dx(abs:-91|rel:-328) dy(abs:0|rel:0)
; node # 108 D(32,2)->(23,2)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:0)
; node # 109 M(32,2)->(28,-1)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 54,91 ; dx/dy. dx(abs:-73|rel:91) dy(abs:54|rel:54)
; node # 110 M(6,-47)->(29,-47)
       fcb 0 ; drawmode 
       fcb 49,-26 ; starx/y relative to previous node
       fdb -54,493 ; dx/dy. dx(abs:420|rel:493) dy(abs:0|rel:-54)
; node # 111 D(15,-58)->(38,-57)
       fcb 2 ; drawmode 
       fcb 11,9 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:420|rel:0) dy(abs:-18|rel:-18)
; node # 112 M(17,13)->(30,14)
       fcb 0 ; drawmode 
       fcb -71,2 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:237|rel:-183) dy(abs:-18|rel:0)
; node # 113 D(21,2)->(33,2)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:18)
; node # 114 M(26,-26)->(46,-25)
       fcb 0 ; drawmode 
       fcb 28,5 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:365|rel:146) dy(abs:-18|rel:-18)
; node # 115 D(22,-17)->(45,-17)
       fcb 2 ; drawmode 
       fcb -9,-4 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:420|rel:55) dy(abs:0|rel:18)
; node # 116 D(10,-23)->(32,-23)
       fcb 2 ; drawmode 
       fcb 6,-12 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:402|rel:-18) dy(abs:0|rel:0)
; node # 117 D(26,-26)->(46,-25)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:365|rel:-37) dy(abs:-18|rel:-18)
; node # 118 M(6,-47)->(29,-47)
       fcb 0 ; drawmode 
       fcb 21,-20 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:420|rel:55) dy(abs:0|rel:18)
; node # 119 D(22,-50)->(43,-49)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:384|rel:-36) dy(abs:-18|rel:-18)
; node # 120 M(22,-50)->(43,-49)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:384|rel:0) dy(abs:-18|rel:0)
; node # 121 D(15,-58)->(38,-57)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:420|rel:36) dy(abs:-18|rel:0)
; node # 122 M(-2,-40)->(9,-40)
       fcb 0 ; drawmode 
       fcb -18,-17 ; starx/y relative to previous node
       fdb 18,-219 ; dx/dy. dx(abs:201|rel:-219) dy(abs:0|rel:18)
; node # 123 D(2,-48)->(14,-47)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
; Animation 16
teapotframe16:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(23,2)->(14,2)
       fcb 0 ; drawmode 
       fcb -2,23 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:0|rel:0)
; node # 1 D(-17,8)->(-25,9)
       fcb 2 ; drawmode 
       fcb -6,-40 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:-18|rel:-18)
; node # 2 D(-9,28)->(-16,28)
       fcb 2 ; drawmode 
       fcb -20,8 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:18)
; node # 3 D(22,23)->(14,23)
       fcb 2 ; drawmode 
       fcb 5,31 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 4 D(23,2)->(14,2)
       fcb 2 ; drawmode 
       fcb 21,1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 5 D(19,-16)->(11,-15)
       fcb 2 ; drawmode 
       fcb 18,-4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:-18|rel:-18)
; node # 6 D(-19,-10)->(-27,-9)
       fcb 2 ; drawmode 
       fcb -6,-38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-18|rel:0)
; node # 7 D(-22,-43)->(-29,-44)
       fcb 2 ; drawmode 
       fcb 33,-3 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:36)
; node # 8 D(-50,-41)->(-54,-43)
       fcb 2 ; drawmode 
       fcb -2,-28 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:36|rel:18)
; node # 9 D(-59,-44)->(-56,-46)
       fcb 2 ; drawmode 
       fcb 3,-9 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:36|rel:0)
; node # 10 D(-64,0)->(-61,0)
       fcb 2 ; drawmode 
       fcb -44,-5 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:-36)
; node # 11 D(-62,24)->(-60,25)
       fcb 2 ; drawmode 
       fcb -24,2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:-18|rel:-18)
; node # 12 D(-41,43)->(-38,44)
       fcb 2 ; drawmode 
       fcb -19,21 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:-18|rel:0)
; node # 13 D(-17,46)->(-8,46)
       fcb 2 ; drawmode 
       fcb -3,24 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:0|rel:18)
; node # 14 D(-31,24)->(-19,24)
       fcb 2 ; drawmode 
       fcb 22,-14 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:219|rel:55) dy(abs:0|rel:0)
; node # 15 D(-35,-4)->(-22,-4)
       fcb 2 ; drawmode 
       fcb 28,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 16 D(-64,0)->(-61,0)
       fcb 2 ; drawmode 
       fcb -4,-29 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:54|rel:-183) dy(abs:0|rel:0)
; node # 17 D(-53,-4)->(-58,-3)
       fcb 2 ; drawmode 
       fcb 4,11 ; starx/y relative to previous node
       fdb -18,-145 ; dx/dy. dx(abs:-91|rel:-145) dy(abs:-18|rel:-18)
; node # 18 D(-50,-41)->(-54,-43)
       fcb 2 ; drawmode 
       fcb 37,3 ; starx/y relative to previous node
       fdb 54,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:36|rel:54)
; node # 19 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb 15,40 ; starx/y relative to previous node
       fdb -36,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:0|rel:-36)
; node # 20 D(-59,-44)->(-56,-46)
       fcb 2 ; drawmode 
       fcb -12,-49 ; starx/y relative to previous node
       fdb 36,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:36|rel:36)
; node # 21 D(-35,-53)->(-25,-54)
       fcb 2 ; drawmode 
       fcb 9,24 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:182|rel:128) dy(abs:18|rel:-18)
; node # 22 D(-35,-4)->(-22,-4)
       fcb 2 ; drawmode 
       fcb -49,0 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:237|rel:55) dy(abs:0|rel:-18)
; node # 23 D(24,-14)->(36,-14)
       fcb 2 ; drawmode 
       fcb 10,59 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:0)
; node # 24 D(30,14)->(42,13)
       fcb 2 ; drawmode 
       fcb -28,6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:18|rel:18)
; node # 25 D(-31,24)->(-19,24)
       fcb 2 ; drawmode 
       fcb -10,-61 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:0|rel:-18)
; node # 26 D(-62,24)->(-60,25)
       fcb 2 ; drawmode 
       fcb 0,-31 ; starx/y relative to previous node
       fdb -18,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:-18|rel:-18)
; node # 27 D(-52,17)->(-57,17)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:0|rel:18)
; node # 28 D(-53,-4)->(-58,-3)
       fcb 2 ; drawmode 
       fcb 21,-1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:-18|rel:-18)
; node # 29 D(-19,-10)->(-27,-9)
       fcb 2 ; drawmode 
       fcb 6,34 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:-18|rel:0)
; node # 30 D(-17,8)->(-25,9)
       fcb 2 ; drawmode 
       fcb -18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-18|rel:0)
; node # 31 D(-52,17)->(-57,17)
       fcb 2 ; drawmode 
       fcb -9,-35 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:0|rel:18)
; node # 32 D(-35,35)->(-39,37)
       fcb 2 ; drawmode 
       fcb -18,17 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:-36|rel:-36)
; node # 33 D(-9,28)->(-16,28)
       fcb 2 ; drawmode 
       fcb 7,26 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:36)
; node # 34 M(-41,43)->(-38,44)
       fcb 0 ; drawmode 
       fcb -15,-32 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:54|rel:182) dy(abs:-18|rel:-18)
; node # 35 D(-35,35)->(-39,37)
       fcb 2 ; drawmode 
       fcb 8,6 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:-36|rel:-18)
; node # 36 M(-17,8)->(-25,9)
       fcb 0 ; drawmode 
       fcb 27,18 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:-18|rel:18)
; node # 37 D(-24,-15)->(-37,-17)
       fcb 2 ; drawmode 
       fcb 23,-7 ; starx/y relative to previous node
       fdb 54,-91 ; dx/dy. dx(abs:-237|rel:-91) dy(abs:36|rel:54)
; node # 38 D(-32,-28)->(-45,-29)
       fcb 2 ; drawmode 
       fcb 13,-8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-237|rel:0) dy(abs:18|rel:-18)
; node # 39 D(-34,-29)->(-46,-30)
       fcb 2 ; drawmode 
       fcb 1,-2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:18|rel:0)
; node # 40 D(-24,-12)->(-31,-12)
       fcb 2 ; drawmode 
       fcb -17,10 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:0|rel:-18)
; node # 41 D(-17,8)->(-25,9)
       fcb 2 ; drawmode 
       fcb -20,7 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:-18)
; node # 42 D(-15,-14)->(-23,-14)
       fcb 2 ; drawmode 
       fcb 22,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:18)
; node # 43 D(-24,-12)->(-31,-12)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 44 M(-26,-30)->(-38,-31)
       fcb 0 ; drawmode 
       fcb 18,-2 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-219|rel:-91) dy(abs:18|rel:18)
; node # 45 D(-34,-29)->(-46,-30)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:0)
; node # 46 M(-32,-28)->(-45,-29)
       fcb 0 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:18|rel:0)
; node # 47 D(-26,-30)->(-38,-31)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:18|rel:0)
; node # 48 D(-15,-14)->(-23,-14)
       fcb 2 ; drawmode 
       fcb -16,11 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:-18)
; node # 49 M(-22,-43)->(-29,-44)
       fcb 0 ; drawmode 
       fcb 29,-7 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:18)
; node # 50 D(11,-48)->(4,-48)
       fcb 2 ; drawmode 
       fcb 5,33 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:-18)
; node # 51 D(19,-16)->(11,-15)
       fcb 2 ; drawmode 
       fcb -32,8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:-18)
; node # 52 D(51,-21)->(45,-20)
       fcb 2 ; drawmode 
       fcb 5,32 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:-18|rel:0)
; node # 53 D(36,-56)->(32,-54)
       fcb 2 ; drawmode 
       fcb 35,-15 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-36|rel:-18)
; node # 54 D(11,-48)->(4,-48)
       fcb 2 ; drawmode 
       fcb -8,-25 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:36)
; node # 55 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb 8,-21 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:18|rel:146) dy(abs:0|rel:0)
; node # 56 D(-4,-66)->(-2,-66)
       fcb 2 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 57 D(-7,-64)->(-7,-64)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:0)
; node # 58 D(-18,-63)->(-17,-64)
       fcb 2 ; drawmode 
       fcb -1,-11 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 59 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:-18)
; node # 60 D(36,-56)->(32,-54)
       fcb 2 ; drawmode 
       fcb 0,46 ; starx/y relative to previous node
       fdb -36,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:-36|rel:-36)
; node # 61 D(41,-61)->(43,-60)
       fcb 2 ; drawmode 
       fcb 5,5 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:-18|rel:18)
; node # 62 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb -5,-51 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:18)
; node # 63 D(-35,-53)->(-25,-54)
       fcb 2 ; drawmode 
       fcb -3,-25 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:182|rel:164) dy(abs:18|rel:18)
; node # 64 D(10,-61)->(21,-60)
       fcb 2 ; drawmode 
       fcb 8,45 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:201|rel:19) dy(abs:-18|rel:-36)
; node # 65 D(24,-14)->(36,-14)
       fcb 2 ; drawmode 
       fcb -47,14 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:0|rel:18)
; node # 66 D(60,-21)->(61,-20)
       fcb 2 ; drawmode 
       fcb 7,36 ; starx/y relative to previous node
       fdb -18,-201 ; dx/dy. dx(abs:18|rel:-201) dy(abs:-18|rel:-18)
; node # 67 D(67,3)->(68,3)
       fcb 2 ; drawmode 
       fcb -24,7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:18)
; node # 68 D(30,14)->(42,13)
       fcb 2 ; drawmode 
       fcb -11,-37 ; starx/y relative to previous node
       fdb 18,201 ; dx/dy. dx(abs:219|rel:201) dy(abs:18|rel:18)
; node # 69 D(25,39)->(33,38)
       fcb 2 ; drawmode 
       fcb -25,-5 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:18|rel:0)
; node # 70 D(52,29)->(52,28)
       fcb 2 ; drawmode 
       fcb 10,27 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:0|rel:-146) dy(abs:18|rel:0)
; node # 71 D(67,3)->(68,3)
       fcb 2 ; drawmode 
       fcb 26,15 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:-18)
; node # 72 D(57,0)->(50,0)
       fcb 2 ; drawmode 
       fcb 3,-10 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:0|rel:0)
; node # 73 D(46,23)->(41,22)
       fcb 2 ; drawmode 
       fcb -23,-11 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:18|rel:18)
; node # 74 D(22,23)->(14,23)
       fcb 2 ; drawmode 
       fcb 0,-24 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:-18)
; node # 75 M(25,39)->(33,38)
       fcb 0 ; drawmode 
       fcb -16,3 ; starx/y relative to previous node
       fdb 18,292 ; dx/dy. dx(abs:146|rel:292) dy(abs:18|rel:18)
; node # 76 D(-17,46)->(-8,46)
       fcb 2 ; drawmode 
       fcb -7,-42 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:164|rel:18) dy(abs:0|rel:-18)
; node # 77 M(46,23)->(41,22)
       fcb 0 ; drawmode 
       fcb 23,63 ; starx/y relative to previous node
       fdb 18,-255 ; dx/dy. dx(abs:-91|rel:-255) dy(abs:18|rel:18)
; node # 78 D(52,29)->(52,28)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:18|rel:0)
; node # 79 M(57,0)->(50,0)
       fcb 0 ; drawmode 
       fcb 29,5 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:-18)
; node # 80 D(51,-21)->(45,-20)
       fcb 2 ; drawmode 
       fcb 21,-6 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:-18)
; node # 81 D(60,-21)->(61,-20)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:18|rel:127) dy(abs:-18|rel:0)
; node # 82 D(41,-61)->(43,-60)
       fcb 2 ; drawmode 
       fcb 40,-19 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:-18|rel:0)
; node # 83 D(10,-61)->(21,-60)
       fcb 2 ; drawmode 
       fcb 0,-31 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:201|rel:165) dy(abs:-18|rel:0)
; node # 84 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb -5,-20 ; starx/y relative to previous node
       fdb 18,-183 ; dx/dy. dx(abs:18|rel:-183) dy(abs:0|rel:18)
; node # 85 M(-4,-66)->(-2,-66)
       fcb 0 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 86 D(-14,-65)->(-12,-66)
       fcb 2 ; drawmode 
       fcb -1,-10 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:18|rel:18)
; node # 87 D(-18,-63)->(-17,-64)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:18|rel:0)
; node # 88 M(-7,-64)->(-7,-64)
       fcb 0 ; drawmode 
       fcb 1,11 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:-18)
; node # 89 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb -8,-3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 90 D(-22,-43)->(-29,-44)
       fcb 2 ; drawmode 
       fcb -13,-12 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:18|rel:18)
; node # 91 M(-14,-65)->(-12,-66)
       fcb 0 ; drawmode 
       fcb 22,8 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:36|rel:164) dy(abs:18|rel:0)
; node # 92 D(-10,-56)->(-9,-56)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:-18)
; node # 93 M(21,-42)->(31,-41)
       fcb 0 ; drawmode 
       fcb -14,31 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:182|rel:164) dy(abs:-18|rel:-18)
; node # 94 D(43,-49)->(61,-47)
       fcb 2 ; drawmode 
       fcb 7,22 ; starx/y relative to previous node
       fdb -18,147 ; dx/dy. dx(abs:329|rel:147) dy(abs:-36|rel:-18)
; node # 95 D(46,-25)->(64,-24)
       fcb 2 ; drawmode 
       fcb -24,3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:329|rel:0) dy(abs:-18|rel:18)
; node # 96 D(33,2)->(44,2)
       fcb 2 ; drawmode 
       fcb -27,-13 ; starx/y relative to previous node
       fdb 18,-128 ; dx/dy. dx(abs:201|rel:-128) dy(abs:0|rel:18)
; node # 97 D(20,4)->(33,4)
       fcb 2 ; drawmode 
       fcb -2,-13 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 98 D(32,-23)->(53,-23)
       fcb 2 ; drawmode 
       fcb 27,12 ; starx/y relative to previous node
       fdb 0,147 ; dx/dy. dx(abs:384|rel:147) dy(abs:0|rel:0)
; node # 99 D(29,-47)->(50,-46)
       fcb 2 ; drawmode 
       fcb 24,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:384|rel:0) dy(abs:-18|rel:-18)
; node # 100 D(9,-40)->(21,-39)
       fcb 2 ; drawmode 
       fcb -7,-20 ; starx/y relative to previous node
       fdb 0,-165 ; dx/dy. dx(abs:219|rel:-165) dy(abs:-18|rel:0)
; node # 101 D(21,-42)->(31,-41)
       fcb 2 ; drawmode 
       fcb 2,12 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:-18|rel:0)
; node # 102 D(14,-47)->(24,-47)
       fcb 2 ; drawmode 
       fcb 5,-7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:0|rel:18)
; node # 103 D(38,-57)->(59,-56)
       fcb 2 ; drawmode 
       fcb 10,24 ; starx/y relative to previous node
       fdb -18,202 ; dx/dy. dx(abs:384|rel:202) dy(abs:-18|rel:-18)
; node # 104 D(45,-17)->(65,-16)
       fcb 2 ; drawmode 
       fcb -40,7 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:365|rel:-19) dy(abs:-18|rel:0)
; node # 105 D(30,14)->(42,13)
       fcb 2 ; drawmode 
       fcb -31,-15 ; starx/y relative to previous node
       fdb 36,-146 ; dx/dy. dx(abs:219|rel:-146) dy(abs:18|rel:36)
; node # 106 D(20,4)->(33,4)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:-18)
; node # 107 M(57,0)->(50,0)
       fcb 0 ; drawmode 
       fcb 4,37 ; starx/y relative to previous node
       fdb 0,-365 ; dx/dy. dx(abs:-128|rel:-365) dy(abs:0|rel:0)
; node # 108 D(23,2)->(14,2)
       fcb 2 ; drawmode 
       fcb -2,-34 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:0)
; node # 110 M(29,-47)->(50,-46)
       fcb 0 ; drawmode 
       fcb 46,1 ; starx/y relative to previous node
       fdb -18,384 ; dx/dy. dx(abs:384|rel:384) dy(abs:-18|rel:-18)
; node # 111 D(38,-57)->(59,-56)
       fcb 2 ; drawmode 
       fcb 10,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:384|rel:0) dy(abs:-18|rel:0)
; node # 112 M(30,14)->(42,13)
       fcb 0 ; drawmode 
       fcb -71,-8 ; starx/y relative to previous node
       fdb 36,-165 ; dx/dy. dx(abs:219|rel:-165) dy(abs:18|rel:36)
; node # 113 D(33,2)->(44,2)
       fcb 2 ; drawmode 
       fcb 12,3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:-18)
; node # 114 M(46,-25)->(64,-24)
       fcb 0 ; drawmode 
       fcb 27,13 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:329|rel:128) dy(abs:-18|rel:-18)
; node # 115 D(45,-17)->(65,-16)
       fcb 2 ; drawmode 
       fcb -8,-1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:365|rel:36) dy(abs:-18|rel:0)
; node # 116 D(32,-23)->(53,-23)
       fcb 2 ; drawmode 
       fcb 6,-13 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:384|rel:19) dy(abs:0|rel:18)
; node # 117 D(46,-25)->(64,-24)
       fcb 2 ; drawmode 
       fcb 2,14 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:329|rel:-55) dy(abs:-18|rel:-18)
; node # 118 M(29,-47)->(50,-46)
       fcb 0 ; drawmode 
       fcb 22,-17 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:384|rel:55) dy(abs:-18|rel:0)
; node # 119 D(43,-49)->(61,-47)
       fcb 2 ; drawmode 
       fcb 2,14 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:329|rel:-55) dy(abs:-36|rel:-18)
; node # 120 M(43,-49)->(61,-47)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:329|rel:0) dy(abs:-36|rel:0)
; node # 121 D(38,-57)->(59,-56)
       fcb 2 ; drawmode 
       fcb 8,-5 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:384|rel:55) dy(abs:-18|rel:18)
; node # 122 M(9,-40)->(21,-39)
       fcb 0 ; drawmode 
       fcb -17,-29 ; starx/y relative to previous node
       fdb 0,-165 ; dx/dy. dx(abs:219|rel:-165) dy(abs:-18|rel:0)
; node # 123 D(14,-47)->(24,-47)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:0|rel:18)
       fcb  1  ; end of anim
; Animation 17
teapotframe17:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(14,2)->(5,2)
       fcb 0 ; drawmode 
       fcb -2,14 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:0|rel:0)
; node # 1 D(-25,9)->(-34,9)
       fcb 2 ; drawmode 
       fcb -7,-39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 2 D(-16,28)->(-23,29)
       fcb 2 ; drawmode 
       fcb -19,9 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-18|rel:-18)
; node # 3 D(14,23)->(7,23)
       fcb 2 ; drawmode 
       fcb 5,30 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
; node # 4 D(14,2)->(5,2)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 5 D(11,-15)->(3,-15)
       fcb 2 ; drawmode 
       fcb 17,-3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 6 D(-27,-9)->(-35,-10)
       fcb 2 ; drawmode 
       fcb -6,-38 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 7 D(-29,-44)->(-35,-44)
       fcb 2 ; drawmode 
       fcb 35,-2 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:-18)
; node # 8 D(-54,-43)->(-57,-44)
       fcb 2 ; drawmode 
       fcb -1,-25 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:18|rel:18)
; node # 9 D(-56,-46)->(-52,-47)
       fcb 2 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:73|rel:127) dy(abs:18|rel:0)
; node # 10 D(-61,0)->(-56,0)
       fcb 2 ; drawmode 
       fcb -46,-5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:91|rel:18) dy(abs:0|rel:-18)
; node # 11 D(-60,25)->(-54,26)
       fcb 2 ; drawmode 
       fcb -25,1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:109|rel:18) dy(abs:-18|rel:-18)
; node # 12 D(-38,44)->(-35,45)
       fcb 2 ; drawmode 
       fcb -19,22 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:54|rel:-55) dy(abs:-18|rel:0)
; node # 13 D(-8,46)->(1,46)
       fcb 2 ; drawmode 
       fcb -2,30 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:0|rel:18)
; node # 14 D(-19,24)->(-5,24)
       fcb 2 ; drawmode 
       fcb 22,-11 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:256|rel:92) dy(abs:0|rel:0)
; node # 15 D(-22,-4)->(-8,-4)
       fcb 2 ; drawmode 
       fcb 28,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:0|rel:0)
; node # 16 D(-61,0)->(-56,0)
       fcb 2 ; drawmode 
       fcb -4,-39 ; starx/y relative to previous node
       fdb 0,-165 ; dx/dy. dx(abs:91|rel:-165) dy(abs:0|rel:0)
; node # 17 D(-58,-3)->(-62,-3)
       fcb 2 ; drawmode 
       fcb 3,3 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-73|rel:-164) dy(abs:0|rel:0)
; node # 18 D(-54,-43)->(-57,-44)
       fcb 2 ; drawmode 
       fcb 40,4 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:18|rel:18)
; node # 19 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb 13,45 ; starx/y relative to previous node
       fdb -18,72 ; dx/dy. dx(abs:18|rel:72) dy(abs:0|rel:-18)
; node # 20 D(-56,-46)->(-52,-47)
       fcb 2 ; drawmode 
       fcb -10,-47 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:73|rel:55) dy(abs:18|rel:18)
; node # 21 D(-25,-54)->(-14,-55)
       fcb 2 ; drawmode 
       fcb 8,31 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:201|rel:128) dy(abs:18|rel:0)
; node # 22 D(-22,-4)->(-8,-4)
       fcb 2 ; drawmode 
       fcb -50,3 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:256|rel:55) dy(abs:0|rel:-18)
; node # 23 D(36,-14)->(46,-13)
       fcb 2 ; drawmode 
       fcb 10,58 ; starx/y relative to previous node
       fdb -18,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:-18|rel:-18)
; node # 24 D(42,13)->(51,13)
       fcb 2 ; drawmode 
       fcb -27,6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:0|rel:18)
; node # 25 D(-19,24)->(-5,24)
       fcb 2 ; drawmode 
       fcb -11,-61 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:256|rel:92) dy(abs:0|rel:0)
; node # 26 D(-60,25)->(-54,26)
       fcb 2 ; drawmode 
       fcb -1,-41 ; starx/y relative to previous node
       fdb -18,-147 ; dx/dy. dx(abs:109|rel:-147) dy(abs:-18|rel:-18)
; node # 27 D(-57,17)->(-62,18)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 0,-200 ; dx/dy. dx(abs:-91|rel:-200) dy(abs:-18|rel:0)
; node # 28 D(-58,-3)->(-62,-3)
       fcb 2 ; drawmode 
       fcb 20,-1 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:0|rel:18)
; node # 29 D(-27,-9)->(-35,-10)
       fcb 2 ; drawmode 
       fcb 6,31 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:18|rel:18)
; node # 30 D(-25,9)->(-34,9)
       fcb 2 ; drawmode 
       fcb -18,2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:-18)
; node # 31 D(-57,17)->(-62,18)
       fcb 2 ; drawmode 
       fcb -8,-32 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:-18|rel:-18)
; node # 32 D(-39,37)->(-42,37)
       fcb 2 ; drawmode 
       fcb -20,18 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:0|rel:18)
; node # 33 D(-16,28)->(-23,29)
       fcb 2 ; drawmode 
       fcb 9,23 ; starx/y relative to previous node
       fdb -18,-74 ; dx/dy. dx(abs:-128|rel:-74) dy(abs:-18|rel:-18)
; node # 34 M(-38,44)->(-35,45)
       fcb 0 ; drawmode 
       fcb -16,-22 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:54|rel:182) dy(abs:-18|rel:0)
; node # 35 D(-39,37)->(-42,37)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 18,-108 ; dx/dy. dx(abs:-54|rel:-108) dy(abs:0|rel:18)
; node # 36 M(-25,9)->(-34,9)
       fcb 0 ; drawmode 
       fcb 28,14 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-164|rel:-110) dy(abs:0|rel:0)
; node # 37 D(-37,-17)->(-48,-18)
       fcb 2 ; drawmode 
       fcb 26,-12 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:18|rel:18)
; node # 38 D(-45,-29)->(-59,-31)
       fcb 2 ; drawmode 
       fcb 12,-8 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-256|rel:-55) dy(abs:36|rel:18)
; node # 39 D(-46,-30)->(-57,-31)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-201|rel:55) dy(abs:18|rel:-18)
; node # 40 D(-31,-12)->(-39,-13)
       fcb 2 ; drawmode 
       fcb -18,15 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-146|rel:55) dy(abs:18|rel:0)
; node # 41 D(-25,9)->(-34,9)
       fcb 2 ; drawmode 
       fcb -21,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:-18)
; node # 42 D(-23,-14)->(-31,-14)
       fcb 2 ; drawmode 
       fcb 23,2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 43 D(-31,-12)->(-39,-13)
       fcb 2 ; drawmode 
       fcb -2,-8 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 44 M(-38,-31)->(-49,-32)
       fcb 0 ; drawmode 
       fcb 19,-7 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:18|rel:0)
; node # 45 D(-46,-30)->(-57,-31)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:18|rel:0)
; node # 46 M(-45,-29)->(-59,-31)
       fcb 0 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-256|rel:-55) dy(abs:36|rel:18)
; node # 47 D(-38,-31)->(-49,-32)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-201|rel:55) dy(abs:18|rel:-18)
; node # 48 D(-23,-14)->(-31,-14)
       fcb 2 ; drawmode 
       fcb -17,15 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-146|rel:55) dy(abs:0|rel:-18)
; node # 49 M(-29,-44)->(-35,-44)
       fcb 0 ; drawmode 
       fcb 30,-6 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 50 D(4,-48)->(-2,-48)
       fcb 2 ; drawmode 
       fcb 4,33 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 51 D(11,-15)->(3,-15)
       fcb 2 ; drawmode 
       fcb -33,7 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:0)
; node # 52 D(45,-20)->(39,-19)
       fcb 2 ; drawmode 
       fcb 5,34 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:-18|rel:-18)
; node # 53 D(32,-54)->(28,-53)
       fcb 2 ; drawmode 
       fcb 34,-13 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-18|rel:0)
; node # 54 D(4,-48)->(-2,-48)
       fcb 2 ; drawmode 
       fcb -6,-28 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:18)
; node # 55 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb 8,-13 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:18|rel:127) dy(abs:0|rel:0)
; node # 56 D(-2,-66)->(-1,-66)
       fcb 2 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 57 D(-7,-64)->(-8,-64)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:0|rel:0)
; node # 58 D(-17,-64)->(-17,-64)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 59 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb -8,8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 60 D(32,-54)->(28,-53)
       fcb 2 ; drawmode 
       fcb -2,41 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:-18|rel:-18)
; node # 61 D(43,-60)->(45,-58)
       fcb 2 ; drawmode 
       fcb 6,11 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:-36|rel:-18)
; node # 62 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb -4,-52 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:36)
; node # 63 D(-25,-54)->(-14,-55)
       fcb 2 ; drawmode 
       fcb -2,-16 ; starx/y relative to previous node
       fdb 18,183 ; dx/dy. dx(abs:201|rel:183) dy(abs:18|rel:18)
; node # 64 D(21,-60)->(30,-59)
       fcb 2 ; drawmode 
       fcb 6,46 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:-18|rel:-36)
; node # 65 D(36,-14)->(46,-13)
       fcb 2 ; drawmode 
       fcb -46,15 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:-18|rel:0)
; node # 66 D(61,-20)->(61,-20)
       fcb 2 ; drawmode 
       fcb 6,25 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:0|rel:18)
; node # 67 D(68,3)->(67,2)
       fcb 2 ; drawmode 
       fcb -23,7 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:18)
; node # 68 D(42,13)->(51,13)
       fcb 2 ; drawmode 
       fcb -10,-26 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:164|rel:182) dy(abs:0|rel:-18)
; node # 69 D(33,38)->(39,37)
       fcb 2 ; drawmode 
       fcb -25,-9 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:18|rel:18)
; node # 70 D(52,28)->(52,27)
       fcb 2 ; drawmode 
       fcb 10,19 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:0|rel:-109) dy(abs:18|rel:0)
; node # 71 D(68,3)->(67,2)
       fcb 2 ; drawmode 
       fcb 25,16 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:0)
; node # 72 D(50,0)->(43,0)
       fcb 2 ; drawmode 
       fcb 3,-18 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:0|rel:-18)
; node # 73 D(41,22)->(36,22)
       fcb 2 ; drawmode 
       fcb -22,-9 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:0|rel:0)
; node # 74 D(14,23)->(7,23)
       fcb 2 ; drawmode 
       fcb -1,-27 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 75 M(33,38)->(39,37)
       fcb 0 ; drawmode 
       fcb -15,19 ; starx/y relative to previous node
       fdb 18,237 ; dx/dy. dx(abs:109|rel:237) dy(abs:18|rel:18)
; node # 76 D(-8,46)->(1,46)
       fcb 2 ; drawmode 
       fcb -8,-41 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:164|rel:55) dy(abs:0|rel:-18)
; node # 77 M(41,22)->(36,22)
       fcb 0 ; drawmode 
       fcb 24,49 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-91|rel:-255) dy(abs:0|rel:0)
; node # 78 D(52,28)->(52,27)
       fcb 2 ; drawmode 
       fcb -6,11 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:18|rel:18)
; node # 79 M(50,0)->(43,0)
       fcb 0 ; drawmode 
       fcb 28,-2 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:-18)
; node # 80 D(45,-20)->(39,-19)
       fcb 2 ; drawmode 
       fcb 20,-5 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:-18)
; node # 81 D(61,-20)->(61,-20)
       fcb 2 ; drawmode 
       fcb 0,16 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:18)
; node # 82 D(43,-60)->(45,-58)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:-36|rel:-36)
; node # 83 D(21,-60)->(30,-59)
       fcb 2 ; drawmode 
       fcb 0,-22 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:164|rel:128) dy(abs:-18|rel:18)
; node # 84 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb -4,-30 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:18|rel:-146) dy(abs:0|rel:18)
; node # 85 M(-2,-66)->(-1,-66)
       fcb 0 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 86 D(-12,-66)->(-10,-66)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 87 D(-17,-64)->(-17,-64)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:0)
; node # 88 M(-7,-64)->(-8,-64)
       fcb 0 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 89 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:0|rel:0)
; node # 90 D(-29,-44)->(-35,-44)
       fcb 2 ; drawmode 
       fcb -12,-20 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:0)
; node # 91 M(-12,-66)->(-10,-66)
       fcb 0 ; drawmode 
       fcb 22,17 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:0|rel:0)
; node # 92 D(-9,-56)->(-8,-56)
       fcb 2 ; drawmode 
       fcb -10,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:0)
; node # 93 M(31,-41)->(40,-40)
       fcb 0 ; drawmode 
       fcb -15,40 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:164|rel:146) dy(abs:-18|rel:-18)
; node # 94 D(61,-47)->(76,-45)
       fcb 2 ; drawmode 
       fcb 6,30 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:274|rel:110) dy(abs:-36|rel:-18)
; node # 95 D(64,-24)->(78,-23)
       fcb 2 ; drawmode 
       fcb -23,3 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:256|rel:-18) dy(abs:-18|rel:18)
; node # 96 D(44,2)->(52,2)
       fcb 2 ; drawmode 
       fcb -26,-20 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:146|rel:-110) dy(abs:0|rel:18)
; node # 97 D(33,4)->(43,4)
       fcb 2 ; drawmode 
       fcb -2,-11 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:182|rel:36) dy(abs:0|rel:0)
; node # 98 D(53,-23)->(69,-21)
       fcb 2 ; drawmode 
       fcb 27,20 ; starx/y relative to previous node
       fdb -36,110 ; dx/dy. dx(abs:292|rel:110) dy(abs:-36|rel:-36)
; node # 99 D(50,-46)->(66,-44)
       fcb 2 ; drawmode 
       fcb 23,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:292|rel:0) dy(abs:-36|rel:0)
; node # 100 D(21,-39)->(31,-39)
       fcb 2 ; drawmode 
       fcb -7,-29 ; starx/y relative to previous node
       fdb 36,-110 ; dx/dy. dx(abs:182|rel:-110) dy(abs:0|rel:36)
; node # 101 D(31,-41)->(40,-40)
       fcb 2 ; drawmode 
       fcb 2,10 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:164|rel:-18) dy(abs:-18|rel:-18)
; node # 102 D(24,-47)->(34,-46)
       fcb 2 ; drawmode 
       fcb 6,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:-18|rel:0)
; node # 103 D(59,-56)->(77,-53)
       fcb 2 ; drawmode 
       fcb 9,35 ; starx/y relative to previous node
       fdb -36,147 ; dx/dy. dx(abs:329|rel:147) dy(abs:-54|rel:-36)
; node # 104 D(65,-16)->(81,-15)
       fcb 2 ; drawmode 
       fcb -40,6 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:292|rel:-37) dy(abs:-18|rel:36)
; node # 105 D(42,13)->(51,13)
       fcb 2 ; drawmode 
       fcb -29,-23 ; starx/y relative to previous node
       fdb 18,-128 ; dx/dy. dx(abs:164|rel:-128) dy(abs:0|rel:18)
; node # 106 D(33,4)->(43,4)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:0|rel:0)
; node # 107 M(50,0)->(43,0)
       fcb 0 ; drawmode 
       fcb 4,17 ; starx/y relative to previous node
       fdb 0,-310 ; dx/dy. dx(abs:-128|rel:-310) dy(abs:0|rel:0)
; node # 108 D(14,2)->(5,2)
       fcb 2 ; drawmode 
       fcb -2,-36 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,14 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:0)
; node # 110 M(50,-46)->(66,-44)
       fcb 0 ; drawmode 
       fcb 45,22 ; starx/y relative to previous node
       fdb -36,292 ; dx/dy. dx(abs:292|rel:292) dy(abs:-36|rel:-36)
; node # 111 D(59,-56)->(77,-53)
       fcb 2 ; drawmode 
       fcb 10,9 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:329|rel:37) dy(abs:-54|rel:-18)
; node # 112 M(42,13)->(51,13)
       fcb 0 ; drawmode 
       fcb -69,-17 ; starx/y relative to previous node
       fdb 54,-165 ; dx/dy. dx(abs:164|rel:-165) dy(abs:0|rel:54)
; node # 113 D(44,2)->(52,2)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:146|rel:-18) dy(abs:0|rel:0)
; node # 114 M(64,-24)->(78,-23)
       fcb 0 ; drawmode 
       fcb 26,20 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:256|rel:110) dy(abs:-18|rel:-18)
; node # 115 D(65,-16)->(81,-15)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:292|rel:36) dy(abs:-18|rel:0)
; node # 116 D(53,-23)->(69,-21)
       fcb 2 ; drawmode 
       fcb 7,-12 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:292|rel:0) dy(abs:-36|rel:-18)
; node # 117 D(64,-24)->(78,-23)
       fcb 2 ; drawmode 
       fcb 1,11 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:256|rel:-36) dy(abs:-18|rel:18)
; node # 118 M(50,-46)->(66,-44)
       fcb 0 ; drawmode 
       fcb 22,-14 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:292|rel:36) dy(abs:-36|rel:-18)
; node # 119 D(61,-47)->(76,-45)
       fcb 2 ; drawmode 
       fcb 1,11 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:274|rel:-18) dy(abs:-36|rel:0)
; node # 120 M(61,-47)->(76,-45)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:274|rel:0) dy(abs:-36|rel:0)
; node # 121 D(59,-56)->(77,-53)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:329|rel:55) dy(abs:-54|rel:-18)
; node # 122 M(21,-39)->(31,-39)
       fcb 0 ; drawmode 
       fcb -17,-38 ; starx/y relative to previous node
       fdb 54,-147 ; dx/dy. dx(abs:182|rel:-147) dy(abs:0|rel:54)
; node # 123 D(24,-47)->(34,-46)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
