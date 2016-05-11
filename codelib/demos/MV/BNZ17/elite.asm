eliteframecount EQU 15 ; number of animations
; index table 
eliteframetab        fdb eliteframe0
       fdb eliteframe1
       fdb eliteframe2
       fdb eliteframe3
       fdb eliteframe4
       fdb eliteframe5
       fdb eliteframe6
       fdb eliteframe7
       fdb eliteframe8
       fdb eliteframe9
       fdb eliteframe10
       fdb eliteframe11
       fdb eliteframe12
       fdb eliteframe13
       fdb eliteframe14

; Animation 0
eliteframe0:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,76)->(18,72)
       fcb 0 ; drawmode 
       fdb -19456,0 ; starx/y relative to previous node
       fdb 51,230 ; dx/dy. dx(abs:230|rel:230) dy(abs:51|rel:51)
; node # 1 D(-49,77)->(-25,81)
       fcb 2 ; drawmode 
       fdb -256,-12544 ; starx/y relative to previous node
       fdb -102,77 ; dx/dy. dx(abs:307|rel:77) dy(abs:-51|rel:-102)
; node # 2 D(-74,80)->(-48,86)
       fcb 2 ; drawmode 
       fdb -768,-6400 ; starx/y relative to previous node
       fdb -25,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:-76|rel:-25)
; node # 3 D(-67,44)->(-48,53)
       fcb 2 ; drawmode 
       fdb 9216,1792 ; starx/y relative to previous node
       fdb -39,-89 ; dx/dy. dx(abs:243|rel:-89) dy(abs:-115|rel:-39)
; node # 4 D(-15,-44)->(-21,-33)
       fcb 2 ; drawmode 
       fdb 22528,13312 ; starx/y relative to previous node
       fdb -25,-319 ; dx/dy. dx(abs:-76|rel:-319) dy(abs:-140|rel:-25)
; node # 5 D(15,-44)->(3,-40)
       fcb 2 ; drawmode 
       fdb 0,7680 ; starx/y relative to previous node
       fdb 89,-77 ; dx/dy. dx(abs:-153|rel:-77) dy(abs:-51|rel:89)
; node # 6 D(67,44)->(67,25)
       fcb 2 ; drawmode 
       fdb -22528,13312 ; starx/y relative to previous node
       fdb 294,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:243|rel:294)
; node # 7 D(74,80)->(81,58)
       fcb 2 ; drawmode 
       fdb -9216,1792 ; starx/y relative to previous node
       fdb 38,89 ; dx/dy. dx(abs:89|rel:89) dy(abs:281|rel:38)
; node # 8 D(49,78)->(63,62)
       fcb 2 ; drawmode 
       fdb 512,-6400 ; starx/y relative to previous node
       fdb -77,90 ; dx/dy. dx(abs:179|rel:90) dy(abs:204|rel:-77)
; node # 9 D(0,76)->(18,72)
       fcb 2 ; drawmode 
       fdb 512,-12544 ; starx/y relative to previous node
       fdb -153,51 ; dx/dy. dx(abs:230|rel:51) dy(abs:51|rel:-153)
; node # 10 M(-4,78)->(13,73)
       fcb 0 ; drawmode 
       fdb -512,-1024 ; starx/y relative to previous node
       fdb 13,-13 ; dx/dy. dx(abs:217|rel:-13) dy(abs:64|rel:13)
; node # 11 D(-25,78)->(-10,78)
       fcb 2 ; drawmode 
       fdb 0,-5376 ; starx/y relative to previous node
       fdb -64,-25 ; dx/dy. dx(abs:192|rel:-25) dy(abs:0|rel:-64)
; node # 12 D(-26,81)->(-10,78)
       fcb 2 ; drawmode 
       fdb -768,-256 ; starx/y relative to previous node
       fdb 38,12 ; dx/dy. dx(abs:204|rel:12) dy(abs:38|rel:38)
; node # 13 D(-4,82)->(13,73)
       fcb 2 ; drawmode 
       fdb -256,5632 ; starx/y relative to previous node
       fdb 77,13 ; dx/dy. dx(abs:217|rel:13) dy(abs:115|rel:77)
; node # 14 D(-4,78)->(13,73)
       fcb 2 ; drawmode 
       fdb 1024,0 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:217|rel:0) dy(abs:64|rel:-51)
; node # 15 M(3,78)->(22,71)
       fcb 0 ; drawmode 
       fdb 0,1792 ; starx/y relative to previous node
       fdb 25,26 ; dx/dy. dx(abs:243|rel:26) dy(abs:89|rel:25)
; node # 16 D(25,78)->(42,67)
       fcb 2 ; drawmode 
       fdb 0,5632 ; starx/y relative to previous node
       fdb 51,-26 ; dx/dy. dx(abs:217|rel:-26) dy(abs:140|rel:51)
; node # 17 D(26,81)->(42,67)
       fcb 2 ; drawmode 
       fdb -768,256 ; starx/y relative to previous node
       fdb 39,-13 ; dx/dy. dx(abs:204|rel:-13) dy(abs:179|rel:39)
; node # 18 D(3,82)->(22,71)
       fcb 2 ; drawmode 
       fdb -256,-5888 ; starx/y relative to previous node
       fdb -39,39 ; dx/dy. dx(abs:243|rel:39) dy(abs:140|rel:-39)
; node # 19 D(3,78)->(22,71)
       fcb 2 ; drawmode 
       fdb 1024,0 ; starx/y relative to previous node
       fdb -51,0 ; dx/dy. dx(abs:243|rel:0) dy(abs:89|rel:-51)
; node # 20 M(0,76)->(18,72)
       fcb 0 ; drawmode 
       fdb 512,-768 ; starx/y relative to previous node
       fdb -38,-13 ; dx/dy. dx(abs:230|rel:-13) dy(abs:51|rel:-38)
; node # 21 D(0,42)->(12,41)
       fcb 2 ; drawmode 
       fdb 8704,0 ; starx/y relative to previous node
       fdb -39,-77 ; dx/dy. dx(abs:153|rel:-77) dy(abs:12|rel:-39)
; node # 22 D(15,-44)->(3,-40)
       fcb 2 ; drawmode 
       fdb 22016,3840 ; starx/y relative to previous node
       fdb -63,-306 ; dx/dy. dx(abs:-153|rel:-306) dy(abs:-51|rel:-63)
; node # 23 M(0,-66)->(-12,-53)
       fcb 0 ; drawmode 
       fdb 5632,-3840 ; starx/y relative to previous node
       fdb -115,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:-166|rel:-115)
; node # 24 D(0,-44)->(-9,-36)
       fcb 2 ; drawmode 
       fdb -5632,0 ; starx/y relative to previous node
       fdb 64,38 ; dx/dy. dx(abs:-115|rel:38) dy(abs:-102|rel:64)
; node # 25 M(-15,-44)->(-21,-33)
       fcb 0 ; drawmode 
       fdb 0,-3840 ; starx/y relative to previous node
       fdb -38,39 ; dx/dy. dx(abs:-76|rel:39) dy(abs:-140|rel:-38)
; node # 26 D(0,42)->(12,41)
       fcb 2 ; drawmode 
       fdb -22016,3840 ; starx/y relative to previous node
       fdb 152,229 ; dx/dy. dx(abs:153|rel:229) dy(abs:12|rel:152)
; node # 27 D(-49,77)->(-25,81)
       fcb 2 ; drawmode 
       fdb -8960,-12544 ; starx/y relative to previous node
       fdb -63,154 ; dx/dy. dx(abs:307|rel:154) dy(abs:-51|rel:-63)
; node # 28 D(-15,-44)->(-21,-33)
       fcb 2 ; drawmode 
       fdb 30976,8704 ; starx/y relative to previous node
       fdb -89,-383 ; dx/dy. dx(abs:-76|rel:-383) dy(abs:-140|rel:-89)
; node # 29 D(-15,83)->(-4,77)
       fcb 2 ; drawmode 
       fdb -32512,0 ; starx/y relative to previous node
       fdb 216,216 ; dx/dy. dx(abs:140|rel:216) dy(abs:76|rel:216)
; node # 30 D(15,83)->(24,71)
       fcb 2 ; drawmode 
       fdb 0,7680 ; starx/y relative to previous node
       fdb 77,-25 ; dx/dy. dx(abs:115|rel:-25) dy(abs:153|rel:77)
; node # 31 D(15,-44)->(3,-40)
       fcb 2 ; drawmode 
       fdb 32512,0 ; starx/y relative to previous node
       fdb -204,-268 ; dx/dy. dx(abs:-153|rel:-268) dy(abs:-51|rel:-204)
; node # 32 D(49,78)->(63,62)
       fcb 2 ; drawmode 
       fdb -31232,8704 ; starx/y relative to previous node
       fdb 255,332 ; dx/dy. dx(abs:179|rel:332) dy(abs:204|rel:255)
; node # 33 D(0,42)->(12,41)
       fcb 2 ; drawmode 
       fdb 9216,-12544 ; starx/y relative to previous node
       fdb -192,-26 ; dx/dy. dx(abs:153|rel:-26) dy(abs:12|rel:-192)
; node # 34 M(-15,83)->(-4,77)
       fcb 0 ; drawmode 
       fdb -10496,-3840 ; starx/y relative to previous node
       fdb 64,-13 ; dx/dy. dx(abs:140|rel:-13) dy(abs:76|rel:64)
; node # 35 D(-74,80)->(-48,86)
       fcb 2 ; drawmode 
       fdb 768,-15104 ; starx/y relative to previous node
       fdb -152,192 ; dx/dy. dx(abs:332|rel:192) dy(abs:-76|rel:-152)
; node # 36 M(-67,44)->(-48,53)
       fcb 0 ; drawmode 
       fdb 9216,1792 ; starx/y relative to previous node
       fdb -39,-89 ; dx/dy. dx(abs:243|rel:-89) dy(abs:-115|rel:-39)
; node # 37 D(-49,77)->(-25,81)
       fcb 2 ; drawmode 
       fdb -8448,4608 ; starx/y relative to previous node
       fdb 64,64 ; dx/dy. dx(abs:307|rel:64) dy(abs:-51|rel:64)
; node # 38 M(-57,79)->(-30,82)
       fcb 0 ; drawmode 
       fdb -512,-2048 ; starx/y relative to previous node
       fdb 13,38 ; dx/dy. dx(abs:345|rel:38) dy(abs:-38|rel:13)
; node # 39 D(-58,80)->(-30,82)
       fcb 2 ; drawmode 
       fdb -256,-256 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:358|rel:13) dy(abs:-25|rel:13)
; node # 40 D(-69,80)->(-44,85)
       fcb 2 ; drawmode 
       fdb 0,-2816 ; starx/y relative to previous node
       fdb -39,-38 ; dx/dy. dx(abs:320|rel:-38) dy(abs:-64|rel:-39)
; node # 41 D(-57,79)->(-30,82)
       fcb 2 ; drawmode 
       fdb 256,3072 ; starx/y relative to previous node
       fdb 26,25 ; dx/dy. dx(abs:345|rel:25) dy(abs:-38|rel:26)
; node # 42 M(15,83)->(24,71)
       fcb 0 ; drawmode 
       fdb -1024,18432 ; starx/y relative to previous node
       fdb 191,-230 ; dx/dy. dx(abs:115|rel:-230) dy(abs:153|rel:191)
; node # 43 D(74,80)->(81,58)
       fcb 2 ; drawmode 
       fdb 768,15104 ; starx/y relative to previous node
       fdb 128,-26 ; dx/dy. dx(abs:89|rel:-26) dy(abs:281|rel:128)
; node # 44 M(67,44)->(67,25)
       fcb 0 ; drawmode 
       fdb 9216,-1792 ; starx/y relative to previous node
       fdb -38,-89 ; dx/dy. dx(abs:0|rel:-89) dy(abs:243|rel:-38)
; node # 45 D(49,78)->(63,62)
       fcb 2 ; drawmode 
       fdb -8704,-4608 ; starx/y relative to previous node
       fdb -39,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:204|rel:-39)
; node # 46 M(57,79)->(68,61)
       fcb 0 ; drawmode 
       fdb -256,2048 ; starx/y relative to previous node
       fdb 26,-39 ; dx/dy. dx(abs:140|rel:-39) dy(abs:230|rel:26)
; node # 47 D(69,80)->(78,59)
       fcb 2 ; drawmode 
       fdb -256,3072 ; starx/y relative to previous node
       fdb 38,-25 ; dx/dy. dx(abs:115|rel:-25) dy(abs:268|rel:38)
; node # 48 D(58,81)->(68,61)
       fcb 2 ; drawmode 
       fdb -256,-2816 ; starx/y relative to previous node
       fdb -12,13 ; dx/dy. dx(abs:128|rel:13) dy(abs:256|rel:-12)
; node # 49 D(57,79)->(68,61)
       fcb 2 ; drawmode 
       fdb 512,-256 ; starx/y relative to previous node
       fdb -26,12 ; dx/dy. dx(abs:140|rel:12) dy(abs:230|rel:-26)
       fcb  1  ; end of anim
; Animation 1
eliteframe1:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(18,72)->(33,69)
       fcb 0 ; drawmode 
       fdb -18432,4608 ; starx/y relative to previous node
       fdb 38,192 ; dx/dy. dx(abs:192|rel:192) dy(abs:38|rel:38)
; node # 1 D(-25,81)->(-7,89)
       fcb 2 ; drawmode 
       fdb -2304,-11008 ; starx/y relative to previous node
       fdb -140,38 ; dx/dy. dx(abs:230|rel:38) dy(abs:-102|rel:-140)
; node # 2 D(-48,86)->(-29,96)
       fcb 2 ; drawmode 
       fdb -1280,-5888 ; starx/y relative to previous node
       fdb -26,13 ; dx/dy. dx(abs:243|rel:13) dy(abs:-128|rel:-26)
; node # 3 D(-48,53)->(-34,65)
       fcb 2 ; drawmode 
       fdb 8448,0 ; starx/y relative to previous node
       fdb -25,-64 ; dx/dy. dx(abs:179|rel:-64) dy(abs:-153|rel:-25)
; node # 4 D(-21,-33)->(-22,-23)
       fcb 2 ; drawmode 
       fdb 22016,6912 ; starx/y relative to previous node
       fdb 25,-191 ; dx/dy. dx(abs:-12|rel:-191) dy(abs:-128|rel:25)
; node # 5 D(3,-40)->(-4,-37)
       fcb 2 ; drawmode 
       fdb 1792,6144 ; starx/y relative to previous node
       fdb 90,-77 ; dx/dy. dx(abs:-89|rel:-77) dy(abs:-38|rel:90)
; node # 6 D(67,25)->(62,3)
       fcb 2 ; drawmode 
       fdb -16640,16384 ; starx/y relative to previous node
       fdb 319,25 ; dx/dy. dx(abs:-64|rel:25) dy(abs:281|rel:319)
; node # 7 D(81,58)->(83,32)
       fcb 2 ; drawmode 
       fdb -8448,3584 ; starx/y relative to previous node
       fdb 51,89 ; dx/dy. dx(abs:25|rel:89) dy(abs:332|rel:51)
; node # 8 D(63,62)->(71,45)
       fcb 2 ; drawmode 
       fdb -1024,-4608 ; starx/y relative to previous node
       fdb -115,77 ; dx/dy. dx(abs:102|rel:77) dy(abs:217|rel:-115)
; node # 9 D(18,72)->(33,69)
       fcb 2 ; drawmode 
       fdb -2560,-11520 ; starx/y relative to previous node
       fdb -179,90 ; dx/dy. dx(abs:192|rel:90) dy(abs:38|rel:-179)
; node # 10 M(13,73)->(26,70)
       fcb 0 ; drawmode 
       fdb -256,-1280 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:166|rel:-26) dy(abs:38|rel:0)
; node # 11 D(-10,78)->(9,79)
       fcb 2 ; drawmode 
       fdb -1280,-5888 ; starx/y relative to previous node
       fdb -50,77 ; dx/dy. dx(abs:243|rel:77) dy(abs:-12|rel:-50)
; node # 12 D(-10,78)->(0,78)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 12,-115 ; dx/dy. dx(abs:128|rel:-115) dy(abs:0|rel:12)
; node # 13 D(13,73)->(14,68)
       fcb 2 ; drawmode 
       fdb 1280,5888 ; starx/y relative to previous node
       fdb 64,-116 ; dx/dy. dx(abs:12|rel:-116) dy(abs:64|rel:64)
; node # 14 D(13,73)->(26,70)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -26,154 ; dx/dy. dx(abs:166|rel:154) dy(abs:38|rel:-26)
; node # 15 M(22,71)->(32,67)
       fcb 0 ; drawmode 
       fdb 512,2304 ; starx/y relative to previous node
       fdb 13,-38 ; dx/dy. dx(abs:128|rel:-38) dy(abs:51|rel:13)
; node # 16 D(42,67)->(47,57)
       fcb 2 ; drawmode 
       fdb 1024,5120 ; starx/y relative to previous node
       fdb 77,-64 ; dx/dy. dx(abs:64|rel:-64) dy(abs:128|rel:77)
; node # 17 D(42,67)->(39,55)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 25,-102 ; dx/dy. dx(abs:-38|rel:-102) dy(abs:153|rel:25)
; node # 18 D(22,71)->(20,65)
       fcb 2 ; drawmode 
       fdb -1024,-5120 ; starx/y relative to previous node
       fdb -77,13 ; dx/dy. dx(abs:-25|rel:13) dy(abs:76|rel:-77)
; node # 19 D(22,71)->(32,67)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -25,153 ; dx/dy. dx(abs:128|rel:153) dy(abs:51|rel:-25)
; node # 20 M(18,72)->(33,69)
       fcb 0 ; drawmode 
       fdb -256,-1024 ; starx/y relative to previous node
       fdb -13,64 ; dx/dy. dx(abs:192|rel:64) dy(abs:38|rel:-13)
; node # 21 D(12,41)->(22,40)
       fcb 2 ; drawmode 
       fdb 7936,-1536 ; starx/y relative to previous node
       fdb -26,-64 ; dx/dy. dx(abs:128|rel:-64) dy(abs:12|rel:-26)
; node # 22 D(3,-40)->(-4,-37)
       fcb 2 ; drawmode 
       fdb 20736,-2304 ; starx/y relative to previous node
       fdb -50,-217 ; dx/dy. dx(abs:-89|rel:-217) dy(abs:-38|rel:-50)
; node # 23 M(-12,-53)->(-18,-43)
       fcb 0 ; drawmode 
       fdb 3328,-3840 ; starx/y relative to previous node
       fdb -90,13 ; dx/dy. dx(abs:-76|rel:13) dy(abs:-128|rel:-90)
; node # 24 D(-9,-36)->(-13,-29)
       fcb 2 ; drawmode 
       fdb -4352,768 ; starx/y relative to previous node
       fdb 39,25 ; dx/dy. dx(abs:-51|rel:25) dy(abs:-89|rel:39)
; node # 25 M(-21,-33)->(-22,-23)
       fcb 0 ; drawmode 
       fdb -768,-3072 ; starx/y relative to previous node
       fdb -39,39 ; dx/dy. dx(abs:-12|rel:39) dy(abs:-128|rel:-39)
; node # 26 D(12,41)->(22,40)
       fcb 2 ; drawmode 
       fdb -18944,8448 ; starx/y relative to previous node
       fdb 140,140 ; dx/dy. dx(abs:128|rel:140) dy(abs:12|rel:140)
; node # 27 D(-25,81)->(-7,89)
       fcb 2 ; drawmode 
       fdb -10240,-9472 ; starx/y relative to previous node
       fdb -114,102 ; dx/dy. dx(abs:230|rel:102) dy(abs:-102|rel:-114)
; node # 28 D(-21,-33)->(-22,-23)
       fcb 2 ; drawmode 
       fdb 29184,1024 ; starx/y relative to previous node
       fdb -26,-242 ; dx/dy. dx(abs:-12|rel:-242) dy(abs:-128|rel:-26)
; node # 29 D(-4,77)->(2,73)
       fcb 2 ; drawmode 
       fdb -28160,4352 ; starx/y relative to previous node
       fdb 179,88 ; dx/dy. dx(abs:76|rel:88) dy(abs:51|rel:179)
; node # 30 D(24,71)->(25,59)
       fcb 2 ; drawmode 
       fdb 1536,7168 ; starx/y relative to previous node
       fdb 102,-64 ; dx/dy. dx(abs:12|rel:-64) dy(abs:153|rel:102)
; node # 31 D(3,-40)->(-4,-37)
       fcb 2 ; drawmode 
       fdb 28416,-5376 ; starx/y relative to previous node
       fdb -191,-101 ; dx/dy. dx(abs:-89|rel:-101) dy(abs:-38|rel:-191)
; node # 32 D(63,62)->(71,45)
       fcb 2 ; drawmode 
       fdb -26112,15360 ; starx/y relative to previous node
       fdb 255,191 ; dx/dy. dx(abs:102|rel:191) dy(abs:217|rel:255)
; node # 33 D(12,41)->(22,40)
       fcb 2 ; drawmode 
       fdb 5376,-13056 ; starx/y relative to previous node
       fdb -205,26 ; dx/dy. dx(abs:128|rel:26) dy(abs:12|rel:-205)
; node # 34 M(-4,77)->(2,73)
       fcb 0 ; drawmode 
       fdb -9216,-4096 ; starx/y relative to previous node
       fdb 39,-52 ; dx/dy. dx(abs:76|rel:-52) dy(abs:51|rel:39)
; node # 35 D(-48,86)->(-29,96)
       fcb 2 ; drawmode 
       fdb -2304,-11264 ; starx/y relative to previous node
       fdb -179,167 ; dx/dy. dx(abs:243|rel:167) dy(abs:-128|rel:-179)
; node # 36 M(-48,53)->(-34,65)
       fcb 0 ; drawmode 
       fdb 8448,0 ; starx/y relative to previous node
       fdb -25,-64 ; dx/dy. dx(abs:179|rel:-64) dy(abs:-153|rel:-25)
; node # 37 D(-25,81)->(-7,89)
       fcb 2 ; drawmode 
       fdb -7168,5888 ; starx/y relative to previous node
       fdb 51,51 ; dx/dy. dx(abs:230|rel:51) dy(abs:-102|rel:51)
; node # 38 M(-30,82)->(-20,91)
       fcb 0 ; drawmode 
       fdb -256,-1280 ; starx/y relative to previous node
       fdb -13,-102 ; dx/dy. dx(abs:128|rel:-102) dy(abs:-115|rel:-13)
; node # 39 D(-30,82)->(-15,90)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 13,64 ; dx/dy. dx(abs:192|rel:64) dy(abs:-102|rel:13)
; node # 40 D(-44,85)->(-25,94)
       fcb 2 ; drawmode 
       fdb -768,-3584 ; starx/y relative to previous node
       fdb -13,51 ; dx/dy. dx(abs:243|rel:51) dy(abs:-115|rel:-13)
; node # 41 D(-30,82)->(-20,91)
       fcb 2 ; drawmode 
       fdb 768,3584 ; starx/y relative to previous node
       fdb 0,-115 ; dx/dy. dx(abs:128|rel:-115) dy(abs:-115|rel:0)
; node # 42 M(24,71)->(25,59)
       fcb 0 ; drawmode 
       fdb 2816,13824 ; starx/y relative to previous node
       fdb 268,-116 ; dx/dy. dx(abs:12|rel:-116) dy(abs:153|rel:268)
