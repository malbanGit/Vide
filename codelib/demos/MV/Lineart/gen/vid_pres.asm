presentsframecount equ 9 ; number of animations
presentsframetotal equ 90 ; total number of frames in animation 
; index table 
presentsframetab        fdb presentsframe0
       fdb presentsframe1
       fdb presentsframe2
       fdb presentsframe3
       fdb presentsframe4
       fdb presentsframe5
       fdb presentsframe6
       fdb presentsframe7
       fdb presentsframe8

; Animation 0
presentsframe0:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(0,0)->(-72,33)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -844,-1843 ; dx/dy. dx(abs:-1843|rel:-1843) dy(abs:-844|rel:-844)
; node # 2 D(0,0)->(-115,22)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 281,-1101 ; dx/dy. dx(abs:-2944|rel:-1101) dy(abs:-563|rel:281)
; node # 3 D(0,0)->(-110,3)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 487,128 ; dx/dy. dx(abs:-2816|rel:128) dy(abs:-76|rel:487)
; node # 4 D(0,0)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 178,256 ; dx/dy. dx(abs:-2560|rel:256) dy(abs:102|rel:178)
; node # 5 D(0,0)->(-88,-1)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -77,308 ; dx/dy. dx(abs:-2252|rel:308) dy(abs:25|rel:-77)
; node # 6 D(0,0)->(-83,9)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -255,128 ; dx/dy. dx(abs:-2124|rel:128) dy(abs:-230|rel:-255)
; node # 7 D(0,0)->(-85,21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -307,-52 ; dx/dy. dx(abs:-2176|rel:-52) dy(abs:-537|rel:-307)
; node # 8 D(0,0)->(-70,25)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -103,384 ; dx/dy. dx(abs:-1792|rel:384) dy(abs:-640|rel:-103)
; node # 9 D(0,0)->(-72,33)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -204,-51 ; dx/dy. dx(abs:-1843|rel:-51) dy(abs:-844|rel:-204)
; node # 10 M(0,0)->(-92,19)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 358,-512 ; dx/dy. dx(abs:-2355|rel:-512) dy(abs:-486|rel:358)
; node # 11 D(0,0)->(-106,16)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 77,-358 ; dx/dy. dx(abs:-2713|rel:-358) dy(abs:-409|rel:77)
; node # 12 D(0,0)->(-103,7)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 230,77 ; dx/dy. dx(abs:-2636|rel:77) dy(abs:-179|rel:230)
; node # 13 D(0,0)->(-96,5)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 51,179 ; dx/dy. dx(abs:-2457|rel:179) dy(abs:-128|rel:51)
; node # 14 D(0,0)->(-91,9)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -102,128 ; dx/dy. dx(abs:-2329|rel:128) dy(abs:-230|rel:-102)
; node # 15 D(0,0)->(-92,19)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -256,-26 ; dx/dy. dx(abs:-2355|rel:-26) dy(abs:-486|rel:-256)
       fcb  1  ; end of anim
; Animation 1
presentsframe1:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(0,0)->(-68,11)
       fcb 0 ; drawmode 
       fcb 19,92 ; starx/y relative to previous node
       fdb -281,-1740 ; dx/dy. dx(abs:-1740|rel:-1740) dy(abs:-281|rel:-281)
; node # 17 D(0,0)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 818,-820 ; dx/dy. dx(abs:-2560|rel:-820) dy(abs:537|rel:818)
; node # 18 D(0,0)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 307,333 ; dx/dy. dx(abs:-2227|rel:333) dy(abs:844|rel:307)
; node # 19 D(0,0)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 103,307 ; dx/dy. dx(abs:-1920|rel:307) dy(abs:947|rel:103)
; node # 20 D(0,0)->(-67,-30)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -179,205 ; dx/dy. dx(abs:-1715|rel:205) dy(abs:768|rel:-179)
; node # 21 D(0,0)->(-66,-18)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -308,26 ; dx/dy. dx(abs:-1689|rel:26) dy(abs:460|rel:-308)
; node # 22 D(0,0)->(-45,-13)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -128,537 ; dx/dy. dx(abs:-1152|rel:537) dy(abs:332|rel:-128)
; node # 23 D(0,0)->(-50,-7)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -153,-128 ; dx/dy. dx(abs:-1280|rel:-128) dy(abs:179|rel:-153)
; node # 24 D(0,0)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 102,-537 ; dx/dy. dx(abs:-1817|rel:-537) dy(abs:281|rel:102)
; node # 25 D(0,0)->(-74,-8)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -77,-77 ; dx/dy. dx(abs:-1894|rel:-77) dy(abs:204|rel:-77)
; node # 26 D(0,0)->(-62,5)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -332,307 ; dx/dy. dx(abs:-1587|rel:307) dy(abs:-128|rel:-332)
; node # 27 D(0,0)->(-68,11)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -153,-153 ; dx/dy. dx(abs:-1740|rel:-153) dy(abs:-281|rel:-153)
; node # 28 M(0,0)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 613,-282 ; dx/dy. dx(abs:-2022|rel:-282) dy(abs:332|rel:613)
; node # 29 D(0,0)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 231,-230 ; dx/dy. dx(abs:-2252|rel:-230) dy(abs:563|rel:231)
; node # 30 D(0,0)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 128,179 ; dx/dy. dx(abs:-2073|rel:179) dy(abs:691|rel:128)
; node # 31 D(0,0)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-1945|rel:128) dy(abs:691|rel:0)
; node # 32 D(0,0)->(-74,-21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -154,51 ; dx/dy. dx(abs:-1894|rel:51) dy(abs:537|rel:-154)
; node # 33 D(0,0)->(-79,-13)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -205,-128 ; dx/dy. dx(abs:-2022|rel:-128) dy(abs:332|rel:-205)
       fcb  1  ; end of anim
