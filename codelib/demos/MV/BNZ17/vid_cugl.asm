vidcubeglframecount EQU 30 ; number of animations
; index table 
vidcubeglframetab        fdb vidcubeglframe0
       fdb vidcubeglframe1
       fdb vidcubeglframe2
       fdb vidcubeglframe3
       fdb vidcubeglframe4
       fdb vidcubeglframe5
       fdb vidcubeglframe6
       fdb vidcubeglframe7
       fdb vidcubeglframe8
       fdb vidcubeglframe9
       fdb vidcubeglframe10
       fdb vidcubeglframe11
       fdb vidcubeglframe12
       fdb vidcubeglframe13
       fdb vidcubeglframe14
       fdb vidcubeglframe15
       fdb vidcubeglframe16
       fdb vidcubeglframe17
       fdb vidcubeglframe18
       fdb vidcubeglframe19
       fdb vidcubeglframe20
       fdb vidcubeglframe21
       fdb vidcubeglframe22
       fdb vidcubeglframe23
       fdb vidcubeglframe24
       fdb vidcubeglframe25
       fdb vidcubeglframe26
       fdb vidcubeglframe27
       fdb vidcubeglframe28
       fdb vidcubeglframe29

; Animation 0
vidcubeglframe0:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-53,-42)->(-62,-36)
       fcb 0 ; drawmode 
       fdb 10752,-13568 ; starx/y relative to previous node
       fdb -153,-230 ; dx/dy. dx(abs:-230|rel:-230) dy(abs:-153|rel:-153)
; node # 1 D(34,-57)->(20,-64)
       fcb 2 ; drawmode 
       fdb 3840,22272 ; starx/y relative to previous node
       fdb 332,-128 ; dx/dy. dx(abs:-358|rel:-128) dy(abs:179|rel:332)
; node # 2 D(48,38)->(43,28)
       fcb 2 ; drawmode 
       fdb -24320,3584 ; starx/y relative to previous node
       fdb 77,230 ; dx/dy. dx(abs:-128|rel:230) dy(abs:256|rel:77)
; node # 3 D(-50,47)->(-50,49)
       fcb 2 ; drawmode 
       fdb -2304,-25088 ; starx/y relative to previous node
       fdb -307,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:-51|rel:-307)
; node # 4 D(-53,-42)->(-61,-36)
       fcb 2 ; drawmode 
       fdb 22784,-768 ; starx/y relative to previous node
       fdb -102,-204 ; dx/dy. dx(abs:-204|rel:-204) dy(abs:-153|rel:-102)
; node # 5 DM(-28,-25)->(-22,-18)
       fcb -1 ; drawmode 
       fdb -4352,6400 ; starx/y relative to previous node
       fdb -26,357 ; dx/dy. dx(abs:153|rel:357) dy(abs:-179|rel:-26)
; node # 6 DM(31,-33)->(33,-34)
       fcb -1 ; drawmode 
       fdb 2048,15104 ; starx/y relative to previous node
       fdb 204,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:25|rel:204)
; node # 7 M(34,-57)->(20,-64)
       fcb 0 ; drawmode 
       fdb 6144,768 ; starx/y relative to previous node
       fdb 154,-409 ; dx/dy. dx(abs:-358|rel:-409) dy(abs:179|rel:154)
; node # 8 DM(31,-33)->(34,-34)
       fcb -1 ; drawmode 
       fdb -6144,-768 ; starx/y relative to previous node
       fdb -154,434 ; dx/dy. dx(abs:76|rel:434) dy(abs:25|rel:-154)
; node # 9 DM(41,30)->(51,27)
       fcb -1 ; drawmode 
       fdb -16128,2560 ; starx/y relative to previous node
       fdb 51,180 ; dx/dy. dx(abs:256|rel:180) dy(abs:76|rel:51)
; node # 10 DM(48,38)->(43,28)
       fcb -1 ; drawmode 
       fdb -2048,1792 ; starx/y relative to previous node
       fdb 180,-384 ; dx/dy. dx(abs:-128|rel:-384) dy(abs:256|rel:180)
; node # 11 M(41,30)->(51,27)
       fcb 0 ; drawmode 
       fdb 2048,-1792 ; starx/y relative to previous node
       fdb -180,384 ; dx/dy. dx(abs:256|rel:384) dy(abs:76|rel:-180)
; node # 12 DM(-22,37)->(-11,43)
       fcb -1 ; drawmode 
       fdb -1792,-16128 ; starx/y relative to previous node
       fdb -229,25 ; dx/dy. dx(abs:281|rel:25) dy(abs:-153|rel:-229)
; node # 13 DM(-50,47)->(-49,49)
       fcb -1 ; drawmode 
       fdb -2560,-7168 ; starx/y relative to previous node
       fdb 102,-256 ; dx/dy. dx(abs:25|rel:-256) dy(abs:-51|rel:102)
; node # 14 M(-22,37)->(-12,43)
       fcb 0 ; drawmode 
       fdb 2560,7168 ; starx/y relative to previous node
       fdb -102,231 ; dx/dy. dx(abs:256|rel:231) dy(abs:-153|rel:-102)
; node # 15 DM(-28,-25)->(-23,-18)
       fcb -1 ; drawmode 
       fdb 15872,-1536 ; starx/y relative to previous node
       fdb -26,-128 ; dx/dy. dx(abs:128|rel:-128) dy(abs:-179|rel:-26)
       fcb  1  ; end of anim
; Animation 1
vidcubeglframe1:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-62,-36)->(-61,-27)
       fcb 0 ; drawmode 
       fdb 9216,-15872 ; starx/y relative to previous node
       fdb -230,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-230|rel:-230)
; node # 1 D(20,-64)->(6,-67)
       fcb 2 ; drawmode 
       fdb 7168,20992 ; starx/y relative to previous node
       fdb 306,-383 ; dx/dy. dx(abs:-358|rel:-383) dy(abs:76|rel:306)
; node # 2 D(43,28)->(35,16)
       fcb 2 ; drawmode 
       fdb -23552,5888 ; starx/y relative to previous node
       fdb 231,154 ; dx/dy. dx(abs:-204|rel:154) dy(abs:307|rel:231)
; node # 3 D(-50,49)->(-50,49)
       fcb 2 ; drawmode 
       fdb -5376,-23808 ; starx/y relative to previous node
       fdb -307,204 ; dx/dy. dx(abs:0|rel:204) dy(abs:0|rel:-307)
; node # 4 D(-61,-36)->(-62,-28)
       fcb 2 ; drawmode 
       fdb 21760,-2816 ; starx/y relative to previous node
       fdb -204,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-204|rel:-204)
; node # 5 DM(-22,-18)->(-18,-9)
       fcb -1 ; drawmode 
       fdb -4608,9984 ; starx/y relative to previous node
       fdb -26,127 ; dx/dy. dx(abs:102|rel:127) dy(abs:-230|rel:-26)
; node # 6 DM(33,-34)->(33,-36)
       fcb -1 ; drawmode 
       fdb 4096,14080 ; starx/y relative to previous node
       fdb 281,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:51|rel:281)
; node # 7 M(20,-64)->(6,-67)
       fcb 0 ; drawmode 
       fdb 7680,-3328 ; starx/y relative to previous node
       fdb 25,-358 ; dx/dy. dx(abs:-358|rel:-358) dy(abs:76|rel:25)
; node # 8 D(34,-34)->(33,-36)
       fcb 2 ; drawmode 
       fdb -7680,3584 ; starx/y relative to previous node
       fdb -25,333 ; dx/dy. dx(abs:-25|rel:333) dy(abs:51|rel:-25)
; node # 9 D(51,27)->(58,25)
       fcb 2 ; drawmode 
       fdb -15616,4352 ; starx/y relative to previous node
       fdb 0,204 ; dx/dy. dx(abs:179|rel:204) dy(abs:51|rel:0)
; node # 10 D(43,28)->(35,17)
       fcb 2 ; drawmode 
       fdb -256,-2048 ; starx/y relative to previous node
       fdb 230,-383 ; dx/dy. dx(abs:-204|rel:-383) dy(abs:281|rel:230)
; node # 11 M(51,27)->(57,25)
       fcb 0 ; drawmode 
       fdb 256,2048 ; starx/y relative to previous node
       fdb -230,357 ; dx/dy. dx(abs:153|rel:357) dy(abs:51|rel:-230)
; node # 12 D(-11,43)->(-5,48)
       fcb 2 ; drawmode 
       fdb -4096,-15872 ; starx/y relative to previous node
       fdb -179,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-128|rel:-179)
; node # 13 D(-49,49)->(-49,49)
       fcb 2 ; drawmode 
       fdb -1536,-9728 ; starx/y relative to previous node
       fdb 128,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:128)
; node # 14 M(-12,43)->(-5,48)
       fcb 0 ; drawmode 
       fdb 1536,9472 ; starx/y relative to previous node
       fdb -128,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:-128|rel:-128)
; node # 15 DM(-23,-18)->(-18,-10)
       fcb -1 ; drawmode 
       fdb 15616,-2816 ; starx/y relative to previous node
       fdb -76,-51 ; dx/dy. dx(abs:128|rel:-51) dy(abs:-204|rel:-76)
       fcb  1  ; end of anim
; Animation 2
vidcubeglframe2:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-61,-27)->(-61,-20)
       fcb 0 ; drawmode 
       fdb 6912,-15616 ; starx/y relative to previous node
       fdb -179,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-179|rel:-179)
; node # 1 D(6,-67)->(-6,-70)
       fcb 2 ; drawmode 
       fdb 10240,17152 ; starx/y relative to previous node
       fdb 255,-307 ; dx/dy. dx(abs:-307|rel:-307) dy(abs:76|rel:255)
; node # 2 D(35,16)->(25,5)
       fcb 2 ; drawmode 
       fdb -21248,7424 ; starx/y relative to previous node
       fdb 205,51 ; dx/dy. dx(abs:-256|rel:51) dy(abs:281|rel:205)
; node # 3 D(-50,49)->(-48,51)
       fcb 2 ; drawmode 
       fdb -8448,-21760 ; starx/y relative to previous node
       fdb -332,307 ; dx/dy. dx(abs:51|rel:307) dy(abs:-51|rel:-332)
; node # 4 D(-62,-28)->(-61,-20)
       fcb 2 ; drawmode 
       fdb 19712,-3072 ; starx/y relative to previous node
       fdb -153,-26 ; dx/dy. dx(abs:25|rel:-26) dy(abs:-204|rel:-153)
; node # 5 DM(-18,-9)->(-11,-3)
       fcb -1 ; drawmode 
       fdb -4864,11264 ; starx/y relative to previous node
       fdb 51,154 ; dx/dy. dx(abs:179|rel:154) dy(abs:-153|rel:51)
; node # 6 DM(33,-36)->(35,-37)
       fcb -1 ; drawmode 
       fdb 6912,13056 ; starx/y relative to previous node
       fdb 178,-128 ; dx/dy. dx(abs:51|rel:-128) dy(abs:25|rel:178)
; node # 7 M(6,-67)->(-6,-69)
       fcb 0 ; drawmode 
       fdb 7936,-6912 ; starx/y relative to previous node
       fdb 26,-358 ; dx/dy. dx(abs:-307|rel:-358) dy(abs:51|rel:26)
; node # 8 D(33,-36)->(35,-37)
       fcb 2 ; drawmode 
       fdb -7936,6912 ; starx/y relative to previous node
       fdb -26,358 ; dx/dy. dx(abs:51|rel:358) dy(abs:25|rel:-26)
; node # 9 D(58,25)->(65,20)
       fcb 2 ; drawmode 
       fdb -15616,6400 ; starx/y relative to previous node
       fdb 103,128 ; dx/dy. dx(abs:179|rel:128) dy(abs:128|rel:103)
; node # 10 D(35,17)->(25,6)
       fcb 2 ; drawmode 
       fdb 2048,-5888 ; starx/y relative to previous node
       fdb 153,-435 ; dx/dy. dx(abs:-256|rel:-435) dy(abs:281|rel:153)
; node # 11 M(57,25)->(65,20)
       fcb 0 ; drawmode 
       fdb -2048,5632 ; starx/y relative to previous node
       fdb -153,460 ; dx/dy. dx(abs:204|rel:460) dy(abs:128|rel:-153)
; node # 12 D(-5,48)->(5,51)
       fcb 2 ; drawmode 
       fdb -5888,-15872 ; starx/y relative to previous node
       fdb -204,52 ; dx/dy. dx(abs:256|rel:52) dy(abs:-76|rel:-204)
; node # 13 D(-49,49)->(-47,50)
       fcb 2 ; drawmode 
       fdb -256,-11264 ; starx/y relative to previous node
       fdb 51,-205 ; dx/dy. dx(abs:51|rel:-205) dy(abs:-25|rel:51)
; node # 14 M(-5,48)->(5,51)
       fcb 0 ; drawmode 
       fdb 256,11264 ; starx/y relative to previous node
       fdb -51,205 ; dx/dy. dx(abs:256|rel:205) dy(abs:-76|rel:-51)
; node # 15 DM(-18,-10)->(-12,-3)
       fcb -1 ; drawmode 
       fdb 14848,-3328 ; starx/y relative to previous node
       fdb -103,-103 ; dx/dy. dx(abs:153|rel:-103) dy(abs:-179|rel:-103)
       fcb  1  ; end of anim
; Animation 3
vidcubeglframe3:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-61,-20)->(-59,-10)
       fcb 0 ; drawmode 
       fdb 5120,-15616 ; starx/y relative to previous node
       fdb -256,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-256|rel:-256)
; node # 1 D(-6,-70)->(-19,-68)
       fcb 2 ; drawmode 
       fdb 12800,14080 ; starx/y relative to previous node
       fdb 205,-383 ; dx/dy. dx(abs:-332|rel:-383) dy(abs:-51|rel:205)
; node # 2 D(25,5)->(11,-6)
       fcb 2 ; drawmode 
       fdb -19200,7936 ; starx/y relative to previous node
       fdb 332,-26 ; dx/dy. dx(abs:-358|rel:-26) dy(abs:281|rel:332)
; node # 3 D(-48,51)->(-46,54)
       fcb 2 ; drawmode 
       fdb -11776,-18688 ; starx/y relative to previous node
       fdb -357,409 ; dx/dy. dx(abs:51|rel:409) dy(abs:-76|rel:-357)
; node # 4 D(-61,-20)->(-59,-10)
       fcb 2 ; drawmode 
       fdb 18176,-3328 ; starx/y relative to previous node
       fdb -180,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-256|rel:-180)
; node # 5 DM(-11,-3)->(-5,2)
       fcb -1 ; drawmode 
       fdb -4352,12800 ; starx/y relative to previous node
       fdb 128,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:-128|rel:128)
; node # 6 DM(35,-37)->(33,-39)
       fcb -1 ; drawmode 
       fdb 8704,11776 ; starx/y relative to previous node
       fdb 179,-204 ; dx/dy. dx(abs:-51|rel:-204) dy(abs:51|rel:179)
; node # 7 M(-6,-69)->(-18,-68)
       fcb 0 ; drawmode 
       fdb 8192,-10496 ; starx/y relative to previous node
       fdb -76,-256 ; dx/dy. dx(abs:-307|rel:-256) dy(abs:-25|rel:-76)
