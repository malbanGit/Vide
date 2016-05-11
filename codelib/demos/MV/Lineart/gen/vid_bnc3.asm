bncoutroframecount equ 6 ; number of animations
bncoutroframetotal equ 110 ; total number of frames in animation 
; index table 
bncoutroframetab        fdb bncoutroframe0
       fdb bncoutroframe1
       fdb bncoutroframe2
       fdb bncoutroframe3
       fdb bncoutroframe4
       fdb bncoutroframe5

; Animation 0
bncoutroframe0:
       fcb 10 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(18,0)->(44,-108)
       fcb 0 ; drawmode 
       fcb 0,18 ; starx/y relative to previous node
       fdb 2764,665 ; dx/dy. dx(abs:665|rel:665) dy(abs:2764|rel:2764)
; node # 1 M(18,0)->(44,-108)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:665|rel:0) dy(abs:2764|rel:0)
; node # 2 D(18,17)->(45,-85)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb -153,26 ; dx/dy. dx(abs:691|rel:26) dy(abs:2611|rel:-153)
; node # 3 D(18,34)->(45,-68)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:691|rel:0) dy(abs:2611|rel:0)
; node # 4 D(18,52)->(46,-47)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb -77,25 ; dx/dy. dx(abs:716|rel:25) dy(abs:2534|rel:-77)
; node # 5 D(18,71)->(46,-31)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 77,0 ; dx/dy. dx(abs:716|rel:0) dy(abs:2611|rel:77)
; node # 6 D(18,93)->(46,-13)
       fcb 2 ; drawmode 
       fcb -22,0 ; starx/y relative to previous node
       fdb 102,0 ; dx/dy. dx(abs:716|rel:0) dy(abs:2713|rel:102)
; node # 7 D(18,118)->(46,41)
       fcb 2 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb -742,0 ; dx/dy. dx(abs:716|rel:0) dy(abs:1971|rel:-742)
; node # 8 D(-33,95)->(-28,65)
       fcb 2 ; drawmode 
       fcb 23,-51 ; starx/y relative to previous node
       fdb -1203,-588 ; dx/dy. dx(abs:128|rel:-588) dy(abs:768|rel:-1203)
; node # 9 D(-71,76)->(-102,88)
       fcb 2 ; drawmode 
       fcb 19,-38 ; starx/y relative to previous node
       fdb -1075,-921 ; dx/dy. dx(abs:-793|rel:-921) dy(abs:-307|rel:-1075)
; node # 10 D(-71,58)->(-104,19)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 1305,-51 ; dx/dy. dx(abs:-844|rel:-51) dy(abs:998|rel:1305)
; node # 11 D(-71,38)->(-104,-12)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 282,0 ; dx/dy. dx(abs:-844|rel:0) dy(abs:1280|rel:282)
; node # 12 D(-71,18)->(-104,-29)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb -77,0 ; dx/dy. dx(abs:-844|rel:0) dy(abs:1203|rel:-77)
; node # 13 D(-71,-2)->(-104,-49)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-844|rel:0) dy(abs:1203|rel:0)
; node # 14 D(-71,-23)->(-104,-89)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 486,0 ; dx/dy. dx(abs:-844|rel:0) dy(abs:1689|rel:486)
; node # 15 D(-28,-12)->(-1,-102)
       fcb 2 ; drawmode 
       fcb -11,43 ; starx/y relative to previous node
       fdb 615,1535 ; dx/dy. dx(abs:691|rel:1535) dy(abs:2304|rel:615)
; node # 16 D(18,0)->(45,-108)
       fcb 2 ; drawmode 
       fcb -12,46 ; starx/y relative to previous node
       fdb 460,0 ; dx/dy. dx(abs:691|rel:0) dy(abs:2764|rel:460)
; node # 17 D(78,-23)->(45,-108)
       fcb 2 ; drawmode 
       fcb 23,60 ; starx/y relative to previous node
       fdb -588,-1535 ; dx/dy. dx(abs:-844|rel:-1535) dy(abs:2176|rel:-588)
