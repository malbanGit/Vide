dudelframecount equ 18 ; number of animations
dudelframetotal equ 360 ; total number of frames in animation 
; index table 
dudelframetab        fdb dudelframe0
       fdb dudelframe1
       fdb dudelframe2
       fdb dudelframe3
       fdb dudelframe4
       fdb dudelframe5
       fdb dudelframe6
       fdb dudelframe7
       fdb dudelframe8
       fdb dudelframe9
       fdb dudelframe10
       fdb dudelframe11
       fdb dudelframe12
       fdb dudelframe13
       fdb dudelframe14
       fdb dudelframe15
       fdb dudelframe16
       fdb dudelframe17

; Animation 0
dudelframe0:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-11,-28)->(-11,-6)
       fcb 0 ; drawmode 
       fcb 28,-11 ; starx/y relative to previous node
       fdb -281,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-281|rel:-281)
; node # 1 D(31,-14)->(31,5)
       fcb 2 ; drawmode 
       fcb -14,42 ; starx/y relative to previous node
       fdb 38,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-243|rel:38)
; node # 2 D(32,32)->(33,48)
       fcb 2 ; drawmode 
       fcb -46,1 ; starx/y relative to previous node
       fdb 39,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-204|rel:39)
; node # 3 D(-12,47)->(-12,62)
       fcb 2 ; drawmode 
       fcb -15,-44 ; starx/y relative to previous node
       fdb 12,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-192|rel:12)
; node # 4 D(-40,9)->(-40,26)
       fcb 2 ; drawmode 
       fcb 38,-28 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-217|rel:-25)
; node # 5 D(-11,-28)->(-11,-6)
       fcb 2 ; drawmode 
       fcb 37,29 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-281|rel:-64)
; node # 6 D(-22,-63)->(-20,-48)
       fcb 2 ; drawmode 
       fcb 35,-11 ; starx/y relative to previous node
       fdb 89,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-192|rel:89)
; node # 7 D(22,-72)->(20,-64)
       fcb 2 ; drawmode 
       fcb 9,44 ; starx/y relative to previous node
       fdb 90,-50 ; dx/dy. dx(abs:-25|rel:-50) dy(abs:-102|rel:90)
; node # 8 D(15,-62)->(14,-74)
       fcb 2 ; drawmode 
       fcb -10,-7 ; starx/y relative to previous node
       fdb 255,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:153|rel:255)
; node # 9 D(54,-12)->(53,-35)
       fcb 2 ; drawmode 
       fcb -50,39 ; starx/y relative to previous node
       fdb 141,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:294|rel:141)
; node # 10 D(16,39)->(16,9)
       fcb 2 ; drawmode 
       fcb -51,-38 ; starx/y relative to previous node
       fdb 90,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:384|rel:90)
; node # 11 D(-44,19)->(-44,-8)
       fcb 2 ; drawmode 
       fcb 20,-60 ; starx/y relative to previous node
       fdb -39,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:345|rel:-39)
; node # 12 D(-43,-43)->(-41,-59)
       fcb 2 ; drawmode 
       fcb 62,1 ; starx/y relative to previous node
       fdb -141,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:204|rel:-141)
; node # 13 D(-61,-46)->(-58,-43)
       fcb 2 ; drawmode 
       fcb 3,-18 ; starx/y relative to previous node
       fdb -242,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:-38|rel:-242)
; node # 14 D(-72,2)->(-73,6)
       fcb 2 ; drawmode 
       fcb -48,-11 ; starx/y relative to previous node
       fdb -13,-50 ; dx/dy. dx(abs:-12|rel:-50) dy(abs:-51|rel:-13)
; node # 15 D(-64,42)->(-66,33)
       fcb 2 ; drawmode 
       fcb -40,8 ; starx/y relative to previous node
       fdb 166,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:115|rel:166)
; node # 16 D(-22,71)->(-24,72)
       fcb 2 ; drawmode 
       fcb -29,42 ; starx/y relative to previous node
       fdb -127,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-12|rel:-127)
; node # 17 D(24,72)->(25,62)
       fcb 2 ; drawmode 
       fcb -1,46 ; starx/y relative to previous node
       fdb 140,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:128|rel:140)
; node # 18 D(58,44)->(61,45)
       fcb 2 ; drawmode 
       fcb 28,34 ; starx/y relative to previous node
       fdb -140,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:-12|rel:-140)
; node # 19 D(76,-2)->(76,-7)
       fcb 2 ; drawmode 
       fcb 46,18 ; starx/y relative to previous node
       fdb 76,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:64|rel:76)
; node # 20 D(56,-39)->(54,-28)
       fcb 2 ; drawmode 
       fcb 37,-20 ; starx/y relative to previous node
       fdb -204,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-140|rel:-204)
; node # 21 D(22,-72)->(20,-64)
       fcb 2 ; drawmode 
       fcb 33,-34 ; starx/y relative to previous node
       fdb 38,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-102|rel:38)
; node # 22 M(15,-62)->(14,-74)
       fcb 0 ; drawmode 
       fcb -10,-7 ; starx/y relative to previous node
       fdb 255,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:153|rel:255)
; node # 23 D(-43,-43)->(-41,-59)
       fcb 2 ; drawmode 
       fcb -19,-58 ; starx/y relative to previous node
       fdb 51,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:204|rel:51)
; node # 24 M(-22,-63)->(-20,-48)
       fcb 0 ; drawmode 
       fcb 20,21 ; starx/y relative to previous node
       fdb -396,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-192|rel:-396)
; node # 25 D(-61,-46)->(-58,-43)
       fcb 2 ; drawmode 
       fcb -17,-39 ; starx/y relative to previous node
       fdb 154,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:-38|rel:154)
; node # 26 M(-44,19)->(-44,-8)
       fcb 0 ; drawmode 
       fcb -65,17 ; starx/y relative to previous node
       fdb 383,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:345|rel:383)
; node # 27 D(-64,42)->(-66,33)
       fcb 2 ; drawmode 
       fcb -23,-20 ; starx/y relative to previous node
       fdb -230,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:115|rel:-230)
; node # 28 M(-40,9)->(-40,26)
       fcb 0 ; drawmode 
       fcb 33,24 ; starx/y relative to previous node
       fdb -332,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-217|rel:-332)
; node # 29 D(-72,2)->(-73,5)
       fcb 2 ; drawmode 
       fcb 7,-32 ; starx/y relative to previous node
       fdb 179,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-38|rel:179)
; node # 30 M(-22,71)->(-24,72)
       fcb 0 ; drawmode 
       fcb -69,50 ; starx/y relative to previous node
       fdb 26,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-12|rel:26)
; node # 31 D(-12,47)->(-12,62)
       fcb 2 ; drawmode 
       fcb 24,10 ; starx/y relative to previous node
       fdb -180,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-192|rel:-180)
; node # 32 M(24,72)->(25,62)
       fcb 0 ; drawmode 
       fcb -25,36 ; starx/y relative to previous node
       fdb 320,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:128|rel:320)
; node # 33 D(16,39)->(16,9)
       fcb 2 ; drawmode 
       fcb 33,-8 ; starx/y relative to previous node
       fdb 256,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:384|rel:256)
; node # 34 M(58,44)->(61,45)
       fcb 0 ; drawmode 
       fcb -5,42 ; starx/y relative to previous node
       fdb -396,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:-12|rel:-396)
; node # 35 D(31,32)->(33,48)
       fcb 2 ; drawmode 
       fcb 12,-27 ; starx/y relative to previous node
       fdb -192,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:-204|rel:-192)
; node # 36 M(76,-2)->(76,-7)
       fcb 0 ; drawmode 
       fcb 34,45 ; starx/y relative to previous node
       fdb 268,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:64|rel:268)
; node # 37 D(54,-12)->(53,-35)
       fcb 2 ; drawmode 
       fcb 10,-22 ; starx/y relative to previous node
       fdb 230,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:294|rel:230)
; node # 38 M(56,-39)->(54,-28)
       fcb 0 ; drawmode 
       fcb 27,2 ; starx/y relative to previous node
       fdb -434,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-140|rel:-434)
; node # 39 D(31,-14)->(31,5)
       fcb 2 ; drawmode 
       fcb -25,-25 ; starx/y relative to previous node
       fdb -103,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-243|rel:-103)
       fcb  1  ; end of anim
; Animation 1
dudelframe1:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-11,-6)->(-11,15)
       fcb 0 ; drawmode 
       fcb 6,-11 ; starx/y relative to previous node
       fdb -268,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:-268)
; node # 1 D(31,5)->(31,24)
       fcb 2 ; drawmode 
       fcb -11,42 ; starx/y relative to previous node
       fdb 25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-243|rel:25)
; node # 2 D(33,48)->(35,60)
       fcb 2 ; drawmode 
       fcb -43,2 ; starx/y relative to previous node
       fdb 90,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-153|rel:90)
; node # 3 D(-12,62)->(-13,73)
       fcb 2 ; drawmode 
       fcb -14,-45 ; starx/y relative to previous node
       fdb 13,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:-140|rel:13)
; node # 4 D(-40,26)->(-41,41)
       fcb 2 ; drawmode 
       fcb 36,-28 ; starx/y relative to previous node
       fdb -52,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-192|rel:-52)
; node # 5 D(-11,-6)->(-11,15)
       fcb 2 ; drawmode 
       fcb 32,29 ; starx/y relative to previous node
       fdb -76,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-268|rel:-76)
; node # 6 D(-20,-48)->(-19,-30)
       fcb 2 ; drawmode 
       fcb 42,-9 ; starx/y relative to previous node
       fdb 38,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-230|rel:38)
; node # 7 D(20,-64)->(20,-50)
       fcb 2 ; drawmode 
       fcb 16,40 ; starx/y relative to previous node
       fdb 51,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-179|rel:51)
; node # 8 D(14,-74)->(13,-75)
       fcb 2 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb 191,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:12|rel:191)
; node # 9 D(53,-35)->(50,-52)
       fcb 2 ; drawmode 
       fcb -39,39 ; starx/y relative to previous node
       fdb 205,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:217|rel:205)
; node # 10 D(16,9)->(16,-23)
       fcb 2 ; drawmode 
       fcb -44,-37 ; starx/y relative to previous node
       fdb 192,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:409|rel:192)
; node # 11 D(-44,-8)->(-44,-34)
       fcb 2 ; drawmode 
       fcb 17,-60 ; starx/y relative to previous node
       fdb -77,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:332|rel:-77)
; node # 12 D(-41,-59)->(-39,-67)
       fcb 2 ; drawmode 
       fcb 51,3 ; starx/y relative to previous node
       fdb -230,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:102|rel:-230)
; node # 13 D(-58,-43)->(-56,-36)
       fcb 2 ; drawmode 
       fcb -16,-17 ; starx/y relative to previous node
       fdb -191,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-89|rel:-191)
; node # 14 D(-73,6)->(-73,9)
       fcb 2 ; drawmode 
       fcb -49,-15 ; starx/y relative to previous node
       fdb 51,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-38|rel:51)
; node # 15 D(-66,33)->(-68,19)
       fcb 2 ; drawmode 
       fcb -27,7 ; starx/y relative to previous node
       fdb 217,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:179|rel:217)
; node # 16 D(-24,72)->(-26,63)
       fcb 2 ; drawmode 
       fcb -39,42 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:115|rel:-64)
; node # 17 D(25,62)->(26,41)
       fcb 2 ; drawmode 
       fcb 10,49 ; starx/y relative to previous node
       fdb 153,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:268|rel:153)
; node # 18 D(61,45)->(64,40)
       fcb 2 ; drawmode 
       fcb 17,36 ; starx/y relative to previous node
       fdb -204,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:64|rel:-204)
; node # 19 D(76,-7)->(75,-11)
       fcb 2 ; drawmode 
       fcb 52,15 ; starx/y relative to previous node
       fdb -13,-50 ; dx/dy. dx(abs:-12|rel:-50) dy(abs:51|rel:-13)
; node # 20 D(54,-28)->(53,-16)
       fcb 2 ; drawmode 
       fcb 21,-22 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-153|rel:-204)
; node # 21 D(20,-64)->(20,-50)
       fcb 2 ; drawmode 
       fcb 36,-34 ; starx/y relative to previous node
       fdb -26,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-179|rel:-26)
; node # 22 M(14,-74)->(13,-75)
       fcb 0 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb 191,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:12|rel:191)
; node # 23 D(-41,-59)->(-39,-67)
       fcb 2 ; drawmode 
       fcb -15,-55 ; starx/y relative to previous node
       fdb 90,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:102|rel:90)
; node # 24 M(-20,-48)->(-19,-29)
       fcb 0 ; drawmode 
       fcb -11,21 ; starx/y relative to previous node
       fdb -345,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-243|rel:-345)
; node # 25 D(-58,-43)->(-56,-36)
       fcb 2 ; drawmode 
       fcb -5,-38 ; starx/y relative to previous node
       fdb 154,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-89|rel:154)
; node # 26 M(-44,-8)->(-44,-34)
       fcb 0 ; drawmode 
       fcb -35,14 ; starx/y relative to previous node
       fdb 421,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:332|rel:421)
; node # 27 D(-66,33)->(-68,19)
       fcb 2 ; drawmode 
       fcb -41,-22 ; starx/y relative to previous node
       fdb -153,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:179|rel:-153)
; node # 28 M(-40,26)->(-41,41)
       fcb 0 ; drawmode 
       fcb 7,26 ; starx/y relative to previous node
       fdb -371,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-192|rel:-371)
; node # 29 D(-73,5)->(-73,9)
       fcb 2 ; drawmode 
       fcb 21,-33 ; starx/y relative to previous node
       fdb 141,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-51|rel:141)
; node # 30 M(-24,72)->(-26,63)
       fcb 0 ; drawmode 
       fcb -67,49 ; starx/y relative to previous node
       fdb 166,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:115|rel:166)
; node # 31 D(-12,62)->(-13,73)
       fcb 2 ; drawmode 
       fcb 10,12 ; starx/y relative to previous node
       fdb -255,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-140|rel:-255)
; node # 32 M(25,62)->(26,41)
       fcb 0 ; drawmode 
       fcb 0,37 ; starx/y relative to previous node
       fdb 408,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:268|rel:408)
; node # 33 D(16,9)->(16,-23)
       fcb 2 ; drawmode 
       fcb 53,-9 ; starx/y relative to previous node
       fdb 141,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:409|rel:141)
; node # 34 M(61,45)->(64,41)
       fcb 0 ; drawmode 
       fcb -36,45 ; starx/y relative to previous node
       fdb -358,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:51|rel:-358)
; node # 35 D(33,48)->(34,60)
       fcb 2 ; drawmode 
       fcb -3,-28 ; starx/y relative to previous node
       fdb -204,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-153|rel:-204)
; node # 36 M(76,-7)->(75,-11)
       fcb 0 ; drawmode 
       fcb 55,43 ; starx/y relative to previous node
       fdb 204,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:51|rel:204)
; node # 37 D(53,-35)->(50,-52)
       fcb 2 ; drawmode 
       fcb 28,-23 ; starx/y relative to previous node
       fdb 166,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:217|rel:166)
; node # 38 M(54,-28)->(53,-16)
       fcb 0 ; drawmode 
       fcb -7,1 ; starx/y relative to previous node
       fdb -370,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-153|rel:-370)
; node # 39 D(31,5)->(31,24)
       fcb 2 ; drawmode 
       fcb -33,-23 ; starx/y relative to previous node
       fdb -90,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-243|rel:-90)
       fcb  1  ; end of anim
; Animation 2
dudelframe2:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-11,15)->(-12,35)
       fcb 0 ; drawmode 
       fcb -15,-11 ; starx/y relative to previous node
       fdb -256,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-256|rel:-256)
; node # 1 D(31,24)->(32,41)
       fcb 2 ; drawmode 
       fcb -9,42 ; starx/y relative to previous node
       fdb 39,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-217|rel:39)
; node # 2 D(35,60)->(36,66)
       fcb 2 ; drawmode 
       fcb -36,4 ; starx/y relative to previous node
       fdb 141,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-76|rel:141)
; node # 3 D(-13,73)->(-14,75)
       fcb 2 ; drawmode 
       fcb -13,-48 ; starx/y relative to previous node
       fdb 51,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-25|rel:51)
; node # 4 D(-41,41)->(-43,53)
       fcb 2 ; drawmode 
       fcb 32,-28 ; starx/y relative to previous node
       fdb -128,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-153|rel:-128)
; node # 5 D(-11,15)->(-12,35)
       fcb 2 ; drawmode 
       fcb 26,30 ; starx/y relative to previous node
       fdb -103,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-256|rel:-103)