; node # 43 D(81,58)->(83,32)
       fcb 2 ; drawmode 
       fdb 3328,14592 ; starx/y relative to previous node
       fdb 179,13 ; dx/dy. dx(abs:25|rel:13) dy(abs:332|rel:179)
; node # 44 M(67,25)->(62,3)
       fcb 0 ; drawmode 
       fdb 8448,-3584 ; starx/y relative to previous node
       fdb -51,-89 ; dx/dy. dx(abs:-64|rel:-89) dy(abs:281|rel:-51)
; node # 45 D(63,62)->(71,45)
       fcb 2 ; drawmode 
       fdb -9472,-1024 ; starx/y relative to previous node
       fdb -64,166 ; dx/dy. dx(abs:102|rel:166) dy(abs:217|rel:-64)
; node # 46 M(68,61)->(70,40)
       fcb 0 ; drawmode 
       fdb 256,1280 ; starx/y relative to previous node
       fdb 51,-77 ; dx/dy. dx(abs:25|rel:-77) dy(abs:268|rel:51)
; node # 47 D(78,59)->(77,36)
       fcb 2 ; drawmode 
       fdb 512,2560 ; starx/y relative to previous node
       fdb 26,-37 ; dx/dy. dx(abs:-12|rel:-37) dy(abs:294|rel:26)
; node # 48 D(68,61)->(73,42)
       fcb 2 ; drawmode 
       fdb -512,-2560 ; starx/y relative to previous node
       fdb -51,76 ; dx/dy. dx(abs:64|rel:76) dy(abs:243|rel:-51)
; node # 49 D(68,61)->(70,40)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 25,-39 ; dx/dy. dx(abs:25|rel:-39) dy(abs:268|rel:25)
       fcb  1  ; end of anim
; Animation 2
eliteframe2:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(33,69)->(40,59)
       fcb 0 ; drawmode 
       fdb -17664,8448 ; starx/y relative to previous node
       fdb 128,89 ; dx/dy. dx(abs:89|rel:89) dy(abs:128|rel:128)
; node # 1 D(-7,89)->(9,91)
       fcb 2 ; drawmode 
       fdb -5120,-10240 ; starx/y relative to previous node
       fdb -153,115 ; dx/dy. dx(abs:204|rel:115) dy(abs:-25|rel:-153)
; node # 2 D(-29,96)->(-12,103)
       fcb 2 ; drawmode 
       fdb -1792,-5632 ; starx/y relative to previous node
       fdb -64,13 ; dx/dy. dx(abs:217|rel:13) dy(abs:-89|rel:-64)
; node # 3 D(-34,65)->(-18,72)
       fcb 2 ; drawmode 
       fdb 7936,-1280 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:204|rel:-13) dy(abs:-89|rel:0)
; node # 4 D(-22,-23)->(-19,-11)
       fcb 2 ; drawmode 
       fdb 22528,3072 ; starx/y relative to previous node
       fdb -64,-166 ; dx/dy. dx(abs:38|rel:-166) dy(abs:-153|rel:-64)
; node # 5 D(-4,-37)->(-8,-31)
       fcb 2 ; drawmode 
       fdb 3584,4608 ; starx/y relative to previous node
       fdb 77,-89 ; dx/dy. dx(abs:-51|rel:-89) dy(abs:-76|rel:77)
; node # 6 D(62,3)->(43,-20)
       fcb 2 ; drawmode 
       fdb -10240,16896 ; starx/y relative to previous node
       fdb 370,-192 ; dx/dy. dx(abs:-243|rel:-192) dy(abs:294|rel:370)
; node # 7 D(83,32)->(64,-1)
       fcb 2 ; drawmode 
       fdb -7424,5376 ; starx/y relative to previous node
       fdb 128,0 ; dx/dy. dx(abs:-243|rel:0) dy(abs:422|rel:128)
; node # 8 D(71,45)->(63,20)
       fcb 2 ; drawmode 
       fdb -3328,-3072 ; starx/y relative to previous node
       fdb -102,141 ; dx/dy. dx(abs:-102|rel:141) dy(abs:320|rel:-102)
; node # 9 D(33,69)->(40,59)
       fcb 2 ; drawmode 
       fdb -6144,-9728 ; starx/y relative to previous node
       fdb -192,191 ; dx/dy. dx(abs:89|rel:191) dy(abs:128|rel:-192)
; node # 10 M(26,70)->(32,60)
       fcb 0 ; drawmode 
       fdb -256,-1792 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:76|rel:-13) dy(abs:128|rel:0)
; node # 11 D(9,79)->(19,74)
       fcb 2 ; drawmode 
       fdb -2304,-4352 ; starx/y relative to previous node
       fdb -64,52 ; dx/dy. dx(abs:128|rel:52) dy(abs:64|rel:-64)
; node # 12 D(0,78)->(5,74)
       fcb 2 ; drawmode 
       fdb 256,-2304 ; starx/y relative to previous node
       fdb -13,-64 ; dx/dy. dx(abs:64|rel:-64) dy(abs:51|rel:-13)
; node # 13 D(14,68)->(13,58)
       fcb 2 ; drawmode 
       fdb 2560,3584 ; starx/y relative to previous node
       fdb 77,-76 ; dx/dy. dx(abs:-12|rel:-76) dy(abs:128|rel:77)
; node # 14 D(26,70)->(32,60)
       fcb 2 ; drawmode 
       fdb -512,3072 ; starx/y relative to previous node
       fdb 0,88 ; dx/dy. dx(abs:76|rel:88) dy(abs:128|rel:0)
; node # 15 M(32,67)->(36,55)
       fcb 0 ; drawmode 
       fdb 768,1536 ; starx/y relative to previous node
       fdb 25,-25 ; dx/dy. dx(abs:51|rel:-25) dy(abs:153|rel:25)
; node # 16 D(47,57)->(45,39)
       fcb 2 ; drawmode 
       fdb 2560,3840 ; starx/y relative to previous node
       fdb 77,-76 ; dx/dy. dx(abs:-25|rel:-76) dy(abs:230|rel:77)
; node # 17 D(39,55)->(32,37)
       fcb 2 ; drawmode 
       fdb 512,-2048 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:-89|rel:-64) dy(abs:230|rel:0)
; node # 18 D(20,65)->(17,53)
       fcb 2 ; drawmode 
       fdb -2560,-4864 ; starx/y relative to previous node
       fdb -77,51 ; dx/dy. dx(abs:-38|rel:51) dy(abs:153|rel:-77)
; node # 19 D(32,67)->(36,55)
       fcb 2 ; drawmode 
       fdb -512,3072 ; starx/y relative to previous node
       fdb 0,89 ; dx/dy. dx(abs:51|rel:89) dy(abs:153|rel:0)
; node # 20 M(33,69)->(40,59)
       fcb 0 ; drawmode 
       fdb -512,256 ; starx/y relative to previous node
       fdb -25,38 ; dx/dy. dx(abs:89|rel:38) dy(abs:128|rel:-25)
; node # 21 D(22,40)->(27,33)
       fcb 2 ; drawmode 
       fdb 7424,-2816 ; starx/y relative to previous node
       fdb -39,-25 ; dx/dy. dx(abs:64|rel:-25) dy(abs:89|rel:-39)
; node # 22 D(-4,-37)->(-8,-31)
       fcb 2 ; drawmode 
       fdb 19712,-6656 ; starx/y relative to previous node
       fdb -165,-115 ; dx/dy. dx(abs:-51|rel:-115) dy(abs:-76|rel:-165)
; node # 23 M(-18,-43)->(-19,-30)
       fcb 0 ; drawmode 
       fdb 1536,-3584 ; starx/y relative to previous node
       fdb -90,39 ; dx/dy. dx(abs:-12|rel:39) dy(abs:-166|rel:-90)
; node # 24 D(-13,-29)->(-13,-20)
       fcb 2 ; drawmode 
       fdb -3584,1280 ; starx/y relative to previous node
       fdb 51,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-115|rel:51)
; node # 25 M(-22,-23)->(-19,-11)
       fcb 0 ; drawmode 
       fdb -1536,-2304 ; starx/y relative to previous node
       fdb -38,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:-153|rel:-38)
; node # 26 D(22,40)->(27,33)
       fcb 2 ; drawmode 
       fdb -16128,11264 ; starx/y relative to previous node
       fdb 242,26 ; dx/dy. dx(abs:64|rel:26) dy(abs:89|rel:242)
; node # 27 D(-7,89)->(9,91)
       fcb 2 ; drawmode 
       fdb -12544,-7424 ; starx/y relative to previous node
       fdb -114,140 ; dx/dy. dx(abs:204|rel:140) dy(abs:-25|rel:-114)
; node # 28 D(-22,-23)->(-19,-11)
       fcb 2 ; drawmode 
       fdb 28672,-3840 ; starx/y relative to previous node
       fdb -128,-166 ; dx/dy. dx(abs:38|rel:-166) dy(abs:-153|rel:-128)
; node # 29 D(2,73)->(2,65)
       fcb 2 ; drawmode 
       fdb -24576,6144 ; starx/y relative to previous node
       fdb 255,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:102|rel:255)
; node # 30 D(25,59)->(17,44)
       fcb 2 ; drawmode 
       fdb 3584,5888 ; starx/y relative to previous node
       fdb 90,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:192|rel:90)
; node # 31 D(-4,-37)->(-8,-31)
       fcb 2 ; drawmode 
       fdb 24576,-7424 ; starx/y relative to previous node
       fdb -268,51 ; dx/dy. dx(abs:-51|rel:51) dy(abs:-76|rel:-268)
; node # 32 D(71,45)->(63,20)
       fcb 2 ; drawmode 
       fdb -20992,19200 ; starx/y relative to previous node
       fdb 396,-51 ; dx/dy. dx(abs:-102|rel:-51) dy(abs:320|rel:396)
; node # 33 D(22,40)->(27,33)
       fcb 2 ; drawmode 
       fdb 1280,-12544 ; starx/y relative to previous node
       fdb -231,166 ; dx/dy. dx(abs:64|rel:166) dy(abs:89|rel:-231)
; node # 34 M(2,73)->(2,65)
       fcb 0 ; drawmode 
       fdb -8448,-5120 ; starx/y relative to previous node
       fdb 13,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:102|rel:13)
; node # 35 D(-29,96)->(-12,103)
       fcb 2 ; drawmode 
       fdb -5888,-7936 ; starx/y relative to previous node
       fdb -191,217 ; dx/dy. dx(abs:217|rel:217) dy(abs:-89|rel:-191)
; node # 36 M(-34,65)->(-18,72)
       fcb 0 ; drawmode 
       fdb 7936,-1280 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:204|rel:-13) dy(abs:-89|rel:0)
; node # 37 D(-7,89)->(9,91)
       fcb 2 ; drawmode 
       fdb -6144,6912 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:-25|rel:64)
; node # 38 M(-20,91)->(-7,94)
       fcb 0 ; drawmode 
       fdb -512,-3328 ; starx/y relative to previous node
       fdb -13,-38 ; dx/dy. dx(abs:166|rel:-38) dy(abs:-38|rel:-13)
; node # 39 D(-15,90)->(0,95)
       fcb 2 ; drawmode 
       fdb 256,1280 ; starx/y relative to previous node
       fdb -26,26 ; dx/dy. dx(abs:192|rel:26) dy(abs:-64|rel:-26)
; node # 40 D(-25,94)->(-9,99)
       fcb 2 ; drawmode 
       fdb -1024,-2560 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:204|rel:12) dy(abs:-64|rel:0)
; node # 41 D(-20,91)->(-7,94)
       fcb 2 ; drawmode 
       fdb 768,1280 ; starx/y relative to previous node
       fdb 26,-38 ; dx/dy. dx(abs:166|rel:-38) dy(abs:-38|rel:26)
; node # 42 M(25,59)->(17,44)
       fcb 0 ; drawmode 
       fdb 8192,11520 ; starx/y relative to previous node
       fdb 230,-268 ; dx/dy. dx(abs:-102|rel:-268) dy(abs:192|rel:230)
; node # 43 D(83,32)->(64,-1)
       fcb 2 ; drawmode 
       fdb 6912,14848 ; starx/y relative to previous node
       fdb 230,-141 ; dx/dy. dx(abs:-243|rel:-141) dy(abs:422|rel:230)
; node # 44 M(62,3)->(43,-20)
       fcb 0 ; drawmode 
       fdb 7424,-5376 ; starx/y relative to previous node
       fdb -128,0 ; dx/dy. dx(abs:-243|rel:0) dy(abs:294|rel:-128)
; node # 45 D(71,45)->(63,20)
       fcb 2 ; drawmode 
       fdb -10752,2304 ; starx/y relative to previous node
       fdb 26,141 ; dx/dy. dx(abs:-102|rel:141) dy(abs:320|rel:26)
; node # 46 M(70,40)->(54,11)
       fcb 0 ; drawmode 
       fdb 1280,-256 ; starx/y relative to previous node
       fdb 51,-102 ; dx/dy. dx(abs:-204|rel:-102) dy(abs:371|rel:51)
; node # 47 D(77,36)->(60,5)
       fcb 2 ; drawmode 
       fdb 1024,1792 ; starx/y relative to previous node
       fdb 25,-13 ; dx/dy. dx(abs:-217|rel:-13) dy(abs:396|rel:25)
; node # 48 D(73,42)->(61,13)
       fcb 2 ; drawmode 
       fdb -1536,-1024 ; starx/y relative to previous node
       fdb -25,64 ; dx/dy. dx(abs:-153|rel:64) dy(abs:371|rel:-25)
; node # 49 D(70,40)->(54,11)
       fcb 2 ; drawmode 
       fdb 512,-768 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-204|rel:-51) dy(abs:371|rel:0)
       fcb  1  ; end of anim
; Animation 3
eliteframe3:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(40,59)->(36,41)
       fcb 0 ; drawmode 
       fdb -15104,10240 ; starx/y relative to previous node
       fdb 230,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:230|rel:230)
; node # 1 D(9,91)->(19,87)
       fcb 2 ; drawmode 
       fdb -8192,-7936 ; starx/y relative to previous node
       fdb -179,179 ; dx/dy. dx(abs:128|rel:179) dy(abs:51|rel:-179)
; node # 2 D(-12,103)->(2,103)
       fcb 2 ; drawmode 
       fdb -3072,-5376 ; starx/y relative to previous node
       fdb -51,51 ; dx/dy. dx(abs:179|rel:51) dy(abs:0|rel:-51)
; node # 3 D(-18,72)->(-4,77)
       fcb 2 ; drawmode 
       fdb 7936,-1536 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:179|rel:0) dy(abs:-64|rel:-64)
; node # 4 D(-19,-11)->(-12,-1)
       fcb 2 ; drawmode 
       fdb 21248,-256 ; starx/y relative to previous node
       fdb -64,-90 ; dx/dy. dx(abs:89|rel:-90) dy(abs:-128|rel:-64)
; node # 5 D(-8,-31)->(-9,-22)
       fcb 2 ; drawmode 
       fdb 5120,2816 ; starx/y relative to previous node
       fdb 13,-101 ; dx/dy. dx(abs:-12|rel:-101) dy(abs:-115|rel:13)
; node # 6 D(43,-20)->(15,-40)
       fcb 2 ; drawmode 
       fdb -2816,13056 ; starx/y relative to previous node
       fdb 371,-346 ; dx/dy. dx(abs:-358|rel:-346) dy(abs:256|rel:371)
; node # 7 D(64,-1)->(27,-34)
       fcb 2 ; drawmode 
       fdb -4864,5376 ; starx/y relative to previous node
       fdb 166,-115 ; dx/dy. dx(abs:-473|rel:-115) dy(abs:422|rel:166)
; node # 8 D(63,20)->(39,-9)
       fcb 2 ; drawmode 
       fdb -5376,-256 ; starx/y relative to previous node
       fdb -51,166 ; dx/dy. dx(abs:-307|rel:166) dy(abs:371|rel:-51)
; node # 9 D(40,59)->(36,42)
       fcb 2 ; drawmode 
       fdb -9984,-5888 ; starx/y relative to previous node
       fdb -154,256 ; dx/dy. dx(abs:-51|rel:256) dy(abs:217|rel:-154)
; node # 10 M(32,60)->(28,46)
       fcb 0 ; drawmode 
       fdb -256,-2048 ; starx/y relative to previous node
       fdb -38,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:179|rel:-38)
; node # 11 D(19,74)->(22,65)
       fcb 2 ; drawmode 
       fdb -3584,-3328 ; starx/y relative to previous node
       fdb -64,89 ; dx/dy. dx(abs:38|rel:89) dy(abs:115|rel:-64)
; node # 12 D(5,74)->(5,65)
       fcb 2 ; drawmode 
       fdb 0,-3584 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:0|rel:-38) dy(abs:115|rel:0)
; node # 13 D(13,58)->(4,45)
       fcb 2 ; drawmode 
       fdb 4096,2048 ; starx/y relative to previous node
       fdb 51,-115 ; dx/dy. dx(abs:-115|rel:-115) dy(abs:166|rel:51)
; node # 14 D(32,60)->(28,46)
       fcb 2 ; drawmode 
       fdb -512,4864 ; starx/y relative to previous node
       fdb 13,64 ; dx/dy. dx(abs:-51|rel:64) dy(abs:179|rel:13)
; node # 15 M(36,55)->(30,38)
       fcb 0 ; drawmode 
       fdb 1280,1024 ; starx/y relative to previous node
       fdb 38,-25 ; dx/dy. dx(abs:-76|rel:-25) dy(abs:217|rel:38)
; node # 16 D(45,39)->(30,17)
       fcb 2 ; drawmode 
       fdb 4096,2304 ; starx/y relative to previous node
       fdb 64,-116 ; dx/dy. dx(abs:-192|rel:-116) dy(abs:281|rel:64)
; node # 17 D(32,37)->(13,16)
       fcb 2 ; drawmode 
       fdb 512,-3328 ; starx/y relative to previous node
       fdb -13,-51 ; dx/dy. dx(abs:-243|rel:-51) dy(abs:268|rel:-13)
; node # 18 D(17,53)->(6,38)
       fcb 2 ; drawmode 
       fdb -4096,-3840 ; starx/y relative to previous node
       fdb -76,103 ; dx/dy. dx(abs:-140|rel:103) dy(abs:192|rel:-76)
; node # 19 D(36,55)->(30,38)
       fcb 2 ; drawmode 
       fdb -512,4864 ; starx/y relative to previous node
       fdb 25,64 ; dx/dy. dx(abs:-76|rel:64) dy(abs:217|rel:25)
; node # 20 M(40,59)->(36,41)
       fcb 0 ; drawmode 
       fdb -1024,1024 ; starx/y relative to previous node
       fdb 13,25 ; dx/dy. dx(abs:-51|rel:25) dy(abs:230|rel:13)
; node # 21 D(27,33)->(26,23)
       fcb 2 ; drawmode 
       fdb 6656,-3328 ; starx/y relative to previous node
       fdb -102,39 ; dx/dy. dx(abs:-12|rel:39) dy(abs:128|rel:-102)
; node # 22 D(-8,-31)->(-9,-22)
       fcb 2 ; drawmode 
       fdb 16384,-8960 ; starx/y relative to previous node
       fdb -243,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-115|rel:-243)
; node # 23 M(-19,-30)->(-13,-17)
       fcb 0 ; drawmode 
       fdb -256,-2816 ; starx/y relative to previous node
       fdb -51,88 ; dx/dy. dx(abs:76|rel:88) dy(abs:-166|rel:-51)
; node # 24 D(-13,-20)->(-10,-11)
       fcb 2 ; drawmode 
       fdb -2560,1536 ; starx/y relative to previous node
       fdb 51,-38 ; dx/dy. dx(abs:38|rel:-38) dy(abs:-115|rel:51)
; node # 25 M(-19,-11)->(-12,-1)
       fcb 0 ; drawmode 
       fdb -2304,-1536 ; starx/y relative to previous node
       fdb -13,51 ; dx/dy. dx(abs:89|rel:51) dy(abs:-128|rel:-13)
; node # 26 D(27,33)->(26,23)
       fcb 2 ; drawmode 
       fdb -11264,11776 ; starx/y relative to previous node
       fdb 256,-101 ; dx/dy. dx(abs:-12|rel:-101) dy(abs:128|rel:256)
; node # 27 D(9,91)->(19,87)
       fcb 2 ; drawmode 
       fdb -14848,-4608 ; starx/y relative to previous node
       fdb -77,140 ; dx/dy. dx(abs:128|rel:140) dy(abs:51|rel:-77)
; node # 28 D(-19,-11)->(-12,-1)
       fcb 2 ; drawmode 
       fdb 26112,-7168 ; starx/y relative to previous node
       fdb -179,-39 ; dx/dy. dx(abs:89|rel:-39) dy(abs:-128|rel:-179)
; node # 29 D(2,65)->(-5,55)
       fcb 2 ; drawmode 
       fdb -19456,5376 ; starx/y relative to previous node
       fdb 256,-178 ; dx/dy. dx(abs:-89|rel:-178) dy(abs:128|rel:256)
; node # 30 D(17,44)->(0,26)
       fcb 2 ; drawmode 
       fdb 5376,3840 ; starx/y relative to previous node
       fdb 102,-128 ; dx/dy. dx(abs:-217|rel:-128) dy(abs:230|rel:102)
; node # 31 D(-8,-31)->(-9,-22)
       fcb 2 ; drawmode 
       fdb 19200,-6400 ; starx/y relative to previous node
       fdb -345,205 ; dx/dy. dx(abs:-12|rel:205) dy(abs:-115|rel:-345)
; node # 32 D(63,20)->(39,-9)
       fcb 2 ; drawmode 
       fdb -13056,18176 ; starx/y relative to previous node
       fdb 486,-295 ; dx/dy. dx(abs:-307|rel:-295) dy(abs:371|rel:486)
; node # 33 D(27,33)->(26,23)
       fcb 2 ; drawmode 
       fdb -3328,-9216 ; starx/y relative to previous node
       fdb -243,295 ; dx/dy. dx(abs:-12|rel:295) dy(abs:128|rel:-243)
; node # 34 M(2,65)->(-5,55)
       fcb 0 ; drawmode 
       fdb -8192,-6400 ; starx/y relative to previous node
       fdb 0,-77 ; dx/dy. dx(abs:-89|rel:-77) dy(abs:128|rel:0)
; node # 35 D(-12,103)->(2,103)
       fcb 2 ; drawmode 
       fdb -9728,-3584 ; starx/y relative to previous node
       fdb -128,268 ; dx/dy. dx(abs:179|rel:268) dy(abs:0|rel:-128)
; node # 36 M(-18,72)->(-4,77)
       fcb 0 ; drawmode 
       fdb 7936,-1536 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:179|rel:0) dy(abs:-64|rel:-64)
; node # 37 D(9,91)->(19,87)
       fcb 2 ; drawmode 
       fdb -4864,6912 ; starx/y relative to previous node
       fdb 115,-51 ; dx/dy. dx(abs:128|rel:-51) dy(abs:51|rel:115)
; node # 38 M(-7,94)->(3,92)
       fcb 0 ; drawmode 
       fdb -768,-4096 ; starx/y relative to previous node
       fdb -26,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:25|rel:-26)
; node # 39 D(0,95)->(11,92)
       fcb 2 ; drawmode 
       fdb -256,1792 ; starx/y relative to previous node
       fdb 13,12 ; dx/dy. dx(abs:140|rel:12) dy(abs:38|rel:13)
