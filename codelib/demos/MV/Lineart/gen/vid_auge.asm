augeframecount EQU 4 ; number of animations
augeframetotal EQU 32 ; total number of frames in animation 
; index table 
augeframetab        fdb augeframe0
       fdb augeframe1
       fdb augeframe2
       fdb augeframe3

; Animation 0
augeframe0:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-85,17)->(-85,17)
       fcb 0 ; drawmode 
       fcb -17,-85 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-85,5)->(-84,5)
       fcb 2 ; drawmode 
       fcb 12,0 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:0|rel:0)
; node # 3 D(-75,-13)->(-74,-8)
       fcb 2 ; drawmode 
       fcb 18,10 ; starx/y relative to previous node
       fdb -160,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-160|rel:-160)
; node # 4 D(-54,-28)->(-54,-22)
       fcb 2 ; drawmode 
       fcb 15,21 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-192|rel:-32)
; node # 5 D(-23,-37)->(-22,-31)
       fcb 2 ; drawmode 
       fcb 9,31 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-192|rel:0)
; node # 6 D(12,-39)->(11,-32)
       fcb 2 ; drawmode 
       fcb 2,35 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:-224|rel:-32)
; node # 7 D(41,-31)->(41,-26)
       fcb 2 ; drawmode 
       fcb -8,29 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-160|rel:64)
; node # 8 D(79,-7)->(76,-6)
       fcb 2 ; drawmode 
       fcb -24,38 ; starx/y relative to previous node
       fdb 128,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:-32|rel:128)
; node # 9 D(96,-1)->(96,-1)
       fcb 2 ; drawmode 
       fcb -6,17 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:32)
; node # 10 D(111,0)->(111,0)
       fcb 2 ; drawmode 
       fcb -1,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(78,11)->(78,11)
       fcb 2 ; drawmode 
       fcb -11,-33 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(42,30)->(41,27)
       fcb 2 ; drawmode 
       fcb -19,-36 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:96|rel:96)
; node # 13 D(-2,34)->(0,32)
       fcb 2 ; drawmode 
       fcb -4,-44 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:64|rel:96) dy(abs:64|rel:-32)
; node # 14 D(-31,30)->(-32,28)
       fcb 2 ; drawmode 
       fcb 4,-29 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-32|rel:-96) dy(abs:64|rel:0)
; node # 15 D(-67,23)->(-67,21)
       fcb 2 ; drawmode 
       fcb 7,-36 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:64|rel:0)
; node # 16 D(-85,17)->(-85,17)
       fcb 2 ; drawmode 
       fcb 6,-18 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-64)
; node # 17 M(-41,27)->(-42,25)
       fcb 0 ; drawmode 
       fcb -10,44 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:64|rel:64)
; node # 18 D(-49,13)->(-49,13)
       fcb 2 ; drawmode 
       fcb 14,-8 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-64)
; node # 19 D(-52,-2)->(-52,-2)
       fcb 2 ; drawmode 
       fcb 15,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-50,-10)->(-50,-10)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-46,-21)->(-46,-21)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(-40,-32)->(-44,-25)
       fcb 2 ; drawmode 
       fcb 11,6 ; starx/y relative to previous node
       fdb -224,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-224|rel:-224)
; node # 23 M(36,-32)->(40,-26)
       fcb 0 ; drawmode 
       fcb 0,76 ; starx/y relative to previous node
       fdb 32,256 ; dx/dy. dx(abs:128|rel:256) dy(abs:-192|rel:32)
; node # 24 D(43,-23)->(43,-23)
       fcb 2 ; drawmode 
       fcb -9,7 ; starx/y relative to previous node
       fdb 192,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:0|rel:192)
; node # 25 D(48,-14)->(48,-14)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(50,-1)->(50,-1)
       fcb 2 ; drawmode 
       fcb -13,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(49,11)->(49,11)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(44,23)->(44,23)
       fcb 2 ; drawmode 
       fcb -12,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(39,30)->(42,26)
       fcb 2 ; drawmode 
       fcb -7,-5 ; starx/y relative to previous node
       fdb 128,96 ; dx/dy. dx(abs:96|rel:96) dy(abs:128|rel:128)
; node # 30 M(-30,-12)->(-30,-12)
       fcb 0 ; drawmode 
       fcb 42,-69 ; starx/y relative to previous node
       fdb -128,-96 ; dx/dy. dx(abs:0|rel:-96) dy(abs:0|rel:-128)
; node # 31 D(-23,-23)->(-23,-23)
       fcb 2 ; drawmode 
       fcb 11,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-12,-30)->(-12,-30)
       fcb 2 ; drawmode 
       fcb 7,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(0,-32)->(0,-32)
       fcb 2 ; drawmode 
       fcb 2,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(12,-30)->(12,-30)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(23,-23)->(23,-23)
       fcb 2 ; drawmode 
       fcb -7,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(30,-12)->(30,-12)
       fcb 2 ; drawmode 
       fcb -11,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(32,0)->(32,0)
       fcb 2 ; drawmode 
       fcb -12,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(30,11)->(30,11)
       fcb 2 ; drawmode 
       fcb -11,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(23,22)->(23,22)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(12,31)->(14,30)
       fcb 2 ; drawmode 
       fcb -9,-11 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:32|rel:32)
; node # 41 D(0,33)->(0,32)
       fcb 2 ; drawmode 
       fcb -2,-12 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:32|rel:0)
; node # 42 D(-12,31)->(-13,30)
       fcb 2 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:32|rel:0)
; node # 43 D(-22,23)->(-22,23)
       fcb 2 ; drawmode 
       fcb 8,-10 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-32)
; node # 44 D(-30,12)->(-30,12)
       fcb 2 ; drawmode 
       fcb 11,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-32,0)->(-32,0)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-30,-12)->(-30,-12)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-87,-5)->(-84,-4)
       fcb 0 ; drawmode 
       fcb -7,-57 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:96|rel:96) dy(abs:-32|rel:-32)
; node # 48 D(-91,-5)->(-89,-4)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:64|rel:-32) dy(abs:-32|rel:0)
; node # 49 D(-98,-7)->(-95,-6)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:96|rel:32) dy(abs:-32|rel:0)
; node # 50 D(-109,-14)->(-107,-11)
       fcb 2 ; drawmode 
       fcb 7,-11 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:64|rel:-32) dy(abs:-96|rel:-64)
; node # 51 M(-74,-19)->(-72,-17)
       fcb 0 ; drawmode 
       fcb 5,35 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:-64|rel:32)
; node # 52 D(-77,-19)->(-76,-17)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-64|rel:0)
; node # 53 D(-88,-21)->(-85,-20)
       fcb 2 ; drawmode 
       fcb 2,-11 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:96|rel:64) dy(abs:-32|rel:32)
