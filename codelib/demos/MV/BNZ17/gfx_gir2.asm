gfxgirl2framecount EQU 1 ; number of animations
; index table 
gfxgirl2frametab        fdb gfxgirl2frame0

; Animation 0
gfxgirl2frame0:
; node # 0 M(20,19)->(0,0)
       fcb 0 ; drawmode 
       fcb -19,20 ; position relative to previous node
; node # 1 DM(14,31)->(10,10)
       fcb -1 ; drawmode 
       fcb -12,-6 ; position relative to previous node
; node # 2 D(3,34)->(30,30)
       fcb 2 ; drawmode 
       fcb -3,-11 ; position relative to previous node
; node # 3 D(-2,31)->(50,50)
       fcb 2 ; drawmode 
       fcb 3,-5 ; position relative to previous node
; node # 4 D(-6,26)->(60,60)
       fcb 2 ; drawmode 
       fcb 5,-4 ; position relative to previous node
; node # 5 D(-9,18)->(70,70)
       fcb 2 ; drawmode 
       fcb 8,-3 ; position relative to previous node
; node # 6 D(-9,9)->(80,80)
       fcb 2 ; drawmode 
       fcb 9,0 ; position relative to previous node
; node # 7 D(-1,2)->(90,90)
       fcb 2 ; drawmode 
       fcb 7,8 ; position relative to previous node
; node # 8 D(6,-5)->(100,100)
       fcb 2 ; drawmode 
       fcb 7,7 ; position relative to previous node
; node # 9 D(11,-12)->(120,120)
       fcb 2 ; drawmode 
       fcb 7,5 ; position relative to previous node
; node # 10 DM(16,-24)->(-116,-116)
       fcb -1 ; drawmode 
       fcb 12,5 ; position relative to previous node
; node # 11 M(39,16)->(-106,-106)
       fcb 0 ; drawmode 
       fcb -40,23 ; position relative to previous node
; node # 12 D(42,15)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 1,3 ; position relative to previous node
; node # 13 D(45,17)->(-86,-86)
       fcb 2 ; drawmode 
       fcb -2,3 ; position relative to previous node
; node # 14 D(45,21)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 15 D(43,23)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -2,-2 ; position relative to previous node
; node # 16 D(39,22)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 1,-4 ; position relative to previous node
; node # 17 D(38,20)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 2,-1 ; position relative to previous node
; node # 18 D(39,16)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 4,1 ; position relative to previous node
; node # 19 M(29,0)->(-96,-96)
       fcb 0 ; drawmode 
       fcb 16,-10 ; position relative to previous node
; node # 20 DM(23,12)->(-96,-96)
       fcb -1 ; drawmode 
       fcb -12,-6 ; position relative to previous node
; node # 21 D(22,20)->(-86,-86)
       fcb 2 ; drawmode 
       fcb -8,-1 ; position relative to previous node
; node # 22 D(25,27)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -7,3 ; position relative to previous node
; node # 23 D(29,32)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -5,4 ; position relative to previous node
; node # 24 D(34,36)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -4,5 ; position relative to previous node
; node # 25 D(40,38)->(-56,-56)
       fcb 2 ; drawmode 
       fcb -2,6 ; position relative to previous node
; node # 26 D(46,38)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 27 D(52,36)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 2,6 ; position relative to previous node
; node # 28 D(57,32)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 29 D(63,20)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 12,6 ; position relative to previous node
; node # 30 M(-4,106)->(-96,-96)
       fcb 0 ; drawmode 
       fcb -86,-67 ; position relative to previous node
; node # 31 D(3,75)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 31,7 ; position relative to previous node
; node # 32 M(3,46)->(4,4)
       fcb 0 ; drawmode 
       fcb 29,0 ; position relative to previous node
; node # 33 D(3,34)->(14,14)
       fcb 2 ; drawmode 
       fcb 12,0 ; position relative to previous node
; node # 34 D(-1,43)->(34,34)
       fcb 2 ; drawmode 
       fcb -9,-4 ; position relative to previous node
; node # 35 D(40,78)->(44,44)
       fcb 2 ; drawmode 
       fcb -35,41 ; position relative to previous node
; node # 36 D(44,81)->(74,74)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 37 M(40,109)->(-122,-122)
       fcb 0 ; drawmode 
       fcb -28,-4 ; position relative to previous node
; node # 38 D(26,98)->(-112,-112)
       fcb 2 ; drawmode 
       fcb 11,-14 ; position relative to previous node
; node # 39 D(17,84)->(-92,-92)
       fcb 2 ; drawmode 
       fcb 14,-9 ; position relative to previous node
; node # 40 D(7,78)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 6,-10 ; position relative to previous node
; node # 41 D(-26,53)->(-42,-42)
       fcb 2 ; drawmode 
       fcb 25,-33 ; position relative to previous node
