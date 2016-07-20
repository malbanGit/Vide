;***************************************************************************
DRAW_TILE_A macro

tile0:
                CMPA    #'#'
                BNE     tile1
                LDX     #tile0v
                LBRA    draw_tile
tile1:
                LDD     pos
                CMPD    my
                BNE     no_player
                LDA     look_direction
                CMPA    #SOUTH
                BNE     test_dir_north
                LDX     #player_south_tile
                BRA     draw_tile
test_dir_north:
                CMPA    #NORTH
                BNE     test_dir_east
                LDX     #player_north_tile
                BRA     draw_tile
test_dir_east:
                CMPA    #EAST
                BNE     test_dir_west
                LDX     #player_east_tile
                BRA     draw_tile
test_dir_west:
                LDX     #player_west_tile
                BRA     draw_tile
no_player:
                LDX     #tile11v
draw_tile:
 DRAW_VLP
;                JSR     Draw_VLp
                endm
;                RTS