; node # 6 D(-19,-30)->(-19,-10)
       fcb 2 ; drawmode 
       fcb 45,-8 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-256|rel:0)
; node # 7 D(20,-50)->(18,-32)
       fcb 2 ; drawmode 
       fcb 20,39 ; starx/y relative to previous node
       fdb 26,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-230|rel:26)
; node # 8 D(13,-75)->(12,-68)
       fcb 2 ; drawmode 
       fcb 25,-7 ; starx/y relative to previous node
       fdb 141,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-89|rel:141)
; node # 9 D(50,-52)->(48,-60)
       fcb 2 ; drawmode 
       fcb -23,37 ; starx/y relative to previous node
       fdb 191,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:102|rel:191)
; node # 10 D(16,-23)->(15,-50)
       fcb 2 ; drawmode 
       fcb -29,-34 ; starx/y relative to previous node
       fdb 243,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:345|rel:243)
; node # 11 D(-44,-34)->(-42,-54)
       fcb 2 ; drawmode 
       fcb 11,-60 ; starx/y relative to previous node
       fdb -89,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:256|rel:-89)
; node # 12 D(-39,-67)->(-37,-65)
       fcb 2 ; drawmode 
       fcb 33,5 ; starx/y relative to previous node
       fdb -281,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-25|rel:-281)
; node # 13 D(-56,-36)->(-55,-25)
       fcb 2 ; drawmode 
       fcb -31,-17 ; starx/y relative to previous node
       fdb -115,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-140|rel:-115)
; node # 14 D(-73,9)->(-74,12)
       fcb 2 ; drawmode 
       fcb -45,-17 ; starx/y relative to previous node
       fdb 102,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-38|rel:102)
; node # 15 D(-68,19)->(-69,2)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 255,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:217|rel:255)
; node # 16 D(-26,63)->(-27,43)
       fcb 2 ; drawmode 
       fcb -44,42 ; starx/y relative to previous node
       fdb 39,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:256|rel:39)
; node # 17 D(26,41)->(27,13)
       fcb 2 ; drawmode 
       fcb 22,52 ; starx/y relative to previous node
       fdb 102,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:358|rel:102)
; node # 18 D(64,40)->(66,30)
       fcb 2 ; drawmode 
       fcb 1,38 ; starx/y relative to previous node
       fdb -230,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:128|rel:-230)
; node # 19 D(75,-11)->(74,-13)
       fcb 2 ; drawmode 
       fcb 51,11 ; starx/y relative to previous node
       fdb -103,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:25|rel:-103)
; node # 20 D(53,-16)->(53,-2)
       fcb 2 ; drawmode 
       fcb 5,-22 ; starx/y relative to previous node
       fdb -204,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-179|rel:-204)
; node # 21 D(20,-50)->(18,-32)
       fcb 2 ; drawmode 
       fcb 34,-33 ; starx/y relative to previous node
       fdb -51,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-230|rel:-51)
; node # 22 M(13,-75)->(12,-68)
       fcb 0 ; drawmode 
       fcb 25,-7 ; starx/y relative to previous node
       fdb 141,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-89|rel:141)
; node # 23 D(-39,-67)->(-37,-65)
       fcb 2 ; drawmode 
       fcb -8,-52 ; starx/y relative to previous node
       fdb 64,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-25|rel:64)
; node # 24 M(-19,-29)->(-19,-10)
       fcb 0 ; drawmode 
       fcb -38,20 ; starx/y relative to previous node
       fdb -218,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-243|rel:-218)
; node # 25 D(-56,-36)->(-55,-25)
       fcb 2 ; drawmode 
       fcb 7,-37 ; starx/y relative to previous node
       fdb 103,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-140|rel:103)
; node # 26 M(-44,-34)->(-42,-54)
       fcb 0 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 396,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:256|rel:396)
; node # 27 D(-68,19)->(-69,2)
       fcb 2 ; drawmode 
       fcb -53,-24 ; starx/y relative to previous node
       fdb -39,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:217|rel:-39)
; node # 28 M(-41,41)->(-43,53)
       fcb 0 ; drawmode 
       fcb -22,27 ; starx/y relative to previous node
       fdb -370,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-153|rel:-370)
; node # 29 D(-73,9)->(-74,12)
       fcb 2 ; drawmode 
       fcb 32,-32 ; starx/y relative to previous node
       fdb 115,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-38|rel:115)
; node # 30 M(-26,63)->(-27,43)
       fcb 0 ; drawmode 
       fcb -54,47 ; starx/y relative to previous node
       fdb 294,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:256|rel:294)
; node # 31 D(-13,73)->(-14,75)
       fcb 2 ; drawmode 
       fcb -10,13 ; starx/y relative to previous node
       fdb -281,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-25|rel:-281)
; node # 32 M(26,41)->(27,13)
       fcb 0 ; drawmode 
       fcb 32,39 ; starx/y relative to previous node
       fdb 383,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:358|rel:383)
; node # 33 D(16,-23)->(15,-50)
       fcb 2 ; drawmode 
       fcb 64,-10 ; starx/y relative to previous node
       fdb -13,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:345|rel:-13)
; node # 34 M(64,41)->(66,30)
       fcb 0 ; drawmode 
       fcb -64,48 ; starx/y relative to previous node
       fdb -205,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:140|rel:-205)
; node # 35 D(34,60)->(36,66)
       fcb 2 ; drawmode 
       fcb -19,-30 ; starx/y relative to previous node
       fdb -216,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-76|rel:-216)
; node # 36 M(75,-11)->(74,-13)
       fcb 0 ; drawmode 
       fcb 71,41 ; starx/y relative to previous node
       fdb 101,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:25|rel:101)
; node # 37 D(50,-52)->(48,-60)
       fcb 2 ; drawmode 
       fcb 41,-25 ; starx/y relative to previous node
       fdb 77,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:102|rel:77)
; node # 38 M(53,-16)->(53,-2)
       fcb 0 ; drawmode 
       fcb -36,3 ; starx/y relative to previous node
       fdb -281,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-179|rel:-281)
; node # 39 D(31,24)->(32,41)
       fcb 2 ; drawmode 
       fcb -40,-22 ; starx/y relative to previous node
       fdb -38,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-217|rel:-38)
       fcb  1  ; end of anim
; Animation 3
dudelframe3:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-12,35)->(-13,53)
       fcb 0 ; drawmode 
       fcb -35,-12 ; starx/y relative to previous node
       fdb -230,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-230|rel:-230)
; node # 1 D(32,41)->(34,55)
       fcb 2 ; drawmode 
       fcb -6,44 ; starx/y relative to previous node
       fdb 51,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-179|rel:51)
; node # 2 D(36,66)->(39,64)
       fcb 2 ; drawmode 
       fcb -25,4 ; starx/y relative to previous node
       fdb 204,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:25|rel:204)
; node # 3 D(-14,75)->(-15,68)
       fcb 2 ; drawmode 
       fcb -9,-50 ; starx/y relative to previous node
       fdb 64,-50 ; dx/dy. dx(abs:-12|rel:-50) dy(abs:89|rel:64)
; node # 4 D(-43,53)->(-46,59)
       fcb 2 ; drawmode 
       fcb 22,-29 ; starx/y relative to previous node
       fdb -165,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:-76|rel:-165)
; node # 5 D(-12,35)->(-13,53)
       fcb 2 ; drawmode 
       fcb 18,31 ; starx/y relative to previous node
       fdb -154,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-230|rel:-154)
; node # 6 D(-19,-10)->(-19,11)
       fcb 2 ; drawmode 
       fcb 45,-7 ; starx/y relative to previous node
       fdb -38,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-268|rel:-38)
; node # 7 D(18,-32)->(18,-11)
       fcb 2 ; drawmode 
       fcb 22,37 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:0)
; node # 8 D(12,-68)->(11,-54)
       fcb 2 ; drawmode 
       fcb 36,-6 ; starx/y relative to previous node
       fdb 89,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-179|rel:89)
; node # 9 D(48,-60)->(46,-61)
       fcb 2 ; drawmode 
       fcb -8,36 ; starx/y relative to previous node
       fdb 191,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:12|rel:191)
; node # 10 D(15,-50)->(15,-68)
       fcb 2 ; drawmode 
       fcb -10,-33 ; starx/y relative to previous node
       fdb 218,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:230|rel:218)
; node # 11 D(-42,-54)->(-40,-65)
       fcb 2 ; drawmode 
       fcb 4,-57 ; starx/y relative to previous node
       fdb -90,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:140|rel:-90)
; node # 12 D(-37,-65)->(-34,-56)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb -255,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:-115|rel:-255)
; node # 13 D(-55,-25)->(-54,-12)
       fcb 2 ; drawmode 
       fcb -40,-18 ; starx/y relative to previous node
       fdb -51,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-166|rel:-51)
; node # 14 D(-74,12)->(-74,12)
       fcb 2 ; drawmode 
       fcb -37,-19 ; starx/y relative to previous node
       fdb 166,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:0|rel:166)
; node # 15 D(-69,2)->(-68,-16)
       fcb 2 ; drawmode 
       fcb 10,5 ; starx/y relative to previous node
       fdb 230,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:230|rel:230)
; node # 16 D(-27,43)->(-28,16)
       fcb 2 ; drawmode 
       fcb -41,42 ; starx/y relative to previous node
       fdb 115,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:345|rel:115)
; node # 17 D(27,13)->(27,-17)
       fcb 2 ; drawmode 
       fcb 30,54 ; starx/y relative to previous node
       fdb 39,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:384|rel:39)
; node # 18 D(66,30)->(67,15)
       fcb 2 ; drawmode 
       fcb -17,39 ; starx/y relative to previous node
       fdb -192,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:192|rel:-192)
; node # 19 D(74,-13)->(74,-14)
       fcb 2 ; drawmode 
       fcb 43,8 ; starx/y relative to previous node
       fdb -180,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:12|rel:-180)
; node # 20 D(53,-2)->(54,11)
       fcb 2 ; drawmode 
       fcb -11,-21 ; starx/y relative to previous node
       fdb -178,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-166|rel:-178)
; node # 21 D(18,-32)->(18,-11)
       fcb 2 ; drawmode 
       fcb 30,-35 ; starx/y relative to previous node
       fdb -102,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-268|rel:-102)
; node # 22 M(12,-68)->(11,-54)
       fcb 0 ; drawmode 
       fcb 36,-6 ; starx/y relative to previous node
       fdb 89,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-179|rel:89)
; node # 23 D(-37,-65)->(-34,-56)
       fcb 2 ; drawmode 
       fcb -3,-49 ; starx/y relative to previous node
       fdb 64,50 ; dx/dy. dx(abs:38|rel:50) dy(abs:-115|rel:64)
; node # 24 M(-19,-10)->(-19,11)
       fcb 0 ; drawmode 
       fcb -55,18 ; starx/y relative to previous node
       fdb -153,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:-268|rel:-153)
; node # 25 D(-55,-25)->(-54,-12)
       fcb 2 ; drawmode 
       fcb 15,-36 ; starx/y relative to previous node
       fdb 102,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-166|rel:102)
; node # 26 M(-42,-54)->(-40,-65)
       fcb 0 ; drawmode 
       fcb 29,13 ; starx/y relative to previous node
       fdb 306,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:140|rel:306)
; node # 27 D(-69,2)->(-68,-16)
       fcb 2 ; drawmode 
       fcb -56,-27 ; starx/y relative to previous node
       fdb 90,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:230|rel:90)
; node # 28 M(-43,53)->(-46,59)
       fcb 0 ; drawmode 
       fcb -51,26 ; starx/y relative to previous node
       fdb -306,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:-76|rel:-306)
; node # 29 D(-74,12)->(-74,12)
       fcb 2 ; drawmode 
       fcb 41,-31 ; starx/y relative to previous node
       fdb 76,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:0|rel:76)
; node # 30 M(-27,43)->(-28,16)
       fcb 0 ; drawmode 
       fcb -31,47 ; starx/y relative to previous node
       fdb 345,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:345|rel:345)
; node # 31 D(-14,75)->(-15,68)
       fcb 2 ; drawmode 
       fcb -32,13 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:89|rel:-256)
; node # 32 M(27,13)->(27,-17)
       fcb 0 ; drawmode 
       fcb 62,41 ; starx/y relative to previous node
       fdb 295,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:384|rel:295)
; node # 33 D(15,-50)->(15,-68)
       fcb 2 ; drawmode 
       fcb 63,-12 ; starx/y relative to previous node
       fdb -154,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:230|rel:-154)
; node # 34 M(66,30)->(67,15)
       fcb 0 ; drawmode 
       fcb -80,51 ; starx/y relative to previous node
       fdb -38,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:192|rel:-38)
; node # 35 D(36,66)->(39,64)
       fcb 2 ; drawmode 
       fcb -36,-30 ; starx/y relative to previous node
       fdb -167,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:25|rel:-167)
; node # 36 M(74,-13)->(74,-14)
       fcb 0 ; drawmode 
       fcb 79,38 ; starx/y relative to previous node
       fdb -13,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:12|rel:-13)
; node # 37 D(48,-60)->(46,-61)
       fcb 2 ; drawmode 
       fcb 47,-26 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:12|rel:0)
; node # 38 M(53,-2)->(54,11)
       fcb 0 ; drawmode 
       fcb -58,5 ; starx/y relative to previous node
       fdb -178,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-166|rel:-178)
; node # 39 D(32,41)->(34,55)
       fcb 2 ; drawmode 
       fcb -43,-21 ; starx/y relative to previous node
       fdb -13,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-179|rel:-13)
       fcb  1  ; end of anim
; Animation 4
dudelframe4:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-13,53)->(-13,67)
       fcb 0 ; drawmode 
       fcb -53,-13 ; starx/y relative to previous node
       fdb -179,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-179|rel:-179)
; node # 1 D(34,55)->(36,64)
       fcb 2 ; drawmode 
       fcb -2,47 ; starx/y relative to previous node
       fdb 64,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-115|rel:64)
; node # 2 D(39,64)->(41,53)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb 255,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:140|rel:255)
; node # 3 D(-15,68)->(-16,49)
       fcb 2 ; drawmode 
       fcb -4,-54 ; starx/y relative to previous node
       fdb 103,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:243|rel:103)
; node # 4 D(-46,59)->(-49,59)
       fcb 2 ; drawmode 
       fcb 9,-31 ; starx/y relative to previous node
       fdb -243,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:0|rel:-243)
; node # 5 D(-13,53)->(-13,67)
       fcb 2 ; drawmode 
       fcb 6,33 ; starx/y relative to previous node
       fdb -179,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-179|rel:-179)
; node # 6 D(-19,11)->(-20,31)
       fcb 2 ; drawmode 
       fcb 42,-6 ; starx/y relative to previous node
       fdb -77,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-256|rel:-77)
; node # 7 D(18,-11)->(18,9)
       fcb 2 ; drawmode 
       fcb 22,37 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-256|rel:0)
; node # 8 D(11,-54)->(10,-36)
       fcb 2 ; drawmode 
       fcb 43,-7 ; starx/y relative to previous node
       fdb 26,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-230|rel:26)
; node # 9 D(46,-61)->(43,-53)
       fcb 2 ; drawmode 
       fcb 7,35 ; starx/y relative to previous node
       fdb 128,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:-102|rel:128)
; node # 10 D(15,-68)->(14,-76)
       fcb 2 ; drawmode 
       fcb 7,-31 ; starx/y relative to previous node
       fdb 204,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:102|rel:204)
; node # 11 D(-40,-65)->(-37,-67)
       fcb 2 ; drawmode 
       fcb -3,-55 ; starx/y relative to previous node
       fdb -77,50 ; dx/dy. dx(abs:38|rel:50) dy(abs:25|rel:-77)
; node # 12 D(-34,-56)->(-33,-42)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb -204,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-179|rel:-204)
; node # 13 D(-54,-12)->(-54,2)
       fcb 2 ; drawmode 
       fcb -44,-20 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-179|rel:0)
; node # 14 D(-74,12)->(-75,12)
       fcb 2 ; drawmode 
       fcb -24,-20 ; starx/y relative to previous node
       fdb 179,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:0|rel:179)
; node # 15 D(-68,-16)->(-66,-31)
       fcb 2 ; drawmode 
       fcb 28,6 ; starx/y relative to previous node
       fdb 192,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:192|rel:192)
; node # 16 D(-28,16)->(-28,-15)
       fcb 2 ; drawmode 
       fcb -32,40 ; starx/y relative to previous node
       fdb 204,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:396|rel:204)
; node # 17 D(27,-17)->(27,-44)
       fcb 2 ; drawmode 
       fcb 33,55 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:345|rel:-51)
