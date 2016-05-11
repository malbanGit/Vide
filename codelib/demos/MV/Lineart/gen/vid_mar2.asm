marchbeginframecount equ 14 ; number of animations
marchbeginframetotal equ 70 ; total number of frames in animation 
; index table 
marchbeginframetab        fdb marchbeginframe0
       fdb marchbeginframe1
       fdb marchbeginframe2
       fdb marchbeginframe3
       fdb marchbeginframe4
       fdb marchbeginframe5
       fdb marchbeginframe6
       fdb marchbeginframe7
       fdb marchbeginframe8
       fdb marchbeginframe9
       fdb marchbeginframe10
       fdb marchbeginframe11
       fdb marchbeginframe12
       fdb marchbeginframe13

; Animation 0
marchbeginframe0:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-67,34)->(-65,33)
       fcb 0 ; drawmode 
       fcb -34,-67 ; starx/y relative to previous node
       fdb 51,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:51)
; node # 1 D(1,34)->(1,34)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb -51,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:-51)
; node # 2 D(69,34)->(67,34)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:0|rel:0)
; node # 3 D(69,-34)->(68,-34)
       fcb 2 ; drawmode 
       fcb 68,0 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-51|rel:51) dy(abs:0|rel:0)
; node # 4 D(68,-102)->(70,-106)
       fcb 2 ; drawmode 
       fcb 68,-1 ; starx/y relative to previous node
       fdb 204,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:204|rel:204)
; node # 5 D(3,-37)->(8,-42)
       fcb 2 ; drawmode 
       fcb -65,-65 ; starx/y relative to previous node
       fdb 52,154 ; dx/dy. dx(abs:256|rel:154) dy(abs:256|rel:52)
; node # 6 D(-67,34)->(-66,33)
       fcb 2 ; drawmode 
       fcb -71,-70 ; starx/y relative to previous node
       fdb -205,-205 ; dx/dy. dx(abs:51|rel:-205) dy(abs:51|rel:-205)
; node # 7 D(-68,-37)->(-68,-40)
       fcb 2 ; drawmode 
       fcb 71,-1 ; starx/y relative to previous node
       fdb 102,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:153|rel:102)
; node # 8 D(-69,-102)->(-70,-106)
       fcb 2 ; drawmode 
       fcb 65,-1 ; starx/y relative to previous node
       fdb 51,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:204|rel:51)
; node # 9 D(2,-102)->(-2,-106)
       fcb 2 ; drawmode 
       fcb 0,71 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-204|rel:-153) dy(abs:204|rel:0)
; node # 10 D(68,-102)->(70,-106)
       fcb 2 ; drawmode 
       fcb 0,66 ; starx/y relative to previous node
       fdb 0,306 ; dx/dy. dx(abs:102|rel:306) dy(abs:204|rel:0)
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
       fcb  1  ; end of anim
; Animation 1
marchbeginframe1:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-65,33)->(-63,35)
       fcb 0 ; drawmode 
       fcb -33,-65 ; starx/y relative to previous node
       fdb -102,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-102|rel:-102)
; node # 1 D(1,33)->(1,34)
       fcb 2 ; drawmode 
       fcb 0,66 ; starx/y relative to previous node
       fdb 51,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-51|rel:51)
; node # 2 D(67,34)->(65,34)
       fcb 2 ; drawmode 
       fcb -1,66 ; starx/y relative to previous node
       fdb 51,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:0|rel:51)
; node # 3 D(69,-33)->(69,-38)
       fcb 2 ; drawmode 
       fcb 67,2 ; starx/y relative to previous node
       fdb 256,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:256|rel:256)
; node # 4 D(70,-106)->(72,-107)
       fcb 2 ; drawmode 
       fcb 73,1 ; starx/y relative to previous node
       fdb -205,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:-205)
; node # 5 D(1,-35)->(4,-36)
       fcb 2 ; drawmode 
       fcb -71,-69 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:51|rel:0)
; node # 6 D(-66,33)->(-64,35)
       fcb 2 ; drawmode 
       fcb -68,-67 ; starx/y relative to previous node
       fdb -153,-51 ; dx/dy. dx(abs:102|rel:-51) dy(abs:-102|rel:-153)
; node # 7 D(-68,-38)->(-68,-36)
       fcb 2 ; drawmode 
       fcb 71,-2 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-102|rel:0)
