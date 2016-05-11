battleframecount equ 18 ; number of animations
battleframetotal equ 360 ; total number of frames in animation 
; index table 
battleframetab        fdb battleframe0
       fdb battleframe1
       fdb battleframe2
       fdb battleframe3
       fdb battleframe4
       fdb battleframe5
       fdb battleframe6
       fdb battleframe7
       fdb battleframe8
       fdb battleframe9
       fdb battleframe10
       fdb battleframe11
       fdb battleframe12
       fdb battleframe13
       fdb battleframe14
       fdb battleframe15
       fdb battleframe16
       fdb battleframe17

; Animation 0
battleframe0:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-31,6)->(-61,5)
       fcb 0 ; drawmode 
       fcb -6,-31 ; starx/y relative to previous node
       fdb 12,-384 ; dx/dy. dx(abs:-384|rel:-384) dy(abs:12|rel:12)
; node # 1 D(-53,22)->(-91,20)
       fcb 2 ; drawmode 
       fcb -16,-22 ; starx/y relative to previous node
       fdb 13,-102 ; dx/dy. dx(abs:-486|rel:-102) dy(abs:25|rel:13)
; node # 2 D(-38,38)->(-73,36)
       fcb 2 ; drawmode 
       fcb -16,15 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:-448|rel:38) dy(abs:25|rel:0)
; node # 3 D(38,38)->(-7,39)
       fcb 2 ; drawmode 
       fcb 0,76 ; starx/y relative to previous node
       fdb -37,-128 ; dx/dy. dx(abs:-576|rel:-128) dy(abs:-12|rel:-37)
; node # 4 D(53,22)->(0,23)
       fcb 2 ; drawmode 
       fcb 16,15 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-678|rel:-102) dy(abs:-12|rel:0)
; node # 5 D(30,5)->(-8,5)
       fcb 2 ; drawmode 
       fcb 17,-23 ; starx/y relative to previous node
       fdb 12,192 ; dx/dy. dx(abs:-486|rel:192) dy(abs:0|rel:12)
; node # 6 D(20,-20)->(16,-20)
       fcb 2 ; drawmode 
       fcb 25,-10 ; starx/y relative to previous node
       fdb 0,435 ; dx/dy. dx(abs:-51|rel:435) dy(abs:0|rel:0)
; node # 7 D(-20,-20)->(-21,-19)
       fcb 2 ; drawmode 
       fcb 0,-40 ; starx/y relative to previous node
       fdb -12,39 ; dx/dy. dx(abs:-12|rel:39) dy(abs:-12|rel:-12)
; node # 8 D(-31,6)->(-61,5)
       fcb 2 ; drawmode 
       fcb -26,-11 ; starx/y relative to previous node
       fdb 24,-372 ; dx/dy. dx(abs:-384|rel:-372) dy(abs:12|rel:24)
; node # 9 D(31,6)->(-8,5)
       fcb 2 ; drawmode 
       fcb 0,62 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:-499|rel:-115) dy(abs:12|rel:0)
; node # 10 D(21,3)->(22,4)
       fcb 2 ; drawmode 
       fcb 3,-10 ; starx/y relative to previous node
       fdb -24,511 ; dx/dy. dx(abs:12|rel:511) dy(abs:-12|rel:-24)
; node # 11 D(-21,3)->(-19,4)
       fcb 2 ; drawmode 
       fcb 0,-42 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:-12|rel:0)
; node # 12 D(-20,-20)->(-21,-19)
       fcb 2 ; drawmode 
       fcb 23,1 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:-12|rel:0)
; node # 13 M(-9,-9)->(-10,-8)
       fcb 0 ; drawmode 
       fcb -11,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-12|rel:0)
; node # 14 D(-9,-31)->(-10,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:0|rel:12)
; node # 15 M(20,-20)->(16,-20)
       fcb 0 ; drawmode 
       fcb -11,29 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:-51|rel:-39) dy(abs:0|rel:0)
; node # 16 D(21,3)->(22,4)
       fcb 2 ; drawmode 
       fcb -23,1 ; starx/y relative to previous node
       fdb -12,63 ; dx/dy. dx(abs:12|rel:63) dy(abs:-12|rel:-12)
; node # 17 D(32,13)->(40,14)
       fcb 2 ; drawmode 
       fcb -10,11 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:102|rel:90) dy(abs:-12|rel:0)
; node # 18 D(53,22)->(0,23)
       fcb 2 ; drawmode 
       fcb -9,21 ; starx/y relative to previous node
       fdb 0,-780 ; dx/dy. dx(abs:-678|rel:-780) dy(abs:-12|rel:0)
; node # 19 D(-53,22)->(-91,20)
       fcb 2 ; drawmode 
       fcb 0,-106 ; starx/y relative to previous node
       fdb 37,192 ; dx/dy. dx(abs:-486|rel:192) dy(abs:25|rel:37)
; node # 20 D(-33,13)->(-23,13)
       fcb 2 ; drawmode 
       fcb 9,20 ; starx/y relative to previous node
       fdb -25,614 ; dx/dy. dx(abs:128|rel:614) dy(abs:0|rel:-25)
; node # 21 D(32,13)->(40,14)
       fcb 2 ; drawmode 
       fcb 0,65 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:102|rel:-26) dy(abs:-12|rel:-12)
; node # 22 D(25,26)->(29,26)
       fcb 2 ; drawmode 
       fcb -13,-7 ; starx/y relative to previous node
       fdb 12,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:0|rel:12)
; node # 23 D(-25,26)->(-19,24)
       fcb 2 ; drawmode 
       fcb 0,-50 ; starx/y relative to previous node
       fdb 25,25 ; dx/dy. dx(abs:76|rel:25) dy(abs:25|rel:25)
; node # 24 D(-33,13)->(-23,13)
       fcb 2 ; drawmode 
       fcb 13,-8 ; starx/y relative to previous node
       fdb -25,52 ; dx/dy. dx(abs:128|rel:52) dy(abs:0|rel:-25)
; node # 25 D(-21,3)->(-19,4)
       fcb 2 ; drawmode 
       fcb 10,12 ; starx/y relative to previous node
       fdb -12,-103 ; dx/dy. dx(abs:25|rel:-103) dy(abs:-12|rel:-12)
; node # 26 D(-31,6)->(-61,5)
       fcb 2 ; drawmode 
       fcb -3,-10 ; starx/y relative to previous node
       fdb 24,-409 ; dx/dy. dx(abs:-384|rel:-409) dy(abs:12|rel:24)
; node # 27 M(-38,38)->(-73,36)
       fcb 0 ; drawmode 
       fcb -32,-7 ; starx/y relative to previous node
       fdb 13,-64 ; dx/dy. dx(abs:-448|rel:-64) dy(abs:25|rel:13)
; node # 28 D(-25,26)->(-19,24)
       fcb 2 ; drawmode 
       fcb 12,13 ; starx/y relative to previous node
       fdb 0,524 ; dx/dy. dx(abs:76|rel:524) dy(abs:25|rel:0)
; node # 29 M(25,26)->(29,26)
       fcb 0 ; drawmode 
       fcb 0,50 ; starx/y relative to previous node
       fdb -25,-25 ; dx/dy. dx(abs:51|rel:-25) dy(abs:0|rel:-25)
; node # 30 D(38,38)->(-7,39)
       fcb 2 ; drawmode 
       fcb -12,13 ; starx/y relative to previous node
       fdb -12,-627 ; dx/dy. dx(abs:-576|rel:-627) dy(abs:-12|rel:-12)
; node # 31 M(5,-11)->(-44,-11)
       fcb 0 ; drawmode 
       fcb 49,-33 ; starx/y relative to previous node
       fdb 12,-51 ; dx/dy. dx(abs:-627|rel:-51) dy(abs:0|rel:12)
; node # 32 D(-5,-11)->(-51,-11)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:-588|rel:39) dy(abs:0|rel:0)
; node # 33 D(-5,-21)->(-51,-20)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:-588|rel:0) dy(abs:-12|rel:-12)
; node # 34 D(5,-21)->(-44,-20)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:-627|rel:-39) dy(abs:-12|rel:0)
; node # 35 D(3,-15)->(-7,-15)
       fcb 2 ; drawmode 
       fcb -6,-2 ; starx/y relative to previous node
       fdb 12,499 ; dx/dy. dx(abs:-128|rel:499) dy(abs:0|rel:12)
; node # 36 D(-3,-15)->(-14,-15)
       fcb 2 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:-140|rel:-12) dy(abs:0|rel:0)
; node # 37 D(-4,-9)->(-20,-9)
       fcb 2 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-204|rel:-64) dy(abs:0|rel:0)
; node # 38 D(3,-9)->(-14,-9)
       fcb 2 ; drawmode 
       fcb 0,7 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-217|rel:-13) dy(abs:0|rel:0)
; node # 39 D(5,-11)->(-44,-11)
       fcb 2 ; drawmode 
       fcb 2,2 ; starx/y relative to previous node
       fdb 0,-410 ; dx/dy. dx(abs:-627|rel:-410) dy(abs:0|rel:0)
; node # 40 D(5,-21)->(-44,-20)
       fcb 2 ; drawmode 
       fcb 10,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:-627|rel:0) dy(abs:-12|rel:-12)
; node # 41 M(-5,-11)->(-51,-11)
       fcb 0 ; drawmode 
       fcb -10,-10 ; starx/y relative to previous node
       fdb 12,39 ; dx/dy. dx(abs:-588|rel:39) dy(abs:0|rel:12)
; node # 42 D(-4,-9)->(-20,-9)
       fcb 2 ; drawmode 
       fcb -2,1 ; starx/y relative to previous node
       fdb 0,384 ; dx/dy. dx(abs:-204|rel:384) dy(abs:0|rel:0)
; node # 43 M(3,-15)->(-7,-15)
       fcb 0 ; drawmode 
       fcb 6,7 ; starx/y relative to previous node
       fdb 0,76 ; dx/dy. dx(abs:-128|rel:76) dy(abs:0|rel:0)
; node # 44 D(3,-9)->(-14,-9)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 0,-89 ; dx/dy. dx(abs:-217|rel:-89) dy(abs:0|rel:0)
; node # 45 M(-3,-15)->(-14,-15)
       fcb 0 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb 0,77 ; dx/dy. dx(abs:-140|rel:77) dy(abs:0|rel:0)
; node # 46 D(-5,-21)->(-51,-20)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb -12,-448 ; dx/dy. dx(abs:-588|rel:-448) dy(abs:-12|rel:-12)
       fcb  1  ; end of anim
; Animation 1
battleframe1:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-61,5)->(-80,5)
       fcb 0 ; drawmode 
       fcb -5,-61 ; starx/y relative to previous node
       fdb 0,-243 ; dx/dy. dx(abs:-243|rel:-243) dy(abs:0|rel:0)
; node # 1 D(-91,20)->(-109,18)
       fcb 2 ; drawmode 
       fcb -15,-30 ; starx/y relative to previous node
       fdb 25,13 ; dx/dy. dx(abs:-230|rel:13) dy(abs:25|rel:25)
; node # 2 D(-73,36)->(-94,32)
       fcb 2 ; drawmode 
       fcb -16,18 ; starx/y relative to previous node
       fdb 26,-38 ; dx/dy. dx(abs:-268|rel:-38) dy(abs:51|rel:26)
; node # 3 D(-7,39)->(-50,37)
       fcb 2 ; drawmode 
       fcb -3,66 ; starx/y relative to previous node
       fdb -26,-282 ; dx/dy. dx(abs:-550|rel:-282) dy(abs:25|rel:-26)
; node # 4 D(0,23)->(-52,22)
       fcb 2 ; drawmode 
       fcb 16,7 ; starx/y relative to previous node
       fdb -13,-115 ; dx/dy. dx(abs:-665|rel:-115) dy(abs:12|rel:-13)
; node # 5 D(-8,5)->(-44,6)
       fcb 2 ; drawmode 
       fcb 18,-8 ; starx/y relative to previous node
       fdb -24,205 ; dx/dy. dx(abs:-460|rel:205) dy(abs:-12|rel:-24)
; node # 6 D(16,-20)->(11,-20)
       fcb 2 ; drawmode 
       fcb 25,24 ; starx/y relative to previous node
       fdb 12,396 ; dx/dy. dx(abs:-64|rel:396) dy(abs:0|rel:12)
; node # 7 D(-21,-19)->(-19,-19)
       fcb 2 ; drawmode 
       fcb -1,-37 ; starx/y relative to previous node
       fdb 0,89 ; dx/dy. dx(abs:25|rel:89) dy(abs:0|rel:0)
; node # 8 D(-61,5)->(-80,5)
       fcb 2 ; drawmode 
       fcb -24,-40 ; starx/y relative to previous node
       fdb 0,-268 ; dx/dy. dx(abs:-243|rel:-268) dy(abs:0|rel:0)
; node # 9 D(-8,5)->(-44,6)
       fcb 2 ; drawmode 
       fcb 0,53 ; starx/y relative to previous node
       fdb -12,-217 ; dx/dy. dx(abs:-460|rel:-217) dy(abs:-12|rel:-12)
; node # 10 D(22,4)->(20,4)
       fcb 2 ; drawmode 
       fcb 1,30 ; starx/y relative to previous node
       fdb 12,435 ; dx/dy. dx(abs:-25|rel:435) dy(abs:0|rel:12)
; node # 11 D(-19,4)->(-14,4)
       fcb 2 ; drawmode 
       fcb 0,-41 ; starx/y relative to previous node
       fdb 0,89 ; dx/dy. dx(abs:64|rel:89) dy(abs:0|rel:0)
; node # 12 D(-21,-19)->(-19,-19)
       fcb 2 ; drawmode 
       fcb 23,-2 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:25|rel:-39) dy(abs:0|rel:0)
; node # 13 M(-10,-8)->(-10,-8)
       fcb 0 ; drawmode 
       fcb -11,11 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:0|rel:0)
; node # 14 D(-10,-31)->(-10,-30)
       fcb 2 ; drawmode 
       fcb 23,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-12|rel:-12)
; node # 15 M(16,-20)->(11,-20)
       fcb 0 ; drawmode 
       fcb -11,26 ; starx/y relative to previous node
       fdb 12,-64 ; dx/dy. dx(abs:-64|rel:-64) dy(abs:0|rel:12)
; node # 16 D(22,4)->(20,4)
       fcb 2 ; drawmode 
       fcb -24,6 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:-25|rel:39) dy(abs:0|rel:0)
; node # 17 D(40,14)->(42,15)
       fcb 2 ; drawmode 
       fcb -10,18 ; starx/y relative to previous node
       fdb -12,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:-12|rel:-12)
; node # 18 D(0,23)->(-52,22)
       fcb 2 ; drawmode 
       fcb -9,-40 ; starx/y relative to previous node
       fdb 24,-690 ; dx/dy. dx(abs:-665|rel:-690) dy(abs:12|rel:24)
; node # 19 D(-91,20)->(-109,18)
       fcb 2 ; drawmode 
       fcb 3,-91 ; starx/y relative to previous node
       fdb 13,435 ; dx/dy. dx(abs:-230|rel:435) dy(abs:25|rel:13)
; node # 20 D(-23,13)->(-11,13)
       fcb 2 ; drawmode 
       fcb 7,68 ; starx/y relative to previous node
       fdb -25,383 ; dx/dy. dx(abs:153|rel:383) dy(abs:0|rel:-25)
; node # 21 D(40,14)->(42,15)
       fcb 2 ; drawmode 
       fcb -1,63 ; starx/y relative to previous node
       fdb -12,-128 ; dx/dy. dx(abs:25|rel:-128) dy(abs:-12|rel:-12)
; node # 22 D(29,26)->(29,27)
       fcb 2 ; drawmode 
       fcb -12,-11 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:0|rel:-25) dy(abs:-12|rel:0)
; node # 23 D(-19,24)->(-11,24)
       fcb 2 ; drawmode 
       fcb 2,-48 ; starx/y relative to previous node
       fdb 12,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:0|rel:12)
; node # 24 D(-23,13)->(-11,13)
       fcb 2 ; drawmode 
       fcb 11,-4 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:0|rel:0)
; node # 25 D(-19,4)->(-14,4)
       fcb 2 ; drawmode 
       fcb 9,4 ; starx/y relative to previous node
       fdb 0,-89 ; dx/dy. dx(abs:64|rel:-89) dy(abs:0|rel:0)
; node # 26 D(-61,5)->(-80,5)
       fcb 2 ; drawmode 
       fcb -1,-42 ; starx/y relative to previous node
       fdb 0,-307 ; dx/dy. dx(abs:-243|rel:-307) dy(abs:0|rel:0)
; node # 27 M(-73,36)->(-94,32)
       fcb 0 ; drawmode 
       fcb -31,-12 ; starx/y relative to previous node
       fdb 51,-25 ; dx/dy. dx(abs:-268|rel:-25) dy(abs:51|rel:51)
; node # 28 D(-19,24)->(-11,24)
       fcb 2 ; drawmode 
       fcb 12,54 ; starx/y relative to previous node
       fdb -51,370 ; dx/dy. dx(abs:102|rel:370) dy(abs:0|rel:-51)
; node # 29 M(29,26)->(29,27)
       fcb 0 ; drawmode 
       fcb -2,48 ; starx/y relative to previous node
       fdb -12,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:-12|rel:-12)
; node # 30 D(-7,39)->(-50,37)
       fcb 2 ; drawmode 
       fcb -13,-36 ; starx/y relative to previous node
       fdb 37,-550 ; dx/dy. dx(abs:-550|rel:-550) dy(abs:25|rel:37)
; node # 31 M(-44,-11)->(-81,-10)
       fcb 0 ; drawmode 
       fcb 50,-37 ; starx/y relative to previous node
       fdb -37,77 ; dx/dy. dx(abs:-473|rel:77) dy(abs:-12|rel:-37)
; node # 32 D(-51,-11)->(-86,-10)
       fcb 2 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:-448|rel:25) dy(abs:-12|rel:0)
; node # 33 D(-51,-20)->(-86,-18)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:-448|rel:0) dy(abs:-25|rel:-13)
; node # 34 D(-44,-20)->(-81,-19)
       fcb 2 ; drawmode 
       fcb 0,7 ; starx/y relative to previous node
       fdb 13,-25 ; dx/dy. dx(abs:-473|rel:-25) dy(abs:-12|rel:13)
; node # 35 D(-7,-15)->(-16,-15)
       fcb 2 ; drawmode 
       fcb -5,37 ; starx/y relative to previous node
       fdb 12,358 ; dx/dy. dx(abs:-115|rel:358) dy(abs:0|rel:12)
; node # 36 D(-14,-15)->(-21,-15)
       fcb 2 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-89|rel:26) dy(abs:0|rel:0)
; node # 37 D(-20,-9)->(-33,-9)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 0,-77 ; dx/dy. dx(abs:-166|rel:-77) dy(abs:0|rel:0)
; node # 38 D(-14,-9)->(-29,-8)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:-192|rel:-26) dy(abs:-12|rel:-12)
; node # 39 D(-44,-11)->(-81,-10)
       fcb 2 ; drawmode 
       fcb 2,-30 ; starx/y relative to previous node
       fdb 0,-281 ; dx/dy. dx(abs:-473|rel:-281) dy(abs:-12|rel:0)
; node # 40 D(-44,-20)->(-81,-19)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-473|rel:0) dy(abs:-12|rel:0)
; node # 41 M(-51,-11)->(-86,-10)
       fcb 0 ; drawmode 
       fcb -9,-7 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:-448|rel:25) dy(abs:-12|rel:0)
; node # 42 D(-20,-9)->(-33,-9)
       fcb 2 ; drawmode 
       fcb -2,31 ; starx/y relative to previous node
       fdb 12,282 ; dx/dy. dx(abs:-166|rel:282) dy(abs:0|rel:12)
; node # 43 M(-7,-15)->(-16,-15)
       fcb 0 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-115|rel:51) dy(abs:0|rel:0)
; node # 44 D(-14,-9)->(-29,-8)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb -12,-77 ; dx/dy. dx(abs:-192|rel:-77) dy(abs:-12|rel:-12)
; node # 45 M(-14,-15)->(-21,-15)
       fcb 0 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 12,103 ; dx/dy. dx(abs:-89|rel:103) dy(abs:0|rel:12)
; node # 46 D(-51,-20)->(-86,-18)
       fcb 2 ; drawmode 
       fcb 5,-37 ; starx/y relative to previous node
       fdb -25,-359 ; dx/dy. dx(abs:-448|rel:-359) dy(abs:-25|rel:-25)
       fcb  1  ; end of anim
; Animation 2
battleframe2:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-80,5)->(-86,4)
       fcb 0 ; drawmode 
       fcb -5,-80 ; starx/y relative to previous node
       fdb 12,-76 ; dx/dy. dx(abs:-76|rel:-76) dy(abs:12|rel:12)
; node # 1 D(-109,18)->(-109,15)
       fcb 2 ; drawmode 
       fcb -13,-29 ; starx/y relative to previous node
       fdb 26,76 ; dx/dy. dx(abs:0|rel:76) dy(abs:38|rel:26)
; node # 2 D(-94,32)->(-96,29)
       fcb 2 ; drawmode 
       fcb -14,15 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:38|rel:0)
; node # 3 D(-50,37)->(-81,35)
       fcb 2 ; drawmode 
       fcb -5,44 ; starx/y relative to previous node
       fdb -13,-371 ; dx/dy. dx(abs:-396|rel:-371) dy(abs:25|rel:-13)
