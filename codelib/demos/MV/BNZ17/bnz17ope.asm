vopenframecount EQU 24 ; number of animations
; index table 
vopenframetab        fdb vopenframe0
       fdb vopenframe1
       fdb vopenframe2
       fdb vopenframe3
       fdb vopenframe4
       fdb vopenframe5
       fdb vopenframe6
       fdb vopenframe7
       fdb vopenframe8
       fdb vopenframe9
       fdb vopenframe10
       fdb vopenframe11
       fdb vopenframe12
       fdb vopenframe13
       fdb vopenframe14
       fdb vopenframe15
       fdb vopenframe16
       fdb vopenframe17
       fdb vopenframe18
       fdb vopenframe19
       fdb vopenframe20
       fdb vopenframe21
       fdb vopenframe22
       fdb vopenframe23

; Animation 0
vopenframe0:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(120,0)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,960 ; dx/dy. dx(abs:960|rel:960) dy(abs:0|rel:0)
; node # 1 D(0,0)->(0,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-960 ; dx/dy. dx(abs:0|rel:-960) dy(abs:0|rel:0)
; node # 2 D(0,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-960 ; dx/dy. dx(abs:-960|rel:-960) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 1
vopenframe1:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,0)->(120,120)
       fcb 0 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb -960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:-960)
; node # 1 D(0,0)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:0)
; node # 2 D(-120,0)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:960)
; node # 4 D(-120,0)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:960)
; node # 5 D(0,0)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:0)
; node # 6 D(120,0)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-960)
; node # 8 D(120,0)->(120,120)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:-960)
       fcb  1  ; end of anim
; Animation 2
vopenframe2:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(-100,-90)->(-70,-40)
       fcb -1 ; drawmode 
       fdb 23040,-25600 ; starx/y relative to previous node
       fdb -533,320 ; dx/dy. dx(abs:320|rel:320) dy(abs:-533|rel:-533)
; node # 11 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 533,-320 ; dx/dy. dx(abs:0|rel:-320) dy(abs:0|rel:533)
; node # 12 M(-110,-90)->(-75,-45)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
       fdb -480,373 ; dx/dy. dx(abs:373|rel:373) dy(abs:-480|rel:-480)
; node # 13 D(-90,-90)->(-65,-35)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
       fdb -106,-107 ; dx/dy. dx(abs:266|rel:-107) dy(abs:-586|rel:-106)
; node # 14 M(-100,-100)->(-65,-45)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb 0,107 ; dx/dy. dx(abs:373|rel:107) dy(abs:-586|rel:0)
; node # 15 D(-100,-80)->(-75,-35)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
       fdb 106,-107 ; dx/dy. dx(abs:266|rel:-107) dy(abs:-480|rel:106)
       fcb  1  ; end of anim
; Animation 3
vopenframe3:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(-70,-40)->(-40,-90)
       fcb -1 ; drawmode 
       fdb 10240,-17920 ; starx/y relative to previous node
       fdb 533,320 ; dx/dy. dx(abs:320|rel:320) dy(abs:533|rel:533)
; node # 11 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -533,-320 ; dx/dy. dx(abs:0|rel:-320) dy(abs:0|rel:-533)
; node # 12 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 M(-75,-35)->(-50,-90)
       fcb 0 ; drawmode 
       fdb -14080,6400 ; starx/y relative to previous node
       fdb 586,266 ; dx/dy. dx(abs:266|rel:266) dy(abs:586|rel:586)
; node # 14 D(-65,-45)->(-30,-90)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
       fdb -106,107 ; dx/dy. dx(abs:373|rel:107) dy(abs:480|rel:-106)
; node # 15 M(-75,-45)->(-40,-100)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
       fdb 106,0 ; dx/dy. dx(abs:373|rel:0) dy(abs:586|rel:106)
; node # 16 D(-65,-35)->(-40,-80)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
       fdb -106,-107 ; dx/dy. dx(abs:266|rel:-107) dy(abs:480|rel:-106)
       fcb  1  ; end of anim
; Animation 4
vopenframe4:
       fcb 10 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 23040,-10240 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 5
vopenframe5:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(-20,-90)->(-20,-40)
       fcb -1 ; drawmode 
       fdb 23040,-5120 ; starx/y relative to previous node
       fdb -533,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-533|rel:-533)
; node # 11 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 533,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:533)
; node # 12 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-25,-85)->(-30,-40)
       fcb 0 ; drawmode 
       fdb -1280,19200 ; starx/y relative to previous node
       fdb -480,-53 ; dx/dy. dx(abs:-53|rel:-53) dy(abs:-480|rel:-480)
; node # 16 D(-15,-95)->(-10,-40)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
       fdb -106,106 ; dx/dy. dx(abs:53|rel:106) dy(abs:-586|rel:-106)
