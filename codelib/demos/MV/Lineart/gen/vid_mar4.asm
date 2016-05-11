marchendframecount equ 15 ; number of animations
marchendframetotal equ 72 ; total number of frames in animation 
; index table 
marchendframetab        fdb marchendframe0
       fdb marchendframe1
       fdb marchendframe2
       fdb marchendframe3
       fdb marchendframe4
       fdb marchendframe5
       fdb marchendframe6
       fdb marchendframe7
       fdb marchendframe8
       fdb marchendframe9
       fdb marchendframe10
       fdb marchendframe11
       fdb marchendframe12
       fdb marchendframe13
       fdb marchendframe14

; Animation 0
marchendframe0:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-67,34)->(-65,33)
       fcb 0 ; drawmode 
       fcb -34,-67 ; starx/y relative to previous node
       fdb 51,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:51)
; node # 1 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,67 ; starx/y relative to previous node
       fdb -51,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:-51)
; node # 2 D(69,34)->(67,34)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:0|rel:0)
; node # 3 D(69,-29)->(69,-35)
       fcb 2 ; drawmode 
       fcb 63,0 ; starx/y relative to previous node
       fdb 307,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:307|rel:307)
; node # 4 D(68,-103)->(70,-106)
       fcb 2 ; drawmode 
       fcb 74,-1 ; starx/y relative to previous node
       fdb -154,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:153|rel:-154)
; node # 5 D(1,-35)->(6,-41)
       fcb 2 ; drawmode 
       fcb -68,-67 ; starx/y relative to previous node
       fdb 154,154 ; dx/dy. dx(abs:256|rel:154) dy(abs:307|rel:154)
; node # 6 D(-67,34)->(-66,33)
       fcb 2 ; drawmode 
       fcb -69,-68 ; starx/y relative to previous node
       fdb -256,-205 ; dx/dy. dx(abs:51|rel:-205) dy(abs:51|rel:-256)
; node # 7 D(-68,-34)->(-68,-35)
       fcb 2 ; drawmode 
       fcb 68,-1 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:51|rel:0)
; node # 8 D(-69,-102)->(-70,-106)
       fcb 2 ; drawmode 
       fcb 68,-1 ; starx/y relative to previous node
       fdb 153,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:204|rel:153)
; node # 9 D(0,-102)->(-3,-106)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-153|rel:-102) dy(abs:204|rel:0)
; node # 10 D(68,-102)->(70,-106)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:204|rel:0)
; node # 11 M(95,-2)->(93,-14)
       fcb 0 ; drawmode 
       fcb -100,27 ; starx/y relative to previous node
       fdb 410,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:614|rel:410)
; node # 12 M(127,105)->(127,90)
       fcb 0 ; drawmode 
       fcb -107,32 ; starx/y relative to previous node
       fdb 154,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:768|rel:154)
; node # 13 D(0,105)->(0,90)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:0)
; node # 14 D(-127,105)->(-127,90)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:0)
; node # 15 M(-127,65)->(-127,59)
       fcb 0 ; drawmode 
       fcb 40,0 ; starx/y relative to previous node
       fdb -461,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:-461)
; node # 16 D(0,65)->(0,59)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 17 D(127,65)->(127,59)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 18 M(127,40)->(127,38)
       fcb 0 ; drawmode 
       fcb 25,0 ; starx/y relative to previous node
       fdb -205,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:-205)
; node # 19 D(0,40)->(0,38)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 20 D(-127,40)->(-127,38)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 21 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-102)
; node # 22 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 1
marchendframe1:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-65,33)->(-63,35)
       fcb 0 ; drawmode 
       fcb -33,-65 ; starx/y relative to previous node
       fdb -102,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-102|rel:-102)
; node # 1 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb -1,65 ; starx/y relative to previous node
       fdb 102,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:102)
; node # 2 D(67,34)->(65,34)
       fcb 2 ; drawmode 
       fcb 0,67 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:0|rel:0)
; node # 3 D(69,-34)->(69,-39)
       fcb 2 ; drawmode 
       fcb 68,2 ; starx/y relative to previous node
       fdb 256,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:256|rel:256)
; node # 4 D(70,-106)->(72,-107)
       fcb 2 ; drawmode 
       fcb 72,1 ; starx/y relative to previous node
       fdb -205,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:-205)
; node # 5 D(1,-35)->(6,-38)
       fcb 2 ; drawmode 
       fcb -71,-69 ; starx/y relative to previous node
       fdb 102,154 ; dx/dy. dx(abs:256|rel:154) dy(abs:153|rel:102)
; node # 6 D(-66,33)->(-64,35)
       fcb 2 ; drawmode 
       fcb -68,-67 ; starx/y relative to previous node
       fdb -255,-154 ; dx/dy. dx(abs:102|rel:-154) dy(abs:-102|rel:-255)
; node # 7 D(-68,-37)->(-68,-37)
       fcb 2 ; drawmode 
       fcb 70,-2 ; starx/y relative to previous node
       fdb 102,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:102)
; node # 8 D(-70,-106)->(-73,-106)
       fcb 2 ; drawmode 
       fcb 69,-2 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:0|rel:0)
; node # 9 D(-1,-106)->(-4,-106)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 10 D(70,-106)->(72,-106)
       fcb 2 ; drawmode 
       fcb 0,71 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:0|rel:0)
; node # 11 M(92,-17)->(93,-12)
       fcb 0 ; drawmode 
       fcb -89,22 ; starx/y relative to previous node
       fdb -256,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-256|rel:-256)
; node # 12 M(127,90)->(127,80)
       fcb 0 ; drawmode 
       fcb -107,35 ; starx/y relative to previous node
       fdb 768,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:512|rel:768)
; node # 13 D(0,90)->(0,80)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:0)
; node # 14 D(-127,90)->(-127,80)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:0)
; node # 15 M(-127,59)->(-127,54)
       fcb 0 ; drawmode 
       fcb 31,0 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:-256)
; node # 16 D(0,59)->(0,54)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 17 D(127,59)->(127,54)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 18 M(127,38)->(127,36)
       fcb 0 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb -154,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:-154)
