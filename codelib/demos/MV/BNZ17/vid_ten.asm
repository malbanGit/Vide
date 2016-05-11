tentacleframecount EQU 2 ; number of animations
; index table 
tentacleframetab        fdb tentacleframe0
       fdb tentacleframe1

; Animation 0
tentacleframe0:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-25,0)->(-22,22)
       fcb 0 ; drawmode 
       fdb 0,-6400 ; starx/y relative to previous node
       fdb -176,24 ; dx/dy. dx(abs:24|rel:24) dy(abs:-176|rel:-176)
; node # 1 D(-17,17)->(0,30)
       fcb 2 ; drawmode 
       fdb -4352,2048 ; starx/y relative to previous node
       fdb 72,112 ; dx/dy. dx(abs:136|rel:112) dy(abs:-104|rel:72)
; node # 2 D(0,25)->(22,22)
       fcb 2 ; drawmode 
       fdb -2048,4352 ; starx/y relative to previous node
       fdb 128,40 ; dx/dy. dx(abs:176|rel:40) dy(abs:24|rel:128)
; node # 3 D(17,17)->(30,0)
       fcb 2 ; drawmode 
       fdb 2048,4352 ; starx/y relative to previous node
       fdb 112,-72 ; dx/dy. dx(abs:104|rel:-72) dy(abs:136|rel:112)
; node # 4 D(25,0)->(22,-22)
       fcb 2 ; drawmode 
       fdb 4352,2048 ; starx/y relative to previous node
       fdb 40,-128 ; dx/dy. dx(abs:-24|rel:-128) dy(abs:176|rel:40)
; node # 5 D(17,-17)->(0,-30)
       fcb 2 ; drawmode 
       fdb 4352,-2048 ; starx/y relative to previous node
       fdb -72,-112 ; dx/dy. dx(abs:-136|rel:-112) dy(abs:104|rel:-72)
; node # 6 D(0,-25)->(-22,-22)
       fcb 2 ; drawmode 
       fdb 2048,-4352 ; starx/y relative to previous node
       fdb -128,-40 ; dx/dy. dx(abs:-176|rel:-40) dy(abs:-24|rel:-128)
; node # 7 D(-17,-17)->(-30,0)
       fcb 2 ; drawmode 
       fdb -2048,-4352 ; starx/y relative to previous node
       fdb -112,72 ; dx/dy. dx(abs:-104|rel:72) dy(abs:-136|rel:-112)
; node # 8 D(-25,0)->(-22,22)
       fcb 2 ; drawmode 
       fdb -4352,-2048 ; starx/y relative to previous node
       fdb -40,128 ; dx/dy. dx(abs:24|rel:128) dy(abs:-176|rel:-40)
; node # 9 D(-40,0)->(-40,11)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb 88,-24 ; dx/dy. dx(abs:0|rel:-24) dy(abs:-88|rel:88)
; node # 10 D(-55,0)->(-40,25)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb -112,120 ; dx/dy. dx(abs:120|rel:120) dy(abs:-200|rel:-112)
; node # 11 D(-70,0)->(-30,35)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb -80,200 ; dx/dy. dx(abs:320|rel:200) dy(abs:-280|rel:-80)
; node # 12 D(-85,0)->(-15,35)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb 0,240 ; dx/dy. dx(abs:560|rel:240) dy(abs:-280|rel:0)
; node # 13 D(-100,0)->(-5,25)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb 80,200 ; dx/dy. dx(abs:760|rel:200) dy(abs:-200|rel:80)
; node # 14 D(-115,0)->(-4,10)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb 120,128 ; dx/dy. dx(abs:888|rel:128) dy(abs:-80|rel:120)
; node # 15 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 0,29440 ; starx/y relative to previous node
       fdb 80,-888 ; dx/dy. dx(abs:0|rel:-888) dy(abs:0|rel:80)