; node # 4 D(-52,22)->(-90,20)
       fcb 2 ; drawmode 
       fcb 15,-2 ; starx/y relative to previous node
       fdb 0,-90 ; dx/dy. dx(abs:-486|rel:-90) dy(abs:25|rel:0)
; node # 5 D(-44,6)->(-71,5)
       fcb 2 ; drawmode 
       fcb 16,8 ; starx/y relative to previous node
       fdb -13,141 ; dx/dy. dx(abs:-345|rel:141) dy(abs:12|rel:-13)
; node # 6 D(11,-20)->(3,-21)
       fcb 2 ; drawmode 
       fcb 26,55 ; starx/y relative to previous node
       fdb 0,243 ; dx/dy. dx(abs:-102|rel:243) dy(abs:12|rel:0)
; node # 7 D(-19,-19)->(-15,-18)
       fcb 2 ; drawmode 
       fcb -1,-30 ; starx/y relative to previous node
       fdb -24,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:-12|rel:-24)
; node # 8 D(-80,5)->(-86,4)
       fcb 2 ; drawmode 
       fcb -24,-61 ; starx/y relative to previous node
       fdb 24,-127 ; dx/dy. dx(abs:-76|rel:-127) dy(abs:12|rel:24)
; node # 9 D(-44,6)->(-71,5)
       fcb 2 ; drawmode 
       fcb -1,36 ; starx/y relative to previous node
       fdb 0,-269 ; dx/dy. dx(abs:-345|rel:-269) dy(abs:12|rel:0)
; node # 10 D(20,4)->(15,5)
       fcb 2 ; drawmode 
       fcb 2,64 ; starx/y relative to previous node
       fdb -24,281 ; dx/dy. dx(abs:-64|rel:281) dy(abs:-12|rel:-24)
; node # 11 D(-14,4)->(-7,4)
       fcb 2 ; drawmode 
       fcb 0,-34 ; starx/y relative to previous node
       fdb 12,153 ; dx/dy. dx(abs:89|rel:153) dy(abs:0|rel:12)
; node # 12 D(-19,-19)->(-15,-18)
       fcb 2 ; drawmode 
       fcb 23,-5 ; starx/y relative to previous node
       fdb -12,-38 ; dx/dy. dx(abs:51|rel:-38) dy(abs:-12|rel:-12)
; node # 13 M(-10,-8)->(-10,-8)
       fcb 0 ; drawmode 
       fcb -11,9 ; starx/y relative to previous node
       fdb 12,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:0|rel:12)
; node # 14 D(-10,-30)->(-10,-30)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(11,-20)->(3,-21)
       fcb 0 ; drawmode 
       fcb -10,21 ; starx/y relative to previous node
       fdb 12,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:12|rel:12)
; node # 16 D(20,4)->(15,5)
       fcb 2 ; drawmode 
       fcb -24,9 ; starx/y relative to previous node
       fdb -24,38 ; dx/dy. dx(abs:-64|rel:38) dy(abs:-12|rel:-24)
; node # 17 D(42,15)->(39,16)
       fcb 2 ; drawmode 
       fcb -11,22 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-38|rel:26) dy(abs:-12|rel:0)
; node # 18 D(-25,20)->(-40,18)
       fcb 2 ; drawmode 
       fcb -5,-67 ; starx/y relative to previous node
       fdb 37,-154 ; dx/dy. dx(abs:-192|rel:-154) dy(abs:25|rel:37)
; node # 19 D(-52,22)->(-90,20)
       fcb 2 ; drawmode 
       fcb -2,-27 ; starx/y relative to previous node
       fdb 0,-294 ; dx/dy. dx(abs:-486|rel:-294) dy(abs:25|rel:0)
; node # 20 D(-109,18)->(-109,15)
       fcb 2 ; drawmode 
       fcb 4,-57 ; starx/y relative to previous node
       fdb 13,486 ; dx/dy. dx(abs:0|rel:486) dy(abs:38|rel:13)
; node # 21 D(-11,13)->(1,13)
       fcb 2 ; drawmode 
       fcb 5,98 ; starx/y relative to previous node
       fdb -38,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:-38)
; node # 22 D(42,15)->(39,16)
       fcb 2 ; drawmode 
       fcb -2,53 ; starx/y relative to previous node
       fdb -12,-191 ; dx/dy. dx(abs:-38|rel:-191) dy(abs:-12|rel:-12)
; node # 23 D(29,27)->(26,28)
       fcb 2 ; drawmode 
       fcb -12,-13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:-12|rel:0)
; node # 24 D(-11,24)->(-1,24)
       fcb 2 ; drawmode 
       fcb 3,-40 ; starx/y relative to previous node
       fdb 12,166 ; dx/dy. dx(abs:128|rel:166) dy(abs:0|rel:12)
; node # 25 D(-11,13)->(1,13)
       fcb 2 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:153|rel:25) dy(abs:0|rel:0)
; node # 26 D(-14,4)->(-7,4)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:89|rel:-64) dy(abs:0|rel:0)
; node # 27 D(-80,5)->(-86,4)
       fcb 2 ; drawmode 
       fcb -1,-66 ; starx/y relative to previous node
       fdb 12,-165 ; dx/dy. dx(abs:-76|rel:-165) dy(abs:12|rel:12)
; node # 28 M(-94,32)->(-96,29)
       fcb 0 ; drawmode 
       fcb -27,-14 ; starx/y relative to previous node
       fdb 26,51 ; dx/dy. dx(abs:-25|rel:51) dy(abs:38|rel:26)
; node # 29 D(-11,24)->(-1,24)
       fcb 2 ; drawmode 
       fcb 8,83 ; starx/y relative to previous node
       fdb -38,153 ; dx/dy. dx(abs:128|rel:153) dy(abs:0|rel:-38)
; node # 30 M(29,27)->(26,28)
       fcb 0 ; drawmode 
       fcb -3,40 ; starx/y relative to previous node
       fdb -12,-166 ; dx/dy. dx(abs:-38|rel:-166) dy(abs:-12|rel:-12)
; node # 31 D(-50,37)->(-81,35)
       fcb 2 ; drawmode 
       fcb -10,-79 ; starx/y relative to previous node
       fdb 37,-358 ; dx/dy. dx(abs:-396|rel:-358) dy(abs:25|rel:37)
; node # 32 M(-81,-10)->(-100,-8)
       fcb 0 ; drawmode 
       fcb 47,-31 ; starx/y relative to previous node
       fdb -50,153 ; dx/dy. dx(abs:-243|rel:153) dy(abs:-25|rel:-50)
; node # 33 D(-86,-10)->(-101,-8)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-192|rel:51) dy(abs:-25|rel:0)
; node # 34 D(-86,-18)->(-101,-16)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:-25|rel:0)
; node # 35 D(-81,-19)->(-100,-17)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-243|rel:-51) dy(abs:-25|rel:0)
; node # 36 D(-16,-15)->(-23,-14)
       fcb 2 ; drawmode 
       fcb -4,65 ; starx/y relative to previous node
       fdb 13,154 ; dx/dy. dx(abs:-89|rel:154) dy(abs:-12|rel:13)
; node # 37 D(-21,-15)->(-26,-14)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:-64|rel:25) dy(abs:-12|rel:0)
; node # 38 D(-33,-9)->(-43,-8)
       fcb 2 ; drawmode 
       fcb -6,-12 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-128|rel:-64) dy(abs:-12|rel:0)
; node # 39 D(-29,-8)->(-39,-8)
       fcb 2 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:12)
; node # 40 D(-81,-10)->(-100,-8)
       fcb 2 ; drawmode 
       fcb 2,-52 ; starx/y relative to previous node
       fdb -25,-115 ; dx/dy. dx(abs:-243|rel:-115) dy(abs:-25|rel:-25)
; node # 41 D(-81,-19)->(-100,-17)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-243|rel:0) dy(abs:-25|rel:0)
; node # 42 M(-86,-10)->(-101,-8)
       fcb 0 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-192|rel:51) dy(abs:-25|rel:0)
; node # 43 D(-33,-9)->(-43,-8)
       fcb 2 ; drawmode 
       fcb -1,53 ; starx/y relative to previous node
       fdb 13,64 ; dx/dy. dx(abs:-128|rel:64) dy(abs:-12|rel:13)
; node # 44 M(-16,-15)->(-23,-14)
       fcb 0 ; drawmode 
       fcb 6,17 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:-89|rel:39) dy(abs:-12|rel:0)
; node # 45 D(-29,-8)->(-39,-8)
       fcb 2 ; drawmode 
       fcb -7,-13 ; starx/y relative to previous node
       fdb 12,-39 ; dx/dy. dx(abs:-128|rel:-39) dy(abs:0|rel:12)
; node # 46 M(-21,-15)->(-26,-14)
       fcb 0 ; drawmode 
       fcb 7,8 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:-64|rel:64) dy(abs:-12|rel:-12)
; node # 47 D(-86,-18)->(-101,-16)
       fcb 2 ; drawmode 
       fcb 3,-65 ; starx/y relative to previous node
       fdb -13,-128 ; dx/dy. dx(abs:-192|rel:-128) dy(abs:-25|rel:-13)
       fcb  1  ; end of anim
; Animation 3
battleframe3:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-86,4)->(-78,3)
       fcb 0 ; drawmode 
       fcb -4,-86 ; starx/y relative to previous node
       fdb 12,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:12|rel:12)
; node # 1 D(-109,15)->(-96,13)
       fcb 2 ; drawmode 
       fcb -11,-23 ; starx/y relative to previous node
       fdb 13,64 ; dx/dy. dx(abs:166|rel:64) dy(abs:25|rel:13)
; node # 2 D(-96,29)->(-89,25)
       fcb 2 ; drawmode 
       fcb -14,13 ; starx/y relative to previous node
       fdb 26,-77 ; dx/dy. dx(abs:89|rel:-77) dy(abs:51|rel:26)
; node # 3 D(-81,35)->(-96,31)
       fcb 2 ; drawmode 
       fcb -6,15 ; starx/y relative to previous node
       fdb 0,-281 ; dx/dy. dx(abs:-192|rel:-281) dy(abs:51|rel:0)
; node # 4 D(-90,20)->(-109,18)
       fcb 2 ; drawmode 
       fcb 15,-9 ; starx/y relative to previous node
       fdb -26,-51 ; dx/dy. dx(abs:-243|rel:-51) dy(abs:25|rel:-26)
; node # 5 D(-71,5)->(-83,4)
       fcb 2 ; drawmode 
       fcb 15,19 ; starx/y relative to previous node
       fdb -13,90 ; dx/dy. dx(abs:-153|rel:90) dy(abs:12|rel:-13)
; node # 6 D(3,-21)->(-4,-21)
       fcb 2 ; drawmode 
       fcb 26,74 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:-89|rel:64) dy(abs:0|rel:-12)
; node # 7 D(-15,-18)->(-10,-18)
       fcb 2 ; drawmode 
       fcb -3,-18 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:64|rel:153) dy(abs:0|rel:0)
; node # 8 D(-86,4)->(-78,3)
       fcb 2 ; drawmode 
       fcb -22,-71 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:102|rel:38) dy(abs:12|rel:12)
; node # 9 D(-71,5)->(-83,4)
       fcb 2 ; drawmode 
       fcb -1,15 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-153|rel:-255) dy(abs:12|rel:0)
; node # 10 D(15,5)->(8,5)
       fcb 2 ; drawmode 
       fcb 0,86 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:-89|rel:64) dy(abs:0|rel:-12)
; node # 11 D(-7,4)->(0,3)
       fcb 2 ; drawmode 
       fcb 1,-22 ; starx/y relative to previous node
       fdb 12,178 ; dx/dy. dx(abs:89|rel:178) dy(abs:12|rel:12)
; node # 12 D(-15,-18)->(-10,-18)
       fcb 2 ; drawmode 
       fcb 22,-8 ; starx/y relative to previous node
       fdb -12,-25 ; dx/dy. dx(abs:64|rel:-25) dy(abs:0|rel:-12)
; node # 13 M(-10,-8)->(-7,-9)
       fcb 0 ; drawmode 
       fcb -10,5 ; starx/y relative to previous node
       fdb 12,-26 ; dx/dy. dx(abs:38|rel:-26) dy(abs:12|rel:12)
; node # 14 D(-10,-30)->(-7,-30)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:38|rel:0) dy(abs:0|rel:-12)
; node # 15 M(3,-21)->(-4,-21)
       fcb 0 ; drawmode 
       fcb -9,13 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-89|rel:-127) dy(abs:0|rel:0)
; node # 16 D(15,5)->(8,5)
       fcb 2 ; drawmode 
       fcb -26,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-89|rel:0) dy(abs:0|rel:0)
; node # 17 D(39,16)->(31,16)
       fcb 2 ; drawmode 
       fcb -11,24 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-102|rel:-13) dy(abs:0|rel:0)
; node # 18 D(-40,18)->(-61,17)
       fcb 2 ; drawmode 
       fcb -2,-79 ; starx/y relative to previous node
       fdb 12,-166 ; dx/dy. dx(abs:-268|rel:-166) dy(abs:12|rel:12)
; node # 19 D(-90,20)->(-109,18)
       fcb 2 ; drawmode 
       fcb -2,-50 ; starx/y relative to previous node
       fdb 13,25 ; dx/dy. dx(abs:-243|rel:25) dy(abs:25|rel:13)
; node # 20 D(-109,15)->(-96,13)
       fcb 2 ; drawmode 
       fcb 5,-19 ; starx/y relative to previous node
       fdb 0,409 ; dx/dy. dx(abs:166|rel:409) dy(abs:25|rel:0)
; node # 21 D(1,13)->(13,13)
       fcb 2 ; drawmode 
       fcb 2,110 ; starx/y relative to previous node
       fdb -25,-13 ; dx/dy. dx(abs:153|rel:-13) dy(abs:0|rel:-25)
; node # 22 D(39,16)->(31,16)
       fcb 2 ; drawmode 
       fcb -3,38 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-102|rel:-255) dy(abs:0|rel:0)
; node # 23 D(26,28)->(19,29)
       fcb 2 ; drawmode 
       fcb -12,-13 ; starx/y relative to previous node
       fdb -12,13 ; dx/dy. dx(abs:-89|rel:13) dy(abs:-12|rel:-12)
; node # 24 D(-1,24)->(8,24)
       fcb 2 ; drawmode 
       fcb 4,-27 ; starx/y relative to previous node
       fdb 12,204 ; dx/dy. dx(abs:115|rel:204) dy(abs:0|rel:12)
; node # 25 D(1,13)->(13,13)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:153|rel:38) dy(abs:0|rel:0)
; node # 26 D(-7,4)->(0,3)
       fcb 2 ; drawmode 
       fcb 9,-8 ; starx/y relative to previous node
       fdb 12,-64 ; dx/dy. dx(abs:89|rel:-64) dy(abs:12|rel:12)
; node # 27 D(-86,4)->(-78,3)
       fcb 2 ; drawmode 
       fcb 0,-79 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:102|rel:13) dy(abs:12|rel:0)
; node # 28 M(-96,29)->(-89,25)
       fcb 0 ; drawmode 
       fcb -25,-10 ; starx/y relative to previous node
       fdb 39,-13 ; dx/dy. dx(abs:89|rel:-13) dy(abs:51|rel:39)
; node # 29 D(-1,24)->(8,24)
       fcb 2 ; drawmode 
       fcb 5,95 ; starx/y relative to previous node
       fdb -51,26 ; dx/dy. dx(abs:115|rel:26) dy(abs:0|rel:-51)
; node # 30 M(26,28)->(19,29)
       fcb 0 ; drawmode 
       fcb -4,27 ; starx/y relative to previous node
       fdb -12,-204 ; dx/dy. dx(abs:-89|rel:-204) dy(abs:-12|rel:-12)
; node # 31 D(-81,35)->(-96,31)
       fcb 2 ; drawmode 
       fcb -7,-107 ; starx/y relative to previous node
       fdb 63,-103 ; dx/dy. dx(abs:-192|rel:-103) dy(abs:51|rel:63)
; node # 32 M(-100,-8)->(-102,-8)
       fcb 0 ; drawmode 
       fcb 43,-19 ; starx/y relative to previous node
       fdb -51,167 ; dx/dy. dx(abs:-25|rel:167) dy(abs:0|rel:-51)
; node # 33 D(-101,-8)->(-101,-8)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:0|rel:0)
; node # 34 D(-101,-16)->(-101,-14)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-25|rel:-25)
; node # 35 D(-100,-17)->(-102,-14)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb -13,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:-38|rel:-13)
; node # 36 D(-23,-14)->(-25,-14)
       fcb 2 ; drawmode 
       fcb -3,77 ; starx/y relative to previous node
       fdb 38,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:0|rel:38)
; node # 37 D(-26,-14)->(-25,-14)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:12|rel:37) dy(abs:0|rel:0)
; node # 38 D(-43,-8)->(-44,-8)
       fcb 2 ; drawmode 
       fcb -6,-17 ; starx/y relative to previous node
       fdb 0,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:0|rel:0)
; node # 39 D(-39,-8)->(-44,-8)
       fcb 2 ; drawmode 
       fcb 0,4 ; starx/y relative to previous node
       fdb 0,-52 ; dx/dy. dx(abs:-64|rel:-52) dy(abs:0|rel:0)
; node # 40 D(-100,-8)->(-102,-8)
       fcb 2 ; drawmode 
       fcb 0,-61 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:-25|rel:39) dy(abs:0|rel:0)
; node # 41 D(-100,-17)->(-102,-14)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb -38,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:-38|rel:-38)
; node # 42 M(-101,-8)->(-101,-8)
       fcb 0 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb 38,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:0|rel:38)
; node # 43 D(-43,-8)->(-44,-8)
       fcb 2 ; drawmode 
       fcb 0,58 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:0|rel:0)
; node # 44 M(-23,-14)->(-25,-14)
       fcb 0 ; drawmode 
       fcb 6,20 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:0|rel:0)
; node # 45 D(-39,-8)->(-44,-8)
       fcb 2 ; drawmode 
       fcb -6,-16 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:-64|rel:-39) dy(abs:0|rel:0)
; node # 46 M(-26,-14)->(-25,-14)
       fcb 0 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb 0,76 ; dx/dy. dx(abs:12|rel:76) dy(abs:0|rel:0)
; node # 47 D(-101,-16)->(-101,-14)
       fcb 2 ; drawmode 
       fcb 2,-75 ; starx/y relative to previous node
       fdb -25,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-25|rel:-25)
       fcb  1  ; end of anim
; Animation 4
battleframe4:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-78,3)->(-65,3)
       fcb 0 ; drawmode 
       fcb -3,-78 ; starx/y relative to previous node
       fdb 0,166 ; dx/dy. dx(abs:166|rel:166) dy(abs:0|rel:0)
; node # 1 D(-96,13)->(-76,12)
       fcb 2 ; drawmode 
       fcb -10,-18 ; starx/y relative to previous node
       fdb 12,90 ; dx/dy. dx(abs:256|rel:90) dy(abs:12|rel:12)
; node # 2 D(-89,25)->(-73,23)
       fcb 2 ; drawmode 
       fcb -12,7 ; starx/y relative to previous node
       fdb 13,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:25|rel:13)
; node # 3 D(-96,31)->(-96,27)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 26,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:51|rel:26)
; node # 4 D(-109,18)->(-110,15)
       fcb 2 ; drawmode 
       fcb 13,-13 ; starx/y relative to previous node
       fdb -13,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:38|rel:-13)
; node # 5 D(-83,4)->(-83,4)
       fcb 2 ; drawmode 
       fcb 14,26 ; starx/y relative to previous node
       fdb -38,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:-38)
; node # 6 D(-4,-21)->(-11,-20)
       fcb 2 ; drawmode 
       fcb 25,79 ; starx/y relative to previous node
       fdb -12,-89 ; dx/dy. dx(abs:-89|rel:-89) dy(abs:-12|rel:-12)
; node # 7 D(-10,-18)->(-4,-18)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb 12,165 ; dx/dy. dx(abs:76|rel:165) dy(abs:0|rel:12)
; node # 8 D(-78,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb -21,-68 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:166|rel:90) dy(abs:0|rel:0)
; node # 9 D(-83,4)->(-83,4)
       fcb 2 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb 0,-166 ; dx/dy. dx(abs:0|rel:-166) dy(abs:0|rel:0)
; node # 10 D(8,5)->(0,5)
       fcb 2 ; drawmode 
       fcb -1,91 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:0|rel:0)
; node # 11 D(0,3)->(7,4)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb -12,191 ; dx/dy. dx(abs:89|rel:191) dy(abs:-12|rel:-12)
; node # 12 D(-10,-18)->(-4,-18)
       fcb 2 ; drawmode 
       fcb 21,-10 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:76|rel:-13) dy(abs:0|rel:12)
; node # 13 M(-7,-9)->(-4,-8)
       fcb 0 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb -12,-38 ; dx/dy. dx(abs:38|rel:-38) dy(abs:-12|rel:-12)
; node # 14 D(-7,-30)->(-4,-30)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:38|rel:0) dy(abs:0|rel:12)
; node # 15 M(-4,-21)->(-11,-20)
       fcb 0 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb -12,-127 ; dx/dy. dx(abs:-89|rel:-127) dy(abs:-12|rel:-12)
; node # 16 D(8,5)->(0,5)
       fcb 2 ; drawmode 
       fcb -26,12 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:-102|rel:-13) dy(abs:0|rel:12)
; node # 17 D(31,16)->(18,17)
       fcb 2 ; drawmode 
       fcb -11,23 ; starx/y relative to previous node
       fdb -12,-64 ; dx/dy. dx(abs:-166|rel:-64) dy(abs:-12|rel:-12)
