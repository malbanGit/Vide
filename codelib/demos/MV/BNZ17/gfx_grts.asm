greetsframecount EQU 13 ; number of animations
; index table 
greetsframetab        fdb greetsframe0
       fdb greetsframe1
       fdb greetsframe2
       fdb greetsframe3
       fdb greetsframe4
       fdb greetsframe5
       fdb greetsframe6
       fdb greetsframe7
       fdb greetsframe8
       fdb greetsframe9
       fdb greetsframe10
       fdb greetsframe11
       fdb greetsframe12

; Animation 0
greetsframe0:
; node # 0 M(-40,-23)->(0,0)
       fcb 0 ; drawmode 
       fcb 23,-40 ; position relative to previous node
; node # 1 D(-48,-22)->(10,10)
       fcb 2 ; drawmode 
       fcb -1,-8 ; position relative to previous node
; node # 2 D(-52,-18)->(20,20)
       fcb 2 ; drawmode 
       fcb -4,-4 ; position relative to previous node
; node # 3 D(-52,-7)->(30,30)
       fcb 2 ; drawmode 
       fcb -11,0 ; position relative to previous node
; node # 4 D(-48,-3)->(40,40)
       fcb 2 ; drawmode 
       fcb -4,4 ; position relative to previous node
; node # 5 D(-40,-3)->(50,50)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 6 D(-40,-7)->(60,60)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 7 D(-48,-8)->(70,70)
       fcb 2 ; drawmode 
       fcb 1,-8 ; position relative to previous node
; node # 8 D(-48,-18)->(80,80)
       fcb 2 ; drawmode 
       fcb 10,0 ; position relative to previous node
; node # 9 D(-39,-19)->(90,90)
       fcb 2 ; drawmode 
       fcb 1,9 ; position relative to previous node
; node # 10 D(-39,-23)->(100,100)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 11 M(-38,-19)->(-38,-19)
       fcb 0 ; drawmode 
       fcb -4,1 ; position relative to previous node
; node # 12 D(-33,-24)->(120,120)
       fcb 2 ; drawmode 
       fcb 5,5 ; position relative to previous node
; node # 13 D(-27,-24)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 14 D(-22,-21)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -3,5 ; position relative to previous node
; node # 15 D(-22,-8)->(-106,-106)
       fcb 2 ; drawmode 
       fcb -13,0 ; position relative to previous node
; node # 16 D(-28,-3)->(-96,-96)
       fcb 2 ; drawmode 
       fcb -5,-6 ; position relative to previous node
; node # 17 D(-33,-3)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 18 D(-38,-7)->(-38,-7)
       fcb 2 ; drawmode 
       fcb 4,-5 ; position relative to previous node
; node # 19 D(-38,-19)->(-38,-19)
       fcb 2 ; drawmode 
       fcb 12,0 ; position relative to previous node
; node # 20 M(-34,-19)->(-56,-56)
       fcb 0 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 21 D(-27,-19)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 22 D(-27,-8)->(-36,-36)
       fcb 2 ; drawmode 
       fcb -11,0 ; position relative to previous node
; node # 23 D(-33,-8)->(-26,-26)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 24 D(-33,-19)->(-16,-16)
       fcb 2 ; drawmode 
       fcb 11,0 ; position relative to previous node
; node # 25 M(-20,-2)->(-20,-2)
       fcb 0 ; drawmode 
       fcb -17,13 ; position relative to previous node
; node # 26 D(-6,-2)->(4,4)
       fcb 2 ; drawmode 
       fcb 0,14 ; position relative to previous node
; node # 27 D(2,-7)->(14,14)
       fcb 2 ; drawmode 
       fcb 5,8 ; position relative to previous node
; node # 28 D(2,-12)->(24,24)
       fcb 2 ; drawmode 
       fcb 5,0 ; position relative to previous node
; node # 29 D(-5,-17)->(-5,-17)
       fcb 2 ; drawmode 
       fcb 5,-7 ; position relative to previous node
; node # 30 D(-10,-17)->(-10,-17)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 31 D(-13,-19)->(54,54)
       fcb 2 ; drawmode 
       fcb 2,-3 ; position relative to previous node
; node # 32 D(-10,-22)->(64,64)
       fcb 2 ; drawmode 
       fcb 3,3 ; position relative to previous node
; node # 33 D(2,-23)->(2,-23)
       fcb 2 ; drawmode 
       fcb 1,12 ; position relative to previous node
; node # 34 D(2,-29)->(84,84)
       fcb 2 ; drawmode 
       fcb 6,0 ; position relative to previous node
; node # 35 D(-13,-26)->(94,94)
       fcb 2 ; drawmode 
       fcb -3,-15 ; position relative to previous node
; node # 36 D(-20,-20)->(-20,-20)
       fcb 2 ; drawmode 
       fcb -6,-7 ; position relative to previous node
; node # 37 D(-19,-16)->(-19,-16)
       fcb 2 ; drawmode 
       fcb -4,1 ; position relative to previous node
; node # 38 D(-13,-12)->(-13,-12)
       fcb 2 ; drawmode 
       fcb -4,6 ; position relative to previous node
; node # 39 D(-7,-12)->(-7,-12)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 40 D(-5,-9)->(-5,-9)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 41 D(-9,-7)->(-9,-7)
       fcb 2 ; drawmode 
       fcb -2,-4 ; position relative to previous node
; node # 42 D(-20,-7)->(-20,-7)
       fcb 2 ; drawmode 
       fcb 0,-11 ; position relative to previous node
; node # 43 D(-20,-2)->(-20,-2)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 44 M(5,-1)->(-82,-82)
       fcb 0 ; drawmode 
       fcb -1,25 ; position relative to previous node
; node # 45 D(5,-29)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 28,0 ; position relative to previous node
; node # 46 D(14,-30)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 1,9 ; position relative to previous node
; node # 47 D(14,-1)->(-52,-52)
       fcb 2 ; drawmode 
       fcb -29,0 ; position relative to previous node
; node # 48 D(5,-1)->(-42,-42)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 49 M(17,-1)->(-32,-32)
       fcb 0 ; drawmode 
       fcb 0,12 ; position relative to previous node
; node # 50 D(17,-31)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 30,0 ; position relative to previous node
; node # 51 D(39,-33)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 2,22 ; position relative to previous node
; node # 52 D(54,-27)->(-2,-2)
       fcb 2 ; drawmode 
       fcb -6,15 ; position relative to previous node
; node # 53 D(54,0)->(8,8)
       fcb 2 ; drawmode 
       fcb -27,0 ; position relative to previous node
; node # 54 D(41,0)->(18,18)
       fcb 2 ; drawmode 
       fcb 0,-13 ; position relative to previous node
; node # 55 D(41,-24)->(28,28)
       fcb 2 ; drawmode 
       fcb 24,0 ; position relative to previous node
; node # 56 D(36,-26)->(36,-26)
       fcb 2 ; drawmode 
       fcb 2,-5 ; position relative to previous node
; node # 57 D(27,-25)->(48,48)
       fcb 2 ; drawmode 
       fcb -1,-9 ; position relative to previous node
; node # 58 D(27,0)->(58,58)
       fcb 2 ; drawmode 
       fcb -25,0 ; position relative to previous node
; node # 59 D(17,-1)->(68,68)
       fcb 2 ; drawmode 
       fcb 1,-10 ; position relative to previous node
; node # 60 M(59,0)->(59,0)
       fcb 0 ; drawmode 
       fcb -1,42 ; position relative to previous node
; node # 61 D(59,-36)->(88,88)
       fcb 2 ; drawmode 
       fcb 36,0 ; position relative to previous node
; node # 62 D(118,-44)->(98,98)
       fcb 2 ; drawmode 
       fcb 8,59 ; position relative to previous node
; node # 63 D(118,-34)->(118,-34)
       fcb 2 ; drawmode 
       fcb -10,0 ; position relative to previous node
; node # 64 D(75,-30)->(118,118)
       fcb 2 ; drawmode 
       fcb -4,-43 ; position relative to previous node
; node # 65 D(75,-22)->(75,-22)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 66 D(98,-23)->(-118,-118)
       fcb 2 ; drawmode 
       fcb 1,23 ; position relative to previous node
; node # 67 D(98,-14)->(-108,-108)
       fcb 2 ; drawmode 
       fcb -9,0 ; position relative to previous node
; node # 68 D(74,-14)->(-98,-98)
       fcb 2 ; drawmode 
       fcb 0,-24 ; position relative to previous node
; node # 69 D(74,-7)->(-88,-88)
       fcb 2 ; drawmode 
       fcb -7,0 ; position relative to previous node
; node # 70 D(118,-7)->(-78,-78)
       fcb 2 ; drawmode 
       fcb 0,44 ; position relative to previous node
; node # 71 D(118,3)->(118,3)
       fcb 2 ; drawmode 
       fcb -10,0 ; position relative to previous node
; node # 72 D(59,1)->(59,1)
       fcb 2 ; drawmode 
       fcb 2,-59 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 1
greetsframe1:
; node # 0 M(-50,-21)->(0,0)
       fcb 0 ; drawmode 
       fcb 21,-50 ; position relative to previous node
; node # 1 D(-85,-23)->(10,10)
       fcb 2 ; drawmode 
       fcb 2,-35 ; position relative to previous node
; node # 2 D(-108,-13)->(20,20)
       fcb 2 ; drawmode 
       fcb -10,-23 ; position relative to previous node
; node # 3 D(-113,19)->(30,30)
       fcb 2 ; drawmode 
       fcb -32,-5 ; position relative to previous node
; node # 4 D(-90,31)->(40,40)
       fcb 2 ; drawmode 
       fcb -12,23 ; position relative to previous node
; node # 5 D(-51,28)->(50,50)
       fcb 2 ; drawmode 
       fcb 3,39 ; position relative to previous node
; node # 6 D(-50,17)->(60,60)
       fcb 2 ; drawmode 
       fcb 11,1 ; position relative to previous node
; node # 7 D(-82,19)->(-82,19)
       fcb 2 ; drawmode 
       fcb -2,-32 ; position relative to previous node
; node # 8 D(-90,14)->(-90,14)
       fcb 2 ; drawmode 
       fcb 5,-8 ; position relative to previous node
; node # 9 D(-88,-9)->(-88,-9)
       fcb 2 ; drawmode 
       fcb 23,2 ; position relative to previous node
; node # 10 D(-80,-13)->(-80,-13)
       fcb 2 ; drawmode 
       fcb 4,8 ; position relative to previous node
; node # 11 D(-50,-12)->(110,110)
       fcb 2 ; drawmode 
       fcb -1,30 ; position relative to previous node
; node # 12 D(-50,-21)->(120,120)
       fcb 2 ; drawmode 
       fcb 9,0 ; position relative to previous node
; node # 13 M(-46,-20)->(-126,-126)
       fcb 0 ; drawmode 
       fcb -1,4 ; position relative to previous node
; node # 14 D(-46,27)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -47,0 ; position relative to previous node
; node # 15 D(-30,26)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 1,16 ; position relative to previous node
; node # 16 D(-31,6)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 20,-1 ; position relative to previous node
; node # 17 D(-20,6)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 0,11 ; position relative to previous node
; node # 18 D(-15,10)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -4,5 ; position relative to previous node
; node # 19 D(-14,25)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -15,1 ; position relative to previous node
; node # 20 D(-1,24)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 1,13 ; position relative to previous node
; node # 21 D(-3,6)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 18,-2 ; position relative to previous node
; node # 22 D(-10,1)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 5,-7 ; position relative to previous node
; node # 23 D(-4,-3)->(-4,-3)
       fcb 2 ; drawmode 
       fcb 4,6 ; position relative to previous node
; node # 24 D(-4,-9)->(-4,-9)
       fcb 2 ; drawmode 
       fcb 6,0 ; position relative to previous node
; node # 25 D(-18,-18)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 9,-14 ; position relative to previous node
; node # 26 D(-46,-20)->(4,4)
       fcb 2 ; drawmode 
       fcb 2,-28 ; position relative to previous node
; node # 27 M(-31,-10)->(14,14)
       fcb 0 ; drawmode 
       fcb -10,15 ; position relative to previous node
; node # 28 D(-31,-3)->(24,24)
       fcb 2 ; drawmode 
       fcb -7,0 ; position relative to previous node
; node # 29 D(-21,-3)->(34,34)
       fcb 2 ; drawmode 
       fcb 0,10 ; position relative to previous node
; node # 30 D(-16,-7)->(44,44)
       fcb 2 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 31 D(-22,-11)->(54,54)
       fcb 2 ; drawmode 
       fcb 4,-6 ; position relative to previous node
; node # 32 D(-31,-11)->(64,64)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 33 M(-2,-18)->(74,74)
       fcb 0 ; drawmode 
       fcb 7,29 ; position relative to previous node
; node # 34 D(2,23)->(84,84)
       fcb 2 ; drawmode 
       fcb -41,4 ; position relative to previous node
; node # 35 D(35,20)->(94,94)
       fcb 2 ; drawmode 
       fcb 3,33 ; position relative to previous node
; node # 36 D(33,13)->(104,104)
       fcb 2 ; drawmode 
       fcb 7,-2 ; position relative to previous node
; node # 37 D(13,14)->(114,114)
       fcb 2 ; drawmode 
       fcb -1,-20 ; position relative to previous node
; node # 38 D(12,5)->(124,124)
       fcb 2 ; drawmode 
       fcb 9,-1 ; position relative to previous node
; node # 39 D(24,5)->(-122,-122)
       fcb 2 ; drawmode 
       fcb 0,12 ; position relative to previous node
; node # 40 D(22,-2)->(-112,-112)
       fcb 2 ; drawmode 
       fcb 7,-2 ; position relative to previous node
; node # 41 D(10,-2)->(-102,-102)
       fcb 2 ; drawmode 
       fcb 0,-12 ; position relative to previous node
; node # 42 D(9,-10)->(-92,-92)
       fcb 2 ; drawmode 
       fcb 8,-1 ; position relative to previous node
; node # 43 D(29,-9)->(-82,-82)
       fcb 2 ; drawmode 
       fcb -1,20 ; position relative to previous node
; node # 44 D(28,-16)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 7,-1 ; position relative to previous node
; node # 45 D(-1,-18)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 2,-29 ; position relative to previous node
; node # 46 M(34,-2)->(34,-2)
       fcb 0 ; drawmode 
       fcb -16,35 ; position relative to previous node
; node # 47 D(44,5)->(-42,-42)
       fcb 2 ; drawmode 
       fcb -7,10 ; position relative to previous node
; node # 48 D(50,5)->(50,5)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 49 D(54,8)->(54,8)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 50 D(51,12)->(51,12)
       fcb 2 ; drawmode 
       fcb -4,-3 ; position relative to previous node
; node # 51 D(45,12)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 52 D(37,13)->(-22,-22)
       fcb 2 ; drawmode 
       fcb -1,-8 ; position relative to previous node
; node # 53 D(38,20)->(-12,-12)
       fcb 2 ; drawmode 
       fcb -7,1 ; position relative to previous node
; node # 54 D(55,19)->(-2,-2)
       fcb 2 ; drawmode 
       fcb 1,17 ; position relative to previous node
; node # 55 D(61,11)->(61,11)
       fcb 2 ; drawmode 
       fcb 8,6 ; position relative to previous node
; node # 56 D(59,5)->(59,5)
       fcb 2 ; drawmode 
       fcb 6,-2 ; position relative to previous node
; node # 57 D(50,-2)->(18,18)
       fcb 2 ; drawmode 
       fcb 7,-9 ; position relative to previous node