; node # 17 M(-25,-95)->(-20,-50)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
       fdb 106,0 ; dx/dy. dx(abs:53|rel:0) dy(abs:-480|rel:106)
; node # 18 D(-15,-85)->(-20,-30)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:-53|rel:-106) dy(abs:-586|rel:-106)
       fcb  1  ; end of anim
; Animation 6
vopenframe6:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(-20,-40)->(30,-40)
       fcb -1 ; drawmode 
       fdb 10240,-5120 ; starx/y relative to previous node
       fdb 0,533 ; dx/dy. dx(abs:533|rel:533) dy(abs:0|rel:0)
; node # 11 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-533 ; dx/dy. dx(abs:0|rel:-533) dy(abs:0|rel:0)
; node # 12 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 M(-72,-67)->(-41,-64)
       fcb 0 ; drawmode 
       fdb -5888,7168 ; starx/y relative to previous node
       fdb -32,330 ; dx/dy. dx(abs:330|rel:330) dy(abs:-32|rel:-32)
; node # 17 M(-30,-40)->(25,-45)
       fcb 0 ; drawmode 
       fdb -6912,10752 ; starx/y relative to previous node
       fdb 85,256 ; dx/dy. dx(abs:586|rel:256) dy(abs:53|rel:85)
; node # 18 D(-10,-40)->(35,-35)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:480|rel:-106) dy(abs:-53|rel:-106)
; node # 19 M(-20,-50)->(35,-45)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb 0,106 ; dx/dy. dx(abs:586|rel:106) dy(abs:-53|rel:0)
; node # 20 D(-20,-30)->(25,-35)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
       fdb 106,-106 ; dx/dy. dx(abs:480|rel:-106) dy(abs:53|rel:106)
       fcb  1  ; end of anim
; Animation 7
vopenframe7:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(30,-40)->(30,-90)
       fcb -1 ; drawmode 
       fdb 10240,7680 ; starx/y relative to previous node
       fdb 533,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:533|rel:533)
; node # 11 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -533,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-533)
; node # 12 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 M(-29,-75)->(-49,-86)
       fcb 0 ; drawmode 
       fdb -3840,18176 ; starx/y relative to previous node
       fdb 117,-213 ; dx/dy. dx(abs:-213|rel:-213) dy(abs:117|rel:117)
; node # 18 M(25,-35)->(20,-90)
       fcb 0 ; drawmode 
       fdb -10240,13824 ; starx/y relative to previous node
       fdb 469,160 ; dx/dy. dx(abs:-53|rel:160) dy(abs:586|rel:469)
; node # 19 D(35,-45)->(40,-90)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
       fdb -106,106 ; dx/dy. dx(abs:53|rel:106) dy(abs:480|rel:-106)
; node # 20 M(25,-45)->(30,-100)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
       fdb 106,0 ; dx/dy. dx(abs:53|rel:0) dy(abs:586|rel:106)
; node # 21 D(35,-35)->(30,-80)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:-53|rel:-106) dy(abs:480|rel:-106)
       fcb  1  ; end of anim
; Animation 8
vopenframe8:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(30,-90)->(-20,-90)
       fcb -1 ; drawmode 
       fdb 23040,7680 ; starx/y relative to previous node
       fdb 0,-533 ; dx/dy. dx(abs:-533|rel:-533) dy(abs:0|rel:0)
; node # 11 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,533 ; dx/dy. dx(abs:0|rel:533) dy(abs:0|rel:0)
; node # 12 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 M(-57,-90)->(-72,-92)
       fcb 0 ; drawmode 
       fdb 0,11008 ; starx/y relative to previous node
       fdb 21,-160 ; dx/dy. dx(abs:-160|rel:-160) dy(abs:21|rel:21)
; node # 19 M(20,-90)->(-25,-95)
       fcb 0 ; drawmode 
       fdb 0,19712 ; starx/y relative to previous node
       fdb 32,-320 ; dx/dy. dx(abs:-480|rel:-320) dy(abs:53|rel:32)
; node # 20 D(40,-90)->(-15,-85)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:-586|rel:-106) dy(abs:-53|rel:-106)
; node # 21 M(30,-100)->(-15,-95)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb 0,106 ; dx/dy. dx(abs:-480|rel:106) dy(abs:-53|rel:0)
; node # 22 D(30,-80)->(-25,-85)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
       fdb 106,-106 ; dx/dy. dx(abs:-586|rel:-106) dy(abs:53|rel:106)
       fcb  1  ; end of anim
; Animation 9
vopenframe9:
       fcb 10 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 23040,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 10
