bruceframecount equ 2 ; number of animations
bruceframetotal equ 120 ; total number of frames in animation 
; index table 
bruceframetab        fdb bruceframe0
       fdb bruceframe1

; Animation 0
bruceframe0:
       fcb 60 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(13,95)->(13,95)
       fcb 0 ; drawmode 
       fcb -95,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(11,48)->(11,48)
       fcb 2 ; drawmode 
       fcb 47,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(23,81)->(35,79)
       fcb 2 ; drawmode 
       fcb -33,12 ; starx/y relative to previous node
       fdb 8,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:8|rel:8)
; node # 3 D(43,62)->(85,69)
       fcb 2 ; drawmode 
       fcb 19,20 ; starx/y relative to previous node
       fdb -37,128 ; dx/dy. dx(abs:179|rel:128) dy(abs:-29|rel:-37)
; node # 4 D(42,46)->(90,50)
       fcb 2 ; drawmode 
       fcb 16,-1 ; starx/y relative to previous node
       fdb 12,25 ; dx/dy. dx(abs:204|rel:25) dy(abs:-17|rel:12)
; node # 5 D(55,37)->(108,44)
       fcb 2 ; drawmode 
       fcb 9,13 ; starx/y relative to previous node
       fdb -12,22 ; dx/dy. dx(abs:226|rel:22) dy(abs:-29|rel:-12)
; node # 6 D(72,48)->(122,55)
       fcb 2 ; drawmode 
       fcb -11,17 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:213|rel:-13) dy(abs:-29|rel:0)
; node # 7 D(60,77)->(115,78)
       fcb 2 ; drawmode 
       fcb -29,-12 ; starx/y relative to previous node
       fdb 25,21 ; dx/dy. dx(abs:234|rel:21) dy(abs:-4|rel:25)
; node # 8 D(25,107)->(29,117)
       fcb 2 ; drawmode 
       fcb -30,-35 ; starx/y relative to previous node
       fdb -38,-217 ; dx/dy. dx(abs:17|rel:-217) dy(abs:-42|rel:-38)
; node # 9 D(13,93)->(13,93)
       fcb 2 ; drawmode 
       fcb 14,-12 ; starx/y relative to previous node
       fdb 42,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:0|rel:42)
; node # 10 DM(10,116)->(14,116)
       fcb -1 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:0|rel:0)
; node # 11 M(-71,115)->(-71,115)
       fcb 0 ; drawmode 
       fcb 1,-81 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:0|rel:0)
; node # 12 DM(-74,88)->(-74,88)
       fcb -1 ; drawmode 
       fcb 27,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-82,88)->(-90,85)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 12,-34 ; dx/dy. dx(abs:-34|rel:-34) dy(abs:12|rel:12)
; node # 14 D(-92,35)->(-95,35)
       fcb 2 ; drawmode 
       fcb 53,-10 ; starx/y relative to previous node
       fdb -12,22 ; dx/dy. dx(abs:-12|rel:22) dy(abs:0|rel:-12)
; node # 15 D(-81,-10)->(-70,-7)
       fcb 2 ; drawmode 
       fcb 45,11 ; starx/y relative to previous node
       fdb -12,58 ; dx/dy. dx(abs:46|rel:58) dy(abs:-12|rel:-12)
; node # 16 D(-67,-20)->(-55,-15)
       fcb 2 ; drawmode 
       fcb 10,14 ; starx/y relative to previous node
       fdb -9,5 ; dx/dy. dx(abs:51|rel:5) dy(abs:-21|rel:-9)
; node # 17 D(-48,-7)->(-39,-6)
       fcb 2 ; drawmode 
       fcb -13,19 ; starx/y relative to previous node
       fdb 17,-13 ; dx/dy. dx(abs:38|rel:-13) dy(abs:-4|rel:17)
; node # 18 D(-40,29)->(-19,20)
       fcb 2 ; drawmode 
       fcb -36,8 ; starx/y relative to previous node
       fdb 42,51 ; dx/dy. dx(abs:89|rel:51) dy(abs:38|rel:42)
; node # 19 D(-29,24)->(-11,17)
       fcb 2 ; drawmode 
       fcb 5,11 ; starx/y relative to previous node
       fdb -9,-13 ; dx/dy. dx(abs:76|rel:-13) dy(abs:29|rel:-9)