; node # 18 D(-61,17)->(-60,16)
       fcb 2 ; drawmode 
       fcb -1,-92 ; starx/y relative to previous node
       fdb 24,178 ; dx/dy. dx(abs:12|rel:178) dy(abs:12|rel:24)
; node # 19 D(-109,18)->(-110,15)
       fcb 2 ; drawmode 
       fcb -1,-48 ; starx/y relative to previous node
       fdb 26,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:38|rel:26)
; node # 20 D(-96,13)->(-76,12)
       fcb 2 ; drawmode 
       fcb 5,13 ; starx/y relative to previous node
       fdb -26,268 ; dx/dy. dx(abs:256|rel:268) dy(abs:12|rel:-26)
; node # 21 D(13,13)->(24,13)
       fcb 2 ; drawmode 
       fcb 0,109 ; starx/y relative to previous node
       fdb -12,-116 ; dx/dy. dx(abs:140|rel:-116) dy(abs:0|rel:-12)
; node # 22 D(31,16)->(18,17)
       fcb 2 ; drawmode 
       fcb -3,18 ; starx/y relative to previous node
       fdb -12,-306 ; dx/dy. dx(abs:-166|rel:-306) dy(abs:-12|rel:-12)
; node # 23 D(19,29)->(9,30)
       fcb 2 ; drawmode 
       fcb -13,-12 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:-128|rel:38) dy(abs:-12|rel:0)
; node # 24 D(8,24)->(16,25)
       fcb 2 ; drawmode 
       fcb 5,-11 ; starx/y relative to previous node
       fdb 0,230 ; dx/dy. dx(abs:102|rel:230) dy(abs:-12|rel:0)
; node # 25 D(13,13)->(24,13)
       fcb 2 ; drawmode 
       fcb 11,5 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:140|rel:38) dy(abs:0|rel:12)
; node # 26 D(0,3)->(7,4)
       fcb 2 ; drawmode 
       fcb 10,-13 ; starx/y relative to previous node
       fdb -12,-51 ; dx/dy. dx(abs:89|rel:-51) dy(abs:-12|rel:-12)
; node # 27 D(-78,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb 0,-78 ; starx/y relative to previous node
       fdb 12,77 ; dx/dy. dx(abs:166|rel:77) dy(abs:0|rel:12)
; node # 28 M(-89,25)->(-73,23)
       fcb 0 ; drawmode 
       fcb -22,-11 ; starx/y relative to previous node
       fdb 25,38 ; dx/dy. dx(abs:204|rel:38) dy(abs:25|rel:25)
; node # 29 D(8,24)->(16,25)
       fcb 2 ; drawmode 
       fcb 1,97 ; starx/y relative to previous node
       fdb -37,-102 ; dx/dy. dx(abs:102|rel:-102) dy(abs:-12|rel:-37)
; node # 30 M(19,29)->(9,30)
       fcb 0 ; drawmode 
       fcb -5,11 ; starx/y relative to previous node
       fdb 0,-230 ; dx/dy. dx(abs:-128|rel:-230) dy(abs:-12|rel:0)
; node # 31 D(-96,31)->(-96,27)
       fcb 2 ; drawmode 
       fcb -2,-115 ; starx/y relative to previous node
       fdb 63,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:51|rel:63)
; node # 32 M(-102,-8)->(-92,-7)
       fcb 0 ; drawmode 
       fcb 39,-6 ; starx/y relative to previous node
       fdb -63,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-12|rel:-63)
; node # 33 D(-101,-8)->(-89,-7)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:153|rel:25) dy(abs:-12|rel:0)
; node # 34 D(-101,-14)->(-89,-13)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-12|rel:0)
; node # 35 D(-102,-14)->(-92,-13)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:128|rel:-25) dy(abs:-12|rel:0)
; node # 36 D(-25,-14)->(-24,-13)
       fcb 2 ; drawmode 
       fcb 0,77 ; starx/y relative to previous node
       fdb 0,-116 ; dx/dy. dx(abs:12|rel:-116) dy(abs:-12|rel:0)
; node # 37 D(-25,-14)->(-25,-13)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-12|rel:0)
; node # 38 D(-44,-8)->(-41,-7)
       fcb 2 ; drawmode 
       fcb -6,-19 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:-12|rel:0)
; node # 39 D(-44,-8)->(-43,-7)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-12|rel:0)
; node # 40 D(-102,-8)->(-92,-7)
       fcb 2 ; drawmode 
       fcb 0,-58 ; starx/y relative to previous node
       fdb 0,116 ; dx/dy. dx(abs:128|rel:116) dy(abs:-12|rel:0)
; node # 41 D(-102,-14)->(-92,-13)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:-12|rel:0)
; node # 42 M(-101,-8)->(-89,-7)
       fcb 0 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:153|rel:25) dy(abs:-12|rel:0)
; node # 43 D(-44,-8)->(-41,-7)
       fcb 2 ; drawmode 
       fcb 0,57 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:38|rel:-115) dy(abs:-12|rel:0)
; node # 44 M(-25,-14)->(-24,-13)
       fcb 0 ; drawmode 
       fcb 6,19 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:-12|rel:0)
; node # 45 D(-44,-8)->(-43,-7)
       fcb 2 ; drawmode 
       fcb -6,-19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-12|rel:0)
; node # 46 M(-25,-14)->(-25,-13)
       fcb 0 ; drawmode 
       fcb 6,19 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-12|rel:0)
; node # 47 D(-101,-14)->(-89,-13)
       fcb 2 ; drawmode 
       fcb 0,-76 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:-12|rel:0)
       fcb  1  ; end of anim
; Animation 5
battleframe5:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-65,3)->(-48,3)
       fcb 0 ; drawmode 
       fcb -3,-65 ; starx/y relative to previous node
       fdb 0,217 ; dx/dy. dx(abs:217|rel:217) dy(abs:0|rel:0)
; node # 1 D(-76,12)->(-52,11)
       fcb 2 ; drawmode 
       fcb -9,-11 ; starx/y relative to previous node
       fdb 12,90 ; dx/dy. dx(abs:307|rel:90) dy(abs:12|rel:12)
; node # 2 D(-73,23)->(-52,21)
       fcb 2 ; drawmode 
       fcb -11,3 ; starx/y relative to previous node
       fdb 13,-39 ; dx/dy. dx(abs:268|rel:-39) dy(abs:25|rel:13)
; node # 3 D(-96,27)->(-83,25)
       fcb 2 ; drawmode 
       fcb -4,-23 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:166|rel:-102) dy(abs:25|rel:0)
; node # 4 D(-110,15)->(-97,14)
       fcb 2 ; drawmode 
       fcb 12,-14 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:166|rel:0) dy(abs:12|rel:-13)
; node # 5 D(-83,4)->(-74,3)
       fcb 2 ; drawmode 
       fcb 11,27 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:115|rel:-51) dy(abs:12|rel:0)
; node # 6 D(-11,-20)->(-16,-20)
       fcb 2 ; drawmode 
       fcb 24,72 ; starx/y relative to previous node
       fdb -12,-179 ; dx/dy. dx(abs:-64|rel:-179) dy(abs:0|rel:-12)
; node # 7 D(-4,-18)->(3,-18)
       fcb 2 ; drawmode 
       fcb -2,7 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:89|rel:153) dy(abs:0|rel:0)
; node # 8 D(-65,3)->(-48,3)
       fcb 2 ; drawmode 
       fcb -21,-61 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:217|rel:128) dy(abs:0|rel:0)
; node # 9 D(-83,4)->(-74,3)
       fcb 2 ; drawmode 
       fcb -1,-18 ; starx/y relative to previous node
       fdb 12,-102 ; dx/dy. dx(abs:115|rel:-102) dy(abs:12|rel:12)
; node # 10 D(0,5)->(-8,5)
       fcb 2 ; drawmode 
       fcb -1,83 ; starx/y relative to previous node
       fdb -12,-217 ; dx/dy. dx(abs:-102|rel:-217) dy(abs:0|rel:-12)
; node # 11 D(7,4)->(13,4)
       fcb 2 ; drawmode 
       fcb 1,7 ; starx/y relative to previous node
       fdb 0,178 ; dx/dy. dx(abs:76|rel:178) dy(abs:0|rel:0)
; node # 12 D(-4,-18)->(3,-18)
       fcb 2 ; drawmode 
       fcb 22,-11 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:89|rel:13) dy(abs:0|rel:0)
; node # 13 M(-4,-8)->(-1,-8)
       fcb 0 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:38|rel:-51) dy(abs:0|rel:0)
; node # 14 D(-4,-30)->(-1,-29)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:38|rel:0) dy(abs:-12|rel:-12)
; node # 15 M(-11,-20)->(-16,-20)
       fcb 0 ; drawmode 
       fcb -10,-7 ; starx/y relative to previous node
       fdb 12,-102 ; dx/dy. dx(abs:-64|rel:-102) dy(abs:0|rel:12)
; node # 16 D(0,5)->(-8,5)
       fcb 2 ; drawmode 
       fcb -25,11 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:-102|rel:-38) dy(abs:0|rel:0)
; node # 17 D(18,17)->(1,17)
       fcb 2 ; drawmode 
       fcb -12,18 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:-217|rel:-115) dy(abs:0|rel:0)
; node # 18 D(-60,16)->(-64,15)
       fcb 2 ; drawmode 
       fcb 1,-78 ; starx/y relative to previous node
       fdb 12,166 ; dx/dy. dx(abs:-51|rel:166) dy(abs:12|rel:12)
; node # 19 D(-110,15)->(-97,14)
       fcb 2 ; drawmode 
       fcb 1,-50 ; starx/y relative to previous node
       fdb 0,217 ; dx/dy. dx(abs:166|rel:217) dy(abs:12|rel:0)
; node # 20 D(-76,12)->(-52,11)
       fcb 2 ; drawmode 
       fcb 3,34 ; starx/y relative to previous node
       fdb 0,141 ; dx/dy. dx(abs:307|rel:141) dy(abs:12|rel:0)
; node # 21 D(24,13)->(35,14)
       fcb 2 ; drawmode 
       fcb -1,100 ; starx/y relative to previous node
       fdb -24,-167 ; dx/dy. dx(abs:140|rel:-167) dy(abs:-12|rel:-24)
; node # 22 D(18,17)->(1,17)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb 12,-357 ; dx/dy. dx(abs:-217|rel:-357) dy(abs:0|rel:12)
; node # 23 D(9,30)->(-2,30)
       fcb 2 ; drawmode 
       fcb -13,-9 ; starx/y relative to previous node
       fdb 0,77 ; dx/dy. dx(abs:-140|rel:77) dy(abs:0|rel:0)
; node # 24 D(16,25)->(23,25)
       fcb 2 ; drawmode 
       fcb 5,7 ; starx/y relative to previous node
       fdb 0,229 ; dx/dy. dx(abs:89|rel:229) dy(abs:0|rel:0)
; node # 25 D(24,13)->(35,14)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb -12,51 ; dx/dy. dx(abs:140|rel:51) dy(abs:-12|rel:-12)
; node # 26 D(7,4)->(13,4)
       fcb 2 ; drawmode 
       fcb 9,-17 ; starx/y relative to previous node
       fdb 12,-64 ; dx/dy. dx(abs:76|rel:-64) dy(abs:0|rel:12)
; node # 27 D(-65,3)->(-48,3)
       fcb 2 ; drawmode 
       fcb 1,-72 ; starx/y relative to previous node
       fdb 0,141 ; dx/dy. dx(abs:217|rel:141) dy(abs:0|rel:0)
; node # 28 M(-73,23)->(-52,21)
       fcb 0 ; drawmode 
       fcb -20,-8 ; starx/y relative to previous node
       fdb 25,51 ; dx/dy. dx(abs:268|rel:51) dy(abs:25|rel:25)
; node # 29 D(16,25)->(23,25)
       fcb 2 ; drawmode 
       fcb -2,89 ; starx/y relative to previous node
       fdb -25,-179 ; dx/dy. dx(abs:89|rel:-179) dy(abs:0|rel:-25)
; node # 30 M(9,30)->(-2,30)
       fcb 0 ; drawmode 
       fcb -5,-7 ; starx/y relative to previous node
       fdb 0,-229 ; dx/dy. dx(abs:-140|rel:-229) dy(abs:0|rel:0)
; node # 31 D(-96,27)->(-83,25)
       fcb 2 ; drawmode 
       fcb 3,-105 ; starx/y relative to previous node
       fdb 25,306 ; dx/dy. dx(abs:166|rel:306) dy(abs:25|rel:25)
; node # 32 M(-92,-7)->(-74,-7)
       fcb 0 ; drawmode 
       fcb 34,4 ; starx/y relative to previous node
       fdb -25,64 ; dx/dy. dx(abs:230|rel:64) dy(abs:0|rel:-25)
; node # 33 D(-89,-7)->(-71,-7)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:0|rel:0)
; node # 34 D(-89,-13)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:-25|rel:-25)
; node # 35 D(-92,-13)->(-74,-12)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:-12|rel:13)
; node # 36 D(-24,-13)->(-24,-13)
       fcb 2 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 12,-230 ; dx/dy. dx(abs:0|rel:-230) dy(abs:0|rel:12)
; node # 37 D(-25,-13)->(-21,-13)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:0|rel:0)
; node # 38 D(-41,-7)->(-34,-7)
       fcb 2 ; drawmode 
       fcb -6,-16 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:89|rel:38) dy(abs:0|rel:0)
; node # 39 D(-43,-7)->(-37,-7)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:76|rel:-13) dy(abs:0|rel:0)
; node # 40 D(-92,-7)->(-74,-7)
       fcb 2 ; drawmode 
       fcb 0,-49 ; starx/y relative to previous node
       fdb 0,154 ; dx/dy. dx(abs:230|rel:154) dy(abs:0|rel:0)
; node # 41 D(-92,-13)->(-74,-12)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:-12|rel:-12)
; node # 42 M(-89,-7)->(-71,-7)
       fcb 0 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:0|rel:12)
; node # 43 D(-41,-7)->(-34,-7)
       fcb 2 ; drawmode 
       fcb 0,48 ; starx/y relative to previous node
       fdb 0,-141 ; dx/dy. dx(abs:89|rel:-141) dy(abs:0|rel:0)
; node # 44 M(-24,-13)->(-24,-13)
       fcb 0 ; drawmode 
       fcb 6,17 ; starx/y relative to previous node
       fdb 0,-89 ; dx/dy. dx(abs:0|rel:-89) dy(abs:0|rel:0)
; node # 45 D(-43,-7)->(-37,-7)
       fcb 2 ; drawmode 
       fcb -6,-19 ; starx/y relative to previous node
       fdb 0,76 ; dx/dy. dx(abs:76|rel:76) dy(abs:0|rel:0)
; node # 46 M(-25,-13)->(-21,-13)
       fcb 0 ; drawmode 
       fcb 6,18 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:51|rel:-25) dy(abs:0|rel:0)
; node # 47 D(-89,-13)->(-71,-11)
       fcb 2 ; drawmode 
       fcb 0,-64 ; starx/y relative to previous node
       fdb -25,179 ; dx/dy. dx(abs:230|rel:179) dy(abs:-25|rel:-25)
       fcb  1  ; end of anim
; Animation 6
battleframe6:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-48,3)->(-27,3)
       fcb 0 ; drawmode 
       fcb -3,-48 ; starx/y relative to previous node
       fdb 0,268 ; dx/dy. dx(abs:268|rel:268) dy(abs:0|rel:0)
; node # 1 D(-52,11)->(-26,11)
       fcb 2 ; drawmode 
       fcb -8,-4 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:332|rel:64) dy(abs:0|rel:0)
; node # 2 D(-52,21)->(-28,20)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 12,-25 ; dx/dy. dx(abs:307|rel:-25) dy(abs:12|rel:12)
; node # 3 D(-83,25)->(-66,23)
       fcb 2 ; drawmode 
       fcb -4,-31 ; starx/y relative to previous node
       fdb 13,-90 ; dx/dy. dx(abs:217|rel:-90) dy(abs:25|rel:13)
; node # 4 D(-97,14)->(-77,13)
       fcb 2 ; drawmode 
       fcb 11,-14 ; starx/y relative to previous node
       fdb -13,39 ; dx/dy. dx(abs:256|rel:39) dy(abs:12|rel:-13)
; node # 5 D(-74,3)->(-58,3)
       fcb 2 ; drawmode 
       fcb 11,23 ; starx/y relative to previous node
       fdb -12,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:0|rel:-12)
; node # 6 D(-16,-20)->(-20,-20)
       fcb 2 ; drawmode 
       fcb 23,58 ; starx/y relative to previous node
       fdb 0,-255 ; dx/dy. dx(abs:-51|rel:-255) dy(abs:0|rel:0)
; node # 7 D(3,-18)->(9,-18)
       fcb 2 ; drawmode 
       fcb -2,19 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:76|rel:127) dy(abs:0|rel:0)
; node # 8 D(-48,3)->(-27,3)
       fcb 2 ; drawmode 
       fcb -21,-51 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:268|rel:192) dy(abs:0|rel:0)
; node # 9 D(-74,3)->(-58,3)
       fcb 2 ; drawmode 
       fcb 0,-26 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:204|rel:-64) dy(abs:0|rel:0)
; node # 10 D(-8,5)->(-15,5)
       fcb 2 ; drawmode 
       fcb -2,66 ; starx/y relative to previous node
       fdb 0,-293 ; dx/dy. dx(abs:-89|rel:-293) dy(abs:0|rel:0)
; node # 11 D(13,4)->(19,4)
       fcb 2 ; drawmode 
       fcb 1,21 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:76|rel:165) dy(abs:0|rel:0)
; node # 12 D(3,-18)->(9,-18)
       fcb 2 ; drawmode 
       fcb 22,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:76|rel:0) dy(abs:0|rel:0)
; node # 13 M(-1,-8)->(3,-9)
       fcb 0 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb 12,-25 ; dx/dy. dx(abs:51|rel:-25) dy(abs:12|rel:12)
; node # 14 D(-1,-29)->(3,-29)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:0|rel:-12)
; node # 15 M(-16,-20)->(-20,-20)
       fcb 0 ; drawmode 
       fcb -9,-15 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-51|rel:-102) dy(abs:0|rel:0)
; node # 16 D(-8,5)->(-15,5)
       fcb 2 ; drawmode 
       fcb -25,8 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:-89|rel:-38) dy(abs:0|rel:0)
; node # 17 D(1,17)->(-15,17)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:-204|rel:-115) dy(abs:0|rel:0)
; node # 18 D(-97,14)->(-77,13)
       fcb 2 ; drawmode 
       fcb 3,-98 ; starx/y relative to previous node
       fdb 12,460 ; dx/dy. dx(abs:256|rel:460) dy(abs:12|rel:12)
; node # 19 D(-52,11)->(-26,11)
       fcb 2 ; drawmode 
       fcb 3,45 ; starx/y relative to previous node
       fdb -12,76 ; dx/dy. dx(abs:332|rel:76) dy(abs:0|rel:-12)
; node # 20 D(35,14)->(40,14)
       fcb 2 ; drawmode 
       fcb -3,87 ; starx/y relative to previous node
       fdb 0,-268 ; dx/dy. dx(abs:64|rel:-268) dy(abs:0|rel:0)
; node # 21 D(1,17)->(-15,17)
       fcb 2 ; drawmode 
       fcb -3,-34 ; starx/y relative to previous node
       fdb 0,-268 ; dx/dy. dx(abs:-204|rel:-268) dy(abs:0|rel:0)
; node # 22 D(-2,30)->(-13,29)
       fcb 2 ; drawmode 
       fcb -13,-3 ; starx/y relative to previous node
       fdb 12,64 ; dx/dy. dx(abs:-140|rel:64) dy(abs:12|rel:12)
; node # 23 D(23,25)->(28,26)
       fcb 2 ; drawmode 
       fcb 5,25 ; starx/y relative to previous node
       fdb -24,204 ; dx/dy. dx(abs:64|rel:204) dy(abs:-12|rel:-24)
; node # 24 D(35,14)->(40,14)
       fcb 2 ; drawmode 
       fcb 11,12 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:0|rel:12)
; node # 25 D(13,4)->(19,4)
       fcb 2 ; drawmode 
       fcb 10,-22 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:76|rel:12) dy(abs:0|rel:0)
; node # 26 D(-48,3)->(-27,3)
       fcb 2 ; drawmode 
       fcb 1,-61 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:268|rel:192) dy(abs:0|rel:0)
; node # 27 M(-52,21)->(-28,20)
       fcb 0 ; drawmode 
       fcb -18,-4 ; starx/y relative to previous node
       fdb 12,39 ; dx/dy. dx(abs:307|rel:39) dy(abs:12|rel:12)
; node # 28 D(23,25)->(28,26)
       fcb 2 ; drawmode 
       fcb -4,75 ; starx/y relative to previous node
       fdb -24,-243 ; dx/dy. dx(abs:64|rel:-243) dy(abs:-12|rel:-24)
; node # 29 M(-2,30)->(-13,29)
       fcb 0 ; drawmode 
       fcb -5,-25 ; starx/y relative to previous node
       fdb 24,-204 ; dx/dy. dx(abs:-140|rel:-204) dy(abs:12|rel:24)
; node # 30 D(-83,25)->(-66,23)
       fcb 2 ; drawmode 
       fcb 5,-81 ; starx/y relative to previous node
       fdb 13,357 ; dx/dy. dx(abs:217|rel:357) dy(abs:25|rel:13)