; node # 18 D(78,-6)->(45,-69)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb -564,0 ; dx/dy. dx(abs:-844|rel:0) dy(abs:1612|rel:-564)
; node # 19 D(78,10)->(46,-47)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb -153,25 ; dx/dy. dx(abs:-819|rel:25) dy(abs:1459|rel:-153)
; node # 20 D(78,25)->(46,-13)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb -487,0 ; dx/dy. dx(abs:-819|rel:0) dy(abs:972|rel:-487)
; node # 21 D(78,43)->(46,41)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb -921,0 ; dx/dy. dx(abs:-819|rel:0) dy(abs:51|rel:-921)
; node # 22 D(78,60)->(46,41)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 435,0 ; dx/dy. dx(abs:-819|rel:0) dy(abs:486|rel:435)
; node # 23 D(78,78)->(45,41)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 461,-25 ; dx/dy. dx(abs:-844|rel:-25) dy(abs:947|rel:461)
; node # 24 D(18,118)->(45,41)
       fcb 2 ; drawmode 
       fcb -40,-60 ; starx/y relative to previous node
       fdb 1024,1535 ; dx/dy. dx(abs:691|rel:1535) dy(abs:1971|rel:1024)
; node # 25 M(51,42)->(45,-31)
       fcb 0 ; drawmode 
       fcb 76,33 ; starx/y relative to previous node
       fdb -103,-844 ; dx/dy. dx(abs:-153|rel:-844) dy(abs:1868|rel:-103)
; node # 26 M(78,-23)->(45,-108)
       fcb 0 ; drawmode 
       fcb 65,27 ; starx/y relative to previous node
       fdb 308,-691 ; dx/dy. dx(abs:-844|rel:-691) dy(abs:2176|rel:308)
; node # 27 D(35,-32)->(-1,-102)
       fcb 2 ; drawmode 
       fcb 9,-43 ; starx/y relative to previous node
       fdb -384,-77 ; dx/dy. dx(abs:-921|rel:-77) dy(abs:1792|rel:-384)
; node # 28 D(-2,-40)->(-104,-89)
       fcb 2 ; drawmode 
       fcb 8,-37 ; starx/y relative to previous node
       fdb -538,-1690 ; dx/dy. dx(abs:-2611|rel:-1690) dy(abs:1254|rel:-538)
; node # 29 D(-71,-23)->(-104,-89)
       fcb 2 ; drawmode 
       fcb -17,-69 ; starx/y relative to previous node
       fdb 435,1767 ; dx/dy. dx(abs:-844|rel:1767) dy(abs:1689|rel:435)
; node # 30 M(-30,-73)->(-30,-113)
       fcb 0 ; drawmode 
       fcb 50,41 ; starx/y relative to previous node
       fdb -665,844 ; dx/dy. dx(abs:0|rel:844) dy(abs:1024|rel:-665)
; node # 31 M(0,-121)->(-4,-126)
       fcb 0 ; drawmode 
       fcb 48,30 ; starx/y relative to previous node
       fdb -896,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:128|rel:-896)
; node # 32 D(0,-110)->(-5,-126)
       fcb 2 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb 281,-26 ; dx/dy. dx(abs:-128|rel:-26) dy(abs:409|rel:281)
; node # 33 D(17,-110)->(1,-127)
       fcb 2 ; drawmode 
       fcb 0,17 ; starx/y relative to previous node
       fdb 26,-281 ; dx/dy. dx(abs:-409|rel:-281) dy(abs:435|rel:26)
; node # 34 D(17,-121)->(-3,-126)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb -307,-103 ; dx/dy. dx(abs:-512|rel:-103) dy(abs:128|rel:-307)
; node # 35 D(0,-121)->(-4,-126)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb 0,410 ; dx/dy. dx(abs:-102|rel:410) dy(abs:128|rel:0)
       fcb  1  ; end of anim