; node # 20 D(-42,-11)->(-34,-10)
       fcb 2 ; drawmode 
       fcb 35,-13 ; starx/y relative to previous node
       fdb -33,-42 ; dx/dy. dx(abs:34|rel:-42) dy(abs:-4|rel:-33)
; node # 21 D(-59,-23)->(-50,-18)
       fcb 2 ; drawmode 
       fcb 12,-17 ; starx/y relative to previous node
       fdb -17,4 ; dx/dy. dx(abs:38|rel:4) dy(abs:-21|rel:-17)
; node # 22 D(-37,-29)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 6,22 ; starx/y relative to previous node
       fdb 50,-34 ; dx/dy. dx(abs:4|rel:-34) dy(abs:29|rel:50)
; node # 23 D(-49,-41)->(-43,-81)
       fcb 2 ; drawmode 
       fcb 12,-12 ; starx/y relative to previous node
       fdb 141,21 ; dx/dy. dx(abs:25|rel:21) dy(abs:170|rel:141)
; node # 24 D(-58,-69)->(-37,-104)
       fcb 2 ; drawmode 
       fcb 28,-9 ; starx/y relative to previous node
       fdb -21,64 ; dx/dy. dx(abs:89|rel:64) dy(abs:149|rel:-21)
; node # 25 D(-52,-96)->(-29,-110)
       fcb 2 ; drawmode 
       fcb 27,6 ; starx/y relative to previous node
       fdb -90,9 ; dx/dy. dx(abs:98|rel:9) dy(abs:59|rel:-90)
; node # 26 D(-32,-112)->(-7,-115)
       fcb 2 ; drawmode 
       fcb 16,20 ; starx/y relative to previous node
       fdb -47,8 ; dx/dy. dx(abs:106|rel:8) dy(abs:12|rel:-47)
; node # 27 D(0,-109)->(7,-113)
       fcb 2 ; drawmode 
       fcb -3,32 ; starx/y relative to previous node
       fdb 5,-77 ; dx/dy. dx(abs:29|rel:-77) dy(abs:17|rel:5)
; node # 28 D(18,-95)->(20,-110)
       fcb 2 ; drawmode 
       fcb -14,18 ; starx/y relative to previous node
       fdb 47,-21 ; dx/dy. dx(abs:8|rel:-21) dy(abs:64|rel:47)
; node # 29 D(17,-67)->(40,-84)
       fcb 2 ; drawmode 
       fcb -28,-1 ; starx/y relative to previous node
       fdb 8,90 ; dx/dy. dx(abs:98|rel:90) dy(abs:72|rel:8)
; node # 30 D(7,-45)->(34,-63)
       fcb 2 ; drawmode 
       fcb -22,-10 ; starx/y relative to previous node
       fdb 4,17 ; dx/dy. dx(abs:115|rel:17) dy(abs:76|rel:4)
; node # 31 D(11,-71)->(27,-80)
       fcb 2 ; drawmode 
       fcb 26,4 ; starx/y relative to previous node
       fdb -38,-47 ; dx/dy. dx(abs:68|rel:-47) dy(abs:38|rel:-38)
; node # 32 D(1,-84)->(9,-86)
       fcb 2 ; drawmode 
       fcb 13,-10 ; starx/y relative to previous node
       fdb -30,-34 ; dx/dy. dx(abs:34|rel:-34) dy(abs:8|rel:-30)
; node # 33 D(-22,-87)->(-7,-78)
       fcb 2 ; drawmode 
       fcb 3,-23 ; starx/y relative to previous node
       fdb -46,30 ; dx/dy. dx(abs:64|rel:30) dy(abs:-38|rel:-46)
; node # 34 D(-36,-81)->(-16,-48)
       fcb 2 ; drawmode 
       fcb -6,-14 ; starx/y relative to previous node
       fdb -102,21 ; dx/dy. dx(abs:85|rel:21) dy(abs:-140|rel:-102)
; node # 35 D(-41,-72)->(-26,-74)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 148,-21 ; dx/dy. dx(abs:64|rel:-21) dy(abs:8|rel:148)
; node # 36 D(-42,-59)->(-30,-71)
       fcb 2 ; drawmode 
       fcb -13,-1 ; starx/y relative to previous node
       fdb 43,-13 ; dx/dy. dx(abs:51|rel:-13) dy(abs:51|rel:43)
