tunnelframecount EQU 2 ; number of animations
; index table 
tunnelframetab        fdb tunnelframe0
       fdb tunnelframe1

; Animation 0
tunnelframe0:
       fcb 32 ; Duration
       fcb 170 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(-7,-7)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 56,-56 ; dx/dy. dx(abs:-56|rel:-56) dy(abs:56|rel:56)
; node # 1 D(0,0)->(-10,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -56,-24 ; dx/dy. dx(abs:-80|rel:-24) dy(abs:0|rel:-56)
; node # 2 D(0,0)->(-7,7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -56,24 ; dx/dy. dx(abs:-56|rel:24) dy(abs:-56|rel:-56)
; node # 3 D(0,0)->(0,10)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -24,56 ; dx/dy. dx(abs:0|rel:56) dy(abs:-80|rel:-24)
; node # 4 D(0,0)->(7,7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 24,56 ; dx/dy. dx(abs:56|rel:56) dy(abs:-56|rel:24)
; node # 5 D(0,0)->(10,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 56,24 ; dx/dy. dx(abs:80|rel:24) dy(abs:0|rel:56)
; node # 6 D(0,0)->(7,-7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 56,-24 ; dx/dy. dx(abs:56|rel:-24) dy(abs:56|rel:56)
; node # 7 D(0,0)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 24,-56 ; dx/dy. dx(abs:0|rel:-56) dy(abs:80|rel:24)
; node # 8 D(0,0)->(-7,-7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -24,-56 ; dx/dy. dx(abs:-56|rel:-56) dy(abs:56|rel:-24)
; node # 9 M(-7,7)->(-35,-5)
       fcb 0 ; drawmode 
       fdb -1792,-1792 ; starx/y relative to previous node
       fdb 40,-168 ; dx/dy. dx(abs:-224|rel:-168) dy(abs:96|rel:40)
; node # 10 D(0,10)->(-27,17)
       fcb 2 ; drawmode 
       fdb -768,1792 ; starx/y relative to previous node
       fdb -152,8 ; dx/dy. dx(abs:-216|rel:8) dy(abs:-56|rel:-152)
; node # 11 D(7,7)->(-5,25)
       fcb 2 ; drawmode 
       fdb 768,1792 ; starx/y relative to previous node
       fdb -88,120 ; dx/dy. dx(abs:-96|rel:120) dy(abs:-144|rel:-88)
; node # 12 D(10,0)->(17,17)
       fcb 2 ; drawmode 
       fdb 1792,768 ; starx/y relative to previous node
       fdb 8,152 ; dx/dy. dx(abs:56|rel:152) dy(abs:-136|rel:8)
; node # 13 D(7,-7)->(25,-5)
       fcb 2 ; drawmode 
       fdb 1792,-768 ; starx/y relative to previous node
       fdb 120,88 ; dx/dy. dx(abs:144|rel:88) dy(abs:-16|rel:120)
; node # 14 D(0,-10)->(17,-27)
       fcb 2 ; drawmode 
       fdb 768,-1792 ; starx/y relative to previous node
       fdb 152,-8 ; dx/dy. dx(abs:136|rel:-8) dy(abs:136|rel:152)
; node # 15 D(-7,-7)->(-5,-35)
       fcb 2 ; drawmode 
       fdb -768,-1792 ; starx/y relative to previous node
       fdb 88,-120 ; dx/dy. dx(abs:16|rel:-120) dy(abs:224|rel:88)
; node # 16 D(-10,0)->(-27,-27)
       fcb 2 ; drawmode 
       fdb -1792,-768 ; starx/y relative to previous node
       fdb -8,-152 ; dx/dy. dx(abs:-136|rel:-152) dy(abs:216|rel:-8)
; node # 17 D(-7,7)->(-35,-5)
       fcb 2 ; drawmode 
       fdb -1792,768 ; starx/y relative to previous node
       fdb -120,-88 ; dx/dy. dx(abs:-224|rel:-88) dy(abs:96|rel:-120)
; node # 18 M(-22,22)->(-59,5)
       fcb 0 ; drawmode 
       fdb -3840,-3840 ; starx/y relative to previous node
       fdb 40,-72 ; dx/dy. dx(abs:-296|rel:-72) dy(abs:136|rel:40)