; node # 16 M(25,0)->(22,-22)
       fcb 0 ; drawmode 
       fdb 0,6400 ; starx/y relative to previous node
       fdb 176,-24 ; dx/dy. dx(abs:-24|rel:-24) dy(abs:176|rel:176)
; node # 17 D(40,0)->(40,-10)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb -96,24 ; dx/dy. dx(abs:0|rel:24) dy(abs:80|rel:-96)
; node # 18 D(55,0)->(40,-25)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb 120,-120 ; dx/dy. dx(abs:-120|rel:-120) dy(abs:200|rel:120)
; node # 19 D(70,0)->(30,-35)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb 80,-200 ; dx/dy. dx(abs:-320|rel:-200) dy(abs:280|rel:80)
; node # 20 D(85,0)->(15,-35)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb 0,-240 ; dx/dy. dx(abs:-560|rel:-240) dy(abs:280|rel:0)
; node # 21 D(100,0)->(5,-25)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb -80,-200 ; dx/dy. dx(abs:-760|rel:-200) dy(abs:200|rel:-80)
; node # 22 D(115,0)->(5,-10)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb -120,-120 ; dx/dy. dx(abs:-880|rel:-120) dy(abs:80|rel:-120)
; node # 23 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 0,-29440 ; starx/y relative to previous node
       fdb -80,880 ; dx/dy. dx(abs:0|rel:880) dy(abs:0|rel:-80)
; node # 24 M(0,-25)->(-22,-22)
       fcb 0 ; drawmode 
       fdb 6400,0 ; starx/y relative to previous node
       fdb -24,-176 ; dx/dy. dx(abs:-176|rel:-176) dy(abs:-24|rel:-24)
; node # 25 D(0,-40)->(-10,-40)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb 24,96 ; dx/dy. dx(abs:-80|rel:96) dy(abs:0|rel:24)
; node # 26 D(0,-55)->(-26,-41)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -112,-128 ; dx/dy. dx(abs:-208|rel:-128) dy(abs:-112|rel:-112)
; node # 27 D(0,-70)->(-35,-30)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -208,-72 ; dx/dy. dx(abs:-280|rel:-72) dy(abs:-320|rel:-208)
; node # 28 D(0,-85)->(-35,-15)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -240,0 ; dx/dy. dx(abs:-280|rel:0) dy(abs:-560|rel:-240)
; node # 29 D(0,-100)->(-25,-5)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -200,80 ; dx/dy. dx(abs:-200|rel:80) dy(abs:-760|rel:-200)
; node # 30 D(0,-115)->(-10,-5)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -120,120 ; dx/dy. dx(abs:-80|rel:120) dy(abs:-880|rel:-120)
; node # 31 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb -29440,0 ; starx/y relative to previous node
       fdb 880,80 ; dx/dy. dx(abs:0|rel:80) dy(abs:0|rel:880)
; node # 32 M(0,25)->(22,22)
       fcb 0 ; drawmode 
       fdb -6400,0 ; starx/y relative to previous node
       fdb 24,176 ; dx/dy. dx(abs:176|rel:176) dy(abs:24|rel:24)
; node # 33 D(0,40)->(10,40)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb -24,-96 ; dx/dy. dx(abs:80|rel:-96) dy(abs:0|rel:-24)
; node # 34 D(0,55)->(25,40)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 120,120 ; dx/dy. dx(abs:200|rel:120) dy(abs:120|rel:120)
; node # 35 D(0,70)->(35,30)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 200,80 ; dx/dy. dx(abs:280|rel:80) dy(abs:320|rel:200)
; node # 36 D(0,85)->(35,15)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 240,0 ; dx/dy. dx(abs:280|rel:0) dy(abs:560|rel:240)
; node # 37 D(0,100)->(25,5)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 200,-80 ; dx/dy. dx(abs:200|rel:-80) dy(abs:760|rel:200)
; node # 38 D(0,115)->(10,5)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 120,-120 ; dx/dy. dx(abs:80|rel:-120) dy(abs:880|rel:120)
; node # 39 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 29440,0 ; starx/y relative to previous node
       fdb -880,-80 ; dx/dy. dx(abs:0|rel:-80) dy(abs:0|rel:-880)