; Animation 2
presentsframe2:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(0,0)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -13,79 ; starx/y relative to previous node
       fdb 256,-1228 ; dx/dy. dx(abs:-1228|rel:-1228) dy(abs:256|rel:256)
; node # 35 D(0,0)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 1024,-461 ; dx/dy. dx(abs:-1689|rel:-461) dy(abs:1280|rel:1024)
; node # 36 D(0,0)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 281,640 ; dx/dy. dx(abs:-1049|rel:640) dy(abs:1561|rel:281)
; node # 37 D(0,0)->(-38,-55)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -153,77 ; dx/dy. dx(abs:-972|rel:77) dy(abs:1408|rel:-153)
; node # 38 D(0,0)->(-56,-47)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -205,-461 ; dx/dy. dx(abs:-1433|rel:-461) dy(abs:1203|rel:-205)
; node # 39 D(0,0)->(-52,-38)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -231,102 ; dx/dy. dx(abs:-1331|rel:102) dy(abs:972|rel:-231)
; node # 40 D(0,0)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 154,333 ; dx/dy. dx(abs:-998|rel:333) dy(abs:1126|rel:154)
; node # 41 D(0,0)->(-36,-37)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -179,77 ; dx/dy. dx(abs:-921|rel:77) dy(abs:947|rel:-179)
; node # 42 D(0,0)->(-49,-31)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -154,-333 ; dx/dy. dx(abs:-1254|rel:-333) dy(abs:793|rel:-154)
; node # 43 D(0,0)->(-44,-20)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -281,128 ; dx/dy. dx(abs:-1126|rel:128) dy(abs:512|rel:-281)
; node # 44 D(0,0)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 204,461 ; dx/dy. dx(abs:-665|rel:461) dy(abs:716|rel:204)
; node # 45 D(0,0)->(-23,-21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -179,77 ; dx/dy. dx(abs:-588|rel:77) dy(abs:537|rel:-179)
; node # 46 D(0,0)->(-48,-10)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -281,-640 ; dx/dy. dx(abs:-1228|rel:-640) dy(abs:256|rel:-281)
       fcb  1  ; end of anim
; Animation 3
presentsframe3:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(-48,-10)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-66,-50)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-41,-61)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-38,-55)->(-38,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-56,-47)->(-56,-47)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-52,-38)->(-52,-38)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-39,-44)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-36,-37)->(-36,-37)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-49,-31)->(-49,-31)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-44,-20)->(-44,-20)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-26,-28)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-23,-21)->(-23,-21)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-48,-10)->(-48,-10)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(0,0)->(-24,-21)
       fcb 0 ; drawmode 
       fcb -10,48 ; starx/y relative to previous node
       fdb 537,-614 ; dx/dy. dx(abs:-614|rel:-614) dy(abs:537|rel:537)