; node # 58 D(45,-2)->(28,28)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 59 D(41,-5)->(41,-5)
       fcb 2 ; drawmode 
       fcb 3,-4 ; position relative to previous node
; node # 60 D(44,-8)->(44,-8)
       fcb 2 ; drawmode 
       fcb 3,3 ; position relative to previous node
; node # 61 D(56,-8)->(48,48)
       fcb 2 ; drawmode 
       fcb 0,12 ; position relative to previous node
; node # 62 D(55,-14)->(55,-14)
       fcb 2 ; drawmode 
       fcb 6,-1 ; position relative to previous node
; node # 63 D(39,-15)->(68,68)
       fcb 2 ; drawmode 
       fcb 1,-16 ; position relative to previous node
; node # 64 D(33,-8)->(33,-8)
       fcb 2 ; drawmode 
       fcb -7,-6 ; position relative to previous node
; node # 65 D(34,-1)->(34,-1)
       fcb 2 ; drawmode 
       fcb -7,1 ; position relative to previous node
; node # 66 M(57,-14)->(88,88)
       fcb 0 ; drawmode 
       fcb 13,23 ; position relative to previous node
; node # 67 D(59,-8)->(98,98)
       fcb 2 ; drawmode 
       fcb -6,2 ; position relative to previous node
; node # 68 D(65,-7)->(108,108)
       fcb 2 ; drawmode 
       fcb -1,6 ; position relative to previous node
; node # 69 D(72,17)->(118,118)
       fcb 2 ; drawmode 
       fcb -24,7 ; position relative to previous node
; node # 70 D(79,17)->(-128,-128)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 71 D(72,-8)->(-118,-118)
       fcb 2 ; drawmode 
       fcb 25,-7 ; position relative to previous node
; node # 72 D(78,-8)->(-108,-108)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 73 D(76,-13)->(-98,-98)
       fcb 2 ; drawmode 
       fcb 5,-2 ; position relative to previous node
; node # 74 D(57,-14)->(-88,-88)
       fcb 2 ; drawmode 
       fcb 1,-19 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 2
greetsframe2:
; node # 0 M(-107,-5)->(-107,-5)
       fcb 0 ; drawmode 
       fcb 5,-107 ; position relative to previous node
; node # 1 D(-116,-4)->(-116,-4)
       fcb 2 ; drawmode 
       fcb -1,-9 ; position relative to previous node
; node # 2 D(-120,3)->(-120,3)
       fcb 2 ; drawmode 
       fcb -7,-4 ; position relative to previous node
; node # 3 D(-120,20)->(-120,20)
       fcb 2 ; drawmode 
       fcb -17,0 ; position relative to previous node
; node # 4 D(-116,27)->(-116,27)
       fcb 2 ; drawmode 
       fcb -7,4 ; position relative to previous node
; node # 5 D(-107,28)->(-107,28)
       fcb 2 ; drawmode 
       fcb -1,9 ; position relative to previous node
; node # 6 D(-107,21)->(-107,21)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 7 D(-116,21)->(-116,21)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 8 D(-116,2)->(-116,2)
       fcb 2 ; drawmode 
       fcb 19,0 ; position relative to previous node
; node # 9 D(-107,2)->(-107,2)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 10 D(-107,-5)->(-107,-5)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 11 M(-106,-5)->(-106,-5)
       fcb 0 ; drawmode 
       fcb 0,1 ; position relative to previous node
; node # 12 D(-106,28)->(-105,28)
       fcb 2 ; drawmode 
       fcb -33,0 ; position relative to previous node
; node # 13 D(-101,28)->(-101,28)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 14 D(-101,15)->(-101,15)
       fcb 2 ; drawmode 
       fcb 13,0 ; position relative to previous node
; node # 15 D(-97,15)->(-97,15)
       fcb 2 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 16 D(-95,17)->(-95,17)
       fcb 2 ; drawmode 
       fcb -2,2 ; position relative to previous node
; node # 17 D(-95,28)->(-95,28)
       fcb 2 ; drawmode 
       fcb -11,0 ; position relative to previous node
; node # 18 D(-90,28)->(-90,28)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 19 D(-90,15)->(-90,15)
       fcb 2 ; drawmode 
       fcb 13,0 ; position relative to previous node
; node # 20 D(-93,11)->(-93,11)
       fcb 2 ; drawmode 
       fcb 4,-3 ; position relative to previous node
; node # 21 D(-91,7)->(-91,7)
       fcb 2 ; drawmode 
       fcb 4,2 ; position relative to previous node
; node # 22 D(-91,1)->(-91,1)
       fcb 2 ; drawmode 
       fcb 6,0 ; position relative to previous node
; node # 23 D(-96,-6)->(-96,-6)
       fcb 2 ; drawmode 
       fcb 7,-5 ; position relative to previous node
; node # 24 D(-105,-5)->(-105,-5)
       fcb 2 ; drawmode 
       fcb -1,-9 ; position relative to previous node
; node # 25 M(-101,1)->(-101,1)
       fcb 0 ; drawmode 
       fcb -6,4 ; position relative to previous node
; node # 26 D(-101,8)->(-101,8)
       fcb 2 ; drawmode 
       fcb -7,0 ; position relative to previous node
; node # 27 D(-98,8)->(-98,8)
       fcb 2 ; drawmode 
       fcb 0,3 ; position relative to previous node
; node # 28 D(-95,4)->(-95,4)
       fcb 2 ; drawmode 
       fcb 4,3 ; position relative to previous node
; node # 29 D(-97,1)->(-97,1)
       fcb 2 ; drawmode 
       fcb 3,-2 ; position relative to previous node
; node # 30 D(-101,1)->(-101,1)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 31 M(-89,-6)->(-89,-6)
       fcb 0 ; drawmode 
       fcb 7,12 ; position relative to previous node
; node # 32 D(-89,29)->(-89,29)
       fcb 2 ; drawmode 
       fcb -35,0 ; position relative to previous node
; node # 33 D(-71,30)->(-71,30)
       fcb 2 ; drawmode 
       fcb -1,18 ; position relative to previous node
; node # 34 D(-71,22)->(-71,22)
       fcb 2 ; drawmode 
       fcb 8,0 ; position relative to previous node
; node # 35 D(-84,22)->(-84,22)
       fcb 2 ; drawmode 
       fcb 0,-13 ; position relative to previous node
; node # 36 D(-84,14)->(-84,14)
       fcb 2 ; drawmode 
       fcb 8,0 ; position relative to previous node
; node # 37 D(-77,14)->(-77,14)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 38 D(-77,7)->(-77,7)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 39 D(-83,7)->(-83,7)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 40 D(-83,0)->(-83,0)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 41 D(-71,0)->(-71,0)
       fcb 2 ; drawmode 
       fcb 0,12 ; position relative to previous node
; node # 42 D(-71,-8)->(-71,-8)
       fcb 2 ; drawmode 
       fcb 8,0 ; position relative to previous node
; node # 43 D(-89,-6)->(-89,-6)
       fcb 2 ; drawmode 
       fcb -2,-18 ; position relative to previous node
; node # 44 M(-69,0)->(-69,0)
       fcb 0 ; drawmode 
       fcb -6,20 ; position relative to previous node
; node # 45 D(-69,30)->(-69,30)
       fcb 2 ; drawmode 
       fcb -30,0 ; position relative to previous node
; node # 46 D(-63,30)->(-63,30)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 47 D(-63,14)->(-63,14)
       fcb 2 ; drawmode 
       fcb 16,0 ; position relative to previous node
; node # 48 D(-55,14)->(-55,14)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 49 D(-55,31)->(-55,31)
       fcb 2 ; drawmode 
       fcb -17,0 ; position relative to previous node
; node # 50 D(-48,31)->(-48,31)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 51 D(-48,-1)->(-48,-1)
       fcb 2 ; drawmode 
       fcb 32,0 ; position relative to previous node
; node # 52 D(-55,-9)->(-55,-9)
       fcb 2 ; drawmode 
       fcb 8,-7 ; position relative to previous node
; node # 53 D(-62,-9)->(-62,-9)
       fcb 2 ; drawmode 
       fcb 0,-7 ; position relative to previous node
; node # 54 D(-69,0)->(-69,0)
       fcb 2 ; drawmode 
       fcb -9,-7 ; position relative to previous node
; node # 55 M(-63,7)->(-63,7)
       fcb 0 ; drawmode 
       fcb -7,6 ; position relative to previous node
; node # 56 D(-63,2)->(-63,2)
       fcb 2 ; drawmode 
       fcb 5,0 ; position relative to previous node
; node # 57 D(-59,-2)->(-59,-2)
       fcb 2 ; drawmode 
       fcb 4,4 ; position relative to previous node
; node # 58 D(-55,1)->(-55,1)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 59 D(-55,7)->(-55,7)
       fcb 2 ; drawmode 
       fcb -6,0 ; position relative to previous node
; node # 60 D(-63,7)->(-63,7)
       fcb 2 ; drawmode 
       fcb 0,-8 ; position relative to previous node
; node # 61 M(-45,-2)->(-45,-2)
       fcb 0 ; drawmode 
       fcb 9,18 ; position relative to previous node
; node # 62 D(-37,-2)->(-37,-2)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 63 D(-37,32)->(-37,32)
       fcb 2 ; drawmode 
       fcb -34,0 ; position relative to previous node
; node # 64 D(-29,32)->(-29,33)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 65 D(-29,-3)->(-19,43)
       fcb 2 ; drawmode 
       fcb 35,0 ; position relative to previous node
; node # 66 D(-20,-4)->(-9,53)
       fcb 2 ; drawmode 
       fcb 1,9 ; position relative to previous node
; node # 67 D(-20,-13)->(1,63)
       fcb 2 ; drawmode 
       fcb 9,0 ; position relative to previous node
; node # 68 D(-45,-10)->(11,73)
       fcb 2 ; drawmode 
       fcb -3,-25 ; position relative to previous node
; node # 69 D(-45,-2)->(21,83)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 70 M(-17,-3)->(31,93)
       fcb 0 ; drawmode 
       fcb 1,28 ; position relative to previous node
; node # 71 D(-17,23)->(41,103)
       fcb 2 ; drawmode 
       fcb -26,0 ; position relative to previous node
; node # 72 D(-7,33)->(51,113)
       fcb 2 ; drawmode 
       fcb -10,10 ; position relative to previous node
; node # 73 D(2,34)->(61,123)
       fcb 2 ; drawmode 
       fcb -1,9 ; position relative to previous node
; node # 74 D(15,24)->(71,-123)
       fcb 2 ; drawmode 
       fcb 10,13 ; position relative to previous node
; node # 75 D(15,-4)->(81,-113)
       fcb 2 ; drawmode 
       fcb 28,0 ; position relative to previous node
; node # 76 D(3,-15)->(91,-103)
       fcb 2 ; drawmode 
       fcb 11,-12 ; position relative to previous node
; node # 77 D(-6,-14)->(101,-93)
       fcb 2 ; drawmode 
       fcb -1,-9 ; position relative to previous node
; node # 78 D(-17,-3)->(111,-83)
       fcb 2 ; drawmode 
       fcb -11,-11 ; position relative to previous node
; node # 79 M(-7,0)->(121,-73)
       fcb 0 ; drawmode 
       fcb -3,10 ; position relative to previous node
; node # 80 D(-7,20)->(-125,-63)
       fcb 2 ; drawmode 
       fcb -20,0 ; position relative to previous node
; node # 81 D(-2,24)->(-115,-53)
       fcb 2 ; drawmode 
       fcb -4,5 ; position relative to previous node
; node # 82 D(4,20)->(-105,-43)
       fcb 2 ; drawmode 
       fcb 4,6 ; position relative to previous node
; node # 83 D(4,0)->(-95,-33)
       fcb 2 ; drawmode 
       fcb 20,0 ; position relative to previous node
; node # 84 D(-2,-5)->(-95,-33)
       fcb 2 ; drawmode 
       fcb 5,-6 ; position relative to previous node
; node # 85 D(-7,0)->(-85,-23)
       fcb 2 ; drawmode 
       fcb -5,-5 ; position relative to previous node
; node # 86 M(18,-16)->(-75,-13)
       fcb 0 ; drawmode 
       fcb 16,25 ; position relative to previous node
; node # 87 D(18,35)->(-65,-3)
       fcb 2 ; drawmode 
       fcb -51,0 ; position relative to previous node
; node # 88 D(30,36)->(-55,7)
       fcb 2 ; drawmode 
       fcb -1,12 ; position relative to previous node
; node # 89 D(30,15)->(-45,17)
       fcb 2 ; drawmode 
       fcb 21,0 ; position relative to previous node
; node # 90 D(39,15)->(-35,27)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 91 D(45,19)->(-25,37)
       fcb 2 ; drawmode 
       fcb -4,6 ; position relative to previous node
; node # 92 D(45,37)->(-15,47)
       fcb 2 ; drawmode 
       fcb -18,0 ; position relative to previous node
; node # 93 D(59,38)->(-5,57)
       fcb 2 ; drawmode 
       fcb -1,14 ; position relative to previous node
; node # 94 D(59,15)->(5,67)
       fcb 2 ; drawmode 
       fcb 23,0 ; position relative to previous node
; node # 95 D(51,8)->(15,77)
       fcb 2 ; drawmode 
       fcb 7,-8 ; position relative to previous node
; node # 96 D(59,2)->(25,87)
       fcb 2 ; drawmode 
       fcb 6,8 ; position relative to previous node
; node # 97 D(59,-7)->(35,97)
       fcb 2 ; drawmode 
       fcb 9,0 ; position relative to previous node
; node # 98 D(44,-18)->(45,107)
       fcb 2 ; drawmode 
       fcb 11,-15 ; position relative to previous node
; node # 99 D(18,-16)->(55,117)
       fcb 2 ; drawmode 
       fcb -2,-26 ; position relative to previous node
; node # 100 M(30,-7)->(65,127)
       fcb 0 ; drawmode 
       fcb -9,12 ; position relative to previous node
; node # 101 D(30,4)->(75,-119)
       fcb 2 ; drawmode 
       fcb -11,0 ; position relative to previous node
; node # 102 D(40,4)->(85,-109)
       fcb 2 ; drawmode 
       fcb 0,10 ; position relative to previous node
; node # 103 D(45,-2)->(95,-99)
       fcb 2 ; drawmode 
       fcb 6,5 ; position relative to previous node
; node # 104 D(39,-8)->(105,-89)
       fcb 2 ; drawmode 
       fcb 6,-6 ; position relative to previous node
; node # 105 D(30,-7)->(115,-79)
       fcb 2 ; drawmode 
       fcb -1,-9 ; position relative to previous node
; node # 106 M(63,-7)->(125,-69)
       fcb 0 ; drawmode 
       fcb 0,33 ; position relative to previous node
; node # 107 D(63,1)->(-121,-59)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 108 D(80,14)->(-111,-49)
       fcb 2 ; drawmode 
       fcb -13,17 ; position relative to previous node
; node # 109 D(91,15)->(-101,-39)
       fcb 2 ; drawmode 
       fcb -1,11 ; position relative to previous node
; node # 110 D(98,20)->(-91,-29)
       fcb 2 ; drawmode 
       fcb -5,7 ; position relative to previous node
; node # 111 D(91,27)->(-81,-19)
       fcb 2 ; drawmode 
       fcb -7,-7 ; position relative to previous node
; node # 112 D(63,26)->(-71,-9)
       fcb 2 ; drawmode 
       fcb 1,-28 ; position relative to previous node