; node # 40 D(-9,99)->(4,99)
       fcb 2 ; drawmode 
       fdb -1024,-2304 ; starx/y relative to previous node
       fdb -38,26 ; dx/dy. dx(abs:166|rel:26) dy(abs:0|rel:-38)
; node # 41 D(-7,94)->(3,92)
       fcb 2 ; drawmode 
       fdb 1280,512 ; starx/y relative to previous node
       fdb 25,-38 ; dx/dy. dx(abs:128|rel:-38) dy(abs:25|rel:25)
; node # 42 M(17,44)->(0,26)
       fcb 0 ; drawmode 
       fdb 12800,6144 ; starx/y relative to previous node
       fdb 205,-345 ; dx/dy. dx(abs:-217|rel:-345) dy(abs:230|rel:205)
; node # 43 D(64,-1)->(27,-34)
       fcb 2 ; drawmode 
       fdb 11520,12032 ; starx/y relative to previous node
       fdb 192,-256 ; dx/dy. dx(abs:-473|rel:-256) dy(abs:422|rel:192)
; node # 44 M(43,-20)->(15,-40)
       fcb 0 ; drawmode 
       fdb 4864,-5376 ; starx/y relative to previous node
       fdb -166,115 ; dx/dy. dx(abs:-358|rel:115) dy(abs:256|rel:-166)
; node # 45 D(63,20)->(39,-9)
       fcb 2 ; drawmode 
       fdb -10240,5120 ; starx/y relative to previous node
       fdb 115,51 ; dx/dy. dx(abs:-307|rel:51) dy(abs:371|rel:115)
; node # 46 M(54,11)->(23,-17)
       fcb 0 ; drawmode 
       fdb 2304,-2304 ; starx/y relative to previous node
       fdb -13,-89 ; dx/dy. dx(abs:-396|rel:-89) dy(abs:358|rel:-13)
; node # 47 D(60,5)->(26,-26)
       fcb 2 ; drawmode 
       fdb 1536,1536 ; starx/y relative to previous node
       fdb 38,-39 ; dx/dy. dx(abs:-435|rel:-39) dy(abs:396|rel:38)
; node # 48 D(61,13)->(32,-16)
       fcb 2 ; drawmode 
       fdb -2048,256 ; starx/y relative to previous node
       fdb -25,64 ; dx/dy. dx(abs:-371|rel:64) dy(abs:371|rel:-25)
; node # 49 D(54,11)->(23,-17)
       fcb 2 ; drawmode 
       fdb 512,-1792 ; starx/y relative to previous node
       fdb -13,-25 ; dx/dy. dx(abs:-396|rel:-25) dy(abs:358|rel:-13)
       fcb  1  ; end of anim
; Animation 4
eliteframe4:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(36,41)->(21,21)
       fcb 0 ; drawmode 
       fdb -10496,9216 ; starx/y relative to previous node
       fdb 256,-192 ; dx/dy. dx(abs:-192|rel:-192) dy(abs:256|rel:256)
; node # 1 D(19,87)->(22,75)
       fcb 2 ; drawmode 
       fdb -11776,-4352 ; starx/y relative to previous node
       fdb -103,230 ; dx/dy. dx(abs:38|rel:230) dy(abs:153|rel:-103)
; node # 2 D(2,103)->(10,99)
       fcb 2 ; drawmode 
       fdb -4096,-4352 ; starx/y relative to previous node
       fdb -102,64 ; dx/dy. dx(abs:102|rel:64) dy(abs:51|rel:-102)
; node # 3 D(-4,77)->(8,75)
       fcb 2 ; drawmode 
       fdb 6656,-1536 ; starx/y relative to previous node
       fdb -26,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:25|rel:-26)
; node # 4 D(-12,-1)->(-1,9)
       fcb 2 ; drawmode 
       fdb 19968,-2048 ; starx/y relative to previous node
       fdb -153,-13 ; dx/dy. dx(abs:140|rel:-13) dy(abs:-128|rel:-153)
; node # 5 D(-9,-22)->(-5,-14)
       fcb 2 ; drawmode 
       fdb 5376,768 ; starx/y relative to previous node
       fdb 26,-89 ; dx/dy. dx(abs:51|rel:-89) dy(abs:-102|rel:26)
; node # 6 D(15,-40)->(-15,-49)
       fcb 2 ; drawmode 
       fdb 4608,6144 ; starx/y relative to previous node
       fdb 217,-435 ; dx/dy. dx(abs:-384|rel:-435) dy(abs:115|rel:217)
; node # 7 D(27,-34)->(-18,-55)
       fcb 2 ; drawmode 
       fdb -1536,3072 ; starx/y relative to previous node
       fdb 153,-192 ; dx/dy. dx(abs:-576|rel:-192) dy(abs:268|rel:153)
; node # 8 D(39,-9)->(3,-33)
       fcb 2 ; drawmode 
       fdb -6400,3072 ; starx/y relative to previous node
       fdb 39,116 ; dx/dy. dx(abs:-460|rel:116) dy(abs:307|rel:39)
; node # 9 D(36,42)->(21,22)
       fcb 2 ; drawmode 
       fdb -13056,-768 ; starx/y relative to previous node
       fdb -51,268 ; dx/dy. dx(abs:-192|rel:268) dy(abs:256|rel:-51)
; node # 10 M(28,46)->(13,27)
       fcb 0 ; drawmode 
       fdb -1024,-2048 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:243|rel:-13)
; node # 11 D(22,65)->(14,50)
       fcb 2 ; drawmode 
       fdb -4864,-1536 ; starx/y relative to previous node
       fdb -51,90 ; dx/dy. dx(abs:-102|rel:90) dy(abs:192|rel:-51)
; node # 12 D(5,65)->(-3,54)
       fcb 2 ; drawmode 
       fdb 0,-4352 ; starx/y relative to previous node
       fdb -52,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:140|rel:-52)
; node # 13 D(4,45)->(-11,31)
       fcb 2 ; drawmode 
       fdb 5120,-256 ; starx/y relative to previous node
       fdb 39,-90 ; dx/dy. dx(abs:-192|rel:-90) dy(abs:179|rel:39)
; node # 14 D(28,46)->(13,27)
       fcb 2 ; drawmode 
       fdb -256,6144 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:-192|rel:0) dy(abs:243|rel:64)
; node # 15 M(30,38)->(12,20)
       fcb 0 ; drawmode 
       fdb 2048,512 ; starx/y relative to previous node
       fdb -13,-38 ; dx/dy. dx(abs:-230|rel:-38) dy(abs:230|rel:-13)
; node # 16 D(30,17)->(5,-4)
       fcb 2 ; drawmode 
       fdb 5376,0 ; starx/y relative to previous node
       fdb 38,-90 ; dx/dy. dx(abs:-320|rel:-90) dy(abs:268|rel:38)
; node # 17 D(13,16)->(-13,-1)
       fcb 2 ; drawmode 
       fdb 256,-4352 ; starx/y relative to previous node
       fdb -51,-12 ; dx/dy. dx(abs:-332|rel:-12) dy(abs:217|rel:-51)
; node # 18 D(6,38)->(-13,24)
       fcb 2 ; drawmode 
       fdb -5632,-1792 ; starx/y relative to previous node
       fdb -38,89 ; dx/dy. dx(abs:-243|rel:89) dy(abs:179|rel:-38)
; node # 19 D(30,38)->(12,20)
       fcb 2 ; drawmode 
       fdb 0,6144 ; starx/y relative to previous node
       fdb 51,13 ; dx/dy. dx(abs:-230|rel:13) dy(abs:230|rel:51)
; node # 20 M(36,41)->(21,21)
       fcb 0 ; drawmode 
       fdb -768,1536 ; starx/y relative to previous node
       fdb 26,38 ; dx/dy. dx(abs:-192|rel:38) dy(abs:256|rel:26)
; node # 21 D(26,23)->(18,11)
       fcb 2 ; drawmode 
       fdb 4608,-2560 ; starx/y relative to previous node
       fdb -103,90 ; dx/dy. dx(abs:-102|rel:90) dy(abs:153|rel:-103)
; node # 22 D(-9,-22)->(-5,-14)
       fcb 2 ; drawmode 
       fdb 11520,-8960 ; starx/y relative to previous node
       fdb -255,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:-102|rel:-255)
; node # 23 M(-13,-17)->(-2,0)
       fcb 0 ; drawmode 
       fdb -1280,-1024 ; starx/y relative to previous node
       fdb -115,89 ; dx/dy. dx(abs:140|rel:89) dy(abs:-217|rel:-115)
; node # 24 D(-10,-11)->(-2,0)
       fcb 2 ; drawmode 
       fdb -1536,768 ; starx/y relative to previous node
       fdb 77,-38 ; dx/dy. dx(abs:102|rel:-38) dy(abs:-140|rel:77)
; node # 25 M(-12,-1)->(-1,9)
       fcb 0 ; drawmode 
       fdb -2560,-512 ; starx/y relative to previous node
       fdb 12,38 ; dx/dy. dx(abs:140|rel:38) dy(abs:-128|rel:12)
; node # 26 D(26,23)->(18,11)
       fcb 2 ; drawmode 
       fdb -6144,9728 ; starx/y relative to previous node
       fdb 281,-242 ; dx/dy. dx(abs:-102|rel:-242) dy(abs:153|rel:281)
; node # 27 D(19,87)->(22,75)
       fcb 2 ; drawmode 
       fdb -16384,-1792 ; starx/y relative to previous node
       fdb 0,140 ; dx/dy. dx(abs:38|rel:140) dy(abs:153|rel:0)
; node # 28 D(-12,-1)->(-1,9)
       fcb 2 ; drawmode 
       fdb 22528,-7936 ; starx/y relative to previous node
       fdb -281,102 ; dx/dy. dx(abs:140|rel:102) dy(abs:-128|rel:-281)
; node # 29 D(-5,55)->(-16,44)
       fcb 2 ; drawmode 
       fdb -14336,1792 ; starx/y relative to previous node
       fdb 268,-280 ; dx/dy. dx(abs:-140|rel:-280) dy(abs:140|rel:268)
; node # 30 D(0,26)->(-22,13)
       fcb 2 ; drawmode 
       fdb 7424,1280 ; starx/y relative to previous node
       fdb 26,-141 ; dx/dy. dx(abs:-281|rel:-141) dy(abs:166|rel:26)
; node # 31 D(-9,-22)->(-5,-14)
       fcb 2 ; drawmode 
       fdb 12288,-2304 ; starx/y relative to previous node
       fdb -268,332 ; dx/dy. dx(abs:51|rel:332) dy(abs:-102|rel:-268)
; node # 32 D(39,-9)->(3,-33)
       fcb 2 ; drawmode 
       fdb -3328,12288 ; starx/y relative to previous node
       fdb 409,-511 ; dx/dy. dx(abs:-460|rel:-511) dy(abs:307|rel:409)
; node # 33 D(26,23)->(18,11)
       fcb 2 ; drawmode 
       fdb -8192,-3328 ; starx/y relative to previous node
       fdb -154,358 ; dx/dy. dx(abs:-102|rel:358) dy(abs:153|rel:-154)
; node # 34 M(-5,55)->(-16,44)
       fcb 0 ; drawmode 
       fdb -8192,-7936 ; starx/y relative to previous node
       fdb -13,-38 ; dx/dy. dx(abs:-140|rel:-38) dy(abs:140|rel:-13)
; node # 35 D(2,103)->(10,99)
       fcb 2 ; drawmode 
       fdb -12288,1792 ; starx/y relative to previous node
       fdb -89,242 ; dx/dy. dx(abs:102|rel:242) dy(abs:51|rel:-89)
; node # 36 M(-4,77)->(8,75)
       fcb 0 ; drawmode 
       fdb 6656,-1536 ; starx/y relative to previous node
       fdb -26,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:25|rel:-26)
; node # 37 D(19,87)->(22,75)
       fcb 2 ; drawmode 
       fdb -2560,5888 ; starx/y relative to previous node
       fdb 128,-115 ; dx/dy. dx(abs:38|rel:-115) dy(abs:153|rel:128)
; node # 38 M(3,92)->(6,85)
       fcb 0 ; drawmode 
       fdb -1280,-4096 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:38|rel:0) dy(abs:89|rel:-64)
; node # 39 D(11,92)->(15,84)
       fcb 2 ; drawmode 
       fdb 0,2048 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:51|rel:13) dy(abs:102|rel:13)
; node # 40 D(4,99)->(10,92)
       fcb 2 ; drawmode 
       fdb -1792,-1792 ; starx/y relative to previous node
       fdb -13,25 ; dx/dy. dx(abs:76|rel:25) dy(abs:89|rel:-13)
; node # 41 D(3,92)->(6,85)
       fcb 2 ; drawmode 
       fdb 1792,-256 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:38|rel:-38) dy(abs:89|rel:0)
; node # 42 M(0,26)->(-22,13)
       fcb 0 ; drawmode 
       fdb 16896,-768 ; starx/y relative to previous node
       fdb 77,-319 ; dx/dy. dx(abs:-281|rel:-319) dy(abs:166|rel:77)
; node # 43 D(27,-34)->(-18,-55)
       fcb 2 ; drawmode 
       fdb 15360,6912 ; starx/y relative to previous node
       fdb 102,-295 ; dx/dy. dx(abs:-576|rel:-295) dy(abs:268|rel:102)
; node # 44 M(15,-40)->(-15,-49)
       fcb 0 ; drawmode 
       fdb 1536,-3072 ; starx/y relative to previous node
       fdb -153,192 ; dx/dy. dx(abs:-384|rel:192) dy(abs:115|rel:-153)
; node # 45 D(39,-9)->(3,-33)
       fcb 2 ; drawmode 
       fdb -7936,6144 ; starx/y relative to previous node
       fdb 192,-76 ; dx/dy. dx(abs:-460|rel:-76) dy(abs:307|rel:192)
; node # 46 M(23,-17)->(-17,-38)
       fcb 0 ; drawmode 
       fdb 2048,-4096 ; starx/y relative to previous node
       fdb -39,-52 ; dx/dy. dx(abs:-512|rel:-52) dy(abs:268|rel:-39)
; node # 47 D(26,-26)->(-17,-47)
       fcb 2 ; drawmode 
       fdb 2304,768 ; starx/y relative to previous node
       fdb 0,-38 ; dx/dy. dx(abs:-550|rel:-38) dy(abs:268|rel:0)
; node # 48 D(32,-16)->(-7,-40)
       fcb 2 ; drawmode 
       fdb -2560,1536 ; starx/y relative to previous node
       fdb 39,51 ; dx/dy. dx(abs:-499|rel:51) dy(abs:307|rel:39)
; node # 49 D(23,-17)->(-17,-38)
       fcb 2 ; drawmode 
       fdb 256,-2304 ; starx/y relative to previous node
       fdb -39,-13 ; dx/dy. dx(abs:-512|rel:-13) dy(abs:268|rel:-39)
       fcb  1  ; end of anim
; Animation 5
eliteframe5:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(21,21)->(-3,3)
       fcb 0 ; drawmode 
       fdb -5376,5376 ; starx/y relative to previous node
       fdb 230,-307 ; dx/dy. dx(abs:-307|rel:-307) dy(abs:230|rel:230)
; node # 1 D(22,75)->(15,61)
       fcb 2 ; drawmode 
       fdb -13824,256 ; starx/y relative to previous node
       fdb -51,218 ; dx/dy. dx(abs:-89|rel:218) dy(abs:179|rel:-51)
; node # 2 D(10,99)->(9,87)
       fcb 2 ; drawmode 
       fdb -6144,-3072 ; starx/y relative to previous node
       fdb -26,77 ; dx/dy. dx(abs:-12|rel:77) dy(abs:153|rel:-26)
; node # 3 D(8,75)->(15,72)
       fcb 2 ; drawmode 
       fdb 6144,-512 ; starx/y relative to previous node
       fdb -115,101 ; dx/dy. dx(abs:89|rel:101) dy(abs:38|rel:-115)
; node # 4 D(-1,9)->(11,15)
       fcb 2 ; drawmode 
       fdb 16896,-2304 ; starx/y relative to previous node
       fdb -114,64 ; dx/dy. dx(abs:153|rel:64) dy(abs:-76|rel:-114)
; node # 5 D(-5,-14)->(1,-6)
       fcb 2 ; drawmode 
       fdb 5888,-1024 ; starx/y relative to previous node
       fdb -26,-77 ; dx/dy. dx(abs:76|rel:-77) dy(abs:-102|rel:-26)
; node # 6 D(-15,-49)->(-34,-46)
       fcb 2 ; drawmode 
       fdb 8960,-2560 ; starx/y relative to previous node
       fdb 64,-319 ; dx/dy. dx(abs:-243|rel:-319) dy(abs:-38|rel:64)
; node # 7 D(-18,-55)->(-58,-60)
       fcb 2 ; drawmode 
       fdb 1536,-768 ; starx/y relative to previous node
       fdb 102,-269 ; dx/dy. dx(abs:-512|rel:-269) dy(abs:64|rel:102)
; node # 8 D(3,-33)->(-34,-45)
       fcb 2 ; drawmode 
       fdb -5632,5376 ; starx/y relative to previous node
       fdb 89,39 ; dx/dy. dx(abs:-473|rel:39) dy(abs:153|rel:89)
; node # 9 D(21,22)->(-3,3)
       fcb 2 ; drawmode 
       fdb -14080,4608 ; starx/y relative to previous node
       fdb 90,166 ; dx/dy. dx(abs:-307|rel:166) dy(abs:243|rel:90)
; node # 10 M(13,27)->(-8,10)
       fcb 0 ; drawmode 
       fdb -1280,-2048 ; starx/y relative to previous node
       fdb -26,39 ; dx/dy. dx(abs:-268|rel:39) dy(abs:217|rel:-26)
; node # 11 D(14,50)->(-1,34)
       fcb 2 ; drawmode 
       fdb -5888,256 ; starx/y relative to previous node
       fdb -13,76 ; dx/dy. dx(abs:-192|rel:76) dy(abs:204|rel:-13)
; node # 12 D(-3,54)->(-17,41)
       fcb 2 ; drawmode 
       fdb -1024,-4352 ; starx/y relative to previous node
       fdb -38,13 ; dx/dy. dx(abs:-179|rel:13) dy(abs:166|rel:-38)
; node # 13 D(-11,31)->(-30,20)
       fcb 2 ; drawmode 
       fdb 5888,-2048 ; starx/y relative to previous node
       fdb -26,-64 ; dx/dy. dx(abs:-243|rel:-64) dy(abs:140|rel:-26)
; node # 14 D(13,27)->(-8,10)
       fcb 2 ; drawmode 
       fdb 1024,6144 ; starx/y relative to previous node
       fdb 77,-25 ; dx/dy. dx(abs:-268|rel:-25) dy(abs:217|rel:77)
; node # 15 M(12,20)->(-12,2)
       fcb 0 ; drawmode 
       fdb 1792,-256 ; starx/y relative to previous node
       fdb 13,-39 ; dx/dy. dx(abs:-307|rel:-39) dy(abs:230|rel:13)
; node # 16 D(5,-4)->(-25,-19)
       fcb 2 ; drawmode 
       fdb 6144,-1792 ; starx/y relative to previous node
       fdb -38,-77 ; dx/dy. dx(abs:-384|rel:-77) dy(abs:192|rel:-38)
; node # 17 D(-13,-1)->(-41,-11)
       fcb 2 ; drawmode 
       fdb -768,-4608 ; starx/y relative to previous node
       fdb -64,26 ; dx/dy. dx(abs:-358|rel:26) dy(abs:128|rel:-64)
; node # 18 D(-13,24)->(-34,13)
       fcb 2 ; drawmode 
       fdb -6400,0 ; starx/y relative to previous node
       fdb 12,90 ; dx/dy. dx(abs:-268|rel:90) dy(abs:140|rel:12)
; node # 19 D(12,20)->(-12,2)
       fcb 2 ; drawmode 
       fdb 1024,6400 ; starx/y relative to previous node
       fdb 90,-39 ; dx/dy. dx(abs:-307|rel:-39) dy(abs:230|rel:90)
; node # 20 M(21,21)->(-3,3)
       fcb 0 ; drawmode 
       fdb -256,2304 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-307|rel:0) dy(abs:230|rel:0)
; node # 21 D(18,11)->(4,1)
       fcb 2 ; drawmode 
       fdb 2560,-768 ; starx/y relative to previous node
       fdb -102,128 ; dx/dy. dx(abs:-179|rel:128) dy(abs:128|rel:-102)
; node # 22 D(-5,-14)->(1,-6)
       fcb 2 ; drawmode 
       fdb 6400,-5888 ; starx/y relative to previous node
       fdb -230,255 ; dx/dy. dx(abs:76|rel:255) dy(abs:-102|rel:-230)
; node # 23 M(-2,0)->(10,3)
       fcb 0 ; drawmode 
       fdb -3584,768 ; starx/y relative to previous node
       fdb 64,77 ; dx/dy. dx(abs:153|rel:77) dy(abs:-38|rel:64)
; node # 24 D(-2,0)->(7,4)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb -13,-38 ; dx/dy. dx(abs:115|rel:-38) dy(abs:-51|rel:-13)
; node # 25 M(-1,9)->(11,15)
       fcb 0 ; drawmode 
       fdb -2304,256 ; starx/y relative to previous node
       fdb -25,38 ; dx/dy. dx(abs:153|rel:38) dy(abs:-76|rel:-25)
; node # 26 D(18,11)->(4,1)
       fcb 2 ; drawmode 
       fdb -512,4864 ; starx/y relative to previous node
       fdb 204,-332 ; dx/dy. dx(abs:-179|rel:-332) dy(abs:128|rel:204)
; node # 27 D(22,75)->(15,61)
       fcb 2 ; drawmode 
       fdb -16384,1024 ; starx/y relative to previous node
       fdb 51,90 ; dx/dy. dx(abs:-89|rel:90) dy(abs:179|rel:51)
; node # 28 D(-1,9)->(11,15)
       fcb 2 ; drawmode 
       fdb 16896,-5888 ; starx/y relative to previous node
       fdb -255,242 ; dx/dy. dx(abs:153|rel:242) dy(abs:-76|rel:-255)
; node # 29 D(-16,44)->(-31,34)
       fcb 2 ; drawmode 
       fdb -8960,-3840 ; starx/y relative to previous node
       fdb 204,-345 ; dx/dy. dx(abs:-192|rel:-345) dy(abs:128|rel:204)
; node # 30 D(-22,13)->(-45,5)
       fcb 2 ; drawmode 
       fdb 7936,-1536 ; starx/y relative to previous node
       fdb -26,-102 ; dx/dy. dx(abs:-294|rel:-102) dy(abs:102|rel:-26)
; node # 31 D(-5,-14)->(1,-6)
       fcb 2 ; drawmode 
       fdb 6912,4352 ; starx/y relative to previous node
       fdb -204,370 ; dx/dy. dx(abs:76|rel:370) dy(abs:-102|rel:-204)
; node # 32 D(3,-33)->(-34,-45)
       fcb 2 ; drawmode 
       fdb 4864,2048 ; starx/y relative to previous node
       fdb 255,-549 ; dx/dy. dx(abs:-473|rel:-549) dy(abs:153|rel:255)
