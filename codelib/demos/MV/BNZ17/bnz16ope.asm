vopenframecount EQU 18 ; number of animations
; index table 
vopenframetab fdb vopenframe0,vopenframe1,vopenframe2,vopenframe3,vopenframe4,vopenframe5,vopenframe6,vopenframe7,vopenframe8,vopenframe9,vopenframe10,vopenframe11,vopenframe12,vopenframe13,vopenframe14,vopenframe15,vopenframe16,vopenframe17
; Animation 0
vopenframe0:
       fcb 64 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,480 ; dx/dy. dx(abs:480|rel:480) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,-480 ; dx/dy. dx(abs:0|rel:-480) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,-480 ; dx/dy. dx(abs:-480|rel:-480) dy(abs:0|rel:0)
       fcb 1  ; end of anim
; Animation 1
vopenframe1:
       fcb 64 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb -480,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-480|rel:-480)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-480|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-480|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 480,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:480)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 480,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:480)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:480|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -480,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-480)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -480,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-480|rel:-480)
       fcb 1  ; end of anim
; Animation 2
vopenframe2:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 23040,-25600 ; starx/y relative to previous node
    fdb -400,240 ; dx/dy. dx(abs:240|rel:240) dy(abs:-400|rel:-400)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 400,-240 ; dx/dy. dx(abs:0|rel:-240) dy(abs:0|rel:400)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
    fdb -360,280 ; dx/dy. dx(abs:280|rel:280) dy(abs:-360|rel:-360)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:200|rel:-80) dy(abs:-440|rel:-80)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
    fdb 0,80 ; dx/dy. dx(abs:280|rel:80) dy(abs:-440|rel:0)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
    fdb 80,-80 ; dx/dy. dx(abs:200|rel:-80) dy(abs:-360|rel:80)
       fcb 1  ; end of anim
; Animation 3
vopenframe3:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 10240,-17920 ; starx/y relative to previous node
    fdb 400,240 ; dx/dy. dx(abs:240|rel:240) dy(abs:400|rel:400)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -400,-240 ; dx/dy. dx(abs:0|rel:-240) dy(abs:0|rel:-400)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -14080,6400 ; starx/y relative to previous node
    fdb 440,200 ; dx/dy. dx(abs:200|rel:200) dy(abs:440|rel:440)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
    fdb -80,80 ; dx/dy. dx(abs:280|rel:80) dy(abs:360|rel:-80)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
    fdb 80,0 ; dx/dy. dx(abs:280|rel:0) dy(abs:440|rel:80)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:200|rel:-80) dy(abs:360|rel:-80)
       fcb 1  ; end of anim
; Animation 4
vopenframe4:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 23040,-10240 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 1  ; end of anim
; Animation 5
vopenframe5:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 23040,-5120 ; starx/y relative to previous node
    fdb -400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-400|rel:-400)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:400)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -1280,19200 ; starx/y relative to previous node
    fdb -360,-40 ; dx/dy. dx(abs:-40|rel:-40) dy(abs:-360|rel:-360)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
    fdb -80,80 ; dx/dy. dx(abs:40|rel:80) dy(abs:-440|rel:-80)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
    fdb 80,0 ; dx/dy. dx(abs:40|rel:0) dy(abs:-360|rel:80)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:-40|rel:-80) dy(abs:-440|rel:-80)
       fcb 1  ; end of anim
; Animation 6
vopenframe6:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 10240,-5120 ; starx/y relative to previous node
    fdb 0,400 ; dx/dy. dx(abs:400|rel:400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,-400 ; dx/dy. dx(abs:0|rel:-400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -12800,17920 ; starx/y relative to previous node
    fdb 40,440 ; dx/dy. dx(abs:440|rel:440) dy(abs:40|rel:40)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:360|rel:-80) dy(abs:-40|rel:-80)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
    fdb 0,80 ; dx/dy. dx(abs:440|rel:80) dy(abs:-40|rel:0)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
    fdb 80,-80 ; dx/dy. dx(abs:360|rel:-80) dy(abs:40|rel:80)
       fcb 1  ; end of anim
; Animation 7
vopenframe7:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 10240,7680 ; starx/y relative to previous node
    fdb 400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:400|rel:400)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -400,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:-400)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -14080,32000 ; starx/y relative to previous node
    fdb 440,-40 ; dx/dy. dx(abs:-40|rel:-40) dy(abs:440|rel:440)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
    fdb -80,80 ; dx/dy. dx(abs:40|rel:80) dy(abs:360|rel:-80)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
    fdb 80,0 ; dx/dy. dx(abs:40|rel:0) dy(abs:440|rel:80)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:-40|rel:-80) dy(abs:360|rel:-80)
       fcb 1  ; end of anim