; node # 31 M(-74,-7)->(-52,-7)
       fcb 0 ; drawmode 
       fcb 32,9 ; starx/y relative to previous node
       fdb -25,64 ; dx/dy. dx(abs:281|rel:64) dy(abs:0|rel:-25)
; node # 32 D(-71,-7)->(-48,-6)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb -12,13 ; dx/dy. dx(abs:294|rel:13) dy(abs:-12|rel:-12)
; node # 33 D(-71,-11)->(-48,-11)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:294|rel:0) dy(abs:0|rel:12)
; node # 34 D(-74,-12)->(-52,-11)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb -12,-13 ; dx/dy. dx(abs:281|rel:-13) dy(abs:-12|rel:-12)
; node # 35 D(-24,-13)->(-19,-13)
       fcb 2 ; drawmode 
       fcb 1,50 ; starx/y relative to previous node
       fdb 12,-217 ; dx/dy. dx(abs:64|rel:-217) dy(abs:0|rel:12)
; node # 36 D(-21,-13)->(-14,-13)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:89|rel:25) dy(abs:0|rel:0)
; node # 37 D(-34,-7)->(-23,-7)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:140|rel:51) dy(abs:0|rel:0)
; node # 38 D(-37,-7)->(-27,-7)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:128|rel:-12) dy(abs:0|rel:0)
; node # 39 D(-74,-7)->(-52,-7)
       fcb 2 ; drawmode 
       fcb 0,-37 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:281|rel:153) dy(abs:0|rel:0)
; node # 40 D(-74,-12)->(-52,-11)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:281|rel:0) dy(abs:-12|rel:-12)
; node # 41 M(-71,-7)->(-48,-6)
       fcb 0 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:294|rel:13) dy(abs:-12|rel:0)
; node # 42 D(-34,-7)->(-23,-7)
       fcb 2 ; drawmode 
       fcb 0,37 ; starx/y relative to previous node
       fdb 12,-154 ; dx/dy. dx(abs:140|rel:-154) dy(abs:0|rel:12)
; node # 43 M(-24,-13)->(-19,-13)
       fcb 0 ; drawmode 
       fcb 6,10 ; starx/y relative to previous node
       fdb 0,-76 ; dx/dy. dx(abs:64|rel:-76) dy(abs:0|rel:0)
; node # 44 D(-37,-7)->(-27,-7)
       fcb 2 ; drawmode 
       fcb -6,-13 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:128|rel:64) dy(abs:0|rel:0)
; node # 45 M(-21,-13)->(-14,-13)
       fcb 0 ; drawmode 
       fcb 6,16 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:89|rel:-39) dy(abs:0|rel:0)
; node # 46 D(-71,-11)->(-48,-11)
       fcb 2 ; drawmode 
       fcb -2,-50 ; starx/y relative to previous node
       fdb 0,205 ; dx/dy. dx(abs:294|rel:205) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 7
battleframe7:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-27,3)->(-4,3)
       fcb 0 ; drawmode 
       fcb -3,-27 ; starx/y relative to previous node
       fdb 0,294 ; dx/dy. dx(abs:294|rel:294) dy(abs:0|rel:0)
; node # 1 D(-26,11)->(0,11)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:332|rel:38) dy(abs:0|rel:0)
; node # 2 D(-28,20)->(-4,20)
       fcb 2 ; drawmode 
       fcb -9,-2 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:307|rel:-25) dy(abs:0|rel:0)
; node # 3 D(-66,23)->(-44,21)
       fcb 2 ; drawmode 
       fcb -3,-38 ; starx/y relative to previous node
       fdb 25,-26 ; dx/dy. dx(abs:281|rel:-26) dy(abs:25|rel:25)
; node # 4 D(-77,13)->(-53,12)
       fcb 2 ; drawmode 
       fcb 10,-11 ; starx/y relative to previous node
       fdb -13,26 ; dx/dy. dx(abs:307|rel:26) dy(abs:12|rel:-13)
; node # 5 D(-58,3)->(-39,3)
       fcb 2 ; drawmode 
       fcb 10,19 ; starx/y relative to previous node
       fdb -12,-64 ; dx/dy. dx(abs:243|rel:-64) dy(abs:0|rel:-12)
; node # 6 D(-20,-20)->(-21,-19)
       fcb 2 ; drawmode 
       fcb 23,38 ; starx/y relative to previous node
       fdb -12,-255 ; dx/dy. dx(abs:-12|rel:-255) dy(abs:-12|rel:-12)
; node # 7 D(9,-18)->(15,-18)
       fcb 2 ; drawmode 
       fcb -2,29 ; starx/y relative to previous node
       fdb 12,88 ; dx/dy. dx(abs:76|rel:88) dy(abs:0|rel:12)
; node # 8 D(-27,3)->(-4,3)
       fcb 2 ; drawmode 
       fcb -21,-36 ; starx/y relative to previous node
       fdb 0,218 ; dx/dy. dx(abs:294|rel:218) dy(abs:0|rel:0)
; node # 9 D(-58,3)->(-39,3)
       fcb 2 ; drawmode 
       fcb 0,-31 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:243|rel:-51) dy(abs:0|rel:0)
; node # 10 D(-15,5)->(-20,4)
       fcb 2 ; drawmode 
       fcb -2,43 ; starx/y relative to previous node
       fdb 12,-307 ; dx/dy. dx(abs:-64|rel:-307) dy(abs:12|rel:12)
; node # 11 D(19,4)->(22,4)
       fcb 2 ; drawmode 
       fcb 1,34 ; starx/y relative to previous node
       fdb -12,102 ; dx/dy. dx(abs:38|rel:102) dy(abs:0|rel:-12)
; node # 12 D(9,-18)->(15,-18)
       fcb 2 ; drawmode 
       fcb 22,-10 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:76|rel:38) dy(abs:0|rel:0)
; node # 13 M(3,-9)->(6,-8)
       fcb 0 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb -12,-38 ; dx/dy. dx(abs:38|rel:-38) dy(abs:-12|rel:-12)
; node # 14 D(3,-29)->(6,-29)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:38|rel:0) dy(abs:0|rel:12)
; node # 15 M(-20,-20)->(-21,-19)
       fcb 0 ; drawmode 
       fcb -9,-23 ; starx/y relative to previous node
       fdb -12,-50 ; dx/dy. dx(abs:-12|rel:-50) dy(abs:-12|rel:-12)
; node # 16 D(-15,5)->(-20,4)
       fcb 2 ; drawmode 
       fcb -25,5 ; starx/y relative to previous node
       fdb 24,-52 ; dx/dy. dx(abs:-64|rel:-52) dy(abs:12|rel:24)
; node # 17 D(-15,17)->(-29,16)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:-179|rel:-115) dy(abs:12|rel:0)
; node # 18 D(-77,13)->(-53,12)
       fcb 2 ; drawmode 
       fcb 4,-62 ; starx/y relative to previous node
       fdb 0,486 ; dx/dy. dx(abs:307|rel:486) dy(abs:12|rel:0)
; node # 19 D(-26,11)->(0,11)
       fcb 2 ; drawmode 
       fcb 2,51 ; starx/y relative to previous node
       fdb -12,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:0|rel:-12)
; node # 20 D(40,14)->(42,15)
       fcb 2 ; drawmode 
       fcb -3,66 ; starx/y relative to previous node
       fdb -12,-307 ; dx/dy. dx(abs:25|rel:-307) dy(abs:-12|rel:-12)
; node # 21 D(-15,17)->(-29,16)
       fcb 2 ; drawmode 
       fcb -3,-55 ; starx/y relative to previous node
       fdb 24,-204 ; dx/dy. dx(abs:-179|rel:-204) dy(abs:12|rel:24)
; node # 22 D(-13,29)->(-22,29)
       fcb 2 ; drawmode 
       fcb -12,2 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:-115|rel:64) dy(abs:0|rel:-12)
; node # 23 D(28,26)->(30,27)
       fcb 2 ; drawmode 
       fcb 3,41 ; starx/y relative to previous node
       fdb -12,140 ; dx/dy. dx(abs:25|rel:140) dy(abs:-12|rel:-12)
; node # 24 D(40,14)->(42,15)
       fcb 2 ; drawmode 
       fcb 12,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:-12|rel:0)
; node # 25 D(19,4)->(22,4)
       fcb 2 ; drawmode 
       fcb 10,-21 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:0|rel:12)
; node # 26 D(-27,3)->(-4,3)
       fcb 2 ; drawmode 
       fcb 1,-46 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:294|rel:256) dy(abs:0|rel:0)
; node # 27 M(-28,20)->(-4,20)
       fcb 0 ; drawmode 
       fcb -17,-1 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:307|rel:13) dy(abs:0|rel:0)
; node # 28 D(28,26)->(30,27)
       fcb 2 ; drawmode 
       fcb -6,56 ; starx/y relative to previous node
       fdb -12,-282 ; dx/dy. dx(abs:25|rel:-282) dy(abs:-12|rel:-12)
; node # 29 M(-13,29)->(-22,29)
       fcb 0 ; drawmode 
       fcb -3,-41 ; starx/y relative to previous node
       fdb 12,-140 ; dx/dy. dx(abs:-115|rel:-140) dy(abs:0|rel:12)
; node # 30 D(-66,23)->(-44,21)
       fcb 2 ; drawmode 
       fcb 6,-53 ; starx/y relative to previous node
       fdb 25,396 ; dx/dy. dx(abs:281|rel:396) dy(abs:25|rel:25)
; node # 31 M(-52,-7)->(-28,-6)
       fcb 0 ; drawmode 
       fcb 30,14 ; starx/y relative to previous node
       fdb -37,26 ; dx/dy. dx(abs:307|rel:26) dy(abs:-12|rel:-37)
; node # 32 D(-48,-6)->(-23,-6)
       fcb 2 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:320|rel:13) dy(abs:0|rel:12)
; node # 33 D(-48,-11)->(-23,-10)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:-12|rel:-12)
; node # 34 D(-52,-11)->(-27,-10)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:-12|rel:0)
; node # 35 D(-19,-13)->(-11,-13)
       fcb 2 ; drawmode 
       fcb 2,33 ; starx/y relative to previous node
       fdb 12,-218 ; dx/dy. dx(abs:102|rel:-218) dy(abs:0|rel:12)
; node # 36 D(-14,-13)->(-6,-12)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:-12|rel:-12)
; node # 37 D(-23,-7)->(-11,-7)
       fcb 2 ; drawmode 
       fcb -6,-9 ; starx/y relative to previous node
       fdb 12,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:0|rel:12)
; node # 38 D(-27,-7)->(-16,-7)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:140|rel:-13) dy(abs:0|rel:0)
; node # 39 D(-52,-7)->(-28,-6)
       fcb 2 ; drawmode 
       fcb 0,-25 ; starx/y relative to previous node
       fdb -12,167 ; dx/dy. dx(abs:307|rel:167) dy(abs:-12|rel:-12)
; node # 40 D(-52,-11)->(-27,-10)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:320|rel:13) dy(abs:-12|rel:0)
; node # 41 M(-48,-6)->(-23,-6)
       fcb 0 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:12)
; node # 42 D(-23,-7)->(-11,-7)
       fcb 2 ; drawmode 
       fcb 1,25 ; starx/y relative to previous node
       fdb 0,-167 ; dx/dy. dx(abs:153|rel:-167) dy(abs:0|rel:0)
; node # 43 M(-19,-13)->(-11,-13)
       fcb 0 ; drawmode 
       fcb 6,4 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:102|rel:-51) dy(abs:0|rel:0)
; node # 44 D(-27,-7)->(-16,-7)
       fcb 2 ; drawmode 
       fcb -6,-8 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:140|rel:38) dy(abs:0|rel:0)
; node # 45 M(-14,-13)->(-6,-12)
       fcb 0 ; drawmode 
       fcb 6,13 ; starx/y relative to previous node
       fdb -12,-38 ; dx/dy. dx(abs:102|rel:-38) dy(abs:-12|rel:-12)
; node # 46 D(-48,-11)->(-23,-10)
       fcb 2 ; drawmode 
       fcb -2,-34 ; starx/y relative to previous node
       fdb 0,218 ; dx/dy. dx(abs:320|rel:218) dy(abs:-12|rel:0)
       fcb  1  ; end of anim
; Animation 8
battleframe8:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-4,3)->(17,2)
       fcb 0 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 12,268 ; dx/dy. dx(abs:268|rel:268) dy(abs:12|rel:12)
; node # 1 D(0,11)->(26,12)
       fcb 2 ; drawmode 
       fcb -8,4 ; starx/y relative to previous node
       fdb -24,64 ; dx/dy. dx(abs:332|rel:64) dy(abs:-12|rel:-24)
; node # 2 D(-4,20)->(21,20)
       fcb 2 ; drawmode 
       fcb -9,-4 ; starx/y relative to previous node
       fdb 12,-12 ; dx/dy. dx(abs:320|rel:-12) dy(abs:0|rel:12)
; node # 3 D(-44,21)->(-20,20)
       fcb 2 ; drawmode 
       fcb -1,-40 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:307|rel:-13) dy(abs:12|rel:12)
; node # 4 D(-53,12)->(-27,12)
       fcb 2 ; drawmode 
       fcb 9,-9 ; starx/y relative to previous node
       fdb -12,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:0|rel:-12)
; node # 5 D(-39,3)->(-18,2)
       fcb 2 ; drawmode 
       fcb 9,14 ; starx/y relative to previous node
       fdb 12,-64 ; dx/dy. dx(abs:268|rel:-64) dy(abs:12|rel:12)
; node # 6 D(-21,-19)->(-19,-19)
       fcb 2 ; drawmode 
       fcb 22,18 ; starx/y relative to previous node
       fdb -12,-243 ; dx/dy. dx(abs:25|rel:-243) dy(abs:0|rel:-12)
; node # 7 D(15,-18)->(19,-19)
       fcb 2 ; drawmode 
       fcb -1,36 ; starx/y relative to previous node
       fdb 12,26 ; dx/dy. dx(abs:51|rel:26) dy(abs:12|rel:12)
; node # 8 D(-4,3)->(17,2)
       fcb 2 ; drawmode 
       fcb -21,-19 ; starx/y relative to previous node
       fdb 0,217 ; dx/dy. dx(abs:268|rel:217) dy(abs:12|rel:0)
; node # 9 D(-39,3)->(-17,2)
       fcb 2 ; drawmode 
       fcb 0,-35 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:281|rel:13) dy(abs:12|rel:0)
; node # 10 D(-20,4)->(-22,4)
       fcb 2 ; drawmode 
       fcb -1,19 ; starx/y relative to previous node
       fdb -12,-306 ; dx/dy. dx(abs:-25|rel:-306) dy(abs:0|rel:-12)
; node # 11 D(22,4)->(22,4)
       fcb 2 ; drawmode 
       fcb 0,42 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:0|rel:0)
; node # 12 D(15,-18)->(19,-19)
       fcb 2 ; drawmode 
       fcb 22,-7 ; starx/y relative to previous node
       fdb 12,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:12|rel:12)
; node # 13 M(6,-8)->(8,-8)
       fcb 0 ; drawmode 
       fcb -10,-9 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:25|rel:-26) dy(abs:0|rel:-12)
; node # 14 D(6,-29)->(8,-30)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:12|rel:12)
; node # 15 M(-21,-19)->(-19,-19)
       fcb 0 ; drawmode 
       fcb -10,-27 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:0|rel:-12)
; node # 16 D(-20,4)->(-22,4)
       fcb 2 ; drawmode 
       fcb -23,1 ; starx/y relative to previous node
       fdb 0,-50 ; dx/dy. dx(abs:-25|rel:-50) dy(abs:0|rel:0)
; node # 17 D(-29,16)->(-39,16)
       fcb 2 ; drawmode 
       fcb -12,-9 ; starx/y relative to previous node
       fdb 0,-103 ; dx/dy. dx(abs:-128|rel:-103) dy(abs:0|rel:0)
; node # 18 D(-53,12)->(-27,12)
       fcb 2 ; drawmode 
       fcb 4,-24 ; starx/y relative to previous node
       fdb 0,460 ; dx/dy. dx(abs:332|rel:460) dy(abs:0|rel:0)
; node # 19 D(0,11)->(26,12)
       fcb 2 ; drawmode 
       fcb 1,53 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:332|rel:0) dy(abs:-12|rel:-12)
; node # 20 D(42,15)->(39,16)
       fcb 2 ; drawmode 
       fcb -4,42 ; starx/y relative to previous node
       fdb 0,-370 ; dx/dy. dx(abs:-38|rel:-370) dy(abs:-12|rel:0)
; node # 21 D(-29,16)->(-39,16)
       fcb 2 ; drawmode 
       fcb -1,-71 ; starx/y relative to previous node
       fdb 12,-90 ; dx/dy. dx(abs:-128|rel:-90) dy(abs:0|rel:12)
; node # 22 D(-22,29)->(-28,28)
       fcb 2 ; drawmode 
       fcb -13,7 ; starx/y relative to previous node
       fdb 12,52 ; dx/dy. dx(abs:-76|rel:52) dy(abs:12|rel:12)
; node # 23 D(30,27)->(28,28)
       fcb 2 ; drawmode 
       fcb 2,52 ; starx/y relative to previous node
       fdb -24,51 ; dx/dy. dx(abs:-25|rel:51) dy(abs:-12|rel:-24)
; node # 24 D(42,15)->(39,16)
       fcb 2 ; drawmode 
       fcb 12,12 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:-12|rel:0)
; node # 25 D(22,4)->(22,4)
       fcb 2 ; drawmode 
       fcb 11,-20 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:0|rel:12)
; node # 26 D(-4,3)->(17,2)
       fcb 2 ; drawmode 
       fcb 1,-26 ; starx/y relative to previous node
       fdb 12,268 ; dx/dy. dx(abs:268|rel:268) dy(abs:12|rel:12)
; node # 27 M(-4,20)->(21,20)
       fcb 0 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb -12,52 ; dx/dy. dx(abs:320|rel:52) dy(abs:0|rel:-12)
; node # 28 D(30,27)->(28,28)
       fcb 2 ; drawmode 
       fcb -7,34 ; starx/y relative to previous node
       fdb -12,-345 ; dx/dy. dx(abs:-25|rel:-345) dy(abs:-12|rel:-12)
; node # 29 M(-22,29)->(-28,28)
       fcb 0 ; drawmode 
       fcb -2,-52 ; starx/y relative to previous node
       fdb 24,-51 ; dx/dy. dx(abs:-76|rel:-51) dy(abs:12|rel:24)
; node # 30 D(-44,21)->(-20,20)
       fcb 2 ; drawmode 
       fcb 8,-22 ; starx/y relative to previous node
       fdb 0,383 ; dx/dy. dx(abs:307|rel:383) dy(abs:12|rel:0)
; node # 31 M(-28,-6)->(-2,-6)
       fcb 0 ; drawmode 
       fcb 27,16 ; starx/y relative to previous node
       fdb -12,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:0|rel:-12)
; node # 32 D(-23,-6)->(2,-6)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:320|rel:-12) dy(abs:0|rel:0)
; node # 33 D(-23,-10)->(2,-10)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 34 D(-27,-10)->(-2,-10)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 35 D(-11,-13)->(-3,-12)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb -12,-218 ; dx/dy. dx(abs:102|rel:-218) dy(abs:-12|rel:-12)
; node # 36 D(-6,-12)->(3,-12)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:115|rel:13) dy(abs:0|rel:12)
; node # 37 D(-11,-7)->(2,-7)
       fcb 2 ; drawmode 
       fcb -5,-5 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:166|rel:51) dy(abs:0|rel:0)
; node # 38 D(-16,-7)->(-3,-7)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:166|rel:0) dy(abs:0|rel:0)
; node # 39 D(-28,-6)->(-2,-6)
       fcb 2 ; drawmode 
       fcb -1,-12 ; starx/y relative to previous node
       fdb 0,166 ; dx/dy. dx(abs:332|rel:166) dy(abs:0|rel:0)
; node # 40 D(-27,-10)->(-2,-10)
       fcb 2 ; drawmode 
       fcb 4,1 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:320|rel:-12) dy(abs:0|rel:0)
; node # 41 M(-23,-6)->(2,-6)
       fcb 0 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 42 D(-11,-7)->(2,-7)
       fcb 2 ; drawmode 
       fcb 1,12 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:166|rel:-154) dy(abs:0|rel:0)
; node # 43 M(-11,-13)->(-3,-12)
       fcb 0 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb -12,-64 ; dx/dy. dx(abs:102|rel:-64) dy(abs:-12|rel:-12)
; node # 44 D(-16,-7)->(-3,-7)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 12,64 ; dx/dy. dx(abs:166|rel:64) dy(abs:0|rel:12)
; node # 45 M(-6,-12)->(3,-12)
       fcb 0 ; drawmode 
       fcb 5,10 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:115|rel:-51) dy(abs:0|rel:0)
; node # 46 D(-23,-10)->(2,-10)
       fcb 2 ; drawmode 
       fcb -2,-17 ; starx/y relative to previous node
       fdb 0,205 ; dx/dy. dx(abs:320|rel:205) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 9
battleframe9:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(17,2)->(39,3)
       fcb 0 ; drawmode 
       fcb -2,17 ; starx/y relative to previous node
       fdb -12,281 ; dx/dy. dx(abs:281|rel:281) dy(abs:-12|rel:-12)