; Animation 1
bncoutroframe1:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(45,-35)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 35,45 ; starx/y relative to previous node
       fdb -204,-883 ; dx/dy. dx(abs:-883|rel:-883) dy(abs:-204|rel:-204)
; node # 1 D(45,-35)->(45,-35)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 204,883 ; dx/dy. dx(abs:0|rel:883) dy(abs:0|rel:204)
; node # 2 D(45,41)->(45,41)
       fcb 2 ; drawmode 
       fcb -76,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-24,63)->(-24,63)
       fcb 2 ; drawmode 
       fcb -22,-69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-24,63)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 1049,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:1049|rel:1049)
; node # 5 M(-103,-1)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 64,-79 ; starx/y relative to previous node
       fdb -819,1011 ; dx/dy. dx(abs:1011|rel:1011) dy(abs:230|rel:-819)
; node # 6 D(-103,-1)->(-103,-1)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -230,-1011 ; dx/dy. dx(abs:0|rel:-1011) dy(abs:0|rel:-230)
; node # 7 D(-103,87)->(-103,87)
       fcb 2 ; drawmode 
       fcb -88,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-24,63)->(-24,63)
       fcb 2 ; drawmode 
       fcb 24,79 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-24,63)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 1049,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:1049|rel:1049)
; node # 10 M(-33,-22)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 85,-9 ; starx/y relative to previous node
       fdb -1087,115 ; dx/dy. dx(abs:115|rel:115) dy(abs:-38|rel:-1087)
; node # 11 M(-24,-99)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 77,9 ; starx/y relative to previous node
       fdb -986,-115 ; dx/dy. dx(abs:0|rel:-115) dy(abs:-1024|rel:-986)
; node # 12 D(-24,-99)->(-24,-99)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 1024,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:1024)
; node # 13 D(-104,-89)->(-104,-89)
       fcb 2 ; drawmode 
       fcb -10,-80 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-103,-1)->(-103,-1)
       fcb 2 ; drawmode 
       fcb -88,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-103,-1)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 230,1011 ; dx/dy. dx(abs:1011|rel:1011) dy(abs:230|rel:230)
; node # 16 M(-30,-38)->(-43,-31)
       fcb 0 ; drawmode 
       fcb 37,73 ; starx/y relative to previous node
       fdb -319,-1177 ; dx/dy. dx(abs:-166|rel:-1177) dy(abs:-89|rel:-319)
; node # 17 M(45,-35)->(-24,-19)
       fcb 0 ; drawmode 
       fcb -3,75 ; starx/y relative to previous node
       fdb -115,-717 ; dx/dy. dx(abs:-883|rel:-717) dy(abs:-204|rel:-115)
; node # 18 D(45,-35)->(45,-35)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 204,883 ; dx/dy. dx(abs:0|rel:883) dy(abs:0|rel:204)
; node # 19 D(45,-108)->(45,-108)
       fcb 2 ; drawmode 
       fcb 73,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-24,-99)->(-24,-99)
       fcb 2 ; drawmode 
       fcb -9,-69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-24,-99)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -1024,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-1024|rel:-1024)
       fcb  1  ; end of anim