; node # 113 D(63,38)->(-61,1)
       fcb 2 ; drawmode 
       fcb -12,0 ; position relative to previous node
; node # 114 D(96,40)->(-51,11)
       fcb 2 ; drawmode 
       fcb -2,33 ; position relative to previous node
; node # 115 D(116,27)->(-41,21)
       fcb 2 ; drawmode 
       fcb 13,20 ; position relative to previous node
; node # 116 D(116,16)->(-31,31)
       fcb 2 ; drawmode 
       fcb 11,0 ; position relative to previous node
; node # 117 D(97,2)->(-21,41)
       fcb 2 ; drawmode 
       fcb 14,-19 ; position relative to previous node
; node # 118 D(86,2)->(-11,51)
       fcb 2 ; drawmode 
       fcb 0,-11 ; position relative to previous node
; node # 119 D(78,-3)->(-1,61)
       fcb 2 ; drawmode 
       fcb 5,-8 ; position relative to previous node
; node # 120 D(85,-10)->(9,71)
       fcb 2 ; drawmode 
       fcb 7,7 ; position relative to previous node
; node # 121 D(116,-12)->(19,81)
       fcb 2 ; drawmode 
       fcb 2,31 ; position relative to previous node
; node # 122 D(116,-25)->(29,91)
       fcb 2 ; drawmode 
       fcb 13,0 ; position relative to previous node
; node # 123 D(80,-22)->(39,101)
       fcb 2 ; drawmode 
       fcb -3,-36 ; position relative to previous node
; node # 124 D(63,-7)->(49,111)
       fcb 2 ; drawmode 
       fcb -15,-17 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 3
greetsframe3:
; node # 0 M(-82,-46)->(0,0)
       fcb 0 ; drawmode 
       fcb 46,-82 ; position relative to previous node
; node # 1 D(-117,-48)->(10,10)
       fcb 2 ; drawmode 
       fcb 2,-35 ; position relative to previous node
; node # 2 D(-117,10)->(20,20)
       fcb 2 ; drawmode 
       fcb -58,0 ; position relative to previous node
; node # 3 D(-106,9)->(30,30)
       fcb 2 ; drawmode 
       fcb 1,11 ; position relative to previous node
; node # 4 D(-106,-13)->(40,40)
       fcb 2 ; drawmode 
       fcb 22,0 ; position relative to previous node
; node # 5 D(-93,-13)->(50,50)
       fcb 2 ; drawmode 
       fcb 0,13 ; position relative to previous node
; node # 6 D(-93,-24)->(60,60)
       fcb 2 ; drawmode 
       fcb 11,0 ; position relative to previous node
; node # 7 D(-106,-24)->(70,70)
       fcb 2 ; drawmode 
       fcb 0,-13 ; position relative to previous node
; node # 8 D(-106,-35)->(80,80)
       fcb 2 ; drawmode 
       fcb 11,0 ; position relative to previous node
; node # 9 D(-82,-35)->(80,80)
       fcb 2 ; drawmode 
       fcb 0,24 ; position relative to previous node
; node # 10 D(-82,-46)->(90,90)
       fcb 2 ; drawmode 
       fcb 11,0 ; position relative to previous node
; node # 11 M(-69,-45)->(100,100)
       fcb 0 ; drawmode 
       fcb -1,13 ; position relative to previous node
; node # 12 D(-60,-45)->(110,110)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 13 D(-50,-32)->(120,120)
       fcb 2 ; drawmode 
       fcb -13,10 ; position relative to previous node
; node # 14 D(-50,7)->(-126,-126)
       fcb 2 ; drawmode 
       fcb -39,0 ; position relative to previous node
; node # 15 D(-59,7)->(-116,-116)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 16 D(-59,-13)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 20,0 ; position relative to previous node
; node # 17 D(-70,-13)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 0,-11 ; position relative to previous node
; node # 18 D(-70,8)->(-86,-86)
       fcb 2 ; drawmode 
       fcb -21,0 ; position relative to previous node
; node # 19 D(-80,8)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 0,-10 ; position relative to previous node
; node # 20 D(-80,-34)->(-66,-66)
       fcb 2 ; drawmode 
       fcb 42,0 ; position relative to previous node
; node # 21 D(-69,-45)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 11,11 ; position relative to previous node
; node # 22 M(-65,-34)->(-46,-46)
       fcb 0 ; drawmode 
       fcb -11,4 ; position relative to previous node
; node # 23 D(-70,-24)->(-26,-26)
       fcb 2 ; drawmode 
       fcb -10,-5 ; position relative to previous node
; node # 24 D(-59,-24)->(-16,-16)
       fcb 2 ; drawmode 
       fcb 0,11 ; position relative to previous node
; node # 25 D(-65,-34)->(14,14)
       fcb 2 ; drawmode 
       fcb 10,-6 ; position relative to previous node
; node # 26 M(-47,-43)->(24,24)
       fcb 0 ; drawmode 
       fcb 9,18 ; position relative to previous node
; node # 27 D(-47,7)->(34,34)
       fcb 2 ; drawmode 
       fcb -50,0 ; position relative to previous node
; node # 28 D(-38,7)->(44,44)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 29 D(-38,-13)->(54,54)
       fcb 2 ; drawmode 
       fcb 20,0 ; position relative to previous node
; node # 30 D(-31,-13)->(64,64)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 31 D(-28,-9)->(74,74)
       fcb 2 ; drawmode 
       fcb -4,3 ; position relative to previous node
; node # 32 D(-28,6)->(84,84)
       fcb 2 ; drawmode 
       fcb -15,0 ; position relative to previous node
; node # 33 D(-20,6)->(94,94)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 34 D(-20,-12)->(104,104)
       fcb 2 ; drawmode 
       fcb 18,0 ; position relative to previous node
; node # 35 D(-25,-18)->(114,114)
       fcb 2 ; drawmode 
       fcb 6,-5 ; position relative to previous node
; node # 36 D(-21,-24)->(124,124)
       fcb 2 ; drawmode 
       fcb 6,4 ; position relative to previous node
; node # 37 D(-20,-31)->(-122,-122)
       fcb 2 ; drawmode 
       fcb 7,1 ; position relative to previous node
; node # 38 D(-29,-43)->(-112,-112)
       fcb 2 ; drawmode 
       fcb 12,-9 ; position relative to previous node
; node # 39 D(-47,-43)->(-102,-102)
       fcb 2 ; drawmode 
       fcb 0,-18 ; position relative to previous node
; node # 40 M(-38,-33)->(-92,-92)
       fcb 0 ; drawmode 
       fcb -10,9 ; position relative to previous node
; node # 41 D(-38,-23)->(-82,-82)
       fcb 2 ; drawmode 
       fcb -10,0 ; position relative to previous node
; node # 42 D(-28,-28)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 5,10 ; position relative to previous node
; node # 43 D(-38,-33)->(-42,-42)
       fcb 2 ; drawmode 
       fcb 5,-10 ; position relative to previous node
; node # 44 M(-18,-42)->(-32,-32)
       fcb 0 ; drawmode 
       fcb 9,20 ; position relative to previous node
; node # 45 D(-18,6)->(-22,-22)
       fcb 2 ; drawmode 
       fcb -48,0 ; position relative to previous node
; node # 46 D(-2,5)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 1,16 ; position relative to previous node
; node # 47 D(6,-5)->(-2,-2)
       fcb 2 ; drawmode 
       fcb 10,8 ; position relative to previous node
; node # 48 D(6,-14)->(8,8)
       fcb 2 ; drawmode 
       fcb 9,0 ; position relative to previous node
; node # 49 D(2,-18)->(18,18)
       fcb 2 ; drawmode 
       fcb 4,-4 ; position relative to previous node
; node # 50 D(6,-23)->(28,28)
       fcb 2 ; drawmode 
       fcb 5,4 ; position relative to previous node
; node # 51 D(6,-30)->(38,38)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 52 D(-1,-41)->(48,48)
       fcb 2 ; drawmode 
       fcb 11,-7 ; position relative to previous node
; node # 53 D(-18,-42)->(58,58)
       fcb 2 ; drawmode 
       fcb 1,-17 ; position relative to previous node
; node # 54 M(-10,-32)->(68,68)
       fcb 0 ; drawmode 
       fcb -10,8 ; position relative to previous node
; node # 55 D(-10,-23)->(78,78)
       fcb 2 ; drawmode 
       fcb -9,0 ; position relative to previous node
; node # 56 D(0,-27)->(98,98)
       fcb 2 ; drawmode 
       fcb 4,10 ; position relative to previous node
; node # 57 D(-10,-32)->(118,118)
       fcb 2 ; drawmode 
       fcb 5,-10 ; position relative to previous node
; node # 58 M(-10,-13)->(-128,-128)
       fcb 0 ; drawmode 
       fcb -19,0 ; position relative to previous node
; node # 59 D(-10,-4)->(-118,-118)
       fcb 2 ; drawmode 
       fcb -9,0 ; position relative to previous node
; node # 60 D(-1,-9)->(-98,-98)
       fcb 2 ; drawmode 
       fcb 5,9 ; position relative to previous node
; node # 61 D(-10,-13)->(-78,-78)
       fcb 2 ; drawmode 
       fcb 4,-9 ; position relative to previous node
; node # 62 M(8,-41)->(-68,-68)
       fcb 0 ; drawmode 
       fcb 28,18 ; position relative to previous node
; node # 63 D(8,5)->(-58,-58)
       fcb 2 ; drawmode 
       fcb -46,0 ; position relative to previous node
; node # 64 D(15,5)->(-48,-48)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 65 D(15,-13)->(-38,-38)
       fcb 2 ; drawmode 
       fcb 18,0 ; position relative to previous node
; node # 66 D(21,-13)->(-28,-28)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 67 D(23,-10)->(-18,-18)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 68 D(23,4)->(-8,-8)
       fcb 2 ; drawmode 
       fcb -14,0 ; position relative to previous node
; node # 69 D(29,4)->(2,2)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 70 D(29,-13)->(12,12)
       fcb 2 ; drawmode 
       fcb 17,0 ; position relative to previous node
; node # 71 D(26,-18)->(22,22)
       fcb 2 ; drawmode 
       fcb 5,-3 ; position relative to previous node
; node # 72 D(30,-22)->(32,32)
       fcb 2 ; drawmode 
       fcb 4,4 ; position relative to previous node
; node # 73 D(30,-30)->(42,42)
       fcb 2 ; drawmode 
       fcb 8,0 ; position relative to previous node
; node # 74 D(23,-40)->(52,52)
       fcb 2 ; drawmode 
       fcb 10,-7 ; position relative to previous node
; node # 75 D(8,-41)->(62,62)
       fcb 2 ; drawmode 
       fcb 1,-15 ; position relative to previous node
; node # 76 M(15,-31)->(72,72)
       fcb 0 ; drawmode 
       fcb -10,7 ; position relative to previous node
; node # 77 D(15,-23)->(82,82)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 78 D(24,-26)->(102,102)
       fcb 2 ; drawmode 
       fcb 3,9 ; position relative to previous node
; node # 79 D(15,-31)->(122,122)
       fcb 2 ; drawmode 
       fcb 5,-9 ; position relative to previous node
; node # 80 M(38,-39)->(72,72)
       fcb 0 ; drawmode 
       fcb 8,23 ; position relative to previous node
; node # 81 D(32,-30)->(82,82)
       fcb 2 ; drawmode 
       fcb -9,-6 ; position relative to previous node
; node # 82 D(32,4)->(92,92)
       fcb 2 ; drawmode 
       fcb -34,0 ; position relative to previous node
; node # 83 D(38,4)->(102,102)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 84 D(38,-13)->(112,112)
       fcb 2 ; drawmode 
       fcb 17,0 ; position relative to previous node
; node # 85 D(45,-13)->(122,122)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 86 D(45,3)->(-124,-124)
       fcb 2 ; drawmode 
       fcb -16,0 ; position relative to previous node
; node # 87 D(51,3)->(-114,-114)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 88 D(51,-30)->(-104,-104)
       fcb 2 ; drawmode 
       fcb 33,0 ; position relative to previous node
; node # 89 D(44,-39)->(-94,-94)
       fcb 2 ; drawmode 
       fcb 9,-7 ; position relative to previous node
; node # 90 D(38,-39)->(-84,-84)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 91 M(42,-31)->(-74,-74)
       fcb 0 ; drawmode 
       fcb -8,4 ; position relative to previous node
; node # 92 D(38,-22)->(-54,-54)
       fcb 2 ; drawmode 
       fcb -9,-4 ; position relative to previous node
; node # 93 D(45,-22)->(-44,-44)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 94 D(42,-30)->(-24,-24)
       fcb 2 ; drawmode 
       fcb 8,-3 ; position relative to previous node
; node # 95 M(53,-38)->(-14,-14)
       fcb 0 ; drawmode 
       fcb 8,11 ; position relative to previous node
; node # 96 D(53,-6)->(-4,-4)
       fcb 2 ; drawmode 
       fcb -32,0 ; position relative to previous node
; node # 97 D(59,3)->(6,6)
       fcb 2 ; drawmode 
       fcb -9,6 ; position relative to previous node
; node # 98 D(65,3)->(16,16)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 99 D(71,-6)->(26,26)
       fcb 2 ; drawmode 
       fcb 9,6 ; position relative to previous node
; node # 100 D(71,-37)->(36,36)
       fcb 2 ; drawmode 
       fcb 31,0 ; position relative to previous node
; node # 101 D(65,-37)->(46,46)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 102 D(65,-9)->(56,56)
       fcb 2 ; drawmode 
       fcb -28,0 ; position relative to previous node
; node # 103 D(62,-5)->(66,66)
       fcb 2 ; drawmode 
       fcb -4,-3 ; position relative to previous node
; node # 104 D(59,-9)->(76,76)
       fcb 2 ; drawmode 
       fcb 4,-3 ; position relative to previous node
; node # 105 D(59,-38)->(86,86)
       fcb 2 ; drawmode 
       fcb 29,0 ; position relative to previous node
; node # 106 D(53,-38)->(96,96)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 107 M(79,-36)->(106,106)
       fcb 0 ; drawmode 
       fcb -2,26 ; position relative to previous node
; node # 108 D(73,-30)->(116,116)
       fcb 2 ; drawmode 
       fcb -6,-6 ; position relative to previous node
; node # 109 D(73,-22)->(126,126)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 110 D(78,-14)->(-120,-120)
       fcb 2 ; drawmode 
       fcb -8,5 ; position relative to previous node
; node # 111 D(82,-13)->(-110,-110)
       fcb 2 ; drawmode 
       fcb -1,4 ; position relative to previous node
; node # 112 D(84,-10)->(-100,-100)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 113 D(82,-6)->(-90,-90)
       fcb 2 ; drawmode 
       fcb -4,-2 ; position relative to previous node
; node # 114 D(73,-6)->(-80,-80)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 115 D(73,2)->(-70,-70)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 116 D(83,2)->(-60,-60)
       fcb 2 ; drawmode 
       fcb 0,10 ; position relative to previous node
; node # 117 D(89,-6)->(-50,-50)
       fcb 2 ; drawmode 
       fcb 8,6 ; position relative to previous node
; node # 118 D(89,-13)->(-40,-40)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 119 D(84,-20)->(-30,-30)
       fcb 2 ; drawmode 
       fcb 7,-5 ; position relative to previous node
; node # 120 D(80,-21)->(-20,-20)
       fcb 2 ; drawmode 
       fcb 1,-4 ; position relative to previous node