; node # 48 D(0,0)->(-24,-30)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 231,0 ; dx/dy. dx(abs:-614|rel:0) dy(abs:768|rel:231)
; node # 49 D(0,0)->(-14,-29)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -26,256 ; dx/dy. dx(abs:-358|rel:256) dy(abs:742|rel:-26)
; node # 50 D(0,0)->(-8,-33)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 102,154 ; dx/dy. dx(abs:-204|rel:154) dy(abs:844|rel:102)
; node # 51 D(0,0)->(-11,-39)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 154,-77 ; dx/dy. dx(abs:-281|rel:-77) dy(abs:998|rel:154)
; node # 52 D(0,0)->(-23,-43)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 102,-307 ; dx/dy. dx(abs:-588|rel:-307) dy(abs:1100|rel:102)
; node # 53 D(0,0)->(-30,-51)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 205,-180 ; dx/dy. dx(abs:-768|rel:-180) dy(abs:1305|rel:205)
; node # 54 D(0,0)->(-28,-62)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 282,52 ; dx/dy. dx(abs:-716|rel:52) dy(abs:1587|rel:282)
; node # 55 D(0,0)->(-19,-68)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 153,230 ; dx/dy. dx(abs:-486|rel:230) dy(abs:1740|rel:153)
; node # 56 D(0,0)->(-6,-66)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -51,333 ; dx/dy. dx(abs:-153|rel:333) dy(abs:1689|rel:-51)
; node # 57 D(0,0)->(-8,-59)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -179,-51 ; dx/dy. dx(abs:-204|rel:-51) dy(abs:1510|rel:-179)
; node # 58 D(0,0)->(-17,-60)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 26,-231 ; dx/dy. dx(abs:-435|rel:-231) dy(abs:1536|rel:26)
; node # 59 D(0,0)->(-22,-56)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -103,-128 ; dx/dy. dx(abs:-563|rel:-128) dy(abs:1433|rel:-103)
; node # 60 D(0,0)->(-19,-51)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -128,77 ; dx/dy. dx(abs:-486|rel:77) dy(abs:1305|rel:-128)
; node # 61 D(0,0)->(-7,-46)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -128,307 ; dx/dy. dx(abs:-179|rel:307) dy(abs:1177|rel:-128)
; node # 62 D(0,0)->(-1,-40)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -153,154 ; dx/dy. dx(abs:-25|rel:154) dy(abs:1024|rel:-153)
; node # 63 D(0,0)->(0,-31)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -231,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:793|rel:-231)
; node # 64 D(0,0)->(-8,-22)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -230,-204 ; dx/dy. dx(abs:-204|rel:-204) dy(abs:563|rel:-230)
; node # 65 D(0,0)->(-24,-21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -26,-410 ; dx/dy. dx(abs:-614|rel:-410) dy(abs:537|rel:-26)
       fcb  1  ; end of anim
; Animation 4
presentsframe4:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(-48,-10)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-66,-50)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-41,-61)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-38,-55)->(-38,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-56,-47)->(-56,-47)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-52,-38)->(-52,-38)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-39,-44)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-36,-37)->(-36,-37)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-49,-31)->(-49,-31)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-44,-20)->(-44,-20)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-26,-28)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-23,-21)->(-23,-21)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-48,-10)->(-48,-10)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-24,-21)->(-24,-21)
       fcb 0 ; drawmode 
       fcb 11,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 48 D(-24,-30)->(-24,-30)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(-14,-29)->(-14,-29)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(-8,-33)->(-8,-33)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(-11,-39)->(-11,-39)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 D(-23,-43)->(-23,-43)
       fcb 2 ; drawmode 
       fcb 4,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(-30,-51)->(-30,-51)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(-28,-62)->(-28,-62)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(-19,-68)->(-19,-68)
       fcb 2 ; drawmode 
       fcb 6,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(-6,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb -2,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-8,-59)->(-8,-59)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(-17,-60)->(-17,-60)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(-22,-56)->(-22,-56)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-19,-51)->(-19,-51)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-7,-46)->(-7,-46)
       fcb 2 ; drawmode 
       fcb -5,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 D(-1,-40)->(-1,-40)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 D(0,-31)->(0,-31)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(-8,-22)->(-8,-22)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 D(-24,-21)->(-24,-21)
       fcb 2 ; drawmode 
       fcb -1,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 M(0,0)->(1,-24)
       fcb 0 ; drawmode 
       fcb -21,24 ; starx/y relative to previous node
       fdb 614,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:614|rel:614)
