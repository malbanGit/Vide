; Line-clipping subroutine
; Copyright (C) 2004  Ville Krumlinde

; This code was originally written in C and compiled with the GCC for 6809 compiler.

;**optimize:
;  byt ut s++ mot -2,s.
;  byt ut jmp mot bra
;  byt ut lbxx mot bxx


_CohenSutherlandClip:
;;;-----------------------------------------
;;;  PROLOGUE for CohenSutherlandClip
;;;-----------------------------------------
        leas    -(30),s ; allocate auto variables
        pshs    x,y,u   ;save registers
;;;END PROLOGUE
        clr     24,s    ;clrqi 24,s
        ldx     38,s    ;movhi: 38,s -> R:x
        ldb     ,x+     ;extendqihi: ,x+ -> R:d
        sex
        tfr     d,u     ;movhi: R:d -> R:u
        stx     38,s    ;movhi: R:x -> 38,s
        leau    -1,u    ;addhi: R:u = R:u + #-1
        cmpu    #-1     ;cmphi:
        lbeq    L37
L38:
        ldx     38,s    ;movhi: 38,s -> R:x
        ldb     ,x+     ;movqi: ,x+ -> R:b
        stb     25,s    ;movqi: R:b -> 25,s
        ldb     ,x+     ;extendqihi: ,x+ -> R:d
        sex
        addd    42,s    ;addhi: R:d += 42,s
        std     34,s    ;movhi: R:d -> 34,s
        ldb     ,x+     ;extendqihi: ,x+ -> R:d
        sex
        stx     38,s    ;movhi: R:x -> 38,s
        ldy     44,s    ;movhi: 44,s -> R:y
        leax    d,y     ;addhi: R:x = R:y + R:d
        stx     32,s    ;movhi: R:x -> 32,s
        ldy     38,s    ;movhi: 38,s -> R:y
        ldb     ,y+     ;extendqihi: ,y+ -> R:d
        sex
        addd    42,s    ;addhi: R:d += 42,s
        std     30,s    ;movhi: R:d -> 30,s
        ldb     ,y+     ;extendqihi: ,y+ -> R:d
        sex
        sty     38,s    ;movhi: R:y -> 38,s
        addd    44,s    ;addhi: R:d += 44,s
        std     28,s    ;movhi: R:d -> 28,s
        clrb            ;clrqi REG:b
        cmpx    _clip_ymax      ;cmphi:
        ble    L39
        ldb     #1      ;movqi: #1 -> R:b
        bra     L40
L39:
        cmpx    _clip_ymin      ;cmphi:
        bge    L40
        ldb     #2      ;movqi: #2 -> R:b
L40:
        ldx     34,s    ;movhi: 34,s -> R:x
        ldy     _clip_xmax      ;movhi: _clip_xmax -> R:y
        pshs    y       ;cmphi: R:y with R:x
        cmpx    ,s++    ;cmphi:
        ble    L42
        orb     #4      ;iorqi: b |= #4
        bra     L43
L42:
        cmpx    _clip_xmin      ;cmphi:
        bge    L43
        orb     #8      ;iorqi: b |= #8
L43:
        stb     27,s    ;movqi: R:b -> 27,s
        clrb            ;clrqi REG:b
        ldx     28,s    ;movhi: 28,s -> R:x
        cmpx    _clip_ymax      ;cmphi:
        ble    L46
        ldb     #1      ;movqi: #1 -> R:b
        bra     L47
L46:
        cmpx    _clip_ymin      ;cmphi:
        bge    L47
        ldb     #2      ;movqi: #2 -> R:b
L47:
        ldx     30,s    ;movhi: 30,s -> R:x
        pshs    y       ;cmphi: R:y with R:x
        cmpx    ,s++    ;cmphi:
        ble    L49
        orb     #4      ;iorqi: b |= #4
        bra     L50
L49:
        cmpx    _clip_xmin      ;cmphi:
        bge    L50
        orb     #8      ;iorqi: b |= #8