; node # 33 D(18,11)->(4,1)
       fcb 2 ; drawmode 
       fdb -11264,3840 ; starx/y relative to previous node
       fdb -25,294 ; dx/dy. dx(abs:-179|rel:294) dy(abs:128|rel:-25)
; node # 34 M(-16,44)->(-31,34)
       fcb 0 ; drawmode 
       fdb -8448,-8704 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:-192|rel:-13) dy(abs:128|rel:0)
; node # 35 D(10,99)->(9,87)
       fcb 2 ; drawmode 
       fdb -14080,6656 ; starx/y relative to previous node
       fdb 25,180 ; dx/dy. dx(abs:-12|rel:180) dy(abs:153|rel:25)
; node # 36 M(8,75)->(15,72)
       fcb 0 ; drawmode 
       fdb 6144,-512 ; starx/y relative to previous node
       fdb -115,101 ; dx/dy. dx(abs:89|rel:101) dy(abs:38|rel:-115)
; node # 37 D(22,75)->(15,61)
       fcb 2 ; drawmode 
       fdb 0,3584 ; starx/y relative to previous node
       fdb 141,-178 ; dx/dy. dx(abs:-89|rel:-178) dy(abs:179|rel:141)
; node # 38 M(6,85)->(1,73)
       fcb 0 ; drawmode 
       fdb -2560,-4096 ; starx/y relative to previous node
       fdb -26,25 ; dx/dy. dx(abs:-64|rel:25) dy(abs:153|rel:-26)
; node # 39 D(15,84)->(10,70)
       fcb 2 ; drawmode 
       fdb 256,2304 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:-64|rel:0) dy(abs:179|rel:26)
; node # 40 D(10,92)->(7,80)
       fcb 2 ; drawmode 
       fdb -2048,-1280 ; starx/y relative to previous node
       fdb -26,26 ; dx/dy. dx(abs:-38|rel:26) dy(abs:153|rel:-26)
; node # 41 D(6,85)->(1,73)
       fcb 2 ; drawmode 
       fdb 1792,-1024 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:-64|rel:-26) dy(abs:153|rel:0)
; node # 42 M(-22,13)->(-45,5)
       fcb 0 ; drawmode 
       fdb 18432,-7168 ; starx/y relative to previous node
       fdb -51,-230 ; dx/dy. dx(abs:-294|rel:-230) dy(abs:102|rel:-51)
; node # 43 D(-18,-55)->(-58,-60)
       fcb 2 ; drawmode 
       fdb 17408,1024 ; starx/y relative to previous node
       fdb -38,-218 ; dx/dy. dx(abs:-512|rel:-218) dy(abs:64|rel:-38)
; node # 44 M(-15,-49)->(-34,-46)
       fcb 0 ; drawmode 
       fdb -1536,768 ; starx/y relative to previous node
       fdb -102,269 ; dx/dy. dx(abs:-243|rel:269) dy(abs:-38|rel:-102)
; node # 45 D(3,-33)->(-34,-45)
       fcb 2 ; drawmode 
       fdb -4096,4608 ; starx/y relative to previous node
       fdb 191,-230 ; dx/dy. dx(abs:-473|rel:-230) dy(abs:153|rel:191)
; node # 46 M(-17,-38)->(-52,-45)
       fcb 0 ; drawmode 
       fdb 1280,-5120 ; starx/y relative to previous node
       fdb -64,25 ; dx/dy. dx(abs:-448|rel:25) dy(abs:89|rel:-64)
; node # 47 D(-17,-47)->(-54,-53)
       fcb 2 ; drawmode 
       fdb 2304,0 ; starx/y relative to previous node
       fdb -13,-25 ; dx/dy. dx(abs:-473|rel:-25) dy(abs:76|rel:-13)
; node # 48 D(-7,-40)->(-45,-49)
       fcb 2 ; drawmode 
       fdb -1792,2560 ; starx/y relative to previous node
       fdb 39,-13 ; dx/dy. dx(abs:-486|rel:-13) dy(abs:115|rel:39)
; node # 49 D(-17,-38)->(-52,-45)
       fcb 2 ; drawmode 
       fdb -512,-2560 ; starx/y relative to previous node
       fdb -26,38 ; dx/dy. dx(abs:-448|rel:38) dy(abs:89|rel:-26)
       fcb  1  ; end of anim
; Animation 6
eliteframe6:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-3,3)->(-42,-12)
       fcb 0 ; drawmode 
       fdb -768,-768 ; starx/y relative to previous node
       fdb 192,-499 ; dx/dy. dx(abs:-499|rel:-499) dy(abs:192|rel:192)
; node # 1 D(15,61)->(-16,31)
       fcb 2 ; drawmode 
       fdb -14848,4608 ; starx/y relative to previous node
       fdb 192,103 ; dx/dy. dx(abs:-396|rel:103) dy(abs:384|rel:192)
; node # 2 D(9,87)->(-10,62)
       fcb 2 ; drawmode 
       fdb -6656,-1536 ; starx/y relative to previous node
       fdb -64,153 ; dx/dy. dx(abs:-243|rel:153) dy(abs:320|rel:-64)
; node # 3 D(15,72)->(11,52)
       fcb 2 ; drawmode 
       fdb 3840,1536 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-51|rel:192) dy(abs:256|rel:-64)
; node # 4 D(11,15)->(29,16)
       fcb 2 ; drawmode 
       fdb 14592,-1024 ; starx/y relative to previous node
       fdb -268,281 ; dx/dy. dx(abs:230|rel:281) dy(abs:-12|rel:-268)
; node # 5 D(1,-6)->(14,0)
       fcb 2 ; drawmode 
       fdb 5376,-2560 ; starx/y relative to previous node
       fdb -64,-64 ; dx/dy. dx(abs:166|rel:-64) dy(abs:-76|rel:-64)
; node # 6 D(-34,-46)->(-73,-39)
       fcb 2 ; drawmode 
       fdb 10240,-8960 ; starx/y relative to previous node
       fdb -13,-665 ; dx/dy. dx(abs:-499|rel:-665) dy(abs:-89|rel:-13)
; node # 7 D(-58,-60)->(-89,-39)
       fcb 2 ; drawmode 
       fdb 3584,-6144 ; starx/y relative to previous node
       fdb -179,103 ; dx/dy. dx(abs:-396|rel:103) dy(abs:-268|rel:-179)
; node # 8 D(-34,-45)->(-73,-39)
       fcb 2 ; drawmode 
       fdb -3840,6144 ; starx/y relative to previous node
       fdb 192,-103 ; dx/dy. dx(abs:-499|rel:-103) dy(abs:-76|rel:192)
; node # 9 D(-3,3)->(-43,-13)
       fcb 2 ; drawmode 
       fdb -12288,7936 ; starx/y relative to previous node
       fdb 280,-13 ; dx/dy. dx(abs:-512|rel:-13) dy(abs:204|rel:280)
; node # 10 M(-8,10)->(-45,-5)
       fcb 0 ; drawmode 
       fdb -1792,-1280 ; starx/y relative to previous node
       fdb -12,39 ; dx/dy. dx(abs:-473|rel:39) dy(abs:192|rel:-12)
; node # 11 D(-1,34)->(-34,14)
       fcb 2 ; drawmode 
       fdb -6144,1792 ; starx/y relative to previous node
       fdb 64,51 ; dx/dy. dx(abs:-422|rel:51) dy(abs:256|rel:64)
; node # 12 D(-17,41)->(-42,27)
       fcb 2 ; drawmode 
       fdb -1792,-4096 ; starx/y relative to previous node
       fdb -77,102 ; dx/dy. dx(abs:-320|rel:102) dy(abs:179|rel:-77)
; node # 13 D(-30,20)->(-56,14)
       fcb 2 ; drawmode 
       fdb 5376,-3328 ; starx/y relative to previous node
       fdb -103,-12 ; dx/dy. dx(abs:-332|rel:-12) dy(abs:76|rel:-103)
; node # 14 D(-8,10)->(-45,-5)
       fcb 2 ; drawmode 
       fdb 2560,5632 ; starx/y relative to previous node
       fdb 116,-141 ; dx/dy. dx(abs:-473|rel:-141) dy(abs:192|rel:116)
; node # 15 M(-12,2)->(-49,-9)
       fcb 0 ; drawmode 
       fdb 2048,-1024 ; starx/y relative to previous node
       fdb -52,0 ; dx/dy. dx(abs:-473|rel:0) dy(abs:140|rel:-52)
; node # 16 D(-25,-19)->(-62,-22)
       fcb 2 ; drawmode 
       fdb 5376,-3328 ; starx/y relative to previous node
       fdb -102,0 ; dx/dy. dx(abs:-473|rel:0) dy(abs:38|rel:-102)
; node # 17 D(-41,-11)->(-70,-8)
       fcb 2 ; drawmode 
       fdb -2048,-4096 ; starx/y relative to previous node
       fdb -76,102 ; dx/dy. dx(abs:-371|rel:102) dy(abs:-38|rel:-76)
; node # 18 D(-34,13)->(-60,9)
       fcb 2 ; drawmode 
       fdb -6144,1792 ; starx/y relative to previous node
       fdb 89,39 ; dx/dy. dx(abs:-332|rel:39) dy(abs:51|rel:89)
; node # 19 D(-12,2)->(-49,-9)
       fcb 2 ; drawmode 
       fdb 2816,5632 ; starx/y relative to previous node
       fdb 89,-141 ; dx/dy. dx(abs:-473|rel:-141) dy(abs:140|rel:89)
; node # 20 M(-3,3)->(-42,-12)
       fcb 0 ; drawmode 
       fdb -256,2304 ; starx/y relative to previous node
       fdb 52,-26 ; dx/dy. dx(abs:-499|rel:-26) dy(abs:192|rel:52)
; node # 21 D(4,1)->(-17,-11)
       fcb 2 ; drawmode 
       fdb 512,1792 ; starx/y relative to previous node
       fdb -39,231 ; dx/dy. dx(abs:-268|rel:231) dy(abs:153|rel:-39)
; node # 22 D(1,-6)->(14,0)
       fcb 2 ; drawmode 
       fdb 1792,-768 ; starx/y relative to previous node
       fdb -229,434 ; dx/dy. dx(abs:166|rel:434) dy(abs:-76|rel:-229)
; node # 23 M(10,3)->(31,8)
       fcb 0 ; drawmode 
       fdb -2304,2304 ; starx/y relative to previous node
       fdb 12,102 ; dx/dy. dx(abs:268|rel:102) dy(abs:-64|rel:12)
; node # 24 D(7,4)->(22,8)
       fcb 2 ; drawmode 
       fdb -256,-768 ; starx/y relative to previous node
       fdb 13,-76 ; dx/dy. dx(abs:192|rel:-76) dy(abs:-51|rel:13)
; node # 25 M(11,15)->(29,16)
       fcb 0 ; drawmode 
       fdb -2816,1024 ; starx/y relative to previous node
       fdb 39,38 ; dx/dy. dx(abs:230|rel:38) dy(abs:-12|rel:39)
; node # 26 D(4,1)->(-17,-11)
       fcb 2 ; drawmode 
       fdb 3584,-1792 ; starx/y relative to previous node
       fdb 165,-498 ; dx/dy. dx(abs:-268|rel:-498) dy(abs:153|rel:165)
; node # 27 D(15,61)->(-16,31)
       fcb 2 ; drawmode 
       fdb -15360,2816 ; starx/y relative to previous node
       fdb 231,-128 ; dx/dy. dx(abs:-396|rel:-128) dy(abs:384|rel:231)
; node # 28 D(11,15)->(29,16)
       fcb 2 ; drawmode 
       fdb 11776,-1024 ; starx/y relative to previous node
       fdb -396,626 ; dx/dy. dx(abs:230|rel:626) dy(abs:-12|rel:-396)
; node # 29 D(-31,34)->(-53,27)
       fcb 2 ; drawmode 
       fdb -4864,-10752 ; starx/y relative to previous node
       fdb 101,-511 ; dx/dy. dx(abs:-281|rel:-511) dy(abs:89|rel:101)
; node # 30 D(-45,5)->(-69,6)
       fcb 2 ; drawmode 
       fdb 7424,-3584 ; starx/y relative to previous node
       fdb -101,-26 ; dx/dy. dx(abs:-307|rel:-26) dy(abs:-12|rel:-101)
; node # 31 D(1,-6)->(14,0)
       fcb 2 ; drawmode 
       fdb 2816,11776 ; starx/y relative to previous node
       fdb -64,473 ; dx/dy. dx(abs:166|rel:473) dy(abs:-76|rel:-64)
; node # 32 D(-34,-45)->(-73,-39)
       fcb 2 ; drawmode 
       fdb 9984,-8960 ; starx/y relative to previous node
       fdb 0,-665 ; dx/dy. dx(abs:-499|rel:-665) dy(abs:-76|rel:0)
; node # 33 D(4,1)->(-17,-11)
       fcb 2 ; drawmode 
       fdb -11776,9728 ; starx/y relative to previous node
       fdb 229,231 ; dx/dy. dx(abs:-268|rel:231) dy(abs:153|rel:229)
; node # 34 M(-31,34)->(-53,27)
       fcb 0 ; drawmode 
       fdb -8448,-8960 ; starx/y relative to previous node
       fdb -64,-13 ; dx/dy. dx(abs:-281|rel:-13) dy(abs:89|rel:-64)
; node # 35 D(9,87)->(-10,62)
       fcb 2 ; drawmode 
       fdb -13568,10240 ; starx/y relative to previous node
       fdb 231,38 ; dx/dy. dx(abs:-243|rel:38) dy(abs:320|rel:231)
; node # 36 M(15,72)->(11,52)
       fcb 0 ; drawmode 
       fdb 3840,1536 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:-51|rel:192) dy(abs:256|rel:-64)
; node # 37 D(15,61)->(-16,31)
       fcb 2 ; drawmode 
       fdb 2816,0 ; starx/y relative to previous node
       fdb 128,-345 ; dx/dy. dx(abs:-396|rel:-345) dy(abs:384|rel:128)
; node # 38 M(1,73)->(-21,50)
       fcb 0 ; drawmode 
       fdb -3072,-3584 ; starx/y relative to previous node
       fdb -90,115 ; dx/dy. dx(abs:-281|rel:115) dy(abs:294|rel:-90)
; node # 39 D(10,70)->(-15,43)
       fcb 2 ; drawmode 
       fdb 768,2304 ; starx/y relative to previous node
       fdb 51,-39 ; dx/dy. dx(abs:-320|rel:-39) dy(abs:345|rel:51)
; node # 40 D(7,80)->(-14,55)
       fcb 2 ; drawmode 
       fdb -2560,-768 ; starx/y relative to previous node
       fdb -25,52 ; dx/dy. dx(abs:-268|rel:52) dy(abs:320|rel:-25)
; node # 41 D(1,73)->(-21,50)
       fcb 2 ; drawmode 
       fdb 1792,-1536 ; starx/y relative to previous node
       fdb -26,-13 ; dx/dy. dx(abs:-281|rel:-13) dy(abs:294|rel:-26)
; node # 42 M(-45,5)->(-69,6)
       fcb 0 ; drawmode 
       fdb 17408,-11776 ; starx/y relative to previous node
       fdb -306,-26 ; dx/dy. dx(abs:-307|rel:-26) dy(abs:-12|rel:-306)
; node # 43 D(-58,-60)->(-89,-39)
       fcb 2 ; drawmode 
       fdb 16640,-3328 ; starx/y relative to previous node
       fdb -256,-89 ; dx/dy. dx(abs:-396|rel:-89) dy(abs:-268|rel:-256)
; node # 44 M(-34,-46)->(-73,-39)
       fcb 0 ; drawmode 
       fdb -3584,6144 ; starx/y relative to previous node
       fdb 179,-103 ; dx/dy. dx(abs:-499|rel:-103) dy(abs:-89|rel:179)
; node # 45 D(-34,-45)->(-73,-39)
       fcb 2 ; drawmode 
       fdb -256,0 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:-499|rel:0) dy(abs:-76|rel:13)
; node # 46 M(-52,-45)->(-84,-31)
       fcb 0 ; drawmode 
       fdb 0,-4608 ; starx/y relative to previous node
       fdb -103,90 ; dx/dy. dx(abs:-409|rel:90) dy(abs:-179|rel:-103)
; node # 47 D(-54,-53)->(-86,-36)
       fcb 2 ; drawmode 
       fdb 2048,-512 ; starx/y relative to previous node
       fdb -38,0 ; dx/dy. dx(abs:-409|rel:0) dy(abs:-217|rel:-38)
; node # 48 D(-45,-49)->(-80,-37)
       fcb 2 ; drawmode 
       fdb -1024,2304 ; starx/y relative to previous node
       fdb 64,-39 ; dx/dy. dx(abs:-448|rel:-39) dy(abs:-153|rel:64)
; node # 49 D(-52,-45)->(-84,-31)
       fcb 2 ; drawmode 
       fdb -1024,-1792 ; starx/y relative to previous node
       fdb -26,39 ; dx/dy. dx(abs:-409|rel:39) dy(abs:-179|rel:-26)
       fcb  1  ; end of anim
; Animation 7
eliteframe7:
       fcb 20 ; Duration
       fcb 20 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-42,-12)->(-63,-12)
       fcb 0 ; drawmode 
       fdb 3072,-10752 ; starx/y relative to previous node
       fdb 0,-268 ; dx/dy. dx(abs:-268|rel:-268) dy(abs:0|rel:0)
; node # 1 D(-16,31)->(-42,17)
       fcb 2 ; drawmode 
       fdb -11008,6656 ; starx/y relative to previous node
       fdb 179,-64 ; dx/dy. dx(abs:-332|rel:-64) dy(abs:179|rel:179)
; node # 2 D(-10,62)->(-35,44)
       fcb 2 ; drawmode 
       fdb -7936,1536 ; starx/y relative to previous node
       fdb 51,12 ; dx/dy. dx(abs:-320|rel:12) dy(abs:230|rel:51)
; node # 3 D(11,52)->(-2,37)
       fcb 2 ; drawmode 
       fdb 2560,5376 ; starx/y relative to previous node
       fdb -38,154 ; dx/dy. dx(abs:-166|rel:154) dy(abs:192|rel:-38)
; node # 4 D(29,16)->(37,11)
       fcb 2 ; drawmode 
       fdb 9216,4608 ; starx/y relative to previous node
       fdb -128,268 ; dx/dy. dx(abs:102|rel:268) dy(abs:64|rel:-128)
; node # 5 D(14,0)->(22,2)
       fcb 2 ; drawmode 
       fdb 4096,-3840 ; starx/y relative to previous node
       fdb -89,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:-25|rel:-89)
; node # 6 D(-73,-39)->(-61,-15)
       fcb 2 ; drawmode 
       fdb 9984,-22272 ; starx/y relative to previous node
       fdb -282,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-307|rel:-282)
; node # 7 D(-89,-39)->(-91,-17)
       fcb 2 ; drawmode 
       fdb 0,-4096 ; starx/y relative to previous node
       fdb 26,-178 ; dx/dy. dx(abs:-25|rel:-178) dy(abs:-281|rel:26)
; node # 8 D(-73,-39)->(-83,-23)
       fcb 2 ; drawmode 
       fdb 0,4096 ; starx/y relative to previous node
       fdb 77,-103 ; dx/dy. dx(abs:-128|rel:-103) dy(abs:-204|rel:77)
; node # 9 D(-43,-13)->(-63,-12)
       fcb 2 ; drawmode 
       fdb -6656,7680 ; starx/y relative to previous node
       fdb 192,-128 ; dx/dy. dx(abs:-256|rel:-128) dy(abs:-12|rel:192)
; node # 10 M(-45,-5)->(-65,-4)
       fcb 0 ; drawmode 
       fdb -2048,-512 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-256|rel:0) dy(abs:-12|rel:0)
; node # 11 D(-34,14)->(-55,8)
       fcb 2 ; drawmode 
       fdb -4864,2816 ; starx/y relative to previous node
       fdb 88,-12 ; dx/dy. dx(abs:-268|rel:-12) dy(abs:76|rel:88)
; node # 12 D(-42,27)->(-58,24)
       fcb 2 ; drawmode 
       fdb -3328,-2048 ; starx/y relative to previous node
       fdb -38,64 ; dx/dy. dx(abs:-204|rel:64) dy(abs:38|rel:-38)
; node # 13 D(-56,14)->(-68,17)
       fcb 2 ; drawmode 
       fdb 3328,-3584 ; starx/y relative to previous node
       fdb -76,51 ; dx/dy. dx(abs:-153|rel:51) dy(abs:-38|rel:-76)
; node # 14 D(-46,-5)->(-65,-4)
       fcb 2 ; drawmode 
       fdb 4864,2560 ; starx/y relative to previous node
       fdb 26,-90 ; dx/dy. dx(abs:-243|rel:-90) dy(abs:-12|rel:26)
; node # 15 M(-49,-9)->(-67,-7)
       fcb 0 ; drawmode 
       fdb 1024,-768 ; starx/y relative to previous node
       fdb -13,13 ; dx/dy. dx(abs:-230|rel:13) dy(abs:-25|rel:-13)
; node # 16 D(-62,-22)->(-76,-12)
       fcb 2 ; drawmode 
       fdb 3328,-3328 ; starx/y relative to previous node
       fdb -103,51 ; dx/dy. dx(abs:-179|rel:51) dy(abs:-128|rel:-103)
; node # 17 D(-70,-8)->(-77,2)
       fcb 2 ; drawmode 
       fdb -3584,-2048 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:-89|rel:90) dy(abs:-128|rel:0)
; node # 18 D(-60,9)->(-70,14)
       fcb 2 ; drawmode 
       fdb -4352,2560 ; starx/y relative to previous node
       fdb 64,-39 ; dx/dy. dx(abs:-128|rel:-39) dy(abs:-64|rel:64)
; node # 19 D(-49,-9)->(-67,-7)
       fcb 2 ; drawmode 
       fdb 4608,2816 ; starx/y relative to previous node
       fdb 39,-102 ; dx/dy. dx(abs:-230|rel:-102) dy(abs:-25|rel:39)
; node # 20 M(-42,-12)->(-63,-12)
       fcb 0 ; drawmode 
       fdb 768,1792 ; starx/y relative to previous node
       fdb 25,-38 ; dx/dy. dx(abs:-268|rel:-38) dy(abs:0|rel:25)
; node # 21 D(-17,-11)->(-33,-12)
       fcb 2 ; drawmode 
       fdb -256,6400 ; starx/y relative to previous node
       fdb 12,64 ; dx/dy. dx(abs:-204|rel:64) dy(abs:12|rel:12)
; node # 22 D(14,0)->(22,2)
       fcb 2 ; drawmode 
       fdb -2816,7936 ; starx/y relative to previous node
       fdb -37,306 ; dx/dy. dx(abs:102|rel:306) dy(abs:-25|rel:-37)
; node # 23 M(31,8)->(43,5)
       fcb 0 ; drawmode 
       fdb -2048,4352 ; starx/y relative to previous node
       fdb 63,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:38|rel:63)
; node # 24 D(22,8)->(30,6)
       fcb 2 ; drawmode 
       fdb 0,-2304 ; starx/y relative to previous node
       fdb -13,-51 ; dx/dy. dx(abs:102|rel:-51) dy(abs:25|rel:-13)
; node # 25 M(29,16)->(37,11)
       fcb 0 ; drawmode 
       fdb -2048,1792 ; starx/y relative to previous node
       fdb 39,0 ; dx/dy. dx(abs:102|rel:0) dy(abs:64|rel:39)