; node # 67 D(0,0)->(6,-68)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 1126,128 ; dx/dy. dx(abs:153|rel:128) dy(abs:1740|rel:1126)
; node # 68 D(0,0)->(34,-65)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -76,717 ; dx/dy. dx(abs:870|rel:717) dy(abs:1664|rel:-76)
; node # 69 D(0,0)->(33,-58)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -180,-26 ; dx/dy. dx(abs:844|rel:-26) dy(abs:1484|rel:-180)
; node # 70 D(0,0)->(13,-60)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 52,-512 ; dx/dy. dx(abs:332|rel:-512) dy(abs:1536|rel:52)
; node # 71 D(0,0)->(12,-51)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -231,-25 ; dx/dy. dx(abs:307|rel:-25) dy(abs:1305|rel:-231)
; node # 72 D(0,0)->(27,-49)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -51,384 ; dx/dy. dx(abs:691|rel:384) dy(abs:1254|rel:-51)
; node # 73 D(0,0)->(26,-42)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -179,-26 ; dx/dy. dx(abs:665|rel:-26) dy(abs:1075|rel:-179)
; node # 74 D(0,0)->(12,-44)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 51,-358 ; dx/dy. dx(abs:307|rel:-358) dy(abs:1126|rel:51)
; node # 75 D(0,0)->(10,-31)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -333,-51 ; dx/dy. dx(abs:256|rel:-51) dy(abs:793|rel:-333)
; node # 76 D(0,0)->(30,-28)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -77,512 ; dx/dy. dx(abs:768|rel:512) dy(abs:716|rel:-77)
; node # 77 D(0,0)->(28,-21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -179,-52 ; dx/dy. dx(abs:716|rel:-52) dy(abs:537|rel:-179)
; node # 78 D(0,0)->(1,-24)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 77,-691 ; dx/dy. dx(abs:25|rel:-691) dy(abs:614|rel:77)
       fcb  1  ; end of anim
; Animation 5
presentsframe5:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(-48,-10)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-66,-50)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-41,-61)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-38,-55)->(-38,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-56,-47)->(-56,-47)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-52,-38)->(-52,-38)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-39,-44)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-36,-37)->(-36,-37)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-49,-31)->(-49,-31)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-44,-20)->(-44,-20)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-26,-28)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-23,-21)->(-23,-21)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-48,-10)->(-48,-10)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-24,-21)->(-24,-21)
       fcb 0 ; drawmode 
       fcb 11,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 48 D(-24,-30)->(-24,-30)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(-14,-29)->(-14,-29)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(-8,-33)->(-8,-33)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(-11,-39)->(-11,-39)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 D(-23,-43)->(-23,-43)
       fcb 2 ; drawmode 
       fcb 4,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(-30,-51)->(-30,-51)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(-28,-62)->(-28,-62)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(-19,-68)->(-19,-68)
       fcb 2 ; drawmode 
       fcb 6,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(-6,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb -2,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-8,-59)->(-8,-59)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(-17,-60)->(-17,-60)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(-22,-56)->(-22,-56)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-19,-51)->(-19,-51)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-7,-46)->(-7,-46)
       fcb 2 ; drawmode 
       fcb -5,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 D(-1,-40)->(-1,-40)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 D(0,-31)->(0,-31)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(-8,-22)->(-8,-22)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 D(-24,-21)->(-24,-21)
       fcb 2 ; drawmode 
       fcb -1,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 M(1,-24)->(1,-24)
       fcb 0 ; drawmode 
       fcb 3,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 D(6,-68)->(6,-68)
       fcb 2 ; drawmode 
       fcb 44,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 D(34,-65)->(34,-65)
       fcb 2 ; drawmode 
       fcb -3,28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 69 D(33,-58)->(33,-58)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 70 D(13,-60)->(13,-60)
       fcb 2 ; drawmode 
       fcb 2,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 71 D(12,-51)->(12,-51)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 72 D(27,-49)->(27,-49)
       fcb 2 ; drawmode 
       fcb -2,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 73 D(26,-42)->(26,-42)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 74 D(12,-44)->(12,-44)
       fcb 2 ; drawmode 
       fcb 2,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 75 D(10,-31)->(10,-31)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 76 D(30,-28)->(30,-28)
       fcb 2 ; drawmode 
       fcb -3,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 77 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 78 D(1,-24)->(1,-24)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 79 M(0,0)->(28,-21)
       fcb 0 ; drawmode 
       fcb -24,-1 ; starx/y relative to previous node
       fdb 537,716 ; dx/dy. dx(abs:716|rel:716) dy(abs:537|rel:537)
; node # 80 D(0,0)->(46,-62)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 1050,461 ; dx/dy. dx(abs:1177|rel:461) dy(abs:1587|rel:1050)
; node # 81 D(0,0)->(50,-60)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -51,103 ; dx/dy. dx(abs:1280|rel:103) dy(abs:1536|rel:-51)
; node # 82 D(0,0)->(57,-28)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -820,179 ; dx/dy. dx(abs:1459|rel:179) dy(abs:716|rel:-820)
; node # 83 D(0,0)->(68,-52)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 615,281 ; dx/dy. dx(abs:1740|rel:281) dy(abs:1331|rel:615)
; node # 84 D(0,0)->(75,-48)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -103,180 ; dx/dy. dx(abs:1920|rel:180) dy(abs:1228|rel:-103)
; node # 85 D(0,0)->(57,-8)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -1024,-461 ; dx/dy. dx(abs:1459|rel:-461) dy(abs:204|rel:-1024)
; node # 86 D(0,0)->(54,-10)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 52,-77 ; dx/dy. dx(abs:1382|rel:-77) dy(abs:256|rel:52)
; node # 87 D(0,0)->(46,-42)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 819,-205 ; dx/dy. dx(abs:1177|rel:-205) dy(abs:1075|rel:819)
; node # 88 D(0,0)->(35,-18)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -615,-281 ; dx/dy. dx(abs:896|rel:-281) dy(abs:460|rel:-615)
; node # 89 D(0,0)->(28,-21)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 77,-180 ; dx/dy. dx(abs:716|rel:-180) dy(abs:537|rel:77)
       fcb  1  ; end of anim