; node # 8 D(35,-37)->(34,-39)
       fcb 2 ; drawmode 
       fdb -8192,10496 ; starx/y relative to previous node
       fdb 76,282 ; dx/dy. dx(abs:-25|rel:282) dy(abs:51|rel:76)
; node # 9 D(65,20)->(69,12)
       fcb 2 ; drawmode 
       fdb -14592,7680 ; starx/y relative to previous node
       fdb 153,127 ; dx/dy. dx(abs:102|rel:127) dy(abs:204|rel:153)
; node # 10 D(25,6)->(11,-6)
       fcb 2 ; drawmode 
       fdb 3584,-10240 ; starx/y relative to previous node
       fdb 103,-460 ; dx/dy. dx(abs:-358|rel:-460) dy(abs:307|rel:103)
; node # 11 M(65,20)->(69,12)
       fcb 0 ; drawmode 
       fdb -3584,10240 ; starx/y relative to previous node
       fdb -103,460 ; dx/dy. dx(abs:102|rel:460) dy(abs:204|rel:-103)
; node # 12 D(5,51)->(16,55)
       fcb 2 ; drawmode 
       fdb -7936,-15360 ; starx/y relative to previous node
       fdb -306,179 ; dx/dy. dx(abs:281|rel:179) dy(abs:-102|rel:-306)
; node # 13 D(-47,50)->(-46,54)
       fcb 2 ; drawmode 
       fdb 256,-13312 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:25|rel:-256) dy(abs:-102|rel:0)
; node # 14 M(5,51)->(16,55)
       fcb 0 ; drawmode 
       fdb -256,13312 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:281|rel:256) dy(abs:-102|rel:0)
; node # 15 DM(-12,-3)->(-5,2)
       fcb -1 ; drawmode 
       fdb 13824,-4352 ; starx/y relative to previous node
       fdb -26,-102 ; dx/dy. dx(abs:179|rel:-102) dy(abs:-128|rel:-26)
       fcb  1  ; end of anim
; Animation 4
vidcubeglframe4:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-59,-10)->(-54,-3)
       fcb 0 ; drawmode 
       fdb 2560,-15104 ; starx/y relative to previous node
       fdb -179,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-179|rel:-179)
; node # 1 D(-19,-68)->(-28,-63)
       fcb 2 ; drawmode 
       fdb 14848,10240 ; starx/y relative to previous node
       fdb 51,-358 ; dx/dy. dx(abs:-230|rel:-358) dy(abs:-128|rel:51)
; node # 2 D(11,-6)->(-5,-15)
       fcb 2 ; drawmode 
       fdb -15872,7680 ; starx/y relative to previous node
       fdb 358,-179 ; dx/dy. dx(abs:-409|rel:-179) dy(abs:230|rel:358)
; node # 3 D(-46,54)->(-46,54)
       fcb 2 ; drawmode 
       fdb -15360,-14592 ; starx/y relative to previous node
       fdb -230,409 ; dx/dy. dx(abs:0|rel:409) dy(abs:0|rel:-230)
; node # 4 D(-59,-10)->(-54,-3)
       fcb 2 ; drawmode 
       fdb 16384,-3328 ; starx/y relative to previous node
       fdb -179,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-179|rel:-179)
; node # 5 DM(-5,2)->(3,7)
       fcb -1 ; drawmode 
       fdb -3072,13824 ; starx/y relative to previous node
       fdb 51,76 ; dx/dy. dx(abs:204|rel:76) dy(abs:-128|rel:51)
; node # 6 DM(33,-39)->(33,-39)
       fcb -1 ; drawmode 
       fdb 10496,9728 ; starx/y relative to previous node
       fdb 128,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:0|rel:128)
; node # 7 M(-18,-68)->(-28,-63)
       fcb 0 ; drawmode 
       fdb 7424,-13056 ; starx/y relative to previous node
       fdb -128,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:-128|rel:-128)
; node # 8 D(34,-39)->(34,-39)
       fcb 2 ; drawmode 
       fdb -7424,13312 ; starx/y relative to previous node
       fdb 128,256 ; dx/dy. dx(abs:0|rel:256) dy(abs:0|rel:128)
; node # 9 D(69,12)->(70,3)
       fcb 2 ; drawmode 
       fdb -13056,8960 ; starx/y relative to previous node
       fdb 230,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:230|rel:230)
; node # 10 D(11,-6)->(-5,-14)
       fcb 2 ; drawmode 
       fdb 4608,-14848 ; starx/y relative to previous node
       fdb -26,-434 ; dx/dy. dx(abs:-409|rel:-434) dy(abs:204|rel:-26)
; node # 11 M(69,12)->(70,3)
       fcb 0 ; drawmode 
       fdb -4608,14848 ; starx/y relative to previous node
       fdb 26,434 ; dx/dy. dx(abs:25|rel:434) dy(abs:230|rel:26)
; node # 12 D(16,55)->(24,57)
       fcb 2 ; drawmode 
       fdb -11008,-13568 ; starx/y relative to previous node
       fdb -281,179 ; dx/dy. dx(abs:204|rel:179) dy(abs:-51|rel:-281)
; node # 13 D(-46,54)->(-46,54)
       fcb 2 ; drawmode 
       fdb 256,-15872 ; starx/y relative to previous node
       fdb 51,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:0|rel:51)
; node # 14 M(16,55)->(24,57)
       fcb 0 ; drawmode 
       fdb -256,15872 ; starx/y relative to previous node
       fdb -51,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-51|rel:-51)
; node # 15 DM(-5,2)->(3,8)
       fcb -1 ; drawmode 
       fdb 13568,-5376 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:-153|rel:-102)
       fcb  1  ; end of anim
; Animation 5
vidcubeglframe5:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-54,-3)->(-48,6)
       fcb 0 ; drawmode 
       fdb 768,-13824 ; starx/y relative to previous node
       fdb -230,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-230|rel:-230)
; node # 1 D(-28,-63)->(-34,-57)
       fcb 2 ; drawmode 
       fdb 15360,6656 ; starx/y relative to previous node
       fdb 77,-306 ; dx/dy. dx(abs:-153|rel:-306) dy(abs:-153|rel:77)
; node # 2 D(-5,-15)->(-20,-23)
       fcb 2 ; drawmode 
       fdb -12288,5888 ; starx/y relative to previous node
       fdb 357,-231 ; dx/dy. dx(abs:-384|rel:-231) dy(abs:204|rel:357)
; node # 3 D(-46,54)->(-43,56)
       fcb 2 ; drawmode 
       fdb -17664,-10496 ; starx/y relative to previous node
       fdb -255,460 ; dx/dy. dx(abs:76|rel:460) dy(abs:-51|rel:-255)
; node # 4 D(-54,-3)->(-48,6)
       fcb 2 ; drawmode 
       fdb 14592,-2048 ; starx/y relative to previous node
       fdb -179,77 ; dx/dy. dx(abs:153|rel:77) dy(abs:-230|rel:-179)
; node # 5 DM(3,7)->(11,11)
       fcb -1 ; drawmode 
       fdb -2560,14592 ; starx/y relative to previous node
       fdb 128,51 ; dx/dy. dx(abs:204|rel:51) dy(abs:-102|rel:128)
; node # 6 DM(33,-39)->(32,-41)
       fcb -1 ; drawmode 
       fdb 11776,7680 ; starx/y relative to previous node
       fdb 153,-229 ; dx/dy. dx(abs:-25|rel:-229) dy(abs:51|rel:153)
; node # 7 M(-28,-63)->(-34,-57)
       fcb 0 ; drawmode 
       fdb 6144,-15616 ; starx/y relative to previous node
       fdb -204,-128 ; dx/dy. dx(abs:-153|rel:-128) dy(abs:-153|rel:-204)
; node # 8 D(34,-39)->(32,-42)
       fcb 2 ; drawmode 
       fdb -6144,15872 ; starx/y relative to previous node
       fdb 229,102 ; dx/dy. dx(abs:-51|rel:102) dy(abs:76|rel:229)
; node # 9 D(70,3)->(68,-8)
       fcb 2 ; drawmode 
       fdb -10752,9216 ; starx/y relative to previous node
       fdb 205,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:281|rel:205)
; node # 10 D(-5,-14)->(-20,-22)
       fcb 2 ; drawmode 
       fdb 4352,-19200 ; starx/y relative to previous node
       fdb -77,-333 ; dx/dy. dx(abs:-384|rel:-333) dy(abs:204|rel:-77)
; node # 11 M(70,3)->(68,-8)
       fcb 0 ; drawmode 
       fdb -4352,19200 ; starx/y relative to previous node
       fdb 77,333 ; dx/dy. dx(abs:-51|rel:333) dy(abs:281|rel:77)
; node # 12 D(24,57)->(34,57)
       fcb 2 ; drawmode 
       fdb -13824,-11776 ; starx/y relative to previous node
       fdb -281,307 ; dx/dy. dx(abs:256|rel:307) dy(abs:0|rel:-281)
; node # 13 D(-46,54)->(-43,57)
       fcb 2 ; drawmode 
       fdb 768,-17920 ; starx/y relative to previous node
       fdb -76,-180 ; dx/dy. dx(abs:76|rel:-180) dy(abs:-76|rel:-76)
; node # 14 M(24,57)->(34,57)
       fcb 0 ; drawmode 
       fdb -768,17920 ; starx/y relative to previous node
       fdb 76,180 ; dx/dy. dx(abs:256|rel:180) dy(abs:0|rel:76)
; node # 15 DM(3,8)->(11,11)
       fcb -1 ; drawmode 
       fdb 12544,-5376 ; starx/y relative to previous node
       fdb -76,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:-76|rel:-76)
       fcb  1  ; end of anim
; Animation 6
vidcubeglframe6:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-48,6)->(-41,13)
       fcb 0 ; drawmode 
       fdb -1536,-12288 ; starx/y relative to previous node
       fdb -179,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:-179|rel:-179)
; node # 1 D(-34,-57)->(-38,-49)
       fcb 2 ; drawmode 
       fdb 16128,3584 ; starx/y relative to previous node
       fdb -25,-281 ; dx/dy. dx(abs:-102|rel:-281) dy(abs:-204|rel:-25)
; node # 2 D(-20,-23)->(-36,-27)
       fcb 2 ; drawmode 
       fdb -8704,3584 ; starx/y relative to previous node
       fdb 306,-307 ; dx/dy. dx(abs:-409|rel:-307) dy(abs:102|rel:306)
; node # 3 D(-43,56)->(-40,55)
       fcb 2 ; drawmode 
       fdb -20224,-5888 ; starx/y relative to previous node
       fdb -77,485 ; dx/dy. dx(abs:76|rel:485) dy(abs:25|rel:-77)
; node # 4 D(-48,6)->(-41,13)
       fcb 2 ; drawmode 
       fdb 12800,-1280 ; starx/y relative to previous node
       fdb -204,103 ; dx/dy. dx(abs:179|rel:103) dy(abs:-179|rel:-204)
; node # 5 DM(11,11)->(19,14)
       fcb -1 ; drawmode 
       fdb -1280,15104 ; starx/y relative to previous node
       fdb 103,25 ; dx/dy. dx(abs:204|rel:25) dy(abs:-76|rel:103)
; node # 6 DM(32,-41)->(31,-43)
       fcb -1 ; drawmode 
       fdb 13312,5376 ; starx/y relative to previous node
       fdb 127,-229 ; dx/dy. dx(abs:-25|rel:-229) dy(abs:51|rel:127)
; node # 7 M(-34,-57)->(-38,-49)
       fcb 0 ; drawmode 
       fdb 4096,-16896 ; starx/y relative to previous node
       fdb -255,-77 ; dx/dy. dx(abs:-102|rel:-77) dy(abs:-204|rel:-255)
; node # 8 D(32,-42)->(31,-43)
       fcb 2 ; drawmode 
       fdb -3840,16896 ; starx/y relative to previous node
       fdb 229,77 ; dx/dy. dx(abs:-25|rel:77) dy(abs:25|rel:229)
; node # 9 D(68,-8)->(64,-21)
       fcb 2 ; drawmode 
       fdb -8704,9216 ; starx/y relative to previous node
       fdb 307,-77 ; dx/dy. dx(abs:-102|rel:-77) dy(abs:332|rel:307)
; node # 10 D(-20,-22)->(-36,-27)
       fcb 2 ; drawmode 
       fdb 3584,-22528 ; starx/y relative to previous node
       fdb -204,-307 ; dx/dy. dx(abs:-409|rel:-307) dy(abs:128|rel:-204)
; node # 11 M(68,-8)->(64,-21)
       fcb 0 ; drawmode 
       fdb -3584,22528 ; starx/y relative to previous node
       fdb 204,307 ; dx/dy. dx(abs:-102|rel:307) dy(abs:332|rel:204)
; node # 12 D(34,57)->(41,54)
       fcb 2 ; drawmode 
       fdb -16640,-8704 ; starx/y relative to previous node
       fdb -256,281 ; dx/dy. dx(abs:179|rel:281) dy(abs:76|rel:-256)
; node # 13 D(-43,57)->(-40,55)
       fcb 2 ; drawmode 
       fdb 0,-19712 ; starx/y relative to previous node
       fdb -25,-103 ; dx/dy. dx(abs:76|rel:-103) dy(abs:51|rel:-25)
; node # 14 M(34,57)->(40,54)
       fcb 0 ; drawmode 
       fdb 0,19712 ; starx/y relative to previous node
       fdb 25,77 ; dx/dy. dx(abs:153|rel:77) dy(abs:76|rel:25)
; node # 15 DM(11,11)->(19,14)
       fcb -1 ; drawmode 
       fdb 11776,-5888 ; starx/y relative to previous node
       fdb -152,51 ; dx/dy. dx(abs:204|rel:51) dy(abs:-76|rel:-152)
       fcb  1  ; end of anim
; Animation 7
vidcubeglframe7:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-41,13)->(-33,21)
       fcb 0 ; drawmode 
       fdb -3328,-10496 ; starx/y relative to previous node
       fdb -204,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-204|rel:-204)
; node # 1 DM(-38,-49)->(-38,-43)
       fcb -1 ; drawmode 
       fdb 15872,768 ; starx/y relative to previous node
       fdb 51,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:-153|rel:51)
; node # 2 D(-36,-27)->(-49,-30)
       fcb 2 ; drawmode 
       fdb -5632,512 ; starx/y relative to previous node
       fdb 229,-332 ; dx/dy. dx(abs:-332|rel:-332) dy(abs:76|rel:229)
; node # 3 D(-40,55)->(-39,57)
       fcb 2 ; drawmode 
       fdb -20992,-1024 ; starx/y relative to previous node
       fdb -127,357 ; dx/dy. dx(abs:25|rel:357) dy(abs:-51|rel:-127)
; node # 4 DM(-41,13)->(-33,21)
       fcb -1 ; drawmode 
       fdb 10752,-256 ; starx/y relative to previous node
       fdb -153,179 ; dx/dy. dx(abs:204|rel:179) dy(abs:-204|rel:-153)
; node # 5 DM(19,14)->(28,18)
       fcb -1 ; drawmode 
       fdb -256,15360 ; starx/y relative to previous node
       fdb 102,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-102|rel:102)