; node # 19 D(0,38)->(0,36)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 20 D(-127,38)->(-127,36)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 21 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-102)
; node # 22 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 2
marchendframe2:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-63,35)->(-61,34)
       fcb 0 ; drawmode 
       fcb -35,-63 ; starx/y relative to previous node
       fdb 51,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:51)
; node # 1 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 1,63 ; starx/y relative to previous node
       fdb -51,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:-51)
; node # 2 D(65,34)->(62,34)
       fcb 2 ; drawmode 
       fcb 0,65 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:0|rel:0)
; node # 3 D(68,-32)->(68,-34)
       fcb 2 ; drawmode 
       fcb 66,3 ; starx/y relative to previous node
       fdb 102,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:102|rel:102)
; node # 4 D(72,-107)->(73,-105)
       fcb 2 ; drawmode 
       fcb 75,4 ; starx/y relative to previous node
       fdb -204,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-102|rel:-204)
; node # 5 D(3,-34)->(9,-38)
       fcb 2 ; drawmode 
       fcb -73,-69 ; starx/y relative to previous node
       fdb 306,256 ; dx/dy. dx(abs:307|rel:256) dy(abs:204|rel:306)
; node # 6 D(-64,35)->(-61,34)
       fcb 2 ; drawmode 
       fcb -69,-67 ; starx/y relative to previous node
       fdb -153,-154 ; dx/dy. dx(abs:153|rel:-154) dy(abs:51|rel:-153)
; node # 7 D(-68,-37)->(-68,-37)
       fcb 2 ; drawmode 
       fcb 72,-4 ; starx/y relative to previous node
       fdb -51,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:-51)
; node # 8 D(-73,-106)->(-74,-105)
       fcb 2 ; drawmode 
       fcb 69,-5 ; starx/y relative to previous node
       fdb -51,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-51|rel:-51)
; node # 9 D(-4,-106)->(2,-105)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb 0,358 ; dx/dy. dx(abs:307|rel:358) dy(abs:-51|rel:0)
; node # 10 D(72,-106)->(73,-105)
       fcb 2 ; drawmode 
       fcb 0,76 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:51|rel:-256) dy(abs:-51|rel:0)
; node # 11 M(99,-18)->(95,-20)
       fcb 0 ; drawmode 
       fcb -88,27 ; starx/y relative to previous node
       fdb 153,-255 ; dx/dy. dx(abs:-204|rel:-255) dy(abs:102|rel:153)
; node # 12 M(127,80)->(127,73)
       fcb 0 ; drawmode 
       fcb -98,28 ; starx/y relative to previous node
       fdb 256,204 ; dx/dy. dx(abs:0|rel:204) dy(abs:358|rel:256)
; node # 13 D(0,80)->(0,73)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:0)
; node # 14 D(-127,80)->(-127,73)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:0)
; node # 15 M(-127,54)->(-127,50)
       fcb 0 ; drawmode 
       fcb 26,0 ; starx/y relative to previous node
       fdb -154,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:-154)
; node # 16 D(0,54)->(0,50)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 17 D(127,54)->(127,50)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 18 M(127,36)->(127,35)
       fcb 0 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb -153,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:-153)
; node # 19 D(0,36)->(0,35)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 20 D(-127,36)->(-127,35)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 21 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 2,0 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-51)
; node # 22 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 3
marchendframe3:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-61,34)->(-58,34)
       fcb 0 ; drawmode 
       fcb -34,-61 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:0)
; node # 1 D(62,34)->(60,34)
       fcb 2 ; drawmode 
       fcb 0,123 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-102|rel:-255) dy(abs:0|rel:0)
; node # 2 D(68,-35)->(67,-29)
       fcb 2 ; drawmode 
       fcb 69,6 ; starx/y relative to previous node
       fdb -307,51 ; dx/dy. dx(abs:-51|rel:51) dy(abs:-307|rel:-307)
; node # 3 D(73,-105)->(75,-101)
       fcb 2 ; drawmode 
       fcb 70,5 ; starx/y relative to previous node
       fdb 103,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:-204|rel:103)
; node # 4 D(8,-37)->(9,-34)
       fcb 2 ; drawmode 
       fcb -68,-65 ; starx/y relative to previous node
       fdb 51,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-153|rel:51)
; node # 5 D(-61,34)->(-58,34)
       fcb 2 ; drawmode 
       fcb -71,-69 ; starx/y relative to previous node
       fdb 153,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:0|rel:153)
; node # 6 D(-68,-34)->(-67,-30)
       fcb 2 ; drawmode 
       fcb 68,-7 ; starx/y relative to previous node
       fdb -204,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-204|rel:-204)
; node # 7 D(-74,-105)->(-76,-100)
       fcb 2 ; drawmode 
       fcb 71,-6 ; starx/y relative to previous node
       fdb -52,-153 ; dx/dy. dx(abs:-102|rel:-153) dy(abs:-256|rel:-52)
; node # 8 D(-2,-105)->(3,-100)
       fcb 2 ; drawmode 
       fcb 0,72 ; starx/y relative to previous node
       fdb 0,358 ; dx/dy. dx(abs:256|rel:358) dy(abs:-256|rel:0)
; node # 9 D(73,-105)->(75,-100)
       fcb 2 ; drawmode 
       fcb 0,75 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:102|rel:-154) dy(abs:-256|rel:0)
; node # 10 M(96,-16)->(99,-17)
       fcb 0 ; drawmode 
       fcb -89,23 ; starx/y relative to previous node
       fdb 307,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:51|rel:307)
; node # 11 M(127,73)->(127,65)
       fcb 0 ; drawmode 
       fcb -89,31 ; starx/y relative to previous node
       fdb 358,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:409|rel:358)
; node # 12 D(0,73)->(0,65)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
; node # 13 D(-127,73)->(-127,65)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
; node # 14 M(-127,50)->(-127,44)
       fcb 0 ; drawmode 
       fcb 23,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:-102)
; node # 15 D(0,50)->(0,44)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 16 D(127,50)->(127,44)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 17 M(127,35)->(127,34)
       fcb 0 ; drawmode 
       fcb 15,0 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:-256)