; Animation 6
presentsframe6:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(-48,-10)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-66,-50)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-41,-61)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-38,-55)->(-38,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-56,-47)->(-56,-47)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-52,-38)->(-52,-38)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-39,-44)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-36,-37)->(-36,-37)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-49,-31)->(-49,-31)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-44,-20)->(-44,-20)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-26,-28)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-23,-21)->(-23,-21)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-48,-10)->(-48,-10)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-24,-21)->(-24,-21)
       fcb 0 ; drawmode 
       fcb 11,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 48 D(-24,-30)->(-24,-30)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(-14,-29)->(-14,-29)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(-8,-33)->(-8,-33)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(-11,-39)->(-11,-39)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 D(-23,-43)->(-23,-43)
       fcb 2 ; drawmode 
       fcb 4,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(-30,-51)->(-30,-51)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(-28,-62)->(-28,-62)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(-19,-68)->(-19,-68)
       fcb 2 ; drawmode 
       fcb 6,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(-6,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb -2,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-8,-59)->(-8,-59)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(-17,-60)->(-17,-60)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(-22,-56)->(-22,-56)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-19,-51)->(-19,-51)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-7,-46)->(-7,-46)
       fcb 2 ; drawmode 
       fcb -5,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 D(-1,-40)->(-1,-40)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 D(0,-31)->(0,-31)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(-8,-22)->(-8,-22)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 D(-24,-21)->(-24,-21)
       fcb 2 ; drawmode 
       fcb -1,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 M(1,-24)->(1,-24)
       fcb 0 ; drawmode 
       fcb 3,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 D(6,-68)->(6,-68)
       fcb 2 ; drawmode 
       fcb 44,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 D(34,-65)->(34,-65)
       fcb 2 ; drawmode 
       fcb -3,28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 69 D(33,-58)->(33,-58)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 70 D(13,-60)->(13,-60)
       fcb 2 ; drawmode 
       fcb 2,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 71 D(12,-51)->(12,-51)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 72 D(27,-49)->(27,-49)
       fcb 2 ; drawmode 
       fcb -2,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 73 D(26,-42)->(26,-42)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 74 D(12,-44)->(12,-44)
       fcb 2 ; drawmode 
       fcb 2,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 75 D(10,-31)->(10,-31)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 76 D(30,-28)->(30,-28)
       fcb 2 ; drawmode 
       fcb -3,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 77 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 78 D(1,-24)->(1,-24)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 79 M(28,-21)->(28,-21)
       fcb 0 ; drawmode 
       fcb -3,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 80 D(46,-62)->(46,-62)
       fcb 2 ; drawmode 
       fcb 41,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 81 D(50,-60)->(50,-60)
       fcb 2 ; drawmode 
       fcb -2,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 82 D(57,-28)->(57,-28)
       fcb 2 ; drawmode 
       fcb -32,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 83 D(68,-52)->(68,-52)
       fcb 2 ; drawmode 
       fcb 24,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 84 D(75,-48)->(75,-48)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 85 D(57,-8)->(57,-8)
       fcb 2 ; drawmode 
       fcb -40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 86 D(54,-10)->(54,-10)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 D(46,-42)->(46,-42)
       fcb 2 ; drawmode 
       fcb 32,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 88 D(35,-18)->(35,-18)
       fcb 2 ; drawmode 
       fcb -24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 89 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb 3,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 M(0,0)->(62,-2)
       fcb 0 ; drawmode 
       fcb -21,-28 ; starx/y relative to previous node
       fdb 51,1587 ; dx/dy. dx(abs:1587|rel:1587) dy(abs:51|rel:51)