; node # 6 DM(31,-43)->(30,-45)
       fcb -1 ; drawmode 
       fdb 14592,3072 ; starx/y relative to previous node
       fdb 153,-255 ; dx/dy. dx(abs:-25|rel:-255) dy(abs:51|rel:153)
; node # 7 M(-38,-49)->(-38,-43)
       fcb 0 ; drawmode 
       fdb 1536,-17664 ; starx/y relative to previous node
       fdb -204,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-153|rel:-204)
; node # 8 D(31,-43)->(29,-45)
       fcb 2 ; drawmode 
       fdb -1536,17664 ; starx/y relative to previous node
       fdb 204,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:51|rel:204)
; node # 9 D(64,-21)->(54,-34)
       fcb 2 ; drawmode 
       fdb -5632,8448 ; starx/y relative to previous node
       fdb 281,-205 ; dx/dy. dx(abs:-256|rel:-205) dy(abs:332|rel:281)
; node # 10 D(-36,-27)->(-48,-30)
       fcb 2 ; drawmode 
       fdb 1536,-25600 ; starx/y relative to previous node
       fdb -256,-51 ; dx/dy. dx(abs:-307|rel:-51) dy(abs:76|rel:-256)
; node # 11 M(64,-21)->(54,-34)
       fcb 0 ; drawmode 
       fdb -1536,25600 ; starx/y relative to previous node
       fdb 256,51 ; dx/dy. dx(abs:-256|rel:51) dy(abs:332|rel:256)
; node # 12 D(41,54)->(48,51)
       fcb 2 ; drawmode 
       fdb -19200,-5888 ; starx/y relative to previous node
       fdb -256,435 ; dx/dy. dx(abs:179|rel:435) dy(abs:76|rel:-256)
; node # 13 D(-40,55)->(-39,58)
       fcb 2 ; drawmode 
       fdb -256,-20736 ; starx/y relative to previous node
       fdb -152,-154 ; dx/dy. dx(abs:25|rel:-154) dy(abs:-76|rel:-152)
; node # 14 M(40,54)->(48,51)
       fcb 0 ; drawmode 
       fdb 256,20480 ; starx/y relative to previous node
       fdb 152,179 ; dx/dy. dx(abs:204|rel:179) dy(abs:76|rel:152)
; node # 15 DM(19,14)->(28,18)
       fcb -1 ; drawmode 
       fdb 10240,-5376 ; starx/y relative to previous node
       fdb -178,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-102|rel:-178)
       fcb  1  ; end of anim
; Animation 8
vidcubeglframe8:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-33,21)->(-25,27)
       fcb 0 ; drawmode 
       fdb -5376,-8448 ; starx/y relative to previous node
       fdb -153,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-153|rel:-153)
; node # 1 DM(-38,-43)->(-37,-35)
       fcb -1 ; drawmode 
       fdb 16384,-1280 ; starx/y relative to previous node
       fdb -51,-179 ; dx/dy. dx(abs:25|rel:-179) dy(abs:-204|rel:-51)
; node # 2 D(-49,-30)->(-57,-27)
       fcb 2 ; drawmode 
       fdb -3328,-2816 ; starx/y relative to previous node
       fdb 128,-229 ; dx/dy. dx(abs:-204|rel:-229) dy(abs:-76|rel:128)
; node # 3 D(-39,57)->(-37,59)
       fcb 2 ; drawmode 
       fdb -22272,2560 ; starx/y relative to previous node
       fdb 25,255 ; dx/dy. dx(abs:51|rel:255) dy(abs:-51|rel:25)
; node # 4 DM(-33,21)->(-25,27)
       fcb -1 ; drawmode 
       fdb 9216,1536 ; starx/y relative to previous node
       fdb -102,153 ; dx/dy. dx(abs:204|rel:153) dy(abs:-153|rel:-102)
; node # 5 DM(28,18)->(36,18)
       fcb -1 ; drawmode 
       fdb 768,15616 ; starx/y relative to previous node
       fdb 153,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:0|rel:153)
; node # 6 DM(30,-45)->(27,-46)
       fcb -1 ; drawmode 
       fdb 16128,512 ; starx/y relative to previous node
       fdb 25,-280 ; dx/dy. dx(abs:-76|rel:-280) dy(abs:25|rel:25)
; node # 7 M(-38,-43)->(-37,-35)
       fcb 0 ; drawmode 
       fdb -512,-17408 ; starx/y relative to previous node
       fdb -229,101 ; dx/dy. dx(abs:25|rel:101) dy(abs:-204|rel:-229)
; node # 8 D(29,-45)->(27,-46)
       fcb 2 ; drawmode 
       fdb 512,17152 ; starx/y relative to previous node
       fdb 229,-76 ; dx/dy. dx(abs:-51|rel:-76) dy(abs:25|rel:229)
; node # 9 D(54,-34)->(40,-45)
       fcb 2 ; drawmode 
       fdb -2816,6400 ; starx/y relative to previous node
       fdb 256,-307 ; dx/dy. dx(abs:-358|rel:-307) dy(abs:281|rel:256)
; node # 10 D(-48,-30)->(-57,-28)
       fcb 2 ; drawmode 
       fdb -1024,-26112 ; starx/y relative to previous node
       fdb -332,128 ; dx/dy. dx(abs:-230|rel:128) dy(abs:-51|rel:-332)
; node # 11 M(54,-34)->(40,-45)
       fcb 0 ; drawmode 
       fdb 1024,26112 ; starx/y relative to previous node
       fdb 332,-128 ; dx/dy. dx(abs:-358|rel:-128) dy(abs:281|rel:332)
; node # 12 D(48,51)->(53,46)
       fcb 2 ; drawmode 
       fdb -21760,-1536 ; starx/y relative to previous node
       fdb -153,486 ; dx/dy. dx(abs:128|rel:486) dy(abs:128|rel:-153)
; node # 13 D(-39,58)->(-37,59)
       fcb 2 ; drawmode 
       fdb -1792,-22272 ; starx/y relative to previous node
       fdb -153,-77 ; dx/dy. dx(abs:51|rel:-77) dy(abs:-25|rel:-153)
; node # 14 M(48,51)->(53,46)
       fcb 0 ; drawmode 
       fdb 1792,22272 ; starx/y relative to previous node
       fdb 153,77 ; dx/dy. dx(abs:128|rel:77) dy(abs:128|rel:153)
; node # 15 DM(28,18)->(36,18)
       fcb -1 ; drawmode 
       fdb 8448,-5120 ; starx/y relative to previous node
       fdb -128,76 ; dx/dy. dx(abs:204|rel:76) dy(abs:0|rel:-128)
       fcb  1  ; end of anim
; Animation 9
vidcubeglframe9:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-25,27)->(-15,34)
       fcb 0 ; drawmode 
       fdb -6912,-6400 ; starx/y relative to previous node
       fdb -179,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-179|rel:-179)
; node # 1 DM(-37,-35)->(-35,-25)
       fcb -1 ; drawmode 
       fdb 15872,-3072 ; starx/y relative to previous node
       fdb -77,-205 ; dx/dy. dx(abs:51|rel:-205) dy(abs:-256|rel:-77)
; node # 2 DM(-57,-27)->(-64,-24)
       fcb -1 ; drawmode 
       fdb -2048,-5120 ; starx/y relative to previous node
       fdb 180,-230 ; dx/dy. dx(abs:-179|rel:-230) dy(abs:-76|rel:180)
; node # 3 D(-37,59)->(-34,62)
       fcb 2 ; drawmode 
       fdb -22016,5120 ; starx/y relative to previous node
       fdb 0,255 ; dx/dy. dx(abs:76|rel:255) dy(abs:-76|rel:0)
; node # 4 DM(-25,27)->(-15,34)
       fcb -1 ; drawmode 
       fdb 8192,3072 ; starx/y relative to previous node
       fdb -103,180 ; dx/dy. dx(abs:256|rel:180) dy(abs:-179|rel:-103)
; node # 5 DM(36,18)->(44,16)
       fcb -1 ; drawmode 
       fdb 2304,15616 ; starx/y relative to previous node
       fdb 230,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:51|rel:230)
; node # 6 DM(27,-46)->(25,-46)
       fcb -1 ; drawmode 
       fdb 16384,-2304 ; starx/y relative to previous node
       fdb -51,-255 ; dx/dy. dx(abs:-51|rel:-255) dy(abs:0|rel:-51)
; node # 7 M(-37,-35)->(-36,-25)
       fcb 0 ; drawmode 
       fdb -2816,-16384 ; starx/y relative to previous node
       fdb -256,76 ; dx/dy. dx(abs:25|rel:76) dy(abs:-256|rel:-256)
; node # 8 DM(27,-46)->(25,-46)
       fcb -1 ; drawmode 
       fdb 2816,16384 ; starx/y relative to previous node
       fdb 256,-76 ; dx/dy. dx(abs:-51|rel:-76) dy(abs:0|rel:256)
; node # 9 DM(40,-45)->(25,-56)
       fcb -1 ; drawmode 
       fdb -256,3328 ; starx/y relative to previous node
       fdb 281,-333 ; dx/dy. dx(abs:-384|rel:-333) dy(abs:281|rel:281)
; node # 10 D(-57,-28)->(-64,-24)
       fcb 2 ; drawmode 
       fdb -4352,-24832 ; starx/y relative to previous node
       fdb -383,205 ; dx/dy. dx(abs:-179|rel:205) dy(abs:-102|rel:-383)
; node # 11 M(40,-45)->(25,-56)
       fcb 0 ; drawmode 
       fdb 4352,24832 ; starx/y relative to previous node
       fdb 383,-205 ; dx/dy. dx(abs:-384|rel:-205) dy(abs:281|rel:383)
; node # 12 D(53,46)->(55,38)
       fcb 2 ; drawmode 
       fdb -23296,3328 ; starx/y relative to previous node
       fdb -77,435 ; dx/dy. dx(abs:51|rel:435) dy(abs:204|rel:-77)
; node # 13 D(-37,59)->(-34,62)
       fcb 2 ; drawmode 
       fdb -3328,-23040 ; starx/y relative to previous node
       fdb -280,25 ; dx/dy. dx(abs:76|rel:25) dy(abs:-76|rel:-280)
; node # 14 M(53,46)->(55,38)
       fcb 0 ; drawmode 
       fdb 3328,23040 ; starx/y relative to previous node
       fdb 280,-25 ; dx/dy. dx(abs:51|rel:-25) dy(abs:204|rel:280)
; node # 15 DM(36,18)->(44,17)
       fcb -1 ; drawmode 
       fdb 7168,-4352 ; starx/y relative to previous node
       fdb -179,153 ; dx/dy. dx(abs:204|rel:153) dy(abs:25|rel:-179)
       fcb  1  ; end of anim
; Animation 10
vidcubeglframe10:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-15,34)->(-7,39)
       fcb 0 ; drawmode 
       fdb -8704,-3840 ; starx/y relative to previous node
       fdb -128,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-128|rel:-128)
; node # 1 DM(-35,-25)->(-31,-19)
       fcb -1 ; drawmode 
       fdb 15104,-5120 ; starx/y relative to previous node
       fdb -25,-102 ; dx/dy. dx(abs:102|rel:-102) dy(abs:-153|rel:-25)
; node # 2 DM(-64,-24)->(-68,-18)
       fcb -1 ; drawmode 
       fdb -256,-7424 ; starx/y relative to previous node
       fdb 0,-204 ; dx/dy. dx(abs:-102|rel:-204) dy(abs:-153|rel:0)
; node # 3 D(-34,62)->(-32,63)
       fcb 2 ; drawmode 
       fdb -22016,7680 ; starx/y relative to previous node
       fdb 128,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:-25|rel:128)
; node # 4 DM(-15,34)->(-7,39)
       fcb -1 ; drawmode 
       fdb 7168,4864 ; starx/y relative to previous node
       fdb -103,153 ; dx/dy. dx(abs:204|rel:153) dy(abs:-128|rel:-103)
; node # 5 DM(44,16)->(52,14)
       fcb -1 ; drawmode 
       fdb 4608,15104 ; starx/y relative to previous node
       fdb 179,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:51|rel:179)
; node # 6 D(25,-46)->(23,-46)
       fcb 2 ; drawmode 
       fdb 15872,-4864 ; starx/y relative to previous node
       fdb -51,-255 ; dx/dy. dx(abs:-51|rel:-255) dy(abs:0|rel:-51)
; node # 7 M(-36,-25)->(-31,-19)
       fcb 0 ; drawmode 
       fdb -5376,-15616 ; starx/y relative to previous node
       fdb -153,179 ; dx/dy. dx(abs:128|rel:179) dy(abs:-153|rel:-153)
; node # 8 DM(25,-46)->(23,-46)
       fcb -1 ; drawmode 
       fdb 5376,15616 ; starx/y relative to previous node
       fdb 153,-179 ; dx/dy. dx(abs:-51|rel:-179) dy(abs:0|rel:153)
; node # 9 D(25,-56)->(10,-63)
       fcb 2 ; drawmode 
       fdb 2560,0 ; starx/y relative to previous node
       fdb 179,-333 ; dx/dy. dx(abs:-384|rel:-333) dy(abs:179|rel:179)
; node # 10 D(-64,-24)->(-68,-18)
       fcb 2 ; drawmode 
       fdb -8192,-22784 ; starx/y relative to previous node
       fdb -332,282 ; dx/dy. dx(abs:-102|rel:282) dy(abs:-153|rel:-332)
; node # 11 M(25,-56)->(10,-63)
       fcb 0 ; drawmode 
       fdb 8192,22784 ; starx/y relative to previous node
       fdb 332,-282 ; dx/dy. dx(abs:-384|rel:-282) dy(abs:179|rel:332)
; node # 12 D(55,38)->(52,29)
       fcb 2 ; drawmode 
       fdb -24064,7680 ; starx/y relative to previous node
       fdb 51,308 ; dx/dy. dx(abs:-76|rel:308) dy(abs:230|rel:51)
; node # 13 D(-34,62)->(-32,63)
       fcb 2 ; drawmode 
       fdb -6144,-22784 ; starx/y relative to previous node
       fdb -255,127 ; dx/dy. dx(abs:51|rel:127) dy(abs:-25|rel:-255)
; node # 14 M(55,38)->(52,29)
       fcb 0 ; drawmode 
       fdb 6144,22784 ; starx/y relative to previous node
       fdb 255,-127 ; dx/dy. dx(abs:-76|rel:-127) dy(abs:230|rel:255)
; node # 15 D(44,17)->(52,14)
       fcb 2 ; drawmode 
       fdb 5376,-2816 ; starx/y relative to previous node
       fdb -154,280 ; dx/dy. dx(abs:204|rel:280) dy(abs:76|rel:-154)
       fcb  1  ; end of anim
; Animation 11
vidcubeglframe11:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-7,39)->(4,43)
       fcb 0 ; drawmode 
       fdb -9984,-1792 ; starx/y relative to previous node
       fdb -102,281 ; dx/dy. dx(abs:281|rel:281) dy(abs:-102|rel:-102)