; node # 18 D(67,15)->(68,-2)
       fcb 2 ; drawmode 
       fcb -32,40 ; starx/y relative to previous node
       fdb -128,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:217|rel:-128)
; node # 19 D(74,-14)->(73,-13)
       fcb 2 ; drawmode 
       fcb 29,7 ; starx/y relative to previous node
       fdb -229,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-12|rel:-229)
; node # 20 D(54,11)->(54,25)
       fcb 2 ; drawmode 
       fcb -25,-20 ; starx/y relative to previous node
       fdb -167,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-179|rel:-167)
; node # 21 D(18,-11)->(18,9)
       fcb 2 ; drawmode 
       fcb 22,-36 ; starx/y relative to previous node
       fdb -77,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:-77)
; node # 22 M(11,-54)->(10,-36)
       fcb 0 ; drawmode 
       fcb 43,-7 ; starx/y relative to previous node
       fdb 26,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-230|rel:26)
; node # 23 D(-34,-56)->(-33,-42)
       fcb 2 ; drawmode 
       fcb 2,-45 ; starx/y relative to previous node
       fdb 51,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-179|rel:51)
; node # 24 M(-19,11)->(-20,31)
       fcb 0 ; drawmode 
       fcb -67,15 ; starx/y relative to previous node
       fdb -77,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-256|rel:-77)
; node # 25 D(-54,-12)->(-54,2)
       fcb 2 ; drawmode 
       fcb 23,-35 ; starx/y relative to previous node
       fdb 77,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-179|rel:77)
; node # 26 M(-40,-65)->(-37,-67)
       fcb 0 ; drawmode 
       fcb 53,14 ; starx/y relative to previous node
       fdb 204,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:25|rel:204)
; node # 27 D(-68,-16)->(-66,-31)
       fcb 2 ; drawmode 
       fcb -49,-28 ; starx/y relative to previous node
       fdb 167,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:192|rel:167)
; node # 28 M(-46,59)->(-49,59)
       fcb 0 ; drawmode 
       fcb -75,22 ; starx/y relative to previous node
       fdb -192,-63 ; dx/dy. dx(abs:-38|rel:-63) dy(abs:0|rel:-192)
; node # 29 D(-74,12)->(-75,12)
       fcb 2 ; drawmode 
       fcb 47,-28 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:0|rel:0)
; node # 30 M(-28,16)->(-28,-15)
       fcb 0 ; drawmode 
       fcb -4,46 ; starx/y relative to previous node
       fdb 396,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:396|rel:396)
; node # 31 D(-15,68)->(-16,49)
       fcb 2 ; drawmode 
       fcb -52,13 ; starx/y relative to previous node
       fdb -153,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:243|rel:-153)
; node # 32 M(27,-17)->(27,-44)
       fcb 0 ; drawmode 
       fcb 85,42 ; starx/y relative to previous node
       fdb 102,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:345|rel:102)
; node # 33 D(15,-68)->(14,-76)
       fcb 2 ; drawmode 
       fcb 51,-12 ; starx/y relative to previous node
       fdb -243,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:102|rel:-243)
; node # 34 M(67,15)->(68,-2)
       fcb 0 ; drawmode 
       fcb -83,52 ; starx/y relative to previous node
       fdb 115,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:217|rel:115)
; node # 35 D(39,64)->(41,53)
       fcb 2 ; drawmode 
       fcb -49,-28 ; starx/y relative to previous node
       fdb -77,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:140|rel:-77)
; node # 36 M(74,-14)->(73,-13)
       fcb 0 ; drawmode 
       fcb 78,35 ; starx/y relative to previous node
       fdb -152,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:-12|rel:-152)
; node # 37 D(46,-61)->(43,-53)
       fcb 2 ; drawmode 
       fcb 47,-28 ; starx/y relative to previous node
       fdb -90,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:-102|rel:-90)
; node # 38 M(54,11)->(54,25)
       fcb 0 ; drawmode 
       fcb -72,8 ; starx/y relative to previous node
       fdb -77,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-179|rel:-77)
; node # 39 D(34,55)->(36,64)
       fcb 2 ; drawmode 
       fcb -44,-20 ; starx/y relative to previous node
       fdb 64,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-115|rel:64)
       fcb  1  ; end of anim
; Animation 5
dudelframe5:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-13,67)->(-14,75)
       fcb 0 ; drawmode 
       fcb -67,-13 ; starx/y relative to previous node
       fdb -102,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-102|rel:-102)
; node # 1 D(36,64)->(38,66)
       fcb 2 ; drawmode 
       fcb 3,49 ; starx/y relative to previous node
       fdb 77,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-25|rel:77)
; node # 2 D(41,53)->(43,33)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb 281,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:256|rel:281)
; node # 3 D(-16,49)->(-17,22)
       fcb 2 ; drawmode 
       fcb 4,-57 ; starx/y relative to previous node
       fdb 89,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:345|rel:89)
; node # 4 D(-49,59)->(-51,50)
       fcb 2 ; drawmode 
       fcb -10,-33 ; starx/y relative to previous node
       fdb -230,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:115|rel:-230)
; node # 5 D(-13,67)->(-14,75)
       fcb 2 ; drawmode 
       fcb -8,36 ; starx/y relative to previous node
       fdb -217,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-102|rel:-217)
; node # 6 D(-20,31)->(-20,49)
       fcb 2 ; drawmode 
       fcb 36,-7 ; starx/y relative to previous node
       fdb -128,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-230|rel:-128)
; node # 7 D(18,9)->(19,29)
       fcb 2 ; drawmode 
       fcb 22,38 ; starx/y relative to previous node
       fdb -26,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-256|rel:-26)
; node # 8 D(10,-36)->(11,-15)
       fcb 2 ; drawmode 
       fcb 45,-8 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-268|rel:-12)
; node # 9 D(43,-53)->(41,-42)
       fcb 2 ; drawmode 
       fcb 17,33 ; starx/y relative to previous node
       fdb 128,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-140|rel:128)
; node # 10 D(14,-76)->(13,-73)
       fcb 2 ; drawmode 
       fcb 23,-29 ; starx/y relative to previous node
       fdb 102,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-38|rel:102)
; node # 11 D(-37,-67)->(-35,-61)
       fcb 2 ; drawmode 
       fcb -9,-51 ; starx/y relative to previous node
       fdb -38,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-76|rel:-38)
; node # 12 D(-33,-42)->(-32,-25)
       fcb 2 ; drawmode 
       fcb -25,4 ; starx/y relative to previous node
       fdb -141,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-217|rel:-141)
; node # 13 D(-54,2)->(-54,16)
       fcb 2 ; drawmode 
       fcb -44,-21 ; starx/y relative to previous node
       fdb 38,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-179|rel:38)
; node # 14 D(-75,12)->(-76,10)
       fcb 2 ; drawmode 
       fcb -10,-21 ; starx/y relative to previous node
       fdb 204,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:25|rel:204)
; node # 15 D(-66,-31)->(-64,-41)
       fcb 2 ; drawmode 
       fcb 43,9 ; starx/y relative to previous node
       fdb 103,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:128|rel:103)
; node # 16 D(-28,-15)->(-27,-42)
       fcb 2 ; drawmode 
       fcb -16,38 ; starx/y relative to previous node
       fdb 217,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:345|rel:217)
; node # 17 D(27,-44)->(26,-64)
       fcb 2 ; drawmode 
       fcb 29,55 ; starx/y relative to previous node
       fdb -89,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:256|rel:-89)
; node # 18 D(68,-2)->(67,-20)
       fcb 2 ; drawmode 
       fcb -42,41 ; starx/y relative to previous node
       fdb -26,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:230|rel:-26)
; node # 19 D(73,-13)->(72,-10)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb -268,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-38|rel:-268)
; node # 20 D(54,25)->(56,35)
       fcb 2 ; drawmode 
       fcb -38,-19 ; starx/y relative to previous node
       fdb -90,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-128|rel:-90)
; node # 21 D(18,9)->(19,29)
       fcb 2 ; drawmode 
       fcb 16,-36 ; starx/y relative to previous node
       fdb -128,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-256|rel:-128)
; node # 22 M(10,-36)->(11,-15)
       fcb 0 ; drawmode 
       fcb 45,-8 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-268|rel:-12)
; node # 23 D(-33,-42)->(-32,-25)
       fcb 2 ; drawmode 
       fcb 6,-43 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-217|rel:51)
; node # 24 M(-20,31)->(-20,49)
       fcb 0 ; drawmode 
       fcb -73,13 ; starx/y relative to previous node
       fdb -13,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-230|rel:-13)
; node # 25 D(-54,2)->(-54,16)
       fcb 2 ; drawmode 
       fcb 29,-34 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-179|rel:51)
; node # 26 M(-37,-67)->(-35,-61)
       fcb 0 ; drawmode 
       fcb 69,17 ; starx/y relative to previous node
       fdb 103,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-76|rel:103)
; node # 27 D(-66,-31)->(-65,-41)
       fcb 2 ; drawmode 
       fcb -36,-29 ; starx/y relative to previous node
       fdb 204,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:128|rel:204)
; node # 28 M(-49,59)->(-51,50)
       fcb 0 ; drawmode 
       fcb -90,17 ; starx/y relative to previous node
       fdb -13,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:115|rel:-13)
; node # 29 D(-75,12)->(-76,10)
       fcb 2 ; drawmode 
       fcb 47,-26 ; starx/y relative to previous node
       fdb -90,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:25|rel:-90)
; node # 30 M(-28,-15)->(-27,-42)
       fcb 0 ; drawmode 
       fcb 27,47 ; starx/y relative to previous node
       fdb 320,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:345|rel:320)
; node # 31 D(-16,49)->(-17,22)
       fcb 2 ; drawmode 
       fcb -64,12 ; starx/y relative to previous node
       fdb 0,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:345|rel:0)
; node # 32 M(27,-44)->(26,-64)
       fcb 0 ; drawmode 
       fcb 93,43 ; starx/y relative to previous node
       fdb -89,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:256|rel:-89)
; node # 33 D(14,-76)->(13,-73)
       fcb 2 ; drawmode 
       fcb 32,-13 ; starx/y relative to previous node
       fdb -294,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-38|rel:-294)
; node # 34 M(68,-2)->(67,-20)
       fcb 0 ; drawmode 
       fcb -74,54 ; starx/y relative to previous node
       fdb 268,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:230|rel:268)
; node # 35 D(41,53)->(43,33)
       fcb 2 ; drawmode 
       fcb -55,-27 ; starx/y relative to previous node
       fdb 26,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:256|rel:26)
; node # 36 M(73,-13)->(72,-10)
       fcb 0 ; drawmode 
       fcb 66,32 ; starx/y relative to previous node
       fdb -294,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:-38|rel:-294)
; node # 37 D(43,-53)->(41,-42)
       fcb 2 ; drawmode 
       fcb 40,-30 ; starx/y relative to previous node
       fdb -102,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-140|rel:-102)
; node # 38 M(54,25)->(56,35)
       fcb 0 ; drawmode 
       fcb -78,11 ; starx/y relative to previous node
       fdb 12,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:-128|rel:12)
; node # 39 D(36,64)->(38,66)
       fcb 2 ; drawmode 
       fcb -39,-18 ; starx/y relative to previous node
       fdb 103,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-25|rel:103)
       fcb  1  ; end of anim
; Animation 6
dudelframe6:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-14,75)->(-15,73)
       fcb 0 ; drawmode 
       fcb -75,-14 ; starx/y relative to previous node
       fdb 25,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:25|rel:25)
; node # 1 D(38,66)->(40,59)
       fcb 2 ; drawmode 
       fcb 9,52 ; starx/y relative to previous node
       fdb 64,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:89|rel:64)
; node # 2 D(43,33)->(44,7)
       fcb 2 ; drawmode 
       fcb 33,5 ; starx/y relative to previous node
       fdb 243,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:332|rel:243)
; node # 3 D(-17,22)->(-17,-10)
       fcb 2 ; drawmode 
       fcb 11,-60 ; starx/y relative to previous node
       fdb 77,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:409|rel:77)
; node # 4 D(-51,50)->(-53,35)
       fcb 2 ; drawmode 
       fcb -28,-34 ; starx/y relative to previous node
       fdb -217,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:192|rel:-217)
; node # 5 D(-14,75)->(-15,73)
       fcb 2 ; drawmode 
       fcb -25,37 ; starx/y relative to previous node
       fdb -167,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:25|rel:-167)
; node # 6 D(-20,49)->(-21,63)
       fcb 2 ; drawmode 
       fcb 26,-6 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-179|rel:-204)
; node # 7 D(19,29)->(19,48)
       fcb 2 ; drawmode 
       fcb 20,39 ; starx/y relative to previous node
       fdb -64,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-243|rel:-64)
; node # 8 D(11,-15)->(11,6)
       fcb 2 ; drawmode 
       fcb 44,-8 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:-25)
; node # 9 D(41,-42)->(39,-26)
       fcb 2 ; drawmode 
       fcb 27,30 ; starx/y relative to previous node
       fdb 64,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-204|rel:64)
; node # 10 D(13,-73)->(12,-63)
       fcb 2 ; drawmode 
       fcb 31,-28 ; starx/y relative to previous node
       fdb 76,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-128|rel:76)
; node # 11 D(-35,-61)->(-33,-48)
       fcb 2 ; drawmode 
       fcb -12,-48 ; starx/y relative to previous node
       fdb -38,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-166|rel:-38)
; node # 12 D(-32,-25)->(-31,-6)
       fcb 2 ; drawmode 
       fcb -36,3 ; starx/y relative to previous node
       fdb -77,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-243|rel:-77)
; node # 13 D(-54,16)->(-55,28)
       fcb 2 ; drawmode 
       fcb -41,-22 ; starx/y relative to previous node
       fdb 90,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-153|rel:90)
; node # 14 D(-76,10)->(-76,10)
       fcb 2 ; drawmode 
       fcb 6,-22 ; starx/y relative to previous node
       fdb 153,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:153)
; node # 15 D(-64,-41)->(-62,-46)
       fcb 2 ; drawmode 
       fcb 51,12 ; starx/y relative to previous node
       fdb 64,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:64|rel:64)
; node # 16 D(-27,-42)->(-26,-63)
       fcb 2 ; drawmode 
       fcb 1,37 ; starx/y relative to previous node
       fdb 204,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:268|rel:204)
; node # 17 D(26,-64)->(23,-72)
       fcb 2 ; drawmode 
       fcb 22,53 ; starx/y relative to previous node
       fdb -166,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:102|rel:-166)
; node # 18 D(67,-20)->(65,-34)
       fcb 2 ; drawmode 
       fcb -44,41 ; starx/y relative to previous node
       fdb 77,13 ; dx/dy. dx(abs:-25|rel:13) dy(abs:179|rel:77)
; node # 19 D(72,-10)->(71,-7)
       fcb 2 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb -217,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-38|rel:-217)
; node # 20 D(56,35)->(58,43)
       fcb 2 ; drawmode 
       fcb -45,-16 ; starx/y relative to previous node
       fdb -64,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-102|rel:-64)
; node # 21 D(19,29)->(19,48)
       fcb 2 ; drawmode 
       fcb 6,-37 ; starx/y relative to previous node
       fdb -141,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-243|rel:-141)
; node # 22 M(11,-15)->(11,6)
       fcb 0 ; drawmode 
       fcb 44,-8 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:-25)
; node # 23 D(-32,-25)->(-31,-6)
       fcb 2 ; drawmode 
       fcb 10,-43 ; starx/y relative to previous node
       fdb 25,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-243|rel:25)
; node # 24 M(-20,49)->(-21,63)
       fcb 0 ; drawmode 
       fcb -74,12 ; starx/y relative to previous node
       fdb 64,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-179|rel:64)
; node # 25 D(-54,16)->(-55,28)
       fcb 2 ; drawmode 
       fcb 33,-34 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-153|rel:26)
; node # 26 M(-35,-61)->(-33,-48)
       fcb 0 ; drawmode 
       fcb 77,19 ; starx/y relative to previous node
       fdb -13,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-166|rel:-13)
; node # 27 D(-65,-41)->(-62,-46)
       fcb 2 ; drawmode 
       fcb -20,-30 ; starx/y relative to previous node
       fdb 230,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:64|rel:230)
; node # 28 M(-51,50)->(-53,35)
       fcb 0 ; drawmode 
       fcb -91,14 ; starx/y relative to previous node
       fdb 128,-63 ; dx/dy. dx(abs:-25|rel:-63) dy(abs:192|rel:128)