; node # 8 D(-70,-106)->(-73,-106)
       fcb 2 ; drawmode 
       fcb 68,-2 ; starx/y relative to previous node
       fdb 102,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:0|rel:102)
; node # 9 D(-1,-106)->(4,-106)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb 0,409 ; dx/dy. dx(abs:256|rel:409) dy(abs:0|rel:0)
; node # 10 D(70,-106)->(72,-106)
       fcb 2 ; drawmode 
       fcb 0,71 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:102|rel:-154) dy(abs:0|rel:0)
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
       fcb  1  ; end of anim
; Animation 2
marchbeginframe2:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-63,35)->(-61,34)
       fcb 0 ; drawmode 
       fcb -35,-63 ; starx/y relative to previous node
       fdb 51,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:51)
; node # 1 D(2,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 1,65 ; starx/y relative to previous node
       fdb -51,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:0|rel:-51)
; node # 2 D(65,34)->(62,34)
       fcb 2 ; drawmode 
       fcb 0,63 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-153|rel:-51) dy(abs:0|rel:0)
; node # 3 D(68,-33)->(68,-34)
       fcb 2 ; drawmode 
       fcb 67,3 ; starx/y relative to previous node
       fdb 51,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:51|rel:51)
; node # 4 D(72,-107)->(73,-105)
       fcb 2 ; drawmode 
       fcb 74,4 ; starx/y relative to previous node
       fdb -153,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-102|rel:-153)
; node # 5 D(10,-42)->(5,-34)
       fcb 2 ; drawmode 
       fcb -65,-62 ; starx/y relative to previous node
       fdb -307,-307 ; dx/dy. dx(abs:-256|rel:-307) dy(abs:-409|rel:-307)
; node # 6 D(-64,35)->(-61,34)
       fcb 2 ; drawmode 
       fcb -77,-74 ; starx/y relative to previous node
       fdb 460,409 ; dx/dy. dx(abs:153|rel:409) dy(abs:51|rel:460)
; node # 7 D(-68,-34)->(-68,-38)
       fcb 2 ; drawmode 
       fcb 69,-4 ; starx/y relative to previous node
       fdb 153,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:204|rel:153)
; node # 8 D(-73,-106)->(-74,-105)
       fcb 2 ; drawmode 
       fcb 72,-5 ; starx/y relative to previous node
       fdb -255,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-51|rel:-255)
; node # 9 D(-2,-106)->(0,-105)
       fcb 2 ; drawmode 
       fcb 0,71 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:-51|rel:0)
; node # 10 D(72,-106)->(73,-105)
       fcb 2 ; drawmode 
       fcb 0,74 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-51|rel:0)
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
       fcb  1  ; end of anim
; Animation 3
marchbeginframe3:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-61,34)->(-58,34)
       fcb 0 ; drawmode 
       fcb -34,-61 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:0)
; node # 1 D(-3,34)->(3,34)
       fcb 2 ; drawmode 
       fcb 0,58 ; starx/y relative to previous node
       fdb 0,154 ; dx/dy. dx(abs:307|rel:154) dy(abs:0|rel:0)
; node # 2 D(62,34)->(60,34)
       fcb 2 ; drawmode 
       fcb 0,65 ; starx/y relative to previous node
       fdb 0,-409 ; dx/dy. dx(abs:-102|rel:-409) dy(abs:0|rel:0)
; node # 3 D(68,-33)->(67,-27)
       fcb 2 ; drawmode 
       fcb 67,6 ; starx/y relative to previous node
       fdb -307,51 ; dx/dy. dx(abs:-51|rel:51) dy(abs:-307|rel:-307)
; node # 4 D(73,-105)->(75,-101)
       fcb 2 ; drawmode 
       fcb 72,5 ; starx/y relative to previous node
       fdb 103,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:-204|rel:103)
; node # 5 D(8,-37)->(9,-33)
       fcb 2 ; drawmode 
       fcb -68,-65 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-204|rel:0)
; node # 6 D(-61,34)->(-58,34)
       fcb 2 ; drawmode 
       fcb -71,-69 ; starx/y relative to previous node
       fdb 204,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:0|rel:204)
; node # 7 D(-68,-37)->(-67,-30)
       fcb 2 ; drawmode 
       fcb 71,-7 ; starx/y relative to previous node
       fdb -358,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-358|rel:-358)
