discoframecount EQU 1 ; number of animations
discoframetotal EQU 64 ; total number of frames in animation 
; index table 
discoframetab        fdb discoframe0

; Animation 0
discoframe0:
       fcb 64 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(1,-30)->(8,-30)
       fcb 0 ; drawmode 
       fcb 30,1 ; starx/y relative to previous node
       fdb 0,28 ; dx/dy. dx(abs:28|rel:28) dy(abs:0|rel:0)
; node # 1 D(-18,0)->(-28,7)
       fcb 2 ; drawmode 
       fcb -30,-19 ; starx/y relative to previous node
       fdb -28,-68 ; dx/dy. dx(abs:-40|rel:-68) dy(abs:-28|rel:-28)
; node # 2 D(-39,54)->(-39,46)
       fcb 2 ; drawmode 
       fcb -54,-21 ; starx/y relative to previous node
       fdb 60,40 ; dx/dy. dx(abs:0|rel:40) dy(abs:32|rel:60)
; node # 3 D(-27,55)->(-29,51)
       fcb 2 ; drawmode 
       fcb -1,12 ; starx/y relative to previous node
       fdb -16,-8 ; dx/dy. dx(abs:-8|rel:-8) dy(abs:16|rel:-16)
; node # 4 D(-46,63)->(-46,55)
       fcb 2 ; drawmode 
       fcb -8,-19 ; starx/y relative to previous node
       fdb 16,8 ; dx/dy. dx(abs:0|rel:8) dy(abs:32|rel:16)
; node # 5 D(-52,71)->(-49,65)
       fcb 2 ; drawmode 
       fcb -8,-6 ; starx/y relative to previous node
       fdb -8,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:24|rel:-8)
; node # 6 D(5,68)->(-6,71)
       fcb 2 ; drawmode 
       fcb 3,57 ; starx/y relative to previous node
       fdb -36,-56 ; dx/dy. dx(abs:-44|rel:-56) dy(abs:-12|rel:-36)
; node # 7 D(3,61)->(-3,61)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb 12,20 ; dx/dy. dx(abs:-24|rel:20) dy(abs:0|rel:12)
; node # 8 D(8,18)->(1,13)
       fcb 2 ; drawmode 
       fcb 43,5 ; starx/y relative to previous node
       fdb 20,-4 ; dx/dy. dx(abs:-28|rel:-4) dy(abs:20|rel:20)
; node # 9 D(23,-10)->(24,-4)
       fcb 2 ; drawmode 
       fcb 28,15 ; starx/y relative to previous node
       fdb -44,32 ; dx/dy. dx(abs:4|rel:32) dy(abs:-24|rel:-44)
; node # 10 D(54,14)->(39,15)
       fcb 2 ; drawmode 
       fcb -24,31 ; starx/y relative to previous node
       fdb 20,-64 ; dx/dy. dx(abs:-60|rel:-64) dy(abs:-4|rel:20)
; node # 11 D(74,52)->(67,63)
       fcb 2 ; drawmode 
       fcb -38,20 ; starx/y relative to previous node
       fdb -40,32 ; dx/dy. dx(abs:-28|rel:32) dy(abs:-44|rel:-40)
; node # 12 D(76,63)->(59,75)
       fcb 2 ; drawmode 
       fcb -11,2 ; starx/y relative to previous node
       fdb -4,-40 ; dx/dy. dx(abs:-68|rel:-40) dy(abs:-48|rel:-4)
; node # 13 D(107,58)->(111,85)
       fcb 2 ; drawmode 
       fcb 5,31 ; starx/y relative to previous node
       fdb -60,84 ; dx/dy. dx(abs:16|rel:84) dy(abs:-108|rel:-60)
; node # 14 D(97,50)->(102,70)
       fcb 2 ; drawmode 
       fcb 8,-10 ; starx/y relative to previous node
       fdb 28,4 ; dx/dy. dx(abs:20|rel:4) dy(abs:-80|rel:28)
; node # 15 D(84,49)->(82,64)
       fcb 2 ; drawmode 
       fcb 1,-13 ; starx/y relative to previous node
       fdb 20,-28 ; dx/dy. dx(abs:-8|rel:-28) dy(abs:-60|rel:20)
; node # 16 D(93,46)->(92,62)
       fcb 2 ; drawmode 
       fcb 3,9 ; starx/y relative to previous node
       fdb -4,4 ; dx/dy. dx(abs:-4|rel:4) dy(abs:-64|rel:-4)
; node # 17 D(74,0)->(62,10)
       fcb 2 ; drawmode 
       fcb 46,-19 ; starx/y relative to previous node
       fdb 24,-44 ; dx/dy. dx(abs:-48|rel:-44) dy(abs:-40|rel:24)