; node # 18 D(0,35)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 19 D(-127,35)->(-127,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 20 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-51)
; node # 21 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 4
marchendframe4:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-58,34)->(-56,35)
       fcb 0 ; drawmode 
       fcb -34,-58 ; starx/y relative to previous node
       fdb -51,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-51|rel:-51)
; node # 1 D(60,34)->(58,35)
       fcb 2 ; drawmode 
       fcb 0,118 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:-51|rel:0)
; node # 2 D(67,-31)->(67,-26)
       fcb 2 ; drawmode 
       fcb 65,7 ; starx/y relative to previous node
       fdb -205,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:-256|rel:-205)
; node # 3 D(75,-101)->(76,-92)
       fcb 2 ; drawmode 
       fcb 70,8 ; starx/y relative to previous node
       fdb -204,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-460|rel:-204)
; node # 4 D(9,-33)->(9,-28)
       fcb 2 ; drawmode 
       fcb -68,-66 ; starx/y relative to previous node
       fdb 204,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:-256|rel:204)
; node # 5 D(-58,34)->(-56,35)
       fcb 2 ; drawmode 
       fcb -67,-67 ; starx/y relative to previous node
       fdb 205,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-51|rel:205)
; node # 6 D(-67,-30)->(-66,-23)
       fcb 2 ; drawmode 
       fcb 64,-9 ; starx/y relative to previous node
       fdb -307,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-358|rel:-307)
; node # 7 D(-76,-100)->(-76,-91)
       fcb 2 ; drawmode 
       fcb 70,-9 ; starx/y relative to previous node
       fdb -102,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:-460|rel:-102)
; node # 8 D(2,-99)->(0,-92)
       fcb 2 ; drawmode 
       fcb -1,78 ; starx/y relative to previous node
       fdb 102,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-358|rel:102)
; node # 9 D(75,-100)->(76,-92)
       fcb 2 ; drawmode 
       fcb 1,73 ; starx/y relative to previous node
       fdb -51,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:-409|rel:-51)
; node # 10 D(41,-99)->(51,-108)
       fcb 2 ; drawmode 
       fcb -1,-34 ; starx/y relative to previous node
       fdb 869,461 ; dx/dy. dx(abs:512|rel:461) dy(abs:460|rel:869)
; switch intensity
       fcb 3
       fcb 0
; node # 11 D(-3,-99)->(-1,-101)
       fcb 2 ; drawmode 
       fcb 0,-44 ; starx/y relative to previous node
       fdb -358,-410 ; dx/dy. dx(abs:102|rel:-410) dy(abs:102|rel:-358)
; switch intensity
       fcb 3
       fcb 127
; node # 12 M(-77,-100)->(-77,-91)
       fcb 0 ; drawmode 
       fcb 1,-74 ; starx/y relative to previous node
       fdb -562,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-460|rel:-562)
; node # 13 D(-40,-100)->(-52,-108)
       fcb 2 ; drawmode 
       fcb 0,37 ; starx/y relative to previous node
       fdb 869,-614 ; dx/dy. dx(abs:-614|rel:-614) dy(abs:409|rel:869)
; node # 14 D(41,-99)->(51,-108)
       fcb 2 ; drawmode 
       fcb -1,81 ; starx/y relative to previous node
       fdb 51,1126 ; dx/dy. dx(abs:512|rel:1126) dy(abs:460|rel:51)
; node # 15 M(-32,-23)->(-38,-34)
       fcb 0 ; drawmode 
       fcb -76,-73 ; starx/y relative to previous node
       fdb 103,-819 ; dx/dy. dx(abs:-307|rel:-819) dy(abs:563|rel:103)
; node # 16 M(-127,65)->(-127,59)
       fcb 0 ; drawmode 
       fcb -88,-95 ; starx/y relative to previous node
       fdb -256,307 ; dx/dy. dx(abs:0|rel:307) dy(abs:307|rel:-256)
; node # 17 D(0,65)->(0,59)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 18 D(127,65)->(127,59)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 19 M(127,44)->(127,40)
       fcb 0 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb -103,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:-103)
; node # 20 D(0,44)->(0,40)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 21 D(-127,44)->(-127,40)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 22 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-204)
; node # 23 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 5
marchendframe5:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-56,35)->(-55,34)
       fcb 0 ; drawmode 
       fcb -35,-56 ; starx/y relative to previous node
       fdb 51,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:51|rel:51)
; node # 1 D(58,35)->(56,35)
       fcb 2 ; drawmode 
       fcb 0,114 ; starx/y relative to previous node
       fdb -51,-153 ; dx/dy. dx(abs:-102|rel:-153) dy(abs:0|rel:-51)
; node # 2 D(76,-92)->(77,-82)
       fcb 2 ; drawmode 
       fcb 127,18 ; starx/y relative to previous node
       fdb -512,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:-512|rel:-512)
; node # 3 D(12,-31)->(6,-20)
       fcb 2 ; drawmode 
       fcb -61,-64 ; starx/y relative to previous node
       fdb -51,-358 ; dx/dy. dx(abs:-307|rel:-358) dy(abs:-563|rel:-51)
; node # 4 D(-56,35)->(-55,34)
       fcb 2 ; drawmode 
       fcb -66,-68 ; starx/y relative to previous node
       fdb 614,358 ; dx/dy. dx(abs:51|rel:358) dy(abs:51|rel:614)
; node # 5 D(-76,-91)->(-77,-82)
       fcb 2 ; drawmode 
       fcb 126,-20 ; starx/y relative to previous node
       fdb -511,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-460|rel:-511)
; node # 6 D(3,-92)->(3,-82)
       fcb 2 ; drawmode 
       fcb 1,79 ; starx/y relative to previous node
       fdb -52,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-512|rel:-52)
; node # 7 D(76,-92)->(77,-82)
       fcb 2 ; drawmode 
       fcb 0,73 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-512|rel:0)
; node # 8 D(51,-108)->(52,-115)
       fcb 2 ; drawmode 
       fcb 16,-25 ; starx/y relative to previous node
       fdb 870,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:358|rel:870)