; node # 121 D(78,-24)->(-10,-10)
       fcb 2 ; drawmode 
       fcb 3,-2 ; position relative to previous node
; node # 122 D(80,-28)->(0,0)
       fcb 2 ; drawmode 
       fcb 4,2 ; position relative to previous node
; node # 123 D(89,-28)->(10,10)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 124 D(89,-36)->(20,20)
       fcb 2 ; drawmode 
       fcb 8,0 ; position relative to previous node
; node # 125 D(78,-36)->(30,30)
       fcb 2 ; drawmode 
       fcb 0,-11 ; position relative to previous node
; node # 126 M(95,-35)->(40,40)
       fcb 0 ; drawmode 
       fcb -1,17 ; position relative to previous node
; node # 127 D(90,-28)->(50,50)
       fcb 2 ; drawmode 
       fcb -7,-5 ; position relative to previous node
; node # 128 D(90,-7)->(60,60)
       fcb 2 ; drawmode 
       fcb -21,0 ; position relative to previous node
; node # 129 D(95,1)->(70,70)
       fcb 2 ; drawmode 
       fcb -8,5 ; position relative to previous node
; node # 130 D(105,1)->(80,80)
       fcb 2 ; drawmode 
       fcb 0,10 ; position relative to previous node
; node # 131 D(105,-6)->(90,90)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 132 D(97,-6)->(100,100)
       fcb 2 ; drawmode 
       fcb 0,-8 ; position relative to previous node
; node # 133 D(95,-8)->(110,110)
       fcb 2 ; drawmode 
       fcb 2,-2 ; position relative to previous node
; node # 134 D(95,-24)->(120,120)
       fcb 2 ; drawmode 
       fcb 16,0 ; position relative to previous node
; node # 135 D(97,-28)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 4,2 ; position relative to previous node
; node # 136 D(105,-28)->(-116,-116)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 137 D(105,-35)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 138 D(95,-35)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 0,-10 ; position relative to previous node
; node # 139 M(107,-35)->(-86,-86)
       fcb 0 ; drawmode 
       fcb 0,12 ; position relative to previous node
; node # 140 D(107,1)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -36,0 ; position relative to previous node
; node # 141 D(111,1)->(-66,-66)
       fcb 2 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 142 D(111,-13)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 14,0 ; position relative to previous node
; node # 143 D(115,-13)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 144 D(115,0)->(-36,-36)
       fcb 2 ; drawmode 
       fcb -13,0 ; position relative to previous node
; node # 145 D(120,0)->(-26,-26)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 146 D(120,-34)->(-16,-16)
       fcb 2 ; drawmode 
       fcb 34,0 ; position relative to previous node
; node # 147 D(116,-34)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 148 D(116,-20)->(4,4)
       fcb 2 ; drawmode 
       fcb -14,0 ; position relative to previous node
; node # 149 D(111,-20)->(14,14)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 150 D(111,-35)->(24,24)
       fcb 2 ; drawmode 
       fcb 15,0 ; position relative to previous node
; node # 151 D(107,-35)->(34,34)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 4
greetsframe4:
; node # 0 M(42,-5)->(0,0)
       fcb 0 ; drawmode 
       fcb 5,42 ; position relative to previous node
; node # 1 D(52,-3)->(10,10)
       fcb 2 ; drawmode 
       fcb -2,10 ; position relative to previous node
; node # 2 D(56,2)->(20,20)
       fcb 2 ; drawmode 
       fcb -5,4 ; position relative to previous node
; node # 3 D(56,17)->(30,30)
       fcb 2 ; drawmode 
       fcb -15,0 ; position relative to previous node
; node # 4 D(52,17)->(40,40)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 5 D(52,3)->(50,50)
       fcb 2 ; drawmode 
       fcb 14,0 ; position relative to previous node
; node # 6 D(50,1)->(60,60)
       fcb 2 ; drawmode 
       fcb 2,-2 ; position relative to previous node
; node # 7 D(47,0)->(70,70)
       fcb 2 ; drawmode 
       fcb 1,-3 ; position relative to previous node
; node # 8 D(47,17)->(80,80)
       fcb 2 ; drawmode 
       fcb -17,0 ; position relative to previous node
; node # 9 D(42,17)->(90,90)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 10 D(42,-5)->(100,100)
       fcb 2 ; drawmode 
       fcb 22,0 ; position relative to previous node
; node # 11 M(40,-5)->(110,110)
       fcb 0 ; drawmode 
       fcb 0,-2 ; position relative to previous node
; node # 12 D(40,-1)->(120,120)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 13 D(28,-3)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 2,-12 ; position relative to previous node
; node # 14 D(28,2)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 15 D(36,3)->(-106,-106)
       fcb 2 ; drawmode 
       fcb -1,8 ; position relative to previous node
; node # 16 D(36,8)->(-96,-96)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 17 D(29,7)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 1,-7 ; position relative to previous node
; node # 18 D(29,11)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 19 D(40,13)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -2,11 ; position relative to previous node
; node # 20 D(40,17)->(-56,-56)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 21 D(23,16)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 1,-17 ; position relative to previous node
; node # 22 D(23,-9)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 25,0 ; position relative to previous node
; node # 23 D(40,-5)->(-26,-26)
       fcb 2 ; drawmode 
       fcb -4,17 ; position relative to previous node
; node # 24 M(20,-9)->(-16,-16)
       fcb 0 ; drawmode 
       fcb 4,-20 ; position relative to previous node
; node # 25 D(20,16)->(-6,-6)
       fcb 2 ; drawmode 
       fcb -25,0 ; position relative to previous node
; node # 26 D(13,16)->(4,4)
       fcb 2 ; drawmode 
       fcb 0,-7 ; position relative to previous node
; node # 27 D(13,-3)->(14,14)
       fcb 2 ; drawmode 
       fcb 19,0 ; position relative to previous node
; node # 28 D(9,-1)->(24,24)
       fcb 2 ; drawmode 
       fcb -2,-4 ; position relative to previous node
; node # 29 D(5,-5)->(34,34)
       fcb 2 ; drawmode 
       fcb 4,-4 ; position relative to previous node
; node # 30 D(5,15)->(44,44)
       fcb 2 ; drawmode 
       fcb -20,0 ; position relative to previous node
; node # 31 D(-4,15)->(54,54)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 32 D(-4,-15)->(64,64)
       fcb 2 ; drawmode 
       fcb 30,0 ; position relative to previous node
; node # 33 D(6,-12)->(74,74)
       fcb 2 ; drawmode 
       fcb -3,10 ; position relative to previous node
; node # 34 D(9,-9)->(84,84)
       fcb 2 ; drawmode 
       fcb -3,3 ; position relative to previous node
; node # 35 D(14,-11)->(94,94)
       fcb 2 ; drawmode 
       fcb 2,5 ; position relative to previous node
; node # 36 D(20,-9)->(104,104)
       fcb 2 ; drawmode 
       fcb -2,6 ; position relative to previous node
; node # 37 M(-6,-15)->(114,114)
       fcb 0 ; drawmode 
       fcb 6,-26 ; position relative to previous node
; node # 38 D(-6,-9)->(124,124)
       fcb 2 ; drawmode 
       fcb -6,0 ; position relative to previous node
; node # 39 D(-16,-11)->(-122,-122)
       fcb 2 ; drawmode 
       fcb 2,-10 ; position relative to previous node
; node # 40 D(-16,14)->(-112,-112)
       fcb 2 ; drawmode 
       fcb -25,0 ; position relative to previous node
; node # 41 D(-27,14)->(-102,-102)
       fcb 2 ; drawmode 
       fcb 0,-11 ; position relative to previous node
; node # 42 D(-27,-12)->(-92,-92)
       fcb 2 ; drawmode 
       fcb 26,0 ; position relative to previous node
; node # 43 D(-39,-14)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 2,-12 ; position relative to previous node
; node # 44 D(-39,-21)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 45 D(-6,-15)->(-62,-62)
       fcb 2 ; drawmode 
       fcb -6,33 ; position relative to previous node
; node # 46 M(-43,-22)->(-52,-52)
       fcb 0 ; drawmode 
       fcb 7,-37 ; position relative to previous node
; node # 47 D(-43,14)->(-42,-42)
       fcb 2 ; drawmode 
       fcb -36,0 ; position relative to previous node
; node # 48 D(-57,13)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 1,-14 ; position relative to previous node
; node # 49 D(-57,-25)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 38,0 ; position relative to previous node
; node # 50 D(-43,-22)->(-12,-12)
       fcb 2 ; drawmode 
       fcb -3,14 ; position relative to previous node
; node # 51 M(-61,-25)->(-2,-2)
       fcb 0 ; drawmode 
       fcb 3,-18 ; position relative to previous node
; node # 52 D(-61,13)->(8,8)
       fcb 2 ; drawmode 
       fcb -38,0 ; position relative to previous node
; node # 53 D(-77,12)->(18,18)
       fcb 2 ; drawmode 
       fcb 1,-16 ; position relative to previous node
; node # 54 D(-78,-4)->(28,28)
       fcb 2 ; drawmode 
       fcb 16,-1 ; position relative to previous node
; node # 55 D(-99,-7)->(38,38)
       fcb 2 ; drawmode 
       fcb 3,-21 ; position relative to previous node
; node # 56 D(-99,11)->(48,48)
       fcb 2 ; drawmode 
       fcb -18,0 ; position relative to previous node
; node # 57 D(-121,11)->(58,58)
       fcb 2 ; drawmode 
       fcb 0,-22 ; position relative to previous node
; node # 58 D(-121,-38)->(68,68)
       fcb 2 ; drawmode 
       fcb 49,0 ; position relative to previous node
; node # 59 D(-99,-33)->(78,78)
       fcb 2 ; drawmode 
       fcb -5,22 ; position relative to previous node
; node # 60 D(-99,-16)->(88,88)
       fcb 2 ; drawmode 
       fcb -17,0 ; position relative to previous node
; node # 61 D(-77,-13)->(98,98)
       fcb 2 ; drawmode 
       fcb -3,22 ; position relative to previous node
; node # 62 D(-77,-29)->(108,108)
       fcb 2 ; drawmode 
       fcb 16,0 ; position relative to previous node
; node # 63 D(-61,-25)->(118,118)
       fcb 2 ; drawmode 
       fcb -4,16 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 5
greetsframe5:
; node # 0 M(108,-73)->(0,0)
       fcb 0 ; drawmode 
       fcb 73,108 ; position relative to previous node
; node # 1 D(110,-54)->(10,10)
       fcb 2 ; drawmode 
       fcb -19,2 ; position relative to previous node
; node # 2 D(63,-51)->(20,20)
       fcb 2 ; drawmode 
       fcb -3,-47 ; position relative to previous node
; node # 3 D(65,-36)->(30,30)
       fcb 2 ; drawmode 
       fcb -15,2 ; position relative to previous node
; node # 4 D(90,-36)->(40,40)
       fcb 2 ; drawmode 
       fcb 0,25 ; position relative to previous node
; node # 5 D(92,-19)->(50,50)
       fcb 2 ; drawmode 
       fcb -17,2 ; position relative to previous node
; node # 6 D(67,-19)->(60,60)
       fcb 2 ; drawmode 
       fcb 0,-25 ; position relative to previous node
; node # 7 D(69,-4)->(70,70)
       fcb 2 ; drawmode 
       fcb -15,2 ; position relative to previous node
; node # 8 D(116,-1)->(80,80)
       fcb 2 ; drawmode 
       fcb -3,47 ; position relative to previous node
; node # 9 D(117,16)->(90,90)
       fcb 2 ; drawmode 
       fcb -17,1 ; position relative to previous node
; node # 10 D(53,9)->(100,100)
       fcb 2 ; drawmode 
       fcb 7,-64 ; position relative to previous node
; node # 11 D(43,-66)->(110,110)
       fcb 2 ; drawmode 
       fcb 75,-10 ; position relative to previous node
; node # 12 D(108,-73)->(120,120)
       fcb 2 ; drawmode 
       fcb 7,65 ; position relative to previous node
; node # 13 M(38,-65)->(-126,-126)
       fcb 0 ; drawmode 
       fcb -8,-70 ; position relative to previous node
; node # 14 D(40,-49)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -16,2 ; position relative to previous node
; node # 15 D(13,-48)->(-106,-106)
       fcb 2 ; drawmode 
       fcb -1,-27 ; position relative to previous node
; node # 16 D(8,-42)->(-96,-96)
       fcb 2 ; drawmode 
       fcb -6,-5 ; position relative to previous node
; node # 17 D(12,-14)->(-86,-86)
       fcb 2 ; drawmode 
       fcb -28,4 ; position relative to previous node
; node # 18 D(19,-7)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -7,7 ; position relative to previous node
; node # 19 D(45,-6)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -1,26 ; position relative to previous node
; node # 20 D(48,9)->(-56,-56)
       fcb 2 ; drawmode 
       fcb -15,3 ; position relative to previous node
; node # 21 D(16,5)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 4,-32 ; position relative to previous node
; node # 22 D(0,-10)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 15,-16 ; position relative to previous node
; node # 23 D(-6,-46)->(-26,-26)
       fcb 2 ; drawmode 
       fcb 36,-6 ; position relative to previous node
; node # 24 D(6,-62)->(-16,-16)
       fcb 2 ; drawmode 
       fcb 16,12 ; position relative to previous node
; node # 25 D(38,-65)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 3,32 ; position relative to previous node
; node # 26 M(-9,-45)->(4,4)
       fcb 0 ; drawmode 
       fcb -20,-47 ; position relative to previous node
; node # 27 D(-2,3)->(14,14)
       fcb 2 ; drawmode 
       fcb -48,7 ; position relative to previous node
; node # 28 D(-14,2)->(24,24)
       fcb 2 ; drawmode 
       fcb 1,-12 ; position relative to previous node
; node # 29 D(-21,-40)->(34,34)
       fcb 2 ; drawmode 
       fcb 42,-7 ; position relative to previous node
; node # 30 D(-26,-46)->(44,44)
       fcb 2 ; drawmode 
       fcb 6,-5 ; position relative to previous node
; node # 31 D(-34,-45)->(54,54)
       fcb 2 ; drawmode 
       fcb -1,-8 ; position relative to previous node
; node # 32 D(-26,1)->(64,64)
       fcb 2 ; drawmode 
       fcb -46,8 ; position relative to previous node
; node # 33 D(-36,-1)->(74,74)
       fcb 2 ; drawmode 
       fcb 2,-10 ; position relative to previous node
; node # 34 D(-46,-56)->(84,84)
       fcb 2 ; drawmode 
       fcb 55,-10 ; position relative to previous node
; node # 35 D(-25,-58)->(94,94)
       fcb 2 ; drawmode 
       fcb 2,21 ; position relative to previous node
; node # 36 D(-9,-45)->(104,104)
       fcb 2 ; drawmode 
       fcb -13,16 ; position relative to previous node
; node # 37 M(-47,-44)->(114,114)
       fcb 0 ; drawmode 
       fcb -1,-38 ; position relative to previous node
; node # 38 D(-39,-1)->(124,124)
       fcb 2 ; drawmode 
       fcb -43,8 ; position relative to previous node
; node # 39 D(-49,-2)->(-122,-122)
       fcb 2 ; drawmode 
       fcb 1,-10 ; position relative to previous node
; node # 40 D(-52,-23)->(-112,-112)
       fcb 2 ; drawmode 
       fcb 21,-3 ; position relative to previous node