; node # 1 D(26,12)->(53,12)
       fcb 2 ; drawmode 
       fcb -10,9 ; starx/y relative to previous node
       fdb 12,64 ; dx/dy. dx(abs:345|rel:64) dy(abs:0|rel:12)
; node # 2 D(21,20)->(44,21)
       fcb 2 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb -12,-51 ; dx/dy. dx(abs:294|rel:-51) dy(abs:-12|rel:-12)
; node # 3 D(-20,20)->(3,20)
       fcb 2 ; drawmode 
       fcb 0,-41 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:294|rel:0) dy(abs:0|rel:12)
; node # 4 D(-27,12)->(0,11)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb 12,51 ; dx/dy. dx(abs:345|rel:51) dy(abs:12|rel:12)
; node # 5 D(-18,2)->(4,3)
       fcb 2 ; drawmode 
       fcb 10,9 ; starx/y relative to previous node
       fdb -24,-64 ; dx/dy. dx(abs:281|rel:-64) dy(abs:-12|rel:-24)
; node # 6 D(-19,-19)->(-16,-18)
       fcb 2 ; drawmode 
       fcb 21,-1 ; starx/y relative to previous node
       fdb 0,-243 ; dx/dy. dx(abs:38|rel:-243) dy(abs:-12|rel:0)
; node # 7 D(19,-19)->(21,-19)
       fcb 2 ; drawmode 
       fcb 0,38 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:0|rel:12)
; node # 8 D(17,2)->(39,3)
       fcb 2 ; drawmode 
       fcb -21,-2 ; starx/y relative to previous node
       fdb -12,256 ; dx/dy. dx(abs:281|rel:256) dy(abs:-12|rel:-12)
; node # 9 D(-17,2)->(4,3)
       fcb 2 ; drawmode 
       fcb 0,-34 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:268|rel:-13) dy(abs:-12|rel:0)
; node # 10 D(-22,4)->(-22,4)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb 12,-268 ; dx/dy. dx(abs:0|rel:-268) dy(abs:0|rel:12)
; node # 11 D(22,4)->(20,4)
       fcb 2 ; drawmode 
       fcb 0,44 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:0|rel:0)
; node # 12 D(19,-19)->(21,-19)
       fcb 2 ; drawmode 
       fcb 23,-3 ; starx/y relative to previous node
       fdb 0,50 ; dx/dy. dx(abs:25|rel:50) dy(abs:0|rel:0)
; node # 13 M(8,-8)->(10,-9)
       fcb 0 ; drawmode 
       fcb -11,-11 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:12|rel:12)
; node # 14 D(8,-30)->(10,-30)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:0|rel:-12)
; node # 15 M(-19,-19)->(-16,-18)
       fcb 0 ; drawmode 
       fcb -11,-27 ; starx/y relative to previous node
       fdb -12,13 ; dx/dy. dx(abs:38|rel:13) dy(abs:-12|rel:-12)
; node # 16 D(-22,4)->(-22,4)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb 12,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:0|rel:12)
; node # 17 D(-39,16)->(-43,15)
       fcb 2 ; drawmode 
       fcb -12,-17 ; starx/y relative to previous node
       fdb 12,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:12|rel:12)
; node # 18 D(-27,12)->(0,11)
       fcb 2 ; drawmode 
       fcb 4,12 ; starx/y relative to previous node
       fdb 0,396 ; dx/dy. dx(abs:345|rel:396) dy(abs:12|rel:0)
; node # 19 D(26,12)->(53,12)
       fcb 2 ; drawmode 
       fcb 0,53 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:345|rel:0) dy(abs:0|rel:-12)
; node # 20 D(39,16)->(29,17)
       fcb 2 ; drawmode 
       fcb -4,13 ; starx/y relative to previous node
       fdb -12,-473 ; dx/dy. dx(abs:-128|rel:-473) dy(abs:-12|rel:-12)
; node # 21 D(-39,16)->(-43,15)
       fcb 2 ; drawmode 
       fcb 0,-78 ; starx/y relative to previous node
       fdb 24,77 ; dx/dy. dx(abs:-51|rel:77) dy(abs:12|rel:24)
; node # 22 D(-28,28)->(-30,27)
       fcb 2 ; drawmode 
       fcb -12,11 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-25|rel:26) dy(abs:12|rel:0)
; node # 23 D(28,28)->(22,29)
       fcb 2 ; drawmode 
       fcb 0,56 ; starx/y relative to previous node
       fdb -24,-51 ; dx/dy. dx(abs:-76|rel:-51) dy(abs:-12|rel:-24)
; node # 24 D(39,16)->(29,17)
       fcb 2 ; drawmode 
       fcb 12,11 ; starx/y relative to previous node
       fdb 0,-52 ; dx/dy. dx(abs:-128|rel:-52) dy(abs:-12|rel:0)
; node # 25 D(22,4)->(20,4)
       fcb 2 ; drawmode 
       fcb 12,-17 ; starx/y relative to previous node
       fdb 12,103 ; dx/dy. dx(abs:-25|rel:103) dy(abs:0|rel:12)
; node # 26 D(17,2)->(39,3)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb -12,306 ; dx/dy. dx(abs:281|rel:306) dy(abs:-12|rel:-12)
; node # 27 M(21,20)->(44,21)
       fcb 0 ; drawmode 
       fcb -18,4 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:294|rel:13) dy(abs:-12|rel:0)
; node # 28 D(28,28)->(22,29)
       fcb 2 ; drawmode 
       fcb -8,7 ; starx/y relative to previous node
       fdb 0,-370 ; dx/dy. dx(abs:-76|rel:-370) dy(abs:-12|rel:0)
; node # 29 M(-28,28)->(-30,27)
       fcb 0 ; drawmode 
       fcb 0,-56 ; starx/y relative to previous node
       fdb 24,51 ; dx/dy. dx(abs:-25|rel:51) dy(abs:12|rel:24)
; node # 30 D(-20,20)->(3,20)
       fcb 2 ; drawmode 
       fcb 8,8 ; starx/y relative to previous node
       fdb -12,319 ; dx/dy. dx(abs:294|rel:319) dy(abs:0|rel:-12)
; node # 31 M(-2,-6)->(23,-6)
       fcb 0 ; drawmode 
       fcb 26,18 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:320|rel:26) dy(abs:0|rel:0)
; node # 32 D(2,-6)->(27,-6)
       fcb 2 ; drawmode 
       fcb 0,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 33 D(2,-10)->(27,-10)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 34 D(-2,-10)->(23,-10)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 35 D(-3,-12)->(5,-12)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 0,-218 ; dx/dy. dx(abs:102|rel:-218) dy(abs:0|rel:0)
; node # 36 D(3,-12)->(11,-13)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:12|rel:12)
; node # 37 D(2,-7)->(15,-7)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:166|rel:64) dy(abs:0|rel:-12)
; node # 38 D(-3,-7)->(10,-7)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:166|rel:0) dy(abs:0|rel:0)
; node # 39 D(-2,-6)->(23,-6)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 0,154 ; dx/dy. dx(abs:320|rel:154) dy(abs:0|rel:0)
; node # 40 D(-2,-10)->(23,-10)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 41 M(2,-6)->(27,-6)
       fcb 0 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:0|rel:0)
; node # 42 D(2,-7)->(15,-7)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:166|rel:-154) dy(abs:0|rel:0)
; node # 43 M(-3,-12)->(5,-12)
       fcb 0 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:102|rel:-64) dy(abs:0|rel:0)
; node # 44 D(-3,-7)->(10,-7)
       fcb 2 ; drawmode 
       fcb -5,0 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:166|rel:64) dy(abs:0|rel:0)
; node # 45 M(3,-12)->(11,-13)
       fcb 0 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb 12,-64 ; dx/dy. dx(abs:102|rel:-64) dy(abs:12|rel:12)
; node # 46 D(2,-10)->(27,-10)
       fcb 2 ; drawmode 
       fcb -2,-1 ; starx/y relative to previous node
       fdb -12,218 ; dx/dy. dx(abs:320|rel:218) dy(abs:0|rel:-12)
       fcb  1  ; end of anim
; Animation 10
battleframe10:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(39,3)->(59,4)
       fcb 0 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb -12,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-12|rel:-12)
; node # 1 D(53,12)->(77,12)
       fcb 2 ; drawmode 
       fcb -9,14 ; starx/y relative to previous node
       fdb 12,51 ; dx/dy. dx(abs:307|rel:51) dy(abs:0|rel:12)
; node # 2 D(44,21)->(66,22)
       fcb 2 ; drawmode 
       fcb -9,-9 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:281|rel:-26) dy(abs:-12|rel:-12)
; node # 3 D(3,20)->(27,20)
       fcb 2 ; drawmode 
       fcb 1,-41 ; starx/y relative to previous node
       fdb 12,26 ; dx/dy. dx(abs:307|rel:26) dy(abs:0|rel:12)
; node # 4 D(0,11)->(26,11)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:0|rel:0)
; node # 5 D(4,3)->(27,3)
       fcb 2 ; drawmode 
       fcb 8,4 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:294|rel:-38) dy(abs:0|rel:0)
; node # 6 D(-16,-18)->(-10,-18)
       fcb 2 ; drawmode 
       fcb 21,-20 ; starx/y relative to previous node
       fdb 0,-218 ; dx/dy. dx(abs:76|rel:-218) dy(abs:0|rel:0)
; node # 7 D(21,-19)->(20,-20)
       fcb 2 ; drawmode 
       fcb 1,37 ; starx/y relative to previous node
       fdb 12,-88 ; dx/dy. dx(abs:-12|rel:-88) dy(abs:12|rel:12)
; node # 8 D(39,3)->(59,4)
       fcb 2 ; drawmode 
       fcb -22,18 ; starx/y relative to previous node
       fdb -24,268 ; dx/dy. dx(abs:256|rel:268) dy(abs:-12|rel:-24)
; node # 9 D(4,3)->(27,3)
       fcb 2 ; drawmode 
       fcb 0,-35 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:294|rel:38) dy(abs:0|rel:12)
; node # 10 D(-22,4)->(-19,4)
       fcb 2 ; drawmode 
       fcb -1,-26 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:38|rel:-256) dy(abs:0|rel:0)
; node # 11 D(20,4)->(15,5)
       fcb 2 ; drawmode 
       fcb 0,42 ; starx/y relative to previous node
       fdb -12,-102 ; dx/dy. dx(abs:-64|rel:-102) dy(abs:-12|rel:-12)
; node # 12 D(21,-19)->(20,-20)
       fcb 2 ; drawmode 
       fcb 23,1 ; starx/y relative to previous node
       fdb 24,52 ; dx/dy. dx(abs:-12|rel:52) dy(abs:12|rel:24)
; node # 13 M(10,-9)->(11,-9)
       fcb 0 ; drawmode 
       fcb -10,-11 ; starx/y relative to previous node
       fdb -12,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:0|rel:-12)
; node # 14 D(10,-30)->(11,-31)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:12|rel:12)
; node # 15 M(-16,-18)->(-10,-18)
       fcb 0 ; drawmode 
       fcb -12,-26 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:76|rel:64) dy(abs:0|rel:-12)
; node # 16 D(-22,4)->(-19,4)
       fcb 2 ; drawmode 
       fcb -22,-6 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:38|rel:-38) dy(abs:0|rel:0)
; node # 17 D(-43,15)->(-41,14)
       fcb 2 ; drawmode 
       fcb -11,-21 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:25|rel:-13) dy(abs:12|rel:12)
; node # 18 D(0,11)->(26,11)
       fcb 2 ; drawmode 
       fcb 4,43 ; starx/y relative to previous node
       fdb -12,307 ; dx/dy. dx(abs:332|rel:307) dy(abs:0|rel:-12)
; node # 19 D(53,12)->(77,12)
       fcb 2 ; drawmode 
       fcb -1,53 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:307|rel:-25) dy(abs:0|rel:0)
; node # 20 D(29,17)->(15,17)
       fcb 2 ; drawmode 
       fcb -5,-24 ; starx/y relative to previous node
       fdb 0,-486 ; dx/dy. dx(abs:-179|rel:-486) dy(abs:0|rel:0)
; node # 21 D(-43,15)->(-41,14)
       fcb 2 ; drawmode 
       fcb 2,-72 ; starx/y relative to previous node
       fdb 12,204 ; dx/dy. dx(abs:25|rel:204) dy(abs:12|rel:12)
; node # 22 D(-30,27)->(-28,27)
       fcb 2 ; drawmode 
       fcb -12,13 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:25|rel:0) dy(abs:0|rel:-12)
; node # 23 D(22,29)->(12,29)
       fcb 2 ; drawmode 
       fcb -2,52 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-128|rel:-153) dy(abs:0|rel:0)
; node # 24 D(29,17)->(15,17)
       fcb 2 ; drawmode 
       fcb 12,7 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-179|rel:-51) dy(abs:0|rel:0)
; node # 25 D(20,4)->(15,5)
       fcb 2 ; drawmode 
       fcb 13,-9 ; starx/y relative to previous node
       fdb -12,115 ; dx/dy. dx(abs:-64|rel:115) dy(abs:-12|rel:-12)
; node # 26 D(39,3)->(59,4)
       fcb 2 ; drawmode 
       fcb 1,19 ; starx/y relative to previous node
       fdb 0,320 ; dx/dy. dx(abs:256|rel:320) dy(abs:-12|rel:0)
; node # 27 M(44,21)->(66,22)
       fcb 0 ; drawmode 
       fcb -18,5 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:281|rel:25) dy(abs:-12|rel:0)
; node # 28 D(22,29)->(12,29)
       fcb 2 ; drawmode 
       fcb -8,-22 ; starx/y relative to previous node
       fdb 12,-409 ; dx/dy. dx(abs:-128|rel:-409) dy(abs:0|rel:12)
; node # 29 M(-30,27)->(-28,27)
       fcb 0 ; drawmode 
       fcb 2,-52 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:25|rel:153) dy(abs:0|rel:0)
; node # 30 D(3,20)->(27,20)
       fcb 2 ; drawmode 
       fcb 7,33 ; starx/y relative to previous node
       fdb 0,282 ; dx/dy. dx(abs:307|rel:282) dy(abs:0|rel:0)
; node # 31 M(23,-6)->(47,-6)
       fcb 0 ; drawmode 
       fcb 26,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:307|rel:0) dy(abs:0|rel:0)
; node # 32 D(27,-6)->(52,-7)
       fcb 2 ; drawmode 
       fcb 0,4 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:320|rel:13) dy(abs:12|rel:12)
; node # 33 D(27,-10)->(52,-11)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:320|rel:0) dy(abs:12|rel:0)
; node # 34 D(23,-10)->(47,-11)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:307|rel:-13) dy(abs:12|rel:0)
; node # 35 D(5,-12)->(13,-13)
       fcb 2 ; drawmode 
       fcb 2,-18 ; starx/y relative to previous node
       fdb 0,-205 ; dx/dy. dx(abs:102|rel:-205) dy(abs:12|rel:0)
; node # 36 D(11,-13)->(18,-13)
       fcb 2 ; drawmode 
       fcb 1,6 ; starx/y relative to previous node
       fdb -12,-13 ; dx/dy. dx(abs:89|rel:-13) dy(abs:0|rel:-12)
; node # 37 D(15,-7)->(27,-7)
       fcb 2 ; drawmode 
       fcb -6,4 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:153|rel:64) dy(abs:0|rel:0)
; node # 38 D(10,-7)->(23,-7)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:166|rel:13) dy(abs:0|rel:0)
; node # 39 D(23,-6)->(47,-6)
       fcb 2 ; drawmode 
       fcb -1,13 ; starx/y relative to previous node
       fdb 0,141 ; dx/dy. dx(abs:307|rel:141) dy(abs:0|rel:0)
; node # 40 D(23,-10)->(47,-11)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:307|rel:0) dy(abs:12|rel:12)
; node # 41 M(27,-6)->(52,-7)
       fcb 0 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:320|rel:13) dy(abs:12|rel:0)
; node # 42 D(15,-7)->(27,-7)
       fcb 2 ; drawmode 
       fcb 1,-12 ; starx/y relative to previous node
       fdb -12,-167 ; dx/dy. dx(abs:153|rel:-167) dy(abs:0|rel:-12)
; node # 43 M(5,-12)->(13,-13)
       fcb 0 ; drawmode 
       fcb 5,-10 ; starx/y relative to previous node
       fdb 12,-51 ; dx/dy. dx(abs:102|rel:-51) dy(abs:12|rel:12)
; node # 44 D(10,-7)->(23,-7)
       fcb 2 ; drawmode 
       fcb -5,5 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:166|rel:64) dy(abs:0|rel:-12)
; node # 45 M(11,-13)->(18,-13)
       fcb 0 ; drawmode 
       fcb 6,1 ; starx/y relative to previous node
       fdb 0,-77 ; dx/dy. dx(abs:89|rel:-77) dy(abs:0|rel:0)
; node # 46 D(27,-10)->(52,-11)
       fcb 2 ; drawmode 
       fcb -3,16 ; starx/y relative to previous node
       fdb 12,231 ; dx/dy. dx(abs:320|rel:231) dy(abs:12|rel:12)
       fcb  1  ; end of anim
; Animation 11
battleframe11:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(59,4)->(73,3)
       fcb 0 ; drawmode 
       fcb -4,59 ; starx/y relative to previous node
       fdb 12,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:12|rel:12)
; node # 1 D(77,12)->(97,14)
       fcb 2 ; drawmode 
       fcb -8,18 ; starx/y relative to previous node
       fdb -37,77 ; dx/dy. dx(abs:256|rel:77) dy(abs:-25|rel:-37)
; node # 2 D(66,22)->(83,25)
       fcb 2 ; drawmode 
       fcb -10,-11 ; starx/y relative to previous node
       fdb -13,-39 ; dx/dy. dx(abs:217|rel:-39) dy(abs:-38|rel:-13)
; node # 3 D(27,20)->(51,21)
       fcb 2 ; drawmode 
       fcb 2,-39 ; starx/y relative to previous node
       fdb 26,90 ; dx/dy. dx(abs:307|rel:90) dy(abs:-12|rel:26)
; node # 4 D(26,11)->(52,11)
       fcb 2 ; drawmode 
       fcb 9,-1 ; starx/y relative to previous node
       fdb 12,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:0|rel:12)
; node # 5 D(27,3)->(47,4)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb -12,-76 ; dx/dy. dx(abs:256|rel:-76) dy(abs:-12|rel:-12)
; node # 6 D(-10,-18)->(-3,-18)
       fcb 2 ; drawmode 
       fcb 21,-37 ; starx/y relative to previous node
       fdb 12,-167 ; dx/dy. dx(abs:89|rel:-167) dy(abs:0|rel:12)
; node # 7 D(20,-20)->(17,-20)
       fcb 2 ; drawmode 
       fcb 2,30 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-38|rel:-127) dy(abs:0|rel:0)
; node # 8 D(59,4)->(73,3)
       fcb 2 ; drawmode 
       fcb -24,39 ; starx/y relative to previous node
       fdb 12,217 ; dx/dy. dx(abs:179|rel:217) dy(abs:12|rel:12)
; node # 9 D(27,3)->(47,4)
       fcb 2 ; drawmode 
       fcb 1,-32 ; starx/y relative to previous node
       fdb -24,77 ; dx/dy. dx(abs:256|rel:77) dy(abs:-12|rel:-24)
; node # 10 D(-19,4)->(-13,4)
       fcb 2 ; drawmode 
       fcb -1,-46 ; starx/y relative to previous node
       fdb 12,-180 ; dx/dy. dx(abs:76|rel:-180) dy(abs:0|rel:12)
; node # 11 D(15,5)->(8,5)
       fcb 2 ; drawmode 
       fcb -1,34 ; starx/y relative to previous node
       fdb 0,-165 ; dx/dy. dx(abs:-89|rel:-165) dy(abs:0|rel:0)
; node # 12 D(20,-20)->(17,-20)
       fcb 2 ; drawmode 
       fcb 25,5 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-38|rel:51) dy(abs:0|rel:0)
; node # 13 M(11,-9)->(10,-9)
       fcb 0 ; drawmode 
       fcb -11,-9 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:0|rel:0)
; node # 14 D(11,-31)->(10,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:0|rel:0)
; node # 15 M(-10,-18)->(-3,-18)
       fcb 0 ; drawmode 
       fcb -13,-21 ; starx/y relative to previous node
       fdb 0,101 ; dx/dy. dx(abs:89|rel:101) dy(abs:0|rel:0)
; node # 16 D(-19,4)->(-13,4)
       fcb 2 ; drawmode 
       fcb -22,-9 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:76|rel:-13) dy(abs:0|rel:0)
; node # 17 D(-41,14)->(-35,14)
       fcb 2 ; drawmode 
       fcb -10,-22 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:76|rel:0) dy(abs:0|rel:0)
; node # 18 D(26,11)->(52,11)
       fcb 2 ; drawmode 
       fcb 3,67 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:332|rel:256) dy(abs:0|rel:0)
; node # 19 D(77,12)->(97,14)
       fcb 2 ; drawmode 
       fcb -1,51 ; starx/y relative to previous node
       fdb -25,-76 ; dx/dy. dx(abs:256|rel:-76) dy(abs:-25|rel:-25)
; node # 20 D(15,17)->(-1,17)
       fcb 2 ; drawmode 
       fcb -5,-62 ; starx/y relative to previous node
       fdb 25,-460 ; dx/dy. dx(abs:-204|rel:-460) dy(abs:0|rel:25)
; node # 21 D(-41,14)->(-35,14)
       fcb 2 ; drawmode 
       fcb 3,-56 ; starx/y relative to previous node
       fdb 0,280 ; dx/dy. dx(abs:76|rel:280) dy(abs:0|rel:0)