; node # 29 D(-76,10)->(-76,10)
       fcb 2 ; drawmode 
       fcb 40,-25 ; starx/y relative to previous node
       fdb -192,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:0|rel:-192)
; node # 30 M(-27,-42)->(-26,-63)
       fcb 0 ; drawmode 
       fcb 52,49 ; starx/y relative to previous node
       fdb 268,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:268|rel:268)
; node # 31 D(-17,22)->(-17,-10)
       fcb 2 ; drawmode 
       fcb -64,10 ; starx/y relative to previous node
       fdb 141,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:409|rel:141)
; node # 32 M(26,-64)->(23,-72)
       fcb 0 ; drawmode 
       fcb 86,43 ; starx/y relative to previous node
       fdb -307,-38 ; dx/dy. dx(abs:-38|rel:-38) dy(abs:102|rel:-307)
; node # 33 D(13,-73)->(12,-63)
       fcb 2 ; drawmode 
       fcb 9,-13 ; starx/y relative to previous node
       fdb -230,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-128|rel:-230)
; node # 34 M(67,-20)->(65,-34)
       fcb 0 ; drawmode 
       fcb -53,54 ; starx/y relative to previous node
       fdb 307,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:179|rel:307)
; node # 35 D(43,33)->(44,7)
       fcb 2 ; drawmode 
       fcb -53,-24 ; starx/y relative to previous node
       fdb 153,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:332|rel:153)
; node # 36 M(72,-10)->(71,-7)
       fcb 0 ; drawmode 
       fcb 43,29 ; starx/y relative to previous node
       fdb -370,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-38|rel:-370)
; node # 37 D(41,-42)->(39,-27)
       fcb 2 ; drawmode 
       fcb 32,-31 ; starx/y relative to previous node
       fdb -154,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-192|rel:-154)
; node # 38 M(56,35)->(58,43)
       fcb 0 ; drawmode 
       fcb -77,15 ; starx/y relative to previous node
       fdb 90,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:-102|rel:90)
; node # 39 D(38,66)->(40,59)
       fcb 2 ; drawmode 
       fcb -31,-18 ; starx/y relative to previous node
       fdb 191,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:89|rel:191)
       fcb  1  ; end of anim
; Animation 7
dudelframe7:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-15,73)->(-16,61)
       fcb 0 ; drawmode 
       fcb -73,-15 ; starx/y relative to previous node
       fdb 153,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:153|rel:153)
; node # 1 D(40,59)->(42,43)
       fcb 2 ; drawmode 
       fcb 14,55 ; starx/y relative to previous node
       fdb 51,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:204|rel:51)
; node # 2 D(44,7)->(44,-19)
       fcb 2 ; drawmode 
       fcb 52,4 ; starx/y relative to previous node
       fdb 128,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:332|rel:128)
; node # 3 D(-17,-10)->(-16,-39)
       fcb 2 ; drawmode 
       fcb 17,-61 ; starx/y relative to previous node
       fdb 39,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:371|rel:39)
; node # 4 D(-53,35)->(-54,12)
       fcb 2 ; drawmode 
       fcb -45,-36 ; starx/y relative to previous node
       fdb -77,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:294|rel:-77)
; node # 5 D(-15,73)->(-16,61)
       fcb 2 ; drawmode 
       fcb -38,38 ; starx/y relative to previous node
       fdb -141,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:153|rel:-141)
; node # 6 D(-21,63)->(-23,71)
       fcb 2 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb -255,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-102|rel:-255)
; node # 7 D(19,48)->(21,62)
       fcb 2 ; drawmode 
       fcb 15,40 ; starx/y relative to previous node
       fdb -77,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:-179|rel:-77)
; node # 8 D(11,6)->(11,27)
       fcb 2 ; drawmode 
       fcb 42,-8 ; starx/y relative to previous node
       fdb -89,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-268|rel:-89)
; node # 9 D(39,-26)->(39,-9)
       fcb 2 ; drawmode 
       fcb 32,28 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-217|rel:51)
; node # 10 D(12,-63)->(11,-47)
       fcb 2 ; drawmode 
       fcb 37,-27 ; starx/y relative to previous node
       fdb 13,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-204|rel:13)
; node # 11 D(-33,-48)->(-32,-32)
       fcb 2 ; drawmode 
       fcb -15,-45 ; starx/y relative to previous node
       fdb 0,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-204|rel:0)
; node # 12 D(-31,-6)->(-31,14)
       fcb 2 ; drawmode 
       fcb -42,2 ; starx/y relative to previous node
       fdb -52,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-256|rel:-52)
; node # 13 D(-55,28)->(-57,38)
       fcb 2 ; drawmode 
       fcb -34,-24 ; starx/y relative to previous node
       fdb 128,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-128|rel:128)
; node # 14 D(-76,10)->(-77,2)
       fcb 2 ; drawmode 
       fcb 18,-21 ; starx/y relative to previous node
       fdb 230,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:102|rel:230)
; node # 15 D(-62,-46)->(-59,-45)
       fcb 2 ; drawmode 
       fcb 56,14 ; starx/y relative to previous node
       fdb -114,50 ; dx/dy. dx(abs:38|rel:50) dy(abs:-12|rel:-114)
; node # 16 D(-26,-63)->(-24,-72)
       fcb 2 ; drawmode 
       fcb 17,36 ; starx/y relative to previous node
       fdb 127,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:115|rel:127)
; node # 17 D(23,-72)->(22,-72)
       fcb 2 ; drawmode 
       fcb 9,49 ; starx/y relative to previous node
       fdb -115,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:0|rel:-115)
; node # 18 D(65,-34)->(63,-43)
       fcb 2 ; drawmode 
       fcb -38,42 ; starx/y relative to previous node
       fdb 115,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:115|rel:115)
; node # 19 D(71,-7)->(71,-2)
       fcb 2 ; drawmode 
       fcb -27,6 ; starx/y relative to previous node
       fdb -179,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-64|rel:-179)
; node # 20 D(58,43)->(61,45)
       fcb 2 ; drawmode 
       fcb -50,-13 ; starx/y relative to previous node
       fdb 39,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:-25|rel:39)
; node # 21 D(19,48)->(21,62)
       fcb 2 ; drawmode 
       fcb -5,-39 ; starx/y relative to previous node
       fdb -154,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:-179|rel:-154)
; node # 22 M(11,6)->(11,27)
       fcb 0 ; drawmode 
       fcb 42,-8 ; starx/y relative to previous node
       fdb -89,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-268|rel:-89)
; node # 23 D(-31,-6)->(-31,14)
       fcb 2 ; drawmode 
       fcb 12,-42 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:12)
; node # 24 M(-21,63)->(-23,71)
       fcb 0 ; drawmode 
       fcb -69,10 ; starx/y relative to previous node
       fdb 154,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-102|rel:154)
; node # 25 D(-55,28)->(-57,38)
       fcb 2 ; drawmode 
       fcb 35,-34 ; starx/y relative to previous node
       fdb -26,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-128|rel:-26)
; node # 26 M(-33,-48)->(-32,-32)
       fcb 0 ; drawmode 
       fcb 76,22 ; starx/y relative to previous node
       fdb -76,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-204|rel:-76)
; node # 27 D(-62,-46)->(-59,-45)
       fcb 2 ; drawmode 
       fcb -2,-29 ; starx/y relative to previous node
       fdb 192,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:-12|rel:192)
; node # 28 M(-53,35)->(-54,12)
       fcb 0 ; drawmode 
       fcb -81,9 ; starx/y relative to previous node
       fdb 306,-50 ; dx/dy. dx(abs:-12|rel:-50) dy(abs:294|rel:306)
; node # 29 D(-76,10)->(-77,2)
       fcb 2 ; drawmode 
       fcb 25,-23 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:102|rel:-192)
; node # 30 M(-26,-63)->(-24,-72)
       fcb 0 ; drawmode 
       fcb 73,50 ; starx/y relative to previous node
       fdb 13,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:115|rel:13)
; node # 31 D(-17,-10)->(-16,-39)
       fcb 2 ; drawmode 
       fcb -53,9 ; starx/y relative to previous node
       fdb 256,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:371|rel:256)
; node # 32 M(23,-72)->(22,-72)
       fcb 0 ; drawmode 
       fcb 62,40 ; starx/y relative to previous node
       fdb -371,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:0|rel:-371)
; node # 33 D(12,-63)->(11,-47)
       fcb 2 ; drawmode 
       fcb -9,-11 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-204|rel:-204)
; node # 34 M(65,-34)->(63,-43)
       fcb 0 ; drawmode 
       fcb -29,53 ; starx/y relative to previous node
       fdb 319,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:115|rel:319)
; node # 35 D(44,7)->(44,-19)
       fcb 2 ; drawmode 
       fcb -41,-21 ; starx/y relative to previous node
       fdb 217,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:332|rel:217)
; node # 36 M(71,-7)->(71,-2)
       fcb 0 ; drawmode 
       fcb 14,27 ; starx/y relative to previous node
       fdb -396,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-64|rel:-396)
; node # 37 D(39,-27)->(39,-9)
       fcb 2 ; drawmode 
       fcb 20,-32 ; starx/y relative to previous node
       fdb -166,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-230|rel:-166)
; node # 38 M(58,43)->(61,45)
       fcb 0 ; drawmode 
       fcb -70,19 ; starx/y relative to previous node
       fdb 205,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:-25|rel:205)
; node # 39 D(40,59)->(42,43)
       fcb 2 ; drawmode 
       fcb -16,-18 ; starx/y relative to previous node
       fdb 229,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:204|rel:229)
       fcb  1  ; end of anim
; Animation 8
dudelframe8:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-16,61)->(-16,39)
       fcb 0 ; drawmode 
       fcb -61,-16 ; starx/y relative to previous node
       fdb 281,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:281|rel:281)
; node # 1 D(42,43)->(44,19)
       fcb 2 ; drawmode 
       fcb 18,58 ; starx/y relative to previous node
       fdb 26,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:307|rel:26)
; node # 2 D(44,-19)->(42,-44)
       fcb 2 ; drawmode 
       fcb 62,2 ; starx/y relative to previous node
       fdb 13,-50 ; dx/dy. dx(abs:-25|rel:-50) dy(abs:320|rel:13)
; node # 3 D(-16,-39)->(-16,-62)
       fcb 2 ; drawmode 
       fcb 20,-60 ; starx/y relative to previous node
       fdb -26,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:294|rel:-26)
; node # 4 D(-54,12)->(-54,-12)
       fcb 2 ; drawmode 
       fcb -51,-38 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:307|rel:13)
; node # 5 D(-16,61)->(-16,39)
       fcb 2 ; drawmode 
       fcb -49,38 ; starx/y relative to previous node
       fdb -26,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:281|rel:-26)
; node # 6 D(-23,71)->(-25,72)
       fcb 2 ; drawmode 
       fcb -10,-7 ; starx/y relative to previous node
       fdb -293,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-12|rel:-293)
; node # 7 D(21,62)->(22,71)
       fcb 2 ; drawmode 
       fcb 9,44 ; starx/y relative to previous node
       fdb -103,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-115|rel:-103)
; node # 8 D(11,27)->(11,46)
       fcb 2 ; drawmode 
       fcb 35,-10 ; starx/y relative to previous node
       fdb -128,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-243|rel:-128)
; node # 9 D(39,-9)->(39,9)
       fcb 2 ; drawmode 
       fcb 36,28 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-230|rel:13)
; node # 10 D(11,-47)->(11,-28)
       fcb 2 ; drawmode 
       fcb 38,-28 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-243|rel:-13)
; node # 11 D(-32,-32)->(-31,-14)
       fcb 2 ; drawmode 
       fcb -15,-43 ; starx/y relative to previous node
       fdb 13,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-230|rel:13)
; node # 12 D(-31,14)->(-32,32)
       fcb 2 ; drawmode 
       fcb -46,1 ; starx/y relative to previous node
       fdb 0,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-230|rel:0)
; node # 13 D(-57,38)->(-59,44)
       fcb 2 ; drawmode 
       fcb -24,-26 ; starx/y relative to previous node
       fdb 154,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-76|rel:154)
; node # 14 D(-77,2)->(-77,-2)
       fcb 2 ; drawmode 
       fcb 36,-20 ; starx/y relative to previous node
       fdb 127,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:51|rel:127)
; node # 15 D(-59,-45)->(-57,-38)
       fcb 2 ; drawmode 
       fcb 47,18 ; starx/y relative to previous node
       fdb -140,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-89|rel:-140)
; node # 16 D(-24,-72)->(-24,-72)
       fcb 2 ; drawmode 
       fcb 27,35 ; starx/y relative to previous node
       fdb 89,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:0|rel:89)
; node # 17 D(22,-72)->(20,-63)
       fcb 2 ; drawmode 
       fcb 0,46 ; starx/y relative to previous node
       fdb -115,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-115|rel:-115)
; node # 18 D(63,-43)->(60,-46)
       fcb 2 ; drawmode 
       fcb -29,41 ; starx/y relative to previous node
       fdb 153,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:38|rel:153)
; node # 19 D(71,-2)->(71,2)
       fcb 2 ; drawmode 
       fcb -41,8 ; starx/y relative to previous node
       fdb -89,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-51|rel:-89)
; node # 20 D(61,45)->(63,43)
       fcb 2 ; drawmode 
       fcb -47,-10 ; starx/y relative to previous node
       fdb 76,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:25|rel:76)
; node # 21 D(21,62)->(22,71)
       fcb 2 ; drawmode 
       fcb -17,-40 ; starx/y relative to previous node
       fdb -140,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-115|rel:-140)
; node # 22 M(11,27)->(11,46)
       fcb 0 ; drawmode 
       fcb 35,-10 ; starx/y relative to previous node
       fdb -128,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-243|rel:-128)
; node # 23 D(-31,14)->(-32,32)
       fcb 2 ; drawmode 
       fcb 13,-42 ; starx/y relative to previous node
       fdb 13,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-230|rel:13)
; node # 24 M(-23,71)->(-25,72)
       fcb 0 ; drawmode 
       fcb -57,8 ; starx/y relative to previous node
       fdb 218,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-12|rel:218)
; node # 25 D(-57,38)->(-59,44)
       fcb 2 ; drawmode 
       fcb 33,-34 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-76|rel:-64)
; node # 26 M(-32,-32)->(-31,-14)
       fcb 0 ; drawmode 
       fcb 70,25 ; starx/y relative to previous node
       fdb -154,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-230|rel:-154)
; node # 27 D(-59,-45)->(-57,-38)
       fcb 2 ; drawmode 
       fcb 13,-27 ; starx/y relative to previous node
       fdb 141,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-89|rel:141)
; node # 28 M(-54,12)->(-54,-12)
       fcb 0 ; drawmode 
       fcb -57,5 ; starx/y relative to previous node
       fdb 396,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:307|rel:396)
; node # 29 D(-77,2)->(-77,-2)
       fcb 2 ; drawmode 
       fcb 10,-23 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:51|rel:-256)
; node # 30 M(-24,-72)->(-24,-72)
       fcb 0 ; drawmode 
       fcb 74,53 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-51)
; node # 31 D(-16,-39)->(-16,-62)
       fcb 2 ; drawmode 
       fcb -33,8 ; starx/y relative to previous node
       fdb 294,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:294|rel:294)
; node # 32 M(22,-72)->(20,-63)
       fcb 0 ; drawmode 
       fcb 33,38 ; starx/y relative to previous node
       fdb -409,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-115|rel:-409)
; node # 33 D(11,-47)->(11,-28)
       fcb 2 ; drawmode 
       fcb -25,-11 ; starx/y relative to previous node
       fdb -128,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-243|rel:-128)
; node # 34 M(63,-43)->(60,-46)
       fcb 0 ; drawmode 
       fcb -4,52 ; starx/y relative to previous node
       fdb 281,-38 ; dx/dy. dx(abs:-38|rel:-38) dy(abs:38|rel:281)
; node # 35 D(44,-19)->(41,-44)
       fcb 2 ; drawmode 
       fcb -24,-19 ; starx/y relative to previous node
       fdb 282,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:320|rel:282)
; node # 36 M(71,-2)->(71,2)
       fcb 0 ; drawmode 
       fcb -17,27 ; starx/y relative to previous node
       fdb -371,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-51|rel:-371)
; node # 37 D(39,-9)->(39,9)
       fcb 2 ; drawmode 
       fcb 7,-32 ; starx/y relative to previous node
       fdb -179,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-230|rel:-179)
; node # 38 M(61,45)->(63,43)
       fcb 0 ; drawmode 
       fcb -54,22 ; starx/y relative to previous node
       fdb 255,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:25|rel:255)