; node # 26 D(-17,-11)->(-33,-12)
       fcb 2 ; drawmode 
       fdb 6912,-11776 ; starx/y relative to previous node
       fdb -52,-306 ; dx/dy. dx(abs:-204|rel:-306) dy(abs:12|rel:-52)
; node # 27 D(-16,31)->(-42,17)
       fcb 2 ; drawmode 
       fdb -10752,256 ; starx/y relative to previous node
       fdb 167,-128 ; dx/dy. dx(abs:-332|rel:-128) dy(abs:179|rel:167)
; node # 28 D(29,16)->(37,11)
       fcb 2 ; drawmode 
       fdb 3840,11520 ; starx/y relative to previous node
       fdb -115,434 ; dx/dy. dx(abs:102|rel:434) dy(abs:64|rel:-115)
; node # 29 D(-53,27)->(-64,28)
       fcb 2 ; drawmode 
       fdb -2816,-20992 ; starx/y relative to previous node
       fdb -76,-242 ; dx/dy. dx(abs:-140|rel:-242) dy(abs:-12|rel:-76)
; node # 30 D(-69,6)->(-75,16)
       fcb 2 ; drawmode 
       fdb 5376,-4096 ; starx/y relative to previous node
       fdb -116,64 ; dx/dy. dx(abs:-76|rel:64) dy(abs:-128|rel:-116)
; node # 31 D(14,0)->(22,2)
       fcb 2 ; drawmode 
       fdb 1536,21248 ; starx/y relative to previous node
       fdb 103,178 ; dx/dy. dx(abs:102|rel:178) dy(abs:-25|rel:103)
; node # 32 D(-73,-39)->(-83,-23)
       fcb 2 ; drawmode 
       fdb 9984,-22272 ; starx/y relative to previous node
       fdb -179,-230 ; dx/dy. dx(abs:-128|rel:-230) dy(abs:-204|rel:-179)
; node # 33 D(-17,-11)->(-33,-12)
       fcb 2 ; drawmode 
       fdb -7168,14336 ; starx/y relative to previous node
       fdb 216,-76 ; dx/dy. dx(abs:-204|rel:-76) dy(abs:12|rel:216)
; node # 34 M(-53,27)->(-64,28)
       fcb 0 ; drawmode 
       fdb -9728,-9216 ; starx/y relative to previous node
       fdb -24,64 ; dx/dy. dx(abs:-140|rel:64) dy(abs:-12|rel:-24)
; node # 35 D(-10,62)->(-35,44)
       fcb 2 ; drawmode 
       fdb -8960,11008 ; starx/y relative to previous node
       fdb 242,-180 ; dx/dy. dx(abs:-320|rel:-180) dy(abs:230|rel:242)
; node # 36 M(11,52)->(-2,37)
       fcb 0 ; drawmode 
       fdb 2560,5376 ; starx/y relative to previous node
       fdb -38,154 ; dx/dy. dx(abs:-166|rel:154) dy(abs:192|rel:-38)
; node # 37 D(-16,31)->(-42,17)
       fcb 2 ; drawmode 
       fdb 5376,-6912 ; starx/y relative to previous node
       fdb -13,-166 ; dx/dy. dx(abs:-332|rel:-166) dy(abs:179|rel:-13)
; node # 38 M(-21,50)->(-42,37)
       fcb 0 ; drawmode 
       fdb -4864,-1280 ; starx/y relative to previous node
       fdb -13,64 ; dx/dy. dx(abs:-268|rel:64) dy(abs:166|rel:-13)
; node # 39 D(-15,43)->(-41,29)
       fcb 2 ; drawmode 
       fdb 1792,1536 ; starx/y relative to previous node
       fdb 13,-64 ; dx/dy. dx(abs:-332|rel:-64) dy(abs:179|rel:13)
; node # 40 D(-14,55)->(-38,39)
       fcb 2 ; drawmode 
       fdb -3072,256 ; starx/y relative to previous node
       fdb 25,25 ; dx/dy. dx(abs:-307|rel:25) dy(abs:204|rel:25)
; node # 41 D(-21,50)->(-42,37)
       fcb 2 ; drawmode 
       fdb 1280,-1792 ; starx/y relative to previous node
       fdb -38,39 ; dx/dy. dx(abs:-268|rel:39) dy(abs:166|rel:-38)
; node # 42 M(-69,6)->(-75,16)
       fcb 0 ; drawmode 
       fdb 11264,-12288 ; starx/y relative to previous node
       fdb -294,192 ; dx/dy. dx(abs:-76|rel:192) dy(abs:-128|rel:-294)
; node # 43 D(-89,-39)->(-91,-17)
       fcb 2 ; drawmode 
       fdb 11520,-5120 ; starx/y relative to previous node
       fdb -153,51 ; dx/dy. dx(abs:-25|rel:51) dy(abs:-281|rel:-153)
; node # 44 M(-73,-39)->(-61,-15)
       fcb 0 ; drawmode 
       fdb 0,4096 ; starx/y relative to previous node
       fdb -26,178 ; dx/dy. dx(abs:153|rel:178) dy(abs:-307|rel:-26)
; node # 45 D(-73,-39)->(-83,-23)
       fcb 2 ; drawmode 
       fdb 0,0 ; starx/y relative to previous node
       fdb 103,-281 ; dx/dy. dx(abs:-128|rel:-281) dy(abs:-204|rel:103)
; node # 46 M(-84,-31)->(-87,-12)
       fcb 0 ; drawmode 
       fdb -2048,-2816 ; starx/y relative to previous node
       fdb -39,90 ; dx/dy. dx(abs:-38|rel:90) dy(abs:-243|rel:-39)
; node # 47 D(-86,-36)->(-89,-15)
       fcb 2 ; drawmode 
       fdb 1280,-512 ; starx/y relative to previous node
       fdb -25,0 ; dx/dy. dx(abs:-38|rel:0) dy(abs:-268|rel:-25)
; node # 48 D(-80,-37)->(-86,-19)
       fcb 2 ; drawmode 
       fdb 256,1536 ; starx/y relative to previous node
       fdb 38,-38 ; dx/dy. dx(abs:-76|rel:-38) dy(abs:-230|rel:38)
; node # 49 D(-84,-31)->(-87,-12)
       fcb 2 ; drawmode 
       fdb -1536,-1024 ; starx/y relative to previous node
       fdb -13,38 ; dx/dy. dx(abs:-38|rel:38) dy(abs:-243|rel:-13)
       fcb  1  ; end of anim
; Animation 8
eliteframe8:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-63,-12)->(-75,-4)
       fcb 0 ; drawmode 
       fdb 3072,-16128 ; starx/y relative to previous node
       fdb -102,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:-102|rel:-102)
; node # 1 D(-42,17)->(-67,10)
       fcb 2 ; drawmode 
       fdb -7424,5376 ; starx/y relative to previous node
       fdb 191,-167 ; dx/dy. dx(abs:-320|rel:-167) dy(abs:89|rel:191)
; node # 2 D(-35,44)->(-61,31)
       fcb 2 ; drawmode 
       fdb -6912,1792 ; starx/y relative to previous node
       fdb 77,-12 ; dx/dy. dx(abs:-332|rel:-12) dy(abs:166|rel:77)
; node # 3 D(-2,37)->(-23,23)
       fcb 2 ; drawmode 
       fdb 1792,8448 ; starx/y relative to previous node
       fdb 13,64 ; dx/dy. dx(abs:-268|rel:64) dy(abs:179|rel:13)
; node # 4 D(37,11)->(41,3)
       fcb 2 ; drawmode 
       fdb 6656,9984 ; starx/y relative to previous node
       fdb -77,319 ; dx/dy. dx(abs:51|rel:319) dy(abs:102|rel:-77)
; node # 5 D(22,2)->(29,-1)
       fcb 2 ; drawmode 
       fdb 2304,-3840 ; starx/y relative to previous node
       fdb -64,38 ; dx/dy. dx(abs:89|rel:38) dy(abs:38|rel:-64)
; node # 6 D(-61,-15)->(-53,4)
       fcb 2 ; drawmode 
       fdb 4352,-21248 ; starx/y relative to previous node
       fdb -281,13 ; dx/dy. dx(abs:102|rel:13) dy(abs:-243|rel:-281)
; node # 7 D(-91,-17)->(-82,7)
       fcb 2 ; drawmode 
       fdb 512,-7680 ; starx/y relative to previous node
       fdb -64,13 ; dx/dy. dx(abs:115|rel:13) dy(abs:-307|rel:-64)
; node # 8 D(-83,-23)->(-80,-3)
       fcb 2 ; drawmode 
       fdb 1536,2048 ; starx/y relative to previous node
       fdb 51,-77 ; dx/dy. dx(abs:38|rel:-77) dy(abs:-256|rel:51)
; node # 9 D(-63,-12)->(-75,-3)
       fcb 2 ; drawmode 
       fdb -2816,5120 ; starx/y relative to previous node
       fdb 141,-191 ; dx/dy. dx(abs:-153|rel:-191) dy(abs:-115|rel:141)
; node # 10 M(-65,-4)->(-74,3)
       fcb 0 ; drawmode 
       fdb -2048,-512 ; starx/y relative to previous node
       fdb 26,38 ; dx/dy. dx(abs:-115|rel:38) dy(abs:-89|rel:26)
; node # 11 D(-55,8)->(-71,9)
       fcb 2 ; drawmode 
       fdb -3072,2560 ; starx/y relative to previous node
       fdb 77,-89 ; dx/dy. dx(abs:-204|rel:-89) dy(abs:-12|rel:77)
; node # 12 D(-58,24)->(-69,26)
       fcb 2 ; drawmode 
       fdb -4096,-768 ; starx/y relative to previous node
       fdb -13,64 ; dx/dy. dx(abs:-140|rel:64) dy(abs:-25|rel:-13)
; node # 13 D(-68,17)->(-72,25)
       fcb 2 ; drawmode 
       fdb 1792,-2560 ; starx/y relative to previous node
       fdb -77,89 ; dx/dy. dx(abs:-51|rel:89) dy(abs:-102|rel:-77)
; node # 14 D(-65,-4)->(-74,3)
       fcb 2 ; drawmode 
       fdb 5376,768 ; starx/y relative to previous node
       fdb 13,-64 ; dx/dy. dx(abs:-115|rel:-64) dy(abs:-89|rel:13)
; node # 15 M(-67,-7)->(-76,3)
       fcb 0 ; drawmode 
       fdb 768,-512 ; starx/y relative to previous node
       fdb -39,0 ; dx/dy. dx(abs:-115|rel:0) dy(abs:-128|rel:-39)
; node # 16 D(-76,-12)->(-77,3)
       fcb 2 ; drawmode 
       fdb 1280,-2304 ; starx/y relative to previous node
       fdb -64,103 ; dx/dy. dx(abs:-12|rel:103) dy(abs:-192|rel:-64)
; node # 17 D(-77,2)->(-76,16)
       fcb 2 ; drawmode 
       fdb -3584,-256 ; starx/y relative to previous node
       fdb 13,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-179|rel:13)
; node # 18 D(-70,14)->(-74,21)
       fcb 2 ; drawmode 
       fdb -3072,1792 ; starx/y relative to previous node
       fdb 90,-63 ; dx/dy. dx(abs:-51|rel:-63) dy(abs:-89|rel:90)
; node # 19 D(-67,-7)->(-76,3)
       fcb 2 ; drawmode 
       fdb 5376,768 ; starx/y relative to previous node
       fdb -39,-64 ; dx/dy. dx(abs:-115|rel:-64) dy(abs:-128|rel:-39)
; node # 20 M(-63,-12)->(-75,-4)
       fcb 0 ; drawmode 
       fdb 1280,1024 ; starx/y relative to previous node
       fdb 26,-38 ; dx/dy. dx(abs:-153|rel:-38) dy(abs:-102|rel:26)
; node # 21 D(-33,-12)->(-41,-9)
       fcb 2 ; drawmode 
       fdb 0,7680 ; starx/y relative to previous node
       fdb 64,51 ; dx/dy. dx(abs:-102|rel:51) dy(abs:-38|rel:64)
; node # 22 D(22,2)->(29,-1)
       fcb 2 ; drawmode 
       fdb -3584,14080 ; starx/y relative to previous node
       fdb 76,191 ; dx/dy. dx(abs:89|rel:191) dy(abs:38|rel:76)
; node # 23 M(43,5)->(50,-2)
       fcb 0 ; drawmode 
       fdb -768,5376 ; starx/y relative to previous node
       fdb 51,0 ; dx/dy. dx(abs:89|rel:0) dy(abs:89|rel:51)
; node # 24 D(30,6)->(34,1)
       fcb 2 ; drawmode 
       fdb -256,-3328 ; starx/y relative to previous node
       fdb -25,-38 ; dx/dy. dx(abs:51|rel:-38) dy(abs:64|rel:-25)
; node # 25 M(37,11)->(41,3)
       fcb 0 ; drawmode 
       fdb -1280,1792 ; starx/y relative to previous node
       fdb 38,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:102|rel:38)
; node # 26 D(-33,-12)->(-41,-9)
       fcb 2 ; drawmode 
       fdb 5888,-17920 ; starx/y relative to previous node
       fdb -140,-153 ; dx/dy. dx(abs:-102|rel:-153) dy(abs:-38|rel:-140)
; node # 27 D(-42,17)->(-67,10)
       fcb 2 ; drawmode 
       fdb -7424,-2304 ; starx/y relative to previous node
       fdb 127,-218 ; dx/dy. dx(abs:-320|rel:-218) dy(abs:89|rel:127)
; node # 28 D(37,11)->(41,3)
       fcb 2 ; drawmode 
       fdb 1536,20224 ; starx/y relative to previous node
       fdb 13,371 ; dx/dy. dx(abs:51|rel:371) dy(abs:102|rel:13)
; node # 29 D(-64,28)->(-69,33)
       fcb 2 ; drawmode 
       fdb -4352,-25856 ; starx/y relative to previous node
       fdb -166,-115 ; dx/dy. dx(abs:-64|rel:-115) dy(abs:-64|rel:-166)
; node # 30 D(-75,16)->(-73,28)
       fcb 2 ; drawmode 
       fdb 3072,-2816 ; starx/y relative to previous node
       fdb -89,89 ; dx/dy. dx(abs:25|rel:89) dy(abs:-153|rel:-89)
; node # 31 D(22,2)->(29,-1)
       fcb 2 ; drawmode 
       fdb 3584,24832 ; starx/y relative to previous node
       fdb 191,64 ; dx/dy. dx(abs:89|rel:64) dy(abs:38|rel:191)
; node # 32 D(-83,-23)->(-80,-3)
       fcb 2 ; drawmode 
       fdb 6400,-26880 ; starx/y relative to previous node
       fdb -294,-51 ; dx/dy. dx(abs:38|rel:-51) dy(abs:-256|rel:-294)
; node # 33 D(-33,-12)->(-41,-9)
       fcb 2 ; drawmode 
       fdb -2816,12800 ; starx/y relative to previous node
       fdb 218,-140 ; dx/dy. dx(abs:-102|rel:-140) dy(abs:-38|rel:218)
; node # 34 M(-64,28)->(-69,33)
       fcb 0 ; drawmode 
       fdb -10240,-7936 ; starx/y relative to previous node
       fdb -26,38 ; dx/dy. dx(abs:-64|rel:38) dy(abs:-64|rel:-26)
; node # 35 D(-35,44)->(-61,31)
       fcb 2 ; drawmode 
       fdb -4096,7424 ; starx/y relative to previous node
       fdb 230,-268 ; dx/dy. dx(abs:-332|rel:-268) dy(abs:166|rel:230)
; node # 36 M(-2,37)->(-23,23)
       fcb 0 ; drawmode 
       fdb 1792,8448 ; starx/y relative to previous node
       fdb 13,64 ; dx/dy. dx(abs:-268|rel:64) dy(abs:179|rel:13)
; node # 37 D(-42,17)->(-67,10)
       fcb 2 ; drawmode 
       fdb 5120,-10240 ; starx/y relative to previous node
       fdb -90,-52 ; dx/dy. dx(abs:-320|rel:-52) dy(abs:89|rel:-90)
; node # 38 M(-42,37)->(-64,30)
       fcb 0 ; drawmode 
       fdb -5120,0 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:-281|rel:39) dy(abs:89|rel:0)
; node # 39 D(-41,29)->(-64,24)
       fcb 2 ; drawmode 
       fdb 2048,256 ; starx/y relative to previous node
       fdb -25,-13 ; dx/dy. dx(abs:-294|rel:-13) dy(abs:64|rel:-25)
; node # 40 D(-38,39)->(-62,29)
       fcb 2 ; drawmode 
       fdb -2560,768 ; starx/y relative to previous node
       fdb 64,-13 ; dx/dy. dx(abs:-307|rel:-13) dy(abs:128|rel:64)
; node # 41 D(-42,37)->(-64,30)
       fcb 2 ; drawmode 
       fdb 512,-1024 ; starx/y relative to previous node
       fdb -39,26 ; dx/dy. dx(abs:-281|rel:26) dy(abs:89|rel:-39)
; node # 42 M(-75,16)->(-73,28)
       fcb 0 ; drawmode 
       fdb 5376,-8448 ; starx/y relative to previous node
       fdb -242,306 ; dx/dy. dx(abs:25|rel:306) dy(abs:-153|rel:-242)
; node # 43 D(-91,-17)->(-82,7)
       fcb 2 ; drawmode 
       fdb 8448,-4096 ; starx/y relative to previous node
       fdb -154,90 ; dx/dy. dx(abs:115|rel:90) dy(abs:-307|rel:-154)
; node # 44 M(-61,-15)->(-53,4)
       fcb 0 ; drawmode 
       fdb -512,7680 ; starx/y relative to previous node
       fdb 64,-13 ; dx/dy. dx(abs:102|rel:-13) dy(abs:-243|rel:64)
; node # 45 D(-83,-23)->(-80,-3)
       fcb 2 ; drawmode 
       fdb 2048,-5632 ; starx/y relative to previous node
       fdb -13,-64 ; dx/dy. dx(abs:38|rel:-64) dy(abs:-256|rel:-13)
; node # 46 M(-87,-12)->(-80,8)
       fcb 0 ; drawmode 
       fdb -2816,-1024 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:89|rel:51) dy(abs:-256|rel:0)
; node # 47 D(-89,-15)->(-81,7)
       fcb 2 ; drawmode 
       fdb 768,-512 ; starx/y relative to previous node
       fdb -25,13 ; dx/dy. dx(abs:102|rel:13) dy(abs:-281|rel:-25)
; node # 48 D(-86,-19)->(-80,0)
       fcb 2 ; drawmode 
       fdb 1024,768 ; starx/y relative to previous node
       fdb 38,-26 ; dx/dy. dx(abs:76|rel:-26) dy(abs:-243|rel:38)
; node # 49 D(-87,-12)->(-80,8)
       fcb 2 ; drawmode 
       fdb -1792,-256 ; starx/y relative to previous node
       fdb -13,13 ; dx/dy. dx(abs:89|rel:13) dy(abs:-256|rel:-13)
       fcb  1  ; end of anim
; Animation 9
eliteframe9:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-75,-4)->(-76,10)
       fcb 0 ; drawmode 
       fdb 1024,-19200 ; starx/y relative to previous node
       fdb -179,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-179|rel:-179)
; node # 1 D(-67,10)->(-69,18)
       fcb 2 ; drawmode 
       fdb -3584,2048 ; starx/y relative to previous node
       fdb 77,-13 ; dx/dy. dx(abs:-25|rel:-13) dy(abs:-102|rel:77)
; node # 2 D(-61,31)->(-63,30)
       fcb 2 ; drawmode 
       fdb -5376,1536 ; starx/y relative to previous node
       fdb 114,0 ; dx/dy. dx(abs:-25|rel:0) dy(abs:12|rel:114)
; node # 3 D(-23,23)->(-38,21)
       fcb 2 ; drawmode 
       fdb 2048,9728 ; starx/y relative to previous node
       fdb 13,-167 ; dx/dy. dx(abs:-192|rel:-167) dy(abs:25|rel:13)
; node # 4 D(41,3)->(38,-8)
       fcb 2 ; drawmode 
       fdb 5120,16384 ; starx/y relative to previous node
       fdb 115,154 ; dx/dy. dx(abs:-38|rel:154) dy(abs:140|rel:115)
; node # 5 D(29,-1)->(30,-7)
       fcb 2 ; drawmode 
       fdb 1024,-3072 ; starx/y relative to previous node
       fdb -64,50 ; dx/dy. dx(abs:12|rel:50) dy(abs:76|rel:-64)
; node # 6 D(-53,4)->(-44,13)
       fcb 2 ; drawmode 
       fdb -1280,-20992 ; starx/y relative to previous node
       fdb -191,103 ; dx/dy. dx(abs:115|rel:103) dy(abs:-115|rel:-191)
; node # 7 D(-82,7)->(-83,26)
       fcb 2 ; drawmode 
       fdb -768,-7424 ; starx/y relative to previous node
       fdb -128,-127 ; dx/dy. dx(abs:-12|rel:-127) dy(abs:-243|rel:-128)
; node # 8 D(-80,-3)->(-84,12)
       fcb 2 ; drawmode 
       fdb 2560,512 ; starx/y relative to previous node
       fdb 51,-39 ; dx/dy. dx(abs:-51|rel:-39) dy(abs:-192|rel:51)
; node # 9 D(-75,-3)->(-76,10)
       fcb 2 ; drawmode 
       fdb 0,1280 ; starx/y relative to previous node
       fdb 26,39 ; dx/dy. dx(abs:-12|rel:39) dy(abs:-166|rel:26)
; node # 10 M(-74,3)->(-75,15)
       fcb 0 ; drawmode 
       fdb -1536,256 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-153|rel:13)
; node # 11 D(-71,9)->(-71,21)
       fcb 2 ; drawmode 
       fdb -1536,768 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-153|rel:0)
; node # 12 D(-69,26)->(-67,32)
       fcb 2 ; drawmode 
       fdb -4352,512 ; starx/y relative to previous node
       fdb 77,25 ; dx/dy. dx(abs:25|rel:25) dy(abs:-76|rel:77)
; node # 13 D(-72,25)->(-68,35)
       fcb 2 ; drawmode 
       fdb 256,-768 ; starx/y relative to previous node
       fdb -52,26 ; dx/dy. dx(abs:51|rel:26) dy(abs:-128|rel:-52)
; node # 14 D(-74,3)->(-75,15)
       fcb 2 ; drawmode 
       fdb 5632,-512 ; starx/y relative to previous node
       fdb -25,-63 ; dx/dy. dx(abs:-12|rel:-63) dy(abs:-153|rel:-25)
; node # 15 M(-76,3)->(-75,16)
       fcb 0 ; drawmode 
       fdb 0,-512 ; starx/y relative to previous node
       fdb -13,24 ; dx/dy. dx(abs:12|rel:24) dy(abs:-166|rel:-13)
; node # 16 D(-77,3)->(-79,17)
       fcb 2 ; drawmode 
       fdb 0,-256 ; starx/y relative to previous node
       fdb -13,-37 ; dx/dy. dx(abs:-25|rel:-37) dy(abs:-179|rel:-13)
; node # 17 D(-76,16)->(-73,32)
       fcb 2 ; drawmode 
       fdb -3328,256 ; starx/y relative to previous node
       fdb -25,63 ; dx/dy. dx(abs:38|rel:63) dy(abs:-204|rel:-25)