; node # 54 D(-98,-30)->(-98,-26)
       fcb 2 ; drawmode 
       fcb 9,-10 ; starx/y relative to previous node
       fdb -96,-96 ; dx/dy. dx(abs:0|rel:-96) dy(abs:-128|rel:-96)
; node # 55 M(-62,-28)->(-62,-24)
       fcb 0 ; drawmode 
       fcb -2,36 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:0)
; node # 56 D(-66,-28)->(-66,-25)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-96|rel:32)
; node # 57 D(-74,-32)->(-73,-29)
       fcb 2 ; drawmode 
       fcb 4,-8 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-96|rel:0)
; node # 58 D(-85,-41)->(-85,-38)
       fcb 2 ; drawmode 
       fcb 9,-11 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-96|rel:0)
; node # 59 M(-47,-36)->(-47,-32)
       fcb 0 ; drawmode 
       fcb -5,38 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:-32)
; node # 60 D(-50,-37)->(-50,-33)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:0)
; node # 61 D(-60,-42)->(-60,-38)
       fcb 2 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:0)
; node # 62 D(-67,-52)->(-67,-47)
       fcb 2 ; drawmode 
       fcb 10,-7 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-160|rel:-32)
; node # 63 M(-33,-41)->(-32,-36)
       fcb 0 ; drawmode 
       fcb -11,34 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-160|rel:0)
; node # 64 D(-36,-43)->(-36,-40)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-96|rel:64)
; node # 65 D(-42,-48)->(-43,-47)
       fcb 2 ; drawmode 
       fcb 5,-6 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-32|rel:64)
; node # 66 D(-47,-58)->(-47,-54)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-128|rel:-96)
; node # 67 M(-18,-43)->(-17,-38)
       fcb 0 ; drawmode 
       fcb -15,29 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-160|rel:-32)
; node # 68 D(-20,-46)->(-20,-42)
       fcb 2 ; drawmode 
       fcb 3,-2 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-128|rel:32)
; node # 69 D(-22,-54)->(-23,-50)
       fcb 2 ; drawmode 
       fcb 8,-2 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-128|rel:0)
; node # 70 D(-23,-63)->(-25,-59)
       fcb 2 ; drawmode 
       fcb 9,-1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:-128|rel:0)
; node # 71 M(-1,-45)->(-1,-40)
       fcb 0 ; drawmode 
       fcb -18,22 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:-160|rel:-32)
; node # 72 D(0,-48)->(1,-45)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-96|rel:64)
; node # 73 D(0,-55)->(1,-53)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-64|rel:32)
; node # 74 D(0,-65)->(0,-61)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-128|rel:-64)
; node # 75 M(15,-44)->(14,-39)
       fcb 0 ; drawmode 
       fcb -21,15 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-160|rel:-32)
; node # 76 D(17,-46)->(18,-43)
       fcb 2 ; drawmode 
       fcb 2,2 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:32|rel:64) dy(abs:-96|rel:64)
; node # 77 D(21,-52)->(21,-48)
       fcb 2 ; drawmode 
       fcb 6,4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-128|rel:-32)
; node # 78 D(23,-62)->(23,-58)
       fcb 2 ; drawmode 
       fcb 10,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:0)
; node # 79 M(35,-41)->(31,-36)
       fcb 0 ; drawmode 
       fcb -21,12 ; starx/y relative to previous node
       fdb -32,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-160|rel:-32)
; node # 80 D(38,-43)->(36,-40)
       fcb 2 ; drawmode 
       fcb 2,3 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:-96|rel:64)
; node # 81 D(44,-49)->(41,-46)
       fcb 2 ; drawmode 
       fcb 6,6 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:-96|rel:0)
; node # 82 D(49,-59)->(45,-54)
       fcb 2 ; drawmode 
       fcb 10,5 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:-128|rel:-32) dy(abs:-160|rel:-64)
; node # 83 M(50,-31)->(46,-29)
       fcb 0 ; drawmode 
       fcb -28,1 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-64|rel:96)
; node # 84 D(54,-32)->(53,-31)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb 32,96 ; dx/dy. dx(abs:-32|rel:96) dy(abs:-32|rel:32)
; node # 85 D(63,-37)->(59,-34)
       fcb 2 ; drawmode 
       fcb 5,9 ; starx/y relative to previous node
       fdb -64,-96 ; dx/dy. dx(abs:-128|rel:-96) dy(abs:-96|rel:-64)
; node # 86 D(74,-47)->(70,-42)
       fcb 2 ; drawmode 
       fcb 10,11 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-160|rel:-64)
; node # 87 M(63,-22)->(61,-19)
       fcb 0 ; drawmode 
       fcb -25,-11 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:-96|rel:64)
; node # 88 D(69,-22)->(69,-20)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:-64|rel:32)
; node # 89 D(79,-25)->(77,-23)
       fcb 2 ; drawmode 
       fcb 3,10 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:-64|rel:0)
; node # 90 D(90,-31)->(87,-28)
       fcb 2 ; drawmode 
       fcb 6,11 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-96|rel:-32) dy(abs:-96|rel:-32)
       fcb  1  ; end of anim
; Animation 1
augeframe1:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-85,17)->(-84,16)
       fcb 0 ; drawmode 
       fcb -17,-85 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:32|rel:32)
; node # 2 D(-84,5)->(-84,11)
       fcb 2 ; drawmode 
       fcb 12,1 ; starx/y relative to previous node
       fdb -224,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-192|rel:-224)
; node # 3 D(-74,-8)->(-74,-3)
       fcb 2 ; drawmode 
       fcb 13,10 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-160|rel:32)
; node # 4 D(-54,-22)->(-52,-15)
       fcb 2 ; drawmode 
       fcb 14,20 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-224|rel:-64)
; node # 5 D(-22,-31)->(-25,-23)
       fcb 2 ; drawmode 
       fcb 9,32 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:-96|rel:-160) dy(abs:-256|rel:-32)
; node # 6 D(11,-32)->(5,-27)
       fcb 2 ; drawmode 
       fcb 1,33 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:-160|rel:96)
; node # 7 D(41,-26)->(41,-17)
       fcb 2 ; drawmode 
       fcb -6,30 ; starx/y relative to previous node
       fdb -128,192 ; dx/dy. dx(abs:0|rel:192) dy(abs:-288|rel:-128)
; node # 8 D(76,-6)->(78,-4)
       fcb 2 ; drawmode 
       fcb -20,35 ; starx/y relative to previous node
       fdb 224,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-64|rel:224)
; node # 9 D(96,-1)->(96,0)
       fcb 2 ; drawmode 
       fcb -5,20 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:-32|rel:32)
; node # 10 D(111,0)->(110,2)
       fcb 2 ; drawmode 
       fcb -1,15 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-64|rel:-32)