; node # 8 D(-74,-105)->(-76,-100)
       fcb 2 ; drawmode 
       fcb 68,-6 ; starx/y relative to previous node
       fdb 102,-153 ; dx/dy. dx(abs:-102|rel:-153) dy(abs:-256|rel:102)
; node # 9 D(-4,-105)->(-2,-100)
       fcb 2 ; drawmode 
       fcb 0,70 ; starx/y relative to previous node
       fdb 0,204 ; dx/dy. dx(abs:102|rel:204) dy(abs:-256|rel:0)
; node # 10 D(73,-105)->(75,-100)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:-256|rel:0)
; node # 11 M(96,-16)->(99,-17)
       fcb 0 ; drawmode 
       fcb -89,23 ; starx/y relative to previous node
       fdb 307,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:51|rel:307)
; node # 12 M(127,73)->(127,65)
       fcb 0 ; drawmode 
       fcb -89,31 ; starx/y relative to previous node
       fdb 358,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:409|rel:358)
; node # 13 D(0,73)->(0,65)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
; node # 14 D(-127,73)->(-127,65)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
       fcb  1  ; end of anim
; Animation 4
marchbeginframe4:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-58,34)->(-56,35)
       fcb 0 ; drawmode 
       fcb -34,-58 ; starx/y relative to previous node
       fdb -51,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-51|rel:-51)
; node # 1 D(2,34)->(0,35)
       fcb 2 ; drawmode 
       fcb 0,60 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:-51|rel:0)
; node # 2 D(60,34)->(58,35)
       fcb 2 ; drawmode 
       fcb 0,58 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:-51|rel:0)
; node # 3 D(67,-30)->(67,-29)
       fcb 2 ; drawmode 
       fcb 64,7 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:-51|rel:0)
; node # 4 D(75,-101)->(76,-92)
       fcb 2 ; drawmode 
       fcb 71,8 ; starx/y relative to previous node
       fdb -409,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-460|rel:-409)
; node # 5 D(5,-30)->(10,-29)
       fcb 2 ; drawmode 
       fcb -71,-70 ; starx/y relative to previous node
       fdb 409,205 ; dx/dy. dx(abs:256|rel:205) dy(abs:-51|rel:409)
; node # 6 D(-58,34)->(-56,35)
       fcb 2 ; drawmode 
       fcb -64,-63 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:102|rel:-154) dy(abs:-51|rel:0)
; node # 7 D(-67,-30)->(-66,-28)
       fcb 2 ; drawmode 
       fcb 64,-9 ; starx/y relative to previous node
       fdb -51,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-102|rel:-51)
; node # 8 D(-76,-100)->(-76,-91)
       fcb 2 ; drawmode 
       fcb 70,-9 ; starx/y relative to previous node
       fdb -358,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:-460|rel:-358)
; node # 9 D(1,-99)->(0,-92)
       fcb 2 ; drawmode 
       fcb -1,77 ; starx/y relative to previous node
       fdb 102,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-358|rel:102)
; node # 10 D(75,-100)->(76,-92)
       fcb 2 ; drawmode 
       fcb 1,74 ; starx/y relative to previous node
       fdb -51,102 ; dx/dy. dx(abs:51|rel:102) dy(abs:-409|rel:-51)
; node # 11 D(41,-99)->(51,-108)
       fcb 2 ; drawmode 
       fcb -1,-34 ; starx/y relative to previous node
       fdb 869,461 ; dx/dy. dx(abs:512|rel:461) dy(abs:460|rel:869)
; node # 12 D(-76,-100)->(-76,-91)
       fcb 2 ; drawmode 
       fcb 1,-117 ; starx/y relative to previous node
       fdb -920,-512 ; dx/dy. dx(abs:0|rel:-512) dy(abs:-460|rel:-920)
; node # 13 D(-40,-100)->(-52,-108)
       fcb 2 ; drawmode 
       fcb 0,36 ; starx/y relative to previous node
       fdb 869,-614 ; dx/dy. dx(abs:-614|rel:-614) dy(abs:409|rel:869)
; node # 14 D(41,-99)->(51,-108)
       fcb 2 ; drawmode 
       fcb -1,81 ; starx/y relative to previous node
       fdb 51,1126 ; dx/dy. dx(abs:512|rel:1126) dy(abs:460|rel:51)