; node # 18 D(-74,21)->(-69,35)
       fcb 2 ; drawmode 
       fdb -1280,512 ; starx/y relative to previous node
       fdb 25,26 ; dx/dy. dx(abs:64|rel:26) dy(abs:-179|rel:25)
; node # 19 D(-76,3)->(-75,16)
       fcb 2 ; drawmode 
       fdb 4608,-512 ; starx/y relative to previous node
       fdb 13,-52 ; dx/dy. dx(abs:12|rel:-52) dy(abs:-166|rel:13)
; node # 20 M(-75,-4)->(-76,10)
       fcb 0 ; drawmode 
       fdb 1792,256 ; starx/y relative to previous node
       fdb -13,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-179|rel:-13)
; node # 21 D(-41,-9)->(-46,-1)
       fcb 2 ; drawmode 
       fdb 1280,8704 ; starx/y relative to previous node
       fdb 77,-52 ; dx/dy. dx(abs:-64|rel:-52) dy(abs:-102|rel:77)
; node # 22 D(29,-1)->(30,-7)
       fcb 2 ; drawmode 
       fdb -2048,17920 ; starx/y relative to previous node
       fdb 178,76 ; dx/dy. dx(abs:12|rel:76) dy(abs:76|rel:178)
; node # 23 M(50,-2)->(47,-11)
       fcb 0 ; drawmode 
       fdb 256,5376 ; starx/y relative to previous node
       fdb 39,-50 ; dx/dy. dx(abs:-38|rel:-50) dy(abs:115|rel:39)
; node # 24 D(34,1)->(36,-8)
       fcb 2 ; drawmode 
       fdb -768,-4096 ; starx/y relative to previous node
       fdb 0,63 ; dx/dy. dx(abs:25|rel:63) dy(abs:115|rel:0)
; node # 25 M(41,3)->(38,-8)
       fcb 0 ; drawmode 
       fdb -512,1792 ; starx/y relative to previous node
       fdb 25,-63 ; dx/dy. dx(abs:-38|rel:-63) dy(abs:140|rel:25)
; node # 26 D(-41,-9)->(-46,-1)
       fcb 2 ; drawmode 
       fdb 3072,-20992 ; starx/y relative to previous node
       fdb -242,-26 ; dx/dy. dx(abs:-64|rel:-26) dy(abs:-102|rel:-242)
; node # 27 D(-67,10)->(-69,18)
       fcb 2 ; drawmode 
       fdb -4864,-6656 ; starx/y relative to previous node
       fdb 0,39 ; dx/dy. dx(abs:-25|rel:39) dy(abs:-102|rel:0)
; node # 28 D(41,3)->(38,-8)
       fcb 2 ; drawmode 
       fdb 1792,27648 ; starx/y relative to previous node
       fdb 242,-13 ; dx/dy. dx(abs:-38|rel:-13) dy(abs:140|rel:242)
; node # 29 D(-69,33)->(-65,41)
       fcb 2 ; drawmode 
       fdb -7680,-28160 ; starx/y relative to previous node
       fdb -242,89 ; dx/dy. dx(abs:51|rel:89) dy(abs:-102|rel:-242)
; node # 30 D(-73,28)->(-69,41)
       fcb 2 ; drawmode 
       fdb 1280,-1024 ; starx/y relative to previous node
       fdb -64,0 ; dx/dy. dx(abs:51|rel:0) dy(abs:-166|rel:-64)
; node # 31 D(29,-1)->(30,-7)
       fcb 2 ; drawmode 
       fdb 7424,26112 ; starx/y relative to previous node
       fdb 242,-39 ; dx/dy. dx(abs:12|rel:-39) dy(abs:76|rel:242)
; node # 32 D(-80,-3)->(-84,12)
       fcb 2 ; drawmode 
       fdb 512,-27904 ; starx/y relative to previous node
       fdb -268,-63 ; dx/dy. dx(abs:-51|rel:-63) dy(abs:-192|rel:-268)
; node # 33 D(-41,-9)->(-46,-1)
       fcb 2 ; drawmode 
       fdb 1536,9984 ; starx/y relative to previous node
       fdb 90,-13 ; dx/dy. dx(abs:-64|rel:-13) dy(abs:-102|rel:90)
; node # 34 M(-69,33)->(-65,41)
       fcb 0 ; drawmode 
       fdb -10752,-7168 ; starx/y relative to previous node
       fdb 0,115 ; dx/dy. dx(abs:51|rel:115) dy(abs:-102|rel:0)
; node # 35 D(-61,31)->(-63,30)
       fcb 2 ; drawmode 
       fdb 512,2048 ; starx/y relative to previous node
       fdb 114,-76 ; dx/dy. dx(abs:-25|rel:-76) dy(abs:12|rel:114)
; node # 36 M(-23,23)->(-38,21)
       fcb 0 ; drawmode 
       fdb 2048,9728 ; starx/y relative to previous node
       fdb 13,-167 ; dx/dy. dx(abs:-192|rel:-167) dy(abs:25|rel:13)
; node # 37 D(-67,10)->(-69,18)
       fcb 2 ; drawmode 
       fdb 3328,-11264 ; starx/y relative to previous node
       fdb -127,167 ; dx/dy. dx(abs:-25|rel:167) dy(abs:-102|rel:-127)
; node # 38 M(-64,30)->(-64,31)
       fcb 0 ; drawmode 
       fdb -5120,768 ; starx/y relative to previous node
       fdb 90,25 ; dx/dy. dx(abs:0|rel:25) dy(abs:-12|rel:90)
; node # 39 D(-64,24)->(-65,26)
       fcb 2 ; drawmode 
       fdb 1536,0 ; starx/y relative to previous node
       fdb -13,-12 ; dx/dy. dx(abs:-12|rel:-12) dy(abs:-25|rel:-13)
; node # 40 D(-62,29)->(-63,30)
       fcb 2 ; drawmode 
       fdb -1280,512 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-12|rel:13)
; node # 41 D(-64,30)->(-64,31)
       fcb 2 ; drawmode 
       fdb -256,-512 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:0|rel:12) dy(abs:-12|rel:0)
; node # 42 M(-73,28)->(-69,41)
       fcb 0 ; drawmode 
       fdb 512,-2304 ; starx/y relative to previous node
       fdb -154,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:-166|rel:-154)
; node # 43 D(-82,7)->(-83,26)
       fcb 2 ; drawmode 
       fdb 5376,-2304 ; starx/y relative to previous node
       fdb -77,-63 ; dx/dy. dx(abs:-12|rel:-63) dy(abs:-243|rel:-77)
; node # 44 M(-53,4)->(-44,13)
       fcb 0 ; drawmode 
       fdb 768,7424 ; starx/y relative to previous node
       fdb 128,127 ; dx/dy. dx(abs:115|rel:127) dy(abs:-115|rel:128)
; node # 45 D(-80,-3)->(-84,12)
       fcb 2 ; drawmode 
       fdb 1792,-6912 ; starx/y relative to previous node
       fdb -77,-166 ; dx/dy. dx(abs:-51|rel:-166) dy(abs:-192|rel:-77)
; node # 46 M(-80,8)->(-79,28)
       fcb 0 ; drawmode 
       fdb -2816,0 ; starx/y relative to previous node
       fdb -64,63 ; dx/dy. dx(abs:12|rel:63) dy(abs:-256|rel:-64)
; node # 47 D(-81,7)->(-82,26)
       fcb 2 ; drawmode 
       fdb 256,-256 ; starx/y relative to previous node
       fdb 13,-24 ; dx/dy. dx(abs:-12|rel:-24) dy(abs:-243|rel:13)
; node # 48 D(-80,0)->(-83,19)
       fcb 2 ; drawmode 
       fdb 1792,256 ; starx/y relative to previous node
       fdb 0,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:-243|rel:0)
; node # 49 D(-80,8)->(-79,28)
       fcb 2 ; drawmode 
       fdb -2048,0 ; starx/y relative to previous node
       fdb -13,50 ; dx/dy. dx(abs:12|rel:50) dy(abs:-256|rel:-13)
       fcb  1  ; end of anim
; Animation 10
eliteframe10:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-76,10)->(-71,24)
       fcb 0 ; drawmode 
       fdb -2560,-19456 ; starx/y relative to previous node
       fdb -179,64 ; dx/dy. dx(abs:64|rel:64) dy(abs:-179|rel:-179)
; node # 1 D(-69,18)->(-49,37)
       fcb 2 ; drawmode 
       fdb -2048,1792 ; starx/y relative to previous node
       fdb -64,192 ; dx/dy. dx(abs:256|rel:192) dy(abs:-243|rel:-64)
; node # 2 D(-63,30)->(-40,50)
       fcb 2 ; drawmode 
       fdb -3072,1536 ; starx/y relative to previous node
       fdb -13,38 ; dx/dy. dx(abs:294|rel:38) dy(abs:-256|rel:-13)
; node # 3 D(-38,21)->(-19,35)
       fcb 2 ; drawmode 
       fdb 2304,6400 ; starx/y relative to previous node
       fdb 77,-51 ; dx/dy. dx(abs:243|rel:-51) dy(abs:-179|rel:77)
; node # 4 D(38,-8)->(32,-14)
       fcb 2 ; drawmode 
       fdb 7424,19456 ; starx/y relative to previous node
       fdb 255,-319 ; dx/dy. dx(abs:-76|rel:-319) dy(abs:76|rel:255)
; node # 5 D(30,-7)->(19,-17)
       fcb 2 ; drawmode 
       fdb -256,-2048 ; starx/y relative to previous node
       fdb 52,-64 ; dx/dy. dx(abs:-140|rel:-64) dy(abs:128|rel:52)
; node # 6 D(-44,13)->(-64,11)
       fcb 2 ; drawmode 
       fdb -5120,-18944 ; starx/y relative to previous node
       fdb -103,-116 ; dx/dy. dx(abs:-256|rel:-116) dy(abs:25|rel:-103)
; node # 7 D(-83,26)->(-97,29)
       fcb 2 ; drawmode 
       fdb -3328,-9984 ; starx/y relative to previous node
       fdb -63,77 ; dx/dy. dx(abs:-179|rel:77) dy(abs:-38|rel:-63)
; node # 8 D(-84,12)->(-92,20)
       fcb 2 ; drawmode 
       fdb 3584,-256 ; starx/y relative to previous node
       fdb -64,77 ; dx/dy. dx(abs:-102|rel:77) dy(abs:-102|rel:-64)
; node # 9 D(-76,10)->(-71,25)
       fcb 2 ; drawmode 
       fdb 512,2048 ; starx/y relative to previous node
       fdb -90,166 ; dx/dy. dx(abs:64|rel:166) dy(abs:-192|rel:-90)
; node # 10 M(-75,15)->(-67,31)
       fcb 0 ; drawmode 
       fdb -1280,256 ; starx/y relative to previous node
       fdb -12,38 ; dx/dy. dx(abs:102|rel:38) dy(abs:-204|rel:-12)
; node # 11 D(-71,21)->(-57,37)
       fcb 2 ; drawmode 
       fdb -1536,1024 ; starx/y relative to previous node
       fdb 0,77 ; dx/dy. dx(abs:179|rel:77) dy(abs:-204|rel:0)
; node # 12 D(-67,32)->(-52,48)
       fcb 2 ; drawmode 
       fdb -2816,1024 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:192|rel:13) dy(abs:-204|rel:0)
; node # 13 D(-68,35)->(-59,48)
       fcb 2 ; drawmode 
       fdb -768,-256 ; starx/y relative to previous node
       fdb 38,-77 ; dx/dy. dx(abs:115|rel:-77) dy(abs:-166|rel:38)
; node # 14 D(-75,15)->(-67,31)
       fcb 2 ; drawmode 
       fdb 5120,-1792 ; starx/y relative to previous node
       fdb -38,-13 ; dx/dy. dx(abs:102|rel:-13) dy(abs:-204|rel:-38)
; node # 15 M(-75,16)->(-70,30)
       fcb 0 ; drawmode 
       fdb -256,0 ; starx/y relative to previous node
       fdb 25,-38 ; dx/dy. dx(abs:64|rel:-38) dy(abs:-179|rel:25)
; node # 16 D(-79,17)->(-78,28)
       fcb 2 ; drawmode 
       fdb -256,-1024 ; starx/y relative to previous node
       fdb 39,-52 ; dx/dy. dx(abs:12|rel:-52) dy(abs:-140|rel:39)
; node # 17 D(-73,32)->(-73,40)
       fcb 2 ; drawmode 
       fdb -3840,1536 ; starx/y relative to previous node
       fdb 38,-12 ; dx/dy. dx(abs:0|rel:-12) dy(abs:-102|rel:38)
; node # 18 D(-69,35)->(-62,47)
       fcb 2 ; drawmode 
       fdb -768,1024 ; starx/y relative to previous node
       fdb -51,89 ; dx/dy. dx(abs:89|rel:89) dy(abs:-153|rel:-51)
; node # 19 D(-75,16)->(-70,30)
       fcb 2 ; drawmode 
       fdb 4864,-1536 ; starx/y relative to previous node
       fdb -26,-25 ; dx/dy. dx(abs:64|rel:-25) dy(abs:-179|rel:-26)
; node # 20 M(-76,10)->(-71,24)
       fcb 0 ; drawmode 
       fdb 1536,-256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:64|rel:0) dy(abs:-179|rel:0)
; node # 21 D(-46,-1)->(-45,9)
       fcb 2 ; drawmode 
       fdb 2816,7680 ; starx/y relative to previous node
       fdb 51,-52 ; dx/dy. dx(abs:12|rel:-52) dy(abs:-128|rel:51)
; node # 22 D(30,-7)->(19,-17)
       fcb 2 ; drawmode 
       fdb 1536,19456 ; starx/y relative to previous node
       fdb 256,-152 ; dx/dy. dx(abs:-140|rel:-152) dy(abs:128|rel:256)
; node # 23 M(47,-11)->(35,-22)
       fcb 0 ; drawmode 
       fdb 1024,4352 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:-153|rel:-13) dy(abs:140|rel:12)
; node # 24 D(36,-8)->(25,-15)
       fcb 2 ; drawmode 
       fdb -768,-2816 ; starx/y relative to previous node
       fdb -51,13 ; dx/dy. dx(abs:-140|rel:13) dy(abs:89|rel:-51)
; node # 25 M(38,-8)->(32,-14)
       fcb 0 ; drawmode 
       fdb 0,512 ; starx/y relative to previous node
       fdb -13,64 ; dx/dy. dx(abs:-76|rel:64) dy(abs:76|rel:-13)
; node # 26 D(-46,-1)->(-45,9)
       fcb 2 ; drawmode 
       fdb -1792,-21504 ; starx/y relative to previous node
       fdb -204,88 ; dx/dy. dx(abs:12|rel:88) dy(abs:-128|rel:-204)
; node # 27 D(-69,18)->(-49,37)
       fcb 2 ; drawmode 
       fdb -4864,-5888 ; starx/y relative to previous node
       fdb -115,244 ; dx/dy. dx(abs:256|rel:244) dy(abs:-243|rel:-115)
; node # 28 D(38,-8)->(32,-14)
       fcb 2 ; drawmode 
       fdb 6656,27392 ; starx/y relative to previous node
       fdb 319,-332 ; dx/dy. dx(abs:-76|rel:-332) dy(abs:76|rel:319)
; node # 29 D(-65,41)->(-52,54)
       fcb 2 ; drawmode 
       fdb -12544,-26368 ; starx/y relative to previous node
       fdb -242,242 ; dx/dy. dx(abs:166|rel:242) dy(abs:-166|rel:-242)
; node # 30 D(-69,41)->(-63,51)
       fcb 2 ; drawmode 
       fdb 0,-1024 ; starx/y relative to previous node
       fdb 38,-90 ; dx/dy. dx(abs:76|rel:-90) dy(abs:-128|rel:38)
; node # 31 D(30,-7)->(19,-17)
       fcb 2 ; drawmode 
       fdb 12288,25344 ; starx/y relative to previous node
       fdb 256,-216 ; dx/dy. dx(abs:-140|rel:-216) dy(abs:128|rel:256)
; node # 32 D(-84,12)->(-92,20)
       fcb 2 ; drawmode 
       fdb -4864,-29184 ; starx/y relative to previous node
       fdb -230,38 ; dx/dy. dx(abs:-102|rel:38) dy(abs:-102|rel:-230)
; node # 33 D(-46,-1)->(-45,9)
       fcb 2 ; drawmode 
       fdb 3328,9728 ; starx/y relative to previous node
       fdb -26,114 ; dx/dy. dx(abs:12|rel:114) dy(abs:-128|rel:-26)
; node # 34 M(-65,41)->(-52,54)
       fcb 0 ; drawmode 
       fdb -10752,-4864 ; starx/y relative to previous node
       fdb -38,154 ; dx/dy. dx(abs:166|rel:154) dy(abs:-166|rel:-38)
; node # 35 D(-63,30)->(-40,50)
       fcb 2 ; drawmode 
       fdb 2816,512 ; starx/y relative to previous node
       fdb -90,128 ; dx/dy. dx(abs:294|rel:128) dy(abs:-256|rel:-90)
; node # 36 M(-38,21)->(-19,35)
       fcb 0 ; drawmode 
       fdb 2304,6400 ; starx/y relative to previous node
       fdb 77,-51 ; dx/dy. dx(abs:243|rel:-51) dy(abs:-179|rel:77)
; node # 37 D(-69,18)->(-49,37)
       fcb 2 ; drawmode 
       fdb 768,-7936 ; starx/y relative to previous node
       fdb -64,13 ; dx/dy. dx(abs:256|rel:13) dy(abs:-243|rel:-64)
; node # 38 M(-64,31)->(-44,50)
       fcb 0 ; drawmode 
       fdb -3328,1280 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:-243|rel:0)
; node # 39 D(-65,26)->(-45,45)
       fcb 2 ; drawmode 
       fdb 1280,-256 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:-243|rel:0)
; node # 40 D(-63,30)->(-42,49)
       fcb 2 ; drawmode 
       fdb -1024,512 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:268|rel:12) dy(abs:-243|rel:0)
; node # 41 D(-64,31)->(-44,50)
       fcb 2 ; drawmode 
       fdb -256,-256 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:256|rel:-12) dy(abs:-243|rel:0)
; node # 42 M(-69,41)->(-63,51)
       fcb 0 ; drawmode 
       fdb -2560,-1280 ; starx/y relative to previous node
       fdb 115,-180 ; dx/dy. dx(abs:76|rel:-180) dy(abs:-128|rel:115)
; node # 43 D(-83,26)->(-97,29)
       fcb 2 ; drawmode 
       fdb 3840,-3584 ; starx/y relative to previous node
       fdb 90,-255 ; dx/dy. dx(abs:-179|rel:-255) dy(abs:-38|rel:90)
; node # 44 M(-44,13)->(-64,11)
       fcb 0 ; drawmode 
       fdb 3328,9984 ; starx/y relative to previous node
       fdb 63,-77 ; dx/dy. dx(abs:-256|rel:-77) dy(abs:25|rel:63)
; node # 45 D(-84,12)->(-92,20)
       fcb 2 ; drawmode 
       fdb 256,-10240 ; starx/y relative to previous node
       fdb -127,154 ; dx/dy. dx(abs:-102|rel:154) dy(abs:-102|rel:-127)
; node # 46 M(-79,28)->(-89,32)
       fcb 0 ; drawmode 
       fdb -4096,1280 ; starx/y relative to previous node
       fdb 51,-26 ; dx/dy. dx(abs:-128|rel:-26) dy(abs:-51|rel:51)
; node # 47 D(-82,26)->(-93,30)
       fcb 2 ; drawmode 
       fdb 512,-768 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:-140|rel:-12) dy(abs:-51|rel:0)
; node # 48 D(-83,19)->(-91,25)
       fcb 2 ; drawmode 
       fdb 1792,-256 ; starx/y relative to previous node
       fdb -25,38 ; dx/dy. dx(abs:-102|rel:38) dy(abs:-76|rel:-25)
; node # 49 D(-79,28)->(-89,32)
       fcb 2 ; drawmode 
       fdb -2304,1024 ; starx/y relative to previous node
       fdb 25,-26 ; dx/dy. dx(abs:-128|rel:-26) dy(abs:-51|rel:25)
       fcb  1  ; end of anim
; Animation 11
eliteframe11:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-71,24)->(-58,41)
       fcb 0 ; drawmode 
       fdb -6144,-18176 ; starx/y relative to previous node
       fdb -217,166 ; dx/dy. dx(abs:166|rel:166) dy(abs:-217|rel:-217)
; node # 1 D(-49,37)->(-29,54)
       fcb 2 ; drawmode 
       fdb -3328,5632 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:256|rel:90) dy(abs:-217|rel:0)
; node # 2 D(-40,50)->(-13,65)
       fcb 2 ; drawmode 
       fdb -3328,2304 ; starx/y relative to previous node
       fdb 25,89 ; dx/dy. dx(abs:345|rel:89) dy(abs:-192|rel:25)
; node # 3 D(-19,35)->(2,45)
       fcb 2 ; drawmode 
       fdb 3840,5376 ; starx/y relative to previous node
       fdb 64,-77 ; dx/dy. dx(abs:268|rel:-77) dy(abs:-128|rel:64)
; node # 4 D(32,-14)->(28,-23)
       fcb 2 ; drawmode 
       fdb 12544,13056 ; starx/y relative to previous node
       fdb 243,-319 ; dx/dy. dx(abs:-51|rel:-319) dy(abs:115|rel:243)
; node # 5 D(19,-17)->(12,-29)
       fcb 2 ; drawmode 
       fdb 768,-3328 ; starx/y relative to previous node
       fdb 38,-38 ; dx/dy. dx(abs:-89|rel:-38) dy(abs:153|rel:38)
; node # 6 D(-64,11)->(-74,13)
       fcb 2 ; drawmode 
       fdb -7168,-21248 ; starx/y relative to previous node
       fdb -178,-39 ; dx/dy. dx(abs:-128|rel:-39) dy(abs:-25|rel:-178)
; node # 7 D(-97,29)->(-101,38)
       fcb 2 ; drawmode 
       fdb -4608,-8448 ; starx/y relative to previous node
       fdb -90,77 ; dx/dy. dx(abs:-51|rel:77) dy(abs:-115|rel:-90)
; node # 8 D(-92,20)->(-89,34)
       fcb 2 ; drawmode 
       fdb 2304,1280 ; starx/y relative to previous node
       fdb -64,89 ; dx/dy. dx(abs:38|rel:89) dy(abs:-179|rel:-64)
; node # 9 D(-71,25)->(-58,41)
       fcb 2 ; drawmode 
       fdb -1280,5376 ; starx/y relative to previous node
       fdb -25,128 ; dx/dy. dx(abs:166|rel:128) dy(abs:-204|rel:-25)
; node # 10 M(-67,31)->(-53,46)
       fcb 0 ; drawmode 
       fdb -1536,1024 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:179|rel:13) dy(abs:-192|rel:12)
; node # 11 D(-57,37)->(-41,51)
       fcb 2 ; drawmode 
       fdb -1536,2560 ; starx/y relative to previous node
       fdb 13,25 ; dx/dy. dx(abs:204|rel:25) dy(abs:-179|rel:13)
; node # 12 D(-52,48)->(-35,61)
       fcb 2 ; drawmode 
       fdb -2816,1280 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:217|rel:13) dy(abs:-166|rel:13)