; node # 37 D(-36,-27)->(-27,-52)
       fcb 2 ; drawmode 
       fcb -32,6 ; starx/y relative to previous node
       fdb 55,-13 ; dx/dy. dx(abs:38|rel:-13) dy(abs:106|rel:55)
; node # 38 M(-42,-33)->(-17,-32)
       fcb 0 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb -110,68 ; dx/dy. dx(abs:106|rel:68) dy(abs:-4|rel:-110)
; node # 39 D(-23,-15)->(5,-14)
       fcb 2 ; drawmode 
       fcb -18,19 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:119|rel:13) dy(abs:-4|rel:0)
; node # 40 D(-4,-18)->(17,-17)
       fcb 2 ; drawmode 
       fcb 3,19 ; starx/y relative to previous node
       fdb 0,-30 ; dx/dy. dx(abs:89|rel:-30) dy(abs:-4|rel:0)
; node # 41 D(3,-31)->(22,-31)
       fcb 2 ; drawmode 
       fcb 13,7 ; starx/y relative to previous node
       fdb 4,-8 ; dx/dy. dx(abs:81|rel:-8) dy(abs:0|rel:4)
; node # 42 D(-13,-28)->(14,-28)
       fcb 2 ; drawmode 
       fcb -3,-16 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:115|rel:34) dy(abs:0|rel:0)
; node # 43 D(-25,-31)->(4,-33)
       fcb 2 ; drawmode 
       fcb 3,-12 ; starx/y relative to previous node
       fdb 8,8 ; dx/dy. dx(abs:123|rel:8) dy(abs:8|rel:8)
; node # 44 D(-12,-34)->(15,-35)
       fcb 2 ; drawmode 
       fcb 3,13 ; starx/y relative to previous node
       fdb -4,-8 ; dx/dy. dx(abs:115|rel:-8) dy(abs:4|rel:-4)
; node # 45 D(-3,-31)->(22,-32)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb 0,-9 ; dx/dy. dx(abs:106|rel:-9) dy(abs:4|rel:0)
; node # 46 D(2,-30)->(30,-51)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb 85,13 ; dx/dy. dx(abs:119|rel:13) dy(abs:89|rel:85)
; node # 47 D(9,-62)->(30,-55)
       fcb 2 ; drawmode 
       fcb 32,7 ; starx/y relative to previous node
       fdb -118,-30 ; dx/dy. dx(abs:89|rel:-30) dy(abs:-29|rel:-118)
; node # 48 D(0,-61)->(26,-55)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 4,21 ; dx/dy. dx(abs:110|rel:21) dy(abs:-25|rel:4)
; node # 49 D(-6,-63)->(23,-59)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 8,13 ; dx/dy. dx(abs:123|rel:13) dy(abs:-17|rel:8)
; node # 50 D(0,-66)->(31,-59)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb -12,9 ; dx/dy. dx(abs:132|rel:9) dy(abs:-29|rel:-12)
; node # 51 D(11,-61)->(33,-62)
       fcb 2 ; drawmode 
       fcb -5,11 ; starx/y relative to previous node
       fdb 33,-39 ; dx/dy. dx(abs:93|rel:-39) dy(abs:4|rel:33)
; node # 52 D(6,-67)->(26,-64)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb -16,-8 ; dx/dy. dx(abs:85|rel:-8) dy(abs:-12|rel:-16)
; node # 53 D(-2,-69)->(34,-66)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:153|rel:68) dy(abs:-12|rel:0)
; node # 54 M(-17,-68)->(19,-66)
       fcb 0 ; drawmode 
       fcb -1,-15 ; starx/y relative to previous node
       fdb 4,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-8|rel:4)
; node # 55 D(-27,-71)->(12,-70)
       fcb 2 ; drawmode 
       fcb 3,-10 ; starx/y relative to previous node
       fdb 4,13 ; dx/dy. dx(abs:166|rel:13) dy(abs:-4|rel:4)
; node # 56 D(-37,-69)->(1,-72)
       fcb 2 ; drawmode 
       fcb -2,-10 ; starx/y relative to previous node
       fdb 16,-4 ; dx/dy. dx(abs:162|rel:-4) dy(abs:12|rel:16)
