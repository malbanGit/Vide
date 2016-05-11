attentionframecount EQU 1 ; number of animations
; index table 
attentionframetab        fdb attentionframe0

; Animation 0
attentionframe0:
; node # 0 M(80,15)->(70,70)
       fcb 0 ; drawmode 
       fcb -15,80 ; position relative to previous node
; node # 1 D(0,15)->(80,80)
       fcb 2 ; drawmode 
       fcb 0,-80 ; position relative to previous node
; node # 2 D(-80,15)->(90,90)
       fcb 2 ; drawmode 
       fcb 0,-80 ; position relative to previous node
; node # 3 D(-39,-54)->(100,100)
       fcb 2 ; drawmode 
       fcb 69,41 ; position relative to previous node
; node # 4 D(0,-120)->(90,90)
       fcb 2 ; drawmode 
       fcb 66,39 ; position relative to previous node
; node # 5 D(40,-53)->(100,100)
       fcb 2 ; drawmode 
       fcb -67,40 ; position relative to previous node
; node # 6 D(80,15)->(100,100)
       fcb 2 ; drawmode 
       fcb -68,40 ; position relative to previous node
; node # 7 M(51,0)->(110,110)
       fcb 0 ; drawmode 
       fcb 15,-29 ; position relative to previous node
; node # 8 D(-51,0)->(120,120)
       fcb 2 ; drawmode 
       fcb 0,-102 ; position relative to previous node
; node # 9 D(-1,-88)->(-126,-126)
       fcb 2 ; drawmode 
       fcb 88,50 ; position relative to previous node
; node # 10 D(51,0)->(-116,-116)
       fcb 2 ; drawmode 
       fcb -88,52 ; position relative to previous node
; node # 11 M(-5,-64)->(-106,-106)
       fcb 0 ; drawmode 
       fcb 64,-56 ; position relative to previous node
; node # 12 D(-1,-27)->(-96,-96)
       fcb 2 ; drawmode 
       fcb -37,4 ; position relative to previous node
; node # 13 D(4,-64)->(-76,-76)
       fcb 2 ; drawmode 
       fcb 37,5 ; position relative to previous node
; node # 14 D(-6,-64)->(-66,-66)
       fcb 2 ; drawmode 
       fcb 0,-10 ; position relative to previous node
; node # 15 M(-1,-12)->(-56,-56)
       fcb 0 ; drawmode 
       fcb -52,5 ; position relative to previous node
; node # 16 D(-5,-15)->(-46,-46)
       fcb 2 ; drawmode 
       fcb 3,-4 ; position relative to previous node
; node # 17 D(-5,-19)->(-36,-36)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 18 D(-1,-22)->(-26,-26)
       fcb 2 ; drawmode 
       fcb 3,4 ; position relative to previous node
; node # 19 D(3,-19)->(-16,-16)
       fcb 2 ; drawmode 
       fcb -3,4 ; position relative to previous node
; node # 20 D(3,-15)->(-6,-6)
       fcb 2 ; drawmode 
       fcb -4,0 ; position relative to previous node
; node # 21 D(-1,-12)->(4,4)
       fcb 2 ; drawmode 
       fcb -3,-4 ; position relative to previous node
       fcb  1  ; end of anim