; node # 42 D(-30,44)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 9,-4 ; position relative to previous node
; node # 43 D(-26,31)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 13,4 ; position relative to previous node
; node # 44 D(-3,-17)->(-2,-2)
       fcb 2 ; drawmode 
       fcb 48,23 ; position relative to previous node
; node # 45 D(12,-42)->(18,18)
       fcb 2 ; drawmode 
       fcb 25,15 ; position relative to previous node
; node # 46 D(17,-46)->(28,28)
       fcb 2 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 47 D(38,-48)->(48,48)
       fcb 2 ; drawmode 
       fcb 2,21 ; position relative to previous node
; node # 48 D(45,-58)->(68,68)
       fcb 2 ; drawmode 
       fcb 10,7 ; position relative to previous node
; node # 49 D(59,-47)->(88,88)
       fcb 2 ; drawmode 
       fcb -11,14 ; position relative to previous node
; node # 50 D(65,-45)->(98,98)
       fcb 2 ; drawmode 
       fcb -2,6 ; position relative to previous node
; node # 51 D(70,-46)->(108,108)
       fcb 2 ; drawmode 
       fcb 1,5 ; position relative to previous node
; node # 52 D(77,-54)->(118,118)
       fcb 2 ; drawmode 
       fcb 8,7 ; position relative to previous node
; node # 53 D(86,-73)->(-118,-118)
       fcb 2 ; drawmode 
       fcb 19,9 ; position relative to previous node
; node # 54 D(87,-86)->(-98,-98)
       fcb 2 ; drawmode 
       fcb 13,1 ; position relative to previous node
; node # 55 D(67,-103)->(-78,-78)
       fcb 2 ; drawmode 
       fcb 17,-20 ; position relative to previous node
; node # 56 D(50,-91)->(-58,-58)
       fcb 2 ; drawmode 
       fcb -12,-17 ; position relative to previous node
; node # 57 D(41,-89)->(-48,-48)
       fcb 2 ; drawmode 
       fcb -2,-9 ; position relative to previous node
; node # 58 DM(40,-82)->(-38,-38)
       fcb -1 ; drawmode 
       fcb -7,-1 ; position relative to previous node
; node # 59 D(43,-66)->(-28,-28)
       fcb 2 ; drawmode 
       fcb -16,3 ; position relative to previous node
; node # 60 D(46,-57)->(-18,-18)
       fcb 2 ; drawmode 
       fcb -9,3 ; position relative to previous node
; node # 61 M(44,-40)->(-122,-122)
       fcb 0 ; drawmode 
       fcb -17,-2 ; position relative to previous node
; node # 62 DM(47,-55)->(-112,-112)
       fcb -1 ; drawmode 
       fcb 15,3 ; position relative to previous node
; node # 63 M(49,-83)->(-102,-102)
       fcb 0 ; drawmode 
       fcb 28,2 ; position relative to previous node
; node # 64 DM(55,-82)->(-92,-92)
       fcb -1 ; drawmode 
       fcb -1,6 ; position relative to previous node
; node # 65 DM(62,-79)->(-82,-82)
       fcb -1 ; drawmode 
       fcb -3,7 ; position relative to previous node
; node # 66 DM(64,-77)->(-72,-72)
       fcb -1 ; drawmode 
       fcb -2,2 ; position relative to previous node
; node # 67 M(71,-78)->(-62,-62)
       fcb 0 ; drawmode 
       fcb 1,7 ; position relative to previous node
; node # 68 DM(75,-81)->(-52,-52)
       fcb -1 ; drawmode 
       fcb 3,4 ; position relative to previous node
; node # 69 DM(80,-82)->(-42,-42)
       fcb -1 ; drawmode 
       fcb 1,5 ; position relative to previous node
; node # 70 DM(84,-82)->(-32,-32)
       fcb -1 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 71 M(49,-77)->(-22,-22)
       fcb 0 ; drawmode 
       fcb -5,-35 ; position relative to previous node
; node # 72 D(52,-75)->(-12,-12)
       fcb 2 ; drawmode 
       fcb -2,3 ; position relative to previous node
; node # 73 D(56,-74)->(-2,-2)
       fcb 2 ; drawmode 
       fcb -1,4 ; position relative to previous node
; node # 74 D(61,-76)->(8,8)
       fcb 2 ; drawmode 
       fcb 2,5 ; position relative to previous node
; node # 75 M(73,-76)->(18,18)
       fcb 0 ; drawmode 
       fcb 0,12 ; position relative to previous node
; node # 76 D(77,-75)->(28,28)
       fcb 2 ; drawmode 
       fcb -1,4 ; position relative to previous node