; node # 41 D(-61,-23)->(-102,-102)
       fcb 2 ; drawmode 
       fcb 0,-9 ; position relative to previous node
; node # 42 D(-58,-3)->(-92,-92)
       fcb 2 ; drawmode 
       fcb -20,3 ; position relative to previous node
; node # 43 D(-66,-4)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 1,-8 ; position relative to previous node
; node # 44 D(-73,-42)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 38,-7 ; position relative to previous node
; node # 45 D(-66,-54)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 12,7 ; position relative to previous node
; node # 46 D(-58,-55)->(-52,-52)
       fcb 2 ; drawmode 
       fcb 1,8 ; position relative to previous node
; node # 47 D(-47,-44)->(-42,-42)
       fcb 2 ; drawmode 
       fcb -11,11 ; position relative to previous node
; node # 48 M(-54,-38)->(-32,-32)
       fcb 0 ; drawmode 
       fcb -6,-7 ; position relative to previous node
; node # 49 D(-53,-33)->(-22,-22)
       fcb 2 ; drawmode 
       fcb -5,1 ; position relative to previous node
; node # 50 D(-64,-33)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 0,-11 ; position relative to previous node
; node # 51 D(-65,-39)->(-2,-2)
       fcb 2 ; drawmode 
       fcb 6,-1 ; position relative to previous node
; node # 52 D(-61,-45)->(8,8)
       fcb 2 ; drawmode 
       fcb 6,4 ; position relative to previous node
; node # 53 D(-54,-38)->(18,18)
       fcb 2 ; drawmode 
       fcb -7,7 ; position relative to previous node
; node # 54 M(-78,-53)->(28,28)
       fcb 0 ; drawmode 
       fcb 15,-24 ; position relative to previous node
; node # 55 D(-70,-15)->(38,38)
       fcb 2 ; drawmode 
       fcb -38,8 ; position relative to previous node
; node # 56 D(-76,-5)->(48,48)
       fcb 2 ; drawmode 
       fcb -10,-6 ; position relative to previous node
; node # 57 D(-82,-5)->(58,58)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 58 D(-91,-16)->(68,68)
       fcb 2 ; drawmode 
       fcb 11,-9 ; position relative to previous node
; node # 59 D(-98,-50)->(78,78)
       fcb 2 ; drawmode 
       fcb 34,-7 ; position relative to previous node
; node # 60 D(-92,-51)->(88,88)
       fcb 2 ; drawmode 
       fcb 1,6 ; position relative to previous node
; node # 61 D(-86,-19)->(98,98)
       fcb 2 ; drawmode 
       fcb -32,6 ; position relative to previous node
; node # 62 D(-81,-13)->(108,108)
       fcb 2 ; drawmode 
       fcb -6,5 ; position relative to previous node
; node # 63 D(-78,-19)->(118,118)
       fcb 2 ; drawmode 
       fcb 6,3 ; position relative to previous node
; node # 64 D(-85,-52)->(-128,-128)
       fcb 2 ; drawmode 
       fcb 33,-7 ; position relative to previous node
; node # 65 D(-77,-53)->(-118,-118)
       fcb 2 ; drawmode 
       fcb 1,8 ; position relative to previous node
; node # 66 M(-98,-40)->(-108,-108)
       fcb 0 ; drawmode 
       fcb -13,-21 ; position relative to previous node
; node # 67 D(-91,-6)->(-98,-98)
       fcb 2 ; drawmode 
       fcb -34,7 ; position relative to previous node
; node # 68 D(-97,-7)->(-88,-88)
       fcb 2 ; drawmode 
       fcb 1,-6 ; position relative to previous node
; node # 69 D(-103,-38)->(-78,-78)
       fcb 2 ; drawmode 
       fcb 31,-6 ; position relative to previous node
; node # 70 D(-106,-41)->(-68,-68)
       fcb 2 ; drawmode 
       fcb 3,-3 ; position relative to previous node
; node # 71 D(-110,-41)->(-58,-58)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 72 D(-103,-7)->(-48,-48)
       fcb 2 ; drawmode 
       fcb -34,7 ; position relative to previous node
; node # 73 D(-109,-8)->(-38,-38)
       fcb 2 ; drawmode 
       fcb 1,-6 ; position relative to previous node
; node # 74 D(-117,-48)->(-28,-28)
       fcb 2 ; drawmode 
       fcb 40,-8 ; position relative to previous node
; node # 75 D(-106,-49)->(-18,-18)
       fcb 2 ; drawmode 
       fcb 1,11 ; position relative to previous node
; node # 76 D(-97,-39)->(-8,-8)
       fcb 2 ; drawmode 
       fcb -10,9 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 6
greetsframe6:
; node # 0 M(-50,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,-50 ; position relative to previous node
; node # 1 D(-50,9)->(10,10)
       fcb 2 ; drawmode 
       fcb -9,0 ; position relative to previous node
; node # 2 D(-73,25)->(20,20)
       fcb 2 ; drawmode 
       fcb -16,-23 ; position relative to previous node
; node # 3 D(-96,29)->(30,30)
       fcb 2 ; drawmode 
       fcb -4,-23 ; position relative to previous node
; node # 4 D(-98,52)->(40,40)
       fcb 2 ; drawmode 
       fcb -23,-2 ; position relative to previous node
; node # 5 D(-124,60)->(50,50)
       fcb 2 ; drawmode 
       fcb -8,-26 ; position relative to previous node
; node # 6 D(-118,-5)->(60,60)
       fcb 2 ; drawmode 
       fcb 65,6 ; position relative to previous node
; node # 7 D(-68,-9)->(70,70)
       fcb 2 ; drawmode 
       fcb 4,50 ; position relative to previous node
; node # 8 D(-50,0)->(80,80)
       fcb 2 ; drawmode 
       fcb -9,18 ; position relative to previous node
; node # 9 M(-77,3)->(90,90)
       fcb 0 ; drawmode 
       fcb -3,-27 ; position relative to previous node
; node # 10 D(-93,5)->(100,100)
       fcb 2 ; drawmode 
       fcb -2,-16 ; position relative to previous node
; node # 11 D(-94,17)->(110,110)
       fcb 2 ; drawmode 
       fcb -12,-1 ; position relative to previous node
; node # 12 D(-77,14)->(120,120)
       fcb 2 ; drawmode 
       fcb 3,17 ; position relative to previous node
; node # 13 D(-67,8)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 6,10 ; position relative to previous node
; node # 14 D(-77,3)->(-116,-116)
       fcb 2 ; drawmode 
       fcb 5,-10 ; position relative to previous node
; node # 15 M(-43,-10)->(-106,-106)
       fcb 0 ; drawmode 
       fcb 13,34 ; position relative to previous node
; node # 16 D(-50,39)->(-96,-96)
       fcb 2 ; drawmode 
       fcb -49,-7 ; position relative to previous node
; node # 17 D(-7,27)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 12,43 ; position relative to previous node
; node # 18 D(-6,19)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 8,1 ; position relative to previous node
; node # 19 D(-33,26)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -7,-27 ; position relative to previous node
; node # 20 D(-28,-12)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 38,5 ; position relative to previous node
; node # 21 D(-43,-11)->(-46,-46)
       fcb 2 ; drawmode 
       fcb -1,-15 ; position relative to previous node
; node # 22 M(2,-14)->(-36,-36)
       fcb 0 ; drawmode 
       fcb 3,45 ; position relative to previous node
; node # 23 D(-2,18)->(-26,-26)
       fcb 2 ; drawmode 
       fcb -32,-4 ; position relative to previous node
; node # 24 D(7,23)->(-16,-16)
       fcb 2 ; drawmode 
       fcb -5,9 ; position relative to previous node
; node # 25 D(16,21)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 2,9 ; position relative to previous node
; node # 26 D(26,11)->(4,4)
       fcb 2 ; drawmode 
       fcb 10,10 ; position relative to previous node
; node # 27 D(31,-16)->(14,14)
       fcb 2 ; drawmode 
       fcb 27,5 ; position relative to previous node
; node # 28 D(23,-16)->(24,24)
       fcb 2 ; drawmode 
       fcb 0,-8 ; position relative to previous node
; node # 29 D(18,11)->(34,34)
       fcb 2 ; drawmode 
       fcb -27,-5 ; position relative to previous node
; node # 30 D(12,15)->(44,44)
       fcb 2 ; drawmode 
       fcb -4,-6 ; position relative to previous node
; node # 31 D(8,13)->(54,54)
       fcb 2 ; drawmode 
       fcb 2,-4 ; position relative to previous node
; node # 32 D(13,-15)->(64,64)
       fcb 2 ; drawmode 
       fcb 28,5 ; position relative to previous node
; node # 33 D(1,-14)->(74,74)
       fcb 2 ; drawmode 
       fcb -1,-12 ; position relative to previous node
; node # 34 M(32,-9)->(84,84)
       fcb 0 ; drawmode 
       fcb -5,31 ; position relative to previous node
; node # 35 D(31,-3)->(94,94)
       fcb 2 ; drawmode 
       fcb -6,-1 ; position relative to previous node
; node # 36 D(38,2)->(104,104)
       fcb 2 ; drawmode 
       fcb -5,7 ; position relative to previous node
; node # 37 D(43,2)->(114,114)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 38 D(44,4)->(124,124)
       fcb 2 ; drawmode 
       fcb -2,1 ; position relative to previous node
; node # 39 D(41,8)->(-122,-122)
       fcb 2 ; drawmode 
       fcb -4,-3 ; position relative to previous node
; node # 40 D(28,11)->(-112,-112)
       fcb 2 ; drawmode 
       fcb -3,-13 ; position relative to previous node
; node # 41 D(27,18)->(-102,-102)
       fcb 2 ; drawmode 
       fcb -7,-1 ; position relative to previous node
; node # 42 D(42,13)->(-92,-92)
       fcb 2 ; drawmode 
       fcb 5,15 ; position relative to previous node
; node # 43 D(49,5)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 8,7 ; position relative to previous node
; node # 44 D(50,0)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 5,1 ; position relative to previous node
; node # 45 D(45,-5)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 5,-5 ; position relative to previous node
; node # 46 D(41,-5)->(-52,-52)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 47 D(37,-7)->(-42,-42)
       fcb 2 ; drawmode 
       fcb 2,-4 ; position relative to previous node
; node # 48 D(42,-11)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 49 D(52,-12)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 1,10 ; position relative to previous node
; node # 50 D(53,-18)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 6,1 ; position relative to previous node
; node # 51 D(41,-17)->(-2,-2)
       fcb 2 ; drawmode 
       fcb -1,-12 ; position relative to previous node
; node # 52 D(32,-9)->(8,8)
       fcb 2 ; drawmode 
       fcb -8,-9 ; position relative to previous node
; node # 53 M(55,-18)->(18,18)
       fcb 0 ; drawmode 
       fcb 9,23 ; position relative to previous node
; node # 54 D(50,11)->(28,28)
       fcb 2 ; drawmode 
       fcb -29,-5 ; position relative to previous node
; node # 55 D(56,9)->(38,38)
       fcb 2 ; drawmode 
       fcb 2,6 ; position relative to previous node
; node # 56 D(58,-2)->(48,48)
       fcb 2 ; drawmode 
       fcb 11,2 ; position relative to previous node
; node # 57 D(63,-3)->(58,58)
       fcb 2 ; drawmode 
       fcb 1,5 ; position relative to previous node
; node # 58 D(61,8)->(68,68)
       fcb 2 ; drawmode 
       fcb -11,-2 ; position relative to previous node
; node # 59 D(65,7)->(78,78)
       fcb 2 ; drawmode 
       fcb 1,4 ; position relative to previous node
; node # 60 D(71,-19)->(88,88)
       fcb 2 ; drawmode 
       fcb 26,6 ; position relative to previous node
; node # 61 D(66,-19)->(98,98)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 62 D(64,-8)->(108,108)
       fcb 2 ; drawmode 
       fcb -11,-2 ; position relative to previous node
; node # 63 D(59,-7)->(118,118)
       fcb 2 ; drawmode 
       fcb -1,-5 ; position relative to previous node
; node # 64 D(61,-18)->(-128,-128)
       fcb 2 ; drawmode 
       fcb 11,2 ; position relative to previous node
; node # 65 D(55,-18)->(-118,-118)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 7
greetsframe7:
; node # 0 M(57,-11)->(0,0)
       fcb 0 ; drawmode 
       fcb 11,57 ; position relative to previous node
; node # 1 D(75,-14)->(10,10)
       fcb 2 ; drawmode 
       fcb 3,18 ; position relative to previous node
; node # 2 D(85,-8)->(20,20)
       fcb 2 ; drawmode 
       fcb -6,10 ; position relative to previous node
; node # 3 D(96,-17)->(30,30)
       fcb 2 ; drawmode 
       fcb 9,11 ; position relative to previous node
; node # 4 D(121,-20)->(40,40)
       fcb 2 ; drawmode 
       fcb 3,25 ; position relative to previous node
; node # 5 D(118,50)->(50,50)
       fcb 2 ; drawmode 
       fcb -70,-3 ; position relative to previous node
; node # 6 D(96,48)->(60,60)
       fcb 2 ; drawmode 
       fcb 2,-22 ; position relative to previous node
; node # 7 D(97,0)->(70,70)
       fcb 2 ; drawmode 
       fcb 48,1 ; position relative to previous node
; node # 8 D(85,8)->(80,80)
       fcb 2 ; drawmode 
       fcb -8,-12 ; position relative to previous node
; node # 9 D(74,1)->(90,90)
       fcb 2 ; drawmode 
       fcb 7,-11 ; position relative to previous node
; node # 10 D(75,46)->(100,100)
       fcb 2 ; drawmode 
       fcb -45,1 ; position relative to previous node
; node # 11 D(57,45)->(110,110)
       fcb 2 ; drawmode 
       fcb 1,-18 ; position relative to previous node
; node # 12 D(57,-11)->(120,120)
       fcb 2 ; drawmode 
       fcb 56,0 ; position relative to previous node
; node # 13 M(53,-10)->(-126,-126)
       fcb 0 ; drawmode 
       fcb -1,-4 ; position relative to previous node
; node # 14 D(54,45)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -55,1 ; position relative to previous node
; node # 15 D(39,44)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 1,-15 ; position relative to previous node
; node # 16 D(38,5)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 39,-1 ; position relative to previous node
; node # 17 D(30,12)->(-86,-86)
       fcb 2 ; drawmode 
       fcb -7,-8 ; position relative to previous node
; node # 18 D(23,6)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 6,-7 ; position relative to previous node
; node # 19 D(25,43)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -37,2 ; position relative to previous node
; node # 20 D(13,43)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 0,-12 ; position relative to previous node
; node # 21 D(10,-5)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 48,-3 ; position relative to previous node
; node # 22 D(23,-6)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 1,13 ; position relative to previous node
; node # 23 D(30,-2)->(-26,-26)
       fcb 2 ; drawmode 
       fcb -4,7 ; position relative to previous node
; node # 24 D(36,-8)->(-16,-16)
       fcb 2 ; drawmode 
       fcb 6,6 ; position relative to previous node
; node # 25 D(53,-10)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 2,17 ; position relative to previous node
; node # 26 M(7,-5)->(4,4)
       fcb 0 ; drawmode 
       fcb -5,-46 ; position relative to previous node
; node # 27 D(9,32)->(14,14)
       fcb 2 ; drawmode 
       fcb -37,2 ; position relative to previous node
; node # 28 D(-1,42)->(24,24)
       fcb 2 ; drawmode 
       fcb -10,-10 ; position relative to previous node