; node # 91 D(0,0)->(90,-26)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 614,717 ; dx/dy. dx(abs:2304|rel:717) dy(abs:665|rel:614)
; node # 92 D(0,0)->(80,-37)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 282,-256 ; dx/dy. dx(abs:2048|rel:-256) dy(abs:947|rel:282)
; node # 93 D(0,0)->(85,-41)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 102,128 ; dx/dy. dx(abs:2176|rel:128) dy(abs:1049|rel:102)
; node # 94 D(0,0)->(110,-15)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -665,640 ; dx/dy. dx(abs:2816|rel:640) dy(abs:384|rel:-665)
; node # 95 D(0,0)->(105,-10)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -128,-128 ; dx/dy. dx(abs:2688|rel:-128) dy(abs:256|rel:-128)
; node # 96 D(0,0)->(95,-20)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 256,-256 ; dx/dy. dx(abs:2432|rel:-256) dy(abs:512|rel:256)
; node # 97 D(0,0)->(67,4)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -614,-717 ; dx/dy. dx(abs:1715|rel:-717) dy(abs:-102|rel:-614)
; node # 98 D(0,0)->(62,-2)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 153,-128 ; dx/dy. dx(abs:1587|rel:-128) dy(abs:51|rel:153)
       fcb  1  ; end of anim
; Animation 7
presentsframe7:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(-48,-10)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-66,-50)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-41,-61)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-38,-55)->(-38,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-56,-47)->(-56,-47)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-52,-38)->(-52,-38)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-39,-44)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-36,-37)->(-36,-37)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-49,-31)->(-49,-31)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-44,-20)->(-44,-20)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-26,-28)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-23,-21)->(-23,-21)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-48,-10)->(-48,-10)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-24,-21)->(-24,-21)
       fcb 0 ; drawmode 
       fcb 11,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 48 D(-24,-30)->(-24,-30)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(-14,-29)->(-14,-29)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(-8,-33)->(-8,-33)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(-11,-39)->(-11,-39)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 D(-23,-43)->(-23,-43)
       fcb 2 ; drawmode 
       fcb 4,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(-30,-51)->(-30,-51)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(-28,-62)->(-28,-62)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(-19,-68)->(-19,-68)
       fcb 2 ; drawmode 
       fcb 6,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(-6,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb -2,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-8,-59)->(-8,-59)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(-17,-60)->(-17,-60)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(-22,-56)->(-22,-56)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-19,-51)->(-19,-51)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-7,-46)->(-7,-46)
       fcb 2 ; drawmode 
       fcb -5,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 D(-1,-40)->(-1,-40)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 D(0,-31)->(0,-31)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(-8,-22)->(-8,-22)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 D(-24,-21)->(-24,-21)
       fcb 2 ; drawmode 
       fcb -1,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 M(1,-24)->(1,-24)
       fcb 0 ; drawmode 
       fcb 3,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 D(6,-68)->(6,-68)
       fcb 2 ; drawmode 
       fcb 44,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 D(34,-65)->(34,-65)
       fcb 2 ; drawmode 
       fcb -3,28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 69 D(33,-58)->(33,-58)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 70 D(13,-60)->(13,-60)
       fcb 2 ; drawmode 
       fcb 2,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 71 D(12,-51)->(12,-51)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 72 D(27,-49)->(27,-49)
       fcb 2 ; drawmode 
       fcb -2,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 73 D(26,-42)->(26,-42)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 74 D(12,-44)->(12,-44)
       fcb 2 ; drawmode 
       fcb 2,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 75 D(10,-31)->(10,-31)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 76 D(30,-28)->(30,-28)
       fcb 2 ; drawmode 
       fcb -3,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 77 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 78 D(1,-24)->(1,-24)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 79 M(28,-21)->(28,-21)
       fcb 0 ; drawmode 
       fcb -3,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 80 D(46,-62)->(46,-62)
       fcb 2 ; drawmode 
       fcb 41,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 81 D(50,-60)->(50,-60)
       fcb 2 ; drawmode 
       fcb -2,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 82 D(57,-28)->(57,-28)
       fcb 2 ; drawmode 
       fcb -32,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 83 D(68,-52)->(68,-52)
       fcb 2 ; drawmode 
       fcb 24,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 84 D(75,-48)->(75,-48)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 85 D(57,-8)->(57,-8)
       fcb 2 ; drawmode 
       fcb -40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 86 D(54,-10)->(54,-10)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 D(46,-42)->(46,-42)
       fcb 2 ; drawmode 
       fcb 32,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 88 D(35,-18)->(35,-18)
       fcb 2 ; drawmode 
       fcb -24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 89 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb 3,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 M(62,-2)->(62,-2)
       fcb 0 ; drawmode 
       fcb -19,34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 91 D(90,-26)->(90,-26)
       fcb 2 ; drawmode 
       fcb 24,28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 92 D(80,-37)->(80,-37)
       fcb 2 ; drawmode 
       fcb 11,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 D(85,-41)->(85,-41)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 94 D(110,-15)->(110,-15)
       fcb 2 ; drawmode 
       fcb -26,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 95 D(105,-10)->(105,-10)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 96 D(95,-20)->(95,-20)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 97 D(67,4)->(67,4)
       fcb 2 ; drawmode 
       fcb -24,-28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 98 D(62,-2)->(62,-2)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 99 M(0,0)->(80,9)
       fcb 0 ; drawmode 
       fcb -2,-62 ; starx/y relative to previous node
       fdb -230,2048 ; dx/dy. dx(abs:2048|rel:2048) dy(abs:-230|rel:-230)