; node # 57 M(-27,-67)->(9,-65)
       fcb 0 ; drawmode 
       fcb -2,10 ; starx/y relative to previous node
       fdb -20,-9 ; dx/dy. dx(abs:153|rel:-9) dy(abs:-8|rel:-20)
; node # 58 D(-35,-64)->(0,-65)
       fcb 2 ; drawmode 
       fcb -3,-8 ; starx/y relative to previous node
       fdb 12,-4 ; dx/dy. dx(abs:149|rel:-4) dy(abs:4|rel:12)
; node # 59 D(-26,-61)->(4,-61)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb -4,-21 ; dx/dy. dx(abs:128|rel:-21) dy(abs:0|rel:-4)
; node # 60 D(-18,-63)->(12,-60)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:-12|rel:-12)
; node # 61 D(-28,-67)->(10,-64)
       fcb 2 ; drawmode 
       fcb 4,-10 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:162|rel:34) dy(abs:-12|rel:0)
; node # 62 M(-12,-60)->(11,-49)
       fcb 0 ; drawmode 
       fcb -7,16 ; starx/y relative to previous node
       fdb -34,-64 ; dx/dy. dx(abs:98|rel:-64) dy(abs:-46|rel:-34)
; node # 63 D(-15,-51)->(8,-47)
       fcb 2 ; drawmode 
       fcb -9,-3 ; starx/y relative to previous node
       fdb 29,0 ; dx/dy. dx(abs:98|rel:0) dy(abs:-17|rel:29)
; node # 64 D(-18,-42)->(9,-43)
       fcb 2 ; drawmode 
       fcb -9,-3 ; starx/y relative to previous node
       fdb 21,17 ; dx/dy. dx(abs:115|rel:17) dy(abs:4|rel:21)
; node # 65 D(-13,-44)->(14,-44)
       fcb 2 ; drawmode 
       fcb 2,5 ; starx/y relative to previous node
       fdb -4,0 ; dx/dy. dx(abs:115|rel:0) dy(abs:0|rel:-4)
; node # 66 D(-10,-41)->(18,-40)
       fcb 2 ; drawmode 
       fcb -3,3 ; starx/y relative to previous node
       fdb -4,4 ; dx/dy. dx(abs:119|rel:4) dy(abs:-4|rel:-4)
; node # 67 D(-5,-42)->(22,-41)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 0,-4 ; dx/dy. dx(abs:115|rel:-4) dy(abs:-4|rel:0)
; node # 68 D(-8,-55)->(21,-60)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 25,8 ; dx/dy. dx(abs:123|rel:8) dy(abs:21|rel:25)
; node # 69 M(-48,34)->(-50,31)
       fcb 0 ; drawmode 
       fcb -89,-40 ; starx/y relative to previous node
       fdb -9,-131 ; dx/dy. dx(abs:-8|rel:-131) dy(abs:12|rel:-9)
; node # 70 D(21,-3)->(25,6)
       fcb 2 ; drawmode 
       fcb 37,69 ; starx/y relative to previous node
       fdb -50,25 ; dx/dy. dx(abs:17|rel:25) dy(abs:-38|rel:-50)
; node # 71 D(28,-25)->(46,-56)
       fcb 2 ; drawmode 
       fcb 22,7 ; starx/y relative to previous node
       fdb 170,59 ; dx/dy. dx(abs:76|rel:59) dy(abs:132|rel:170)
; node # 72 D(33,-27)->(56,-56)
       fcb 2 ; drawmode 
       fcb 2,5 ; starx/y relative to previous node
       fdb -9,22 ; dx/dy. dx(abs:98|rel:22) dy(abs:123|rel:-9)
; node # 73 D(41,-27)->(48,-28)
       fcb 2 ; drawmode 
       fcb 0,8 ; starx/y relative to previous node
       fdb -119,-69 ; dx/dy. dx(abs:29|rel:-69) dy(abs:4|rel:-119)
; node # 74 D(44,-28)->(76,-77)
       fcb 2 ; drawmode 
       fcb 1,3 ; starx/y relative to previous node
       fdb 205,107 ; dx/dy. dx(abs:136|rel:107) dy(abs:209|rel:205)