; node # 19 D(0,30)->(-40,55)
       fcb 2 ; drawmode 
       fdb -2048,5632 ; starx/y relative to previous node
       fdb -336,-24 ; dx/dy. dx(abs:-320|rel:-24) dy(abs:-200|rel:-336)
; node # 20 D(22,22)->(10,75)
       fcb 2 ; drawmode 
       fdb 2048,5632 ; starx/y relative to previous node
       fdb -224,224 ; dx/dy. dx(abs:-96|rel:224) dy(abs:-424|rel:-224)
; node # 21 D(30,0)->(60,55)
       fcb 2 ; drawmode 
       fdb 5632,2048 ; starx/y relative to previous node
       fdb -16,336 ; dx/dy. dx(abs:240|rel:336) dy(abs:-440|rel:-16)
; node # 22 D(22,-22)->(80,4)
       fcb 2 ; drawmode 
       fdb 5632,-2048 ; starx/y relative to previous node
       fdb 232,224 ; dx/dy. dx(abs:464|rel:224) dy(abs:-208|rel:232)
; node # 23 D(0,-30)->(60,-45)
       fcb 2 ; drawmode 
       fdb 2048,-5632 ; starx/y relative to previous node
       fdb 328,16 ; dx/dy. dx(abs:480|rel:16) dy(abs:120|rel:328)
; node # 24 D(-22,-22)->(10,-65)
       fcb 2 ; drawmode 
       fdb -2048,-5632 ; starx/y relative to previous node
       fdb 224,-224 ; dx/dy. dx(abs:256|rel:-224) dy(abs:344|rel:224)
; node # 25 D(-30,0)->(-40,-44)
       fcb 2 ; drawmode 
       fdb -5632,-2048 ; starx/y relative to previous node
       fdb 8,-336 ; dx/dy. dx(abs:-80|rel:-336) dy(abs:352|rel:8)
; node # 26 D(-22,22)->(-59,5)
       fcb 2 ; drawmode 
       fdb -5632,2048 ; starx/y relative to previous node
       fdb -216,-216 ; dx/dy. dx(abs:-296|rel:-216) dy(abs:136|rel:-216)
; node # 27 M(-50,50)->(-127,0)
       fcb 0 ; drawmode 
       fdb -7168,-7168 ; starx/y relative to previous node
       fdb 264,-320 ; dx/dy. dx(abs:-616|rel:-320) dy(abs:400|rel:264)
; node # 28 DM(0,70)->(-90,90)
       fcb -1 ; drawmode 
       fdb -5120,12800 ; starx/y relative to previous node
       fdb -560,-104 ; dx/dy. dx(abs:-720|rel:-104) dy(abs:-160|rel:-560)
; node # 29 DM(50,50)->(0,127)
       fcb -1 ; drawmode 
       fdb 5120,12800 ; starx/y relative to previous node
       fdb -456,320 ; dx/dy. dx(abs:-400|rel:320) dy(abs:-616|rel:-456)
; node # 30 DM(70,0)->(90,90)
       fcb -1 ; drawmode 
       fdb 12800,5120 ; starx/y relative to previous node
       fdb -104,560 ; dx/dy. dx(abs:160|rel:560) dy(abs:-720|rel:-104)
; node # 31 DM(50,-50)->(127,0)
       fcb -1 ; drawmode 
       fdb 12800,-5120 ; starx/y relative to previous node
       fdb 320,456 ; dx/dy. dx(abs:616|rel:456) dy(abs:-400|rel:320)
; node # 32 DM(0,-70)->(90,-90)
       fcb -1 ; drawmode 
       fdb 5120,-12800 ; starx/y relative to previous node
       fdb 560,104 ; dx/dy. dx(abs:720|rel:104) dy(abs:160|rel:560)
; node # 33 DM(-50,-50)->(0,-127)
       fcb -1 ; drawmode 
       fdb -5120,-12800 ; starx/y relative to previous node
       fdb 456,-320 ; dx/dy. dx(abs:400|rel:-320) dy(abs:616|rel:456)
; node # 34 DM(-70,0)->(-90,-90)
       fcb -1 ; drawmode 
       fdb -12800,-5120 ; starx/y relative to previous node
       fdb 104,-560 ; dx/dy. dx(abs:-160|rel:-560) dy(abs:720|rel:104)
; node # 35 DM(-50,50)->(-127,0)
       fcb -1 ; drawmode 
       fdb -12800,5120 ; starx/y relative to previous node
       fdb -320,-456 ; dx/dy. dx(abs:-616|rel:-456) dy(abs:400|rel:-320)