; node # 100 D(0,0)->(90,8)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 26,256 ; dx/dy. dx(abs:2304|rel:256) dy(abs:-204|rel:26)
; node # 101 D(0,0)->(92,18)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -256,51 ; dx/dy. dx(abs:2355|rel:51) dy(abs:-460|rel:-256)
; node # 102 D(0,0)->(81,19)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -26,-282 ; dx/dy. dx(abs:2073|rel:-282) dy(abs:-486|rel:-26)
; node # 103 M(0,0)->(115,5)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 358,871 ; dx/dy. dx(abs:2944|rel:871) dy(abs:-128|rel:358)
; node # 104 D(0,0)->(116,16)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -281,25 ; dx/dy. dx(abs:2969|rel:25) dy(abs:-409|rel:-281)
; node # 105 D(0,0)->(107,17)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -26,-230 ; dx/dy. dx(abs:2739|rel:-230) dy(abs:-435|rel:-26)
; node # 106 D(0,0)->(106,7)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 256,-26 ; dx/dy. dx(abs:2713|rel:-26) dy(abs:-179|rel:256)
; node # 107 D(0,0)->(115,5)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 51,231 ; dx/dy. dx(abs:2944|rel:231) dy(abs:-128|rel:51)
; node # 108 M(0,0)->(81,19)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -358,-871 ; dx/dy. dx(abs:2073|rel:-871) dy(abs:-486|rel:-358)
; node # 109 D(0,0)->(80,9)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 256,-25 ; dx/dy. dx(abs:2048|rel:-25) dy(abs:-230|rel:256)
       fcb  1  ; end of anim