; node # 39 D(42,43)->(44,19)
       fcb 2 ; drawmode 
       fcb 2,-19 ; starx/y relative to previous node
       fdb 282,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:307|rel:282)
       fcb  1  ; end of anim
; Animation 9
dudelframe9:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-16,39)->(-17,9)
       fcb 0 ; drawmode 
       fcb -39,-16 ; starx/y relative to previous node
       fdb 384,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:384|rel:384)
; node # 1 D(44,19)->(44,-8)
       fcb 2 ; drawmode 
       fcb 20,60 ; starx/y relative to previous node
       fdb -39,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:345|rel:-39)
; node # 2 D(42,-44)->(41,-59)
       fcb 2 ; drawmode 
       fcb 63,-2 ; starx/y relative to previous node
       fdb -153,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:192|rel:-153)
; node # 3 D(-16,-62)->(-14,-74)
       fcb 2 ; drawmode 
       fcb 18,-58 ; starx/y relative to previous node
       fdb -39,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:153|rel:-39)
; node # 4 D(-54,-12)->(-53,-35)
       fcb 2 ; drawmode 
       fcb -50,-38 ; starx/y relative to previous node
       fdb 141,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:294|rel:141)
; node # 5 D(-16,39)->(-17,9)
       fcb 2 ; drawmode 
       fcb -51,38 ; starx/y relative to previous node
       fdb 90,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:384|rel:90)
; node # 6 D(-25,72)->(-26,62)
       fcb 2 ; drawmode 
       fcb -33,-9 ; starx/y relative to previous node
       fdb -256,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:128|rel:-256)
; node # 7 D(22,71)->(23,72)
       fcb 2 ; drawmode 
       fcb 1,47 ; starx/y relative to previous node
       fdb -140,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-12|rel:-140)
; node # 8 D(11,46)->(12,62)
       fcb 2 ; drawmode 
       fcb 25,-11 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-204|rel:-192)
; node # 9 D(39,9)->(39,26)
       fcb 2 ; drawmode 
       fcb 37,28 ; starx/y relative to previous node
       fdb -13,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-217|rel:-13)
; node # 10 D(11,-28)->(11,-6)
       fcb 2 ; drawmode 
       fcb 37,-28 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-281|rel:-64)
; node # 11 D(-31,-14)->(-31,5)
       fcb 2 ; drawmode 
       fcb -14,-42 ; starx/y relative to previous node
       fdb 38,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-243|rel:38)
; node # 12 D(-32,32)->(-34,48)
       fcb 2 ; drawmode 
       fcb -46,-1 ; starx/y relative to previous node
       fdb 39,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-204|rel:39)
; node # 13 D(-59,44)->(-62,45)
       fcb 2 ; drawmode 
       fcb -12,-27 ; starx/y relative to previous node
       fdb 192,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:-12|rel:192)
; node # 14 D(-77,-2)->(-77,-7)
       fcb 2 ; drawmode 
       fcb 46,-18 ; starx/y relative to previous node
       fdb 76,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:64|rel:76)
; node # 15 D(-57,-38)->(-55,-28)
       fcb 2 ; drawmode 
       fcb 36,20 ; starx/y relative to previous node
       fdb -192,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-128|rel:-192)
; node # 16 D(-24,-72)->(-22,-64)
       fcb 2 ; drawmode 
       fcb 34,33 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-102|rel:26)
; node # 17 D(20,-63)->(19,-49)
       fcb 2 ; drawmode 
       fcb -9,44 ; starx/y relative to previous node
       fdb -77,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:-179|rel:-77)
; node # 18 D(60,-46)->(58,-43)
       fcb 2 ; drawmode 
       fcb -17,40 ; starx/y relative to previous node
       fdb 141,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-38|rel:141)
; node # 19 D(71,2)->(71,6)
       fcb 2 ; drawmode 
       fcb -48,11 ; starx/y relative to previous node
       fdb -13,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-51|rel:-13)
; node # 20 D(63,43)->(66,34)
       fcb 2 ; drawmode 
       fcb -41,-8 ; starx/y relative to previous node
       fdb 166,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:115|rel:166)
; node # 21 D(22,71)->(23,72)
       fcb 2 ; drawmode 
       fcb -28,-41 ; starx/y relative to previous node
       fdb -127,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-12|rel:-127)
; node # 22 M(11,46)->(12,62)
       fcb 0 ; drawmode 
       fcb 25,-11 ; starx/y relative to previous node
       fdb -192,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-204|rel:-192)
; node # 23 D(-32,32)->(-34,48)
       fcb 2 ; drawmode 
       fcb 14,-43 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-204|rel:0)
; node # 24 M(-25,72)->(-26,62)
       fcb 0 ; drawmode 
       fcb -40,7 ; starx/y relative to previous node
       fdb 332,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:128|rel:332)
; node # 25 D(-59,44)->(-62,45)
       fcb 2 ; drawmode 
       fcb 28,-34 ; starx/y relative to previous node
       fdb -140,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:-12|rel:-140)
; node # 26 M(-31,-14)->(-31,5)
       fcb 0 ; drawmode 
       fcb 58,28 ; starx/y relative to previous node
       fdb -231,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-243|rel:-231)
; node # 27 D(-57,-38)->(-55,-28)
       fcb 2 ; drawmode 
       fcb 24,-26 ; starx/y relative to previous node
       fdb 115,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-128|rel:115)
; node # 28 M(-54,-12)->(-53,-35)
       fcb 0 ; drawmode 
       fcb -26,3 ; starx/y relative to previous node
       fdb 422,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:294|rel:422)
; node # 29 D(-77,-2)->(-77,-7)
       fcb 2 ; drawmode 
       fcb -10,-23 ; starx/y relative to previous node
       fdb -230,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:64|rel:-230)
; node # 30 M(-24,-72)->(-22,-64)
       fcb 0 ; drawmode 
       fcb 70,53 ; starx/y relative to previous node
       fdb -166,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-102|rel:-166)
; node # 31 D(-16,-62)->(-14,-74)
       fcb 2 ; drawmode 
       fcb -10,8 ; starx/y relative to previous node
       fdb 255,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:153|rel:255)
; node # 32 M(20,-63)->(19,-49)
       fcb 0 ; drawmode 
       fcb 1,36 ; starx/y relative to previous node
       fdb -332,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:-179|rel:-332)
; node # 33 D(11,-28)->(11,-6)
       fcb 2 ; drawmode 
       fcb -35,-9 ; starx/y relative to previous node
       fdb -102,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-281|rel:-102)
; node # 34 M(60,-46)->(58,-43)
       fcb 0 ; drawmode 
       fcb 18,49 ; starx/y relative to previous node
       fdb 243,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-38|rel:243)
; node # 35 D(41,-44)->(41,-59)
       fcb 2 ; drawmode 
       fcb -2,-19 ; starx/y relative to previous node
       fdb 230,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:192|rel:230)
; node # 36 M(71,2)->(71,6)
       fcb 0 ; drawmode 
       fcb -46,30 ; starx/y relative to previous node
       fdb -243,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-51|rel:-243)
; node # 37 D(39,9)->(39,26)
       fcb 2 ; drawmode 
       fcb -7,-32 ; starx/y relative to previous node
       fdb -166,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-217|rel:-166)
; node # 38 M(63,43)->(66,34)
       fcb 0 ; drawmode 
       fcb -34,24 ; starx/y relative to previous node
       fdb 332,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:115|rel:332)
; node # 39 D(44,19)->(44,-8)
       fcb 2 ; drawmode 
       fcb 24,-19 ; starx/y relative to previous node
       fdb 230,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:345|rel:230)
       fcb  1  ; end of anim
; Animation 10
dudelframe10:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-17,9)->(-17,-23)
       fcb 0 ; drawmode 
       fcb -9,-17 ; starx/y relative to previous node
       fdb 409,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:409|rel:409)
; node # 1 D(44,-8)->(43,-34)
       fcb 2 ; drawmode 
       fcb 17,61 ; starx/y relative to previous node
       fdb -77,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:332|rel:-77)
; node # 2 D(41,-59)->(38,-66)
       fcb 2 ; drawmode 
       fcb 51,-3 ; starx/y relative to previous node
       fdb -243,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:89|rel:-243)
; node # 3 D(-14,-74)->(-14,-75)
       fcb 2 ; drawmode 
       fcb 15,-55 ; starx/y relative to previous node
       fdb -77,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:12|rel:-77)
; node # 4 D(-53,-35)->(-51,-52)
       fcb 2 ; drawmode 
       fcb -39,-39 ; starx/y relative to previous node
       fdb 205,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:217|rel:205)
; node # 5 D(-17,9)->(-17,-23)
       fcb 2 ; drawmode 
       fcb -44,36 ; starx/y relative to previous node
       fdb 192,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:409|rel:192)
; node # 6 D(-26,62)->(-28,42)
       fcb 2 ; drawmode 
       fcb -53,-9 ; starx/y relative to previous node
       fdb -153,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:256|rel:-153)
; node # 7 D(23,72)->(25,63)
       fcb 2 ; drawmode 
       fcb -10,49 ; starx/y relative to previous node
       fdb -141,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:115|rel:-141)
; node # 8 D(12,62)->(13,73)
       fcb 2 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb -255,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-140|rel:-255)
; node # 9 D(39,26)->(41,41)
       fcb 2 ; drawmode 
       fcb 36,27 ; starx/y relative to previous node
       fdb -52,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-192|rel:-52)
; node # 10 D(11,-6)->(11,15)
       fcb 2 ; drawmode 
       fcb 32,-28 ; starx/y relative to previous node
       fdb -76,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-268|rel:-76)
; node # 11 D(-31,5)->(-32,24)
       fcb 2 ; drawmode 
       fcb -11,-42 ; starx/y relative to previous node
       fdb 25,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-243|rel:25)
; node # 12 D(-34,48)->(-36,60)
       fcb 2 ; drawmode 
       fcb -43,-3 ; starx/y relative to previous node
       fdb 90,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-153|rel:90)
; node # 13 D(-62,45)->(-65,40)
       fcb 2 ; drawmode 
       fcb 3,-28 ; starx/y relative to previous node
       fdb 217,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:64|rel:217)
; node # 14 D(-77,-7)->(-77,-11)
       fcb 2 ; drawmode 
       fcb 52,-15 ; starx/y relative to previous node
       fdb -13,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:51|rel:-13)
; node # 15 D(-55,-28)->(-54,-16)
       fcb 2 ; drawmode 
       fcb 21,22 ; starx/y relative to previous node
       fdb -204,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-153|rel:-204)
; node # 16 D(-22,-64)->(-20,-50)
       fcb 2 ; drawmode 
       fcb 36,33 ; starx/y relative to previous node
       fdb -26,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-179|rel:-26)
; node # 17 D(19,-49)->(19,-30)
       fcb 2 ; drawmode 
       fcb -15,41 ; starx/y relative to previous node
       fdb -64,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-243|rel:-64)
; node # 18 D(58,-43)->(56,-36)
       fcb 2 ; drawmode 
       fcb -6,39 ; starx/y relative to previous node
       fdb 154,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-89|rel:154)
; node # 19 D(71,6)->(72,10)
       fcb 2 ; drawmode 
       fcb -49,13 ; starx/y relative to previous node
       fdb 38,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-51|rel:38)
; node # 20 D(66,34)->(67,19)
       fcb 2 ; drawmode 
       fcb -28,-5 ; starx/y relative to previous node
       fdb 243,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:192|rel:243)
; node # 21 D(23,72)->(25,63)
       fcb 2 ; drawmode 
       fcb -38,-43 ; starx/y relative to previous node
       fdb -77,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:115|rel:-77)
; node # 22 M(12,62)->(13,73)
       fcb 0 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb -255,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-140|rel:-255)
; node # 23 D(-34,48)->(-36,60)
       fcb 2 ; drawmode 
       fcb 14,-46 ; starx/y relative to previous node
       fdb -13,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-153|rel:-13)
; node # 24 M(-26,62)->(-28,42)
       fcb 0 ; drawmode 
       fcb -14,8 ; starx/y relative to previous node
       fdb 409,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:256|rel:409)
; node # 25 D(-62,45)->(-65,40)
       fcb 2 ; drawmode 
       fcb 17,-36 ; starx/y relative to previous node
       fdb -192,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:64|rel:-192)
; node # 26 M(-31,5)->(-32,24)
       fcb 0 ; drawmode 
       fcb 40,31 ; starx/y relative to previous node
       fdb -307,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-243|rel:-307)
; node # 27 D(-55,-28)->(-54,-16)
       fcb 2 ; drawmode 
       fcb 33,-24 ; starx/y relative to previous node
       fdb 90,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-153|rel:90)
; node # 28 M(-53,-35)->(-51,-52)
       fcb 0 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb 370,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:217|rel:370)
; node # 29 D(-77,-7)->(-77,-11)
       fcb 2 ; drawmode 
       fcb -28,-24 ; starx/y relative to previous node
       fdb -166,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:51|rel:-166)
; node # 30 M(-22,-64)->(-20,-50)
       fcb 0 ; drawmode 
       fcb 57,55 ; starx/y relative to previous node
       fdb -230,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-179|rel:-230)
; node # 31 D(-14,-74)->(-14,-75)
       fcb 2 ; drawmode 
       fcb 10,8 ; starx/y relative to previous node
       fdb 191,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:12|rel:191)
; node # 32 M(19,-49)->(19,-30)
       fcb 0 ; drawmode 
       fcb -25,33 ; starx/y relative to previous node
       fdb -255,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-243|rel:-255)
; node # 33 D(11,-6)->(11,15)
       fcb 2 ; drawmode 
       fcb -43,-8 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:-25)
; node # 34 M(58,-43)->(56,-36)
       fcb 0 ; drawmode 
       fcb 37,47 ; starx/y relative to previous node
       fdb 179,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-89|rel:179)
; node # 35 D(41,-59)->(38,-66)
       fcb 2 ; drawmode 
       fcb 16,-17 ; starx/y relative to previous node
       fdb 178,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:89|rel:178)
; node # 36 M(71,6)->(72,10)
       fcb 0 ; drawmode 
       fcb -65,30 ; starx/y relative to previous node
       fdb -140,50 ; dx/dy. dx(abs:12|rel:50) dy(abs:-51|rel:-140)
; node # 37 D(39,26)->(41,41)
       fcb 2 ; drawmode 
       fcb -20,-32 ; starx/y relative to previous node
       fdb -141,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-192|rel:-141)
; node # 38 M(66,34)->(67,19)
       fcb 0 ; drawmode 
       fcb -8,27 ; starx/y relative to previous node
       fdb 384,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:192|rel:384)
; node # 39 D(44,-8)->(43,-34)
       fcb 2 ; drawmode 
       fcb 42,-22 ; starx/y relative to previous node
       fdb 140,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:332|rel:140)
       fcb  1  ; end of anim
; Animation 11
dudelframe11:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-17,-23)->(-16,-50)
       fcb 0 ; drawmode 
       fcb 23,-17 ; starx/y relative to previous node
       fdb 345,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:345|rel:345)
; node # 1 D(43,-34)->(41,-54)
       fcb 2 ; drawmode 
       fcb 11,60 ; starx/y relative to previous node
       fdb -89,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:256|rel:-89)
; node # 2 D(38,-66)->(36,-65)
       fcb 2 ; drawmode 
       fcb 32,-5 ; starx/y relative to previous node
       fdb -268,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-12|rel:-268)
; node # 3 D(-14,-75)->(-13,-68)
       fcb 2 ; drawmode 
       fcb 9,-52 ; starx/y relative to previous node
       fdb -77,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-89|rel:-77)
; node # 4 D(-51,-52)->(-48,-60)
       fcb 2 ; drawmode 
       fcb -23,-37 ; starx/y relative to previous node
       fdb 191,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:102|rel:191)
; node # 5 D(-17,-23)->(-16,-50)
       fcb 2 ; drawmode 
       fcb -29,34 ; starx/y relative to previous node
       fdb 243,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:345|rel:243)
; node # 6 D(-28,42)->(-28,13)
       fcb 2 ; drawmode 
       fcb -65,-11 ; starx/y relative to previous node
       fdb 26,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:371|rel:26)
; node # 7 D(25,63)->(26,44)
       fcb 2 ; drawmode 
       fcb -21,53 ; starx/y relative to previous node
       fdb -128,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:243|rel:-128)
; node # 8 D(13,73)->(14,75)
       fcb 2 ; drawmode 
       fcb -10,-12 ; starx/y relative to previous node
       fdb -268,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-25|rel:-268)
; node # 9 D(41,41)->(43,53)
       fcb 2 ; drawmode 
       fcb 32,28 ; starx/y relative to previous node
       fdb -128,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-153|rel:-128)