; node # 36 DM(-22,22)->(-59,5)
       fcb -1 ; drawmode 
       fdb 7168,7168 ; starx/y relative to previous node
       fdb -264,320 ; dx/dy. dx(abs:-296|rel:320) dy(abs:136|rel:-264)
; node # 37 D(-7,7)->(-35,-5)
       fcb 2 ; drawmode 
       fdb 3840,3840 ; starx/y relative to previous node
       fdb -40,72 ; dx/dy. dx(abs:-224|rel:72) dy(abs:96|rel:-40)
; node # 38 D(0,0)->(-9,-1)
       fcb 2 ; drawmode 
       fdb 1792,1792 ; starx/y relative to previous node
       fdb -88,152 ; dx/dy. dx(abs:-72|rel:152) dy(abs:8|rel:-88)
; node # 39 M(0,0)->(0,-10)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 72,72 ; dx/dy. dx(abs:0|rel:72) dy(abs:80|rel:72)
; node # 40 D(-7,-7)->(-5,-35)
       fcb 2 ; drawmode 
       fdb 1792,-1792 ; starx/y relative to previous node
       fdb 144,16 ; dx/dy. dx(abs:16|rel:16) dy(abs:224|rel:144)
; node # 41 D(-22,-22)->(10,-65)
       fcb 2 ; drawmode 
       fdb 3840,-3840 ; starx/y relative to previous node
       fdb 120,240 ; dx/dy. dx(abs:256|rel:240) dy(abs:344|rel:120)
; node # 42 DM(-50,-50)->(0,-127)
       fcb -1 ; drawmode 
       fdb 7168,-7168 ; starx/y relative to previous node
       fdb 272,144 ; dx/dy. dx(abs:400|rel:144) dy(abs:616|rel:272)
; node # 43 M(50,-50)->(127,0)
       fcb 0 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb -1016,216 ; dx/dy. dx(abs:616|rel:216) dy(abs:-400|rel:-1016)
; node # 44 DM(22,-22)->(80,4)
       fcb -1 ; drawmode 
       fdb -7168,-7168 ; starx/y relative to previous node
       fdb 192,-152 ; dx/dy. dx(abs:464|rel:-152) dy(abs:-208|rel:192)
; node # 45 D(7,-7)->(25,-5)
       fcb 2 ; drawmode 
       fdb -3840,-3840 ; starx/y relative to previous node
       fdb 192,-320 ; dx/dy. dx(abs:144|rel:-320) dy(abs:-16|rel:192)
; node # 46 D(0,0)->(10,0)
       fcb 2 ; drawmode 
       fdb -1792,-1792 ; starx/y relative to previous node
       fdb 16,-64 ; dx/dy. dx(abs:80|rel:-64) dy(abs:0|rel:16)
; node # 47 M(0,0)->(0,10)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -80,-80 ; dx/dy. dx(abs:0|rel:-80) dy(abs:-80|rel:-80)
; node # 48 D(7,7)->(-4,25)
       fcb 2 ; drawmode 
       fdb -1792,1792 ; starx/y relative to previous node
       fdb -64,-88 ; dx/dy. dx(abs:-88|rel:-88) dy(abs:-144|rel:-64)
; node # 49 D(22,22)->(10,75)
       fcb 2 ; drawmode 
       fdb -3840,3840 ; starx/y relative to previous node
       fdb -280,-8 ; dx/dy. dx(abs:-96|rel:-8) dy(abs:-424|rel:-280)
; node # 50 DM(50,50)->(0,127)
       fcb -1 ; drawmode 
       fdb -7168,7168 ; starx/y relative to previous node
       fdb -192,-304 ; dx/dy. dx(abs:-400|rel:-304) dy(abs:-616|rel:-192)
       fcb  1  ; end of anim
; Animation 1
tunnelframe1:
       fcb 32 ; Duration
       fcb 170 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,-10)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 80,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:80|rel:80)