; switch intensity
       fcb 3
       fcb 0
; node # 9 D(-5,-100)->(-4,-100)
       fcb 2 ; drawmode 
       fcb -8,-56 ; starx/y relative to previous node
       fdb -358,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:0|rel:-358)
; switch intensity
       fcb 3
       fcb 127
; node # 10 M(-76,-91)->(-77,-82)
       fcb 0 ; drawmode 
       fcb -9,-71 ; starx/y relative to previous node
       fdb -460,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-460|rel:-460)
; node # 11 D(-52,-108)->(-53,-115)
       fcb 2 ; drawmode 
       fcb 17,24 ; starx/y relative to previous node
       fdb 818,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:358|rel:818)
; node # 12 D(51,-108)->(52,-115)
       fcb 2 ; drawmode 
       fcb 0,103 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:51|rel:102) dy(abs:358|rel:0)
; node # 13 M(-38,-31)->(-35,-35)
       fcb 0 ; drawmode 
       fcb -77,-89 ; starx/y relative to previous node
       fdb -154,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:204|rel:-154)
; node # 14 M(-127,59)->(-127,54)
       fcb 0 ; drawmode 
       fcb -90,-89 ; starx/y relative to previous node
       fdb 52,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:256|rel:52)
; node # 15 D(0,59)->(0,54)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 16 D(127,59)->(127,54)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 17 M(127,40)->(127,38)
       fcb 0 ; drawmode 
       fcb 19,0 ; starx/y relative to previous node
       fdb -154,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:-154)
; node # 18 D(0,40)->(0,38)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 19 D(-127,40)->(-127,38)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 20 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-102)
; node # 21 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 6
marchendframe6:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-55,34)->(-52,34)
       fcb 0 ; drawmode 
       fcb -34,-55 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:0)
; node # 1 D(56,35)->(56,35)
       fcb 2 ; drawmode 
       fcb -1,111 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:0)
; node # 2 D(77,-82)->(77,-70)
       fcb 2 ; drawmode 
       fcb 117,21 ; starx/y relative to previous node
       fdb -614,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-614|rel:-614)
; node # 3 D(10,-23)->(11,-16)
       fcb 2 ; drawmode 
       fcb -59,-67 ; starx/y relative to previous node
       fdb 256,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-358|rel:256)
; node # 4 D(-55,34)->(-52,34)
       fcb 2 ; drawmode 
       fcb -57,-65 ; starx/y relative to previous node
       fdb 358,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:0|rel:358)
; node # 5 D(-77,-82)->(-77,-69)
       fcb 2 ; drawmode 
       fcb 116,-22 ; starx/y relative to previous node
       fdb -665,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:-665|rel:-665)
; node # 6 D(0,-82)->(0,-69)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-665|rel:0)
; node # 7 D(77,-82)->(77,-70)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-614|rel:51)
; node # 8 D(52,-115)->(55,-121)
       fcb 2 ; drawmode 
       fcb 33,-25 ; starx/y relative to previous node
       fdb 921,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:307|rel:921)
; node # 9 M(-6,-100)->(-5,-97)
       fcb 0 ; drawmode 
       fcb -15,-58 ; starx/y relative to previous node
       fdb -460,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-153|rel:-460)
; node # 10 M(-77,-82)->(-77,-69)
       fcb 0 ; drawmode 
       fcb -18,-71 ; starx/y relative to previous node
       fdb -512,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:-665|rel:-512)
; node # 11 D(-53,-115)->(-55,-120)
       fcb 2 ; drawmode 
       fcb 33,24 ; starx/y relative to previous node
       fdb 921,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:256|rel:921)
; node # 12 D(52,-115)->(55,-121)
       fcb 2 ; drawmode 
       fcb 0,105 ; starx/y relative to previous node
       fdb 51,255 ; dx/dy. dx(abs:153|rel:255) dy(abs:307|rel:51)
; node # 13 M(91,-29)->(83,-20)
       fcb 0 ; drawmode 
       fcb -86,39 ; starx/y relative to previous node
       fdb -767,-562 ; dx/dy. dx(abs:-409|rel:-562) dy(abs:-460|rel:-767)
; node # 14 M(127,54)->(127,50)
       fcb 0 ; drawmode 
       fcb -83,36 ; starx/y relative to previous node
       fdb 664,409 ; dx/dy. dx(abs:0|rel:409) dy(abs:204|rel:664)
; node # 15 D(0,54)->(0,50)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 16 D(-127,54)->(-127,50)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 17 M(0,45)->(0,42)
       fcb 0 ; drawmode 
       fcb 9,127 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:153|rel:-51)
; node # 18 M(127,38)->(127,36)
       fcb 0 ; drawmode 
       fcb 7,127 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:-51)
; node # 19 D(0,38)->(0,36)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 20 D(-127,38)->(-127,36)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 21 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-102)
; node # 22 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 7
marchendframe7:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-52,34)->(-52,34)
       fcb 0 ; drawmode 
       fcb -34,-52 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(56,35)->(53,35)
       fcb 2 ; drawmode 
       fcb -1,108 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:0|rel:0)
; node # 2 D(77,-70)->(76,-56)
       fcb 2 ; drawmode 
       fcb 105,21 ; starx/y relative to previous node
       fdb -716,102 ; dx/dy. dx(abs:-51|rel:102) dy(abs:-716|rel:-716)
; node # 3 D(9,-15)->(18,-14)
       fcb 2 ; drawmode 
       fcb -55,-68 ; starx/y relative to previous node
       fdb 665,511 ; dx/dy. dx(abs:460|rel:511) dy(abs:-51|rel:665)
; node # 4 D(-52,34)->(-52,34)
       fcb 2 ; drawmode 
       fcb -49,-61 ; starx/y relative to previous node
       fdb 51,-460 ; dx/dy. dx(abs:0|rel:-460) dy(abs:0|rel:51)
; node # 5 D(-77,-69)->(-77,-55)
       fcb 2 ; drawmode 
       fcb 103,-25 ; starx/y relative to previous node
       fdb -716,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-716|rel:-716)