; node # 22 D(-28,27)->(-23,26)
       fcb 2 ; drawmode 
       fcb -13,13 ; starx/y relative to previous node
       fdb 12,-12 ; dx/dy. dx(abs:64|rel:-12) dy(abs:12|rel:12)
; node # 23 D(12,29)->(2,30)
       fcb 2 ; drawmode 
       fcb -2,40 ; starx/y relative to previous node
       fdb -24,-192 ; dx/dy. dx(abs:-128|rel:-192) dy(abs:-12|rel:-24)
; node # 24 D(15,17)->(-1,17)
       fcb 2 ; drawmode 
       fcb 12,3 ; starx/y relative to previous node
       fdb 12,-76 ; dx/dy. dx(abs:-204|rel:-76) dy(abs:0|rel:12)
; node # 25 D(15,5)->(8,5)
       fcb 2 ; drawmode 
       fcb 12,0 ; starx/y relative to previous node
       fdb 0,115 ; dx/dy. dx(abs:-89|rel:115) dy(abs:0|rel:0)
; node # 26 D(59,4)->(73,3)
       fcb 2 ; drawmode 
       fcb 1,44 ; starx/y relative to previous node
       fdb 12,268 ; dx/dy. dx(abs:179|rel:268) dy(abs:12|rel:12)
; node # 27 M(66,22)->(83,25)
       fcb 0 ; drawmode 
       fcb -18,7 ; starx/y relative to previous node
       fdb -50,38 ; dx/dy. dx(abs:217|rel:38) dy(abs:-38|rel:-50)
; node # 28 D(12,29)->(2,30)
       fcb 2 ; drawmode 
       fcb -7,-54 ; starx/y relative to previous node
       fdb 26,-345 ; dx/dy. dx(abs:-128|rel:-345) dy(abs:-12|rel:26)
; node # 29 M(-28,27)->(-23,26)
       fcb 0 ; drawmode 
       fcb 2,-40 ; starx/y relative to previous node
       fdb 24,192 ; dx/dy. dx(abs:64|rel:192) dy(abs:12|rel:24)
; node # 30 D(27,20)->(51,21)
       fcb 2 ; drawmode 
       fcb 7,55 ; starx/y relative to previous node
       fdb -24,243 ; dx/dy. dx(abs:307|rel:243) dy(abs:-12|rel:-24)
; node # 31 M(47,-6)->(71,-6)
       fcb 0 ; drawmode 
       fcb 26,20 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:307|rel:0) dy(abs:0|rel:12)
; node # 32 D(52,-7)->(74,-7)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:281|rel:-26) dy(abs:0|rel:0)
; node # 33 D(52,-11)->(74,-11)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:281|rel:0) dy(abs:0|rel:0)
; node # 34 D(47,-11)->(71,-12)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 12,26 ; dx/dy. dx(abs:307|rel:26) dy(abs:12|rel:12)
; node # 35 D(13,-13)->(19,-13)
       fcb 2 ; drawmode 
       fcb 2,-34 ; starx/y relative to previous node
       fdb -12,-231 ; dx/dy. dx(abs:76|rel:-231) dy(abs:0|rel:-12)
; node # 36 D(18,-13)->(25,-13)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:89|rel:13) dy(abs:0|rel:0)
; node # 37 D(27,-7)->(36,-7)
       fcb 2 ; drawmode 
       fcb -6,9 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:115|rel:26) dy(abs:0|rel:0)
; node # 38 D(23,-7)->(32,-7)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:115|rel:0) dy(abs:0|rel:0)
; node # 39 D(47,-6)->(71,-6)
       fcb 2 ; drawmode 
       fcb -1,24 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:307|rel:192) dy(abs:0|rel:0)
; node # 40 D(47,-11)->(71,-12)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:307|rel:0) dy(abs:12|rel:12)
; node # 41 M(52,-7)->(74,-7)
       fcb 0 ; drawmode 
       fcb -4,5 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:281|rel:-26) dy(abs:0|rel:-12)
; node # 42 D(27,-7)->(36,-7)
       fcb 2 ; drawmode 
       fcb 0,-25 ; starx/y relative to previous node
       fdb 0,-166 ; dx/dy. dx(abs:115|rel:-166) dy(abs:0|rel:0)
; node # 43 M(13,-13)->(19,-13)
       fcb 0 ; drawmode 
       fcb 6,-14 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:76|rel:-39) dy(abs:0|rel:0)
; node # 44 D(23,-7)->(32,-7)
       fcb 2 ; drawmode 
       fcb -6,10 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:115|rel:39) dy(abs:0|rel:0)
; node # 45 M(18,-13)->(25,-13)
       fcb 0 ; drawmode 
       fcb 6,-5 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:89|rel:-26) dy(abs:0|rel:0)
; node # 46 D(52,-11)->(74,-11)
       fcb 2 ; drawmode 
       fcb -2,34 ; starx/y relative to previous node
       fdb 0,192 ; dx/dy. dx(abs:281|rel:192) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 12
battleframe12:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(73,3)->(83,4)
       fcb 0 ; drawmode 
       fcb -3,73 ; starx/y relative to previous node
       fdb -12,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:-12|rel:-12)
; node # 1 D(97,14)->(109,15)
       fcb 2 ; drawmode 
       fcb -11,24 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:153|rel:25) dy(abs:-12|rel:0)
; node # 2 D(83,25)->(95,28)
       fcb 2 ; drawmode 
       fcb -11,-14 ; starx/y relative to previous node
       fdb -26,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-38|rel:-26)
; node # 3 D(51,21)->(72,23)
       fcb 2 ; drawmode 
       fcb 4,-32 ; starx/y relative to previous node
       fdb 13,115 ; dx/dy. dx(abs:268|rel:115) dy(abs:-25|rel:13)
; node # 4 D(52,11)->(76,12)
       fcb 2 ; drawmode 
       fcb 10,1 ; starx/y relative to previous node
       fdb 13,39 ; dx/dy. dx(abs:307|rel:39) dy(abs:-12|rel:13)
; node # 5 D(47,4)->(65,3)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 24,-77 ; dx/dy. dx(abs:230|rel:-77) dy(abs:12|rel:24)
; node # 6 D(-3,-18)->(3,-18)
       fcb 2 ; drawmode 
       fcb 22,-50 ; starx/y relative to previous node
       fdb -12,-154 ; dx/dy. dx(abs:76|rel:-154) dy(abs:0|rel:-12)
; node # 7 D(17,-20)->(11,-20)
       fcb 2 ; drawmode 
       fcb 2,20 ; starx/y relative to previous node
       fdb 0,-152 ; dx/dy. dx(abs:-76|rel:-152) dy(abs:0|rel:0)
; node # 8 D(73,3)->(83,4)
       fcb 2 ; drawmode 
       fcb -23,56 ; starx/y relative to previous node
       fdb -12,204 ; dx/dy. dx(abs:128|rel:204) dy(abs:-12|rel:-12)
; node # 9 D(47,4)->(65,3)
       fcb 2 ; drawmode 
       fcb -1,-26 ; starx/y relative to previous node
       fdb 24,102 ; dx/dy. dx(abs:230|rel:102) dy(abs:12|rel:24)
; node # 10 D(-13,4)->(-7,3)
       fcb 2 ; drawmode 
       fcb 0,-60 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:76|rel:-154) dy(abs:12|rel:0)
; node # 11 D(8,5)->(0,5)
       fcb 2 ; drawmode 
       fcb -1,21 ; starx/y relative to previous node
       fdb -12,-178 ; dx/dy. dx(abs:-102|rel:-178) dy(abs:0|rel:-12)
; node # 12 D(17,-20)->(11,-20)
       fcb 2 ; drawmode 
       fcb 25,9 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-76|rel:26) dy(abs:0|rel:0)
; node # 13 M(10,-9)->(7,-9)
       fcb 0 ; drawmode 
       fcb -11,-7 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:-38|rel:38) dy(abs:0|rel:0)
; node # 14 D(10,-31)->(7,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:0|rel:0)
; node # 15 M(-3,-18)->(3,-18)
       fcb 0 ; drawmode 
       fcb -13,-13 ; starx/y relative to previous node
       fdb 0,114 ; dx/dy. dx(abs:76|rel:114) dy(abs:0|rel:0)
; node # 16 D(-13,4)->(-7,3)
       fcb 2 ; drawmode 
       fcb -22,-10 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:76|rel:0) dy(abs:12|rel:12)
; node # 17 D(-35,14)->(-26,13)
       fcb 2 ; drawmode 
       fcb -10,-22 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:115|rel:39) dy(abs:12|rel:0)
; node # 18 D(52,11)->(76,12)
       fcb 2 ; drawmode 
       fcb 3,87 ; starx/y relative to previous node
       fdb -24,192 ; dx/dy. dx(abs:307|rel:192) dy(abs:-12|rel:-24)
; node # 19 D(97,14)->(109,15)
       fcb 2 ; drawmode 
       fcb -3,45 ; starx/y relative to previous node
       fdb 0,-154 ; dx/dy. dx(abs:153|rel:-154) dy(abs:-12|rel:0)
; node # 20 D(-1,17)->(-17,17)
       fcb 2 ; drawmode 
       fcb -3,-98 ; starx/y relative to previous node
       fdb 12,-357 ; dx/dy. dx(abs:-204|rel:-357) dy(abs:0|rel:12)
; node # 21 D(-35,14)->(-26,13)
       fcb 2 ; drawmode 
       fcb 3,-34 ; starx/y relative to previous node
       fdb 12,319 ; dx/dy. dx(abs:115|rel:319) dy(abs:12|rel:12)
; node # 22 D(-23,26)->(-17,25)
       fcb 2 ; drawmode 
       fcb -12,12 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:76|rel:-39) dy(abs:12|rel:0)
; node # 23 D(2,30)->(-9,30)
       fcb 2 ; drawmode 
       fcb -4,25 ; starx/y relative to previous node
       fdb -12,-216 ; dx/dy. dx(abs:-140|rel:-216) dy(abs:0|rel:-12)
; node # 24 D(-1,17)->(-17,17)
       fcb 2 ; drawmode 
       fcb 13,-3 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-204|rel:-64) dy(abs:0|rel:0)
; node # 25 D(8,5)->(0,5)
       fcb 2 ; drawmode 
       fcb 12,9 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:-102|rel:102) dy(abs:0|rel:0)
; node # 26 D(73,3)->(83,4)
       fcb 2 ; drawmode 
       fcb 2,65 ; starx/y relative to previous node
       fdb -12,230 ; dx/dy. dx(abs:128|rel:230) dy(abs:-12|rel:-12)
; node # 27 M(83,25)->(95,28)
       fcb 0 ; drawmode 
       fcb -22,10 ; starx/y relative to previous node
       fdb -26,25 ; dx/dy. dx(abs:153|rel:25) dy(abs:-38|rel:-26)
; node # 28 D(2,30)->(-9,30)
       fcb 2 ; drawmode 
       fcb -5,-81 ; starx/y relative to previous node
       fdb 38,-293 ; dx/dy. dx(abs:-140|rel:-293) dy(abs:0|rel:38)
; node # 29 M(-23,26)->(-17,25)
       fcb 0 ; drawmode 
       fcb 4,-25 ; starx/y relative to previous node
       fdb 12,216 ; dx/dy. dx(abs:76|rel:216) dy(abs:12|rel:12)
; node # 30 D(51,21)->(72,23)
       fcb 2 ; drawmode 
       fcb 5,74 ; starx/y relative to previous node
       fdb -37,192 ; dx/dy. dx(abs:268|rel:192) dy(abs:-25|rel:-37)
; node # 31 M(71,-6)->(89,-7)
       fcb 0 ; drawmode 
       fcb 27,20 ; starx/y relative to previous node
       fdb 37,-38 ; dx/dy. dx(abs:230|rel:-38) dy(abs:12|rel:37)
; node # 32 D(74,-7)->(92,-7)
       fcb 2 ; drawmode 
       fcb 1,3 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:0|rel:-12)
; node # 33 D(74,-11)->(92,-13)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 25,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:25|rel:25)
; node # 34 D(71,-12)->(89,-13)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:12|rel:-13)
; node # 35 D(19,-13)->(24,-14)
       fcb 2 ; drawmode 
       fcb 1,-52 ; starx/y relative to previous node
       fdb 0,-166 ; dx/dy. dx(abs:64|rel:-166) dy(abs:12|rel:0)
; node # 36 D(25,-13)->(25,-14)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:12|rel:0)
; node # 37 D(36,-7)->(41,-8)
       fcb 2 ; drawmode 
       fcb -6,11 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:12|rel:0)
; node # 38 D(32,-7)->(40,-8)
       fcb 2 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:102|rel:38) dy(abs:12|rel:0)
; node # 39 D(71,-6)->(89,-7)
       fcb 2 ; drawmode 
       fcb -1,39 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:230|rel:128) dy(abs:12|rel:0)
; node # 40 D(71,-12)->(89,-13)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:12|rel:0)
; node # 41 M(74,-7)->(92,-7)
       fcb 0 ; drawmode 
       fcb -5,3 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:230|rel:0) dy(abs:0|rel:-12)
; node # 42 D(36,-7)->(41,-8)
       fcb 2 ; drawmode 
       fcb 0,-38 ; starx/y relative to previous node
       fdb 12,-166 ; dx/dy. dx(abs:64|rel:-166) dy(abs:12|rel:12)
; node # 43 M(19,-13)->(24,-14)
       fcb 0 ; drawmode 
       fcb 6,-17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:12|rel:0)
; node # 44 D(32,-7)->(40,-8)
       fcb 2 ; drawmode 
       fcb -6,13 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:102|rel:38) dy(abs:12|rel:0)
; node # 45 M(25,-13)->(25,-14)
       fcb 0 ; drawmode 
       fcb 6,-7 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:12|rel:0)
; node # 46 D(74,-11)->(92,-13)
       fcb 2 ; drawmode 
       fcb -2,49 ; starx/y relative to previous node
       fdb 13,230 ; dx/dy. dx(abs:230|rel:230) dy(abs:25|rel:13)
       fcb  1  ; end of anim
; Animation 13
battleframe13:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(83,4)->(83,4)
       fcb 0 ; drawmode 
       fcb -4,83 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(109,15)->(108,18)
       fcb 2 ; drawmode 
       fcb -11,26 ; starx/y relative to previous node
       fdb -38,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-38|rel:-38)
; node # 2 D(95,28)->(96,31)
       fcb 2 ; drawmode 
       fcb -13,-14 ; starx/y relative to previous node
       fdb 0,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-38|rel:0)
; node # 3 D(72,23)->(88,25)
       fcb 2 ; drawmode 
       fcb 5,-23 ; starx/y relative to previous node
       fdb 13,192 ; dx/dy. dx(abs:204|rel:192) dy(abs:-25|rel:13)
; node # 4 D(76,12)->(96,13)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb 13,52 ; dx/dy. dx(abs:256|rel:52) dy(abs:-12|rel:13)
; node # 5 D(65,3)->(78,4)
       fcb 2 ; drawmode 
       fcb 9,-11 ; starx/y relative to previous node
       fdb 0,-90 ; dx/dy. dx(abs:166|rel:-90) dy(abs:-12|rel:0)
; node # 6 D(3,-18)->(10,-17)
       fcb 2 ; drawmode 
       fcb 21,-62 ; starx/y relative to previous node
       fdb 0,-77 ; dx/dy. dx(abs:89|rel:-77) dy(abs:-12|rel:0)
; node # 7 D(11,-20)->(4,-20)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb 12,-178 ; dx/dy. dx(abs:-89|rel:-178) dy(abs:0|rel:12)
; node # 8 D(83,4)->(83,4)
       fcb 2 ; drawmode 
       fcb -24,72 ; starx/y relative to previous node
       fdb 0,89 ; dx/dy. dx(abs:0|rel:89) dy(abs:0|rel:0)
; node # 9 D(65,3)->(78,4)
       fcb 2 ; drawmode 
       fcb 1,-18 ; starx/y relative to previous node
       fdb -12,166 ; dx/dy. dx(abs:166|rel:166) dy(abs:-12|rel:-12)
; node # 10 D(-7,3)->(0,3)
       fcb 2 ; drawmode 
       fcb 0,-72 ; starx/y relative to previous node
       fdb 12,-77 ; dx/dy. dx(abs:89|rel:-77) dy(abs:0|rel:12)
; node # 11 D(0,5)->(-8,4)
       fcb 2 ; drawmode 
       fcb -2,7 ; starx/y relative to previous node
       fdb 12,-191 ; dx/dy. dx(abs:-102|rel:-191) dy(abs:12|rel:12)
; node # 12 D(11,-20)->(4,-20)
       fcb 2 ; drawmode 
       fcb 25,11 ; starx/y relative to previous node
       fdb -12,13 ; dx/dy. dx(abs:-89|rel:13) dy(abs:0|rel:-12)
; node # 13 M(7,-9)->(4,-9)
       fcb 0 ; drawmode 
       fcb -11,-4 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-38|rel:51) dy(abs:0|rel:0)
; node # 14 D(7,-31)->(4,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:0|rel:0)
; node # 15 M(3,-18)->(10,-17)
       fcb 0 ; drawmode 
       fcb -13,-4 ; starx/y relative to previous node
       fdb -12,127 ; dx/dy. dx(abs:89|rel:127) dy(abs:-12|rel:-12)
; node # 16 D(-7,3)->(0,3)
       fcb 2 ; drawmode 
       fcb -21,-10 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:89|rel:0) dy(abs:0|rel:12)
; node # 17 D(-26,13)->(-14,13)
       fcb 2 ; drawmode 
       fcb -10,-19 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:153|rel:64) dy(abs:0|rel:0)
; node # 18 D(76,12)->(96,13)
       fcb 2 ; drawmode 
       fcb 1,102 ; starx/y relative to previous node
       fdb -12,103 ; dx/dy. dx(abs:256|rel:103) dy(abs:-12|rel:-12)
; node # 19 D(109,15)->(108,18)
       fcb 2 ; drawmode 
       fcb -3,33 ; starx/y relative to previous node
       fdb -26,-268 ; dx/dy. dx(abs:-12|rel:-268) dy(abs:-38|rel:-26)
; node # 20 D(45,16)->(37,17)
       fcb 2 ; drawmode 
       fcb -1,-64 ; starx/y relative to previous node
       fdb 26,-90 ; dx/dy. dx(abs:-102|rel:-90) dy(abs:-12|rel:26)
; node # 21 D(-17,17)->(-31,16)
       fcb 2 ; drawmode 
       fcb -1,-62 ; starx/y relative to previous node
       fdb 24,-77 ; dx/dy. dx(abs:-179|rel:-77) dy(abs:12|rel:24)
; node # 22 D(-26,13)->(-14,13)
       fcb 2 ; drawmode 
       fcb 4,-9 ; starx/y relative to previous node
       fdb -12,332 ; dx/dy. dx(abs:153|rel:332) dy(abs:0|rel:-12)
; node # 23 D(-17,25)->(-8,24)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb 12,-38 ; dx/dy. dx(abs:115|rel:-38) dy(abs:12|rel:12)
; node # 24 D(-9,30)->(-19,29)
       fcb 2 ; drawmode 
       fcb -5,8 ; starx/y relative to previous node
       fdb 0,-243 ; dx/dy. dx(abs:-128|rel:-243) dy(abs:12|rel:0)
; node # 25 D(-17,17)->(-31,16)
       fcb 2 ; drawmode 
       fcb 13,-8 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-179|rel:-51) dy(abs:12|rel:0)
; node # 26 D(0,5)->(-8,4)
       fcb 2 ; drawmode 
       fcb 12,17 ; starx/y relative to previous node
       fdb 0,77 ; dx/dy. dx(abs:-102|rel:77) dy(abs:12|rel:0)
; node # 27 D(83,4)->(83,4)
       fcb 2 ; drawmode 
       fcb 1,83 ; starx/y relative to previous node
       fdb -12,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:0|rel:-12)
; node # 28 M(95,28)->(96,31)
       fcb 0 ; drawmode 
       fcb -24,12 ; starx/y relative to previous node
       fdb -38,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:-38|rel:-38)
; node # 29 D(-9,30)->(-19,29)
       fcb 2 ; drawmode 
       fcb -2,-104 ; starx/y relative to previous node
       fdb 50,-140 ; dx/dy. dx(abs:-128|rel:-140) dy(abs:12|rel:50)
; node # 30 M(-17,25)->(-8,24)
       fcb 0 ; drawmode 
       fcb 5,-8 ; starx/y relative to previous node
       fdb 0,243 ; dx/dy. dx(abs:115|rel:243) dy(abs:12|rel:0)
; node # 31 D(72,23)->(88,25)
       fcb 2 ; drawmode 
       fcb 2,89 ; starx/y relative to previous node
       fdb -37,89 ; dx/dy. dx(abs:204|rel:89) dy(abs:-25|rel:-37)
; node # 32 M(89,-7)->(101,-8)
       fcb 0 ; drawmode 
       fcb 30,17 ; starx/y relative to previous node
       fdb 37,-51 ; dx/dy. dx(abs:153|rel:-51) dy(abs:12|rel:37)
; node # 33 D(92,-7)->(102,-8)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:128|rel:-25) dy(abs:12|rel:0)
; node # 34 D(92,-13)->(102,-14)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:12|rel:0)
; node # 35 D(89,-13)->(101,-14)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:153|rel:25) dy(abs:12|rel:0)
; node # 36 D(24,-14)->(24,-14)
       fcb 2 ; drawmode 
       fcb 1,-65 ; starx/y relative to previous node
       fdb -12,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:-12)