L50:
        stb     26,s    ;movqi: R:b -> 26,s
        leax    -1,u    ;addhi: R:x = R:u + #-1
        stx     6,s     ;movhi: R:x -> 6,s
        jmp     L53
L56:
        ldb     27,s    ;movqi: 27,s -> R:b
        andb    26,s    ;andqi: R:b &= 26,s
        tstb            ;tstqi: R:b
        lbne    L36
        tst     27,s    ;tstqi: MEM:27,s
        lbeq    L58
        leay    34,s    ;addhi: R:y = R:s + #34
        sty     18,s    ;movhi: R:y -> 18,s
        leax    32,s    ;addhi: R:x = R:s + #32
        stx     16,s    ;movhi: R:x -> 16,s
        ldb     25,s    ;movqi: 25,s -> R:b
        cmpb    #1      ;cmpqi:
        beq    L59
        bgt    L60
        tstb            ;tstqi: R:b
        beq    L61
        jmp     L83
L60:
        ldb     25,s    ;movqi: 25,s -> R:b
        cmpb    #2      ;cmpqi:
        beq    L63
        jmp     L83
L61:
        ldb     27,s    ;movqi: 27,s -> R:b
        andb    #1      ;andqi: R:b &= #1
        tstb            ;tstqi: R:b
        beq    L64
        ldy     _clip_ymax      ;movhi: _clip_ymax -> R:y
        jmp     L126
L64:
        ldy     _clip_ymin      ;movhi: _clip_ymin -> R:y
L126:
        ldx     16,s    ;movhi: 16,s -> R:x
        sty     ,x      ;movhi: R:y -> ,x
        jmp     L83
L59:
        ldb     27,s    ;movqi: 27,s -> R:b
        andb    #4      ;andqi: R:b &= #4
        tstb            ;tstqi: R:b
        beq    L66
        ldy     _clip_xmax      ;movhi: _clip_xmax -> R:y
        jmp     L127
L66:
        ldy     _clip_xmin      ;movhi: _clip_xmin -> R:y
L127:
        ldx     18,s    ;movhi: 18,s -> R:x
        sty     ,x      ;movhi: R:y -> ,x
        jmp     L83
L63:
        ldb     27,s    ;movqi: 27,s -> R:b
        andb    #1      ;andqi: R:b &= #1
        tstb            ;tstqi: R:b
        beq    L68
        ldx     16,s    ;movhi: 16,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        ldu     _clip_ymax      ;movhi: _clip_ymax -> R:u
        pshs    u       ;subhi: R:d -= R:u
        subd    ,s++
                        ;ashlhi: d by #1
        aslb
        rola
        tfr     d,y     ;movhi: R:d -> R:y
        ldx     18,s    ;movhi: 18,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        leax    d,y     ;addhi: R:x = R:y + R:d
        cmpd    30,s    ;cmphi:
        blt    L69
        pshs    y       ;subhi: R:d -= R:y
        subd    ,s++
        tfr     d,x     ;movhi: R:d -> R:x
L69:
        ldy     18,s    ;movhi: 18,s -> R:y
        stx     ,y      ;movhi: R:x -> ,y
        ldx     16,s    ;movhi: 16,s -> R:x
        jmp     L128
L68:
        ldb     27,s    ;movqi: 27,s -> R:b
        andb    #2      ;andqi: R:b &= #2
        tstb            ;tstqi: R:b
        beq    L72
        ldu     _clip_ymin      ;movhi: _clip_ymin -> R:u
        tfr     u,d     ;movhi: R:u -> R:d
        ldy     16,s    ;movhi: 16,s -> R:y
        subd    ,y      ;subhi: R:d -= ,y
                        ;ashlhi: d by #1
        aslb
        rola
        tfr     d,y     ;movhi: R:d -> R:y
        ldx     18,s    ;movhi: 18,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        leax    d,y     ;addhi: R:x = R:y + R:d
        cmpd    30,s    ;cmphi:
        blt    L73
        pshs    y       ;subhi: R:d -= R:y
        subd    ,s++
        tfr     d,x     ;movhi: R:d -> R:x