; node # 40 D(5,1)->(0,0)
       fcb 2 ; drawmode 
       fdb -256,1280 ; starx/y relative to previous node
       fdb 8,-40 ; dx/dy. dx(abs:-40|rel:-40) dy(abs:8|rel:8)
; node # 41 D(8,-3)->(0,0)
       fcb 2 ; drawmode 
       fdb 1024,768 ; starx/y relative to previous node
       fdb -32,-24 ; dx/dy. dx(abs:-64|rel:-24) dy(abs:-24|rel:-32)
; node # 42 D(3,-11)->(0,0)
       fcb 2 ; drawmode 
       fdb 2048,-1280 ; starx/y relative to previous node
       fdb -64,40 ; dx/dy. dx(abs:-24|rel:40) dy(abs:-88|rel:-64)
; node # 43 D(-5,-13)->(0,0)
       fcb 2 ; drawmode 
       fdb 512,-2048 ; starx/y relative to previous node
       fdb -16,64 ; dx/dy. dx(abs:40|rel:64) dy(abs:-104|rel:-16)
; node # 44 D(-12,-10)->(0,0)
       fcb 2 ; drawmode 
       fdb -768,-1792 ; starx/y relative to previous node
       fdb 24,56 ; dx/dy. dx(abs:96|rel:56) dy(abs:-80|rel:24)
; node # 45 D(-17,2)->(0,0)
       fcb 2 ; drawmode 
       fdb -3072,-1280 ; starx/y relative to previous node
       fdb 96,40 ; dx/dy. dx(abs:136|rel:40) dy(abs:16|rel:96)
       fcb  1  ; end of anim
; Animation 1
tentacleframe1:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-22,22)->(0,25)
       fcb 0 ; drawmode 
       fdb -5632,-5632 ; starx/y relative to previous node
       fdb -24,176 ; dx/dy. dx(abs:176|rel:176) dy(abs:-24|rel:-24)
; node # 1 D(0,30)->(17,17)
       fcb 2 ; drawmode 
       fdb -2048,5632 ; starx/y relative to previous node
       fdb 128,-40 ; dx/dy. dx(abs:136|rel:-40) dy(abs:104|rel:128)
; node # 2 D(22,22)->(25,0)
       fcb 2 ; drawmode 
       fdb 2048,5632 ; starx/y relative to previous node
       fdb 72,-112 ; dx/dy. dx(abs:24|rel:-112) dy(abs:176|rel:72)
; node # 3 D(30,0)->(17,-17)
       fcb 2 ; drawmode 
       fdb 5632,2048 ; starx/y relative to previous node
       fdb -40,-128 ; dx/dy. dx(abs:-104|rel:-128) dy(abs:136|rel:-40)
; node # 4 D(22,-22)->(0,-25)
       fcb 2 ; drawmode 
       fdb 5632,-2048 ; starx/y relative to previous node
       fdb -112,-72 ; dx/dy. dx(abs:-176|rel:-72) dy(abs:24|rel:-112)
; node # 5 D(0,-30)->(-17,-17)
       fcb 2 ; drawmode 
       fdb 2048,-5632 ; starx/y relative to previous node
       fdb -128,40 ; dx/dy. dx(abs:-136|rel:40) dy(abs:-104|rel:-128)
; node # 6 D(-22,-22)->(-25,0)
       fcb 2 ; drawmode 
       fdb -2048,-5632 ; starx/y relative to previous node
       fdb -72,112 ; dx/dy. dx(abs:-24|rel:112) dy(abs:-176|rel:-72)
; node # 7 D(-30,0)->(-17,17)
       fcb 2 ; drawmode 
       fdb -5632,-2048 ; starx/y relative to previous node
       fdb 40,128 ; dx/dy. dx(abs:104|rel:128) dy(abs:-136|rel:40)