; Animation 8
vopenframe8:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 23040,7680 ; starx/y relative to previous node
    fdb 0,-400 ; dx/dy. dx(abs:-400|rel:-400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,400 ; dx/dy. dx(abs:0|rel:400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 40,-360 ; dx/dy. dx(abs:-360|rel:-360) dy(abs:40|rel:40)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:-440|rel:-80) dy(abs:-40|rel:-80)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
    fdb 0,80 ; dx/dy. dx(abs:-360|rel:80) dy(abs:-40|rel:0)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
    fdb 80,-80 ; dx/dy. dx(abs:-440|rel:-80) dy(abs:40|rel:80)
       fcb 1  ; end of anim
; Animation 9
vopenframe9:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 23040,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 1  ; end of anim
; Animation 10
vopenframe10:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 23040,12800 ; starx/y relative to previous node
    fdb 0,400 ; dx/dy. dx(abs:400|rel:400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,-400 ; dx/dy. dx(abs:0|rel:-400) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,35840 ; starx/y relative to previous node
    fdb 40,440 ; dx/dy. dx(abs:440|rel:440) dy(abs:40|rel:40)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:360|rel:-80) dy(abs:-40|rel:-80)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
    fdb 0,80 ; dx/dy. dx(abs:440|rel:80) dy(abs:-40|rel:0)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
    fdb 80,-80 ; dx/dy. dx(abs:360|rel:-80) dy(abs:40|rel:80)
       fcb 1  ; end of anim
; Animation 11
vopenframe11:
       fcb 64 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 23040,25600 ; starx/y relative to previous node
    fdb -200,-200 ; dx/dy. dx(abs:-200|rel:-200) dy(abs:-200|rel:-200)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 200,200 ; dx/dy. dx(abs:0|rel:200) dy(abs:0|rel:200)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -1280,49920 ; starx/y relative to previous node
    fdb -180,-220 ; dx/dy. dx(abs:-220|rel:-220) dy(abs:-180|rel:-180)
       fcb 2 ; drawmode 
       fdb 2560,2560 ; starx/y relative to previous node
    fdb -40,40 ; dx/dy. dx(abs:-180|rel:40) dy(abs:-220|rel:-40)
       fcb 0 ; drawmode 
       fdb 0,-2560 ; starx/y relative to previous node
    fdb 40,0 ; dx/dy. dx(abs:-180|rel:0) dy(abs:-180|rel:40)
       fcb 2 ; drawmode 
       fdb -2560,2560 ; starx/y relative to previous node
    fdb -40,-40 ; dx/dy. dx(abs:-220|rel:-40) dy(abs:-220|rel:-40)
       fcb 1  ; end of anim
; Animation 12
vopenframe12:
       fcb 32 ; Duration
       fcb 204 ; Masking 
       fcb 1 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 30720,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb -1 ; drawmode 
       fdb 10240,12800 ; starx/y relative to previous node
    fdb 0,400 ; dx/dy. dx(abs:400|rel:400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,-400 ; dx/dy. dx(abs:0|rel:-400) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -12800,35840 ; starx/y relative to previous node
    fdb 40,440 ; dx/dy. dx(abs:440|rel:440) dy(abs:40|rel:40)
       fcb 2 ; drawmode 
       fdb 0,5120 ; starx/y relative to previous node
    fdb -80,-80 ; dx/dy. dx(abs:360|rel:-80) dy(abs:-40|rel:-80)
       fcb 0 ; drawmode 
       fdb 2560,-2560 ; starx/y relative to previous node
    fdb 0,80 ; dx/dy. dx(abs:440|rel:80) dy(abs:-40|rel:0)
       fcb 2 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
    fdb 80,-80 ; dx/dy. dx(abs:360|rel:-80) dy(abs:40|rel:80)
       fcb 1  ; end of anim
; Animation 13
vopenframe13:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 23040,-3840 ; starx/y relative to previous node
    fdb 48,16 ; dx/dy. dx(abs:16|rel:16) dy(abs:48|rel:48)
       fcb 0 ; drawmode 
       fdb 17920,-1280 ; starx/y relative to previous node
    fdb -48,-16 ; dx/dy. dx(abs:0|rel:-16) dy(abs:0|rel:-48)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 1  ; end of anim
; Animation 14
vopenframe14:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 22784,-4608 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 18176,-512 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,33280 ; starx/y relative to previous node
    fdb 80,-80 ; dx/dy. dx(abs:-80|rel:-80) dy(abs:80|rel:80)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -160,160 ; dx/dy. dx(abs:80|rel:160) dy(abs:-80|rel:-160)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,-160 ; dx/dy. dx(abs:-80|rel:-160) dy(abs:-80|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 160,160 ; dx/dy. dx(abs:80|rel:160) dy(abs:80|rel:160)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -40,-80 ; dx/dy. dx(abs:0|rel:-80) dy(abs:40|rel:-40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb -80,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-40|rel:-80)
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 40,-40 ; dx/dy. dx(abs:-40|rel:-40) dy(abs:0|rel:40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,80 ; dx/dy. dx(abs:40|rel:80) dy(abs:0|rel:0)
       fcb 1  ; end of anim
; Animation 15
vopenframe15:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 22784,-4608 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 18176,-512 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 2560,30720 ; starx/y relative to previous node
    fdb -80,80 ; dx/dy. dx(abs:80|rel:80) dy(abs:-80|rel:-80)
       fcb 2 ; drawmode 
       fdb -5120,5120 ; starx/y relative to previous node
    fdb 160,-160 ; dx/dy. dx(abs:-80|rel:-160) dy(abs:80|rel:160)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,160 ; dx/dy. dx(abs:80|rel:160) dy(abs:80|rel:0)
       fcb 2 ; drawmode 
       fdb 5120,5120 ; starx/y relative to previous node
    fdb -160,-160 ; dx/dy. dx(abs:-80|rel:-160) dy(abs:-80|rel:-160)
       fcb 0 ; drawmode 
       fdb -1280,-2560 ; starx/y relative to previous node
    fdb 40,80 ; dx/dy. dx(abs:0|rel:80) dy(abs:-40|rel:40)
       fcb 2 ; drawmode 
       fdb -2560,0 ; starx/y relative to previous node
    fdb 80,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:40|rel:80)
       fcb 0 ; drawmode 
       fdb 1280,-1280 ; starx/y relative to previous node
    fdb -40,40 ; dx/dy. dx(abs:40|rel:40) dy(abs:0|rel:-40)
       fcb 2 ; drawmode 
       fdb 0,2560 ; starx/y relative to previous node
    fdb 0,-80 ; dx/dy. dx(abs:-40|rel:-80) dy(abs:0|rel:0)
       fcb 1  ; end of anim
; Animation 16
vopenframe16:
       fcb 32 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,800 ; dx/dy. dx(abs:800|rel:800) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,800 ; dx/dy. dx(abs:1600|rel:800) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 2560,0 ; starx/y relative to previous node
    fdb 16,88 ; dx/dy. dx(abs:1688|rel:88) dy(abs:16|rel:16)
       fcb 2 ; drawmode 
       fdb 5120,1280 ; starx/y relative to previous node
    fdb -96,80 ; dx/dy. dx(abs:1768|rel:80) dy(abs:-80|rel:-96)
       fcb 2 ; drawmode 
       fdb -3840,1280 ; starx/y relative to previous node
    fdb -24,-128 ; dx/dy. dx(abs:1640|rel:-128) dy(abs:-104|rel:-24)
       fcb 2 ; drawmode 
       fdb 1024,4096 ; starx/y relative to previous node
    fdb -160,-32 ; dx/dy. dx(abs:1608|rel:-32) dy(abs:-264|rel:-160)
       fcb 2 ; drawmode 
       fdb -3584,-2560 ; starx/y relative to previous node
    fdb 144,-64 ; dx/dy. dx(abs:1544|rel:-64) dy(abs:-120|rel:144)
       fcb 2 ; drawmode 
       fdb -3584,2304 ; starx/y relative to previous node
    fdb -40,-72 ; dx/dy. dx(abs:1472|rel:-72) dy(abs:-160|rel:-40)
       fcb 2 ; drawmode 
       fdb 1536,-3840 ; starx/y relative to previous node
    fdb 88,32 ; dx/dy. dx(abs:1504|rel:32) dy(abs:-72|rel:88)
       fcb 2 ; drawmode 
       fdb -2560,-1536 ; starx/y relative to previous node
    fdb 112,-128 ; dx/dy. dx(abs:1376|rel:-128) dy(abs:40|rel:112)
       fcb 2 ; drawmode 
       fdb 3072,-1536 ; starx/y relative to previous node
    fdb -24,232 ; dx/dy. dx(abs:1608|rel:232) dy(abs:16|rel:-24)
       fcb 2 ; drawmode 
       fdb 1792,-4352 ; starx/y relative to previous node
    fdb 136,24 ; dx/dy. dx(abs:1632|rel:24) dy(abs:152|rel:136)
       fcb 2 ; drawmode 
       fdb 1024,4864 ; starx/y relative to previous node
    fdb -136,56 ; dx/dy. dx(abs:1688|rel:56) dy(abs:16|rel:-136)
       fcb 1  ; end of anim
; Animation 17
vopenframe17:
       fcb 1 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb -30720,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,30720 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -30720,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 24576,-3328 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 16384,-1792 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-17920 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,-12800 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 0,-5120 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 12800,-7680 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -20480,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,25600 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 1  ; end of anim