; node # 13 D(-59,48)->(-46,59)
       fcb 2 ; drawmode 
       fdb 0,-1792 ; starx/y relative to previous node
       fdb 26,-51 ; dx/dy. dx(abs:166|rel:-51) dy(abs:-140|rel:26)
; node # 14 D(-67,31)->(-53,46)
       fcb 2 ; drawmode 
       fdb 4352,-2048 ; starx/y relative to previous node
       fdb -52,13 ; dx/dy. dx(abs:179|rel:13) dy(abs:-192|rel:-52)
; node # 15 M(-70,30)->(-58,44)
       fcb 0 ; drawmode 
       fdb 256,-768 ; starx/y relative to previous node
       fdb 13,-26 ; dx/dy. dx(abs:153|rel:-26) dy(abs:-179|rel:13)
; node # 16 D(-78,28)->(-71,42)
       fcb 2 ; drawmode 
       fdb 512,-2048 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:89|rel:-64) dy(abs:-179|rel:0)
; node # 17 D(-73,40)->(-65,52)
       fcb 2 ; drawmode 
       fdb -3072,1280 ; starx/y relative to previous node
       fdb 26,13 ; dx/dy. dx(abs:102|rel:13) dy(abs:-153|rel:26)
; node # 18 D(-62,47)->(-50,58)
       fcb 2 ; drawmode 
       fdb -1792,2816 ; starx/y relative to previous node
       fdb 13,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-140|rel:13)
; node # 19 D(-70,30)->(-58,44)
       fcb 2 ; drawmode 
       fdb 4352,-2048 ; starx/y relative to previous node
       fdb -39,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-179|rel:-39)
; node # 20 M(-71,24)->(-58,41)
       fcb 0 ; drawmode 
       fdb 1536,-256 ; starx/y relative to previous node
       fdb -38,13 ; dx/dy. dx(abs:166|rel:13) dy(abs:-217|rel:-38)
; node # 21 D(-45,9)->(-40,18)
       fcb 2 ; drawmode 
       fdb 3840,6656 ; starx/y relative to previous node
       fdb 102,-102 ; dx/dy. dx(abs:64|rel:-102) dy(abs:-115|rel:102)
; node # 22 D(19,-17)->(12,-29)
       fcb 2 ; drawmode 
       fdb 6656,16384 ; starx/y relative to previous node
       fdb 268,-153 ; dx/dy. dx(abs:-89|rel:-153) dy(abs:153|rel:268)
; node # 23 M(35,-22)->(26,-37)
       fcb 0 ; drawmode 
       fdb 1280,4096 ; starx/y relative to previous node
       fdb 39,-26 ; dx/dy. dx(abs:-115|rel:-26) dy(abs:192|rel:39)
; node # 24 D(25,-15)->(19,-26)
       fcb 2 ; drawmode 
       fdb -1792,-2560 ; starx/y relative to previous node
       fdb -52,39 ; dx/dy. dx(abs:-76|rel:39) dy(abs:140|rel:-52)
; node # 25 M(32,-14)->(28,-23)
       fcb 0 ; drawmode 
       fdb -256,1792 ; starx/y relative to previous node
       fdb -25,25 ; dx/dy. dx(abs:-51|rel:25) dy(abs:115|rel:-25)
; node # 26 D(-45,9)->(-40,18)
       fcb 2 ; drawmode 
       fdb -5888,-19712 ; starx/y relative to previous node
       fdb -230,115 ; dx/dy. dx(abs:64|rel:115) dy(abs:-115|rel:-230)
; node # 27 D(-49,37)->(-29,54)
       fcb 2 ; drawmode 
       fdb -7168,-1024 ; starx/y relative to previous node
       fdb -102,192 ; dx/dy. dx(abs:256|rel:192) dy(abs:-217|rel:-102)
; node # 28 D(32,-14)->(28,-23)
       fcb 2 ; drawmode 
       fdb 13056,20736 ; starx/y relative to previous node
       fdb 332,-307 ; dx/dy. dx(abs:-51|rel:-307) dy(abs:115|rel:332)
; node # 29 D(-52,54)->(-37,65)
       fcb 2 ; drawmode 
       fdb -17408,-21504 ; starx/y relative to previous node
       fdb -255,243 ; dx/dy. dx(abs:192|rel:243) dy(abs:-140|rel:-255)
; node # 30 D(-63,51)->(-55,60)
       fcb 2 ; drawmode 
       fdb 768,-2816 ; starx/y relative to previous node
       fdb 25,-90 ; dx/dy. dx(abs:102|rel:-90) dy(abs:-115|rel:25)
; node # 31 D(19,-17)->(12,-29)
       fcb 2 ; drawmode 
       fdb 17408,20992 ; starx/y relative to previous node
       fdb 268,-191 ; dx/dy. dx(abs:-89|rel:-191) dy(abs:153|rel:268)
; node # 32 D(-92,20)->(-89,34)
       fcb 2 ; drawmode 
       fdb -9472,-28416 ; starx/y relative to previous node
       fdb -332,127 ; dx/dy. dx(abs:38|rel:127) dy(abs:-179|rel:-332)
; node # 33 D(-45,9)->(-40,18)
       fcb 2 ; drawmode 
       fdb 2816,12032 ; starx/y relative to previous node
       fdb 64,26 ; dx/dy. dx(abs:64|rel:26) dy(abs:-115|rel:64)
; node # 34 M(-52,54)->(-37,65)
       fcb 0 ; drawmode 
       fdb -11520,-1792 ; starx/y relative to previous node
       fdb -25,128 ; dx/dy. dx(abs:192|rel:128) dy(abs:-140|rel:-25)
; node # 35 D(-40,50)->(-13,65)
       fcb 2 ; drawmode 
       fdb 1024,3072 ; starx/y relative to previous node
       fdb -52,153 ; dx/dy. dx(abs:345|rel:153) dy(abs:-192|rel:-52)
; node # 36 M(-19,35)->(2,45)
       fcb 0 ; drawmode 
       fdb 3840,5376 ; starx/y relative to previous node
       fdb 64,-77 ; dx/dy. dx(abs:268|rel:-77) dy(abs:-128|rel:64)
; node # 37 D(-49,37)->(-29,54)
       fcb 2 ; drawmode 
       fdb -512,-7680 ; starx/y relative to previous node
       fdb -89,-12 ; dx/dy. dx(abs:256|rel:-12) dy(abs:-217|rel:-89)
; node # 38 M(-44,50)->(-20,64)
       fcb 0 ; drawmode 
       fdb -3328,1280 ; starx/y relative to previous node
       fdb 38,51 ; dx/dy. dx(abs:307|rel:51) dy(abs:-179|rel:38)
; node # 39 D(-45,45)->(-22,60)
       fcb 2 ; drawmode 
       fdb 1280,-256 ; starx/y relative to previous node
       fdb -13,-13 ; dx/dy. dx(abs:294|rel:-13) dy(abs:-192|rel:-13)
; node # 40 D(-42,49)->(-16,64)
       fcb 2 ; drawmode 
       fdb -1024,768 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:332|rel:38) dy(abs:-192|rel:0)
; node # 41 D(-44,50)->(-20,64)
       fcb 2 ; drawmode 
       fdb -256,-512 ; starx/y relative to previous node
       fdb 13,-25 ; dx/dy. dx(abs:307|rel:-25) dy(abs:-179|rel:13)
; node # 42 M(-64,51)->(-55,60)
       fcb 0 ; drawmode 
       fdb -256,-5120 ; starx/y relative to previous node
       fdb 64,-192 ; dx/dy. dx(abs:115|rel:-192) dy(abs:-115|rel:64)
; node # 43 D(-97,29)->(-101,38)
       fcb 2 ; drawmode 
       fdb 5632,-8448 ; starx/y relative to previous node
       fdb 0,-166 ; dx/dy. dx(abs:-51|rel:-166) dy(abs:-115|rel:0)
; node # 44 M(-64,11)->(-74,13)
       fcb 0 ; drawmode 
       fdb 4608,8448 ; starx/y relative to previous node
       fdb 90,-77 ; dx/dy. dx(abs:-128|rel:-77) dy(abs:-25|rel:90)
; node # 45 D(-92,20)->(-89,34)
       fcb 2 ; drawmode 
       fdb -2304,-7168 ; starx/y relative to previous node
       fdb -154,166 ; dx/dy. dx(abs:38|rel:166) dy(abs:-179|rel:-154)
; node # 46 M(-89,32)->(-90,42)
       fcb 0 ; drawmode 
       fdb -3072,768 ; starx/y relative to previous node
       fdb 51,-50 ; dx/dy. dx(abs:-12|rel:-50) dy(abs:-128|rel:51)
; node # 47 D(-93,30)->(-96,39)
       fcb 2 ; drawmode 
       fdb 512,-1024 ; starx/y relative to previous node
       fdb 13,-26 ; dx/dy. dx(abs:-38|rel:-26) dy(abs:-115|rel:13)
; node # 48 D(-91,25)->(-92,36)
       fcb 2 ; drawmode 
       fdb 1280,512 ; starx/y relative to previous node
       fdb -25,26 ; dx/dy. dx(abs:-12|rel:26) dy(abs:-140|rel:-25)
; node # 49 D(-89,32)->(-90,42)
       fcb 2 ; drawmode 
       fdb -1792,512 ; starx/y relative to previous node
       fdb 12,0 ; dx/dy. dx(abs:-12|rel:0) dy(abs:-128|rel:12)
       fcb  1  ; end of anim
; Animation 12
eliteframe12:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-58,41)->(-42,54)
       fcb 0 ; drawmode 
       fdb -10496,-14848 ; starx/y relative to previous node
       fdb -166,204 ; dx/dy. dx(abs:204|rel:204) dy(abs:-166|rel:-166)
; node # 1 D(-29,54)->(-3,66)
       fcb 2 ; drawmode 
       fdb -3328,7424 ; starx/y relative to previous node
       fdb 13,128 ; dx/dy. dx(abs:332|rel:128) dy(abs:-153|rel:13)
; node # 2 D(-13,65)->(15,74)
       fcb 2 ; drawmode 
       fdb -2816,4096 ; starx/y relative to previous node
       fdb 38,26 ; dx/dy. dx(abs:358|rel:26) dy(abs:-115|rel:38)
; node # 3 D(2,45)->(22,48)
       fcb 2 ; drawmode 
       fdb 5120,3840 ; starx/y relative to previous node
       fdb 77,-102 ; dx/dy. dx(abs:256|rel:-102) dy(abs:-38|rel:77)
; node # 4 D(28,-23)->(18,-32)
       fcb 2 ; drawmode 
       fdb 17408,6656 ; starx/y relative to previous node
       fdb 153,-384 ; dx/dy. dx(abs:-128|rel:-384) dy(abs:115|rel:153)
; node # 5 D(12,-29)->(-5,-38)
       fcb 2 ; drawmode 
       fdb 1536,-4096 ; starx/y relative to previous node
       fdb 0,-89 ; dx/dy. dx(abs:-217|rel:-89) dy(abs:115|rel:0)
; node # 6 D(-74,13)->(-80,22)
       fcb 2 ; drawmode 
       fdb -10752,-22016 ; starx/y relative to previous node
       fdb -230,141 ; dx/dy. dx(abs:-76|rel:141) dy(abs:-115|rel:-230)
; node # 7 D(-101,38)->(-97,51)
       fcb 2 ; drawmode 
       fdb -6400,-6912 ; starx/y relative to previous node
       fdb -51,127 ; dx/dy. dx(abs:51|rel:127) dy(abs:-166|rel:-51)
; node # 8 D(-89,34)->(-80,49)
       fcb 2 ; drawmode 
       fdb 1024,3072 ; starx/y relative to previous node
       fdb -26,64 ; dx/dy. dx(abs:115|rel:64) dy(abs:-192|rel:-26)
; node # 9 D(-58,41)->(-42,54)
       fcb 2 ; drawmode 
       fdb -1792,7936 ; starx/y relative to previous node
       fdb 26,89 ; dx/dy. dx(abs:204|rel:89) dy(abs:-166|rel:26)
; node # 10 M(-53,46)->(-37,58)
       fcb 0 ; drawmode 
       fdb -1280,1280 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:-153|rel:13)
; node # 11 D(-41,51)->(-20,63)
       fcb 2 ; drawmode 
       fdb -1280,3072 ; starx/y relative to previous node
       fdb 0,64 ; dx/dy. dx(abs:268|rel:64) dy(abs:-153|rel:0)
; node # 12 D(-35,61)->(-16,70)
       fcb 2 ; drawmode 
       fdb -2560,1536 ; starx/y relative to previous node
       fdb 38,-25 ; dx/dy. dx(abs:243|rel:-25) dy(abs:-115|rel:38)
; node # 13 D(-46,59)->(-31,68)
       fcb 2 ; drawmode 
       fdb 512,-2816 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:192|rel:-51) dy(abs:-115|rel:0)
; node # 14 D(-53,46)->(-37,58)
       fcb 2 ; drawmode 
       fdb 3328,-1792 ; starx/y relative to previous node
       fdb -38,12 ; dx/dy. dx(abs:204|rel:12) dy(abs:-153|rel:-38)
; node # 15 M(-58,44)->(-43,57)
       fcb 0 ; drawmode 
       fdb 512,-1280 ; starx/y relative to previous node
       fdb -13,-12 ; dx/dy. dx(abs:192|rel:-12) dy(abs:-166|rel:-13)
; node # 16 D(-71,42)->(-59,55)
       fcb 2 ; drawmode 
       fdb 512,-3328 ; starx/y relative to previous node
       fdb 0,-39 ; dx/dy. dx(abs:153|rel:-39) dy(abs:-166|rel:0)
; node # 17 D(-65,52)->(-55,62)
       fcb 2 ; drawmode 
       fdb -2560,1536 ; starx/y relative to previous node
       fdb 38,-25 ; dx/dy. dx(abs:128|rel:-25) dy(abs:-128|rel:38)
; node # 18 D(-50,58)->(-37,67)
       fcb 2 ; drawmode 
       fdb -1536,3840 ; starx/y relative to previous node
       fdb 13,38 ; dx/dy. dx(abs:166|rel:38) dy(abs:-115|rel:13)
; node # 19 D(-58,44)->(-43,57)
       fcb 2 ; drawmode 
       fdb 3584,-2048 ; starx/y relative to previous node
       fdb -51,26 ; dx/dy. dx(abs:192|rel:26) dy(abs:-166|rel:-51)
; node # 20 M(-58,41)->(-42,54)
       fcb 0 ; drawmode 
       fdb 768,0 ; starx/y relative to previous node
       fdb 0,12 ; dx/dy. dx(abs:204|rel:12) dy(abs:-166|rel:0)
; node # 21 D(-40,18)->(-30,27)
       fcb 2 ; drawmode 
       fdb 5888,4608 ; starx/y relative to previous node
       fdb 51,-76 ; dx/dy. dx(abs:128|rel:-76) dy(abs:-115|rel:51)
; node # 22 D(12,-29)->(-5,-38)
       fcb 2 ; drawmode 
       fdb 12032,13312 ; starx/y relative to previous node
       fdb 230,-345 ; dx/dy. dx(abs:-217|rel:-345) dy(abs:115|rel:230)
; node # 23 M(26,-37)->(11,-51)
       fcb 0 ; drawmode 
       fdb 2048,3584 ; starx/y relative to previous node
       fdb 64,25 ; dx/dy. dx(abs:-192|rel:25) dy(abs:179|rel:64)
; node # 24 D(19,-26)->(6,-35)
       fcb 2 ; drawmode 
       fdb -2816,-1792 ; starx/y relative to previous node
       fdb -64,26 ; dx/dy. dx(abs:-166|rel:26) dy(abs:115|rel:-64)
; node # 25 M(28,-23)->(18,-32)
       fcb 0 ; drawmode 
       fdb -768,2304 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:-128|rel:38) dy(abs:115|rel:0)
; node # 26 D(-40,18)->(-30,27)
       fcb 2 ; drawmode 
       fdb -10496,-17408 ; starx/y relative to previous node
       fdb -230,256 ; dx/dy. dx(abs:128|rel:256) dy(abs:-115|rel:-230)
; node # 27 D(-29,54)->(-3,66)
       fcb 2 ; drawmode 
       fdb -9216,2816 ; starx/y relative to previous node
       fdb -38,204 ; dx/dy. dx(abs:332|rel:204) dy(abs:-153|rel:-38)
; node # 28 D(28,-23)->(18,-32)
       fcb 2 ; drawmode 
       fdb 19712,14592 ; starx/y relative to previous node
       fdb 268,-460 ; dx/dy. dx(abs:-128|rel:-460) dy(abs:115|rel:268)
; node # 29 D(-37,65)->(-21,73)
       fcb 2 ; drawmode 
       fdb -22528,-16640 ; starx/y relative to previous node
       fdb -217,332 ; dx/dy. dx(abs:204|rel:332) dy(abs:-102|rel:-217)
; node # 30 D(-55,60)->(-44,68)
       fcb 2 ; drawmode 
       fdb 1280,-4608 ; starx/y relative to previous node
       fdb 0,-64 ; dx/dy. dx(abs:140|rel:-64) dy(abs:-102|rel:0)
; node # 31 D(12,-29)->(-5,-38)
       fcb 2 ; drawmode 
       fdb 22784,17152 ; starx/y relative to previous node
       fdb 217,-357 ; dx/dy. dx(abs:-217|rel:-357) dy(abs:115|rel:217)
; node # 32 D(-89,34)->(-80,49)
       fcb 2 ; drawmode 
       fdb -16128,-25856 ; starx/y relative to previous node
       fdb -307,332 ; dx/dy. dx(abs:115|rel:332) dy(abs:-192|rel:-307)
; node # 33 D(-40,18)->(-30,27)
       fcb 2 ; drawmode 
       fdb 4096,12544 ; starx/y relative to previous node
       fdb 77,13 ; dx/dy. dx(abs:128|rel:13) dy(abs:-115|rel:77)
; node # 34 M(-37,65)->(-21,73)
       fcb 0 ; drawmode 
       fdb -12032,768 ; starx/y relative to previous node
       fdb 13,76 ; dx/dy. dx(abs:204|rel:76) dy(abs:-102|rel:13)
; node # 35 D(-13,65)->(15,74)
       fcb 2 ; drawmode 
       fdb 0,6144 ; starx/y relative to previous node
       fdb -13,154 ; dx/dy. dx(abs:358|rel:154) dy(abs:-115|rel:-13)
; node # 36 M(2,45)->(22,48)
       fcb 0 ; drawmode 
       fdb 5120,3840 ; starx/y relative to previous node
       fdb 77,-102 ; dx/dy. dx(abs:256|rel:-102) dy(abs:-38|rel:77)
; node # 37 D(-29,54)->(-3,66)
       fcb 2 ; drawmode 
       fdb -2304,-7936 ; starx/y relative to previous node
       fdb -115,76 ; dx/dy. dx(abs:332|rel:76) dy(abs:-153|rel:-115)
; node # 38 M(-20,64)->(5,73)
       fcb 0 ; drawmode 
       fdb -2560,2304 ; starx/y relative to previous node
       fdb 38,-12 ; dx/dy. dx(abs:320|rel:-12) dy(abs:-115|rel:38)
; node # 39 D(-22,60)->(2,69)
       fcb 2 ; drawmode 
       fdb 1024,-512 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:307|rel:-13) dy(abs:-115|rel:0)
; node # 40 D(-16,64)->(10,73)
       fcb 2 ; drawmode 
       fdb -1024,1536 ; starx/y relative to previous node
       fdb 0,25 ; dx/dy. dx(abs:332|rel:25) dy(abs:-115|rel:0)
; node # 41 D(-20,64)->(5,73)
       fcb 2 ; drawmode 
       fdb 0,-1024 ; starx/y relative to previous node
       fdb 0,-12 ; dx/dy. dx(abs:320|rel:-12) dy(abs:-115|rel:0)
; node # 42 M(-55,60)->(-44,68)
       fcb 0 ; drawmode 
       fdb 1024,-8960 ; starx/y relative to previous node
       fdb 13,-180 ; dx/dy. dx(abs:140|rel:-180) dy(abs:-102|rel:13)
; node # 43 D(-101,38)->(-97,51)
       fcb 2 ; drawmode 
       fdb 5632,-11776 ; starx/y relative to previous node
       fdb -64,-89 ; dx/dy. dx(abs:51|rel:-89) dy(abs:-166|rel:-64)
; node # 44 M(-74,13)->(-80,22)
       fcb 0 ; drawmode 
       fdb 6400,6912 ; starx/y relative to previous node
       fdb 51,-127 ; dx/dy. dx(abs:-76|rel:-127) dy(abs:-115|rel:51)
; node # 45 D(-89,34)->(-80,49)
       fcb 2 ; drawmode 
       fdb -5376,-3840 ; starx/y relative to previous node
       fdb -77,191 ; dx/dy. dx(abs:115|rel:191) dy(abs:-192|rel:-77)
; node # 46 M(-90,42)->(-84,54)
       fcb 0 ; drawmode 
       fdb -2048,-256 ; starx/y relative to previous node
       fdb 39,-39 ; dx/dy. dx(abs:76|rel:-39) dy(abs:-153|rel:39)
; node # 47 D(-96,39)->(-90,52)
       fcb 2 ; drawmode 
       fdb 768,-1536 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:76|rel:0) dy(abs:-166|rel:-13)
; node # 48 D(-92,36)->(-84,50)
       fcb 2 ; drawmode 
       fdb 768,1024 ; starx/y relative to previous node
       fdb -13,26 ; dx/dy. dx(abs:102|rel:26) dy(abs:-179|rel:-13)
; node # 49 D(-90,42)->(-84,54)
       fcb 2 ; drawmode 
       fdb -1536,512 ; starx/y relative to previous node
       fdb 26,-26 ; dx/dy. dx(abs:76|rel:-26) dy(abs:-153|rel:26)
       fcb  1  ; end of anim
; Animation 13
eliteframe13:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-42,54)->(-20,65)
       fcb 0 ; drawmode 
       fdb -13824,-10752 ; starx/y relative to previous node
       fdb -140,281 ; dx/dy. dx(abs:281|rel:281) dy(abs:-140|rel:-140)
; node # 1 D(-3,66)->(23,71)
       fcb 2 ; drawmode 
       fdb -3072,9984 ; starx/y relative to previous node
       fdb 76,51 ; dx/dy. dx(abs:332|rel:51) dy(abs:-64|rel:76)
; node # 2 D(15,74)->(44,76)
       fcb 2 ; drawmode 
       fdb -2048,4608 ; starx/y relative to previous node
       fdb 39,39 ; dx/dy. dx(abs:371|rel:39) dy(abs:-25|rel:39)
; node # 3 D(22,48)->(43,45)
       fcb 2 ; drawmode 
       fdb 6656,1792 ; starx/y relative to previous node
       fdb 63,-103 ; dx/dy. dx(abs:268|rel:-103) dy(abs:38|rel:63)
; node # 4 D(18,-32)->(10,-38)
       fcb 2 ; drawmode 
       fdb 20480,-1024 ; starx/y relative to previous node
       fdb 38,-370 ; dx/dy. dx(abs:-102|rel:-370) dy(abs:76|rel:38)