; node # 10 D(11,15)->(11,35)
       fcb 2 ; drawmode 
       fcb 26,-30 ; starx/y relative to previous node
       fdb -103,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-256|rel:-103)
; node # 11 D(-32,24)->(-33,42)
       fcb 2 ; drawmode 
       fcb -9,-43 ; starx/y relative to previous node
       fdb 26,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-230|rel:26)
; node # 12 D(-36,60)->(-37,66)
       fcb 2 ; drawmode 
       fcb -36,-4 ; starx/y relative to previous node
       fdb 154,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-76|rel:154)
; node # 13 D(-65,40)->(-66,30)
       fcb 2 ; drawmode 
       fcb 20,-29 ; starx/y relative to previous node
       fdb 204,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:128|rel:204)
; node # 14 D(-77,-11)->(-76,-13)
       fcb 2 ; drawmode 
       fcb 51,-12 ; starx/y relative to previous node
       fdb -103,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:25|rel:-103)
; node # 15 D(-54,-16)->(-54,-2)
       fcb 2 ; drawmode 
       fcb 5,23 ; starx/y relative to previous node
       fdb -204,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-179|rel:-204)
; node # 16 D(-20,-50)->(-19,-32)
       fcb 2 ; drawmode 
       fcb 34,34 ; starx/y relative to previous node
       fdb -51,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-230|rel:-51)
; node # 17 D(19,-30)->(19,-10)
       fcb 2 ; drawmode 
       fcb -20,39 ; starx/y relative to previous node
       fdb -26,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-256|rel:-26)
; node # 18 D(56,-36)->(54,-25)
       fcb 2 ; drawmode 
       fcb 6,37 ; starx/y relative to previous node
       fdb 116,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-140|rel:116)
; node # 19 D(72,10)->(73,12)
       fcb 2 ; drawmode 
       fcb -46,16 ; starx/y relative to previous node
       fdb 115,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-25|rel:115)
; node # 20 D(67,19)->(68,2)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 242,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:217|rel:242)
; node # 21 D(25,63)->(27,43)
       fcb 2 ; drawmode 
       fcb -44,-42 ; starx/y relative to previous node
       fdb 39,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:256|rel:39)
; node # 22 M(13,73)->(14,75)
       fcb 0 ; drawmode 
       fcb -10,-12 ; starx/y relative to previous node
       fdb -281,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-25|rel:-281)
; node # 23 D(-36,60)->(-37,66)
       fcb 2 ; drawmode 
       fcb 13,-49 ; starx/y relative to previous node
       fdb -51,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-76|rel:-51)
; node # 24 M(-28,42)->(-28,13)
       fcb 0 ; drawmode 
       fcb 18,8 ; starx/y relative to previous node
       fdb 447,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:371|rel:447)
; node # 25 D(-65,40)->(-66,30)
       fcb 2 ; drawmode 
       fcb 2,-37 ; starx/y relative to previous node
       fdb -243,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:128|rel:-243)
; node # 26 M(-32,24)->(-33,42)
       fcb 0 ; drawmode 
       fcb 16,33 ; starx/y relative to previous node
       fdb -358,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-230|rel:-358)
; node # 27 D(-54,-16)->(-54,-2)
       fcb 2 ; drawmode 
       fcb 40,-22 ; starx/y relative to previous node
       fdb 51,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-179|rel:51)
; node # 28 M(-51,-52)->(-48,-60)
       fcb 0 ; drawmode 
       fcb 36,3 ; starx/y relative to previous node
       fdb 281,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:102|rel:281)
; node # 29 D(-77,-11)->(-76,-13)
       fcb 2 ; drawmode 
       fcb -41,-26 ; starx/y relative to previous node
       fdb -77,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:25|rel:-77)
; node # 30 M(-20,-50)->(-19,-32)
       fcb 0 ; drawmode 
       fcb 39,57 ; starx/y relative to previous node
       fdb -255,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-230|rel:-255)
; node # 31 D(-14,-75)->(-13,-68)
       fcb 2 ; drawmode 
       fcb 25,6 ; starx/y relative to previous node
       fdb 141,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-89|rel:141)
; node # 32 M(19,-30)->(19,-10)
       fcb 0 ; drawmode 
       fcb -45,33 ; starx/y relative to previous node
       fdb -167,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-256|rel:-167)
; node # 33 D(11,15)->(11,35)
       fcb 2 ; drawmode 
       fcb -45,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:0)
; node # 34 M(56,-36)->(54,-25)
       fcb 0 ; drawmode 
       fcb 51,45 ; starx/y relative to previous node
       fdb 116,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-140|rel:116)
; node # 35 D(38,-66)->(36,-65)
       fcb 2 ; drawmode 
       fcb 30,-18 ; starx/y relative to previous node
       fdb 128,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-12|rel:128)
; node # 36 M(72,10)->(73,12)
       fcb 0 ; drawmode 
       fcb -76,34 ; starx/y relative to previous node
       fdb -13,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-25|rel:-13)
; node # 37 D(41,41)->(43,53)
       fcb 2 ; drawmode 
       fcb -31,-31 ; starx/y relative to previous node
       fdb -128,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-153|rel:-128)
; node # 38 M(67,19)->(68,2)
       fcb 0 ; drawmode 
       fcb 22,26 ; starx/y relative to previous node
       fdb 370,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:217|rel:370)
; node # 39 D(43,-34)->(41,-54)
       fcb 2 ; drawmode 
       fcb 53,-24 ; starx/y relative to previous node
       fdb 39,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:256|rel:39)
       fcb  1  ; end of anim
; Animation 12
dudelframe12:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-16,-50)->(-15,-68)
       fcb 0 ; drawmode 
       fcb 50,-16 ; starx/y relative to previous node
       fdb 230,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:230|rel:230)
; node # 1 D(41,-54)->(39,-65)
       fcb 2 ; drawmode 
       fcb 4,57 ; starx/y relative to previous node
       fdb -90,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:140|rel:-90)
; node # 2 D(36,-65)->(34,-56)
       fcb 2 ; drawmode 
       fcb 11,-5 ; starx/y relative to previous node
       fdb -255,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-115|rel:-255)
; node # 3 D(-13,-68)->(-12,-54)
       fcb 2 ; drawmode 
       fcb 3,-49 ; starx/y relative to previous node
       fdb -64,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-179|rel:-64)
; node # 4 D(-48,-60)->(-46,-60)
       fcb 2 ; drawmode 
       fcb -8,-35 ; starx/y relative to previous node
       fdb 179,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:0|rel:179)
; node # 5 D(-16,-50)->(-15,-68)
       fcb 2 ; drawmode 
       fcb -10,32 ; starx/y relative to previous node
       fdb 230,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:230|rel:230)
; node # 6 D(-28,13)->(-28,-17)
       fcb 2 ; drawmode 
       fcb -63,-12 ; starx/y relative to previous node
       fdb 154,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:384|rel:154)
; node # 7 D(26,44)->(27,16)
       fcb 2 ; drawmode 
       fcb -31,54 ; starx/y relative to previous node
       fdb -26,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:358|rel:-26)
; node # 8 D(14,75)->(15,68)
       fcb 2 ; drawmode 
       fcb -31,-12 ; starx/y relative to previous node
       fdb -269,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:89|rel:-269)
; node # 9 D(43,53)->(45,60)
       fcb 2 ; drawmode 
       fcb 22,29 ; starx/y relative to previous node
       fdb -178,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-89|rel:-178)
; node # 10 D(11,35)->(12,53)
       fcb 2 ; drawmode 
       fcb 18,-32 ; starx/y relative to previous node
       fdb -141,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-230|rel:-141)
; node # 11 D(-33,42)->(-35,55)
       fcb 2 ; drawmode 
       fcb -7,-44 ; starx/y relative to previous node
       fdb 64,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-166|rel:64)
; node # 12 D(-37,66)->(-40,64)
       fcb 2 ; drawmode 
       fcb -24,-4 ; starx/y relative to previous node
       fdb 191,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:25|rel:191)
; node # 13 D(-66,30)->(-68,15)
       fcb 2 ; drawmode 
       fcb 36,-29 ; starx/y relative to previous node
       fdb 167,13 ; dx/dy. dx(abs:-25|rel:13) dy(abs:192|rel:167)
; node # 14 D(-76,-13)->(-75,-14)
       fcb 2 ; drawmode 
       fcb 43,-10 ; starx/y relative to previous node
       fdb -180,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:12|rel:-180)
; node # 15 D(-54,-2)->(-54,11)
       fcb 2 ; drawmode 
       fcb -11,22 ; starx/y relative to previous node
       fdb -178,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-166|rel:-178)
; node # 16 D(-19,-32)->(-19,-11)
       fcb 2 ; drawmode 
       fcb 30,35 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:-102)
; node # 17 D(19,-10)->(19,11)
       fcb 2 ; drawmode 
       fcb -22,38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:0)
; node # 18 D(54,-25)->(54,-12)
       fcb 2 ; drawmode 
       fcb 15,35 ; starx/y relative to previous node
       fdb 102,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-166|rel:102)
; node # 19 D(73,12)->(74,13)
       fcb 2 ; drawmode 
       fcb -37,19 ; starx/y relative to previous node
       fdb 154,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-12|rel:154)
; node # 20 D(68,2)->(68,-16)
       fcb 2 ; drawmode 
       fcb 10,-5 ; starx/y relative to previous node
       fdb 242,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:230|rel:242)
; node # 21 D(27,43)->(27,16)
       fcb 2 ; drawmode 
       fcb -41,-41 ; starx/y relative to previous node
       fdb 115,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:345|rel:115)
; node # 22 M(14,75)->(15,68)
       fcb 0 ; drawmode 
       fcb -32,-13 ; starx/y relative to previous node
       fdb -256,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:89|rel:-256)
; node # 23 D(-37,66)->(-40,64)
       fcb 2 ; drawmode 
       fcb 9,-51 ; starx/y relative to previous node
       fdb -64,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:25|rel:-64)
; node # 24 M(-28,13)->(-28,-17)
       fcb 0 ; drawmode 
       fcb 53,9 ; starx/y relative to previous node
       fdb 359,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:384|rel:359)
; node # 25 D(-66,30)->(-68,15)
       fcb 2 ; drawmode 
       fcb -17,-38 ; starx/y relative to previous node
       fdb -192,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:192|rel:-192)
; node # 26 M(-33,42)->(-35,55)
       fcb 0 ; drawmode 
       fcb -12,33 ; starx/y relative to previous node
       fdb -358,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-166|rel:-358)
; node # 27 D(-54,-2)->(-54,11)
       fcb 2 ; drawmode 
       fcb 44,-21 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-166|rel:0)
; node # 28 M(-48,-60)->(-46,-60)
       fcb 0 ; drawmode 
       fcb 58,6 ; starx/y relative to previous node
       fdb 166,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:0|rel:166)
; node # 29 D(-76,-13)->(-75,-14)
       fcb 2 ; drawmode 
       fcb -47,-28 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:12|rel:12)
; node # 30 M(-19,-32)->(-19,-11)
       fcb 0 ; drawmode 
       fcb 19,57 ; starx/y relative to previous node
       fdb -280,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-268|rel:-280)
; node # 31 D(-13,-68)->(-12,-54)
       fcb 2 ; drawmode 
       fcb 36,6 ; starx/y relative to previous node
       fdb 89,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-179|rel:89)
; node # 32 M(19,-10)->(19,11)
       fcb 0 ; drawmode 
       fcb -58,32 ; starx/y relative to previous node
       fdb -89,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-268|rel:-89)
; node # 33 D(11,35)->(12,53)
       fcb 2 ; drawmode 
       fcb -45,-8 ; starx/y relative to previous node
       fdb 38,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-230|rel:38)
; node # 34 M(54,-25)->(54,-12)
       fcb 0 ; drawmode 
       fcb 60,43 ; starx/y relative to previous node
       fdb 64,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-166|rel:64)
; node # 35 D(36,-65)->(34,-56)
       fcb 2 ; drawmode 
       fcb 40,-18 ; starx/y relative to previous node
       fdb 51,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-115|rel:51)
; node # 36 M(73,12)->(74,13)
       fcb 0 ; drawmode 
       fcb -77,37 ; starx/y relative to previous node
       fdb 103,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-12|rel:103)
; node # 37 D(43,53)->(45,60)
       fcb 2 ; drawmode 
       fcb -41,-30 ; starx/y relative to previous node
       fdb -77,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-89|rel:-77)
; node # 38 M(68,2)->(68,-16)
       fcb 0 ; drawmode 
       fcb 51,25 ; starx/y relative to previous node
       fdb 319,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:230|rel:319)
; node # 39 D(41,-54)->(39,-65)
       fcb 2 ; drawmode 
       fcb 56,-27 ; starx/y relative to previous node
       fdb -90,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:140|rel:-90)
       fcb  1  ; end of anim
; Animation 13
dudelframe13:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-15,-68)->(-14,-75)
       fcb 0 ; drawmode 
       fcb 68,-15 ; starx/y relative to previous node
       fdb 89,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:89|rel:89)
; node # 1 D(39,-65)->(37,-66)
       fcb 2 ; drawmode 
       fcb -3,54 ; starx/y relative to previous node
       fdb -77,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:12|rel:-77)
; node # 2 D(34,-56)->(32,-42)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb -191,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-179|rel:-191)
; node # 3 D(-12,-54)->(-12,-36)
       fcb 2 ; drawmode 
       fcb -2,-46 ; starx/y relative to previous node
       fdb -51,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-230|rel:-51)
; node # 4 D(-46,-60)->(-44,-53)
       fcb 2 ; drawmode 
       fcb 6,-34 ; starx/y relative to previous node
       fdb 141,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-89|rel:141)
; node # 5 D(-15,-68)->(-14,-75)
       fcb 2 ; drawmode 
       fcb 8,31 ; starx/y relative to previous node
       fdb 178,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:89|rel:178)
; node # 6 D(-28,-17)->(-27,-44)
       fcb 2 ; drawmode 
       fcb -51,-13 ; starx/y relative to previous node
       fdb 256,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:345|rel:256)
; node # 7 D(27,16)->(27,-15)
       fcb 2 ; drawmode 
       fcb -33,55 ; starx/y relative to previous node
       fdb 51,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:396|rel:51)
; node # 8 D(15,68)->(16,49)
       fcb 2 ; drawmode 
       fcb -52,-12 ; starx/y relative to previous node
       fdb -153,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:243|rel:-153)
; node # 9 D(45,60)->(48,59)
       fcb 2 ; drawmode 
       fcb 8,30 ; starx/y relative to previous node
       fdb -231,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:12|rel:-231)
; node # 10 D(12,53)->(12,67)
       fcb 2 ; drawmode 
       fcb 7,-33 ; starx/y relative to previous node
       fdb -191,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:-179|rel:-191)
; node # 11 D(-35,55)->(-37,65)
       fcb 2 ; drawmode 
       fcb -2,-47 ; starx/y relative to previous node
       fdb 51,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-128|rel:51)
; node # 12 D(-40,64)->(-42,53)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 268,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:140|rel:268)
; node # 13 D(-68,15)->(-68,-3)
       fcb 2 ; drawmode 
       fcb 49,-28 ; starx/y relative to previous node
       fdb 90,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:230|rel:90)
; node # 14 D(-75,-14)->(-74,-12)
       fcb 2 ; drawmode 
       fcb 29,-7 ; starx/y relative to previous node
       fdb -255,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-25|rel:-255)
; node # 15 D(-54,11)->(-56,25)
       fcb 2 ; drawmode 
       fcb -25,21 ; starx/y relative to previous node
       fdb -154,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-179|rel:-154)
; node # 16 D(-19,-11)->(-19,9)
       fcb 2 ; drawmode 
       fcb 22,35 ; starx/y relative to previous node
       fdb -77,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-256|rel:-77)
; node # 17 D(19,11)->(19,31)
       fcb 2 ; drawmode 
       fcb -22,38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:0)
; node # 18 D(54,-12)->(53,2)
       fcb 2 ; drawmode 
       fcb 23,35 ; starx/y relative to previous node
       fdb 77,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-179|rel:77)
; node # 19 D(74,13)->(74,13)
       fcb 2 ; drawmode 
       fcb -25,20 ; starx/y relative to previous node
       fdb 179,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:179)
; node # 20 D(68,-16)->(66,-31)
       fcb 2 ; drawmode 
       fcb 29,-6 ; starx/y relative to previous node
       fdb 192,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:192|rel:192)
; node # 21 D(27,16)->(27,-15)
       fcb 2 ; drawmode 
       fcb -32,-41 ; starx/y relative to previous node
       fdb 204,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:396|rel:204)