; node # 15 M(97,-15)->(88,-21)
       fcb 0 ; drawmode 
       fcb -84,56 ; starx/y relative to previous node
       fdb -153,-972 ; dx/dy. dx(abs:-460|rel:-972) dy(abs:307|rel:-153)
; node # 16 M(127,65)->(127,59)
       fcb 0 ; drawmode 
       fcb -80,30 ; starx/y relative to previous node
       fdb 0,460 ; dx/dy. dx(abs:0|rel:460) dy(abs:307|rel:0)
; node # 17 D(0,65)->(0,59)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 18 D(-127,65)->(-127,59)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 19 M(-127,105)->(-127,90)
       fcb 0 ; drawmode 
       fcb -40,0 ; starx/y relative to previous node
       fdb 461,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:461)
; node # 20 D(0,105)->(0,90)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:0)
; node # 21 D(127,105)->(127,90)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:0)
       fcb  1  ; end of anim
; Animation 5
marchbeginframe5:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-56,35)->(-55,34)
       fcb 0 ; drawmode 
       fcb -35,-56 ; starx/y relative to previous node
       fdb 51,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:51|rel:51)
; node # 1 D(1,35)->(3,35)
       fcb 2 ; drawmode 
       fcb 0,57 ; starx/y relative to previous node
       fdb -51,51 ; dx/dy. dx(abs:102|rel:51) dy(abs:0|rel:-51)
; node # 2 D(58,35)->(56,35)
       fcb 2 ; drawmode 
       fcb 0,57 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:0|rel:0)
; node # 3 D(66,-25)->(66,-23)
       fcb 2 ; drawmode 
       fcb 60,8 ; starx/y relative to previous node
       fdb -102,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:-102|rel:-102)
; node # 4 D(76,-92)->(77,-82)
       fcb 2 ; drawmode 
       fcb 67,10 ; starx/y relative to previous node
       fdb -410,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-512|rel:-410)
; node # 5 D(6,-26)->(9,-22)
       fcb 2 ; drawmode 
       fcb -66,-70 ; starx/y relative to previous node
       fdb 308,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:-204|rel:308)
; node # 6 D(-56,35)->(-55,34)
       fcb 2 ; drawmode 
       fcb -61,-62 ; starx/y relative to previous node
       fdb 255,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:51|rel:255)
; node # 7 D(-76,-91)->(-77,-82)
       fcb 2 ; drawmode 
       fcb 126,-20 ; starx/y relative to previous node
       fdb -511,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-460|rel:-511)
; node # 8 D(-1,-91)->(-4,-82)
       fcb 2 ; drawmode 
       fcb 0,75 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-153|rel:-102) dy(abs:-460|rel:0)
; node # 9 D(76,-92)->(77,-82)
       fcb 2 ; drawmode 
       fcb 1,77 ; starx/y relative to previous node
       fdb -52,204 ; dx/dy. dx(abs:51|rel:204) dy(abs:-512|rel:-52)
; node # 10 D(51,-108)->(52,-115)
       fcb 2 ; drawmode 
       fcb 16,-25 ; starx/y relative to previous node
       fdb 870,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:358|rel:870)
; node # 11 D(-9,-100)->(-3,-100)
       fcb 2 ; drawmode 
       fcb -8,-60 ; starx/y relative to previous node
       fdb -358,256 ; dx/dy. dx(abs:307|rel:256) dy(abs:0|rel:-358)
; node # 12 D(-76,-91)->(-77,-82)
       fcb 2 ; drawmode 
       fcb -9,-67 ; starx/y relative to previous node
       fdb -460,-358 ; dx/dy. dx(abs:-51|rel:-358) dy(abs:-460|rel:-460)
; node # 13 D(-52,-108)->(-53,-115)
       fcb 2 ; drawmode 
       fcb 17,24 ; starx/y relative to previous node
       fdb 818,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:358|rel:818)
; node # 14 D(51,-108)->(52,-115)
       fcb 2 ; drawmode 
       fcb 0,103 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:51|rel:102) dy(abs:358|rel:0)
; node # 15 M(86,-29)->(92,-22)
       fcb 0 ; drawmode 
       fcb -79,35 ; starx/y relative to previous node
       fdb -716,256 ; dx/dy. dx(abs:307|rel:256) dy(abs:-358|rel:-716)
