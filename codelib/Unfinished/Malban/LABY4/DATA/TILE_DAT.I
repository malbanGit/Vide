TILE_SIZE EQU 126
;'#'
tile0v:
                DB  $ff, $00, TILE_SIZE
                DB  $ff, -TILE_SIZE, 0
                DB  $ff, $00, -TILE_SIZE
                DB  $ff, TILE_SIZE, 0
                DB  $00, $00, TILE_SIZE
                DB  $01
;' '
tile11v:
                DB  $00, $00, TILE_SIZE
                DB  $01
;'v'
player_south_tile:
                DB  $0, 0, TILE_SIZE/2
                DB  $ff, -TILE_SIZE, 0
                DB  $ff, TILE_SIZE/2, -TILE_SIZE/2
                DB  $00, -TILE_SIZE/2, TILE_SIZE/2
                DB  $ff, TILE_SIZE/2, TILE_SIZE/2
                DB  $00, TILE_SIZE/2, 0
                DB  $01
player_north_tile:
                DB  $0, 0, TILE_SIZE/2
                DB  $ff, -TILE_SIZE, 0
                DB  $00, TILE_SIZE, 0
                DB  $ff, -TILE_SIZE/2, -TILE_SIZE/2
                DB  $00, TILE_SIZE/2, TILE_SIZE/2
                DB  $ff, -TILE_SIZE/2, TILE_SIZE/2
                DB  $00, TILE_SIZE/2, 0
                DB  $01
player_east_tile:
                DB  $0, -TILE_SIZE/2, 0
                DB  $ff, 0, TILE_SIZE
                DB  $ff, TILE_SIZE/2, -TILE_SIZE/2
                DB  $00, -TILE_SIZE/2, TILE_SIZE/2
                DB  $ff, -TILE_SIZE/2, -TILE_SIZE/2
                DB  $00, TILE_SIZE, TILE_SIZE/2
                DB  $01
player_west_tile:
                DB  $0, -TILE_SIZE/2, 0
                DB  $ff, 0, TILE_SIZE
                DB  $00, 0, -TILE_SIZE
                DB  $ff, TILE_SIZE/2, TILE_SIZE/2
                DB  $00, -TILE_SIZE/2, -TILE_SIZE/2
                DB  $ff, -TILE_SIZE/2, TILE_SIZE/2
                DB  $00, TILE_SIZE, TILE_SIZE/2
                DB  $01