; node # 1 DM(-31,-19)->(-25,-11)
       fcb -1 ; drawmode 
       fdb 14848,-6144 ; starx/y relative to previous node
       fdb -102,-128 ; dx/dy. dx(abs:153|rel:-128) dy(abs:-204|rel:-102)
; node # 2 DM(-68,-18)->(-69,-12)
       fcb -1 ; drawmode 
       fdb -256,-9472 ; starx/y relative to previous node
       fdb 51,-178 ; dx/dy. dx(abs:-25|rel:-178) dy(abs:-153|rel:51)
; node # 3 D(-32,63)->(-32,63)
       fcb 2 ; drawmode 
       fdb -20736,9216 ; starx/y relative to previous node
       fdb 153,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:0|rel:153)
; node # 4 DM(-7,39)->(4,44)
       fcb -1 ; drawmode 
       fdb 6144,6400 ; starx/y relative to previous node
       fdb -128,281 ; dx/dy. dx(abs:281|rel:281) dy(abs:-128|rel:-128)
; node # 5 DM(52,14)->(58,11)
       fcb -1 ; drawmode 
       fdb 6400,15104 ; starx/y relative to previous node
       fdb 204,-128 ; dx/dy. dx(abs:153|rel:-128) dy(abs:76|rel:204)
; node # 6 D(23,-46)->(23,-46)
       fcb 2 ; drawmode 
       fdb 15360,-7424 ; starx/y relative to previous node
       fdb -76,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:-76)
; node # 7 M(-31,-19)->(-26,-11)
       fcb 0 ; drawmode 
       fdb -6912,-13824 ; starx/y relative to previous node
       fdb -204,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-204|rel:-204)
; node # 8 DM(23,-46)->(23,-46)
       fcb -1 ; drawmode 
       fdb 6912,13824 ; starx/y relative to previous node
       fdb 204,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:0|rel:204)
; node # 9 D(10,-63)->(-6,-67)
       fcb 2 ; drawmode 
       fdb 4352,-3328 ; starx/y relative to previous node
       fdb 102,-409 ; dx/dy. dx(abs:-409|rel:-409) dy(abs:102|rel:102)
; node # 10 D(-68,-18)->(-69,-12)
       fcb 2 ; drawmode 
       fdb -11520,-19968 ; starx/y relative to previous node
       fdb -255,384 ; dx/dy. dx(abs:-25|rel:384) dy(abs:-153|rel:-255)
; node # 11 M(10,-63)->(-6,-67)
       fcb 0 ; drawmode 
       fdb 11520,19968 ; starx/y relative to previous node
       fdb 255,-384 ; dx/dy. dx(abs:-409|rel:-384) dy(abs:102|rel:255)
; node # 12 D(52,29)->(46,18)
       fcb 2 ; drawmode 
       fdb -23552,10752 ; starx/y relative to previous node
       fdb 179,256 ; dx/dy. dx(abs:-153|rel:256) dy(abs:281|rel:179)
; node # 13 D(-32,63)->(-32,63)
       fcb 2 ; drawmode 
       fdb -8704,-21504 ; starx/y relative to previous node
       fdb -281,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:0|rel:-281)
; node # 14 M(52,29)->(46,19)
       fcb 0 ; drawmode 
       fdb 8704,21504 ; starx/y relative to previous node
       fdb 256,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:256|rel:256)
; node # 15 D(52,14)->(58,11)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -180,306 ; dx/dy. dx(abs:153|rel:306) dy(abs:76|rel:-180)
       fcb  1  ; end of anim
; Animation 12
vidcubeglframe12:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(4,43)->(13,45)
       fcb 0 ; drawmode 
       fdb -11008,1024 ; starx/y relative to previous node
       fdb -51,230 ; dx/dy. dx(abs:230|rel:230) dy(abs:-51|rel:-51)
; node # 1 DM(-25,-11)->(-19,-4)
       fcb -1 ; drawmode 
       fdb 13824,-7424 ; starx/y relative to previous node
       fdb -128,-77 ; dx/dy. dx(abs:153|rel:-77) dy(abs:-179|rel:-128)
; node # 2 DM(-69,-12)->(-68,-5)
       fcb -1 ; drawmode 
       fdb 256,-11264 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:25|rel:-128) dy(abs:-179|rel:0)
; node # 3 D(-32,63)->(-28,64)
       fcb 2 ; drawmode 
       fdb -19200,9472 ; starx/y relative to previous node
       fdb 154,77 ; dx/dy. dx(abs:102|rel:77) dy(abs:-25|rel:154)
; node # 4 D(4,44)->(14,46)
       fcb 2 ; drawmode 
       fdb 4864,9216 ; starx/y relative to previous node
       fdb -26,154 ; dx/dy. dx(abs:256|rel:154) dy(abs:-51|rel:-26)
; node # 5 D(58,11)->(64,5)
       fcb 2 ; drawmode 
       fdb 8448,13824 ; starx/y relative to previous node
       fdb 204,-103 ; dx/dy. dx(abs:153|rel:-103) dy(abs:153|rel:204)
; node # 6 D(23,-46)->(21,-46)
       fcb 2 ; drawmode 
       fdb 14592,-8960 ; starx/y relative to previous node
       fdb -153,-204 ; dx/dy. dx(abs:-51|rel:-204) dy(abs:0|rel:-153)
; node # 7 M(-26,-11)->(-19,-4)
       fcb 0 ; drawmode 
       fdb -8960,-12544 ; starx/y relative to previous node
       fdb -179,230 ; dx/dy. dx(abs:179|rel:230) dy(abs:-179|rel:-179)
; node # 8 DM(23,-46)->(21,-46)
       fcb -1 ; drawmode 
       fdb 8960,12544 ; starx/y relative to previous node
       fdb 179,-230 ; dx/dy. dx(abs:-51|rel:-230) dy(abs:0|rel:179)
; node # 9 D(-6,-67)->(-19,-67)
       fcb 2 ; drawmode 
       fdb 5376,-7424 ; starx/y relative to previous node
       fdb 0,-281 ; dx/dy. dx(abs:-332|rel:-281) dy(abs:0|rel:0)
; node # 10 D(-69,-12)->(-68,-5)
       fcb 2 ; drawmode 
       fdb -14080,-16128 ; starx/y relative to previous node
       fdb -179,357 ; dx/dy. dx(abs:25|rel:357) dy(abs:-179|rel:-179)
; node # 11 M(-6,-67)->(-19,-67)
       fcb 0 ; drawmode 
       fdb 14080,16128 ; starx/y relative to previous node
       fdb 179,-357 ; dx/dy. dx(abs:-332|rel:-357) dy(abs:0|rel:179)
; node # 12 D(46,18)->(38,5)
       fcb 2 ; drawmode 
       fdb -21760,13312 ; starx/y relative to previous node
       fdb 332,128 ; dx/dy. dx(abs:-204|rel:128) dy(abs:332|rel:332)
; node # 13 D(-32,63)->(-28,64)
       fcb 2 ; drawmode 
       fdb -11520,-19968 ; starx/y relative to previous node
       fdb -357,306 ; dx/dy. dx(abs:102|rel:306) dy(abs:-25|rel:-357)
; node # 14 M(46,19)->(38,5)
       fcb 0 ; drawmode 
       fdb 11264,19968 ; starx/y relative to previous node
       fdb 383,-306 ; dx/dy. dx(abs:-204|rel:-306) dy(abs:358|rel:383)
; node # 15 D(58,11)->(64,5)
       fcb 2 ; drawmode 
       fdb 2048,3072 ; starx/y relative to previous node
       fdb -205,357 ; dx/dy. dx(abs:153|rel:357) dy(abs:153|rel:-205)
       fcb  1  ; end of anim
; Animation 13
vidcubeglframe13:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(13,45)->(23,47)
       fcb 0 ; drawmode 
       fdb -11520,3328 ; starx/y relative to previous node
       fdb -51,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-51|rel:-51)
; node # 1 DM(-19,-4)->(-12,2)
       fcb -1 ; drawmode 
       fdb 12544,-8192 ; starx/y relative to previous node
       fdb -102,-77 ; dx/dy. dx(abs:179|rel:-77) dy(abs:-153|rel:-102)
; node # 2 DM(-68,-5)->(-64,2)
       fcb -1 ; drawmode 
       fdb 256,-12544 ; starx/y relative to previous node
       fdb -26,-77 ; dx/dy. dx(abs:102|rel:-77) dy(abs:-179|rel:-26)
; node # 3 D(-28,64)->(-28,64)
       fcb 2 ; drawmode 
       fdb -17664,10240 ; starx/y relative to previous node
       fdb 179,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:179)
; node # 4 D(14,46)->(23,48)
       fcb 2 ; drawmode 
       fdb 4608,10752 ; starx/y relative to previous node
       fdb -51,230 ; dx/dy. dx(abs:230|rel:230) dy(abs:-51|rel:-51)
; node # 5 D(64,5)->(66,-4)
       fcb 2 ; drawmode 
       fdb 10496,12800 ; starx/y relative to previous node
       fdb 281,-179 ; dx/dy. dx(abs:51|rel:-179) dy(abs:230|rel:281)
; node # 6 D(21,-46)->(21,-46)
       fcb 2 ; drawmode 
       fdb 13056,-11008 ; starx/y relative to previous node
       fdb -230,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:0|rel:-230)
; node # 7 M(-19,-4)->(-12,2)
       fcb 0 ; drawmode 
       fdb -10752,-10240 ; starx/y relative to previous node
       fdb -153,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:-153|rel:-153)
; node # 8 DM(21,-46)->(21,-46)
       fcb -1 ; drawmode 
       fdb 10752,10240 ; starx/y relative to previous node
       fdb 153,-179 ; dx/dy. dx(abs:0|rel:-179) dy(abs:0|rel:153)
; node # 9 D(-19,-67)->(-30,-64)
       fcb 2 ; drawmode 
       fdb 5376,-10240 ; starx/y relative to previous node
       fdb -76,-281 ; dx/dy. dx(abs:-281|rel:-281) dy(abs:-76|rel:-76)
; node # 10 D(-68,-5)->(-64,2)
       fcb 2 ; drawmode 
       fdb -15872,-12544 ; starx/y relative to previous node
       fdb -103,383 ; dx/dy. dx(abs:102|rel:383) dy(abs:-179|rel:-103)
; node # 11 M(-19,-67)->(-30,-64)
       fcb 0 ; drawmode 
       fdb 15872,12544 ; starx/y relative to previous node
       fdb 103,-383 ; dx/dy. dx(abs:-281|rel:-383) dy(abs:-76|rel:103)
; node # 12 D(38,5)->(25,-8)
       fcb 2 ; drawmode 
       fdb -18432,14592 ; starx/y relative to previous node
       fdb 408,-51 ; dx/dy. dx(abs:-332|rel:-51) dy(abs:332|rel:408)
; node # 13 D(-28,64)->(-28,64)
       fcb 2 ; drawmode 
       fdb -15104,-16896 ; starx/y relative to previous node
       fdb -332,332 ; dx/dy. dx(abs:0|rel:332) dy(abs:0|rel:-332)
; node # 14 M(38,5)->(25,-7)
       fcb 0 ; drawmode 
       fdb 15104,16896 ; starx/y relative to previous node
       fdb 307,-332 ; dx/dy. dx(abs:-332|rel:-332) dy(abs:307|rel:307)
; node # 15 D(64,5)->(66,-4)
       fcb 2 ; drawmode 
       fdb 0,6656 ; starx/y relative to previous node
       fdb -77,383 ; dx/dy. dx(abs:51|rel:383) dy(abs:230|rel:-77)
       fcb  1  ; end of anim
; Animation 14
vidcubeglframe14:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(23,47)->(33,49)
       fcb 0 ; drawmode 
       fdb -12032,5888 ; starx/y relative to previous node
       fdb -51,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-51|rel:-51)
; node # 1 DM(-12,2)->(-5,9)
       fcb -1 ; drawmode 
       fdb 11520,-8960 ; starx/y relative to previous node
       fdb -128,-77 ; dx/dy. dx(abs:179|rel:-77) dy(abs:-179|rel:-128)
; node # 2 DM(-64,2)->(-60,10)
       fcb -1 ; drawmode 
       fdb 0,-13312 ; starx/y relative to previous node
       fdb -25,-77 ; dx/dy. dx(abs:102|rel:-77) dy(abs:-204|rel:-25)
; node # 3 D(-28,64)->(-28,64)
       fcb 2 ; drawmode 
       fdb -15872,9216 ; starx/y relative to previous node
       fdb 204,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:204)
; node # 4 D(23,48)->(33,49)
       fcb 2 ; drawmode 
       fdb 4096,13056 ; starx/y relative to previous node
       fdb -25,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-25|rel:-25)
; node # 5 D(66,-4)->(68,-13)
       fcb 2 ; drawmode 
       fdb 13312,11008 ; starx/y relative to previous node
       fdb 255,-205 ; dx/dy. dx(abs:51|rel:-205) dy(abs:230|rel:255)
; node # 6 D(21,-46)->(19,-45)
       fcb 2 ; drawmode 
       fdb 10752,-11520 ; starx/y relative to previous node
       fdb -255,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:-25|rel:-255)
; node # 7 M(-12,2)->(-4,9)
       fcb 0 ; drawmode 
       fdb -12288,-8448 ; starx/y relative to previous node
       fdb -154,255 ; dx/dy. dx(abs:204|rel:255) dy(abs:-179|rel:-154)
; node # 8 DM(21,-46)->(19,-45)
       fcb -1 ; drawmode 
       fdb 12288,8448 ; starx/y relative to previous node
       fdb 154,-255 ; dx/dy. dx(abs:-51|rel:-255) dy(abs:-25|rel:154)
; node # 9 D(-30,-64)->(-38,-58)
       fcb 2 ; drawmode 
       fdb 4608,-13056 ; starx/y relative to previous node
       fdb -128,-153 ; dx/dy. dx(abs:-204|rel:-153) dy(abs:-153|rel:-128)
; node # 10 D(-64,2)->(-60,10)
       fcb 2 ; drawmode 
       fdb -16896,-8704 ; starx/y relative to previous node
       fdb -51,306 ; dx/dy. dx(abs:102|rel:306) dy(abs:-204|rel:-51)
; node # 11 M(-30,-64)->(-39,-58)
       fcb 0 ; drawmode 
       fdb 16896,8704 ; starx/y relative to previous node
       fdb 51,-332 ; dx/dy. dx(abs:-230|rel:-332) dy(abs:-153|rel:51)
; node # 12 D(25,-8)->(10,-20)
       fcb 2 ; drawmode 
       fdb -14336,14080 ; starx/y relative to previous node
       fdb 460,-154 ; dx/dy. dx(abs:-384|rel:-154) dy(abs:307|rel:460)
; node # 13 D(-28,64)->(-28,64)
       fcb 2 ; drawmode 
       fdb -18432,-13568 ; starx/y relative to previous node
       fdb -307,384 ; dx/dy. dx(abs:0|rel:384) dy(abs:0|rel:-307)
; node # 14 M(25,-7)->(10,-20)
       fcb 0 ; drawmode 
       fdb 18176,13568 ; starx/y relative to previous node
       fdb 332,-384 ; dx/dy. dx(abs:-384|rel:-384) dy(abs:332|rel:332)