; node # 11 D(78,11)->(78,11)
       fcb 2 ; drawmode 
       fcb -11,-33 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:64)
; node # 12 D(41,27)->(40,23)
       fcb 2 ; drawmode 
       fcb -16,-37 ; starx/y relative to previous node
       fdb 128,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:128|rel:128)
; node # 13 D(0,32)->(0,29)
       fcb 2 ; drawmode 
       fcb -5,-41 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:96|rel:-32)
; node # 14 D(-32,28)->(-32,25)
       fcb 2 ; drawmode 
       fcb 4,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:96|rel:0)
; node # 15 D(-67,21)->(-67,19)
       fcb 2 ; drawmode 
       fcb 7,-35 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:64|rel:-32)
; node # 16 D(-85,17)->(-84,16)
       fcb 2 ; drawmode 
       fcb 4,-18 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:32|rel:-32)
; node # 17 M(-42,25)->(-43,23)
       fcb 0 ; drawmode 
       fcb -8,43 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:64|rel:32)
; node # 18 D(-49,13)->(-49,13)
       fcb 2 ; drawmode 
       fcb 12,-7 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-64)
; node # 19 D(-52,-2)->(-52,-2)
       fcb 2 ; drawmode 
       fcb 15,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-50,-10)->(-50,-10)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-46,-21)->(-48,-16)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb -160,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:-160|rel:-160)
; node # 22 D(-44,-25)->(-48,-16)
       fcb 2 ; drawmode 
       fcb 4,2 ; starx/y relative to previous node
       fdb -128,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:-288|rel:-128)
; node # 23 M(40,-26)->(48,-14)
       fcb 0 ; drawmode 
       fcb 1,84 ; starx/y relative to previous node
       fdb -96,384 ; dx/dy. dx(abs:256|rel:384) dy(abs:-384|rel:-96)
; node # 24 D(43,-23)->(48,-14)
       fcb 2 ; drawmode 
       fcb -3,3 ; starx/y relative to previous node
       fdb 96,-96 ; dx/dy. dx(abs:160|rel:-96) dy(abs:-288|rel:96)
; node # 25 D(48,-14)->(48,-14)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb 288,-160 ; dx/dy. dx(abs:0|rel:-160) dy(abs:0|rel:288)
; node # 26 D(50,-1)->(50,-1)
       fcb 2 ; drawmode 
       fcb -13,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(49,11)->(49,11)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(44,23)->(45,21)
       fcb 2 ; drawmode 
       fcb -12,-5 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:64|rel:64)
; node # 29 D(42,26)->(44,22)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:64|rel:32) dy(abs:128|rel:64)
; node # 30 M(-30,-12)->(-30,-12)
       fcb 0 ; drawmode 
       fcb 38,-72 ; starx/y relative to previous node
       fdb -128,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:0|rel:-128)
; node # 31 D(-23,-23)->(-23,-23)
       fcb 2 ; drawmode 
       fcb 11,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-12,-30)->(-22,-24)
       fcb 2 ; drawmode 
       fcb 7,11 ; starx/y relative to previous node
       fdb -192,-320 ; dx/dy. dx(abs:-320|rel:-320) dy(abs:-192|rel:-192)
; node # 33 D(0,-32)->(-22,-24)
       fcb 2 ; drawmode 
       fcb 2,12 ; starx/y relative to previous node
       fdb -64,-384 ; dx/dy. dx(abs:-704|rel:-384) dy(abs:-256|rel:-64)
; node # 34 M(0,-32)->(23,-23)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -32,1440 ; dx/dy. dx(abs:736|rel:1440) dy(abs:-288|rel:-32)
; node # 35 D(12,-30)->(23,-23)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 64,-384 ; dx/dy. dx(abs:352|rel:-384) dy(abs:-224|rel:64)
; node # 36 D(23,-23)->(23,-23)
       fcb 2 ; drawmode 
       fcb -7,11 ; starx/y relative to previous node
       fdb 224,-352 ; dx/dy. dx(abs:0|rel:-352) dy(abs:0|rel:224)
; node # 37 D(30,-12)->(30,-12)
       fcb 2 ; drawmode 
       fcb -11,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(32,0)->(32,0)
       fcb 2 ; drawmode 
       fcb -12,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(30,11)->(30,11)
       fcb 2 ; drawmode 
       fcb -11,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(23,22)->(23,22)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(14,30)->(19,26)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb 128,160 ; dx/dy. dx(abs:160|rel:160) dy(abs:128|rel:128)
; node # 42 M(-13,30)->(-18,27)
       fcb 0 ; drawmode 
       fcb 0,-27 ; starx/y relative to previous node
       fdb -32,-320 ; dx/dy. dx(abs:-160|rel:-320) dy(abs:96|rel:-32)
; node # 43 D(-22,23)->(-22,23)
       fcb 2 ; drawmode 
       fcb 7,-9 ; starx/y relative to previous node
       fdb -96,160 ; dx/dy. dx(abs:0|rel:160) dy(abs:0|rel:-96)
; node # 44 D(-30,12)->(-30,12)
       fcb 2 ; drawmode 
       fcb 11,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-32,0)->(-32,0)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-30,-12)->(-30,-12)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 M(-84,-4)->(-84,-1)
       fcb 0 ; drawmode 
       fcb -8,-54 ; starx/y relative to previous node
       fdb -96,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-96|rel:-96)
; node # 48 D(-89,-4)->(-88,-2)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-64|rel:32)
; node # 49 D(-95,-6)->(-95,-4)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-64|rel:0)
; node # 50 D(-107,-11)->(-107,-8)
       fcb 2 ; drawmode 
       fcb 5,-12 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-96|rel:-32)
; node # 51 M(-72,-17)->(-71,-14)
       fcb 0 ; drawmode 
       fcb 6,35 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-96|rel:0)
; node # 52 D(-76,-17)->(-78,-16)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:-64|rel:-96) dy(abs:-32|rel:64)
; node # 53 D(-85,-20)->(-85,-18)
       fcb 2 ; drawmode 
       fcb 3,-9 ; starx/y relative to previous node
       fdb -32,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:-64|rel:-32)
; node # 54 D(-98,-26)->(-95,-23)
       fcb 2 ; drawmode 
       fcb 6,-13 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:96|rel:96) dy(abs:-96|rel:-32)
; node # 55 M(-62,-24)->(-58,-21)
       fcb 0 ; drawmode 
       fcb -2,36 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:128|rel:32) dy(abs:-96|rel:0)
; node # 56 D(-66,-25)->(-63,-23)
       fcb 2 ; drawmode 
       fcb 1,-4 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:96|rel:-32) dy(abs:-64|rel:32)