; node # 1 D(0,0)->(7,-7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -24,56 ; dx/dy. dx(abs:56|rel:56) dy(abs:56|rel:-24)
; node # 2 D(0,0)->(10,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -56,24 ; dx/dy. dx(abs:80|rel:24) dy(abs:0|rel:-56)
; node # 3 D(0,0)->(7,7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -56,-24 ; dx/dy. dx(abs:56|rel:-24) dy(abs:-56|rel:-56)
; node # 4 D(0,0)->(0,10)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -24,-56 ; dx/dy. dx(abs:0|rel:-56) dy(abs:-80|rel:-24)
; node # 5 D(0,0)->(-7,7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 24,-56 ; dx/dy. dx(abs:-56|rel:-56) dy(abs:-56|rel:24)
; node # 6 D(0,0)->(-10,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 56,-24 ; dx/dy. dx(abs:-80|rel:-24) dy(abs:0|rel:56)
; node # 7 D(0,0)->(-7,-7)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 56,24 ; dx/dy. dx(abs:-56|rel:24) dy(abs:56|rel:56)
; node # 8 D(0,0)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 24,56 ; dx/dy. dx(abs:0|rel:56) dy(abs:80|rel:24)
; node # 9 M(-7,-7)->(0,-30)
       fcb 0 ; drawmode 
       fdb 1792,-1792 ; starx/y relative to previous node
       fdb 104,56 ; dx/dy. dx(abs:56|rel:56) dy(abs:184|rel:104)
; node # 10 D(-10,0)->(-22,-22)
       fcb 2 ; drawmode 
       fdb -1792,-768 ; starx/y relative to previous node
       fdb -8,-152 ; dx/dy. dx(abs:-96|rel:-152) dy(abs:176|rel:-8)
; node # 11 D(-7,7)->(-30,0)
       fcb 2 ; drawmode 
       fdb -1792,768 ; starx/y relative to previous node
       fdb -120,-88 ; dx/dy. dx(abs:-184|rel:-88) dy(abs:56|rel:-120)
; node # 12 D(0,10)->(-22,22)
       fcb 2 ; drawmode 
       fdb -768,1792 ; starx/y relative to previous node
       fdb -152,8 ; dx/dy. dx(abs:-176|rel:8) dy(abs:-96|rel:-152)
; node # 13 D(7,7)->(0,30)
       fcb 2 ; drawmode 
       fdb 768,1792 ; starx/y relative to previous node
       fdb -88,120 ; dx/dy. dx(abs:-56|rel:120) dy(abs:-184|rel:-88)
; node # 14 D(10,0)->(22,22)
       fcb 2 ; drawmode 
       fdb 1792,768 ; starx/y relative to previous node
       fdb 8,152 ; dx/dy. dx(abs:96|rel:152) dy(abs:-176|rel:8)
; node # 15 D(7,-7)->(30,0)
       fcb 2 ; drawmode 
       fdb 1792,-768 ; starx/y relative to previous node
       fdb 120,88 ; dx/dy. dx(abs:184|rel:88) dy(abs:-56|rel:120)
; node # 16 D(0,-10)->(22,-22)
       fcb 2 ; drawmode 
       fdb 768,-1792 ; starx/y relative to previous node
       fdb 152,-8 ; dx/dy. dx(abs:176|rel:-8) dy(abs:96|rel:152)
; node # 17 D(-7,-7)->(0,-30)
       fcb 2 ; drawmode 
       fdb -768,-1792 ; starx/y relative to previous node
       fdb 88,-120 ; dx/dy. dx(abs:56|rel:-120) dy(abs:184|rel:88)
; node # 18 M(-35,-5)->(-50,-50)
       fcb 0 ; drawmode 
       fdb -512,-7168 ; starx/y relative to previous node
       fdb 176,-176 ; dx/dy. dx(abs:-120|rel:-176) dy(abs:360|rel:176)
; node # 19 D(-27,17)->(-70,0)
       fcb 2 ; drawmode 
       fdb -5632,2048 ; starx/y relative to previous node
       fdb -224,-224 ; dx/dy. dx(abs:-344|rel:-224) dy(abs:136|rel:-224)
; node # 20 D(-5,25)->(-50,50)
       fcb 2 ; drawmode 
       fdb -2048,5632 ; starx/y relative to previous node
       fdb -336,-16 ; dx/dy. dx(abs:-360|rel:-16) dy(abs:-200|rel:-336)
; node # 21 D(17,17)->(0,70)
       fcb 2 ; drawmode 
       fdb 2048,5632 ; starx/y relative to previous node
       fdb -224,224 ; dx/dy. dx(abs:-136|rel:224) dy(abs:-424|rel:-224)