; node # 15 D(66,-4)->(68,-13)
       fcb 2 ; drawmode 
       fdb -768,10496 ; starx/y relative to previous node
       fdb -102,435 ; dx/dy. dx(abs:51|rel:435) dy(abs:230|rel:-102)
       fcb  1  ; end of anim
; Animation 15
vidcubeglframe15:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(33,49)->(41,49)
       fcb 0 ; drawmode 
       fdb -12544,8448 ; starx/y relative to previous node
       fdb 0,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:0|rel:0)
; node # 1 DM(-5,9)->(4,15)
       fcb -1 ; drawmode 
       fdb 10240,-9728 ; starx/y relative to previous node
       fdb -153,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-153|rel:-153)
; node # 2 DM(-60,10)->(-54,19)
       fcb -1 ; drawmode 
       fdb -256,-14080 ; starx/y relative to previous node
       fdb -77,-77 ; dx/dy. dx(abs:153|rel:-77) dy(abs:-230|rel:-77)
; node # 3 D(-28,64)->(-25,63)
       fcb 2 ; drawmode 
       fdb -13824,8192 ; starx/y relative to previous node
       fdb 255,-77 ; dx/dy. dx(abs:76|rel:-77) dy(abs:25|rel:255)
; node # 4 D(33,49)->(41,49)
       fcb 2 ; drawmode 
       fdb 3840,15616 ; starx/y relative to previous node
       fdb -25,128 ; dx/dy. dx(abs:204|rel:128) dy(abs:0|rel:-25)
; node # 5 D(68,-13)->(65,-24)
       fcb 2 ; drawmode 
       fdb 15872,8960 ; starx/y relative to previous node
       fdb 281,-280 ; dx/dy. dx(abs:-76|rel:-280) dy(abs:281|rel:281)
; node # 6 D(19,-45)->(18,-44)
       fcb 2 ; drawmode 
       fdb 8192,-12544 ; starx/y relative to previous node
       fdb -306,51 ; dx/dy. dx(abs:-25|rel:51) dy(abs:-25|rel:-306)
; node # 7 M(-4,9)->(4,15)
       fcb 0 ; drawmode 
       fdb -13824,-5888 ; starx/y relative to previous node
       fdb -128,229 ; dx/dy. dx(abs:204|rel:229) dy(abs:-153|rel:-128)
; node # 8 DM(19,-45)->(18,-44)
       fcb -1 ; drawmode 
       fdb 13824,5888 ; starx/y relative to previous node
       fdb 128,-229 ; dx/dy. dx(abs:-25|rel:-229) dy(abs:-25|rel:128)
; node # 9 D(-38,-58)->(-44,-52)
       fcb 2 ; drawmode 
       fdb 3328,-14592 ; starx/y relative to previous node
       fdb -128,-128 ; dx/dy. dx(abs:-153|rel:-128) dy(abs:-153|rel:-128)
; node # 10 D(-60,10)->(-54,18)
       fcb 2 ; drawmode 
       fdb -17408,-5632 ; starx/y relative to previous node
       fdb -51,306 ; dx/dy. dx(abs:153|rel:306) dy(abs:-204|rel:-51)
; node # 11 M(-39,-58)->(-44,-52)
       fcb 0 ; drawmode 
       fdb 17408,5376 ; starx/y relative to previous node
       fdb 51,-281 ; dx/dy. dx(abs:-128|rel:-281) dy(abs:-153|rel:51)
; node # 12 D(10,-20)->(-6,-30)
       fcb 2 ; drawmode 
       fdb -9728,12544 ; starx/y relative to previous node
       fdb 409,-281 ; dx/dy. dx(abs:-409|rel:-281) dy(abs:256|rel:409)
; node # 13 D(-28,64)->(-25,63)
       fcb 2 ; drawmode 
       fdb -21504,-9728 ; starx/y relative to previous node
       fdb -231,485 ; dx/dy. dx(abs:76|rel:485) dy(abs:25|rel:-231)
; node # 14 M(10,-20)->(-7,-30)
       fcb 0 ; drawmode 
       fdb 21504,9728 ; starx/y relative to previous node
       fdb 231,-511 ; dx/dy. dx(abs:-435|rel:-511) dy(abs:256|rel:231)
; node # 15 D(68,-13)->(65,-24)
       fcb 2 ; drawmode 
       fdb -1792,14848 ; starx/y relative to previous node
       fdb 25,359 ; dx/dy. dx(abs:-76|rel:359) dy(abs:281|rel:25)
       fcb  1  ; end of anim
; Animation 16
vidcubeglframe16:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(41,49)->(49,47)
       fcb 0 ; drawmode 
       fdb -12544,10496 ; starx/y relative to previous node
       fdb 51,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:51|rel:51)
; node # 1 DM(4,15)->(13,19)
       fcb -1 ; drawmode 
       fdb 8704,-9472 ; starx/y relative to previous node
       fdb -153,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-102|rel:-153)
; node # 2 DM(-54,19)->(-47,25)
       fcb -1 ; drawmode 
       fdb -1024,-14848 ; starx/y relative to previous node
       fdb -51,-51 ; dx/dy. dx(abs:179|rel:-51) dy(abs:-153|rel:-51)
; node # 3 D(-25,63)->(-25,62)
       fcb 2 ; drawmode 
       fdb -11264,7424 ; starx/y relative to previous node
       fdb 178,-179 ; dx/dy. dx(abs:0|rel:-179) dy(abs:25|rel:178)
; node # 4 D(41,49)->(50,47)
       fcb 2 ; drawmode 
       fdb 3584,16896 ; starx/y relative to previous node
       fdb 26,230 ; dx/dy. dx(abs:230|rel:230) dy(abs:51|rel:26)
; node # 5 D(65,-24)->(61,-35)
       fcb 2 ; drawmode 
       fdb 18688,6144 ; starx/y relative to previous node
       fdb 230,-332 ; dx/dy. dx(abs:-102|rel:-332) dy(abs:281|rel:230)
; node # 6 D(18,-44)->(17,-42)
       fcb 2 ; drawmode 
       fdb 5120,-12032 ; starx/y relative to previous node
       fdb -332,77 ; dx/dy. dx(abs:-25|rel:77) dy(abs:-51|rel:-332)
; node # 7 M(4,15)->(13,19)
       fcb 0 ; drawmode 
       fdb -15104,-3584 ; starx/y relative to previous node
       fdb -51,255 ; dx/dy. dx(abs:230|rel:255) dy(abs:-102|rel:-51)
; node # 8 DM(18,-44)->(18,-42)
       fcb -1 ; drawmode 
       fdb 15104,3584 ; starx/y relative to previous node
       fdb 51,-230 ; dx/dy. dx(abs:0|rel:-230) dy(abs:-51|rel:51)
; node # 9 D(-44,-52)->(-47,-43)
       fcb 2 ; drawmode 
       fdb 2048,-15872 ; starx/y relative to previous node
       fdb -179,-76 ; dx/dy. dx(abs:-76|rel:-76) dy(abs:-230|rel:-179)
; node # 10 D(-54,18)->(-47,25)
       fcb 2 ; drawmode 
       fdb -17920,-2560 ; starx/y relative to previous node
       fdb 51,255 ; dx/dy. dx(abs:179|rel:255) dy(abs:-179|rel:51)
; node # 11 M(-44,-52)->(-47,-43)
       fcb 0 ; drawmode 
       fdb 17920,2560 ; starx/y relative to previous node
       fdb -51,-255 ; dx/dy. dx(abs:-76|rel:-255) dy(abs:-230|rel:-51)
; node # 12 D(-6,-30)->(-24,-36)
       fcb 2 ; drawmode 
       fdb -5632,9728 ; starx/y relative to previous node
       fdb 383,-384 ; dx/dy. dx(abs:-460|rel:-384) dy(abs:153|rel:383)
; node # 13 D(-25,63)->(-25,62)
       fcb 2 ; drawmode 
       fdb -23808,-4864 ; starx/y relative to previous node
       fdb -128,460 ; dx/dy. dx(abs:0|rel:460) dy(abs:25|rel:-128)
; node # 14 M(-7,-30)->(-24,-36)
       fcb 0 ; drawmode 
       fdb 23808,4608 ; starx/y relative to previous node
       fdb 128,-435 ; dx/dy. dx(abs:-435|rel:-435) dy(abs:153|rel:128)
; node # 15 D(65,-24)->(61,-35)
       fcb 2 ; drawmode 
       fdb -1536,18432 ; starx/y relative to previous node
       fdb 128,333 ; dx/dy. dx(abs:-102|rel:333) dy(abs:281|rel:128)
       fcb  1  ; end of anim
; Animation 17
vidcubeglframe17:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(49,47)->(56,41)
       fcb 0 ; drawmode 
       fdb -12032,12544 ; starx/y relative to previous node
       fdb 153,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:153|rel:153)
; node # 1 DM(13,19)->(20,21)
       fcb -1 ; drawmode 
       fdb 7168,-9216 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:179|rel:0) dy(abs:-51|rel:-204)
; node # 2 DM(-47,25)->(-40,32)
       fcb -1 ; drawmode 
       fdb -1536,-15360 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:179|rel:0) dy(abs:-179|rel:-128)
; node # 3 D(-25,62)->(-28,60)
       fcb 2 ; drawmode 
       fdb -9472,5632 ; starx/y relative to previous node
       fdb 230,-255 ; dx/dy. dx(abs:-76|rel:-255) dy(abs:51|rel:230)
; node # 4 D(50,47)->(57,42)
       fcb 2 ; drawmode 
       fdb 3840,19200 ; starx/y relative to previous node
       fdb 77,255 ; dx/dy. dx(abs:179|rel:255) dy(abs:128|rel:77)
; node # 5 D(61,-35)->(55,-44)
       fcb 2 ; drawmode 
       fdb 20992,2816 ; starx/y relative to previous node
       fdb 102,-332 ; dx/dy. dx(abs:-153|rel:-332) dy(abs:230|rel:102)
; node # 6 D(17,-42)->(17,-39)
       fcb 2 ; drawmode 
       fdb 1792,-11264 ; starx/y relative to previous node
       fdb -306,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:-76|rel:-306)
; node # 7 M(13,19)->(20,21)
       fcb 0 ; drawmode 
       fdb -15616,-1024 ; starx/y relative to previous node
       fdb 25,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:-51|rel:25)
; node # 8 DM(18,-42)->(18,-39)
       fcb -1 ; drawmode 
       fdb 15616,1280 ; starx/y relative to previous node
       fdb -25,-179 ; dx/dy. dx(abs:0|rel:-179) dy(abs:-76|rel:-25)
; node # 9 D(-47,-43)->(-48,-34)
       fcb 2 ; drawmode 
       fdb 256,-16640 ; starx/y relative to previous node
       fdb -154,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-230|rel:-154)
; node # 10 D(-47,25)->(-40,32)
       fcb 2 ; drawmode 
       fdb -17408,0 ; starx/y relative to previous node
       fdb 51,204 ; dx/dy. dx(abs:179|rel:204) dy(abs:-179|rel:51)
; node # 11 M(-47,-43)->(-48,-34)
       fcb 0 ; drawmode 
       fdb 17408,0 ; starx/y relative to previous node
       fdb -51,-204 ; dx/dy. dx(abs:-25|rel:-204) dy(abs:-230|rel:-51)
; node # 12 D(-24,-36)->(-38,-38)
       fcb 2 ; drawmode 
       fdb -1792,5888 ; starx/y relative to previous node
       fdb 281,-333 ; dx/dy. dx(abs:-358|rel:-333) dy(abs:51|rel:281)
; node # 13 D(-25,62)->(-28,60)
       fcb 2 ; drawmode 
       fdb -25088,-256 ; starx/y relative to previous node
       fdb 0,282 ; dx/dy. dx(abs:-76|rel:282) dy(abs:51|rel:0)
; node # 14 M(-24,-36)->(-39,-38)
       fcb 0 ; drawmode 
       fdb 25088,256 ; starx/y relative to previous node
       fdb 0,-308 ; dx/dy. dx(abs:-384|rel:-308) dy(abs:51|rel:0)
; node # 15 D(61,-35)->(55,-44)
       fcb 2 ; drawmode 
       fdb -256,21760 ; starx/y relative to previous node
       fdb 179,231 ; dx/dy. dx(abs:-153|rel:231) dy(abs:230|rel:179)
       fcb  1  ; end of anim
; Animation 18
vidcubeglframe18:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(56,41)->(61,34)
       fcb 0 ; drawmode 
       fdb -10496,14336 ; starx/y relative to previous node
       fdb 179,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:179|rel:179)
; node # 1 DM(20,21)->(29,23)
       fcb -1 ; drawmode 
       fdb 5120,-9216 ; starx/y relative to previous node
       fdb -230,102 ; dx/dy. dx(abs:230|rel:102) dy(abs:-51|rel:-230)
; node # 2 DM(-40,32)->(-33,40)
       fcb -1 ; drawmode 
       fdb -2816,-15360 ; starx/y relative to previous node
       fdb -153,-51 ; dx/dy. dx(abs:179|rel:-51) dy(abs:-204|rel:-153)
; node # 3 D(-28,60)->(-28,59)
       fcb 2 ; drawmode 
       fdb -7168,3072 ; starx/y relative to previous node
       fdb 229,-179 ; dx/dy. dx(abs:0|rel:-179) dy(abs:25|rel:229)
; node # 4 D(57,42)->(61,34)
       fcb 2 ; drawmode 
       fdb 4608,21760 ; starx/y relative to previous node
       fdb 179,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:204|rel:179)
; node # 5 D(55,-44)->(44,-55)
       fcb 2 ; drawmode 
       fdb 22016,-512 ; starx/y relative to previous node
       fdb 77,-383 ; dx/dy. dx(abs:-281|rel:-383) dy(abs:281|rel:77)
; node # 6 DM(17,-39)->(18,-38)
       fcb -1 ; drawmode 
       fdb -1280,-9728 ; starx/y relative to previous node
       fdb -306,306 ; dx/dy. dx(abs:25|rel:306) dy(abs:-25|rel:-306)
; node # 7 M(20,21)->(29,23)
       fcb 0 ; drawmode 
       fdb -15360,768 ; starx/y relative to previous node
       fdb -26,205 ; dx/dy. dx(abs:230|rel:205) dy(abs:-51|rel:-26)
; node # 8 DM(18,-39)->(17,-37)
       fcb -1 ; drawmode 
       fdb 15360,-512 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-25|rel:-255) dy(abs:-51|rel:0)
; node # 9 DM(-48,-34)->(-45,-26)
       fcb -1 ; drawmode 
       fdb -1280,-16896 ; starx/y relative to previous node
       fdb -153,101 ; dx/dy. dx(abs:76|rel:101) dy(abs:-204|rel:-153)
; node # 10 D(-40,32)->(-33,40)
       fcb 2 ; drawmode 
       fdb -16896,2048 ; starx/y relative to previous node
       fdb 0,103 ; dx/dy. dx(abs:179|rel:103) dy(abs:-204|rel:0)
; node # 11 M(-48,-34)->(-44,-26)
       fcb 0 ; drawmode 
       fdb 16896,-2048 ; starx/y relative to previous node
       fdb 0,-77 ; dx/dy. dx(abs:102|rel:-77) dy(abs:-204|rel:0)