vopenframe10:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(50,-90)->(100,-90)
       fcb -1 ; drawmode 
       fdb 23040,12800 ; starx/y relative to previous node
       fdb 0,533 ; dx/dy. dx(abs:533|rel:533) dy(abs:0|rel:0)
; node # 11 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-533 ; dx/dy. dx(abs:0|rel:-533) dy(abs:0|rel:0)
; node # 12 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 M(-4,-90)->(1,-93)
       fcb 0 ; drawmode 
       fdb 0,24576 ; starx/y relative to previous node
       fdb 32,53 ; dx/dy. dx(abs:53|rel:53) dy(abs:32|rel:32)
; node # 21 M(40,-90)->(95,-95)
       fcb 0 ; drawmode 
       fdb 0,11264 ; starx/y relative to previous node
       fdb 21,533 ; dx/dy. dx(abs:586|rel:533) dy(abs:53|rel:21)
; node # 22 D(60,-90)->(105,-85)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:480|rel:-106) dy(abs:-53|rel:-106)
; node # 23 M(50,-100)->(105,-95)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb 0,106 ; dx/dy. dx(abs:586|rel:106) dy(abs:-53|rel:0)
; node # 24 D(50,-80)->(95,-85)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
       fdb 106,-106 ; dx/dy. dx(abs:480|rel:-106) dy(abs:53|rel:106)
       fcb  1  ; end of anim
; Animation 11
vopenframe11:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(100,-90)->(50,-40)
       fcb -1 ; drawmode 
       fdb 23040,25600 ; starx/y relative to previous node
       fdb -533,-533 ; dx/dy. dx(abs:-533|rel:-533) dy(abs:-533|rel:-533)
; node # 11 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 533,533 ; dx/dy. dx(abs:0|rel:533) dy(abs:0|rel:533)
; node # 12 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 M(8,-87)->(-32,-66)
       fcb 0 ; drawmode 
       fdb -768,27648 ; starx/y relative to previous node
       fdb -224,-426 ; dx/dy. dx(abs:-426|rel:-426) dy(abs:-224|rel:-224)
; node # 22 M(95,-85)->(40,-40)
       fcb 0 ; drawmode 
       fdb -512,22272 ; starx/y relative to previous node
       fdb -256,-160 ; dx/dy. dx(abs:-586|rel:-160) dy(abs:-480|rel:-256)
; node # 23 D(105,-95)->(60,-40)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
       fdb -106,106 ; dx/dy. dx(abs:-480|rel:106) dy(abs:-586|rel:-106)
; node # 24 M(95,-95)->(50,-50)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
       fdb 106,0 ; dx/dy. dx(abs:-480|rel:0) dy(abs:-480|rel:106)
; node # 25 D(105,-85)->(50,-30)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:-586|rel:-106) dy(abs:-586|rel:-106)
       fcb  1  ; end of anim
; Animation 12
vopenframe12:
       fcb 24 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 DM(50,-40)->(100,-40)
       fcb -1 ; drawmode 
       fdb 10240,12800 ; starx/y relative to previous node
       fdb 0,533 ; dx/dy. dx(abs:533|rel:533) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-533 ; dx/dy. dx(abs:0|rel:-533) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-14,-60)->(5,-66)
       fcb 0 ; drawmode 
       fdb -7680,22016 ; starx/y relative to previous node
       fdb 64,202 ; dx/dy. dx(abs:202|rel:202) dy(abs:64|rel:64)
; node # 23 M(40,-40)->(95,-45)
       fcb 0 ; drawmode 
       fdb -5120,13824 ; starx/y relative to previous node
       fdb -11,384 ; dx/dy. dx(abs:586|rel:384) dy(abs:53|rel:-11)
; node # 24 D(60,-40)->(105,-35)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
       fdb -106,-106 ; dx/dy. dx(abs:480|rel:-106) dy(abs:-53|rel:-106)
; node # 25 M(50,-50)->(105,-45)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
       fdb 0,106 ; dx/dy. dx(abs:586|rel:106) dy(abs:-53|rel:0)
; node # 26 D(50,-30)->(95,-35)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
       fdb 106,-106 ; dx/dy. dx(abs:480|rel:-106) dy(abs:53|rel:106)
       fcb  1  ; end of anim
; Animation 13
vopenframe13:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(105,30)->(107,24)
       fcb 0 ; drawmode 
       fdb 23040,-3840 ; starx/y relative to previous node
       fdb 48,16 ; dx/dy. dx(abs:16|rel:16) dy(abs:48|rel:48)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 17920,-1280 ; starx/y relative to previous node
       fdb -48,-16 ; dx/dy. dx(abs:0|rel:-16) dy(abs:0|rel:-48)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 14
vopenframe14:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(102,31)->(102,31)
       fcb 0 ; drawmode 
       fdb 22784,-4608 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 18176,-512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-50,-90)->(-45,-95)
       fcb 0 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 40,40 ; dx/dy. dx(abs:40|rel:40) dy(abs:40|rel:40)