; node # 5 D(-5,-38)->(-15,-42)
       fcb 2 ; drawmode 
       fdb 1536,-5888 ; starx/y relative to previous node
       fdb -25,-26 ; dx/dy. dx(abs:-128|rel:-26) dy(abs:51|rel:-25)
; node # 6 D(-80,22)->(-73,32)
       fcb 2 ; drawmode 
       fdb -15360,-19200 ; starx/y relative to previous node
       fdb -179,217 ; dx/dy. dx(abs:89|rel:217) dy(abs:-128|rel:-179)
; node # 7 D(-97,51)->(-84,65)
       fcb 2 ; drawmode 
       fdb -7424,-4352 ; starx/y relative to previous node
       fdb -51,77 ; dx/dy. dx(abs:166|rel:77) dy(abs:-179|rel:-51)
; node # 8 D(-80,49)->(-64,63)
       fcb 2 ; drawmode 
       fdb 512,4352 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:204|rel:38) dy(abs:-179|rel:0)
; node # 9 D(-42,54)->(-20,65)
       fcb 2 ; drawmode 
       fdb -1280,9728 ; starx/y relative to previous node
       fdb 39,77 ; dx/dy. dx(abs:281|rel:77) dy(abs:-140|rel:39)
; node # 10 M(-37,58)->(-16,67)
       fcb 0 ; drawmode 
       fdb -1024,1280 ; starx/y relative to previous node
       fdb 25,-13 ; dx/dy. dx(abs:268|rel:-13) dy(abs:-115|rel:25)
; node # 11 D(-20,63)->(3,70)
       fcb 2 ; drawmode 
       fdb -1280,4352 ; starx/y relative to previous node
       fdb 26,26 ; dx/dy. dx(abs:294|rel:26) dy(abs:-89|rel:26)
; node # 12 D(-16,70)->(4,74)
       fcb 2 ; drawmode 
       fdb -1792,1024 ; starx/y relative to previous node
       fdb 38,-38 ; dx/dy. dx(abs:256|rel:-38) dy(abs:-51|rel:38)
; node # 13 D(-31,68)->(-13,74)
       fcb 2 ; drawmode 
       fdb 512,-3840 ; starx/y relative to previous node
       fdb -25,-26 ; dx/dy. dx(abs:230|rel:-26) dy(abs:-76|rel:-25)
; node # 14 D(-37,58)->(-16,67)
       fcb 2 ; drawmode 
       fdb 2560,-1536 ; starx/y relative to previous node
       fdb -39,38 ; dx/dy. dx(abs:268|rel:38) dy(abs:-115|rel:-39)
; node # 15 M(-43,57)->(-22,67)
       fcb 0 ; drawmode 
       fdb 256,-1536 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:268|rel:0) dy(abs:-128|rel:-13)
; node # 16 D(-59,55)->(-41,66)
       fcb 2 ; drawmode 
       fdb 512,-4096 ; starx/y relative to previous node
       fdb -12,-38 ; dx/dy. dx(abs:230|rel:-38) dy(abs:-140|rel:-12)
; node # 17 D(-55,62)->(-40,70)
       fcb 2 ; drawmode 
       fdb -1792,1024 ; starx/y relative to previous node
       fdb 38,-38 ; dx/dy. dx(abs:192|rel:-38) dy(abs:-102|rel:38)
; node # 18 D(-37,67)->(-20,73)
       fcb 2 ; drawmode 
       fdb -1280,4608 ; starx/y relative to previous node
       fdb 26,25 ; dx/dy. dx(abs:217|rel:25) dy(abs:-76|rel:26)
; node # 19 D(-43,57)->(-22,67)
       fcb 2 ; drawmode 
       fdb 2560,-1536 ; starx/y relative to previous node
       fdb -52,51 ; dx/dy. dx(abs:268|rel:51) dy(abs:-128|rel:-52)
; node # 20 M(-42,54)->(-20,65)
       fcb 0 ; drawmode 
       fdb 768,256 ; starx/y relative to previous node
       fdb -12,13 ; dx/dy. dx(abs:281|rel:13) dy(abs:-140|rel:-12)
; node # 21 D(-30,27)->(-16,35)
       fcb 2 ; drawmode 
       fdb 6912,3072 ; starx/y relative to previous node
       fdb 38,-102 ; dx/dy. dx(abs:179|rel:-102) dy(abs:-102|rel:38)
; node # 22 D(-5,-38)->(-15,-42)
       fcb 2 ; drawmode 
       fdb 16640,6400 ; starx/y relative to previous node
       fdb 153,-307 ; dx/dy. dx(abs:-128|rel:-307) dy(abs:51|rel:153)
; node # 23 M(11,-51)->(0,-59)
       fcb 0 ; drawmode 
       fdb 3328,4096 ; starx/y relative to previous node
       fdb 51,-12 ; dx/dy. dx(abs:-140|rel:-12) dy(abs:102|rel:51)
; node # 24 D(6,-35)->(-3,-40)
       fcb 2 ; drawmode 
       fdb -4096,-1280 ; starx/y relative to previous node
       fdb -38,25 ; dx/dy. dx(abs:-115|rel:25) dy(abs:64|rel:-38)
; node # 25 M(18,-32)->(10,-38)
       fcb 0 ; drawmode 
       fdb -768,3072 ; starx/y relative to previous node
       fdb 12,13 ; dx/dy. dx(abs:-102|rel:13) dy(abs:76|rel:12)
; node # 26 D(-30,27)->(-16,35)
       fcb 2 ; drawmode 
       fdb -15104,-12288 ; starx/y relative to previous node
       fdb -178,281 ; dx/dy. dx(abs:179|rel:281) dy(abs:-102|rel:-178)
; node # 27 D(-3,66)->(23,71)
       fcb 2 ; drawmode 
       fdb -9984,6912 ; starx/y relative to previous node
       fdb 38,153 ; dx/dy. dx(abs:332|rel:153) dy(abs:-64|rel:38)
; node # 28 D(18,-32)->(10,-38)
       fcb 2 ; drawmode 
       fdb 25088,5376 ; starx/y relative to previous node
       fdb 140,-434 ; dx/dy. dx(abs:-102|rel:-434) dy(abs:76|rel:140)
; node # 29 D(-21,73)->(-3,76)
       fcb 2 ; drawmode 
       fdb -26880,-9984 ; starx/y relative to previous node
       fdb -114,332 ; dx/dy. dx(abs:230|rel:332) dy(abs:-38|rel:-114)
; node # 30 D(-44,68)->(-29,74)
       fcb 2 ; drawmode 
       fdb 1280,-5888 ; starx/y relative to previous node
       fdb -38,-38 ; dx/dy. dx(abs:192|rel:-38) dy(abs:-76|rel:-38)
; node # 31 D(-5,-38)->(-15,-42)
       fcb 2 ; drawmode 
       fdb 27136,9984 ; starx/y relative to previous node
       fdb 127,-320 ; dx/dy. dx(abs:-128|rel:-320) dy(abs:51|rel:127)
; node # 32 D(-80,49)->(-64,63)
       fcb 2 ; drawmode 
       fdb -22272,-19200 ; starx/y relative to previous node
       fdb -230,332 ; dx/dy. dx(abs:204|rel:332) dy(abs:-179|rel:-230)
; node # 33 D(-30,27)->(-16,35)
       fcb 2 ; drawmode 
       fdb 5632,12800 ; starx/y relative to previous node
       fdb 77,-25 ; dx/dy. dx(abs:179|rel:-25) dy(abs:-102|rel:77)
; node # 34 M(-21,73)->(-3,76)
       fcb 0 ; drawmode 
       fdb -11776,2304 ; starx/y relative to previous node
       fdb 64,51 ; dx/dy. dx(abs:230|rel:51) dy(abs:-38|rel:64)
; node # 35 D(15,74)->(44,76)
       fcb 2 ; drawmode 
       fdb -256,9216 ; starx/y relative to previous node
       fdb 13,141 ; dx/dy. dx(abs:371|rel:141) dy(abs:-25|rel:13)
; node # 36 M(22,48)->(43,45)
       fcb 0 ; drawmode 
       fdb 6656,1792 ; starx/y relative to previous node
       fdb 63,-103 ; dx/dy. dx(abs:268|rel:-103) dy(abs:38|rel:63)
; node # 37 D(-3,66)->(23,71)
       fcb 2 ; drawmode 
       fdb -4608,-6400 ; starx/y relative to previous node
       fdb -102,64 ; dx/dy. dx(abs:332|rel:64) dy(abs:-64|rel:-102)
; node # 38 M(5,73)->(32,76)
       fcb 0 ; drawmode 
       fdb -1792,2048 ; starx/y relative to previous node
       fdb 26,13 ; dx/dy. dx(abs:345|rel:13) dy(abs:-38|rel:26)
; node # 39 D(2,69)->(30,74)
       fcb 2 ; drawmode 
       fdb 1024,-768 ; starx/y relative to previous node
       fdb -26,13 ; dx/dy. dx(abs:358|rel:13) dy(abs:-64|rel:-26)
; node # 40 D(10,73)->(37,75)
       fcb 2 ; drawmode 
       fdb -1024,2048 ; starx/y relative to previous node
       fdb 39,-13 ; dx/dy. dx(abs:345|rel:-13) dy(abs:-25|rel:39)
; node # 41 D(5,73)->(32,76)
       fcb 2 ; drawmode 
       fdb 0,-1280 ; starx/y relative to previous node
       fdb -13,0 ; dx/dy. dx(abs:345|rel:0) dy(abs:-38|rel:-13)
; node # 42 M(-44,68)->(-29,74)
       fcb 0 ; drawmode 
       fdb 1280,-12544 ; starx/y relative to previous node
       fdb -38,-153 ; dx/dy. dx(abs:192|rel:-153) dy(abs:-76|rel:-38)
; node # 43 D(-97,51)->(-84,65)
       fcb 2 ; drawmode 
       fdb 4352,-13568 ; starx/y relative to previous node
       fdb -103,-26 ; dx/dy. dx(abs:166|rel:-26) dy(abs:-179|rel:-103)
; node # 44 M(-80,22)->(-73,32)
       fcb 0 ; drawmode 
       fdb 7424,4352 ; starx/y relative to previous node
       fdb 51,-77 ; dx/dy. dx(abs:89|rel:-77) dy(abs:-128|rel:51)
; node # 45 D(-80,49)->(-64,63)
       fcb 2 ; drawmode 
       fdb -6912,0 ; starx/y relative to previous node
       fdb -51,115 ; dx/dy. dx(abs:204|rel:115) dy(abs:-179|rel:-51)
; node # 46 M(-84,54)->(-70,67)
       fcb 0 ; drawmode 
       fdb -1280,-1024 ; starx/y relative to previous node
       fdb 13,-25 ; dx/dy. dx(abs:179|rel:-25) dy(abs:-166|rel:13)
; node # 47 D(-90,52)->(-77,65)
       fcb 2 ; drawmode 
       fdb 512,-1536 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:166|rel:-13) dy(abs:-166|rel:0)
; node # 48 D(-84,50)->(-69,64)
       fcb 2 ; drawmode 
       fdb 512,1536 ; starx/y relative to previous node
       fdb -13,26 ; dx/dy. dx(abs:192|rel:26) dy(abs:-179|rel:-13)
; node # 49 D(-84,54)->(-70,67)
       fcb 2 ; drawmode 
       fdb -1024,0 ; starx/y relative to previous node
       fdb 13,-13 ; dx/dy. dx(abs:179|rel:-13) dy(abs:-166|rel:13)
       fcb  1  ; end of anim
; Animation 14
eliteframe14:
       fcb 20 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-20,65)->(0,76)
       fcb 0 ; drawmode 
       fdb -16640,-5120 ; starx/y relative to previous node
       fdb -140,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:-140|rel:-140)
; node # 1 D(23,71)->(50,77)
       fcb 2 ; drawmode 
       fdb -1536,11008 ; starx/y relative to previous node
       fdb 64,89 ; dx/dy. dx(abs:345|rel:89) dy(abs:-76|rel:64)
; node # 2 D(44,76)->(73,81)
       fcb 2 ; drawmode 
       fdb -1280,5376 ; starx/y relative to previous node
       fdb 12,26 ; dx/dy. dx(abs:371|rel:26) dy(abs:-64|rel:12)
; node # 3 D(43,45)->(66,44)
       fcb 2 ; drawmode 
       fdb 7936,-256 ; starx/y relative to previous node
       fdb 76,-77 ; dx/dy. dx(abs:294|rel:-77) dy(abs:12|rel:76)
; node # 4 D(10,-38)->(15,-44)
       fcb 2 ; drawmode 
       fdb 21248,-8448 ; starx/y relative to previous node
       fdb 64,-230 ; dx/dy. dx(abs:64|rel:-230) dy(abs:76|rel:64)
; node # 5 D(-15,-42)->(-15,-44)
       fcb 2 ; drawmode 
       fdb 1024,-6400 ; starx/y relative to previous node
       fdb -51,-64 ; dx/dy. dx(abs:0|rel:-64) dy(abs:25|rel:-51)
; node # 6 D(-73,32)->(-67,44)
       fcb 2 ; drawmode 
       fdb -18944,-14848 ; starx/y relative to previous node
       fdb -178,76 ; dx/dy. dx(abs:76|rel:76) dy(abs:-153|rel:-178)
; node # 7 D(-84,65)->(-73,80)
       fcb 2 ; drawmode 
       fdb -8448,-2816 ; starx/y relative to previous node
       fdb -39,64 ; dx/dy. dx(abs:140|rel:64) dy(abs:-192|rel:-39)
; node # 8 D(-64,63)->(-50,77)
       fcb 2 ; drawmode 
       fdb 512,5120 ; starx/y relative to previous node
       fdb 13,39 ; dx/dy. dx(abs:179|rel:39) dy(abs:-179|rel:13)
; node # 9 D(-20,65)->(0,76)
       fcb 2 ; drawmode 
       fdb -512,11264 ; starx/y relative to previous node
       fdb 39,77 ; dx/dy. dx(abs:256|rel:77) dy(abs:-140|rel:39)
; node # 10 M(-16,67)->(3,78)
       fcb 0 ; drawmode 
       fdb -512,1024 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:243|rel:-13) dy(abs:-140|rel:0)
; node # 11 D(3,70)->(25,78)
       fcb 2 ; drawmode 
       fdb -768,4864 ; starx/y relative to previous node
       fdb 38,38 ; dx/dy. dx(abs:281|rel:38) dy(abs:-102|rel:38)
; node # 12 D(4,74)->(26,81)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 13,0 ; dx/dy. dx(abs:281|rel:0) dy(abs:-89|rel:13)
; node # 13 D(-13,74)->(3,82)
       fcb 2 ; drawmode 
       fdb 0,-4352 ; starx/y relative to previous node
       fdb -13,-77 ; dx/dy. dx(abs:204|rel:-77) dy(abs:-102|rel:-13)
; node # 14 D(-16,67)->(3,78)
       fcb 2 ; drawmode 
       fdb 1792,-768 ; starx/y relative to previous node
       fdb -38,39 ; dx/dy. dx(abs:243|rel:39) dy(abs:-140|rel:-38)
; node # 15 M(-22,67)->(-4,78)
       fcb 0 ; drawmode 
       fdb 0,-1536 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:230|rel:-13) dy(abs:-140|rel:0)
; node # 16 D(-41,66)->(-25,78)
       fcb 2 ; drawmode 
       fdb 256,-4864 ; starx/y relative to previous node
       fdb -13,-26 ; dx/dy. dx(abs:204|rel:-26) dy(abs:-153|rel:-13)
; node # 17 D(-40,70)->(-26,81)
       fcb 2 ; drawmode 
       fdb -1024,256 ; starx/y relative to previous node
       fdb 13,-25 ; dx/dy. dx(abs:179|rel:-25) dy(abs:-140|rel:13)
; node # 18 D(-20,73)->(-4,82)
       fcb 2 ; drawmode 
       fdb -768,5120 ; starx/y relative to previous node
       fdb 25,25 ; dx/dy. dx(abs:204|rel:25) dy(abs:-115|rel:25)
; node # 19 D(-22,67)->(-4,78)
       fcb 2 ; drawmode 
       fdb 1536,-512 ; starx/y relative to previous node
       fdb -25,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-140|rel:-25)
; node # 20 M(-20,65)->(0,76)
       fcb 0 ; drawmode 
       fdb 512,512 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:256|rel:26) dy(abs:-140|rel:0)
; node # 21 D(-16,35)->(0,42)
       fcb 2 ; drawmode 
       fdb 7680,1024 ; starx/y relative to previous node
       fdb 51,-52 ; dx/dy. dx(abs:204|rel:-52) dy(abs:-89|rel:51)
; node # 22 D(-15,-42)->(-15,-44)
       fcb 2 ; drawmode 
       fdb 19712,256 ; starx/y relative to previous node
       fdb 114,-204 ; dx/dy. dx(abs:0|rel:-204) dy(abs:25|rel:114)
; node # 23 M(0,-59)->(0,-66)
       fcb 0 ; drawmode 
       fdb 4352,3840 ; starx/y relative to previous node
       fdb 64,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:89|rel:64)
; node # 24 D(-3,-40)->(0,-44)
       fcb 2 ; drawmode 
       fdb -4864,-768 ; starx/y relative to previous node
       fdb -38,38 ; dx/dy. dx(abs:38|rel:38) dy(abs:51|rel:-38)
; node # 25 M(10,-38)->(15,-44)
       fcb 0 ; drawmode 
       fdb -512,3328 ; starx/y relative to previous node
       fdb 25,26 ; dx/dy. dx(abs:64|rel:26) dy(abs:76|rel:25)
; node # 26 D(-16,35)->(0,42)
       fcb 2 ; drawmode 
       fdb -18688,-6656 ; starx/y relative to previous node
       fdb -165,140 ; dx/dy. dx(abs:204|rel:140) dy(abs:-89|rel:-165)
; node # 27 D(23,71)->(50,77)
       fcb 2 ; drawmode 
       fdb -9216,9984 ; starx/y relative to previous node
       fdb 13,141 ; dx/dy. dx(abs:345|rel:141) dy(abs:-76|rel:13)
; node # 28 D(10,-38)->(15,-44)
       fcb 2 ; drawmode 
       fdb 27904,-3328 ; starx/y relative to previous node
       fdb 152,-281 ; dx/dy. dx(abs:64|rel:-281) dy(abs:76|rel:152)
; node # 29 D(-3,76)->(15,83)
       fcb 2 ; drawmode 
       fdb -29184,-3328 ; starx/y relative to previous node
       fdb -165,166 ; dx/dy. dx(abs:230|rel:166) dy(abs:-89|rel:-165)
; node # 30 D(-29,74)->(-15,83)
       fcb 2 ; drawmode 
       fdb 512,-6656 ; starx/y relative to previous node
       fdb -26,-51 ; dx/dy. dx(abs:179|rel:-51) dy(abs:-115|rel:-26)
; node # 31 D(-15,-42)->(-15,-44)
       fcb 2 ; drawmode 
       fdb 29696,3584 ; starx/y relative to previous node
       fdb 140,-179 ; dx/dy. dx(abs:0|rel:-179) dy(abs:25|rel:140)
; node # 32 D(-64,63)->(-50,77)
       fcb 2 ; drawmode 
       fdb -26880,-12544 ; starx/y relative to previous node
       fdb -204,179 ; dx/dy. dx(abs:179|rel:179) dy(abs:-179|rel:-204)
; node # 33 D(-16,35)->(0,42)
       fcb 2 ; drawmode 
       fdb 7168,12288 ; starx/y relative to previous node
       fdb 90,25 ; dx/dy. dx(abs:204|rel:25) dy(abs:-89|rel:90)
; node # 34 M(-3,76)->(15,83)
       fcb 0 ; drawmode 
       fdb -10496,3328 ; starx/y relative to previous node
       fdb 0,26 ; dx/dy. dx(abs:230|rel:26) dy(abs:-89|rel:0)
; node # 35 D(44,76)->(73,81)
       fcb 2 ; drawmode 
       fdb 0,12032 ; starx/y relative to previous node
       fdb 25,141 ; dx/dy. dx(abs:371|rel:141) dy(abs:-64|rel:25)
; node # 36 M(43,45)->(66,44)
       fcb 0 ; drawmode 
       fdb 7936,-256 ; starx/y relative to previous node
       fdb 76,-77 ; dx/dy. dx(abs:294|rel:-77) dy(abs:12|rel:76)
; node # 37 D(23,71)->(50,77)
       fcb 2 ; drawmode 
       fdb -6656,-5120 ; starx/y relative to previous node
       fdb -88,51 ; dx/dy. dx(abs:345|rel:51) dy(abs:-76|rel:-88)
; node # 38 M(32,76)->(58,81)
       fcb 0 ; drawmode 
       fdb -1280,2304 ; starx/y relative to previous node
       fdb 12,-13 ; dx/dy. dx(abs:332|rel:-13) dy(abs:-64|rel:12)
; node # 39 D(30,74)->(57,79)
       fcb 2 ; drawmode 
       fdb 512,-512 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:345|rel:13) dy(abs:-64|rel:0)
; node # 40 D(37,75)->(68,81)
       fcb 2 ; drawmode 
       fdb -256,1792 ; starx/y relative to previous node
       fdb -12,51 ; dx/dy. dx(abs:396|rel:51) dy(abs:-76|rel:-12)
; node # 41 D(32,76)->(58,81)
       fcb 2 ; drawmode 
       fdb -256,-1280 ; starx/y relative to previous node
       fdb 12,-64 ; dx/dy. dx(abs:332|rel:-64) dy(abs:-64|rel:12)
; node # 42 M(-29,74)->(-15,83)
       fcb 0 ; drawmode 
       fdb 512,-15616 ; starx/y relative to previous node
       fdb -51,-153 ; dx/dy. dx(abs:179|rel:-153) dy(abs:-115|rel:-51)
; node # 43 D(-84,65)->(-73,80)
       fcb 2 ; drawmode 
       fdb 2304,-14080 ; starx/y relative to previous node
       fdb -77,-39 ; dx/dy. dx(abs:140|rel:-39) dy(abs:-192|rel:-77)
; node # 44 M(-73,32)->(-67,44)
       fcb 0 ; drawmode 
       fdb 8448,2816 ; starx/y relative to previous node
       fdb 39,-64 ; dx/dy. dx(abs:76|rel:-64) dy(abs:-153|rel:39)
; node # 45 D(-64,63)->(-50,77)
       fcb 2 ; drawmode 
       fdb -7936,2304 ; starx/y relative to previous node
       fdb -26,103 ; dx/dy. dx(abs:179|rel:103) dy(abs:-179|rel:-26)
; node # 46 M(-69,67)->(-58,80)
       fcb 0 ; drawmode 
       fdb -1024,-1280 ; starx/y relative to previous node
       fdb 13,-39 ; dx/dy. dx(abs:140|rel:-39) dy(abs:-166|rel:13)
; node # 47 D(-77,65)->(-69,80)
       fcb 2 ; drawmode 
       fdb 512,-2048 ; starx/y relative to previous node
       fdb -26,-38 ; dx/dy. dx(abs:102|rel:-38) dy(abs:-192|rel:-26)
; node # 48 D(-69,64)->(-57,79)
       fcb 2 ; drawmode 
       fdb 256,2048 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-192|rel:0)
; node # 49 D(-70,67)->(-58,80)
       fcb 2 ; drawmode 
       fdb -768,-256 ; starx/y relative to previous node
       fdb 26,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-166|rel:26)
       fcb  1  ; end of anim
