
        .globl offset

        ; produces an incorrect operand
        cp a,offset(iy)
        cp a,(iy+offset)
        cp a,#offset

        ; produces the correct operand
        cp offset(iy)
        cp (iy+offset)
        cp #offset


