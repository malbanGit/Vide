marchtransframecount equ 3 ; number of animations
marchtransframetotal equ 64 ; total number of frames in animation 
; index table 
marchtransframetab        fdb marchtransframe0
       fdb marchtransframe1
       fdb marchtransframe2

; Animation 0
marchtransframe0:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-32,29)->(-68,35)
       fcb 0 ; drawmode 
       fcb -29,-32 ; starx/y relative to previous node
       fdb -48,-288 ; dx/dy. dx(abs:-288|rel:-288) dy(abs:-48|rel:-48)
; node # 1 D(16,52)->(2,35)
       fcb 2 ; drawmode 
       fcb -23,48 ; starx/y relative to previous node
       fdb 184,176 ; dx/dy. dx(abs:-112|rel:176) dy(abs:136|rel:184)
; node # 2 D(68,77)->(68,34)
       fcb 2 ; drawmode 
       fcb -25,52 ; starx/y relative to previous node
       fdb 208,112 ; dx/dy. dx(abs:0|rel:112) dy(abs:344|rel:208)
; node # 3 D(80,38)->(68,-33)
       fcb 2 ; drawmode 
       fcb 39,12 ; starx/y relative to previous node
       fdb 224,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:568|rel:224)
; node # 4 D(91,-1)->(68,-102)
       fcb 2 ; drawmode 
       fcb 39,11 ; starx/y relative to previous node
       fdb 240,-88 ; dx/dy. dx(abs:-184|rel:-88) dy(abs:808|rel:240)
; switch intensity
       fcb 3
       fcb 0
; node # 5 D(45,-31)->(78,-92)
       fcb 2 ; drawmode 
       fcb 30,-46 ; starx/y relative to previous node
       fdb -320,448 ; dx/dy. dx(abs:264|rel:448) dy(abs:488|rel:-320)
; node # 6 D(-19,-71)->(88,-82)
       fcb 2 ; drawmode 
       fcb 40,-64 ; starx/y relative to previous node
       fdb -400,592 ; dx/dy. dx(abs:856|rel:592) dy(abs:88|rel:-400)
; switch intensity
       fcb 3
       fcb 127
; node # 7 M(-50,-121)->(67,-101)
       fcb 0 ; drawmode 
       fcb 50,-31 ; starx/y relative to previous node
       fdb -248,80 ; dx/dy. dx(abs:936|rel:80) dy(abs:-160|rel:-248)
; node # 8 D(-63,-51)->(5,-39)
       fcb 2 ; drawmode 
       fcb -70,-13 ; starx/y relative to previous node
       fdb 64,-392 ; dx/dy. dx(abs:544|rel:-392) dy(abs:-96|rel:64)
; node # 9 D(-75,19)->(-68,34)
       fcb 2 ; drawmode 
       fcb -70,-12 ; starx/y relative to previous node
       fdb -24,-488 ; dx/dy. dx(abs:56|rel:-488) dy(abs:-120|rel:-24)
; node # 10 M(-75,19)->(-68,34)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:56|rel:0) dy(abs:-120|rel:0)
; node # 11 D(-101,-26)->(-68,-39)
       fcb 2 ; drawmode 
       fcb 45,-26 ; starx/y relative to previous node
       fdb 224,208 ; dx/dy. dx(abs:264|rel:208) dy(abs:104|rel:224)
; node # 12 D(-125,-70)->(-69,-101)
       fcb 2 ; drawmode 
       fcb 44,-24 ; starx/y relative to previous node
       fdb 144,184 ; dx/dy. dx(abs:448|rel:184) dy(abs:248|rel:144)
; node # 13 D(-92,-92)->(-8,-101)
       fcb 2 ; drawmode 
       fcb 22,33 ; starx/y relative to previous node
       fdb -176,224 ; dx/dy. dx(abs:672|rel:224) dy(abs:72|rel:-176)
; node # 14 D(-50,-121)->(68,-102)
       fcb 2 ; drawmode 
       fcb 29,42 ; starx/y relative to previous node
       fdb -224,272 ; dx/dy. dx(abs:944|rel:272) dy(abs:-152|rel:-224)
; switch intensity
       fcb 3
       fcb 0
; node # 15 D(10,-42)->(78,-92)
       fcb 2 ; drawmode 
       fcb -79,60 ; starx/y relative to previous node
       fdb 552,-400 ; dx/dy. dx(abs:544|rel:-400) dy(abs:400|rel:552)