; node # 29 D(-11,41)->(34,34)
       fcb 2 ; drawmode 
       fcb 1,-10 ; position relative to previous node
; node # 30 D(-21,32)->(44,44)
       fcb 2 ; drawmode 
       fcb 9,-10 ; position relative to previous node
; node # 31 D(-22,-1)->(54,54)
       fcb 2 ; drawmode 
       fcb 33,-1 ; position relative to previous node
; node # 32 D(-14,-2)->(64,64)
       fcb 2 ; drawmode 
       fcb 1,8 ; position relative to previous node
; node # 33 D(-12,29)->(74,74)
       fcb 2 ; drawmode 
       fcb -31,2 ; position relative to previous node
; node # 34 D(-7,34)->(84,84)
       fcb 2 ; drawmode 
       fcb -5,5 ; position relative to previous node
; node # 35 D(-1,29)->(94,94)
       fcb 2 ; drawmode 
       fcb 5,6 ; position relative to previous node
; node # 36 D(-3,-3)->(104,104)
       fcb 2 ; drawmode 
       fcb 32,-2 ; position relative to previous node
; node # 37 D(7,-5)->(114,114)
       fcb 2 ; drawmode 
       fcb 2,10 ; position relative to previous node
; node # 38 M(-25,9)->(124,124)
       fcb 0 ; drawmode 
       fcb -14,-32 ; position relative to previous node
; node # 39 D(-24,17)->(-122,-122)
       fcb 2 ; drawmode 
       fcb -8,1 ; position relative to previous node
; node # 40 D(-29,20)->(-112,-112)
       fcb 2 ; drawmode 
       fcb -3,-5 ; position relative to previous node
; node # 41 D(-24,24)->(-102,-102)
       fcb 2 ; drawmode 
       fcb -4,5 ; position relative to previous node
; node # 42 D(-22,40)->(-92,-92)
       fcb 2 ; drawmode 
       fcb -16,2 ; position relative to previous node
; node # 43 D(-30,40)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 0,-8 ; position relative to previous node
; node # 44 D(-31,27)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 13,-1 ; position relative to previous node
; node # 45 D(-34,25)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 2,-3 ; position relative to previous node
; node # 46 D(-39,25)->(-52,-52)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 47 D(-38,39)->(-42,-42)
       fcb 2 ; drawmode 
       fcb -14,1 ; position relative to previous node
; node # 48 D(-45,39)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 0,-7 ; position relative to previous node
; node # 49 D(-48,3)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 36,-3 ; position relative to previous node
; node # 50 D(-33,1)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 2,15 ; position relative to previous node
; node # 51 D(-25,9)->(-2,-2)
       fcb 2 ; drawmode 
       fcb -8,8 ; position relative to previous node
; node # 52 M(-35,9)->(-2,-2)
       fcb 0 ; drawmode 
       fcb 0,-10 ; position relative to previous node
; node # 53 D(-41,10)->(8,8)
       fcb 2 ; drawmode 
       fcb -1,-6 ; position relative to previous node
; node # 54 D(-40,17)->(18,18)
       fcb 2 ; drawmode 
       fcb -7,1 ; position relative to previous node
; node # 55 D(-35,17)->(28,28)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 56 D(-32,12)->(38,38)
       fcb 2 ; drawmode 
       fcb 5,3 ; position relative to previous node
; node # 57 D(-35,9)->(48,48)
       fcb 2 ; drawmode 
       fcb 3,-3 ; position relative to previous node
; node # 58 M(-49,11)->(58,58)
       fcb 0 ; drawmode 
       fcb -2,-14 ; position relative to previous node
; node # 59 D(-48,31)->(68,68)
       fcb 2 ; drawmode 
       fcb -20,1 ; position relative to previous node
; node # 60 D(-53,39)->(78,78)
       fcb 2 ; drawmode 
       fcb -8,-5 ; position relative to previous node
; node # 61 D(-65,38)->(88,88)
       fcb 2 ; drawmode 
       fcb 1,-12 ; position relative to previous node
; node # 62 D(-68,5)->(98,98)
       fcb 2 ; drawmode 
       fcb 33,-3 ; position relative to previous node
; node # 63 D(-56,4)->(108,108)
       fcb 2 ; drawmode 
       fcb 1,12 ; position relative to previous node
; node # 64 D(-49,12)->(118,118)
       fcb 2 ; drawmode 
       fcb -8,7 ; position relative to previous node
; node # 65 M(-57,11)->(-128,-128)
       fcb 0 ; drawmode 
       fcb 1,-8 ; position relative to previous node
; node # 66 D(-55,14)->(-118,-118)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 67 D(-54,28)->(-108,-108)
       fcb 2 ; drawmode 
       fcb -14,1 ; position relative to previous node
; node # 68 D(-56,32)->(-98,-98)
       fcb 2 ; drawmode 
       fcb -4,-2 ; position relative to previous node
; node # 69 D(-60,32)->(-88,-88)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 70 D(-62,12)->(-78,-78)
       fcb 2 ; drawmode 
       fcb 20,-2 ; position relative to previous node
; node # 71 D(-57,11)->(-68,-68)
       fcb 2 ; drawmode 
       fcb 1,5 ; position relative to previous node
; node # 72 M(-69,5)->(-58,-58)
       fcb 0 ; drawmode 
       fcb 6,-12 ; position relative to previous node
; node # 73 D(-68,18)->(-48,-48)
       fcb 2 ; drawmode 
       fcb -13,1 ; position relative to previous node
; node # 74 D(-71,22)->(-38,-38)
       fcb 2 ; drawmode 
       fcb -4,-3 ; position relative to previous node
; node # 75 D(-67,25)->(-28,-28)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 76 D(-66,38)->(-18,-18)
       fcb 2 ; drawmode 
       fcb -13,1 ; position relative to previous node
; node # 77 D(-71,37)->(-8,-8)
       fcb 2 ; drawmode 
       fcb 1,-5 ; position relative to previous node
; node # 78 D(-71,29)->(2,2)
       fcb 2 ; drawmode 
       fcb 8,0 ; position relative to previous node
; node # 79 D(-73,25)->(12,12)
       fcb 2 ; drawmode 
       fcb 4,-2 ; position relative to previous node
; node # 80 D(-77,25)->(22,22)
       fcb 2 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 81 D(-76,37)->(32,32)
       fcb 2 ; drawmode 
       fcb -12,1 ; position relative to previous node
; node # 82 D(-81,37)->(42,42)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 83 D(-83,8)->(52,52)
       fcb 2 ; drawmode 
       fcb 29,-2 ; position relative to previous node
; node # 84 D(-79,7)->(62,62)
       fcb 2 ; drawmode 
       fcb 1,4 ; position relative to previous node
; node # 85 D(-78,20)->(72,72)
       fcb 2 ; drawmode 
       fcb -13,1 ; position relative to previous node
; node # 86 D(-74,19)->(82,82)
       fcb 2 ; drawmode 
       fcb 1,4 ; position relative to previous node
; node # 87 D(-73,16)->(92,92)
       fcb 2 ; drawmode 
       fcb 3,1 ; position relative to previous node
; node # 88 D(-74,7)->(102,102)
       fcb 2 ; drawmode 
       fcb 9,-1 ; position relative to previous node
; node # 89 D(-69,6)->(112,112)
       fcb 2 ; drawmode 
       fcb 1,5 ; position relative to previous node
; node # 90 M(-85,8)->(122,122)
       fcb 0 ; drawmode 
       fcb -2,-16 ; position relative to previous node
; node # 91 D(-84,14)->(-124,-124)
       fcb 2 ; drawmode 
       fcb -6,1 ; position relative to previous node
; node # 92 D(-90,14)->(-114,-114)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 93 D(-92,17)->(-104,-104)
       fcb 2 ; drawmode 
       fcb -3,-2 ; position relative to previous node
; node # 94 D(-91,28)->(-94,-94)
       fcb 2 ; drawmode 
       fcb -11,1 ; position relative to previous node
; node # 95 D(-88,31)->(-84,-84)
       fcb 2 ; drawmode 
       fcb -3,3 ; position relative to previous node
; node # 96 D(-83,31)->(-74,-74)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 97 D(-82,37)->(-64,-64)
       fcb 2 ; drawmode 
       fcb -6,1 ; position relative to previous node
; node # 98 D(-89,37)->(-54,-54)
       fcb 2 ; drawmode 
       fcb 0,-7 ; position relative to previous node
; node # 99 D(-94,31)->(-44,-44)
       fcb 2 ; drawmode 
       fcb 6,-5 ; position relative to previous node
; node # 100 D(-96,15)->(-34,-34)
       fcb 2 ; drawmode 
       fcb 16,-2 ; position relative to previous node
; node # 101 D(-92,9)->(-24,-24)
       fcb 2 ; drawmode 
       fcb 6,4 ; position relative to previous node
; node # 102 D(-85,8)->(-14,-14)
       fcb 2 ; drawmode 
       fcb 1,7 ; position relative to previous node
; node # 103 M(-97,10)->(-4,-4)
       fcb 0 ; drawmode 
       fcb -2,-12 ; position relative to previous node
; node # 104 D(-97,16)->(6,6)
       fcb 2 ; drawmode 
       fcb -6,0 ; position relative to previous node
; node # 105 D(-103,16)->(16,16)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 106 D(-103,21)->(26,26)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 107 D(-99,21)->(36,36)
       fcb 2 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 108 D(-98,25)->(46,46)
       fcb 2 ; drawmode 
       fcb -4,1 ; position relative to previous node
; node # 109 D(-102,26)->(56,56)
       fcb 2 ; drawmode 
       fcb -1,-4 ; position relative to previous node
; node # 110 D(-101,31)->(66,66)
       fcb 2 ; drawmode 
       fcb -5,1 ; position relative to previous node
; node # 111 D(-95,31)->(76,76)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 112 D(-95,36)->(86,86)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 113 D(-104,35)->(96,96)
       fcb 2 ; drawmode 
       fcb 1,-9 ; position relative to previous node
; node # 114 D(-107,11)->(106,106)
       fcb 2 ; drawmode 
       fcb 24,-3 ; position relative to previous node
; node # 115 D(-97,10)->(116,116)
       fcb 2 ; drawmode 
       fcb 1,10 ; position relative to previous node
; node # 116 M(-107,17)->(126,126)
       fcb 0 ; drawmode 
       fcb -7,-10 ; position relative to previous node
; node # 117 D(-107,21)->(-120,-120)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 118 D(-109,26)->(-110,-110)
       fcb 2 ; drawmode 
       fcb -5,-2 ; position relative to previous node
; node # 119 D(-112,26)->(-100,-100)
       fcb 2 ; drawmode 
       fcb 0,-3 ; position relative to previous node
; node # 120 D(-111,35)->(-90,-90)
       fcb 2 ; drawmode 
       fcb -9,1 ; position relative to previous node
; node # 121 D(-114,35)->(-80,-80)
       fcb 2 ; drawmode 
       fcb 0,-3 ; position relative to previous node
; node # 122 D(-116,12)->(-70,-70)
       fcb 2 ; drawmode 
       fcb 23,-2 ; position relative to previous node
; node # 123 D(-111,12)->(-60,-60)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 124 D(-107,17)->(-50,-50)
       fcb 2 ; drawmode 
       fcb -5,4 ; position relative to previous node
; node # 125 M(-111,17)->(-40,-40)
       fcb 0 ; drawmode 
       fcb 0,-4 ; position relative to previous node
; node # 126 D(-109,19)->(-30,-30)
       fcb 2 ; drawmode 
       fcb -2,2 ; position relative to previous node
; node # 127 D(-110,20)->(-20,-20)
       fcb 2 ; drawmode 
       fcb -1,-1 ; position relative to previous node
; node # 128 D(-113,21)->(-10,-10)
       fcb 2 ; drawmode 
       fcb -1,-3 ; position relative to previous node
; node # 129 D(-113,17)->(0,0)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 130 D(-111,17)->(10,10)
       fcb 2 ; drawmode 
       fcb 0,2 ; position relative to previous node
; node # 131 M(-117,13)->(20,20)
       fcb 0 ; drawmode 
       fcb 4,-6 ; position relative to previous node
; node # 132 D(-117,17)->(30,30)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 133 D(-120,17)->(40,40)
       fcb 2 ; drawmode 
       fcb 0,-3 ; position relative to previous node
; node # 134 D(-121,19)->(50,50)
       fcb 2 ; drawmode 
       fcb -2,-1 ; position relative to previous node
; node # 135 D(-119,22)->(60,60)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 136 D(-115,27)->(70,70)
       fcb 2 ; drawmode 
       fcb -5,4 ; position relative to previous node
; node # 137 D(-114,30)->(80,80)
       fcb 2 ; drawmode 
       fcb -3,1 ; position relative to previous node
; node # 138 D(-116,34)->(90,90)
       fcb 2 ; drawmode 
       fcb -4,-2 ; position relative to previous node
; node # 139 D(-121,34)->(100,100)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 140 D(-121,30)->(110,110)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 141 D(-118,30)->(120,120)
       fcb 2 ; drawmode 
       fcb 0,3 ; position relative to previous node
; node # 142 D(-118,26)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 143 D(-120,26)->(-116,-116)
       fcb 2 ; drawmode 
       fcb 0,-2 ; position relative to previous node
; node # 144 D(-124,20)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 6,-4 ; position relative to previous node
; node # 145 D(-124,17)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 3,0 ; position relative to previous node
; node # 146 D(-121,13)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 4,3 ; position relative to previous node
; node # 147 D(-117,13)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 0,4 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 8
greetsframe8:
; node # 0 M(-36,-29)->(0,0)
       fcb 0 ; drawmode 
       fcb 29,-36 ; position relative to previous node
; node # 1 D(-38,-22)->(10,10)
       fcb 2 ; drawmode 
       fcb -7,-2 ; position relative to previous node
; node # 2 D(-62,-23)->(20,20)
       fcb 2 ; drawmode 
       fcb 1,-24 ; position relative to previous node
; node # 3 D(-70,-20)->(30,30)
       fcb 2 ; drawmode 
       fcb -3,-8 ; position relative to previous node
; node # 4 D(-65,-15)->(40,40)
       fcb 2 ; drawmode 
       fcb -5,5 ; position relative to previous node
; node # 5 D(-56,-15)->(50,50)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 6 D(-43,-6)->(60,60)
       fcb 2 ; drawmode 
       fcb -9,13 ; position relative to previous node
; node # 7 D(-44,0)->(70,70)
       fcb 2 ; drawmode 
       fcb -6,-1 ; position relative to previous node
; node # 8 D(-61,9)->(80,80)
       fcb 2 ; drawmode 
       fcb -9,-17 ; position relative to previous node
; node # 9 D(-93,10)->(90,90)
       fcb 2 ; drawmode 
       fcb -1,-32 ; position relative to previous node
; node # 10 D(-90,1)->(100,100)
       fcb 2 ; drawmode 
       fcb 9,3 ; position relative to previous node
; node # 11 D(-64,1)->(110,110)
       fcb 2 ; drawmode 
       fcb 0,26 ; position relative to previous node
; node # 12 D(-56,-2)->(120,120)
       fcb 2 ; drawmode 
       fcb 3,8 ; position relative to previous node
; node # 13 D(-63,-7)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 5,-7 ; position relative to previous node
; node # 14 D(-73,-7)->(-116,-116)
       fcb 2 ; drawmode 
       fcb 0,-10 ; position relative to previous node
