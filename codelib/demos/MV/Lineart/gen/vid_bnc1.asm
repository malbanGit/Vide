bncintroframecount equ 1 ; number of animations
bncintroframetotal equ 64 ; total number of frames in animation 
; index table 
bncintroframetab        fdb bncintroframe0

; Animation 0
bncintroframe0:
       fcb 64 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(68,-102)->(18,0)
       fcb 0 ; drawmode 
       fcb 102,68 ; starx/y relative to previous node
       fdb -408,-200 ; dx/dy. dx(abs:-200|rel:-200) dy(abs:-408|rel:-408)
; node # 1 M(68,-102)->(18,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-200|rel:0) dy(abs:-408|rel:0)
; node # 2 D(68,-90)->(18,17)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb -20,0 ; dx/dy. dx(abs:-200|rel:0) dy(abs:-428|rel:-20)
; node # 3 D(68,-78)->(18,34)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb -20,0 ; dx/dy. dx(abs:-200|rel:0) dy(abs:-448|rel:-20)
; node # 4 D(68,-60)->(18,52)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-200|rel:0) dy(abs:-448|rel:0)
; node # 5 D(69,-35)->(18,71)
       fcb 2 ; drawmode 
       fcb -25,1 ; starx/y relative to previous node
       fdb 24,-4 ; dx/dy. dx(abs:-204|rel:-4) dy(abs:-424|rel:24)
; node # 6 D(69,-14)->(18,93)
       fcb 2 ; drawmode 
       fcb -21,0 ; starx/y relative to previous node
       fdb -4,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:-428|rel:-4)
; node # 7 D(69,34)->(18,118)
       fcb 2 ; drawmode 
       fcb -48,0 ; starx/y relative to previous node
       fdb 92,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:-336|rel:92)
; node # 8 D(2,35)->(-28,97)
       fcb 2 ; drawmode 
       fcb -1,-67 ; starx/y relative to previous node
       fdb 88,84 ; dx/dy. dx(abs:-120|rel:84) dy(abs:-248|rel:88)
; node # 9 D(-68,35)->(-71,76)
       fcb 2 ; drawmode 
       fcb 0,-70 ; starx/y relative to previous node
       fdb 84,108 ; dx/dy. dx(abs:-12|rel:108) dy(abs:-164|rel:84)
; node # 10 D(-68,10)->(-71,58)
       fcb 2 ; drawmode 
       fcb 25,0 ; starx/y relative to previous node
       fdb -28,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-192|rel:-28)
; node # 11 D(-68,-16)->(-71,38)
       fcb 2 ; drawmode 
       fcb 26,0 ; starx/y relative to previous node
       fdb -24,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-216|rel:-24)
; node # 12 D(-68,-40)->(-71,18)
       fcb 2 ; drawmode 
       fcb 24,0 ; starx/y relative to previous node
       fdb -16,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-232|rel:-16)
; node # 13 D(-69,-61)->(-71,-2)
       fcb 2 ; drawmode 
       fcb 21,-1 ; starx/y relative to previous node
       fdb -4,4 ; dx/dy. dx(abs:-8|rel:4) dy(abs:-236|rel:-4)
; node # 14 D(-69,-102)->(-71,-23)
       fcb 2 ; drawmode 
       fcb 41,0 ; starx/y relative to previous node
       fdb -80,0 ; dx/dy. dx(abs:-8|rel:0) dy(abs:-316|rel:-80)
; node # 15 D(-1,-102)->(-28,-12)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb -44,-100 ; dx/dy. dx(abs:-108|rel:-100) dy(abs:-360|rel:-44)
; node # 16 D(68,-102)->(18,0)
       fcb 2 ; drawmode 
       fcb 0,69 ; starx/y relative to previous node
       fdb -48,-92 ; dx/dy. dx(abs:-200|rel:-92) dy(abs:-408|rel:-48)
; node # 17 D(68,-102)->(78,-23)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 92,240 ; dx/dy. dx(abs:40|rel:240) dy(abs:-316|rel:92)
; node # 18 D(68,-71)->(78,-6)
       fcb 2 ; drawmode 
       fcb -31,0 ; starx/y relative to previous node
       fdb 56,0 ; dx/dy. dx(abs:40|rel:0) dy(abs:-260|rel:56)
; node # 19 D(68,-52)->(78,10)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:40|rel:0) dy(abs:-248|rel:12)
; node # 20 D(69,-24)->(78,25)
       fcb 2 ; drawmode 
       fcb -28,1 ; starx/y relative to previous node
       fdb 52,-4 ; dx/dy. dx(abs:36|rel:-4) dy(abs:-196|rel:52)
; node # 21 D(69,-1)->(78,43)
       fcb 2 ; drawmode 
       fcb -23,0 ; starx/y relative to previous node
       fdb 20,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-176|rel:20)
; node # 22 D(69,13)->(78,60)
       fcb 2 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-188|rel:-12)
; node # 23 D(69,34)->(78,76)
       fcb 2 ; drawmode 
       fcb -21,0 ; starx/y relative to previous node
       fdb 20,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-168|rel:20)
; node # 24 D(69,34)->(18,118)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -168,-240 ; dx/dy. dx(abs:-204|rel:-240) dy(abs:-336|rel:-168)
; node # 25 M(69,-41)->(51,42)
       fcb 0 ; drawmode 
       fcb 75,0 ; starx/y relative to previous node
       fdb 4,132 ; dx/dy. dx(abs:-72|rel:132) dy(abs:-332|rel:4)
; node # 26 M(68,-102)->(78,-23)
       fcb 0 ; drawmode 
       fcb 61,-1 ; starx/y relative to previous node
       fdb 16,112 ; dx/dy. dx(abs:40|rel:112) dy(abs:-316|rel:16)
; node # 27 D(5,-102)->(35,-32)
       fcb 2 ; drawmode 
       fcb 0,-63 ; starx/y relative to previous node
       fdb 36,80 ; dx/dy. dx(abs:120|rel:80) dy(abs:-280|rel:36)
; node # 28 D(-69,-102)->(-2,-40)
       fcb 2 ; drawmode 
       fcb 0,-74 ; starx/y relative to previous node
       fdb 32,148 ; dx/dy. dx(abs:268|rel:148) dy(abs:-248|rel:32)
; node # 29 D(-69,-102)->(-71,-23)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -68,-276 ; dx/dy. dx(abs:-8|rel:-276) dy(abs:-316|rel:-68)
; node # 30 M(-30,-113)->(-30,-73)
       fcb 0 ; drawmode 
       fcb 11,39 ; starx/y relative to previous node
       fdb 156,8 ; dx/dy. dx(abs:0|rel:8) dy(abs:-160|rel:156)
; node # 31 M(0,-121)->(0,-121)
       fcb 0 ; drawmode 
       fcb 8,30 ; starx/y relative to previous node
       fdb 160,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:160)
; node # 32 D(0,-110)->(0,-110)
       fcb 2 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(17,-110)->(17,-110)
       fcb 2 ; drawmode 
       fcb 0,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(17,-121)->(17,-121)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(0,-121)->(0,-121)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