; switch intensity
       fcb 3
       fcb 127
; node # 16 M(91,-1)->(68,-102)
       fcb 0 ; drawmode 
       fcb -41,81 ; starx/y relative to previous node
       fdb 408,-728 ; dx/dy. dx(abs:-184|rel:-728) dy(abs:808|rel:408)
; node # 17 D(32,13)->(5,-39)
       fcb 2 ; drawmode 
       fcb -14,-59 ; starx/y relative to previous node
       fdb -392,-32 ; dx/dy. dx(abs:-216|rel:-32) dy(abs:416|rel:-392)
; node # 18 D(-33,29)->(-68,34)
       fcb 2 ; drawmode 
       fcb -16,-65 ; starx/y relative to previous node
       fdb -456,-64 ; dx/dy. dx(abs:-280|rel:-64) dy(abs:-40|rel:-456)
       fcb  1  ; end of anim
; Animation 1
marchtransframe1:
       fcb 16 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-68,35)->(-62,38)
       fcb 0 ; drawmode 
       fcb -35,-68 ; starx/y relative to previous node
       fdb -48,96 ; dx/dy. dx(abs:96|rel:96) dy(abs:-48|rel:-48)
; node # 1 D(0,34)->(5,38)
       fcb 2 ; drawmode 
       fcb 1,68 ; starx/y relative to previous node
       fdb -16,-16 ; dx/dy. dx(abs:80|rel:-16) dy(abs:-64|rel:-16)
; node # 2 D(68,34)->(72,37)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 16,-16 ; dx/dy. dx(abs:64|rel:-16) dy(abs:-48|rel:16)
; node # 3 D(68,-33)->(70,-32)
       fcb 2 ; drawmode 
       fcb 67,0 ; starx/y relative to previous node
       fdb 32,-32 ; dx/dy. dx(abs:32|rel:-32) dy(abs:-16|rel:32)
; node # 4 D(68,-102)->(68,-99)
       fcb 2 ; drawmode 
       fcb 69,0 ; starx/y relative to previous node
       fdb -32,-32 ; dx/dy. dx(abs:0|rel:-32) dy(abs:-48|rel:-32)
; node # 5 M(67,-101)->(63,-102)
       fcb 0 ; drawmode 
       fcb -1,-1 ; starx/y relative to previous node
       fdb 64,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:16|rel:64)
; node # 6 D(2,-36)->(-6,-36)
       fcb 2 ; drawmode 
       fcb -65,-65 ; starx/y relative to previous node
       fdb -16,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:0|rel:-16)
; node # 7 D(-68,34)->(-75,28)
       fcb 2 ; drawmode 
       fcb -70,-70 ; starx/y relative to previous node
       fdb 96,16 ; dx/dy. dx(abs:-112|rel:16) dy(abs:96|rel:96)
; node # 8 M(-68,34)->(-75,28)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-112|rel:0) dy(abs:96|rel:0)
; node # 9 D(-68,-34)->(-75,-39)
       fcb 2 ; drawmode 
       fcb 68,0 ; starx/y relative to previous node
       fdb -16,0 ; dx/dy. dx(abs:-112|rel:0) dy(abs:80|rel:-16)
; node # 10 D(-69,-100)->(-75,-105)
       fcb 2 ; drawmode 
       fcb 66,-1 ; starx/y relative to previous node
       fdb 0,16 ; dx/dy. dx(abs:-96|rel:16) dy(abs:80|rel:0)
; node # 11 D(0,-101)->(-15,-104)
       fcb 2 ; drawmode 
       fcb 1,69 ; starx/y relative to previous node
       fdb -32,-144 ; dx/dy. dx(abs:-240|rel:-144) dy(abs:48|rel:-32)
; node # 12 D(68,-102)->(63,-102)
       fcb 2 ; drawmode 
       fcb 1,68 ; starx/y relative to previous node
       fdb -48,160 ; dx/dy. dx(abs:-80|rel:160) dy(abs:0|rel:-48)
; node # 13 M(68,-102)->(68,-99)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -48,80 ; dx/dy. dx(abs:0|rel:80) dy(abs:-48|rel:-48)
; node # 14 D(2,-36)->(6,-32)
       fcb 2 ; drawmode 
       fcb -66,-66 ; starx/y relative to previous node
       fdb -16,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-64|rel:-16)
