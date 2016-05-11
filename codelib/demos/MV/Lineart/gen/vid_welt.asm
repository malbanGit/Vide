weltframecount equ 24 ; number of animations
weltframetotal equ 192 ; total number of frames in animation 
; index table 
weltframetab        fdb weltframe0
       fdb weltframe1
       fdb weltframe2
       fdb weltframe3
       fdb weltframe4
       fdb weltframe5
       fdb weltframe6
       fdb weltframe7
       fdb weltframe8
       fdb weltframe9
       fdb weltframe10
       fdb weltframe11
       fdb weltframe12
       fdb weltframe13
       fdb weltframe14
       fdb weltframe15
       fdb weltframe16
       fdb weltframe17
       fdb weltframe18
       fdb weltframe19
       fdb weltframe20
       fdb weltframe21
       fdb weltframe22
       fdb weltframe23

; Animation 0
weltframe0:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-1,-54)->(-38,-54)
       fcb 0 ; drawmode 
       fcb 54,-1 ; starx/y relative to previous node
       fdb 0,-1184 ; dx/dy. dx(abs:-1184|rel:-1184) dy(abs:0|rel:0)
; node # 1 D(-27,-58)->(-58,-58)
       fcb 2 ; drawmode 
       fcb 4,-26 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-992|rel:192) dy(abs:0|rel:0)
; node # 2 D(-31,-52)->(-63,-52)
       fcb 2 ; drawmode 
       fcb -6,-4 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:0|rel:0)
; node # 3 D(-49,-60)->(-76,-60)
       fcb 2 ; drawmode 
       fcb 8,-18 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-864|rel:160) dy(abs:0|rel:0)
; node # 4 D(-49,-68)->(-75,-67)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-832|rel:32) dy(abs:-32|rel:-32)
; node # 5 D(-76,-63)->(-97,-61)
       fcb 2 ; drawmode 
       fcb -5,-27 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-672|rel:160) dy(abs:-64|rel:-32)
; node # 6 D(-95,-43)->(-112,-43)
       fcb 2 ; drawmode 
       fcb -20,-19 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-544|rel:128) dy(abs:0|rel:64)
; node # 7 D(-103,-28)->(-119,-28)
       fcb 2 ; drawmode 
       fcb -15,-8 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-512|rel:32) dy(abs:0|rel:0)
; node # 8 D(-106,-5)->(-122,-4)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-512|rel:0) dy(abs:-32|rel:-32)
; node # 9 D(-93,16)->(-113,15)
       fcb 2 ; drawmode 
       fcb -21,13 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-640|rel:-128) dy(abs:32|rel:64)
; node # 10 D(-73,11)->(-100,11)
       fcb 2 ; drawmode 
       fcb 5,20 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-864|rel:-224) dy(abs:0|rel:-32)
; node # 11 D(-57,19)->(-87,17)
       fcb 2 ; drawmode 
       fcb -8,16 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:64|rel:64)
; node # 12 D(-56,33)->(-85,33)
       fcb 2 ; drawmode 
       fcb -14,1 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:0|rel:-64)
; node # 13 D(-46,45)->(-75,48)
       fcb 2 ; drawmode 
       fcb -12,10 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:-96|rel:-96)
; node # 14 D(-44,69)->(-70,72)
       fcb 2 ; drawmode 
       fcb -24,2 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-832|rel:96) dy(abs:-96|rel:0)
; node # 15 D(-20,106)->(-44,103)
       fcb 2 ; drawmode 
       fcb -37,24 ; starx/y relative to previous node
       fdb 192,64 ; dx/dy. dx(abs:-768|rel:64) dy(abs:96|rel:192)
; node # 16 D(-8,103)->(-34,103)
       fcb 2 ; drawmode 
       fcb 3,12 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:0|rel:-96)
; node # 17 D(0,91)->(-26,88)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:96|rel:96)
; node # 18 D(6,86)->(-22,86)
       fcb 2 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-896|rel:-64) dy(abs:0|rel:-96)
; node # 19 D(4,79)->(-26,78)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-960|rel:-64) dy(abs:32|rel:32)
; node # 20 D(19,67)->(-13,67)
       fcb 2 ; drawmode 
       fcb 12,15 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:0|rel:-32)
; node # 21 D(17,40)->(-18,43)
       fcb 2 ; drawmode 
       fcb 27,-2 ; starx/y relative to previous node
       fdb -96,-96 ; dx/dy. dx(abs:-1120|rel:-96) dy(abs:-96|rel:-96)
; node # 22 D(40,18)->(1,20)
       fcb 2 ; drawmode 
       fcb 22,23 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1248|rel:-128) dy(abs:-64|rel:32)
; node # 23 D(47,-1)->(11,0)
       fcb 2 ; drawmode 
       fcb 19,7 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1152|rel:96) dy(abs:-32|rel:32)
; node # 24 D(33,1)->(-6,0)
       fcb 2 ; drawmode 
       fcb -2,-14 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-1248|rel:-96) dy(abs:32|rel:64)
; node # 25 D(18,-13)->(-18,-12)
       fcb 2 ; drawmode 
       fcb 14,-15 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-1152|rel:96) dy(abs:-32|rel:-64)
; node # 26 D(-1,-54)->(-38,-54)
       fcb 2 ; drawmode 
       fcb 41,-19 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1184|rel:-32) dy(abs:0|rel:32)
; node # 27 M(38,61)->(6,62)
       fcb 0 ; drawmode 
       fcb -115,39 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-1024|rel:160) dy(abs:-32|rel:-32)
; node # 28 D(27,71)->(-5,71)
       fcb 2 ; drawmode 
       fcb -10,-11 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:32)
; node # 29 D(23,81)->(-8,84)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:-96|rel:-96)
; node # 30 D(24,90)->(-4,91)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:-32|rel:64)
; node # 31 D(38,61)->(6,62)
       fcb 2 ; drawmode 
       fcb 29,14 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1024|rel:-128) dy(abs:-32|rel:0)
; node # 32 M(64,-30)->(31,-31)
       fcb 0 ; drawmode 
       fcb 91,26 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:32|rel:64)
; node # 33 D(57,-18)->(22,-19)
       fcb 2 ; drawmode 
       fcb -12,-7 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1120|rel:-64) dy(abs:32|rel:0)
; node # 34 D(31,-7)->(-8,-8)
       fcb 2 ; drawmode 
       fcb -11,-26 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1248|rel:-128) dy(abs:32|rel:0)
; node # 35 D(4,-51)->(-30,-49)
       fcb 2 ; drawmode 
       fcb 44,-27 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-1088|rel:160) dy(abs:-64|rel:-96)
; node # 36 D(6,-68)->(-27,-67)
       fcb 2 ; drawmode 
       fcb 17,2 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:-32|rel:32)
; node # 37 D(-11,-68)->(-40,-67)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-928|rel:128) dy(abs:-32|rel:0)
; node # 38 D(-14,-74)->(-45,-73)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-992|rel:-64) dy(abs:-32|rel:0)
; node # 39 D(14,-79)->(-16,-79)
       fcb 2 ; drawmode 
       fcb 5,28 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:0|rel:32)
; node # 40 D(7,-91)->(-21,-91)
       fcb 2 ; drawmode 
       fcb 12,-7 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-896|rel:64) dy(abs:0|rel:0)
; node # 41 D(-12,-85)->(-41,-82)
       fcb 2 ; drawmode 
       fcb -6,-19 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-928|rel:-32) dy(abs:-96|rel:-96)
; node # 42 D(-13,-77)->(-41,-77)
       fcb 2 ; drawmode 
       fcb -8,-1 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:96)
; node # 43 D(-22,-76)->(-51,-76)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-928|rel:-32) dy(abs:0|rel:0)
; node # 44 D(-23,-69)->(-53,-68)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:-32|rel:-32)
; node # 45 D(-29,-79)->(-57,-79)
       fcb 2 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-896|rel:64) dy(abs:0|rel:32)
; node # 46 D(-38,-87)->(-63,-85)
       fcb 2 ; drawmode 
       fcb 8,-9 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:-64|rel:-64)
; node # 47 D(-41,-85)->(-65,-83)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:-64|rel:0)
; node # 48 D(-34,-77)->(-60,-76)
       fcb 2 ; drawmode 
       fcb -8,7 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:-32|rel:32)
; node # 49 D(-35,-71)->(-64,-72)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-928|rel:-96) dy(abs:32|rel:64)
; node # 50 D(-45,-84)->(-69,-82)
       fcb 2 ; drawmode 
       fcb 13,-10 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-768|rel:160) dy(abs:-64|rel:-96)
; node # 51 D(-63,-76)->(-85,-74)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:-64|rel:0)
; node # 52 D(-68,-68)->(-91,-66)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-736|rel:-32) dy(abs:-64|rel:0)
; node # 53 D(-80,-68)->(-98,-65)
       fcb 2 ; drawmode 
       fcb 0,-12 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-576|rel:160) dy(abs:-96|rel:-32)
; node # 54 D(-72,-80)->(-91,-80)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:0|rel:96)
; node # 55 D(-63,-81)->(-83,-79)
       fcb 2 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-640|rel:-32) dy(abs:-64|rel:-64)
; node # 56 D(-59,-91)->(-79,-89)
       fcb 2 ; drawmode 
       fcb 10,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-640|rel:0) dy(abs:-64|rel:0)
; node # 57 D(-39,-101)->(-59,-99)
       fcb 2 ; drawmode 
       fcb 10,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-640|rel:0) dy(abs:-64|rel:0)
; node # 58 D(-22,-102)->(-44,-102)
       fcb 2 ; drawmode 
       fcb 1,17 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:0|rel:64)
; node # 59 D(-11,-110)->(-31,-109)
       fcb 2 ; drawmode 
       fcb 8,11 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-640|rel:64) dy(abs:-32|rel:-32)
; node # 60 D(-19,-111)->(-37,-111)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:0|rel:32)
; node # 61 D(-29,-104)->(-52,-103)
       fcb 2 ; drawmode 
       fcb -7,-10 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:-736|rel:-160) dy(abs:-32|rel:-32)
; node # 62 D(-36,-111)->(-51,-111)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb 32,256 ; dx/dy. dx(abs:-480|rel:256) dy(abs:0|rel:32)
; node # 63 D(-12,-121)->(-30,-119)
       fcb 2 ; drawmode 
       fcb 10,24 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-576|rel:-96) dy(abs:-64|rel:-64)
; node # 64 D(0,-118)->(-17,-119)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-544|rel:32) dy(abs:32|rel:96)
; node # 65 D(-6,-117)->(-23,-117)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:0|rel:-32)
; node # 66 D(6,-118)->(-8,-119)
       fcb 2 ; drawmode 
       fcb 1,12 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-448|rel:96) dy(abs:32|rel:32)
; node # 67 D(51,-117)->(45,-118)
       fcb 2 ; drawmode 
       fcb -1,45 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:-192|rel:256) dy(abs:32|rel:0)
; node # 68 D(78,-102)->(62,-112)
       fcb 2 ; drawmode 
       fcb -15,27 ; starx/y relative to previous node
       fdb 288,-320 ; dx/dy. dx(abs:-512|rel:-320) dy(abs:320|rel:288)
; node # 69 D(98,-82)->(90,-92)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:-256|rel:256) dy(abs:320|rel:0)
; node # 70 D(107,-70)->(104,-69)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb -352,160 ; dx/dy. dx(abs:-96|rel:160) dy(abs:-32|rel:-352)
; node # 71 D(118,-49)->(116,-49)
       fcb 2 ; drawmode 
       fcb -21,11 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-64|rel:32) dy(abs:0|rel:32)
; node # 72 D(124,-31)->(121,-31)
       fcb 2 ; drawmode 
       fcb -18,6 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:0|rel:0)
; node # 73 D(126,-24)->(116,-24)
       fcb 2 ; drawmode 
       fcb -7,2 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-320|rel:-224) dy(abs:0|rel:0)
; node # 74 D(127,-10)->(120,-10)
       fcb 2 ; drawmode 
       fcb -14,1 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-224|rel:96) dy(abs:0|rel:0)
; node # 75 D(127,1)->(120,1)
       fcb 2 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-224|rel:0) dy(abs:0|rel:0)
; node # 76 M(127,11)->(125,11)
       fcb 0 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-64|rel:160) dy(abs:0|rel:0)
; node # 77 D(125,25)->(123,26)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-64|rel:0) dy(abs:-32|rel:-32)
; node # 78 D(122,34)->(119,34)
       fcb 2 ; drawmode 
       fcb -9,-3 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:0|rel:32)
; node # 79 D(125,24)->(120,24)
       fcb 2 ; drawmode 
       fcb 10,3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:0|rel:0)
; node # 80 D(127,11)->(125,11)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-64|rel:96) dy(abs:0|rel:0)
; node # 81 M(127,1)->(120,1)
       fcb 0 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-224|rel:-160) dy(abs:0|rel:0)
; node # 82 D(127,-5)->(113,-5)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-448|rel:-224) dy(abs:0|rel:0)
; node # 83 D(127,7)->(115,21)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb -448,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:-448|rel:-448)
; node # 84 D(126,7)->(112,20)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-448|rel:-64) dy(abs:-416|rel:32)
; node # 85 D(122,-15)->(108,-16)
       fcb 2 ; drawmode 
       fcb 22,-4 ; starx/y relative to previous node
       fdb 448,0 ; dx/dy. dx(abs:-448|rel:0) dy(abs:32|rel:448)
; node # 86 D(121,-12)->(105,-13)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-512|rel:-64) dy(abs:32|rel:0)
; node # 87 D(113,-29)->(94,-31)
       fcb 2 ; drawmode 
       fcb 17,-8 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:64|rel:32)
; node # 88 D(111,-23)->(89,-25)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:64|rel:0)
; node # 89 D(104,-12)->(80,-13)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-768|rel:-64) dy(abs:32|rel:-32)
; node # 90 D(105,1)->(80,1)
       fcb 2 ; drawmode 
       fcb -13,1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:0|rel:-32)
; node # 91 D(102,6)->(75,6)
       fcb 2 ; drawmode 
       fcb -5,-3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:0|rel:0)
; node # 92 D(90,-22)->(63,-21)
       fcb 2 ; drawmode 
       fcb 28,-12 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-864|rel:0) dy(abs:-32|rel:-32)
; node # 93 D(91,-30)->(62,-30)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:0|rel:32)
; node # 94 D(87,-26)->(55,-28)
       fcb 2 ; drawmode 
       fcb -4,-4 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:64|rel:64)
; node # 95 D(84,-32)->(55,-33)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-928|rel:96) dy(abs:32|rel:-32)
; node # 96 D(78,-39)->(45,-39)
       fcb 2 ; drawmode 
       fcb 7,-6 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-1056|rel:-128) dy(abs:0|rel:-32)
; node # 97 D(65,-39)->(25,-39)
       fcb 2 ; drawmode 
       fcb 0,-13 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-1280|rel:-224) dy(abs:0|rel:0)
; node # 98 D(56,-44)->(21,-43)
       fcb 2 ; drawmode 
       fcb 5,-9 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-1120|rel:160) dy(abs:-32|rel:-32)
; node # 99 D(49,-43)->(9,-46)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 128,-160 ; dx/dy. dx(abs:-1280|rel:-160) dy(abs:96|rel:128)
; node # 100 D(38,-53)->(3,-53)
       fcb 2 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-1120|rel:160) dy(abs:0|rel:-96)
; node # 101 D(34,-50)->(0,-50)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:0|rel:0)
; node # 102 D(43,-40)->(7,-39)
       fcb 2 ; drawmode 
       fcb -10,9 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1152|rel:-64) dy(abs:-32|rel:-32)
; node # 103 D(49,-36)->(17,-36)
       fcb 2 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:0|rel:32)
; node # 104 D(55,-41)->(20,-40)
       fcb 2 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1120|rel:-96) dy(abs:-32|rel:-32)
; node # 105 D(64,-29)->(30,-30)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:32|rel:64)
       fcb  1  ; end of anim
; Animation 1
weltframe1:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-38,-54)->(-69,-53)
       fcb 0 ; drawmode 
       fcb 54,-38 ; starx/y relative to previous node
       fdb -32,-992 ; dx/dy. dx(abs:-992|rel:-992) dy(abs:-32|rel:-32)
; node # 1 D(-58,-58)->(-85,-56)
       fcb 2 ; drawmode 
       fcb 4,-20 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-864|rel:128) dy(abs:-64|rel:-32)
; node # 2 D(-63,-52)->(-90,-51)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-864|rel:0) dy(abs:-32|rel:32)
; node # 3 D(-76,-60)->(-97,-56)
       fcb 2 ; drawmode 
       fcb 8,-13 ; starx/y relative to previous node
       fdb -96,192 ; dx/dy. dx(abs:-672|rel:192) dy(abs:-128|rel:-96)
; node # 4 D(-75,-67)->(-97,-65)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:-64|rel:64)
; node # 5 D(-97,-61)->(-111,-59)
       fcb 2 ; drawmode 
       fcb -6,-22 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:-448|rel:256) dy(abs:-64|rel:0)
; node # 6 D(-112,-43)->(-121,-42)
       fcb 2 ; drawmode 
       fcb -18,-15 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:-288|rel:160) dy(abs:-32|rel:32)
; node # 7 D(-119,-28)->(-125,-28)
       fcb 2 ; drawmode 
       fcb -15,-7 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-192|rel:96) dy(abs:0|rel:32)
; node # 8 D(-122,-4)->(-128,-5)
       fcb 2 ; drawmode 
       fcb -24,-3 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:32|rel:32)
; node # 9 D(-113,15)->(-125,15)
       fcb 2 ; drawmode 
       fcb -19,9 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-384|rel:-192) dy(abs:0|rel:-32)
; node # 10 D(-100,11)->(-117,11)
       fcb 2 ; drawmode 
       fcb 4,13 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-544|rel:-160) dy(abs:0|rel:0)
; node # 11 D(-87,17)->(-111,16)
       fcb 2 ; drawmode 
       fcb -6,13 ; starx/y relative to previous node
       fdb 32,-224 ; dx/dy. dx(abs:-768|rel:-224) dy(abs:32|rel:32)
; node # 12 D(-85,33)->(-106,34)
       fcb 2 ; drawmode 
       fcb -16,2 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-672|rel:96) dy(abs:-32|rel:-64)
; node # 13 D(-75,48)->(-95,53)
       fcb 2 ; drawmode 
       fcb -15,10 ; starx/y relative to previous node
       fdb -128,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:-160|rel:-128)
; node # 14 D(-70,72)->(-92,70)
       fcb 2 ; drawmode 
       fcb -24,5 ; starx/y relative to previous node
       fdb 224,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:64|rel:224)
; node # 15 D(-44,103)->(-63,101)
       fcb 2 ; drawmode 
       fcb -31,26 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:64|rel:0)
; node # 16 D(-34,103)->(-54,103)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-640|rel:-32) dy(abs:0|rel:-64)
; node # 17 D(-26,88)->(-53,88)
       fcb 2 ; drawmode 
       fcb 15,8 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-864|rel:-224) dy(abs:0|rel:0)
; node # 18 D(-22,86)->(-50,84)
       fcb 2 ; drawmode 
       fcb 2,4 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:64|rel:64)
; node # 19 D(-26,78)->(-53,79)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:-32|rel:-96)
; node # 20 D(-13,67)->(-46,69)
       fcb 2 ; drawmode 
       fcb 11,13 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-1056|rel:-192) dy(abs:-64|rel:-32)
; node # 21 D(-18,43)->(-53,41)
       fcb 2 ; drawmode 
       fcb 24,-5 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-1120|rel:-64) dy(abs:64|rel:128)
; node # 22 D(1,20)->(-38,22)
       fcb 2 ; drawmode 
       fcb 23,19 ; starx/y relative to previous node
       fdb -128,-128 ; dx/dy. dx(abs:-1248|rel:-128) dy(abs:-64|rel:-128)
; node # 23 D(11,0)->(-26,-1)
       fcb 2 ; drawmode 
       fcb 20,10 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-1184|rel:64) dy(abs:32|rel:96)
; node # 24 D(-6,0)->(-45,1)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-1248|rel:-64) dy(abs:-32|rel:-64)
; node # 25 D(-18,-12)->(-51,-8)
       fcb 2 ; drawmode 
       fcb 12,-12 ; starx/y relative to previous node
       fdb -96,192 ; dx/dy. dx(abs:-1056|rel:192) dy(abs:-128|rel:-96)
; node # 26 D(-26,-29)->(-61,-24)
       fcb 2 ; drawmode 
       fcb 17,-8 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1120|rel:-64) dy(abs:-160|rel:-32)
; node # 27 D(-38,-54)->(-68,-53)
       fcb 2 ; drawmode 
       fcb 25,-12 ; starx/y relative to previous node
       fdb 128,160 ; dx/dy. dx(abs:-960|rel:160) dy(abs:-32|rel:128)
; node # 28 M(6,62)->(-27,62)
       fcb 0 ; drawmode 
       fcb -116,44 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:0|rel:32)
; node # 29 D(-5,71)->(-36,70)
       fcb 2 ; drawmode 
       fcb -9,-11 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:32|rel:32)
; node # 30 D(-8,84)->(-36,85)
       fcb 2 ; drawmode 
       fcb -13,-3 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:-32|rel:-64)
; node # 31 D(-4,91)->(-31,91)
       fcb 2 ; drawmode 
       fcb -7,4 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:0|rel:32)
; node # 32 D(5,62)->(-27,62)
       fcb 2 ; drawmode 
       fcb 29,9 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-1024|rel:-160) dy(abs:0|rel:0)
; node # 33 M(31,-31)->(-4,-31)
       fcb 0 ; drawmode 
       fcb 93,26 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1120|rel:-96) dy(abs:0|rel:0)
; node # 34 D(22,-19)->(-13,-20)
       fcb 2 ; drawmode 
       fcb -12,-9 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:32|rel:32)
; node # 35 D(-8,-8)->(-44,-6)
       fcb 2 ; drawmode 
       fcb -11,-30 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:-64|rel:-96)
; node # 36 D(-30,-49)->(-62,-48)
       fcb 2 ; drawmode 
       fcb 41,-22 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:-32|rel:32)
; node # 37 D(-27,-67)->(-57,-67)
       fcb 2 ; drawmode 
       fcb 18,3 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:0|rel:32)
; node # 38 D(-40,-67)->(-72,-67)
       fcb 2 ; drawmode 
       fcb 0,-13 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:0|rel:0)
; node # 39 D(-45,-73)->(-72,-74)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:-864|rel:160) dy(abs:32|rel:32)
; node # 40 D(-16,-79)->(-45,-80)
       fcb 2 ; drawmode 
       fcb 6,29 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:32|rel:0)
; node # 41 D(-21,-91)->(-48,-91)
       fcb 2 ; drawmode 
       fcb 12,-5 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-864|rel:64) dy(abs:0|rel:-32)
; node # 42 D(-41,-82)->(-67,-80)
       fcb 2 ; drawmode 
       fcb -9,-20 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-832|rel:32) dy(abs:-64|rel:-64)
; node # 43 D(-41,-77)->(-69,-77)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-896|rel:-64) dy(abs:0|rel:64)
; node # 44 D(-51,-76)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -1,-10 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:0|rel:0)
; node # 45 D(-53,-68)->(-81,-66)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-896|rel:-96) dy(abs:-64|rel:-64)
; node # 46 D(-57,-79)->(-80,-77)
       fcb 2 ; drawmode 
       fcb 11,-4 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-736|rel:160) dy(abs:-64|rel:0)
; node # 47 D(-63,-85)->(-83,-84)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:-32|rel:32)
; node # 48 D(-65,-83)->(-85,-83)
       fcb 2 ; drawmode 
       fcb -2,-2 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-640|rel:0) dy(abs:0|rel:32)
; node # 49 D(-60,-76)->(-83,-75)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:-32|rel:-32)
; node # 50 D(-64,-72)->(-87,-71)
       fcb 2 ; drawmode 
       fcb -4,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:-32|rel:0)
; node # 51 D(-69,-82)->(-88,-81)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-608|rel:128) dy(abs:-32|rel:0)
; node # 52 D(-85,-74)->(-98,-72)
       fcb 2 ; drawmode 
       fcb -8,-16 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-416|rel:192) dy(abs:-64|rel:-32)
; node # 53 D(-91,-66)->(-105,-65)
       fcb 2 ; drawmode 
       fcb -8,-6 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-448|rel:-32) dy(abs:-32|rel:32)
; node # 54 D(-98,-65)->(-110,-64)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:-32|rel:0)
; node # 55 D(-91,-80)->(-101,-77)
       fcb 2 ; drawmode 
       fcb 15,7 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-320|rel:64) dy(abs:-96|rel:-64)
; node # 56 D(-83,-79)->(-96,-78)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-416|rel:-96) dy(abs:-32|rel:64)
; node # 57 D(-79,-89)->(-90,-88)
       fcb 2 ; drawmode 
       fcb 10,4 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-352|rel:64) dy(abs:-32|rel:0)
; node # 58 D(-59,-99)->(-74,-98)
       fcb 2 ; drawmode 
       fcb 10,20 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-480|rel:-128) dy(abs:-32|rel:0)
; node # 59 D(-44,-102)->(-63,-100)
       fcb 2 ; drawmode 
       fcb 3,15 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-608|rel:-128) dy(abs:-64|rel:-32)
; node # 60 D(-31,-109)->(-49,-109)
       fcb 2 ; drawmode 
       fcb 7,13 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:0|rel:64)
; node # 61 D(-37,-111)->(-54,-109)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-544|rel:32) dy(abs:-64|rel:-64)
; node # 62 D(-52,-103)->(-66,-102)
       fcb 2 ; drawmode 
       fcb -8,-15 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-448|rel:96) dy(abs:-32|rel:32)
; node # 63 D(-51,-111)->(-69,-105)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb -160,-128 ; dx/dy. dx(abs:-576|rel:-128) dy(abs:-192|rel:-160)
; node # 64 D(-30,-119)->(-47,-117)
       fcb 2 ; drawmode 
       fcb 8,21 ; starx/y relative to previous node
       fdb 128,32 ; dx/dy. dx(abs:-544|rel:32) dy(abs:-64|rel:128)
; node # 65 D(-17,-119)->(-34,-119)
       fcb 2 ; drawmode 
       fcb 0,13 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:0|rel:64)
; node # 66 D(-23,-117)->(-39,-116)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-512|rel:32) dy(abs:-32|rel:-32)
; node # 67 D(-8,-119)->(-27,-118)
       fcb 2 ; drawmode 
       fcb 2,15 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:-32|rel:0)
; node # 68 D(45,-118)->(26,-120)
       fcb 2 ; drawmode 
       fcb -1,53 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:64|rel:96)
; node # 69 D(62,-112)->(38,-120)
       fcb 2 ; drawmode 
       fcb -6,17 ; starx/y relative to previous node
       fdb 192,-160 ; dx/dy. dx(abs:-768|rel:-160) dy(abs:256|rel:192)
; node # 70 D(79,-100)->(68,-109)
       fcb 2 ; drawmode 
       fcb -12,17 ; starx/y relative to previous node
       fdb 32,416 ; dx/dy. dx(abs:-352|rel:416) dy(abs:288|rel:32)
; node # 71 D(87,-93)->(73,-99)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb -96,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:192|rel:-96)
; node # 72 D(94,-85)->(88,-89)
       fcb 2 ; drawmode 
       fcb -8,7 ; starx/y relative to previous node
       fdb -64,256 ; dx/dy. dx(abs:-192|rel:256) dy(abs:128|rel:-64)
; node # 73 D(99,-79)->(100,-71)
       fcb 2 ; drawmode 
       fcb -6,5 ; starx/y relative to previous node
       fdb -384,224 ; dx/dy. dx(abs:32|rel:224) dy(abs:-256|rel:-384)
; node # 74 D(103,-69)->(97,-70)
       fcb 2 ; drawmode 
       fcb -10,4 ; starx/y relative to previous node
       fdb 288,-224 ; dx/dy. dx(abs:-192|rel:-224) dy(abs:32|rel:288)
; node # 75 D(116,-49)->(110,-47)
       fcb 2 ; drawmode 
       fcb -20,13 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:-64|rel:-96)
; node # 76 D(121,-31)->(111,-30)
       fcb 2 ; drawmode 
       fcb -18,5 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-320|rel:-128) dy(abs:-32|rel:32)
; node # 77 D(116,-24)->(98,-27)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb 128,-256 ; dx/dy. dx(abs:-576|rel:-256) dy(abs:96|rel:128)
; node # 78 D(120,-9)->(107,-2)
       fcb 2 ; drawmode 
       fcb -15,4 ; starx/y relative to previous node
       fdb -320,160 ; dx/dy. dx(abs:-416|rel:160) dy(abs:-224|rel:-320)
; node # 79 D(120,1)->(100,3)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 160,-224 ; dx/dy. dx(abs:-640|rel:-224) dy(abs:-64|rel:160)
; node # 80 M(125,11)->(114,11)
       fcb 0 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 64,288 ; dx/dy. dx(abs:-352|rel:288) dy(abs:0|rel:64)
; node # 81 D(121,34)->(110,36)
       fcb 2 ; drawmode 
       fcb -23,-4 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:-64|rel:-64)
; node # 82 D(119,34)->(105,35)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:-32|rel:32)
; node # 83 D(119,28)->(104,25)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:96|rel:128)
; node # 84 D(121,20)->(111,19)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:-320|rel:160) dy(abs:32|rel:-64)
; node # 85 D(125,11)->(114,11)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-352|rel:-32) dy(abs:0|rel:-32)
; node # 86 M(120,1)->(100,3)
       fcb 0 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb -64,-288 ; dx/dy. dx(abs:-640|rel:-288) dy(abs:-64|rel:-64)
; node # 87 D(113,-5)->(91,-6)
       fcb 2 ; drawmode 
       fcb 6,-7 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:32|rel:96)
; node # 88 D(115,21)->(97,18)
       fcb 2 ; drawmode 
       fcb -26,2 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:96|rel:64)
; node # 89 D(112,20)->(95,24)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb -224,32 ; dx/dy. dx(abs:-544|rel:32) dy(abs:-128|rel:-224)
; node # 90 D(108,-16)->(84,-16)
       fcb 2 ; drawmode 
       fcb 36,-4 ; starx/y relative to previous node
       fdb 128,-224 ; dx/dy. dx(abs:-768|rel:-224) dy(abs:0|rel:128)
; node # 91 D(105,-13)->(81,-14)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-768|rel:0) dy(abs:32|rel:32)
; node # 92 D(98,-26)->(70,-31)
       fcb 2 ; drawmode 
       fcb 13,-7 ; starx/y relative to previous node
       fdb 128,-128 ; dx/dy. dx(abs:-896|rel:-128) dy(abs:160|rel:128)
; node # 93 D(93,-31)->(62,-30)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb -192,-96 ; dx/dy. dx(abs:-992|rel:-96) dy(abs:-32|rel:-192)
; node # 94 D(80,-13)->(49,-14)
       fcb 2 ; drawmode 
       fcb -18,-13 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-992|rel:0) dy(abs:32|rel:64)
; node # 95 D(80,1)->(47,0)
       fcb 2 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:32|rel:0)
; node # 96 M(82,95)->(69,101)
       fcb 0 ; drawmode 
       fcb -94,2 ; starx/y relative to previous node
       fdb -224,640 ; dx/dy. dx(abs:-416|rel:640) dy(abs:-192|rel:-224)
; node # 97 D(98,80)->(88,79)
       fcb 2 ; drawmode 
       fcb 15,16 ; starx/y relative to previous node
       fdb 224,96 ; dx/dy. dx(abs:-320|rel:96) dy(abs:32|rel:224)
; node # 98 D(106,70)->(100,70)
       fcb 2 ; drawmode 
       fcb 10,8 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-192|rel:128) dy(abs:0|rel:-32)
; node # 99 D(110,65)->(117,52)
       fcb 2 ; drawmode 
       fcb 5,4 ; starx/y relative to previous node
       fdb 416,416 ; dx/dy. dx(abs:224|rel:416) dy(abs:416|rel:416)
; node # 100 D(100,78)->(101,79)
       fcb 2 ; drawmode 
       fcb -13,-10 ; starx/y relative to previous node
       fdb -448,-192 ; dx/dy. dx(abs:32|rel:-192) dy(abs:-32|rel:-448)
; node # 101 D(91,87)->(83,96)
       fcb 2 ; drawmode 
       fcb -9,-9 ; starx/y relative to previous node
       fdb -256,-288 ; dx/dy. dx(abs:-256|rel:-288) dy(abs:-288|rel:-256)
; node # 102 D(85,92)->(69,101)
       fcb 2 ; drawmode 
       fcb -5,-6 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-512|rel:-256) dy(abs:-288|rel:0)
; node # 103 M(80,1)->(47,0)
       fcb 0 ; drawmode 
       fcb 91,-5 ; starx/y relative to previous node
       fdb 320,-544 ; dx/dy. dx(abs:-1056|rel:-544) dy(abs:32|rel:320)
; node # 104 D(75,6)->(42,6)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:-32)
; node # 105 D(63,-21)->(29,-19)
       fcb 2 ; drawmode 
       fcb 27,-12 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:-64|rel:-64)
; node # 106 D(62,-30)->(27,-31)
       fcb 2 ; drawmode 
       fcb 9,-1 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:32|rel:96)
; node # 107 D(55,-28)->(21,-28)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:0|rel:-32)
; node # 108 D(55,-33)->(16,-36)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-1248|rel:-160) dy(abs:96|rel:96)
; node # 109 D(45,-39)->(10,-40)
       fcb 2 ; drawmode 
       fcb 6,-10 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-1120|rel:128) dy(abs:32|rel:-64)
; node # 110 D(25,-39)->(-11,-41)
       fcb 2 ; drawmode 
       fcb 0,-20 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:64|rel:32)
; node # 111 D(21,-43)->(-14,-45)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:64|rel:0)
; node # 112 D(9,-46)->(-25,-46)
       fcb 2 ; drawmode 
       fcb 3,-12 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:0|rel:-64)
; node # 113 D(3,-53)->(-30,-53)
       fcb 2 ; drawmode 
       fcb 7,-6 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:0|rel:0)
; node # 114 D(0,-50)->(-35,-50)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1120|rel:-64) dy(abs:0|rel:0)
; node # 115 D(7,-39)->(-24,-36)
       fcb 2 ; drawmode 
       fcb -11,7 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-992|rel:128) dy(abs:-96|rel:-96)
; node # 116 D(17,-36)->(-19,-36)
       fcb 2 ; drawmode 
       fcb -3,10 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-1152|rel:-160) dy(abs:0|rel:96)
; node # 117 D(20,-40)->(-15,-40)
       fcb 2 ; drawmode 
       fcb 4,3 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:0|rel:0)
; node # 118 D(30,-30)->(-5,-31)
       fcb 2 ; drawmode 
       fcb -10,10 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:32|rel:32)
       fcb  1  ; end of anim
; Animation 2
weltframe2:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-68,-53)->(-93,-51)
       fcb 0 ; drawmode 
       fcb 53,-68 ; starx/y relative to previous node
       fdb -64,-800 ; dx/dy. dx(abs:-800|rel:-800) dy(abs:-64|rel:-64)
; node # 1 D(-85,-56)->(-105,-54)
       fcb 2 ; drawmode 
       fcb 3,-17 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-640|rel:160) dy(abs:-64|rel:0)
; node # 2 D(-90,-51)->(-108,-48)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:-96|rel:-32)
; node # 3 D(-97,-56)->(-110,-55)
       fcb 2 ; drawmode 
       fcb 5,-7 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-416|rel:160) dy(abs:-32|rel:64)
; node # 4 D(-97,-65)->(-109,-63)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-384|rel:32) dy(abs:-64|rel:-32)
; node # 5 D(-111,-59)->(-112,-61)
       fcb 2 ; drawmode 
       fcb -6,-14 ; starx/y relative to previous node
       fdb 128,352 ; dx/dy. dx(abs:-32|rel:352) dy(abs:64|rel:128)
; node # 6 D(-121,-42)->(-121,-42)
       fcb 2 ; drawmode 
       fcb -17,-10 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-64)
; node # 7 D(-128,-5)->(-128,-14)
       fcb 2 ; drawmode 
       fcb -37,-7 ; starx/y relative to previous node
       fdb 288,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:288|rel:288)
; node # 8 D(-125,15)->(-127,12)
       fcb 2 ; drawmode 
       fcb -20,3 ; starx/y relative to previous node
       fdb -192,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:96|rel:-192)
; node # 9 D(-117,11)->(-125,13)
       fcb 2 ; drawmode 
       fcb 4,8 ; starx/y relative to previous node
       fdb -160,-192 ; dx/dy. dx(abs:-256|rel:-192) dy(abs:-64|rel:-160)
; node # 10 D(-111,16)->(-123,16)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-384|rel:-128) dy(abs:0|rel:64)
; node # 11 D(-106,34)->(-120,34)
       fcb 2 ; drawmode 
       fcb -18,5 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-448|rel:-64) dy(abs:0|rel:0)
; node # 12 D(-95,53)->(-111,52)
       fcb 2 ; drawmode 
       fcb -19,11 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-512|rel:-64) dy(abs:32|rel:32)
; node # 13 D(-92,70)->(-102,71)
       fcb 2 ; drawmode 
       fcb -17,3 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-320|rel:192) dy(abs:-32|rel:-64)
; node # 14 D(-63,101)->(-73,101)
       fcb 2 ; drawmode 
       fcb -31,29 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:0|rel:32)
; node # 15 D(-54,103)->(-68,101)
       fcb 2 ; drawmode 
       fcb -2,9 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-448|rel:-128) dy(abs:64|rel:64)
; node # 16 D(-53,88)->(-73,87)
       fcb 2 ; drawmode 
       fcb 15,1 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-640|rel:-192) dy(abs:32|rel:-32)
; node # 17 D(-50,84)->(-71,83)
       fcb 2 ; drawmode 
       fcb 4,3 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:32|rel:0)
; node # 18 D(-53,79)->(-78,76)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-800|rel:-128) dy(abs:96|rel:64)
; node # 19 D(-46,69)->(-73,66)
       fcb 2 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:96|rel:0)
; node # 20 D(-53,41)->(-83,38)
       fcb 2 ; drawmode 
       fcb 28,-7 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:96|rel:0)
; node # 21 D(-38,22)->(-68,20)
       fcb 2 ; drawmode 
       fcb 19,15 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:64|rel:-32)
; node # 22 D(-26,-1)->(-62,-1)
       fcb 2 ; drawmode 
       fcb 23,12 ; starx/y relative to previous node
       fdb -64,-192 ; dx/dy. dx(abs:-1152|rel:-192) dy(abs:0|rel:-64)
; node # 23 D(-45,1)->(-77,2)
       fcb 2 ; drawmode 
       fcb -2,-19 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:-32|rel:-32)
; node # 24 D(-61,-24)->(-88,-20)
       fcb 2 ; drawmode 
       fcb 25,-16 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-864|rel:160) dy(abs:-128|rel:-96)
; node # 25 D(-68,-53)->(-93,-51)
       fcb 2 ; drawmode 
       fcb 29,-7 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-800|rel:64) dy(abs:-64|rel:64)
; node # 26 M(-27,62)->(-58,61)
       fcb 0 ; drawmode 
       fcb -115,41 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-992|rel:-192) dy(abs:32|rel:96)
; node # 27 D(-36,70)->(-65,70)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-928|rel:64) dy(abs:0|rel:-32)
; node # 28 D(-36,85)->(-61,84)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-800|rel:128) dy(abs:32|rel:32)
; node # 29 D(-31,91)->(-55,88)
       fcb 2 ; drawmode 
       fcb -6,5 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:96|rel:64)
; node # 30 D(-27,62)->(-58,61)
       fcb 2 ; drawmode 
       fcb 29,4 ; starx/y relative to previous node
       fdb -64,-224 ; dx/dy. dx(abs:-992|rel:-224) dy(abs:32|rel:-64)
; node # 31 M(-4,-31)->(-42,-31)
       fcb 0 ; drawmode 
       fcb 93,23 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-1216|rel:-224) dy(abs:0|rel:-32)
; node # 32 D(-13,-20)->(-63,-11)
       fcb 2 ; drawmode 
       fcb -11,-9 ; starx/y relative to previous node
       fdb -288,-384 ; dx/dy. dx(abs:-1600|rel:-384) dy(abs:-288|rel:-288)
; node # 33 D(-44,-6)->(-77,-6)
       fcb 2 ; drawmode 
       fcb -14,-31 ; starx/y relative to previous node
       fdb 288,544 ; dx/dy. dx(abs:-1056|rel:544) dy(abs:0|rel:288)
; node # 34 D(-62,-48)->(-88,-47)
       fcb 2 ; drawmode 
       fcb 42,-18 ; starx/y relative to previous node
       fdb -32,224 ; dx/dy. dx(abs:-832|rel:224) dy(abs:-32|rel:-32)
; node # 35 D(-57,-67)->(-82,-66)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-800|rel:32) dy(abs:-32|rel:0)
; node # 36 D(-72,-67)->(-93,-65)
       fcb 2 ; drawmode 
       fcb 0,-15 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:-64|rel:-32)
; node # 37 D(-72,-74)->(-92,-72)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:-64|rel:0)
; node # 38 D(-45,-80)->(-69,-78)
       fcb 2 ; drawmode 
       fcb 6,27 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:-64|rel:0)
; node # 39 D(-48,-91)->(-70,-90)
       fcb 2 ; drawmode 
       fcb 11,-3 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:-32|rel:32)
; node # 40 D(-69,-77)->(-88,-75)
       fcb 2 ; drawmode 
       fcb -14,-21 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:-64|rel:-32)
; node # 41 D(-76,-76)->(-93,-74)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-544|rel:64) dy(abs:-64|rel:0)
; node # 42 D(-81,-66)->(-99,-66)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-576|rel:-32) dy(abs:0|rel:64)
; node # 43 D(-80,-77)->(-95,-75)
       fcb 2 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-480|rel:96) dy(abs:-64|rel:-64)
; node # 44 D(-83,-84)->(-95,-82)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-384|rel:96) dy(abs:-64|rel:0)
; node # 45 D(-85,-83)->(-97,-80)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-384|rel:0) dy(abs:-96|rel:-32)
; node # 46 D(-83,-75)->(-98,-74)
       fcb 2 ; drawmode 
       fcb -8,2 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-480|rel:-96) dy(abs:-32|rel:64)
; node # 47 D(-87,-71)->(-102,-67)
       fcb 2 ; drawmode 
       fcb -4,-4 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:-128|rel:-96)
; node # 48 D(-88,-81)->(-100,-78)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-384|rel:96) dy(abs:-96|rel:32)
; node # 49 D(-105,-65)->(-110,-65)
       fcb 2 ; drawmode 
       fcb -16,-17 ; starx/y relative to previous node
       fdb 96,224 ; dx/dy. dx(abs:-160|rel:224) dy(abs:0|rel:96)
; node # 50 D(-110,-64)->(-110,-65)
       fcb 2 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:0|rel:160) dy(abs:32|rel:32)
; node # 51 D(-101,-77)->(-102,-77)
       fcb 2 ; drawmode 
       fcb 13,9 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:0|rel:-32)
; node # 52 D(-96,-78)->(-100,-79)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-128|rel:-96) dy(abs:32|rel:32)
; node # 53 D(-90,-88)->(-94,-87)
       fcb 2 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-32|rel:-64)
; node # 54 D(-74,-98)->(-80,-98)
       fcb 2 ; drawmode 
       fcb 10,16 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-192|rel:-64) dy(abs:0|rel:32)
; node # 55 D(-63,-100)->(-77,-100)
       fcb 2 ; drawmode 
       fcb 2,11 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-448|rel:-256) dy(abs:0|rel:0)
; node # 56 D(-49,-109)->(-64,-109)
       fcb 2 ; drawmode 
       fcb 9,14 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:0|rel:0)
; node # 57 D(-54,-109)->(-66,-107)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-384|rel:96) dy(abs:-64|rel:-64)
; node # 58 D(-66,-102)->(-77,-100)
       fcb 2 ; drawmode 
       fcb -7,-12 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:-64|rel:0)
; node # 59 D(-69,-105)->(-72,-104)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb 32,256 ; dx/dy. dx(abs:-96|rel:256) dy(abs:-32|rel:32)
; node # 60 D(-47,-117)->(-54,-113)
       fcb 2 ; drawmode 
       fcb 12,22 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-224|rel:-128) dy(abs:-128|rel:-96)
; node # 61 D(-34,-119)->(-43,-116)
       fcb 2 ; drawmode 
       fcb 2,13 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-288|rel:-64) dy(abs:-96|rel:32)
; node # 62 D(-39,-116)->(-50,-114)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:-64|rel:32)
; node # 63 D(-27,-118)->(-43,-116)
       fcb 2 ; drawmode 
       fcb 2,12 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-512|rel:-160) dy(abs:-64|rel:0)
; node # 64 D(38,-120)->(26,-121)
       fcb 2 ; drawmode 
       fcb 2,65 ; starx/y relative to previous node
       fdb 96,128 ; dx/dy. dx(abs:-384|rel:128) dy(abs:32|rel:96)
; node # 65 D(67,-109)->(60,-112)
       fcb 2 ; drawmode 
       fcb -11,29 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-224|rel:160) dy(abs:96|rel:64)
; node # 66 D(73,-100)->(63,-101)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-320|rel:-96) dy(abs:32|rel:-64)
; node # 67 D(88,-89)->(81,-90)
       fcb 2 ; drawmode 
       fcb -11,15 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-224|rel:96) dy(abs:32|rel:0)
; node # 68 D(100,-71)->(83,-76)
       fcb 2 ; drawmode 
       fcb -18,12 ; starx/y relative to previous node
       fdb 128,-320 ; dx/dy. dx(abs:-544|rel:-320) dy(abs:160|rel:128)
; node # 69 D(97,-70)->(80,-72)
       fcb 2 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:64|rel:-96)
; node # 70 D(100,-63)->(79,-62)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-672|rel:-128) dy(abs:-32|rel:-96)
; node # 71 D(110,-47)->(90,-50)
       fcb 2 ; drawmode 
       fcb -16,10 ; starx/y relative to previous node
       fdb 128,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:96|rel:128)
; node # 72 D(111,-30)->(90,-32)
       fcb 2 ; drawmode 
       fcb -17,1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:64|rel:-32)
; node # 73 D(103,-29)->(74,-29)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -64,-256 ; dx/dy. dx(abs:-928|rel:-256) dy(abs:0|rel:-64)
; node # 74 D(98,-27)->(71,-25)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-864|rel:64) dy(abs:-64|rel:-64)
; node # 75 D(107,-2)->(82,-6)
       fcb 2 ; drawmode 
       fcb -25,9 ; starx/y relative to previous node
       fdb 192,64 ; dx/dy. dx(abs:-800|rel:64) dy(abs:128|rel:192)
; node # 76 D(100,3)->(75,3)
       fcb 2 ; drawmode 
       fcb -5,-7 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-800|rel:0) dy(abs:0|rel:-128)
; node # 77 M(114,11)->(96,11)
       fcb 0 ; drawmode 
       fcb -8,14 ; starx/y relative to previous node
       fdb 0,224 ; dx/dy. dx(abs:-576|rel:224) dy(abs:0|rel:0)
; node # 78 D(112,23)->(96,24)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:-32|rel:-32)
; node # 79 D(110,36)->(90,38)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-640|rel:-128) dy(abs:-64|rel:-32)
; node # 80 D(104,35)->(80,36)
       fcb 2 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:-32|rel:32)
; node # 81 D(104,25)->(80,25)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-768|rel:0) dy(abs:0|rel:32)
; node # 82 D(111,19)->(89,22)
       fcb 2 ; drawmode 
       fcb 6,7 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:-96|rel:-96)
; node # 83 D(114,11)->(96,11)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 96,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:0|rel:96)
; node # 84 M(124,29)->(115,33)
       fcb 0 ; drawmode 
       fcb -18,10 ; starx/y relative to previous node
       fdb -128,288 ; dx/dy. dx(abs:-288|rel:288) dy(abs:-128|rel:-128)
; node # 85 D(123,36)->(120,41)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-96|rel:192) dy(abs:-160|rel:-32)
; node # 86 D(121,45)->(116,48)
       fcb 2 ; drawmode 
       fcb -9,-2 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:-96|rel:64)
; node # 87 D(124,29)->(115,33)
       fcb 2 ; drawmode 
       fcb 16,3 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-288|rel:-128) dy(abs:-128|rel:-32)
; node # 88 M(69,101)->(54,102)
       fcb 0 ; drawmode 
       fcb -72,-55 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-480|rel:-192) dy(abs:-32|rel:96)
; node # 89 D(88,79)->(69,80)
       fcb 2 ; drawmode 
       fcb 22,19 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-608|rel:-128) dy(abs:-32|rel:0)
; node # 90 D(100,70)->(85,74)
       fcb 2 ; drawmode 
       fcb 9,12 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-480|rel:128) dy(abs:-128|rel:-96)
; node # 91 D(117,52)->(105,57)
       fcb 2 ; drawmode 
       fcb 18,17 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-384|rel:96) dy(abs:-160|rel:-32)
; node # 92 D(113,59)->(103,70)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb -192,64 ; dx/dy. dx(abs:-320|rel:64) dy(abs:-352|rel:-192)
; node # 93 D(117,52)->(113,54)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb 288,192 ; dx/dy. dx(abs:-128|rel:192) dy(abs:-64|rel:288)
; node # 94 D(101,79)->(99,79)
       fcb 2 ; drawmode 
       fcb -27,-16 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:0|rel:64)
; node # 95 D(83,96)->(83,96)
       fcb 2 ; drawmode 
       fcb -17,-18 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:0)
; node # 96 D(76,102)->(68,106)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb -128,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:-128|rel:-128)
; node # 97 D(83,96)->(74,98)
       fcb 2 ; drawmode 
       fcb 6,7 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-288|rel:-32) dy(abs:-64|rel:64)
; node # 98 D(69,101)->(54,102)
       fcb 2 ; drawmode 
       fcb -5,-14 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-480|rel:-192) dy(abs:-32|rel:32)
; node # 99 M(100,3)->(75,3)
       fcb 0 ; drawmode 
       fcb 98,31 ; starx/y relative to previous node
       fdb 32,-320 ; dx/dy. dx(abs:-800|rel:-320) dy(abs:0|rel:32)
; node # 100 D(91,-6)->(62,-7)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-928|rel:-128) dy(abs:32|rel:32)
; node # 101 D(97,18)->(70,24)
       fcb 2 ; drawmode 
       fcb -24,6 ; starx/y relative to previous node
       fdb -224,64 ; dx/dy. dx(abs:-864|rel:64) dy(abs:-192|rel:-224)
; node # 102 D(95,24)->(65,22)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb 256,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:64|rel:256)
; node # 103 D(84,-16)->(53,-17)
       fcb 2 ; drawmode 
       fcb 40,-11 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:32|rel:-32)
; node # 104 D(81,-14)->(49,-14)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:0|rel:-32)
; node # 105 D(70,-31)->(36,-33)
       fcb 2 ; drawmode 
       fcb 17,-11 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-1088|rel:-64) dy(abs:64|rel:64)
; node # 106 D(62,-30)->(27,-30)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:0|rel:-64)
; node # 107 D(49,-14)->(10,-14)
       fcb 2 ; drawmode 
       fcb -16,-13 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1248|rel:-128) dy(abs:0|rel:0)
; node # 108 D(47,0)->(10,0)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-1184|rel:64) dy(abs:0|rel:0)
; node # 109 D(42,6)->(5,7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1184|rel:0) dy(abs:-32|rel:-32)
; node # 110 D(29,-19)->(-7,-18)
       fcb 2 ; drawmode 
       fcb 25,-13 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:-32|rel:0)
; node # 111 D(27,-31)->(-10,-32)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1184|rel:-32) dy(abs:32|rel:64)
; node # 112 D(21,-28)->(-15,-28)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:0|rel:-32)
; node # 113 D(16,-36)->(-18,-34)
       fcb 2 ; drawmode 
       fcb 8,-5 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:-64|rel:-64)
; node # 114 D(10,-40)->(-25,-41)
       fcb 2 ; drawmode 
       fcb 4,-6 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:32|rel:96)
; node # 115 D(-11,-41)->(-44,-40)
       fcb 2 ; drawmode 
       fcb 1,-21 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-1056|rel:64) dy(abs:-32|rel:-64)
; node # 116 D(-14,-45)->(-48,-44)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:-32|rel:0)
; node # 117 D(-25,-46)->(-56,-44)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-992|rel:96) dy(abs:-64|rel:-32)
; node # 118 D(-30,-53)->(-63,-52)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:-32|rel:32)
; node # 119 D(-35,-50)->(-67,-51)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:32|rel:64)
; node # 120 D(-24,-36)->(-62,-38)
       fcb 2 ; drawmode 
       fcb -14,11 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-1216|rel:-192) dy(abs:64|rel:32)
; node # 121 D(-19,-36)->(-57,-36)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1216|rel:0) dy(abs:0|rel:-64)
; node # 122 D(-15,-40)->(-50,-40)
       fcb 2 ; drawmode 
       fcb 4,4 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-1120|rel:96) dy(abs:0|rel:0)
; node # 123 D(-5,-31)->(-42,-31)
       fcb 2 ; drawmode 
       fcb -9,10 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1184|rel:-64) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 3
weltframe3:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-93,-51)->(-111,-51)
       fcb 0 ; drawmode 
       fcb 51,-93 ; starx/y relative to previous node
       fdb 0,-576 ; dx/dy. dx(abs:-576|rel:-576) dy(abs:0|rel:0)
; node # 1 D(-105,-54)->(-112,-51)
       fcb 2 ; drawmode 
       fcb 3,-12 ; starx/y relative to previous node
       fdb -96,352 ; dx/dy. dx(abs:-224|rel:352) dy(abs:-96|rel:-96)
; node # 2 D(-108,-48)->(-114,-50)
       fcb 2 ; drawmode 
       fcb -6,-3 ; starx/y relative to previous node
       fdb 160,32 ; dx/dy. dx(abs:-192|rel:32) dy(abs:64|rel:160)
; node # 3 D(-110,-55)->(-116,-53)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:-64|rel:-128)
; node # 4 D(-111,-63)->(-113,-60)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-64|rel:128) dy(abs:-96|rel:-32)
; node # 5 D(-121,-42)->(-121,-42)
       fcb 2 ; drawmode 
       fcb -21,-10 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:96)
; node # 6 D(-128,-14)->(-128,-14)
       fcb 2 ; drawmode 
       fcb -28,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-127,12)->(-128,0)
       fcb 2 ; drawmode 
       fcb -26,1 ; starx/y relative to previous node
       fdb 384,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:384|rel:384)
; node # 8 D(-125,13)->(-128,12)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb -352,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:32|rel:-352)
; node # 9 D(-123,16)->(-127,17)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-128|rel:-32) dy(abs:-32|rel:-64)
; node # 10 D(-120,34)->(-124,33)
       fcb 2 ; drawmode 
       fcb -18,3 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:32|rel:64)
; node # 11 D(-111,52)->(-118,52)
       fcb 2 ; drawmode 
       fcb -18,9 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-224|rel:-96) dy(abs:0|rel:-32)
; node # 12 D(-102,71)->(-103,76)
       fcb 2 ; drawmode 
       fcb -19,9 ; starx/y relative to previous node
       fdb -160,192 ; dx/dy. dx(abs:-32|rel:192) dy(abs:-160|rel:-160)
; node # 13 D(-73,101)->(-80,100)
       fcb 2 ; drawmode 
       fcb -30,29 ; starx/y relative to previous node
       fdb 192,-192 ; dx/dy. dx(abs:-224|rel:-192) dy(abs:32|rel:192)
; node # 14 D(-68,101)->(-80,100)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-384|rel:-160) dy(abs:32|rel:0)
; node # 15 D(-73,87)->(-87,87)
       fcb 2 ; drawmode 
       fcb 14,-5 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-448|rel:-64) dy(abs:0|rel:-32)
; node # 16 D(-71,83)->(-88,82)
       fcb 2 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-544|rel:-96) dy(abs:32|rel:32)
; node # 17 D(-78,76)->(-95,72)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:128|rel:96)
; node # 18 D(-73,66)->(-93,67)
       fcb 2 ; drawmode 
       fcb 10,5 ; starx/y relative to previous node
       fdb -160,-96 ; dx/dy. dx(abs:-640|rel:-96) dy(abs:-32|rel:-160)
; node # 19 D(-83,38)->(-106,37)
       fcb 2 ; drawmode 
       fcb 28,-10 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:32|rel:64)
; node # 20 D(-68,20)->(-97,22)
       fcb 2 ; drawmode 
       fcb 18,15 ; starx/y relative to previous node
       fdb -96,-192 ; dx/dy. dx(abs:-928|rel:-192) dy(abs:-64|rel:-96)
; node # 21 D(-62,-1)->(-92,-1)
       fcb 2 ; drawmode 
       fcb 21,6 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:0|rel:64)
; node # 22 D(-77,2)->(-103,1)
       fcb 2 ; drawmode 
       fcb -3,-15 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-832|rel:128) dy(abs:32|rel:32)
; node # 23 D(-88,-20)->(-109,-14)
       fcb 2 ; drawmode 
       fcb 22,-11 ; starx/y relative to previous node
       fdb -224,160 ; dx/dy. dx(abs:-672|rel:160) dy(abs:-192|rel:-224)
; node # 24 D(-93,-51)->(-112,-51)
       fcb 2 ; drawmode 
       fcb 31,-5 ; starx/y relative to previous node
       fdb 192,64 ; dx/dy. dx(abs:-608|rel:64) dy(abs:0|rel:192)
; node # 25 M(-58,61)->(-83,60)
       fcb 0 ; drawmode 
       fcb -112,35 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-800|rel:-192) dy(abs:32|rel:32)
; node # 26 D(-65,70)->(-87,69)
       fcb 2 ; drawmode 
       fcb -9,-7 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-704|rel:96) dy(abs:32|rel:0)
; node # 27 D(-61,84)->(-82,83)
       fcb 2 ; drawmode 
       fcb -14,4 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:32|rel:0)
; node # 28 D(-55,88)->(-76,88)
       fcb 2 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-672|rel:0) dy(abs:0|rel:-32)
; node # 29 D(-58,61)->(-83,61)
       fcb 2 ; drawmode 
       fcb 27,-3 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-800|rel:-128) dy(abs:0|rel:0)
; node # 30 M(-42,-31)->(-74,-31)
       fcb 0 ; drawmode 
       fcb 92,16 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-1024|rel:-224) dy(abs:0|rel:0)
; node # 31 D(-63,-11)->(-91,-12)
       fcb 2 ; drawmode 
       fcb -20,-21 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-896|rel:128) dy(abs:32|rel:32)
; node # 32 D(-77,-6)->(-102,-5)
       fcb 2 ; drawmode 
       fcb -5,-14 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:-32|rel:-64)
; node # 33 D(-88,-47)->(-107,-47)
       fcb 2 ; drawmode 
       fcb 41,-11 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-608|rel:192) dy(abs:0|rel:32)
; node # 34 D(-82,-66)->(-101,-64)
       fcb 2 ; drawmode 
       fcb 19,6 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:-64|rel:-64)
; node # 35 D(-93,-65)->(-106,-65)
       fcb 2 ; drawmode 
       fcb -1,-11 ; starx/y relative to previous node
       fdb 64,192 ; dx/dy. dx(abs:-416|rel:192) dy(abs:0|rel:64)
; node # 36 D(-92,-72)->(-103,-70)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-352|rel:64) dy(abs:-64|rel:-64)
; node # 37 D(-78,-76)->(-98,-75)
       fcb 2 ; drawmode 
       fcb 4,14 ; starx/y relative to previous node
       fdb 32,-288 ; dx/dy. dx(abs:-640|rel:-288) dy(abs:-32|rel:32)
; node # 38 D(-75,-75)->(-92,-73)
       fcb 2 ; drawmode 
       fcb -1,3 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-544|rel:96) dy(abs:-64|rel:-32)
; node # 39 D(-69,-78)->(-88,-78)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-608|rel:-64) dy(abs:0|rel:64)
; node # 40 D(-72,-83)->(-89,-82)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-544|rel:64) dy(abs:-32|rel:-32)
; node # 41 D(-70,-90)->(-86,-87)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-512|rel:32) dy(abs:-96|rel:-64)
; node # 42 D(-88,-75)->(-100,-75)
       fcb 2 ; drawmode 
       fcb -15,-18 ; starx/y relative to previous node
       fdb 96,128 ; dx/dy. dx(abs:-384|rel:128) dy(abs:0|rel:96)
; node # 43 D(-93,-74)->(-104,-72)
       fcb 2 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:-64|rel:-64)
; node # 44 D(-99,-66)->(-109,-67)
       fcb 2 ; drawmode 
       fcb -8,-6 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-320|rel:32) dy(abs:32|rel:96)
; node # 45 D(-95,-75)->(-103,-76)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-256|rel:64) dy(abs:32|rel:0)
; node # 46 D(-95,-82)->(-99,-82)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-128|rel:128) dy(abs:0|rel:-32)
; node # 47 D(-97,-80)->(-100,-80)
       fcb 2 ; drawmode 
       fcb -2,-2 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-96|rel:32) dy(abs:0|rel:0)
; node # 48 D(-98,-74)->(-104,-74)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:0|rel:0)
; node # 49 D(-102,-67)->(-109,-67)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-224|rel:-32) dy(abs:0|rel:0)
; node # 50 D(-100,-78)->(-102,-78)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-64|rel:160) dy(abs:0|rel:0)
; node # 51 D(-93,-89)->(-96,-85)
       fcb 2 ; drawmode 
       fcb 11,7 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:-128|rel:-128)
; node # 52 D(-81,-99)->(-82,-99)
       fcb 2 ; drawmode 
       fcb 10,12 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:-32|rel:64) dy(abs:0|rel:128)
; node # 53 D(-55,-113)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,26 ; starx/y relative to previous node
       fdb -64,-288 ; dx/dy. dx(abs:-320|rel:-288) dy(abs:-64|rel:-64)
; node # 54 D(26,-121)->(8,-121)
       fcb 2 ; drawmode 
       fcb 8,81 ; starx/y relative to previous node
       fdb 64,-256 ; dx/dy. dx(abs:-576|rel:-256) dy(abs:0|rel:64)
; node # 55 D(60,-112)->(55,-114)
       fcb 2 ; drawmode 
       fcb -9,34 ; starx/y relative to previous node
       fdb 64,416 ; dx/dy. dx(abs:-160|rel:416) dy(abs:64|rel:64)
; node # 56 D(61,-107)->(57,-109)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-128|rel:32) dy(abs:64|rel:0)
; node # 57 D(61,-106)->(39,-108)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 0,-576 ; dx/dy. dx(abs:-704|rel:-576) dy(abs:64|rel:0)
; node # 58 D(62,-101)->(43,-101)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:0|rel:-64)
; node # 59 D(81,-90)->(63,-91)
       fcb 2 ; drawmode 
       fcb -11,19 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:32|rel:32)
; node # 60 D(83,-76)->(62,-73)
       fcb 2 ; drawmode 
       fcb -14,2 ; starx/y relative to previous node
       fdb -128,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:-96|rel:-128)
; node # 61 D(80,-72)->(56,-74)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb 160,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:64|rel:160)
; node # 62 D(79,-62)->(52,-62)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-864|rel:-96) dy(abs:0|rel:-64)
; node # 63 D(90,-50)->(64,-50)
       fcb 2 ; drawmode 
       fcb -12,11 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-832|rel:32) dy(abs:0|rel:0)
; node # 64 D(90,-32)->(63,-36)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-864|rel:-32) dy(abs:128|rel:128)
; node # 65 D(74,-29)->(42,-29)
       fcb 2 ; drawmode 
       fcb -3,-16 ; starx/y relative to previous node
       fdb -128,-160 ; dx/dy. dx(abs:-1024|rel:-160) dy(abs:0|rel:-128)
; node # 66 D(71,-25)->(38,-24)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-32|rel:-32)
; node # 67 D(82,-6)->(50,-7)
       fcb 2 ; drawmode 
       fcb -19,11 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:32|rel:64)
; node # 68 D(75,3)->(41,3)
       fcb 2 ; drawmode 
       fcb -9,-7 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1088|rel:-64) dy(abs:0|rel:-32)
; node # 69 M(96,11)->(68,12)
       fcb 0 ; drawmode 
       fcb -8,21 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-896|rel:192) dy(abs:-32|rel:-32)
; node # 70 D(96,24)->(71,27)
       fcb 2 ; drawmode 
       fcb -13,0 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:-96|rel:-64)
; node # 71 D(90,38)->(64,38)
       fcb 2 ; drawmode 
       fcb -14,-6 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-832|rel:-32) dy(abs:0|rel:96)
; node # 72 D(80,36)->(51,36)
       fcb 2 ; drawmode 
       fcb 2,-10 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-928|rel:-96) dy(abs:0|rel:0)
; node # 73 M(114,32)->(97,35)
       fcb 0 ; drawmode 
       fcb 4,34 ; starx/y relative to previous node
       fdb -96,384 ; dx/dy. dx(abs:-544|rel:384) dy(abs:-96|rel:-96)
; node # 74 D(118,35)->(104,33)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb 160,96 ; dx/dy. dx(abs:-448|rel:96) dy(abs:64|rel:160)
; node # 75 D(119,37)->(110,39)
       fcb 2 ; drawmode 
       fcb -2,1 ; starx/y relative to previous node
       fdb -128,160 ; dx/dy. dx(abs:-288|rel:160) dy(abs:-64|rel:-128)
; node # 76 D(120,40)->(109,45)
       fcb 2 ; drawmode 
       fcb -3,1 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:-160|rel:-96)
; node # 77 D(116,48)->(102,51)
       fcb 2 ; drawmode 
       fcb -8,-4 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:-96|rel:64)
; node # 78 D(114,32)->(97,35)
       fcb 2 ; drawmode 
       fcb 16,-2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-544|rel:-96) dy(abs:-96|rel:0)
; node # 79 M(80,36)->(51,36)
       fcb 0 ; drawmode 
       fcb -4,-34 ; starx/y relative to previous node
       fdb 96,-384 ; dx/dy. dx(abs:-928|rel:-384) dy(abs:0|rel:96)
; node # 80 D(80,25)->(49,27)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-992|rel:-64) dy(abs:-64|rel:-64)
; node # 81 D(89,22)->(58,23)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-992|rel:0) dy(abs:-32|rel:32)
; node # 82 D(96,11)->(68,12)
       fcb 2 ; drawmode 
       fcb 11,7 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:-32|rel:0)
; node # 83 M(75,3)->(41,3)
       fcb 0 ; drawmode 
       fcb 8,-21 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-1088|rel:-192) dy(abs:0|rel:32)
; node # 84 D(62,-7)->(26,-7)
       fcb 2 ; drawmode 
       fcb 10,-13 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1152|rel:-64) dy(abs:0|rel:0)
; node # 85 D(70,24)->(38,25)
       fcb 2 ; drawmode 
       fcb -31,8 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:-32|rel:-32)
; node # 86 D(65,22)->(32,22)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:0|rel:32)
; node # 87 D(53,-17)->(17,-17)
       fcb 2 ; drawmode 
       fcb 39,-12 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:0|rel:0)
; node # 88 D(49,-14)->(13,-15)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:32|rel:32)
; node # 89 D(36,-33)->(2,-33)
       fcb 2 ; drawmode 
       fcb 19,-13 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:0|rel:-32)
; node # 90 D(27,-30)->(-9,-31)
       fcb 2 ; drawmode 
       fcb -3,-9 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1152|rel:-64) dy(abs:32|rel:32)
; node # 91 D(10,-14)->(-26,-13)
       fcb 2 ; drawmode 
       fcb -16,-17 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:-64)
; node # 92 D(10,0)->(-26,0)
       fcb 2 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:0|rel:32)
; node # 93 M(54,102)->(34,103)
       fcb 0 ; drawmode 
       fcb -102,44 ; starx/y relative to previous node
       fdb -32,512 ; dx/dy. dx(abs:-640|rel:512) dy(abs:-32|rel:-32)
; node # 94 D(69,80)->(45,82)
       fcb 2 ; drawmode 
       fcb 22,15 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:-64|rel:-32)
; node # 95 D(85,74)->(61,78)
       fcb 2 ; drawmode 
       fcb 6,16 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-768|rel:0) dy(abs:-128|rel:-64)
; node # 96 D(94,65)->(77,64)
       fcb 2 ; drawmode 
       fcb 9,9 ; starx/y relative to previous node
       fdb 160,224 ; dx/dy. dx(abs:-544|rel:224) dy(abs:32|rel:160)
; node # 97 D(97,64)->(80,64)
       fcb 2 ; drawmode 
       fcb 1,3 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:0|rel:-32)
; node # 98 D(105,57)->(91,57)
       fcb 2 ; drawmode 
       fcb 7,8 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-448|rel:96) dy(abs:0|rel:0)
; node # 99 D(104,62)->(88,65)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-512|rel:-64) dy(abs:-96|rel:-96)
; node # 100 D(103,70)->(91,70)
       fcb 2 ; drawmode 
       fcb -8,-1 ; starx/y relative to previous node
       fdb 96,128 ; dx/dy. dx(abs:-384|rel:128) dy(abs:0|rel:96)
; node # 101 D(107,63)->(97,64)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-320|rel:64) dy(abs:-32|rel:-32)
; node # 102 D(113,54)->(101,55)
       fcb 2 ; drawmode 
       fcb 9,6 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-384|rel:-64) dy(abs:-32|rel:0)
; node # 103 D(99,79)->(94,79)
       fcb 2 ; drawmode 
       fcb -25,-14 ; starx/y relative to previous node
       fdb 32,224 ; dx/dy. dx(abs:-160|rel:224) dy(abs:0|rel:32)
; node # 104 D(83,96)->(79,97)
       fcb 2 ; drawmode 
       fcb -17,-16 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-128|rel:32) dy(abs:-32|rel:-32)
; node # 105 D(68,106)->(55,109)
       fcb 2 ; drawmode 
       fcb -10,-15 ; starx/y relative to previous node
       fdb -64,-288 ; dx/dy. dx(abs:-416|rel:-288) dy(abs:-96|rel:-64)
; node # 106 D(74,98)->(61,99)
       fcb 2 ; drawmode 
       fcb 8,6 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-416|rel:0) dy(abs:-32|rel:64)
; node # 107 D(54,102)->(33,103)
       fcb 2 ; drawmode 
       fcb -4,-20 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-672|rel:-256) dy(abs:-32|rel:0)
; node # 108 M(10,0)->(-26,0)
       fcb 0 ; drawmode 
       fcb 102,-44 ; starx/y relative to previous node
       fdb 32,-480 ; dx/dy. dx(abs:-1152|rel:-480) dy(abs:0|rel:32)
; node # 109 D(5,7)->(-33,6)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1216|rel:-64) dy(abs:32|rel:32)
; node # 110 D(-7,-18)->(-44,-19)
       fcb 2 ; drawmode 
       fcb 25,-12 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1184|rel:32) dy(abs:32|rel:0)
; node # 111 D(-10,-32)->(-45,-31)
       fcb 2 ; drawmode 
       fcb 14,-3 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-1120|rel:64) dy(abs:-32|rel:-64)
; node # 112 D(-15,-28)->(-50,-28)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:0|rel:32)
; node # 113 D(-18,-34)->(-54,-36)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:64|rel:64)
; node # 114 D(-25,-41)->(-61,-40)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:-96)
; node # 115 D(-44,-40)->(-75,-39)
       fcb 2 ; drawmode 
       fcb -1,-19 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-992|rel:160) dy(abs:-32|rel:0)
; node # 116 D(-48,-44)->(-78,-44)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:0|rel:32)
; node # 117 D(-56,-44)->(-84,-42)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-896|rel:64) dy(abs:-64|rel:-64)
; node # 118 D(-63,-52)->(-88,-52)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:0|rel:64)
; node # 119 D(-67,-51)->(-92,-50)
       fcb 2 ; drawmode 
       fcb -1,-4 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-800|rel:0) dy(abs:-32|rel:-32)
; node # 120 D(-62,-38)->(-89,-38)
       fcb 2 ; drawmode 
       fcb -13,5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:0|rel:32)
; node # 121 D(-57,-36)->(-86,-35)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:-32|rel:-32)
; node # 122 D(-50,-40)->(-81,-39)
       fcb 2 ; drawmode 
       fcb 4,7 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-992|rel:-64) dy(abs:-32|rel:0)
; node # 123 D(-42,-31)->(-74,-31)
       fcb 2 ; drawmode 
       fcb -9,8 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:0|rel:32)
       fcb  1  ; end of anim
; Animation 4
weltframe4:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-112,-51)->(-122,-39)
       fcb 0 ; drawmode 
       fcb 51,-112 ; starx/y relative to previous node
       fdb -384,-320 ; dx/dy. dx(abs:-320|rel:-320) dy(abs:-384|rel:-384)
; node # 1 D(-112,-51)->(-120,-45)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 192,64 ; dx/dy. dx(abs:-256|rel:64) dy(abs:-192|rel:192)
; node # 2 D(-114,-50)->(-120,-45)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-192|rel:64) dy(abs:-160|rel:32)
; node # 3 D(-116,-53)->(-116,-53)
       fcb 2 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb 160,192 ; dx/dy. dx(abs:0|rel:192) dy(abs:0|rel:160)
; node # 4 D(-121,-42)->(-121,-42)
       fcb 2 ; drawmode 
       fcb -11,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-128,-6)->(-128,-4)
       fcb 2 ; drawmode 
       fcb -36,-7 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-64|rel:-64)
; node # 6 D(-127,17)->(-127,17)
       fcb 2 ; drawmode 
       fcb -23,1 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:64)
; node # 7 D(-122,38)->(-122,40)
       fcb 2 ; drawmode 
       fcb -21,5 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-64|rel:-64)
; node # 8 D(-103,76)->(-103,76)
       fcb 2 ; drawmode 
       fcb -38,19 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:64)
; node # 9 D(-80,100)->(-91,89)
       fcb 2 ; drawmode 
       fcb -24,23 ; starx/y relative to previous node
       fdb 352,-352 ; dx/dy. dx(abs:-352|rel:-352) dy(abs:352|rel:352)
; node # 10 D(-80,100)->(-91,89)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:352|rel:0)
; node # 11 D(-87,87)->(-98,80)
       fcb 2 ; drawmode 
       fcb 13,-7 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:224|rel:-128)
; node # 12 D(-88,82)->(-102,75)
       fcb 2 ; drawmode 
       fcb 5,-1 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:224|rel:0)
; node # 13 D(-95,72)->(-105,70)
       fcb 2 ; drawmode 
       fcb 10,-7 ; starx/y relative to previous node
       fdb -160,128 ; dx/dy. dx(abs:-320|rel:128) dy(abs:64|rel:-160)
; node # 14 D(-93,67)->(-105,66)
       fcb 2 ; drawmode 
       fcb 5,2 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-384|rel:-64) dy(abs:32|rel:-32)
; node # 15 D(-106,37)->(-118,36)
       fcb 2 ; drawmode 
       fcb 30,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-384|rel:0) dy(abs:32|rel:0)
; node # 16 D(-97,22)->(-116,20)
       fcb 2 ; drawmode 
       fcb 15,9 ; starx/y relative to previous node
       fdb 32,-224 ; dx/dy. dx(abs:-608|rel:-224) dy(abs:64|rel:32)
; node # 17 D(-92,-1)->(-112,-1)
       fcb 2 ; drawmode 
       fcb 23,5 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-640|rel:-32) dy(abs:0|rel:-64)
; node # 18 D(-103,1)->(-119,0)
       fcb 2 ; drawmode 
       fcb -2,-11 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-512|rel:128) dy(abs:32|rel:32)
; node # 19 D(-109,-14)->(-122,-11)
       fcb 2 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb -128,96 ; dx/dy. dx(abs:-416|rel:96) dy(abs:-96|rel:-128)
; node # 20 D(-112,-51)->(-121,-41)
       fcb 2 ; drawmode 
       fcb 37,-3 ; starx/y relative to previous node
       fdb -224,128 ; dx/dy. dx(abs:-288|rel:128) dy(abs:-320|rel:-224)
; node # 21 M(-83,60)->(-102,60)
       fcb 0 ; drawmode 
       fcb -111,29 ; starx/y relative to previous node
       fdb 320,-320 ; dx/dy. dx(abs:-608|rel:-320) dy(abs:0|rel:320)
; node # 22 D(-87,69)->(-102,69)
       fcb 2 ; drawmode 
       fcb -9,-4 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-480|rel:128) dy(abs:0|rel:0)
; node # 23 D(-82,83)->(-96,80)
       fcb 2 ; drawmode 
       fcb -14,5 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-448|rel:32) dy(abs:96|rel:96)
; node # 24 D(-76,88)->(-91,85)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:96|rel:0)
; node # 25 D(-83,61)->(-102,60)
       fcb 2 ; drawmode 
       fcb 27,-7 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-608|rel:-128) dy(abs:32|rel:-64)
; node # 26 M(-74,-31)->(-100,-30)
       fcb 0 ; drawmode 
       fcb 92,9 ; starx/y relative to previous node
       fdb -64,-224 ; dx/dy. dx(abs:-832|rel:-224) dy(abs:-32|rel:-64)
; node # 27 D(-83,-18)->(-106,-18)
       fcb 2 ; drawmode 
       fcb -13,-9 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:0|rel:32)
; node # 28 D(-102,-5)->(-119,-4)
       fcb 2 ; drawmode 
       fcb -13,-19 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-544|rel:192) dy(abs:-32|rel:-32)
; node # 29 D(-107,-47)->(-119,-43)
       fcb 2 ; drawmode 
       fcb 42,-5 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-384|rel:160) dy(abs:-128|rel:-96)
; node # 30 D(-101,-64)->(-110,-64)
       fcb 2 ; drawmode 
       fcb 17,6 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:-288|rel:96) dy(abs:0|rel:128)
; node # 31 D(-106,-65)->(-110,-65)
       fcb 2 ; drawmode 
       fcb 1,-5 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-128|rel:160) dy(abs:0|rel:0)
; node # 32 D(-97,-76)->(-105,-73)
       fcb 2 ; drawmode 
       fcb 11,9 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-256|rel:-128) dy(abs:-96|rel:-96)
; node # 33 D(-94,-73)->(-105,-73)
       fcb 2 ; drawmode 
       fcb -3,3 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-352|rel:-96) dy(abs:0|rel:96)
; node # 34 D(-88,-78)->(-102,-78)
       fcb 2 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:0|rel:0)
; node # 35 D(-89,-82)->(-99,-81)
       fcb 2 ; drawmode 
       fcb 4,-1 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-320|rel:128) dy(abs:-32|rel:-32)
; node # 36 D(-86,-87)->(-95,-86)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-288|rel:32) dy(abs:-32|rel:0)
; node # 37 D(-109,-67)->(-109,-67)
       fcb 2 ; drawmode 
       fcb -20,-23 ; starx/y relative to previous node
       fdb 32,288 ; dx/dy. dx(abs:0|rel:288) dy(abs:0|rel:32)
; node # 38 D(-96,-85)->(-96,-85)
       fcb 2 ; drawmode 
       fcb 18,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-83,-98)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 13,13 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-32|rel:-32)
; node # 40 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 13,18 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:32)
; node # 41 D(8,-121)->(-8,-121)
       fcb 2 ; drawmode 
       fcb 10,73 ; starx/y relative to previous node
       fdb 0,-512 ; dx/dy. dx(abs:-512|rel:-512) dy(abs:0|rel:0)
; node # 42 D(56,-114)->(46,-114)
       fcb 2 ; drawmode 
       fcb -7,48 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-320|rel:192) dy(abs:0|rel:0)
; node # 43 D(57,-109)->(43,-109)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-448|rel:-128) dy(abs:0|rel:0)
; node # 44 D(39,-108)->(19,-108)
       fcb 2 ; drawmode 
       fcb -1,-18 ; starx/y relative to previous node
       fdb 0,-192 ; dx/dy. dx(abs:-640|rel:-192) dy(abs:0|rel:0)
; node # 45 D(43,-101)->(21,-102)
       fcb 2 ; drawmode 
       fcb -7,4 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:32|rel:32)
; node # 46 D(63,-91)->(35,-96)
       fcb 2 ; drawmode 
       fcb -10,20 ; starx/y relative to previous node
       fdb 128,-192 ; dx/dy. dx(abs:-896|rel:-192) dy(abs:160|rel:128)
; node # 47 D(63,-82)->(40,-82)
       fcb 2 ; drawmode 
       fcb -9,0 ; starx/y relative to previous node
       fdb -160,160 ; dx/dy. dx(abs:-736|rel:160) dy(abs:0|rel:-160)
; node # 48 D(61,-77)->(34,-82)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb 160,-128 ; dx/dy. dx(abs:-864|rel:-128) dy(abs:160|rel:160)
; node # 49 D(62,-73)->(34,-75)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:64|rel:-96)
; node # 50 D(56,-74)->(26,-75)
       fcb 2 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-960|rel:-64) dy(abs:32|rel:-32)
; node # 51 D(52,-62)->(22,-64)
       fcb 2 ; drawmode 
       fcb -12,-4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:64|rel:32)
; node # 52 D(64,-50)->(34,-49)
       fcb 2 ; drawmode 
       fcb -12,12 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:-32|rel:-96)
; node # 53 D(63,-36)->(29,-35)
       fcb 2 ; drawmode 
       fcb -14,-1 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1088|rel:-128) dy(abs:-32|rel:0)
; node # 54 D(42,-29)->(3,-30)
       fcb 2 ; drawmode 
       fcb -7,-21 ; starx/y relative to previous node
       fdb 64,-160 ; dx/dy. dx(abs:-1248|rel:-160) dy(abs:32|rel:64)
; node # 55 D(38,-24)->(1,-26)
       fcb 2 ; drawmode 
       fcb -5,-4 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-1184|rel:64) dy(abs:64|rel:32)
; node # 56 D(50,-7)->(14,-7)
       fcb 2 ; drawmode 
       fcb -17,12 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:0|rel:-64)
; node # 57 D(41,3)->(5,4)
       fcb 2 ; drawmode 
       fcb -10,-9 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:-32)
; node # 58 M(68,12)->(35,12)
       fcb 0 ; drawmode 
       fcb -9,27 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1056|rel:96) dy(abs:0|rel:32)
; node # 59 D(71,27)->(38,26)
       fcb 2 ; drawmode 
       fcb -15,3 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:32|rel:32)
; node # 60 D(64,38)->(31,39)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:-32|rel:-64)
; node # 61 D(51,36)->(16,37)
       fcb 2 ; drawmode 
       fcb 2,-13 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1120|rel:-64) dy(abs:-32|rel:0)
; node # 62 M(97,35)->(74,35)
       fcb 0 ; drawmode 
       fcb 1,46 ; starx/y relative to previous node
       fdb 32,384 ; dx/dy. dx(abs:-736|rel:384) dy(abs:0|rel:32)
; node # 63 D(104,33)->(83,34)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-672|rel:64) dy(abs:-32|rel:-32)
; node # 64 D(110,39)->(93,42)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-544|rel:128) dy(abs:-96|rel:-64)
; node # 65 D(109,45)->(94,48)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-480|rel:64) dy(abs:-96|rel:0)
; node # 66 D(109,45)->(93,54)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -192,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:-288|rel:-192)
; node # 67 D(109,45)->(88,48)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 192,-160 ; dx/dy. dx(abs:-672|rel:-160) dy(abs:-96|rel:192)
; node # 68 D(102,51)->(82,52)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:-32|rel:64)
; node # 69 D(100,44)->(79,49)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:-160|rel:-128)
; node # 70 D(99,41)->(80,44)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-608|rel:64) dy(abs:-96|rel:64)
; node # 71 D(97,35)->(74,40)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-736|rel:-128) dy(abs:-160|rel:-64)
; node # 72 D(97,35)->(68,32)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 256,-192 ; dx/dy. dx(abs:-928|rel:-192) dy(abs:96|rel:256)
; node # 73 D(97,35)->(74,35)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -96,192 ; dx/dy. dx(abs:-736|rel:192) dy(abs:0|rel:-96)
; node # 74 M(51,36)->(16,37)
       fcb 0 ; drawmode 
       fcb -1,-46 ; starx/y relative to previous node
       fdb -32,-384 ; dx/dy. dx(abs:-1120|rel:-384) dy(abs:-32|rel:-32)
; node # 75 D(49,27)->(15,27)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:0|rel:32)
; node # 76 D(58,23)->(25,22)
       fcb 2 ; drawmode 
       fcb 4,9 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:32|rel:32)
; node # 77 D(68,12)->(35,12)
       fcb 2 ; drawmode 
       fcb 11,10 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:-32)
; node # 78 M(41,3)->(5,4)
       fcb 0 ; drawmode 
       fcb 9,-27 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:-32|rel:-32)
; node # 79 D(26,-7)->(-13,-8)
       fcb 2 ; drawmode 
       fcb 10,-15 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-1248|rel:-96) dy(abs:32|rel:64)
; node # 80 D(30,4)->(-12,3)
       fcb 2 ; drawmode 
       fcb -11,4 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1344|rel:-96) dy(abs:32|rel:0)
; node # 81 D(38,25)->(0,24)
       fcb 2 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-1216|rel:128) dy(abs:32|rel:0)
; node # 82 D(32,22)->(-6,22)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1216|rel:0) dy(abs:0|rel:-32)
; node # 83 D(28,12)->(-15,8)
       fcb 2 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb 128,-160 ; dx/dy. dx(abs:-1376|rel:-160) dy(abs:128|rel:128)
; node # 84 D(17,-17)->(-22,-18)
       fcb 2 ; drawmode 
       fcb 29,-11 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-1248|rel:128) dy(abs:32|rel:-96)
; node # 85 D(13,-15)->(-24,-15)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1184|rel:64) dy(abs:0|rel:-32)
; node # 86 D(2,-33)->(-36,-32)
       fcb 2 ; drawmode 
       fcb 18,-11 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1216|rel:-32) dy(abs:-32|rel:-32)
; node # 87 D(-9,-31)->(-45,-31)
       fcb 2 ; drawmode 
       fcb -2,-11 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-1152|rel:64) dy(abs:0|rel:32)
; node # 88 D(-26,-13)->(-61,-14)
       fcb 2 ; drawmode 
       fcb -18,-17 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:32|rel:32)
; node # 89 D(-26,0)->(-62,0)
       fcb 2 ; drawmode 
       fcb -13,0 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:0|rel:-32)
; node # 90 M(34,103)->(12,105)
       fcb 0 ; drawmode 
       fcb -103,60 ; starx/y relative to previous node
       fdb -64,448 ; dx/dy. dx(abs:-704|rel:448) dy(abs:-64|rel:-64)
; node # 91 D(45,82)->(17,83)
       fcb 2 ; drawmode 
       fcb 21,11 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-896|rel:-192) dy(abs:-32|rel:32)
; node # 92 D(61,78)->(34,78)
       fcb 2 ; drawmode 
       fcb 4,16 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:0|rel:32)
; node # 93 D(77,64)->(49,64)
       fcb 2 ; drawmode 
       fcb 14,16 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:0|rel:0)
; node # 94 D(80,64)->(53,67)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:-96|rel:-96)
; node # 95 D(85,61)->(60,60)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:-800|rel:64) dy(abs:32|rel:128)
; node # 96 D(91,57)->(68,59)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-736|rel:64) dy(abs:-64|rel:-96)
; node # 97 D(88,65)->(65,67)
       fcb 2 ; drawmode 
       fcb -8,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:-64|rel:0)
; node # 98 D(91,70)->(71,73)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:-96|rel:-32)
; node # 99 D(97,64)->(75,66)
       fcb 2 ; drawmode 
       fcb 6,6 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:-64|rel:32)
; node # 100 D(101,55)->(81,56)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-640|rel:64) dy(abs:-32|rel:32)
; node # 101 D(94,79)->(76,89)
       fcb 2 ; drawmode 
       fcb -24,-7 ; starx/y relative to previous node
       fdb -288,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:-320|rel:-288)
; node # 102 D(79,97)->(64,99)
       fcb 2 ; drawmode 
       fcb -18,-15 ; starx/y relative to previous node
       fdb 256,96 ; dx/dy. dx(abs:-480|rel:96) dy(abs:-64|rel:256)
; node # 103 D(55,109)->(40,111)
       fcb 2 ; drawmode 
       fcb -12,-24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:-64|rel:0)
; node # 104 D(58,102)->(41,104)
       fcb 2 ; drawmode 
       fcb 7,3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-544|rel:-64) dy(abs:-64|rel:0)
; node # 105 D(61,99)->(38,100)
       fcb 2 ; drawmode 
       fcb 3,3 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-736|rel:-192) dy(abs:-32|rel:32)
; node # 106 D(33,103)->(12,105)
       fcb 2 ; drawmode 
       fcb -4,-28 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-672|rel:64) dy(abs:-64|rel:-32)
; node # 107 M(-26,0)->(-62,0)
       fcb 0 ; drawmode 
       fcb 103,-59 ; starx/y relative to previous node
       fdb 64,-480 ; dx/dy. dx(abs:-1152|rel:-480) dy(abs:0|rel:64)
; node # 108 D(-33,6)->(-67,7)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:-32|rel:-32)
; node # 109 D(-44,-19)->(-76,-20)
       fcb 2 ; drawmode 
       fcb 25,-11 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-1024|rel:64) dy(abs:32|rel:64)
; node # 110 D(-45,-31)->(-77,-32)
       fcb 2 ; drawmode 
       fcb 12,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:32|rel:0)
; node # 111 D(-50,-28)->(-82,-28)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:-32)
; node # 112 D(-54,-36)->(-86,-40)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb 128,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:128|rel:128)
; node # 113 D(-61,-40)->(-94,-39)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb -160,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-32|rel:-160)
; node # 114 D(-75,-39)->(-100,-38)
       fcb 2 ; drawmode 
       fcb -1,-14 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:-800|rel:256) dy(abs:-32|rel:0)
; node # 115 D(-78,-44)->(-102,-42)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:-64|rel:-32)
; node # 116 D(-84,-42)->(-106,-43)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:32|rel:96)
; node # 117 D(-88,-52)->(-106,-50)
       fcb 2 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:-64|rel:-96)
; node # 118 D(-92,-50)->(-110,-49)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-576|rel:0) dy(abs:-32|rel:32)
; node # 119 D(-89,-38)->(-110,-37)
       fcb 2 ; drawmode 
       fcb -12,3 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:-32|rel:0)
; node # 120 D(-86,-35)->(-108,-34)
       fcb 2 ; drawmode 
       fcb -3,3 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:-32|rel:0)
; node # 121 D(-81,-39)->(-103,-39)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:0|rel:32)
; node # 122 D(-74,-31)->(-100,-30)
       fcb 2 ; drawmode 
       fcb -8,7 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-832|rel:-128) dy(abs:-32|rel:-32)
       fcb  1  ; end of anim
; Animation 5
weltframe5:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-122,-39)->(-122,-39)
       fcb 0 ; drawmode 
       fcb 39,-122 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-128,-4)->(-128,-4)
       fcb 2 ; drawmode 
       fcb -35,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-127,17)->(-127,17)
       fcb 2 ; drawmode 
       fcb -21,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-122,40)->(-122,40)
       fcb 2 ; drawmode 
       fcb -23,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-103,76)->(-102,76)
       fcb 2 ; drawmode 
       fcb -36,19 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:0|rel:0)
; node # 5 D(-91,89)->(-91,89)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:0|rel:0)
; node # 6 D(-91,89)->(-91,89)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-98,80)->(-98,80)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-102,75)->(-102,76)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-32|rel:-32)
; node # 9 D(-105,70)->(-106,70)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:0|rel:32)
; node # 10 D(-105,66)->(-112,60)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 192,-192 ; dx/dy. dx(abs:-224|rel:-192) dy(abs:192|rel:192)
; node # 11 D(-118,36)->(-122,40)
       fcb 2 ; drawmode 
       fcb 30,-13 ; starx/y relative to previous node
       fdb -320,96 ; dx/dy. dx(abs:-128|rel:96) dy(abs:-128|rel:-320)
; node # 12 D(-116,20)->(-126,21)
       fcb 2 ; drawmode 
       fcb 16,2 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-320|rel:-192) dy(abs:-32|rel:96)
; node # 13 D(-112,-1)->(-128,-2)
       fcb 2 ; drawmode 
       fcb 21,4 ; starx/y relative to previous node
       fdb 64,-192 ; dx/dy. dx(abs:-512|rel:-192) dy(abs:32|rel:64)
; node # 14 D(-120,1)->(-128,1)
       fcb 2 ; drawmode 
       fcb -2,-8 ; starx/y relative to previous node
       fdb -32,256 ; dx/dy. dx(abs:-256|rel:256) dy(abs:0|rel:-32)
; node # 15 D(-122,-9)->(-127,-19)
       fcb 2 ; drawmode 
       fcb 10,-2 ; starx/y relative to previous node
       fdb 320,96 ; dx/dy. dx(abs:-160|rel:96) dy(abs:320|rel:320)
; node # 16 D(-122,-38)->(-122,-39)
       fcb 2 ; drawmode 
       fcb 29,0 ; starx/y relative to previous node
       fdb -288,160 ; dx/dy. dx(abs:0|rel:160) dy(abs:32|rel:-288)
; node # 17 M(-102,60)->(-107,66)
       fcb 0 ; drawmode 
       fcb -98,20 ; starx/y relative to previous node
       fdb -224,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:-192|rel:-224)
; node # 18 D(-102,69)->(-105,72)
       fcb 2 ; drawmode 
       fcb -9,0 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-96|rel:64) dy(abs:-96|rel:96)
; node # 19 D(-96,80)->(-97,81)
       fcb 2 ; drawmode 
       fcb -11,6 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-32|rel:64) dy(abs:-32|rel:64)
; node # 20 D(-91,85)->(-92,87)
       fcb 2 ; drawmode 
       fcb -5,5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:-64|rel:-32)
; node # 21 D(-102,60)->(-107,66)
       fcb 2 ; drawmode 
       fcb 25,-11 ; starx/y relative to previous node
       fdb -128,-128 ; dx/dy. dx(abs:-160|rel:-128) dy(abs:-192|rel:-128)
; node # 22 M(-100,-30)->(-116,-29)
       fcb 0 ; drawmode 
       fcb 90,2 ; starx/y relative to previous node
       fdb 160,-352 ; dx/dy. dx(abs:-512|rel:-352) dy(abs:-32|rel:160)
; node # 23 D(-106,-18)->(-121,-21)
       fcb 2 ; drawmode 
       fcb -12,-6 ; starx/y relative to previous node
       fdb 128,32 ; dx/dy. dx(abs:-480|rel:32) dy(abs:96|rel:128)
; node # 24 D(-119,-4)->(-128,-5)
       fcb 2 ; drawmode 
       fcb -14,-13 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-288|rel:192) dy(abs:32|rel:-64)
; node # 25 D(-119,-43)->(-122,-42)
       fcb 2 ; drawmode 
       fcb 39,0 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-96|rel:192) dy(abs:-32|rel:-64)
; node # 26 D(-114,-59)->(-116,-55)
       fcb 2 ; drawmode 
       fcb 16,5 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-64|rel:32) dy(abs:-128|rel:-96)
; node # 27 D(-102,-80)->(-102,-80)
       fcb 2 ; drawmode 
       fcb 21,12 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:128)
; node # 28 D(-84,-97)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 17,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-8,-121)->(-26,-120)
       fcb 2 ; drawmode 
       fcb 10,57 ; starx/y relative to previous node
       fdb -32,-576 ; dx/dy. dx(abs:-576|rel:-576) dy(abs:-32|rel:-32)
; node # 31 D(46,-114)->(30,-115)
       fcb 2 ; drawmode 
       fcb -7,54 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:32|rel:64)
; node # 32 D(44,-109)->(25,-110)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:32|rel:0)
; node # 33 D(19,-108)->(-2,-109)
       fcb 2 ; drawmode 
       fcb -1,-25 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-672|rel:-64) dy(abs:32|rel:0)
; node # 34 D(21,-102)->(-5,-103)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-832|rel:-160) dy(abs:32|rel:0)
; node # 35 D(35,-96)->(11,-95)
       fcb 2 ; drawmode 
       fcb -6,14 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-768|rel:64) dy(abs:-32|rel:-64)
; node # 36 D(40,-82)->(9,-82)
       fcb 2 ; drawmode 
       fcb -14,5 ; starx/y relative to previous node
       fdb 32,-224 ; dx/dy. dx(abs:-992|rel:-224) dy(abs:0|rel:32)
; node # 37 D(34,-82)->(5,-82)
       fcb 2 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-928|rel:64) dy(abs:0|rel:0)
; node # 38 D(34,-75)->(1,-74)
       fcb 2 ; drawmode 
       fcb -7,0 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-1056|rel:-128) dy(abs:-32|rel:-32)
; node # 39 D(26,-75)->(-2,-74)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-896|rel:160) dy(abs:-32|rel:0)
; node # 40 D(22,-64)->(-12,-64)
       fcb 2 ; drawmode 
       fcb -11,-4 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-1088|rel:-192) dy(abs:0|rel:32)
; node # 41 D(34,-49)->(-1,-49)
       fcb 2 ; drawmode 
       fcb -15,12 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:0|rel:0)
; node # 42 D(29,-35)->(-7,-35)
       fcb 2 ; drawmode 
       fcb -14,-5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:0|rel:0)
; node # 43 D(3,-30)->(-32,-29)
       fcb 2 ; drawmode 
       fcb -5,-26 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:-32|rel:-32)
; node # 44 D(1,-26)->(-38,-24)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-1248|rel:-128) dy(abs:-64|rel:-32)
; node # 45 D(14,-7)->(-23,-6)
       fcb 2 ; drawmode 
       fcb -19,13 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-1184|rel:64) dy(abs:-32|rel:32)
; node # 46 D(5,4)->(-33,5)
       fcb 2 ; drawmode 
       fcb -11,-9 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1216|rel:-32) dy(abs:-32|rel:0)
; node # 47 M(35,12)->(1,14)
       fcb 0 ; drawmode 
       fcb -8,30 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1088|rel:128) dy(abs:-64|rel:-32)
; node # 48 D(38,26)->(1,27)
       fcb 2 ; drawmode 
       fcb -14,3 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1184|rel:-96) dy(abs:-32|rel:32)
; node # 49 D(31,39)->(-5,39)
       fcb 2 ; drawmode 
       fcb -13,-7 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:0|rel:32)
; node # 50 D(16,37)->(-19,37)
       fcb 2 ; drawmode 
       fcb 2,-15 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:0|rel:0)
; node # 51 M(74,35)->(43,37)
       fcb 0 ; drawmode 
       fcb 2,58 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-992|rel:128) dy(abs:-64|rel:-64)
; node # 52 D(83,34)->(50,35)
       fcb 2 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:-32|rel:32)
; node # 53 D(93,42)->(67,42)
       fcb 2 ; drawmode 
       fcb -8,10 ; starx/y relative to previous node
       fdb 32,224 ; dx/dy. dx(abs:-832|rel:224) dy(abs:0|rel:32)
; node # 54 D(94,48)->(68,50)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:-64|rel:-64)
; node # 55 D(93,54)->(70,56)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:-64|rel:0)
; node # 56 D(88,48)->(62,49)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-832|rel:-96) dy(abs:-32|rel:32)
; node # 57 D(82,52)->(51,52)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-992|rel:-160) dy(abs:0|rel:32)
; node # 58 D(79,49)->(49,46)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:96|rel:96)
; node # 59 D(80,44)->(45,41)
       fcb 2 ; drawmode 
       fcb 5,1 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-1120|rel:-160) dy(abs:96|rel:0)
; node # 60 D(74,40)->(39,39)
       fcb 2 ; drawmode 
       fcb 4,-6 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:32|rel:-64)
; node # 61 D(68,32)->(35,32)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1056|rel:64) dy(abs:0|rel:-32)
; node # 62 D(74,35)->(43,37)
       fcb 2 ; drawmode 
       fcb -3,6 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:-64|rel:-64)
; node # 63 M(16,37)->(-19,37)
       fcb 0 ; drawmode 
       fcb -2,-58 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-1120|rel:-128) dy(abs:0|rel:64)
; node # 64 D(15,27)->(-23,26)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1216|rel:-96) dy(abs:32|rel:32)
; node # 65 D(25,22)->(-14,23)
       fcb 2 ; drawmode 
       fcb 5,10 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1248|rel:-32) dy(abs:-32|rel:-64)
; node # 66 D(35,12)->(-3,12)
       fcb 2 ; drawmode 
       fcb 10,10 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1216|rel:32) dy(abs:0|rel:32)
; node # 67 D(35,12)->(1,14)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-1088|rel:128) dy(abs:-64|rel:-64)
; node # 68 M(5,4)->(-33,5)
       fcb 0 ; drawmode 
       fcb 8,-30 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1216|rel:-128) dy(abs:-32|rel:32)
; node # 69 D(-13,-8)->(-48,-9)
       fcb 2 ; drawmode 
       fcb 12,-18 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-1120|rel:96) dy(abs:32|rel:64)
; node # 70 D(-12,3)->(-48,3)
       fcb 2 ; drawmode 
       fcb -11,1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:0|rel:-32)
; node # 71 D(0,24)->(-36,25)
       fcb 2 ; drawmode 
       fcb -21,12 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:-32)
; node # 72 D(-6,22)->(-42,22)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:0|rel:32)
; node # 73 D(-15,8)->(-51,8)
       fcb 2 ; drawmode 
       fcb 14,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:0|rel:0)
; node # 74 D(-22,-18)->(-56,-18)
       fcb 2 ; drawmode 
       fcb 26,-7 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:0|rel:0)
; node # 75 D(-24,-15)->(-59,-14)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:-32|rel:-32)
; node # 76 D(-36,-32)->(-68,-32)
       fcb 2 ; drawmode 
       fcb 17,-12 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1024|rel:96) dy(abs:0|rel:32)
; node # 77 D(-45,-31)->(-75,-31)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:0|rel:0)
; node # 78 D(-61,-14)->(-91,-15)
       fcb 2 ; drawmode 
       fcb -17,-16 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:32|rel:32)
; node # 79 D(-62,0)->(-91,0)
       fcb 2 ; drawmode 
       fcb -14,-1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:0|rel:-32)
; node # 80 M(12,105)->(-11,104)
       fcb 0 ; drawmode 
       fcb -105,74 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-736|rel:192) dy(abs:32|rel:32)
; node # 81 D(17,83)->(-13,83)
       fcb 2 ; drawmode 
       fcb 22,5 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-960|rel:-224) dy(abs:0|rel:-32)
; node # 82 D(34,78)->(2,79)
       fcb 2 ; drawmode 
       fcb 5,17 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:-32|rel:-32)
; node # 83 D(49,64)->(16,65)
       fcb 2 ; drawmode 
       fcb 14,15 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-32|rel:0)
; node # 84 D(53,67)->(24,67)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-928|rel:128) dy(abs:0|rel:32)
; node # 85 D(60,60)->(30,60)
       fcb 2 ; drawmode 
       fcb 7,7 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:0|rel:0)
; node # 86 D(68,59)->(39,61)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:-64|rel:-64)
; node # 87 D(65,67)->(37,69)
       fcb 2 ; drawmode 
       fcb -8,-3 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:-64|rel:0)
; node # 88 D(71,73)->(44,73)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:0|rel:64)
; node # 89 D(75,66)->(50,67)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-800|rel:64) dy(abs:-32|rel:-32)
; node # 90 D(81,56)->(54,58)
       fcb 2 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:-64|rel:-32)
; node # 91 D(76,89)->(55,90)
       fcb 2 ; drawmode 
       fcb -33,-5 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-672|rel:192) dy(abs:-32|rel:32)
; node # 92 D(64,99)->(40,105)
       fcb 2 ; drawmode 
       fcb -10,-12 ; starx/y relative to previous node
       fdb -160,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:-192|rel:-160)
; node # 93 D(40,111)->(22,112)
       fcb 2 ; drawmode 
       fcb -12,-24 ; starx/y relative to previous node
       fdb 160,192 ; dx/dy. dx(abs:-576|rel:192) dy(abs:-32|rel:160)
; node # 94 D(41,104)->(19,104)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-704|rel:-128) dy(abs:0|rel:32)
; node # 95 D(38,100)->(8,101)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb -32,-256 ; dx/dy. dx(abs:-960|rel:-256) dy(abs:-32|rel:-32)
; node # 96 D(12,105)->(-11,104)
       fcb 2 ; drawmode 
       fcb -5,-26 ; starx/y relative to previous node
       fdb 64,224 ; dx/dy. dx(abs:-736|rel:224) dy(abs:32|rel:64)
; node # 97 M(-62,0)->(-91,0)
       fcb 0 ; drawmode 
       fcb 105,-74 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-928|rel:-192) dy(abs:0|rel:-32)
; node # 98 D(-67,7)->(-95,7)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:0)
; node # 99 D(-76,-20)->(-101,-21)
       fcb 2 ; drawmode 
       fcb 27,-9 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:32|rel:32)
; node # 100 D(-77,-32)->(-102,-31)
       fcb 2 ; drawmode 
       fcb 12,-1 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-800|rel:0) dy(abs:-32|rel:-64)
; node # 101 D(-82,-28)->(-104,-27)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-704|rel:96) dy(abs:-32|rel:0)
; node # 102 D(-86,-40)->(-108,-39)
       fcb 2 ; drawmode 
       fcb 12,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:-32|rel:0)
; node # 103 D(-94,-39)->(-112,-37)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:-64|rel:-32)
; node # 104 D(-100,-38)->(-115,-37)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-480|rel:96) dy(abs:-32|rel:32)
; node # 105 D(-102,-42)->(-115,-41)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-416|rel:64) dy(abs:-32|rel:0)
; node # 106 D(-106,-43)->(-117,-41)
       fcb 2 ; drawmode 
       fcb 1,-4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-352|rel:64) dy(abs:-64|rel:-32)
; node # 107 D(-106,-50)->(-118,-47)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-384|rel:-32) dy(abs:-96|rel:-32)
; node # 108 D(-110,-49)->(-119,-46)
       fcb 2 ; drawmode 
       fcb -1,-4 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-288|rel:96) dy(abs:-96|rel:0)
; node # 109 D(-110,-37)->(-121,-38)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:32|rel:128)
; node # 110 D(-108,-34)->(-120,-34)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-384|rel:-32) dy(abs:0|rel:-32)
; node # 111 D(-103,-39)->(-118,-37)
       fcb 2 ; drawmode 
       fcb 5,5 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-480|rel:-96) dy(abs:-64|rel:-64)
; node # 112 D(-100,-30)->(-116,-29)
       fcb 2 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:-32|rel:32)
       fcb  1  ; end of anim
; Animation 6
weltframe6:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-103,78)->(-123,30)
       fcb 0 ; drawmode 
       fcb -78,-103 ; starx/y relative to previous node
       fdb 1536,-640 ; dx/dy. dx(abs:-640|rel:-640) dy(abs:1536|rel:1536)
; node # 1 D(-111,66)->(-125,20)
       fcb 2 ; drawmode 
       fcb 12,-8 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-448|rel:192) dy(abs:1472|rel:-64)
; node # 2 D(-123,37)->(-127,11)
       fcb 2 ; drawmode 
       fcb 29,-12 ; starx/y relative to previous node
       fdb -640,320 ; dx/dy. dx(abs:-128|rel:320) dy(abs:832|rel:-640)
; node # 3 D(-127,15)->(-128,-2)
       fcb 2 ; drawmode 
       fcb 22,-4 ; starx/y relative to previous node
       fdb -288,96 ; dx/dy. dx(abs:-32|rel:96) dy(abs:544|rel:-288)
; node # 4 D(-128,2)->(-128,1)
       fcb 2 ; drawmode 
       fcb 13,-1 ; starx/y relative to previous node
       fdb -512,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:32|rel:-512)
; node # 5 M(-116,-29)->(-124,-29)
       fcb 0 ; drawmode 
       fcb 31,12 ; starx/y relative to previous node
       fdb -32,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:0|rel:-32)
; node # 6 D(-121,-21)->(-126,-21)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-160|rel:96) dy(abs:0|rel:0)
; node # 7 D(-128,-5)->(-128,-6)
       fcb 2 ; drawmode 
       fcb -16,-7 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:0|rel:160) dy(abs:32|rel:32)
; node # 8 D(-125,-27)->(-126,-25)
       fcb 2 ; drawmode 
       fcb 22,3 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-64|rel:-96)
; node # 9 D(-116,-55)->(-116,-55)
       fcb 2 ; drawmode 
       fcb 28,9 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:64)
; node # 10 D(-102,-80)->(-102,-80)
       fcb 2 ; drawmode 
       fcb 25,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-84,-97)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 17,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-26,-120)->(-39,-120)
       fcb 2 ; drawmode 
       fcb 9,39 ; starx/y relative to previous node
       fdb 0,-416 ; dx/dy. dx(abs:-416|rel:-416) dy(abs:0|rel:0)
; node # 14 D(30,-115)->(12,-116)
       fcb 2 ; drawmode 
       fcb -5,56 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-576|rel:-160) dy(abs:32|rel:32)
; node # 15 D(25,-110)->(3,-110)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-704|rel:-128) dy(abs:0|rel:-32)
; node # 16 D(-2,-109)->(-24,-109)
       fcb 2 ; drawmode 
       fcb -1,-27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:0|rel:0)
; node # 17 D(-5,-103)->(-29,-102)
       fcb 2 ; drawmode 
       fcb -6,-3 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-768|rel:-64) dy(abs:-32|rel:-32)
; node # 18 D(11,-95)->(-16,-98)
       fcb 2 ; drawmode 
       fcb -8,16 ; starx/y relative to previous node
       fdb 128,-96 ; dx/dy. dx(abs:-864|rel:-96) dy(abs:96|rel:128)
; node # 19 D(9,-82)->(-20,-82)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:0|rel:-96)
; node # 20 D(5,-82)->(-24,-82)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:0|rel:0)
; node # 21 D(1,-74)->(-29,-75)
       fcb 2 ; drawmode 
       fcb -8,-4 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:32|rel:32)
; node # 22 D(-2,-74)->(-35,-74)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:0|rel:-32)
; node # 23 D(-12,-64)->(-44,-64)
       fcb 2 ; drawmode 
       fcb -10,-10 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:0|rel:0)
; node # 24 D(-1,-49)->(-36,-51)
       fcb 2 ; drawmode 
       fcb -15,11 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-1120|rel:-96) dy(abs:64|rel:64)
; node # 25 D(-7,-35)->(-42,-35)
       fcb 2 ; drawmode 
       fcb -14,-6 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:0|rel:-64)
; node # 26 D(-32,-29)->(-65,-30)
       fcb 2 ; drawmode 
       fcb -6,-25 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-1056|rel:64) dy(abs:32|rel:32)
; node # 27 D(-38,-24)->(-69,-23)
       fcb 2 ; drawmode 
       fcb -5,-6 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:-32|rel:-64)
; node # 28 D(-23,-6)->(-59,-6)
       fcb 2 ; drawmode 
       fcb -18,15 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-1152|rel:-160) dy(abs:0|rel:32)
; node # 29 D(-33,5)->(-67,4)
       fcb 2 ; drawmode 
       fcb -11,-10 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:32|rel:32)
; node # 30 M(1,14)->(-35,15)
       fcb 0 ; drawmode 
       fcb -9,34 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-1152|rel:-64) dy(abs:-32|rel:-64)
; node # 31 D(0,19)->(-38,20)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1216|rel:-64) dy(abs:-32|rel:0)
; node # 32 D(1,27)->(-35,26)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-1152|rel:64) dy(abs:32|rel:64)
; node # 33 D(-5,39)->(-41,38)
       fcb 2 ; drawmode 
       fcb -12,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:32|rel:0)
; node # 34 D(-19,37)->(-53,36)
       fcb 2 ; drawmode 
       fcb 2,-14 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:32|rel:0)
; node # 35 M(43,37)->(6,37)
       fcb 0 ; drawmode 
       fcb 0,62 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1184|rel:-96) dy(abs:0|rel:-32)
; node # 36 D(50,35)->(16,34)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:32|rel:32)
; node # 37 D(67,42)->(36,43)
       fcb 2 ; drawmode 
       fcb -7,17 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-992|rel:96) dy(abs:-32|rel:-64)
; node # 38 D(68,50)->(36,49)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:32|rel:64)
; node # 39 D(70,56)->(41,58)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb -96,96 ; dx/dy. dx(abs:-928|rel:96) dy(abs:-64|rel:-96)
; node # 40 D(62,49)->(28,50)
       fcb 2 ; drawmode 
       fcb 7,-8 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-1088|rel:-160) dy(abs:-32|rel:32)
; node # 41 D(51,52)->(20,54)
       fcb 2 ; drawmode 
       fcb -3,-11 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-992|rel:96) dy(abs:-64|rel:-32)
; node # 42 D(49,46)->(14,45)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb 96,-128 ; dx/dy. dx(abs:-1120|rel:-128) dy(abs:32|rel:96)
; node # 43 D(45,41)->(10,40)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:32|rel:0)
; node # 44 D(39,39)->(3,40)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:-32|rel:-64)
; node # 45 D(35,32)->(-1,32)
       fcb 2 ; drawmode 
       fcb 7,-4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:0|rel:32)
; node # 46 D(43,37)->(6,37)
       fcb 2 ; drawmode 
       fcb -5,8 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1184|rel:-32) dy(abs:0|rel:0)
; node # 47 M(-19,37)->(-53,36)
       fcb 0 ; drawmode 
       fcb 0,-62 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:32|rel:32)
; node # 48 D(-23,26)->(-57,26)
       fcb 2 ; drawmode 
       fcb 11,-4 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:0|rel:-32)
; node # 49 D(-14,23)->(-48,21)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:64|rel:64)
; node # 50 D(-3,12)->(-41,12)
       fcb 2 ; drawmode 
       fcb 11,11 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-1216|rel:-128) dy(abs:0|rel:-64)
; node # 51 D(1,14)->(-35,15)
       fcb 2 ; drawmode 
       fcb -2,4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1152|rel:64) dy(abs:-32|rel:-32)
; node # 52 M(-33,5)->(-67,4)
       fcb 0 ; drawmode 
       fcb 9,-34 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:32|rel:64)
; node # 53 D(-48,-9)->(-80,-8)
       fcb 2 ; drawmode 
       fcb 14,-15 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-1024|rel:64) dy(abs:-32|rel:-64)
; node # 54 D(-48,3)->(-80,3)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:32)
; node # 55 D(-36,25)->(-69,25)
       fcb 2 ; drawmode 
       fcb -22,12 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:0|rel:0)
; node # 56 D(-42,22)->(-74,22)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:0|rel:0)
; node # 57 D(-51,8)->(-83,8)
       fcb 2 ; drawmode 
       fcb 14,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:0)
; node # 58 D(-56,-18)->(-88,-18)
       fcb 2 ; drawmode 
       fcb 26,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:0)
; node # 59 D(-59,-14)->(-90,-15)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:32|rel:32)
; node # 60 D(-68,-32)->(-95,-31)
       fcb 2 ; drawmode 
       fcb 18,-9 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-864|rel:128) dy(abs:-32|rel:-64)
; node # 61 D(-75,-31)->(-101,-30)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-832|rel:32) dy(abs:-32|rel:0)
; node # 62 D(-91,-15)->(-112,-14)
       fcb 2 ; drawmode 
       fcb -16,-16 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-672|rel:160) dy(abs:-32|rel:0)
; node # 63 D(-91,0)->(-112,0)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-672|rel:0) dy(abs:0|rel:32)
; node # 64 M(-11,104)->(-33,104)
       fcb 0 ; drawmode 
       fcb -104,80 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:0|rel:0)
; node # 65 D(-13,83)->(-43,83)
       fcb 2 ; drawmode 
       fcb 21,-2 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-960|rel:-256) dy(abs:0|rel:0)
; node # 66 D(2,79)->(-26,78)
       fcb 2 ; drawmode 
       fcb 4,15 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-896|rel:64) dy(abs:32|rel:32)
; node # 67 D(16,65)->(-17,66)
       fcb 2 ; drawmode 
       fcb 14,14 ; starx/y relative to previous node
       fdb -64,-160 ; dx/dy. dx(abs:-1056|rel:-160) dy(abs:-32|rel:-64)
; node # 68 D(24,67)->(-10,68)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:-32|rel:0)
; node # 69 D(30,60)->(-4,61)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:-32|rel:0)
; node # 70 D(39,61)->(6,61)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:0|rel:32)
; node # 71 D(37,69)->(5,68)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:32|rel:32)
; node # 72 D(44,73)->(14,75)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:-64|rel:-96)
; node # 73 D(50,67)->(18,69)
       fcb 2 ; drawmode 
       fcb 6,6 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:-64|rel:0)
; node # 74 D(54,58)->(23,59)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:-32|rel:32)
; node # 75 D(54,64)->(26,67)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:-96|rel:-64)
; node # 76 D(54,74)->(26,77)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-896|rel:0) dy(abs:-96|rel:0)
; node # 77 D(55,90)->(32,92)
       fcb 2 ; drawmode 
       fcb -16,1 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:-736|rel:160) dy(abs:-64|rel:32)
; node # 78 D(40,105)->(15,108)
       fcb 2 ; drawmode 
       fcb -15,-15 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-800|rel:-64) dy(abs:-96|rel:-32)
; node # 79 D(22,112)->(1,112)
       fcb 2 ; drawmode 
       fcb -7,-18 ; starx/y relative to previous node
       fdb 96,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:0|rel:96)
; node # 80 D(19,104)->(-3,103)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:32|rel:32)
; node # 81 D(8,101)->(-19,101)
       fcb 2 ; drawmode 
       fcb 3,-11 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:-864|rel:-160) dy(abs:0|rel:-32)
; node # 82 D(-11,104)->(-33,104)
       fcb 2 ; drawmode 
       fcb -3,-19 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-704|rel:160) dy(abs:0|rel:0)
; node # 83 M(-91,0)->(-112,0)
       fcb 0 ; drawmode 
       fcb 104,-80 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:0|rel:0)
; node # 84 D(-95,7)->(-115,7)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:0|rel:0)
; node # 85 D(-101,-21)->(-119,-21)
       fcb 2 ; drawmode 
       fcb 28,-6 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:0|rel:0)
; node # 86 D(-102,-31)->(-118,-32)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:32|rel:32)
; node # 87 D(-104,-27)->(-120,-27)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-512|rel:0) dy(abs:0|rel:-32)
; node # 88 D(-108,-39)->(-120,-35)
       fcb 2 ; drawmode 
       fcb 12,-4 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-384|rel:128) dy(abs:-128|rel:-128)
; node # 89 D(-112,-37)->(-122,-37)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:-320|rel:64) dy(abs:0|rel:128)
; node # 90 D(-115,-37)->(-121,-37)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-192|rel:128) dy(abs:0|rel:0)
; node # 91 D(-115,-41)->(-120,-40)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-160|rel:32) dy(abs:-32|rel:-32)
; node # 92 D(-117,-41)->(-120,-41)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-96|rel:64) dy(abs:0|rel:32)
; node # 93 D(-118,-47)->(-118,-47)
       fcb 2 ; drawmode 
       fcb 6,-1 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:0)
; node # 94 D(-119,-46)->(-119,-46)
       fcb 2 ; drawmode 
       fcb -1,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 95 D(-121,-38)->(-121,-38)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 96 D(-120,-34)->(-120,-34)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 97 D(-118,-37)->(-123,-36)
       fcb 2 ; drawmode 
       fcb 3,2 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:-32|rel:-32)
; node # 98 D(-116,-29)->(-124,-29)
       fcb 2 ; drawmode 
       fcb -8,2 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-256|rel:-96) dy(abs:0|rel:32)
       fcb  1  ; end of anim
; Animation 7
weltframe7:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-124,-32)->(-124,-31)
       fcb 0 ; drawmode 
       fcb 32,-124 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-32|rel:-32)
; node # 1 D(-116,-55)->(-116,-55)
       fcb 2 ; drawmode 
       fcb 23,8 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:32)
; node # 2 D(-102,-80)->(-102,-80)
       fcb 2 ; drawmode 
       fcb 25,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-84,-97)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 17,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-44,-120)->(-51,-118)
       fcb 2 ; drawmode 
       fcb 9,21 ; starx/y relative to previous node
       fdb -64,-224 ; dx/dy. dx(abs:-224|rel:-224) dy(abs:-64|rel:-64)
; node # 6 D(12,-116)->(-9,-117)
       fcb 2 ; drawmode 
       fcb -4,56 ; starx/y relative to previous node
       fdb 96,-448 ; dx/dy. dx(abs:-672|rel:-448) dy(abs:32|rel:96)
; node # 7 D(3,-110)->(-19,-110)
       fcb 2 ; drawmode 
       fcb -6,-9 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:0|rel:-32)
; node # 8 D(-24,-109)->(-44,-107)
       fcb 2 ; drawmode 
       fcb -1,-27 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-640|rel:64) dy(abs:-64|rel:-64)
; node # 9 D(-29,-102)->(-51,-101)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:-32|rel:32)
; node # 10 D(-16,-98)->(-42,-98)
       fcb 2 ; drawmode 
       fcb -4,13 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-832|rel:-128) dy(abs:0|rel:32)
; node # 11 D(-20,-82)->(-47,-82)
       fcb 2 ; drawmode 
       fcb -16,-4 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-864|rel:-32) dy(abs:0|rel:0)
; node # 12 D(-24,-82)->(-53,-82)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:0|rel:0)
; node # 13 D(-29,-75)->(-58,-74)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:-32|rel:-32)
; node # 14 D(-35,-74)->(-66,-75)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-992|rel:-64) dy(abs:32|rel:64)
; node # 15 D(-44,-64)->(-72,-63)
       fcb 2 ; drawmode 
       fcb -10,-9 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:-32|rel:-64)
; node # 16 D(-36,-51)->(-67,-48)
       fcb 2 ; drawmode 
       fcb -13,8 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-992|rel:-96) dy(abs:-96|rel:-64)
; node # 17 D(-42,-35)->(-75,-34)
       fcb 2 ; drawmode 
       fcb -16,-6 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:-32|rel:64)
; node # 18 D(-65,-30)->(-93,-29)
       fcb 2 ; drawmode 
       fcb -5,-23 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-896|rel:160) dy(abs:-32|rel:0)
; node # 19 D(-69,-23)->(-96,-22)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:-32|rel:0)
; node # 20 D(-59,-6)->(-90,-5)
       fcb 2 ; drawmode 
       fcb -17,10 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-992|rel:-128) dy(abs:-32|rel:0)
; node # 21 D(-67,4)->(-95,4)
       fcb 2 ; drawmode 
       fcb -10,-8 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:0|rel:32)
; node # 22 M(-35,15)->(-69,16)
       fcb 0 ; drawmode 
       fcb -11,32 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-1088|rel:-192) dy(abs:-32|rel:-32)
; node # 23 D(-38,20)->(-71,22)
       fcb 2 ; drawmode 
       fcb -5,-3 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:-64|rel:-32)
; node # 24 D(-35,26)->(-68,26)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:64)
; node # 25 D(-41,38)->(-73,38)
       fcb 2 ; drawmode 
       fcb -12,-6 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:0|rel:0)
; node # 26 D(-53,36)->(-83,37)
       fcb 2 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:-32|rel:-32)
; node # 27 M(6,37)->(-28,37)
       fcb 0 ; drawmode 
       fcb -1,59 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1088|rel:-128) dy(abs:0|rel:32)
; node # 28 D(16,34)->(-20,35)
       fcb 2 ; drawmode 
       fcb 3,10 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1152|rel:-64) dy(abs:-32|rel:-32)
; node # 29 D(36,43)->(0,45)
       fcb 2 ; drawmode 
       fcb -9,20 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-64|rel:-32)
; node # 30 D(36,49)->(3,51)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-1056|rel:96) dy(abs:-64|rel:0)
; node # 31 D(41,58)->(8,58)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:64)
; node # 32 D(28,50)->(-7,50)
       fcb 2 ; drawmode 
       fcb 8,-13 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1120|rel:-64) dy(abs:0|rel:0)
; node # 33 D(20,54)->(-12,53)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1024|rel:96) dy(abs:32|rel:32)
; node # 34 D(14,45)->(-19,49)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb -160,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-128|rel:-160)
; node # 35 D(10,40)->(-26,40)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 128,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:0|rel:128)
; node # 36 D(3,40)->(-33,39)
       fcb 2 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:32|rel:32)
; node # 37 D(-1,32)->(-37,33)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:-64)
; node # 38 D(6,37)->(-28,37)
       fcb 2 ; drawmode 
       fcb -5,7 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:0|rel:32)
; node # 39 M(-53,36)->(-83,37)
       fcb 0 ; drawmode 
       fcb 1,-59 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-960|rel:128) dy(abs:-32|rel:-32)
; node # 40 D(-57,26)->(-88,25)
       fcb 2 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:32|rel:64)
; node # 41 D(-48,21)->(-81,22)
       fcb 2 ; drawmode 
       fcb 5,9 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:-32|rel:-64)
; node # 42 D(-41,12)->(-74,12)
       fcb 2 ; drawmode 
       fcb 9,7 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:32)
; node # 43 D(-35,15)->(-69,16)
       fcb 2 ; drawmode 
       fcb -3,6 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:-32|rel:-32)
; node # 44 M(-67,4)->(-95,4)
       fcb 0 ; drawmode 
       fcb 11,-32 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-896|rel:192) dy(abs:0|rel:32)
; node # 45 D(-80,-8)->(-106,-8)
       fcb 2 ; drawmode 
       fcb 12,-13 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:0|rel:0)
; node # 46 D(-80,3)->(-105,3)
       fcb 2 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-800|rel:32) dy(abs:0|rel:0)
; node # 47 D(-69,25)->(-95,24)
       fcb 2 ; drawmode 
       fcb -22,11 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-832|rel:-32) dy(abs:32|rel:32)
; node # 48 D(-74,22)->(-101,21)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-864|rel:-32) dy(abs:32|rel:0)
; node # 49 D(-83,8)->(-107,6)
       fcb 2 ; drawmode 
       fcb 14,-9 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-768|rel:96) dy(abs:64|rel:32)
; node # 50 D(-83,-13)->(-108,-15)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:64|rel:0)
; node # 51 D(-88,-18)->(-110,-17)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb -96,96 ; dx/dy. dx(abs:-704|rel:96) dy(abs:-32|rel:-96)
; node # 52 D(-90,-15)->(-111,-14)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:-32|rel:0)
; node # 53 D(-95,-31)->(-115,-31)
       fcb 2 ; drawmode 
       fcb 16,-5 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:0|rel:32)
; node # 54 D(-101,-30)->(-119,-28)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:-64|rel:-64)
; node # 55 D(-112,-14)->(-125,-12)
       fcb 2 ; drawmode 
       fcb -16,-11 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-416|rel:160) dy(abs:-64|rel:0)
; node # 56 D(-112,0)->(-124,0)
       fcb 2 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-384|rel:32) dy(abs:0|rel:64)
; node # 57 M(-33,104)->(-55,104)
       fcb 0 ; drawmode 
       fcb -104,79 ; starx/y relative to previous node
       fdb 0,-320 ; dx/dy. dx(abs:-704|rel:-320) dy(abs:0|rel:0)
; node # 58 D(-43,83)->(-65,83)
       fcb 2 ; drawmode 
       fcb 21,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:0|rel:0)
; node # 59 D(-26,78)->(-56,77)
       fcb 2 ; drawmode 
       fcb 5,17 ; starx/y relative to previous node
       fdb 32,-256 ; dx/dy. dx(abs:-960|rel:-256) dy(abs:32|rel:32)
; node # 60 D(-17,66)->(-48,65)
       fcb 2 ; drawmode 
       fcb 12,9 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:32|rel:0)
; node # 61 D(-10,68)->(-41,68)
       fcb 2 ; drawmode 
       fcb -2,7 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-992|rel:0) dy(abs:0|rel:-32)
; node # 62 D(-4,61)->(-37,60)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:32|rel:32)
; node # 63 D(6,61)->(-26,61)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:0|rel:-32)
; node # 64 D(5,68)->(-28,67)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:32|rel:32)
; node # 65 D(14,75)->(-17,75)
       fcb 2 ; drawmode 
       fcb -7,9 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:0|rel:-32)
; node # 66 D(18,69)->(-13,68)
       fcb 2 ; drawmode 
       fcb 6,4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-992|rel:0) dy(abs:32|rel:32)
; node # 67 D(23,59)->(-12,60)
       fcb 2 ; drawmode 
       fcb 10,5 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-1120|rel:-128) dy(abs:-32|rel:-64)
; node # 68 D(26,67)->(-5,68)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-992|rel:128) dy(abs:-32|rel:0)
; node # 69 D(26,77)->(-4,77)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:0|rel:32)
; node # 70 D(32,92)->(5,91)
       fcb 2 ; drawmode 
       fcb -15,6 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-864|rel:96) dy(abs:32|rel:32)
; node # 71 D(15,108)->(-5,107)
       fcb 2 ; drawmode 
       fcb -16,-17 ; starx/y relative to previous node
       fdb 0,224 ; dx/dy. dx(abs:-640|rel:224) dy(abs:32|rel:0)
; node # 72 D(1,112)->(-21,110)
       fcb 2 ; drawmode 
       fcb -4,-14 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:64|rel:32)
; node # 73 D(-3,103)->(-31,100)
       fcb 2 ; drawmode 
       fcb 9,-4 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-896|rel:-192) dy(abs:96|rel:32)
; node # 74 D(-19,101)->(-43,101)
       fcb 2 ; drawmode 
       fcb 2,-16 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-768|rel:128) dy(abs:0|rel:-96)
; node # 75 D(-33,104)->(-55,104)
       fcb 2 ; drawmode 
       fcb -3,-14 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:0|rel:0)
; node # 76 M(-112,0)->(-124,0)
       fcb 0 ; drawmode 
       fcb 104,-79 ; starx/y relative to previous node
       fdb 0,320 ; dx/dy. dx(abs:-384|rel:320) dy(abs:0|rel:0)
; node # 77 D(-115,7)->(-126,5)
       fcb 2 ; drawmode 
       fcb -7,-3 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:64|rel:64)
; node # 78 D(-119,-21)->(-126,-20)
       fcb 2 ; drawmode 
       fcb 28,-4 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-224|rel:128) dy(abs:-32|rel:-96)
; node # 79 D(-118,-32)->(-124,-31)
       fcb 2 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-192|rel:32) dy(abs:-32|rel:0)
; node # 80 D(-120,-27)->(-125,-26)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-160|rel:32) dy(abs:-32|rel:0)
; node # 81 D(-120,-36)->(-123,-36)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-96|rel:64) dy(abs:0|rel:32)
; node # 82 D(-120,-37)->(-123,-34)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-96|rel:0) dy(abs:-96|rel:-96)
; node # 83 D(-124,-32)->(-124,-31)
       fcb 2 ; drawmode 
       fcb -5,-4 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:-32|rel:64)
       fcb  1  ; end of anim
; Animation 8
weltframe8:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-122,-40)->(-123,-36)
       fcb 0 ; drawmode 
       fcb 40,-122 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-128|rel:-128)
; node # 1 D(-114,-60)->(-115,-59)
       fcb 2 ; drawmode 
       fcb 20,8 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:-32|rel:96)
; node # 2 D(-102,-80)->(-102,-80)
       fcb 2 ; drawmode 
       fcb 20,12 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:32)
; node # 3 D(-84,-97)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 17,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-51,-118)->(-51,-118)
       fcb 2 ; drawmode 
       fcb 7,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-9,-117)->(-26,-117)
       fcb 2 ; drawmode 
       fcb -1,42 ; starx/y relative to previous node
       fdb 0,-544 ; dx/dy. dx(abs:-544|rel:-544) dy(abs:0|rel:0)
; node # 7 D(-19,-110)->(-36,-110)
       fcb 2 ; drawmode 
       fcb -7,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:0|rel:0)
; node # 8 D(-44,-107)->(-57,-107)
       fcb 2 ; drawmode 
       fcb -3,-25 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-416|rel:128) dy(abs:0|rel:0)
; node # 9 D(-51,-101)->(-67,-101)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-512|rel:-96) dy(abs:0|rel:0)
; node # 10 D(-42,-98)->(-62,-98)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-640|rel:-128) dy(abs:0|rel:0)
; node # 11 D(-47,-82)->(-71,-81)
       fcb 2 ; drawmode 
       fcb -16,-5 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:-32|rel:-32)
; node # 12 D(-53,-82)->(-76,-80)
       fcb 2 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-736|rel:32) dy(abs:-64|rel:-32)
; node # 13 D(-58,-74)->(-82,-74)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:0|rel:64)
; node # 14 D(-66,-75)->(-86,-72)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-640|rel:128) dy(abs:-96|rel:-96)
; node # 15 D(-72,-63)->(-93,-62)
       fcb 2 ; drawmode 
       fcb -12,-6 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:-32|rel:64)
; node # 16 D(-67,-48)->(-93,-48)
       fcb 2 ; drawmode 
       fcb -15,5 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-832|rel:-160) dy(abs:0|rel:32)
; node # 17 D(-75,-34)->(-100,-34)
       fcb 2 ; drawmode 
       fcb -14,-8 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-800|rel:32) dy(abs:0|rel:0)
; node # 18 D(-93,-29)->(-112,-29)
       fcb 2 ; drawmode 
       fcb -5,-18 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-608|rel:192) dy(abs:0|rel:0)
; node # 19 D(-96,-22)->(-115,-22)
       fcb 2 ; drawmode 
       fcb -7,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:0|rel:0)
; node # 20 D(-90,-5)->(-111,-3)
       fcb 2 ; drawmode 
       fcb -17,6 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-672|rel:-64) dy(abs:-64|rel:-64)
; node # 21 D(-95,4)->(-115,3)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:32|rel:96)
; node # 22 M(-69,16)->(-96,14)
       fcb 0 ; drawmode 
       fcb -12,26 ; starx/y relative to previous node
       fdb 32,-224 ; dx/dy. dx(abs:-864|rel:-224) dy(abs:64|rel:32)
; node # 23 D(-71,22)->(-97,22)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-832|rel:32) dy(abs:0|rel:-64)
; node # 24 D(-68,26)->(-95,25)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-864|rel:-32) dy(abs:32|rel:32)
; node # 25 D(-73,38)->(-97,37)
       fcb 2 ; drawmode 
       fcb -12,-5 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-768|rel:96) dy(abs:32|rel:0)
; node # 26 D(-83,37)->(-105,37)
       fcb 2 ; drawmode 
       fcb 1,-10 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:0|rel:-32)
; node # 27 M(-28,37)->(-62,36)
       fcb 0 ; drawmode 
       fcb 0,55 ; starx/y relative to previous node
       fdb 32,-384 ; dx/dy. dx(abs:-1088|rel:-384) dy(abs:32|rel:32)
; node # 28 D(-20,35)->(-57,34)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1184|rel:-96) dy(abs:32|rel:0)
; node # 29 D(0,45)->(-33,45)
       fcb 2 ; drawmode 
       fcb -10,20 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1056|rel:128) dy(abs:0|rel:-32)
; node # 30 D(3,51)->(-33,50)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:32|rel:32)
; node # 31 D(8,58)->(-25,58)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1056|rel:96) dy(abs:0|rel:-32)
; node # 32 D(-7,50)->(-41,49)
       fcb 2 ; drawmode 
       fcb 8,-15 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:32|rel:32)
; node # 33 D(-12,53)->(-44,54)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-1024|rel:64) dy(abs:-32|rel:-64)
; node # 34 D(-19,49)->(-53,49)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1088|rel:-64) dy(abs:0|rel:32)
; node # 35 D(-26,40)->(-56,42)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-960|rel:128) dy(abs:-64|rel:-64)
; node # 36 D(-33,39)->(-66,38)
       fcb 2 ; drawmode 
       fcb 1,-7 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:32|rel:96)
; node # 37 D(-37,33)->(-71,31)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:64|rel:32)
; node # 38 D(-28,37)->(-62,36)
       fcb 2 ; drawmode 
       fcb -4,9 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:32|rel:-32)
; node # 39 M(-83,37)->(-105,37)
       fcb 0 ; drawmode 
       fcb 0,-55 ; starx/y relative to previous node
       fdb -32,384 ; dx/dy. dx(abs:-704|rel:384) dy(abs:0|rel:-32)
; node # 40 D(-88,25)->(-110,25)
       fcb 2 ; drawmode 
       fcb 12,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:0|rel:0)
; node # 41 D(-81,22)->(-106,24)
       fcb 2 ; drawmode 
       fcb 3,7 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-800|rel:-96) dy(abs:-64|rel:-64)
; node # 42 D(-74,12)->(-101,12)
       fcb 2 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:0|rel:64)
; node # 43 D(-69,16)->(-96,14)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-864|rel:0) dy(abs:64|rel:64)
; node # 44 M(-95,4)->(-115,3)
       fcb 0 ; drawmode 
       fcb 12,-26 ; starx/y relative to previous node
       fdb -32,224 ; dx/dy. dx(abs:-640|rel:224) dy(abs:32|rel:-32)
; node # 45 D(-106,-8)->(-121,-6)
       fcb 2 ; drawmode 
       fcb 12,-11 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-480|rel:160) dy(abs:-64|rel:-96)
; node # 46 D(-105,3)->(-121,3)
       fcb 2 ; drawmode 
       fcb -11,1 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:0|rel:64)
; node # 47 D(-95,24)->(-115,25)
       fcb 2 ; drawmode 
       fcb -21,10 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-640|rel:-128) dy(abs:-32|rel:-32)
; node # 48 D(-101,21)->(-118,20)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-544|rel:96) dy(abs:32|rel:64)
; node # 49 D(-107,6)->(-122,6)
       fcb 2 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-480|rel:64) dy(abs:0|rel:-32)
; node # 50 D(-108,-15)->(-122,-15)
       fcb 2 ; drawmode 
       fcb 21,-1 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-448|rel:32) dy(abs:0|rel:0)
; node # 51 D(-110,-17)->(-122,-16)
       fcb 2 ; drawmode 
       fcb 2,-2 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:-32|rel:-32)
; node # 52 D(-111,-14)->(-124,-13)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-416|rel:-32) dy(abs:-32|rel:0)
; node # 53 D(-115,-31)->(-124,-31)
       fcb 2 ; drawmode 
       fcb 17,-4 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-288|rel:128) dy(abs:0|rel:32)
; node # 54 D(-119,-28)->(-125,-28)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-192|rel:96) dy(abs:0|rel:0)
; node # 55 D(-125,-12)->(-127,-11)
       fcb 2 ; drawmode 
       fcb -16,-6 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-64|rel:128) dy(abs:-32|rel:-32)
; node # 56 D(-124,0)->(-128,0)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:0|rel:32)
; node # 57 M(-55,104)->(-68,103)
       fcb 0 ; drawmode 
       fcb -104,69 ; starx/y relative to previous node
       fdb 32,-288 ; dx/dy. dx(abs:-416|rel:-288) dy(abs:32|rel:32)
; node # 58 D(-65,83)->(-85,80)
       fcb 2 ; drawmode 
       fcb 21,-10 ; starx/y relative to previous node
       fdb 64,-224 ; dx/dy. dx(abs:-640|rel:-224) dy(abs:96|rel:64)
; node # 59 D(-56,77)->(-79,76)
       fcb 2 ; drawmode 
       fcb 6,9 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:32|rel:-64)
; node # 60 D(-48,65)->(-75,64)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-864|rel:-128) dy(abs:32|rel:0)
; node # 61 D(-41,68)->(-69,68)
       fcb 2 ; drawmode 
       fcb -3,7 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:0|rel:-32)
; node # 62 D(-37,60)->(-67,60)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-960|rel:-64) dy(abs:0|rel:0)
; node # 63 D(-26,61)->(-58,60)
       fcb 2 ; drawmode 
       fcb -1,11 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:32|rel:32)
; node # 64 D(-28,67)->(-58,67)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:0|rel:-32)
; node # 65 D(-17,75)->(-50,74)
       fcb 2 ; drawmode 
       fcb -8,11 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:32|rel:32)
; node # 66 D(-13,68)->(-45,68)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:0|rel:-32)
; node # 67 D(-12,60)->(-44,59)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:32|rel:32)
; node # 68 D(-5,68)->(-37,69)
       fcb 2 ; drawmode 
       fcb -8,7 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:-32|rel:-64)
; node # 69 D(-4,77)->(-37,75)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:64|rel:96)
; node # 70 D(5,91)->(-22,90)
       fcb 2 ; drawmode 
       fcb -14,9 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-864|rel:192) dy(abs:32|rel:-32)
; node # 71 D(-5,107)->(-29,108)
       fcb 2 ; drawmode 
       fcb -16,-10 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-768|rel:96) dy(abs:-32|rel:-64)
; node # 72 D(-21,110)->(-39,111)
       fcb 2 ; drawmode 
       fcb -3,-16 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-576|rel:192) dy(abs:-32|rel:0)
; node # 73 D(-31,100)->(-51,101)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-640|rel:-64) dy(abs:-32|rel:0)
; node # 74 D(-43,101)->(-60,99)
       fcb 2 ; drawmode 
       fcb -1,-12 ; starx/y relative to previous node
       fdb 96,96 ; dx/dy. dx(abs:-544|rel:96) dy(abs:64|rel:96)
; node # 75 D(-55,104)->(-68,103)
       fcb 2 ; drawmode 
       fcb -3,-12 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-416|rel:128) dy(abs:32|rel:-32)
; node # 76 M(-124,0)->(-128,0)
       fcb 0 ; drawmode 
       fcb 104,-69 ; starx/y relative to previous node
       fdb -32,288 ; dx/dy. dx(abs:-128|rel:288) dy(abs:0|rel:-32)
; node # 77 D(-126,5)->(-128,4)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:32|rel:32)
; node # 78 D(-126,-6)->(-128,-6)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-64|rel:0) dy(abs:0|rel:-32)
; node # 79 D(-126,-20)->(-126,-20)
       fcb 2 ; drawmode 
       fcb 14,0 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:0)
; node # 80 D(-122,-40)->(-123,-36)
       fcb 2 ; drawmode 
       fcb 20,4 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-128|rel:-128)
; node # 81 M(-20,-81)->(-18,-86)
       fcb 0 ; drawmode 
       fcb 41,102 ; starx/y relative to previous node
       fdb 288,96 ; dx/dy. dx(abs:64|rel:96) dy(abs:160|rel:288)
; node # 82 M(58,-114)->(55,-115)
       fcb 0 ; drawmode 
       fcb 33,78 ; starx/y relative to previous node
       fdb -128,-160 ; dx/dy. dx(abs:-96|rel:-160) dy(abs:32|rel:-128)
; node # 83 D(71,-106)->(68,-103)
       fcb 2 ; drawmode 
       fcb -8,13 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-96|rel:0) dy(abs:-96|rel:-128)
; node # 84 D(70,-107)->(73,-102)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:96|rel:192) dy(abs:-160|rel:-64)
; node # 85 D(72,-106)->(88,-91)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb -320,416 ; dx/dy. dx(abs:512|rel:416) dy(abs:-480|rel:-320)
; node # 86 D(78,-100)->(99,-79)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb -192,160 ; dx/dy. dx(abs:672|rel:160) dy(abs:-672|rel:-192)
; node # 87 D(79,-100)->(117,-52)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb -864,544 ; dx/dy. dx(abs:1216|rel:544) dy(abs:-1536|rel:-864)
; node # 88 D(78,-100)->(100,-78)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 832,-512 ; dx/dy. dx(abs:704|rel:-512) dy(abs:-704|rel:832)
; node # 89 D(79,-99)->(88,-91)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 448,-416 ; dx/dy. dx(abs:288|rel:-416) dy(abs:-256|rel:448)
; node # 90 D(79,-100)->(72,-105)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 416,-512 ; dx/dy. dx(abs:-224|rel:-512) dy(abs:160|rel:416)
; node # 91 D(65,-111)->(63,-111)
       fcb 2 ; drawmode 
       fcb 11,-14 ; starx/y relative to previous node
       fdb -160,160 ; dx/dy. dx(abs:-64|rel:160) dy(abs:0|rel:-160)
; node # 92 D(58,-114)->(55,-115)
       fcb 2 ; drawmode 
       fcb 3,-7 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:32|rel:32)
       fcb  1  ; end of anim
; Animation 9
weltframe9:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-123,-36)->(-123,-36)
       fcb 0 ; drawmode 
       fcb 36,-123 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-115,-59)->(-115,-59)
       fcb 2 ; drawmode 
       fcb 23,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-102,-80)->(-102,-80)
       fcb 2 ; drawmode 
       fcb 21,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-84,-97)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 17,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-51,-118)->(-51,-118)
       fcb 2 ; drawmode 
       fcb 7,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-26,-117)->(-42,-116)
       fcb 2 ; drawmode 
       fcb -1,25 ; starx/y relative to previous node
       fdb -32,-512 ; dx/dy. dx(abs:-512|rel:-512) dy(abs:-32|rel:-32)
; node # 7 D(-36,-110)->(-56,-108)
       fcb 2 ; drawmode 
       fcb -7,-10 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-640|rel:-128) dy(abs:-64|rel:-32)
; node # 8 D(-57,-107)->(-71,-105)
       fcb 2 ; drawmode 
       fcb -3,-21 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-448|rel:192) dy(abs:-64|rel:0)
; node # 9 D(-67,-101)->(-79,-98)
       fcb 2 ; drawmode 
       fcb -6,-10 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:-96|rel:-32)
; node # 10 D(-62,-98)->(-78,-97)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-512|rel:-128) dy(abs:-32|rel:64)
; node # 11 D(-71,-81)->(-87,-81)
       fcb 2 ; drawmode 
       fcb -17,-9 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-512|rel:0) dy(abs:0|rel:32)
; node # 12 D(-76,-80)->(-93,-78)
       fcb 2 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-544|rel:-32) dy(abs:-64|rel:-64)
; node # 13 D(-82,-74)->(-99,-71)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:-96|rel:-32)
; node # 14 D(-86,-72)->(-101,-70)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-480|rel:64) dy(abs:-64|rel:32)
; node # 15 D(-93,-62)->(-107,-62)
       fcb 2 ; drawmode 
       fcb -10,-7 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-448|rel:32) dy(abs:0|rel:64)
; node # 16 D(-93,-48)->(-111,-47)
       fcb 2 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-576|rel:-128) dy(abs:-32|rel:-32)
; node # 17 D(-100,-34)->(-116,-33)
       fcb 2 ; drawmode 
       fcb -14,-7 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:-32|rel:0)
; node # 18 D(-112,-29)->(-123,-27)
       fcb 2 ; drawmode 
       fcb -5,-12 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-352|rel:160) dy(abs:-64|rel:-32)
; node # 19 D(-115,-22)->(-124,-25)
       fcb 2 ; drawmode 
       fcb -7,-3 ; starx/y relative to previous node
       fdb 160,64 ; dx/dy. dx(abs:-288|rel:64) dy(abs:96|rel:160)
; node # 20 D(-111,-3)->(-124,-3)
       fcb 2 ; drawmode 
       fcb -19,4 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-416|rel:-128) dy(abs:0|rel:-96)
; node # 21 D(-115,3)->(-126,3)
       fcb 2 ; drawmode 
       fcb -6,-4 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-352|rel:64) dy(abs:0|rel:0)
; node # 22 M(-96,14)->(-115,12)
       fcb 0 ; drawmode 
       fcb -11,19 ; starx/y relative to previous node
       fdb 64,-256 ; dx/dy. dx(abs:-608|rel:-256) dy(abs:64|rel:64)
; node # 23 D(-97,22)->(-115,21)
       fcb 2 ; drawmode 
       fcb -8,-1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:32|rel:-32)
; node # 24 D(-95,25)->(-114,26)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:-32|rel:-64)
; node # 25 D(-97,37)->(-114,35)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-544|rel:64) dy(abs:64|rel:96)
; node # 26 D(-105,37)->(-119,34)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-448|rel:96) dy(abs:96|rel:32)
; node # 27 M(-62,36)->(-90,36)
       fcb 0 ; drawmode 
       fcb 1,43 ; starx/y relative to previous node
       fdb -96,-448 ; dx/dy. dx(abs:-896|rel:-448) dy(abs:0|rel:-96)
; node # 28 D(-57,34)->(-85,34)
       fcb 2 ; drawmode 
       fcb 2,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-896|rel:0) dy(abs:0|rel:0)
; node # 29 D(-33,45)->(-65,45)
       fcb 2 ; drawmode 
       fcb -11,24 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1024|rel:-128) dy(abs:0|rel:0)
; node # 30 D(-33,50)->(-65,50)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:0)
; node # 31 D(-25,58)->(-56,58)
       fcb 2 ; drawmode 
       fcb -8,8 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:0|rel:0)
; node # 32 D(-41,49)->(-72,49)
       fcb 2 ; drawmode 
       fcb 9,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-992|rel:0) dy(abs:0|rel:0)
; node # 33 D(-44,54)->(-74,53)
       fcb 2 ; drawmode 
       fcb -5,-3 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:32|rel:32)
; node # 34 D(-53,49)->(-81,49)
       fcb 2 ; drawmode 
       fcb 5,-9 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-896|rel:64) dy(abs:0|rel:-32)
; node # 35 D(-56,42)->(-82,44)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:-64|rel:-64)
; node # 36 D(-66,38)->(-92,38)
       fcb 2 ; drawmode 
       fcb 4,-10 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:0|rel:64)
; node # 37 D(-71,31)->(-97,31)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:0|rel:0)
; node # 38 D(-62,36)->(-90,36)
       fcb 2 ; drawmode 
       fcb -5,9 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-896|rel:-64) dy(abs:0|rel:0)
; node # 39 M(-105,37)->(-119,34)
       fcb 0 ; drawmode 
       fcb -1,-43 ; starx/y relative to previous node
       fdb 96,448 ; dx/dy. dx(abs:-448|rel:448) dy(abs:96|rel:96)
; node # 40 D(-110,25)->(-122,24)
       fcb 2 ; drawmode 
       fcb 12,-5 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:32|rel:-64)
; node # 41 D(-106,24)->(-120,23)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-448|rel:-64) dy(abs:32|rel:0)
; node # 42 D(-101,12)->(-119,12)
       fcb 2 ; drawmode 
       fcb 12,5 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-576|rel:-128) dy(abs:0|rel:-32)
; node # 43 D(-96,14)->(-115,12)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:64|rel:64)
; node # 44 M(-115,3)->(-126,2)
       fcb 0 ; drawmode 
       fcb 11,-19 ; starx/y relative to previous node
       fdb -32,256 ; dx/dy. dx(abs:-352|rel:256) dy(abs:32|rel:-32)
; node # 45 D(-121,-6)->(-127,-5)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:-192|rel:160) dy(abs:-32|rel:-64)
; node # 46 D(-121,3)->(-127,2)
       fcb 2 ; drawmode 
       fcb -9,0 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:32|rel:64)
; node # 47 D(-115,25)->(-125,24)
       fcb 2 ; drawmode 
       fcb -22,6 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-320|rel:-128) dy(abs:32|rel:0)
; node # 48 D(-118,20)->(-126,20)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-256|rel:64) dy(abs:0|rel:-32)
; node # 49 D(-122,6)->(-128,6)
       fcb 2 ; drawmode 
       fcb 14,-4 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-192|rel:64) dy(abs:0|rel:0)
; node # 50 D(-122,-15)->(-126,-16)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-128|rel:64) dy(abs:32|rel:32)
; node # 51 D(-122,-16)->(-126,-16)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:-32)
; node # 52 D(-124,-13)->(-127,-12)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-96|rel:32) dy(abs:-32|rel:-32)
; node # 53 M(-68,103)->(-78,100)
       fcb 0 ; drawmode 
       fcb -116,56 ; starx/y relative to previous node
       fdb 128,-224 ; dx/dy. dx(abs:-320|rel:-224) dy(abs:96|rel:128)
; node # 54 D(-85,80)->(-97,78)
       fcb 2 ; drawmode 
       fcb 23,-17 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-384|rel:-64) dy(abs:64|rel:-32)
; node # 55 D(-79,76)->(-95,75)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-512|rel:-128) dy(abs:32|rel:-32)
; node # 56 D(-75,64)->(-95,63)
       fcb 2 ; drawmode 
       fcb 12,4 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-640|rel:-128) dy(abs:32|rel:0)
; node # 57 D(-69,68)->(-91,66)
       fcb 2 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:64|rel:32)
; node # 58 D(-67,60)->(-90,59)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-736|rel:-32) dy(abs:32|rel:-32)
; node # 59 D(-58,60)->(-83,60)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-800|rel:-64) dy(abs:0|rel:-32)
; node # 60 D(-58,67)->(-82,66)
       fcb 2 ; drawmode 
       fcb -7,0 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:32|rel:32)
; node # 61 D(-50,74)->(-74,73)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-768|rel:0) dy(abs:32|rel:0)
; node # 62 D(-45,68)->(-72,67)
       fcb 2 ; drawmode 
       fcb 6,5 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-864|rel:-96) dy(abs:32|rel:0)
; node # 63 D(-44,59)->(-74,58)
       fcb 2 ; drawmode 
       fcb 9,1 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:32|rel:0)
; node # 64 D(-37,69)->(-66,67)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:64|rel:32)
; node # 65 D(-37,75)->(-63,74)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-832|rel:96) dy(abs:32|rel:-32)
; node # 66 D(-22,90)->(-46,94)
       fcb 2 ; drawmode 
       fcb -15,15 ; starx/y relative to previous node
       fdb -160,64 ; dx/dy. dx(abs:-768|rel:64) dy(abs:-128|rel:-160)
; node # 67 D(-29,108)->(-48,108)
       fcb 2 ; drawmode 
       fcb -18,-7 ; starx/y relative to previous node
       fdb 128,160 ; dx/dy. dx(abs:-608|rel:160) dy(abs:0|rel:128)
; node # 68 D(-39,111)->(-55,110)
       fcb 2 ; drawmode 
       fcb -3,-10 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-512|rel:96) dy(abs:32|rel:32)
; node # 69 D(-51,101)->(-64,102)
       fcb 2 ; drawmode 
       fcb 10,-12 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-416|rel:96) dy(abs:-32|rel:-64)
; node # 70 D(-60,99)->(-75,98)
       fcb 2 ; drawmode 
       fcb 2,-9 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-480|rel:-64) dy(abs:32|rel:64)
; node # 71 D(-68,103)->(-78,100)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-320|rel:160) dy(abs:96|rel:64)
; node # 72 M(-124,-13)->(-127,-12)
       fcb 0 ; drawmode 
       fcb 116,-56 ; starx/y relative to previous node
       fdb -128,224 ; dx/dy. dx(abs:-96|rel:224) dy(abs:-32|rel:-128)
; node # 73 D(-123,-36)->(-123,-36)
       fcb 2 ; drawmode 
       fcb 23,1 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:32)
; node # 74 M(-18,-86)->(-18,-86)
       fcb 0 ; drawmode 
       fcb 50,105 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 75 M(55,-115)->(49,-117)
       fcb 0 ; drawmode 
       fcb 29,73 ; starx/y relative to previous node
       fdb 64,-192 ; dx/dy. dx(abs:-192|rel:-192) dy(abs:64|rel:64)
; node # 76 D(57,-112)->(54,-108)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -192,96 ; dx/dy. dx(abs:-96|rel:96) dy(abs:-128|rel:-192)
; node # 77 D(62,-109)->(60,-107)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-64|rel:32) dy(abs:-64|rel:64)
; node # 78 D(68,-103)->(68,-105)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:64|rel:128)
; node # 79 D(73,-102)->(73,-102)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-64)
; node # 80 D(81,-94)->(83,-93)
       fcb 2 ; drawmode 
       fcb -8,8 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-32|rel:-32)
; node # 81 D(93,-86)->(90,-86)
       fcb 2 ; drawmode 
       fcb -8,12 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-96|rel:-160) dy(abs:0|rel:32)
; node # 82 D(105,-71)->(95,-71)
       fcb 2 ; drawmode 
       fcb -15,12 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-320|rel:-224) dy(abs:0|rel:0)
; node # 83 D(110,-63)->(106,-55)
       fcb 2 ; drawmode 
       fcb -8,5 ; starx/y relative to previous node
       fdb -256,192 ; dx/dy. dx(abs:-128|rel:192) dy(abs:-256|rel:-256)
; node # 84 D(124,-34)->(115,-34)
       fcb 2 ; drawmode 
       fcb -29,14 ; starx/y relative to previous node
       fdb 256,-160 ; dx/dy. dx(abs:-288|rel:-160) dy(abs:0|rel:256)
; node # 85 D(114,-54)->(111,-49)
       fcb 2 ; drawmode 
       fcb 20,-10 ; starx/y relative to previous node
       fdb -160,192 ; dx/dy. dx(abs:-96|rel:192) dy(abs:-160|rel:-160)
; node # 86 D(124,-33)->(123,-20)
       fcb 2 ; drawmode 
       fcb -21,10 ; starx/y relative to previous node
       fdb -256,64 ; dx/dy. dx(abs:-32|rel:64) dy(abs:-416|rel:-256)
; node # 87 D(117,-52)->(127,-10)
       fcb 2 ; drawmode 
       fcb 19,-7 ; starx/y relative to previous node
       fdb -928,352 ; dx/dy. dx(abs:320|rel:352) dy(abs:-1344|rel:-928)
; node # 88 D(103,-77)->(121,-41)
       fcb 2 ; drawmode 
       fcb 25,-14 ; starx/y relative to previous node
       fdb 192,256 ; dx/dy. dx(abs:576|rel:256) dy(abs:-1152|rel:192)
; node # 89 D(91,-91)->(110,-64)
       fcb 2 ; drawmode 
       fcb 14,-12 ; starx/y relative to previous node
       fdb 288,32 ; dx/dy. dx(abs:608|rel:32) dy(abs:-864|rel:288)
; node # 90 D(80,-101)->(91,-90)
       fcb 2 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb 512,-256 ; dx/dy. dx(abs:352|rel:-256) dy(abs:-352|rel:512)
; node # 91 D(73,-105)->(73,-105)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 352,-352 ; dx/dy. dx(abs:0|rel:-352) dy(abs:0|rel:352)
; node # 92 D(63,-111)->(63,-111)
       fcb 2 ; drawmode 
       fcb 6,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 D(55,-115)->(50,-118)
       fcb 2 ; drawmode 
       fcb 4,-8 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:96|rel:96)
       fcb  1  ; end of anim
; Animation 10
weltframe10:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-123,-36)->(-123,-36)
       fcb 0 ; drawmode 
       fcb 36,-123 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-115,-59)->(-115,-59)
       fcb 2 ; drawmode 
       fcb 23,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-102,-80)->(-102,-80)
       fcb 2 ; drawmode 
       fcb 21,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-84,-97)->(-84,-97)
       fcb 2 ; drawmode 
       fcb 17,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-65,-111)->(-65,-111)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-51,-118)->(-51,-118)
       fcb 2 ; drawmode 
       fcb 7,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-42,-116)->(-51,-115)
       fcb 2 ; drawmode 
       fcb -2,9 ; starx/y relative to previous node
       fdb -32,-288 ; dx/dy. dx(abs:-288|rel:-288) dy(abs:-32|rel:-32)
; node # 7 D(-56,-108)->(-67,-106)
       fcb 2 ; drawmode 
       fcb -8,-14 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:-64|rel:-32)
; node # 8 D(-71,-105)->(-72,-105)
       fcb 2 ; drawmode 
       fcb -3,-15 ; starx/y relative to previous node
       fdb 64,320 ; dx/dy. dx(abs:-32|rel:320) dy(abs:0|rel:64)
; node # 9 D(-79,-98)->(-80,-100)
       fcb 2 ; drawmode 
       fcb -7,-8 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:64|rel:64)
; node # 10 D(-78,-97)->(-85,-97)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb -64,-192 ; dx/dy. dx(abs:-224|rel:-192) dy(abs:0|rel:-64)
; node # 11 D(-87,-81)->(-99,-81)
       fcb 2 ; drawmode 
       fcb -16,-9 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-384|rel:-160) dy(abs:0|rel:0)
; node # 12 D(-93,-78)->(-102,-77)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-288|rel:96) dy(abs:-32|rel:-32)
; node # 13 D(-99,-71)->(-105,-72)
       fcb 2 ; drawmode 
       fcb -7,-6 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-192|rel:96) dy(abs:32|rel:64)
; node # 14 D(-101,-70)->(-105,-71)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-128|rel:64) dy(abs:32|rel:0)
; node # 15 D(-107,-62)->(-112,-63)
       fcb 2 ; drawmode 
       fcb -8,-6 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-160|rel:-32) dy(abs:32|rel:0)
; node # 16 D(-111,-47)->(-118,-48)
       fcb 2 ; drawmode 
       fcb -15,-4 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-224|rel:-64) dy(abs:32|rel:0)
; node # 17 D(-116,-33)->(-123,-34)
       fcb 2 ; drawmode 
       fcb -14,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-224|rel:0) dy(abs:32|rel:0)
; node # 18 D(-123,-27)->(-124,-28)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-32|rel:192) dy(abs:32|rel:0)
; node # 19 D(-124,-25)->(-125,-26)
       fcb 2 ; drawmode 
       fcb -2,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:32|rel:0)
; node # 20 D(-125,2)->(-128,-1)
       fcb 2 ; drawmode 
       fcb -27,-1 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:96|rel:64)
; node # 21 M(-115,12)->(-127,11)
       fcb 0 ; drawmode 
       fcb -10,10 ; starx/y relative to previous node
       fdb -64,-288 ; dx/dy. dx(abs:-384|rel:-288) dy(abs:32|rel:-64)
; node # 22 D(-115,21)->(-126,21)
       fcb 2 ; drawmode 
       fcb -9,0 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:0|rel:-32)
; node # 23 D(-114,26)->(-125,25)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:32|rel:32)
; node # 24 D(-114,35)->(-123,35)
       fcb 2 ; drawmode 
       fcb -9,0 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-288|rel:64) dy(abs:0|rel:-32)
; node # 25 D(-119,34)->(-119,34)
       fcb 2 ; drawmode 
       fcb 1,-5 ; starx/y relative to previous node
       fdb 0,288 ; dx/dy. dx(abs:0|rel:288) dy(abs:0|rel:0)
; node # 26 M(-90,36)->(-110,35)
       fcb 0 ; drawmode 
       fcb -2,29 ; starx/y relative to previous node
       fdb 32,-640 ; dx/dy. dx(abs:-640|rel:-640) dy(abs:32|rel:32)
; node # 27 D(-85,34)->(-106,33)
       fcb 2 ; drawmode 
       fcb 2,5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:32|rel:0)
; node # 28 D(-65,45)->(-93,44)
       fcb 2 ; drawmode 
       fcb -11,20 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-896|rel:-224) dy(abs:32|rel:0)
; node # 29 D(-65,50)->(-91,48)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:64|rel:32)
; node # 30 D(-56,58)->(-84,57)
       fcb 2 ; drawmode 
       fcb -8,9 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-896|rel:-64) dy(abs:32|rel:-32)
; node # 31 D(-72,49)->(-97,47)
       fcb 2 ; drawmode 
       fcb 9,-16 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:64|rel:32)
; node # 32 D(-74,53)->(-96,51)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-704|rel:96) dy(abs:64|rel:0)
; node # 33 D(-81,49)->(-102,49)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:0|rel:-64)
; node # 34 D(-82,44)->(-107,40)
       fcb 2 ; drawmode 
       fcb 5,-1 ; starx/y relative to previous node
       fdb 128,-128 ; dx/dy. dx(abs:-800|rel:-128) dy(abs:128|rel:128)
; node # 35 D(-92,38)->(-111,38)
       fcb 2 ; drawmode 
       fcb 6,-10 ; starx/y relative to previous node
       fdb -128,192 ; dx/dy. dx(abs:-608|rel:192) dy(abs:0|rel:-128)
; node # 36 D(-97,31)->(-115,30)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:32|rel:32)
; node # 37 D(-90,36)->(-110,35)
       fcb 2 ; drawmode 
       fcb -5,7 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-640|rel:-64) dy(abs:32|rel:0)
; node # 38 M(-119,34)->(-123,33)
       fcb 0 ; drawmode 
       fcb 2,-29 ; starx/y relative to previous node
       fdb 0,512 ; dx/dy. dx(abs:-128|rel:512) dy(abs:32|rel:0)
; node # 39 D(-122,24)->(-125,24)
       fcb 2 ; drawmode 
       fcb 10,-3 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-96|rel:32) dy(abs:0|rel:-32)
; node # 40 D(-120,23)->(-125,22)
       fcb 2 ; drawmode 
       fcb 1,2 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:32|rel:32)
; node # 41 D(-119,12)->(-127,11)
       fcb 2 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-256|rel:-96) dy(abs:32|rel:0)
; node # 42 D(-115,12)->(-126,11)
       fcb 2 ; drawmode 
       fcb 0,4 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-352|rel:-96) dy(abs:32|rel:0)
; node # 43 M(-126,2)->(-128,-1)
       fcb 0 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb 64,288 ; dx/dy. dx(abs:-64|rel:288) dy(abs:96|rel:64)
; node # 44 D(-127,-8)->(-127,-16)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 160,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:256|rel:160)
; node # 45 D(-126,-20)->(-127,-17)
       fcb 2 ; drawmode 
       fcb 12,1 ; starx/y relative to previous node
       fdb -352,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-96|rel:-352)
; node # 46 M(-78,100)->(-81,100)
       fcb 0 ; drawmode 
       fcb -120,48 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:0|rel:96)
; node # 47 D(-97,78)->(-100,79)
       fcb 2 ; drawmode 
       fcb 22,-19 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-96|rel:0) dy(abs:-32|rel:-32)
; node # 48 D(-95,75)->(-104,75)
       fcb 2 ; drawmode 
       fcb 3,2 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-288|rel:-192) dy(abs:0|rel:32)
; node # 49 D(-95,63)->(-109,62)
       fcb 2 ; drawmode 
       fcb 12,0 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-448|rel:-160) dy(abs:32|rel:32)
; node # 50 D(-91,66)->(-106,64)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:64|rel:32)
; node # 51 D(-90,59)->(-106,57)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:64|rel:0)
; node # 52 D(-83,60)->(-102,58)
       fcb 2 ; drawmode 
       fcb -1,7 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:64|rel:0)
; node # 53 D(-82,66)->(-100,65)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:32|rel:-32)
; node # 54 D(-74,73)->(-93,72)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:32|rel:0)
; node # 55 D(-72,67)->(-94,65)
       fcb 2 ; drawmode 
       fcb 6,2 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:64|rel:32)
; node # 56 D(-74,58)->(-95,57)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:32|rel:-32)
; node # 57 D(-66,67)->(-88,67)
       fcb 2 ; drawmode 
       fcb -9,8 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:0|rel:-32)
; node # 58 D(-63,74)->(-84,75)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:-32|rel:-32)
; node # 59 D(-46,94)->(-70,90)
       fcb 2 ; drawmode 
       fcb -20,17 ; starx/y relative to previous node
       fdb 160,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:128|rel:160)
; node # 60 D(-48,108)->(-63,106)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb -64,288 ; dx/dy. dx(abs:-480|rel:288) dy(abs:64|rel:-64)
; node # 61 D(-55,110)->(-66,107)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-352|rel:128) dy(abs:96|rel:32)
; node # 62 D(-64,102)->(-82,98)
       fcb 2 ; drawmode 
       fcb 8,-9 ; starx/y relative to previous node
       fdb 32,-224 ; dx/dy. dx(abs:-576|rel:-224) dy(abs:128|rel:32)
; node # 63 D(-75,98)->(-82,97)
       fcb 2 ; drawmode 
       fcb 4,-11 ; starx/y relative to previous node
       fdb -96,352 ; dx/dy. dx(abs:-224|rel:352) dy(abs:32|rel:-96)
; node # 64 D(-78,100)->(-81,100)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-96|rel:128) dy(abs:0|rel:-32)
; node # 65 M(-126,-20)->(-126,-20)
       fcb 0 ; drawmode 
       fcb 120,-48 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:0)
; node # 66 D(-123,-36)->(-123,-36)
       fcb 2 ; drawmode 
       fcb 16,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 M(-18,-86)->(-18,-86)
       fcb 0 ; drawmode 
       fcb 50,105 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 M(49,-117)->(50,-118)
       fcb 0 ; drawmode 
       fcb 31,67 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:32|rel:32)
; node # 69 D(48,-119)->(40,-118)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb -64,-288 ; dx/dy. dx(abs:-256|rel:-288) dy(abs:-32|rel:-64)
; node # 70 D(59,-107)->(38,-109)
       fcb 2 ; drawmode 
       fcb -12,11 ; starx/y relative to previous node
       fdb 96,-416 ; dx/dy. dx(abs:-672|rel:-416) dy(abs:64|rel:96)
; node # 71 D(57,-108)->(48,-109)
       fcb 2 ; drawmode 
       fcb 1,-2 ; starx/y relative to previous node
       fdb -32,384 ; dx/dy. dx(abs:-288|rel:384) dy(abs:32|rel:-32)
; node # 72 D(60,-107)->(60,-107)
       fcb 2 ; drawmode 
       fcb -1,3 ; starx/y relative to previous node
       fdb -32,288 ; dx/dy. dx(abs:0|rel:288) dy(abs:0|rel:-32)
; node # 73 D(68,-105)->(64,-103)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-64|rel:-64)
; node # 74 D(73,-102)->(67,-98)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-192|rel:-64) dy(abs:-128|rel:-64)
; node # 75 D(83,-93)->(75,-88)
       fcb 2 ; drawmode 
       fcb -9,10 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-256|rel:-64) dy(abs:-160|rel:-32)
; node # 76 D(90,-86)->(77,-82)
       fcb 2 ; drawmode 
       fcb -7,7 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-416|rel:-160) dy(abs:-128|rel:32)
; node # 77 D(95,-71)->(81,-68)
       fcb 2 ; drawmode 
       fcb -15,5 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-448|rel:-32) dy(abs:-96|rel:32)
; node # 78 D(106,-55)->(90,-52)
       fcb 2 ; drawmode 
       fcb -16,11 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-512|rel:-64) dy(abs:-96|rel:0)
; node # 79 D(115,-34)->(98,-33)
       fcb 2 ; drawmode 
       fcb -21,9 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-544|rel:-32) dy(abs:-32|rel:64)
; node # 80 D(111,-49)->(92,-52)
       fcb 2 ; drawmode 
       fcb 15,-4 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-608|rel:-64) dy(abs:96|rel:128)
; node # 81 D(123,-20)->(110,-19)
       fcb 2 ; drawmode 
       fcb -29,12 ; starx/y relative to previous node
       fdb -128,192 ; dx/dy. dx(abs:-416|rel:192) dy(abs:-32|rel:-128)
; node # 82 D(126,-16)->(119,-13)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-224|rel:192) dy(abs:-96|rel:-64)
; node # 83 D(127,-10)->(126,3)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb -320,192 ; dx/dy. dx(abs:-32|rel:192) dy(abs:-416|rel:-320)
; node # 84 D(125,-28)->(123,-20)
       fcb 2 ; drawmode 
       fcb 18,-2 ; starx/y relative to previous node
       fdb 160,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:-256|rel:160)
; node # 85 D(125,-29)->(121,-24)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:-160|rel:96)
; node # 86 D(125,-29)->(118,-18)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -192,-96 ; dx/dy. dx(abs:-224|rel:-96) dy(abs:-352|rel:-192)
; node # 87 D(118,-50)->(113,-47)
       fcb 2 ; drawmode 
       fcb 21,-7 ; starx/y relative to previous node
       fdb 256,64 ; dx/dy. dx(abs:-160|rel:64) dy(abs:-96|rel:256)
; node # 88 D(118,-50)->(119,-48)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:32|rel:192) dy(abs:-64|rel:32)
; node # 89 D(110,-64)->(110,-64)
       fcb 2 ; drawmode 
       fcb 14,-8 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:0|rel:64)
; node # 90 D(91,-90)->(91,-90)
       fcb 2 ; drawmode 
       fcb 26,-19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 91 D(73,-105)->(73,-105)
       fcb 2 ; drawmode 
       fcb 15,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 92 D(63,-111)->(63,-111)
       fcb 2 ; drawmode 
       fcb 6,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 D(50,-118)->(50,-118)
       fcb 2 ; drawmode 
       fcb 7,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 11
weltframe11:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-72,-106)->(-74,-104)
       fcb 0 ; drawmode 
       fcb 106,-72 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:-64|rel:-64)
; node # 1 D(-51,-118)->(-54,-116)
       fcb 2 ; drawmode 
       fcb 12,21 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:-64|rel:0)
; node # 2 D(-50,-118)->(-56,-115)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:-96|rel:-32)
; node # 3 D(-53,-116)->(-58,-114)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-160|rel:32) dy(abs:-64|rel:32)
; node # 4 D(-51,-115)->(-59,-113)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-256|rel:-96) dy(abs:-64|rel:0)
; node # 5 D(-67,-106)->(-74,-104)
       fcb 2 ; drawmode 
       fcb -9,-16 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-224|rel:32) dy(abs:-64|rel:0)
; node # 6 D(-72,-106)->(-67,-109)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 160,384 ; dx/dy. dx(abs:160|rel:384) dy(abs:96|rel:160)
; node # 7 M(-72,-106)->(-97,-83)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -832,-960 ; dx/dy. dx(abs:-800|rel:-960) dy(abs:-736|rel:-832)
; node # 8 D(-89,-93)->(-100,-80)
       fcb 2 ; drawmode 
       fcb -13,-17 ; starx/y relative to previous node
       fdb 320,448 ; dx/dy. dx(abs:-352|rel:448) dy(abs:-416|rel:320)
; node # 9 D(-101,-78)->(-104,-75)
       fcb 2 ; drawmode 
       fcb -15,-12 ; starx/y relative to previous node
       fdb 320,256 ; dx/dy. dx(abs:-96|rel:256) dy(abs:-96|rel:320)
; node # 10 D(-114,-59)->(-112,-61)
       fcb 2 ; drawmode 
       fcb -19,-13 ; starx/y relative to previous node
       fdb 160,160 ; dx/dy. dx(abs:64|rel:160) dy(abs:64|rel:160)
; node # 11 D(-123,-35)->(-114,-57)
       fcb 2 ; drawmode 
       fcb -24,-9 ; starx/y relative to previous node
       fdb 640,224 ; dx/dy. dx(abs:288|rel:224) dy(abs:704|rel:640)
; node # 12 D(-128,-5)->(-115,-55)
       fcb 2 ; drawmode 
       fcb -30,-5 ; starx/y relative to previous node
       fdb 896,128 ; dx/dy. dx(abs:416|rel:128) dy(abs:1600|rel:896)
; node # 13 M(-110,35)->(-121,35)
       fcb 0 ; drawmode 
       fcb -40,18 ; starx/y relative to previous node
       fdb -1600,-768 ; dx/dy. dx(abs:-352|rel:-768) dy(abs:0|rel:-1600)
; node # 14 D(-106,33)->(-120,32)
       fcb 2 ; drawmode 
       fcb 2,4 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:32|rel:32)
; node # 15 D(-93,44)->(-111,42)
       fcb 2 ; drawmode 
       fcb -11,13 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-576|rel:-128) dy(abs:64|rel:32)
; node # 16 D(-91,48)->(-109,46)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-576|rel:0) dy(abs:64|rel:0)
; node # 17 D(-84,57)->(-104,55)
       fcb 2 ; drawmode 
       fcb -9,7 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-640|rel:-64) dy(abs:64|rel:0)
; node # 18 D(-97,47)->(-111,47)
       fcb 2 ; drawmode 
       fcb 10,-13 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-448|rel:192) dy(abs:0|rel:-64)
; node # 19 D(-96,51)->(-111,47)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:128|rel:128)
; node # 20 D(-102,49)->(-113,49)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-352|rel:128) dy(abs:0|rel:-128)
; node # 21 D(-107,40)->(-116,43)
       fcb 2 ; drawmode 
       fcb 9,-5 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-288|rel:64) dy(abs:-96|rel:-96)
; node # 22 D(-111,38)->(-120,38)
       fcb 2 ; drawmode 
       fcb 2,-4 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-288|rel:0) dy(abs:0|rel:96)
; node # 23 D(-115,30)->(-125,33)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-320|rel:-32) dy(abs:-96|rel:-96)
; node # 24 D(-110,35)->(-121,35)
       fcb 2 ; drawmode 
       fcb -5,5 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-352|rel:-32) dy(abs:0|rel:96)
; node # 25 M(-81,100)->(-81,100)
       fcb 0 ; drawmode 
       fcb -65,29 ; starx/y relative to previous node
       fdb 0,352 ; dx/dy. dx(abs:0|rel:352) dy(abs:0|rel:0)
; node # 26 D(-100,79)->(-100,79)
       fcb 2 ; drawmode 
       fcb 21,-19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-104,75)->(-104,75)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(-109,62)->(-112,62)
       fcb 2 ; drawmode 
       fcb 13,-5 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:0|rel:0)
; node # 29 D(-106,64)->(-111,63)
       fcb 2 ; drawmode 
       fcb -2,3 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:32|rel:32)
; node # 30 D(-106,57)->(-115,55)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-288|rel:-128) dy(abs:64|rel:32)
; node # 31 D(-102,58)->(-113,58)
       fcb 2 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:0|rel:-64)
; node # 32 D(-100,65)->(-109,63)
       fcb 2 ; drawmode 
       fcb -7,2 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-288|rel:64) dy(abs:64|rel:64)
; node # 33 D(-93,72)->(-105,69)
       fcb 2 ; drawmode 
       fcb -7,7 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-384|rel:-96) dy(abs:96|rel:32)
; node # 34 D(-94,65)->(-105,64)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:32|rel:-64)
; node # 35 D(-95,57)->(-110,56)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-480|rel:-128) dy(abs:32|rel:0)
; node # 36 D(-88,67)->(-102,67)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-448|rel:32) dy(abs:0|rel:-32)
; node # 37 D(-84,75)->(-95,77)
       fcb 2 ; drawmode 
       fcb -8,4 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-352|rel:96) dy(abs:-64|rel:-64)
; node # 38 D(-70,90)->(-84,90)
       fcb 2 ; drawmode 
       fcb -15,14 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:0|rel:64)
; node # 39 D(-63,106)->(-73,105)
       fcb 2 ; drawmode 
       fcb -16,7 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-320|rel:128) dy(abs:32|rel:32)
; node # 40 D(-66,107)->(-72,107)
       fcb 2 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-192|rel:128) dy(abs:0|rel:-32)
; node # 41 D(-82,98)->(-82,98)
       fcb 2 ; drawmode 
       fcb 9,-16 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:0|rel:192) dy(abs:0|rel:0)
; node # 42 D(-82,97)->(-83,97)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:0|rel:0)
; node # 43 D(-81,100)->(-81,100)
       fcb 2 ; drawmode 
       fcb -3,1 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:0)
; node # 44 M(-38,31)->(-51,34)
       fcb 0 ; drawmode 
       fcb 69,43 ; starx/y relative to previous node
       fdb -96,-416 ; dx/dy. dx(abs:-416|rel:-416) dy(abs:-96|rel:-96)
; node # 45 M(8,-58)->(-7,-54)
       fcb 0 ; drawmode 
       fcb 89,46 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-480|rel:-64) dy(abs:-128|rel:-32)
; node # 46 M(50,-118)->(26,-119)
       fcb 0 ; drawmode 
       fcb 60,42 ; starx/y relative to previous node
       fdb 160,-288 ; dx/dy. dx(abs:-768|rel:-288) dy(abs:32|rel:160)
; node # 47 D(39,-119)->(21,-118)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-576|rel:192) dy(abs:-32|rel:-64)
; node # 48 D(39,-115)->(18,-113)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:-64|rel:-32)
; node # 49 D(39,-112)->(18,-108)
       fcb 2 ; drawmode 
       fcb -3,0 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-672|rel:0) dy(abs:-128|rel:-64)
; node # 50 D(38,-109)->(15,-105)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-736|rel:-64) dy(abs:-128|rel:0)
; node # 51 D(48,-109)->(26,-109)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 128,32 ; dx/dy. dx(abs:-704|rel:32) dy(abs:0|rel:128)
; node # 52 D(60,-107)->(37,-110)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-736|rel:-32) dy(abs:96|rel:96)
; node # 53 D(64,-103)->(46,-105)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-576|rel:160) dy(abs:64|rel:-32)
; node # 54 D(67,-98)->(51,-98)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:0|rel:-64)
; node # 55 D(75,-88)->(57,-88)
       fcb 2 ; drawmode 
       fcb -10,8 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-576|rel:-64) dy(abs:0|rel:0)
; node # 56 D(77,-82)->(53,-77)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb -160,-192 ; dx/dy. dx(abs:-768|rel:-192) dy(abs:-160|rel:-160)
; node # 57 D(81,-68)->(58,-61)
       fcb 2 ; drawmode 
       fcb -14,4 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-736|rel:32) dy(abs:-224|rel:-64)
; node # 58 D(85,-60)->(63,-59)
       fcb 2 ; drawmode 
       fcb -8,4 ; starx/y relative to previous node
       fdb 192,32 ; dx/dy. dx(abs:-704|rel:32) dy(abs:-32|rel:192)
; node # 59 D(90,-52)->(65,-53)
       fcb 2 ; drawmode 
       fcb -8,5 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-800|rel:-96) dy(abs:32|rel:64)
; node # 60 D(98,-32)->(76,-32)
       fcb 2 ; drawmode 
       fcb -20,8 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-704|rel:96) dy(abs:0|rel:-32)
; node # 61 D(98,-33)->(77,-34)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:32|rel:32)
; node # 62 D(92,-52)->(68,-55)
       fcb 2 ; drawmode 
       fcb 19,-6 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:96|rel:64)
; node # 63 D(101,-40)->(82,-36)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb -224,160 ; dx/dy. dx(abs:-608|rel:160) dy(abs:-128|rel:-224)
; node # 64 D(107,-28)->(87,-21)
       fcb 2 ; drawmode 
       fcb -12,6 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-640|rel:-32) dy(abs:-224|rel:-96)
; node # 65 D(110,-19)->(103,-13)
       fcb 2 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb 32,416 ; dx/dy. dx(abs:-224|rel:416) dy(abs:-192|rel:32)
; node # 66 D(119,-13)->(111,-6)
       fcb 2 ; drawmode 
       fcb -6,9 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-256|rel:-32) dy(abs:-224|rel:-32)
; node # 67 D(126,3)->(116,4)
       fcb 2 ; drawmode 
       fcb -16,7 ; starx/y relative to previous node
       fdb 192,-64 ; dx/dy. dx(abs:-320|rel:-64) dy(abs:-32|rel:192)
; node # 68 M(124,28)->(126,0)
       fcb 0 ; drawmode 
       fcb -25,-2 ; starx/y relative to previous node
       fdb 928,384 ; dx/dy. dx(abs:64|rel:384) dy(abs:896|rel:928)
; node # 69 D(115,54)->(127,18)
       fcb 2 ; drawmode 
       fcb -26,-9 ; starx/y relative to previous node
       fdb 256,320 ; dx/dy. dx(abs:384|rel:320) dy(abs:1152|rel:256)
; node # 70 D(114,54)->(123,36)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb -576,-96 ; dx/dy. dx(abs:288|rel:-96) dy(abs:576|rel:-576)
; node # 71 D(113,58)->(113,58)
       fcb 2 ; drawmode 
       fcb -4,-1 ; starx/y relative to previous node
       fdb -576,-288 ; dx/dy. dx(abs:0|rel:-288) dy(abs:0|rel:-576)
; node # 72 D(110,63)->(111,62)
       fcb 2 ; drawmode 
       fcb -5,-3 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:32|rel:32)
; node # 73 D(106,70)->(104,71)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-64|rel:-96) dy(abs:-32|rel:-64)
; node # 74 D(111,61)->(110,56)
       fcb 2 ; drawmode 
       fcb 9,5 ; starx/y relative to previous node
       fdb 192,32 ; dx/dy. dx(abs:-32|rel:32) dy(abs:160|rel:192)
; node # 75 D(117,48)->(114,29)
       fcb 2 ; drawmode 
       fcb 13,6 ; starx/y relative to previous node
       fdb 448,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:608|rel:448)
; node # 76 D(120,40)->(120,17)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:736|rel:128)
; node # 77 D(124,28)->(126,0)
       fcb 2 ; drawmode 
       fcb 12,4 ; starx/y relative to previous node
       fdb 160,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:896|rel:160)
; node # 78 M(126,3)->(116,4)
       fcb 0 ; drawmode 
       fcb 25,2 ; starx/y relative to previous node
       fdb -928,-384 ; dx/dy. dx(abs:-320|rel:-384) dy(abs:-32|rel:-928)
; node # 79 D(123,-13)->(116,-12)
       fcb 2 ; drawmode 
       fcb 16,-3 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-224|rel:96) dy(abs:-32|rel:0)
; node # 80 D(123,-20)->(111,-14)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb -160,-160 ; dx/dy. dx(abs:-384|rel:-160) dy(abs:-192|rel:-160)
; node # 81 D(121,-24)->(109,-28)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 320,0 ; dx/dy. dx(abs:-384|rel:0) dy(abs:128|rel:320)
; node # 82 D(120,-21)->(107,-23)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-416|rel:-32) dy(abs:64|rel:-64)
; node # 83 D(118,-18)->(102,-20)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-512|rel:-96) dy(abs:64|rel:0)
; node # 84 D(115,-36)->(96,-31)
       fcb 2 ; drawmode 
       fcb 18,-3 ; starx/y relative to previous node
       fdb -224,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:-160|rel:-224)
; node # 85 D(113,-47)->(97,-47)
       fcb 2 ; drawmode 
       fcb 11,-2 ; starx/y relative to previous node
       fdb 160,96 ; dx/dy. dx(abs:-512|rel:96) dy(abs:0|rel:160)
; node # 86 D(119,-48)->(110,-49)
       fcb 2 ; drawmode 
       fcb 1,6 ; starx/y relative to previous node
       fdb 32,224 ; dx/dy. dx(abs:-288|rel:224) dy(abs:32|rel:32)
; node # 87 D(110,-64)->(109,-64)
       fcb 2 ; drawmode 
       fcb 16,-9 ; starx/y relative to previous node
       fdb -32,256 ; dx/dy. dx(abs:-32|rel:256) dy(abs:0|rel:-32)
; node # 88 D(104,-73)->(100,-78)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 160,-96 ; dx/dy. dx(abs:-128|rel:-96) dy(abs:160|rel:160)
; node # 89 D(97,-82)->(96,-83)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb -128,96 ; dx/dy. dx(abs:-32|rel:96) dy(abs:32|rel:-128)
; node # 90 D(91,-90)->(91,-90)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-32)
; node # 91 D(73,-105)->(73,-105)
       fcb 2 ; drawmode 
       fcb 15,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 92 D(63,-111)->(63,-111)
       fcb 2 ; drawmode 
       fcb 6,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 D(59,-114)->(48,-118)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 128,-352 ; dx/dy. dx(abs:-352|rel:-352) dy(abs:128|rel:128)
; node # 94 D(50,-118)->(27,-119)
       fcb 2 ; drawmode 
       fcb 4,-9 ; starx/y relative to previous node
       fdb -96,-384 ; dx/dy. dx(abs:-736|rel:-384) dy(abs:32|rel:-96)
       fcb  1  ; end of anim
; Animation 12
weltframe12:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-76,22)->(-65,20)
       fcb 0 ; drawmode 
       fcb -22,-76 ; starx/y relative to previous node
       fdb 64,352 ; dx/dy. dx(abs:352|rel:352) dy(abs:64|rel:64)
; node # 1 M(-121,35)->(-122,38)
       fcb 0 ; drawmode 
       fcb -13,-45 ; starx/y relative to previous node
       fdb -160,-384 ; dx/dy. dx(abs:-32|rel:-384) dy(abs:-96|rel:-160)
; node # 2 D(-120,31)->(-121,39)
       fcb 2 ; drawmode 
       fcb 4,1 ; starx/y relative to previous node
       fdb -160,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:-256|rel:-160)
; node # 3 D(-111,42)->(-120,42)
       fcb 2 ; drawmode 
       fcb -11,9 ; starx/y relative to previous node
       fdb 256,-256 ; dx/dy. dx(abs:-288|rel:-256) dy(abs:0|rel:256)
; node # 4 D(-109,46)->(-119,46)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-320|rel:-32) dy(abs:0|rel:0)
; node # 5 D(-104,55)->(-117,49)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb 192,-96 ; dx/dy. dx(abs:-416|rel:-96) dy(abs:192|rel:192)
; node # 6 D(-111,47)->(-119,44)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:-256|rel:160) dy(abs:96|rel:-96)
; node # 7 D(-111,47)->(-119,45)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-256|rel:0) dy(abs:64|rel:-32)
; node # 8 D(-113,49)->(-119,43)
       fcb 2 ; drawmode 
       fcb -2,-2 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:-192|rel:64) dy(abs:192|rel:128)
; node # 9 D(-116,43)->(-120,43)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -192,64 ; dx/dy. dx(abs:-128|rel:64) dy(abs:0|rel:-192)
; node # 10 D(-120,38)->(-121,41)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb -96,96 ; dx/dy. dx(abs:-32|rel:96) dy(abs:-96|rel:-96)
; node # 11 D(-125,33)->(-122,38)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:96|rel:128) dy(abs:-160|rel:-64)
; node # 12 D(-121,35)->(-121,35)
       fcb 2 ; drawmode 
       fcb -2,4 ; starx/y relative to previous node
       fdb 160,-96 ; dx/dy. dx(abs:0|rel:-96) dy(abs:0|rel:160)
; node # 13 M(-81,100)->(-91,89)
       fcb 0 ; drawmode 
       fcb -65,40 ; starx/y relative to previous node
       fdb 352,-320 ; dx/dy. dx(abs:-320|rel:-320) dy(abs:352|rel:352)
; node # 14 D(-100,79)->(-100,79)
       fcb 2 ; drawmode 
       fcb 21,-19 ; starx/y relative to previous node
       fdb -352,320 ; dx/dy. dx(abs:0|rel:320) dy(abs:0|rel:-352)
; node # 15 D(-104,75)->(-100,79)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-128|rel:-128)
; node # 16 D(-112,62)->(-105,72)
       fcb 2 ; drawmode 
       fcb 13,-8 ; starx/y relative to previous node
       fdb -192,96 ; dx/dy. dx(abs:224|rel:96) dy(abs:-320|rel:-192)
; node # 17 D(-111,63)->(-106,69)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:160|rel:-64) dy(abs:-192|rel:128)
; node # 18 D(-115,55)->(-112,62)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:96|rel:-64) dy(abs:-224|rel:-32)
; node # 19 D(-113,58)->(-109,67)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:128|rel:32) dy(abs:-288|rel:-64)
; node # 20 D(-109,63)->(-109,66)
       fcb 2 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb 192,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:-96|rel:192)
; node # 21 D(-105,69)->(-106,71)
       fcb 2 ; drawmode 
       fcb -6,4 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-64|rel:32)
; node # 22 D(-105,64)->(-105,72)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb -192,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-256|rel:-192)
; node # 23 D(-110,56)->(-111,63)
       fcb 2 ; drawmode 
       fcb 8,-5 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-224|rel:32)
; node # 24 D(-102,67)->(-104,74)
       fcb 2 ; drawmode 
       fcb -11,8 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:-224|rel:0)
; node # 25 D(-95,77)->(-101,78)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb 192,-128 ; dx/dy. dx(abs:-192|rel:-128) dy(abs:-32|rel:192)
; node # 26 D(-84,90)->(-97,82)
       fcb 2 ; drawmode 
       fcb -13,11 ; starx/y relative to previous node
       fdb 288,-224 ; dx/dy. dx(abs:-416|rel:-224) dy(abs:256|rel:288)
; node # 27 D(-73,105)->(-86,93)
       fcb 2 ; drawmode 
       fcb -15,11 ; starx/y relative to previous node
       fdb 128,0 ; dx/dy. dx(abs:-416|rel:0) dy(abs:384|rel:128)
; node # 28 D(-72,107)->(-86,94)
       fcb 2 ; drawmode 
       fcb -2,1 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-448|rel:-32) dy(abs:416|rel:32)
; node # 29 D(-82,98)->(-92,88)
       fcb 2 ; drawmode 
       fcb 9,-10 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-320|rel:128) dy(abs:320|rel:-96)
; node # 30 D(-83,97)->(-92,88)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-288|rel:32) dy(abs:288|rel:-32)
; node # 31 D(-81,100)->(-89,91)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-256|rel:32) dy(abs:288|rel:0)
; node # 32 M(-33,-6)->(-38,-10)
       fcb 0 ; drawmode 
       fcb 106,48 ; starx/y relative to previous node
       fdb -160,96 ; dx/dy. dx(abs:-160|rel:96) dy(abs:128|rel:-160)
; node # 33 M(21,-117)->(15,-121)
       fcb 0 ; drawmode 
       fcb 111,54 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-192|rel:-32) dy(abs:128|rel:0)
; node # 34 D(21,-118)->(8,-119)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb -96,-224 ; dx/dy. dx(abs:-416|rel:-224) dy(abs:32|rel:-96)
; node # 35 D(18,-113)->(-2,-113)
       fcb 2 ; drawmode 
       fcb -5,-3 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-640|rel:-224) dy(abs:0|rel:-32)
; node # 36 D(18,-108)->(-4,-107)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:-32|rel:-32)
; node # 37 D(15,-105)->(-4,-107)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 96,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:64|rel:96)
; node # 38 D(26,-109)->(7,-110)
       fcb 2 ; drawmode 
       fcb 4,11 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:32|rel:-32)
; node # 39 D(37,-110)->(14,-111)
       fcb 2 ; drawmode 
       fcb 1,11 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-736|rel:-128) dy(abs:32|rel:0)
; node # 40 D(46,-105)->(27,-107)
       fcb 2 ; drawmode 
       fcb -5,9 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-608|rel:128) dy(abs:64|rel:32)
; node # 41 D(51,-98)->(30,-97)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-672|rel:-64) dy(abs:-32|rel:-96)
; node # 42 D(57,-88)->(31,-89)
       fcb 2 ; drawmode 
       fcb -10,6 ; starx/y relative to previous node
       fdb 64,-160 ; dx/dy. dx(abs:-832|rel:-160) dy(abs:32|rel:64)
; node # 43 D(53,-77)->(24,-75)
       fcb 2 ; drawmode 
       fcb -11,-4 ; starx/y relative to previous node
       fdb -96,-96 ; dx/dy. dx(abs:-928|rel:-96) dy(abs:-64|rel:-96)
; node # 44 D(58,-61)->(28,-62)
       fcb 2 ; drawmode 
       fcb -16,5 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:32|rel:96)
; node # 45 D(63,-59)->(33,-58)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:-32|rel:-64)
; node # 46 D(76,-32)->(42,-34)
       fcb 2 ; drawmode 
       fcb -27,13 ; starx/y relative to previous node
       fdb 96,-128 ; dx/dy. dx(abs:-1088|rel:-128) dy(abs:64|rel:96)
; node # 47 D(77,-34)->(47,-36)
       fcb 2 ; drawmode 
       fcb 2,1 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-960|rel:128) dy(abs:64|rel:0)
; node # 48 D(68,-55)->(37,-55)
       fcb 2 ; drawmode 
       fcb 21,-9 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:0|rel:-64)
; node # 49 D(82,-36)->(39,-55)
       fcb 2 ; drawmode 
       fcb -19,14 ; starx/y relative to previous node
       fdb 608,-384 ; dx/dy. dx(abs:-1376|rel:-384) dy(abs:608|rel:608)
; node # 50 D(87,-21)->(56,-23)
       fcb 2 ; drawmode 
       fcb -15,5 ; starx/y relative to previous node
       fdb -544,384 ; dx/dy. dx(abs:-992|rel:384) dy(abs:64|rel:-544)
; node # 51 D(103,-13)->(76,-15)
       fcb 2 ; drawmode 
       fcb -8,16 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-864|rel:128) dy(abs:64|rel:0)
; node # 52 D(111,-6)->(90,-5)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb -96,192 ; dx/dy. dx(abs:-672|rel:192) dy(abs:-32|rel:-96)
; node # 53 D(116,4)->(99,7)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-544|rel:128) dy(abs:-96|rel:-64)
; node # 54 M(126,0)->(115,0)
       fcb 0 ; drawmode 
       fcb 4,10 ; starx/y relative to previous node
       fdb 96,192 ; dx/dy. dx(abs:-352|rel:192) dy(abs:0|rel:96)
; node # 55 D(126,6)->(126,7)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb -32,352 ; dx/dy. dx(abs:0|rel:352) dy(abs:-32|rel:-32)
; node # 56 D(127,18)->(127,18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:32)
; node # 57 D(123,36)->(123,36)
       fcb 2 ; drawmode 
       fcb -18,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(118,48)->(116,53)
       fcb 2 ; drawmode 
       fcb -12,-5 ; starx/y relative to previous node
       fdb -160,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:-160|rel:-160)
; node # 59 D(113,58)->(105,70)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb -224,-192 ; dx/dy. dx(abs:-256|rel:-192) dy(abs:-384|rel:-224)
; node # 60 D(111,62)->(94,84)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb -320,-288 ; dx/dy. dx(abs:-544|rel:-288) dy(abs:-704|rel:-320)
; node # 61 D(108,66)->(80,98)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb -320,-352 ; dx/dy. dx(abs:-896|rel:-352) dy(abs:-1024|rel:-320)
; node # 62 D(104,71)->(63,110)
       fcb 2 ; drawmode 
       fcb -5,-4 ; starx/y relative to previous node
       fdb -224,-416 ; dx/dy. dx(abs:-1312|rel:-416) dy(abs:-1248|rel:-224)
; node # 63 D(107,63)->(83,92)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 320,544 ; dx/dy. dx(abs:-768|rel:544) dy(abs:-928|rel:320)
; node # 64 D(109,59)->(96,72)
       fcb 2 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 512,352 ; dx/dy. dx(abs:-416|rel:352) dy(abs:-416|rel:512)
; node # 65 D(110,56)->(97,48)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb 672,0 ; dx/dy. dx(abs:-416|rel:0) dy(abs:256|rel:672)
; node # 66 D(114,29)->(99,27)
       fcb 2 ; drawmode 
       fcb 27,4 ; starx/y relative to previous node
       fdb -192,-64 ; dx/dy. dx(abs:-480|rel:-64) dy(abs:64|rel:-192)
; node # 67 D(120,17)->(105,15)
       fcb 2 ; drawmode 
       fcb 12,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:64|rel:0)
; node # 68 D(123,8)->(108,4)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:128|rel:64)
; node # 69 D(126,0)->(115,0)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-352|rel:128) dy(abs:0|rel:-128)
; node # 70 M(116,4)->(99,7)
       fcb 0 ; drawmode 
       fcb -4,-10 ; starx/y relative to previous node
       fdb -96,-192 ; dx/dy. dx(abs:-544|rel:-192) dy(abs:-96|rel:-96)
; node # 71 D(116,-12)->(96,-12)
       fcb 2 ; drawmode 
       fcb 16,0 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-640|rel:-96) dy(abs:0|rel:96)
; node # 72 D(111,-14)->(88,-15)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:32|rel:32)
; node # 73 D(109,-28)->(89,-30)
       fcb 2 ; drawmode 
       fcb 14,-2 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:64|rel:32)
; node # 74 D(107,-23)->(84,-25)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:64|rel:0)
; node # 75 D(102,-20)->(78,-20)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:0|rel:-64)
; node # 76 D(96,-31)->(71,-34)
       fcb 2 ; drawmode 
       fcb 11,-6 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:96|rel:96)
; node # 77 D(97,-47)->(76,-50)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:96|rel:0)
; node # 78 D(102,-48)->(89,-51)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:-416|rel:256) dy(abs:96|rel:0)
; node # 79 D(112,-47)->(102,-38)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb -384,96 ; dx/dy. dx(abs:-320|rel:96) dy(abs:-288|rel:-384)
; node # 80 D(110,-56)->(97,-54)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb 224,-96 ; dx/dy. dx(abs:-416|rel:-96) dy(abs:-64|rel:224)
; node # 81 D(109,-63)->(102,-61)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-224|rel:192) dy(abs:-64|rel:0)
; node # 82 D(100,-78)->(100,-78)
       fcb 2 ; drawmode 
       fcb 15,-9 ; starx/y relative to previous node
       fdb 64,224 ; dx/dy. dx(abs:0|rel:224) dy(abs:0|rel:64)
; node # 83 D(96,-83)->(98,-82)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-32|rel:-32)
; node # 84 D(91,-90)->(91,-90)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:0|rel:32)
; node # 85 D(73,-104)->(73,-105)
       fcb 2 ; drawmode 
       fcb 14,-18 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:32|rel:32)
; node # 86 D(75,-103)->(79,-96)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb -256,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-224|rel:-256)
; node # 87 D(72,-105)->(66,-105)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 224,-320 ; dx/dy. dx(abs:-192|rel:-320) dy(abs:0|rel:224)
; node # 88 D(63,-111)->(63,-111)
       fcb 2 ; drawmode 
       fcb 6,-9 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:0|rel:192) dy(abs:0|rel:0)
; node # 89 D(48,-118)->(44,-117)
       fcb 2 ; drawmode 
       fcb 7,-15 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-32|rel:-32)
; node # 90 D(32,-119)->(22,-120)
       fcb 2 ; drawmode 
       fcb 1,-16 ; starx/y relative to previous node
       fdb 64,-192 ; dx/dy. dx(abs:-320|rel:-192) dy(abs:32|rel:64)
; node # 91 D(21,-118)->(15,-121)
       fcb 2 ; drawmode 
       fcb -1,-11 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-192|rel:128) dy(abs:96|rel:64)
       fcb  1  ; end of anim
; Animation 13
weltframe13:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(15,-121)->(-3,-121)
       fcb 0 ; drawmode 
       fcb 121,15 ; starx/y relative to previous node
       fdb 0,-576 ; dx/dy. dx(abs:-576|rel:-576) dy(abs:0|rel:0)
; node # 1 D(8,-119)->(-13,-118)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:-32|rel:-32)
; node # 2 D(-2,-113)->(-21,-113)
       fcb 2 ; drawmode 
       fcb -6,-10 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-608|rel:64) dy(abs:0|rel:32)
; node # 3 D(-4,-107)->(-27,-106)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-736|rel:-128) dy(abs:-32|rel:-32)
; node # 4 D(-4,-107)->(-21,-107)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-544|rel:192) dy(abs:0|rel:32)
; node # 5 D(14,-111)->(-6,-111)
       fcb 2 ; drawmode 
       fcb 4,18 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-640|rel:-96) dy(abs:0|rel:0)
; node # 6 D(27,-107)->(3,-108)
       fcb 2 ; drawmode 
       fcb -4,13 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:32|rel:32)
; node # 7 D(30,-97)->(5,-100)
       fcb 2 ; drawmode 
       fcb -10,3 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:96|rel:64)
; node # 8 D(31,-89)->(8,-93)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-736|rel:64) dy(abs:128|rel:32)
; node # 9 D(24,-75)->(-6,-75)
       fcb 2 ; drawmode 
       fcb -14,-7 ; starx/y relative to previous node
       fdb -128,-224 ; dx/dy. dx(abs:-960|rel:-224) dy(abs:0|rel:-128)
; node # 10 D(28,-62)->(-5,-62)
       fcb 2 ; drawmode 
       fcb -13,4 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:0|rel:0)
; node # 11 D(33,-58)->(0,-60)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:64|rel:64)
; node # 12 D(42,-34)->(4,-38)
       fcb 2 ; drawmode 
       fcb -24,9 ; starx/y relative to previous node
       fdb 64,-160 ; dx/dy. dx(abs:-1216|rel:-160) dy(abs:128|rel:64)
; node # 13 D(47,-36)->(9,-34)
       fcb 2 ; drawmode 
       fcb 2,5 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:-1216|rel:0) dy(abs:-64|rel:-192)
; node # 14 D(37,-55)->(3,-55)
       fcb 2 ; drawmode 
       fcb 19,-10 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-1088|rel:128) dy(abs:0|rel:64)
; node # 15 D(39,-55)->(6,-55)
       fcb 2 ; drawmode 
       fcb 0,2 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:0|rel:0)
; node # 16 D(56,-23)->(18,-26)
       fcb 2 ; drawmode 
       fcb -32,17 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-1216|rel:-160) dy(abs:96|rel:96)
; node # 17 D(76,-15)->(40,-14)
       fcb 2 ; drawmode 
       fcb -8,20 ; starx/y relative to previous node
       fdb -128,64 ; dx/dy. dx(abs:-1152|rel:64) dy(abs:-32|rel:-128)
; node # 18 D(81,-11)->(45,-16)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 192,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:160|rel:192)
; node # 19 D(86,-8)->(50,-10)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:64|rel:-96)
; node # 20 D(90,-5)->(60,-6)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-960|rel:192) dy(abs:32|rel:-32)
; node # 21 D(94,0)->(65,4)
       fcb 2 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb -160,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:-128|rel:-160)
; node # 22 D(99,7)->(75,9)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-768|rel:160) dy(abs:-64|rel:64)
; node # 23 M(115,0)->(90,-2)
       fcb 0 ; drawmode 
       fcb 7,16 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:64|rel:128)
; node # 24 D(126,7)->(109,4)
       fcb 2 ; drawmode 
       fcb -7,11 ; starx/y relative to previous node
       fdb 32,256 ; dx/dy. dx(abs:-544|rel:256) dy(abs:96|rel:32)
; node # 25 D(127,18)->(117,17)
       fcb 2 ; drawmode 
       fcb -11,1 ; starx/y relative to previous node
       fdb -64,224 ; dx/dy. dx(abs:-320|rel:224) dy(abs:32|rel:-64)
; node # 26 D(125,26)->(116,29)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb -128,32 ; dx/dy. dx(abs:-288|rel:32) dy(abs:-96|rel:-128)
; node # 27 D(123,36)->(123,36)
       fcb 2 ; drawmode 
       fcb -10,-2 ; starx/y relative to previous node
       fdb 96,288 ; dx/dy. dx(abs:0|rel:288) dy(abs:0|rel:96)
; node # 28 D(116,53)->(116,53)
       fcb 2 ; drawmode 
       fcb -17,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(105,70)->(105,70)
       fcb 2 ; drawmode 
       fcb -17,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(94,84)->(94,84)
       fcb 2 ; drawmode 
       fcb -14,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(80,98)->(80,98)
       fcb 2 ; drawmode 
       fcb -14,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(63,110)->(42,119)
       fcb 2 ; drawmode 
       fcb -12,-17 ; starx/y relative to previous node
       fdb -288,-672 ; dx/dy. dx(abs:-672|rel:-672) dy(abs:-288|rel:-288)
; node # 33 D(83,92)->(68,97)
       fcb 2 ; drawmode 
       fcb 18,20 ; starx/y relative to previous node
       fdb 128,192 ; dx/dy. dx(abs:-480|rel:192) dy(abs:-160|rel:128)
; node # 34 D(96,72)->(80,75)
       fcb 2 ; drawmode 
       fcb 20,13 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:-96|rel:64)
; node # 35 D(97,48)->(71,51)
       fcb 2 ; drawmode 
       fcb 24,1 ; starx/y relative to previous node
       fdb 0,-320 ; dx/dy. dx(abs:-832|rel:-320) dy(abs:-96|rel:0)
; node # 36 D(99,27)->(71,32)
       fcb 2 ; drawmode 
       fcb 21,2 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-896|rel:-64) dy(abs:-160|rel:-64)
; node # 37 D(105,15)->(80,18)
       fcb 2 ; drawmode 
       fcb 12,6 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:-96|rel:64)
; node # 38 D(108,4)->(80,6)
       fcb 2 ; drawmode 
       fcb 11,3 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-896|rel:-96) dy(abs:-64|rel:32)
; node # 39 D(115,0)->(90,-2)
       fcb 2 ; drawmode 
       fcb 4,7 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:64|rel:128)
; node # 40 M(99,7)->(75,9)
       fcb 0 ; drawmode 
       fcb -7,-16 ; starx/y relative to previous node
       fdb -128,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:-64|rel:-128)
; node # 41 D(97,-5)->(69,0)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-896|rel:-128) dy(abs:-160|rel:-96)
; node # 42 D(96,-13)->(69,-14)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 192,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:32|rel:192)
; node # 43 D(88,-15)->(58,-15)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:0|rel:-32)
; node # 44 D(89,-30)->(63,-29)
       fcb 2 ; drawmode 
       fcb 15,1 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-832|rel:128) dy(abs:-32|rel:-32)
; node # 45 D(84,-25)->(54,-26)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-960|rel:-128) dy(abs:32|rel:64)
; node # 46 D(78,-20)->(45,-21)
       fcb 2 ; drawmode 
       fcb -5,-6 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:32|rel:0)
; node # 47 D(71,-34)->(39,-35)
       fcb 2 ; drawmode 
       fcb 14,-7 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:32|rel:0)
; node # 48 D(76,-50)->(47,-50)
       fcb 2 ; drawmode 
       fcb 16,5 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-928|rel:96) dy(abs:0|rel:-32)
; node # 49 D(89,-51)->(66,-51)
       fcb 2 ; drawmode 
       fcb 1,13 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-736|rel:192) dy(abs:0|rel:0)
; node # 50 D(102,-38)->(77,-38)
       fcb 2 ; drawmode 
       fcb -13,13 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-800|rel:-64) dy(abs:0|rel:0)
; node # 51 D(97,-54)->(74,-54)
       fcb 2 ; drawmode 
       fcb 16,-5 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-736|rel:64) dy(abs:0|rel:0)
; node # 52 D(102,-61)->(82,-63)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:64|rel:64)
; node # 53 D(100,-69)->(81,-73)
       fcb 2 ; drawmode 
       fcb 8,-2 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-608|rel:32) dy(abs:128|rel:64)
; node # 54 D(99,-77)->(85,-82)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:-448|rel:160) dy(abs:160|rel:32)
; node # 55 D(99,-76)->(90,-79)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:-288|rel:160) dy(abs:96|rel:-64)
; node # 56 D(98,-82)->(85,-89)
       fcb 2 ; drawmode 
       fcb 6,-1 ; starx/y relative to previous node
       fdb 128,-128 ; dx/dy. dx(abs:-416|rel:-128) dy(abs:224|rel:128)
; node # 57 D(91,-90)->(85,-94)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb -96,224 ; dx/dy. dx(abs:-192|rel:224) dy(abs:128|rel:-96)
; node # 58 D(73,-105)->(62,-109)
       fcb 2 ; drawmode 
       fcb 15,-18 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-352|rel:-160) dy(abs:128|rel:0)
; node # 59 D(80,-95)->(69,-96)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:32|rel:-96)
; node # 60 D(66,-105)->(50,-106)
       fcb 2 ; drawmode 
       fcb 10,-14 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-512|rel:-160) dy(abs:32|rel:0)
; node # 61 D(63,-111)->(52,-114)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-352|rel:160) dy(abs:96|rel:64)
; node # 62 D(44,-117)->(24,-120)
       fcb 2 ; drawmode 
       fcb 6,-19 ; starx/y relative to previous node
       fdb 0,-288 ; dx/dy. dx(abs:-640|rel:-288) dy(abs:96|rel:0)
; node # 63 D(22,-120)->(15,-119)
       fcb 2 ; drawmode 
       fcb 3,-22 ; starx/y relative to previous node
       fdb -128,416 ; dx/dy. dx(abs:-224|rel:416) dy(abs:-32|rel:-128)
; node # 64 D(15,-121)->(-3,-121)
       fcb 2 ; drawmode 
       fcb 1,-7 ; starx/y relative to previous node
       fdb 32,-352 ; dx/dy. dx(abs:-576|rel:-352) dy(abs:0|rel:32)
       fcb  1  ; end of anim
; Animation 14
weltframe14:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-3,-121)->(-23,-121)
       fcb 0 ; drawmode 
       fcb 121,-3 ; starx/y relative to previous node
       fdb 0,-640 ; dx/dy. dx(abs:-640|rel:-640) dy(abs:0|rel:0)
; node # 1 D(-13,-118)->(-33,-114)
       fcb 2 ; drawmode 
       fcb -3,-10 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-640|rel:0) dy(abs:-128|rel:-128)
; node # 2 D(-21,-113)->(-42,-111)
       fcb 2 ; drawmode 
       fcb -5,-8 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:-64|rel:64)
; node # 3 D(-27,-106)->(-48,-105)
       fcb 2 ; drawmode 
       fcb -7,-6 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-672|rel:0) dy(abs:-32|rel:32)
; node # 4 D(-21,-107)->(-37,-108)
       fcb 2 ; drawmode 
       fcb 1,6 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-512|rel:160) dy(abs:32|rel:64)
; node # 5 D(-6,-111)->(-29,-111)
       fcb 2 ; drawmode 
       fcb 4,15 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-736|rel:-224) dy(abs:0|rel:-32)
; node # 6 D(3,-108)->(-17,-107)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:-32|rel:-32)
; node # 7 D(5,-100)->(-22,-98)
       fcb 2 ; drawmode 
       fcb -8,2 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-864|rel:-224) dy(abs:-64|rel:-32)
; node # 8 D(8,-93)->(-18,-92)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-832|rel:32) dy(abs:-32|rel:32)
; node # 9 D(-6,-75)->(-37,-75)
       fcb 2 ; drawmode 
       fcb -18,-14 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-992|rel:-160) dy(abs:0|rel:32)
; node # 10 D(-5,-62)->(-38,-63)
       fcb 2 ; drawmode 
       fcb -13,1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:32|rel:32)
; node # 11 D(0,-60)->(-34,-60)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:0|rel:-32)
; node # 12 D(4,-38)->(-31,-40)
       fcb 2 ; drawmode 
       fcb -22,4 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:64|rel:64)
; node # 13 D(9,-34)->(-27,-36)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:64|rel:0)
; node # 14 D(3,-55)->(-32,-57)
       fcb 2 ; drawmode 
       fcb 21,-6 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:64|rel:0)
; node # 15 D(6,-55)->(-28,-56)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:32|rel:-32)
; node # 16 D(18,-26)->(-16,-23)
       fcb 2 ; drawmode 
       fcb -29,12 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:-96|rel:-128)
; node # 17 D(40,-14)->(0,-14)
       fcb 2 ; drawmode 
       fcb -12,22 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-1280|rel:-192) dy(abs:0|rel:96)
; node # 18 D(45,-16)->(8,-16)
       fcb 2 ; drawmode 
       fcb 2,5 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-1184|rel:96) dy(abs:0|rel:0)
; node # 19 D(50,-10)->(15,-9)
       fcb 2 ; drawmode 
       fcb -6,5 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1120|rel:64) dy(abs:-32|rel:-32)
; node # 20 D(60,-6)->(24,-6)
       fcb 2 ; drawmode 
       fcb -4,10 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:0|rel:32)
; node # 21 D(65,4)->(31,4)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:0|rel:0)
; node # 22 D(75,9)->(42,8)
       fcb 2 ; drawmode 
       fcb -5,10 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:32|rel:32)
; node # 23 M(90,-2)->(62,-3)
       fcb 0 ; drawmode 
       fcb 11,15 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-896|rel:160) dy(abs:32|rel:0)
; node # 24 D(109,4)->(83,3)
       fcb 2 ; drawmode 
       fcb -6,19 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:32|rel:0)
; node # 25 D(117,17)->(97,15)
       fcb 2 ; drawmode 
       fcb -13,8 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-640|rel:192) dy(abs:64|rel:32)
; node # 26 D(116,29)->(100,29)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-512|rel:128) dy(abs:0|rel:-64)
; node # 27 D(123,36)->(115,43)
       fcb 2 ; drawmode 
       fcb -7,7 ; starx/y relative to previous node
       fdb -224,256 ; dx/dy. dx(abs:-256|rel:256) dy(abs:-224|rel:-224)
; node # 28 D(116,53)->(106,57)
       fcb 2 ; drawmode 
       fcb -17,-7 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-320|rel:-64) dy(abs:-128|rel:96)
; node # 29 D(105,70)->(92,79)
       fcb 2 ; drawmode 
       fcb -17,-11 ; starx/y relative to previous node
       fdb -160,-96 ; dx/dy. dx(abs:-416|rel:-96) dy(abs:-288|rel:-160)
; node # 30 D(94,84)->(82,86)
       fcb 2 ; drawmode 
       fcb -14,-11 ; starx/y relative to previous node
       fdb 224,32 ; dx/dy. dx(abs:-384|rel:32) dy(abs:-64|rel:224)
; node # 31 D(80,98)->(64,103)
       fcb 2 ; drawmode 
       fcb -14,-14 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-512|rel:-128) dy(abs:-160|rel:-96)
; node # 32 D(42,119)->(29,123)
       fcb 2 ; drawmode 
       fcb -21,-38 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-416|rel:96) dy(abs:-128|rel:32)
; node # 33 D(68,97)->(49,97)
       fcb 2 ; drawmode 
       fcb 22,26 ; starx/y relative to previous node
       fdb 128,-192 ; dx/dy. dx(abs:-608|rel:-192) dy(abs:0|rel:128)
; node # 34 D(80,75)->(55,74)
       fcb 2 ; drawmode 
       fcb 22,12 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-800|rel:-192) dy(abs:32|rel:32)
; node # 35 D(71,51)->(39,45)
       fcb 2 ; drawmode 
       fcb 24,-9 ; starx/y relative to previous node
       fdb 160,-224 ; dx/dy. dx(abs:-1024|rel:-224) dy(abs:192|rel:160)
; node # 36 D(71,32)->(39,32)
       fcb 2 ; drawmode 
       fcb 19,0 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:0|rel:-192)
; node # 37 D(80,18)->(49,18)
       fcb 2 ; drawmode 
       fcb 14,9 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:0|rel:0)
; node # 38 D(80,6)->(48,7)
       fcb 2 ; drawmode 
       fcb 12,0 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:-32|rel:-32)
; node # 39 D(90,-2)->(63,-3)
       fcb 2 ; drawmode 
       fcb 8,10 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-864|rel:160) dy(abs:32|rel:64)
; node # 40 M(75,9)->(42,8)
       fcb 0 ; drawmode 
       fcb -11,-15 ; starx/y relative to previous node
       fdb 0,-192 ; dx/dy. dx(abs:-1056|rel:-192) dy(abs:32|rel:0)
; node # 41 D(69,0)->(35,0)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:0|rel:-32)
; node # 42 D(69,-14)->(34,-14)
       fcb 2 ; drawmode 
       fcb 14,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:0|rel:0)
; node # 43 D(58,-15)->(23,-15)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:0|rel:0)
; node # 44 D(63,-29)->(27,-30)
       fcb 2 ; drawmode 
       fcb 14,5 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:32|rel:32)
; node # 45 D(54,-26)->(18,-24)
       fcb 2 ; drawmode 
       fcb -3,-9 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-64|rel:-96)
; node # 46 D(45,-21)->(10,-21)
       fcb 2 ; drawmode 
       fcb -5,-9 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:0|rel:64)
; node # 47 D(39,-35)->(2,-32)
       fcb 2 ; drawmode 
       fcb 14,-6 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-1184|rel:-64) dy(abs:-96|rel:-96)
; node # 48 D(47,-50)->(9,-50)
       fcb 2 ; drawmode 
       fcb 15,8 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-1216|rel:-32) dy(abs:0|rel:96)
; node # 49 D(66,-51)->(35,-52)
       fcb 2 ; drawmode 
       fcb 1,19 ; starx/y relative to previous node
       fdb 32,224 ; dx/dy. dx(abs:-992|rel:224) dy(abs:32|rel:32)
; node # 50 D(77,-38)->(46,-38)
       fcb 2 ; drawmode 
       fcb -13,11 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-992|rel:0) dy(abs:0|rel:-32)
; node # 51 D(74,-54)->(46,-55)
       fcb 2 ; drawmode 
       fcb 16,-3 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:32|rel:32)
; node # 52 D(82,-63)->(56,-64)
       fcb 2 ; drawmode 
       fcb 9,8 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:32|rel:0)
; node # 53 D(81,-73)->(55,-71)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:-64|rel:-96)
; node # 54 D(85,-82)->(68,-86)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb 192,288 ; dx/dy. dx(abs:-544|rel:288) dy(abs:128|rel:192)
; node # 55 D(90,-79)->(75,-83)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-480|rel:64) dy(abs:128|rel:0)
; node # 56 D(85,-89)->(65,-93)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-640|rel:-160) dy(abs:128|rel:0)
; node # 57 D(85,-94)->(74,-97)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb -32,288 ; dx/dy. dx(abs:-352|rel:288) dy(abs:96|rel:-32)
; node # 58 D(62,-109)->(48,-112)
       fcb 2 ; drawmode 
       fcb 15,-23 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:96|rel:0)
; node # 59 D(69,-96)->(50,-96)
       fcb 2 ; drawmode 
       fcb -13,7 ; starx/y relative to previous node
       fdb -96,-160 ; dx/dy. dx(abs:-608|rel:-160) dy(abs:0|rel:-96)
; node # 60 D(50,-106)->(33,-108)
       fcb 2 ; drawmode 
       fcb 10,-19 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-544|rel:64) dy(abs:64|rel:64)
; node # 61 D(52,-114)->(40,-116)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-384|rel:160) dy(abs:64|rel:0)
; node # 62 D(24,-120)->(6,-120)
       fcb 2 ; drawmode 
       fcb 6,-28 ; starx/y relative to previous node
       fdb -64,-192 ; dx/dy. dx(abs:-576|rel:-192) dy(abs:0|rel:-64)
; node # 63 D(15,-119)->(-3,-120)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-576|rel:0) dy(abs:32|rel:32)
; node # 64 D(-3,-121)->(-23,-121)
       fcb 2 ; drawmode 
       fcb 2,-18 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-640|rel:-64) dy(abs:0|rel:-32)
       fcb  1  ; end of anim
; Animation 15
weltframe15:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-23,-121)->(-45,-116)
       fcb 0 ; drawmode 
       fcb 121,-23 ; starx/y relative to previous node
       fdb -160,-704 ; dx/dy. dx(abs:-704|rel:-704) dy(abs:-160|rel:-160)
; node # 1 D(-33,-114)->(-55,-111)
       fcb 2 ; drawmode 
       fcb -7,-10 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:-96|rel:64)
; node # 2 D(-42,-111)->(-62,-106)
       fcb 2 ; drawmode 
       fcb -3,-9 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-640|rel:64) dy(abs:-160|rel:-64)
; node # 3 D(-48,-105)->(-70,-100)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:-160|rel:0)
; node # 4 D(-37,-108)->(-56,-105)
       fcb 2 ; drawmode 
       fcb 3,11 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:-96|rel:64)
; node # 5 D(-29,-111)->(-46,-110)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-544|rel:64) dy(abs:-32|rel:64)
; node # 6 D(-17,-107)->(-39,-107)
       fcb 2 ; drawmode 
       fcb -4,12 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-704|rel:-160) dy(abs:0|rel:32)
; node # 7 D(-22,-98)->(-45,-96)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-736|rel:-32) dy(abs:-64|rel:-64)
; node # 8 D(-18,-92)->(-45,-89)
       fcb 2 ; drawmode 
       fcb -6,4 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-864|rel:-128) dy(abs:-96|rel:-32)
; node # 9 D(-37,-75)->(-64,-75)
       fcb 2 ; drawmode 
       fcb -17,-19 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-864|rel:0) dy(abs:0|rel:96)
; node # 10 D(-38,-63)->(-67,-61)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:-64|rel:-64)
; node # 11 D(-34,-60)->(-64,-57)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:-96|rel:-32)
; node # 12 D(-31,-40)->(-65,-42)
       fcb 2 ; drawmode 
       fcb -20,3 ; starx/y relative to previous node
       fdb 160,-128 ; dx/dy. dx(abs:-1088|rel:-128) dy(abs:64|rel:160)
; node # 13 D(-27,-36)->(-62,-34)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:-64|rel:-128)
; node # 14 D(-32,-57)->(-62,-55)
       fcb 2 ; drawmode 
       fcb 21,-5 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-960|rel:160) dy(abs:-64|rel:0)
; node # 15 D(-28,-56)->(-59,-54)
       fcb 2 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:-64|rel:0)
; node # 16 D(-16,-23)->(-52,-24)
       fcb 2 ; drawmode 
       fcb -33,12 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-1152|rel:-160) dy(abs:32|rel:96)
; node # 17 D(0,-14)->(-35,-13)
       fcb 2 ; drawmode 
       fcb -9,16 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:-32|rel:-64)
; node # 18 D(8,-16)->(-29,-16)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1184|rel:-64) dy(abs:0|rel:32)
; node # 19 D(15,-9)->(-23,-9)
       fcb 2 ; drawmode 
       fcb -7,7 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1216|rel:-32) dy(abs:0|rel:0)
; node # 20 D(24,-6)->(-13,-7)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1184|rel:32) dy(abs:32|rel:32)
; node # 21 D(31,4)->(-6,4)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1184|rel:0) dy(abs:0|rel:-32)
; node # 22 D(42,8)->(8,7)
       fcb 2 ; drawmode 
       fcb -4,11 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:32|rel:32)
; node # 23 M(62,-3)->(25,-3)
       fcb 0 ; drawmode 
       fcb 11,20 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1184|rel:-96) dy(abs:0|rel:-32)
; node # 24 D(83,3)->(53,3)
       fcb 2 ; drawmode 
       fcb -6,21 ; starx/y relative to previous node
       fdb 0,224 ; dx/dy. dx(abs:-960|rel:224) dy(abs:0|rel:0)
; node # 25 D(87,7)->(60,13)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb -192,96 ; dx/dy. dx(abs:-864|rel:96) dy(abs:-192|rel:-192)
; node # 26 D(92,12)->(71,13)
       fcb 2 ; drawmode 
       fcb -5,5 ; starx/y relative to previous node
       fdb 160,192 ; dx/dy. dx(abs:-672|rel:192) dy(abs:-32|rel:160)
; node # 27 D(97,15)->(77,17)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:-64|rel:-32)
; node # 28 D(100,29)->(74,32)
       fcb 2 ; drawmode 
       fcb -14,3 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-832|rel:-192) dy(abs:-96|rel:-32)
; node # 29 D(115,43)->(98,43)
       fcb 2 ; drawmode 
       fcb -14,15 ; starx/y relative to previous node
       fdb 96,288 ; dx/dy. dx(abs:-544|rel:288) dy(abs:0|rel:96)
; node # 30 D(106,57)->(89,63)
       fcb 2 ; drawmode 
       fcb -14,-9 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:-192|rel:-192)
; node # 31 D(92,79)->(77,82)
       fcb 2 ; drawmode 
       fcb -22,-14 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-480|rel:64) dy(abs:-96|rel:96)
; node # 32 D(82,86)->(66,86)
       fcb 2 ; drawmode 
       fcb -7,-10 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:0|rel:96)
; node # 33 D(64,103)->(51,103)
       fcb 2 ; drawmode 
       fcb -17,-18 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-416|rel:96) dy(abs:0|rel:0)
; node # 34 D(29,123)->(19,124)
       fcb 2 ; drawmode 
       fcb -20,-35 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-320|rel:96) dy(abs:-32|rel:-32)
; node # 35 D(49,97)->(25,100)
       fcb 2 ; drawmode 
       fcb 26,20 ; starx/y relative to previous node
       fdb -64,-448 ; dx/dy. dx(abs:-768|rel:-448) dy(abs:-96|rel:-64)
; node # 36 D(55,74)->(27,76)
       fcb 2 ; drawmode 
       fcb 23,6 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-896|rel:-128) dy(abs:-64|rel:32)
; node # 37 D(39,45)->(4,45)
       fcb 2 ; drawmode 
       fcb 29,-16 ; starx/y relative to previous node
       fdb 64,-224 ; dx/dy. dx(abs:-1120|rel:-224) dy(abs:0|rel:64)
; node # 38 D(39,32)->(4,32)
       fcb 2 ; drawmode 
       fcb 13,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:0|rel:0)
; node # 39 D(49,18)->(12,19)
       fcb 2 ; drawmode 
       fcb 14,10 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1184|rel:-64) dy(abs:-32|rel:-32)
; node # 40 D(48,7)->(10,6)
       fcb 2 ; drawmode 
       fcb 11,-1 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1216|rel:-32) dy(abs:32|rel:64)
; node # 41 D(63,-3)->(26,-3)
       fcb 2 ; drawmode 
       fcb 10,15 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1184|rel:32) dy(abs:0|rel:-32)
; node # 42 M(42,8)->(8,7)
       fcb 0 ; drawmode 
       fcb -11,-21 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:32|rel:32)
; node # 43 D(35,0)->(-3,-1)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1216|rel:-128) dy(abs:32|rel:0)
; node # 44 D(34,-14)->(-1,-14)
       fcb 2 ; drawmode 
       fcb 14,-1 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1120|rel:96) dy(abs:0|rel:-32)
; node # 45 D(23,-15)->(-13,-14)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:-32|rel:-32)
; node # 46 D(27,-30)->(-9,-29)
       fcb 2 ; drawmode 
       fcb 15,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:0)
; node # 47 D(18,-24)->(-17,-28)
       fcb 2 ; drawmode 
       fcb -6,-9 ; starx/y relative to previous node
       fdb 160,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:128|rel:160)
; node # 48 D(10,-21)->(-27,-22)
       fcb 2 ; drawmode 
       fcb -3,-8 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-1184|rel:-64) dy(abs:32|rel:-96)
; node # 49 D(2,-32)->(-34,-36)
       fcb 2 ; drawmode 
       fcb 11,-8 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:128|rel:96)
; node # 50 D(9,-50)->(-23,-51)
       fcb 2 ; drawmode 
       fcb 18,7 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:32|rel:-96)
; node # 51 D(35,-52)->(2,-52)
       fcb 2 ; drawmode 
       fcb 2,26 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:0|rel:-32)
; node # 52 D(46,-38)->(12,-39)
       fcb 2 ; drawmode 
       fcb -14,11 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:32|rel:32)
; node # 53 D(46,-55)->(11,-54)
       fcb 2 ; drawmode 
       fcb 17,0 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:-32|rel:-64)
; node # 54 D(56,-64)->(24,-64)
       fcb 2 ; drawmode 
       fcb 9,10 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1024|rel:96) dy(abs:0|rel:32)
; node # 55 D(55,-71)->(25,-71)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:0|rel:0)
; node # 56 D(68,-86)->(43,-85)
       fcb 2 ; drawmode 
       fcb 15,13 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-800|rel:160) dy(abs:-32|rel:-32)
; node # 57 D(75,-83)->(54,-84)
       fcb 2 ; drawmode 
       fcb -3,7 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:32|rel:64)
; node # 58 D(65,-93)->(41,-93)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:0|rel:-32)
; node # 59 D(74,-97)->(56,-98)
       fcb 2 ; drawmode 
       fcb 4,9 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-576|rel:192) dy(abs:32|rel:32)
; node # 60 D(48,-112)->(33,-112)
       fcb 2 ; drawmode 
       fcb 15,-26 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-480|rel:96) dy(abs:0|rel:-32)
; node # 61 D(50,-96)->(26,-98)
       fcb 2 ; drawmode 
       fcb -16,2 ; starx/y relative to previous node
       fdb 64,-288 ; dx/dy. dx(abs:-768|rel:-288) dy(abs:64|rel:64)
; node # 62 D(33,-108)->(11,-109)
       fcb 2 ; drawmode 
       fcb 12,-17 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:32|rel:-32)
; node # 63 D(40,-116)->(22,-117)
       fcb 2 ; drawmode 
       fcb 8,7 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:32|rel:0)
; node # 64 D(6,-120)->(-13,-120)
       fcb 2 ; drawmode 
       fcb 4,-34 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:0|rel:-32)
; node # 65 D(-3,-120)->(-27,-120)
       fcb 2 ; drawmode 
       fcb 0,-9 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-768|rel:-160) dy(abs:0|rel:0)
; node # 66 D(-23,-121)->(-45,-116)
       fcb 2 ; drawmode 
       fcb 1,-20 ; starx/y relative to previous node
       fdb -160,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:-160|rel:-160)
; node # 67 M(25,-79)->(25,-79)
       fcb 0 ; drawmode 
       fcb -42,48 ; starx/y relative to previous node
       fdb 160,704 ; dx/dy. dx(abs:0|rel:704) dy(abs:0|rel:160)
; node # 68 M(124,-30)->(117,-46)
       fcb 0 ; drawmode 
       fcb -49,99 ; starx/y relative to previous node
       fdb 512,-224 ; dx/dy. dx(abs:-224|rel:-224) dy(abs:512|rel:512)
; node # 69 D(123,-33)->(115,-52)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-256|rel:-32) dy(abs:608|rel:96)
; node # 70 D(122,-35)->(114,-54)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-256|rel:0) dy(abs:608|rel:0)
; node # 71 D(125,-25)->(121,-25)
       fcb 2 ; drawmode 
       fcb -10,3 ; starx/y relative to previous node
       fdb -608,128 ; dx/dy. dx(abs:-128|rel:128) dy(abs:0|rel:-608)
; node # 72 D(126,-20)->(124,-4)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb -512,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:-512|rel:-512)
; node # 73 D(127,-12)->(127,7)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:-608|rel:-96)
; node # 74 D(127,-9)->(127,12)
       fcb 2 ; drawmode 
       fcb -3,0 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-672|rel:-64)
; node # 75 D(127,-14)->(127,-14)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 672,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:672)
; node # 76 D(125,-28)->(124,-27)
       fcb 2 ; drawmode 
       fcb 14,-2 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-32|rel:-32)
; node # 77 D(124,-31)->(121,-37)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 224,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:192|rel:224)
       fcb  1  ; end of anim
; Animation 16
weltframe16:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-45,-116)->(-56,-113)
       fcb 0 ; drawmode 
       fcb 116,-45 ; starx/y relative to previous node
       fdb -96,-352 ; dx/dy. dx(abs:-352|rel:-352) dy(abs:-96|rel:-96)
; node # 1 D(-55,-111)->(-68,-108)
       fcb 2 ; drawmode 
       fcb -5,-10 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-416|rel:-64) dy(abs:-96|rel:0)
; node # 2 D(-70,-100)->(-79,-99)
       fcb 2 ; drawmode 
       fcb -11,-15 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-288|rel:128) dy(abs:-32|rel:64)
; node # 3 D(-56,-105)->(-70,-104)
       fcb 2 ; drawmode 
       fcb 5,14 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-448|rel:-160) dy(abs:-32|rel:0)
; node # 4 D(-46,-110)->(-65,-107)
       fcb 2 ; drawmode 
       fcb 5,10 ; starx/y relative to previous node
       fdb -64,-160 ; dx/dy. dx(abs:-608|rel:-160) dy(abs:-96|rel:-64)
; node # 5 D(-39,-107)->(-57,-109)
       fcb 2 ; drawmode 
       fcb -3,7 ; starx/y relative to previous node
       fdb 160,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:64|rel:160)
; node # 6 D(-45,-96)->(-65,-96)
       fcb 2 ; drawmode 
       fcb -11,-6 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-640|rel:-64) dy(abs:0|rel:-64)
; node # 7 D(-45,-89)->(-69,-89)
       fcb 2 ; drawmode 
       fcb -7,0 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:0|rel:0)
; node # 8 D(-64,-75)->(-85,-74)
       fcb 2 ; drawmode 
       fcb -14,-19 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-672|rel:96) dy(abs:-32|rel:-32)
; node # 9 D(-67,-61)->(-91,-61)
       fcb 2 ; drawmode 
       fcb -14,-3 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:0|rel:32)
; node # 10 D(-64,-57)->(-89,-57)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:0|rel:0)
; node # 11 D(-65,-42)->(-92,-38)
       fcb 2 ; drawmode 
       fcb -15,-1 ; starx/y relative to previous node
       fdb -128,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:-128|rel:-128)
; node # 12 D(-62,-34)->(-90,-33)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:-32|rel:96)
; node # 13 D(-62,-55)->(-88,-55)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:0|rel:32)
; node # 14 D(-59,-54)->(-86,-53)
       fcb 2 ; drawmode 
       fcb -1,3 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-864|rel:-32) dy(abs:-32|rel:-32)
; node # 15 D(-52,-24)->(-84,-23)
       fcb 2 ; drawmode 
       fcb -30,7 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-1024|rel:-160) dy(abs:-32|rel:0)
; node # 16 D(-35,-13)->(-69,-13)
       fcb 2 ; drawmode 
       fcb -11,17 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1088|rel:-64) dy(abs:0|rel:32)
; node # 17 D(-29,-16)->(-62,-15)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:-32|rel:-32)
; node # 18 D(-23,-9)->(-54,-8)
       fcb 2 ; drawmode 
       fcb -7,6 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:-32|rel:0)
; node # 19 D(-13,-7)->(-46,-6)
       fcb 2 ; drawmode 
       fcb -2,10 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:-32|rel:0)
; node # 20 D(-6,4)->(-43,4)
       fcb 2 ; drawmode 
       fcb -11,7 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1184|rel:-128) dy(abs:0|rel:32)
; node # 21 D(8,7)->(-25,7)
       fcb 2 ; drawmode 
       fcb -3,14 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-1056|rel:128) dy(abs:0|rel:0)
; node # 22 M(25,-3)->(-11,-4)
       fcb 0 ; drawmode 
       fcb 10,17 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:32|rel:32)
; node # 23 D(53,3)->(19,3)
       fcb 2 ; drawmode 
       fcb -6,28 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:0|rel:-32)
; node # 24 D(60,13)->(27,13)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:0|rel:0)
; node # 25 D(71,13)->(39,15)
       fcb 2 ; drawmode 
       fcb 0,11 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:-64|rel:-64)
; node # 26 D(77,17)->(44,19)
       fcb 2 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-64|rel:0)
; node # 27 D(74,32)->(41,29)
       fcb 2 ; drawmode 
       fcb -15,-3 ; starx/y relative to previous node
       fdb 160,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:96|rel:160)
; node # 28 D(92,38)->(66,36)
       fcb 2 ; drawmode 
       fcb -6,18 ; starx/y relative to previous node
       fdb -32,224 ; dx/dy. dx(abs:-832|rel:224) dy(abs:64|rel:-32)
; node # 29 D(98,43)->(76,45)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-704|rel:128) dy(abs:-64|rel:-128)
; node # 30 D(89,63)->(65,63)
       fcb 2 ; drawmode 
       fcb -20,-9 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-768|rel:-64) dy(abs:0|rel:64)
; node # 31 D(77,82)->(52,84)
       fcb 2 ; drawmode 
       fcb -19,-12 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:-64|rel:-64)
; node # 32 D(66,86)->(41,87)
       fcb 2 ; drawmode 
       fcb -4,-11 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-800|rel:0) dy(abs:-32|rel:32)
; node # 33 D(59,94)->(30,104)
       fcb 2 ; drawmode 
       fcb -8,-7 ; starx/y relative to previous node
       fdb -288,-128 ; dx/dy. dx(abs:-928|rel:-128) dy(abs:-320|rel:-288)
; node # 34 D(51,103)->(19,110)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:-224|rel:96)
; node # 35 D(19,124)->(7,127)
       fcb 2 ; drawmode 
       fcb -21,-32 ; starx/y relative to previous node
       fdb 128,640 ; dx/dy. dx(abs:-384|rel:640) dy(abs:-96|rel:128)
; node # 36 D(25,100)->(0,101)
       fcb 2 ; drawmode 
       fcb 24,6 ; starx/y relative to previous node
       fdb 64,-416 ; dx/dy. dx(abs:-800|rel:-416) dy(abs:-32|rel:64)
; node # 37 D(27,76)->(-2,76)
       fcb 2 ; drawmode 
       fcb 24,2 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-928|rel:-128) dy(abs:0|rel:32)
; node # 38 D(17,66)->(-16,69)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-1056|rel:-128) dy(abs:-96|rel:-96)
; node # 39 D(4,45)->(-32,45)
       fcb 2 ; drawmode 
       fcb 21,-13 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:0|rel:96)
; node # 40 D(4,32)->(-32,30)
       fcb 2 ; drawmode 
       fcb 13,0 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:64|rel:64)
; node # 41 D(12,19)->(-24,18)
       fcb 2 ; drawmode 
       fcb 13,8 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:32|rel:-32)
; node # 42 D(10,6)->(-26,7)
       fcb 2 ; drawmode 
       fcb 13,-2 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1152|rel:0) dy(abs:-32|rel:-64)
; node # 43 D(26,-3)->(-11,-4)
       fcb 2 ; drawmode 
       fcb 9,16 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1184|rel:-32) dy(abs:32|rel:64)
; node # 44 M(8,7)->(-25,7)
       fcb 0 ; drawmode 
       fcb -10,-18 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1056|rel:128) dy(abs:0|rel:-32)
; node # 45 D(-3,-1)->(-39,0)
       fcb 2 ; drawmode 
       fcb 8,-11 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:-32|rel:-32)
; node # 46 D(-1,-14)->(-39,-13)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1216|rel:-64) dy(abs:-32|rel:0)
; node # 47 D(-13,-14)->(-50,-14)
       fcb 2 ; drawmode 
       fcb 0,-12 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1184|rel:32) dy(abs:0|rel:32)
; node # 48 D(-9,-29)->(-43,-28)
       fcb 2 ; drawmode 
       fcb 15,4 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:-32|rel:-32)
; node # 49 D(-17,-28)->(-50,-27)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:-32|rel:0)
; node # 50 D(-27,-22)->(-61,-21)
       fcb 2 ; drawmode 
       fcb -6,-10 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:-32|rel:0)
; node # 51 D(-34,-36)->(-69,-33)
       fcb 2 ; drawmode 
       fcb 14,-7 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:-96|rel:-64)
; node # 52 D(-23,-51)->(-57,-50)
       fcb 2 ; drawmode 
       fcb 15,11 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:-32|rel:64)
; node # 53 D(2,-52)->(-33,-54)
       fcb 2 ; drawmode 
       fcb 1,25 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:64|rel:96)
; node # 54 D(12,-39)->(-25,-39)
       fcb 2 ; drawmode 
       fcb -13,10 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-1184|rel:-64) dy(abs:0|rel:-64)
; node # 55 D(11,-54)->(-23,-56)
       fcb 2 ; drawmode 
       fcb 15,-1 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:64|rel:64)
; node # 56 D(24,-64)->(-8,-66)
       fcb 2 ; drawmode 
       fcb 10,13 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-1024|rel:64) dy(abs:64|rel:0)
; node # 57 D(25,-71)->(-5,-71)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:0|rel:-64)
; node # 58 D(43,-85)->(14,-85)
       fcb 2 ; drawmode 
       fcb 14,18 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:0|rel:0)
; node # 59 D(54,-84)->(28,-83)
       fcb 2 ; drawmode 
       fcb -1,11 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-832|rel:96) dy(abs:-32|rel:-32)
; node # 60 D(41,-93)->(17,-93)
       fcb 2 ; drawmode 
       fcb 9,-13 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-768|rel:64) dy(abs:0|rel:32)
; node # 61 D(56,-98)->(37,-100)
       fcb 2 ; drawmode 
       fcb 5,15 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-608|rel:160) dy(abs:64|rel:64)
; node # 62 D(33,-112)->(12,-112)
       fcb 2 ; drawmode 
       fcb 14,-23 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-672|rel:-64) dy(abs:0|rel:-64)
; node # 63 D(26,-98)->(0,-98)
       fcb 2 ; drawmode 
       fcb -14,-7 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-832|rel:-160) dy(abs:0|rel:0)
; node # 64 D(11,-109)->(-11,-109)
       fcb 2 ; drawmode 
       fcb 11,-15 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-704|rel:128) dy(abs:0|rel:0)
; node # 65 D(22,-117)->(4,-116)
       fcb 2 ; drawmode 
       fcb 8,11 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:-32|rel:-32)
; node # 66 D(-13,-120)->(-31,-117)
       fcb 2 ; drawmode 
       fcb 3,-35 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-576|rel:0) dy(abs:-96|rel:-64)
; node # 67 D(-27,-120)->(-43,-119)
       fcb 2 ; drawmode 
       fcb 0,-14 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:-32|rel:64)
; node # 68 D(-45,-116)->(-56,-113)
       fcb 2 ; drawmode 
       fcb -4,-18 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:-352|rel:160) dy(abs:-96|rel:-64)
; node # 69 M(25,-79)->(25,-79)
       fcb 0 ; drawmode 
       fcb -37,70 ; starx/y relative to previous node
       fdb 96,352 ; dx/dy. dx(abs:0|rel:352) dy(abs:0|rel:96)
; node # 70 M(117,-46)->(117,-46)
       fcb 0 ; drawmode 
       fcb -33,92 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 71 D(121,-37)->(117,-47)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 320,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:320|rel:320)
; node # 72 D(118,-44)->(118,-43)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb -352,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:-32|rel:-352)
; node # 73 D(115,-52)->(115,-52)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:32)
; node # 74 D(114,-55)->(113,-55)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:0|rel:0)
; node # 75 D(114,-55)->(111,-59)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:128|rel:128)
; node # 76 D(114,-54)->(108,-57)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:96|rel:-32)
; node # 77 D(121,-25)->(109,-26)
       fcb 2 ; drawmode 
       fcb -29,7 ; starx/y relative to previous node
       fdb -64,-192 ; dx/dy. dx(abs:-384|rel:-192) dy(abs:32|rel:-64)
; node # 78 D(124,-4)->(112,1)
       fcb 2 ; drawmode 
       fcb -21,3 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:-384|rel:0) dy(abs:-160|rel:-192)
; node # 79 D(127,7)->(119,15)
       fcb 2 ; drawmode 
       fcb -11,3 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-256|rel:128) dy(abs:-256|rel:-96)
; node # 80 D(127,12)->(126,13)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 224,224 ; dx/dy. dx(abs:-32|rel:224) dy(abs:-32|rel:224)
; node # 81 D(127,12)->(126,13)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:-32|rel:0)
; node # 82 D(127,12)->(126,13)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:-32|rel:0)
; node # 83 D(127,-14)->(127,-14)
       fcb 2 ; drawmode 
       fcb 26,0 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:32)
; node # 84 D(124,-27)->(124,-27)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 85 D(121,-37)->(117,-46)
       fcb 2 ; drawmode 
       fcb 10,-3 ; starx/y relative to previous node
       fdb 288,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:288|rel:288)
; node # 86 M(108,-72)->(108,-72)
       fcb 0 ; drawmode 
       fcb 35,-13 ; starx/y relative to previous node
       fdb -288,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:-288)
; node # 87 D(102,-78)->(100,-81)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:96|rel:96)
; node # 88 D(104,-77)->(104,-77)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:-96)
; node # 89 D(108,-72)->(108,-72)
       fcb 2 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 D(103,-77)->(103,-77)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 91 D(105,-75)->(105,-75)
       fcb 2 ; drawmode 
       fcb -2,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 92 D(105,-75)->(104,-75)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:0|rel:0)
; node # 93 D(106,-74)->(104,-74)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:0|rel:0)
; node # 94 D(108,-72)->(104,-71)
       fcb 2 ; drawmode 
       fcb -2,2 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:-32|rel:-32)
; node # 95 D(109,-69)->(107,-67)
       fcb 2 ; drawmode 
       fcb -3,1 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:-64|rel:-32)
; node # 96 D(109,-68)->(109,-63)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:-160|rel:-96)
; node # 97 D(108,-71)->(106,-64)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:-224|rel:-64)
; node # 98 D(104,-75)->(100,-74)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 192,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:-32|rel:192)
; node # 99 D(104,-76)->(102,-76)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:0|rel:32)
; node # 100 D(103,-78)->(97,-83)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 160,-128 ; dx/dy. dx(abs:-192|rel:-128) dy(abs:160|rel:160)
; node # 101 D(102,-79)->(88,-92)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb 256,-256 ; dx/dy. dx(abs:-448|rel:-256) dy(abs:416|rel:256)
; node # 102 D(102,-79)->(83,-97)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 160,-160 ; dx/dy. dx(abs:-608|rel:-160) dy(abs:576|rel:160)
; node # 103 D(102,-79)->(93,-87)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -320,320 ; dx/dy. dx(abs:-288|rel:320) dy(abs:256|rel:-320)
; node # 104 D(103,-78)->(100,-81)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb -160,192 ; dx/dy. dx(abs:-96|rel:192) dy(abs:96|rel:-160)
       fcb  1  ; end of anim
; Animation 17
weltframe17:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-56,-113)->(-57,-115)
       fcb 0 ; drawmode 
       fcb 113,-56 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:64|rel:64)
; node # 1 D(-68,-108)->(-65,-110)
       fcb 2 ; drawmode 
       fcb -5,-12 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:96|rel:128) dy(abs:64|rel:0)
; node # 2 D(-79,-99)->(-72,-106)
       fcb 2 ; drawmode 
       fcb -9,-11 ; starx/y relative to previous node
       fdb 160,128 ; dx/dy. dx(abs:224|rel:128) dy(abs:224|rel:160)
; node # 3 D(-70,-104)->(-68,-108)
       fcb 2 ; drawmode 
       fcb 5,9 ; starx/y relative to previous node
       fdb -96,-160 ; dx/dy. dx(abs:64|rel:-160) dy(abs:128|rel:-96)
; node # 4 D(-65,-107)->(-63,-111)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:128|rel:0)
; node # 5 D(-57,-109)->(-67,-108)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb -160,-384 ; dx/dy. dx(abs:-320|rel:-384) dy(abs:-32|rel:-160)
; node # 6 D(-65,-96)->(-79,-94)
       fcb 2 ; drawmode 
       fcb -13,-8 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-448|rel:-128) dy(abs:-64|rel:-32)
; node # 7 D(-69,-89)->(-85,-88)
       fcb 2 ; drawmode 
       fcb -7,-4 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-512|rel:-64) dy(abs:-32|rel:32)
; node # 8 D(-85,-74)->(-101,-70)
       fcb 2 ; drawmode 
       fcb -15,-16 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-512|rel:0) dy(abs:-128|rel:-96)
; node # 9 D(-91,-61)->(-107,-58)
       fcb 2 ; drawmode 
       fcb -13,-6 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-512|rel:0) dy(abs:-96|rel:32)
; node # 10 D(-89,-57)->(-106,-56)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-544|rel:-32) dy(abs:-32|rel:64)
; node # 11 D(-92,-38)->(-110,-46)
       fcb 2 ; drawmode 
       fcb -19,-3 ; starx/y relative to previous node
       fdb 288,-32 ; dx/dy. dx(abs:-576|rel:-32) dy(abs:256|rel:288)
; node # 12 D(-90,-33)->(-111,-31)
       fcb 2 ; drawmode 
       fcb -5,2 ; starx/y relative to previous node
       fdb -320,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:-64|rel:-320)
; node # 13 D(-88,-55)->(-106,-53)
       fcb 2 ; drawmode 
       fcb 22,2 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-576|rel:96) dy(abs:-64|rel:0)
; node # 14 D(-86,-53)->(-105,-52)
       fcb 2 ; drawmode 
       fcb -2,2 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:-32|rel:32)
; node # 15 D(-84,-23)->(-106,-21)
       fcb 2 ; drawmode 
       fcb -30,2 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:-64|rel:-32)
; node # 16 D(-69,-13)->(-97,-13)
       fcb 2 ; drawmode 
       fcb -10,15 ; starx/y relative to previous node
       fdb 64,-192 ; dx/dy. dx(abs:-896|rel:-192) dy(abs:0|rel:64)
; node # 17 D(-62,-15)->(-91,-15)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-928|rel:-32) dy(abs:0|rel:0)
; node # 18 D(-54,-8)->(-85,-7)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-992|rel:-64) dy(abs:-32|rel:-32)
; node # 19 D(-46,-6)->(-82,-7)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 64,-160 ; dx/dy. dx(abs:-1152|rel:-160) dy(abs:32|rel:64)
; node # 20 D(-43,4)->(-75,4)
       fcb 2 ; drawmode 
       fcb -10,3 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:0|rel:-32)
; node # 21 D(-25,7)->(-66,9)
       fcb 2 ; drawmode 
       fcb -3,18 ; starx/y relative to previous node
       fdb -64,-288 ; dx/dy. dx(abs:-1312|rel:-288) dy(abs:-64|rel:-64)
; node # 22 M(-11,-4)->(-48,-1)
       fcb 0 ; drawmode 
       fcb 11,14 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-1184|rel:128) dy(abs:-96|rel:-32)
; node # 23 D(19,3)->(-14,5)
       fcb 2 ; drawmode 
       fcb -7,30 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-1056|rel:128) dy(abs:-64|rel:32)
; node # 24 D(27,13)->(-10,14)
       fcb 2 ; drawmode 
       fcb -10,8 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1184|rel:-128) dy(abs:-32|rel:32)
; node # 25 D(39,15)->(2,16)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1184|rel:0) dy(abs:-32|rel:0)
; node # 26 D(44,19)->(8,21)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:-64|rel:-32)
; node # 27 D(41,29)->(9,31)
       fcb 2 ; drawmode 
       fcb -10,-3 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-1024|rel:128) dy(abs:-64|rel:0)
; node # 28 D(66,36)->(36,37)
       fcb 2 ; drawmode 
       fcb -7,25 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:-32|rel:32)
; node # 29 D(76,45)->(47,47)
       fcb 2 ; drawmode 
       fcb -9,10 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:-64|rel:-32)
; node # 30 D(65,63)->(36,64)
       fcb 2 ; drawmode 
       fcb -18,-11 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:-32|rel:32)
; node # 31 D(52,84)->(28,85)
       fcb 2 ; drawmode 
       fcb -21,-13 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-768|rel:160) dy(abs:-32|rel:0)
; node # 32 D(41,87)->(15,88)
       fcb 2 ; drawmode 
       fcb -3,-11 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:-32|rel:0)
; node # 33 D(30,104)->(4,107)
       fcb 2 ; drawmode 
       fcb -17,-11 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:-96|rel:-64)
; node # 34 D(19,110)->(-5,114)
       fcb 2 ; drawmode 
       fcb -6,-11 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-768|rel:64) dy(abs:-128|rel:-32)
; node # 35 D(7,127)->(-5,126)
       fcb 2 ; drawmode 
       fcb -17,-12 ; starx/y relative to previous node
       fdb 160,384 ; dx/dy. dx(abs:-384|rel:384) dy(abs:32|rel:160)
; node # 36 D(0,101)->(-22,107)
       fcb 2 ; drawmode 
       fcb 26,-7 ; starx/y relative to previous node
       fdb -224,-320 ; dx/dy. dx(abs:-704|rel:-320) dy(abs:-192|rel:-224)
; node # 37 D(-2,76)->(-32,77)
       fcb 2 ; drawmode 
       fcb 25,-2 ; starx/y relative to previous node
       fdb 160,-256 ; dx/dy. dx(abs:-960|rel:-256) dy(abs:-32|rel:160)
; node # 38 D(-16,69)->(-46,69)
       fcb 2 ; drawmode 
       fcb 7,-14 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:0|rel:32)
; node # 39 D(-32,45)->(-65,44)
       fcb 2 ; drawmode 
       fcb 24,-16 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:32|rel:32)
; node # 40 D(-32,30)->(-66,30)
       fcb 2 ; drawmode 
       fcb 15,0 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:0|rel:-32)
; node # 41 D(-24,18)->(-58,18)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:0|rel:0)
; node # 42 D(-26,7)->(-60,8)
       fcb 2 ; drawmode 
       fcb 11,-2 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:-32|rel:-32)
; node # 43 D(-11,-4)->(-49,-1)
       fcb 2 ; drawmode 
       fcb 11,15 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-1216|rel:-128) dy(abs:-96|rel:-64)
; node # 44 M(-25,7)->(-66,9)
       fcb 0 ; drawmode 
       fcb -11,-14 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1312|rel:-96) dy(abs:-64|rel:32)
; node # 45 D(-39,0)->(-72,1)
       fcb 2 ; drawmode 
       fcb 7,-14 ; starx/y relative to previous node
       fdb 32,256 ; dx/dy. dx(abs:-1056|rel:256) dy(abs:-32|rel:32)
; node # 46 D(-39,-13)->(-73,-12)
       fcb 2 ; drawmode 
       fcb 13,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:-32|rel:0)
; node # 47 D(-50,-14)->(-81,-15)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-992|rel:96) dy(abs:32|rel:64)
; node # 48 D(-43,-28)->(-77,-28)
       fcb 2 ; drawmode 
       fcb 14,7 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1088|rel:-96) dy(abs:0|rel:-32)
; node # 49 D(-50,-27)->(-80,-28)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-960|rel:128) dy(abs:32|rel:32)
; node # 50 D(-61,-21)->(-92,-19)
       fcb 2 ; drawmode 
       fcb -6,-11 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:-64|rel:-96)
; node # 51 D(-69,-33)->(-94,-31)
       fcb 2 ; drawmode 
       fcb 12,-8 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-800|rel:192) dy(abs:-64|rel:0)
; node # 52 D(-57,-50)->(-88,-49)
       fcb 2 ; drawmode 
       fcb 17,12 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-992|rel:-192) dy(abs:-32|rel:32)
; node # 53 D(-33,-54)->(-65,-52)
       fcb 2 ; drawmode 
       fcb 4,24 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:-64|rel:-32)
; node # 54 D(-25,-39)->(-58,-38)
       fcb 2 ; drawmode 
       fcb -15,8 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-32|rel:32)
; node # 55 D(-23,-56)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 17,2 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:32)
; node # 56 D(-8,-66)->(-39,-66)
       fcb 2 ; drawmode 
       fcb 10,15 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:0|rel:0)
; node # 57 D(-5,-71)->(-39,-72)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1088|rel:-96) dy(abs:32|rel:32)
; node # 58 D(14,-85)->(-16,-86)
       fcb 2 ; drawmode 
       fcb 14,19 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-960|rel:128) dy(abs:32|rel:0)
; node # 59 D(28,-83)->(-3,-86)
       fcb 2 ; drawmode 
       fcb -2,14 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-992|rel:-32) dy(abs:96|rel:64)
; node # 60 D(17,-93)->(-12,-93)
       fcb 2 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-928|rel:64) dy(abs:0|rel:-96)
; node # 61 D(37,-100)->(13,-100)
       fcb 2 ; drawmode 
       fcb 7,20 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-768|rel:160) dy(abs:0|rel:0)
; node # 62 D(13,-112)->(-3,-112)
       fcb 2 ; drawmode 
       fcb 12,-24 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:-512|rel:256) dy(abs:0|rel:0)
; node # 63 D(0,-98)->(-25,-98)
       fcb 2 ; drawmode 
       fcb -14,-13 ; starx/y relative to previous node
       fdb 0,-288 ; dx/dy. dx(abs:-800|rel:-288) dy(abs:0|rel:0)
; node # 64 D(-11,-109)->(-31,-109)
       fcb 2 ; drawmode 
       fcb 11,-11 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-640|rel:160) dy(abs:0|rel:0)
; node # 65 D(4,-116)->(-14,-117)
       fcb 2 ; drawmode 
       fcb 7,15 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:32|rel:32)
; node # 66 D(-31,-117)->(-42,-118)
       fcb 2 ; drawmode 
       fcb 1,-35 ; starx/y relative to previous node
       fdb 0,224 ; dx/dy. dx(abs:-352|rel:224) dy(abs:32|rel:0)
; node # 67 D(-43,-119)->(-51,-117)
       fcb 2 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb -96,96 ; dx/dy. dx(abs:-256|rel:96) dy(abs:-64|rel:-96)
; node # 68 D(-56,-113)->(-57,-115)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 128,224 ; dx/dy. dx(abs:-32|rel:224) dy(abs:64|rel:128)
; node # 69 M(41,-69)->(25,-79)
       fcb 0 ; drawmode 
       fcb -44,97 ; starx/y relative to previous node
       fdb 256,-480 ; dx/dy. dx(abs:-512|rel:-480) dy(abs:320|rel:256)
; node # 70 M(120,-38)->(117,-47)
       fcb 0 ; drawmode 
       fcb -31,79 ; starx/y relative to previous node
       fdb -32,416 ; dx/dy. dx(abs:-96|rel:416) dy(abs:288|rel:-32)
; node # 71 D(113,-55)->(108,-63)
       fcb 2 ; drawmode 
       fcb 17,-7 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:256|rel:-32)
; node # 72 D(111,-59)->(99,-64)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb -96,-224 ; dx/dy. dx(abs:-384|rel:-224) dy(abs:160|rel:-96)
; node # 73 D(108,-57)->(95,-62)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-416|rel:-32) dy(abs:160|rel:0)
; node # 74 D(109,-26)->(86,-28)
       fcb 2 ; drawmode 
       fcb -31,1 ; starx/y relative to previous node
       fdb -96,-320 ; dx/dy. dx(abs:-736|rel:-320) dy(abs:64|rel:-96)
; node # 75 D(112,1)->(89,-3)
       fcb 2 ; drawmode 
       fcb -27,3 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:128|rel:64)
; node # 76 D(119,15)->(104,16)
       fcb 2 ; drawmode 
       fcb -14,7 ; starx/y relative to previous node
       fdb -160,256 ; dx/dy. dx(abs:-480|rel:256) dy(abs:-32|rel:-160)
; node # 77 D(126,13)->(117,11)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 96,192 ; dx/dy. dx(abs:-288|rel:192) dy(abs:64|rel:96)
; node # 78 D(126,13)->(120,17)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -192,96 ; dx/dy. dx(abs:-192|rel:96) dy(abs:-128|rel:-192)
; node # 79 D(125,16)->(116,44)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb -768,-96 ; dx/dy. dx(abs:-288|rel:-96) dy(abs:-896|rel:-768)
; node # 80 D(126,15)->(115,47)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb -128,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:-1024|rel:-128)
; node # 81 D(125,16)->(111,59)
       fcb 2 ; drawmode 
       fcb -1,-1 ; starx/y relative to previous node
       fdb -352,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:-1376|rel:-352)
; node # 82 D(125,16)->(113,55)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:-1248|rel:128)
; node # 83 D(126,15)->(115,49)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb 160,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:-1088|rel:160)
; node # 84 D(125,15)->(118,42)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 224,128 ; dx/dy. dx(abs:-224|rel:128) dy(abs:-864|rel:224)
; node # 85 D(126,14)->(120,36)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb 160,32 ; dx/dy. dx(abs:-192|rel:32) dy(abs:-704|rel:160)
; node # 86 D(126,15)->(123,28)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 288,96 ; dx/dy. dx(abs:-96|rel:96) dy(abs:-416|rel:288)
; node # 87 D(126,15)->(126,15)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 416,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:416)
; node # 88 D(127,-1)->(127,-1)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 89 D(127,-1)->(127,-1)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 D(127,-14)->(127,-14)
       fcb 2 ; drawmode 
       fcb 13,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 91 D(120,-38)->(117,-46)
       fcb 2 ; drawmode 
       fcb 24,-7 ; starx/y relative to previous node
       fdb 256,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:256|rel:256)
; node # 92 M(108,-72)->(108,-72)
       fcb 0 ; drawmode 
       fcb 34,-12 ; starx/y relative to previous node
       fdb -256,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:-256)
; node # 93 D(100,-81)->(96,-86)
       fcb 2 ; drawmode 
       fcb 9,-8 ; starx/y relative to previous node
       fdb 160,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:160|rel:160)
; node # 94 D(104,-77)->(104,-77)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb -160,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:-160)
; node # 95 D(108,-72)->(108,-71)
       fcb 2 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-32|rel:-32)
; node # 96 D(103,-77)->(103,-77)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:32)
; node # 97 D(105,-75)->(103,-77)
       fcb 2 ; drawmode 
       fcb -2,2 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:64|rel:64)
; node # 98 D(104,-75)->(98,-80)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 96,-128 ; dx/dy. dx(abs:-192|rel:-128) dy(abs:160|rel:96)
; node # 99 D(104,-71)->(95,-78)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-288|rel:-96) dy(abs:224|rel:64)
; node # 100 D(107,-67)->(96,-72)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:160|rel:-64)
; node # 101 D(109,-63)->(97,-67)
       fcb 2 ; drawmode 
       fcb -4,2 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-384|rel:-32) dy(abs:128|rel:-32)
; node # 102 D(106,-64)->(88,-68)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb 0,-192 ; dx/dy. dx(abs:-576|rel:-192) dy(abs:128|rel:0)
; node # 103 D(100,-74)->(84,-81)
       fcb 2 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:224|rel:96)
; node # 104 D(102,-76)->(90,-80)
       fcb 2 ; drawmode 
       fcb 2,2 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-384|rel:128) dy(abs:128|rel:-96)
; node # 105 D(97,-83)->(82,-88)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-480|rel:-96) dy(abs:160|rel:32)
; node # 106 D(93,-86)->(83,-91)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-320|rel:160) dy(abs:160|rel:0)
; node # 107 D(92,-87)->(82,-94)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:224|rel:64)
; node # 108 D(89,-90)->(82,-95)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-224|rel:96) dy(abs:160|rel:-64)
; node # 109 D(88,-92)->(83,-96)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-160|rel:64) dy(abs:128|rel:-32)
; node # 110 D(94,-85)->(83,-97)
       fcb 2 ; drawmode 
       fcb -7,6 ; starx/y relative to previous node
       fdb 256,-192 ; dx/dy. dx(abs:-352|rel:-192) dy(abs:384|rel:256)
; node # 111 D(92,-87)->(69,-108)
       fcb 2 ; drawmode 
       fcb 2,-2 ; starx/y relative to previous node
       fdb 288,-384 ; dx/dy. dx(abs:-736|rel:-384) dy(abs:672|rel:288)
; node # 112 D(83,-97)->(64,-111)
       fcb 2 ; drawmode 
       fcb 10,-9 ; starx/y relative to previous node
       fdb -224,128 ; dx/dy. dx(abs:-608|rel:128) dy(abs:448|rel:-224)
; node # 113 D(93,-87)->(66,-110)
       fcb 2 ; drawmode 
       fcb -10,10 ; starx/y relative to previous node
       fdb 288,-256 ; dx/dy. dx(abs:-864|rel:-256) dy(abs:736|rel:288)
; node # 114 D(100,-81)->(96,-86)
       fcb 2 ; drawmode 
       fcb -6,7 ; starx/y relative to previous node
       fdb -576,736 ; dx/dy. dx(abs:-128|rel:736) dy(abs:160|rel:-576)
       fcb  1  ; end of anim
; Animation 18
weltframe18:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-57,-115)->(-57,-115)
       fcb 0 ; drawmode 
       fcb 115,-57 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-64,-111)->(-69,-108)
       fcb 2 ; drawmode 
       fcb -4,-7 ; starx/y relative to previous node
       fdb -96,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:-96|rel:-96)
; node # 2 D(-79,-94)->(-84,-96)
       fcb 2 ; drawmode 
       fcb -17,-15 ; starx/y relative to previous node
       fdb 160,0 ; dx/dy. dx(abs:-160|rel:0) dy(abs:64|rel:160)
; node # 3 D(-101,-70)->(-107,-70)
       fcb 2 ; drawmode 
       fcb -24,-22 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-192|rel:-32) dy(abs:0|rel:-64)
; node # 4 D(-107,-58)->(-113,-58)
       fcb 2 ; drawmode 
       fcb -12,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:0|rel:0)
; node # 5 D(-106,-56)->(-115,-54)
       fcb 2 ; drawmode 
       fcb -2,1 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-288|rel:-96) dy(abs:-64|rel:-64)
; node # 6 D(-110,-46)->(-119,-40)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-288|rel:0) dy(abs:-192|rel:-128)
; node # 7 D(-111,-31)->(-120,-32)
       fcb 2 ; drawmode 
       fcb -15,-1 ; starx/y relative to previous node
       fdb 224,0 ; dx/dy. dx(abs:-288|rel:0) dy(abs:32|rel:224)
; node # 8 D(-106,-53)->(-116,-52)
       fcb 2 ; drawmode 
       fcb 22,5 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-320|rel:-32) dy(abs:-32|rel:-64)
; node # 9 D(-105,-52)->(-116,-52)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-352|rel:-32) dy(abs:0|rel:32)
; node # 10 D(-106,-21)->(-121,-23)
       fcb 2 ; drawmode 
       fcb -31,-1 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-480|rel:-128) dy(abs:64|rel:64)
; node # 11 D(-97,-13)->(-117,-13)
       fcb 2 ; drawmode 
       fcb -8,9 ; starx/y relative to previous node
       fdb -64,-160 ; dx/dy. dx(abs:-640|rel:-160) dy(abs:0|rel:-64)
; node # 12 D(-91,-15)->(-113,-15)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-704|rel:-64) dy(abs:0|rel:0)
; node # 13 D(-85,-7)->(-111,-8)
       fcb 2 ; drawmode 
       fcb -8,6 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-832|rel:-128) dy(abs:32|rel:32)
; node # 14 D(-82,-7)->(-105,-6)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:-32|rel:-64)
; node # 15 D(-75,4)->(-103,3)
       fcb 2 ; drawmode 
       fcb -11,7 ; starx/y relative to previous node
       fdb 64,-160 ; dx/dy. dx(abs:-896|rel:-160) dy(abs:32|rel:64)
; node # 16 D(-66,9)->(-94,8)
       fcb 2 ; drawmode 
       fcb -5,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-896|rel:0) dy(abs:32|rel:0)
; node # 17 M(-48,-1)->(-80,-3)
       fcb 0 ; drawmode 
       fcb 10,18 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1024|rel:-128) dy(abs:64|rel:32)
; node # 18 D(-14,5)->(-57,2)
       fcb 2 ; drawmode 
       fcb -6,34 ; starx/y relative to previous node
       fdb 32,-352 ; dx/dy. dx(abs:-1376|rel:-352) dy(abs:96|rel:32)
; node # 19 D(-10,14)->(-47,12)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-1184|rel:192) dy(abs:64|rel:-32)
; node # 20 D(2,16)->(-35,14)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1184|rel:0) dy(abs:64|rel:0)
; node # 21 D(8,21)->(-29,23)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-1184|rel:0) dy(abs:-64|rel:-128)
; node # 22 D(9,31)->(-28,30)
       fcb 2 ; drawmode 
       fcb -10,1 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-1184|rel:0) dy(abs:32|rel:96)
; node # 23 D(36,37)->(0,38)
       fcb 2 ; drawmode 
       fcb -6,27 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1152|rel:32) dy(abs:-32|rel:-64)
; node # 24 D(47,47)->(12,50)
       fcb 2 ; drawmode 
       fcb -10,11 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1120|rel:32) dy(abs:-96|rel:-64)
; node # 25 D(36,64)->(2,64)
       fcb 2 ; drawmode 
       fcb -17,-11 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:0|rel:96)
; node # 26 D(28,85)->(-1,83)
       fcb 2 ; drawmode 
       fcb -21,-8 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-928|rel:160) dy(abs:64|rel:64)
; node # 27 D(15,88)->(-13,88)
       fcb 2 ; drawmode 
       fcb -3,-13 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:-64)
; node # 28 D(4,107)->(-18,107)
       fcb 2 ; drawmode 
       fcb -19,-11 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-704|rel:192) dy(abs:0|rel:0)
; node # 29 D(-5,114)->(-22,116)
       fcb 2 ; drawmode 
       fcb -7,-9 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:-544|rel:160) dy(abs:-64|rel:-64)
; node # 30 D(-5,126)->(-16,125)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 96,192 ; dx/dy. dx(abs:-352|rel:192) dy(abs:32|rel:96)
; node # 31 D(-22,107)->(-42,106)
       fcb 2 ; drawmode 
       fcb 19,-17 ; starx/y relative to previous node
       fdb 0,-288 ; dx/dy. dx(abs:-640|rel:-288) dy(abs:32|rel:0)
; node # 32 D(-32,77)->(-59,76)
       fcb 2 ; drawmode 
       fcb 30,-10 ; starx/y relative to previous node
       fdb 0,-224 ; dx/dy. dx(abs:-864|rel:-224) dy(abs:32|rel:0)
; node # 33 D(-46,69)->(-74,66)
       fcb 2 ; drawmode 
       fcb 8,-14 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:96|rel:64)
; node # 34 D(-65,44)->(-92,43)
       fcb 2 ; drawmode 
       fcb 25,-19 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:32|rel:-64)
; node # 35 D(-66,30)->(-94,30)
       fcb 2 ; drawmode 
       fcb 14,-1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:0|rel:-32)
; node # 36 D(-58,18)->(-89,19)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-992|rel:-96) dy(abs:-32|rel:-32)
; node # 37 D(-60,8)->(-92,8)
       fcb 2 ; drawmode 
       fcb 10,-2 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:0|rel:32)
; node # 38 D(-49,-1)->(-80,-3)
       fcb 2 ; drawmode 
       fcb 9,11 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:64|rel:64)
; node # 39 M(-66,9)->(-94,8)
       fcb 0 ; drawmode 
       fcb -10,-17 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-896|rel:96) dy(abs:32|rel:-32)
; node # 40 D(-72,1)->(-100,0)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-896|rel:0) dy(abs:32|rel:0)
; node # 41 D(-73,-12)->(-99,-12)
       fcb 2 ; drawmode 
       fcb 13,-1 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:0|rel:-32)
; node # 42 D(-81,-15)->(-106,-14)
       fcb 2 ; drawmode 
       fcb 3,-8 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-800|rel:32) dy(abs:-32|rel:-32)
; node # 43 D(-77,-28)->(-102,-28)
       fcb 2 ; drawmode 
       fcb 13,4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-800|rel:0) dy(abs:0|rel:32)
; node # 44 D(-80,-28)->(-106,-26)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-832|rel:-32) dy(abs:-64|rel:-64)
; node # 45 D(-92,-19)->(-113,-20)
       fcb 2 ; drawmode 
       fcb -9,-12 ; starx/y relative to previous node
       fdb 96,160 ; dx/dy. dx(abs:-672|rel:160) dy(abs:32|rel:96)
; node # 46 D(-94,-31)->(-112,-36)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:-576|rel:96) dy(abs:160|rel:128)
; node # 47 D(-88,-49)->(-107,-43)
       fcb 2 ; drawmode 
       fcb 18,6 ; starx/y relative to previous node
       fdb -352,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:-192|rel:-352)
; node # 48 D(-65,-52)->(-91,-51)
       fcb 2 ; drawmode 
       fcb 3,23 ; starx/y relative to previous node
       fdb 160,-224 ; dx/dy. dx(abs:-832|rel:-224) dy(abs:-32|rel:160)
; node # 49 D(-58,-38)->(-87,-39)
       fcb 2 ; drawmode 
       fcb -14,7 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-928|rel:-96) dy(abs:32|rel:64)
; node # 50 D(-56,-56)->(-83,-53)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb -128,64 ; dx/dy. dx(abs:-864|rel:64) dy(abs:-96|rel:-128)
; node # 51 D(-39,-66)->(-67,-66)
       fcb 2 ; drawmode 
       fcb 10,17 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:0|rel:96)
; node # 52 D(-39,-72)->(-67,-70)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-896|rel:0) dy(abs:-64|rel:-64)
; node # 53 D(-16,-86)->(-40,-85)
       fcb 2 ; drawmode 
       fcb 14,23 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-768|rel:128) dy(abs:-32|rel:32)
; node # 54 D(-3,-86)->(-29,-86)
       fcb 2 ; drawmode 
       fcb 0,13 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:0|rel:32)
; node # 55 D(-12,-93)->(-35,-93)
       fcb 2 ; drawmode 
       fcb 7,-9 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:0|rel:0)
; node # 56 D(13,-100)->(-11,-100)
       fcb 2 ; drawmode 
       fcb 7,25 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:0|rel:0)
; node # 57 D(-3,-112)->(-26,-112)
       fcb 2 ; drawmode 
       fcb 12,-16 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-736|rel:32) dy(abs:0|rel:0)
; node # 58 D(-25,-98)->(-46,-97)
       fcb 2 ; drawmode 
       fcb -14,-22 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-672|rel:64) dy(abs:-32|rel:-32)
; node # 59 D(-31,-109)->(-49,-108)
       fcb 2 ; drawmode 
       fcb 11,-6 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-576|rel:96) dy(abs:-32|rel:0)
; node # 60 D(-14,-117)->(-35,-117)
       fcb 2 ; drawmode 
       fcb 8,17 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:0|rel:32)
; node # 61 D(-42,-118)->(-54,-116)
       fcb 2 ; drawmode 
       fcb 1,-28 ; starx/y relative to previous node
       fdb -64,288 ; dx/dy. dx(abs:-384|rel:288) dy(abs:-64|rel:-64)
; node # 62 D(-51,-117)->(-51,-117)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 64,384 ; dx/dy. dx(abs:0|rel:384) dy(abs:0|rel:64)
; node # 63 D(-57,-115)->(-57,-115)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 M(25,-79)->(25,-79)
       fcb 0 ; drawmode 
       fcb -36,82 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 M(117,-46)->(117,-46)
       fcb 0 ; drawmode 
       fcb -33,92 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 D(117,-47)->(109,-53)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 192,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:192|rel:192)
; node # 67 D(118,-43)->(110,-48)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-256|rel:0) dy(abs:160|rel:-32)
; node # 68 D(115,-52)->(103,-55)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-384|rel:-128) dy(abs:96|rel:-64)
; node # 69 D(108,-63)->(93,-66)
       fcb 2 ; drawmode 
       fcb 11,-7 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-480|rel:-96) dy(abs:96|rel:0)
; node # 70 D(99,-64)->(82,-66)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-544|rel:-64) dy(abs:64|rel:-32)
; node # 71 D(95,-62)->(72,-61)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb -96,-192 ; dx/dy. dx(abs:-736|rel:-192) dy(abs:-32|rel:-96)
; node # 72 D(86,-28)->(57,-32)
       fcb 2 ; drawmode 
       fcb -34,-9 ; starx/y relative to previous node
       fdb 160,-192 ; dx/dy. dx(abs:-928|rel:-192) dy(abs:128|rel:160)
; node # 73 D(89,-3)->(57,-4)
       fcb 2 ; drawmode 
       fcb -25,3 ; starx/y relative to previous node
       fdb -96,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:32|rel:-96)
; node # 74 D(104,16)->(76,17)
       fcb 2 ; drawmode 
       fcb -19,15 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-896|rel:128) dy(abs:-32|rel:-64)
; node # 75 D(117,11)->(98,12)
       fcb 2 ; drawmode 
       fcb 5,13 ; starx/y relative to previous node
       fdb 0,288 ; dx/dy. dx(abs:-608|rel:288) dy(abs:-32|rel:0)
; node # 76 D(120,17)->(105,19)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-480|rel:128) dy(abs:-64|rel:-32)
; node # 77 D(118,32)->(103,34)
       fcb 2 ; drawmode 
       fcb -15,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:-64|rel:0)
; node # 78 D(116,44)->(103,52)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb -192,64 ; dx/dy. dx(abs:-416|rel:64) dy(abs:-256|rel:-192)
; node # 79 D(115,47)->(92,72)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb -544,-320 ; dx/dy. dx(abs:-736|rel:-320) dy(abs:-800|rel:-544)
; node # 80 D(111,59)->(78,99)
       fcb 2 ; drawmode 
       fcb -12,-4 ; starx/y relative to previous node
       fdb -480,-320 ; dx/dy. dx(abs:-1056|rel:-320) dy(abs:-1280|rel:-480)
; node # 81 D(113,55)->(88,92)
       fcb 2 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb 96,256 ; dx/dy. dx(abs:-800|rel:256) dy(abs:-1184|rel:96)
; node # 82 D(115,49)->(94,82)
       fcb 2 ; drawmode 
       fcb 6,2 ; starx/y relative to previous node
       fdb 128,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:-1056|rel:128)
; node # 83 D(118,42)->(99,74)
       fcb 2 ; drawmode 
       fcb 7,3 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-608|rel:64) dy(abs:-1024|rel:32)
; node # 84 D(120,36)->(104,67)
       fcb 2 ; drawmode 
       fcb 6,2 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-512|rel:96) dy(abs:-992|rel:32)
; node # 85 D(123,28)->(113,52)
       fcb 2 ; drawmode 
       fcb 8,3 ; starx/y relative to previous node
       fdb 224,192 ; dx/dy. dx(abs:-320|rel:192) dy(abs:-768|rel:224)
; node # 86 D(124,23)->(118,39)
       fcb 2 ; drawmode 
       fcb 5,1 ; starx/y relative to previous node
       fdb 256,128 ; dx/dy. dx(abs:-192|rel:128) dy(abs:-512|rel:256)
; node # 87 D(126,15)->(126,15)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 512,192 ; dx/dy. dx(abs:0|rel:192) dy(abs:0|rel:512)
; node # 88 D(127,-1)->(127,-1)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 89 D(127,-1)->(127,-1)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 D(127,-14)->(127,-14)
       fcb 2 ; drawmode 
       fcb 13,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 91 D(124,-27)->(123,-31)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:128|rel:128)
; node # 92 D(117,-46)->(117,-46)
       fcb 2 ; drawmode 
       fcb 19,-7 ; starx/y relative to previous node
       fdb -128,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-128)
; node # 93 M(108,-72)->(126,-23)
       fcb 0 ; drawmode 
       fcb 26,-9 ; starx/y relative to previous node
       fdb -1568,576 ; dx/dy. dx(abs:576|rel:576) dy(abs:-1568|rel:-1568)
; node # 94 D(106,-75)->(126,-19)
       fcb 2 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb -224,64 ; dx/dy. dx(abs:640|rel:64) dy(abs:-1792|rel:-224)
; node # 95 D(103,-78)->(118,-49)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb 864,-160 ; dx/dy. dx(abs:480|rel:-160) dy(abs:-928|rel:864)
; node # 96 D(101,-80)->(107,-70)
       fcb 2 ; drawmode 
       fcb 2,-2 ; starx/y relative to previous node
       fdb 608,-288 ; dx/dy. dx(abs:192|rel:-288) dy(abs:-320|rel:608)
; node # 97 D(96,-86)->(100,-79)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:128|rel:-64) dy(abs:-224|rel:96)
; node # 98 D(106,-74)->(102,-72)
       fcb 2 ; drawmode 
       fcb -12,10 ; starx/y relative to previous node
       fdb 160,-256 ; dx/dy. dx(abs:-128|rel:-256) dy(abs:-64|rel:160)
; node # 99 D(108,-71)->(107,-65)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -128,96 ; dx/dy. dx(abs:-32|rel:96) dy(abs:-192|rel:-128)
; node # 100 D(103,-77)->(97,-75)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 128,-160 ; dx/dy. dx(abs:-192|rel:-160) dy(abs:-64|rel:128)
; node # 101 D(99,-82)->(86,-83)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 96,-224 ; dx/dy. dx(abs:-416|rel:-224) dy(abs:32|rel:96)
; node # 102 D(98,-83)->(85,-82)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-416|rel:0) dy(abs:-32|rel:-64)
; node # 103 D(103,-77)->(97,-73)
       fcb 2 ; drawmode 
       fcb -6,5 ; starx/y relative to previous node
       fdb -96,224 ; dx/dy. dx(abs:-192|rel:224) dy(abs:-128|rel:-96)
; node # 104 D(103,-76)->(97,-70)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:-192|rel:-64)
; node # 105 D(98,-80)->(84,-81)
       fcb 2 ; drawmode 
       fcb 4,-5 ; starx/y relative to previous node
       fdb 224,-256 ; dx/dy. dx(abs:-448|rel:-256) dy(abs:32|rel:224)
; node # 106 D(96,-72)->(78,-72)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-576|rel:-128) dy(abs:0|rel:-32)
; node # 107 D(97,-67)->(78,-68)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:32|rel:32)
; node # 108 D(88,-68)->(66,-68)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:0|rel:-32)
; node # 109 D(84,-81)->(63,-81)
       fcb 2 ; drawmode 
       fcb 13,-4 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:0|rel:0)
; node # 110 D(90,-80)->(72,-81)
       fcb 2 ; drawmode 
       fcb -1,6 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-576|rel:96) dy(abs:32|rel:32)
; node # 111 D(83,-91)->(64,-91)
       fcb 2 ; drawmode 
       fcb 11,-7 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:0|rel:-32)
; node # 112 D(82,-94)->(71,-97)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 96,256 ; dx/dy. dx(abs:-352|rel:256) dy(abs:96|rel:96)
; node # 113 D(83,-97)->(76,-97)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-224|rel:128) dy(abs:0|rel:-96)
; node # 114 D(77,-103)->(74,-102)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-96|rel:128) dy(abs:-32|rel:-32)
; node # 115 D(73,-106)->(70,-105)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-96|rel:0) dy(abs:-32|rel:0)
; node # 116 D(77,-103)->(71,-101)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:-64|rel:-32)
; node # 117 D(66,-110)->(56,-109)
       fcb 2 ; drawmode 
       fcb 7,-11 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-320|rel:-128) dy(abs:-32|rel:32)
; node # 118 D(64,-111)->(53,-116)
       fcb 2 ; drawmode 
       fcb 1,-2 ; starx/y relative to previous node
       fdb 192,-32 ; dx/dy. dx(abs:-352|rel:-32) dy(abs:160|rel:192)
; node # 119 D(66,-110)->(57,-115)
       fcb 2 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-288|rel:64) dy(abs:160|rel:0)
; node # 120 D(78,-102)->(78,-102)
       fcb 2 ; drawmode 
       fcb -8,12 ; starx/y relative to previous node
       fdb -160,288 ; dx/dy. dx(abs:0|rel:288) dy(abs:0|rel:-160)
; node # 121 D(96,-86)->(100,-79)
       fcb 2 ; drawmode 
       fcb -16,18 ; starx/y relative to previous node
       fdb -224,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-224|rel:-224)
       fcb  1  ; end of anim
; Animation 19
weltframe19:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-57,-115)->(-57,-115)
       fcb 0 ; drawmode 
       fcb 115,-57 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-69,-108)->(-69,-108)
       fcb 2 ; drawmode 
       fcb -7,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-84,-96)->(-84,-96)
       fcb 2 ; drawmode 
       fcb -12,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-107,-70)->(-107,-70)
       fcb 2 ; drawmode 
       fcb -26,-23 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-119,-42)->(-122,-36)
       fcb 2 ; drawmode 
       fcb -28,-12 ; starx/y relative to previous node
       fdb -192,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:-192|rel:-192)
; node # 5 D(-121,-23)->(-126,-22)
       fcb 2 ; drawmode 
       fcb -19,-2 ; starx/y relative to previous node
       fdb 160,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:-32|rel:160)
; node # 6 D(-117,-13)->(-127,-13)
       fcb 2 ; drawmode 
       fcb -10,4 ; starx/y relative to previous node
       fdb 32,-160 ; dx/dy. dx(abs:-320|rel:-160) dy(abs:0|rel:32)
; node # 7 D(-113,-15)->(-126,-14)
       fcb 2 ; drawmode 
       fcb 2,4 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-416|rel:-96) dy(abs:-32|rel:-32)
; node # 8 D(-111,-8)->(-124,-11)
       fcb 2 ; drawmode 
       fcb -7,2 ; starx/y relative to previous node
       fdb 128,0 ; dx/dy. dx(abs:-416|rel:0) dy(abs:96|rel:128)
; node # 9 D(-105,-6)->(-122,-6)
       fcb 2 ; drawmode 
       fcb -2,6 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-544|rel:-128) dy(abs:0|rel:-96)
; node # 10 D(-103,3)->(-121,-1)
       fcb 2 ; drawmode 
       fcb -9,2 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-576|rel:-32) dy(abs:128|rel:128)
; node # 11 D(-94,8)->(-115,8)
       fcb 2 ; drawmode 
       fcb -5,9 ; starx/y relative to previous node
       fdb -128,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:0|rel:-128)
; node # 12 M(-80,-3)->(-104,-3)
       fcb 0 ; drawmode 
       fcb 11,14 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:0|rel:0)
; node # 13 D(-57,2)->(-89,2)
       fcb 2 ; drawmode 
       fcb -5,23 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-1024|rel:-256) dy(abs:0|rel:0)
; node # 14 D(-47,12)->(-80,11)
       fcb 2 ; drawmode 
       fcb -10,10 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:32|rel:32)
; node # 15 D(-35,14)->(-69,14)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:0|rel:-32)
; node # 16 D(-29,23)->(-66,20)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1184|rel:-96) dy(abs:96|rel:96)
; node # 17 D(-28,30)->(-63,28)
       fcb 2 ; drawmode 
       fcb -7,1 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1120|rel:64) dy(abs:64|rel:-32)
; node # 18 D(0,38)->(-38,37)
       fcb 2 ; drawmode 
       fcb -8,28 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1216|rel:-96) dy(abs:32|rel:-32)
; node # 19 D(12,50)->(-24,47)
       fcb 2 ; drawmode 
       fcb -12,12 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-1152|rel:64) dy(abs:96|rel:64)
; node # 20 D(2,64)->(-32,64)
       fcb 2 ; drawmode 
       fcb -14,-10 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-1088|rel:64) dy(abs:0|rel:-96)
; node # 21 D(-1,83)->(-32,83)
       fcb 2 ; drawmode 
       fcb -19,-3 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-992|rel:96) dy(abs:0|rel:0)
; node # 22 D(-13,88)->(-42,87)
       fcb 2 ; drawmode 
       fcb -5,-12 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-928|rel:64) dy(abs:32|rel:32)
; node # 23 D(-18,107)->(-39,100)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb 192,256 ; dx/dy. dx(abs:-672|rel:256) dy(abs:224|rel:192)
; node # 24 D(-22,116)->(-42,112)
       fcb 2 ; drawmode 
       fcb -9,-4 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:128|rel:-96)
; node # 25 D(-16,125)->(-29,124)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb -96,224 ; dx/dy. dx(abs:-416|rel:224) dy(abs:32|rel:-96)
; node # 26 D(-42,106)->(-62,104)
       fcb 2 ; drawmode 
       fcb 19,-26 ; starx/y relative to previous node
       fdb 32,-224 ; dx/dy. dx(abs:-640|rel:-224) dy(abs:64|rel:32)
; node # 27 D(-59,76)->(-86,70)
       fcb 2 ; drawmode 
       fcb 30,-17 ; starx/y relative to previous node
       fdb 128,-224 ; dx/dy. dx(abs:-864|rel:-224) dy(abs:192|rel:128)
; node # 28 D(-74,66)->(-95,65)
       fcb 2 ; drawmode 
       fcb 10,-15 ; starx/y relative to previous node
       fdb -160,192 ; dx/dy. dx(abs:-672|rel:192) dy(abs:32|rel:-160)
; node # 29 D(-92,43)->(-110,43)
       fcb 2 ; drawmode 
       fcb 23,-18 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-576|rel:96) dy(abs:0|rel:-32)
; node # 30 D(-94,30)->(-113,30)
       fcb 2 ; drawmode 
       fcb 13,-2 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-608|rel:-32) dy(abs:0|rel:0)
; node # 31 D(-89,19)->(-111,15)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb 128,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:128|rel:128)
; node # 32 D(-92,8)->(-110,4)
       fcb 2 ; drawmode 
       fcb 11,-3 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:128|rel:0)
; node # 33 D(-80,-3)->(-104,-3)
       fcb 2 ; drawmode 
       fcb 11,12 ; starx/y relative to previous node
       fdb -128,-192 ; dx/dy. dx(abs:-768|rel:-192) dy(abs:0|rel:-128)
; node # 34 M(-94,8)->(-115,7)
       fcb 0 ; drawmode 
       fcb -11,-14 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-672|rel:96) dy(abs:32|rel:32)
; node # 35 D(-100,0)->(-116,-1)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-512|rel:160) dy(abs:32|rel:0)
; node # 36 D(-99,-12)->(-118,-13)
       fcb 2 ; drawmode 
       fcb 12,1 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:32|rel:0)
; node # 37 D(-106,-14)->(-121,-15)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-480|rel:128) dy(abs:32|rel:0)
; node # 38 D(-102,-28)->(-118,-28)
       fcb 2 ; drawmode 
       fcb 14,4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-512|rel:-32) dy(abs:0|rel:-32)
; node # 39 D(-106,-26)->(-120,-25)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-448|rel:64) dy(abs:-32|rel:-32)
; node # 40 D(-113,-20)->(-124,-20)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-352|rel:96) dy(abs:0|rel:32)
; node # 41 D(-112,-36)->(-121,-35)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-288|rel:64) dy(abs:-32|rel:-32)
; node # 42 D(-107,-43)->(-118,-44)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-352|rel:-64) dy(abs:32|rel:64)
; node # 43 D(-91,-51)->(-111,-49)
       fcb 2 ; drawmode 
       fcb 8,16 ; starx/y relative to previous node
       fdb -96,-288 ; dx/dy. dx(abs:-640|rel:-288) dy(abs:-64|rel:-96)
; node # 44 D(-87,-39)->(-106,-40)
       fcb 2 ; drawmode 
       fcb -12,4 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-608|rel:32) dy(abs:32|rel:96)
; node # 45 D(-83,-53)->(-104,-51)
       fcb 2 ; drawmode 
       fcb 14,4 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-672|rel:-64) dy(abs:-64|rel:-96)
; node # 46 D(-67,-66)->(-92,-62)
       fcb 2 ; drawmode 
       fcb 13,16 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-800|rel:-128) dy(abs:-128|rel:-64)
; node # 47 D(-67,-70)->(-88,-70)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 128,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:0|rel:128)
; node # 48 D(-40,-85)->(-63,-85)
       fcb 2 ; drawmode 
       fcb 15,27 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-736|rel:-64) dy(abs:0|rel:0)
; node # 49 D(-29,-86)->(-58,-83)
       fcb 2 ; drawmode 
       fcb 1,11 ; starx/y relative to previous node
       fdb -96,-192 ; dx/dy. dx(abs:-928|rel:-192) dy(abs:-96|rel:-96)
; node # 50 D(-35,-93)->(-55,-93)
       fcb 2 ; drawmode 
       fcb 7,-6 ; starx/y relative to previous node
       fdb 96,288 ; dx/dy. dx(abs:-640|rel:288) dy(abs:0|rel:96)
; node # 51 D(-11,-100)->(-35,-100)
       fcb 2 ; drawmode 
       fcb 7,24 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:0|rel:0)
; node # 52 D(-26,-112)->(-43,-112)
       fcb 2 ; drawmode 
       fcb 12,-15 ; starx/y relative to previous node
       fdb 0,224 ; dx/dy. dx(abs:-544|rel:224) dy(abs:0|rel:0)
; node # 53 D(-26,-112)->(-43,-112)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:0|rel:0)
; node # 54 D(-46,-97)->(-67,-96)
       fcb 2 ; drawmode 
       fcb -15,-20 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-672|rel:-128) dy(abs:-32|rel:-32)
; node # 55 D(-49,-108)->(-66,-104)
       fcb 2 ; drawmode 
       fcb 11,-3 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-544|rel:128) dy(abs:-128|rel:-96)
; node # 56 D(-35,-117)->(-45,-114)
       fcb 2 ; drawmode 
       fcb 9,14 ; starx/y relative to previous node
       fdb 32,224 ; dx/dy. dx(abs:-320|rel:224) dy(abs:-96|rel:32)
; node # 57 D(-57,-115)->(-57,-115)
       fcb 2 ; drawmode 
       fcb -2,-22 ; starx/y relative to previous node
       fdb 96,320 ; dx/dy. dx(abs:0|rel:320) dy(abs:0|rel:96)
; node # 58 M(25,-79)->(25,-79)
       fcb 0 ; drawmode 
       fcb -36,82 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 M(117,-46)->(109,-48)
       fcb 0 ; drawmode 
       fcb -33,92 ; starx/y relative to previous node
       fdb 64,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:64|rel:64)
; node # 60 D(109,-53)->(92,-57)
       fcb 2 ; drawmode 
       fcb 7,-8 ; starx/y relative to previous node
       fdb 64,-288 ; dx/dy. dx(abs:-544|rel:-288) dy(abs:128|rel:64)
; node # 61 D(110,-48)->(93,-50)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:64|rel:-64)
; node # 62 D(103,-55)->(76,-60)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb 96,-320 ; dx/dy. dx(abs:-864|rel:-320) dy(abs:160|rel:96)
; node # 63 D(93,-66)->(74,-67)
       fcb 2 ; drawmode 
       fcb 11,-10 ; starx/y relative to previous node
       fdb -128,256 ; dx/dy. dx(abs:-608|rel:256) dy(abs:32|rel:-128)
; node # 64 D(82,-66)->(46,-65)
       fcb 2 ; drawmode 
       fcb 0,-11 ; starx/y relative to previous node
       fdb -64,-544 ; dx/dy. dx(abs:-1152|rel:-544) dy(abs:-32|rel:-64)
; node # 65 D(72,-61)->(39,-59)
       fcb 2 ; drawmode 
       fcb -5,-10 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1056|rel:96) dy(abs:-64|rel:-32)
; node # 66 D(57,-32)->(27,-42)
       fcb 2 ; drawmode 
       fcb -29,-15 ; starx/y relative to previous node
       fdb 384,96 ; dx/dy. dx(abs:-960|rel:96) dy(abs:320|rel:384)
; node # 67 D(57,-4)->(23,-2)
       fcb 2 ; drawmode 
       fcb -28,0 ; starx/y relative to previous node
       fdb -384,-128 ; dx/dy. dx(abs:-1088|rel:-128) dy(abs:-64|rel:-384)
; node # 68 D(76,17)->(43,18)
       fcb 2 ; drawmode 
       fcb -21,19 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:-32|rel:32)
; node # 69 D(98,12)->(71,11)
       fcb 2 ; drawmode 
       fcb 5,22 ; starx/y relative to previous node
       fdb 64,192 ; dx/dy. dx(abs:-864|rel:192) dy(abs:32|rel:64)
; node # 70 D(105,19)->(82,19)
       fcb 2 ; drawmode 
       fcb -7,7 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-736|rel:128) dy(abs:0|rel:-32)
; node # 71 D(103,34)->(80,34)
       fcb 2 ; drawmode 
       fcb -15,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:0|rel:0)
; node # 72 D(103,52)->(82,53)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-672|rel:64) dy(abs:-32|rel:-32)
; node # 73 D(92,72)->(74,73)
       fcb 2 ; drawmode 
       fcb -20,-11 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-576|rel:96) dy(abs:-32|rel:0)
; node # 74 D(78,99)->(62,104)
       fcb 2 ; drawmode 
       fcb -27,-14 ; starx/y relative to previous node
       fdb -128,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:-160|rel:-128)
; node # 75 D(88,92)->(71,101)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-544|rel:-32) dy(abs:-288|rel:-128)
; node # 76 D(94,82)->(93,82)
       fcb 2 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb 288,512 ; dx/dy. dx(abs:-32|rel:512) dy(abs:0|rel:288)
; node # 77 D(99,74)->(97,74)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:0|rel:0)
; node # 78 D(104,67)->(104,67)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:0)
; node # 79 D(113,52)->(113,52)
       fcb 2 ; drawmode 
       fcb 15,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 80 D(126,15)->(127,15)
       fcb 2 ; drawmode 
       fcb 37,13 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:0|rel:0)
; node # 81 D(127,-1)->(126,-2)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:32|rel:32)
; node # 82 D(127,-1)->(125,-2)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:32|rel:0)
; node # 83 D(117,-46)->(109,-48)
       fcb 2 ; drawmode 
       fcb 45,-10 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-256|rel:-192) dy(abs:64|rel:32)
; node # 84 M(126,-26)->(126,-27)
       fcb 0 ; drawmode 
       fcb -20,9 ; starx/y relative to previous node
       fdb -32,256 ; dx/dy. dx(abs:0|rel:256) dy(abs:32|rel:-32)
; node # 85 D(126,-23)->(127,-9)
       fcb 2 ; drawmode 
       fcb -3,0 ; starx/y relative to previous node
       fdb -480,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-448|rel:-480)
; node # 86 D(126,-19)->(126,-2)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-544|rel:-96)
; node # 87 D(111,-63)->(104,-63)
       fcb 2 ; drawmode 
       fcb 44,-15 ; starx/y relative to previous node
       fdb 544,-224 ; dx/dy. dx(abs:-224|rel:-224) dy(abs:0|rel:544)
; node # 88 D(109,-65)->(97,-64)
       fcb 2 ; drawmode 
       fcb 2,-2 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:-384|rel:-160) dy(abs:-32|rel:-32)
; node # 89 D(108,-68)->(91,-73)
       fcb 2 ; drawmode 
       fcb 3,-1 ; starx/y relative to previous node
       fdb 192,-160 ; dx/dy. dx(abs:-544|rel:-160) dy(abs:160|rel:192)
; node # 90 D(107,-70)->(101,-74)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb -32,352 ; dx/dy. dx(abs:-192|rel:352) dy(abs:128|rel:-32)
; node # 91 D(100,-79)->(91,-82)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-288|rel:-96) dy(abs:96|rel:-32)
; node # 92 D(98,-80)->(88,-82)
       fcb 2 ; drawmode 
       fcb 1,-2 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-320|rel:-32) dy(abs:64|rel:-32)
; node # 93 D(102,-74)->(91,-74)
       fcb 2 ; drawmode 
       fcb -6,4 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-352|rel:-32) dy(abs:0|rel:-64)
; node # 94 D(102,-72)->(88,-74)
       fcb 2 ; drawmode 
       fcb -2,0 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-448|rel:-96) dy(abs:64|rel:64)
; node # 95 D(107,-65)->(92,-66)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:32|rel:-32)
; node # 96 D(97,-75)->(80,-78)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-544|rel:-64) dy(abs:96|rel:64)
; node # 97 D(86,-83)->(69,-85)
       fcb 2 ; drawmode 
       fcb 8,-11 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-544|rel:0) dy(abs:64|rel:-32)
; node # 98 D(85,-82)->(67,-84)
       fcb 2 ; drawmode 
       fcb -1,-1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-576|rel:-32) dy(abs:64|rel:0)
; node # 99 D(97,-73)->(81,-74)
       fcb 2 ; drawmode 
       fcb -9,12 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-512|rel:64) dy(abs:32|rel:-32)
; node # 100 D(97,-70)->(82,-68)
       fcb 2 ; drawmode 
       fcb -3,0 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-480|rel:32) dy(abs:-64|rel:-96)
; node # 101 D(84,-81)->(65,-82)
       fcb 2 ; drawmode 
       fcb 11,-13 ; starx/y relative to previous node
       fdb 96,-128 ; dx/dy. dx(abs:-608|rel:-128) dy(abs:32|rel:96)
; node # 102 D(83,-79)->(58,-81)
       fcb 2 ; drawmode 
       fcb -2,-1 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-800|rel:-192) dy(abs:64|rel:32)
; node # 103 D(78,-72)->(55,-76)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-736|rel:64) dy(abs:128|rel:64)
; node # 104 D(78,-68)->(54,-69)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:32|rel:-96)
; node # 105 D(66,-68)->(38,-69)
       fcb 2 ; drawmode 
       fcb 0,-12 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-896|rel:-128) dy(abs:32|rel:0)
; node # 106 D(63,-81)->(37,-82)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-832|rel:64) dy(abs:32|rel:0)
; node # 107 D(72,-81)->(49,-82)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:32|rel:0)
; node # 108 D(64,-91)->(44,-92)
       fcb 2 ; drawmode 
       fcb 10,-8 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:32|rel:0)
; node # 109 D(71,-97)->(54,-99)
       fcb 2 ; drawmode 
       fcb 6,7 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-544|rel:96) dy(abs:64|rel:32)
; node # 110 D(76,-97)->(63,-100)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-416|rel:128) dy(abs:96|rel:32)
; node # 111 D(74,-102)->(63,-106)
       fcb 2 ; drawmode 
       fcb 5,-2 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-352|rel:64) dy(abs:128|rel:32)
; node # 112 D(70,-105)->(57,-108)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-416|rel:-64) dy(abs:96|rel:-32)
; node # 113 D(71,-101)->(59,-103)
       fcb 2 ; drawmode 
       fcb -4,1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-384|rel:32) dy(abs:64|rel:-32)
; node # 114 D(56,-109)->(43,-111)
       fcb 2 ; drawmode 
       fcb 8,-15 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-416|rel:-32) dy(abs:64|rel:0)
; node # 115 D(53,-116)->(44,-119)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-288|rel:128) dy(abs:96|rel:32)
; node # 116 D(57,-115)->(53,-116)
       fcb 2 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:-128|rel:160) dy(abs:32|rel:-64)
; node # 117 D(78,-102)->(78,-102)
       fcb 2 ; drawmode 
       fcb -13,21 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:-32)
; node # 118 D(98,-82)->(98,-82)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 119 D(115,-56)->(115,-56)
       fcb 2 ; drawmode 
       fcb -26,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 120 D(126,-27)->(126,-27)
       fcb 2 ; drawmode 
       fcb -29,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 20
weltframe20:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-57,-115)->(-57,-115)
       fcb 0 ; drawmode 
       fcb 115,-57 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-69,-108)->(-69,-108)
       fcb 2 ; drawmode 
       fcb -7,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-84,-96)->(-94,-87)
       fcb 2 ; drawmode 
       fcb -12,-15 ; starx/y relative to previous node
       fdb -288,-320 ; dx/dy. dx(abs:-320|rel:-320) dy(abs:-288|rel:-288)
; node # 3 D(-107,-70)->(-107,-70)
       fcb 2 ; drawmode 
       fcb -26,-23 ; starx/y relative to previous node
       fdb 288,320 ; dx/dy. dx(abs:0|rel:320) dy(abs:0|rel:288)
; node # 4 D(-119,-45)->(-119,-45)
       fcb 2 ; drawmode 
       fcb -25,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-126,-14)->(-126,-14)
       fcb 2 ; drawmode 
       fcb -31,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-126,-14)->(-126,-14)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-121,-1)->(-126,-1)
       fcb 2 ; drawmode 
       fcb -13,5 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:0|rel:0)
; node # 8 D(-115,8)->(-126,4)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb 128,-192 ; dx/dy. dx(abs:-352|rel:-192) dy(abs:128|rel:128)
; node # 9 M(-104,-3)->(-121,-2)
       fcb 0 ; drawmode 
       fcb 11,11 ; starx/y relative to previous node
       fdb -160,-192 ; dx/dy. dx(abs:-544|rel:-192) dy(abs:-32|rel:-160)
; node # 10 D(-89,2)->(-114,0)
       fcb 2 ; drawmode 
       fcb -5,15 ; starx/y relative to previous node
       fdb 96,-256 ; dx/dy. dx(abs:-800|rel:-256) dy(abs:64|rel:96)
; node # 11 D(-80,11)->(-104,11)
       fcb 2 ; drawmode 
       fcb -9,9 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:0|rel:-64)
; node # 12 D(-69,14)->(-96,13)
       fcb 2 ; drawmode 
       fcb -3,11 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-864|rel:-96) dy(abs:32|rel:32)
; node # 13 D(-63,28)->(-91,29)
       fcb 2 ; drawmode 
       fcb -14,6 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-896|rel:-32) dy(abs:-32|rel:-64)
; node # 14 D(-38,37)->(-69,38)
       fcb 2 ; drawmode 
       fcb -9,25 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-992|rel:-96) dy(abs:-32|rel:0)
; node # 15 D(-24,47)->(-58,47)
       fcb 2 ; drawmode 
       fcb -10,14 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1088|rel:-96) dy(abs:0|rel:32)
; node # 16 D(-32,64)->(-60,64)
       fcb 2 ; drawmode 
       fcb -17,-8 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-896|rel:192) dy(abs:0|rel:0)
; node # 17 D(-32,83)->(-56,83)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-768|rel:128) dy(abs:0|rel:0)
; node # 18 D(-42,87)->(-64,87)
       fcb 2 ; drawmode 
       fcb -4,-10 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:0|rel:0)
; node # 19 D(-39,100)->(-57,103)
       fcb 2 ; drawmode 
       fcb -13,3 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:-96|rel:-96)
; node # 20 D(-42,112)->(-54,112)
       fcb 2 ; drawmode 
       fcb -12,-3 ; starx/y relative to previous node
       fdb 96,192 ; dx/dy. dx(abs:-384|rel:192) dy(abs:0|rel:96)
; node # 21 D(-29,124)->(-40,121)
       fcb 2 ; drawmode 
       fcb -12,13 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-352|rel:32) dy(abs:96|rel:96)
; node # 22 D(-62,104)->(-79,98)
       fcb 2 ; drawmode 
       fcb 20,-33 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-544|rel:-192) dy(abs:192|rel:96)
; node # 23 D(-86,70)->(-107,63)
       fcb 2 ; drawmode 
       fcb 34,-24 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-672|rel:-128) dy(abs:224|rel:32)
; node # 24 D(-95,65)->(-111,59)
       fcb 2 ; drawmode 
       fcb 5,-9 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-512|rel:160) dy(abs:192|rel:-32)
; node # 25 D(-110,43)->(-120,40)
       fcb 2 ; drawmode 
       fcb 22,-15 ; starx/y relative to previous node
       fdb -96,192 ; dx/dy. dx(abs:-320|rel:192) dy(abs:96|rel:-96)
; node # 26 D(-113,30)->(-123,27)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:96|rel:0)
; node # 27 D(-110,4)->(-125,6)
       fcb 2 ; drawmode 
       fcb 26,3 ; starx/y relative to previous node
       fdb -160,-160 ; dx/dy. dx(abs:-480|rel:-160) dy(abs:-64|rel:-160)
; node # 28 D(-104,-3)->(-121,-2)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-544|rel:-64) dy(abs:-32|rel:32)
; node # 29 M(-115,7)->(-126,5)
       fcb 0 ; drawmode 
       fcb -10,-11 ; starx/y relative to previous node
       fdb 96,192 ; dx/dy. dx(abs:-352|rel:192) dy(abs:64|rel:96)
; node # 30 D(-118,-13)->(-125,-14)
       fcb 2 ; drawmode 
       fcb 20,-3 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-224|rel:128) dy(abs:32|rel:-32)
; node # 31 D(-121,-15)->(-125,-16)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-128|rel:96) dy(abs:32|rel:0)
; node # 32 D(-118,-28)->(-122,-30)
       fcb 2 ; drawmode 
       fcb 13,3 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:64|rel:32)
; node # 33 D(-124,-20)->(-124,-20)
       fcb 2 ; drawmode 
       fcb -8,-6 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:-64)
; node # 34 D(-117,-44)->(-118,-47)
       fcb 2 ; drawmode 
       fcb 24,7 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:96|rel:96)
; node # 35 D(-111,-49)->(-117,-48)
       fcb 2 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb -128,-160 ; dx/dy. dx(abs:-192|rel:-160) dy(abs:-32|rel:-128)
; node # 36 D(-106,-39)->(-120,-41)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 96,-256 ; dx/dy. dx(abs:-448|rel:-256) dy(abs:64|rel:96)
; node # 37 D(-104,-51)->(-116,-50)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-384|rel:64) dy(abs:-32|rel:-96)
; node # 38 D(-92,-62)->(-105,-62)
       fcb 2 ; drawmode 
       fcb 11,12 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-416|rel:-32) dy(abs:0|rel:32)
; node # 39 D(-88,-70)->(-103,-68)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-480|rel:-64) dy(abs:-64|rel:-64)
; node # 40 D(-63,-85)->(-84,-83)
       fcb 2 ; drawmode 
       fcb 15,25 ; starx/y relative to previous node
       fdb 0,-192 ; dx/dy. dx(abs:-672|rel:-192) dy(abs:-64|rel:0)
; node # 41 D(-58,-83)->(-77,-86)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb 160,64 ; dx/dy. dx(abs:-608|rel:64) dy(abs:96|rel:160)
; node # 42 D(-55,-93)->(-80,-90)
       fcb 2 ; drawmode 
       fcb 10,3 ; starx/y relative to previous node
       fdb -192,-192 ; dx/dy. dx(abs:-800|rel:-192) dy(abs:-96|rel:-192)
; node # 43 D(-35,-100)->(-56,-98)
       fcb 2 ; drawmode 
       fcb 7,20 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-672|rel:128) dy(abs:-64|rel:32)
; node # 44 D(-43,-112)->(-56,-105)
       fcb 2 ; drawmode 
       fcb 12,-8 ; starx/y relative to previous node
       fdb -160,256 ; dx/dy. dx(abs:-416|rel:256) dy(abs:-224|rel:-160)
; node # 45 D(-43,-112)->(-59,-109)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 128,-96 ; dx/dy. dx(abs:-512|rel:-96) dy(abs:-96|rel:128)
; node # 46 D(-67,-96)->(-80,-93)
       fcb 2 ; drawmode 
       fcb -16,-24 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-416|rel:96) dy(abs:-96|rel:0)
; node # 47 D(-66,-104)->(-76,-102)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-320|rel:96) dy(abs:-64|rel:32)
; node # 48 D(-45,-114)->(-55,-113)
       fcb 2 ; drawmode 
       fcb 10,21 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:-32|rel:32)
; node # 49 D(-57,-115)->(-57,-115)
       fcb 2 ; drawmode 
       fcb 1,-12 ; starx/y relative to previous node
       fdb 32,320 ; dx/dy. dx(abs:0|rel:320) dy(abs:0|rel:32)
; node # 50 M(25,-79)->(0,-75)
       fcb 0 ; drawmode 
       fcb -36,82 ; starx/y relative to previous node
       fdb -128,-800 ; dx/dy. dx(abs:-800|rel:-800) dy(abs:-128|rel:-128)
; node # 51 M(109,-48)->(87,-51)
       fcb 0 ; drawmode 
       fcb -31,84 ; starx/y relative to previous node
       fdb 224,96 ; dx/dy. dx(abs:-704|rel:96) dy(abs:96|rel:224)
; node # 52 D(92,-57)->(69,-58)
       fcb 2 ; drawmode 
       fcb 9,-17 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-736|rel:-32) dy(abs:32|rel:-64)
; node # 53 D(93,-50)->(68,-51)
       fcb 2 ; drawmode 
       fcb -7,1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-800|rel:-64) dy(abs:32|rel:0)
; node # 54 D(76,-60)->(48,-61)
       fcb 2 ; drawmode 
       fcb 10,-17 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-896|rel:-96) dy(abs:32|rel:0)
; node # 55 D(74,-67)->(47,-67)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:0|rel:-32)
; node # 56 D(46,-65)->(16,-64)
       fcb 2 ; drawmode 
       fcb -2,-28 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:-32|rel:-32)
; node # 57 D(39,-59)->(2,-51)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb -224,-224 ; dx/dy. dx(abs:-1184|rel:-224) dy(abs:-256|rel:-224)
; node # 58 D(27,-42)->(-12,-29)
       fcb 2 ; drawmode 
       fcb -17,-12 ; starx/y relative to previous node
       fdb -160,-64 ; dx/dy. dx(abs:-1248|rel:-64) dy(abs:-416|rel:-160)
; node # 59 D(23,-2)->(-12,-4)
       fcb 2 ; drawmode 
       fcb -40,-4 ; starx/y relative to previous node
       fdb 480,128 ; dx/dy. dx(abs:-1120|rel:128) dy(abs:64|rel:480)
; node # 60 D(43,18)->(9,18)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1088|rel:32) dy(abs:0|rel:-64)
; node # 61 D(71,11)->(38,11)
       fcb 2 ; drawmode 
       fcb 7,28 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:0|rel:0)
; node # 62 D(82,19)->(52,19)
       fcb 2 ; drawmode 
       fcb -8,11 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-960|rel:96) dy(abs:0|rel:0)
; node # 63 D(80,34)->(50,33)
       fcb 2 ; drawmode 
       fcb -15,-2 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:32|rel:32)
; node # 64 D(82,53)->(56,57)
       fcb 2 ; drawmode 
       fcb -19,2 ; starx/y relative to previous node
       fdb -160,128 ; dx/dy. dx(abs:-832|rel:128) dy(abs:-128|rel:-160)
; node # 65 D(74,73)->(49,75)
       fcb 2 ; drawmode 
       fcb -20,-8 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:-800|rel:32) dy(abs:-64|rel:64)
; node # 66 D(62,104)->(47,105)
       fcb 2 ; drawmode 
       fcb -31,-12 ; starx/y relative to previous node
       fdb 32,320 ; dx/dy. dx(abs:-480|rel:320) dy(abs:-32|rel:32)
; node # 67 D(71,101)->(57,102)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-448|rel:32) dy(abs:-32|rel:0)
; node # 68 D(93,82)->(73,89)
       fcb 2 ; drawmode 
       fcb 19,22 ; starx/y relative to previous node
       fdb -192,-192 ; dx/dy. dx(abs:-640|rel:-192) dy(abs:-224|rel:-192)
; node # 69 D(97,74)->(82,76)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb 160,160 ; dx/dy. dx(abs:-480|rel:160) dy(abs:-64|rel:160)
; node # 70 D(104,67)->(92,69)
       fcb 2 ; drawmode 
       fcb 7,7 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-384|rel:96) dy(abs:-64|rel:0)
; node # 71 D(113,52)->(100,58)
       fcb 2 ; drawmode 
       fcb 15,9 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-416|rel:-32) dy(abs:-192|rel:-128)
; node # 72 D(118,39)->(104,40)
       fcb 2 ; drawmode 
       fcb 13,5 ; starx/y relative to previous node
       fdb 160,-32 ; dx/dy. dx(abs:-448|rel:-32) dy(abs:-32|rel:160)
; node # 73 D(127,15)->(117,20)
       fcb 2 ; drawmode 
       fcb 24,9 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-320|rel:128) dy(abs:-160|rel:-128)
; node # 74 D(126,-2)->(121,0)
       fcb 2 ; drawmode 
       fcb 17,-1 ; starx/y relative to previous node
       fdb 96,160 ; dx/dy. dx(abs:-160|rel:160) dy(abs:-64|rel:96)
; node # 75 D(125,-2)->(114,-1)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-352|rel:-192) dy(abs:-32|rel:32)
; node # 76 D(109,-48)->(87,-51)
       fcb 2 ; drawmode 
       fcb 46,-16 ; starx/y relative to previous node
       fdb 128,-352 ; dx/dy. dx(abs:-704|rel:-352) dy(abs:96|rel:128)
; node # 77 M(109,66)->(105,61)
       fcb 0 ; drawmode 
       fcb -114,0 ; starx/y relative to previous node
       fdb 64,576 ; dx/dy. dx(abs:-128|rel:576) dy(abs:160|rel:64)
; node # 78 D(99,80)->(89,81)
       fcb 2 ; drawmode 
       fcb -14,-10 ; starx/y relative to previous node
       fdb -192,-192 ; dx/dy. dx(abs:-320|rel:-192) dy(abs:-32|rel:-192)
; node # 79 D(96,84)->(87,87)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-288|rel:32) dy(abs:-96|rel:-64)
; node # 80 D(109,66)->(105,61)
       fcb 2 ; drawmode 
       fcb 18,13 ; starx/y relative to previous node
       fdb 256,160 ; dx/dy. dx(abs:-128|rel:160) dy(abs:160|rel:256)
; node # 81 M(126,-24)->(123,-26)
       fcb 0 ; drawmode 
       fcb 90,17 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:-96|rel:32) dy(abs:64|rel:-96)
; node # 82 D(126,-20)->(122,-20)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-128|rel:-32) dy(abs:0|rel:-64)
; node # 83 D(126,-2)->(116,-4)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 64,-192 ; dx/dy. dx(abs:-320|rel:-192) dy(abs:64|rel:64)
; node # 84 D(113,-44)->(95,-48)
       fcb 2 ; drawmode 
       fcb 42,-13 ; starx/y relative to previous node
       fdb 64,-256 ; dx/dy. dx(abs:-576|rel:-256) dy(abs:128|rel:64)
; node # 85 D(104,-63)->(90,-63)
       fcb 2 ; drawmode 
       fcb 19,-9 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-448|rel:128) dy(abs:0|rel:-128)
; node # 86 D(97,-64)->(77,-67)
       fcb 2 ; drawmode 
       fcb 1,-7 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-640|rel:-192) dy(abs:96|rel:96)
; node # 87 D(91,-73)->(73,-73)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb -96,64 ; dx/dy. dx(abs:-576|rel:64) dy(abs:0|rel:-96)
; node # 88 D(101,-74)->(88,-76)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb 64,160 ; dx/dy. dx(abs:-416|rel:160) dy(abs:64|rel:64)
; node # 89 D(91,-82)->(78,-86)
       fcb 2 ; drawmode 
       fcb 8,-10 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-416|rel:0) dy(abs:128|rel:64)
; node # 90 D(88,-82)->(71,-85)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-544|rel:-128) dy(abs:96|rel:-32)
; node # 91 D(91,-74)->(72,-76)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-608|rel:-64) dy(abs:64|rel:-32)
; node # 92 D(88,-74)->(66,-74)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:0|rel:-64)
; node # 93 D(92,-66)->(70,-66)
       fcb 2 ; drawmode 
       fcb -8,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-704|rel:0) dy(abs:0|rel:0)
; node # 94 D(80,-78)->(56,-81)
       fcb 2 ; drawmode 
       fcb 12,-12 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-768|rel:-64) dy(abs:96|rel:96)
; node # 95 D(69,-85)->(46,-86)
       fcb 2 ; drawmode 
       fcb 7,-11 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-736|rel:32) dy(abs:32|rel:-64)
; node # 96 D(67,-84)->(44,-85)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:32|rel:0)
; node # 97 D(81,-74)->(57,-76)
       fcb 2 ; drawmode 
       fcb -10,14 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:64|rel:32)
; node # 98 D(82,-68)->(57,-68)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:0|rel:-64)
; node # 99 D(65,-82)->(41,-83)
       fcb 2 ; drawmode 
       fcb 14,-17 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:32|rel:32)
; node # 100 D(58,-81)->(32,-82)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:32|rel:0)
; node # 101 D(55,-76)->(25,-75)
       fcb 2 ; drawmode 
       fcb -5,-3 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-960|rel:-128) dy(abs:-32|rel:-64)
; node # 102 D(54,-69)->(24,-69)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:0|rel:32)
; node # 103 D(38,-69)->(6,-69)
       fcb 2 ; drawmode 
       fcb 0,-16 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:0|rel:0)
; node # 104 D(37,-82)->(8,-83)
       fcb 2 ; drawmode 
       fcb 13,-1 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-928|rel:96) dy(abs:32|rel:32)
; node # 105 D(49,-82)->(21,-82)
       fcb 2 ; drawmode 
       fcb 0,12 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:-32)
; node # 106 D(44,-92)->(17,-91)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-864|rel:32) dy(abs:-32|rel:-32)
; node # 107 D(54,-99)->(33,-100)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 64,192 ; dx/dy. dx(abs:-672|rel:192) dy(abs:32|rel:64)
; node # 108 D(63,-100)->(46,-101)
       fcb 2 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-544|rel:128) dy(abs:32|rel:0)
; node # 109 D(63,-106)->(50,-108)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-416|rel:128) dy(abs:64|rel:32)
; node # 110 D(57,-108)->(42,-109)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-480|rel:-64) dy(abs:32|rel:-32)
; node # 111 D(59,-103)->(40,-104)
       fcb 2 ; drawmode 
       fcb -5,2 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-608|rel:-128) dy(abs:32|rel:0)
; node # 112 D(43,-111)->(24,-112)
       fcb 2 ; drawmode 
       fcb 8,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:32|rel:0)
; node # 113 D(44,-119)->(34,-120)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 0,288 ; dx/dy. dx(abs:-320|rel:288) dy(abs:32|rel:0)
; node # 114 D(57,-114)->(48,-115)
       fcb 2 ; drawmode 
       fcb -5,13 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-288|rel:32) dy(abs:32|rel:0)
; node # 115 D(58,-113)->(44,-114)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-448|rel:-160) dy(abs:32|rel:0)
; node # 116 D(53,-116)->(51,-116)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb -32,384 ; dx/dy. dx(abs:-64|rel:384) dy(abs:0|rel:-32)
; node # 117 D(78,-102)->(78,-102)
       fcb 2 ; drawmode 
       fcb -14,25 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:0)
; node # 118 D(98,-82)->(98,-82)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 119 D(115,-56)->(115,-56)
       fcb 2 ; drawmode 
       fcb -26,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 120 D(126,-27)->(126,-27)
       fcb 2 ; drawmode 
       fcb -29,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 121 D(120,-43)->(112,-46)
       fcb 2 ; drawmode 
       fcb 16,-6 ; starx/y relative to previous node
       fdb 96,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:96|rel:96)
; node # 122 D(120,-43)->(110,-43)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -96,-64 ; dx/dy. dx(abs:-320|rel:-64) dy(abs:0|rel:-96)
; node # 123 D(126,-26)->(123,-26)
       fcb 2 ; drawmode 
       fcb -17,6 ; starx/y relative to previous node
       fdb 0,224 ; dx/dy. dx(abs:-96|rel:224) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 21
weltframe21:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-57,-115)->(-68,-108)
       fcb 0 ; drawmode 
       fcb 115,-57 ; starx/y relative to previous node
       fdb -224,-352 ; dx/dy. dx(abs:-352|rel:-352) dy(abs:-224|rel:-224)
; node # 1 D(-69,-108)->(-69,-108)
       fcb 2 ; drawmode 
       fcb -7,-12 ; starx/y relative to previous node
       fdb 224,352 ; dx/dy. dx(abs:0|rel:352) dy(abs:0|rel:224)
; node # 2 D(-94,-87)->(-98,-82)
       fcb 2 ; drawmode 
       fcb -21,-25 ; starx/y relative to previous node
       fdb -160,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-160|rel:-160)
; node # 3 D(-107,-70)->(-107,-70)
       fcb 2 ; drawmode 
       fcb -17,-13 ; starx/y relative to previous node
       fdb 160,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:160)
; node # 4 D(-123,-35)->(-114,-57)
       fcb 2 ; drawmode 
       fcb -35,-16 ; starx/y relative to previous node
       fdb 704,288 ; dx/dy. dx(abs:288|rel:288) dy(abs:704|rel:704)
; node # 5 M(-121,-2)->(-127,-1)
       fcb 0 ; drawmode 
       fcb -33,2 ; starx/y relative to previous node
       fdb -736,-480 ; dx/dy. dx(abs:-192|rel:-480) dy(abs:-32|rel:-736)
; node # 6 D(-113,0)->(-123,4)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-320|rel:-128) dy(abs:-128|rel:-96)
; node # 7 D(-104,11)->(-120,12)
       fcb 2 ; drawmode 
       fcb -11,9 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-512|rel:-192) dy(abs:-32|rel:96)
; node # 8 D(-96,13)->(-115,14)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:-32|rel:0)
; node # 9 D(-91,29)->(-112,29)
       fcb 2 ; drawmode 
       fcb -16,5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-672|rel:-64) dy(abs:0|rel:32)
; node # 10 D(-69,38)->(-94,37)
       fcb 2 ; drawmode 
       fcb -9,22 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-800|rel:-128) dy(abs:32|rel:32)
; node # 11 D(-58,47)->(-83,45)
       fcb 2 ; drawmode 
       fcb -9,11 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-800|rel:0) dy(abs:64|rel:32)
; node # 12 D(-60,64)->(-86,60)
       fcb 2 ; drawmode 
       fcb -17,-2 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-832|rel:-32) dy(abs:128|rel:64)
; node # 13 D(-56,83)->(-78,80)
       fcb 2 ; drawmode 
       fcb -19,4 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-704|rel:128) dy(abs:96|rel:-32)
; node # 14 D(-64,87)->(-82,86)
       fcb 2 ; drawmode 
       fcb -4,-8 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:32|rel:-64)
; node # 15 D(-57,103)->(-72,101)
       fcb 2 ; drawmode 
       fcb -16,7 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-480|rel:96) dy(abs:64|rel:32)
; node # 16 D(-54,112)->(-63,111)
       fcb 2 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-288|rel:192) dy(abs:32|rel:-32)
; node # 17 D(-40,121)->(-59,114)
       fcb 2 ; drawmode 
       fcb -9,14 ; starx/y relative to previous node
       fdb 192,-320 ; dx/dy. dx(abs:-608|rel:-320) dy(abs:224|rel:192)
; node # 18 D(-79,98)->(-85,97)
       fcb 2 ; drawmode 
       fcb 23,-39 ; starx/y relative to previous node
       fdb -192,416 ; dx/dy. dx(abs:-192|rel:416) dy(abs:32|rel:-192)
; node # 19 D(-107,63)->(-101,79)
       fcb 2 ; drawmode 
       fcb 35,-28 ; starx/y relative to previous node
       fdb -544,384 ; dx/dy. dx(abs:192|rel:384) dy(abs:-512|rel:-544)
; node # 20 D(-111,59)->(-110,64)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 352,-160 ; dx/dy. dx(abs:32|rel:-160) dy(abs:-160|rel:352)
; node # 21 D(-120,40)->(-119,49)
       fcb 2 ; drawmode 
       fcb 19,-9 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-288|rel:-128)
; node # 22 D(-123,27)->(-124,32)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:-160|rel:128)
; node # 23 D(-124,17)->(-127,17)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 160,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:0|rel:160)
; node # 24 D(-124,7)->(-128,6)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-128|rel:-32) dy(abs:32|rel:32)
; node # 25 D(-121,-2)->(-127,-1)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-192|rel:-64) dy(abs:-32|rel:-64)
; node # 26 M(-126,-18)->(-124,-31)
       fcb 0 ; drawmode 
       fcb 16,-5 ; starx/y relative to previous node
       fdb 448,256 ; dx/dy. dx(abs:64|rel:256) dy(abs:416|rel:448)
; node # 27 D(-123,-35)->(-123,-35)
       fcb 2 ; drawmode 
       fcb 17,3 ; starx/y relative to previous node
       fdb -416,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:0|rel:-416)
; node # 28 D(-116,-47)->(-119,-47)
       fcb 2 ; drawmode 
       fcb 12,7 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:0|rel:0)
; node # 29 D(-116,-50)->(-117,-51)
       fcb 2 ; drawmode 
       fcb 3,0 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-32|rel:64) dy(abs:32|rel:32)
; node # 30 D(-105,-62)->(-110,-64)
       fcb 2 ; drawmode 
       fcb 12,11 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-160|rel:-128) dy(abs:64|rel:32)
; node # 31 D(-103,-68)->(-107,-69)
       fcb 2 ; drawmode 
       fcb 6,2 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-128|rel:32) dy(abs:32|rel:-32)
; node # 32 D(-84,-83)->(-96,-82)
       fcb 2 ; drawmode 
       fcb 15,19 ; starx/y relative to previous node
       fdb -64,-256 ; dx/dy. dx(abs:-384|rel:-256) dy(abs:-32|rel:-64)
; node # 33 D(-77,-86)->(-91,-81)
       fcb 2 ; drawmode 
       fcb 3,7 ; starx/y relative to previous node
       fdb -128,-64 ; dx/dy. dx(abs:-448|rel:-64) dy(abs:-160|rel:-128)
; node # 34 D(-80,-90)->(-90,-87)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 64,128 ; dx/dy. dx(abs:-320|rel:128) dy(abs:-96|rel:64)
; node # 35 D(-56,-98)->(-72,-96)
       fcb 2 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-512|rel:-192) dy(abs:-64|rel:32)
; node # 36 D(-56,-105)->(-70,-105)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-448|rel:64) dy(abs:0|rel:64)
; node # 37 D(-59,-109)->(-70,-106)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb -96,96 ; dx/dy. dx(abs:-352|rel:96) dy(abs:-96|rel:-96)
; node # 38 D(-80,-93)->(-81,-97)
       fcb 2 ; drawmode 
       fcb -16,-21 ; starx/y relative to previous node
       fdb 224,320 ; dx/dy. dx(abs:-32|rel:320) dy(abs:128|rel:224)
; node # 39 D(-76,-102)->(-81,-97)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb -288,-128 ; dx/dy. dx(abs:-160|rel:-128) dy(abs:-160|rel:-288)
; node # 40 D(-55,-113)->(-75,-103)
       fcb 2 ; drawmode 
       fcb 11,21 ; starx/y relative to previous node
       fdb -160,-480 ; dx/dy. dx(abs:-640|rel:-480) dy(abs:-320|rel:-160)
; node # 41 D(-57,-115)->(-73,-104)
       fcb 2 ; drawmode 
       fcb 2,-2 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-512|rel:128) dy(abs:-352|rel:-32)
; node # 42 M(30,-75)->(7,-73)
       fcb 0 ; drawmode 
       fcb -40,87 ; starx/y relative to previous node
       fdb 288,-224 ; dx/dy. dx(abs:-736|rel:-224) dy(abs:-64|rel:288)
; node # 43 M(87,-51)->(62,-52)
       fcb 0 ; drawmode 
       fcb -24,57 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-800|rel:-64) dy(abs:32|rel:96)
; node # 44 D(69,-58)->(40,-59)
       fcb 2 ; drawmode 
       fcb 7,-18 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-928|rel:-128) dy(abs:32|rel:0)
; node # 45 D(68,-51)->(37,-52)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-992|rel:-64) dy(abs:32|rel:0)
; node # 46 D(48,-61)->(16,-61)
       fcb 2 ; drawmode 
       fcb 10,-20 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1024|rel:-32) dy(abs:0|rel:-32)
; node # 47 D(47,-67)->(16,-68)
       fcb 2 ; drawmode 
       fcb 6,-1 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:32|rel:32)
; node # 48 D(16,-64)->(-19,-65)
       fcb 2 ; drawmode 
       fcb -3,-31 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-1120|rel:-128) dy(abs:32|rel:0)
; node # 49 D(2,-51)->(-33,-52)
       fcb 2 ; drawmode 
       fcb -13,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:32|rel:0)
; node # 50 D(-12,-29)->(-50,-28)
       fcb 2 ; drawmode 
       fcb -22,-14 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-1216|rel:-96) dy(abs:-32|rel:-64)
; node # 51 D(-12,-4)->(-50,-4)
       fcb 2 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-1216|rel:0) dy(abs:0|rel:32)
; node # 52 D(9,18)->(-26,17)
       fcb 2 ; drawmode 
       fcb -22,21 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-1120|rel:96) dy(abs:32|rel:32)
; node # 53 D(38,11)->(2,12)
       fcb 2 ; drawmode 
       fcb 7,29 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-1152|rel:-32) dy(abs:-32|rel:-64)
; node # 54 D(52,19)->(13,17)
       fcb 2 ; drawmode 
       fcb -8,14 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1248|rel:-96) dy(abs:64|rel:96)
; node # 55 D(50,33)->(15,33)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:-1120|rel:128) dy(abs:0|rel:-64)
; node # 56 D(56,57)->(24,58)
       fcb 2 ; drawmode 
       fcb -24,6 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1024|rel:96) dy(abs:-32|rel:-32)
; node # 57 D(49,75)->(18,71)
       fcb 2 ; drawmode 
       fcb -18,-7 ; starx/y relative to previous node
       fdb 160,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:128|rel:160)
; node # 58 D(47,105)->(25,106)
       fcb 2 ; drawmode 
       fcb -30,-2 ; starx/y relative to previous node
       fdb -160,288 ; dx/dy. dx(abs:-704|rel:288) dy(abs:-32|rel:-160)
; node # 59 D(57,102)->(39,103)
       fcb 2 ; drawmode 
       fcb 3,10 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-576|rel:128) dy(abs:-32|rel:0)
; node # 60 D(73,89)->(50,95)
       fcb 2 ; drawmode 
       fcb 13,16 ; starx/y relative to previous node
       fdb -160,-160 ; dx/dy. dx(abs:-736|rel:-160) dy(abs:-192|rel:-160)
; node # 61 D(82,76)->(59,86)
       fcb 2 ; drawmode 
       fcb 13,9 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:-320|rel:-128)
; node # 62 D(92,69)->(64,76)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-896|rel:-160) dy(abs:-224|rel:96)
; node # 63 D(100,58)->(80,62)
       fcb 2 ; drawmode 
       fcb 11,8 ; starx/y relative to previous node
       fdb 96,256 ; dx/dy. dx(abs:-640|rel:256) dy(abs:-128|rel:96)
; node # 64 D(104,40)->(81,41)
       fcb 2 ; drawmode 
       fcb 18,4 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:-32|rel:96)
; node # 65 D(117,20)->(100,18)
       fcb 2 ; drawmode 
       fcb 20,13 ; starx/y relative to previous node
       fdb 96,192 ; dx/dy. dx(abs:-544|rel:192) dy(abs:64|rel:96)
; node # 66 D(121,0)->(105,-1)
       fcb 2 ; drawmode 
       fcb 20,4 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-512|rel:32) dy(abs:32|rel:-32)
; node # 67 D(115,0)->(96,0)
       fcb 2 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:0|rel:-32)
; node # 68 D(87,-51)->(62,-52)
       fcb 2 ; drawmode 
       fcb 51,-28 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-800|rel:-192) dy(abs:32|rel:32)
; node # 69 M(105,61)->(91,60)
       fcb 0 ; drawmode 
       fcb -112,18 ; starx/y relative to previous node
       fdb 0,352 ; dx/dy. dx(abs:-448|rel:352) dy(abs:32|rel:0)
; node # 70 D(89,81)->(74,81)
       fcb 2 ; drawmode 
       fcb -20,-16 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-480|rel:-32) dy(abs:0|rel:-32)
; node # 71 D(87,87)->(72,89)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:-64|rel:-64)
; node # 72 D(105,61)->(91,60)
       fcb 2 ; drawmode 
       fcb 26,18 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-448|rel:32) dy(abs:32|rel:96)
; node # 73 M(123,-26)->(112,-30)
       fcb 0 ; drawmode 
       fcb 87,18 ; starx/y relative to previous node
       fdb 96,96 ; dx/dy. dx(abs:-352|rel:96) dy(abs:128|rel:96)
; node # 74 D(122,-20)->(111,-19)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb -160,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:-32|rel:-160)
; node # 75 D(116,-4)->(96,-6)
       fcb 2 ; drawmode 
       fcb -16,-6 ; starx/y relative to previous node
       fdb 96,-288 ; dx/dy. dx(abs:-640|rel:-288) dy(abs:64|rel:96)
; node # 76 D(95,-48)->(72,-47)
       fcb 2 ; drawmode 
       fcb 44,-21 ; starx/y relative to previous node
       fdb -96,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:-32|rel:-96)
; node # 77 D(90,-63)->(65,-66)
       fcb 2 ; drawmode 
       fcb 15,-5 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-800|rel:-64) dy(abs:96|rel:128)
; node # 78 D(77,-67)->(53,-66)
       fcb 2 ; drawmode 
       fcb 4,-13 ; starx/y relative to previous node
       fdb -128,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:-32|rel:-128)
; node # 79 D(73,-73)->(48,-73)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-800|rel:-32) dy(abs:0|rel:32)
; node # 80 D(88,-76)->(69,-77)
       fcb 2 ; drawmode 
       fcb 3,15 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-608|rel:192) dy(abs:32|rel:32)
; node # 81 D(78,-86)->(58,-89)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-640|rel:-32) dy(abs:96|rel:64)
; node # 82 D(71,-85)->(47,-86)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-768|rel:-128) dy(abs:32|rel:-64)
; node # 83 D(72,-76)->(46,-77)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:32|rel:0)
; node # 84 D(66,-74)->(40,-76)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-832|rel:0) dy(abs:64|rel:32)
; node # 85 D(70,-66)->(42,-67)
       fcb 2 ; drawmode 
       fcb -8,4 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-896|rel:-64) dy(abs:32|rel:-32)
; node # 86 D(56,-81)->(32,-78)
       fcb 2 ; drawmode 
       fcb 15,-14 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-768|rel:128) dy(abs:-96|rel:-128)
; node # 87 D(46,-86)->(19,-88)
       fcb 2 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb 160,-96 ; dx/dy. dx(abs:-864|rel:-96) dy(abs:64|rel:160)
; node # 88 D(44,-85)->(17,-86)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-864|rel:0) dy(abs:32|rel:-32)
; node # 89 D(57,-76)->(28,-77)
       fcb 2 ; drawmode 
       fcb -9,13 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:32|rel:0)
; node # 90 D(57,-68)->(28,-70)
       fcb 2 ; drawmode 
       fcb -8,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:64|rel:32)
; node # 91 D(41,-83)->(13,-83)
       fcb 2 ; drawmode 
       fcb 15,-16 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:-64)
; node # 92 D(32,-82)->(0,-79)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb -96,-128 ; dx/dy. dx(abs:-1024|rel:-128) dy(abs:-96|rel:-96)
; node # 93 D(25,-75)->(-6,-75)
       fcb 2 ; drawmode 
       fcb -7,-7 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:0|rel:96)
; node # 94 D(24,-69)->(-6,-70)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:32|rel:32)
; node # 95 D(6,-69)->(-24,-69)
       fcb 2 ; drawmode 
       fcb 0,-18 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:0|rel:-32)
; node # 96 D(8,-83)->(-21,-83)
       fcb 2 ; drawmode 
       fcb 14,2 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:0|rel:0)
; node # 97 D(21,-82)->(-7,-82)
       fcb 2 ; drawmode 
       fcb -1,13 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:0)
; node # 98 D(17,-91)->(-8,-93)
       fcb 2 ; drawmode 
       fcb 9,-4 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-800|rel:96) dy(abs:64|rel:64)
; node # 99 D(33,-100)->(7,-101)
       fcb 2 ; drawmode 
       fcb 9,16 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-832|rel:-32) dy(abs:32|rel:-32)
; node # 100 D(46,-101)->(21,-102)
       fcb 2 ; drawmode 
       fcb 1,13 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-800|rel:32) dy(abs:32|rel:0)
; node # 101 D(50,-108)->(31,-108)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-608|rel:192) dy(abs:0|rel:-32)
; node # 102 D(42,-109)->(23,-110)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:32|rel:32)
; node # 103 D(40,-104)->(18,-104)
       fcb 2 ; drawmode 
       fcb -5,-2 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:0|rel:-32)
; node # 104 D(24,-112)->(5,-113)
       fcb 2 ; drawmode 
       fcb 8,-16 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:32|rel:32)
; node # 105 D(34,-120)->(17,-121)
       fcb 2 ; drawmode 
       fcb 8,10 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-544|rel:64) dy(abs:32|rel:0)
; node # 106 D(48,-115)->(35,-116)
       fcb 2 ; drawmode 
       fcb -5,14 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-416|rel:128) dy(abs:32|rel:0)
; node # 107 D(44,-114)->(30,-114)
       fcb 2 ; drawmode 
       fcb -1,-4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-448|rel:-32) dy(abs:0|rel:-32)
; node # 108 D(51,-117)->(51,-117)
       fcb 2 ; drawmode 
       fcb 3,7 ; starx/y relative to previous node
       fdb 0,448 ; dx/dy. dx(abs:0|rel:448) dy(abs:0|rel:0)
; node # 109 D(78,-102)->(78,-102)
       fcb 2 ; drawmode 
       fcb -15,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 110 D(98,-82)->(98,-82)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 111 D(115,-56)->(115,-56)
       fcb 2 ; drawmode 
       fcb -26,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 112 D(122,-39)->(122,-39)
       fcb 2 ; drawmode 
       fcb -17,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 113 D(125,-31)->(127,-2)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb -928,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-928|rel:-928)
; node # 114 D(122,-34)->(119,-34)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb 928,-160 ; dx/dy. dx(abs:-96|rel:-160) dy(abs:0|rel:928)
; node # 115 D(122,-34)->(116,-32)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:-64|rel:-64)
; node # 116 D(121,-36)->(114,-36)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-224|rel:-32) dy(abs:0|rel:64)
; node # 117 D(120,-37)->(112,-38)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-256|rel:-32) dy(abs:32|rel:32)
; node # 118 D(120,-37)->(101,-41)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 96,-352 ; dx/dy. dx(abs:-608|rel:-352) dy(abs:128|rel:96)
; node # 119 D(112,-46)->(94,-51)
       fcb 2 ; drawmode 
       fcb 9,-8 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-576|rel:32) dy(abs:160|rel:32)
; node # 120 D(110,-44)->(89,-49)
       fcb 2 ; drawmode 
       fcb -2,-2 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-672|rel:-96) dy(abs:160|rel:0)
; node # 121 D(118,-33)->(101,-34)
       fcb 2 ; drawmode 
       fcb -11,8 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-544|rel:128) dy(abs:32|rel:-128)
; node # 122 D(121,-29)->(107,-34)
       fcb 2 ; drawmode 
       fcb -4,3 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:-448|rel:96) dy(abs:160|rel:128)
; node # 123 D(123,-26)->(112,-30)
       fcb 2 ; drawmode 
       fcb -3,2 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-352|rel:96) dy(abs:128|rel:-32)
       fcb  1  ; end of anim
; Animation 22
weltframe22:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-68,-108)->(-68,-108)
       fcb 0 ; drawmode 
       fcb 108,-68 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-88,-93)->(-88,-93)
       fcb 2 ; drawmode 
       fcb -15,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-98,-82)->(-98,-82)
       fcb 2 ; drawmode 
       fcb -11,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,-65)->(-100,-80)
       fcb 2 ; drawmode 
       fcb -17,-12 ; starx/y relative to previous node
       fdb 480,320 ; dx/dy. dx(abs:320|rel:320) dy(abs:480|rel:480)
; node # 4 D(-120,-45)->(-102,-77)
       fcb 2 ; drawmode 
       fcb -20,-10 ; starx/y relative to previous node
       fdb 544,256 ; dx/dy. dx(abs:576|rel:256) dy(abs:1024|rel:544)
; node # 5 D(-124,-29)->(-104,-74)
       fcb 2 ; drawmode 
       fcb -16,-4 ; starx/y relative to previous node
       fdb 416,64 ; dx/dy. dx(abs:640|rel:64) dy(abs:1440|rel:416)
; node # 6 M(-127,-1)->(-128,3)
       fcb 0 ; drawmode 
       fcb -28,-3 ; starx/y relative to previous node
       fdb -1568,-672 ; dx/dy. dx(abs:-32|rel:-672) dy(abs:-128|rel:-1568)
; node # 7 D(-120,12)->(-128,12)
       fcb 2 ; drawmode 
       fcb -13,7 ; starx/y relative to previous node
       fdb 128,-224 ; dx/dy. dx(abs:-256|rel:-224) dy(abs:0|rel:128)
; node # 8 D(-115,14)->(-126,15)
       fcb 2 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-352|rel:-96) dy(abs:-32|rel:-32)
; node # 9 D(-112,29)->(-123,27)
       fcb 2 ; drawmode 
       fcb -15,3 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:64|rel:96)
; node # 10 D(-94,37)->(-118,32)
       fcb 2 ; drawmode 
       fcb -8,18 ; starx/y relative to previous node
       fdb 96,-416 ; dx/dy. dx(abs:-768|rel:-416) dy(abs:160|rel:96)
; node # 11 D(-83,45)->(-105,44)
       fcb 2 ; drawmode 
       fcb -8,11 ; starx/y relative to previous node
       fdb -128,64 ; dx/dy. dx(abs:-704|rel:64) dy(abs:32|rel:-128)
; node # 12 D(-86,60)->(-103,60)
       fcb 2 ; drawmode 
       fcb -15,-3 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-544|rel:160) dy(abs:0|rel:-32)
; node # 13 D(-78,80)->(-93,79)
       fcb 2 ; drawmode 
       fcb -20,8 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:-480|rel:64) dy(abs:32|rel:32)
; node # 14 D(-82,86)->(-95,82)
       fcb 2 ; drawmode 
       fcb -6,-4 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:-416|rel:64) dy(abs:128|rel:96)
; node # 15 D(-72,101)->(-81,100)
       fcb 2 ; drawmode 
       fcb -15,10 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:-288|rel:128) dy(abs:32|rel:-96)
; node # 16 D(-63,111)->(-75,104)
       fcb 2 ; drawmode 
       fcb -10,9 ; starx/y relative to previous node
       fdb 192,-96 ; dx/dy. dx(abs:-384|rel:-96) dy(abs:224|rel:192)
; node # 17 D(-59,114)->(-75,104)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb 96,-128 ; dx/dy. dx(abs:-512|rel:-128) dy(abs:320|rel:96)
; node # 18 D(-85,97)->(-90,93)
       fcb 2 ; drawmode 
       fcb 17,-26 ; starx/y relative to previous node
       fdb -192,352 ; dx/dy. dx(abs:-160|rel:352) dy(abs:128|rel:-192)
; node # 19 D(-101,79)->(-101,79)
       fcb 2 ; drawmode 
       fcb 18,-16 ; starx/y relative to previous node
       fdb -128,160 ; dx/dy. dx(abs:0|rel:160) dy(abs:0|rel:-128)
; node # 20 D(-110,64)->(-110,64)
       fcb 2 ; drawmode 
       fcb 15,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-119,49)->(-119,49)
       fcb 2 ; drawmode 
       fcb 15,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-124,32)->(-124,32)
       fcb 2 ; drawmode 
       fcb 17,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-127,17)->(-127,17)
       fcb 2 ; drawmode 
       fcb 15,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-128,-1)->(-128,2)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-96|rel:-96)
; node # 25 M(-124,-29)->(-104,-74)
       fcb 0 ; drawmode 
       fcb 28,4 ; starx/y relative to previous node
       fdb 1536,640 ; dx/dy. dx(abs:640|rel:640) dy(abs:1440|rel:1536)
; node # 26 D(-120,-45)->(-102,-77)
       fcb 2 ; drawmode 
       fcb 16,4 ; starx/y relative to previous node
       fdb -416,-64 ; dx/dy. dx(abs:576|rel:-64) dy(abs:1024|rel:-416)
; node # 27 D(-110,-64)->(-100,-80)
       fcb 2 ; drawmode 
       fcb 19,10 ; starx/y relative to previous node
       fdb -512,-256 ; dx/dy. dx(abs:320|rel:-256) dy(abs:512|rel:-512)
; node # 28 D(-99,-80)->(-98,-82)
       fcb 2 ; drawmode 
       fcb 16,11 ; starx/y relative to previous node
       fdb -448,-288 ; dx/dy. dx(abs:32|rel:-288) dy(abs:64|rel:-448)
; node # 29 D(-91,-81)->(-95,-86)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-128|rel:-160) dy(abs:160|rel:96)
; node # 30 D(-90,-87)->(-92,-88)
       fcb 2 ; drawmode 
       fcb 6,1 ; starx/y relative to previous node
       fdb -128,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:32|rel:-128)
; node # 31 D(-72,-96)->(-83,-98)
       fcb 2 ; drawmode 
       fcb 9,18 ; starx/y relative to previous node
       fdb 32,-288 ; dx/dy. dx(abs:-352|rel:-288) dy(abs:64|rel:32)
; node # 32 D(-70,-106)->(-72,-105)
       fcb 2 ; drawmode 
       fcb 10,2 ; starx/y relative to previous node
       fdb -96,288 ; dx/dy. dx(abs:-64|rel:288) dy(abs:-32|rel:-96)
; node # 33 M(-52,-17)->(-52,-17)
       fcb 0 ; drawmode 
       fcb -89,18 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:32)
; node # 34 M(62,-52)->(30,-52)
       fcb 0 ; drawmode 
       fcb 35,114 ; starx/y relative to previous node
       fdb 0,-1024 ; dx/dy. dx(abs:-1024|rel:-1024) dy(abs:0|rel:0)
; node # 35 D(40,-59)->(7,-58)
       fcb 2 ; drawmode 
       fcb 7,-22 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-32|rel:-32)
; node # 36 D(37,-52)->(0,-52)
       fcb 2 ; drawmode 
       fcb -7,-3 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-1184|rel:-128) dy(abs:0|rel:32)
; node # 37 D(16,-61)->(-16,-61)
       fcb 2 ; drawmode 
       fcb 9,-21 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-1024|rel:160) dy(abs:0|rel:0)
; node # 38 D(16,-68)->(-17,-68)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:0|rel:0)
; node # 39 D(-19,-65)->(-50,-64)
       fcb 2 ; drawmode 
       fcb -3,-35 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:-32|rel:-32)
; node # 40 D(-33,-52)->(-72,-42)
       fcb 2 ; drawmode 
       fcb -13,-14 ; starx/y relative to previous node
       fdb -288,-256 ; dx/dy. dx(abs:-1248|rel:-256) dy(abs:-320|rel:-288)
; node # 41 D(-50,-28)->(-80,-30)
       fcb 2 ; drawmode 
       fcb -24,-17 ; starx/y relative to previous node
       fdb 384,288 ; dx/dy. dx(abs:-960|rel:288) dy(abs:64|rel:384)
; node # 42 D(-50,-4)->(-83,-5)
       fcb 2 ; drawmode 
       fcb -24,0 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:32|rel:-32)
; node # 43 D(-26,17)->(-62,16)
       fcb 2 ; drawmode 
       fcb -21,24 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:32|rel:0)
; node # 44 D(2,12)->(-36,12)
       fcb 2 ; drawmode 
       fcb 5,28 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1216|rel:-64) dy(abs:0|rel:-32)
; node # 45 D(13,17)->(-23,19)
       fcb 2 ; drawmode 
       fcb -5,11 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-1152|rel:64) dy(abs:-64|rel:-64)
; node # 46 D(15,33)->(-22,33)
       fcb 2 ; drawmode 
       fcb -16,2 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-1184|rel:-32) dy(abs:0|rel:64)
; node # 47 D(24,58)->(-11,53)
       fcb 2 ; drawmode 
       fcb -25,9 ; starx/y relative to previous node
       fdb 160,64 ; dx/dy. dx(abs:-1120|rel:64) dy(abs:160|rel:160)
; node # 48 D(18,71)->(-13,70)
       fcb 2 ; drawmode 
       fcb -13,-6 ; starx/y relative to previous node
       fdb -128,128 ; dx/dy. dx(abs:-992|rel:128) dy(abs:32|rel:-128)
; node # 49 D(25,106)->(4,106)
       fcb 2 ; drawmode 
       fcb -35,7 ; starx/y relative to previous node
       fdb -32,320 ; dx/dy. dx(abs:-672|rel:320) dy(abs:0|rel:-32)
; node # 50 D(39,103)->(18,103)
       fcb 2 ; drawmode 
       fcb 3,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-672|rel:0) dy(abs:0|rel:0)
; node # 51 D(50,95)->(27,91)
       fcb 2 ; drawmode 
       fcb 8,11 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:-736|rel:-64) dy(abs:128|rel:128)
; node # 52 D(59,86)->(35,86)
       fcb 2 ; drawmode 
       fcb 9,9 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:0|rel:-128)
; node # 53 D(64,76)->(36,78)
       fcb 2 ; drawmode 
       fcb 10,5 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-896|rel:-128) dy(abs:-64|rel:-64)
; node # 54 D(80,62)->(52,66)
       fcb 2 ; drawmode 
       fcb 14,16 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-896|rel:0) dy(abs:-128|rel:-64)
; node # 55 D(81,41)->(51,44)
       fcb 2 ; drawmode 
       fcb 21,1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-960|rel:-64) dy(abs:-96|rel:32)
; node # 56 D(100,18)->(73,20)
       fcb 2 ; drawmode 
       fcb 23,19 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-864|rel:96) dy(abs:-64|rel:32)
; node # 57 D(105,-1)->(80,-1)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-800|rel:64) dy(abs:0|rel:64)
; node # 58 D(96,0)->(69,2)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-864|rel:-64) dy(abs:-64|rel:-64)
; node # 59 D(62,-52)->(30,-52)
       fcb 2 ; drawmode 
       fcb 52,-34 ; starx/y relative to previous node
       fdb 64,-160 ; dx/dy. dx(abs:-1024|rel:-160) dy(abs:0|rel:64)
; node # 60 M(91,60)->(67,61)
       fcb 0 ; drawmode 
       fcb -112,29 ; starx/y relative to previous node
       fdb -32,256 ; dx/dy. dx(abs:-768|rel:256) dy(abs:-32|rel:-32)
; node # 61 D(74,81)->(53,77)
       fcb 2 ; drawmode 
       fcb -21,-17 ; starx/y relative to previous node
       fdb 160,96 ; dx/dy. dx(abs:-672|rel:96) dy(abs:128|rel:160)
; node # 62 D(72,89)->(51,90)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb -160,0 ; dx/dy. dx(abs:-672|rel:0) dy(abs:-32|rel:-160)
; node # 63 D(91,60)->(67,61)
       fcb 2 ; drawmode 
       fcb 29,19 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-768|rel:-96) dy(abs:-32|rel:0)
; node # 64 M(112,-30)->(93,-29)
       fcb 0 ; drawmode 
       fcb 90,21 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:-608|rel:160) dy(abs:-32|rel:0)
; node # 65 D(111,-19)->(89,-19)
       fcb 2 ; drawmode 
       fcb -11,-1 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:0|rel:32)
; node # 66 D(96,-6)->(66,-5)
       fcb 2 ; drawmode 
       fcb -13,-15 ; starx/y relative to previous node
       fdb -32,-256 ; dx/dy. dx(abs:-960|rel:-256) dy(abs:-32|rel:-32)
; node # 67 D(72,-47)->(39,-49)
       fcb 2 ; drawmode 
       fcb 41,-24 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:64|rel:96)
; node # 68 D(65,-66)->(38,-67)
       fcb 2 ; drawmode 
       fcb 19,-7 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-864|rel:192) dy(abs:32|rel:-32)
; node # 69 D(53,-66)->(23,-67)
       fcb 2 ; drawmode 
       fcb 0,-12 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:32|rel:0)
; node # 70 D(48,-73)->(18,-74)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:32|rel:0)
; node # 71 D(69,-77)->(43,-79)
       fcb 2 ; drawmode 
       fcb 4,21 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:-832|rel:128) dy(abs:64|rel:32)
; node # 72 D(58,-89)->(34,-91)
       fcb 2 ; drawmode 
       fcb 12,-11 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-768|rel:64) dy(abs:64|rel:0)
; node # 73 D(47,-86)->(18,-85)
       fcb 2 ; drawmode 
       fcb -3,-11 ; starx/y relative to previous node
       fdb -96,-160 ; dx/dy. dx(abs:-928|rel:-160) dy(abs:-32|rel:-96)
; node # 74 D(46,-77)->(16,-79)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:64|rel:96)
; node # 75 D(40,-76)->(10,-75)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:-32|rel:-96)
; node # 76 D(42,-67)->(10,-67)
       fcb 2 ; drawmode 
       fcb -9,2 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-1024|rel:-64) dy(abs:0|rel:32)
; node # 77 D(32,-78)->(2,-78)
       fcb 2 ; drawmode 
       fcb 11,-10 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-960|rel:64) dy(abs:0|rel:0)
; node # 78 D(19,-88)->(-8,-87)
       fcb 2 ; drawmode 
       fcb 10,-13 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-864|rel:96) dy(abs:-32|rel:-32)
; node # 79 D(17,-86)->(-12,-86)
       fcb 2 ; drawmode 
       fcb -2,-2 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:0|rel:32)
; node # 80 D(28,-77)->(-1,-75)
       fcb 2 ; drawmode 
       fcb -9,11 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:-64|rel:-64)
; node # 81 D(28,-70)->(-4,-71)
       fcb 2 ; drawmode 
       fcb -7,0 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:32|rel:96)
; node # 82 D(13,-83)->(-16,-84)
       fcb 2 ; drawmode 
       fcb 13,-15 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-928|rel:96) dy(abs:32|rel:0)
; node # 83 D(0,-79)->(-29,-82)
       fcb 2 ; drawmode 
       fcb -4,-13 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:96|rel:64)
; node # 84 D(-6,-75)->(-35,-76)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:32|rel:-64)
; node # 85 D(-6,-70)->(-38,-70)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:0|rel:-32)
; node # 86 D(-24,-69)->(-55,-69)
       fcb 2 ; drawmode 
       fcb -1,-18 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:0|rel:0)
; node # 87 D(-21,-83)->(-48,-82)
       fcb 2 ; drawmode 
       fcb 14,3 ; starx/y relative to previous node
       fdb -32,128 ; dx/dy. dx(abs:-864|rel:128) dy(abs:-32|rel:-32)
; node # 88 D(-7,-82)->(-37,-82)
       fcb 2 ; drawmode 
       fcb -1,14 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:0|rel:32)
; node # 89 D(-8,-93)->(-36,-91)
       fcb 2 ; drawmode 
       fcb 11,-1 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-896|rel:64) dy(abs:-64|rel:-64)
; node # 90 D(7,-101)->(-15,-101)
       fcb 2 ; drawmode 
       fcb 8,15 ; starx/y relative to previous node
       fdb 64,192 ; dx/dy. dx(abs:-704|rel:192) dy(abs:0|rel:64)
; node # 91 D(21,-102)->(1,-102)
       fcb 2 ; drawmode 
       fcb 1,14 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-640|rel:64) dy(abs:0|rel:0)
; node # 92 D(31,-108)->(12,-109)
       fcb 2 ; drawmode 
       fcb 6,10 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-608|rel:32) dy(abs:32|rel:32)
; node # 93 D(23,-110)->(1,-110)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-704|rel:-96) dy(abs:0|rel:-32)
; node # 94 D(18,-104)->(-6,-103)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-768|rel:-64) dy(abs:-32|rel:-32)
; node # 95 D(5,-113)->(-16,-112)
       fcb 2 ; drawmode 
       fcb 9,-13 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-672|rel:96) dy(abs:-32|rel:0)
; node # 96 D(17,-121)->(4,-122)
       fcb 2 ; drawmode 
       fcb 8,12 ; starx/y relative to previous node
       fdb 64,256 ; dx/dy. dx(abs:-416|rel:256) dy(abs:32|rel:64)
; node # 97 D(35,-116)->(19,-118)
       fcb 2 ; drawmode 
       fcb -5,18 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-512|rel:-96) dy(abs:64|rel:32)
; node # 98 D(30,-114)->(13,-116)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-544|rel:-32) dy(abs:64|rel:0)
; node # 99 D(51,-117)->(51,-117)
       fcb 2 ; drawmode 
       fcb 3,21 ; starx/y relative to previous node
       fdb -64,544 ; dx/dy. dx(abs:0|rel:544) dy(abs:0|rel:-64)
; node # 100 D(78,-102)->(78,-102)
       fcb 2 ; drawmode 
       fcb -15,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 101 D(98,-82)->(98,-82)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 102 D(115,-56)->(115,-56)
       fcb 2 ; drawmode 
       fcb -26,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 103 D(122,-39)->(122,-39)
       fcb 2 ; drawmode 
       fcb -17,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 104 D(127,-16)->(127,-16)
       fcb 2 ; drawmode 
       fcb -23,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 105 D(127,-20)->(124,-19)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:-32|rel:-32)
; node # 106 D(126,-19)->(121,-19)
       fcb 2 ; drawmode 
       fcb -1,-1 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:0|rel:32)
; node # 107 D(126,-18)->(121,-18)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-160|rel:0) dy(abs:0|rel:0)
; node # 108 D(126,-5)->(121,-5)
       fcb 2 ; drawmode 
       fcb -13,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-160|rel:0) dy(abs:0|rel:0)
; node # 109 D(126,1)->(121,1)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-160|rel:0) dy(abs:0|rel:0)
; node # 110 D(126,6)->(120,6)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-192|rel:-32) dy(abs:0|rel:0)
; node # 111 D(123,-24)->(112,-23)
       fcb 2 ; drawmode 
       fcb 30,-3 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:-352|rel:-160) dy(abs:-32|rel:-32)
; node # 112 D(119,-34)->(112,-28)
       fcb 2 ; drawmode 
       fcb 10,-4 ; starx/y relative to previous node
       fdb -160,128 ; dx/dy. dx(abs:-224|rel:128) dy(abs:-192|rel:-160)
; node # 113 D(116,-32)->(107,-26)
       fcb 2 ; drawmode 
       fcb -2,-3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-288|rel:-64) dy(abs:-192|rel:0)
; node # 114 D(112,-38)->(100,-37)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 160,-96 ; dx/dy. dx(abs:-384|rel:-96) dy(abs:-32|rel:160)
; node # 115 D(106,-40)->(90,-37)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:-512|rel:-128) dy(abs:-96|rel:-64)
; node # 116 D(101,-41)->(79,-43)
       fcb 2 ; drawmode 
       fcb 1,-5 ; starx/y relative to previous node
       fdb 160,-192 ; dx/dy. dx(abs:-704|rel:-192) dy(abs:64|rel:160)
; node # 117 D(94,-51)->(71,-51)
       fcb 2 ; drawmode 
       fcb 10,-7 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-736|rel:-32) dy(abs:0|rel:-64)
; node # 118 D(89,-49)->(66,-48)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:-32|rel:-32)
; node # 119 D(101,-34)->(80,-35)
       fcb 2 ; drawmode 
       fcb -15,12 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-672|rel:64) dy(abs:32|rel:64)
; node # 120 D(107,-34)->(85,-36)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:64|rel:32)
; node # 121 D(112,-30)->(93,-30)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-608|rel:96) dy(abs:0|rel:-64)
       fcb  1  ; end of anim
; Animation 23
weltframe23:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-128,12)->(-128,12)
       fcb 0 ; drawmode 
       fcb -12,-128 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-123,27)->(-126,25)
       fcb 2 ; drawmode 
       fcb -15,5 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:64|rel:64)
; node # 2 D(-118,32)->(-124,31)
       fcb 2 ; drawmode 
       fcb -5,5 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:32|rel:-32)
; node # 3 D(-105,44)->(-121,43)
       fcb 2 ; drawmode 
       fcb -12,13 ; starx/y relative to previous node
       fdb 0,-320 ; dx/dy. dx(abs:-512|rel:-320) dy(abs:32|rel:0)
; node # 4 D(-103,60)->(-115,56)
       fcb 2 ; drawmode 
       fcb -16,2 ; starx/y relative to previous node
       fdb 96,128 ; dx/dy. dx(abs:-384|rel:128) dy(abs:128|rel:96)
; node # 5 D(-93,79)->(-108,69)
       fcb 2 ; drawmode 
       fcb -19,10 ; starx/y relative to previous node
       fdb 192,-96 ; dx/dy. dx(abs:-480|rel:-96) dy(abs:320|rel:192)
; node # 6 D(-95,82)->(-105,73)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb -32,160 ; dx/dy. dx(abs:-320|rel:160) dy(abs:288|rel:-32)
; node # 7 D(-81,100)->(-103,76)
       fcb 2 ; drawmode 
       fcb -18,14 ; starx/y relative to previous node
       fdb 480,-384 ; dx/dy. dx(abs:-704|rel:-384) dy(abs:768|rel:480)
; node # 8 D(-75,104)->(-102,77)
       fcb 2 ; drawmode 
       fcb -4,6 ; starx/y relative to previous node
       fdb 96,-160 ; dx/dy. dx(abs:-864|rel:-160) dy(abs:864|rel:96)
; node # 9 D(-75,104)->(-102,78)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-864|rel:0) dy(abs:832|rel:-32)
; node # 10 D(-90,93)->(-104,75)
       fcb 2 ; drawmode 
       fcb 11,-15 ; starx/y relative to previous node
       fdb -256,416 ; dx/dy. dx(abs:-448|rel:416) dy(abs:576|rel:-256)
; node # 11 D(-101,79)->(-109,67)
       fcb 2 ; drawmode 
       fcb 14,-11 ; starx/y relative to previous node
       fdb -192,192 ; dx/dy. dx(abs:-256|rel:192) dy(abs:384|rel:-192)
; node # 12 D(-110,64)->(-113,61)
       fcb 2 ; drawmode 
       fcb 15,-9 ; starx/y relative to previous node
       fdb -288,160 ; dx/dy. dx(abs:-96|rel:160) dy(abs:96|rel:-288)
; node # 13 D(-119,49)->(-119,48)
       fcb 2 ; drawmode 
       fcb 15,-9 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:32|rel:-64)
; node # 14 D(-124,32)->(-124,32)
       fcb 2 ; drawmode 
       fcb 17,-5 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-32)
; node # 15 D(-128,12)->(-127,17)
       fcb 2 ; drawmode 
       fcb 20,-4 ; starx/y relative to previous node
       fdb -160,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-160|rel:-160)
; node # 16 M(-52,-17)->(-60,-9)
       fcb 0 ; drawmode 
       fcb 29,76 ; starx/y relative to previous node
       fdb -96,-288 ; dx/dy. dx(abs:-256|rel:-288) dy(abs:-256|rel:-96)
; node # 17 M(30,-52)->(-1,-54)
       fcb 0 ; drawmode 
       fcb 35,82 ; starx/y relative to previous node
       fdb 320,-736 ; dx/dy. dx(abs:-992|rel:-736) dy(abs:64|rel:320)
; node # 18 D(7,-58)->(-27,-58)
       fcb 2 ; drawmode 
       fcb 6,-23 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-1088|rel:-96) dy(abs:0|rel:-64)
; node # 19 D(0,-52)->(-31,-52)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-992|rel:96) dy(abs:0|rel:0)
; node # 20 D(-16,-61)->(-49,-60)
       fcb 2 ; drawmode 
       fcb 9,-16 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-1056|rel:-64) dy(abs:-32|rel:-32)
; node # 21 D(-17,-68)->(-49,-68)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:0|rel:32)
; node # 22 D(-50,-64)->(-76,-63)
       fcb 2 ; drawmode 
       fcb -4,-33 ; starx/y relative to previous node
       fdb -32,192 ; dx/dy. dx(abs:-832|rel:192) dy(abs:-32|rel:-32)
; node # 23 D(-72,-42)->(-95,-43)
       fcb 2 ; drawmode 
       fcb -22,-22 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:32|rel:64)
; node # 24 D(-80,-30)->(-103,-28)
       fcb 2 ; drawmode 
       fcb -12,-8 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:-64|rel:-96)
; node # 25 D(-83,-5)->(-106,-5)
       fcb 2 ; drawmode 
       fcb -25,-3 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:0|rel:64)
; node # 26 D(-62,16)->(-93,16)
       fcb 2 ; drawmode 
       fcb -21,21 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-992|rel:-256) dy(abs:0|rel:0)
; node # 27 D(-36,12)->(-73,11)
       fcb 2 ; drawmode 
       fcb 4,26 ; starx/y relative to previous node
       fdb 32,-192 ; dx/dy. dx(abs:-1184|rel:-192) dy(abs:32|rel:32)
; node # 28 D(-23,19)->(-57,19)
       fcb 2 ; drawmode 
       fcb -7,13 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1088|rel:96) dy(abs:0|rel:-32)
; node # 29 D(-22,33)->(-56,33)
       fcb 2 ; drawmode 
       fcb -14,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1088|rel:0) dy(abs:0|rel:0)
; node # 30 D(-11,53)->(-46,45)
       fcb 2 ; drawmode 
       fcb -20,11 ; starx/y relative to previous node
       fdb 256,-32 ; dx/dy. dx(abs:-1120|rel:-32) dy(abs:256|rel:256)
; node # 31 D(-13,70)->(-44,69)
       fcb 2 ; drawmode 
       fcb -17,-2 ; starx/y relative to previous node
       fdb -224,128 ; dx/dy. dx(abs:-992|rel:128) dy(abs:32|rel:-224)
; node # 32 D(4,106)->(-20,106)
       fcb 2 ; drawmode 
       fcb -36,17 ; starx/y relative to previous node
       fdb -32,224 ; dx/dy. dx(abs:-768|rel:224) dy(abs:0|rel:-32)
; node # 33 D(18,103)->(-8,103)
       fcb 2 ; drawmode 
       fcb 3,14 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:0|rel:0)
; node # 34 D(27,91)->(0,91)
       fcb 2 ; drawmode 
       fcb 12,9 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-864|rel:-32) dy(abs:0|rel:0)
; node # 35 D(35,86)->(6,86)
       fcb 2 ; drawmode 
       fcb 5,8 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:0|rel:0)
; node # 36 D(36,78)->(4,79)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:-32|rel:-32)
; node # 37 D(52,66)->(19,67)
       fcb 2 ; drawmode 
       fcb 12,16 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:-32|rel:0)
; node # 38 D(51,44)->(17,40)
       fcb 2 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb 160,-32 ; dx/dy. dx(abs:-1088|rel:-32) dy(abs:128|rel:160)
; node # 39 D(73,20)->(40,18)
       fcb 2 ; drawmode 
       fcb 24,22 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-1056|rel:32) dy(abs:64|rel:-64)
; node # 40 D(80,-1)->(47,-1)
       fcb 2 ; drawmode 
       fcb 21,7 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-1056|rel:0) dy(abs:0|rel:-64)
; node # 41 D(69,2)->(33,1)
       fcb 2 ; drawmode 
       fcb -3,-11 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-1152|rel:-96) dy(abs:32|rel:32)
; node # 42 D(60,-9)->(18,-13)
       fcb 2 ; drawmode 
       fcb 11,-9 ; starx/y relative to previous node
       fdb 96,-192 ; dx/dy. dx(abs:-1344|rel:-192) dy(abs:128|rel:96)
; node # 43 D(30,-52)->(-1,-54)
       fcb 2 ; drawmode 
       fcb 43,-30 ; starx/y relative to previous node
       fdb -64,352 ; dx/dy. dx(abs:-992|rel:352) dy(abs:64|rel:-64)
; node # 44 M(67,61)->(38,61)
       fcb 0 ; drawmode 
       fcb -113,37 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-928|rel:64) dy(abs:0|rel:-64)
; node # 45 D(57,72)->(27,71)
       fcb 2 ; drawmode 
       fcb -11,-10 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:32|rel:32)
; node # 46 D(53,77)->(23,81)
       fcb 2 ; drawmode 
       fcb -5,-4 ; starx/y relative to previous node
       fdb -160,0 ; dx/dy. dx(abs:-960|rel:0) dy(abs:-128|rel:-160)
; node # 47 D(51,90)->(24,90)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:-864|rel:96) dy(abs:0|rel:128)
; node # 48 D(67,61)->(38,61)
       fcb 2 ; drawmode 
       fcb 29,16 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-928|rel:-64) dy(abs:0|rel:0)
; node # 49 M(93,-29)->(64,-30)
       fcb 0 ; drawmode 
       fcb 90,26 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:32|rel:32)
; node # 50 D(89,-19)->(57,-18)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:-32|rel:-64)
; node # 51 D(66,-5)->(31,-7)
       fcb 2 ; drawmode 
       fcb -14,-23 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1120|rel:-96) dy(abs:64|rel:96)
; node # 52 D(39,-49)->(4,-51)
       fcb 2 ; drawmode 
       fcb 44,-27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-1120|rel:0) dy(abs:64|rel:0)
; node # 53 D(38,-67)->(6,-68)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:-1024|rel:96) dy(abs:32|rel:-32)
; node # 54 D(23,-67)->(-11,-68)
       fcb 2 ; drawmode 
       fcb 0,-15 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-1088|rel:-64) dy(abs:32|rel:0)
; node # 55 D(18,-74)->(-14,-74)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-1024|rel:64) dy(abs:0|rel:-32)
; node # 56 D(43,-79)->(14,-79)
       fcb 2 ; drawmode 
       fcb 5,25 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-928|rel:96) dy(abs:0|rel:0)
; node # 57 D(34,-91)->(7,-91)
       fcb 2 ; drawmode 
       fcb 12,-9 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-864|rel:64) dy(abs:0|rel:0)
; node # 58 D(18,-85)->(-12,-85)
       fcb 2 ; drawmode 
       fcb -6,-16 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-960|rel:-96) dy(abs:0|rel:0)
; node # 59 D(16,-79)->(-13,-77)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:-64|rel:-64)
; node # 60 D(10,-75)->(-22,-76)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-1024|rel:-96) dy(abs:32|rel:96)
; node # 61 D(10,-67)->(-23,-69)
       fcb 2 ; drawmode 
       fcb -8,0 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-1056|rel:-32) dy(abs:64|rel:32)
; node # 62 D(2,-78)->(-29,-79)
       fcb 2 ; drawmode 
       fcb 11,-8 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:32|rel:-32)
; node # 63 D(-8,-87)->(-38,-87)
       fcb 2 ; drawmode 
       fcb 9,-10 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:0|rel:-32)
; node # 64 D(-12,-86)->(-41,-85)
       fcb 2 ; drawmode 
       fcb -1,-4 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:-32|rel:-32)
; node # 65 D(-1,-75)->(-34,-77)
       fcb 2 ; drawmode 
       fcb -11,11 ; starx/y relative to previous node
       fdb 96,-128 ; dx/dy. dx(abs:-1056|rel:-128) dy(abs:64|rel:96)
; node # 66 D(-4,-71)->(-35,-71)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:-992|rel:64) dy(abs:0|rel:-64)
; node # 67 D(-16,-84)->(-45,-84)
       fcb 2 ; drawmode 
       fcb 13,-12 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-928|rel:64) dy(abs:0|rel:0)
; node # 68 D(-29,-82)->(-58,-78)
       fcb 2 ; drawmode 
       fcb -2,-13 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-928|rel:0) dy(abs:-128|rel:-128)
; node # 69 D(-35,-76)->(-63,-76)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 128,32 ; dx/dy. dx(abs:-896|rel:32) dy(abs:0|rel:128)
; node # 70 D(-38,-70)->(-68,-68)
       fcb 2 ; drawmode 
       fcb -6,-3 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-960|rel:-64) dy(abs:-64|rel:-64)
; node # 71 D(-55,-69)->(-80,-68)
       fcb 2 ; drawmode 
       fcb -1,-17 ; starx/y relative to previous node
       fdb 32,160 ; dx/dy. dx(abs:-800|rel:160) dy(abs:-32|rel:32)
; node # 72 D(-48,-82)->(-72,-80)
       fcb 2 ; drawmode 
       fcb 13,7 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-768|rel:32) dy(abs:-64|rel:-32)
; node # 73 D(-37,-82)->(-63,-81)
       fcb 2 ; drawmode 
       fcb 0,11 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-832|rel:-64) dy(abs:-32|rel:32)
; node # 74 D(-36,-91)->(-59,-91)
       fcb 2 ; drawmode 
       fcb 9,1 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-736|rel:96) dy(abs:0|rel:32)
; node # 75 D(-15,-101)->(-39,-101)
       fcb 2 ; drawmode 
       fcb 10,21 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-768|rel:-32) dy(abs:0|rel:0)
; node # 76 D(1,-102)->(-22,-102)
       fcb 2 ; drawmode 
       fcb 1,16 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-736|rel:32) dy(abs:0|rel:0)
; node # 77 D(12,-109)->(-11,-110)
       fcb 2 ; drawmode 
       fcb 7,11 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-736|rel:0) dy(abs:32|rel:32)
; node # 78 D(1,-110)->(-19,-111)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 0,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:32|rel:0)
; node # 79 D(-6,-103)->(-29,-104)
       fcb 2 ; drawmode 
       fcb -7,-7 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-736|rel:-96) dy(abs:32|rel:0)
; node # 80 D(-16,-112)->(-36,-111)
       fcb 2 ; drawmode 
       fcb 9,-10 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:-640|rel:96) dy(abs:-32|rel:-64)
; node # 81 D(4,-122)->(-12,-121)
       fcb 2 ; drawmode 
       fcb 10,20 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-512|rel:128) dy(abs:-32|rel:0)
; node # 82 D(19,-118)->(0,-118)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-608|rel:-96) dy(abs:0|rel:32)
; node # 83 D(13,-116)->(-6,-117)
       fcb 2 ; drawmode 
       fcb -2,-6 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-608|rel:0) dy(abs:32|rel:32)
; node # 84 D(51,-117)->(50,-116)
       fcb 2 ; drawmode 
       fcb 1,38 ; starx/y relative to previous node
       fdb -64,576 ; dx/dy. dx(abs:-32|rel:576) dy(abs:-32|rel:-64)
; node # 85 D(78,-102)->(78,-102)
       fcb 2 ; drawmode 
       fcb -15,27 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:32)
; node # 86 D(98,-82)->(98,-82)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 D(107,-70)->(107,-70)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 88 D(115,-56)->(118,-49)
       fcb 2 ; drawmode 
       fcb -14,8 ; starx/y relative to previous node
       fdb -224,96 ; dx/dy. dx(abs:96|rel:96) dy(abs:-224|rel:-224)
; node # 89 D(122,-39)->(124,-31)
       fcb 2 ; drawmode 
       fcb -17,7 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:64|rel:-32) dy(abs:-256|rel:-32)
; node # 90 D(126,-16)->(127,-10)
       fcb 2 ; drawmode 
       fcb -23,4 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-192|rel:64)
; node # 91 D(127,-6)->(127,1)
       fcb 2 ; drawmode 
       fcb -10,1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-224|rel:-32)
; node # 92 D(127,-16)->(122,-15)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb 192,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:-32|rel:192)
; node # 93 D(127,-12)->(121,-12)
       fcb 2 ; drawmode 
       fcb -4,0 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-192|rel:-32) dy(abs:0|rel:32)
; node # 94 D(123,-20)->(113,-29)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb 288,-128 ; dx/dy. dx(abs:-320|rel:-128) dy(abs:288|rel:288)
; node # 95 D(121,-19)->(111,-23)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb -160,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:128|rel:-160)
; node # 96 D(121,-18)->(104,-12)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb -320,-224 ; dx/dy. dx(abs:-544|rel:-224) dy(abs:-192|rel:-320)
; node # 97 D(121,-5)->(105,1)
       fcb 2 ; drawmode 
       fcb -13,0 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-512|rel:32) dy(abs:-192|rel:0)
; node # 98 D(121,1)->(105,1)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 192,0 ; dx/dy. dx(abs:-512|rel:0) dy(abs:0|rel:192)
; node # 99 D(120,6)->(102,6)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-576|rel:-64) dy(abs:0|rel:0)
; node # 100 D(112,-23)->(90,-22)
       fcb 2 ; drawmode 
       fcb 29,-8 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-704|rel:-128) dy(abs:-32|rel:-32)
; node # 101 D(112,-28)->(91,-30)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-672|rel:32) dy(abs:64|rel:96)
; node # 102 D(107,-26)->(87,-26)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:-640|rel:32) dy(abs:0|rel:-64)
; node # 103 D(105,-31)->(84,-32)
       fcb 2 ; drawmode 
       fcb 5,-2 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-672|rel:-32) dy(abs:32|rel:32)
; node # 104 D(100,-37)->(78,-39)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-704|rel:-32) dy(abs:64|rel:32)
; node # 105 D(90,-37)->(65,-39)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-800|rel:-96) dy(abs:64|rel:0)
; node # 106 D(85,-40)->(56,-44)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-928|rel:-128) dy(abs:128|rel:64)
; node # 107 D(79,-43)->(49,-43)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-960|rel:-32) dy(abs:0|rel:-128)
; node # 108 D(71,-51)->(38,-53)
       fcb 2 ; drawmode 
       fcb 8,-8 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-1056|rel:-96) dy(abs:64|rel:64)
; node # 109 D(66,-48)->(34,-50)
       fcb 2 ; drawmode 
       fcb -3,-5 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-1024|rel:32) dy(abs:64|rel:0)
; node # 110 D(75,-39)->(43,-40)
       fcb 2 ; drawmode 
       fcb -9,9 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-1024|rel:0) dy(abs:32|rel:-32)
; node # 111 D(80,-35)->(49,-36)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:-992|rel:32) dy(abs:32|rel:0)
; node # 112 D(85,-36)->(55,-41)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 128,32 ; dx/dy. dx(abs:-960|rel:32) dy(abs:160|rel:128)
; node # 113 D(93,-30)->(64,-29)
       fcb 2 ; drawmode 
       fcb -6,8 ; starx/y relative to previous node
       fdb -192,32 ; dx/dy. dx(abs:-928|rel:32) dy(abs:-32|rel:-192)
       fcb  1  ; end of anim