; node # 77 D(81,-76)->(38,38)
       fcb 2 ; drawmode 
       fcb 1,4 ; position relative to previous node
; node # 78 M(68,-74)->(48,48)
       fcb 0 ; drawmode 
       fcb -2,-13 ; position relative to previous node
; node # 79 D(68,-69)->(58,58)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 80 D(69,-62)->(68,68)
       fcb 2 ; drawmode 
       fcb -7,1 ; position relative to previous node
; node # 81 D(65,-61)->(88,88)
       fcb 2 ; drawmode 
       fcb -1,-4 ; position relative to previous node
; node # 82 DM(62,-62)->(98,98)
       fcb -1 ; drawmode 
       fcb 1,-3 ; position relative to previous node
; node # 83 M(56,-57)->(108,108)
       fcb 0 ; drawmode 
       fcb -5,-6 ; position relative to previous node
; node # 84 D(64,-58)->(118,118)
       fcb 2 ; drawmode 
       fcb 1,8 ; position relative to previous node
; node # 85 D(69,-58)->(-128,-128)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 86 D(74,-57)->(-108,-108)
       fcb 2 ; drawmode 
       fcb -1,5 ; position relative to previous node
; node # 87 D(67,-55)->(-98,-98)
       fcb 2 ; drawmode 
       fcb -2,-7 ; position relative to previous node
; node # 88 D(61,-56)->(-88,-88)
       fcb 2 ; drawmode 
       fcb 1,-6 ; position relative to previous node
; node # 89 D(56,-57)->(-78,-78)
       fcb 2 ; drawmode 
       fcb 1,-5 ; position relative to previous node
; node # 90 D(59,-55)->(-68,-68)
       fcb 2 ; drawmode 
       fcb -2,3 ; position relative to previous node
; node # 91 D(63,-52)->(-58,-58)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 92 D(68,-52)->(-48,-48)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 93 D(71,-54)->(-38,-38)
       fcb 2 ; drawmode 
       fcb 2,3 ; position relative to previous node
; node # 94 D(74,-57)->(-28,-28)
       fcb 2 ; drawmode 
       fcb 3,3 ; position relative to previous node
; node # 95 M(67,-103)->(-18,-18)
       fcb 0 ; drawmode 
       fcb 46,-7 ; position relative to previous node
; node # 96 DM(58,-110)->(-8,-8)
       fcb -1 ; drawmode 
       fcb 7,-9 ; position relative to previous node
; node # 97 DM(52,-119)->(2,2)
       fcb -1 ; drawmode 
       fcb 9,-6 ; position relative to previous node
; node # 98 M(49,-125)->(12,12)
       fcb 0 ; drawmode 
       fcb 6,-3 ; position relative to previous node
; node # 99 M(41,-72)->(62,62)
       fcb 0 ; drawmode 
       fcb -53,-8 ; position relative to previous node
; node # 100 D(32,-85)->(72,72)
       fcb 2 ; drawmode 
       fcb 13,-9 ; position relative to previous node
; node # 101 D(30,-100)->(82,82)
       fcb 2 ; drawmode 
       fcb 15,-2 ; position relative to previous node
; node # 102 D(34,-113)->(102,102)
       fcb 2 ; drawmode 
       fcb 13,4 ; position relative to previous node
; node # 103 D(44,-124)->(112,112)
       fcb 2 ; drawmode 
       fcb 11,10 ; position relative to previous node
; node # 104 D(60,-128)->(122,122)
       fcb 2 ; drawmode 
       fcb 4,16 ; position relative to previous node
; node # 105 D(79,-124)->(-124,-124)
       fcb 2 ; drawmode 
       fcb -4,19 ; position relative to previous node
; node # 106 D(90,-116)->(-114,-114)
       fcb 2 ; drawmode 
       fcb -8,11 ; position relative to previous node
; node # 107 D(95,-108)->(-104,-104)
       fcb 2 ; drawmode 
       fcb -8,5 ; position relative to previous node
; node # 108 D(97,-97)->(-94,-94)
       fcb 2 ; drawmode 
       fcb -11,2 ; position relative to previous node
; node # 109 D(95,-81)->(-84,-84)
       fcb 2 ; drawmode 
       fcb -16,-2 ; position relative to previous node
; node # 110 D(85,-70)->(-64,-64)
       fcb 2 ; drawmode 
       fcb -11,-10 ; position relative to previous node
; node # 111 M(92,-77)->(-54,-54)
       fcb 0 ; drawmode 
       fcb 7,7 ; position relative to previous node
; node # 112 D(95,-71)->(-44,-44)
       fcb 2 ; drawmode 
       fcb -6,3 ; position relative to previous node
; node # 113 D(94,-66)->(-34,-34)
       fcb 2 ; drawmode 
       fcb -5,-1 ; position relative to previous node