L73:
        ldy     18,s    ;movhi: 18,s -> R:y
        stx     ,y      ;movhi: R:x -> ,y
        ldx     16,s    ;movhi: 16,s -> R:x
        jmp     L128
L72:
        ldb     27,s    ;movqi: 27,s -> R:b
        andb    #4      ;andqi: R:b &= #4
        tstb            ;tstqi: R:b
        beq    L75
        ldy     18,s    ;movhi: 18,s -> R:y
        ldd     ,y      ;movhi: ,y -> R:d
        ldu     _clip_xmax      ;movhi: _clip_xmax -> R:u
        pshs    u       ;subhi: R:d -= R:u
        subd    ,s++
        bra     L132
L75:
        ldu     _clip_xmin      ;movhi: _clip_xmin -> R:u
        tfr     u,d     ;movhi: R:u -> R:d
        ldy     18,s    ;movhi: 18,s -> R:y
        subd    ,y      ;subhi: R:d -= ,y
L132:
                        ;ashrhi: d by #1
        asra
        rorb
        tfr     d,y     ;movhi: R:d -> R:y
        ldx     16,s    ;movhi: 16,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        leax    d,y     ;addhi: R:x = R:y + R:d
        cmpd    28,s    ;cmphi:
        blt    L78
        pshs    y       ;subhi: R:d -= R:y
        subd    ,s++
        tfr     d,x     ;movhi: R:d -> R:x
L78:
        ldy     16,s    ;movhi: 16,s -> R:y
        stx     ,y      ;movhi: R:x -> ,y
        ldx     18,s    ;movhi: 18,s -> R:x
L128:
        stu     ,x      ;movhi: R:u -> ,x
L83:
        ldy     34,s    ;movhi: 34,s -> R:y
        ldx     32,s    ;movhi: 32,s -> R:x
        clrb            ;clrqi REG:b
        cmpx    _clip_ymax      ;cmphi:
        ble    L84
        ldb     #1      ;movqi: #1 -> R:b
        bra     L85
L84:
        cmpx    _clip_ymin      ;cmphi:
        bge    L85
        ldb     #2      ;movqi: #2 -> R:b
L85:
        cmpy    _clip_xmax      ;cmphi:
        ble    L87
        orb     #4      ;iorqi: b |= #4
        bra     L88
L87:
        cmpy    _clip_xmin      ;cmphi:
        bge    L88
        orb     #8      ;iorqi: b |= #8
L88:
        stb     27,s    ;movqi: R:b -> 27,s
        jmp     L53
L58:
        leay    30,s    ;addhi: R:y = R:s + #30
        sty     14,s    ;movhi: R:y -> 14,s
        leax    28,s    ;addhi: R:x = R:s + #28
        stx     12,s    ;movhi: R:x -> 12,s
        ldy     34,s    ;movhi: 34,s -> R:y
        sty     10,s    ;movhi: R:y -> 10,s
        ldd     32,s    ;movhi: 32,s -> R:d
        std     8,s     ;movhi: R:d -> 8,s
        ldb     25,s    ;movqi: 25,s -> R:b
        cmpb    #1      ;cmpqi:
        beq    L92
        bgt    L93
        tstb            ;tstqi: R:b
        beq    L94
        jmp     L116
L93:
        ldb     25,s    ;movqi: 25,s -> R:b
        cmpb    #2      ;cmpqi:
        beq    L96
        jmp     L116
L94:
        ldb     26,s    ;movqi: 26,s -> R:b
        andb    #1      ;andqi: R:b &= #1
        tstb            ;tstqi: R:b
        beq    L97
        ldy     _clip_ymax      ;movhi: _clip_ymax -> R:y
        jmp     L129