; node # 12 D(-38,-38)->(-50,-38)
       fcb 2 ; drawmode 
       fdb 1024,2560 ; starx/y relative to previous node
       fdb 204,-409 ; dx/dy. dx(abs:-307|rel:-409) dy(abs:0|rel:204)
; node # 13 D(-28,60)->(-29,58)
       fcb 2 ; drawmode 
       fdb -25088,2560 ; starx/y relative to previous node
       fdb 51,282 ; dx/dy. dx(abs:-25|rel:282) dy(abs:51|rel:51)
; node # 14 M(-39,-38)->(-50,-38)
       fcb 0 ; drawmode 
       fdb 25088,-2816 ; starx/y relative to previous node
       fdb -51,-256 ; dx/dy. dx(abs:-281|rel:-256) dy(abs:0|rel:-51)
; node # 15 D(55,-44)->(44,-55)
       fcb 2 ; drawmode 
       fdb 1536,24064 ; starx/y relative to previous node
       fdb 281,0 ; dx/dy. dx(abs:-281|rel:0) dy(abs:281|rel:281)
       fcb  1  ; end of anim
; Animation 19
vidcubeglframe19:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(61,34)->(64,26)
       fcb 0 ; drawmode 
       fdb -8704,15616 ; starx/y relative to previous node
       fdb 204,76 ; dx/dy. dx(abs:76|rel:76) dy(abs:204|rel:204)
; node # 1 DM(29,23)->(38,23)
       fcb -1 ; drawmode 
       fdb 2816,-8192 ; starx/y relative to previous node
       fdb -204,154 ; dx/dy. dx(abs:230|rel:154) dy(abs:0|rel:-204)
; node # 2 DM(-33,40)->(-21,44)
       fcb -1 ; drawmode 
       fdb -4352,-15872 ; starx/y relative to previous node
       fdb -102,77 ; dx/dy. dx(abs:307|rel:77) dy(abs:-102|rel:-102)
; node # 3 DM(-28,59)->(-30,59)
       fcb -1 ; drawmode 
       fdb -4864,1280 ; starx/y relative to previous node
       fdb 102,-358 ; dx/dy. dx(abs:-51|rel:-358) dy(abs:0|rel:102)
; node # 4 D(61,34)->(64,26)
       fcb 2 ; drawmode 
       fdb 6400,22784 ; starx/y relative to previous node
       fdb 204,127 ; dx/dy. dx(abs:76|rel:127) dy(abs:204|rel:204)
; node # 5 D(44,-55)->(30,-63)
       fcb 2 ; drawmode 
       fdb 22784,-4352 ; starx/y relative to previous node
       fdb 0,-434 ; dx/dy. dx(abs:-358|rel:-434) dy(abs:204|rel:0)
; node # 6 DM(18,-38)->(17,-36)
       fcb -1 ; drawmode 
       fdb -4352,-6656 ; starx/y relative to previous node
       fdb -255,333 ; dx/dy. dx(abs:-25|rel:333) dy(abs:-51|rel:-255)
; node # 7 M(29,23)->(38,23)
       fcb 0 ; drawmode 
       fdb -15616,2816 ; starx/y relative to previous node
       fdb 51,255 ; dx/dy. dx(abs:230|rel:255) dy(abs:0|rel:51)
; node # 8 DM(17,-37)->(17,-36)
       fcb -1 ; drawmode 
       fdb 15360,-3072 ; starx/y relative to previous node
       fdb -25,-230 ; dx/dy. dx(abs:0|rel:-230) dy(abs:-25|rel:-25)
; node # 9 DM(-45,-26)->(-42,-17)
       fcb -1 ; drawmode 
       fdb -2816,-15872 ; starx/y relative to previous node
       fdb -205,76 ; dx/dy. dx(abs:76|rel:76) dy(abs:-230|rel:-205)
; node # 10 DM(-33,40)->(-22,44)
       fcb -1 ; drawmode 
       fdb -16896,3072 ; starx/y relative to previous node
       fdb 128,205 ; dx/dy. dx(abs:281|rel:205) dy(abs:-102|rel:128)
; node # 11 M(-44,-26)->(-42,-17)
       fcb 0 ; drawmode 
       fdb 16896,-2816 ; starx/y relative to previous node
       fdb -128,-230 ; dx/dy. dx(abs:51|rel:-230) dy(abs:-230|rel:-128)
; node # 12 DM(-50,-38)->(-59,-34)
       fcb -1 ; drawmode 
       fdb 3072,-1536 ; starx/y relative to previous node
       fdb 128,-281 ; dx/dy. dx(abs:-230|rel:-281) dy(abs:-102|rel:128)
; node # 13 D(-29,58)->(-30,58)
       fcb 2 ; drawmode 
       fdb -24576,5376 ; starx/y relative to previous node
       fdb 102,205 ; dx/dy. dx(abs:-25|rel:205) dy(abs:0|rel:102)
; node # 14 M(-50,-38)->(-59,-34)
       fcb 0 ; drawmode 
       fdb 24576,-5376 ; starx/y relative to previous node
       fdb -102,-205 ; dx/dy. dx(abs:-230|rel:-205) dy(abs:-102|rel:-102)
; node # 15 D(44,-55)->(30,-63)
       fcb 2 ; drawmode 
       fdb 4352,24064 ; starx/y relative to previous node
       fdb 306,-128 ; dx/dy. dx(abs:-358|rel:-128) dy(abs:204|rel:306)
       fcb  1  ; end of anim
; Animation 20
vidcubeglframe20:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(64,26)->(61,14)
       fcb 0 ; drawmode 
       fdb -6656,16384 ; starx/y relative to previous node
       fdb 307,-76 ; dx/dy. dx(abs:-76|rel:-76) dy(abs:307|rel:307)
; node # 1 DM(38,23)->(49,21)
       fcb -1 ; drawmode 
       fdb 768,-6656 ; starx/y relative to previous node
       fdb -256,357 ; dx/dy. dx(abs:281|rel:357) dy(abs:51|rel:-256)
; node # 2 DM(-21,44)->(-11,50)
       fcb -1 ; drawmode 
       fdb -5376,-15104 ; starx/y relative to previous node
       fdb -204,-25 ; dx/dy. dx(abs:256|rel:-25) dy(abs:-153|rel:-204)
; node # 3 DM(-30,59)->(-31,57)
       fcb -1 ; drawmode 
       fdb -3840,-2304 ; starx/y relative to previous node
       fdb 204,-281 ; dx/dy. dx(abs:-25|rel:-281) dy(abs:51|rel:204)
; node # 4 D(64,26)->(61,14)
       fcb 2 ; drawmode 
       fdb 8448,24064 ; starx/y relative to previous node
       fdb 256,-51 ; dx/dy. dx(abs:-76|rel:-51) dy(abs:307|rel:256)
; node # 5 D(30,-63)->(17,-68)
       fcb 2 ; drawmode 
       fdb 22784,-8704 ; starx/y relative to previous node
       fdb -179,-256 ; dx/dy. dx(abs:-332|rel:-256) dy(abs:128|rel:-179)
; node # 6 DM(17,-36)->(19,-35)
       fcb -1 ; drawmode 
       fdb -6912,-3328 ; starx/y relative to previous node
       fdb -153,383 ; dx/dy. dx(abs:51|rel:383) dy(abs:-25|rel:-153)
; node # 7 M(38,23)->(49,21)
       fcb 0 ; drawmode 
       fdb -15104,5376 ; starx/y relative to previous node
       fdb 76,230 ; dx/dy. dx(abs:281|rel:230) dy(abs:51|rel:76)
; node # 8 DM(17,-36)->(19,-35)
       fcb -1 ; drawmode 
       fdb 15104,-5376 ; starx/y relative to previous node
       fdb -76,-230 ; dx/dy. dx(abs:51|rel:-230) dy(abs:-25|rel:-76)
; node # 9 DM(-42,-17)->(-36,-8)
       fcb -1 ; drawmode 
       fdb -4864,-15104 ; starx/y relative to previous node
       fdb -205,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:-230|rel:-205)
; node # 10 DM(-22,44)->(-13,50)
       fcb -1 ; drawmode 
       fdb -15616,5120 ; starx/y relative to previous node
       fdb 77,77 ; dx/dy. dx(abs:230|rel:77) dy(abs:-153|rel:77)
; node # 11 M(-42,-17)->(-36,-8)
       fcb 0 ; drawmode 
       fdb 15616,-5120 ; starx/y relative to previous node
       fdb -77,-77 ; dx/dy. dx(abs:153|rel:-77) dy(abs:-230|rel:-77)
; node # 12 DM(-59,-34)->(-65,-29)
       fcb -1 ; drawmode 
       fdb 4352,-4352 ; starx/y relative to previous node
       fdb 102,-306 ; dx/dy. dx(abs:-153|rel:-306) dy(abs:-128|rel:102)
; node # 13 D(-30,58)->(-31,57)
       fcb 2 ; drawmode 
       fdb -23552,7424 ; starx/y relative to previous node
       fdb 153,128 ; dx/dy. dx(abs:-25|rel:128) dy(abs:25|rel:153)
; node # 14 M(-59,-34)->(-65,-29)
       fcb 0 ; drawmode 
       fdb 23552,-7424 ; starx/y relative to previous node
       fdb -153,-128 ; dx/dy. dx(abs:-153|rel:-128) dy(abs:-128|rel:-153)
; node # 15 D(30,-63)->(17,-68)
       fcb 2 ; drawmode 
       fdb 7424,22784 ; starx/y relative to previous node
       fdb 256,-179 ; dx/dy. dx(abs:-332|rel:-179) dy(abs:128|rel:256)
       fcb  1  ; end of anim
; Animation 21
vidcubeglframe21:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(61,14)->(53,0)
       fcb 0 ; drawmode 
       fdb -3584,15616 ; starx/y relative to previous node
       fdb 358,-204 ; dx/dy. dx(abs:-204|rel:-204) dy(abs:358|rel:358)
; node # 1 D(49,21)->(55,19)
       fcb 2 ; drawmode 
       fdb -1792,-3072 ; starx/y relative to previous node
       fdb -307,357 ; dx/dy. dx(abs:153|rel:357) dy(abs:51|rel:-307)
; node # 2 D(-11,50)->(-2,54)
       fcb 2 ; drawmode 
       fdb -7424,-15360 ; starx/y relative to previous node
       fdb -153,77 ; dx/dy. dx(abs:230|rel:77) dy(abs:-102|rel:-153)
; node # 3 D(-31,57)->(-35,54)
       fcb 2 ; drawmode 
       fdb -1792,-5120 ; starx/y relative to previous node
       fdb 178,-332 ; dx/dy. dx(abs:-102|rel:-332) dy(abs:76|rel:178)
; node # 4 D(61,14)->(54,0)
       fcb 2 ; drawmode 
       fdb 11008,23552 ; starx/y relative to previous node
       fdb 282,-77 ; dx/dy. dx(abs:-179|rel:-77) dy(abs:358|rel:282)
; node # 5 D(17,-68)->(4,-71)
       fcb 2 ; drawmode 
       fdb 20992,-11264 ; starx/y relative to previous node
       fdb -282,-153 ; dx/dy. dx(abs:-332|rel:-153) dy(abs:76|rel:-282)
; node # 6 DM(19,-35)->(21,-34)
       fcb -1 ; drawmode 
       fdb -8448,512 ; starx/y relative to previous node
       fdb -101,383 ; dx/dy. dx(abs:51|rel:383) dy(abs:-25|rel:-101)
; node # 7 M(49,21)->(55,19)
       fcb 0 ; drawmode 
       fdb -14336,7680 ; starx/y relative to previous node
       fdb 76,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:51|rel:76)
; node # 8 DM(19,-35)->(21,-34)
       fcb -1 ; drawmode 
       fdb 14336,-7680 ; starx/y relative to previous node
       fdb -76,-102 ; dx/dy. dx(abs:51|rel:-102) dy(abs:-25|rel:-76)
; node # 9 DM(-36,-8)->(-30,0)
       fcb -1 ; drawmode 
       fdb -6912,-14080 ; starx/y relative to previous node
       fdb -179,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:-204|rel:-179)
; node # 10 DM(-13,50)->(-3,54)
       fcb -1 ; drawmode 
       fdb -14848,5888 ; starx/y relative to previous node
       fdb 102,103 ; dx/dy. dx(abs:256|rel:103) dy(abs:-102|rel:102)
; node # 11 M(-36,-8)->(-30,0)
       fcb 0 ; drawmode 
       fdb 14848,-5888 ; starx/y relative to previous node
       fdb -102,-103 ; dx/dy. dx(abs:153|rel:-103) dy(abs:-204|rel:-102)
; node # 12 DM(-65,-29)->(-68,-22)
       fcb -1 ; drawmode 
       fdb 5376,-7424 ; starx/y relative to previous node
       fdb 25,-229 ; dx/dy. dx(abs:-76|rel:-229) dy(abs:-179|rel:25)
; node # 13 D(-31,57)->(-35,54)
       fcb 2 ; drawmode 
       fdb -22016,8704 ; starx/y relative to previous node
       fdb 255,-26 ; dx/dy. dx(abs:-102|rel:-26) dy(abs:76|rel:255)
; node # 14 M(-65,-29)->(-68,-22)
       fcb 0 ; drawmode 
       fdb 22016,-8704 ; starx/y relative to previous node
       fdb -255,26 ; dx/dy. dx(abs:-76|rel:26) dy(abs:-179|rel:-255)
; node # 15 D(17,-68)->(4,-71)
       fcb 2 ; drawmode 
       fdb 9984,20992 ; starx/y relative to previous node
       fdb 255,-256 ; dx/dy. dx(abs:-332|rel:-256) dy(abs:76|rel:255)
       fcb  1  ; end of anim
; Animation 22
vidcubeglframe22:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(53,0)->(44,-13)
       fcb 0 ; drawmode 
       fdb 0,13568 ; starx/y relative to previous node
       fdb 332,-230 ; dx/dy. dx(abs:-230|rel:-230) dy(abs:332|rel:332)
; node # 1 D(55,19)->(62,14)
       fcb 2 ; drawmode 
       fdb -4864,512 ; starx/y relative to previous node
       fdb -204,409 ; dx/dy. dx(abs:179|rel:409) dy(abs:128|rel:-204)
; node # 2 D(-2,54)->(6,58)
       fcb 2 ; drawmode 
       fdb -8960,-14592 ; starx/y relative to previous node
       fdb -230,25 ; dx/dy. dx(abs:204|rel:25) dy(abs:-102|rel:-230)
; node # 3 D(-35,54)->(-36,54)
       fcb 2 ; drawmode 
       fdb 0,-8448 ; starx/y relative to previous node
       fdb 102,-229 ; dx/dy. dx(abs:-25|rel:-229) dy(abs:0|rel:102)
; node # 4 D(54,0)->(44,-13)
       fcb 2 ; drawmode 
       fdb 13824,22784 ; starx/y relative to previous node
       fdb 332,-231 ; dx/dy. dx(abs:-256|rel:-231) dy(abs:332|rel:332)
; node # 5 D(4,-71)->(-8,-71)
       fcb 2 ; drawmode 
       fdb 18176,-12800 ; starx/y relative to previous node
       fdb -332,-51 ; dx/dy. dx(abs:-307|rel:-51) dy(abs:0|rel:-332)