; node # 23 M(30,-90)->(20,-100)
       fcb 0 ; drawmode 
       fdb 0,20480 ; starx/y relative to previous node
       fdb 40,-120 ; dx/dy. dx(abs:-80|rel:-120) dy(abs:80|rel:40)
; node # 24 D(30,-90)->(40,-80)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -160,160 ; dx/dy. dx(abs:80|rel:160) dy(abs:-80|rel:-160)
; node # 25 M(30,-90)->(20,-80)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,-160 ; dx/dy. dx(abs:-80|rel:-160) dy(abs:-80|rel:0)
; node # 26 D(30,-90)->(40,-100)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 160,160 ; dx/dy. dx(abs:80|rel:160) dy(abs:80|rel:160)
; node # 27 M(30,-90)->(30,-95)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -40,-80 ; dx/dy. dx(abs:0|rel:-80) dy(abs:40|rel:-40)
; node # 28 D(30,-90)->(30,-85)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -80,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-40|rel:-80)
; node # 29 M(30,-90)->(25,-90)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 40,-40 ; dx/dy. dx(abs:-40|rel:-40) dy(abs:0|rel:40)
; node # 30 D(30,-90)->(35,-90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,80 ; dx/dy. dx(abs:40|rel:80) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 15
vopenframe15:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(102,31)->(102,31)
       fcb 0 ; drawmode 
       fdb 22784,-4608 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 18176,-512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-46,-94)->(-58,-90)
       fcb 0 ; drawmode 
       fdb 1024,13824 ; starx/y relative to previous node
       fdb -32,-96 ; dx/dy. dx(abs:-96|rel:-96) dy(abs:-32|rel:-32)
; node # 23 M(20,-100)->(30,-90)
       fcb 0 ; drawmode 
       fdb 1536,16896 ; starx/y relative to previous node
       fdb -48,176 ; dx/dy. dx(abs:80|rel:176) dy(abs:-80|rel:-48)
; node # 24 D(40,-80)->(30,-90)
       fcb 2 ; drawmode 
       fdb -5120,5120 ; starx/y relative to previous node
       fdb 160,-160 ; dx/dy. dx(abs:-80|rel:-160) dy(abs:80|rel:160)
; node # 25 M(20,-80)->(30,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,160 ; dx/dy. dx(abs:80|rel:160) dy(abs:80|rel:0)
; node # 26 D(40,-100)->(30,-90)
       fcb 2 ; drawmode 
       fdb 5120,5120 ; starx/y relative to previous node
       fdb -160,-160 ; dx/dy. dx(abs:-80|rel:-160) dy(abs:-80|rel:-160)
; node # 27 M(30,-95)->(30,-90)
       fcb 0 ; drawmode 
       fdb -1280,-2560 ; starx/y relative to previous node
       fdb 40,80 ; dx/dy. dx(abs:0|rel:80) dy(abs:-40|rel:40)
; node # 28 D(30,-85)->(30,-90)
       fcb 2 ; drawmode 
       fdb -2560,0 ; starx/y relative to previous node
       fdb 80,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:40|rel:80)
; node # 29 M(25,-90)->(30,-90)
       fcb 0 ; drawmode 
       fdb 1280,-1280 ; starx/y relative to previous node
       fdb -40,40 ; dx/dy. dx(abs:40|rel:40) dy(abs:0|rel:-40)
; node # 30 D(35,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,2560 ; starx/y relative to previous node
       fdb 0,-80 ; dx/dy. dx(abs:-40|rel:-80) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 16
vopenframe16:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(107,24)->(107,24)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-100,-10)->(-100,-10)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(-100,-10)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,800 ; dx/dy. dx(abs:800|rel:800) dy(abs:0|rel:0)
; node # 24 D(-97,-11)->(97,-10)
       fcb 2 ; drawmode 
       fdb 256,768 ; starx/y relative to previous node
       fdb -8,752 ; dx/dy. dx(abs:1552|rel:752) dy(abs:-8|rel:-8)
; node # 25 M(-100,-20)->(106,-16)
       fcb 0 ; drawmode 
       fdb 2304,-768 ; starx/y relative to previous node
       fdb -24,96 ; dx/dy. dx(abs:1648|rel:96) dy(abs:-32|rel:-24)
; node # 26 D(-98,-39)->(123,-26)
       fcb 2 ; drawmode 
       fdb 4864,512 ; starx/y relative to previous node
       fdb -72,120 ; dx/dy. dx(abs:1768|rel:120) dy(abs:-104|rel:-72)