; node # 6 D(-2,-69)->(-1,-55)
       fcb 2 ; drawmode 
       fcb 0,75 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-716|rel:0)
; node # 7 D(77,-70)->(76,-55)
       fcb 2 ; drawmode 
       fcb 1,79 ; starx/y relative to previous node
       fdb -52,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-768|rel:-52)
; node # 8 D(55,-121)->(57,-125)
       fcb 2 ; drawmode 
       fcb 51,-22 ; starx/y relative to previous node
       fdb 972,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:204|rel:972)
; switch intensity
       fcb 3
       fcb 0
; node # 9 M(-8,-96)->(-6,-91)
       fcb 0 ; drawmode 
       fcb -25,-63 ; starx/y relative to previous node
       fdb -460,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:-256|rel:-460)
; switch intensity
       fcb 3
       fcb 127
; node # 10 M(-77,-69)->(-77,-55)
       fcb 0 ; drawmode 
       fcb -27,-69 ; starx/y relative to previous node
       fdb -460,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-716|rel:-460)
; node # 11 D(-55,-120)->(-57,-125)
       fcb 2 ; drawmode 
       fcb 51,22 ; starx/y relative to previous node
       fdb 972,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:256|rel:972)
; node # 12 D(55,-121)->(57,-125)
       fcb 2 ; drawmode 
       fcb 1,110 ; starx/y relative to previous node
       fdb -52,204 ; dx/dy. dx(abs:102|rel:204) dy(abs:204|rel:-52)
; node # 13 M(87,-31)->(89,-38)
       fcb 0 ; drawmode 
       fcb -90,32 ; starx/y relative to previous node
       fdb 154,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:358|rel:154)
; node # 14 M(127,50)->(127,44)
       fcb 0 ; drawmode 
       fcb -81,40 ; starx/y relative to previous node
       fdb -51,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:307|rel:-51)
; node # 15 D(0,50)->(0,44)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 16 D(-127,50)->(-127,44)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; switch intensity
       fcb 3
       fcb 0
; node # 17 M(-49,44)->(-60,40)
       fcb 0 ; drawmode 
       fcb 6,78 ; starx/y relative to previous node
       fdb -103,-563 ; dx/dy. dx(abs:-563|rel:-563) dy(abs:204|rel:-103)
; node # 18 M(38,41)->(60,39)
       fcb 0 ; drawmode 
       fcb 3,87 ; starx/y relative to previous node
       fdb -102,1689 ; dx/dy. dx(abs:1126|rel:1689) dy(abs:102|rel:-102)
; switch intensity
       fcb 3
       fcb 127
; node # 19 M(127,34)->(127,34)
       fcb 0 ; drawmode 
       fcb 7,89 ; starx/y relative to previous node
       fdb -102,-1126 ; dx/dy. dx(abs:0|rel:-1126) dy(abs:0|rel:-102)
; node # 20 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-127,34)->(-127,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-127,35)->(-127,34)
       fcb 0 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:51)
; node # 23 D(0,35)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 24 D(127,35)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
       fcb  1  ; end of anim
; Animation 8
marchendframe8:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-52,34)->(-49,34)
       fcb 0 ; drawmode 
       fcb -34,-52 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:0)
; node # 1 D(53,35)->(51,34)
       fcb 2 ; drawmode 
       fcb -1,105 ; starx/y relative to previous node
       fdb 51,-255 ; dx/dy. dx(abs:-102|rel:-255) dy(abs:51|rel:51)
; node # 2 D(76,-56)->(76,-40)
       fcb 2 ; drawmode 
       fcb 91,23 ; starx/y relative to previous node
       fdb -870,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:-819|rel:-870)
; node # 3 D(14,-12)->(13,-3)
       fcb 2 ; drawmode 
       fcb -44,-62 ; starx/y relative to previous node
       fdb 359,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-460|rel:359)
; node # 4 D(-52,34)->(-48,34)
       fcb 2 ; drawmode 
       fcb -46,-66 ; starx/y relative to previous node
       fdb 460,255 ; dx/dy. dx(abs:204|rel:255) dy(abs:0|rel:460)
; node # 5 D(-77,-55)->(-76,-39)
       fcb 2 ; drawmode 
       fcb 89,-25 ; starx/y relative to previous node
       fdb -819,-153 ; dx/dy. dx(abs:51|rel:-153) dy(abs:-819|rel:-819)
; node # 6 D(1,-55)->(0,-40)
       fcb 2 ; drawmode 
       fcb 0,78 ; starx/y relative to previous node
       fdb 51,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-768|rel:51)
; node # 7 D(76,-55)->(76,-40)
       fcb 2 ; drawmode 
       fcb 0,75 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-768|rel:0)
; node # 8 D(57,-125)->(59,-126)
       fcb 2 ; drawmode 
       fcb 70,-19 ; starx/y relative to previous node
       fdb 819,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:819)
; switch intensity
       fcb 3
       fcb 0
; node # 9 M(-4,-93)->(-5,-84)
       fcb 0 ; drawmode 
       fcb -32,-61 ; starx/y relative to previous node
       fdb -511,-153 ; dx/dy. dx(abs:-51|rel:-153) dy(abs:-460|rel:-511)
; switch intensity
       fcb 3
       fcb 127
; node # 10 M(-77,-55)->(-76,-39)
       fcb 0 ; drawmode 
       fcb -38,-73 ; starx/y relative to previous node
       fdb -359,102 ; dx/dy. dx(abs:51|rel:102) dy(abs:-819|rel:-359)
; node # 11 D(-57,-125)->(-58,-126)
       fcb 2 ; drawmode 
       fcb 70,20 ; starx/y relative to previous node
       fdb 870,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:51|rel:870)
; node # 12 D(57,-125)->(59,-126)
       fcb 2 ; drawmode 
       fcb 0,114 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:51|rel:0)
; node # 13 M(95,-36)->(85,-46)
       fcb 0 ; drawmode 
       fcb -89,38 ; starx/y relative to previous node
       fdb 461,-614 ; dx/dy. dx(abs:-512|rel:-614) dy(abs:512|rel:461)