; node # 6 DM(21,-34)->(22,-32)
       fcb -1 ; drawmode 
       fdb -9472,4352 ; starx/y relative to previous node
       fdb -51,332 ; dx/dy. dx(abs:25|rel:332) dy(abs:-51|rel:-51)
; node # 7 M(55,19)->(62,14)
       fcb 0 ; drawmode 
       fdb -13568,8704 ; starx/y relative to previous node
       fdb 179,154 ; dx/dy. dx(abs:179|rel:154) dy(abs:128|rel:179)
; node # 8 DM(21,-34)->(22,-32)
       fcb -1 ; drawmode 
       fdb 13568,-8704 ; starx/y relative to previous node
       fdb -179,-154 ; dx/dy. dx(abs:25|rel:-154) dy(abs:-51|rel:-179)
; node # 9 DM(-30,0)->(-23,8)
       fcb -1 ; drawmode 
       fdb -8704,-13056 ; starx/y relative to previous node
       fdb -153,154 ; dx/dy. dx(abs:179|rel:154) dy(abs:-204|rel:-153)
; node # 10 DM(-3,54)->(6,58)
       fcb -1 ; drawmode 
       fdb -13824,6912 ; starx/y relative to previous node
       fdb 102,51 ; dx/dy. dx(abs:230|rel:51) dy(abs:-102|rel:102)
; node # 11 M(-30,0)->(-23,8)
       fcb 0 ; drawmode 
       fdb 13824,-6912 ; starx/y relative to previous node
       fdb -102,-51 ; dx/dy. dx(abs:179|rel:-51) dy(abs:-204|rel:-102)
; node # 12 DM(-68,-22)->(-68,-13)
       fcb -1 ; drawmode 
       fdb 5632,-9728 ; starx/y relative to previous node
       fdb -26,-179 ; dx/dy. dx(abs:0|rel:-179) dy(abs:-230|rel:-26)
; node # 13 D(-35,54)->(-36,54)
       fcb 2 ; drawmode 
       fdb -19456,8448 ; starx/y relative to previous node
       fdb 230,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:0|rel:230)
; node # 14 M(-68,-22)->(-68,-13)
       fcb 0 ; drawmode 
       fdb 19456,-8448 ; starx/y relative to previous node
       fdb -230,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-230|rel:-230)
; node # 15 D(4,-71)->(-8,-71)
       fcb 2 ; drawmode 
       fdb 12544,18432 ; starx/y relative to previous node
       fdb 230,-307 ; dx/dy. dx(abs:-307|rel:-307) dy(abs:0|rel:230)
       fcb  1  ; end of anim
; Animation 23
vidcubeglframe23:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(44,-13)->(31,-26)
       fcb 0 ; drawmode 
       fdb 3328,11264 ; starx/y relative to previous node
       fdb 332,-332 ; dx/dy. dx(abs:-332|rel:-332) dy(abs:332|rel:332)
; node # 1 D(62,14)->(67,6)
       fcb 2 ; drawmode 
       fdb -6912,4608 ; starx/y relative to previous node
       fdb -128,460 ; dx/dy. dx(abs:128|rel:460) dy(abs:204|rel:-128)
; node # 2 D(6,58)->(15,60)
       fcb 2 ; drawmode 
       fdb -11264,-14336 ; starx/y relative to previous node
       fdb -255,102 ; dx/dy. dx(abs:230|rel:102) dy(abs:-51|rel:-255)
; node # 3 D(-36,54)->(-38,52)
       fcb 2 ; drawmode 
       fdb 1024,-10752 ; starx/y relative to previous node
       fdb 102,-281 ; dx/dy. dx(abs:-51|rel:-281) dy(abs:51|rel:102)
; node # 4 D(44,-13)->(31,-26)
       fcb 2 ; drawmode 
       fdb 17152,20480 ; starx/y relative to previous node
       fdb 281,-281 ; dx/dy. dx(abs:-332|rel:-281) dy(abs:332|rel:281)
; node # 5 D(-8,-71)->(-17,-67)
       fcb 2 ; drawmode 
       fdb 14848,-13312 ; starx/y relative to previous node
       fdb -434,102 ; dx/dy. dx(abs:-230|rel:102) dy(abs:-102|rel:-434)
; node # 6 DM(22,-32)->(22,-32)
       fcb -1 ; drawmode 
       fdb -9984,7680 ; starx/y relative to previous node
       fdb 102,230 ; dx/dy. dx(abs:0|rel:230) dy(abs:0|rel:102)
; node # 7 M(62,14)->(67,6)
       fcb 0 ; drawmode 
       fdb -11776,10240 ; starx/y relative to previous node
       fdb 204,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:204|rel:204)
; node # 8 DM(22,-32)->(22,-32)
       fcb -1 ; drawmode 
       fdb 11776,-10240 ; starx/y relative to previous node
       fdb -204,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:0|rel:-204)
; node # 9 DM(-23,8)->(-16,13)
       fcb -1 ; drawmode 
       fdb -10240,-11520 ; starx/y relative to previous node
       fdb -128,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:-128|rel:-128)
; node # 10 DM(6,58)->(15,60)
       fcb -1 ; drawmode 
       fdb -12800,7424 ; starx/y relative to previous node
       fdb 77,51 ; dx/dy. dx(abs:230|rel:51) dy(abs:-51|rel:77)
; node # 11 M(-23,8)->(-16,14)
       fcb 0 ; drawmode 
       fdb 12800,-7424 ; starx/y relative to previous node
       fdb -102,-51 ; dx/dy. dx(abs:179|rel:-51) dy(abs:-153|rel:-102)
; node # 12 DM(-68,-13)->(-66,-7)
       fcb -1 ; drawmode 
       fdb 5376,-11520 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:51|rel:-128) dy(abs:-153|rel:0)
; node # 13 D(-36,54)->(-39,52)
       fcb 2 ; drawmode 
       fdb -17152,8192 ; starx/y relative to previous node
       fdb 204,-127 ; dx/dy. dx(abs:-76|rel:-127) dy(abs:51|rel:204)
; node # 14 M(-68,-13)->(-66,-7)
       fcb 0 ; drawmode 
       fdb 17152,-8192 ; starx/y relative to previous node
       fdb -204,127 ; dx/dy. dx(abs:51|rel:127) dy(abs:-153|rel:-204)
; node # 15 D(-8,-71)->(-17,-67)
       fcb 2 ; drawmode 
       fdb 14848,15360 ; starx/y relative to previous node
       fdb 51,-281 ; dx/dy. dx(abs:-230|rel:-281) dy(abs:-102|rel:51)
       fcb  1  ; end of anim
; Animation 24
vidcubeglframe24:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(31,-26)->(14,-37)
       fcb 0 ; drawmode 
       fdb 6656,7936 ; starx/y relative to previous node
       fdb 281,-435 ; dx/dy. dx(abs:-435|rel:-435) dy(abs:281|rel:281)
; node # 1 D(67,6)->(70,-3)
       fcb 2 ; drawmode 
       fdb -8192,9216 ; starx/y relative to previous node
       fdb -51,511 ; dx/dy. dx(abs:76|rel:511) dy(abs:230|rel:-51)
; node # 2 D(15,60)->(24,61)
       fcb 2 ; drawmode 
       fdb -13824,-13312 ; starx/y relative to previous node
       fdb -255,154 ; dx/dy. dx(abs:230|rel:154) dy(abs:-25|rel:-255)
; node # 3 D(-38,52)->(-42,52)
       fcb 2 ; drawmode 
       fdb 2048,-13568 ; starx/y relative to previous node
       fdb 25,-332 ; dx/dy. dx(abs:-102|rel:-332) dy(abs:0|rel:25)
; node # 4 D(31,-26)->(14,-37)
       fcb 2 ; drawmode 
       fdb 19968,17664 ; starx/y relative to previous node
       fdb 281,-333 ; dx/dy. dx(abs:-435|rel:-333) dy(abs:281|rel:281)
; node # 5 D(-17,-67)->(-26,-63)
       fcb 2 ; drawmode 
       fdb 10496,-12288 ; starx/y relative to previous node
       fdb -383,205 ; dx/dy. dx(abs:-230|rel:205) dy(abs:-102|rel:-383)
; node # 6 DM(22,-32)->(26,-31)
       fcb -1 ; drawmode 
       fdb -8960,9984 ; starx/y relative to previous node
       fdb 77,332 ; dx/dy. dx(abs:102|rel:332) dy(abs:-25|rel:77)
; node # 7 M(67,6)->(70,-3)
       fcb 0 ; drawmode 
       fdb -9728,11520 ; starx/y relative to previous node
       fdb 255,-26 ; dx/dy. dx(abs:76|rel:-26) dy(abs:230|rel:255)
; node # 8 DM(22,-32)->(26,-31)
       fcb -1 ; drawmode 
       fdb 9728,-11520 ; starx/y relative to previous node
       fdb -255,26 ; dx/dy. dx(abs:102|rel:26) dy(abs:-25|rel:-255)
; node # 9 DM(-16,13)->(-8,18)
       fcb -1 ; drawmode 
       fdb -11520,-9728 ; starx/y relative to previous node
       fdb -103,102 ; dx/dy. dx(abs:204|rel:102) dy(abs:-128|rel:-103)
; node # 10 DM(15,60)->(24,61)
       fcb -1 ; drawmode 
       fdb -12032,7936 ; starx/y relative to previous node
       fdb 103,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-25|rel:103)
; node # 11 M(-16,14)->(-7,18)
       fcb 0 ; drawmode 
       fdb 11776,-7936 ; starx/y relative to previous node
       fdb -77,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:-102|rel:-77)
; node # 12 DM(-66,-7)->(-61,2)
       fcb -1 ; drawmode 
       fdb 5376,-12800 ; starx/y relative to previous node
       fdb -128,-102 ; dx/dy. dx(abs:128|rel:-102) dy(abs:-230|rel:-128)
; node # 13 D(-39,52)->(-41,52)
       fcb 2 ; drawmode 
       fdb -15104,6912 ; starx/y relative to previous node
       fdb 230,-179 ; dx/dy. dx(abs:-51|rel:-179) dy(abs:0|rel:230)
; node # 14 M(-66,-7)->(-62,1)
       fcb 0 ; drawmode 
       fdb 15104,-6912 ; starx/y relative to previous node
       fdb -204,153 ; dx/dy. dx(abs:102|rel:153) dy(abs:-204|rel:-204)
; node # 15 D(-17,-67)->(-26,-63)
       fcb 2 ; drawmode 
       fdb 15360,12544 ; starx/y relative to previous node
       fdb 102,-332 ; dx/dy. dx(abs:-230|rel:-332) dy(abs:-102|rel:102)
       fcb  1  ; end of anim
; Animation 25
vidcubeglframe25:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(14,-37)->(-5,-45)
       fcb 0 ; drawmode 
       fdb 9472,3584 ; starx/y relative to previous node
       fdb 204,-486 ; dx/dy. dx(abs:-486|rel:-486) dy(abs:204|rel:204)
; node # 1 D(70,-3)->(70,-13)
       fcb 2 ; drawmode 
       fdb -8704,14336 ; starx/y relative to previous node
       fdb 52,486 ; dx/dy. dx(abs:0|rel:486) dy(abs:256|rel:52)
; node # 2 D(24,61)->(33,62)
       fcb 2 ; drawmode 
       fdb -16384,-11776 ; starx/y relative to previous node
       fdb -281,230 ; dx/dy. dx(abs:230|rel:230) dy(abs:-25|rel:-281)
; node # 3 D(-42,52)->(-44,50)
       fcb 2 ; drawmode 
       fdb 2304,-16896 ; starx/y relative to previous node
       fdb 76,-281 ; dx/dy. dx(abs:-51|rel:-281) dy(abs:51|rel:76)
; node # 4 D(14,-37)->(-5,-45)
       fcb 2 ; drawmode 
       fdb 22784,14336 ; starx/y relative to previous node
       fdb 153,-435 ; dx/dy. dx(abs:-486|rel:-435) dy(abs:204|rel:153)
; node # 5 D(-26,-63)->(-30,-56)
       fcb 2 ; drawmode 
       fdb 6656,-10240 ; starx/y relative to previous node
       fdb -383,384 ; dx/dy. dx(abs:-102|rel:384) dy(abs:-179|rel:-383)
; node # 6 DM(26,-31)->(26,-31)
       fcb -1 ; drawmode 
       fdb -8192,13312 ; starx/y relative to previous node
       fdb 179,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:179)
; node # 7 M(70,-3)->(70,-13)
       fcb 0 ; drawmode 
       fdb -7168,11264 ; starx/y relative to previous node
       fdb 256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:256|rel:256)
; node # 8 DM(26,-31)->(26,-31)
       fcb -1 ; drawmode 
       fdb 7168,-11264 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-256)
; node # 9 DM(-8,18)->(2,24)
       fcb -1 ; drawmode 
       fdb -12544,-8704 ; starx/y relative to previous node
       fdb -153,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-153|rel:-153)
; node # 10 DM(24,61)->(32,62)
       fcb -1 ; drawmode 
       fdb -11008,8192 ; starx/y relative to previous node
       fdb 128,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:-25|rel:128)
; node # 11 M(-7,18)->(2,24)
       fcb 0 ; drawmode 
       fdb 11008,-7936 ; starx/y relative to previous node
       fdb -128,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-153|rel:-128)
; node # 12 DM(-61,2)->(-57,9)
       fcb -1 ; drawmode 
       fdb 4096,-13824 ; starx/y relative to previous node
       fdb -26,-128 ; dx/dy. dx(abs:102|rel:-128) dy(abs:-179|rel:-26)
; node # 13 D(-41,52)->(-44,50)
       fcb 2 ; drawmode 
       fdb -12800,5120 ; starx/y relative to previous node
       fdb 230,-178 ; dx/dy. dx(abs:-76|rel:-178) dy(abs:51|rel:230)
; node # 14 M(-62,1)->(-57,9)
       fcb 0 ; drawmode 
       fdb 13056,-5376 ; starx/y relative to previous node
       fdb -255,204 ; dx/dy. dx(abs:128|rel:204) dy(abs:-204|rel:-255)
; node # 15 D(-26,-63)->(-31,-56)
       fcb 2 ; drawmode 
       fdb 16384,9216 ; starx/y relative to previous node
       fdb 25,-256 ; dx/dy. dx(abs:-128|rel:-256) dy(abs:-179|rel:25)
       fcb  1  ; end of anim
; Animation 26
vidcubeglframe26:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-5,-45)->(-21,-50)
       fcb 0 ; drawmode 
       fdb 11520,-1280 ; starx/y relative to previous node
       fdb 128,-409 ; dx/dy. dx(abs:-409|rel:-409) dy(abs:128|rel:128)
; node # 1 D(70,-13)->(66,-25)
       fcb 2 ; drawmode 
       fdb -8192,19200 ; starx/y relative to previous node
       fdb 179,307 ; dx/dy. dx(abs:-102|rel:307) dy(abs:307|rel:179)