; node # 57 D(-73,-29)->(-71,-27)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:64|rel:-32) dy(abs:-64|rel:0)
; node # 58 D(-85,-38)->(-81,-34)
       fcb 2 ; drawmode 
       fcb 9,-12 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:128|rel:64) dy(abs:-128|rel:-64)
; node # 59 M(-47,-32)->(-44,-27)
       fcb 0 ; drawmode 
       fcb -6,38 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:96|rel:-32) dy(abs:-160|rel:-32)
; node # 60 D(-50,-33)->(-50,-30)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:0|rel:-96) dy(abs:-96|rel:64)
; node # 61 D(-60,-38)->(-57,-34)
       fcb 2 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:96|rel:96) dy(abs:-128|rel:-32)
; node # 62 D(-67,-47)->(-65,-41)
       fcb 2 ; drawmode 
       fcb 9,-7 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:64|rel:-32) dy(abs:-192|rel:-64)
; node # 63 M(-32,-36)->(-30,-30)
       fcb 0 ; drawmode 
       fcb -11,35 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:-192|rel:0)
; node # 64 D(-36,-40)->(-35,-33)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-224|rel:-32)
; node # 65 D(-43,-47)->(-42,-41)
       fcb 2 ; drawmode 
       fcb 7,-7 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-192|rel:32)
; node # 66 D(-47,-54)->(-47,-47)
       fcb 2 ; drawmode 
       fcb 7,-4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-224|rel:-32)
; node # 67 M(-17,-38)->(-15,-33)
       fcb 0 ; drawmode 
       fcb -16,30 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-160|rel:64)
; node # 68 D(-20,-42)->(-19,-38)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-128|rel:32)
; node # 69 D(-23,-50)->(-23,-44)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb -64,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-192|rel:-64)
; node # 70 D(-25,-59)->(-26,-53)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-192|rel:0)
; node # 71 M(-1,-40)->(0,-36)
       fcb 0 ; drawmode 
       fcb -19,24 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:32|rel:64) dy(abs:-128|rel:64)
; node # 72 D(1,-45)->(2,-43)
       fcb 2 ; drawmode 
       fcb 5,2 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-64|rel:64)
; node # 73 D(1,-53)->(2,-50)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-96|rel:-32)
; node # 74 D(0,-61)->(2,-57)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:64|rel:32) dy(abs:-128|rel:-32)
; node # 75 M(14,-39)->(15,-35)
       fcb 0 ; drawmode 
       fcb -22,14 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-128|rel:0)
; node # 76 D(18,-43)->(20,-38)
       fcb 2 ; drawmode 
       fcb 4,4 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:64|rel:32) dy(abs:-160|rel:-32)
; node # 77 D(21,-48)->(24,-45)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:96|rel:32) dy(abs:-96|rel:64)
; node # 78 D(23,-58)->(28,-56)
       fcb 2 ; drawmode 
       fcb 10,2 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:160|rel:64) dy(abs:-64|rel:32)
; node # 79 M(31,-36)->(31,-30)
       fcb 0 ; drawmode 
       fcb -22,8 ; starx/y relative to previous node
       fdb -128,-160 ; dx/dy. dx(abs:0|rel:-160) dy(abs:-192|rel:-128)
; node # 80 D(36,-40)->(37,-34)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-192|rel:0)
; node # 81 D(41,-46)->(44,-42)
       fcb 2 ; drawmode 
       fcb 6,5 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:96|rel:64) dy(abs:-128|rel:64)
; node # 82 D(45,-54)->(50,-51)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:160|rel:64) dy(abs:-96|rel:32)
; node # 83 M(46,-29)->(46,-23)
       fcb 0 ; drawmode 
       fcb -25,1 ; starx/y relative to previous node
       fdb -96,-160 ; dx/dy. dx(abs:0|rel:-160) dy(abs:-192|rel:-96)
; node # 84 D(53,-31)->(54,-26)
       fcb 2 ; drawmode 
       fcb 2,7 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-160|rel:32)
; node # 85 D(59,-34)->(61,-30)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:64|rel:32) dy(abs:-128|rel:32)
; node # 86 D(70,-42)->(72,-39)
       fcb 2 ; drawmode 
       fcb 8,11 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:-96|rel:32)
; node # 87 M(61,-19)->(60,-16)
       fcb 0 ; drawmode 
       fcb -23,-9 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-32|rel:-96) dy(abs:-96|rel:0)
; node # 88 D(69,-20)->(69,-17)
       fcb 2 ; drawmode 
       fcb 1,8 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-96|rel:0)
; node # 89 D(77,-23)->(77,-19)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:-32)
; node # 90 D(87,-28)->(87,-24)
       fcb 2 ; drawmode 
       fcb 5,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:0)
       fcb  1  ; end of anim
; Animation 2
augeframe2:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-84,16)->(-85,15)
       fcb 0 ; drawmode 
       fcb -16,-84 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:32|rel:32)
; node # 2 D(-84,11)->(-82,12)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:64|rel:96) dy(abs:-32|rel:-64)
; node # 3 D(-74,-3)->(-74,4)
       fcb 2 ; drawmode 
       fcb 14,10 ; starx/y relative to previous node
       fdb -192,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:-224|rel:-192)
; node # 4 D(-52,-15)->(-54,-7)
       fcb 2 ; drawmode 
       fcb 12,22 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:-256|rel:-32)
; node # 5 D(-25,-23)->(-35,-11)
       fcb 2 ; drawmode 
       fcb 8,27 ; starx/y relative to previous node
       fdb -128,-256 ; dx/dy. dx(abs:-320|rel:-256) dy(abs:-384|rel:-128)
; node # 6 D(5,-27)->(1,-16)
       fcb 2 ; drawmode 
       fcb 4,30 ; starx/y relative to previous node
       fdb 32,192 ; dx/dy. dx(abs:-128|rel:192) dy(abs:-352|rel:32)
; node # 7 D(41,-17)->(40,-11)
       fcb 2 ; drawmode 
       fcb -10,36 ; starx/y relative to previous node
       fdb 160,96 ; dx/dy. dx(abs:-32|rel:96) dy(abs:-192|rel:160)
; node # 8 D(78,-4)->(78,-1)
       fcb 2 ; drawmode 
       fcb -13,37 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-96|rel:96)
; node # 9 D(96,0)->(92,2)
       fcb 2 ; drawmode 
       fcb -4,18 ; starx/y relative to previous node
       fdb 32,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-64|rel:32)
; node # 10 D(110,2)->(108,4)
       fcb 2 ; drawmode 
       fcb -2,14 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:-64|rel:0)
; node # 11 D(78,11)->(78,11)
       fcb 2 ; drawmode 
       fcb -9,-32 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:0|rel:64)
