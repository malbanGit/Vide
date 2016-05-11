schiss1framecount EQU 1 ; number of animations
; index table 
schiss1frametab fdb schiss1frame0
; Animation 0
schiss1frame0:
       fcb 64 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
       fcb 0 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb -13056,-11008 ; starx/y relative to previous node
    fdb 0,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -256,1024 ; starx/y relative to previous node
    fdb -8,8 ; dx/dy. dx(abs:20|rel:8) dy(abs:-8|rel:-8)
       fcb -1 ; drawmode 
       fdb -2304,1024 ; starx/y relative to previous node
    fdb 16,-20 ; dx/dy. dx(abs:0|rel:-20) dy(abs:8|rel:16)
       fcb 2 ; drawmode 
       fdb 512,-2304 ; starx/y relative to previous node
    fdb 0,12 ; dx/dy. dx(abs:12|rel:12) dy(abs:8|rel:0)
       fcb 2 ; drawmode 
       fdb 2048,0 ; starx/y relative to previous node
    fdb -4,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:4|rel:-4)
       fcb 0 ; drawmode 
       fdb -18944,-20736 ; starx/y relative to previous node
    fdb -4,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:0|rel:-4)
       fcb 2 ; drawmode 
       fdb 0,64256 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 52480,-31232 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -52736,-33536 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 3072,5376 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 0,54272 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 45056,-25856 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -44800,-28672 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 0 ; drawmode 
       fdb 12288,21248 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -2304,-1792 ; starx/y relative to previous node
    fdb -4,-28 ; dx/dy. dx(abs:-28|rel:-28) dy(abs:-4|rel:-4)
       fcb 2 ; drawmode 
       fdb 1024,-5888 ; starx/y relative to previous node
    fdb 40,16 ; dx/dy. dx(abs:-12|rel:16) dy(abs:36|rel:40)
       fcb 2 ; drawmode 
       fdb 5376,-768 ; starx/y relative to previous node
    fdb 4,48 ; dx/dy. dx(abs:36|rel:48) dy(abs:40|rel:4)
       fcb 2 ; drawmode 
       fdb 2560,5632 ; starx/y relative to previous node
    fdb -48,-8 ; dx/dy. dx(abs:28|rel:-8) dy(abs:-8|rel:-48)
       fcb 2 ; drawmode 
       fdb -5632,4352 ; starx/y relative to previous node
    fdb -4,-28 ; dx/dy. dx(abs:0|rel:-28) dy(abs:-12|rel:-4)
       fcb 2 ; drawmode 
       fdb -2304,512 ; starx/y relative to previous node
    fdb -48,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-60|rel:-48)
       fcb 2 ; drawmode 
       fdb -1792,-1792 ; starx/y relative to previous node
    fdb 36,-8 ; dx/dy. dx(abs:-8|rel:-8) dy(abs:-24|rel:36)
       fcb 2 ; drawmode 
       fdb 3584,256 ; starx/y relative to previous node
    fdb 24,8 ; dx/dy. dx(abs:0|rel:8) dy(abs:0|rel:24)
       fcb 0 ; drawmode 
       fdb 1792,6912 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -2304,-512 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -3584,3072 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -5376,-1792 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb -256,8704 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 5376,-1536 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 3072,4096 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 2048,-1024 ; starx/y relative to previous node
    fdb -16,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-16|rel:-16)
       fcb 2 ; drawmode 
       fdb -512,-3584 ; starx/y relative to previous node
    fdb 16,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:16)
       fcb 2 ; drawmode 
       fdb 0,-3584 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 2048,-4352 ; starx/y relative to previous node
    fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb 2 ; drawmode 
       fdb 256,3584 ; starx/y relative to previous node
    fdb -36,16 ; dx/dy. dx(abs:16|rel:16) dy(abs:-36|rel:-36)
       fcb 2 ; drawmode 
       fdb -256,5120 ; starx/y relative to previous node
    fdb 8,-40 ; dx/dy. dx(abs:-24|rel:-40) dy(abs:-28|rel:8)
       fcb 2 ; drawmode 
       fdb -1280,2560 ; starx/y relative to previous node
    fdb 8,16 ; dx/dy. dx(abs:-8|rel:16) dy(abs:-20|rel:8)
       fcb 2 ; drawmode 
       fdb 8704,-1280 ; starx/y relative to previous node
    fdb -124,12 ; dx/dy. dx(abs:4|rel:12) dy(abs:-144|rel:-124)
       fcb 2 ; drawmode 
       fdb 2304,-3072 ; starx/y relative to previous node
    fdb -20,16 ; dx/dy. dx(abs:20|rel:16) dy(abs:-164|rel:-20)
       fcb 2 ; drawmode 
       fdb -256,-3584 ; starx/y relative to previous node
    fdb 12,0 ; dx/dy. dx(abs:20|rel:0) dy(abs:-152|rel:12)
       fcb 2 ; drawmode 
       fdb -1536,-3072 ; starx/y relative to previous node
    fdb 20,8 ; dx/dy. dx(abs:28|rel:8) dy(abs:-132|rel:20)
       fcb 2 ; drawmode 
       fdb -6912,-256 ; starx/y relative to previous node
    fdb 124,-20 ; dx/dy. dx(abs:8|rel:-20) dy(abs:-8|rel:124)
       fcb 0 ; drawmode 
       fdb 1024,-1280 ; starx/y relative to previous node
    fdb 64,-20 ; dx/dy. dx(abs:-12|rel:-20) dy(abs:56|rel:64)
       fcb 2 ; drawmode 
       fdb 1280,-1792 ; starx/y relative to previous node
    fdb -8,4 ; dx/dy. dx(abs:-8|rel:4) dy(abs:48|rel:-8)
       fcb 2 ; drawmode 
       fdb 1536,1792 ; starx/y relative to previous node
    fdb 8,-8 ; dx/dy. dx(abs:-16|rel:-8) dy(abs:56|rel:8)
       fcb 2 ; drawmode 
       fdb -2560,0 ; starx/y relative to previous node
    fdb -8,4 ; dx/dy. dx(abs:-12|rel:4) dy(abs:48|rel:-8)
       fcb 2 ; drawmode 
       fdb 9728,-1280 ; starx/y relative to previous node
    fdb -48,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:0|rel:-48)
       fcb 0 ; drawmode 
       fdb 34560,-22272 ; starx/y relative to previous node
    fdb -16,-108 ; dx/dy. dx(abs:-108|rel:-108) dy(abs:-16|rel:-16)
       fcb 2 ; drawmode 
       fdb -8960,1536 ; starx/y relative to previous node
    fdb -120,24 ; dx/dy. dx(abs:-84|rel:24) dy(abs:-136|rel:-120)
       fcb 2 ; drawmode 
       fdb 2048,2048 ; starx/y relative to previous node
    fdb 112,12 ; dx/dy. dx(abs:-72|rel:12) dy(abs:-24|rel:112)
       fcb 2 ; drawmode 
       fdb -2560,1280 ; starx/y relative to previous node
    fdb -80,44 ; dx/dy. dx(abs:-28|rel:44) dy(abs:-104|rel:-80)
       fcb 2 ; drawmode 
       fdb 9472,-256 ; starx/y relative to previous node
    fdb 88,52 ; dx/dy. dx(abs:24|rel:52) dy(abs:-16|rel:88)
       fcb 0 ; drawmode 
       fdb -9472,2816 ; starx/y relative to previous node
    fdb -76,-40 ; dx/dy. dx(abs:-16|rel:-40) dy(abs:-92|rel:-76)
       fcb 2 ; drawmode 
       fdb 9472,512 ; starx/y relative to previous node
    fdb 80,20 ; dx/dy. dx(abs:4|rel:20) dy(abs:-12|rel:80)
       fcb 2 ; drawmode 
       fdb -9472,2304 ; starx/y relative to previous node
    fdb -40,8 ; dx/dy. dx(abs:12|rel:8) dy(abs:-52|rel:-40)
       fcb 0 ; drawmode 
       fdb 4096,-768 ; starx/y relative to previous node
    fdb 48,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-4|rel:48)
       fcb 2 ; drawmode 
       fdb 512,-2048 ; starx/y relative to previous node
    fdb -44,-4 ; dx/dy. dx(abs:-4|rel:-4) dy(abs:-48|rel:-44)
       fcb 0 ; drawmode 
       fdb -4608,4864 ; starx/y relative to previous node
    fdb 12,16 ; dx/dy. dx(abs:12|rel:16) dy(abs:-36|rel:12)
       fcb 2 ; drawmode 
       fdb 9216,-256 ; starx/y relative to previous node
    fdb 32,0 ; dx/dy. dx(abs:12|rel:0) dy(abs:-4|rel:32)
       fcb 2 ; drawmode 
       fdb -1792,2048 ; starx/y relative to previous node
    fdb -4,8 ; dx/dy. dx(abs:20|rel:8) dy(abs:-8|rel:-4)
       fcb 2 ; drawmode 
       fdb -1536,512 ; starx/y relative to previous node
    fdb -20,-4 ; dx/dy. dx(abs:16|rel:-4) dy(abs:-28|rel:-20)
       fcb 2 ; drawmode 
       fdb -1536,-1280 ; starx/y relative to previous node
    fdb 4,-4 ; dx/dy. dx(abs:12|rel:-4) dy(abs:-24|rel:4)
       fcb 2 ; drawmode 
       fdb -4608,2048 ; starx/y relative to previous node
    fdb 0,8 ; dx/dy. dx(abs:20|rel:8) dy(abs:-24|rel:0)
       fcb 0 ; drawmode 
       fdb 256,3072 ; starx/y relative to previous node
    fdb 0,16 ; dx/dy. dx(abs:36|rel:16) dy(abs:-24|rel:0)
       fcb 2 ; drawmode 
       fdb 9472,-256 ; starx/y relative to previous node
    fdb -4,-24 ; dx/dy. dx(abs:12|rel:-24) dy(abs:-28|rel:-4)
       fcb 2 ; drawmode 
       fdb -9472,4352 ; starx/y relative to previous node
    fdb 12,8 ; dx/dy. dx(abs:20|rel:8) dy(abs:-16|rel:12)
       fcb 2 ; drawmode 
       fdb 9216,-1280 ; starx/y relative to previous node
    fdb -4,12 ; dx/dy. dx(abs:32|rel:12) dy(abs:-20|rel:-4)
       fcb 0 ; drawmode 
       fdb -512,3584 ; starx/y relative to previous node
    fdb 16,-12 ; dx/dy. dx(abs:20|rel:-12) dy(abs:-4|rel:16)
       fcb 2 ; drawmode 
       fdb -6656,-768 ; starx/y relative to previous node
    fdb -12,12 ; dx/dy. dx(abs:32|rel:12) dy(abs:-16|rel:-12)
       fcb 2 ; drawmode 
       fdb -2816,768 ; starx/y relative to previous node
    fdb 4,12 ; dx/dy. dx(abs:44|rel:12) dy(abs:-12|rel:4)
       fcb 2 ; drawmode 
       fdb 512,3840 ; starx/y relative to previous node
    fdb -44,0 ; dx/dy. dx(abs:44|rel:0) dy(abs:-56|rel:-44)
       fcb 2 ; drawmode 
       fdb 9728,-512 ; starx/y relative to previous node
    fdb 44,-4 ; dx/dy. dx(abs:40|rel:-4) dy(abs:-12|rel:44)
       fcb 0 ; drawmode 
       fdb -9216,2304 ; starx/y relative to previous node
    fdb -64,24 ; dx/dy. dx(abs:64|rel:24) dy(abs:-76|rel:-64)
       fcb 2 ; drawmode 
       fdb 8960,256 ; starx/y relative to previous node
    fdb 76,-16 ; dx/dy. dx(abs:48|rel:-16) dy(abs:0|rel:76)
       fcb 2 ; drawmode 
       fdb -9216,3584 ; starx/y relative to previous node
    fdb -88,56 ; dx/dy. dx(abs:104|rel:56) dy(abs:-88|rel:-88)
       fcb 2 ; drawmode 
       fdb 9472,-256 ; starx/y relative to previous node
    fdb 84,-12 ; dx/dy. dx(abs:92|rel:-12) dy(abs:-4|rel:84)
       fcb 0 ; drawmode 
       fdb -3840,11008 ; starx/y relative to previous node
    fdb -16,80 ; dx/dy. dx(abs:172|rel:80) dy(abs:-20|rel:-16)
       fcb 2 ; drawmode 
       fdb 2560,-1536 ; starx/y relative to previous node
    fdb 8,-24 ; dx/dy. dx(abs:148|rel:-24) dy(abs:-12|rel:8)
       fcb 2 ; drawmode 
       fdb 1024,-2304 ; starx/y relative to previous node
    fdb 16,-16 ; dx/dy. dx(abs:132|rel:-16) dy(abs:4|rel:16)
       fcb 2 ; drawmode 
       fdb -768,-4608 ; starx/y relative to previous node
    fdb -20,-16 ; dx/dy. dx(abs:116|rel:-16) dy(abs:-16|rel:-20)
       fcb 2 ; drawmode 
       fdb -4352,-1280 ; starx/y relative to previous node
    fdb 8,16 ; dx/dy. dx(abs:132|rel:16) dy(abs:-8|rel:8)
       fcb 2 ; drawmode 
       fdb -5120,3072 ; starx/y relative to previous node
    fdb -84,-12 ; dx/dy. dx(abs:120|rel:-12) dy(abs:-92|rel:-84)
       fcb 2 ; drawmode 
       fdb -256,5632 ; starx/y relative to previous node
    fdb -100,28 ; dx/dy. dx(abs:148|rel:28) dy(abs:-192|rel:-100)
       fcb 2 ; drawmode 
       fdb 3072,1024 ; starx/y relative to previous node
    fdb 48,24 ; dx/dy. dx(abs:172|rel:24) dy(abs:-144|rel:48)
       fcb 2 ; drawmode 
       fdb 1536,-2048 ; starx/y relative to previous node
    fdb 52,32 ; dx/dy. dx(abs:204|rel:32) dy(abs:-92|rel:52)
       fcb 2 ; drawmode 
       fdb 0,-3584 ; starx/y relative to previous node
    fdb 36,-8 ; dx/dy. dx(abs:196|rel:-8) dy(abs:-56|rel:36)
       fcb 1  ; end of anim