; node # 16 M(127,59)->(127,54)
       fcb 0 ; drawmode 
       fcb -88,41 ; starx/y relative to previous node
       fdb 614,-307 ; dx/dy. dx(abs:0|rel:-307) dy(abs:256|rel:614)
; node # 17 D(0,59)->(0,54)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 18 D(-127,59)->(-127,54)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 19 M(-127,90)->(-127,80)
       fcb 0 ; drawmode 
       fcb -31,0 ; starx/y relative to previous node
       fdb 256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:256)
; node # 20 D(0,90)->(0,80)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:0)
; node # 21 D(127,90)->(127,80)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:0)
       fcb  1  ; end of anim
; Animation 6
marchbeginframe6:
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
; node # 3 D(8,-21)->(11,-17)
       fcb 2 ; drawmode 
       fcb -61,-69 ; starx/y relative to previous node
       fdb 410,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-204|rel:410)
; node # 4 D(-55,34)->(-52,34)
       fcb 2 ; drawmode 
       fcb -55,-63 ; starx/y relative to previous node
       fdb 204,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:0|rel:204)
; node # 5 D(-77,-82)->(-77,-69)
       fcb 2 ; drawmode 
       fcb 116,-22 ; starx/y relative to previous node
       fdb -665,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:-665|rel:-665)
; node # 6 D(0,-82)->(-2,-69)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-665|rel:0)
; node # 7 D(77,-82)->(77,-70)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 51,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:-614|rel:51)
; node # 8 D(52,-115)->(55,-121)
       fcb 2 ; drawmode 
       fcb 33,-25 ; starx/y relative to previous node
       fdb 921,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:307|rel:921)
; node # 9 D(-9,-99)->(-3,-98)
       fcb 2 ; drawmode 
       fcb -16,-61 ; starx/y relative to previous node
       fdb -358,154 ; dx/dy. dx(abs:307|rel:154) dy(abs:-51|rel:-358)
; node # 10 D(-77,-82)->(-77,-69)
       fcb 2 ; drawmode 
       fcb -17,-68 ; starx/y relative to previous node
       fdb -614,-307 ; dx/dy. dx(abs:0|rel:-307) dy(abs:-665|rel:-614)
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
; node # 17 M(-127,80)->(-127,73)
       fcb 0 ; drawmode 
       fcb -26,0 ; starx/y relative to previous node
       fdb 154,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:154)
; node # 18 D(0,80)->(0,73)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:0)
; node # 19 D(127,80)->(127,73)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:0)
       fcb  1  ; end of anim
; Animation 7
marchbeginframe7:
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
; node # 3 D(13,-18)->(12,-10)
       fcb 2 ; drawmode 
       fcb -52,-64 ; starx/y relative to previous node
       fdb 307,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:-409|rel:307)
; node # 4 D(-52,34)->(-52,34)
       fcb 2 ; drawmode 
       fcb -52,-65 ; starx/y relative to previous node
       fdb 409,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:0|rel:409)
; node # 5 D(-77,-69)->(-77,-55)
       fcb 2 ; drawmode 
       fcb 103,-25 ; starx/y relative to previous node
       fdb -716,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-716|rel:-716)
; node # 6 D(0,-69)->(-1,-55)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-716|rel:0)
; node # 7 D(77,-70)->(76,-55)
       fcb 2 ; drawmode 
       fcb 1,77 ; starx/y relative to previous node
       fdb -52,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:-768|rel:-52)
; node # 8 D(55,-121)->(57,-125)
       fcb 2 ; drawmode 
       fcb 51,-22 ; starx/y relative to previous node
       fdb 972,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:204|rel:972)
; node # 9 D(-5,-97)->(-10,-90)
       fcb 2 ; drawmode 
       fcb -24,-60 ; starx/y relative to previous node
       fdb -562,-358 ; dx/dy. dx(abs:-256|rel:-358) dy(abs:-358|rel:-562)
; node # 10 D(-77,-69)->(-77,-55)
       fcb 2 ; drawmode 
       fcb -28,-72 ; starx/y relative to previous node
       fdb -358,256 ; dx/dy. dx(abs:0|rel:256) dy(abs:-716|rel:-358)
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
; node # 17 M(-127,73)->(-127,65)
       fcb 0 ; drawmode 
       fcb -23,0 ; starx/y relative to previous node
       fdb 102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:102)