; node # 22 D(25,-5)->(50,50)
       fcb 2 ; drawmode 
       fdb 5632,2048 ; starx/y relative to previous node
       fdb -16,336 ; dx/dy. dx(abs:200|rel:336) dy(abs:-440|rel:-16)
; node # 23 D(17,-27)->(70,0)
       fcb 2 ; drawmode 
       fdb 5632,-2048 ; starx/y relative to previous node
       fdb 224,224 ; dx/dy. dx(abs:424|rel:224) dy(abs:-216|rel:224)
; node # 24 D(-5,-35)->(50,-50)
       fcb 2 ; drawmode 
       fdb 2048,-5632 ; starx/y relative to previous node
       fdb 336,16 ; dx/dy. dx(abs:440|rel:16) dy(abs:120|rel:336)
; node # 25 D(-27,-27)->(0,-70)
       fcb 2 ; drawmode 
       fdb -2048,-5632 ; starx/y relative to previous node
       fdb 224,-224 ; dx/dy. dx(abs:216|rel:-224) dy(abs:344|rel:224)
; node # 26 D(-35,-5)->(-50,-50)
       fcb 2 ; drawmode 
       fdb -5632,-2048 ; starx/y relative to previous node
       fdb 16,-336 ; dx/dy. dx(abs:-120|rel:-336) dy(abs:360|rel:16)
; node # 27 M(-59,5)->(-90,-90)
       fcb 0 ; drawmode 
       fdb -2560,-6144 ; starx/y relative to previous node
       fdb 400,-128 ; dx/dy. dx(abs:-248|rel:-128) dy(abs:760|rel:400)
; node # 28 DM(-40,55)->(-127,0)
       fcb -1 ; drawmode 
       fdb -12800,4864 ; starx/y relative to previous node
       fdb -320,-448 ; dx/dy. dx(abs:-696|rel:-448) dy(abs:440|rel:-320)
; node # 29 DM(10,75)->(-90,90)
       fcb -1 ; drawmode 
       fdb -5120,12800 ; starx/y relative to previous node
       fdb -560,-104 ; dx/dy. dx(abs:-800|rel:-104) dy(abs:-120|rel:-560)
; node # 30 DM(60,55)->(0,127)
       fcb -1 ; drawmode 
       fdb 5120,12800 ; starx/y relative to previous node
       fdb -456,320 ; dx/dy. dx(abs:-480|rel:320) dy(abs:-576|rel:-456)
; node # 31 DM(80,4)->(90,90)
       fcb -1 ; drawmode 
       fdb 13056,5120 ; starx/y relative to previous node
       fdb -112,560 ; dx/dy. dx(abs:80|rel:560) dy(abs:-688|rel:-112)
; node # 32 DM(60,-45)->(127,0)
       fcb -1 ; drawmode 
       fdb 12544,-5120 ; starx/y relative to previous node
       fdb 328,456 ; dx/dy. dx(abs:536|rel:456) dy(abs:-360|rel:328)
; node # 33 DM(10,-65)->(90,-90)
       fcb -1 ; drawmode 
       fdb 5120,-12800 ; starx/y relative to previous node
       fdb 560,104 ; dx/dy. dx(abs:640|rel:104) dy(abs:200|rel:560)
; node # 34 DM(-40,-44)->(0,-127)
       fcb -1 ; drawmode 
       fdb -5376,-12800 ; starx/y relative to previous node
       fdb 464,-320 ; dx/dy. dx(abs:320|rel:-320) dy(abs:664|rel:464)
; node # 35 DM(-59,5)->(-90,-90)
       fcb -1 ; drawmode 
       fdb -12544,-4864 ; starx/y relative to previous node
       fdb 96,-568 ; dx/dy. dx(abs:-248|rel:-568) dy(abs:760|rel:96)
; node # 36 M(0,-10)->(22,-22)
       fcb 0 ; drawmode 
       fdb 3840,15104 ; starx/y relative to previous node
       fdb -664,424 ; dx/dy. dx(abs:176|rel:424) dy(abs:96|rel:-664)
; node # 37 D(-5,-35)->(50,-50)
       fcb 2 ; drawmode 
       fdb 6400,-1280 ; starx/y relative to previous node
       fdb 24,264 ; dx/dy. dx(abs:440|rel:264) dy(abs:120|rel:24)