; Animation 8
presentsframe8:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-72,33)->(-72,33)
       fcb 0 ; drawmode 
       fcb -33,-72 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-115,22)->(-115,22)
       fcb 2 ; drawmode 
       fcb 11,-43 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-110,3)->(-110,3)
       fcb 2 ; drawmode 
       fcb 19,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-100,-4)->(-100,-4)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-88,-1)->(-88,-1)
       fcb 2 ; drawmode 
       fcb -3,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-83,9)->(-83,9)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-85,21)->(-85,21)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-70,25)->(-70,25)
       fcb 2 ; drawmode 
       fcb -4,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-72,33)->(-72,33)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-92,19)->(-92,19)
       fcb 0 ; drawmode 
       fcb 14,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-106,16)->(-106,16)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-103,7)->(-103,7)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-96,5)->(-96,5)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-91,9)->(-91,9)
       fcb 2 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-92,19)->(-92,19)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-68,11)->(-68,11)
       fcb 0 ; drawmode 
       fcb 8,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-21)->(-100,-21)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-87,-33)->(-87,-33)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-75,-37)->(-75,-37)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-67,-30)->(-67,-30)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-66,-18)->(-66,-18)
       fcb 2 ; drawmode 
       fcb -12,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-45,-13)->(-45,-13)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-50,-7)->(-50,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(-71,-11)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 4,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-74,-8)->(-74,-8)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-62,5)->(-62,5)
       fcb 2 ; drawmode 
       fcb -13,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-68,11)->(-68,11)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-79,-13)->(-79,-13)
       fcb 0 ; drawmode 
       fcb 24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-88,-22)->(-88,-22)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(-81,-27)->(-81,-27)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(-76,-27)->(-76,-27)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-74,-21)->(-74,-21)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(-79,-13)->(-79,-13)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 M(-48,-10)->(-48,-10)
       fcb 0 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-66,-50)->(-66,-50)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-41,-61)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-38,-55)->(-38,-55)
       fcb 2 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-56,-47)->(-56,-47)
       fcb 2 ; drawmode 
       fcb -8,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-52,-38)->(-52,-38)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-39,-44)->(-39,-44)
       fcb 2 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-36,-37)->(-36,-37)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-49,-31)->(-49,-31)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-44,-20)->(-44,-20)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-26,-28)->(-26,-28)
       fcb 2 ; drawmode 
       fcb 8,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-23,-21)->(-23,-21)
       fcb 2 ; drawmode 
       fcb -7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-48,-10)->(-48,-10)
       fcb 2 ; drawmode 
       fcb -11,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-24,-21)->(-24,-21)
       fcb 0 ; drawmode 
       fcb 11,24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 48 D(-24,-30)->(-24,-30)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(-14,-29)->(-14,-29)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(-8,-33)->(-8,-33)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(-11,-39)->(-11,-39)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 D(-23,-43)->(-23,-43)
       fcb 2 ; drawmode 
       fcb 4,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(-30,-51)->(-30,-51)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(-28,-62)->(-28,-62)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(-19,-68)->(-19,-68)
       fcb 2 ; drawmode 
       fcb 6,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(-6,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb -2,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-8,-59)->(-8,-59)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(-17,-60)->(-17,-60)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(-22,-56)->(-22,-56)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-19,-51)->(-19,-51)
       fcb 2 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-7,-46)->(-7,-46)
       fcb 2 ; drawmode 
       fcb -5,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 D(-1,-40)->(-1,-40)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 D(0,-31)->(0,-31)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(-8,-22)->(-8,-22)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 D(-24,-21)->(-24,-21)
       fcb 2 ; drawmode 
       fcb -1,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 M(1,-24)->(1,-24)
       fcb 0 ; drawmode 
       fcb 3,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 D(6,-68)->(6,-68)
       fcb 2 ; drawmode 
       fcb 44,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 D(34,-65)->(34,-65)
       fcb 2 ; drawmode 
       fcb -3,28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 69 D(33,-58)->(33,-58)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 70 D(13,-60)->(13,-60)
       fcb 2 ; drawmode 
       fcb 2,-20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 71 D(12,-51)->(12,-51)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 72 D(27,-49)->(27,-49)
       fcb 2 ; drawmode 
       fcb -2,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 73 D(26,-42)->(26,-42)
       fcb 2 ; drawmode 
       fcb -7,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 74 D(12,-44)->(12,-44)
       fcb 2 ; drawmode 
       fcb 2,-14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 75 D(10,-31)->(10,-31)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 76 D(30,-28)->(30,-28)
       fcb 2 ; drawmode 
       fcb -3,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 77 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb -7,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 78 D(1,-24)->(1,-24)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 79 M(28,-21)->(28,-21)
       fcb 0 ; drawmode 
       fcb -3,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 80 D(46,-62)->(46,-62)
       fcb 2 ; drawmode 
       fcb 41,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 81 D(50,-60)->(50,-60)
       fcb 2 ; drawmode 
       fcb -2,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 82 D(57,-28)->(57,-28)
       fcb 2 ; drawmode 
       fcb -32,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 83 D(68,-52)->(68,-52)
       fcb 2 ; drawmode 
       fcb 24,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 84 D(75,-48)->(75,-48)
       fcb 2 ; drawmode 
       fcb -4,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 85 D(57,-8)->(57,-8)
       fcb 2 ; drawmode 
       fcb -40,-18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 86 D(54,-10)->(54,-10)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 D(46,-42)->(46,-42)
       fcb 2 ; drawmode 
       fcb 32,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 88 D(35,-18)->(35,-18)
       fcb 2 ; drawmode 
       fcb -24,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 89 D(28,-21)->(28,-21)
       fcb 2 ; drawmode 
       fcb 3,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 90 M(62,-2)->(62,-2)
       fcb 0 ; drawmode 
       fcb -19,34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 91 D(90,-26)->(90,-26)
       fcb 2 ; drawmode 
       fcb 24,28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 92 D(80,-37)->(80,-37)
       fcb 2 ; drawmode 
       fcb 11,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 D(85,-41)->(85,-41)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 94 D(110,-15)->(110,-15)
       fcb 2 ; drawmode 
       fcb -26,25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 95 D(105,-10)->(105,-10)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 96 D(95,-20)->(95,-20)
       fcb 2 ; drawmode 
       fcb 10,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 97 D(67,4)->(67,4)
       fcb 2 ; drawmode 
       fcb -24,-28 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 98 D(62,-2)->(62,-2)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 99 M(80,9)->(80,9)
       fcb 0 ; drawmode 
       fcb -11,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 100 D(90,8)->(90,8)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 101 D(92,18)->(92,18)
       fcb 2 ; drawmode 
       fcb -10,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 102 D(81,19)->(81,19)
       fcb 2 ; drawmode 
       fcb -1,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 103 M(115,5)->(115,5)
       fcb 0 ; drawmode 
       fcb 14,34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 104 D(116,16)->(116,16)
       fcb 2 ; drawmode 
       fcb -11,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 105 D(107,17)->(107,17)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 106 D(106,7)->(106,7)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 107 D(115,5)->(115,5)
       fcb 2 ; drawmode 
       fcb 2,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 108 M(81,19)->(81,19)
       fcb 0 ; drawmode 
       fcb -14,-34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 109 D(80,9)->(80,9)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