; node # 14 M(127,44)->(127,40)
       fcb 0 ; drawmode 
       fcb -80,32 ; starx/y relative to previous node
       fdb -308,512 ; dx/dy. dx(abs:0|rel:512) dy(abs:204|rel:-308)
; node # 15 D(0,44)->(0,40)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 16 D(-127,44)->(-127,40)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 17 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-204)
; node # 18 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 9
marchendframe9:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-49,34)->(-47,34)
       fcb 0 ; drawmode 
       fcb -34,-49 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:0|rel:0)
; node # 1 D(51,34)->(51,34)
       fcb 2 ; drawmode 
       fcb 0,100 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:0)
; node # 2 D(76,-40)->(73,-22)
       fcb 2 ; drawmode 
       fcb 74,25 ; starx/y relative to previous node
       fdb -921,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:-921|rel:-921)
; node # 3 D(-48,34)->(-48,34)
       fcb 2 ; drawmode 
       fcb -74,-124 ; starx/y relative to previous node
       fdb 921,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:0|rel:921)
; node # 4 D(-76,-39)->(-75,-22)
       fcb 2 ; drawmode 
       fcb 73,-28 ; starx/y relative to previous node
       fdb -870,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-870|rel:-870)
; node # 5 D(-1,-40)->(1,-22)
       fcb 2 ; drawmode 
       fcb 1,75 ; starx/y relative to previous node
       fdb -51,51 ; dx/dy. dx(abs:102|rel:51) dy(abs:-921|rel:-51)
; node # 6 D(76,-40)->(73,-22)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-153|rel:-255) dy(abs:-921|rel:0)
; node # 7 D(59,-126)->(61,-125)
       fcb 2 ; drawmode 
       fcb 86,-17 ; starx/y relative to previous node
       fdb 870,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:-51|rel:870)
; switch intensity
       fcb 3
       fcb 0
; node # 8 M(-4,-84)->(-8,-72)
       fcb 0 ; drawmode 
       fcb -42,-63 ; starx/y relative to previous node
       fdb -563,-306 ; dx/dy. dx(abs:-204|rel:-306) dy(abs:-614|rel:-563)
; switch intensity
       fcb 3
       fcb 127
; node # 9 M(-76,-39)->(-75,-21)
       fcb 0 ; drawmode 
       fcb -45,-72 ; starx/y relative to previous node
       fdb -307,255 ; dx/dy. dx(abs:51|rel:255) dy(abs:-921|rel:-307)
; node # 10 D(-58,-126)->(-61,-125)
       fcb 2 ; drawmode 
       fcb 87,18 ; starx/y relative to previous node
       fdb 870,-204 ; dx/dy. dx(abs:-153|rel:-204) dy(abs:-51|rel:870)
; node # 11 D(59,-126)->(61,-125)
       fcb 2 ; drawmode 
       fcb 0,117 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:-51|rel:0)
; node # 12 M(88,-47)->(83,-51)
       fcb 0 ; drawmode 
       fcb -79,29 ; starx/y relative to previous node
       fdb 255,-358 ; dx/dy. dx(abs:-256|rel:-358) dy(abs:204|rel:255)
; node # 13 M(127,40)->(127,38)
       fcb 0 ; drawmode 
       fcb -87,39 ; starx/y relative to previous node
       fdb -102,256 ; dx/dy. dx(abs:0|rel:256) dy(abs:102|rel:-102)
; node # 14 D(0,40)->(0,38)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 15 D(-127,40)->(-127,38)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 16 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-102)
; node # 17 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 10
marchendframe10:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-47,34)->(-45,34)
       fcb 0 ; drawmode 
       fcb -34,-47 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:0|rel:0)
; node # 1 D(51,34)->(48,34)
       fcb 2 ; drawmode 
       fcb 0,98 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-153|rel:-255) dy(abs:0|rel:0)
; node # 2 D(73,-22)->(73,-5)
       fcb 2 ; drawmode 
       fcb 56,22 ; starx/y relative to previous node
       fdb -870,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:-870|rel:-870)
; node # 3 D(-48,34)->(-45,34)
       fcb 2 ; drawmode 
       fcb -56,-121 ; starx/y relative to previous node
       fdb 870,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:870)
; node # 4 D(-75,-22)->(-74,-4)
       fcb 2 ; drawmode 
       fcb 56,-27 ; starx/y relative to previous node
       fdb -921,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-921|rel:-921)
; node # 5 D(1,-22)->(0,-5)
       fcb 2 ; drawmode 
       fcb 0,76 ; starx/y relative to previous node
       fdb 51,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-870|rel:51)
; node # 6 D(73,-22)->(73,-5)
       fcb 2 ; drawmode 
       fcb 0,72 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-870|rel:0)
; node # 7 D(61,-125)->(63,-123)
       fcb 2 ; drawmode 
       fcb 103,-12 ; starx/y relative to previous node
       fdb 768,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-102|rel:768)
; switch intensity
       fcb 3
       fcb 0
; node # 8 M(-3,-75)->(-3,-63)
       fcb 0 ; drawmode 
       fcb -50,-64 ; starx/y relative to previous node
       fdb -512,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-614|rel:-512)
; switch intensity
       fcb 3
       fcb 127
; node # 9 M(-75,-21)->(-74,-4)
       fcb 0 ; drawmode 
       fcb -54,-72 ; starx/y relative to previous node
       fdb -256,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-870|rel:-256)
; node # 10 D(-61,-125)->(-64,-121)
       fcb 2 ; drawmode 
       fcb 104,14 ; starx/y relative to previous node
       fdb 666,-204 ; dx/dy. dx(abs:-153|rel:-204) dy(abs:-204|rel:666)
; node # 11 D(61,-125)->(63,-123)
       fcb 2 ; drawmode 
       fcb 0,122 ; starx/y relative to previous node
       fdb 102,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:-102|rel:102)
; node # 12 M(88,-45)->(91,-50)
       fcb 0 ; drawmode 
       fcb -80,27 ; starx/y relative to previous node
       fdb 358,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:256|rel:358)
; node # 13 M(127,38)->(127,36)
       fcb 0 ; drawmode 
       fcb -83,39 ; starx/y relative to previous node
       fdb -154,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:102|rel:-154)