; node # 27 D(-89,-25)->(114,-10)
       fcb 2 ; drawmode 
       fdb -3584,2304 ; starx/y relative to previous node
       fdb -16,-144 ; dx/dy. dx(abs:1624|rel:-144) dy(abs:-120|rel:-16)
; node # 28 D(-75,-30)->(127,3)
       fcb 2 ; drawmode 
       fdb 1280,3584 ; starx/y relative to previous node
       fdb -144,-8 ; dx/dy. dx(abs:1616|rel:-8) dy(abs:-264|rel:-144)
; node # 29 D(-84,-15)->(109,1)
       fcb 2 ; drawmode 
       fdb -3840,-2304 ; starx/y relative to previous node
       fdb 136,-72 ; dx/dy. dx(abs:1544|rel:-72) dy(abs:-128|rel:136)
; node # 30 D(-75,-1)->(101,21)
       fcb 2 ; drawmode 
       fdb -3584,2304 ; starx/y relative to previous node
       fdb -48,-136 ; dx/dy. dx(abs:1408|rel:-136) dy(abs:-176|rel:-48)
; node # 31 D(-90,-7)->(97,1)
       fcb 2 ; drawmode 
       fdb 1536,-3840 ; starx/y relative to previous node
       fdb 112,88 ; dx/dy. dx(abs:1496|rel:88) dy(abs:-64|rel:112)
; node # 32 D(-98,4)->(76,-1)
       fcb 2 ; drawmode 
       fdb -2816,-2048 ; starx/y relative to previous node
       fdb 104,-104 ; dx/dy. dx(abs:1392|rel:-104) dy(abs:40|rel:104)
; node # 33 D(-97,-10)->(97,-10)
       fcb 2 ; drawmode 
       fdb 3584,256 ; starx/y relative to previous node
       fdb -40,160 ; dx/dy. dx(abs:1552|rel:160) dy(abs:0|rel:-40)
; node # 34 D(-116,-16)->(92,-30)
       fcb 2 ; drawmode 
       fdb 1536,-4864 ; starx/y relative to previous node
       fdb 112,112 ; dx/dy. dx(abs:1664|rel:112) dy(abs:112|rel:112)
; node # 35 D(-98,-22)->(106,-16)
       fcb 2 ; drawmode 
       fdb 1536,4608 ; starx/y relative to previous node
       fdb -160,-32 ; dx/dy. dx(abs:1632|rel:-32) dy(abs:-48|rel:-160)
       fcb  1  ; end of anim
; Animation 17
vopenframe17:
       fcb 24 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(107,24)->(107,24)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-100,-10)->(-100,-10)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(0,-10)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(100,-10)->(100,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fdb -2560,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 M(-120,-10)->(-100,20)
       fcb 0 ; drawmode 
       fdb 2560,-30720 ; starx/y relative to previous node
       fdb -320,213 ; dx/dy. dx(abs:213|rel:213) dy(abs:-320|rel:-320)
; node # 27 D(-45,-10)->(-65,20)
       fcb 2 ; drawmode 
       fdb 0,19200 ; starx/y relative to previous node
       fdb 0,-426 ; dx/dy. dx(abs:-213|rel:-426) dy(abs:-320|rel:0)
; node # 28 D(-45,35)->(-65,50)
       fcb 2 ; drawmode 
       fdb -11520,0 ; starx/y relative to previous node
       fdb 160,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:-160|rel:160)
; node # 29 D(-120,127)->(-100,100)
       fcb 2 ; drawmode 
       fdb -23552,-19200 ; starx/y relative to previous node
       fdb 448,426 ; dx/dy. dx(abs:213|rel:426) dy(abs:288|rel:448)
; node # 30 D(-45,127)->(-65,100)
       fcb 2 ; drawmode 
       fdb 0,19200 ; starx/y relative to previous node
       fdb 0,-426 ; dx/dy. dx(abs:-213|rel:-426) dy(abs:288|rel:0)
       fcb  1  ; end of anim
; Animation 18
vopenframe18:
       fcb 24 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(107,24)->(107,24)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-100,-10)->(-100,-10)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(0,-10)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(100,-10)->(100,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 M(10,-10)->(-10,20)
       fcb 0 ; drawmode 
       fdb 0,-23040 ; starx/y relative to previous node
       fdb -320,-213 ; dx/dy. dx(abs:-213|rel:-213) dy(abs:-320|rel:-320)
; node # 26 D(10,57)->(-10,60)
       fcb 2 ; drawmode 
       fdb -17152,0 ; starx/y relative to previous node
       fdb 288,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:-32|rel:288)
; node # 27 D(10,127)->(-10,100)
       fcb 2 ; drawmode 
       fdb -17920,0 ; starx/y relative to previous node
       fdb 320,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:288|rel:320)