; node # 18 D(0,73)->(0,65)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
; node # 19 D(127,73)->(127,65)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
       fcb  1  ; end of anim
; Animation 8
marchbeginframe8:
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
; node # 3 D(8,-7)->(13,-3)
       fcb 2 ; drawmode 
       fcb -49,-68 ; starx/y relative to previous node
       fdb 615,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-204|rel:615)
; node # 4 D(-52,34)->(-48,34)
       fcb 2 ; drawmode 
       fcb -41,-60 ; starx/y relative to previous node
       fdb 204,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:0|rel:204)
; node # 5 D(-77,-55)->(-76,-39)
       fcb 2 ; drawmode 
       fcb 89,-25 ; starx/y relative to previous node
       fdb -819,-153 ; dx/dy. dx(abs:51|rel:-153) dy(abs:-819|rel:-819)
; node # 6 D(1,-55)->(-2,-39)
       fcb 2 ; drawmode 
       fcb 0,78 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:-153|rel:-204) dy(abs:-819|rel:0)
; node # 7 D(76,-55)->(76,-40)
       fcb 2 ; drawmode 
       fcb 0,75 ; starx/y relative to previous node
       fdb 51,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:-768|rel:51)
; node # 8 D(57,-125)->(59,-126)
       fcb 2 ; drawmode 
       fcb 70,-19 ; starx/y relative to previous node
       fdb 819,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:51|rel:819)
; node # 9 D(-5,-92)->(-5,-84)
       fcb 2 ; drawmode 
       fcb -33,-62 ; starx/y relative to previous node
       fdb -460,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-409|rel:-460)
; node # 10 D(-77,-55)->(-76,-39)
       fcb 2 ; drawmode 
       fcb -37,-72 ; starx/y relative to previous node
       fdb -410,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-819|rel:-410)
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
; node # 17 M(-127,65)->(-127,59)
       fcb 0 ; drawmode 
       fcb -21,0 ; starx/y relative to previous node
       fdb 103,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:103)
; node # 18 D(0,65)->(0,59)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 19 D(127,65)->(127,59)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
       fcb  1  ; end of anim
; Animation 9
marchbeginframe9:
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
; node # 5 D(-3,-39)->(-6,-22)
       fcb 2 ; drawmode 
       fcb 0,73 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:-153|rel:-204) dy(abs:-870|rel:0)
; node # 6 D(76,-40)->(73,-22)
       fcb 2 ; drawmode 
       fcb 1,79 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:-921|rel:-51)
; node # 7 D(59,-126)->(61,-125)
       fcb 2 ; drawmode 
       fcb 86,-17 ; starx/y relative to previous node
       fdb 870,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:-51|rel:870)
; node # 8 D(-8,-82)->(-5,-75)
       fcb 2 ; drawmode 
       fcb -44,-67 ; starx/y relative to previous node
       fdb -307,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-358|rel:-307)
; node # 9 D(-76,-39)->(-75,-21)
       fcb 2 ; drawmode 
       fcb -43,-68 ; starx/y relative to previous node
       fdb -563,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-921|rel:-563)
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
; node # 16 M(-127,59)->(-127,54)
       fcb 0 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 154,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:154)
; node # 17 D(0,59)->(0,54)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 18 D(127,59)->(127,54)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:0)
; node # 19 M(127,105)->(127,90)
       fcb 0 ; drawmode 
       fcb -46,0 ; starx/y relative to previous node
       fdb 512,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:512)
; node # 20 D(0,105)->(0,90)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:0)
; node # 21 D(-127,105)->(-127,90)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:768|rel:0)
       fcb  1  ; end of anim
; Animation 10
marchbeginframe10:
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
; node # 5 D(-7,-22)->(-5,-4)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:102|rel:51) dy(abs:-921|rel:0)
; node # 6 D(73,-22)->(73,-5)
       fcb 2 ; drawmode 
       fcb 0,80 ; starx/y relative to previous node
       fdb 51,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-870|rel:51)
; node # 7 D(61,-125)->(63,-123)
       fcb 2 ; drawmode 
       fcb 103,-12 ; starx/y relative to previous node
       fdb 768,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-102|rel:768)
; node # 8 D(-4,-75)->(-3,-65)
       fcb 2 ; drawmode 
       fcb -50,-65 ; starx/y relative to previous node
       fdb -410,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:-512|rel:-410)