L97:
        ldy     _clip_ymin      ;movhi: _clip_ymin -> R:y
L129:
        ldx     12,s    ;movhi: 12,s -> R:x
        sty     ,x      ;movhi: R:y -> ,x
        jmp     L116
L92:
        ldb     26,s    ;movqi: 26,s -> R:b
        andb    #4      ;andqi: R:b &= #4
        tstb            ;tstqi: R:b
        beq    L99
        ldy     _clip_xmax      ;movhi: _clip_xmax -> R:y
        bra     L130
L99:
        ldy     _clip_xmin      ;movhi: _clip_xmin -> R:y
L130:
        ldx     14,s    ;movhi: 14,s -> R:x
        sty     ,x      ;movhi: R:y -> ,x
        jmp     L116
L96:
        ldb     26,s    ;movqi: 26,s -> R:b
        andb    #1      ;andqi: R:b &= #1
        tstb            ;tstqi: R:b
        beq    L101
        ldx     12,s    ;movhi: 12,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        ldu     _clip_ymax      ;movhi: _clip_ymax -> R:u
        pshs    u       ;subhi: R:d -= R:u
        subd    ,s++
                        ;ashlhi: d by #1
        aslb
        rola
        tfr     d,y     ;movhi: R:d -> R:y
        ldx     14,s    ;movhi: 14,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        leax    d,y     ;addhi: R:x = R:y + R:d
        cmpd    10,s    ;cmphi:
        blt    L102
        pshs    y       ;subhi: R:d -= R:y
        subd    ,s++
        tfr     d,x     ;movhi: R:d -> R:x
L102:
        ldy     14,s    ;movhi: 14,s -> R:y
        stx     ,y      ;movhi: R:x -> ,y
        ldx     12,s    ;movhi: 12,s -> R:x
        jmp     L131
L101:
        ldb     26,s    ;movqi: 26,s -> R:b
        andb    #2      ;andqi: R:b &= #2
        tstb            ;tstqi: R:b
        beq    L105
        ldu     _clip_ymin      ;movhi: _clip_ymin -> R:u
        tfr     u,d     ;movhi: R:u -> R:d
        ldy     12,s    ;movhi: 12,s -> R:y
        subd    ,y      ;subhi: R:d -= ,y
                        ;ashlhi: d by #1
        aslb
        rola
        tfr     d,y     ;movhi: R:d -> R:y
        ldx     14,s    ;movhi: 14,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        leax    d,y     ;addhi: R:x = R:y + R:d
        cmpd    10,s    ;cmphi:
        blt    L106
        pshs    y       ;subhi: R:d -= R:y
        subd    ,s++
        tfr     d,x     ;movhi: R:d -> R:x
L106:
        ldy     14,s    ;movhi: 14,s -> R:y
        stx     ,y      ;movhi: R:x -> ,y
        ldx     12,s    ;movhi: 12,s -> R:x
        jmp     L131
L105:
        ldb     26,s    ;movqi: 26,s -> R:b
        andb    #4      ;andqi: R:b &= #4
        tstb            ;tstqi: R:b
        beq    L108
        ldy     14,s    ;movhi: 14,s -> R:y
        ldd     ,y      ;movhi: ,y -> R:d
        ldu     _clip_xmax      ;movhi: _clip_xmax -> R:u
        pshs    u       ;subhi: R:d -= R:u
        subd    ,s++
        bra     L133
L108:
        ldu     _clip_xmin      ;movhi: _clip_xmin -> R:u
        tfr     u,d     ;movhi: R:u -> R:d
        ldy     14,s    ;movhi: 14,s -> R:y
        subd    ,y      ;subhi: R:d -= ,y
L133:
                        ;ashrhi: d by #1
        asra
        rorb
        tfr     d,y     ;movhi: R:d -> R:y
        ldx     12,s    ;movhi: 12,s -> R:x
        ldd     ,x      ;movhi: ,x -> R:d
        leax    d,y     ;addhi: R:x = R:y + R:d
        cmpd    8,s     ;cmphi:
        blt    L111
        pshs    y       ;subhi: R:d -= R:y
        subd    ,s++
        tfr     d,x     ;movhi: R:d -> R:x
