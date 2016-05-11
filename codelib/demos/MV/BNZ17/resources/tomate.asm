tomateframecount EQU 1 ; number of animations
; index table 
tomateframetab fdb tomateframe0
; Animation 0
tomateframe0:
       fcb 64 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb -7424,-30208 ; starx/y relative to previous node
    fdb 12,-20 ; dx/dy. dx(abs:-20|rel:-20) dy(abs:12|rel:12)
       fcb 2 ; drawmode 
       fdb -18944,8192 ; starx/y relative to previous node
    fdb 0,36 ; dx/dy. dx(abs:16|rel:36) dy(abs:12|rel:0)
       fcb 2 ; drawmode 
       fdb -6144,18944 ; starx/y relative to previous node
    fdb -8,-28 ; dx/dy. dx(abs:-12|rel:-28) dy(abs:4|rel:-8)
       fcb 2 ; drawmode 
       fdb 768,20480 ; starx/y relative to previous node
    fdb 8,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:12|rel:8)
       fcb 2 ; drawmode 
       fdb 7936,10240 ; starx/y relative to previous node
    fdb -4,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:8|rel:-4)
       fcb 2 ; drawmode 
       fdb 13824,4864 ; starx/y relative to previous node
    fdb 8,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:16|rel:8)
       fcb 2 ; drawmode 
       fdb 13824,-7168 ; starx/y relative to previous node
    fdb 20,16 ; dx/dy. dx(abs:4|rel:16) dy(abs:36|rel:20)
       fcb 2 ; drawmode 
       fdb 13824,-12032 ; starx/y relative to previous node
    fdb -40,-4 ; dx/dy. dx(abs:0|rel:-4) dy(abs:-4|rel:-40)
       fcb 2 ; drawmode 
       fdb 2560,-12800 ; starx/y relative to previous node
    fdb 0,40 ; dx/dy. dx(abs:40|rel:40) dy(abs:-4|rel:0)
       fcb 2 ; drawmode 
       fdb 5120,-2048 ; starx/y relative to previous node
    fdb 0,-20 ; dx/dy. dx(abs:20|rel:-20) dy(abs:-4|rel:0)
       fcb 2 ; drawmode 
       fdb 1536,2048 ; starx/y relative to previous node
    fdb 0,8 ; dx/dy. dx(abs:28|rel:8) dy(abs:-4|rel:0)
       fcb 2 ; drawmode 
       fdb 2048,1024 ; starx/y relative to previous node
    fdb 4,-8 ; dx/dy. dx(abs:20|rel:-8) dy(abs:0|rel:4)
       fcb 2 ; drawmode 
       fdb 1024,-1792 ; starx/y relative to previous node
    fdb 4,0 ; dx/dy. dx(abs:20|rel:0) dy(abs:4|rel:4)
       fcb 2 ; drawmode 
       fdb -2048,-1536 ; starx/y relative to previous node
    fdb 4,8 ; dx/dy. dx(abs:28|rel:8) dy(abs:8|rel:4)
       fcb 2 ; drawmode 
       fdb 2304,-2048 ; starx/y relative to previous node
    fdb 8,8 ; dx/dy. dx(abs:36|rel:8) dy(abs:16|rel:8)
       fcb 2 ; drawmode 
       fdb -512,-3072 ; starx/y relative to previous node
    fdb 8,-4 ; dx/dy. dx(abs:32|rel:-4) dy(abs:24|rel:8)
       fcb 2 ; drawmode 
       fdb -4352,-3072 ; starx/y relative to previous node
    fdb 32,16 ; dx/dy. dx(abs:48|rel:16) dy(abs:56|rel:32)
       fcb 2 ; drawmode 
       fdb -5632,6912 ; starx/y relative to previous node
    fdb -52,-48 ; dx/dy. dx(abs:0|rel:-48) dy(abs:4|rel:-52)
       fcb 2 ; drawmode 
       fdb -2304,2816 ; starx/y relative to previous node
    fdb -16,-16 ; dx/dy. dx(abs:-16|rel:-16) dy(abs:-12|rel:-16)
       fcb 0 ; drawmode 
       fdb 2048,-3584 ; starx/y relative to previous node
    fdb 52,16 ; dx/dy. dx(abs:0|rel:16) dy(abs:40|rel:52)
       fcb 2 ; drawmode 
       fdb -2048,-12032 ; starx/y relative to previous node
    fdb 0,-16 ; dx/dy. dx(abs:-16|rel:-16) dy(abs:40|rel:0)
       fcb 2 ; drawmode 
       fdb -7424,-12544 ; starx/y relative to previous node
    fdb -44,28 ; dx/dy. dx(abs:12|rel:28) dy(abs:-4|rel:-44)
       fcb 2 ; drawmode 
       fdb -17408,-1792 ; starx/y relative to previous node
    fdb 24,-28 ; dx/dy. dx(abs:-16|rel:-28) dy(abs:20|rel:24)
       fcb 0 ; drawmode 
       fdb -1024,9984 ; starx/y relative to previous node
    fdb -40,8 ; dx/dy. dx(abs:-8|rel:8) dy(abs:-20|rel:-40)
       fcb 2 ; drawmode 
       fdb -9216,3328 ; starx/y relative to previous node
    fdb -4,8 ; dx/dy. dx(abs:0|rel:8) dy(abs:-24|rel:-4)
       fcb 2 ; drawmode 
       fdb -8960,14080 ; starx/y relative to previous node
    fdb 44,112 ; dx/dy. dx(abs:112|rel:112) dy(abs:20|rel:44)
       fcb 2 ; drawmode 
       fdb 768,17920 ; starx/y relative to previous node
    fdb -8,-164 ; dx/dy. dx(abs:-52|rel:-164) dy(abs:12|rel:-8)
       fcb 2 ; drawmode 
       fdb 7936,11264 ; starx/y relative to previous node
    fdb 56,36 ; dx/dy. dx(abs:-16|rel:36) dy(abs:68|rel:56)
       fcb 2 ; drawmode 
       fdb 11776,-2048 ; starx/y relative to previous node
    fdb -92,28 ; dx/dy. dx(abs:12|rel:28) dy(abs:-24|rel:-92)
       fcb 2 ; drawmode 
       fdb -6912,-8448 ; starx/y relative to previous node
    fdb -16,-4 ; dx/dy. dx(abs:8|rel:-4) dy(abs:-40|rel:-16)
       fcb 2 ; drawmode 
       fdb -2304,-5632 ; starx/y relative to previous node
    fdb -20,-16 ; dx/dy. dx(abs:-8|rel:-16) dy(abs:-60|rel:-20)
       fcb 2 ; drawmode 
       fdb -512,-10240 ; starx/y relative to previous node
    fdb 12,4 ; dx/dy. dx(abs:-4|rel:4) dy(abs:-48|rel:12)
       fcb 2 ; drawmode 
       fdb 5376,-8960 ; starx/y relative to previous node
    fdb -24,4 ; dx/dy. dx(abs:0|rel:4) dy(abs:-72|rel:-24)
       fcb 2 ; drawmode 
       fdb 1792,-11264 ; starx/y relative to previous node
    fdb 52,-4 ; dx/dy. dx(abs:-4|rel:-4) dy(abs:-20|rel:52)
       fcb 0 ; drawmode 
       fdb 16640,2304 ; starx/y relative to previous node
    fdb -28,-40 ; dx/dy. dx(abs:-44|rel:-40) dy(abs:-48|rel:-28)
       fcb 2 ; drawmode 
       fdb 256,1792 ; starx/y relative to previous node
    fdb 56,96 ; dx/dy. dx(abs:52|rel:96) dy(abs:8|rel:56)
       fcb 2 ; drawmode 
       fdb -2816,4096 ; starx/y relative to previous node
    fdb 8,-24 ; dx/dy. dx(abs:28|rel:-24) dy(abs:16|rel:8)
       fcb 2 ; drawmode 
       fdb -1536,6400 ; starx/y relative to previous node
    fdb -16,-12 ; dx/dy. dx(abs:16|rel:-12) dy(abs:0|rel:-16)
       fcb 2 ; drawmode 
       fdb -1792,3072 ; starx/y relative to previous node
    fdb -12,-8 ; dx/dy. dx(abs:8|rel:-8) dy(abs:-12|rel:-12)
       fcb 2 ; drawmode 
       fdb 1536,-7680 ; starx/y relative to previous node
    fdb -20,0 ; dx/dy. dx(abs:8|rel:0) dy(abs:-32|rel:-20)
       fcb 2 ; drawmode 
       fdb 1536,-5888 ; starx/y relative to previous node
    fdb 8,-36 ; dx/dy. dx(abs:-28|rel:-36) dy(abs:-24|rel:8)
       fcb 2 ; drawmode 
       fdb 2560,-1536 ; starx/y relative to previous node
    fdb -20,-28 ; dx/dy. dx(abs:-56|rel:-28) dy(abs:-44|rel:-20)
       fcb 0 ; drawmode 
       fdb -6912,22272 ; starx/y relative to previous node
    fdb 44,40 ; dx/dy. dx(abs:-16|rel:40) dy(abs:0|rel:44)
       fcb 2 ; drawmode 
       fdb 768,9728 ; starx/y relative to previous node
    fdb -24,20 ; dx/dy. dx(abs:4|rel:20) dy(abs:-24|rel:-24)
       fcb 2 ; drawmode 
       fdb 4864,4608 ; starx/y relative to previous node
    fdb -24,0 ; dx/dy. dx(abs:4|rel:0) dy(abs:-48|rel:-24)
       fcb 2 ; drawmode 
       fdb 0,-1280 ; starx/y relative to previous node
    fdb 72,-16 ; dx/dy. dx(abs:-12|rel:-16) dy(abs:24|rel:72)
       fcb 2 ; drawmode 
       fdb -2560,-4352 ; starx/y relative to previous node
    fdb 36,-4 ; dx/dy. dx(abs:-16|rel:-4) dy(abs:60|rel:36)
       fcb 2 ; drawmode 
       fdb -512,-3584 ; starx/y relative to previous node
    fdb -40,-28 ; dx/dy. dx(abs:-44|rel:-28) dy(abs:20|rel:-40)
       fcb 2 ; drawmode 
       fdb -2560,-4864 ; starx/y relative to previous node
    fdb -20,24 ; dx/dy. dx(abs:-20|rel:24) dy(abs:0|rel:-20)
       fcb 1  ; end of anim