; node # 75 D(49,-27)->(85,-74)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb -9,17 ; dx/dy. dx(abs:153|rel:17) dy(abs:200|rel:-9)
; node # 76 D(54,-26)->(62,-29)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb -188,-119 ; dx/dy. dx(abs:34|rel:-119) dy(abs:12|rel:-188)
; node # 77 D(56,-27)->(93,-74)
       fcb 2 ; drawmode 
       fcb 1,2 ; starx/y relative to previous node
       fdb 188,123 ; dx/dy. dx(abs:157|rel:123) dy(abs:200|rel:188)
; node # 78 D(63,-25)->(101,-65)
       fcb 2 ; drawmode 
       fcb -2,7 ; starx/y relative to previous node
       fdb -30,5 ; dx/dy. dx(abs:162|rel:5) dy(abs:170|rel:-30)
; node # 79 D(67,-20)->(69,-20)
       fcb 2 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb -170,-154 ; dx/dy. dx(abs:8|rel:-154) dy(abs:0|rel:-170)
; node # 80 D(69,-16)->(104,-60)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 187,141 ; dx/dy. dx(abs:149|rel:141) dy(abs:187|rel:187)
; node # 81 D(75,-6)->(109,-51)
       fcb 2 ; drawmode 
       fcb -10,6 ; starx/y relative to previous node
       fdb 5,-4 ; dx/dy. dx(abs:145|rel:-4) dy(abs:192|rel:5)
; node # 82 D(67,5)->(74,5)
       fcb 2 ; drawmode 
       fcb -11,-8 ; starx/y relative to previous node
       fdb -192,-116 ; dx/dy. dx(abs:29|rel:-116) dy(abs:0|rel:-192)
; node # 83 D(75,-3)->(105,-2)
       fcb 2 ; drawmode 
       fcb 8,8 ; starx/y relative to previous node
       fdb -4,99 ; dx/dy. dx(abs:128|rel:99) dy(abs:-4|rel:-4)
; node # 84 D(64,10)->(108,11)
       fcb 2 ; drawmode 
       fcb -13,-11 ; starx/y relative to previous node
       fdb 0,59 ; dx/dy. dx(abs:187|rel:59) dy(abs:-4|rel:0)
; node # 85 D(29,38)->(29,38)
       fcb 2 ; drawmode 
       fcb -28,-35 ; starx/y relative to previous node
       fdb 4,-187 ; dx/dy. dx(abs:0|rel:-187) dy(abs:0|rel:4)
; node # 86 D(-73,88)->(-73,88)
       fcb 2 ; drawmode 
       fcb -50,-102 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 M(0,7)->(-6,14)
       fcb 0 ; drawmode 
       fcb 81,73 ; starx/y relative to previous node
       fdb -29,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-29|rel:-29)
; node # 88 D(-6,-16)->(3,-14)
       fcb 2 ; drawmode 
       fcb 23,-6 ; starx/y relative to previous node
       fdb 21,63 ; dx/dy. dx(abs:38|rel:63) dy(abs:-8|rel:21)
       fcb  1  ; end of anim
; Animation 1
bruceframe1:
       fcb 60 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(13,95)->(13,95)
       fcb 0 ; drawmode 
       fcb -95,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(11,48)->(11,50)
       fcb 2 ; drawmode 
       fcb 47,-2 ; starx/y relative to previous node
       fdb -8,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-8|rel:-8)
; node # 2 D(35,79)->(35,79)
       fcb 2 ; drawmode 
       fcb -31,24 ; starx/y relative to previous node
       fdb 8,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:8)
; node # 3 D(85,69)->(63,58)
       fcb 2 ; drawmode 
       fcb 10,50 ; starx/y relative to previous node
       fdb 46,-93 ; dx/dy. dx(abs:-93|rel:-93) dy(abs:46|rel:46)
; node # 4 D(90,50)->(67,37)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 9,-5 ; dx/dy. dx(abs:-98|rel:-5) dy(abs:55|rel:9)
; node # 5 D(108,44)->(86,28)
       fcb 2 ; drawmode 
       fcb 6,18 ; starx/y relative to previous node
       fdb 13,5 ; dx/dy. dx(abs:-93|rel:5) dy(abs:68|rel:13)