; node # 12 D(40,23)->(38,20)
       fcb 2 ; drawmode 
       fcb -12,-38 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:96|rel:96)
; node # 13 D(0,29)->(0,25)
       fcb 2 ; drawmode 
       fcb -6,-40 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:0|rel:64) dy(abs:128|rel:32)
; node # 14 D(-32,25)->(-32,23)
       fcb 2 ; drawmode 
       fcb 4,-32 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:64|rel:-64)
; node # 15 D(-67,19)->(-67,17)
       fcb 2 ; drawmode 
       fcb 6,-35 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:64|rel:0)
; node # 16 D(-84,16)->(-85,15)
       fcb 2 ; drawmode 
       fcb 3,-17 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:32|rel:-32)
; node # 17 M(-43,23)->(-44,21)
       fcb 0 ; drawmode 
       fcb -7,41 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-32|rel:0) dy(abs:64|rel:32)
; node # 18 D(-49,13)->(-49,13)
       fcb 2 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:0|rel:-64)
; node # 19 D(-52,-2)->(-52,-2)
       fcb 2 ; drawmode 
       fcb 15,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-50,-10)->(-51,-7)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb -96,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-96|rel:-96)
; node # 21 D(-48,-16)->(-50,-8)
       fcb 2 ; drawmode 
       fcb 6,2 ; starx/y relative to previous node
       fdb -160,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:-256|rel:-160)
; node # 22 M(48,-14)->(49,-8)
       fcb 0 ; drawmode 
       fcb -2,96 ; starx/y relative to previous node
       fdb 64,96 ; dx/dy. dx(abs:32|rel:96) dy(abs:-192|rel:64)
; node # 23 D(50,-1)->(50,-1)
       fcb 2 ; drawmode 
       fcb -13,2 ; starx/y relative to previous node
       fdb 192,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:0|rel:192)
; node # 24 D(49,11)->(49,11)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(45,21)->(47,17)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb 128,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:128|rel:128)
; node # 26 M(-30,-12)->(-30,-12)
       fcb 0 ; drawmode 
       fcb 33,-75 ; starx/y relative to previous node
       fdb -128,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:0|rel:-128)
; node # 27 D(-23,-23)->(-30,-12)
       fcb 2 ; drawmode 
       fcb 11,7 ; starx/y relative to previous node
       fdb -352,-224 ; dx/dy. dx(abs:-224|rel:-224) dy(abs:-352|rel:-352)
; node # 28 M(23,-22)->(30,-12)
       fcb 0 ; drawmode 
       fcb -1,46 ; starx/y relative to previous node
       fdb 32,448 ; dx/dy. dx(abs:224|rel:448) dy(abs:-320|rel:32)
; node # 29 D(30,-12)->(30,-12)
       fcb 2 ; drawmode 
       fcb -10,7 ; starx/y relative to previous node
       fdb 320,-224 ; dx/dy. dx(abs:0|rel:-224) dy(abs:0|rel:320)
; node # 30 D(32,0)->(32,0)
       fcb 2 ; drawmode 
       fcb -12,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(30,11)->(30,11)
       fcb 2 ; drawmode 
       fcb -11,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(23,22)->(23,22)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(19,26)->(23,22)
       fcb 2 ; drawmode 
       fcb -4,-4 ; starx/y relative to previous node
       fdb 128,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:128|rel:128)
; node # 34 M(-18,27)->(-21,24)
       fcb 0 ; drawmode 
       fcb -1,-37 ; starx/y relative to previous node
       fdb -32,-224 ; dx/dy. dx(abs:-96|rel:-224) dy(abs:96|rel:-32)
; node # 35 D(-22,23)->(-22,23)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb -96,96 ; dx/dy. dx(abs:0|rel:96) dy(abs:0|rel:-96)
; node # 36 D(-30,12)->(-30,12)
       fcb 2 ; drawmode 
       fcb 11,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(-32,0)->(-32,0)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-30,-12)->(-30,-12)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 M(-84,-1)->(-79,1)
       fcb 0 ; drawmode 
       fcb -11,-54 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:160|rel:160) dy(abs:-64|rel:-64)
; node # 40 D(-88,-2)->(-84,0)
       fcb 2 ; drawmode 
       fcb 1,-4 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:128|rel:-32) dy(abs:-64|rel:0)
; node # 41 D(-95,-4)->(-93,-1)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:64|rel:-64) dy(abs:-96|rel:-32)
; node # 42 D(-107,-8)->(-102,-4)
       fcb 2 ; drawmode 
       fcb 4,-12 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:160|rel:96) dy(abs:-128|rel:-32)
; node # 43 M(-71,-14)->(-65,-8)
       fcb 0 ; drawmode 
       fcb 6,36 ; starx/y relative to previous node
       fdb -64,32 ; dx/dy. dx(abs:192|rel:32) dy(abs:-192|rel:-64)
; node # 44 D(-78,-16)->(-70,-10)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:256|rel:64) dy(abs:-192|rel:0)
; node # 45 D(-85,-18)->(-80,-14)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 64,-96 ; dx/dy. dx(abs:160|rel:-96) dy(abs:-128|rel:64)
; node # 46 D(-95,-23)->(-87,-18)
       fcb 2 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:256|rel:96) dy(abs:-160|rel:-32)
; node # 47 M(-58,-21)->(-54,-14)
       fcb 0 ; drawmode 
       fcb -2,37 ; starx/y relative to previous node
       fdb -64,-128 ; dx/dy. dx(abs:128|rel:-128) dy(abs:-224|rel:-64)
; node # 48 D(-63,-23)->(-60,-18)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb 64,-32 ; dx/dy. dx(abs:96|rel:-32) dy(abs:-160|rel:64)
; node # 49 D(-71,-27)->(-66,-23)
       fcb 2 ; drawmode 
       fcb 4,-8 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:160|rel:64) dy(abs:-128|rel:32)
; node # 50 D(-81,-34)->(-71,-28)
       fcb 2 ; drawmode 
       fcb 7,-10 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:320|rel:160) dy(abs:-192|rel:-64)
; node # 51 M(-44,-27)->(-40,-18)
       fcb 0 ; drawmode 
       fcb -7,37 ; starx/y relative to previous node
       fdb -96,-192 ; dx/dy. dx(abs:128|rel:-192) dy(abs:-288|rel:-96)
; node # 52 D(-50,-30)->(-45,-21)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:160|rel:32) dy(abs:-288|rel:0)
; node # 53 D(-57,-34)->(-51,-27)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:192|rel:32) dy(abs:-224|rel:64)
; node # 54 D(-65,-41)->(-56,-33)
       fcb 2 ; drawmode 
       fcb 7,-8 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:288|rel:96) dy(abs:-256|rel:-32)