; node # 37 D(25,-14)->(24,-14)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:0|rel:0)
; node # 38 D(41,-8)->(44,-7)
       fcb 2 ; drawmode 
       fcb -6,16 ; starx/y relative to previous node
       fdb -12,50 ; dx/dy. dx(abs:38|rel:50) dy(abs:-12|rel:-12)
; node # 39 D(40,-8)->(44,-7)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:51|rel:13) dy(abs:-12|rel:0)
; node # 40 D(89,-7)->(101,-8)
       fcb 2 ; drawmode 
       fcb -1,49 ; starx/y relative to previous node
       fdb 24,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:12|rel:24)
; node # 41 D(89,-13)->(101,-14)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:12|rel:0)
; node # 42 M(92,-7)->(102,-8)
       fcb 0 ; drawmode 
       fcb -6,3 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:128|rel:-25) dy(abs:12|rel:0)
; node # 43 D(41,-8)->(44,-7)
       fcb 2 ; drawmode 
       fcb 1,-51 ; starx/y relative to previous node
       fdb -24,-90 ; dx/dy. dx(abs:38|rel:-90) dy(abs:-12|rel:-24)
; node # 44 M(24,-14)->(24,-14)
       fcb 0 ; drawmode 
       fcb 6,-17 ; starx/y relative to previous node
       fdb 12,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:0|rel:12)
; node # 45 D(40,-8)->(44,-7)
       fcb 2 ; drawmode 
       fcb -6,16 ; starx/y relative to previous node
       fdb -12,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-12|rel:-12)
; node # 46 M(25,-14)->(24,-14)
       fcb 0 ; drawmode 
       fcb 6,-15 ; starx/y relative to previous node
       fdb 12,-63 ; dx/dy. dx(abs:-12|rel:-63) dy(abs:0|rel:12)
; node # 47 D(92,-13)->(102,-14)
       fcb 2 ; drawmode 
       fcb -1,67 ; starx/y relative to previous node
       fdb 12,140 ; dx/dy. dx(abs:128|rel:140) dy(abs:12|rel:12)
       fcb  1  ; end of anim
; Animation 14
battleframe14:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(83,4)->(71,5)
       fcb 0 ; drawmode 
       fcb -4,83 ; starx/y relative to previous node
       fdb -12,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:-12|rel:-12)
; node # 1 D(108,18)->(90,20)
       fcb 2 ; drawmode 
       fcb -14,25 ; starx/y relative to previous node
       fdb -13,-77 ; dx/dy. dx(abs:-230|rel:-77) dy(abs:-25|rel:-13)
; node # 2 D(96,31)->(81,35)
       fcb 2 ; drawmode 
       fcb -13,-12 ; starx/y relative to previous node
       fdb -26,38 ; dx/dy. dx(abs:-192|rel:38) dy(abs:-51|rel:-26)
; node # 3 D(88,25)->(96,29)
       fcb 2 ; drawmode 
       fcb 6,-8 ; starx/y relative to previous node
       fdb 0,294 ; dx/dy. dx(abs:102|rel:294) dy(abs:-51|rel:0)
; node # 4 D(96,13)->(108,16)
       fcb 2 ; drawmode 
       fcb 12,8 ; starx/y relative to previous node
       fdb 13,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-38|rel:13)
; node # 5 D(78,4)->(84,4)
       fcb 2 ; drawmode 
       fcb 9,-18 ; starx/y relative to previous node
       fdb 38,-77 ; dx/dy. dx(abs:76|rel:-77) dy(abs:0|rel:38)
; node # 6 D(10,-17)->(15,-18)
       fcb 2 ; drawmode 
       fcb 21,-68 ; starx/y relative to previous node
       fdb 12,-12 ; dx/dy. dx(abs:64|rel:-12) dy(abs:12|rel:12)
; node # 7 D(4,-20)->(-4,-20)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb -12,-166 ; dx/dy. dx(abs:-102|rel:-166) dy(abs:0|rel:-12)
; node # 8 D(83,4)->(71,5)
       fcb 2 ; drawmode 
       fcb -24,79 ; starx/y relative to previous node
       fdb -12,-51 ; dx/dy. dx(abs:-153|rel:-51) dy(abs:-12|rel:-12)
; node # 9 D(78,4)->(84,4)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 12,229 ; dx/dy. dx(abs:76|rel:229) dy(abs:0|rel:12)
; node # 10 D(0,3)->(7,3)
       fcb 2 ; drawmode 
       fcb 1,-78 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:89|rel:13) dy(abs:0|rel:0)
; node # 11 D(-8,4)->(-15,5)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -12,-178 ; dx/dy. dx(abs:-89|rel:-178) dy(abs:-12|rel:-12)
; node # 12 D(4,-20)->(-4,-20)
       fcb 2 ; drawmode 
       fcb 24,12 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:-102|rel:-13) dy(abs:0|rel:12)
; node # 13 M(4,-9)->(0,-9)
       fcb 0 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-51|rel:51) dy(abs:0|rel:0)
; node # 14 D(4,-31)->(0,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:0|rel:0)
; node # 15 M(10,-17)->(15,-18)
       fcb 0 ; drawmode 
       fcb -14,6 ; starx/y relative to previous node
       fdb 12,115 ; dx/dy. dx(abs:64|rel:115) dy(abs:12|rel:12)
; node # 16 D(0,3)->(7,3)
       fcb 2 ; drawmode 
       fcb -20,-10 ; starx/y relative to previous node
       fdb -12,25 ; dx/dy. dx(abs:89|rel:25) dy(abs:0|rel:-12)
; node # 17 D(-14,13)->(-2,13)
       fcb 2 ; drawmode 
       fcb -10,-14 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:153|rel:64) dy(abs:0|rel:0)
; node # 18 D(96,13)->(108,16)
       fcb 2 ; drawmode 
       fcb 0,110 ; starx/y relative to previous node
       fdb -38,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-38|rel:-38)
; node # 19 D(108,18)->(90,20)
       fcb 2 ; drawmode 
       fcb -5,12 ; starx/y relative to previous node
       fdb 13,-383 ; dx/dy. dx(abs:-230|rel:-383) dy(abs:-25|rel:13)
; node # 20 D(37,17)->(27,18)
       fcb 2 ; drawmode 
       fcb 1,-71 ; starx/y relative to previous node
       fdb 13,102 ; dx/dy. dx(abs:-128|rel:102) dy(abs:-12|rel:13)
; node # 21 D(-31,16)->(-40,16)
       fcb 2 ; drawmode 
       fcb 1,-68 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:-115|rel:13) dy(abs:0|rel:12)
; node # 22 D(-14,13)->(-2,13)
       fcb 2 ; drawmode 
       fcb 3,17 ; starx/y relative to previous node
       fdb 0,268 ; dx/dy. dx(abs:153|rel:268) dy(abs:0|rel:0)
; node # 23 D(-8,24)->(1,24)
       fcb 2 ; drawmode 
       fcb -11,6 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:115|rel:-38) dy(abs:0|rel:0)
; node # 24 D(-19,29)->(-26,28)
       fcb 2 ; drawmode 
       fcb -5,-11 ; starx/y relative to previous node
       fdb 12,-204 ; dx/dy. dx(abs:-89|rel:-204) dy(abs:12|rel:12)
; node # 25 D(-31,16)->(-40,16)
       fcb 2 ; drawmode 
       fcb 13,-12 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:-115|rel:-26) dy(abs:0|rel:-12)
; node # 26 D(-8,4)->(-15,5)
       fcb 2 ; drawmode 
       fcb 12,23 ; starx/y relative to previous node
       fdb -12,26 ; dx/dy. dx(abs:-89|rel:26) dy(abs:-12|rel:-12)
; node # 27 D(83,4)->(71,5)
       fcb 2 ; drawmode 
       fcb 0,91 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-153|rel:-64) dy(abs:-12|rel:0)
; node # 28 M(96,31)->(81,35)
       fcb 0 ; drawmode 
       fcb -27,13 ; starx/y relative to previous node
       fdb -39,-39 ; dx/dy. dx(abs:-192|rel:-39) dy(abs:-51|rel:-39)
; node # 29 D(-19,29)->(-26,28)
       fcb 2 ; drawmode 
       fcb 2,-115 ; starx/y relative to previous node
       fdb 63,103 ; dx/dy. dx(abs:-89|rel:103) dy(abs:12|rel:63)
; node # 30 M(-8,24)->(1,24)
       fcb 0 ; drawmode 
       fcb 5,11 ; starx/y relative to previous node
       fdb -12,204 ; dx/dy. dx(abs:115|rel:204) dy(abs:0|rel:-12)
; node # 31 D(88,25)->(96,29)
       fcb 2 ; drawmode 
       fcb -1,96 ; starx/y relative to previous node
       fdb -51,-13 ; dx/dy. dx(abs:102|rel:-13) dy(abs:-51|rel:-51)
; node # 32 M(101,-8)->(101,-9)
       fcb 0 ; drawmode 
       fcb 33,13 ; starx/y relative to previous node
       fdb 63,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:12|rel:63)
; node # 33 D(102,-8)->(100,-9)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:12|rel:0)
; node # 34 D(102,-14)->(100,-16)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:25|rel:13)
; node # 35 D(101,-14)->(101,-15)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb -13,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:12|rel:-13)
; node # 36 D(24,-14)->(23,-14)
       fcb 2 ; drawmode 
       fcb 0,-77 ; starx/y relative to previous node
       fdb -12,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:0|rel:-12)
; node # 37 D(24,-14)->(24,-14)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:0)
; node # 38 D(44,-7)->(40,-8)
       fcb 2 ; drawmode 
       fcb -7,20 ; starx/y relative to previous node
       fdb 12,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:12|rel:12)
; node # 39 D(44,-7)->(41,-8)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:-38|rel:13) dy(abs:12|rel:0)
; node # 40 D(101,-8)->(101,-9)
       fcb 2 ; drawmode 
       fcb 1,57 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:12|rel:0)
; node # 41 D(101,-14)->(101,-15)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:12|rel:0)
; node # 42 M(102,-8)->(100,-9)
       fcb 0 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:12|rel:0)
; node # 43 D(44,-7)->(40,-8)
       fcb 2 ; drawmode 
       fcb -1,-58 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:-51|rel:-26) dy(abs:12|rel:0)
; node # 44 M(24,-14)->(23,-14)
       fcb 0 ; drawmode 
       fcb 7,-20 ; starx/y relative to previous node
       fdb -12,39 ; dx/dy. dx(abs:-12|rel:39) dy(abs:0|rel:-12)
; node # 45 D(44,-7)->(41,-8)
       fcb 2 ; drawmode 
       fcb -7,20 ; starx/y relative to previous node
       fdb 12,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:12|rel:12)
; node # 46 M(24,-14)->(24,-14)
       fcb 0 ; drawmode 
       fcb 7,-20 ; starx/y relative to previous node
       fdb -12,38 ; dx/dy. dx(abs:0|rel:38) dy(abs:0|rel:-12)
; node # 47 D(102,-14)->(100,-16)
       fcb 2 ; drawmode 
       fcb 0,78 ; starx/y relative to previous node
       fdb 25,-25 ; dx/dy. dx(abs:-25|rel:-25) dy(abs:25|rel:25)
       fcb  1  ; end of anim
; Animation 15
battleframe15:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(71,5)->(45,6)
       fcb 0 ; drawmode 
       fcb -5,71 ; starx/y relative to previous node
       fdb -12,-332 ; dx/dy. dx(abs:-332|rel:-332) dy(abs:-12|rel:-12)
; node # 1 D(90,20)->(51,22)
       fcb 2 ; drawmode 
       fcb -15,19 ; starx/y relative to previous node
       fdb -13,-167 ; dx/dy. dx(abs:-499|rel:-167) dy(abs:-25|rel:-13)
; node # 2 D(81,35)->(50,37)
       fcb 2 ; drawmode 
       fcb -15,-9 ; starx/y relative to previous node
       fdb 0,103 ; dx/dy. dx(abs:-396|rel:103) dy(abs:-25|rel:0)
; node # 3 D(96,29)->(93,32)
       fcb 2 ; drawmode 
       fcb 6,15 ; starx/y relative to previous node
       fdb -13,358 ; dx/dy. dx(abs:-38|rel:358) dy(abs:-38|rel:-13)
; node # 4 D(108,16)->(109,17)
       fcb 2 ; drawmode 
       fcb 13,12 ; starx/y relative to previous node
       fdb 26,50 ; dx/dy. dx(abs:12|rel:50) dy(abs:-12|rel:26)
; node # 5 D(84,4)->(79,5)
       fcb 2 ; drawmode 
       fcb 12,-24 ; starx/y relative to previous node
       fdb 0,-76 ; dx/dy. dx(abs:-64|rel:-76) dy(abs:-12|rel:0)
; node # 6 D(15,-18)->(20,-18)
       fcb 2 ; drawmode 
       fcb 22,-69 ; starx/y relative to previous node
       fdb 12,128 ; dx/dy. dx(abs:64|rel:128) dy(abs:0|rel:12)
; node # 7 D(-4,-20)->(-11,-20)
       fcb 2 ; drawmode 
       fcb 2,-19 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-89|rel:-153) dy(abs:0|rel:0)
; node # 8 D(71,5)->(45,6)
       fcb 2 ; drawmode 
       fcb -25,75 ; starx/y relative to previous node
       fdb -12,-243 ; dx/dy. dx(abs:-332|rel:-243) dy(abs:-12|rel:-12)
; node # 9 D(84,4)->(79,5)
       fcb 2 ; drawmode 
       fcb 1,13 ; starx/y relative to previous node
       fdb 0,268 ; dx/dy. dx(abs:-64|rel:268) dy(abs:-12|rel:0)
; node # 10 D(7,3)->(14,4)
       fcb 2 ; drawmode 
       fcb 1,-77 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:89|rel:153) dy(abs:-12|rel:0)
; node # 11 D(-15,5)->(-20,4)
       fcb 2 ; drawmode 
       fcb -2,-22 ; starx/y relative to previous node
       fdb 24,-153 ; dx/dy. dx(abs:-64|rel:-153) dy(abs:12|rel:24)
; node # 12 D(-4,-20)->(-11,-20)
       fcb 2 ; drawmode 
       fcb 25,11 ; starx/y relative to previous node
       fdb -12,-25 ; dx/dy. dx(abs:-89|rel:-25) dy(abs:0|rel:-12)
; node # 13 M(0,-9)->(-3,-9)
       fcb 0 ; drawmode 
       fcb -11,4 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-38|rel:51) dy(abs:0|rel:0)
; node # 14 D(0,-31)->(-3,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:0|rel:0)
; node # 15 M(15,-18)->(20,-18)
       fcb 0 ; drawmode 
       fcb -13,15 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:64|rel:102) dy(abs:0|rel:0)
; node # 16 D(7,3)->(14,4)
       fcb 2 ; drawmode 
       fcb -21,-8 ; starx/y relative to previous node
       fdb -12,25 ; dx/dy. dx(abs:89|rel:25) dy(abs:-12|rel:-12)
; node # 17 D(-2,13)->(11,12)
       fcb 2 ; drawmode 
       fcb -10,-9 ; starx/y relative to previous node
       fdb 24,77 ; dx/dy. dx(abs:166|rel:77) dy(abs:12|rel:24)
; node # 18 D(108,16)->(109,17)
       fcb 2 ; drawmode 
       fcb -3,110 ; starx/y relative to previous node
       fdb -24,-154 ; dx/dy. dx(abs:12|rel:-154) dy(abs:-12|rel:-24)
; node # 19 D(90,20)->(51,22)
       fcb 2 ; drawmode 
       fcb -4,-18 ; starx/y relative to previous node
       fdb -13,-511 ; dx/dy. dx(abs:-499|rel:-511) dy(abs:-25|rel:-13)
; node # 20 D(27,18)->(-2,18)
       fcb 2 ; drawmode 
       fcb 2,-63 ; starx/y relative to previous node
       fdb 25,128 ; dx/dy. dx(abs:-371|rel:128) dy(abs:0|rel:25)
; node # 21 D(-40,16)->(-42,15)
       fcb 2 ; drawmode 
       fcb 2,-67 ; starx/y relative to previous node
       fdb 12,346 ; dx/dy. dx(abs:-25|rel:346) dy(abs:12|rel:12)
; node # 22 D(-2,13)->(11,12)
       fcb 2 ; drawmode 
       fcb 3,38 ; starx/y relative to previous node
       fdb 0,191 ; dx/dy. dx(abs:166|rel:191) dy(abs:12|rel:0)
; node # 23 D(1,24)->(10,24)
       fcb 2 ; drawmode 
       fcb -11,3 ; starx/y relative to previous node
       fdb -12,-51 ; dx/dy. dx(abs:115|rel:-51) dy(abs:0|rel:-12)
; node # 24 D(-26,28)->(-30,27)
       fcb 2 ; drawmode 
       fcb -4,-27 ; starx/y relative to previous node
       fdb 12,-166 ; dx/dy. dx(abs:-51|rel:-166) dy(abs:12|rel:12)
; node # 25 D(-40,16)->(-42,15)
       fcb 2 ; drawmode 
       fcb 12,-14 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-25|rel:26) dy(abs:12|rel:0)
; node # 26 D(-15,5)->(-20,4)
       fcb 2 ; drawmode 
       fcb 11,25 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:-64|rel:-39) dy(abs:12|rel:0)
; node # 27 D(71,5)->(45,6)
       fcb 2 ; drawmode 
       fcb 0,86 ; starx/y relative to previous node
       fdb -24,-268 ; dx/dy. dx(abs:-332|rel:-268) dy(abs:-12|rel:-24)
; node # 28 M(81,35)->(50,37)
       fcb 0 ; drawmode 
       fcb -30,10 ; starx/y relative to previous node
       fdb -13,-64 ; dx/dy. dx(abs:-396|rel:-64) dy(abs:-25|rel:-13)
; node # 29 D(-26,28)->(-30,27)
       fcb 2 ; drawmode 
       fcb 7,-107 ; starx/y relative to previous node
       fdb 37,345 ; dx/dy. dx(abs:-51|rel:345) dy(abs:12|rel:37)
; node # 30 M(1,24)->(10,24)
       fcb 0 ; drawmode 
       fcb 4,27 ; starx/y relative to previous node
       fdb -12,166 ; dx/dy. dx(abs:115|rel:166) dy(abs:0|rel:-12)
; node # 31 D(96,29)->(93,32)
       fcb 2 ; drawmode 
       fcb -5,95 ; starx/y relative to previous node
       fdb -38,-153 ; dx/dy. dx(abs:-38|rel:-153) dy(abs:-38|rel:-38)
; node # 32 M(101,-9)->(86,-10)
       fcb 0 ; drawmode 
       fcb 38,5 ; starx/y relative to previous node
       fdb 50,-154 ; dx/dy. dx(abs:-192|rel:-154) dy(abs:12|rel:50)
; node # 33 D(100,-9)->(81,-10)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-243|rel:-51) dy(abs:12|rel:0)
; node # 34 D(100,-16)->(81,-18)
       fcb 2 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:-243|rel:0) dy(abs:25|rel:13)
; node # 35 D(101,-15)->(86,-18)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb 13,51 ; dx/dy. dx(abs:-192|rel:51) dy(abs:38|rel:13)
; node # 36 D(23,-14)->(21,-15)
       fcb 2 ; drawmode 
       fcb -1,-78 ; starx/y relative to previous node
       fdb -26,167 ; dx/dy. dx(abs:-25|rel:167) dy(abs:12|rel:-26)
; node # 37 D(24,-14)->(15,-15)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 0,-90 ; dx/dy. dx(abs:-115|rel:-90) dy(abs:12|rel:0)
; node # 38 D(40,-8)->(29,-8)
       fcb 2 ; drawmode 
       fcb -6,16 ; starx/y relative to previous node
       fdb -12,-25 ; dx/dy. dx(abs:-140|rel:-25) dy(abs:0|rel:-12)
; node # 39 D(41,-8)->(33,-8)
       fcb 2 ; drawmode 
       fcb 0,1 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:-102|rel:38) dy(abs:0|rel:0)
; node # 40 D(101,-9)->(86,-10)
       fcb 2 ; drawmode 
       fcb 1,60 ; starx/y relative to previous node
       fdb 12,-90 ; dx/dy. dx(abs:-192|rel:-90) dy(abs:12|rel:12)
; node # 41 D(101,-15)->(86,-18)
       fcb 2 ; drawmode 
       fcb 6,0 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:38|rel:26)
; node # 42 M(100,-9)->(81,-10)
       fcb 0 ; drawmode 
       fcb -6,-1 ; starx/y relative to previous node
       fdb -26,-51 ; dx/dy. dx(abs:-243|rel:-51) dy(abs:12|rel:-26)
; node # 43 D(40,-8)->(29,-8)
       fcb 2 ; drawmode 
       fcb -1,-60 ; starx/y relative to previous node
       fdb -12,103 ; dx/dy. dx(abs:-140|rel:103) dy(abs:0|rel:-12)
; node # 44 M(23,-14)->(21,-15)
       fcb 0 ; drawmode 
       fcb 6,-17 ; starx/y relative to previous node
       fdb 12,115 ; dx/dy. dx(abs:-25|rel:115) dy(abs:12|rel:12)
; node # 45 D(41,-8)->(33,-8)
       fcb 2 ; drawmode 
       fcb -6,18 ; starx/y relative to previous node
       fdb -12,-77 ; dx/dy. dx(abs:-102|rel:-77) dy(abs:0|rel:-12)