; node # 18 D(43,-29)->(45,-31)
       fcb 2 ; drawmode 
       fcb 29,-31 ; starx/y relative to previous node
       fdb 48,56 ; dx/dy. dx(abs:8|rel:56) dy(abs:8|rel:48)
; node # 19 D(0,-31)->(8,-30)
       fcb 2 ; drawmode 
       fcb 2,-43 ; starx/y relative to previous node
       fdb -12,24 ; dx/dy. dx(abs:32|rel:24) dy(abs:-4|rel:-12)
; node # 20 M(1,-31)->(9,-30)
       fcb 0 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:32|rel:0) dy(abs:-4|rel:0)
; node # 21 D(-13,-50)->(-7,-50)
       fcb 2 ; drawmode 
       fcb 19,-14 ; starx/y relative to previous node
       fdb 4,-8 ; dx/dy. dx(abs:24|rel:-8) dy(abs:0|rel:4)
; node # 22 D(-3,-76)->(-5,-79)
       fcb 2 ; drawmode 
       fcb 26,10 ; starx/y relative to previous node
       fdb 12,-32 ; dx/dy. dx(abs:-8|rel:-32) dy(abs:12|rel:12)
; node # 23 D(-33,-89)->(-35,-55)
       fcb 2 ; drawmode 
       fcb 13,-30 ; starx/y relative to previous node
       fdb -148,0 ; dx/dy. dx(abs:-8|rel:0) dy(abs:-136|rel:-148)
; node # 24 D(-52,-111)->(-70,-57)
       fcb 2 ; drawmode 
       fcb 22,-19 ; starx/y relative to previous node
       fdb -80,-64 ; dx/dy. dx(abs:-72|rel:-64) dy(abs:-216|rel:-80)
; node # 25 D(-42,-114)->(-76,-51)
       fcb 2 ; drawmode 
       fcb 3,10 ; starx/y relative to previous node
       fdb -36,-64 ; dx/dy. dx(abs:-136|rel:-64) dy(abs:-252|rel:-36)
; node # 26 D(-47,-124)->(-85,-50)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb -44,-16 ; dx/dy. dx(abs:-152|rel:-16) dy(abs:-296|rel:-44)
; node # 27 D(-38,-128)->(-89,-58)
       fcb 2 ; drawmode 
       fcb 4,9 ; starx/y relative to previous node
       fdb 16,-52 ; dx/dy. dx(abs:-204|rel:-52) dy(abs:-280|rel:16)
; node # 28 D(-36,-121)->(-78,-62)
       fcb 2 ; drawmode 
       fcb -7,2 ; starx/y relative to previous node
       fdb 44,36 ; dx/dy. dx(abs:-168|rel:36) dy(abs:-236|rel:44)
; node # 29 D(-29,-112)->(-80,-69)
       fcb 2 ; drawmode 
       fcb -9,7 ; starx/y relative to previous node
       fdb 64,-36 ; dx/dy. dx(abs:-204|rel:-36) dy(abs:-172|rel:64)
; node # 30 D(-23,-93)->(-35,-71)
       fcb 2 ; drawmode 
       fcb -19,6 ; starx/y relative to previous node
       fdb 84,156 ; dx/dy. dx(abs:-48|rel:156) dy(abs:-88|rel:84)
; node # 31 D(-4,-87)->(-2,-90)
       fcb 2 ; drawmode 
       fcb -6,19 ; starx/y relative to previous node
       fdb 100,56 ; dx/dy. dx(abs:8|rel:56) dy(abs:12|rel:100)
; node # 32 D(15,-83)->(15,-87)
       fcb 2 ; drawmode 
       fcb -4,19 ; starx/y relative to previous node
       fdb 4,-8 ; dx/dy. dx(abs:0|rel:-8) dy(abs:16|rel:4)
; node # 33 D(27,-64)->(22,-60)
       fcb 2 ; drawmode 
       fcb -19,12 ; starx/y relative to previous node
       fdb -32,-20 ; dx/dy. dx(abs:-20|rel:-20) dy(abs:-16|rel:-32)
; node # 34 D(29,-84)->(31,-87)
       fcb 2 ; drawmode 
       fcb 20,2 ; starx/y relative to previous node
       fdb 28,28 ; dx/dy. dx(abs:8|rel:28) dy(abs:12|rel:28)
; node # 35 D(43,-83)->(43,-85)
       fcb 2 ; drawmode 
       fcb -1,14 ; starx/y relative to previous node
       fdb -4,-8 ; dx/dy. dx(abs:0|rel:-8) dy(abs:8|rel:-4)