; node # 55 M(-30,-30)->(-26,-21)
       fcb 0 ; drawmode 
       fcb -11,35 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:128|rel:-160) dy(abs:-288|rel:-32)
; node # 56 D(-35,-33)->(-33,-26)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:64|rel:-64) dy(abs:-224|rel:64)
; node # 57 D(-42,-41)->(-36,-31)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb -96,128 ; dx/dy. dx(abs:192|rel:128) dy(abs:-320|rel:-96)
; node # 58 D(-47,-47)->(-39,-38)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:256|rel:64) dy(abs:-288|rel:32)
; node # 59 M(-15,-33)->(-13,-23)
       fcb 0 ; drawmode 
       fcb -14,32 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:64|rel:-192) dy(abs:-320|rel:-32)
; node # 60 D(-19,-38)->(-16,-27)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:96|rel:32) dy(abs:-352|rel:-32)
; node # 61 D(-23,-44)->(-19,-35)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:128|rel:32) dy(abs:-288|rel:64)
; node # 62 D(-26,-53)->(-21,-41)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:160|rel:32) dy(abs:-384|rel:-96)
; node # 63 M(0,-36)->(-1,-23)
       fcb 0 ; drawmode 
       fcb -17,26 ; starx/y relative to previous node
       fdb -32,-192 ; dx/dy. dx(abs:-32|rel:-192) dy(abs:-416|rel:-32)
; node # 64 D(2,-43)->(0,-26)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb -128,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:-544|rel:-128)
; node # 65 D(2,-50)->(0,-31)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-64|rel:0) dy(abs:-608|rel:-64)
; node # 66 D(2,-57)->(1,-41)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-32|rel:32) dy(abs:-512|rel:96)
; node # 67 M(15,-35)->(13,-22)
       fcb 0 ; drawmode 
       fcb -22,13 ; starx/y relative to previous node
       fdb 96,-32 ; dx/dy. dx(abs:-64|rel:-32) dy(abs:-416|rel:96)
; node # 68 D(20,-38)->(16,-26)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:-384|rel:32)
; node # 69 D(24,-45)->(19,-32)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-160|rel:-32) dy(abs:-416|rel:-32)
; node # 70 D(28,-56)->(21,-38)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb -160,-64 ; dx/dy. dx(abs:-224|rel:-64) dy(abs:-576|rel:-160)
; node # 71 M(31,-30)->(26,-21)
       fcb 0 ; drawmode 
       fcb -26,3 ; starx/y relative to previous node
       fdb 288,64 ; dx/dy. dx(abs:-160|rel:64) dy(abs:-288|rel:288)
; node # 72 D(37,-34)->(30,-23)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-224|rel:-64) dy(abs:-352|rel:-64)
; node # 73 D(44,-42)->(34,-26)
       fcb 2 ; drawmode 
       fcb 8,7 ; starx/y relative to previous node
       fdb -160,-96 ; dx/dy. dx(abs:-320|rel:-96) dy(abs:-512|rel:-160)
; node # 74 D(50,-51)->(40,-33)
       fcb 2 ; drawmode 
       fcb 9,6 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:-576|rel:-64)
; node # 75 M(46,-23)->(43,-16)
       fcb 0 ; drawmode 
       fcb -28,-4 ; starx/y relative to previous node
       fdb 352,224 ; dx/dy. dx(abs:-96|rel:224) dy(abs:-224|rel:352)
; node # 76 D(54,-26)->(49,-18)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:-256|rel:-32)
; node # 77 D(61,-30)->(56,-23)
       fcb 2 ; drawmode 
       fcb 4,7 ; starx/y relative to previous node
       fdb 32,0 ; dx/dy. dx(abs:-160|rel:0) dy(abs:-224|rel:32)
; node # 78 D(72,-39)->(61,-28)
       fcb 2 ; drawmode 
       fcb 9,11 ; starx/y relative to previous node
       fdb -128,-192 ; dx/dy. dx(abs:-352|rel:-192) dy(abs:-352|rel:-128)
; node # 79 M(60,-16)->(58,-10)
       fcb 0 ; drawmode 
       fcb -23,-12 ; starx/y relative to previous node
       fdb 160,288 ; dx/dy. dx(abs:-64|rel:288) dy(abs:-192|rel:160)
; node # 80 D(69,-17)->(64,-12)
       fcb 2 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb 32,-96 ; dx/dy. dx(abs:-160|rel:-96) dy(abs:-160|rel:32)
; node # 81 D(77,-19)->(71,-15)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:-192|rel:-32) dy(abs:-128|rel:32)
; node # 82 D(87,-24)->(81,-19)
       fcb 2 ; drawmode 
       fcb 5,10 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:-160|rel:-32)
       fcb  1  ; end of anim
; Animation 3
augeframe3:
       fcb 8 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-85,15)->(-83,8)
       fcb 0 ; drawmode 
       fcb -15,-85 ; starx/y relative to previous node
       fdb 224,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:224|rel:224)
; node # 2 D(-82,12)->(-73,7)
       fcb 2 ; drawmode 
       fcb 3,3 ; starx/y relative to previous node
       fdb -64,224 ; dx/dy. dx(abs:288|rel:224) dy(abs:160|rel:-64)
; node # 3 D(-74,4)->(-63,7)
       fcb 2 ; drawmode 
       fcb 8,8 ; starx/y relative to previous node
       fdb -256,64 ; dx/dy. dx(abs:352|rel:64) dy(abs:-96|rel:-256)
; node # 4 D(-54,-7)->(-52,6)
       fcb 2 ; drawmode 
       fcb 11,20 ; starx/y relative to previous node
       fdb -320,-288 ; dx/dy. dx(abs:64|rel:-288) dy(abs:-416|rel:-320)
; node # 5 D(-35,-11)->(-34,8)
       fcb 2 ; drawmode 
       fcb 4,19 ; starx/y relative to previous node
       fdb -192,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-608|rel:-192)
; node # 6 D(1,-16)->(0,10)
       fcb 2 ; drawmode 
       fcb 5,36 ; starx/y relative to previous node
       fdb -224,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:-832|rel:-224)
; node # 7 D(40,-11)->(40,9)
       fcb 2 ; drawmode 
       fcb -5,39 ; starx/y relative to previous node
       fdb 192,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-640|rel:192)
; node # 8 D(78,-1)->(80,6)
       fcb 2 ; drawmode 
       fcb -10,38 ; starx/y relative to previous node
       fdb 416,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-224|rel:416)
; node # 9 D(92,2)->(92,5)
       fcb 2 ; drawmode 
       fcb -3,14 ; starx/y relative to previous node
       fdb 128,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:-96|rel:128)
; node # 10 D(108,4)->(108,4)
       fcb 2 ; drawmode 
       fcb -2,16 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:96)