; Animation 2
bncoutroframe2:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-24,-19)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 19,-24 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(45,-35)->(45,-35)
       fcb 2 ; drawmode 
       fcb 16,69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(45,41)->(45,41)
       fcb 2 ; drawmode 
       fcb -76,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-24,63)->(-24,63)
       fcb 2 ; drawmode 
       fcb -22,-69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-24,-19)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 82,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 M(-24,-19)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-103,-1)->(-103,-1)
       fcb 2 ; drawmode 
       fcb -18,-79 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-103,87)->(-103,87)
       fcb 2 ; drawmode 
       fcb -88,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-24,63)->(-24,63)
       fcb 2 ; drawmode 
       fcb 24,79 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-24,-19)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 82,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-24,-19)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-24,-99)->(-24,-99)
       fcb 2 ; drawmode 
       fcb 80,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-104,-89)->(-104,-89)
       fcb 2 ; drawmode 
       fcb -10,-80 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-103,-1)->(-103,-1)
       fcb 2 ; drawmode 
       fcb -88,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-24,-19)->(-24,-19)
       fcb 2 ; drawmode 
       fcb 18,79 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-24,-19)->(-24,-19)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(45,-35)->(45,-35)
       fcb 2 ; drawmode 
       fcb 16,69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(45,-108)->(45,-108)
       fcb 2 ; drawmode 
       fcb 73,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-24,-99)->(-24,-99)
       fcb 2 ; drawmode 
       fcb -9,-69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-24,-99)->(-24,-99)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 M(70,-68)->(28,-56)
       fcb 0 ; drawmode 
       fcb -31,94 ; starx/y relative to previous node
       fdb -153,-537 ; dx/dy. dx(abs:-537|rel:-537) dy(abs:-153|rel:-153)
; node # 21 M(127,-35)->(-17,-17)
       fcb 0 ; drawmode 
       fcb -33,57 ; starx/y relative to previous node
       fdb -77,-1306 ; dx/dy. dx(abs:-1843|rel:-1306) dy(abs:-230|rel:-77)
; node # 22 D(127,-23)->(-27,-13)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 102,-128 ; dx/dy. dx(abs:-1971|rel:-128) dy(abs:-128|rel:102)
; node # 23 D(118,-30)->(-29,-22)
       fcb 2 ; drawmode 
       fcb 7,-9 ; starx/y relative to previous node
       fdb 26,90 ; dx/dy. dx(abs:-1881|rel:90) dy(abs:-102|rel:26)
; node # 24 D(126,-35)->(-17,-16)
       fcb 2 ; drawmode 
       fcb 5,8 ; starx/y relative to previous node
       fdb -141,51 ; dx/dy. dx(abs:-1830|rel:51) dy(abs:-243|rel:-141)
       fcb  1  ; end of anim
; Animation 3
bncoutroframe3:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-24,-19)->(-32,-13)
       fcb 0 ; drawmode 
       fcb 19,-24 ; starx/y relative to previous node
       fdb -76,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-76|rel:-76)
; node # 1 D(45,-35)->(7,-29)
       fcb 2 ; drawmode 
       fcb 16,69 ; starx/y relative to previous node
       fdb 0,-384 ; dx/dy. dx(abs:-486|rel:-384) dy(abs:-76|rel:0)
; node # 2 D(45,41)->(5,1)
       fcb 2 ; drawmode 
       fcb -76,0 ; starx/y relative to previous node
       fdb 588,-26 ; dx/dy. dx(abs:-512|rel:-26) dy(abs:512|rel:588)
; node # 3 D(-24,63)->(-31,38)
       fcb 2 ; drawmode 
       fcb -22,-69 ; starx/y relative to previous node
       fdb -192,423 ; dx/dy. dx(abs:-89|rel:423) dy(abs:320|rel:-192)
; node # 4 D(-24,-19)->(-32,-13)
       fcb 2 ; drawmode 
       fcb 82,0 ; starx/y relative to previous node
       fdb -396,-13 ; dx/dy. dx(abs:-102|rel:-13) dy(abs:-76|rel:-396)
; node # 5 M(-24,-19)->(-76,-7)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -77,-563 ; dx/dy. dx(abs:-665|rel:-563) dy(abs:-153|rel:-77)
; node # 6 D(-103,-1)->(-124,16)
       fcb 2 ; drawmode 
       fcb -18,-79 ; starx/y relative to previous node
       fdb -64,397 ; dx/dy. dx(abs:-268|rel:397) dy(abs:-217|rel:-64)
; node # 7 D(-103,87)->(-122,68)
       fcb 2 ; drawmode 
       fcb -88,0 ; starx/y relative to previous node
       fdb 460,25 ; dx/dy. dx(abs:-243|rel:25) dy(abs:243|rel:460)