; node # 2 D(33,62)->(40,59)
       fcb 2 ; drawmode 
       fdb -19200,-9472 ; starx/y relative to previous node
       fdb -231,281 ; dx/dy. dx(abs:179|rel:281) dy(abs:76|rel:-231)
; node # 3 D(-44,50)->(-47,50)
       fcb 2 ; drawmode 
       fdb 3072,-19712 ; starx/y relative to previous node
       fdb -76,-255 ; dx/dy. dx(abs:-76|rel:-255) dy(abs:0|rel:-76)
; node # 4 D(-5,-45)->(-21,-50)
       fcb 2 ; drawmode 
       fdb 24320,9984 ; starx/y relative to previous node
       fdb 128,-333 ; dx/dy. dx(abs:-409|rel:-333) dy(abs:128|rel:128)
; node # 5 D(-30,-56)->(-34,-50)
       fcb 2 ; drawmode 
       fdb 2816,-6400 ; starx/y relative to previous node
       fdb -281,307 ; dx/dy. dx(abs:-102|rel:307) dy(abs:-153|rel:-281)
; node # 6 DM(26,-31)->(27,-31)
       fcb -1 ; drawmode 
       fdb -6400,14336 ; starx/y relative to previous node
       fdb 153,127 ; dx/dy. dx(abs:25|rel:127) dy(abs:0|rel:153)
; node # 7 M(70,-13)->(66,-25)
       fcb 0 ; drawmode 
       fdb -4608,11264 ; starx/y relative to previous node
       fdb 307,-127 ; dx/dy. dx(abs:-102|rel:-127) dy(abs:307|rel:307)
; node # 8 DM(26,-31)->(28,-31)
       fcb -1 ; drawmode 
       fdb 4608,-11264 ; starx/y relative to previous node
       fdb -307,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:0|rel:-307)
; node # 9 DM(2,24)->(12,28)
       fcb -1 ; drawmode 
       fdb -14080,-6144 ; starx/y relative to previous node
       fdb -102,205 ; dx/dy. dx(abs:256|rel:205) dy(abs:-102|rel:-102)
; node # 10 DM(32,62)->(40,59)
       fcb -1 ; drawmode 
       fdb -9728,7680 ; starx/y relative to previous node
       fdb 178,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:76|rel:178)
; node # 11 M(2,24)->(12,28)
       fcb 0 ; drawmode 
       fdb 9728,-7680 ; starx/y relative to previous node
       fdb -178,52 ; dx/dy. dx(abs:256|rel:52) dy(abs:-102|rel:-178)
; node # 12 DM(-57,9)->(-49,18)
       fcb -1 ; drawmode 
       fdb 3840,-15104 ; starx/y relative to previous node
       fdb -128,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:-230|rel:-128)
; node # 13 D(-44,50)->(-47,50)
       fcb 2 ; drawmode 
       fdb -10496,3328 ; starx/y relative to previous node
       fdb 230,-280 ; dx/dy. dx(abs:-76|rel:-280) dy(abs:0|rel:230)
; node # 14 M(-57,9)->(-49,18)
       fcb 0 ; drawmode 
       fdb 10496,-3328 ; starx/y relative to previous node
       fdb -230,280 ; dx/dy. dx(abs:204|rel:280) dy(abs:-230|rel:-230)
; node # 15 D(-31,-56)->(-34,-50)
       fcb 2 ; drawmode 
       fdb 16640,6656 ; starx/y relative to previous node
       fdb 77,-280 ; dx/dy. dx(abs:-76|rel:-280) dy(abs:-153|rel:77)
       fcb  1  ; end of anim
; Animation 27
vidcubeglframe27:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-21,-50)->(-37,-51)
       fcb 0 ; drawmode 
       fdb 12800,-5376 ; starx/y relative to previous node
       fdb 25,-409 ; dx/dy. dx(abs:-409|rel:-409) dy(abs:25|rel:25)
; node # 1 D(66,-25)->(59,-36)
       fcb 2 ; drawmode 
       fdb -6400,22272 ; starx/y relative to previous node
       fdb 256,230 ; dx/dy. dx(abs:-179|rel:230) dy(abs:281|rel:256)
; node # 2 D(40,59)->(45,56)
       fcb 2 ; drawmode 
       fdb -21504,-6656 ; starx/y relative to previous node
       fdb -205,307 ; dx/dy. dx(abs:128|rel:307) dy(abs:76|rel:-205)
; node # 3 D(-47,50)->(-47,50)
       fcb 2 ; drawmode 
       fdb 2304,-22272 ; starx/y relative to previous node
       fdb -76,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:0|rel:-76)
; node # 4 D(-21,-50)->(-37,-50)
       fcb 2 ; drawmode 
       fdb 25600,6656 ; starx/y relative to previous node
       fdb 0,-409 ; dx/dy. dx(abs:-409|rel:-409) dy(abs:0|rel:0)
; node # 5 D(-34,-50)->(-34,-40)
       fcb 2 ; drawmode 
       fdb 0,-3328 ; starx/y relative to previous node
       fdb -256,409 ; dx/dy. dx(abs:0|rel:409) dy(abs:-256|rel:-256)
; node # 6 DM(27,-31)->(29,-31)
       fcb -1 ; drawmode 
       fdb -4864,15616 ; starx/y relative to previous node
       fdb 256,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:0|rel:256)
; node # 7 M(66,-25)->(59,-35)
       fcb 0 ; drawmode 
       fdb -1536,9984 ; starx/y relative to previous node
       fdb 256,-230 ; dx/dy. dx(abs:-179|rel:-230) dy(abs:256|rel:256)
; node # 8 DM(28,-31)->(29,-31)
       fcb -1 ; drawmode 
       fdb 1536,-9728 ; starx/y relative to previous node
       fdb -256,204 ; dx/dy. dx(abs:25|rel:204) dy(abs:0|rel:-256)
; node # 9 DM(12,28)->(22,30)
       fcb -1 ; drawmode 
       fdb -15104,-4096 ; starx/y relative to previous node
       fdb -51,231 ; dx/dy. dx(abs:256|rel:231) dy(abs:-51|rel:-51)
; node # 10 DM(40,59)->(45,56)
       fcb -1 ; drawmode 
       fdb -7936,7168 ; starx/y relative to previous node
       fdb 127,-128 ; dx/dy. dx(abs:128|rel:-128) dy(abs:76|rel:127)
; node # 11 M(12,28)->(22,31)
       fcb 0 ; drawmode 
       fdb 7936,-7168 ; starx/y relative to previous node
       fdb -152,128 ; dx/dy. dx(abs:256|rel:128) dy(abs:-76|rel:-152)
; node # 12 DM(-49,18)->(-41,26)
       fcb -1 ; drawmode 
       fdb 2560,-15616 ; starx/y relative to previous node
       fdb -128,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:-204|rel:-128)
; node # 13 D(-47,50)->(-47,50)
       fcb 2 ; drawmode 
       fdb -8192,512 ; starx/y relative to previous node
       fdb 204,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:0|rel:204)
; node # 14 M(-49,18)->(-41,26)
       fcb 0 ; drawmode 
       fdb 8192,-512 ; starx/y relative to previous node
       fdb -204,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-204|rel:-204)
; node # 15 D(-34,-50)->(-34,-40)
       fcb 2 ; drawmode 
       fdb 17408,3840 ; starx/y relative to previous node
       fdb -52,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:-256|rel:-52)
       fcb  1  ; end of anim
; Animation 28
vidcubeglframe28:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-37,-51)->(-47,-48)
       fcb 0 ; drawmode 
       fdb 13056,-9472 ; starx/y relative to previous node
       fdb -76,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:-76|rel:-76)
; node # 1 D(59,-36)->(47,-48)
       fcb 2 ; drawmode 
       fdb -3840,24576 ; starx/y relative to previous node
       fdb 383,-51 ; dx/dy. dx(abs:-307|rel:-51) dy(abs:307|rel:383)
; node # 2 D(45,56)->(49,50)
       fcb 2 ; drawmode 
       fdb -23552,-3584 ; starx/y relative to previous node
       fdb -154,409 ; dx/dy. dx(abs:102|rel:409) dy(abs:153|rel:-154)
; node # 3 D(-47,50)->(-47,50)
       fcb 2 ; drawmode 
       fdb 1536,-23552 ; starx/y relative to previous node
       fdb -153,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:-153)
; node # 4 D(-37,-50)->(-47,-48)
       fcb 2 ; drawmode 
       fdb 25600,2560 ; starx/y relative to previous node
       fdb -51,-256 ; dx/dy. dx(abs:-256|rel:-256) dy(abs:-51|rel:-51)
; node # 5 DM(-34,-40)->(-33,-33)
       fcb -1 ; drawmode 
       fdb -2560,768 ; starx/y relative to previous node
       fdb -128,281 ; dx/dy. dx(abs:25|rel:281) dy(abs:-179|rel:-128)
; node # 6 DM(29,-31)->(31,-33)
       fcb -1 ; drawmode 
       fdb -2304,16128 ; starx/y relative to previous node
       fdb 230,26 ; dx/dy. dx(abs:51|rel:26) dy(abs:51|rel:230)
; node # 7 M(59,-35)->(48,-48)
       fcb 0 ; drawmode 
       fdb 1024,7680 ; starx/y relative to previous node
       fdb 281,-332 ; dx/dy. dx(abs:-281|rel:-332) dy(abs:332|rel:281)
; node # 8 DM(29,-31)->(31,-32)
       fcb -1 ; drawmode 
       fdb -1024,-7680 ; starx/y relative to previous node
       fdb -307,332 ; dx/dy. dx(abs:51|rel:332) dy(abs:25|rel:-307)
; node # 9 DM(22,30)->(31,32)
       fcb -1 ; drawmode 
       fdb -15616,-1792 ; starx/y relative to previous node
       fdb -76,179 ; dx/dy. dx(abs:230|rel:179) dy(abs:-51|rel:-76)
; node # 10 DM(45,56)->(49,50)
       fcb -1 ; drawmode 
       fdb -6656,5888 ; starx/y relative to previous node
       fdb 204,-128 ; dx/dy. dx(abs:102|rel:-128) dy(abs:153|rel:204)
; node # 11 M(22,31)->(31,32)
       fcb 0 ; drawmode 
       fdb 6400,-5888 ; starx/y relative to previous node
       fdb -178,128 ; dx/dy. dx(abs:230|rel:128) dy(abs:-25|rel:-178)
; node # 12 DM(-41,26)->(-33,32)
       fcb -1 ; drawmode 
       fdb 1280,-16128 ; starx/y relative to previous node
       fdb -128,-26 ; dx/dy. dx(abs:204|rel:-26) dy(abs:-153|rel:-128)
; node # 13 DM(-47,50)->(-47,49)
       fcb -1 ; drawmode 
       fdb -6144,-1536 ; starx/y relative to previous node
       fdb 178,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:25|rel:178)
; node # 14 M(-41,26)->(-33,32)
       fcb 0 ; drawmode 
       fdb 6144,1536 ; starx/y relative to previous node
       fdb -178,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-153|rel:-178)
; node # 15 DM(-34,-40)->(-33,-33)
       fcb -1 ; drawmode 
       fdb 16896,1792 ; starx/y relative to previous node
       fdb -26,-179 ; dx/dy. dx(abs:25|rel:-179) dy(abs:-179|rel:-26)
       fcb  1  ; end of anim
; Animation 29
vidcubeglframe29:
       fcb 10 ; Duration
       fcb 240 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-47,-48)->(-53,-42)
       fcb 0 ; drawmode 
       fdb 12288,-12032 ; starx/y relative to previous node
       fdb -153,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:-153|rel:-153)
; node # 1 D(47,-48)->(34,-57)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 383,-179 ; dx/dy. dx(abs:-332|rel:-179) dy(abs:230|rel:383)
; node # 2 D(49,50)->(48,38)
       fcb 2 ; drawmode 
       fdb -25088,512 ; starx/y relative to previous node
       fdb 77,307 ; dx/dy. dx(abs:-25|rel:307) dy(abs:307|rel:77)
; node # 3 D(-47,50)->(-50,47)
       fcb 2 ; drawmode 
       fdb 0,-24576 ; starx/y relative to previous node
       fdb -231,-51 ; dx/dy. dx(abs:-76|rel:-51) dy(abs:76|rel:-231)
; node # 4 D(-47,-48)->(-53,-42)
       fcb 2 ; drawmode 
       fdb 25088,0 ; starx/y relative to previous node
       fdb -229,-77 ; dx/dy. dx(abs:-153|rel:-77) dy(abs:-153|rel:-229)
; node # 5 DM(-33,-33)->(-28,-25)
       fcb -1 ; drawmode 
       fdb -3840,3584 ; starx/y relative to previous node
       fdb -51,281 ; dx/dy. dx(abs:128|rel:281) dy(abs:-204|rel:-51)
; node # 6 DM(31,-33)->(31,-33)
       fcb -1 ; drawmode 
       fdb 0,16384 ; starx/y relative to previous node
       fdb 204,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:0|rel:204)
; node # 7 M(48,-48)->(34,-57)
       fcb 0 ; drawmode 
       fdb 3840,4352 ; starx/y relative to previous node
       fdb 230,-358 ; dx/dy. dx(abs:-358|rel:-358) dy(abs:230|rel:230)
; node # 8 DM(31,-32)->(31,-33)
       fcb -1 ; drawmode 
       fdb -4096,-4352 ; starx/y relative to previous node
       fdb -205,358 ; dx/dy. dx(abs:0|rel:358) dy(abs:25|rel:-205)
; node # 9 DM(31,32)->(41,30)
       fcb -1 ; drawmode 
       fdb -16384,0 ; starx/y relative to previous node
       fdb 26,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:51|rel:26)
; node # 10 DM(49,50)->(48,38)
       fcb -1 ; drawmode 
       fdb -4608,4608 ; starx/y relative to previous node
       fdb 256,-281 ; dx/dy. dx(abs:-25|rel:-281) dy(abs:307|rel:256)
; node # 11 M(31,32)->(41,30)
       fcb 0 ; drawmode 
       fdb 4608,-4608 ; starx/y relative to previous node
       fdb -256,281 ; dx/dy. dx(abs:256|rel:281) dy(abs:51|rel:-256)
; node # 12 DM(-33,32)->(-22,37)
       fcb -1 ; drawmode 
       fdb 0,-16384 ; starx/y relative to previous node
       fdb -179,25 ; dx/dy. dx(abs:281|rel:25) dy(abs:-128|rel:-179)
; node # 13 DM(-47,49)->(-50,47)
       fcb -1 ; drawmode 
       fdb -4352,-3584 ; starx/y relative to previous node
       fdb 179,-357 ; dx/dy. dx(abs:-76|rel:-357) dy(abs:51|rel:179)
; node # 14 M(-33,32)->(-22,37)
       fcb 0 ; drawmode 
       fdb 4352,3584 ; starx/y relative to previous node
       fdb -179,357 ; dx/dy. dx(abs:281|rel:357) dy(abs:-128|rel:-179)
; node # 15 DM(-33,-33)->(-28,-25)
       fcb -1 ; drawmode 
       fdb 16640,0 ; starx/y relative to previous node
       fdb -76,-153 ; dx/dy. dx(abs:128|rel:-153) dy(abs:-204|rel:-76)
       fcb  1  ; end of anim