; node # 11 D(78,11)->(77,6)
       fcb 2 ; drawmode 
       fcb -7,-30 ; starx/y relative to previous node
       fdb 160,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:160|rel:160)
; node # 12 D(38,20)->(38,9)
       fcb 2 ; drawmode 
       fcb -9,-40 ; starx/y relative to previous node
       fdb 192,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:352|rel:192)
; node # 13 D(0,25)->(0,10)
       fcb 2 ; drawmode 
       fcb -5,-38 ; starx/y relative to previous node
       fdb 128,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:128)
; node # 14 D(-32,23)->(-34,8)
       fcb 2 ; drawmode 
       fcb 2,-32 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:480|rel:0)
; node # 15 D(-67,17)->(-66,7)
       fcb 2 ; drawmode 
       fcb 6,-35 ; starx/y relative to previous node
       fdb -160,96 ; dx/dy. dx(abs:32|rel:96) dy(abs:320|rel:-160)
; node # 16 D(-85,15)->(-83,8)
       fcb 2 ; drawmode 
       fcb 2,-18 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:64|rel:32) dy(abs:224|rel:-96)
; node # 17 M(-44,21)->(-51,5)
       fcb 0 ; drawmode 
       fcb -6,41 ; starx/y relative to previous node
       fdb 288,-288 ; dx/dy. dx(abs:-224|rel:-288) dy(abs:512|rel:288)
; node # 18 D(-49,13)->(-51,5)
       fcb 2 ; drawmode 
       fcb 8,-5 ; starx/y relative to previous node
       fdb -256,160 ; dx/dy. dx(abs:-64|rel:160) dy(abs:256|rel:-256)
; node # 19 D(-52,-2)->(-51,5)
       fcb 2 ; drawmode 
       fcb 15,-3 ; starx/y relative to previous node
       fdb -480,96 ; dx/dy. dx(abs:32|rel:96) dy(abs:-224|rel:-480)
; node # 20 D(-51,-7)->(-51,5)
       fcb 2 ; drawmode 
       fcb 5,1 ; starx/y relative to previous node
       fdb -160,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-384|rel:-160)
; node # 21 D(-50,-8)->(-51,5)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-416|rel:-32)
; node # 22 M(49,-8)->(49,8)
       fcb 0 ; drawmode 
       fcb 0,99 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:-512|rel:-96)
; node # 23 D(50,-1)->(49,8)
       fcb 2 ; drawmode 
       fcb -7,1 ; starx/y relative to previous node
       fdb 224,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-288|rel:224)
; node # 24 D(49,11)->(49,8)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb 384,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:96|rel:384)
; node # 25 D(47,17)->(49,8)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb 192,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:288|rel:192)
; node # 26 M(-30,-12)->(-30,-12)
       fcb 0 ; drawmode 
       fcb 29,-77 ; starx/y relative to previous node
       fdb -288,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:0|rel:-288)
; node # 27 D(-30,-12)->(-30,-12)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(30,-12)->(31,9)
       fcb 0 ; drawmode 
       fcb 0,60 ; starx/y relative to previous node
       fdb -672,32 ; dx/dy. dx(abs:32|rel:32) dy(abs:-672|rel:-672)
; node # 29 D(30,-12)->(31,9)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-672|rel:0)
; node # 30 D(32,0)->(31,9)
       fcb 2 ; drawmode 
       fcb -12,2 ; starx/y relative to previous node
       fdb 384,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:-288|rel:384)
; node # 31 D(30,11)->(31,9)
       fcb 2 ; drawmode 
       fcb -11,-2 ; starx/y relative to previous node
       fdb 352,64 ; dx/dy. dx(abs:32|rel:64) dy(abs:64|rel:352)
; node # 32 D(23,22)->(31,9)
       fcb 2 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 352,224 ; dx/dy. dx(abs:256|rel:224) dy(abs:416|rel:352)
; node # 33 D(23,22)->(31,9)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:416|rel:0)
; node # 34 M(-21,24)->(-31,7)
       fcb 0 ; drawmode 
       fcb -2,-44 ; starx/y relative to previous node
       fdb 128,-576 ; dx/dy. dx(abs:-320|rel:-576) dy(abs:544|rel:128)
; node # 35 D(-22,23)->(-31,7)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:-288|rel:32) dy(abs:512|rel:-32)
; node # 36 D(-30,12)->(-31,7)
       fcb 2 ; drawmode 
       fcb 11,-8 ; starx/y relative to previous node
       fdb -352,256 ; dx/dy. dx(abs:-32|rel:256) dy(abs:160|rel:-352)
; node # 37 D(-32,0)->(-31,7)
       fcb 2 ; drawmode 
       fcb 12,-2 ; starx/y relative to previous node
       fdb -384,64 ; dx/dy. dx(abs:32|rel:64) dy(abs:-224|rel:-384)
; node # 38 D(-30,-12)->(-31,7)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb -384,-64 ; dx/dy. dx(abs:-32|rel:-64) dy(abs:-608|rel:-384)
; node # 39 M(-79,1)->(-75,4)
       fcb 0 ; drawmode 
       fcb -13,-49 ; starx/y relative to previous node
       fdb 512,160 ; dx/dy. dx(abs:128|rel:160) dy(abs:-96|rel:512)
; node # 40 D(-84,0)->(-79,2)
       fcb 2 ; drawmode 
       fcb 1,-5 ; starx/y relative to previous node
       fdb 32,32 ; dx/dy. dx(abs:160|rel:32) dy(abs:-64|rel:32)
; node # 41 D(-93,-1)->(-86,-2)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 96,64 ; dx/dy. dx(abs:224|rel:64) dy(abs:32|rel:96)
; node # 42 D(-102,-4)->(-91,-6)
       fcb 2 ; drawmode 
       fcb 3,-9 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:352|rel:128) dy(abs:64|rel:32)
; node # 43 M(-65,-8)->(-63,1)
       fcb 0 ; drawmode 
       fcb 4,37 ; starx/y relative to previous node
       fdb -352,-288 ; dx/dy. dx(abs:64|rel:-288) dy(abs:-288|rel:-352)
; node # 44 D(-70,-10)->(-67,0)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb -32,32 ; dx/dy. dx(abs:96|rel:32) dy(abs:-320|rel:-32)
; node # 45 D(-80,-14)->(-73,-5)
       fcb 2 ; drawmode 
       fcb 4,-10 ; starx/y relative to previous node
       fdb 32,128 ; dx/dy. dx(abs:224|rel:128) dy(abs:-288|rel:32)
; node # 46 D(-87,-18)->(-78,-10)
       fcb 2 ; drawmode 
       fcb 4,-7 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:288|rel:64) dy(abs:-256|rel:32)