; node # 8 D(-24,63)->(-79,36)
       fcb 2 ; drawmode 
       fcb 24,79 ; starx/y relative to previous node
       fdb 102,-461 ; dx/dy. dx(abs:-704|rel:-461) dy(abs:345|rel:102)
; node # 9 D(-24,-19)->(-75,-7)
       fcb 2 ; drawmode 
       fcb 82,0 ; starx/y relative to previous node
       fdb -498,52 ; dx/dy. dx(abs:-652|rel:52) dy(abs:-153|rel:-498)
; node # 10 M(-24,-19)->(-57,-54)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 601,230 ; dx/dy. dx(abs:-422|rel:230) dy(abs:448|rel:601)
; node # 11 D(-24,-99)->(-51,-114)
       fcb 2 ; drawmode 
       fcb 80,0 ; starx/y relative to previous node
       fdb -256,77 ; dx/dy. dx(abs:-345|rel:77) dy(abs:192|rel:-256)
; node # 12 D(-104,-89)->(-107,-121)
       fcb 2 ; drawmode 
       fcb -10,-80 ; starx/y relative to previous node
       fdb 217,307 ; dx/dy. dx(abs:-38|rel:307) dy(abs:409|rel:217)
; node # 13 D(-103,-1)->(-125,-65)
       fcb 2 ; drawmode 
       fcb -88,1 ; starx/y relative to previous node
       fdb 410,-243 ; dx/dy. dx(abs:-281|rel:-243) dy(abs:819|rel:410)
; node # 14 D(-24,-19)->(-57,-54)
       fcb 2 ; drawmode 
       fcb 18,79 ; starx/y relative to previous node
       fdb -371,-141 ; dx/dy. dx(abs:-422|rel:-141) dy(abs:448|rel:-371)
; node # 15 M(-24,-19)->(-23,-76)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 281,434 ; dx/dy. dx(abs:12|rel:434) dy(abs:729|rel:281)
; node # 16 D(45,-35)->(20,-82)
       fcb 2 ; drawmode 
       fcb 16,69 ; starx/y relative to previous node
       fdb -128,-332 ; dx/dy. dx(abs:-320|rel:-332) dy(abs:601|rel:-128)
; node # 17 D(45,-108)->(12,-125)
       fcb 2 ; drawmode 
       fcb 73,0 ; starx/y relative to previous node
       fdb -384,-102 ; dx/dy. dx(abs:-422|rel:-102) dy(abs:217|rel:-384)
; node # 18 D(-24,-99)->(-41,-122)
       fcb 2 ; drawmode 
       fcb -9,-69 ; starx/y relative to previous node
       fdb 77,205 ; dx/dy. dx(abs:-217|rel:205) dy(abs:294|rel:77)
; node # 19 D(-24,-19)->(-23,-76)
       fcb 2 ; drawmode 
       fcb -80,0 ; starx/y relative to previous node
       fdb 435,229 ; dx/dy. dx(abs:12|rel:229) dy(abs:729|rel:435)
; node # 20 M(-19,-30)->(-72,-61)
       fcb 0 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb -333,-690 ; dx/dy. dx(abs:-678|rel:-690) dy(abs:396|rel:-333)
; node # 21 M(-17,-17)->(-117,-11)
       fcb 0 ; drawmode 
       fcb -13,2 ; starx/y relative to previous node
       fdb -472,-602 ; dx/dy. dx(abs:-1280|rel:-602) dy(abs:-76|rel:-472)
; node # 22 D(-27,-13)->(-126,-6)
       fcb 2 ; drawmode 
       fcb -4,-10 ; starx/y relative to previous node
       fdb -13,13 ; dx/dy. dx(abs:-1267|rel:13) dy(abs:-89|rel:-13)