; node # 15 D(-68,34)->(-62,38)
       fcb 2 ; drawmode 
       fcb -70,-70 ; starx/y relative to previous node
       fdb 0,32 ; dx/dy. dx(abs:96|rel:32) dy(abs:-64|rel:0)
       fcb  1  ; end of anim
; Animation 2
marchtransframe2:
       fcb 16 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-62,38)->(-68,35)
       fcb 0 ; drawmode 
       fcb -38,-62 ; starx/y relative to previous node
       fdb 48,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:48|rel:48)
; node # 1 D(6,37)->(1,34)
       fcb 2 ; drawmode 
       fcb 1,68 ; starx/y relative to previous node
       fdb 0,16 ; dx/dy. dx(abs:-80|rel:16) dy(abs:48|rel:0)
; node # 2 D(72,37)->(68,34)
       fcb 2 ; drawmode 
       fcb 0,66 ; starx/y relative to previous node
       fdb 0,16 ; dx/dy. dx(abs:-64|rel:16) dy(abs:48|rel:0)
; node # 3 D(70,-28)->(68,-37)
       fcb 2 ; drawmode 
       fcb 65,-2 ; starx/y relative to previous node
       fdb 96,32 ; dx/dy. dx(abs:-32|rel:32) dy(abs:144|rel:96)
; node # 4 D(68,-99)->(68,-102)
       fcb 2 ; drawmode 
       fcb 71,-2 ; starx/y relative to previous node
       fdb -96,32 ; dx/dy. dx(abs:0|rel:32) dy(abs:48|rel:-96)
; node # 5 M(63,-102)->(68,-102)
       fcb 0 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb -48,80 ; dx/dy. dx(abs:80|rel:80) dy(abs:0|rel:-48)
; node # 6 D(-6,-36)->(6,-39)
       fcb 2 ; drawmode 
       fcb -66,-69 ; starx/y relative to previous node
       fdb 48,112 ; dx/dy. dx(abs:192|rel:112) dy(abs:48|rel:48)
; node # 7 D(-75,28)->(-68,35)
       fcb 2 ; drawmode 
       fcb -64,-69 ; starx/y relative to previous node
       fdb -160,-80 ; dx/dy. dx(abs:112|rel:-80) dy(abs:-112|rel:-160)
; node # 8 M(-75,28)->(-68,35)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:112|rel:0) dy(abs:-112|rel:0)
; node # 9 D(-75,-40)->(-68,-34)
       fcb 2 ; drawmode 
       fcb 68,0 ; starx/y relative to previous node
       fdb 16,0 ; dx/dy. dx(abs:112|rel:0) dy(abs:-96|rel:16)
; node # 10 D(-75,-105)->(-68,-102)
       fcb 2 ; drawmode 
       fcb 65,0 ; starx/y relative to previous node
       fdb 48,0 ; dx/dy. dx(abs:112|rel:0) dy(abs:-48|rel:48)
; node # 11 D(-2,-103)->(0,-102)
       fcb 2 ; drawmode 
       fcb -2,73 ; starx/y relative to previous node
       fdb 32,-80 ; dx/dy. dx(abs:32|rel:-80) dy(abs:-16|rel:32)
; node # 12 D(63,-102)->(68,-102)
       fcb 2 ; drawmode 
       fcb -1,65 ; starx/y relative to previous node
       fdb 16,48 ; dx/dy. dx(abs:80|rel:48) dy(abs:0|rel:16)
; node # 13 M(68,-99)->(68,-102)
       fcb 0 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 48,-80 ; dx/dy. dx(abs:0|rel:-80) dy(abs:48|rel:48)
; node # 14 D(7,-32)->(6,-40)
       fcb 2 ; drawmode 
       fcb -67,-61 ; starx/y relative to previous node
       fdb 80,-16 ; dx/dy. dx(abs:-16|rel:-16) dy(abs:128|rel:80)
; node # 15 D(-61,38)->(-68,35)
       fcb 2 ; drawmode 
       fcb -70,-68 ; starx/y relative to previous node
       fdb -80,-96 ; dx/dy. dx(abs:-112|rel:-96) dy(abs:48|rel:-80)
       fcb  1  ; end of anim