; node # 46 M(24,-14)->(15,-15)
       fcb 0 ; drawmode 
       fcb 6,-17 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:-115|rel:-13) dy(abs:12|rel:12)
; node # 47 D(100,-16)->(81,-18)
       fcb 2 ; drawmode 
       fcb 2,76 ; starx/y relative to previous node
       fdb 13,-128 ; dx/dy. dx(abs:-243|rel:-128) dy(abs:25|rel:13)
       fcb  1  ; end of anim
; Animation 16
battleframe16:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(45,6)->(7,6)
       fcb 0 ; drawmode 
       fcb -6,45 ; starx/y relative to previous node
       fdb 0,-486 ; dx/dy. dx(abs:-486|rel:-486) dy(abs:0|rel:0)
; node # 1 D(51,22)->(-1,22)
       fcb 2 ; drawmode 
       fcb -16,6 ; starx/y relative to previous node
       fdb 0,-179 ; dx/dy. dx(abs:-665|rel:-179) dy(abs:0|rel:0)
; node # 2 D(50,37)->(7,39)
       fcb 2 ; drawmode 
       fcb -15,-1 ; starx/y relative to previous node
       fdb -25,115 ; dx/dy. dx(abs:-550|rel:115) dy(abs:-25|rel:-25)
; node # 3 D(93,32)->(74,36)
       fcb 2 ; drawmode 
       fcb 5,43 ; starx/y relative to previous node
       fdb -26,307 ; dx/dy. dx(abs:-243|rel:307) dy(abs:-51|rel:-26)
; node # 4 D(109,17)->(91,20)
       fcb 2 ; drawmode 
       fcb 15,16 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:-230|rel:13) dy(abs:-38|rel:13)
; node # 5 D(79,5)->(60,5)
       fcb 2 ; drawmode 
       fcb 12,-30 ; starx/y relative to previous node
       fdb 38,-13 ; dx/dy. dx(abs:-243|rel:-13) dy(abs:0|rel:38)
; node # 6 D(20,-18)->(21,-19)
       fcb 2 ; drawmode 
       fcb 23,-59 ; starx/y relative to previous node
       fdb 12,255 ; dx/dy. dx(abs:12|rel:255) dy(abs:12|rel:12)
; node # 7 D(-11,-20)->(-17,-20)
       fcb 2 ; drawmode 
       fcb 2,-31 ; starx/y relative to previous node
       fdb -12,-88 ; dx/dy. dx(abs:-76|rel:-88) dy(abs:0|rel:-12)
; node # 8 D(45,6)->(7,6)
       fcb 2 ; drawmode 
       fcb -26,56 ; starx/y relative to previous node
       fdb 0,-410 ; dx/dy. dx(abs:-486|rel:-410) dy(abs:0|rel:0)
; node # 9 D(79,5)->(60,5)
       fcb 2 ; drawmode 
       fcb 1,34 ; starx/y relative to previous node
       fdb 0,243 ; dx/dy. dx(abs:-243|rel:243) dy(abs:0|rel:0)
; node # 10 D(14,4)->(18,4)
       fcb 2 ; drawmode 
       fcb 1,-65 ; starx/y relative to previous node
       fdb 0,294 ; dx/dy. dx(abs:51|rel:294) dy(abs:0|rel:0)
; node # 11 D(-20,4)->(-22,4)
       fcb 2 ; drawmode 
       fcb 0,-34 ; starx/y relative to previous node
       fdb 0,-76 ; dx/dy. dx(abs:-25|rel:-76) dy(abs:0|rel:0)
; node # 12 D(-11,-20)->(-17,-20)
       fcb 2 ; drawmode 
       fcb 24,9 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-76|rel:-51) dy(abs:0|rel:0)
; node # 13 M(-3,-9)->(-6,-10)
       fcb 0 ; drawmode 
       fcb -11,8 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:-38|rel:38) dy(abs:12|rel:12)
; node # 14 D(-3,-31)->(-6,-31)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:0|rel:-12)
; node # 15 M(20,-18)->(21,-19)
       fcb 0 ; drawmode 
       fcb -13,23 ; starx/y relative to previous node
       fdb 12,50 ; dx/dy. dx(abs:12|rel:50) dy(abs:12|rel:12)
; node # 16 D(14,4)->(18,4)
       fcb 2 ; drawmode 
       fcb -22,-6 ; starx/y relative to previous node
       fdb -12,39 ; dx/dy. dx(abs:51|rel:39) dy(abs:0|rel:-12)
; node # 17 D(11,12)->(23,13)
       fcb 2 ; drawmode 
       fcb -8,-3 ; starx/y relative to previous node
       fdb -12,102 ; dx/dy. dx(abs:153|rel:102) dy(abs:-12|rel:-12)
; node # 18 D(109,17)->(91,20)
       fcb 2 ; drawmode 
       fcb -5,98 ; starx/y relative to previous node
       fdb -26,-383 ; dx/dy. dx(abs:-230|rel:-383) dy(abs:-38|rel:-26)
; node # 19 D(51,22)->(-1,22)
       fcb 2 ; drawmode 
       fcb -5,-58 ; starx/y relative to previous node
       fdb 38,-435 ; dx/dy. dx(abs:-665|rel:-435) dy(abs:0|rel:38)
; node # 20 D(-42,15)->(-40,14)
       fcb 2 ; drawmode 
       fcb 7,-93 ; starx/y relative to previous node
       fdb 12,690 ; dx/dy. dx(abs:25|rel:690) dy(abs:12|rel:12)
; node # 21 D(11,12)->(23,13)
       fcb 2 ; drawmode 
       fcb 3,53 ; starx/y relative to previous node
       fdb -24,128 ; dx/dy. dx(abs:153|rel:128) dy(abs:-12|rel:-24)
; node # 22 D(10,24)->(19,25)
       fcb 2 ; drawmode 
       fcb -12,-1 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:115|rel:-38) dy(abs:-12|rel:0)
; node # 23 D(-30,27)->(-30,26)
       fcb 2 ; drawmode 
       fcb -3,-40 ; starx/y relative to previous node
       fdb 24,-115 ; dx/dy. dx(abs:0|rel:-115) dy(abs:12|rel:24)
; node # 24 D(-42,15)->(-40,14)
       fcb 2 ; drawmode 
       fcb 12,-12 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:12|rel:0)
; node # 25 D(-20,4)->(-22,4)
       fcb 2 ; drawmode 
       fcb 11,22 ; starx/y relative to previous node
       fdb -12,-50 ; dx/dy. dx(abs:-25|rel:-50) dy(abs:0|rel:-12)
; node # 26 D(45,6)->(7,6)
       fcb 2 ; drawmode 
       fcb -2,65 ; starx/y relative to previous node
       fdb 0,-461 ; dx/dy. dx(abs:-486|rel:-461) dy(abs:0|rel:0)
; node # 27 M(50,37)->(7,39)
       fcb 0 ; drawmode 
       fcb -31,5 ; starx/y relative to previous node
       fdb -25,-64 ; dx/dy. dx(abs:-550|rel:-64) dy(abs:-25|rel:-25)
; node # 28 D(-30,27)->(-30,26)
       fcb 2 ; drawmode 
       fcb 10,-80 ; starx/y relative to previous node
       fdb 37,550 ; dx/dy. dx(abs:0|rel:550) dy(abs:12|rel:37)
; node # 29 M(10,24)->(19,25)
       fcb 0 ; drawmode 
       fcb 3,40 ; starx/y relative to previous node
       fdb -24,115 ; dx/dy. dx(abs:115|rel:115) dy(abs:-12|rel:-24)
; node # 30 D(93,32)->(74,36)
       fcb 2 ; drawmode 
       fcb -8,83 ; starx/y relative to previous node
       fdb -39,-358 ; dx/dy. dx(abs:-243|rel:-358) dy(abs:-51|rel:-39)
; node # 31 M(86,-10)->(51,-11)
       fcb 0 ; drawmode 
       fcb 42,-7 ; starx/y relative to previous node
       fdb 63,-205 ; dx/dy. dx(abs:-448|rel:-205) dy(abs:12|rel:63)
; node # 32 D(81,-10)->(44,-11)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-473|rel:-25) dy(abs:12|rel:0)
; node # 33 D(81,-18)->(44,-20)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:-473|rel:0) dy(abs:25|rel:13)
; node # 34 D(86,-18)->(51,-19)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb -13,25 ; dx/dy. dx(abs:-448|rel:25) dy(abs:12|rel:-13)
; node # 35 D(21,-15)->(13,-15)
       fcb 2 ; drawmode 
       fcb -3,-65 ; starx/y relative to previous node
       fdb -12,346 ; dx/dy. dx(abs:-102|rel:346) dy(abs:0|rel:-12)
; node # 36 D(15,-15)->(6,-15)
       fcb 2 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-115|rel:-13) dy(abs:0|rel:0)
; node # 37 D(29,-8)->(14,-9)
       fcb 2 ; drawmode 
       fcb -7,14 ; starx/y relative to previous node
       fdb 12,-77 ; dx/dy. dx(abs:-192|rel:-77) dy(abs:12|rel:12)
; node # 38 D(33,-8)->(19,-9)
       fcb 2 ; drawmode 
       fcb 0,4 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:-179|rel:13) dy(abs:12|rel:0)
; node # 39 D(86,-10)->(51,-11)
       fcb 2 ; drawmode 
       fcb 2,53 ; starx/y relative to previous node
       fdb 0,-269 ; dx/dy. dx(abs:-448|rel:-269) dy(abs:12|rel:0)
; node # 40 D(86,-18)->(51,-19)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-448|rel:0) dy(abs:12|rel:0)
; node # 41 M(81,-10)->(44,-11)
       fcb 0 ; drawmode 
       fcb -8,-5 ; starx/y relative to previous node
       fdb 0,-25 ; dx/dy. dx(abs:-473|rel:-25) dy(abs:12|rel:0)
; node # 42 D(29,-8)->(14,-9)
       fcb 2 ; drawmode 
       fcb -2,-52 ; starx/y relative to previous node
       fdb 0,281 ; dx/dy. dx(abs:-192|rel:281) dy(abs:12|rel:0)
; node # 43 M(21,-15)->(13,-15)
       fcb 0 ; drawmode 
       fcb 7,-8 ; starx/y relative to previous node
       fdb -12,90 ; dx/dy. dx(abs:-102|rel:90) dy(abs:0|rel:-12)
; node # 44 D(33,-8)->(19,-9)
       fcb 2 ; drawmode 
       fcb -7,12 ; starx/y relative to previous node
       fdb 12,-77 ; dx/dy. dx(abs:-179|rel:-77) dy(abs:12|rel:12)
; node # 45 M(15,-15)->(6,-15)
       fcb 0 ; drawmode 
       fcb 7,-18 ; starx/y relative to previous node
       fdb -12,64 ; dx/dy. dx(abs:-115|rel:64) dy(abs:0|rel:-12)
; node # 46 D(81,-18)->(44,-20)
       fcb 2 ; drawmode 
       fcb 3,66 ; starx/y relative to previous node
       fdb 25,-358 ; dx/dy. dx(abs:-473|rel:-358) dy(abs:25|rel:25)
       fcb  1  ; end of anim
; Animation 17
battleframe17:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(7,6)->(-31,6)
       fcb 0 ; drawmode 
       fcb -6,7 ; starx/y relative to previous node
       fdb 0,-486 ; dx/dy. dx(abs:-486|rel:-486) dy(abs:0|rel:0)
; node # 1 D(-1,22)->(-53,22)
       fcb 2 ; drawmode 
       fcb -16,-8 ; starx/y relative to previous node
       fdb 0,-179 ; dx/dy. dx(abs:-665|rel:-179) dy(abs:0|rel:0)
; node # 2 D(7,39)->(-38,38)
       fcb 2 ; drawmode 
       fcb -17,8 ; starx/y relative to previous node
       fdb 12,89 ; dx/dy. dx(abs:-576|rel:89) dy(abs:12|rel:12)
; node # 3 D(74,36)->(38,38)
       fcb 2 ; drawmode 
       fcb 3,67 ; starx/y relative to previous node
       fdb -37,116 ; dx/dy. dx(abs:-460|rel:116) dy(abs:-25|rel:-37)
; node # 4 D(91,20)->(53,22)
       fcb 2 ; drawmode 
       fcb 16,17 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:-486|rel:-26) dy(abs:-25|rel:0)
; node # 5 D(60,5)->(30,5)
       fcb 2 ; drawmode 
       fcb 15,-31 ; starx/y relative to previous node
       fdb 25,102 ; dx/dy. dx(abs:-384|rel:102) dy(abs:0|rel:25)
; node # 6 D(21,-19)->(20,-20)
       fcb 2 ; drawmode 
       fcb 24,-39 ; starx/y relative to previous node
       fdb 12,372 ; dx/dy. dx(abs:-12|rel:372) dy(abs:12|rel:12)
; node # 7 D(-17,-20)->(-20,-20)
       fcb 2 ; drawmode 
       fcb 1,-38 ; starx/y relative to previous node
       fdb -12,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:0|rel:-12)
; node # 8 D(7,6)->(-31,6)
       fcb 2 ; drawmode 
       fcb -26,24 ; starx/y relative to previous node
       fdb 0,-448 ; dx/dy. dx(abs:-486|rel:-448) dy(abs:0|rel:0)
; node # 9 D(60,5)->(31,6)
       fcb 2 ; drawmode 
       fcb 1,53 ; starx/y relative to previous node
       fdb -12,115 ; dx/dy. dx(abs:-371|rel:115) dy(abs:-12|rel:-12)
; node # 10 D(18,4)->(21,3)
       fcb 2 ; drawmode 
       fcb 1,-42 ; starx/y relative to previous node
       fdb 24,409 ; dx/dy. dx(abs:38|rel:409) dy(abs:12|rel:24)
; node # 11 D(-22,4)->(-21,3)
       fcb 2 ; drawmode 
       fcb 0,-40 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:12|rel:-26) dy(abs:12|rel:0)
; node # 12 D(-17,-20)->(-20,-20)
       fcb 2 ; drawmode 
       fcb 24,5 ; starx/y relative to previous node
       fdb -12,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:0|rel:-12)
; node # 13 M(-6,-10)->(-9,-9)
       fcb 0 ; drawmode 
       fcb -10,11 ; starx/y relative to previous node
       fdb -12,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:-12|rel:-12)
; node # 14 D(-6,-31)->(-9,-31)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:0|rel:12)
; node # 15 M(21,-19)->(20,-20)
       fcb 0 ; drawmode 
       fcb -12,27 ; starx/y relative to previous node
       fdb 12,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:12|rel:12)
; node # 16 D(18,4)->(21,3)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb 0,50 ; dx/dy. dx(abs:38|rel:50) dy(abs:12|rel:0)
; node # 17 D(23,13)->(32,13)
       fcb 2 ; drawmode 
       fcb -9,5 ; starx/y relative to previous node
       fdb -12,77 ; dx/dy. dx(abs:115|rel:77) dy(abs:0|rel:-12)
; node # 18 D(91,20)->(53,22)
       fcb 2 ; drawmode 
       fcb -7,68 ; starx/y relative to previous node
       fdb -25,-601 ; dx/dy. dx(abs:-486|rel:-601) dy(abs:-25|rel:-25)
; node # 19 D(-1,22)->(-53,22)
       fcb 2 ; drawmode 
       fcb -2,-92 ; starx/y relative to previous node
       fdb 25,-179 ; dx/dy. dx(abs:-665|rel:-179) dy(abs:0|rel:25)
; node # 20 D(-40,14)->(-33,13)
       fcb 2 ; drawmode 
       fcb 8,-39 ; starx/y relative to previous node
       fdb 12,754 ; dx/dy. dx(abs:89|rel:754) dy(abs:12|rel:12)
; node # 21 D(23,13)->(32,13)
       fcb 2 ; drawmode 
       fcb 1,63 ; starx/y relative to previous node
       fdb -12,26 ; dx/dy. dx(abs:115|rel:26) dy(abs:0|rel:-12)
; node # 22 D(19,25)->(25,26)
       fcb 2 ; drawmode 
       fcb -12,-4 ; starx/y relative to previous node
       fdb -12,-39 ; dx/dy. dx(abs:76|rel:-39) dy(abs:-12|rel:-12)
; node # 23 D(-30,26)->(-25,26)
       fcb 2 ; drawmode 
       fcb -1,-49 ; starx/y relative to previous node
       fdb 12,-12 ; dx/dy. dx(abs:64|rel:-12) dy(abs:0|rel:12)
; node # 24 D(-40,14)->(-33,13)
       fcb 2 ; drawmode 
       fcb 12,-10 ; starx/y relative to previous node
       fdb 12,25 ; dx/dy. dx(abs:89|rel:25) dy(abs:12|rel:12)
; node # 25 D(-22,4)->(-21,3)
       fcb 2 ; drawmode 
       fcb 10,18 ; starx/y relative to previous node
       fdb 0,-77 ; dx/dy. dx(abs:12|rel:-77) dy(abs:12|rel:0)
; node # 26 D(7,6)->(-31,6)
       fcb 2 ; drawmode 
       fcb -2,29 ; starx/y relative to previous node
       fdb -12,-498 ; dx/dy. dx(abs:-486|rel:-498) dy(abs:0|rel:-12)
; node # 27 M(7,39)->(-38,38)
       fcb 0 ; drawmode 
       fcb -33,0 ; starx/y relative to previous node
       fdb 12,-90 ; dx/dy. dx(abs:-576|rel:-90) dy(abs:12|rel:12)
; node # 28 D(-30,26)->(-25,26)
       fcb 2 ; drawmode 
       fcb 13,-37 ; starx/y relative to previous node
       fdb -12,640 ; dx/dy. dx(abs:64|rel:640) dy(abs:0|rel:-12)
; node # 29 M(19,25)->(25,26)
       fcb 0 ; drawmode 
       fcb 1,49 ; starx/y relative to previous node
       fdb -12,12 ; dx/dy. dx(abs:76|rel:12) dy(abs:-12|rel:-12)
; node # 30 D(74,36)->(38,38)
       fcb 2 ; drawmode 
       fcb -11,55 ; starx/y relative to previous node
       fdb -13,-536 ; dx/dy. dx(abs:-460|rel:-536) dy(abs:-25|rel:-13)
; node # 31 M(51,-11)->(5,-11)
       fcb 0 ; drawmode 
       fcb 47,-23 ; starx/y relative to previous node
       fdb 25,-128 ; dx/dy. dx(abs:-588|rel:-128) dy(abs:0|rel:25)
; node # 32 D(44,-11)->(-5,-11)
       fcb 2 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:-627|rel:-39) dy(abs:0|rel:0)
; node # 33 D(44,-20)->(-5,-21)
       fcb 2 ; drawmode 
       fcb 9,0 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:-627|rel:0) dy(abs:12|rel:12)
; node # 34 D(51,-19)->(5,-21)
       fcb 2 ; drawmode 
       fcb -1,7 ; starx/y relative to previous node
       fdb 13,39 ; dx/dy. dx(abs:-588|rel:39) dy(abs:25|rel:13)
; node # 35 D(13,-15)->(3,-15)
       fcb 2 ; drawmode 
       fcb -4,-38 ; starx/y relative to previous node
       fdb -25,460 ; dx/dy. dx(abs:-128|rel:460) dy(abs:0|rel:-25)
; node # 36 D(6,-15)->(-3,-15)
       fcb 2 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:-115|rel:13) dy(abs:0|rel:0)
; node # 37 D(14,-9)->(-4,-9)
       fcb 2 ; drawmode 
       fcb -6,8 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:-230|rel:-115) dy(abs:0|rel:0)
; node # 38 D(19,-9)->(3,-9)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:-204|rel:26) dy(abs:0|rel:0)
; node # 39 D(51,-11)->(5,-11)
       fcb 2 ; drawmode 
       fcb 2,32 ; starx/y relative to previous node
       fdb 0,-384 ; dx/dy. dx(abs:-588|rel:-384) dy(abs:0|rel:0)
; node # 40 D(51,-19)->(5,-21)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 25,0 ; dx/dy. dx(abs:-588|rel:0) dy(abs:25|rel:25)
; node # 41 M(44,-11)->(-5,-11)
       fcb 0 ; drawmode 
       fcb -8,-7 ; starx/y relative to previous node
       fdb -25,-39 ; dx/dy. dx(abs:-627|rel:-39) dy(abs:0|rel:-25)
; node # 42 D(14,-9)->(-4,-9)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb 0,397 ; dx/dy. dx(abs:-230|rel:397) dy(abs:0|rel:0)
; node # 43 M(13,-15)->(3,-15)
       fcb 0 ; drawmode 
       fcb 6,-1 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:-128|rel:102) dy(abs:0|rel:0)
; node # 44 D(19,-9)->(3,-9)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 0,-76 ; dx/dy. dx(abs:-204|rel:-76) dy(abs:0|rel:0)
; node # 45 M(6,-15)->(-3,-15)
       fcb 0 ; drawmode 
       fcb 6,-13 ; starx/y relative to previous node
       fdb 0,89 ; dx/dy. dx(abs:-115|rel:89) dy(abs:0|rel:0)
; node # 46 D(44,-20)->(-5,-21)
       fcb 2 ; drawmode 
       fcb 5,38 ; starx/y relative to previous node
       fdb 12,-512 ; dx/dy. dx(abs:-627|rel:-512) dy(abs:12|rel:12)
       fcb  1  ; end of anim