; node # 6 D(122,55)->(99,40)
       fcb 2 ; drawmode 
       fcb -11,14 ; starx/y relative to previous node
       fdb -4,-5 ; dx/dy. dx(abs:-98|rel:-5) dy(abs:64|rel:-4)
; node # 7 D(115,78)->(96,60)
       fcb 2 ; drawmode 
       fcb -23,-7 ; starx/y relative to previous node
       fdb 12,17 ; dx/dy. dx(abs:-81|rel:17) dy(abs:76|rel:12)
; node # 8 D(29,117)->(29,117)
       fcb 2 ; drawmode 
       fcb -39,-86 ; starx/y relative to previous node
       fdb -76,81 ; dx/dy. dx(abs:0|rel:81) dy(abs:0|rel:-76)
; node # 9 D(13,93)->(13,93)
       fcb 2 ; drawmode 
       fcb 24,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(14,116)->(14,116)
       fcb -1 ; drawmode 
       fcb -23,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 M(-71,115)->(-71,115)
       fcb 0 ; drawmode 
       fcb 1,-85 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 DM(-74,88)->(-43,87)
       fcb -1 ; drawmode 
       fcb 27,-3 ; starx/y relative to previous node
       fdb 4,132 ; dx/dy. dx(abs:132|rel:132) dy(abs:4|rel:4)
; node # 13 D(-90,85)->(-76,100)
       fcb 2 ; drawmode 
       fcb 3,-16 ; starx/y relative to previous node
       fdb -68,-73 ; dx/dy. dx(abs:59|rel:-73) dy(abs:-64|rel:-68)
; node # 14 D(-95,35)->(-88,42)
       fcb 2 ; drawmode 
       fcb 50,-5 ; starx/y relative to previous node
       fdb 35,-30 ; dx/dy. dx(abs:29|rel:-30) dy(abs:-29|rel:35)
; node # 15 D(-70,-7)->(-70,-7)
       fcb 2 ; drawmode 
       fcb 42,25 ; starx/y relative to previous node
       fdb 29,-29 ; dx/dy. dx(abs:0|rel:-29) dy(abs:0|rel:29)
; node # 16 D(-55,-15)->(-55,-15)
       fcb 2 ; drawmode 
       fcb 8,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-39,-6)->(-39,-6)
       fcb 2 ; drawmode 
       fcb -9,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-19,20)->(-15,25)
       fcb 2 ; drawmode 
       fcb -26,20 ; starx/y relative to previous node
       fdb -21,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:-21|rel:-21)
; node # 19 D(-11,17)->(-7,21)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb 4,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:-17|rel:4)
; node # 20 D(-34,-10)->(-34,-10)
       fcb 2 ; drawmode 
       fcb 27,-23 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:0|rel:17)
; node # 21 D(-50,-18)->(-50,-18)
       fcb 2 ; drawmode 
       fcb 8,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-36,-36)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 18,14 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:-17|rel:-17)
; node # 23 D(-43,-81)->(-42,-78)
       fcb 2 ; drawmode 
       fcb 45,-7 ; starx/y relative to previous node
       fdb 5,-13 ; dx/dy. dx(abs:4|rel:-13) dy(abs:-12|rel:5)
; node # 24 D(-37,-104)->(-38,-95)
       fcb 2 ; drawmode 
       fcb 23,6 ; starx/y relative to previous node
       fdb -26,-8 ; dx/dy. dx(abs:-4|rel:-8) dy(abs:-38|rel:-26)
; node # 25 D(-29,-110)->(-25,-109)
       fcb 2 ; drawmode 
       fcb 6,8 ; starx/y relative to previous node
       fdb 34,21 ; dx/dy. dx(abs:17|rel:21) dy(abs:-4|rel:34)
; node # 26 D(-7,-115)->(-7,-115)
       fcb 2 ; drawmode 
       fcb 5,22 ; starx/y relative to previous node
       fdb 4,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:0|rel:4)
; node # 27 D(7,-113)->(7,-113)
       fcb 2 ; drawmode 
       fcb -2,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(20,-110)->(24,-109)
       fcb 2 ; drawmode 
       fcb -3,13 ; starx/y relative to previous node
       fdb -4,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:-4|rel:-4)