; node # 15 D(-86,-16)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 9,-13 ; position relative to previous node
; node # 16 D(-84,-23)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 7,2 ; position relative to previous node
; node # 17 D(-64,-32)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 9,20 ; position relative to previous node
; node # 18 D(-36,-30)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -2,28 ; position relative to previous node
; node # 19 M(-35,-21)->(-66,-66)
       fcb 0 ; drawmode 
       fcb -9,1 ; position relative to previous node
; node # 20 D(-41,0)->(-56,-56)
       fcb 2 ; drawmode 
       fcb -21,-6 ; position relative to previous node
; node # 21 D(-29,9)->(-46,-46)
       fcb 2 ; drawmode 
       fcb -9,12 ; position relative to previous node
; node # 22 D(-17,8)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 1,12 ; position relative to previous node
; node # 23 D(-14,6)->(-26,-26)
       fcb 2 ; drawmode 
       fcb 2,3 ; position relative to previous node
; node # 24 D(-12,8)->(-16,-16)
       fcb 2 ; drawmode 
       fcb -2,2 ; position relative to previous node
; node # 25 D(-6,8)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 26 D(-4,3)->(4,4)
       fcb 2 ; drawmode 
       fcb 5,2 ; position relative to previous node
; node # 27 D(-6,1)->(14,14)
       fcb 2 ; drawmode 
       fcb 2,-2 ; position relative to previous node
; node # 28 D(-4,0)->(24,24)
       fcb 2 ; drawmode 
       fcb 1,2 ; position relative to previous node
; node # 29 D(1,-19)->(34,34)
       fcb 2 ; drawmode 
       fcb 19,5 ; position relative to previous node
; node # 30 D(-8,-28)->(44,44)
       fcb 2 ; drawmode 
       fcb 9,-9 ; position relative to previous node
; node # 31 D(-19,-29)->(54,54)
       fcb 2 ; drawmode 
       fcb 1,-11 ; position relative to previous node
; node # 32 D(-35,-21)->(64,64)
       fcb 2 ; drawmode 
       fcb -8,-16 ; position relative to previous node
; node # 33 M(-24,-18)->(74,74)
       fcb 0 ; drawmode 
       fcb -3,11 ; position relative to previous node
; node # 34 D(-27,-2)->(84,84)
       fcb 2 ; drawmode 
       fcb -16,-3 ; position relative to previous node
; node # 35 D(-21,2)->(94,94)
       fcb 2 ; drawmode 
       fcb -4,6 ; position relative to previous node
; node # 36 D(-14,-2)->(104,104)
       fcb 2 ; drawmode 
       fcb 4,7 ; position relative to previous node
; node # 37 D(-10,-17)->(114,114)
       fcb 2 ; drawmode 
       fcb 15,4 ; position relative to previous node
; node # 38 D(-16,-22)->(124,124)
       fcb 2 ; drawmode 
       fcb 5,-6 ; position relative to previous node
; node # 39 D(-23,-18)->(-122,-122)
       fcb 2 ; drawmode 
       fcb -4,-7 ; position relative to previous node
; node # 40 M(6,-26)->(-112,-112)
       fcb 0 ; drawmode 
       fcb 8,29 ; position relative to previous node
; node # 41 D(-1,0)->(-102,-102)
       fcb 2 ; drawmode 
       fcb -26,-7 ; position relative to previous node
; node # 42 D(9,8)->(-92,-92)
       fcb 2 ; drawmode 
       fcb -8,10 ; position relative to previous node
; node # 43 D(18,8)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 44 D(30,0)->(-72,-72)
       fcb 2 ; drawmode 
       fcb 8,12 ; position relative to previous node
; node # 45 D(36,-24)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 24,6 ; position relative to previous node
; node # 46 D(27,-25)->(-52,-52)
       fcb 2 ; drawmode 
       fcb 1,-9 ; position relative to previous node
; node # 47 D(22,-2)->(-42,-42)
       fcb 2 ; drawmode 
       fcb -23,-5 ; position relative to previous node
; node # 48 D(15,2)->(-32,-32)
       fcb 2 ; drawmode 
       fcb -4,-7 ; position relative to previous node
; node # 49 D(10,-1)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 3,-5 ; position relative to previous node
; node # 50 D(16,-26)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 25,6 ; position relative to previous node
; node # 51 D(6,-26)->(-2,-2)
       fcb 2 ; drawmode 
       fcb 0,-10 ; position relative to previous node
; node # 52 M(37,-17)->(8,8)
       fcb 0 ; drawmode 
       fcb -9,31 ; position relative to previous node
; node # 53 D(32,0)->(18,18)
       fcb 2 ; drawmode 
       fcb -17,-5 ; position relative to previous node
; node # 54 D(40,7)->(28,28)
       fcb 2 ; drawmode 
       fcb -7,8 ; position relative to previous node
; node # 55 D(48,7)->(38,38)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 56 D(58,1)->(48,48)
       fcb 2 ; drawmode 
       fcb 6,10 ; position relative to previous node
; node # 57 D(62,-16)->(58,58)
       fcb 2 ; drawmode 
       fcb 17,4 ; position relative to previous node
; node # 58 D(55,-23)->(68,68)
       fcb 2 ; drawmode 
       fcb 7,-7 ; position relative to previous node
; node # 59 D(48,-24)->(78,78)
       fcb 2 ; drawmode 
       fcb 1,-7 ; position relative to previous node
; node # 60 D(37,-17)->(88,88)
       fcb 2 ; drawmode 
       fcb -7,-11 ; position relative to previous node
; node # 61 M(45,-15)->(98,98)
       fcb 0 ; drawmode 
       fcb -2,8 ; position relative to previous node
; node # 62 D(42,-2)->(108,108)
       fcb 2 ; drawmode 
       fcb -13,-3 ; position relative to previous node
; node # 63 D(46,1)->(118,118)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 64 D(51,-2)->(-128,-128)
       fcb 2 ; drawmode 
       fcb 3,5 ; position relative to previous node
; node # 65 D(54,-15)->(-118,-118)
       fcb 2 ; drawmode 
       fcb 13,3 ; position relative to previous node
; node # 66 D(50,-18)->(-108,-108)
       fcb 2 ; drawmode 
       fcb 3,-4 ; position relative to previous node
; node # 67 D(45,-15)->(-98,-98)
       fcb 2 ; drawmode 
       fcb -3,-5 ; position relative to previous node
; node # 68 M(64,-16)->(-88,-88)
       fcb 0 ; drawmode 
       fcb 1,19 ; position relative to previous node
; node # 69 D(60,0)->(-78,-78)
       fcb 2 ; drawmode 
       fcb -16,-4 ; position relative to previous node
; node # 70 D(66,6)->(-68,-68)
       fcb 2 ; drawmode 
       fcb -6,6 ; position relative to previous node
; node # 71 D(74,6)->(-58,-58)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 72 D(76,3)->(-48,-48)
       fcb 2 ; drawmode 
       fcb 3,2 ; position relative to previous node
; node # 73 D(77,6)->(-38,-38)
       fcb 2 ; drawmode 
       fcb -3,1 ; position relative to previous node
; node # 74 D(80,6)->(-28,-28)
       fcb 2 ; drawmode 
       fcb 0,3 ; position relative to previous node
; node # 75 D(82,3)->(-18,-18)
       fcb 2 ; drawmode 
       fcb 3,2 ; position relative to previous node
; node # 76 D(80,1)->(-8,-8)
       fcb 2 ; drawmode 
       fcb 2,-2 ; position relative to previous node
; node # 77 D(82,-1)->(2,2)
       fcb 2 ; drawmode 
       fcb 2,2 ; position relative to previous node
; node # 78 D(86,-15)->(12,12)
       fcb 2 ; drawmode 
       fcb 14,4 ; position relative to previous node
; node # 79 D(80,-21)->(22,22)
       fcb 2 ; drawmode 
       fcb 6,-6 ; position relative to previous node
; node # 80 D(74,-22)->(32,32)
       fcb 2 ; drawmode 
       fcb 1,-6 ; position relative to previous node
; node # 81 D(64,-16)->(42,42)
       fcb 2 ; drawmode 
       fcb -6,-10 ; position relative to previous node
; node # 82 M(70,-13)->(52,52)
       fcb 0 ; drawmode 
       fcb -3,6 ; position relative to previous node
; node # 83 D(68,-2)->(62,62)
       fcb 2 ; drawmode 
       fcb -11,-2 ; position relative to previous node
; node # 84 D(72,1)->(72,72)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 85 D(76,-3)->(82,82)
       fcb 2 ; drawmode 
       fcb 4,4 ; position relative to previous node
; node # 86 D(79,-14)->(92,92)
       fcb 2 ; drawmode 
       fcb 11,3 ; position relative to previous node
; node # 87 D(75,-17)->(102,102)
       fcb 2 ; drawmode 
       fcb 3,-4 ; position relative to previous node
; node # 88 D(70,-13)->(112,112)
       fcb 2 ; drawmode 
       fcb -4,-5 ; position relative to previous node
; node # 89 M(89,-21)->(122,122)
       fcb 0 ; drawmode 
       fcb 8,19 ; position relative to previous node
; node # 90 D(84,0)->(-124,-124)
       fcb 2 ; drawmode 
       fcb -21,-5 ; position relative to previous node
; node # 91 D(89,6)->(-114,-114)
       fcb 2 ; drawmode 
       fcb -6,5 ; position relative to previous node
; node # 92 D(95,6)->(-104,-104)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 93 D(103,0)->(-94,-94)
       fcb 2 ; drawmode 
       fcb 6,8 ; position relative to previous node
; node # 94 D(108,-19)->(-84,-84)
       fcb 2 ; drawmode 
       fcb 19,5 ; position relative to previous node
; node # 95 D(102,-20)->(-74,-74)
       fcb 2 ; drawmode 
       fcb 1,-6 ; position relative to previous node
; node # 96 D(98,-2)->(-64,-64)
       fcb 2 ; drawmode 
       fcb -18,-4 ; position relative to previous node
; node # 97 D(94,1)->(-54,-54)
       fcb 2 ; drawmode 
       fcb -3,-4 ; position relative to previous node
; node # 98 D(91,-2)->(-44,-44)
       fcb 2 ; drawmode 
       fcb 3,-3 ; position relative to previous node
; node # 99 D(95,-21)->(-34,-34)
       fcb 2 ; drawmode 
       fcb 19,4 ; position relative to previous node
; node # 100 D(89,-21)->(-24,-24)
       fcb 2 ; drawmode 
       fcb 0,-6 ; position relative to previous node
; node # 101 M(114,-19)->(-14,-14)
       fcb 0 ; drawmode 
       fcb -2,25 ; position relative to previous node
; node # 102 D(108,-13)->(-4,-4)
       fcb 2 ; drawmode 
       fcb -6,-6 ; position relative to previous node
; node # 103 D(105,0)->(6,6)
       fcb 2 ; drawmode 
       fcb -13,-3 ; position relative to previous node
; node # 104 D(108,5)->(16,16)
       fcb 2 ; drawmode 
       fcb -5,3 ; position relative to previous node
; node # 105 D(114,5)->(26,26)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 106 D(121,0)->(36,36)
       fcb 2 ; drawmode 
       fcb 5,7 ; position relative to previous node
; node # 107 D(124,-13)->(46,46)
       fcb 2 ; drawmode 
       fcb 13,3 ; position relative to previous node
; node # 108 D(121,-18)->(56,56)
       fcb 2 ; drawmode 
       fcb 5,-3 ; position relative to previous node
; node # 109 D(114,-19)->(66,66)
       fcb 2 ; drawmode 
       fcb 1,-7 ; position relative to previous node
; node # 110 M(116,-14)->(76,76)
       fcb 0 ; drawmode 
       fcb -5,2 ; position relative to previous node
; node # 111 D(112,-11)->(86,86)
       fcb 2 ; drawmode 
       fcb -3,-4 ; position relative to previous node
; node # 112 D(110,-2)->(96,96)
       fcb 2 ; drawmode 
       fcb -9,-2 ; position relative to previous node
; node # 113 D(112,1)->(106,106)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 114 D(116,-1)->(116,116)
       fcb 2 ; drawmode 
       fcb 2,4 ; position relative to previous node
; node # 115 D(119,-12)->(126,126)
       fcb 2 ; drawmode 
       fcb 11,3 ; position relative to previous node
; node # 116 D(116,-14)->(-120,-120)
       fcb 2 ; drawmode 
       fcb 2,-3 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 9
greetsframe9:
; node # 0 M(-28,-15)->(0,0)
       fcb 0 ; drawmode 
       fcb 15,-28 ; position relative to previous node
; node # 1 D(-26,-7)->(10,10)
       fcb 2 ; drawmode 
       fcb -8,2 ; position relative to previous node
; node # 2 D(-19,-7)->(20,20)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 3 D(-13,22)->(30,30)
       fcb 2 ; drawmode 
       fcb -29,6 ; position relative to previous node
; node # 4 D(-5,23)->(40,40)
       fcb 2 ; drawmode 
       fcb -1,8 ; position relative to previous node
; node # 5 D(-10,-9)->(50,50)
       fcb 2 ; drawmode 
       fcb 32,-5 ; position relative to previous node
; node # 6 D(-1,-10)->(60,60)
       fcb 2 ; drawmode 
       fcb 1,9 ; position relative to previous node
; node # 7 D(-2,-18)->(70,70)
       fcb 2 ; drawmode 
       fcb 8,-1 ; position relative to previous node
; node # 8 D(-27,-15)->(80,80)
       fcb 2 ; drawmode 
       fcb -3,-25 ; position relative to previous node
; node # 9 M(1,-19)->(90,90)
       fcb 0 ; drawmode 
       fcb 4,28 ; position relative to previous node
; node # 10 D(7,23)->(100,100)
       fcb 2 ; drawmode 
       fcb -42,6 ; position relative to previous node
; node # 11 D(17,25)->(110,110)
       fcb 2 ; drawmode 
       fcb -2,10 ; position relative to previous node
; node # 12 D(23,20)->(120,120)
       fcb 2 ; drawmode 
       fcb 5,6 ; position relative to previous node
; node # 13 D(29,26)->(-126,-126)
       fcb 2 ; drawmode 
       fcb -6,6 ; position relative to previous node
; node # 14 D(43,27)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -1,14 ; position relative to previous node
; node # 15 D(40,-25)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 52,-3 ; position relative to previous node
; node # 16 D(26,-23)->(-96,-96)
       fcb 2 ; drawmode 
       fcb -2,-14 ; position relative to previous node
; node # 17 D(29,14)->(-86,-86)
       fcb 2 ; drawmode 
       fcb -37,3 ; position relative to previous node
; node # 18 D(21,9)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 5,-8 ; position relative to previous node
; node # 19 D(16,14)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -5,-5 ; position relative to previous node
; node # 20 D(12,-20)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 34,-4 ; position relative to previous node
; node # 21 D(0,-19)->(-46,-46)
       fcb 2 ; drawmode 
       fcb -1,-12 ; position relative to previous node
; node # 22 M(45,-13)->(-36,-36)
       fcb 0 ; drawmode 
       fcb -6,45 ; position relative to previous node
; node # 23 D(46,16)->(-26,-26)
       fcb 2 ; drawmode 
       fcb -29,1 ; position relative to previous node
; node # 24 D(63,28)->(-16,-16)
       fcb 2 ; drawmode 
       fcb -12,17 ; position relative to previous node
; node # 25 D(102,32)->(-6,-6)
       fcb 2 ; drawmode 
       fcb -4,39 ; position relative to previous node