; node # 23 D(-29,-22)->(-127,-16)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:-1254|rel:13) dy(abs:-76|rel:13)
; node # 24 D(-17,-16)->(-117,-11)
       fcb 2 ; drawmode 
       fcb -6,12 ; starx/y relative to previous node
       fdb 12,-26 ; dx/dy. dx(abs:-1280|rel:-26) dy(abs:-64|rel:12)
       fcb  1  ; end of anim
; Animation 4
bncoutroframe4:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-32,-13)->(-57,-45)
       fcb 0 ; drawmode 
       fcb 13,-32 ; starx/y relative to previous node
       fdb 409,-320 ; dx/dy. dx(abs:-320|rel:-320) dy(abs:409|rel:409)
; node # 1 D(7,-29)->(-57,-32)
       fcb 2 ; drawmode 
       fcb 16,39 ; starx/y relative to previous node
       fdb -371,-499 ; dx/dy. dx(abs:-819|rel:-499) dy(abs:38|rel:-371)
; node # 2 D(5,1)->(-70,-30)
       fcb 2 ; drawmode 
       fcb -30,-2 ; starx/y relative to previous node
       fdb 358,-141 ; dx/dy. dx(abs:-960|rel:-141) dy(abs:396|rel:358)
; node # 3 D(-31,38)->(-69,-42)
       fcb 2 ; drawmode 
       fcb -37,-36 ; starx/y relative to previous node
       fdb 628,474 ; dx/dy. dx(abs:-486|rel:474) dy(abs:1024|rel:628)
; node # 4 D(-32,-13)->(-58,-45)
       fcb 2 ; drawmode 
       fcb 51,-1 ; starx/y relative to previous node
       fdb -615,154 ; dx/dy. dx(abs:-332|rel:154) dy(abs:409|rel:-615)
; node # 5 M(-76,-7)->(-107,-21)
       fcb 0 ; drawmode 
       fcb -6,-44 ; starx/y relative to previous node
       fdb -230,-64 ; dx/dy. dx(abs:-396|rel:-64) dy(abs:179|rel:-230)
; node # 6 D(-124,16)->(-113,-32)
       fcb 2 ; drawmode 
       fcb -23,-48 ; starx/y relative to previous node
       fdb 435,536 ; dx/dy. dx(abs:140|rel:536) dy(abs:614|rel:435)
; node # 7 D(-122,68)->(-125,-29)
       fcb 2 ; drawmode 
       fcb -52,2 ; starx/y relative to previous node
       fdb 627,-178 ; dx/dy. dx(abs:-38|rel:-178) dy(abs:1241|rel:627)
; node # 8 D(-79,36)->(-121,-16)
       fcb 2 ; drawmode 
       fcb 32,43 ; starx/y relative to previous node
       fdb -576,-499 ; dx/dy. dx(abs:-537|rel:-499) dy(abs:665|rel:-576)
; node # 9 D(-75,-7)->(-107,-21)
       fcb 2 ; drawmode 
       fcb 43,4 ; starx/y relative to previous node
       fdb -486,128 ; dx/dy. dx(abs:-409|rel:128) dy(abs:179|rel:-486)
; node # 10 M(-57,-54)->(-111,-108)
       fcb 0 ; drawmode 
       fcb 47,18 ; starx/y relative to previous node
       fdb 512,-282 ; dx/dy. dx(abs:-691|rel:-282) dy(abs:691|rel:512)
; node # 11 D(-51,-114)->(-95,-103)
       fcb 2 ; drawmode 
       fcb 60,6 ; starx/y relative to previous node
       fdb -831,128 ; dx/dy. dx(abs:-563|rel:128) dy(abs:-140|rel:-831)
; node # 12 D(-107,-121)->(-80,-118)
       fcb 2 ; drawmode 
       fcb 7,-56 ; starx/y relative to previous node
       fdb 102,908 ; dx/dy. dx(abs:345|rel:908) dy(abs:-38|rel:102)