; node # 114 D(82,-54)->(-14,-14)
       fcb 2 ; drawmode 
       fcb -12,-12 ; position relative to previous node
; node # 115 DM(80,-60)->(-4,-4)
       fcb -1 ; drawmode 
       fcb 6,-2 ; position relative to previous node
; node # 116 M(89,-62)->(6,6)
       fcb 0 ; drawmode 
       fcb 2,9 ; position relative to previous node
; node # 117 D(92,-58)->(16,16)
       fcb 2 ; drawmode 
       fcb -4,3 ; position relative to previous node
; node # 118 D(92,-54)->(26,26)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 119 D(79,-45)->(46,46)
       fcb 2 ; drawmode 
       fcb -9,-13 ; position relative to previous node
; node # 120 D(76,-52)->(56,56)
       fcb 2 ; drawmode 
       fcb 7,-3 ; position relative to previous node
; node # 121 D(72,-41)->(66,66)
       fcb 2 ; drawmode 
       fcb -11,-4 ; position relative to previous node
; node # 122 D(76,-38)->(76,76)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 123 D(86,-44)->(86,86)
       fcb 2 ; drawmode 
       fcb 6,10 ; position relative to previous node
; node # 124 D(85,-49)->(106,106)
       fcb 2 ; drawmode 
       fcb 5,-1 ; position relative to previous node
; node # 125 M(71,-41)->(116,116)
       fcb 0 ; drawmode 
       fcb -8,-14 ; position relative to previous node
; node # 126 D(70,-39)->(126,126)
       fcb 2 ; drawmode 
       fcb -2,-1 ; position relative to previous node
; node # 127 D(75,-38)->(-120,-120)
       fcb 2 ; drawmode 
       fcb -1,5 ; position relative to previous node
; node # 128 D(69,-26)->(-110,-110)
       fcb 2 ; drawmode 
       fcb -12,-6 ; position relative to previous node
; node # 129 D(68,-29)->(-100,-100)
       fcb 2 ; drawmode 
       fcb 3,-1 ; position relative to previous node
; node # 130 D(65,-27)->(-90,-90)
       fcb 2 ; drawmode 
       fcb -2,-3 ; position relative to previous node
; node # 131 D(59,-26)->(-70,-70)
       fcb 2 ; drawmode 
       fcb -1,-6 ; position relative to previous node
; node # 132 D(70,-39)->(-60,-60)
       fcb 2 ; drawmode 
       fcb 13,11 ; position relative to previous node
; node # 133 M(86,-43)->(-50,-50)
       fcb 0 ; drawmode 
       fcb 4,16 ; position relative to previous node
; node # 134 D(95,-36)->(-40,-40)
       fcb 2 ; drawmode 
       fcb -7,9 ; position relative to previous node
; node # 135 D(100,-26)->(-20,-20)
       fcb 2 ; drawmode 
       fcb -10,5 ; position relative to previous node
; node # 136 D(96,13)->(10,10)
       fcb 2 ; drawmode 
       fcb -39,-4 ; position relative to previous node
; node # 137 D(82,48)->(40,40)
       fcb 2 ; drawmode 
       fcb -35,-14 ; position relative to previous node
; node # 138 D(74,62)->(50,50)
       fcb 2 ; drawmode 
       fcb -14,-8 ; position relative to previous node
; node # 139 D(69,73)->(60,60)
       fcb 2 ; drawmode 
       fcb -11,-5 ; position relative to previous node
; node # 140 D(61,112)->(80,80)
       fcb 2 ; drawmode 
       fcb -39,-8 ; position relative to previous node
; node # 141 M(88,112)->(90,90)
       fcb 0 ; drawmode 
       fcb 0,27 ; position relative to previous node
; node # 142 D(84,97)->(100,100)
       fcb 2 ; drawmode 
       fcb 15,-4 ; position relative to previous node
; node # 143 D(75,77)->(110,110)
       fcb 2 ; drawmode 
       fcb 20,-9 ; position relative to previous node
; node # 144 D(73,63)->(100,100)
       fcb 2 ; drawmode 
       fcb 14,-2 ; position relative to previous node
; node # 145 M(40,109)->(110,110)
       fcb 0 ; drawmode 
       fcb -46,-33 ; position relative to previous node
; node # 146 D(45,74)->(120,120)
       fcb 2 ; drawmode 
       fcb 35,5 ; position relative to previous node
; node # 147 D(49,58)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 16,4 ; position relative to previous node
; node # 148 D(63,21)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 37,14 ; position relative to previous node
; node # 149 DM(69,-11)->(-76,-76)
       fcb -1 ; drawmode 
       fcb 32,6 ; position relative to previous node
       fcb  1  ; end of anim