; node # 28 D(-65,127)->(-45,100)
       fcb 2 ; drawmode 
       fdb 0,-19200 ; starx/y relative to previous node
       fdb 0,426 ; dx/dy. dx(abs:213|rel:426) dy(abs:288|rel:0)
; node # 29 D(-65,57)->(-45,59)
       fcb 2 ; drawmode 
       fdb 17920,0 ; starx/y relative to previous node
       fdb -309,0 ; dx/dy. dx(abs:213|rel:0) dy(abs:-21|rel:-309)
; node # 30 D(-65,-10)->(-45,20)
       fcb 2 ; drawmode 
       fdb 17152,0 ; starx/y relative to previous node
       fdb -299,0 ; dx/dy. dx(abs:213|rel:0) dy(abs:-320|rel:-299)
; node # 31 D(10,-10)->(-10,20)
       fcb 2 ; drawmode 
       fdb 0,19200 ; starx/y relative to previous node
       fdb 0,-426 ; dx/dy. dx(abs:-213|rel:-426) dy(abs:-320|rel:0)
; node # 32 M(-100,20)->(-100,20)
       fcb 0 ; drawmode 
       fdb -7680,-28160 ; starx/y relative to previous node
       fdb 320,213 ; dx/dy. dx(abs:0|rel:213) dy(abs:0|rel:320)
; node # 33 D(-65,20)->(-65,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(-65,50)->(-65,50)
       fcb 2 ; drawmode 
       fdb -7680,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-100,100)->(-100,100)
       fcb 2 ; drawmode 
       fdb -12800,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-65,100)->(-65,100)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 19
vopenframe19:
       fcb 24 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(107,24)->(107,24)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-100,-10)->(-100,-10)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(0,-10)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(100,-10)->(100,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 M(65,-10)->(45,20)
       fcb 0 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb -320,-213 ; dx/dy. dx(abs:-213|rel:-213) dy(abs:-320|rel:-320)
; node # 26 D(65,58)->(45,58)
       fcb 2 ; drawmode 
       fdb -17408,0 ; starx/y relative to previous node
       fdb 320,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:0|rel:320)
; node # 27 D(65,127)->(45,100)
       fcb 2 ; drawmode 
       fdb -17664,0 ; starx/y relative to previous node
       fdb 288,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:288|rel:288)
; node # 28 D(-10,127)->(10,100)
       fcb 2 ; drawmode 
       fdb 0,-19200 ; starx/y relative to previous node
       fdb 0,426 ; dx/dy. dx(abs:213|rel:426) dy(abs:288|rel:0)
; node # 29 D(-10,57)->(10,57)
       fcb 2 ; drawmode 
       fdb 17920,0 ; starx/y relative to previous node
       fdb -288,0 ; dx/dy. dx(abs:213|rel:0) dy(abs:0|rel:-288)
; node # 30 D(-10,-10)->(10,20)
       fcb 2 ; drawmode 
       fdb 17152,0 ; starx/y relative to previous node
       fdb -320,0 ; dx/dy. dx(abs:213|rel:0) dy(abs:-320|rel:-320)
; node # 31 D(65,-10)->(45,20)
       fcb 2 ; drawmode 
       fdb 0,19200 ; starx/y relative to previous node
       fdb 0,-426 ; dx/dy. dx(abs:-213|rel:-426) dy(abs:-320|rel:0)
; node # 32 M(-10,20)->(-10,20)
       fcb 0 ; drawmode 
       fdb -7680,-19200 ; starx/y relative to previous node
       fdb 320,213 ; dx/dy. dx(abs:0|rel:213) dy(abs:0|rel:320)
; node # 33 D(-10,100)->(-10,100)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(-45,100)->(-45,100)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(-45,20)->(-45,20)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-10,20)->(-10,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 M(-100,20)->(-100,20)
       fcb 0 ; drawmode 
       fdb 0,-23040 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-65,20)->(-65,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-65,50)->(-65,50)
       fcb 2 ; drawmode 
       fdb -7680,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-100,100)->(-100,100)
       fcb 2 ; drawmode 
       fdb -12800,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-65,100)->(-65,100)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 20
vopenframe20:
       fcb 24 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(107,24)->(107,24)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-100,-10)->(-100,-10)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(0,-10)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(100,-10)->(100,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 M(120,60)->(100,60)
       fcb 0 ; drawmode 
       fdb -17920,5120 ; starx/y relative to previous node
       fdb 0,-213 ; dx/dy. dx(abs:-213|rel:-213) dy(abs:0|rel:0)
; node # 26 D(120,-10)->(100,20)
       fcb 2 ; drawmode 
       fdb 17920,0 ; starx/y relative to previous node
       fdb -320,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:-320|rel:-320)