; node # 13 D(-125,-65)->(-107,-124)
       fcb 2 ; drawmode 
       fcb -56,-18 ; starx/y relative to previous node
       fdb 793,-115 ; dx/dy. dx(abs:230|rel:-115) dy(abs:755|rel:793)
; node # 14 D(-57,-54)->(-111,-108)
       fcb 2 ; drawmode 
       fcb -11,68 ; starx/y relative to previous node
       fdb -64,-921 ; dx/dy. dx(abs:-691|rel:-921) dy(abs:691|rel:-64)
; node # 15 M(-23,-76)->(-57,-112)
       fcb 0 ; drawmode 
       fcb 22,34 ; starx/y relative to previous node
       fdb -231,256 ; dx/dy. dx(abs:-435|rel:256) dy(abs:460|rel:-231)
; node # 16 D(20,-82)->(-50,-103)
       fcb 2 ; drawmode 
       fcb 6,43 ; starx/y relative to previous node
       fdb -192,-461 ; dx/dy. dx(abs:-896|rel:-461) dy(abs:268|rel:-192)
; node # 17 D(12,-125)->(-41,-111)
       fcb 2 ; drawmode 
       fcb 43,-8 ; starx/y relative to previous node
       fdb -447,218 ; dx/dy. dx(abs:-678|rel:218) dy(abs:-179|rel:-447)
; node # 18 D(-41,-122)->(-46,-124)
       fcb 2 ; drawmode 
       fcb -3,-53 ; starx/y relative to previous node
       fdb 204,614 ; dx/dy. dx(abs:-64|rel:614) dy(abs:25|rel:204)
; node # 19 D(-23,-76)->(-57,-113)
       fcb 2 ; drawmode 
       fcb -46,18 ; starx/y relative to previous node
       fdb 448,-371 ; dx/dy. dx(abs:-435|rel:-371) dy(abs:473|rel:448)
; node # 20 M(-72,-61)->(-72,-61)
       fcb 0 ; drawmode 
       fcb -15,-49 ; starx/y relative to previous node
       fdb -473,435 ; dx/dy. dx(abs:0|rel:435) dy(abs:0|rel:-473)
       fcb  1  ; end of anim
; Animation 5
bncoutroframe5:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-57,-45)->(-91,-57)
       fcb 0 ; drawmode 
       fcb 45,-57 ; starx/y relative to previous node
       fdb 153,-435 ; dx/dy. dx(abs:-435|rel:-435) dy(abs:153|rel:153)
; node # 1 D(-57,-32)->(-91,-57)
       fcb 2 ; drawmode 
       fcb -13,0 ; starx/y relative to previous node
       fdb 167,0 ; dx/dy. dx(abs:-435|rel:0) dy(abs:320|rel:167)
; node # 2 D(-70,-30)->(-91,-57)
       fcb 2 ; drawmode 
       fcb -2,-13 ; starx/y relative to previous node
       fdb 25,167 ; dx/dy. dx(abs:-268|rel:167) dy(abs:345|rel:25)
; node # 3 D(-69,-42)->(-91,-57)
       fcb 2 ; drawmode 
       fcb 12,1 ; starx/y relative to previous node
       fdb -153,-13 ; dx/dy. dx(abs:-281|rel:-13) dy(abs:192|rel:-153)
; node # 4 D(-58,-45)->(-91,-57)
       fcb 2 ; drawmode 
       fcb 3,11 ; starx/y relative to previous node
       fdb -39,-141 ; dx/dy. dx(abs:-422|rel:-141) dy(abs:153|rel:-39)
; node # 5 M(-107,-21)->(-126,-58)
       fcb 0 ; drawmode 
       fcb -24,-49 ; starx/y relative to previous node
       fdb 320,179 ; dx/dy. dx(abs:-243|rel:179) dy(abs:473|rel:320)
; node # 6 D(-113,-32)->(-126,-58)
       fcb 2 ; drawmode 
       fcb 11,-6 ; starx/y relative to previous node
       fdb -141,77 ; dx/dy. dx(abs:-166|rel:77) dy(abs:332|rel:-141)