; node # 8 D(-22,22)->(0,25)
       fcb 2 ; drawmode 
       fdb -5632,2048 ; starx/y relative to previous node
       fdb 112,72 ; dx/dy. dx(abs:176|rel:72) dy(abs:-24|rel:112)
; node # 9 D(-40,11)->(0,40)
       fcb 2 ; drawmode 
       fdb 2816,-4608 ; starx/y relative to previous node
       fdb -208,144 ; dx/dy. dx(abs:320|rel:144) dy(abs:-232|rel:-208)
; node # 10 D(-40,25)->(0,55)
       fcb 2 ; drawmode 
       fdb -3584,0 ; starx/y relative to previous node
       fdb -8,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:-240|rel:-8)
; node # 11 D(-30,35)->(0,70)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
       fdb -40,-80 ; dx/dy. dx(abs:240|rel:-80) dy(abs:-280|rel:-40)
; node # 12 D(-15,35)->(0,85)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb -120,-120 ; dx/dy. dx(abs:120|rel:-120) dy(abs:-400|rel:-120)
; node # 13 D(-5,25)->(0,100)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
       fdb -200,-80 ; dx/dy. dx(abs:40|rel:-80) dy(abs:-600|rel:-200)
; node # 14 D(-4,10)->(0,115)
       fcb 2 ; drawmode 
       fdb 3840,256 ; starx/y relative to previous node
       fdb -240,-8 ; dx/dy. dx(abs:32|rel:-8) dy(abs:-840|rel:-240)
; node # 15 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 2560,1024 ; starx/y relative to previous node
       fdb 840,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:0|rel:840)
; node # 16 M(22,-22)->(0,-25)
       fcb 0 ; drawmode 
       fdb 5632,5632 ; starx/y relative to previous node
       fdb 24,-176 ; dx/dy. dx(abs:-176|rel:-176) dy(abs:24|rel:24)
; node # 17 D(40,-10)->(0,-40)
       fcb 2 ; drawmode 
       fdb -3072,4608 ; starx/y relative to previous node
       fdb 216,-144 ; dx/dy. dx(abs:-320|rel:-144) dy(abs:240|rel:216)
; node # 18 D(40,-25)->(0,-55)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-320|rel:0) dy(abs:240|rel:0)
; node # 19 D(30,-35)->(0,-70)
       fcb 2 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb 40,80 ; dx/dy. dx(abs:-240|rel:80) dy(abs:280|rel:40)
; node # 20 D(15,-35)->(0,-85)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb 120,120 ; dx/dy. dx(abs:-120|rel:120) dy(abs:400|rel:120)
; node # 21 D(5,-25)->(0,-100)
       fcb 2 ; drawmode 
       fdb -2560,-2560 ; starx/y relative to previous node
       fdb 200,80 ; dx/dy. dx(abs:-40|rel:80) dy(abs:600|rel:200)
; node # 22 D(5,-10)->(0,-115)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 240,0 ; dx/dy. dx(abs:-40|rel:0) dy(abs:840|rel:240)
; node # 23 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb -2560,-1280 ; starx/y relative to previous node
       fdb -840,40 ; dx/dy. dx(abs:0|rel:40) dy(abs:0|rel:-840)
; node # 24 M(-22,-22)->(-25,0)
       fcb 0 ; drawmode 
       fdb 5632,-5632 ; starx/y relative to previous node
       fdb -176,-24 ; dx/dy. dx(abs:-24|rel:-24) dy(abs:-176|rel:-176)
; node # 25 D(-10,-40)->(-40,0)
       fcb 2 ; drawmode 
       fdb 4608,3072 ; starx/y relative to previous node
       fdb -144,-216 ; dx/dy. dx(abs:-240|rel:-216) dy(abs:-320|rel:-144)