; node # 38 DM(10,-65)->(90,-90)
       fcb -1 ; drawmode 
       fdb 7680,3840 ; starx/y relative to previous node
       fdb 80,200 ; dx/dy. dx(abs:640|rel:200) dy(abs:200|rel:80)
; node # 39 M(42,-31)->(92,-1)
       fcb 0 ; drawmode 
       fdb -8704,8192 ; starx/y relative to previous node
       fdb -440,-240 ; dx/dy. dx(abs:400|rel:-240) dy(abs:-240|rel:-440)
; node # 40 M(80,4)->(90,90)
       fcb 0 ; drawmode 
       fdb -8960,9728 ; starx/y relative to previous node
       fdb -448,-320 ; dx/dy. dx(abs:80|rel:-320) dy(abs:-688|rel:-448)
; node # 41 DM(25,-5)->(50,50)
       fcb -1 ; drawmode 
       fdb 2304,-14080 ; starx/y relative to previous node
       fdb 248,120 ; dx/dy. dx(abs:200|rel:120) dy(abs:-440|rel:248)
; node # 42 D(10,0)->(22,22)
       fcb 2 ; drawmode 
       fdb -1280,-3840 ; starx/y relative to previous node
       fdb 264,-104 ; dx/dy. dx(abs:96|rel:-104) dy(abs:-176|rel:264)
; node # 43 D(0,0)->(7,7)
       fcb 2 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
       fdb 120,-40 ; dx/dy. dx(abs:56|rel:-40) dy(abs:-56|rel:120)
; node # 44 M(0,0)->(-6,7)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-104 ; dx/dy. dx(abs:-48|rel:-104) dy(abs:-56|rel:0)
; node # 45 D(0,10)->(-22,22)
       fcb 2 ; drawmode 
       fdb -2560,0 ; starx/y relative to previous node
       fdb -40,-128 ; dx/dy. dx(abs:-176|rel:-128) dy(abs:-96|rel:-40)
; node # 46 D(-4,24)->(-50,50)
       fcb 2 ; drawmode 
       fdb -3584,-1024 ; starx/y relative to previous node
       fdb -112,-192 ; dx/dy. dx(abs:-368|rel:-192) dy(abs:-208|rel:-112)
; node # 47 DM(10,75)->(-90,90)
       fcb -1 ; drawmode 
       fdb -13056,3584 ; starx/y relative to previous node
       fdb 88,-432 ; dx/dy. dx(abs:-800|rel:-432) dy(abs:-120|rel:88)
; node # 48 M(-30,38)->(-92,0)
       fcb 0 ; drawmode 
       fdb 9472,-10240 ; starx/y relative to previous node
       fdb 424,304 ; dx/dy. dx(abs:-496|rel:304) dy(abs:304|rel:424)
; node # 49 M(-59,5)->(-90,-90)
       fcb 0 ; drawmode 
       fdb 8448,-7424 ; starx/y relative to previous node
       fdb 456,248 ; dx/dy. dx(abs:-248|rel:248) dy(abs:760|rel:456)
; node # 50 DM(-35,-5)->(-50,-49)
       fcb -1 ; drawmode 
       fdb 2560,6144 ; starx/y relative to previous node
       fdb -408,128 ; dx/dy. dx(abs:-120|rel:128) dy(abs:352|rel:-408)
; node # 51 D(-10,0)->(-22,-22)
       fcb 2 ; drawmode 
       fdb -1280,6400 ; starx/y relative to previous node
       fdb -176,24 ; dx/dy. dx(abs:-96|rel:24) dy(abs:176|rel:-176)
; node # 52 D(0,0)->(-7,-7)
       fcb 2 ; drawmode 
       fdb 0,2560 ; starx/y relative to previous node
       fdb -120,40 ; dx/dy. dx(abs:-56|rel:40) dy(abs:56|rel:-120)
; node # 53 M(0,-1)->(6,-7)
       fcb 0 ; drawmode 
       fdb 256,0 ; starx/y relative to previous node
       fdb -8,104 ; dx/dy. dx(abs:48|rel:104) dy(abs:48|rel:-8)
; node # 54 D(0,-10)->(22,-22)
       fcb 2 ; drawmode 
       fdb 2304,0 ; starx/y relative to previous node
       fdb 48,128 ; dx/dy. dx(abs:176|rel:128) dy(abs:96|rel:48)
       fcb  1  ; end of anim