; node # 7 D(-125,-29)->(-126,-58)
       fcb 2 ; drawmode 
       fcb -3,-12 ; starx/y relative to previous node
       fdb 39,154 ; dx/dy. dx(abs:-12|rel:154) dy(abs:371|rel:39)
; node # 8 D(-121,-16)->(-126,-58)
       fcb 2 ; drawmode 
       fcb -13,4 ; starx/y relative to previous node
       fdb 166,-52 ; dx/dy. dx(abs:-64|rel:-52) dy(abs:537|rel:166)
; node # 9 D(-107,-21)->(-126,-58)
       fcb 2 ; drawmode 
       fcb 5,14 ; starx/y relative to previous node
       fdb -64,-179 ; dx/dy. dx(abs:-243|rel:-179) dy(abs:473|rel:-64)
; node # 10 M(-111,-108)->(-122,-120)
       fcb 0 ; drawmode 
       fcb 87,-4 ; starx/y relative to previous node
       fdb -320,103 ; dx/dy. dx(abs:-140|rel:103) dy(abs:153|rel:-320)
; node # 11 D(-95,-103)->(-122,-120)
       fcb 2 ; drawmode 
       fcb -5,16 ; starx/y relative to previous node
       fdb 64,-205 ; dx/dy. dx(abs:-345|rel:-205) dy(abs:217|rel:64)
; node # 12 D(-80,-118)->(-122,-120)
       fcb 2 ; drawmode 
       fcb 15,15 ; starx/y relative to previous node
       fdb -192,-192 ; dx/dy. dx(abs:-537|rel:-192) dy(abs:25|rel:-192)
; node # 13 D(-107,-124)->(-122,-120)
       fcb 2 ; drawmode 
       fcb 6,-27 ; starx/y relative to previous node
       fdb -76,345 ; dx/dy. dx(abs:-192|rel:345) dy(abs:-51|rel:-76)
; node # 14 D(-111,-108)->(-122,-120)
       fcb 2 ; drawmode 
       fcb -16,-4 ; starx/y relative to previous node
       fdb 204,52 ; dx/dy. dx(abs:-140|rel:52) dy(abs:153|rel:204)
; node # 15 M(-57,-112)->(-83,-125)
       fcb 0 ; drawmode 
       fcb 4,54 ; starx/y relative to previous node
       fdb 13,-192 ; dx/dy. dx(abs:-332|rel:-192) dy(abs:166|rel:13)
; node # 16 D(-50,-103)->(-83,-125)
       fcb 2 ; drawmode 
       fcb -9,7 ; starx/y relative to previous node
       fdb 115,-90 ; dx/dy. dx(abs:-422|rel:-90) dy(abs:281|rel:115)
; node # 17 D(-41,-111)->(-83,-125)
       fcb 2 ; drawmode 
       fcb 8,9 ; starx/y relative to previous node
       fdb -102,-115 ; dx/dy. dx(abs:-537|rel:-115) dy(abs:179|rel:-102)
; node # 18 D(-46,-124)->(-83,-125)
       fcb 2 ; drawmode 
       fcb 13,-5 ; starx/y relative to previous node
       fdb -167,64 ; dx/dy. dx(abs:-473|rel:64) dy(abs:12|rel:-167)
; node # 19 D(-57,-113)->(-83,-125)
       fcb 2 ; drawmode 
       fcb -11,-11 ; starx/y relative to previous node
       fdb 141,141 ; dx/dy. dx(abs:-332|rel:141) dy(abs:153|rel:141)
; node # 20 M(-72,-61)->(-72,-61)
       fcb 0 ; drawmode 
       fcb -52,-15 ; starx/y relative to previous node
       fdb -153,332 ; dx/dy. dx(abs:0|rel:332) dy(abs:0|rel:-153)
       fcb  1  ; end of anim