; node # 36 D(77,-72)->(80,-97)
       fcb 2 ; drawmode 
       fcb -11,34 ; starx/y relative to previous node
       fdb 92,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:100|rel:92)
; node # 37 D(97,-78)->(88,-117)
       fcb 2 ; drawmode 
       fcb 6,20 ; starx/y relative to previous node
       fdb 56,-48 ; dx/dy. dx(abs:-36|rel:-48) dy(abs:156|rel:56)
; node # 38 D(103,-73)->(94,-115)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:168|rel:12)
; node # 39 D(115,-76)->(97,-126)
       fcb 2 ; drawmode 
       fcb 3,12 ; starx/y relative to previous node
       fdb 32,-36 ; dx/dy. dx(abs:-72|rel:-36) dy(abs:200|rel:32)
; node # 40 D(118,-65)->(108,-126)
       fcb 2 ; drawmode 
       fcb -11,3 ; starx/y relative to previous node
       fdb 44,32 ; dx/dy. dx(abs:-40|rel:32) dy(abs:244|rel:44)
; node # 41 D(103,-65)->(101,-113)
       fcb 2 ; drawmode 
       fcb 0,-15 ; starx/y relative to previous node
       fdb -52,32 ; dx/dy. dx(abs:-8|rel:32) dy(abs:192|rel:-52)
; node # 42 D(106,-57)->(110,-110)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb 20,24 ; dx/dy. dx(abs:16|rel:24) dy(abs:212|rel:20)
; node # 43 D(80,-55)->(88,-90)
       fcb 2 ; drawmode 
       fcb -2,-26 ; starx/y relative to previous node
       fdb -72,16 ; dx/dy. dx(abs:32|rel:16) dy(abs:140|rel:-72)
; node # 44 D(49,-72)->(54,-71)
       fcb 2 ; drawmode 
       fcb 17,-31 ; starx/y relative to previous node
       fdb -144,-12 ; dx/dy. dx(abs:20|rel:-12) dy(abs:-4|rel:-144)
; node # 45 D(51,-49)->(56,-49)
       fcb 2 ; drawmode 
       fcb -23,2 ; starx/y relative to previous node
       fdb 4,0 ; dx/dy. dx(abs:20|rel:0) dy(abs:0|rel:4)
; node # 46 D(42,-30)->(45,-31)
       fcb 2 ; drawmode 
       fcb -19,-9 ; starx/y relative to previous node
       fdb 4,-8 ; dx/dy. dx(abs:12|rel:-8) dy(abs:4|rel:4)
; node # 47 M(28,-84)->(30,-87)
       fcb 0 ; drawmode 
       fcb 54,-14 ; starx/y relative to previous node
       fdb 8,-4 ; dx/dy. dx(abs:8|rel:-4) dy(abs:12|rel:8)
; node # 48 D(38,-98)->(40,-98)
       fcb 2 ; drawmode 
       fcb 14,10 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:8|rel:0) dy(abs:0|rel:-12)
; node # 49 D(37,-110)->(41,-110)
       fcb 2 ; drawmode 
       fcb 12,-1 ; starx/y relative to previous node
       fdb 0,8 ; dx/dy. dx(abs:16|rel:8) dy(abs:0|rel:0)
; node # 50 D(29,-116)->(34,-117)
       fcb 2 ; drawmode 
       fcb 6,-8 ; starx/y relative to previous node
       fdb 4,4 ; dx/dy. dx(abs:20|rel:4) dy(abs:4|rel:4)
; node # 51 D(14,-113)->(21,-115)
       fcb 2 ; drawmode 
       fcb -3,-15 ; starx/y relative to previous node
       fdb 4,8 ; dx/dy. dx(abs:28|rel:8) dy(abs:8|rel:4)
; node # 52 D(8,-104)->(10,-110)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 16,-20 ; dx/dy. dx(abs:8|rel:-20) dy(abs:24|rel:16)
; node # 53 D(10,-95)->(10,-103)
       fcb 2 ; drawmode 
       fcb -9,2 ; starx/y relative to previous node
       fdb 8,-8 ; dx/dy. dx(abs:0|rel:-8) dy(abs:32|rel:8)
; node # 54 D(16,-99)->(16,-99)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb -32,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-32)
; node # 55 D(17,-107)->(17,-109)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 8,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:8|rel:8)
; node # 56 D(34,-107)->(33,-110)
       fcb 2 ; drawmode 
       fcb 0,17 ; starx/y relative to previous node
       fdb 4,-4 ; dx/dy. dx(abs:-4|rel:-4) dy(abs:12|rel:4)
; node # 57 D(33,-98)->(33,-102)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 4,4 ; dx/dy. dx(abs:0|rel:4) dy(abs:16|rel:4)
       fcb  1  ; end of anim