; node # 29 D(40,-84)->(40,-87)
       fcb 2 ; drawmode 
       fcb -26,20 ; starx/y relative to previous node
       fdb 16,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:12|rel:16)
; node # 30 D(34,-63)->(34,-63)
       fcb 2 ; drawmode 
       fcb -21,-6 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-12)
; node # 31 D(27,-80)->(27,-80)
       fcb 2 ; drawmode 
       fcb 17,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(9,-86)->(9,-86)
       fcb 2 ; drawmode 
       fcb 6,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-7,-78)->(-7,-78)
       fcb 2 ; drawmode 
       fcb -8,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(-16,-48)->(-14,-45)
       fcb 2 ; drawmode 
       fcb -30,-9 ; starx/y relative to previous node
       fdb -12,8 ; dx/dy. dx(abs:8|rel:8) dy(abs:-12|rel:-12)
; node # 35 D(-26,-74)->(-24,-74)
       fcb 2 ; drawmode 
       fcb 26,-10 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:8|rel:0) dy(abs:0|rel:12)
; node # 36 D(-30,-71)->(-30,-71)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 0,-8 ; dx/dy. dx(abs:0|rel:-8) dy(abs:0|rel:0)
; node # 37 D(-27,-52)->(-27,-52)
       fcb 2 ; drawmode 
       fcb -19,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 M(-17,-32)->(-17,-32)
       fcb 0 ; drawmode 
       fcb -20,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(5,-14)->(5,-14)
       fcb 2 ; drawmode 
       fcb -18,22 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(17,-17)->(17,-17)
       fcb 2 ; drawmode 
       fcb 3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(22,-31)->(22,-31)
       fcb 2 ; drawmode 
       fcb 14,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(14,-28)->(14,-28)
       fcb 2 ; drawmode 
       fcb -3,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(4,-33)->(3,-38)
       fcb 2 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb 21,-4 ; dx/dy. dx(abs:-4|rel:-4) dy(abs:21|rel:21)
; node # 44 D(15,-35)->(15,-32)
       fcb 2 ; drawmode 
       fcb 2,11 ; starx/y relative to previous node
       fdb -33,4 ; dx/dy. dx(abs:0|rel:4) dy(abs:-12|rel:-33)
; node # 45 D(22,-32)->(22,-32)
       fcb 2 ; drawmode 
       fcb -3,7 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:12)
; node # 46 D(30,-51)->(30,-51)
       fcb 2 ; drawmode 
       fcb 19,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 D(30,-55)->(30,-55)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 48 D(26,-55)->(26,-55)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(23,-59)->(23,-59)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(31,-59)->(31,-59)
       fcb 2 ; drawmode 
       fcb 0,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(33,-62)->(33,-62)
       fcb 2 ; drawmode 
       fcb 3,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 D(26,-64)->(26,-64)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(34,-66)->(34,-66)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 M(19,-66)->(19,-66)
       fcb 0 ; drawmode 
       fcb 0,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(12,-70)->(12,-70)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(1,-72)->(1,-72)
       fcb 2 ; drawmode 
       fcb 2,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 M(9,-65)->(9,-65)
       fcb 0 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(0,-65)->(0,-65)
       fcb 2 ; drawmode 
       fcb 0,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(4,-61)->(4,-61)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(12,-60)->(12,-60)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(10,-64)->(10,-64)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 M(11,-49)->(11,-49)
       fcb 0 ; drawmode 
       fcb -15,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 D(8,-47)->(8,-47)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(9,-43)->(9,-43)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 D(14,-44)->(14,-44)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 D(18,-40)->(18,-40)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 D(22,-41)->(22,-41)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 D(21,-60)->(21,-60)
       fcb 2 ; drawmode 
       fcb 19,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 69 M(-50,31)->(-42,37)
       fcb 0 ; drawmode 
       fcb -91,-71 ; starx/y relative to previous node
       fdb -25,34 ; dx/dy. dx(abs:34|rel:34) dy(abs:-25|rel:-25)
; node # 70 D(25,6)->(25,6)
       fcb 2 ; drawmode 
       fcb 25,75 ; starx/y relative to previous node
       fdb 25,-34 ; dx/dy. dx(abs:0|rel:-34) dy(abs:0|rel:25)
