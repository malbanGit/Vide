ekgframecount EQU 23 ; number of animations
; index table 
ekgframetab        fdb ekgframe0
       fdb ekgframe1
       fdb ekgframe2
       fdb ekgframe3
       fdb ekgframe4
       fdb ekgframe5
       fdb ekgframe6
       fdb ekgframe7
       fdb ekgframe8
       fdb ekgframe9
       fdb ekgframe10
       fdb ekgframe11
       fdb ekgframe12
       fdb ekgframe13
       fdb ekgframe14
       fdb ekgframe15
       fdb ekgframe16
       fdb ekgframe17
       fdb ekgframe18
       fdb ekgframe19
       fdb ekgframe20
       fdb ekgframe21
       fdb ekgframe22

; Animation 0
ekgframe0:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-100,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,1203 ; dx/dy. dx(abs:1203|rel:1203) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 1
ekgframe1:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-6,0)->(0,-4)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 204,307 ; dx/dy. dx(abs:307|rel:307) dy(abs:204|rel:204)
       fcb  1  ; end of anim
; Animation 2
ekgframe2:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(0,-4)->(2,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -204,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-204|rel:-204)
       fcb  1  ; end of anim
; Animation 3
ekgframe3:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(2,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 4
ekgframe4:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(5,0)->(6,2)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -102,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-102|rel:-102)
       fcb  1  ; end of anim
; Animation 5
ekgframe5:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(6,2)->(10,-19)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 1075,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:1075|rel:1075)
       fcb  1  ; end of anim
; Animation 6
ekgframe6:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(10,-19)->(11,12)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -1587,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-1587|rel:-1587)
       fcb  1  ; end of anim
; Animation 7
ekgframe7:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(11,12)->(14,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 614,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:614|rel:614)
       fcb  1  ; end of anim
; Animation 8
ekgframe8:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(14,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,563 ; dx/dy. dx(abs:563|rel:563) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 9
ekgframe9:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(25,0)->(33,-4)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 204,409 ; dx/dy. dx(abs:409|rel:409) dy(abs:204|rel:204)
       fcb  1  ; end of anim
; Animation 10
ekgframe10:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-100,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(33,-4)->(34,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -204,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-204|rel:-204)
       fcb  1  ; end of anim
; Animation 11
ekgframe11:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-100,0)->(-6,0)
       fcb 0 ; drawmode 
       fdb 0,-25600 ; starx/y relative to previous node
       fdb 0,1203 ; dx/dy. dx(abs:1203|rel:1203) dy(abs:0|rel:0)
; node # 1 D(-6,0)->(-6,0)
       fcb 2 ; drawmode 
       fdb 0,24064 ; starx/y relative to previous node
       fdb 0,-1203 ; dx/dy. dx(abs:0|rel:-1203) dy(abs:0|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(34,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,857 ; dx/dy. dx(abs:857|rel:857) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 12
ekgframe12:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-6,0)->(0,-4)
       fcb 0 ; drawmode 
       fdb 0,-1536 ; starx/y relative to previous node
       fdb 204,307 ; dx/dy. dx(abs:307|rel:307) dy(abs:204|rel:204)
; node # 1 D(-6,0)->(0,-4)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:307|rel:0) dy(abs:204|rel:0)
; node # 2 D(0,-4)->(0,-4)
       fcb 2 ; drawmode 
       fdb 1024,1536 ; starx/y relative to previous node
       fdb -204,-307 ; dx/dy. dx(abs:0|rel:-307) dy(abs:0|rel:-204)
; node # 3 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 13
ekgframe13:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,-4)->(2,0)
       fcb 0 ; drawmode 
       fdb 1024,0 ; starx/y relative to previous node
       fdb -204,102 ; dx/dy. dx(abs:102|rel:102) dy(abs:-204|rel:-204)
; node # 1 D(0,-4)->(2,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:-204|rel:0)
; node # 2 D(2,0)->(2,0)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 204,-102 ; dx/dy. dx(abs:0|rel:-102) dy(abs:0|rel:204)
; node # 3 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 14
ekgframe14:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(2,0)->(5,0)
       fcb 0 ; drawmode 
       fdb 0,512 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:0|rel:0)
; node # 1 D(2,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:0|rel:0)
; node # 2 D(5,0)->(5,0)
       fcb 2 ; drawmode 
       fdb 0,768 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:0)