; node # 22 M(15,68)->(16,49)
       fcb 0 ; drawmode 
       fcb -52,-12 ; starx/y relative to previous node
       fdb -153,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:243|rel:-153)
; node # 23 D(-40,64)->(-42,53)
       fcb 2 ; drawmode 
       fcb 4,-55 ; starx/y relative to previous node
       fdb -103,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:140|rel:-103)
; node # 24 M(-28,-17)->(-27,-44)
       fcb 0 ; drawmode 
       fcb 81,12 ; starx/y relative to previous node
       fdb 205,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:345|rel:205)
; node # 25 D(-68,15)->(-68,-3)
       fcb 2 ; drawmode 
       fcb -32,-40 ; starx/y relative to previous node
       fdb -115,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:230|rel:-115)
; node # 26 M(-35,55)->(-37,65)
       fcb 0 ; drawmode 
       fcb -40,33 ; starx/y relative to previous node
       fdb -358,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-128|rel:-358)
; node # 27 D(-54,11)->(-56,25)
       fcb 2 ; drawmode 
       fcb 44,-19 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-179|rel:-51)
; node # 28 M(-46,-60)->(-44,-53)
       fcb 0 ; drawmode 
       fcb 71,8 ; starx/y relative to previous node
       fdb 90,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:-89|rel:90)
; node # 29 D(-75,-14)->(-74,-12)
       fcb 2 ; drawmode 
       fcb -46,-29 ; starx/y relative to previous node
       fdb 64,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-25|rel:64)
; node # 30 M(-19,-11)->(-19,9)
       fcb 0 ; drawmode 
       fcb -3,56 ; starx/y relative to previous node
       fdb -231,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-256|rel:-231)
; node # 31 D(-12,-54)->(-12,-36)
       fcb 2 ; drawmode 
       fcb 43,7 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-230|rel:26)
; node # 32 M(19,11)->(19,31)
       fcb 0 ; drawmode 
       fcb -65,31 ; starx/y relative to previous node
       fdb -26,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-256|rel:-26)
; node # 33 D(12,53)->(12,67)
       fcb 2 ; drawmode 
       fcb -42,-7 ; starx/y relative to previous node
       fdb 77,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-179|rel:77)
; node # 34 M(54,-12)->(53,2)
       fcb 0 ; drawmode 
       fcb 65,42 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-179|rel:0)
; node # 35 D(34,-56)->(32,-42)
       fcb 2 ; drawmode 
       fcb 44,-20 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-179|rel:0)
; node # 36 M(74,13)->(74,13)
       fcb 0 ; drawmode 
       fcb -69,40 ; starx/y relative to previous node
       fdb 179,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:0|rel:179)
; node # 37 D(45,60)->(48,59)
       fcb 2 ; drawmode 
       fcb -47,-29 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:12|rel:12)
; node # 38 M(68,-16)->(66,-31)
       fcb 0 ; drawmode 
       fcb 76,23 ; starx/y relative to previous node
       fdb 180,-63 ; dx/dy. dx(abs:-25|rel:-63) dy(abs:192|rel:180)
; node # 39 D(39,-65)->(37,-66)
       fcb 2 ; drawmode 
       fcb 49,-29 ; starx/y relative to previous node
       fdb -180,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:12|rel:-180)
       fcb  1  ; end of anim
; Animation 14
dudelframe14:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-14,-75)->(-13,-73)
       fcb 0 ; drawmode 
       fcb 75,-14 ; starx/y relative to previous node
       fdb -25,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-25|rel:-25)
; node # 1 D(37,-66)->(34,-61)
       fcb 2 ; drawmode 
       fcb -9,51 ; starx/y relative to previous node
       fdb -39,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:-64|rel:-39)
; node # 2 D(32,-42)->(31,-25)
       fcb 2 ; drawmode 
       fcb -24,-5 ; starx/y relative to previous node
       fdb -153,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-217|rel:-153)
; node # 3 D(-12,-36)->(-11,-16)
       fcb 2 ; drawmode 
       fcb -6,-44 ; starx/y relative to previous node
       fdb -39,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-256|rel:-39)
; node # 4 D(-44,-53)->(-42,-42)
       fcb 2 ; drawmode 
       fcb 17,-32 ; starx/y relative to previous node
       fdb 116,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-140|rel:116)
; node # 5 D(-14,-75)->(-13,-73)
       fcb 2 ; drawmode 
       fcb 22,30 ; starx/y relative to previous node
       fdb 115,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-25|rel:115)
; node # 6 D(-27,-44)->(-26,-64)
       fcb 2 ; drawmode 
       fcb -31,-13 ; starx/y relative to previous node
       fdb 281,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:256|rel:281)
; node # 7 D(27,-15)->(26,-42)
       fcb 2 ; drawmode 
       fcb -29,54 ; starx/y relative to previous node
       fdb 89,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:345|rel:89)
; node # 8 D(16,49)->(16,22)
       fcb 2 ; drawmode 
       fcb -64,-11 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:345|rel:0)
; node # 9 D(48,59)->(51,50)
       fcb 2 ; drawmode 
       fcb -10,32 ; starx/y relative to previous node
       fdb -230,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:115|rel:-230)
; node # 10 D(12,67)->(13,74)
       fcb 2 ; drawmode 
       fcb -8,-36 ; starx/y relative to previous node
       fdb -204,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-89|rel:-204)
; node # 11 D(-37,65)->(-39,66)
       fcb 2 ; drawmode 
       fcb 2,-49 ; starx/y relative to previous node
       fdb 77,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-12|rel:77)
; node # 12 D(-42,53)->(-44,33)
       fcb 2 ; drawmode 
       fcb 12,-5 ; starx/y relative to previous node
       fdb 268,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:256|rel:268)
; node # 13 D(-68,-3)->(-68,-20)
       fcb 2 ; drawmode 
       fcb 56,-26 ; starx/y relative to previous node
       fdb -39,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:217|rel:-39)
; node # 14 D(-74,-12)->(-73,-10)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb -242,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-25|rel:-242)
; node # 15 D(-56,25)->(-57,35)
       fcb 2 ; drawmode 
       fcb -37,18 ; starx/y relative to previous node
       fdb -103,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-128|rel:-103)
; node # 16 D(-19,9)->(-20,29)
       fcb 2 ; drawmode 
       fcb 16,37 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-256|rel:-128)
; node # 17 D(19,31)->(19,49)
       fcb 2 ; drawmode 
       fcb -22,38 ; starx/y relative to previous node
       fdb 26,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-230|rel:26)
; node # 18 D(53,2)->(53,15)
       fcb 2 ; drawmode 
       fcb 29,34 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-166|rel:64)
; node # 19 D(74,13)->(75,10)
       fcb 2 ; drawmode 
       fcb -11,21 ; starx/y relative to previous node
       fdb 204,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:38|rel:204)
; node # 20 D(66,-31)->(64,-41)
       fcb 2 ; drawmode 
       fcb 44,-8 ; starx/y relative to previous node
       fdb 90,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:128|rel:90)
; node # 21 D(27,-15)->(26,-42)
       fcb 2 ; drawmode 
       fcb -16,-39 ; starx/y relative to previous node
       fdb 217,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:345|rel:217)
; node # 22 M(16,49)->(16,22)
       fcb 0 ; drawmode 
       fcb -64,-11 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:345|rel:0)
; node # 23 D(-42,53)->(-44,33)
       fcb 2 ; drawmode 
       fcb -4,-58 ; starx/y relative to previous node
       fdb -89,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:256|rel:-89)
; node # 24 M(-27,-44)->(-26,-64)
       fcb 0 ; drawmode 
       fcb 97,15 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:256|rel:0)
; node # 25 D(-68,-3)->(-68,-20)
       fcb 2 ; drawmode 
       fcb -41,-41 ; starx/y relative to previous node
       fdb -39,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:217|rel:-39)
; node # 26 M(-37,65)->(-39,66)
       fcb 0 ; drawmode 
       fcb -68,31 ; starx/y relative to previous node
       fdb -229,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-12|rel:-229)
; node # 27 D(-56,25)->(-57,35)
       fcb 2 ; drawmode 
       fcb 40,-19 ; starx/y relative to previous node
       fdb -116,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:-128|rel:-116)
; node # 28 M(-44,-53)->(-42,-42)
       fcb 0 ; drawmode 
       fcb 78,12 ; starx/y relative to previous node
       fdb -12,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:-140|rel:-12)
; node # 29 D(-74,-12)->(-73,-10)
       fcb 2 ; drawmode 
       fcb -41,-30 ; starx/y relative to previous node
       fdb 115,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-25|rel:115)
; node # 30 M(-19,9)->(-20,29)
       fcb 0 ; drawmode 
       fcb -21,55 ; starx/y relative to previous node
       fdb -231,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-256|rel:-231)
; node # 31 D(-12,-36)->(-11,-16)
       fcb 2 ; drawmode 
       fcb 45,7 ; starx/y relative to previous node
       fdb 0,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-256|rel:0)
; node # 32 M(19,31)->(19,49)
       fcb 0 ; drawmode 
       fcb -67,31 ; starx/y relative to previous node
       fdb 26,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-230|rel:26)
; node # 33 D(12,67)->(13,74)
       fcb 2 ; drawmode 
       fcb -36,-7 ; starx/y relative to previous node
       fdb 141,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-89|rel:141)
; node # 34 M(53,2)->(53,15)
       fcb 0 ; drawmode 
       fcb 65,41 ; starx/y relative to previous node
       fdb -77,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-166|rel:-77)
; node # 35 D(32,-42)->(31,-25)
       fcb 2 ; drawmode 
       fcb 44,-21 ; starx/y relative to previous node
       fdb -51,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-217|rel:-51)
; node # 36 M(74,13)->(75,10)
       fcb 0 ; drawmode 
       fcb -55,42 ; starx/y relative to previous node
       fdb 255,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:38|rel:255)
; node # 37 D(48,59)->(51,50)
       fcb 2 ; drawmode 
       fcb -46,-26 ; starx/y relative to previous node
       fdb 77,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:115|rel:77)
; node # 38 M(66,-31)->(64,-41)
       fcb 0 ; drawmode 
       fcb 90,18 ; starx/y relative to previous node
       fdb 13,-63 ; dx/dy. dx(abs:-25|rel:-63) dy(abs:128|rel:13)
; node # 39 D(37,-66)->(34,-61)
       fcb 2 ; drawmode 
       fcb 35,-29 ; starx/y relative to previous node
       fdb -192,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:-64|rel:-192)
       fcb  1  ; end of anim
; Animation 15
dudelframe15:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-13,-73)->(-12,-63)
       fcb 0 ; drawmode 
       fcb 73,-13 ; starx/y relative to previous node
       fdb -128,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-128|rel:-128)
; node # 1 D(34,-61)->(33,-49)
       fcb 2 ; drawmode 
       fcb -12,47 ; starx/y relative to previous node
       fdb -25,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-153|rel:-25)
; node # 2 D(31,-25)->(31,-6)
       fcb 2 ; drawmode 
       fcb -36,-3 ; starx/y relative to previous node
       fdb -90,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-243|rel:-90)
; node # 3 D(-11,-16)->(-11,6)
       fcb 2 ; drawmode 
       fcb -9,-42 ; starx/y relative to previous node
       fdb -38,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-281|rel:-38)
; node # 4 D(-42,-42)->(-40,-27)
       fcb 2 ; drawmode 
       fcb 26,-31 ; starx/y relative to previous node
       fdb 89,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-192|rel:89)
; node # 5 D(-13,-73)->(-12,-63)
       fcb 2 ; drawmode 
       fcb 31,29 ; starx/y relative to previous node
       fdb 64,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-128|rel:64)
; node # 6 D(-26,-64)->(-24,-72)
       fcb 2 ; drawmode 
       fcb -9,-13 ; starx/y relative to previous node
       fdb 230,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:102|rel:230)
; node # 7 D(26,-42)->(25,-63)
       fcb 2 ; drawmode 
       fcb -22,52 ; starx/y relative to previous node
       fdb 166,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:268|rel:166)
; node # 8 D(16,22)->(16,-10)
       fcb 2 ; drawmode 
       fcb -64,-10 ; starx/y relative to previous node
       fdb 141,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:409|rel:141)
; node # 9 D(51,50)->(52,35)
       fcb 2 ; drawmode 
       fcb -28,35 ; starx/y relative to previous node
       fdb -217,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:192|rel:-217)
; node # 10 D(13,74)->(14,73)
       fcb 2 ; drawmode 
       fcb -24,-38 ; starx/y relative to previous node
       fdb -180,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:12|rel:-180)
; node # 11 D(-39,66)->(-41,59)
       fcb 2 ; drawmode 
       fcb 8,-52 ; starx/y relative to previous node
       fdb 77,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:89|rel:77)
; node # 12 D(-44,33)->(-45,8)
       fcb 2 ; drawmode 
       fcb 33,-5 ; starx/y relative to previous node
       fdb 231,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:320|rel:231)
; node # 13 D(-68,-20)->(-66,-34)
       fcb 2 ; drawmode 
       fcb 53,-24 ; starx/y relative to previous node
       fdb -141,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:179|rel:-141)
; node # 14 D(-73,-10)->(-73,-7)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb -217,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-38|rel:-217)
; node # 15 D(-57,35)->(-59,43)
       fcb 2 ; drawmode 
       fcb -45,16 ; starx/y relative to previous node
       fdb -64,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-102|rel:-64)
; node # 16 D(-20,29)->(-20,48)
       fcb 2 ; drawmode 
       fcb 6,37 ; starx/y relative to previous node
       fdb -141,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-243|rel:-141)
; node # 17 D(19,49)->(20,64)
       fcb 2 ; drawmode 
       fcb -20,39 ; starx/y relative to previous node
       fdb 51,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-192|rel:51)
; node # 18 D(53,15)->(54,28)
       fcb 2 ; drawmode 
       fcb 34,34 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-166|rel:26)
; node # 19 D(75,10)->(76,6)
       fcb 2 ; drawmode 
       fcb 5,22 ; starx/y relative to previous node
       fdb 217,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:51|rel:217)
; node # 20 D(64,-41)->(61,-46)
       fcb 2 ; drawmode 
       fcb 51,-11 ; starx/y relative to previous node
       fdb 13,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:64|rel:13)
; node # 21 D(26,-42)->(25,-63)
       fcb 2 ; drawmode 
       fcb 1,-38 ; starx/y relative to previous node
       fdb 204,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:268|rel:204)
; node # 22 M(16,22)->(16,-10)
       fcb 0 ; drawmode 
       fcb -64,-10 ; starx/y relative to previous node
       fdb 141,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:409|rel:141)
; node # 23 D(-44,33)->(-45,8)
       fcb 2 ; drawmode 
       fcb -11,-60 ; starx/y relative to previous node
       fdb -89,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:320|rel:-89)
; node # 24 M(-26,-64)->(-24,-72)
       fcb 0 ; drawmode 
       fcb 97,18 ; starx/y relative to previous node
       fdb -218,37 ; dx/dy. dx(abs:25|rel:37) dy(abs:102|rel:-218)
; node # 25 D(-68,-20)->(-66,-34)
       fcb 2 ; drawmode 
       fcb -44,-42 ; starx/y relative to previous node
       fdb 77,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:179|rel:77)
; node # 26 M(-39,66)->(-41,59)
       fcb 0 ; drawmode 
       fcb -86,29 ; starx/y relative to previous node
       fdb -90,-50 ; dx/dy. dx(abs:-25|rel:-50) dy(abs:89|rel:-90)
; node # 27 D(-57,35)->(-59,43)
       fcb 2 ; drawmode 
       fcb 31,-18 ; starx/y relative to previous node
       fdb -191,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-102|rel:-191)
; node # 28 M(-42,-42)->(-40,-27)
       fcb 0 ; drawmode 
       fcb 77,15 ; starx/y relative to previous node
       fdb -90,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:-192|rel:-90)
; node # 29 D(-73,-10)->(-73,-7)
       fcb 2 ; drawmode 
       fcb -32,-31 ; starx/y relative to previous node
       fdb 154,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-38|rel:154)
; node # 30 M(-20,29)->(-20,48)
       fcb 0 ; drawmode 
       fcb -39,53 ; starx/y relative to previous node
       fdb -205,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-243|rel:-205)
; node # 31 D(-11,-16)->(-11,6)
       fcb 2 ; drawmode 
       fcb 45,9 ; starx/y relative to previous node
       fdb -38,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-281|rel:-38)
; node # 32 M(19,49)->(20,64)
       fcb 0 ; drawmode 
       fcb -65,30 ; starx/y relative to previous node
       fdb 89,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-192|rel:89)