; node # 47 M(-54,-14)->(-52,0)
       fcb 0 ; drawmode 
       fcb -4,33 ; starx/y relative to previous node
       fdb -192,-224 ; dx/dy. dx(abs:64|rel:-224) dy(abs:-448|rel:-192)
; node # 48 D(-60,-18)->(-54,-2)
       fcb 2 ; drawmode 
       fcb 4,-6 ; starx/y relative to previous node
       fdb -64,128 ; dx/dy. dx(abs:192|rel:128) dy(abs:-512|rel:-64)
; node # 49 D(-66,-23)->(-59,-7)
       fcb 2 ; drawmode 
       fcb 5,-6 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:224|rel:32) dy(abs:-512|rel:0)
; node # 50 D(-71,-28)->(-62,-13)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 32,64 ; dx/dy. dx(abs:288|rel:64) dy(abs:-480|rel:32)
; node # 51 M(-40,-18)->(-38,0)
       fcb 0 ; drawmode 
       fcb -10,31 ; starx/y relative to previous node
       fdb -96,-224 ; dx/dy. dx(abs:64|rel:-224) dy(abs:-576|rel:-96)
; node # 52 D(-45,-21)->(-40,-2)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb -32,96 ; dx/dy. dx(abs:160|rel:96) dy(abs:-608|rel:-32)
; node # 53 D(-51,-27)->(-43,-6)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb -64,96 ; dx/dy. dx(abs:256|rel:96) dy(abs:-672|rel:-64)
; node # 54 D(-56,-33)->(-47,-14)
       fcb 2 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 64,32 ; dx/dy. dx(abs:288|rel:32) dy(abs:-608|rel:64)
; node # 55 M(-26,-21)->(-25,-1)
       fcb 0 ; drawmode 
       fcb -12,30 ; starx/y relative to previous node
       fdb -32,-256 ; dx/dy. dx(abs:32|rel:-256) dy(abs:-640|rel:-32)
; node # 56 D(-33,-26)->(-27,-4)
       fcb 2 ; drawmode 
       fcb 5,-7 ; starx/y relative to previous node
       fdb -64,160 ; dx/dy. dx(abs:192|rel:160) dy(abs:-704|rel:-64)
; node # 57 D(-36,-31)->(-30,-12)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb 96,0 ; dx/dy. dx(abs:192|rel:0) dy(abs:-608|rel:96)
; node # 58 D(-39,-38)->(-32,-16)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:224|rel:32) dy(abs:-704|rel:-96)
; node # 59 M(-13,-23)->(-11,0)
       fcb 0 ; drawmode 
       fcb -15,26 ; starx/y relative to previous node
       fdb -32,-160 ; dx/dy. dx(abs:64|rel:-160) dy(abs:-736|rel:-32)
; node # 60 D(-16,-27)->(-12,-2)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb -64,64 ; dx/dy. dx(abs:128|rel:64) dy(abs:-800|rel:-64)
; node # 61 D(-19,-35)->(-14,-7)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:160|rel:32) dy(abs:-896|rel:-96)
; node # 62 D(-21,-41)->(-16,-18)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb 160,0 ; dx/dy. dx(abs:160|rel:0) dy(abs:-736|rel:160)
; node # 63 M(-1,-23)->(0,0)
       fcb 0 ; drawmode 
       fcb -18,20 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:32|rel:-128) dy(abs:-736|rel:0)
; node # 64 D(0,-26)->(0,-4)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-704|rel:32)
; node # 65 D(0,-31)->(0,-9)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-704|rel:0)
; node # 66 D(1,-41)->(0,-19)
       fcb 2 ; drawmode 
       fcb 10,1 ; starx/y relative to previous node
       fdb 0,-32 ; dx/dy. dx(abs:-32|rel:-32) dy(abs:-704|rel:0)
; node # 67 M(13,-22)->(10,0)
       fcb 0 ; drawmode 
       fcb -19,12 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-96|rel:-64) dy(abs:-704|rel:0)
; node # 68 D(16,-26)->(11,-2)
       fcb 2 ; drawmode 
       fcb 4,3 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-160|rel:-64) dy(abs:-768|rel:-64)
; node # 69 D(19,-32)->(12,-6)
       fcb 2 ; drawmode 
       fcb 6,3 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:-224|rel:-64) dy(abs:-832|rel:-64)
; node # 70 D(21,-38)->(14,-17)
       fcb 2 ; drawmode 
       fcb 6,2 ; starx/y relative to previous node
       fdb 160,0 ; dx/dy. dx(abs:-224|rel:0) dy(abs:-672|rel:160)
; node # 71 M(26,-21)->(23,0)
       fcb 0 ; drawmode 
       fcb -17,5 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:-96|rel:128) dy(abs:-672|rel:0)
; node # 72 D(30,-23)->(24,-2)
       fcb 2 ; drawmode 
       fcb 2,4 ; starx/y relative to previous node
       fdb 0,-96 ; dx/dy. dx(abs:-192|rel:-96) dy(abs:-672|rel:0)
; node # 73 D(34,-26)->(26,-8)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 96,-64 ; dx/dy. dx(abs:-256|rel:-64) dy(abs:-576|rel:96)
; node # 74 D(40,-33)->(28,-17)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-384|rel:-128) dy(abs:-512|rel:64)
; node # 75 M(43,-16)->(37,0)
       fcb 0 ; drawmode 
       fcb -17,3 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:-192|rel:192) dy(abs:-512|rel:0)
; node # 76 D(49,-18)->(41,-3)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb 32,-64 ; dx/dy. dx(abs:-256|rel:-64) dy(abs:-480|rel:32)
; node # 77 D(56,-23)->(45,-7)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-352|rel:-96) dy(abs:-512|rel:-32)
; node # 78 D(61,-28)->(50,-14)
       fcb 2 ; drawmode 
       fcb 5,5 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-352|rel:0) dy(abs:-448|rel:64)
; node # 79 M(58,-10)->(53,0)
       fcb 0 ; drawmode 
       fcb -18,-3 ; starx/y relative to previous node
       fdb 128,192 ; dx/dy. dx(abs:-160|rel:192) dy(abs:-320|rel:128)
; node # 80 D(64,-12)->(57,-1)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb -32,-64 ; dx/dy. dx(abs:-224|rel:-64) dy(abs:-352|rel:-32)
; node # 81 D(71,-15)->(63,-3)
       fcb 2 ; drawmode 
       fcb 3,7 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:-256|rel:-32) dy(abs:-384|rel:-32)
; node # 82 D(81,-19)->(69,-9)
       fcb 2 ; drawmode 
       fcb 4,10 ; starx/y relative to previous node
       fdb 64,-128 ; dx/dy. dx(abs:-384|rel:-128) dy(abs:-320|rel:64)
       fcb  1  ; end of anim