; node # 9 D(-75,-21)->(-74,-4)
       fcb 2 ; drawmode 
       fcb -54,-71 ; starx/y relative to previous node
       fdb -358,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-870|rel:-358)
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
; node # 16 M(-127,54)->(-127,50)
       fcb 0 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:102)
; node # 17 D(0,54)->(0,50)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 18 D(127,54)->(127,50)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 19 M(127,90)->(127,80)
       fcb 0 ; drawmode 
       fcb -36,0 ; starx/y relative to previous node
       fdb 308,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:308)
; node # 20 D(0,90)->(0,80)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:0)
; node # 21 D(-127,90)->(-127,80)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:512|rel:0)
       fcb  1  ; end of anim
; Animation 11
marchbeginframe11:
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
; node # 5 D(-9,-4)->(-6,12)
       fcb 2 ; drawmode 
       fcb 0,65 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-819|rel:51)
; node # 6 D(73,-5)->(70,12)
       fcb 2 ; drawmode 
       fcb 1,82 ; starx/y relative to previous node
       fdb -51,-306 ; dx/dy. dx(abs:-153|rel:-306) dy(abs:-870|rel:-51)
; node # 7 D(68,-58)->(68,-49)
       fcb 2 ; drawmode 
       fcb 53,-5 ; starx/y relative to previous node
       fdb 410,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:-460|rel:410)
; node # 8 D(63,-123)->(66,-116)
       fcb 2 ; drawmode 
       fcb 65,-5 ; starx/y relative to previous node
       fdb 102,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-358|rel:102)
; node # 9 D(-2,-66)->(-5,-49)
       fcb 2 ; drawmode 
       fcb -57,-65 ; starx/y relative to previous node
       fdb -512,-306 ; dx/dy. dx(abs:-153|rel:-306) dy(abs:-870|rel:-512)
; node # 10 D(-74,-4)->(-72,13)
       fcb 2 ; drawmode 
       fcb -62,-72 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:102|rel:255) dy(abs:-870|rel:0)
; node # 11 D(-69,-65)->(-69,-53)
       fcb 2 ; drawmode 
       fcb 61,5 ; starx/y relative to previous node
       fdb 256,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-614|rel:256)
; node # 12 D(-64,-121)->(-65,-115)
       fcb 2 ; drawmode 
       fcb 56,5 ; starx/y relative to previous node
       fdb 307,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-307|rel:307)
; node # 13 D(-7,-122)->(-1,-116)
       fcb 2 ; drawmode 
       fcb 1,57 ; starx/y relative to previous node
       fdb 0,358 ; dx/dy. dx(abs:307|rel:358) dy(abs:-307|rel:0)
; node # 14 D(63,-123)->(66,-116)
       fcb 2 ; drawmode 
       fcb 1,70 ; starx/y relative to previous node
       fdb -51,-154 ; dx/dy. dx(abs:153|rel:-154) dy(abs:-358|rel:-51)
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
; node # 19 M(-127,50)->(-127,44)
       fcb 0 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb 256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:256)
; node # 20 D(0,50)->(0,44)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 21 D(127,50)->(127,44)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 22 M(127,80)->(127,73)
       fcb 0 ; drawmode 
       fcb -30,0 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:51)
; node # 23 D(0,80)->(0,73)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:0)
; node # 24 D(-127,80)->(-127,73)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:358|rel:0)
       fcb  1  ; end of anim
; Animation 12
marchbeginframe12:
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
; node # 5 D(-2,12)->(-1,29)
       fcb 2 ; drawmode 
       fcb 1,69 ; starx/y relative to previous node
       fdb -51,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-870|rel:-51)
; node # 6 D(70,12)->(69,29)
       fcb 2 ; drawmode 
       fcb 0,72 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-870|rel:0)
; node # 7 D(68,-51)->(68,-41)
       fcb 2 ; drawmode 
       fcb 63,-2 ; starx/y relative to previous node
       fdb 358,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-512|rel:358)
; node # 8 D(66,-116)->(68,-107)
       fcb 2 ; drawmode 
       fcb 65,-2 ; starx/y relative to previous node
       fdb 52,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-460|rel:52)
; node # 9 D(-4,-50)->(1,-40)
       fcb 2 ; drawmode 
       fcb -66,-70 ; starx/y relative to previous node
       fdb -52,154 ; dx/dy. dx(abs:256|rel:154) dy(abs:-512|rel:-52)