; node # 3 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 15
ekgframe15:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(5,0)->(6,2)
       fcb 0 ; drawmode 
       fdb 0,1280 ; starx/y relative to previous node
       fdb -102,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-102|rel:-102)
; node # 1 D(5,0)->(6,2)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-102|rel:0)
; node # 2 D(6,2)->(6,2)
       fcb 2 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb 102,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:0|rel:102)
; node # 3 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 16
ekgframe16:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(6,2)->(10,-19)
       fcb 0 ; drawmode 
       fdb -512,1536 ; starx/y relative to previous node
       fdb 1075,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:1075|rel:1075)
; node # 1 D(6,2)->(10,-19)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:1075|rel:0)
; node # 2 D(10,-19)->(10,-19)
       fcb 2 ; drawmode 
       fdb 5376,1024 ; starx/y relative to previous node
       fdb -1075,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:0|rel:-1075)
; node # 3 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 17
ekgframe17:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(10,-19)->(11,12)
       fcb 0 ; drawmode 
       fdb 4864,2560 ; starx/y relative to previous node
       fdb -1587,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-1587|rel:-1587)
; node # 1 D(10,-19)->(11,12)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-1587|rel:0)
; node # 2 D(11,12)->(11,12)
       fcb 2 ; drawmode 
       fdb -7936,256 ; starx/y relative to previous node
       fdb 1587,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:0|rel:1587)
; node # 3 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 18
ekgframe18:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(11,12)->(14,0)
       fcb 0 ; drawmode 
       fdb -3072,2816 ; starx/y relative to previous node
       fdb 614,153 ; dx/dy. dx(abs:153|rel:153) dy(abs:614|rel:614)
; node # 1 D(11,12)->(14,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:614|rel:0)
; node # 2 D(14,0)->(14,0)
       fcb 2 ; drawmode 
       fdb 3072,768 ; starx/y relative to previous node
       fdb -614,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:0|rel:-614)
; node # 3 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 19
ekgframe19:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(14,0)->(25,0)
       fcb 0 ; drawmode 
       fdb 0,3584 ; starx/y relative to previous node
       fdb 0,563 ; dx/dy. dx(abs:563|rel:563) dy(abs:0|rel:0)
; node # 1 D(14,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:563|rel:0) dy(abs:0|rel:0)
; node # 2 D(25,0)->(25,0)
       fcb 2 ; drawmode 
       fdb 0,2816 ; starx/y relative to previous node
       fdb 0,-563 ; dx/dy. dx(abs:0|rel:-563) dy(abs:0|rel:0)
; node # 3 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 20
ekgframe20:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(25,0)->(33,-4)
       fcb 0 ; drawmode 
       fdb 0,6400 ; starx/y relative to previous node
       fdb 204,409 ; dx/dy. dx(abs:409|rel:409) dy(abs:204|rel:204)
; node # 1 D(25,0)->(33,-4)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:409|rel:0) dy(abs:204|rel:0)
; node # 2 D(33,-4)->(33,-4)
       fcb 2 ; drawmode 
       fdb 1024,2048 ; starx/y relative to previous node
       fdb -204,-409 ; dx/dy. dx(abs:0|rel:-409) dy(abs:0|rel:-204)
; node # 3 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 21
ekgframe21:
       fcb 5 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(33,-4)->(34,0)
       fcb 0 ; drawmode 
       fdb 1024,8448 ; starx/y relative to previous node
       fdb -204,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-204|rel:-204)
; node # 1 D(33,-4)->(34,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-204|rel:0)
; node # 2 D(34,0)->(34,0)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 204,-51 ; dx/dy. dx(abs:0|rel:-51) dy(abs:0|rel:204)
; node # 3 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 22
ekgframe22:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(34,0)->(101,0)
       fcb 0 ; drawmode 
       fdb 0,8704 ; starx/y relative to previous node
       fdb 0,857 ; dx/dy. dx(abs:857|rel:857) dy(abs:0|rel:0)
; node # 1 D(34,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:857|rel:0) dy(abs:0|rel:0)
; node # 2 D(101,0)->(101,0)
       fcb 2 ; drawmode 
       fdb 0,17152 ; starx/y relative to previous node
       fdb 0,-857 ; dx/dy. dx(abs:0|rel:-857) dy(abs:0|rel:0)
       fcb  1  ; end of anim