; node # 26 D(-26,-41)->(-55,0)
       fcb 2 ; drawmode 
       fdb 256,-4096 ; starx/y relative to previous node
       fdb -8,8 ; dx/dy. dx(abs:-232|rel:8) dy(abs:-328|rel:-8)
; node # 27 D(-35,-30)->(-70,0)
       fcb 2 ; drawmode 
       fdb -2816,-2304 ; starx/y relative to previous node
       fdb 88,-48 ; dx/dy. dx(abs:-280|rel:-48) dy(abs:-240|rel:88)
; node # 28 D(-35,-15)->(-85,0)
       fcb 2 ; drawmode 
       fdb -3840,0 ; starx/y relative to previous node
       fdb 120,-120 ; dx/dy. dx(abs:-400|rel:-120) dy(abs:-120|rel:120)
; node # 29 D(-25,-5)->(-100,0)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
       fdb 80,-200 ; dx/dy. dx(abs:-600|rel:-200) dy(abs:-40|rel:80)
; node # 30 D(-10,-5)->(-115,0)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb 0,-240 ; dx/dy. dx(abs:-840|rel:-240) dy(abs:-40|rel:0)
; node # 31 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb -1280,2560 ; starx/y relative to previous node
       fdb 40,840 ; dx/dy. dx(abs:0|rel:840) dy(abs:0|rel:40)
; node # 32 M(22,22)->(25,0)
       fcb 0 ; drawmode 
       fdb -5632,5632 ; starx/y relative to previous node
       fdb 176,24 ; dx/dy. dx(abs:24|rel:24) dy(abs:176|rel:176)
; node # 33 D(10,40)->(40,0)
       fcb 2 ; drawmode 
       fdb -4608,-3072 ; starx/y relative to previous node
       fdb 144,216 ; dx/dy. dx(abs:240|rel:216) dy(abs:320|rel:144)
; node # 34 D(25,40)->(55,0)
       fcb 2 ; drawmode 
       fdb 0,3840 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:240|rel:0) dy(abs:320|rel:0)
; node # 35 D(35,30)->(70,0)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
       fdb -80,40 ; dx/dy. dx(abs:280|rel:40) dy(abs:240|rel:-80)
; node # 36 D(35,15)->(85,0)
       fcb 2 ; drawmode 
       fdb 3840,0 ; starx/y relative to previous node
       fdb -120,120 ; dx/dy. dx(abs:400|rel:120) dy(abs:120|rel:-120)
; node # 37 D(25,5)->(100,0)
       fcb 2 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb -80,200 ; dx/dy. dx(abs:600|rel:200) dy(abs:40|rel:-80)
; node # 38 D(10,5)->(115,0)
       fcb 2 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb 0,240 ; dx/dy. dx(abs:840|rel:240) dy(abs:40|rel:0)
; node # 39 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 1280,-2560 ; starx/y relative to previous node
       fdb -40,-840 ; dx/dy. dx(abs:0|rel:-840) dy(abs:0|rel:-40)
; node # 40 D(0,0)->(5,1)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -8,40 ; dx/dy. dx(abs:40|rel:40) dy(abs:-8|rel:-8)
; node # 41 D(0,0)->(8,-3)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 32,24 ; dx/dy. dx(abs:64|rel:24) dy(abs:24|rel:32)
; node # 42 D(0,0)->(3,-11)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 64,-40 ; dx/dy. dx(abs:24|rel:-40) dy(abs:88|rel:64)
; node # 43 D(0,0)->(-5,-13)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 16,-64 ; dx/dy. dx(abs:-40|rel:-64) dy(abs:104|rel:16)
; node # 44 D(0,0)->(-12,-10)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -24,-56 ; dx/dy. dx(abs:-96|rel:-56) dy(abs:80|rel:-24)
; node # 45 D(0,0)->(-17,2)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -96,-40 ; dx/dy. dx(abs:-136|rel:-40) dy(abs:-16|rel:-96)
       fcb  1  ; end of anim