; node # 10 D(-72,13)->(-68,29)
       fcb 2 ; drawmode 
       fcb -63,-68 ; starx/y relative to previous node
       fdb -307,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:-819|rel:-307)
; node # 11 D(-68,-55)->(-68,-38)
       fcb 2 ; drawmode 
       fcb 68,4 ; starx/y relative to previous node
       fdb -51,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:-870|rel:-51)
; node # 12 D(-65,-115)->(-68,-107)
       fcb 2 ; drawmode 
       fcb 60,3 ; starx/y relative to previous node
       fdb 461,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:-409|rel:461)
; node # 13 D(0,-116)->(1,-107)
       fcb 2 ; drawmode 
       fcb 1,65 ; starx/y relative to previous node
       fdb -51,204 ; dx/dy. dx(abs:51|rel:204) dy(abs:-460|rel:-51)
; node # 14 D(66,-116)->(68,-107)
       fcb 2 ; drawmode 
       fcb 0,66 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:102|rel:51) dy(abs:-460|rel:0)
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
; node # 19 M(-127,44)->(-127,40)
       fcb 0 ; drawmode 
       fcb -9,0 ; starx/y relative to previous node
       fdb 153,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:153)
; node # 20 D(0,44)->(0,40)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 21 D(127,44)->(127,40)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:204|rel:0)
; node # 22 M(127,73)->(127,65)
       fcb 0 ; drawmode 
       fcb -29,0 ; starx/y relative to previous node
       fdb 205,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:205)
; node # 23 D(0,73)->(0,65)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
; node # 24 D(-127,73)->(-127,65)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:0)
       fcb  1  ; end of anim
; Animation 13
marchbeginframe13:
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
; node # 5 D(-8,29)->(-7,34)
       fcb 2 ; drawmode 
       fcb 0,60 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-256|rel:51)
; node # 6 D(69,29)->(69,34)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:-256|rel:0)
; node # 7 D(69,-37)->(69,-37)
       fcb 2 ; drawmode 
       fcb 66,0 ; starx/y relative to previous node
       fdb 256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:256)
; node # 8 D(68,-107)->(68,-102)
       fcb 2 ; drawmode 
       fcb 70,-1 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:-256)
; node # 9 D(-4,-35)->(-1,-33)
       fcb 2 ; drawmode 
       fcb -72,-72 ; starx/y relative to previous node
       fdb 154,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-102|rel:154)
; node # 10 D(-68,29)->(-68,35)
       fcb 2 ; drawmode 
       fcb -64,-64 ; starx/y relative to previous node
       fdb -205,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:-307|rel:-205)
; node # 11 D(-68,-41)->(-68,-34)
       fcb 2 ; drawmode 
       fcb 70,0 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-358|rel:-51)
; node # 12 D(-68,-107)->(-69,-102)
       fcb 2 ; drawmode 
       fcb 66,0 ; starx/y relative to previous node
       fdb 102,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-256|rel:102)
; node # 13 D(2,-107)->(1,-102)
       fcb 2 ; drawmode 
       fcb 0,70 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:-256|rel:0)
; node # 14 D(68,-107)->(68,-102)
       fcb 2 ; drawmode 
       fcb 0,66 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:0|rel:51) dy(abs:-256|rel:0)
; node # 15 M(96,-37)->(94,-30)
       fcb 0 ; drawmode 
       fcb -70,28 ; starx/y relative to previous node
       fdb -102,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-358|rel:-102)
; node # 16 M(127,34)->(127,34)
       fcb 0 ; drawmode 
       fcb -71,31 ; starx/y relative to previous node
       fdb 358,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:358)
; node # 17 D(0,34)->(0,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-127,34)->(-127,34)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-127,40)->(-127,38)
       fcb 0 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:102)
; node # 20 D(0,40)->(0,38)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 21 D(127,40)->(127,38)
       fcb 2 ; drawmode 
       fcb 0,127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:102|rel:0)
; node # 22 M(127,65)->(127,59)
       fcb 0 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb 205,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:205)
; node # 23 D(0,65)->(0,59)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
; node # 24 D(-127,65)->(-127,59)
       fcb 2 ; drawmode 
       fcb 0,-127 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:0)
       fcb  1  ; end of anim