; node # 33 D(13,74)->(14,73)
       fcb 2 ; drawmode 
       fcb -25,-6 ; starx/y relative to previous node
       fdb 204,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:12|rel:204)
; node # 34 M(53,15)->(54,28)
       fcb 0 ; drawmode 
       fcb 59,40 ; starx/y relative to previous node
       fdb -178,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-166|rel:-178)
; node # 35 D(31,-25)->(31,-6)
       fcb 2 ; drawmode 
       fcb 40,-22 ; starx/y relative to previous node
       fdb -77,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-243|rel:-77)
; node # 36 M(75,10)->(76,6)
       fcb 0 ; drawmode 
       fcb -35,44 ; starx/y relative to previous node
       fdb 294,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:51|rel:294)
; node # 37 D(51,50)->(52,35)
       fcb 2 ; drawmode 
       fcb -40,-24 ; starx/y relative to previous node
       fdb 141,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:192|rel:141)
; node # 38 M(64,-41)->(61,-46)
       fcb 0 ; drawmode 
       fcb 91,13 ; starx/y relative to previous node
       fdb -128,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:64|rel:-128)
; node # 39 D(34,-61)->(33,-49)
       fcb 2 ; drawmode 
       fcb 20,-30 ; starx/y relative to previous node
       fdb -217,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-153|rel:-217)
       fcb  1  ; end of anim
; Animation 16
dudelframe16:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-12,-63)->(-12,-47)
       fcb 0 ; drawmode 
       fcb 63,-12 ; starx/y relative to previous node
       fdb -204,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-204|rel:-204)
; node # 1 D(33,-49)->(31,-33)
       fcb 2 ; drawmode 
       fcb -14,45 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-204|rel:0)
; node # 2 D(31,-6)->(31,13)
       fcb 2 ; drawmode 
       fcb -43,-2 ; starx/y relative to previous node
       fdb -39,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-243|rel:-39)
; node # 3 D(-11,6)->(-11,27)
       fcb 2 ; drawmode 
       fcb -12,-42 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-268|rel:-25)
; node # 4 D(-40,-27)->(-40,-9)
       fcb 2 ; drawmode 
       fcb 33,-29 ; starx/y relative to previous node
       fdb 38,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-230|rel:38)
; node # 5 D(-12,-63)->(-12,-47)
       fcb 2 ; drawmode 
       fcb 36,28 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-204|rel:26)
; node # 6 D(-24,-72)->(-22,-72)
       fcb 2 ; drawmode 
       fcb 9,-12 ; starx/y relative to previous node
       fdb 204,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:0|rel:204)
; node # 7 D(25,-63)->(24,-72)
       fcb 2 ; drawmode 
       fcb -9,49 ; starx/y relative to previous node
       fdb 115,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:115|rel:115)
; node # 8 D(16,-10)->(16,-40)
       fcb 2 ; drawmode 
       fcb -53,-9 ; starx/y relative to previous node
       fdb 269,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:384|rel:269)
; node # 9 D(52,35)->(54,12)
       fcb 2 ; drawmode 
       fcb -45,36 ; starx/y relative to previous node
       fdb -90,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:294|rel:-90)
; node # 10 D(14,73)->(14,61)
       fcb 2 ; drawmode 
       fcb -38,-38 ; starx/y relative to previous node
       fdb -141,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:153|rel:-141)
; node # 11 D(-41,59)->(-42,43)
       fcb 2 ; drawmode 
       fcb 14,-55 ; starx/y relative to previous node
       fdb 51,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:204|rel:51)
; node # 12 D(-45,8)->(-44,-19)
       fcb 2 ; drawmode 
       fcb 51,-4 ; starx/y relative to previous node
       fdb 141,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:345|rel:141)
; node # 13 D(-66,-34)->(-64,-43)
       fcb 2 ; drawmode 
       fcb 42,-21 ; starx/y relative to previous node
       fdb -230,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:115|rel:-230)
; node # 14 D(-73,-7)->(-72,-2)
       fcb 2 ; drawmode 
       fcb -27,-7 ; starx/y relative to previous node
       fdb -179,-13 ; dx/dy. dx(abs:12|rel:-13) dy(abs:-64|rel:-179)
; node # 15 D(-59,43)->(-61,45)
       fcb 2 ; drawmode 
       fcb -50,14 ; starx/y relative to previous node
       fdb 39,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-25|rel:39)
; node # 16 D(-20,48)->(-22,62)
       fcb 2 ; drawmode 
       fcb -5,39 ; starx/y relative to previous node
       fdb -154,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-179|rel:-154)
; node # 17 D(20,64)->(21,71)
       fcb 2 ; drawmode 
       fcb -16,40 ; starx/y relative to previous node
       fdb 90,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:-89|rel:90)
; node # 18 D(54,28)->(57,38)
       fcb 2 ; drawmode 
       fcb 36,34 ; starx/y relative to previous node
       fdb -39,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:-128|rel:-39)
; node # 19 D(76,6)->(77,2)
       fcb 2 ; drawmode 
       fcb 22,22 ; starx/y relative to previous node
       fdb 179,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:51|rel:179)
; node # 20 D(61,-46)->(58,-45)
       fcb 2 ; drawmode 
       fcb 52,-15 ; starx/y relative to previous node
       fdb -63,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:-12|rel:-63)
; node # 21 D(25,-63)->(24,-72)
       fcb 2 ; drawmode 
       fcb 17,-36 ; starx/y relative to previous node
       fdb 127,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:115|rel:127)
; node # 22 M(16,-10)->(16,-40)
       fcb 0 ; drawmode 
       fcb -53,-9 ; starx/y relative to previous node
       fdb 269,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:384|rel:269)
; node # 23 D(-45,8)->(-44,-19)
       fcb 2 ; drawmode 
       fcb -18,-61 ; starx/y relative to previous node
       fdb -39,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:345|rel:-39)
; node # 24 M(-24,-72)->(-22,-72)
       fcb 0 ; drawmode 
       fcb 80,21 ; starx/y relative to previous node
       fdb -345,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:0|rel:-345)
; node # 25 D(-66,-34)->(-64,-43)
       fcb 2 ; drawmode 
       fcb -38,-42 ; starx/y relative to previous node
       fdb 115,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:115|rel:115)
; node # 26 M(-41,59)->(-42,43)
       fcb 0 ; drawmode 
       fcb -93,25 ; starx/y relative to previous node
       fdb 89,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:204|rel:89)
; node # 27 D(-59,43)->(-61,45)
       fcb 2 ; drawmode 
       fcb 16,-18 ; starx/y relative to previous node
       fdb -229,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-25|rel:-229)
; node # 28 M(-40,-27)->(-40,-9)
       fcb 0 ; drawmode 
       fcb 70,19 ; starx/y relative to previous node
       fdb -205,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-230|rel:-205)
; node # 29 D(-73,-7)->(-72,-2)
       fcb 2 ; drawmode 
       fcb -20,-33 ; starx/y relative to previous node
       fdb 166,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-64|rel:166)
; node # 30 M(-20,48)->(-22,62)
       fcb 0 ; drawmode 
       fcb -55,53 ; starx/y relative to previous node
       fdb -115,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-179|rel:-115)
; node # 31 D(-11,6)->(-11,27)
       fcb 2 ; drawmode 
       fcb 42,9 ; starx/y relative to previous node
       fdb -89,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-268|rel:-89)
; node # 32 M(20,64)->(21,71)
       fcb 0 ; drawmode 
       fcb -58,31 ; starx/y relative to previous node
       fdb 179,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-89|rel:179)
; node # 33 D(14,73)->(15,61)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 242,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:153|rel:242)
; node # 34 M(54,28)->(57,38)
       fcb 0 ; drawmode 
       fcb 45,40 ; starx/y relative to previous node
       fdb -281,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:-128|rel:-281)
; node # 35 D(31,-6)->(31,13)
       fcb 2 ; drawmode 
       fcb 34,-23 ; starx/y relative to previous node
       fdb -115,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:-243|rel:-115)
; node # 36 M(76,6)->(77,2)
       fcb 0 ; drawmode 
       fcb -12,45 ; starx/y relative to previous node
       fdb 294,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:51|rel:294)
; node # 37 D(52,35)->(54,12)
       fcb 2 ; drawmode 
       fcb -29,-24 ; starx/y relative to previous node
       fdb 243,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:294|rel:243)
; node # 38 M(61,-46)->(58,-45)
       fcb 0 ; drawmode 
       fcb 81,9 ; starx/y relative to previous node
       fdb -306,-63 ; dx/dy. dx(abs:-38|rel:-63) dy(abs:-12|rel:-306)
; node # 39 D(33,-49)->(31,-33)
       fcb 2 ; drawmode 
       fcb 3,-28 ; starx/y relative to previous node
       fdb -192,13 ; dx/dy. dx(abs:-25|rel:13) dy(abs:-204|rel:-192)
       fcb  1  ; end of anim
; Animation 17
dudelframe17:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-12,-47)->(-11,-28)
       fcb 0 ; drawmode 
       fcb 47,-12 ; starx/y relative to previous node
       fdb -243,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-243|rel:-243)
; node # 1 D(31,-33)->(31,-14)
       fcb 2 ; drawmode 
       fcb -14,43 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-243|rel:0)
; node # 2 D(31,13)->(32,32)
       fcb 2 ; drawmode 
       fcb -46,0 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-243|rel:0)
; node # 3 D(-11,27)->(-12,47)
       fcb 2 ; drawmode 
       fcb -14,-42 ; starx/y relative to previous node
       fdb -13,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-256|rel:-13)
; node # 4 D(-40,-9)->(-40,9)
       fcb 2 ; drawmode 
       fcb 36,-29 ; starx/y relative to previous node
       fdb 26,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-230|rel:26)
; node # 5 D(-12,-47)->(-11,-28)
       fcb 2 ; drawmode 
       fcb 38,28 ; starx/y relative to previous node
       fdb -13,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-243|rel:-13)
; node # 6 D(-22,-72)->(-22,-63)
       fcb 2 ; drawmode 
       fcb 25,-10 ; starx/y relative to previous node
       fdb 128,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-115|rel:128)
; node # 7 D(24,-72)->(22,-72)
       fcb 2 ; drawmode 
       fcb 0,46 ; starx/y relative to previous node
       fdb 115,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:0|rel:115)
; node # 8 D(16,-40)->(15,-62)
       fcb 2 ; drawmode 
       fcb -32,-8 ; starx/y relative to previous node
       fdb 281,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:281|rel:281)
; node # 9 D(54,12)->(54,-12)
       fcb 2 ; drawmode 
       fcb -52,38 ; starx/y relative to previous node
       fdb 26,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:307|rel:26)
; node # 10 D(14,61)->(16,39)
       fcb 2 ; drawmode 
       fcb -49,-40 ; starx/y relative to previous node
       fdb -26,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:281|rel:-26)
; node # 11 D(-42,43)->(-44,19)
       fcb 2 ; drawmode 
       fcb 18,-56 ; starx/y relative to previous node
       fdb 26,-50 ; dx/dy. dx(abs:-25|rel:-50) dy(abs:307|rel:26)
; node # 12 D(-44,-19)->(-43,-43)
       fcb 2 ; drawmode 
       fcb 62,-2 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:307|rel:0)
; node # 13 D(-64,-43)->(-61,-46)
       fcb 2 ; drawmode 
       fcb 24,-20 ; starx/y relative to previous node
       fdb -269,26 ; dx/dy. dx(abs:38|rel:26) dy(abs:38|rel:-269)
; node # 14 D(-72,-2)->(-72,2)
       fcb 2 ; drawmode 
       fcb -41,-8 ; starx/y relative to previous node
       fdb -89,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:-51|rel:-89)
; node # 15 D(-61,45)->(-64,42)
       fcb 2 ; drawmode 
       fcb -47,11 ; starx/y relative to previous node
       fdb 89,-38 ; dx/dy. dx(abs:-38|rel:-38) dy(abs:38|rel:89)
; node # 16 D(-22,62)->(-22,71)
       fcb 2 ; drawmode 
       fcb -17,39 ; starx/y relative to previous node
       fdb -153,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-115|rel:-153)
; node # 17 D(21,71)->(24,72)
       fcb 2 ; drawmode 
       fcb -9,43 ; starx/y relative to previous node
       fdb 103,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:-12|rel:103)
; node # 18 D(57,38)->(58,44)
       fcb 2 ; drawmode 
       fcb 33,36 ; starx/y relative to previous node
       fdb -64,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-76|rel:-64)
; node # 19 D(77,2)->(76,-2)
       fcb 2 ; drawmode 
       fcb 36,20 ; starx/y relative to previous node
       fdb 127,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:51|rel:127)
; node # 20 D(58,-45)->(56,-39)
       fcb 2 ; drawmode 
       fcb 47,-19 ; starx/y relative to previous node
       fdb -127,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-76|rel:-127)
; node # 21 D(24,-72)->(22,-72)
       fcb 2 ; drawmode 
       fcb 27,-34 ; starx/y relative to previous node
       fdb 76,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:0|rel:76)
; node # 22 M(16,-40)->(15,-62)
       fcb 0 ; drawmode 
       fcb -32,-8 ; starx/y relative to previous node
       fdb 281,13 ; dx/dy. dx(abs:-12|rel:13) dy(abs:281|rel:281)
; node # 23 D(-44,-19)->(-43,-43)
       fcb 2 ; drawmode 
       fcb -21,-60 ; starx/y relative to previous node
       fdb 26,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:307|rel:26)
; node # 24 M(-22,-72)->(-22,-63)
       fcb 0 ; drawmode 
       fcb 53,22 ; starx/y relative to previous node
       fdb -422,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-115|rel:-422)
; node # 25 D(-64,-43)->(-61,-46)
       fcb 2 ; drawmode 
       fcb -29,-42 ; starx/y relative to previous node
       fdb 153,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:38|rel:153)
; node # 26 M(-42,43)->(-44,19)
       fcb 0 ; drawmode 
       fcb -86,22 ; starx/y relative to previous node
       fdb 269,-63 ; dx/dy. dx(abs:-25|rel:-63) dy(abs:307|rel:269)
; node # 27 D(-61,45)->(-64,42)
       fcb 2 ; drawmode 
       fcb -2,-19 ; starx/y relative to previous node
       fdb -269,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:38|rel:-269)
; node # 28 M(-40,-9)->(-40,9)
       fcb 0 ; drawmode 
       fcb 54,21 ; starx/y relative to previous node
       fdb -268,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:-230|rel:-268)
; node # 29 D(-72,-2)->(-72,2)
       fcb 2 ; drawmode 
       fcb -7,-32 ; starx/y relative to previous node
       fdb 179,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-51|rel:179)
; node # 30 M(-22,62)->(-22,71)
       fcb 0 ; drawmode 
       fcb -64,50 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-115|rel:-64)
; node # 31 D(-11,27)->(-12,47)
       fcb 2 ; drawmode 
       fcb 35,11 ; starx/y relative to previous node
       fdb -141,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-256|rel:-141)
; node # 32 M(21,71)->(24,72)
       fcb 0 ; drawmode 
       fcb -44,32 ; starx/y relative to previous node
       fdb 244,50 ; dx/dy. dx(abs:38|rel:50) dy(abs:-12|rel:244)
; node # 33 D(15,61)->(16,39)
       fcb 2 ; drawmode 
       fcb 10,-6 ; starx/y relative to previous node
       fdb 293,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:281|rel:293)
; node # 34 M(57,38)->(58,44)
       fcb 0 ; drawmode 
       fcb 23,42 ; starx/y relative to previous node
       fdb -357,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-76|rel:-357)
; node # 35 D(31,13)->(31,32)
       fcb 2 ; drawmode 
       fcb 25,-26 ; starx/y relative to previous node
       fdb -167,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-243|rel:-167)
; node # 36 M(77,2)->(76,-2)
       fcb 0 ; drawmode 
       fcb 11,46 ; starx/y relative to previous node
       fdb 294,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:51|rel:294)
; node # 37 D(54,12)->(54,-12)
       fcb 2 ; drawmode 
       fcb -10,-23 ; starx/y relative to previous node
       fdb 256,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:307|rel:256)
; node # 38 M(58,-45)->(56,-39)
       fcb 0 ; drawmode 
       fcb 57,4 ; starx/y relative to previous node
       fdb -383,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-76|rel:-383)
; node # 39 D(31,-33)->(31,-14)
       fcb 2 ; drawmode 
       fcb -12,-27 ; starx/y relative to previous node
       fdb -167,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-243|rel:-167)
       fcb  1  ; end of anim
