bncloopframecount equ 3 ; number of animations
bncloopframetotal equ 52 ; total number of frames in animation 
; index table 
bncloopframetab        fdb bncloopframe0
       fdb bncloopframe1
       fdb bncloopframe2

; Animation 0
bncloopframe0:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(18,0)->(18,0)
       fcb 0 ; drawmode 
       fcb 0,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(18,0)->(18,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(18,17)->(18,17)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(18,34)->(18,34)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(18,52)->(18,52)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(18,71)->(18,71)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(18,93)->(18,93)
       fcb 2 ; drawmode 
       fcb -22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(18,118)->(18,118)
       fcb 2 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-71,76)->(-71,76)
       fcb 2 ; drawmode 
       fcb 42,-89 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-71,58)->(-71,58)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(-71,38)->(-71,38)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-71,18)->(-71,18)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-71,-2)->(-71,-2)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-71,-23)->(-71,-23)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(18,0)->(18,0)
       fcb 2 ; drawmode 
       fcb -23,89 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(78,-23)->(78,-23)
       fcb 2 ; drawmode 
       fcb 23,60 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(78,-6)->(78,-6)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(78,10)->(78,10)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(78,25)->(78,25)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(78,43)->(78,43)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(78,60)->(78,60)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(78,76)->(78,76)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(18,118)->(18,118)
       fcb 2 ; drawmode 
       fcb -42,-60 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 M(51,42)->(51,42)
       fcb 0 ; drawmode 
       fcb 76,33 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 M(78,-23)->(78,-23)
       fcb 0 ; drawmode 
       fcb 65,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-2,-40)->(-2,-40)
       fcb 2 ; drawmode 
       fcb 17,-80 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-71,-23)->(-71,-23)
       fcb 2 ; drawmode 
       fcb -17,-69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 M(-30,-73)->(-26,-28)
       fcb 0 ; drawmode 
       fcb 50,41 ; starx/y relative to previous node
       fdb -768,68 ; dx/dy. dx(abs:68|rel:68) dy(abs:-768|rel:-768)
; node # 28 M(0,-121)->(0,-92)
       fcb 0 ; drawmode 
       fcb 48,30 ; starx/y relative to previous node
       fdb 274,-68 ; dx/dy. dx(abs:0|rel:-68) dy(abs:-494|rel:274)
; node # 29 D(0,-110)->(0,-80)
       fcb 2 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-512|rel:-18)
; node # 30 D(16,-110)->(16,-80)
       fcb 2 ; drawmode 
       fcb 0,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-512|rel:0)
; node # 31 D(16,-121)->(16,-92)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-494|rel:18)
; node # 32 D(0,-121)->(0,-92)
       fcb 2 ; drawmode 
       fcb 0,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-494|rel:0)
       fcb  1  ; end of anim
; Animation 1
bncloopframe1:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(18,0)->(18,0)
       fcb 0 ; drawmode 
       fcb 0,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(18,0)->(18,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(18,17)->(18,17)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(18,34)->(18,34)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(18,52)->(18,52)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(18,71)->(18,71)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(18,93)->(18,93)
       fcb 2 ; drawmode 
       fcb -22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(18,118)->(18,118)
       fcb 2 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-71,76)->(-71,76)
       fcb 2 ; drawmode 
       fcb 42,-89 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-71,58)->(-71,58)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(-71,38)->(-71,38)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-71,18)->(-71,18)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-71,-2)->(-71,-2)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-71,-23)->(-71,-23)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(18,0)->(18,0)
       fcb 2 ; drawmode 
       fcb -23,89 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(78,-23)->(78,-23)
       fcb 2 ; drawmode 
       fcb 23,60 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(78,-6)->(78,-6)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(78,10)->(78,10)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(78,25)->(78,25)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(78,43)->(78,43)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(78,60)->(78,60)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(78,76)->(78,76)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 D(18,118)->(18,118)
       fcb 2 ; drawmode 
       fcb -42,-60 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 M(51,42)->(51,42)
       fcb 0 ; drawmode 
       fcb 76,33 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 M(78,-23)->(78,-23)
       fcb 0 ; drawmode 
       fcb 65,27 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(-2,-40)->(-2,-40)
       fcb 2 ; drawmode 
       fcb 17,-80 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(-71,-23)->(-71,-23)
       fcb 2 ; drawmode 
       fcb -17,-69 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 M(-30,-73)->(-26,-28)
       fcb 0 ; drawmode 
       fcb 50,41 ; starx/y relative to previous node
       fdb -768,68 ; dx/dy. dx(abs:68|rel:68) dy(abs:-768|rel:-768)
; node # 28 M(0,-92)->(0,-30)
       fcb 0 ; drawmode 
       fcb 19,30 ; starx/y relative to previous node
       fdb -290,-68 ; dx/dy. dx(abs:0|rel:-68) dy(abs:-1058|rel:-290)
; node # 29 D(0,-80)->(0,-20)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 34,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-1024|rel:34)
; node # 30 D(16,-80)->(17,-20)
       fcb 2 ; drawmode 
       fcb 0,16 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:-1024|rel:0)
; node # 31 D(16,-92)->(17,-30)
       fcb 2 ; drawmode 
       fcb 12,0 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:-1058|rel:-34)
; node # 32 D(0,-92)->(0,-30)
       fcb 2 ; drawmode 
       fcb 0,-16 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:-1058|rel:0)
       fcb  1  ; end of anim