; node # 14 D(0,38)->(0,36)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 15 D(-127,38)->(-127,36)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 16 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-102)
; node # 17 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 11
marchendframe11:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-45,34)->(-45,34)
       fcb 0 ; drawmode 
       fcb -34,-45 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(48,34)->(48,34)
       fcb 2 ; drawmode 
       fcb 0,93 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(73,-5)->(71,12)
       fcb 2 ; drawmode 
       fcb 39,25 ; starx/y relative to previous node
       fdb -870,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-870|rel:-870)
; node # 3 D(-45,34)->(-45,34)
       fcb 2 ; drawmode 
       fcb -39,-118 ; starx/y relative to previous node
       fdb 870,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:870)
; node # 4 D(-74,-4)->(-71,13)
       fcb 2 ; drawmode 
       fcb 38,-29 ; starx/y relative to previous node
       fdb -870,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-870|rel:-870)
; node # 5 D(-4,-4)->(-1,12)
       fcb 2 ; drawmode 
       fcb 0,70 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-819|rel:51)
; node # 6 D(73,-5)->(70,12)
       fcb 2 ; drawmode 
       fcb 1,77 ; starx/y relative to previous node
       fdb -51,-306 ; dx/dy. dx(abs:-153|rel:-306) dy(abs:-870|rel:-51)
; node # 7 D(68,-62)->(68,-49)
       fcb 2 ; drawmode 
       fcb 57,-5 ; starx/y relative to previous node
       fdb 205,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:-665|rel:205)
; node # 8 D(63,-123)->(66,-116)
       fcb 2 ; drawmode 
       fcb 61,-5 ; starx/y relative to previous node
       fdb 307,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-358|rel:307)
; switch intensity
       fcb 3
       fcb 0
; node # 9 M(-2,-65)->(4,-58)
       fcb 0 ; drawmode 
       fcb -58,-65 ; starx/y relative to previous node
       fdb 0,154 ; dx/dy. dx(abs:307|rel:154) dy(abs:-358|rel:0)
; switch intensity
       fcb 3
       fcb 127
; node # 10 M(-74,-4)->(-72,13)
       fcb 0 ; drawmode 
       fcb -61,-72 ; starx/y relative to previous node
       fdb -512,-205 ; dx/dy. dx(abs:102|rel:-205) dy(abs:-870|rel:-512)
; node # 11 D(-68,-63)->(-68,-56)
       fcb 2 ; drawmode 
       fcb 59,6 ; starx/y relative to previous node
       fdb 512,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-358|rel:512)
; node # 12 D(-64,-121)->(-65,-115)
       fcb 2 ; drawmode 
       fcb 58,4 ; starx/y relative to previous node
       fdb 51,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-307|rel:51)
; node # 13 D(-2,-122)->(0,-116)
       fcb 2 ; drawmode 
       fcb 1,62 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:-307|rel:0)
; node # 14 D(63,-123)->(66,-116)
       fcb 2 ; drawmode 
       fcb 1,65 ; starx/y relative to previous node
       fdb -51,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-358|rel:-51)
; node # 15 M(91,-39)->(94,-31)
       fcb 0 ; drawmode 
       fcb -84,28 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-409|rel:-51)
; node # 16 M(127,36)->(127,35)
       fcb 0 ; drawmode 
       fcb -75,36 ; starx/y relative to previous node
       fdb 460,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:51|rel:460)
; node # 17 D(0,36)->(0,35)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 18 D(-127,36)->(-127,35)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 19 M(-127,34)->(-127,34)
       fcb 0 ; drawmode 
       fcb 2,0 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-51)
; node # 20 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(127,34)->(127,34)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 12
marchendframe12:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-45,34)->(-45,34)
       fcb 0 ; drawmode 
       fcb -34,-45 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(48,34)->(48,34)
       fcb 2 ; drawmode 
       fcb 0,93 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(71,12)->(69,29)
       fcb 2 ; drawmode 
       fcb 22,23 ; starx/y relative to previous node
       fdb -870,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-870|rel:-870)
; node # 3 D(-45,34)->(-45,34)
       fcb 2 ; drawmode 
       fcb -22,-116 ; starx/y relative to previous node
       fdb 870,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:870)
; node # 4 D(-71,13)->(-68,29)
       fcb 2 ; drawmode 
       fcb 21,-26 ; starx/y relative to previous node
       fdb -819,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-819|rel:-819)
; node # 5 D(0,12)->(0,29)
       fcb 2 ; drawmode 
       fcb 1,71 ; starx/y relative to previous node
       fdb -51,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:-870|rel:-51)
; node # 6 D(70,12)->(69,29)
       fcb 2 ; drawmode 
       fcb 0,70 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-870|rel:0)
; node # 7 D(69,-53)->(69,-33)
       fcb 2 ; drawmode 
       fcb 65,-1 ; starx/y relative to previous node
       fdb -154,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-1024|rel:-154)
; node # 8 D(66,-116)->(68,-107)
       fcb 2 ; drawmode 
       fcb 63,-3 ; starx/y relative to previous node
       fdb 564,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-460|rel:564)
; switch intensity
       fcb 3
       fcb 0
; node # 9 M(1,-56)->(2,-41)
       fcb 0 ; drawmode 
       fcb -60,-65 ; starx/y relative to previous node
       fdb -308,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-768|rel:-308)
; switch intensity
       fcb 3
       fcb 127
; node # 10 M(-72,13)->(-68,29)
       fcb 0 ; drawmode 
       fcb -69,-73 ; starx/y relative to previous node
       fdb -51,153 ; dx/dy. dx(abs:204|rel:153) dy(abs:-819|rel:-51)
; node # 11 D(-68,-52)->(-68,-41)
       fcb 2 ; drawmode 
       fcb 65,4 ; starx/y relative to previous node
       fdb 256,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:-563|rel:256)
; node # 12 D(-65,-115)->(-68,-107)
       fcb 2 ; drawmode 
       fcb 63,3 ; starx/y relative to previous node
       fdb 154,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:-409|rel:154)