L111:
        ldy     12,s    ;movhi: 12,s -> R:y
        stx     ,y      ;movhi: R:x -> ,y
        ldx     14,s    ;movhi: 14,s -> R:x
L131:
        stu     ,x      ;movhi: R:u -> ,x
L116:
        ldy     30,s    ;movhi: 30,s -> R:y
        ldx     28,s    ;movhi: 28,s -> R:x
        clrb            ;clrqi REG:b
        cmpx    _clip_ymax      ;cmphi:
        ble    L117
        ldb     #1      ;movqi: #1 -> R:b
        bra     L118
L117:
        cmpx    _clip_ymin      ;cmphi:
        bge    L118
        ldb     #2      ;movqi: #2 -> R:b
L118:
        cmpy    _clip_xmax      ;cmphi:
        ble    L120
        orb     #4      ;iorqi: b |= #4
        bra     L121
L120:
        cmpy    _clip_xmin      ;cmphi:
        bge    L121
        orb     #8      ;iorqi: b |= #8
L121:
        stb     26,s    ;movqi: R:b -> 26,s
L53:
        ldb     27,s    ;movqi: 27,s -> R:b
        orb     26,s    ;iorqi: b |= 26,s
        tstb            ;tstqi: R:b
        lbne    L56
        ldd     34,s    ;movhi: 34,s -> R:d
        subd    _clip_xmin      ;subhi: R:d -= _clip_xmin
        std     22,s    ;movhi: R:d -> 22,s
        ldd     _clip_ymin      ;movhi: _clip_ymin -> R:d
        subd    32,s    ;subhi: R:d -= 32,s
        std     20,s    ;movhi: R:d -> 20,s
        ldx     40,s    ;movhi: 40,s -> R:x
        ldb     #-1     ;movqi: #-1 -> R:b
        stb     ,x+     ;movqi: R:b -> ,x+
        ldb     21,s    ;movlsbqihi: 20,s -> R:b (with corrected memadress)
        addb    #127    ;addqi: R:b += #127
        stb     ,x+     ;movqi: R:b -> ,x+
        ldb     23,s    ;movlsbqihi: 22,s -> R:b (with corrected memadress)
        addb    #-128   ;addqi: R:b += #-128
        stb     ,x+     ;movqi: R:b -> ,x+
        ldb     #1      ;movqi: #1 -> R:b
        stb     ,x+     ;movqi: R:b -> ,x+
        ldd     _clip_ymin      ;movhi: _clip_ymin -> R:d
        subd    28,s    ;subhi: R:d -= 28,s
        subd    20,s    ;subhi: R:d -= 20,s
        stb     ,x+     ;movqi: R:b -> ,x+
        ldd     30,s    ;movhi: 30,s -> R:d
        subd    _clip_xmin      ;subhi: R:d -= _clip_xmin
        subd    22,s    ;subhi: R:d -= 22,s
        stb     ,x+     ;movqi: R:b -> ,x+
        stx     40,s    ;movhi: R:x -> 40,s
        ldb     24,s    ;movqi: 24,s -> R:b
        addb    #6      ;addqi: R:b += #6
        stb     24,s    ;movqi: R:b -> 24,s
L36:
        ldu     6,s     ;movhi: 6,s -> R:u
        cmpu    #-1     ;cmphi:
        lbne    L38
L37:
        ldb     24,s    ;extendqihi: 24,s -> R:d
        sex
;;;EPILOGUE
        puls    x,y,u   ;restore registers
        leas    30,s    ; deallocate auto variables
        rts             ; return from function
;;;-----------------------------------------
;;; END EPILOGUE for CohenSutherlandClip
;;;-----------------------------------------