; Animation 2
bncloopframe2:
       fcb 22 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(18,0)->(-7,5)
       fcb 0 ; drawmode 
       fcb 0,18 ; starx/y relative to previous node
       fdb -58,-290 ; dx/dy. dx(abs:-290|rel:-290) dy(abs:-58|rel:-58)
; node # 1 M(18,0)->(15,17)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -139,256 ; dx/dy. dx(abs:-34|rel:256) dy(abs:-197|rel:-139)
; node # 2 D(18,17)->(12,30)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 46,-35 ; dx/dy. dx(abs:-69|rel:-35) dy(abs:-151|rel:46)
; node # 3 D(18,34)->(10,47)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,-24 ; dx/dy. dx(abs:-93|rel:-24) dy(abs:-151|rel:0)
; node # 4 D(18,52)->(10,65)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-93|rel:0) dy(abs:-151|rel:0)
; node # 5 D(18,71)->(11,82)
       fcb 2 ; drawmode 
       fcb -19,0 ; starx/y relative to previous node
       fdb 23,12 ; dx/dy. dx(abs:-81|rel:12) dy(abs:-128|rel:23)
; node # 6 D(18,93)->(15,102)
       fcb 2 ; drawmode 
       fcb -22,0 ; starx/y relative to previous node
       fdb 24,47 ; dx/dy. dx(abs:-34|rel:47) dy(abs:-104|rel:24)
; node # 7 D(18,118)->(18,118)
       fcb 2 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb 104,34 ; dx/dy. dx(abs:0|rel:34) dy(abs:0|rel:104)
; node # 8 D(-71,76)->(-71,76)
       fcb 2 ; drawmode 
       fcb 42,-89 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(-71,58)->(-81,63)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb -58,-116 ; dx/dy. dx(abs:-116|rel:-116) dy(abs:-58|rel:-58)
; node # 10 D(-71,38)->(-85,46)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb -35,-46 ; dx/dy. dx(abs:-162|rel:-46) dy(abs:-93|rel:-35)
; node # 11 D(-71,18)->(-85,27)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb -11,0 ; dx/dy. dx(abs:-162|rel:0) dy(abs:-104|rel:-11)
; node # 12 D(-71,-2)->(-82,8)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb -12,34 ; dx/dy. dx(abs:-128|rel:34) dy(abs:-116|rel:-12)
; node # 13 D(-71,-23)->(-76,-8)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb -58,70 ; dx/dy. dx(abs:-58|rel:70) dy(abs:-174|rel:-58)
; node # 14 D(18,0)->(15,17)
       fcb 2 ; drawmode 
       fcb -23,89 ; starx/y relative to previous node
       fdb -23,24 ; dx/dy. dx(abs:-34|rel:24) dy(abs:-197|rel:-23)
; node # 15 D(78,-23)->(78,-12)
       fcb 2 ; drawmode 
       fcb 23,60 ; starx/y relative to previous node
       fdb 69,34 ; dx/dy. dx(abs:0|rel:34) dy(abs:-128|rel:69)
; node # 16 D(78,-6)->(84,-1)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 70,69 ; dx/dy. dx(abs:69|rel:69) dy(abs:-58|rel:70)
; node # 17 D(78,10)->(89,13)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 24,59 ; dx/dy. dx(abs:128|rel:59) dy(abs:-34|rel:24)
; node # 18 D(78,25)->(92,28)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:162|rel:34) dy(abs:-34|rel:0)
; node # 19 D(78,43)->(92,44)
       fcb 2 ; drawmode 
       fcb -18,0 ; starx/y relative to previous node
       fdb 23,0 ; dx/dy. dx(abs:162|rel:0) dy(abs:-11|rel:23)
; node # 20 D(78,60)->(88,61)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb 0,-46 ; dx/dy. dx(abs:116|rel:-46) dy(abs:-11|rel:0)
; node # 21 D(78,76)->(78,76)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb 11,-116 ; dx/dy. dx(abs:0|rel:-116) dy(abs:0|rel:11)
; node # 22 D(18,118)->(18,118)
       fcb 2 ; drawmode 
       fcb -42,-60 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 M(51,42)->(51,42)
       fcb 0 ; drawmode 
       fcb 76,33 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 M(78,-23)->(78,-12)
       fcb 0 ; drawmode 
       fcb 65,27 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-128|rel:-128)
; node # 25 D(-2,-40)->(-4,-27)
       fcb 2 ; drawmode 
       fcb 17,-80 ; starx/y relative to previous node
       fdb -23,-23 ; dx/dy. dx(abs:-23|rel:-23) dy(abs:-151|rel:-23)
; node # 26 D(-71,-23)->(-76,-8)
       fcb 2 ; drawmode 
       fcb -17,-69 ; starx/y relative to previous node
       fdb -23,-35 ; dx/dy. dx(abs:-58|rel:-35) dy(abs:-174|rel:-23)
; node # 27 M(-26,-28)->(-26,-28)
       fcb 0 ; drawmode 
       fcb 5,45 ; starx/y relative to previous node
       fdb 174,58 ; dx/dy. dx(abs:0|rel:58) dy(abs:0|rel:174)
; node # 28 M(0,-30)->(0,-15)
       fcb 0 ; drawmode 
       fcb 2,26 ; starx/y relative to previous node
       fdb -174,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-174|rel:-174)
; node # 29 D(0,-20)->(0,-4)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-186|rel:-12)
; node # 30 D(17,-20)->(17,-4)
       fcb 2 ; drawmode 
       fcb 0,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-186|rel:0)
; node # 31 D(17,-30)->(17,-15)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-174|rel:12)
; node # 32 D(0,-30)->(0,-15)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-174|rel:0)
       fcb  1  ; end of anim
