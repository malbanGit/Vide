
vpos_1:
vpos_y_1:
                DB lo(SQUARE_SIZE)
vpos_x_1:
                DB lo(-SQUARE_SIZE)
MIDDLE_CORRECT EQU -15

square_quarter_left_vlist:
                DB  $00, -SQUARE_SIZE, $00
                DB  $00, -SQUARE_SIZE, $00
                DB  $ff, SQUARE_SIZE, $00
                DB  $ff, SQUARE_SIZE, $00
                DB  $01

square_quarter_right_vlist:
                DB  $00, $00, SQUARE_SIZE
                DB  $00, $00, SQUARE_SIZE
                DB  $ff, -SQUARE_SIZE, $00
                DB  $ff, -SQUARE_SIZE, $00
                DB  $00, SQUARE_SIZE, -SQUARE_SIZE
                DB  $00, SQUARE_SIZE, -SQUARE_SIZE
                DB  $01
square_half_vlist:
                DB  $00, $00, SQUARE_SIZE
                DB  $00, $00, SQUARE_SIZE
                DB  $ff, -SQUARE_SIZE, $00
                DB  $ff, -SQUARE_SIZE, $00
                DB  $00, $00, -SQUARE_SIZE
                DB  $00, $00, -SQUARE_SIZE
                DB  $ff, SQUARE_SIZE, $00
                DB  $ff, SQUARE_SIZE, $00
                DB  $01
square_full_vlist:
                DB  $ff, $00, SQUARE_SIZE
                DB  $ff, $00, SQUARE_SIZE
                DB  $ff, -SQUARE_SIZE, $00
                DB  $ff, -SQUARE_SIZE, $00
                DB  $ff, $00, -SQUARE_SIZE
                DB  $ff, $00, -SQUARE_SIZE
                DB  $ff, SQUARE_SIZE, $00
                DB  $ff, SQUARE_SIZE, $00
                DB  $01

left_wall_vlist:
                DB  $ff, (WALL_SIZE*2), (-WALL_SIZE*2)
                DB  $00, -(WALL_SIZE*2), -(-WALL_SIZE*2)
                DB  $00, (-SQUARE_SIZE), $00
                DB  $00, (-SQUARE_SIZE), $00
                DB  $ff, -(WALL_SIZE*2), (-WALL_SIZE*2)
                DB  $01

left_return:
                DB  $00, SQUARE_SIZE , $00
                DB  $00, SQUARE_SIZE , (WALL_SIZE*2)
                DB  $00, (WALL_SIZE*2) , 0
                DB  $01
left_wall_vlist_first:
                DB  $ff, (WALL_SIZE*1), (-WALL_SIZE*1)
                DB  $00, -(WALL_SIZE*1), -(-WALL_SIZE*1)
                DB  $00, (-SQUARE_SIZE), $00
                DB  $00, (-SQUARE_SIZE), $00
                DB  $ff, -(WALL_SIZE*1), (-WALL_SIZE*1)
                DB  $01
left_return_first:
                DB  $00, SQUARE_SIZE , $00
                DB  $00, SQUARE_SIZE , (WALL_SIZE*1)
                DB  $00, (WALL_SIZE*1) , 0
                DB  $01

no_left_wall_vlist:
                DB  $ff, 0, (-WALL_SIZE*2)
                DB  $00, 0, -(-WALL_SIZE*2)
                DB  $00, (-SQUARE_SIZE), $00
                DB  $00, (-SQUARE_SIZE), $00
                DB  $ff, 0, (-WALL_SIZE*2)
                DB  $01

no_left_return:
                DB  $00, SQUARE_SIZE , $00
                DB  $00, SQUARE_SIZE , (WALL_SIZE*2)
                DB  $01

right_wall_vlist:
                DB  $00, $00, SQUARE_SIZE
                DB  $00, $00, SQUARE_SIZE
                DB  $ff, 2*WALL_SIZE, 2*WALL_SIZE
                DB  $00, -2*WALL_SIZE, -2*WALL_SIZE
                DB  $00, (-SQUARE_SIZE), $00
                DB  $00, (-SQUARE_SIZE), $00
                DB  $ff, -2*WALL_SIZE, 2*WALL_SIZE
                DB  $01

right_wall_vlist_first:
                DB  $00, $00, SQUARE_SIZE
                DB  $00, $00, SQUARE_SIZE
                DB  $ff, 1*WALL_SIZE, 1*WALL_SIZE
                DB  $00, -1*WALL_SIZE, -1*WALL_SIZE
                DB  $00, (-SQUARE_SIZE), $00
                DB  $00, (-SQUARE_SIZE), $00
                DB  $ff, -1*WALL_SIZE, 1*WALL_SIZE
                DB  $01

no_right_wall_vlist:
                DB  $00, $00, SQUARE_SIZE
                DB  $00, $00, SQUARE_SIZE
                DB  $ff, 0, 2*WALL_SIZE
                DB  $00, 0, -2*WALL_SIZE
                DB  $00, (-SQUARE_SIZE), $00
                DB  $00, (-SQUARE_SIZE), $00
                DB  $ff, 0, 2*WALL_SIZE
                DB  $01