; node # 26 D(105,-6)->(4,4)
       fcb 2 ; drawmode 
       fcb 38,3 ; position relative to previous node
; node # 27 D(68,-4)->(14,14)
       fcb 2 ; drawmode 
       fcb -2,-37 ; position relative to previous node
; node # 28 D(68,7)->(24,24)
       fcb 2 ; drawmode 
       fcb -11,0 ; position relative to previous node
; node # 29 D(82,8)->(34,34)
       fcb 2 ; drawmode 
       fcb -1,14 ; position relative to previous node
; node # 30 D(82,19)->(44,44)
       fcb 2 ; drawmode 
       fcb -11,0 ; position relative to previous node
; node # 31 D(69,19)->(54,54)
       fcb 2 ; drawmode 
       fcb 0,-13 ; position relative to previous node
; node # 32 D(61,13)->(64,64)
       fcb 2 ; drawmode 
       fcb 6,-8 ; position relative to previous node
; node # 33 D(61,-10)->(74,74)
       fcb 2 ; drawmode 
       fcb 23,0 ; position relative to previous node
; node # 34 D(69,-17)->(84,84)
       fcb 2 ; drawmode 
       fcb 7,8 ; position relative to previous node
; node # 35 D(106,-19)->(94,94)
       fcb 2 ; drawmode 
       fcb 2,37 ; position relative to previous node
; node # 36 D(108,-35)->(104,104)
       fcb 2 ; drawmode 
       fcb 16,2 ; position relative to previous node
; node # 37 D(63,-28)->(114,114)
       fcb 2 ; drawmode 
       fcb -7,-45 ; position relative to previous node
; node # 38 D(45,-12)->(124,124)
       fcb 2 ; drawmode 
       fcb -16,-18 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 10
greetsframe10:
; node # 0 M(-105,-33)->(0,0)
       fcb 0 ; drawmode 
       fcb 33,-105 ; position relative to previous node
; node # 1 D(-106,-21)->(10,10)
       fcb 2 ; drawmode 
       fcb -12,-1 ; position relative to previous node
; node # 2 D(-75,-15)->(20,20)
       fcb 2 ; drawmode 
       fcb -6,31 ; position relative to previous node
; node # 3 D(-75,31)->(30,30)
       fcb 2 ; drawmode 
       fcb -46,0 ; position relative to previous node
; node # 4 D(-51,31)->(40,40)
       fcb 2 ; drawmode 
       fcb 0,24 ; position relative to previous node
; node # 5 D(-51,-11)->(50,50)
       fcb 2 ; drawmode 
       fcb 42,0 ; position relative to previous node
; node # 6 D(-32,-8)->(60,60)
       fcb 2 ; drawmode 
       fcb -3,19 ; position relative to previous node
; node # 7 D(-32,-18)->(70,70)
       fcb 2 ; drawmode 
       fcb 10,0 ; position relative to previous node
; node # 8 D(-105,-33)->(80,80)
       fcb 2 ; drawmode 
       fcb 15,-73 ; position relative to previous node
; node # 9 M(-27,-17)->(90,90)
       fcb 0 ; drawmode 
       fcb -16,78 ; position relative to previous node
; node # 10 D(-27,30)->(100,100)
       fcb 2 ; drawmode 
       fcb -47,0 ; position relative to previous node
; node # 11 D(-12,30)->(110,110)
       fcb 2 ; drawmode 
       fcb 0,15 ; position relative to previous node
; node # 12 D(-12,12)->(120,120)
       fcb 2 ; drawmode 
       fcb 18,0 ; position relative to previous node
; node # 13 D(-2,13)->(-126,-126)
       fcb 2 ; drawmode 
       fcb -1,10 ; position relative to previous node
; node # 14 D(2,16)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 15 D(2,29)->(-106,-106)
       fcb 2 ; drawmode 
       fcb -13,0 ; position relative to previous node
; node # 16 D(13,29)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 0,11 ; position relative to previous node
; node # 17 D(13,15)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 14,0 ; position relative to previous node
; node # 18 D(7,9)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 6,-6 ; position relative to previous node
; node # 19 D(13,5)->(-66,-66)
       fcb 2 ; drawmode 
       fcb 4,6 ; position relative to previous node
; node # 20 D(13,0)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 5,0 ; position relative to previous node
; node # 21 D(2,-11)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 11,-11 ; position relative to previous node
; node # 22 D(-27,-17)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 6,-29 ; position relative to previous node
; node # 23 M(-12,-5)->(-26,-26)
       fcb 0 ; drawmode 
       fcb -12,15 ; position relative to previous node
; node # 24 D(-12,3)->(-16,-16)
       fcb 2 ; drawmode 
       fcb -8,0 ; position relative to previous node
; node # 25 D(-2,5)->(-6,-6)
       fcb 2 ; drawmode 
       fcb -2,10 ; position relative to previous node
; node # 26 D(2,1)->(4,4)
       fcb 2 ; drawmode 
       fcb 4,4 ; position relative to previous node
; node # 27 D(-2,-3)->(14,14)
       fcb 2 ; drawmode 
       fcb 4,-4 ; position relative to previous node
; node # 28 D(-12,-5)->(24,24)
       fcb 2 ; drawmode 
       fcb 2,-10 ; position relative to previous node
; node # 29 M(16,0)->(34,34)
       fcb 0 ; drawmode 
       fcb -5,28 ; position relative to previous node
; node # 30 D(16,6)->(44,44)
       fcb 2 ; drawmode 
       fcb -6,0 ; position relative to previous node
; node # 31 D(26,15)->(54,54)
       fcb 2 ; drawmode 
       fcb -9,10 ; position relative to previous node
; node # 32 D(31,15)->(64,64)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 33 D(34,18)->(74,74)
       fcb 2 ; drawmode 
       fcb -3,3 ; position relative to previous node
; node # 34 D(30,22)->(84,84)
       fcb 2 ; drawmode 
       fcb -4,-4 ; position relative to previous node
; node # 35 D(16,22)->(94,94)
       fcb 2 ; drawmode 
       fcb 0,-14 ; position relative to previous node
; node # 36 D(16,29)->(104,104)
       fcb 2 ; drawmode 
       fcb -7,0 ; position relative to previous node
; node # 37 D(34,28)->(114,114)
       fcb 2 ; drawmode 
       fcb 1,18 ; position relative to previous node
; node # 38 D(41,21)->(124,124)
       fcb 2 ; drawmode 
       fcb 7,7 ; position relative to previous node
; node # 39 D(41,16)->(-122,-122)
       fcb 2 ; drawmode 
       fcb 5,0 ; position relative to previous node
; node # 40 D(35,9)->(-112,-112)
       fcb 2 ; drawmode 
       fcb 7,-6 ; position relative to previous node
; node # 41 D(28,8)->(-102,-102)
       fcb 2 ; drawmode 
       fcb 1,-7 ; position relative to previous node
; node # 42 D(25,4)->(-92,-92)
       fcb 2 ; drawmode 
       fcb 4,-3 ; position relative to previous node
; node # 43 D(28,1)->(-82,-82)
       fcb 2 ; drawmode 
       fcb 3,3 ; position relative to previous node
; node # 44 D(41,4)->(-72,-72)
       fcb 2 ; drawmode 
       fcb -3,13 ; position relative to previous node
; node # 45 D(41,-2)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 6,0 ; position relative to previous node
; node # 46 D(26,-6)->(-52,-52)
       fcb 2 ; drawmode 
       fcb 4,-15 ; position relative to previous node
; node # 47 D(16,0)->(-42,-42)
       fcb 2 ; drawmode 
       fcb -6,-10 ; position relative to previous node
; node # 48 M(43,-2)->(-32,-32)
       fcb 0 ; drawmode 
       fcb 2,27 ; position relative to previous node
; node # 49 D(43,27)->(-22,-22)
       fcb 2 ; drawmode 
       fcb -29,0 ; position relative to previous node
; node # 50 D(49,27)->(-12,-12)
       fcb 2 ; drawmode 
       fcb 0,6 ; position relative to previous node
; node # 51 D(49,-1)->(-2,-2)
       fcb 2 ; drawmode 
       fcb 28,0 ; position relative to previous node
; node # 52 D(43,-2)->(8,8)
       fcb 2 ; drawmode 
       fcb 1,-6 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 11
greetsframe11:
; node # 0 M(-64,-5)->(0,0)
       fcb 0 ; drawmode 
       fcb 5,-64 ; position relative to previous node
; node # 1 D(-65,26)->(10,10)
       fcb 2 ; drawmode 
       fcb -31,-1 ; position relative to previous node
; node # 2 D(-58,26)->(20,20)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 3 D(-43,-9)->(30,30)
       fcb 2 ; drawmode 
       fcb 35,15 ; position relative to previous node
; node # 4 D(-51,-8)->(40,40)
       fcb 2 ; drawmode 
       fcb -1,-8 ; position relative to previous node
; node # 5 D(-58,9)->(50,50)
       fcb 2 ; drawmode 
       fcb -17,-7 ; position relative to previous node
; node # 6 D(-58,-7)->(60,60)
       fcb 2 ; drawmode 
       fcb 16,0 ; position relative to previous node
; node # 7 D(-64,-6)->(70,70)
       fcb 2 ; drawmode 
       fcb -1,-6 ; position relative to previous node
; node # 8 M(-41,-10)->(80,80)
       fcb 0 ; drawmode 
       fcb 4,23 ; position relative to previous node
; node # 9 D(-48,26)->(90,90)
       fcb 2 ; drawmode 
       fcb -36,-7 ; position relative to previous node
; node # 10 D(-40,26)->(100,100)
       fcb 2 ; drawmode 
       fcb 0,8 ; position relative to previous node
; node # 11 D(-33,-10)->(110,110)
       fcb 2 ; drawmode 
       fcb 36,7 ; position relative to previous node
; node # 12 D(-41,-9)->(120,120)
       fcb 2 ; drawmode 
       fcb -1,-8 ; position relative to previous node
; node # 13 M(-30,-11)->(-126,-126)
       fcb 0 ; drawmode 
       fcb 2,11 ; position relative to previous node
; node # 14 D(-37,26)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -37,-7 ; position relative to previous node
; node # 15 D(-28,26)->(-106,-106)
       fcb 2 ; drawmode 
       fcb 0,9 ; position relative to previous node
; node # 16 D(-25,9)->(-96,-96)
       fcb 2 ; drawmode 
       fcb 17,3 ; position relative to previous node
; node # 17 D(-18,9)->(-86,-86)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 18 D(-14,13)->(-76,-76)
       fcb 2 ; drawmode 
       fcb -4,4 ; position relative to previous node
; node # 19 D(-16,27)->(-66,-66)
       fcb 2 ; drawmode 
       fcb -14,-2 ; position relative to previous node
; node # 20 D(-5,27)->(-56,-56)
       fcb 2 ; drawmode 
       fcb 0,11 ; position relative to previous node
; node # 21 D(-3,9)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 18,2 ; position relative to previous node
; node # 22 D(-8,5)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 4,-5 ; position relative to previous node
; node # 23 D(-2,0)->(-26,-26)
       fcb 2 ; drawmode 
       fcb 5,6 ; position relative to previous node
; node # 24 D(-2,-7)->(-16,-16)
       fcb 2 ; drawmode 
       fcb 7,0 ; position relative to previous node
; node # 25 D(-11,-14)->(-6,-6)
       fcb 2 ; drawmode 
       fcb 7,-9 ; position relative to previous node
; node # 26 D(-29,-11)->(4,4)
       fcb 2 ; drawmode 
       fcb -3,-18 ; position relative to previous node
; node # 27 M(-23,-5)->(14,14)
       fcb 0 ; drawmode 
       fcb -6,6 ; position relative to previous node
; node # 28 D(-24,2)->(24,24)
       fcb 2 ; drawmode 
       fcb -7,-1 ; position relative to previous node
; node # 29 D(-17,2)->(34,34)
       fcb 2 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 30 D(-12,-2)->(44,44)
       fcb 2 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 31 D(-15,-6)->(54,54)
       fcb 2 ; drawmode 
       fcb 4,-3 ; position relative to previous node
; node # 32 D(-23,-5)->(64,64)
       fcb 2 ; drawmode 
       fcb -1,-8 ; position relative to previous node
; node # 33 M(2,-16)->(14,14)
       fcb 0 ; drawmode 
       fcb 11,25 ; position relative to previous node
; node # 34 D(0,16)->(24,24)
       fcb 2 ; drawmode 
       fcb -32,-2 ; position relative to previous node
; node # 35 D(11,27)->(34,34)
       fcb 2 ; drawmode 
       fcb -11,11 ; position relative to previous node
; node # 36 D(25,27)->(44,44)
       fcb 2 ; drawmode 
       fcb 0,14 ; position relative to previous node
; node # 37 D(43,16)->(54,54)
       fcb 2 ; drawmode 
       fcb 11,18 ; position relative to previous node
; node # 38 D(44,-23)->(64,64)
       fcb 2 ; drawmode 
       fcb 39,1 ; position relative to previous node
; node # 39 D(29,-20)->(74,74)
       fcb 2 ; drawmode 
       fcb -3,-15 ; position relative to previous node
; node # 40 D(28,12)->(84,84)
       fcb 2 ; drawmode 
       fcb -32,-1 ; position relative to previous node
; node # 41 D(19,18)->(94,94)
       fcb 2 ; drawmode 
       fcb -6,-9 ; position relative to previous node
; node # 42 D(12,11)->(104,104)
       fcb 2 ; drawmode 
       fcb 7,-7 ; position relative to previous node
; node # 43 D(15,-18)->(114,114)
       fcb 2 ; drawmode 
       fcb 29,3 ; position relative to previous node
; node # 44 D(2,-16)->(124,124)
       fcb 2 ; drawmode 
       fcb -2,-13 ; position relative to previous node
; node # 45 M(49,-24)->(-122,-122)
       fcb 0 ; drawmode 
       fcb 8,47 ; position relative to previous node
; node # 46 D(49,-15)->(-112,-112)
       fcb 2 ; drawmode 
       fcb -9,0 ; position relative to previous node
; node # 47 D(89,-19)->(-102,-102)
       fcb 2 ; drawmode 
       fcb 4,40 ; position relative to previous node
; node # 48 D(48,8)->(-92,-92)
       fcb 2 ; drawmode 
       fcb -27,-41 ; position relative to previous node
; node # 49 D(48,27)->(-82,-82)
       fcb 2 ; drawmode 
       fcb -19,0 ; position relative to previous node
; node # 50 D(117,28)->(-72,-72)
       fcb 2 ; drawmode 
       fcb -1,69 ; position relative to previous node
; node # 51 D(115,14)->(-62,-62)
       fcb 2 ; drawmode 
       fcb 14,-2 ; position relative to previous node
; node # 52 D(67,16)->(-52,-52)
       fcb 2 ; drawmode 
       fcb -2,-48 ; position relative to previous node
; node # 53 D(67,10)->(-42,-42)
       fcb 2 ; drawmode 
       fcb 6,0 ; position relative to previous node
; node # 54 D(111,-18)->(-32,-32)
       fcb 2 ; drawmode 
       fcb 28,44 ; position relative to previous node
; node # 55 D(109,-34)->(-22,-22)
       fcb 2 ; drawmode 
       fcb 16,-2 ; position relative to previous node
; node # 56 D(49,-24)->(-12,-12)
       fcb 2 ; drawmode 
       fcb -10,-60 ; position relative to previous node
       fcb  1  ; end of anim
; Animation 12
greetsframe12:
       fcb  1  ; end of anim
