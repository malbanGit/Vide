                              1  .module ayfxplayer.s
                              2  .bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)
                              3  .area .cartridge (BANK=rom) 
                              4  .area .text (BANK=rom)
                              5  .area .text.hot (BANK=rom)
                              6  .area .text.unlikely (BANK=rom)
                              7 
                              8  .bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
                              9  .area .data  (BANK=ram)
                             10  .area .bss   (BANK=ram)
                             11 
                             12  .area .text
                             13 
                             14  .area .bss
                             15 
                             16  .globl _currentSFX_1
   C98F                      17 _currentSFX_1:        .blkb       2                            ; sfx player used 
                             18  .globl _currentSFX_2
   C991                      19 _currentSFX_2:        .blkb       2                            ; sfx player used 
                             20  .globl _currentSFX_3
   C993                      21 _currentSFX_3:        .blkb       2                            ; sfx player used 
                             22  .globl _sfx_status_1
   C995                      23 _sfx_status_1:        .blkb       1                            ; sfx player used 
                             24  .globl _sfx_status_2
   C996                      25 _sfx_status_2:        .blkb       1                            ; sfx player used 
                             26  .globl _sfx_status_3
   C997                      27 _sfx_status_3:        .blkb       1                            ; sfx player used 
                             28  .globl _sfx_pointer_1
   C998                      29 _sfx_pointer_1:       .blkb       2                            ; sfx player used 
                             30  .globl _sfx_pointer_2
   C99A                      31 _sfx_pointer_2:       .blkb       2                            ; sfx player used 
                             32  .globl _sfx_pointer_3
   C99C                      33 _sfx_pointer_3:       .blkb       2                            ; sfx player used 
                             34 
                             35  .area .text
                             36 
                             37 ; this file is part of Release, written by Malban in 2017
                             38 ;
                             39 ; original vectrex routine were written by Richard Chadd
                             40 ;
                             41 ; (optimized version!)
                             42 ; regs used by below implementation
                             43 ; U and D
                             44 ; X is also used, but can be spared - see below comments
                             45 ; this is only channel 1 is implemented
                     C84C    46 SHADOW_BASE         =        0xC84C;0xc83f 
                             47 ;;;;;;;;;;;;;;;;
                             48 ;;;;;;;;;;;;;;;;
                             49 
                             50 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             51 
                             52  .globl sfx_endofeffect_1
   3009                      53 sfx_endofeffect_1: 
                             54                                                           ; set volume off channel 3 
                             55                                                           ; set reg1sf0 
                             56                                                           ; Set volume 
   3009 CC 00 00      [ 3]   57                     LDD      #0x0000                       ; reset sfx 
   300C B7 C8 44      [ 5]   58                     sta      SHADOW_BASE-0x08 
   300F FD C9 98      [ 6]   59                     STD      _sfx_pointer_1 
   3012 B7 C9 95      [ 5]   60                     STA      _sfx_status_1 
   3015 FD C9 8F      [ 6]   61                     std      _currentSFX_1 
                             62  .globl noay1
   3018                      63 noay1: 
   3018 39            [ 5]   64                     RTS      
                             65 
                             66  .globl sfx_doframe_intern_1
   3019                      67 sfx_doframe_intern_1:                                     ;#isfunction  
   3019 B6 C9 95      [ 5]   68                     LDA      _sfx_status_1                 ; check if sfx to play 
   301C 27 FA         [ 3]   69                     BEQ      noay1 
   301E FE C9 98      [ 6]   70                     LDU      _sfx_pointer_1                ; get current frame pointer 
   3021 E6 C0         [ 6]   71                     LDB      ,U+ 
   3023 C1 D0         [ 2]   72                     CMPB     #0xD0                         ; check first flag byte D0 
   3025 26 06         [ 3]   73                     BNE      sfx_checktonefreq_1          ; no match - continue to process frame 
   3027 A6 C4         [ 4]   74                     LDA      ,U 
   3029 81 20         [ 2]   75                     CMPA     #0x20                         ; check second flag byte 20 
   302B 27 DC         [ 3]   76                     BEQ      sfx_endofeffect_1            ; match - end of effect found so stop playing 
                             77  .globl sfx_checktonefreq_1
   302D                      78 sfx_checktonefreq_1: 
   302D C5 20         [ 2]   79                     BITB     #0b00100000                   ; if bit 5 of B is set 
   302F 27 07         [ 3]   80                     BEQ      sfx_checknoisefreq_1         ; skip as no tone freq data 
   3031 EC C1         [ 8]   81                     ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
   3033 FD C8 4C      [ 6]   82                     std      SHADOW_BASE-00 ; here I destroy d
   3036 E6 5D         [ 5]   83                     ldb      -3,u ; and load b anew - one instruction to many, 
                             84  .globl sfx_checknoisefreq_1
   3038                      85 sfx_checknoisefreq_1: 
   3038 C5 40         [ 2]   86                     BITB     #0b01000000                   ; if bit 6 of B is only set 
   303A 27 05         [ 3]   87                     BEQ      sfx_checkvolume_1            ; skip as no noise freq data 
   303C A6 C0         [ 6]   88                     LDA      ,U+                          ; get next data byte and copy to noise freq reg 
   303E B7 C8 46      [ 5]   89                     STA      SHADOW_BASE-06               ; set noise freq 
                             90  .globl sfx_checkvolume_1
   3041                      91 sfx_checkvolume_1: 
   3041 1F 98         [ 6]   92                     tfr      b,a 
   3043 84 0F         [ 2]   93                     ANDA     #0b00001111                   ; get volume from bits 0-3 
   3045 B7 C8 44      [ 5]   94                     STA      SHADOW_BASE-0x08              ; set tone freq 
                             95  .globl sfx_checktonedisable_1
   3048                      96 sfx_checktonedisable_1: 
   3048 B6 C8 45      [ 5]   97                     LDA      SHADOW_BASE-0x07              ; in the following reg 7 will be altered - load once 
   304B C5 10         [ 2]   98                     BITB     #0b00010000                   ; if bit 4 of B is set disable the tone 
   304D 27 0F         [ 3]   99                     BEQ      sfx_enabletone_1 
                            100  .globl sfx_disabletone_1
   304F                     101 sfx_disabletone_1: 
   304F 8A 01         [ 2]  102                     ORA      #0b00000001 
   3051 C5 80         [ 2]  103                     BITB     #0b10000000                   ; if bit7 of B is set disable noise 
   3053 27 18         [ 3]  104                     BEQ      sfx_enablenoise_1 
   3055 8A 08         [ 2]  105                     ORA      #0b00001000 
   3057 B7 C8 45      [ 5]  106                     STA      SHADOW_BASE-0x07              ; set tone freq 
   305A FF C9 98      [ 6]  107                     STU      _sfx_pointer_1                ; update frame pointer to next flag byte in Y 
   305D 39            [ 5]  108                     RTS      
                            109 
                            110  .globl sfx_enabletone_1
   305E                     111 sfx_enabletone_1: 
   305E 84 FE         [ 2]  112                     ANDA     #0b11111110 
                            113  .globl sfx_checknoisedisable_1
   3060                     114 sfx_checknoisedisable_1: 
   3060 C5 80         [ 2]  115                     BITB     #0b10000000                   ; if bit7 of B is set disable noise 
   3062 27 09         [ 3]  116                     BEQ      sfx_enablenoise_1 
                            117  .globl sfx_disablenoise_1
   3064                     118 sfx_disablenoise_1: 
   3064 8A 08         [ 2]  119                     ORA      #0b00001000 
   3066 B7 C8 45      [ 5]  120                     STA      SHADOW_BASE-0x07              ; set tone freq 
   3069 FF C9 98      [ 6]  121                     STU      _sfx_pointer_1                ; update frame pointer to next flag byte in Y 
   306C 39            [ 5]  122                     RTS      
                            123 
                            124  .globl sfx_enablenoise_1
   306D                     125 sfx_enablenoise_1: 
   306D 84 F7         [ 2]  126                     ANDA     #0b11110111 
   306F B7 C8 45      [ 5]  127                     STA      SHADOW_BASE-0x07              ; set tone freq 
   3072 FF C9 98      [ 6]  128                     STU      _sfx_pointer_1                ; update frame pointer to next flag byte in Y 
   3075 39            [ 5]  129                     RTS      
                            130 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            131 
                            132  .globl sfx_endofeffect_2
   3076                     133 sfx_endofeffect_2: 
                            134                                                           ; set volume off channel 3 
                            135                                                           ; set reg1sf0 
                            136                                                           ; Set volume 
   3076 CC 00 00      [ 3]  137                     LDD      #0x0000                       ; reset sfx 
   3079 B7 C8 43      [ 5]  138                     sta      SHADOW_BASE-0x09 
   307C FD C9 9A      [ 6]  139                     STD      _sfx_pointer_2 
   307F B7 C9 96      [ 5]  140                     STA      _sfx_status_2 
   3082 FD C9 91      [ 6]  141                     std      _currentSFX_2 
                            142  
                            143  .globl noay2
   3085                     144 noay2:
   3085 39            [ 5]  145                     RTS      
                            146 
                            147  .globl sfx_doframe_intern_2
   3086                     148 sfx_doframe_intern_2:  ;#isfunction
                            149 
                            150 
   3086 B6 C9 96      [ 5]  151                     LDA      _sfx_status_2                ; check if sfx to play 
   3089 27 FA         [ 3]  152                     BEQ      noay2 
                            153 
   308B FE C9 9A      [ 6]  154                     LDU      _sfx_pointer_2                ; get current frame pointer 
   308E E6 C0         [ 6]  155                     LDB      ,U+ 
   3090 C1 D0         [ 2]  156                     CMPB     #0xD0                         ; check first flag byte D0 
   3092 26 06         [ 3]  157                     BNE      sfx_checktonefreq_2          ; no match - continue to process frame 
   3094 A6 C4         [ 4]  158                     LDA      ,U 
   3096 81 20         [ 2]  159                     CMPA     #0x20                         ; check second flag byte 20 
   3098 27 DC         [ 3]  160                     BEQ      sfx_endofeffect_2            ; match - end of effect found so stop playing 
                            161  .globl sfx_checktonefreq_2
   309A                     162 sfx_checktonefreq_2: 
   309A C5 20         [ 2]  163                     BITB     #0b00100000                   ; if bit 5 of B is set 
   309C 27 07         [ 3]  164                     BEQ      sfx_checknoisefreq_2         ; skip as no tone freq data 
   309E EC C1         [ 8]  165                     ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
   30A0 FD C8 4A      [ 6]  166                     std      SHADOW_BASE-02 ; here I destroy d
   30A3 E6 5D         [ 5]  167                     ldb -3,u ; and load b anew - one instruction to many, 
                            168  .globl sfx_checknoisefreq_2
   30A5                     169 sfx_checknoisefreq_2: 
   30A5 C5 40         [ 2]  170                     BITB     #0b01000000                   ; if bit 6 of B is only set 
   30A7 27 05         [ 3]  171                     BEQ      sfx_checkvolume_2            ; skip as no noise freq data 
   30A9 A6 C0         [ 6]  172                     LDA      ,U+                          ; get next data byte and copy to noise freq reg 
   30AB B7 C8 46      [ 5]  173                     STA      SHADOW_BASE-06               ; set noise freq 
                            174  .globl sfx_checkvolume_2
   30AE                     175 sfx_checkvolume_2: 
   30AE 1F 98         [ 6]  176                     tfr      b,a 
   30B0 84 0F         [ 2]  177                     ANDA     #0b00001111                   ; get volume from bits 0-3 
   30B2 B7 C8 43      [ 5]  178                     STA      SHADOW_BASE-0x09              ; set tone freq 
                            179  .globl sfx_checktonedisable_2
   30B5                     180 sfx_checktonedisable_2: 
   30B5 B6 C8 45      [ 5]  181                     LDA      SHADOW_BASE-0x07              ; in the following reg 7 will be altered - load once 
   30B8 C5 10         [ 2]  182                     BITB     #0b00010000                   ; if bit 4 of B is set disable the tone 
   30BA 27 0F         [ 3]  183                     BEQ      sfx_enabletone_2 
                            184  .globl sfx_disabletone_2
   30BC                     185 sfx_disabletone_2: 
   30BC 8A 02         [ 2]  186                     ORA      #0b00000010 
   30BE C5 80         [ 2]  187                     BITB     #0b10000000                   ; if bit7 of B is set disable noise 
   30C0 27 18         [ 3]  188                     BEQ      sfx_enablenoise_2 
   30C2 8A 10         [ 2]  189                     ORA      #0b00010000 
   30C4 B7 C8 45      [ 5]  190                     STA      SHADOW_BASE-0x07              ; set tone freq 
   30C7 FF C9 9A      [ 6]  191                     STU      _sfx_pointer_2                ; update frame pointer to next flag byte in Y 
   30CA 39            [ 5]  192                     RTS      
                            193 
                            194  .globl sfx_enabletone_2
   30CB                     195 sfx_enabletone_2: 
   30CB 84 FD         [ 2]  196                     ANDA     #0b11111101 
                            197  .globl sfx_checknoisedisable_2
   30CD                     198 sfx_checknoisedisable_2: 
   30CD C5 80         [ 2]  199                     BITB     #0b10000000                   ; if bit7 of B is set disable noise 
   30CF 27 09         [ 3]  200                     BEQ      sfx_enablenoise_2 
                            201  .globl sfx_disablenoise_2
   30D1                     202 sfx_disablenoise_2: 
   30D1 8A 10         [ 2]  203                     ORA      #0b00010000 
   30D3 B7 C8 45      [ 5]  204                     STA      SHADOW_BASE-0x07              ; set tone freq 
   30D6 FF C9 9A      [ 6]  205                     STU      _sfx_pointer_2                ; update frame pointer to next flag byte in Y 
   30D9 39            [ 5]  206                     RTS      
                            207 
                            208  .globl sfx_enablenoise_2
   30DA                     209 sfx_enablenoise_2: 
   30DA 84 EF         [ 2]  210                     ANDA     #0b11101111 
   30DC B7 C8 45      [ 5]  211                     STA      SHADOW_BASE-0x07              ; set tone freq 
   30DF FF C9 9A      [ 6]  212                     STU      _sfx_pointer_2                ; update frame pointer to next flag byte in Y 
   30E2 39            [ 5]  213                     RTS      
                            214 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            215  .globl sfx_endofeffect_3
   30E3                     216 sfx_endofeffect_3: 
                            217                                                           ; set volume off channel 3 
                            218                                                           ; set reg1sf0 
                            219                                                           ; Set volume 
   30E3 CC 00 00      [ 3]  220                     LDD      #0x0000                       ; reset sfx 
   30E6 B7 C8 42      [ 5]  221                     sta      SHADOW_BASE-0x0a 
   30E9 FD C9 9C      [ 6]  222                     STD      _sfx_pointer_3 
   30EC B7 C9 97      [ 5]  223                     STA      _sfx_status_3 
   30EF FD C9 93      [ 6]  224                     std      _currentSFX_3 
                            225  
                            226  .globl noay3
   30F2                     227 noay3:
   30F2 39            [ 5]  228                     RTS      
                            229 
                            230  .globl sfx_doframe_intern_3
   30F3                     231 sfx_doframe_intern_3:  ;#isfunction
                            232 
                            233 
   30F3 B6 C9 97      [ 5]  234                     LDA      _sfx_status_3                ; check if sfx to play 
   30F6 27 FA         [ 3]  235                     BEQ      noay3 
                            236 
   30F8 FE C9 9C      [ 6]  237                     LDU      _sfx_pointer_3                ; get current frame pointer 
   30FB E6 C0         [ 6]  238                     LDB      ,U+ 
   30FD C1 D0         [ 2]  239                     CMPB     #0xD0                         ; check first flag byte D0 
   30FF 26 06         [ 3]  240                     BNE      sfx_checktonefreq_3          ; no match - continue to process frame 
   3101 A6 C4         [ 4]  241                     LDA      ,U 
   3103 81 20         [ 2]  242                     CMPA     #0x20                         ; check second flag byte 20 
   3105 27 DC         [ 3]  243                     BEQ      sfx_endofeffect_3            ; match - end of effect found so stop playing 
                            244  .globl sfx_checktonefreq_3
   3107                     245 sfx_checktonefreq_3: 
   3107 C5 20         [ 2]  246                     BITB     #0b00100000                   ; if bit 5 of B is set 
   3109 27 07         [ 3]  247                     BEQ      sfx_checknoisefreq_3         ; skip as no tone freq data 
   310B EC C1         [ 8]  248                     ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
   310D FD C8 48      [ 6]  249                     std      SHADOW_BASE-04 ; here I destroy d
   3110 E6 5D         [ 5]  250                     ldb -3,u ; and load b anew - one instruction to many, 
                            251  .globl sfx_checknoisefreq_3
   3112                     252 sfx_checknoisefreq_3: 
   3112 C5 40         [ 2]  253                     BITB     #0b01000000                   ; if bit 6 of B is only set 
   3114 27 05         [ 3]  254                     BEQ      sfx_checkvolume_3            ; skip as no noise freq data 
   3116 A6 C0         [ 6]  255                     LDA      ,U+                          ; get next data byte and copy to noise freq reg 
   3118 B7 C8 46      [ 5]  256                     STA      SHADOW_BASE-06               ; set tone freq 
                            257  .globl sfx_checkvolume_3
   311B                     258 sfx_checkvolume_3: 
   311B 1F 98         [ 6]  259                     tfr      b,a 
   311D 84 0F         [ 2]  260                     ANDA     #0b00001111                   ; get volume from bits 0-3 
   311F B7 C8 42      [ 5]  261                     STA      SHADOW_BASE-0x0A              ; set tone freq 
                            262  .globl sfx_checktonedisable_3
   3122                     263 sfx_checktonedisable_3: 
   3122 B6 C8 45      [ 5]  264                     LDA      SHADOW_BASE-0x07              ; in the following reg 7 will be altered - load once 
   3125 C5 10         [ 2]  265                     BITB     #0b00010000                   ; if bit 4 of B is set disable the tone 
   3127 27 0F         [ 3]  266                     BEQ      sfx_enabletone_3 
                            267  .globl sfx_disabletone_3
   3129                     268 sfx_disabletone_3: 
   3129 8A 04         [ 2]  269                     ORA      #0b00000100 
   312B C5 80         [ 2]  270                     BITB     #0b10000000                   ; if bit7 of B is set disable noise 
   312D 27 18         [ 3]  271                     BEQ      sfx_enablenoise_3 
   312F 8A 20         [ 2]  272                     ORA      #0b00100000 
   3131 B7 C8 45      [ 5]  273                     STA      SHADOW_BASE-0x07              ; set tone freq 
   3134 FF C9 9C      [ 6]  274                     STU      _sfx_pointer_3                ; update frame pointer to next flag byte in Y 
   3137 39            [ 5]  275                     RTS      
                            276 
                            277  .globl sfx_enabletone_3
   3138                     278 sfx_enabletone_3: 
   3138 84 FB         [ 2]  279                     ANDA     #0b11111011 
                            280  .globl sfx_checknoisedisable_3
   313A                     281 sfx_checknoisedisable_3: 
   313A C5 80         [ 2]  282                     BITB     #0b10000000                   ; if bit7 of B is set disable noise 
   313C 27 09         [ 3]  283                     BEQ      sfx_enablenoise_3 
                            284  .globl sfx_disablenoise_3
   313E                     285 sfx_disablenoise_3: 
   313E 8A 20         [ 2]  286                     ORA      #0b00100000 
   3140 B7 C8 45      [ 5]  287                     STA      SHADOW_BASE-0x07              ; set tone freq 
   3143 FF C9 9C      [ 6]  288                     STU      _sfx_pointer_3                ; update frame pointer to next flag byte in Y 
   3146 39            [ 5]  289                     RTS      
                            290 
                            291  .globl sfx_enablenoise_3
   3147                     292 sfx_enablenoise_3: 
   3147 84 DF         [ 2]  293                     ANDA     #0b11011111 
   3149 B7 C8 45      [ 5]  294                     STA      SHADOW_BASE-0x07              ; set tone freq 
   314C FF C9 9C      [ 6]  295                     STU      _sfx_pointer_3                ; update frame pointer to next flag byte in Y 
   314F 39            [ 5]  296                     RTS      
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  3 A$ayfxPlayer.p     0046 GR  |   3 A$ayfxPlayer.p     0048 GR
  3 A$ayfxPlayer.p     004A GR  |   3 A$ayfxPlayer.p     004C GR
  3 A$ayfxPlayer.p     004E GR  |   3 A$ayfxPlayer.p     0051 GR
  3 A$ayfxPlayer.p     0054 GR  |   3 A$ayfxPlayer.p     0055 GR
  3 A$ayfxPlayer.p     0057 GR  |   3 A$ayfxPlayer.p     0059 GR
  3 A$ayfxPlayer.p     005B GR  |   3 A$ayfxPlayer.p     005D GR
  3 A$ayfxPlayer.p     0060 GR  |   3 A$ayfxPlayer.p     0063 GR
  3 A$ayfxPlayer.p     0064 GR  |   3 A$ayfxPlayer.p     0066 GR
  3 A$ayfxPlayer.p     0069 GR  |   3 A$ayfxPlayer.p     006C GR
  3 A$ayfxPlayer.p     006D GR  |   3 A$ayfxPlayer.p     0070 GR
  3 A$ayfxPlayer.p     0073 GR  |   3 A$ayfxPlayer.p     0076 GR
  3 A$ayfxPlayer.p     0079 GR  |   3 A$ayfxPlayer.p     007C GR
  3 A$ayfxPlayer.p     007D GR  |   3 A$ayfxPlayer.p     0080 GR
  3 A$ayfxPlayer.p     0082 GR  |   3 A$ayfxPlayer.p     0085 GR
  3 A$ayfxPlayer.p     0087 GR  |   3 A$ayfxPlayer.p     0089 GR
  3 A$ayfxPlayer.p     008B GR  |   3 A$ayfxPlayer.p     008D GR
  3 A$ayfxPlayer.p     008F GR  |   3 A$ayfxPlayer.p     0091 GR
  3 A$ayfxPlayer.p     0093 GR  |   3 A$ayfxPlayer.p     0095 GR
  3 A$ayfxPlayer.p     0097 GR  |   3 A$ayfxPlayer.p     009A GR
  3 A$ayfxPlayer.p     009C GR  |   3 A$ayfxPlayer.p     009E GR
  3 A$ayfxPlayer.p     00A0 GR  |   3 A$ayfxPlayer.p     00A2 GR
  3 A$ayfxPlayer.p     00A5 GR  |   3 A$ayfxPlayer.p     00A7 GR
  3 A$ayfxPlayer.p     00A9 GR  |   3 A$ayfxPlayer.p     00AC GR
  3 A$ayfxPlayer.p     00AF GR  |   3 A$ayfxPlayer.p     00B1 GR
  3 A$ayfxPlayer.p     00B3 GR  |   3 A$ayfxPlayer.p     00B5 GR
  3 A$ayfxPlayer.p     00B7 GR  |   3 A$ayfxPlayer.p     00B9 GR
  3 A$ayfxPlayer.p     00BB GR  |   3 A$ayfxPlayer.p     00BE GR
  3 A$ayfxPlayer.p     00C1 GR  |   3 A$ayfxPlayer.p     00C2 GR
  3 A$ayfxPlayer.p     00C4 GR  |   3 A$ayfxPlayer.p     00C6 GR
  3 A$ayfxPlayer.p     00C8 GR  |   3 A$ayfxPlayer.p     00CA GR
  3 A$ayfxPlayer.p     00CD GR  |   3 A$ayfxPlayer.p     00D0 GR
  3 A$ayfxPlayer.p     00D1 GR  |   3 A$ayfxPlayer.p     00D3 GR
  3 A$ayfxPlayer.p     00D6 GR  |   3 A$ayfxPlayer.p     00D9 GR
  3 A$ayfxPlayer.p     00DA GR  |   3 A$ayfxPlayer.p     00DD GR
  3 A$ayfxPlayer.p     00E0 GR  |   3 A$ayfxPlayer.p     00E3 GR
  3 A$ayfxPlayer.p     00E6 GR  |   3 A$ayfxPlayer.p     00E9 GR
  3 A$ayfxPlayer.p     00EA GR  |   3 A$ayfxPlayer.p     00ED GR
  3 A$ayfxPlayer.p     00EF GR  |   3 A$ayfxPlayer.p     00F2 GR
  3 A$ayfxPlayer.p     00F4 GR  |   3 A$ayfxPlayer.p     00F6 GR
  3 A$ayfxPlayer.p     00F8 GR  |   3 A$ayfxPlayer.p     00FA GR
  3 A$ayfxPlayer.p     00FC GR  |   3 A$ayfxPlayer.p     00FE GR
  3 A$ayfxPlayer.p     0100 GR  |   3 A$ayfxPlayer.p     0102 GR
  3 A$ayfxPlayer.p     0104 GR  |   3 A$ayfxPlayer.p     0107 GR
  3 A$ayfxPlayer.p     0109 GR  |   3 A$ayfxPlayer.p     010B GR
  3 A$ayfxPlayer.p     010D GR  |   3 A$ayfxPlayer.p     010F GR
  3 A$ayfxPlayer.p     0112 GR  |   3 A$ayfxPlayer.p     0114 GR
  3 A$ayfxPlayer.p     0116 GR  |   3 A$ayfxPlayer.p     0119 GR
  3 A$ayfxPlayer.p     011C GR  |   3 A$ayfxPlayer.p     011E GR
  3 A$ayfxPlayer.p     0120 GR  |   3 A$ayfxPlayer.p     0122 GR
  3 A$ayfxPlayer.p     0124 GR  |   3 A$ayfxPlayer.p     0126 GR
  3 A$ayfxPlayer.p     0128 GR  |   3 A$ayfxPlayer.p     012B GR
  3 A$ayfxPlayer.p     012E GR  |   3 A$ayfxPlayer.p     012F GR
  3 A$ayfxPlayer.p     0131 GR  |   3 A$ayfxPlayer.p     0133 GR
  3 A$ayfxPlayer.p     0135 GR  |   3 A$ayfxPlayer.p     0137 GR
  3 A$ayfxPlayer.p     013A GR  |   3 A$ayfxPlayer.p     013D GR
  3 A$ayfxPlayer.p     013E GR  |   3 A$ayfxPlayer.p     0140 GR
  3 A$ayfxPlayer.p     0143 GR  |   3 A$ayfxPlayer.p     0146 GR
  3 A$ayfxPlayer.p     0000 GR  |   3 A$ayfxPlayer.p     0003 GR
  3 A$ayfxPlayer.p     0006 GR  |   3 A$ayfxPlayer.p     0009 GR
  3 A$ayfxPlayer.p     000C GR  |   3 A$ayfxPlayer.p     000F GR
  3 A$ayfxPlayer.p     0010 GR  |   3 A$ayfxPlayer.p     0013 GR
  3 A$ayfxPlayer.p     0015 GR  |   3 A$ayfxPlayer.p     0018 GR
  3 A$ayfxPlayer.p     001A GR  |   3 A$ayfxPlayer.p     001C GR
  3 A$ayfxPlayer.p     001E GR  |   3 A$ayfxPlayer.p     0020 GR
  3 A$ayfxPlayer.p     0022 GR  |   3 A$ayfxPlayer.p     0024 GR
  3 A$ayfxPlayer.p     0026 GR  |   3 A$ayfxPlayer.p     0028 GR
  3 A$ayfxPlayer.p     002A GR  |   3 A$ayfxPlayer.p     002D GR
  3 A$ayfxPlayer.p     002F GR  |   3 A$ayfxPlayer.p     0031 GR
  3 A$ayfxPlayer.p     0033 GR  |   3 A$ayfxPlayer.p     0035 GR
  3 A$ayfxPlayer.p     0038 GR  |   3 A$ayfxPlayer.p     003A GR
  3 A$ayfxPlayer.p     003C GR  |   3 A$ayfxPlayer.p     003F GR
  3 A$ayfxPlayer.p     0042 GR  |   3 A$ayfxPlayer.p     0044 GR
    SHADOW_BASE    =   C84C     |   7 _currentSFX_1      0000 GR
  7 _currentSFX_2      0002 GR  |   7 _currentSFX_3      0004 GR
  7 _sfx_pointer_1     0009 GR  |   7 _sfx_pointer_2     000B GR
  7 _sfx_pointer_3     000D GR  |   7 _sfx_status_1      0006 GR
  7 _sfx_status_2      0007 GR  |   7 _sfx_status_3      0008 GR
  3 noay1              000F GR  |   3 noay2              007C GR
  3 noay3              00E9 GR  |   3 sfx_checknoise     0057 GR
  3 sfx_checknoise     00C4 GR  |   3 sfx_checknoise     0131 GR
  3 sfx_checknoise     002F GR  |   3 sfx_checknoise     009C GR
  3 sfx_checknoise     0109 GR  |   3 sfx_checktoned     003F GR
  3 sfx_checktoned     00AC GR  |   3 sfx_checktoned     0119 GR
  3 sfx_checktonef     0024 GR  |   3 sfx_checktonef     0091 GR
  3 sfx_checktonef     00FE GR  |   3 sfx_checkvolum     0038 GR
  3 sfx_checkvolum     00A5 GR  |   3 sfx_checkvolum     0112 GR
  3 sfx_disablenoi     005B GR  |   3 sfx_disablenoi     00C8 GR
  3 sfx_disablenoi     0135 GR  |   3 sfx_disableton     0046 GR
  3 sfx_disableton     00B3 GR  |   3 sfx_disableton     0120 GR
  3 sfx_doframe_in     0010 GR  |   3 sfx_doframe_in     007D GR
  3 sfx_doframe_in     00EA GR  |   3 sfx_enablenois     0064 GR
  3 sfx_enablenois     00D1 GR  |   3 sfx_enablenois     013E GR
  3 sfx_enabletone     0055 GR  |   3 sfx_enabletone     00C2 GR
  3 sfx_enabletone     012F GR  |   3 sfx_endofeffec     0000 GR
  3 sfx_endofeffec     006D GR  |   3 sfx_endofeffec     00DA GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[rom]
   2 .cartridge       size    0   flags 8080
   3 .text            size  147   flags 8180
   4 .text.hot        size    0   flags 8080
   5 .text.unlikely   size    0   flags 8080
[ram]
   6 .data            size    0   flags 8080
   7 .bss             size    F   flags 8080