; node # 13 D(2,-116)->(1,-107)
       fcb 2 ; drawmode 
       fcb 1,67 ; starx/y relative to previous node
       fdb -51,102 ; dx/dy. dx(abs:-51|rel:102) dy(abs:-460|rel:-51)
; node # 14 D(66,-116)->(68,-107)
       fcb 2 ; drawmode 
       fcb 0,64 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:-460|rel:0)
; node # 15 M(97,-32)->(95,-36)
       fcb 0 ; drawmode 
       fcb -84,31 ; starx/y relative to previous node
       fdb 664,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:204|rel:664)
; node # 16 M(127,35)->(127,34)
       fcb 0 ; drawmode 
       fcb -67,30 ; starx/y relative to previous node
       fdb -153,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:51|rel:-153)
; node # 17 D(0,35)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
; node # 18 D(-127,35)->(-127,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:0)
       fcb  1  ; end of anim
; Animation 13
marchendframe13:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-45,34)->(-33,35)
       fcb 0 ; drawmode 
       fcb -34,-45 ; starx/y relative to previous node
       fdb -51,614 ; dx/dy. dx(abs:614|rel:614) dy(abs:-51|rel:-51)
; node # 1 D(48,34)->(39,34)
       fcb 2 ; drawmode 
       fcb 0,93 ; starx/y relative to previous node
       fdb 51,-1074 ; dx/dy. dx(abs:-460|rel:-1074) dy(abs:0|rel:51)
; node # 2 D(69,29)->(69,34)
       fcb 2 ; drawmode 
       fcb 5,21 ; starx/y relative to previous node
       fdb -256,460 ; dx/dy. dx(abs:0|rel:460) dy(abs:-256|rel:-256)
; node # 3 D(-45,34)->(-33,35)
       fcb 2 ; drawmode 
       fcb -5,-114 ; starx/y relative to previous node
       fdb 205,614 ; dx/dy. dx(abs:614|rel:614) dy(abs:-51|rel:205)
; node # 4 D(-68,29)->(-67,35)
       fcb 2 ; drawmode 
       fcb 5,-23 ; starx/y relative to previous node
       fdb -256,-563 ; dx/dy. dx(abs:51|rel:-563) dy(abs:-307|rel:-256)
; node # 5 D(-3,29)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,65 ; starx/y relative to previous node
       fdb 51,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:-256|rel:51)
; node # 6 D(69,29)->(69,34)
       fcb 2 ; drawmode 
       fcb 0,72 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:-256|rel:0)
; node # 7 D(69,-40)->(69,-36)
       fcb 2 ; drawmode 
       fcb 69,0 ; starx/y relative to previous node
       fdb 52,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-204|rel:52)
; node # 8 D(68,-107)->(68,-102)
       fcb 2 ; drawmode 
       fcb 67,-1 ; starx/y relative to previous node
       fdb -52,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:-52)
; switch intensity
       fcb 3
       fcb 0
; node # 9 M(4,-42)->(4,-38)
       fcb 0 ; drawmode 
       fcb -65,-64 ; starx/y relative to previous node
       fdb 52,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-204|rel:52)
; switch intensity
       fcb 3
       fcb 127
; node # 10 M(-68,29)->(-68,35)
       fcb 0 ; drawmode 
       fcb -71,-72 ; starx/y relative to previous node
       fdb -103,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-307|rel:-103)
; node # 11 D(-68,-45)->(-68,-39)
       fcb 2 ; drawmode 
       fcb 74,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-307|rel:0)
; node # 12 D(-68,-107)->(-69,-102)
       fcb 2 ; drawmode 
       fcb 62,0 ; starx/y relative to previous node
       fdb 51,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-256|rel:51)
; node # 13 D(3,-107)->(1,-102)
       fcb 2 ; drawmode 
       fcb 0,71 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-102|rel:-51) dy(abs:-256|rel:0)
; node # 14 D(68,-107)->(68,-102)
       fcb 2 ; drawmode 
       fcb 0,65 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:-256|rel:0)
; node # 15 M(96,-37)->(23,-21)
       fcb 0 ; drawmode 
       fcb -70,28 ; starx/y relative to previous node
       fdb -563,-3737 ; dx/dy. dx(abs:-3737|rel:-3737) dy(abs:-819|rel:-563)
; node # 16 M(127,34)->(0,34)
       fcb 0 ; drawmode 
       fcb -71,31 ; starx/y relative to previous node
       fdb 819,-2765 ; dx/dy. dx(abs:-6502|rel:-2765) dy(abs:0|rel:819)
; node # 17 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,6502 ; dx/dy. dx(abs:0|rel:6502) dy(abs:0|rel:0)
; node # 18 D(-127,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,6502 ; dx/dy. dx(abs:6502|rel:6502) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 14
marchendframe14:
       fcb 2 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; switch intensity
       fcb 3
       fcb 0
; node # 0 M(68,-102)->(68,-102)
       fcb 0 ; drawmode 
       fcb 102,68 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; switch intensity
       fcb 3
       fcb 127
; node # 1 D(69,-39)->(69,-39)
       fcb 2 ; drawmode 
       fcb -63,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(69,34)->(69,34)
       fcb 2 ; drawmode 
       fcb -73,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(8,34)->(5,34)
       fcb 2 ; drawmode 
       fcb 0,-61 ; starx/y relative to previous node
       fdb 0,-384 ; dx/dy. dx(abs:-384|rel:-384) dy(abs:0|rel:0)
; node # 4 D(-68,35)->(-68,35)
       fcb 2 ; drawmode 
       fcb -1,-76 ; starx/y relative to previous node
       fdb 0,384 ; dx/dy. dx(abs:0|rel:384) dy(abs:0|rel:0)
; node # 5 D(-68,-35)->(-68,-37)
       fcb 2 ; drawmode 
       fcb 70,0 ; starx/y relative to previous node
       fdb 256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:256)
; node # 6 D(-69,-102)->(-69,-102)
       fcb 2 ; drawmode 
       fcb 67,-1 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-256)
; node # 7 D(0,-102)->(-1,-102)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 8 D(68,-102)->(68,-102)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
       fcb  1  ; end of anim