; node # 27 D(45,-10)->(65,20)
       fcb 2 ; drawmode 
       fdb 0,-19200 ; starx/y relative to previous node
       fdb 0,426 ; dx/dy. dx(abs:213|rel:426) dy(abs:-320|rel:0)
; node # 28 D(45,60)->(65,60)
       fcb 2 ; drawmode 
       fdb -17920,0 ; starx/y relative to previous node
       fdb 320,0 ; dx/dy. dx(abs:213|rel:0) dy(abs:0|rel:320)
; node # 29 D(45,127)->(65,100)
       fcb 2 ; drawmode 
       fdb -17152,0 ; starx/y relative to previous node
       fdb 288,0 ; dx/dy. dx(abs:213|rel:0) dy(abs:288|rel:288)
; node # 30 D(120,127)->(100,100)
       fcb 2 ; drawmode 
       fdb 0,19200 ; starx/y relative to previous node
       fdb 0,-426 ; dx/dy. dx(abs:-213|rel:-426) dy(abs:288|rel:0)
; node # 31 D(120,60)->(100,60)
       fcb 2 ; drawmode 
       fdb 17152,0 ; starx/y relative to previous node
       fdb -288,0 ; dx/dy. dx(abs:-213|rel:0) dy(abs:0|rel:-288)
; node # 32 D(45,60)->(65,60)
       fcb 2 ; drawmode 
       fdb 0,-19200 ; starx/y relative to previous node
       fdb 0,426 ; dx/dy. dx(abs:213|rel:426) dy(abs:0|rel:0)
; node # 33 M(45,20)->(45,20)
       fcb 0 ; drawmode 
       fdb 10240,0 ; starx/y relative to previous node
       fdb 0,-213 ; dx/dy. dx(abs:0|rel:-213) dy(abs:0|rel:0)
; node # 34 D(45,100)->(45,100)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(10,100)->(10,100)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(10,20)->(10,20)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 D(45,20)->(45,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 M(-10,20)->(-10,20)
       fcb 0 ; drawmode 
       fdb 0,-14080 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-10,100)->(-10,100)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-45,100)->(-45,100)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-45,20)->(-45,20)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-10,20)->(-10,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 M(-100,20)->(-100,20)
       fcb 0 ; drawmode 
       fdb 0,-23040 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-65,20)->(-65,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-65,50)->(-65,50)
       fcb 2 ; drawmode 
       fdb -7680,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-100,100)->(-100,100)
       fcb 2 ; drawmode 
       fdb -12800,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 47 D(-65,100)->(-65,100)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 21
vopenframe21:
       fcb 52 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,120)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(0,120)->(0,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-120,120)->(-120,120)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-120,-120)->(-120,-120)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(0,-120)->(0,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(120,-120)->(120,-120)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(120,120)->(120,120)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(107,24)->(107,24)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 M(100,-40)->(100,-40)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(50,-40)->(50,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(100,-90)->(100,-90)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(50,-90)->(50,-90)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 M(-20,-90)->(-20,-90)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 D(30,-90)->(30,-90)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(30,-40)->(30,-40)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-20,-40)->(-20,-40)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-20,-90)->(-20,-90)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(-40,-90)->(-40,-90)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(-70,-40)->(-70,-40)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(-100,-90)->(-100,-90)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(-100,-10)->(-100,-10)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(0,-10)->(0,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 D(100,-10)->(100,-10)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 M(100,60)->(100,60)
       fcb 0 ; drawmode 
       fdb -17920,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 D(100,20)->(100,20)
       fcb 2 ; drawmode 
       fdb 10240,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(65,20)->(65,20)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(65,100)->(65,100)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(100,100)->(100,100)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 D(100,60)->(100,60)
       fcb 2 ; drawmode 
       fdb 10240,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 31 D(65,60)->(65,60)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 M(45,20)->(45,20)
       fcb 0 ; drawmode 
       fdb 10240,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 D(45,100)->(45,100)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(10,100)->(10,100)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 D(10,20)->(10,20)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(45,20)->(45,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 M(-10,20)->(-10,20)
       fcb 0 ; drawmode 
       fdb 0,-14080 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-10,100)->(-10,100)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-45,100)->(-45,100)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-45,20)->(-45,20)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(-10,20)->(-10,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 M(-100,20)->(-100,20)
       fcb 0 ; drawmode 
       fdb 0,-23040 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 D(-65,20)->(-65,20)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-65,50)->(-65,50)
       fcb 2 ; drawmode 
       fdb -7680,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(-100,100)->(-100,100)
       fcb 2 ; drawmode 
       fdb -12800,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-65,100)->(-65,100)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 22
vopenframe22:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,120)->(120,0)
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
       fdb 960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:960)