; node # 71 D(46,-56)->(42,-45)
       fcb 2 ; drawmode 
       fcb 62,21 ; starx/y relative to previous node
       fdb -46,-17 ; dx/dy. dx(abs:-17|rel:-17) dy(abs:-46|rel:-46)
; node # 72 D(56,-56)->(53,-48)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 12,5 ; dx/dy. dx(abs:-12|rel:5) dy(abs:-34|rel:12)
; node # 73 D(48,-28)->(48,-28)
       fcb 2 ; drawmode 
       fcb -28,-8 ; starx/y relative to previous node
       fdb 34,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:34)
; node # 74 D(76,-77)->(57,-46)
       fcb 2 ; drawmode 
       fcb 49,28 ; starx/y relative to previous node
       fdb -132,-81 ; dx/dy. dx(abs:-81|rel:-81) dy(abs:-132|rel:-132)
; node # 75 D(85,-74)->(66,-41)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb -8,0 ; dx/dy. dx(abs:-81|rel:0) dy(abs:-140|rel:-8)
; node # 76 D(62,-29)->(62,-29)
       fcb 2 ; drawmode 
       fcb -45,-23 ; starx/y relative to previous node
       fdb 140,81 ; dx/dy. dx(abs:0|rel:81) dy(abs:0|rel:140)
; node # 77 D(93,-74)->(88,-64)
       fcb 2 ; drawmode 
       fcb 45,31 ; starx/y relative to previous node
       fdb -42,-21 ; dx/dy. dx(abs:-21|rel:-21) dy(abs:-42|rel:-42)
; node # 78 D(101,-65)->(98,-56)
       fcb 2 ; drawmode 
       fcb -9,8 ; starx/y relative to previous node
       fdb 4,9 ; dx/dy. dx(abs:-12|rel:9) dy(abs:-38|rel:4)
; node # 79 D(69,-20)->(69,-18)
       fcb 2 ; drawmode 
       fcb -45,-32 ; starx/y relative to previous node
       fdb 30,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-8|rel:30)
; node # 80 D(104,-60)->(81,-28)
       fcb 2 ; drawmode 
       fcb 40,35 ; starx/y relative to previous node
       fdb -128,-98 ; dx/dy. dx(abs:-98|rel:-98) dy(abs:-136|rel:-128)
; node # 81 D(109,-51)->(86,-19)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-98|rel:0) dy(abs:-136|rel:0)
; node # 82 D(74,5)->(71,1)
       fcb 2 ; drawmode 
       fcb -56,-35 ; starx/y relative to previous node
       fdb 153,86 ; dx/dy. dx(abs:-12|rel:86) dy(abs:17|rel:153)
; node # 83 D(105,-2)->(82,-5)
       fcb 2 ; drawmode 
       fcb 7,31 ; starx/y relative to previous node
       fdb -5,-86 ; dx/dy. dx(abs:-98|rel:-86) dy(abs:12|rel:-5)
; node # 84 D(108,11)->(79,9)
       fcb 2 ; drawmode 
       fcb -13,3 ; starx/y relative to previous node
       fdb -4,-25 ; dx/dy. dx(abs:-123|rel:-25) dy(abs:8|rel:-4)
; node # 85 D(29,38)->(29,38)
       fcb 2 ; drawmode 
       fcb -27,-79 ; starx/y relative to previous node
       fdb -8,123 ; dx/dy. dx(abs:0|rel:123) dy(abs:0|rel:-8)
; node # 86 D(-73,88)->(-44,87)
       fcb 2 ; drawmode 
       fcb -50,-102 ; starx/y relative to previous node
       fdb 4,123 ; dx/dy. dx(abs:123|rel:123) dy(abs:4|rel:4)
; node # 87 M(-6,14)->(5,15)
       fcb 0 ; drawmode 
       fcb 74,67 ; starx/y relative to previous node
       fdb -8,-77 ; dx/dy. dx(abs:46|rel:-77) dy(abs:-4|rel:-8)
; node # 88 D(3,-14)->(3,-14)
       fcb 2 ; drawmode 
       fcb 28,9 ; starx/y relative to previous node
       fdb 4,-46 ; dx/dy. dx(abs:0|rel:-46) dy(abs:0|rel:4)
       fcb  1  ; end of anim