; node # 1 D(0,120)->(0,0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:0)
; node # 2 D(-120,120)->(-120,0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:0)
; node # 3 D(-120,0)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb -960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-960)
; node # 4 D(-120,-120)->(-120,0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
       fdb -960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:-960)
; node # 5 D(0,-120)->(0,0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:0)
; node # 6 D(120,-120)->(120,0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-960|rel:0)
; node # 7 D(120,0)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:960)
; node # 8 D(120,120)->(120,0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
       fdb 960,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:960|rel:960)
; node # 9 M(107,24)->(107,0)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
       fdb -768,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:192|rel:-768)
; node # 10 M(100,-40)->(100,0)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
       fdb -512,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-320|rel:-512)
; node # 11 D(50,-40)->(50,0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-320|rel:0)
; node # 12 D(100,-90)->(100,0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
       fdb -400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:-400)
; node # 13 D(50,-90)->(50,0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:0)
; node # 14 M(-20,-90)->(-20,0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:0)
; node # 15 D(30,-90)->(30,0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:0)
; node # 16 D(30,-40)->(30,0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
       fdb 400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-320|rel:400)
; node # 17 D(-20,-40)->(-20,0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-320|rel:0)
; node # 18 D(-20,-90)->(-20,0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
       fdb -400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:-400)
; node # 19 M(-40,-90)->(-40,0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:0)
; node # 20 D(-70,-40)->(-70,0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
       fdb 400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-320|rel:400)
; node # 21 D(-100,-90)->(-100,0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
       fdb -400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-720|rel:-400)
; node # 22 M(-100,-10)->(-100,0)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 640,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-80|rel:640)
; node # 23 D(0,-10)->(0,0)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-80|rel:0)
; node # 24 D(100,-10)->(100,0)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-80|rel:0)
; node # 25 M(100,60)->(100,0)
       fcb 0 ; drawmode 
       fdb -17920,0 ; starx/y relative to previous node
       fdb 560,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:560)
; node # 26 D(100,20)->(100,0)
       fcb 2 ; drawmode 
       fdb 10240,0 ; starx/y relative to previous node
       fdb -320,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:-320)
; node # 27 D(65,20)->(65,0)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:0)
; node # 28 D(65,100)->(65,0)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 640,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:640)
; node # 29 D(100,100)->(100,0)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:0)
; node # 30 D(100,60)->(100,0)
       fcb 2 ; drawmode 
       fdb 10240,0 ; starx/y relative to previous node
       fdb -320,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:-320)
; node # 31 D(65,60)->(65,0)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:0)
; node # 32 M(45,20)->(45,0)
       fcb 0 ; drawmode 
       fdb 10240,-5120 ; starx/y relative to previous node
       fdb -320,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:-320)
; node # 33 D(45,100)->(45,0)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 640,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:640)
; node # 34 D(10,100)->(10,0)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:0)
; node # 35 D(10,20)->(10,0)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb -640,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:-640)
; node # 36 D(45,20)->(45,0)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:0)
; node # 37 M(-10,20)->(-10,0)
       fcb 0 ; drawmode 
       fdb 0,-14080 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:0)
; node # 38 D(-10,100)->(-10,0)
       fcb 2 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
       fdb 640,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:640)
; node # 39 D(-45,100)->(-45,0)
       fcb 2 ; drawmode 
       fdb 0,-8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:0)
; node # 40 D(-45,20)->(-45,0)
       fcb 2 ; drawmode 
       fdb 20480,0 ; starx/y relative to previous node
       fdb -640,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:-640)
; node # 41 D(-10,20)->(-10,0)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:0)
; node # 42 M(-100,20)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-23040 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:0)
; node # 43 D(-65,20)->(-65,0)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:160|rel:0)
; node # 44 D(-65,50)->(-65,0)
       fcb 2 ; drawmode 
       fdb -7680,0 ; starx/y relative to previous node
       fdb 240,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:400|rel:240)
; node # 45 D(-100,100)->(-100,0)
       fcb 2 ; drawmode 
       fdb -12800,-8960 ; starx/y relative to previous node
       fdb 400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:400)
; node # 46 D(-65,100)->(-65,0)
       fcb 2 ; drawmode 
       fdb 0,8960 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:800|rel:0)
       fcb  1  ; end of anim
; Animation 23
vopenframe23:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(120,0)->(0,0)
       fcb 0 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
       fdb 0,-960 ; dx/dy. dx(abs:-960|rel:-960) dy(abs:0|rel:0)
; node # 1 D(0,0)->(0,0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,960 ; dx/dy. dx(abs:0|rel:960) dy(abs:0|rel:0)
; node # 2 D(-120,0)->(0,0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
       fdb 0,960 ; dx/dy. dx(abs:960|rel:960) dy(abs:0|rel:0)
       fcb  1  ; end of anim
