/*
 * This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
 * Please forward any comments, corrections or additions back to Fred.
 *
 * Mine Storm
 */


      .org 0xE000;

MS_header:
       .word #MS_music;  /* Mine Storm music block pointer */
       .byte 0xF8;    /* height = -8 */
       .byte 0x50;    /* width = 80 */
       .byte 0x30;    /* rel y = 48 */
       .byte 0xE8;    /* rel x = -24 */
       .byte "MINE",0x80;
       .byte 0xF8;    /* height = -8 */
       .byte 0x50;    /* width = 80 */
       .byte 0x00;    /* rel y = 0 */
       .byte 0xDE;    /* rel x = -34 */
       .byte "STORM",0x80,0x00;

/* Start of the Mine Storm game */
MS_start:
       ldx   #0xC883;        /* Clear C883 - CBC5 */
PE019: clr   ,x+;
       cmpx  #0xCBC5;
       bne   PE019;

       jsr   $init_motion_dots;
       inc   $C824;
       lda   #0xBB;
       sta   $C880;          /* Store console enable flags in C880 */
       ldx   #0x0101;
       stx   $C881;          /* Store jstick mak in C881 */

restart_game:
       ldx   #0xC883;        /* Clear C883 - CB70 */
PE034: clr   ,x+;
       cmpx  #0xCB70;
       bne   PE034;
       bra   PE03D;

PE03D: jsr   $dptoC8;
       ldd   #0x0200;        /* Ask for number of players */
       jsr   $get_players_game;
       dec   0x79;           /* C879 contains # of players selected */
       clr   0x56;
       clr   0x9B;           /* C89B specifies which player is active */

       ldx   #0xC8A8;
       jsr   $set_dft_score; /* Initialize player 1 score */
       ldx   #0xC8AF;
       jsr   $set_dft_score; /* Initialize player 2 score */
       ldx   #0xC8F9;
       jsr   $set_dft_score; /* Initialize mine field # for player 1 */
       ldd   #0x0001;
       jsr   $add_d_to_x_in_bcd;
       ldx   #0xC900;
       jsr   $set_dft_score; /* Initialize mine field # for player 2 */
       ldd   #0x0001;
       jsr   $add_d_to_x_in_bcd;

       ldx   #mines_at_level_x; /* Initialize player 1 & 2's pointers */
       stx   0xC4;              /* into the structure describing which */
       stx   0xC6;              /* mines are at which level. */

       lda   #0x05;
       sta   0xD9;       /* Initialize # of ships for active player */
       sta   0xDA;       /* Initialize # of ships for player 1 */
       sta   0xDB;       /* Initialize # of ships for player 2 */
       bra   restart_same_level;


start_next_mine_level:
       jsr   $bring_ship_to_center;
       ldy   #0xC8C4;    /* Increment the pointer into the struct */
       lda   0x9B;       /* describing which mines are at which */
       ldx   a,y;        /* level, for the active player. */
       leax  4,x;
       stx   a,y;

       ldx   #mine_field_level_pointers;
       lda   0x9B;           /* Check the mine field level for */
       ldx   a,x;            /* the active player, and if it is */
       lda   5,x;            /* a multiple of 4, then award that */
       anda  #0x03;          /* player a bonus ship.           */
       bne   goto_next_mine_level;
       inc   0xD9;

goto_next_mine_level:
       ldd   #0x0001;              /* Increment active players mine */
       jsr   $add_d_to_x_in_bcd;   /* field level indicator. */
restart_same_level:
       jsr   $init_RAM_for_new_level;
       ldx   #0xC8C4;        /* Use the pointer in C8C4 (player 1) */
       lda   0x9B;           /* or C8C6 (player 2) to determine */
       ldx   a,x;            /* which mines are at this level. */
       lda   ,x;
       bmi   check_4_end_of_game; /* After level 13, skip any level whose */
       jsr   $seed_the_screen;    /* first byte is negative.              */
       bra   main_loop;

check_4_end_of_game:
       ldd   0xF0;           /* If C8F0 counts down to 0, then */
       subd  #0x0001;        /* start a new game; used as a delay */
       std   0xF0;           /* after a game is over.          */
       beq   start_a_new_game;

       /* Display 'game over' string, & both scores */
       pshs  dp;
       jsr   $dptoD0;
       jsr   $display_both_scores;
       ldu   #game_over;
       jsr   $MS_print_1_string7F;
       puls  dp;

       lda   0x0F;          /* If no buttons pressed, then see if */
       beq   main_loop;     /* we should goto advanced levels. */

       /*
        * Find out if a new hi score is available,
        * and then start up a new game.
        */
start_a_new_game:
       ldx   #0xC8A8;        /* See if player 1 has new hi score */
       ldu   #0xCBEB;
       jsr   $check_4_new_hi_score;
       ldx   #0xC8AF;        /* See if player 2 has new hi score */
       ldu   #0xCBEB;
       jsr   $check_4_new_hi_score;
       ldd   0xF0;
       lbne  restart_game;   /* Just start a new game */
       jsr   $reinit;
       clr   0x3B;           /* Flag that a hi score should be displayed */
       lds   #0xCBEA;
       jmp   $powerup_loop;  /* Go thru a complete reset sequence */

/*
 * This is the main loop during a players turn.  Control will
 * remain in this loop, until either a player clears a level,
 * or has his ship destroyed.
 */
main_loop:
       pshs  dp;
       jsr   $process_indirect_jumps;
       jsr   $draw_non_dead_mines;
       jsr   $process_jstick_and_buttons;
       jsr   $process_bullets;
       jsr   $reseed_screen;
       puls  dp;
       jsr   $check_bullets_for_hits;
       jsr   $check_ship_4_mine_collision;
       jsr   $check_ship_4_enemy_collision;
       jsr   $display_explosion_pattern;
       blo   main_loop;
       lda   0xBD;           /* See if cmd ship is disabled */
       lbeq  start_next_mine_level;
       lda   0xBE;           /* See if the game is over */
       lbne  check_4_end_of_game;
       jmp   $restart_same_level;


/*
 * This block of code is responsible for seeding the screen
 * at the beginning of play.  It will draw the enemy ship
 * as it moves from the top of the screen to the bottom.
 * After the field has been completely seeded, the mine
 * field number will be displayed.
 * I think that the x register, at entry, points to a
 * structure describing the types of mines for this level.
 */
seed_the_screen:
       stx   0xC2;           /* Save pointer to mine info */
       ldd   #0x7F00;
       std   0xDC;           /* C8DC contains enemy ship coords */
       sta   0xB7;           /* C8B7 is used as loop cntr (0x7F) */
       lda   #0x20;
       sta   0x9C;                   /* Set up 1 of the indirect */
       ldx   #generate_mine_coords;  /* jump ptrs, to generate some */
       stx   0x9D;                   /* mine coordinates.        */
       ldx   #0xC933;        /* Load mine buf addr into C8B9-C8BA */
       stx   0xB9;
       lda   #0x1D;          /* Load # of mines into C8B8 */
       sta   0xB8;
       clr   0x56;
       ldu   #MS_music;
       jsr   $init_sound2;
continue_seeding_screen:
       pshs  dp;
       jsr   $PE711;         /* Draw active players ship count */
       jsr   $init_sound;
       lda   0x26;           /* Decrement our loop counter, C8B7 */
       bita  #0x01;          /* every other pass.                */
       bne   PE15C;
       dec   0xB7;
PE15C: jsr   $process_indirect_jumps;

       /* This block draws the enemy ship */
       jsr   $display_both_scores;
       jsr   $do_sound;
       jsr   $draw_non_dead_mines;
       jsr   $intensity_to_5F;
       ldb   $C8B7;             /* Wait until screen is seeded, */
       beq   activate_4_mines;  /* then activate 1st 4 mines.   */
       ldx   #enemy_ship_pt1;
       ldy   $C8DC;
       jsr   $move_y_draw_x;    /* Draw the enemy ship */
       ldx   #enemy_ship_pt2;
       jsr   $move_y_draw_x;
       ldx   #enemy_ship_pt3;
       jsr   $move_y_draw_x;
       puls  dp;
       dec   0xDC;              /* Decrement y coord for enemy ship */
       bra   continue_seeding_screen;

/*
 * This routine is called at the beginning of a turn for the
 * active player.  It will activate the first 4 mines for
 * the level.  The type of mines activated are controlled
 * by the array whose pointer is contained in C8C2.
 */
activate_4_mines:
       puls  dp;
       clr   0x9C;
       lda   #0x04;          /* Use C8B7 as a loop counter */
       sta   0xB7;           /* Use C8B8 as a delay counter; when it */
       lda   #0x7F;          /* = 0, stop displaying the mine field */
       sta   0xB8;           /* level, and activate 1st 4 mine. */
PE198: lda   0xB7;
       beq   PE1E6;          /* Exit when loop counter = 0 */
       ldb   0xB8;
       beq   PE1A4;       /* Don't activate the mines until the */
       dec   0xB8;        /* counter in C8B8 = 0; this allows the */
       bra   PE1B6;       /* mine field level to stay displayed awhile */
PE1A4: ldb   0x26;
       andb  #0x1F;          /* After every 31 times thru waitrecal(), */
       bne   PE1B6;          /* activate another mine. */
       deca;
       sta   0xB7;           /* Decrement loop counter */
       ldx   0xC2;
       lda   a,x;            /* Determine what type mine this should be */
       ldb   #0x03;          /* Set generation number to 'largest'. */
       jsr   $activate_a_mine;
PE1B6: pshs  dp;
       jsr   $process_indirect_jumps;

       /* Tell user what mine field number this is */
       jsr   $intensity_to_7F;
       ldu   #mine_field;
       jsr   $MS_print_1_string7F;
       ldy   #0xE0F8;
       ldu   #mine_field_level_pointers;
       lda   $C89B;
       ldu   a,u;
       jsr   $move_y_print_string;

       jsr   $draw_non_dead_mines;
       jsr   $process_jstick_and_buttons;
       jsr   $process_bullets;
       puls  dp;
       jsr   $check_bullets_for_hits;
       jsr   $display_explosion_pattern;
       bra   PE198;
PE1E6: rts;


/*
 * This block of code generates random coordinates
 * for a single mine.  C8B9 contains a pointer to
 * the appropriate entry in the mine structure.
 * Before exiting, this routine will update the
 * pointer in C8B9 to point to the next entry.
 */
generate_mine_coords:
       dec   0xB8;           /* Decrement the mine counter (C8B8) */
       beq   PE239;          /* and exit when it equals 0. */
       inc   0xED;           /* Inc mine dot counter */
       jsr   $get_random_a;
       anda  #0x07;          /* Reset the ind jump counter, to */
       adda  #0x04;          /* generate the next set of mine  */
       sta   0x9C;           /* coordinates.                   */
       ldu   0xB9;           /* Load u register w/ mine structure ptr */
       lda   #0x80;          /* Flag that a mine is in this slot */
       sta   ,u;             /* Get the coordinates of enemy ship */
       ldd   0xDC;
       adda  #0x08;
       sta   4,u;            /* Save y coordinate in 4th slot */
       clr   5,u;
       stb   6,u;            /* Save x coordinate in 6th slot */
       clr   7,u;
generate_final_x_for_mine:
       jsr   $get_random_a;  /* Generate the final x position for */
       tsta;                 /* this mine.                        */
       bmi   PE21A;
       cmpa  #0x10;
       bge   PE214;
       adda  #0x0C;
PE214: cmpa  #0x60;
       ble   PE226;
       bra   generate_final_x_for_mine;
PE21A: cmpa  #0xF0;
       ble   PE220;
       suba  #0x0C;
PE220: cmpa  #0xA0;
       bge   PE226;
       bra   generate_final_x_for_mine;

PE226: sta   0x11,u;
       tfr   a,b;            /* Determine what the delta movement    */
       sex;                  /* value will be for this mine: -1 or 1 */
       ora   #0x01;
       sta   0x10,u;
       clr   2,u;            /* Start with a scale factor of 0 */
       leay  0x12,u;         /* Update C8B9 to point to next entry */
       sty   0xB9;
PE239: rts;

final_mine_scale_factor:
       .byte 0x00;
       .byte 0x02;           /* Small */
       .byte 0x07;           /* Medium */
       .byte 0x10;           /* Large */

mine_velocity:
       .byte 0x00;
       .byte 0x20;           /* Small */
       .byte 0x18;           /* Medium */
       .byte 0x10;           /* Large */

mine_values:
       .byte 0x01;           /* dumb mine = BCD 100 */
       .byte 0x00;
       .byte 0x05;           /* magnetic mine = BCD 500 */
       .byte 0x00;
       .byte 0x03;           /* fireball mine = BCD 325 */
       .byte 0x25;
       .byte 0x07;           /* magnetic fireball mine = BCD 750 */
       .byte 0x50;

extra_mine_value:
       .byte 0x00;
       .byte 0x00;
       .byte 0x01;           /* Small (100) */
       .byte 0x00;
       .byte 0x00;           /* Medium (35) */
       .byte 0x35;
       .byte 0x00;           /* Large (0) */
       .byte 0x00;

mine_sizes:
       .byte 0x00;
       .byte 0x00;
       .byte 0x04;           /* Small */
       .byte 0x04;
       .byte 0x08;           /* Medium */
       .byte 0x08;
       .byte 0x0D;           /* Large */
       .byte 0x0D;

/* Table of pointers to mine vectors */
mine_vector_ptrs:
       .word #dumb_mine;
       .word #magnetic_mine;
       .word #fireball_mine;
       .word #magnetic_fireball_mine;


/*
 * This block of code processe the hyperspace and move
 * buttons.  It also checks the state of the joystick,
 * and updates the command ship rotation value, kept
 * in C8D4, if the joystick is not centered.  If the
 * joystick is left, then the rotation value is
 * incremented; if it is to the right, then the rotation
 * value is decremented.  After updating the rotation
 * value, the command ship will be redrawn at its
 * current position (specified in C8C8-C8C9).
 */
process_jstick_and_buttons:
       pshs  dp;
       lda   #0xC8;
       tfr   a,dp;
       lda   0xBD;           /* Skip if cmd ship disabled */
       lbne  PE30A;
       lda   0xEE;           /* Continue hyperspace, if active */
       lbne  continue_hyperspace;
       lda   0x13;           /* Check the hyperspace button (2) */
       lbne  hyperspace;
       lda   0x14;           /* Check the move button (3) */
       beq   no_ship_movement;

       /*
        * The following block of code takes care of
        * generating the new command coordinates,
        * because it is moving.  It attempts to make
        * all turns into smooth motion.
        */
       lda   0xD4;
       cmpa  0xD6;
       beq   PE2A0;
       cmpa  0xD8;
       beq   PE290;
       lda   0xD5;
       beq   PE2A0;
       lda   0xD7;
       bne   no_ship_movement;
PE290: lda   0xD7;
       adda  #0x0C;
       cmpa  #0x7F;
       bhi   no_ship_movement;
       sta   0xD7;
       lda   0xD4;
       sta   0xD8;
       bra   PE2AE;
PE2A0: lda   0xD5;
       adda  #0x0C;
       cmpa  #0x7F;
       bhi   no_ship_movement;
       sta   0xD5;
       lda   0xD4;
       sta   0xD6;
PE2AE: inc   0xF2;           /* Flag that a sound should be made */

no_ship_movement:
       lda   0xD5;
       beq   PE2C2;
       suba  #0x02;
       sta   0xD5;
       ldb   0xD6;
       jsr   $calc_rise_run1;
       sty   0xCC;
       stx   0xCE;
PE2C2: lda   0xD7;
       beq   PE2D4;
       suba  #0x02;
       sta   0xD7;
       ldb   0xD8;
       jsr   $calc_rise_run1; /* Generate new rise & run */
       sty   0xD0;
       stx   0xD2;
PE2D4: ldd   0xC8;           /* Update cmd ships y coord */
       addd  0xCC;
       addd  0xD0;
       std   0xC8;
       ldd   0xCA;           /* Update cmd ships x coord */
       addd  0xCE;
       addd  0xD2;
       std   0xCA;

       /* Check joystick state (in C81B) */
       lda   0x1B;
       beq   draw_cmd_ship1; /* Joystick is centered */
       bmi   PE2EE;
       dec   0xD4;           /* Joystick to right */
       bra   draw_cmd_ship2;
PE2EE: inc   0xD4;           /* Joystick to left */
       bra   draw_cmd_ship2;
PE2F2: pshs  dp;

/*
 * draw_cmd_ship2() runs the command ships coordinates
 * thru a rotation transformation, and then draws the
 * command ship using the transforms coordinates.
 * draw_cmd_ship1() draws the command ship using the
 * current transformed ship coordinates.
 */
draw_cmd_ship2:
       jsr   $rotate_cmd_ship; /* Rotate the command ship */
draw_cmd_ship1:
       lda   #0xD0;
       tfr   a,dp;
       jsr   $intensity_to_5F;
       ldb   #0x0C;
       ldy   #0xC8C8;        /* Draw the xformed command ship */
       ldx   #0xCB89;
       jsr   $move_y_draw_x2;
PE30A: puls  dp,pc;


/* This routine handles the hyperspace request */
hyperspace:
       lda   #0x80;
       sta   0xEE;
       jsr   $get_random_a;
       anda  #0x03;
       adda  #0x03;
       sta   0xEF;
       inc   0xF6;
continue_hyperspace:
       lda   0xEE;
       bpl   process_hyperspace_dots;
       dec   0xEF;
       beq   PE330;
       jsr   $MS_get_2_random_nums;
       sta   0xC8;
       clr   0xC9;           /* Generate new coordinates */
       stb   0xCA;           /* for the command ship.    */
       clr   0xCB;
       puls  dp,pc;
PE330: lsr   0xEE;
       lda   #0x1F;
       sta   0xEF;
       puls  dp,pc;


/*
 * This code draws the ever decreasing hyperspace dots
 * during an active hyperspace.  The scale factor for
 * the hyperspace dots, stored in C8EF, is decremented,
 * and when it finally reaches a minimum value, the
 * hyperspace is complete.
 */
process_hyperspace_dots:
       ldb   0xEF;           /* See if scale factor has reached */
       cmpb  #0xE0;          /* the limit.                      */
       ble   hyperspace_complete;
       lda   0xEF;
       suba  #0x04;          /* Decrement the scale factor      */
       sta   0xEF;
       clra;
       jsr   $draw_hyperspace_motion_dots;
       puls  dp,pc;

hyperspace_complete:
       clr   0xEF;
       clr   0xEE;
       jsr   $clear_cmd_ship_xformation;
       puls  dp,pc;


/*
 * After the player has cleared all but the small mines
 * from a layer, the enemy ship will again appear, and
 * attempt to reseed the screen.  This code checks to
 * see if the enemy ship is visible (C8E7), and if it
 * is, then it generates new coordinates for it, and
 * then moves it.
 */
reseed_screen:
       lda   $C8E7;
       beq   PE383;          /* Do only if ship is visible */
       pshs  dp;
       lda   #0xC8;
       tfr   a,dp;
       lda   0xE7;
       beq   PE383;
       ldd   0xDE;
       addd  0xE2;
       std   0xDE;
       sta   0xDC;           /* New y coordinate */
       ldd   0xE0;
       addd  0xE4;
       std   0xE0;
       sta   0xDD;           /* New x coordinate */
       puls  dp;
       jsr   $intensity_to_5F;
       ldb   #0x08;
       ldy   $C8DC;
       ldx   #simple_enemy_ship;
       jsr   $move_y_draw_x;  /* Draw the enemy ship */
PE383: rts;


/*
 * This procedure is invoked only through the indirect jump
 * pointers.  After only small mines are left, this routine
 * will eventually be called.  It will determine which way
 * the enemy ship will move, and will also set up another
 * indirect jump to the routine which does the actual
 * reseeding of the screen.
 */
ind_init_screen_reseeding:
       ldx   #ind_reseed_screen;
       stx   0xA3;           /* Set up next indirect jump ptr */
       jsr   $get_random_a;
       ldx   #0xE448;        /* Determine where enemy ship will move */
       anda  #0x06;
       ldx   a,x;
       ldd   ,x++;
       std   0xDC;           /* Save enemy ships new coordinates */
       sta   0xDE;
       clr   0xDF;
       stb   0xE0;
       clr   0xE1;
       bra   PE3F9;


/*
 * This routine is invoked only through the indirect jump
 * mechanism.  It will continue to be called, until either
 * the enemy ship is destroyed, or until the screen has
 * been reseeded.  It will reseed upto 7 new mines.
 */
ind_reseed_screen:
       lda   0xBF;           /* See if all mines have been seeded */
       bne   PE3BE;
PE3A5: jsr   $get_random_a;
       anda  #0x7F;
       adda  #0x30;          /* Set up the indirect jump counter 4 */
       sta   0xA2;           /* the next pass.                     */
       jsr   $get_random_a;
       anda  #0x3F;
       sta   0xE6;
       jsr   $get_random_a;
       adda  #0x10;
       sta   0xE7;
       bra   PE407;
PE3BE: lda   0xBD;
       bne   PE3A5;

       /*
        * Load the b register with the number of mines (28),
        * and load the u register with the pointer to the
        * mine structure.  Then look through the mine structure
        * for an available slot, and fill it with the newly
        * seeded mine.
        */
       ldb   #0x1C;
       ldu   #0xC933;
PE3C7: lda   ,u;             /* Look for an unused mine */
       beq   found_avail_mine;
       leau  0x12,u;
       decb;
       bne   PE3C7;
       bra   PE407;

found_avail_mine:
       inc   0xED;           /* Incr the # of mines which R dots */
       dec   0xBF;           /* Decrement the reseed counter */
       ldx   0xDE;
       stx   4,u;            /* Set y coordinate for mine */
       ldx   0xE0;
       stx   6,u;            /* Set x coordinate for mine */
       lda   #0x40;
       sta   ,u;             /* Flag that mine is a stationary dot. */
       lda   0xC0;           /* See if this is 1st mine activated. */
       bne   PE3F7;
       ldx   #ind_start_large_mine;
       stx   0x9D;                  /* Set things up to eventually */
       jsr   $get_random_a;         /* activate 1 large mine.      */
       anda  #0x7F;
       adda  #0x40;
       sta   0x9C;
       inc   0xC0;           /* Flag that 1st mine has been activated */
PE3F7: ldx   0xE8;
PE3F9: lda   ,x+;
       sta   0xA2;
       lda   ,x+;
       sta   0xE6;
       lda   ,x+;
       sta   0xE7;
       stx   0xE8;
PE407: ldb   0xE6;
       jsr   $calc_rise_run1; /* Generate rise & run for mine */
       sty   0xE2;
       stx   0xE4;
       rts;

/*
 * This routine is called only thru the indirect jump
 * handler.  It is responsible for activating a single
 * large mine.  The type of mine is indicated by the
 * first entry in the table of mines for this level.
 */
ind_start_large_mine:
       ldu   #0xC8C4;
       lda   0x9B;
       ldu   a,u;
       lda   ,u;             /* Determine the type of mine */
       ldb   #0x03;          /* Set generation to 'largest' */
       jsr   $activate_a_mine;
       ldx   #ind_activate_rangen_mine;
       stx   0x9D;
       rts;

/*
 * This routine decrements the counter in C8C1, and if
 * it equal 0, then it activates a mine with a random
 * generation number; else, it sets the indirect counter
 * in C89C to -1, and returns.  This routine is called
 * only thru the indirect jump handler.
 */
ind_activate_rangen_mine:
       dec   0xC1;
       beq   PE430;
       lda   #0xFF;
       sta   0x9C;
       bra   PE447;
PE430: jsr   $get_random_a;
       tfr   a,b;
       andb  #0x03;
       bne   PE43B;
       addb  #0x01;
PE43B: ldu   #0xC8C4;
       lda   0x9B;
       ldu   a,u;
       lda   ,u;
       jsr   $activate_a_mine;
PE447: rts;


/* Some sort of pointer table */
SE448: .word #SE450;
       .word #SE46A;
       .word #SE484;
       .word #SE49E;

SE450: .byte 0x7F;
       .byte 0x00;
       .byte 0x28;
       .byte 0x20;
       .byte 0x30;
       .byte 0x40;
       .byte 0x28;
       .byte 0x30;
       .byte 0x28;
       .byte 0x00;
       .byte 0x10;
       .byte 0x30;
       .byte 0x10;
       .byte 0x40;
       .byte 0x18;
       .byte 0x20;
       .byte 0x50;
       .byte 0x40;
       .byte 0x30;
       .byte 0x28;
       .byte 0x30;
       .byte 0x08;
       .byte 0x60;
       .byte 0x7F;
       .byte 0x38;
       .byte 0x70;

SE46A: .byte 0x80;
       .byte 0x00;
       .byte 0x40;
       .byte 0x00;
       .byte 0x30;
       .byte 0x20;
       .byte 0x10;
       .byte 0x50;
       .byte 0x20;
       .byte 0x28;
       .byte 0x40;
       .byte 0x30;
       .byte 0x3E;
       .byte 0x70;
       .byte 0x18;
       .byte 0x30;
       .byte 0x60;
       .byte 0x20;
       .byte 0x18;
       .byte 0x40;
       .byte 0x30;
       .byte 0x24;
       .byte 0x50;
       .byte 0x7F;
       .byte 0x06;
       .byte 0x70;

SE484: .byte 0x00;
       .byte 0x7F;
       .byte 0x40;
       .byte 0x10;
       .byte 0x60;
       .byte 0x28;
       .byte 0x38;
       .byte 0x30;
       .byte 0x28;
       .byte 0x08;
       .byte 0x40;
       .byte 0x30;
       .byte 0x28;
       .byte 0x7F;
       .byte 0x20;
       .byte 0x18;
       .byte 0x30;
       .byte 0x30;
       .byte 0x08;
       .byte 0x68;
       .byte 0x40;
       .byte 0x20;
       .byte 0x50;
       .byte 0x7F;
       .byte 0x38;
       .byte 0x70;

SE49E: .byte 0x00;
       .byte 0x80;
       .byte 0x40;
       .byte 0x30;
       .byte 0x60;
       .byte 0x38;
       .byte 0x18;
       .byte 0x30;
       .byte 0x30;
       .byte 0x20;
       .byte 0x18;
       .byte 0x20;
       .byte 0x38;
       .byte 0x40;
       .byte 0x28;
       .byte 0x10;
       .byte 0x60;
       .byte 0x20;
       .byte 0x00;
       .byte 0x30;
       .byte 0x40;
       .byte 0x38;
       .byte 0x50;
       .byte 0x7F;
       .byte 0x1C;
       .byte 0x70;


/*
 * This routine is responsible for displaying any active
 * bullets, and also for firing new bullets, when an
 * available spot in the bullet structure becomes available.
 * The maximum number of active bullets is 4.  The 40 byte
 * bullet structure starts at C90B.  A bullet will remain
 * 'active' for at most 0x18 passes thru this routine.
 */
process_bullets:
       lda   #0x04;          /* Loop counter = 4 */
       ldu   #0xC90B;        /* Bullet buffer */
       ldx   #0xC815;        /* State of fire button (4) */
       sta   $C88F;
       jsr   $intensity_to_7F;
next_bullet:
       lda   ,u;                /* If the current spot is empty, then */
       beq   check_fire_button; /* see if a new bullet should be fired */
       dec   9,u;            /* Decrement the cycle counter for the */
       beq   erase_bullet;   /* and erase bullet if it = 0.  */
       ldd   5,u;
       addd  1,u;    /* y */
       std   5,u;            /* Increment bullet coordinates */
       ldd   7,u;
       addd  3,u;    /* x */
       std   7,u;
       leay  5,u;
       jsr   $draw_dot7F_ptr_in_y;     /* Draw bullet */
update_bufr_ptr:
       leau  10,u;
       dec   $C88F;          /* Point to next entry */
       bne   next_bullet;
       rts;

erase_bullet:
       clr   ,u;
       dec   $C8EA;          /* Decrement active bullet counter */
check_fire_button:
       lda   $C8BD;
       bne   update_bufr_ptr;
       lda   $C8EE;
       bne   update_bufr_ptr;
       lda   ,x;             /* Check the 'fire' button state */
       beq   update_bufr_ptr;

       /*
        * This code 'fires' a new bullet, and fills the
        * available spot in the bullet structure.
        */
       clr   ,x;
       inc   $C8B6;          /* Flag that a bullet sound should be made */
       inc   ,u;
       ldd   $C8C8;          /* Get ships coordinates */
       std   5,u;
       ldd   $C8CA;
       std   7,u;
       ldd   $C907;          /* Get ship rise */
       std   1,u;
       ldd   $C909;          /* Get ship run */
       std   3,u;
       lda   #0x18;          /* # of passes before bullet expires */
       sta   9,u;
       inc   $C8EA;          /* Increment active bullet counter */
       bra   update_bufr_ptr;


/*
 * This procedure processes each mine which has not been
 * destroyed.  If the mine is a moving dot, then its position
 * is updated; if the mine is a dot, then it is draw in its
 * appropriate place; if the mine is active, then the appropriate
 * mine is drawn; if it is a fireball, then the fireball is drawn.
 * The state of the mine is determined by the first byte in the
 * mine structure.  The following values are valid:
 *
 *      0x00 - Mine is dead.
 *      0x01 - Mine is in process of being destroyed.
 *      0x08 - Mine is visible and moving.
 *      0x10 - Mine is visible, but not moving.
 *      0x20 - Mine is just becoming visible.
 *      0x40 - Mine is a stationary dot.
 *      0x80 - Mine is still moving to final resting place.
 *
 */
draw_non_dead_mines:
       lda   #0x1C;
       sta   $C88F;          /* Use C88F as a loop counter */
       ldu   #0xC933;        /* Put mine pointer into u register */
PE526: lda   ,u;
       bne   non_dead_mine;
update_mine_ptr:
       leau  0x12,u;
       dec   $C88F;
       bne   PE526;
       rts;

non_dead_mine:
       lbmi  move_mine_dot;
       bita  #0x40;
       lbne  draw_mine_as_dot;
       bita  #0x20;
       lbne  mine_becoming_visible;
       bita  #0x10;
       lbne  delay_B4_moving_mine;
       bita  #0x01;
       lbne  process_destroyed_mine;
       lda   1,u;
       cmpa  #0x04;          /* See if this is a fireball */
       beq   process_fireball;
       bita  #0x01;          /* Code below moves visible mine */
       beq   non_magnetic_mine;
       lda   $C8EE;          /* Skip below if hyperspace active */
       bne   non_magnetic_mine;
       lda   $C8BD;          /* Skip below if cmd ship disabled */
       bne   non_magnetic_mine;
       pshs  dp;
       jsr   $dptoC8;
       lda   0xC8;           /* Draw the mine towards the cmd ship */
       suba  4,u;
       ldb   0xCA;
       subb  6,u;
       jsr   $PF593;
       suba  #0x10;
       sta   0x83;
       ldx   #mine_velocity;
       ldb   3,u;
       lda   b,x;
       ldb   0x83;
       jsr   $calc_rise_run1; /* Calculate new rise and run values */
       sty   8,u;
       stx   10,u;
       puls  dp;
non_magnetic_mine:
       ldd   4,u;            /* This block update mine coordinates */
       addd  8,u;
       std   4,u;
       ldd   6,u;
       addd  10,u;
       std   6,u;

/*
 * This block of code draws a mine, using information in
 * the mine structure element pointed to by the u register.
 */
draw_a_visible_mine:
       jsr   $intensity_to_5F;
       ldx   #mine_vector_ptrs;
       lda   1,u;            /* byte 1 = mine type */
       asla;
       ldx   a,x;            /* Set x = ptr to mine vector list */
       leay  4,u;            /* Set y = mine coordinates. */
       ldb   2,u;            /* Set b = scale factor.     */
       jsr   $move_y_draw_x2;
       jmp   $update_mine_ptr;

/*
 * This routine appears to be processing a fireball.
 * It checks to see if the fireball has reached the
 * edge of the display, and if it has, then the
 * fireball is removed; else, the fireball is drawn
 * on the display.
 */
process_fireball:
       ldd   4,u;            /* See if the fireball has */
       addd  8,u;            /* reached the edge of the */
       bvs   remove_fireball;  /* display. */
       std   4,u;
       ldd   6,u;
       addd  10,u;
       bvs   remove_fireball;
       std   6,u;
       jsr   $intensity_to_7F;
       leay  4,u;            /* Draw the fireball */
       ldx   #0xCBA7;
       ldb   #0x04;
       jsr   $move_y_draw_x2;
       jmp   $update_mine_ptr;

remove_fireball:
       clr   ,u;             /* Flag that the fireball has */
       dec   $C8EB;          /* been removed. */
       jmp   $update_mine_ptr;


/*
 * move_mine_dot () does some sort of processing on the
 * mine's coordinates, and then draws the mine as
 * a dot.  I believe that the processing being done
 * is the movement of the dot in the x direction,
 * after the mine field has been seeded, but before
 * the mine dot has reached it's final place.
 * draw_mine_as_dot() draws a mine as a dot.
 *
 * For both these routines, the u register must
 * point to a structure element describing the
 * mine.
 */
move_mine_dot:
       lda   6,u;              /* Update the mines x coordinate, */
       adda  0x10,u;           /* and check to see if it has reached */
       sta   6,u;              /* its final resting place.       */
       cmpa  0x11,u;
       bne   draw_mine_as_dot; /* Flag that the mine dot is at its */
       lsr   ,u;               /* final resting place. */
draw_mine_as_dot:
       jsr   $intensity_to_5F;
       leay  4,u;
       jsr   $draw_dot7F_ptr_in_y;
       jmp   $update_mine_ptr;


/*
 * This procedure is called when a mine first becomes visible.
 * If the mine is not a large mine, then the mine is drawn at
 * full scale factor; otherwise, if the mine is a large mine,
 * then it will be drawn with a steadily increasing scale factor.
 * This gives the effect of the mine 'popping' up.
 */
mine_becoming_visible:
       lda   3,u;
       cmpa  #0x03;          /* See if this is a large mine */
       bne   use_max_scale_factor;
       lda   2,u;
       cmpa  0x10,u;
       bge   use_max_scale_factor;
       adda  #0x08;
       sta   2,u;            /* Increment the scale factor */
       bra   PE61A;
use_max_scale_factor:
       lsr   ,u;             /* Flag that mine is full size & visible */
       lda   0x10,u;
       sta   2,u;            /* Set final scale factor */
       lda   #0x18;
       sta   0x10,u;         /* Set up a delay */
       lda   $C8ED;
       bne   PE61A;          /* Check to see if any more mine dots left */
       lda   $C8C0;
       bne   PE61A;          /* See if re-seeding already in progress. */
       lda   #0x7F;          /* Set up indirect counter for reseeding */
       sta   $C8A2;          /* since only small mines are left. */
PE61A: jmp   $draw_a_visible_mine;


/*
 * This procedure is used to delay the movement of a mine
 * right after it become visible.  After the delay is over,
 * the mine will start moving.
 */
delay_B4_moving_mine:
       dec   0x10,u;         /* Decrement delay counter */
       bne   PE624;
       lsr   ,u;
PE624: jmp   $draw_a_visible_mine;


/*
 * This procedure processes the activation of 2 new mines
 * after a mine has been destroyed.  If the destroyed mine
 * was a small mine, or a fireball, then 2 new mines will
 * not be activated.  At entry time, the 'a' register must
 * contain the type of mine to be started up.
 */
process_destroyed_mine:
       clr   ,u;             /* Flag that this mine is gone */
       lda   1,u;
       cmpa  #0x04;          /* If this was a fireball, then don't */
       beq   PE644;          /* start up 2 new mines. */
       ldb   3,u;
       decb;                 /* If this was a small mine, then don't */
       beq   PE644;          /* start up 2 new mines. */
       pshs  a,dp;
       lda   #0xC8;
       tfr   a,dp;
       lda   ,s;             /* Get the type of mine */
       jsr   $activate_a_mine;
       jsr   $activate_a_mine;
       puls  a,dp;
PE644: jmp   $update_mine_ptr;


/*
 * This routine is responsible for displaying the explosion
 * pattern for all active explosions.  If the command ship
 * is sexploding, then it will also switch over to the
 * next player (eventually).
 */
display_explosion_pattern:
       pshs  dp;
       jsr   $dptoD0;
       jsr   $intensity_to_7F;
       ldu   #0xCB2B;        /* Get pointer to the explosion struct */
       lda   #0x0E;
       sta   $C88F;          /* Use C88F as a loop counter */
check_next_explosion:
       lda   ,u;
       lbeq  inc_expl_ptr;
       ldb   4,u;            /* If the scale factor for the explosion */
       cmpb  1,u;            /* has not surpassed the max value, then */
       bhs   chk_4_cmd_ship_explosion;    /* increment it.   */
       addb  #0x03;
       stb   4,u;
       ldy   2,u;
       ldx   #explosion;     /* Draw the explosion pattern */
       jsr   $move_y_draw_x;

chk_4_cmd_ship_explosion:
       tsta;                 /* This is a cmd ship explosion if bit */
       lbpl  check_4_expired_explosion; /* 0x80 is set. */
       dec   $C8F7;          /* Stop displaying explosion when C8F7 */
       lbeq  dead_ship;      /* reaches zero. */
       lda   $C826;
       anda  #0x01;              /* Every other pass through the loop, */
       bne   draw_expl_cmd_ship; /* increment the scale factor used to */
       inc   $C8F8;              /* draw the destroyed command ship. */

draw_expl_cmd_ship:
       lda   $C8F8;          /* Draw the cmd ship in pieces. */
       ldy   #0x7F00;
       ldx   #cmd_ship_pt1;
       jsr   $draw_cmd_ship_fragment;
       ldy   #0x6080;
       ldx   #cmd_ship_pt2;
       jsr   $draw_cmd_ship_fragment;
       ldy   #0x8050;
       ldx   #cmd_ship_pt3;
       jsr   $draw_cmd_ship_fragment;
       ldy   #0xA080;
       ldx   #cmd_ship_pt4;
       jsr   $draw_cmd_ship_fragment;
       bra   inc_expl_ptr;

/*
 * This routine is called after a ship has been destroyed.
 * The number of ships for the active player, kept in C8D9,
 * will be decremented.  If more than one player is playing,
 * then save the active players ship count in a memory
 * location (C8DA for player 1, and C8DB for player 2),
 * and then determine who's turn it now is.
 */
dead_ship:
       dec   $C8D9;          /* Decrement the number of ships */
       clr   $C8EB;
       clr   $C8ED;

       lda   $C879;            /* If more than 1 player is playing, */
       beq   check_ship_count; /* then save the active players ship */
       lda   $C89B;            /* ship count in RAM.                */
       lsra;
       ldx   #0xC8DA;
       ldb   $C8D9;
       stb   a,x;

       lda   $C8DA;          /* See who's turn it is.  Skip a player */
       bne   next_player;    /* if he has no more ships.             */
       lda   $C8DB;
       beq   flag_no_ships_left;

next_player:
       lda   $C89B;          /* Increment active player indicator */
       adda  #0x02;
       anda  #0x02;
       sta   $C89B;

       lsra;                 /* Load the ship count for new player */
       ldx   #0xC8DA;
       ldb   a,x;
       stb   $C8D9;
       beq   next_player;

/*
 * This routine checks to see if the active player has any ships
 * left, after the command ship has exploded.
 */
check_ship_count:
       lda   $C8D9;
       bne   explosion_expired;
flag_no_ships_left:
       lda   #0x01;
       sta   $C8BE;          /* Set C8BE when no ships left */
       bra   explosion_expired;

/*
 * This routine checks to see if the explosion has expired.
 * An explosion expires when its scale factor surpasses a
 * preset maximum value.
 */
check_4_expired_explosion:
       ldb   4,u;            /* See if scale factor has reached */
       cmpb  1,u;            /* the maximum value allowed. */
       blo   inc_expl_ptr;
explosion_expired:
       clr   ,u;
       dec   $C8EC;          /* Flag completion of cmd ship explosion */

inc_expl_ptr:
       leau  5,u;
       dec   $C88F;
       lbne  check_next_explosion;
       jsr   $make_misc_sounds;
       bra   draw_tiny_ships;

/* Draw the tiny ships in lower righthand corner */
PE711: pshs  dp;
       jsr   $dptoD0;
draw_tiny_ship:
       jsr   $intensity_to_5F;
       ldx   #0x8038;
       stx   $C890;                   /* Position for first ship */
       lda   $C8D9;                   /* Don't bother, if the active */
       beq   rotate_fireball_vectors; /* player has no ships left. */
       sta   $C88F;
PE727: dec   $C88F;
       beq   rotate_fireball_vectors; /* Exit when all ships drawn */
       lda   $C891;
       adda  #0x06;          /* Increment x coordinate */
       sta   $C891;
       ldb   #0x04;
       ldy   $C890;
       ldx   #command_ship;
       jsr   $move_y_draw_x; /* Draw the tiny command ship */
       bra   PE727;

/*
 * This routine rotates the fireball vector list.  Also,
 * it checks to see whether this level has been cleared.
 */
rotate_fireball_vectors:
       puls  dp;
       lda   0x26;
       anda  #0x01;
       asla;
       asla;
       asla;
       ldx   #fireball;
       ldu   #0xCBA7;
       jsr   $rotate_vector_list1;

       /*
        * This block of code determines whether or not the main
        * loop should be exited.  If the cmd ship is disabled, or
        * if the player has cleared the level, then the main loop
        * will be exited (this is flagged by clearing the carry bit.
        */
       ldb   0xEC;           /* See if cmd ship is being exploded */
       bne   PE767;
       lda   0xBD;           /* See if cmd ship is disabled */
       bne   PE764;
       ldb   0xEB;           /* check # of active mines */
       bne   PE767;
       ldb   0xED;           /* check # of dot mines */
       bne   PE767;
PE764: andcc #0xFE;          /* Says 'exit main loop' */
       rts;
PE767: orcc  #0x01;          /* Says 'do not exit main loop' */
       rts;


/*
 * This routine is responsible for drawing a single fragment
 * of the exploding command ship.  At entry, 'a' = scale factor,
 * 'y' = pen position, and 'x' = ptr to vector list.
 */
draw_cmd_ship_fragment:
       pshs  a,x,y;
       ldx   #0xC8C8;        /* Move pen to cmd ships location */
       jsr   $move_pen7F_no_inc;
       lda   ,s;
       sta   0x04;           /* Set scale factor = a register */
       tfr   y,d;
       jsr   $move_pen_d;    /* Move pen to position in y register */
       ldb   #0x0C;
       ldx   1,s;
       jsr   $drawl1b;       /* Draw vector list pointed to by x reg */
       puls  a,x,y,pc;


/*
 * This routine is called after a bullet has hit something,
 * or the command ship collides with something.  It will
 * search through the explosion structure, looking for an
 * empty slot.  When it finds one, it will fill it with the
 * information passed in.  At entry time, 'a' = type of explosion
 * and the scale factor to use, 'b' = the max scale factor to
 * be used, and 'x' contains the position for the explosion.
 * If the hi bit of 'a' is set, then that flags that it is the
 * command ship exploding; the lower 7 bits are used to specify
 * the initial scale factor.
 */
add_an_explosion:
     : pshs  a,b,x;
       ldx   #0xCB2B;
       lda   #0x0E;
PE78B: ldb   ,x;             /* Find an empty spot in structure */
       beq   found_empty_exp_slot;
       leax  5,x;
       deca;
       bne   PE78B;
       bra   PE7B3;

found_empty_exp_slot:
       lda   ,s;             /* Save the explosion type */
       anda  #0x80;
       inca;
       sta   ,x;             /* See if this is a cmd ship explosion */
       bpl   PE7A1;
       inc   0xBD;           /* Flag that cmd ship is disabled */
PE7A1: lda   ,s;
       anda  #0x7F;
       sta   4,x;            /* Save starting scale factor */
       lda   1,s;
       sta   1,x;
       ldd   2,s;
       std   2,x;            /* Save maximum scale factor */
       inc   0xEC;           /* Flag that cmd ship is exploding */
       inc   0xF3;           /* Flag that explosion sound should be made */
PE7B3: puls  a,b,x,pc;


/*
 * This routine is responsible for calculating a rise and run
 * for an object whose angle of travel is in the 'b' register,
 * and whose velocity is in the 'a' register.
 * The rise is returned in the 'y' register, and the run is
 * returned in the 'x' register.
 */
calc_rise_run1:
       pshs  a,b,x,y;
       jsr   $rotate_1_coordinate;
       sta   4,s;
       sex;
       aslb;
       rola;
       aslb;
       rola;
       aslb;
       rola;
       std   2,s;
       ldb   4,s;
       sex;
       aslb;
       rola;
       aslb;
       rola;
       aslb;
       rola;
       std   4,s;
       puls  a,b,x,y,pc;


/*
 * This routine also calculates some sort of rise & run pair.
 * The same parameters are expected at entry time, and the
 * values are returned in the same registers.
 */
calc_rise_run2:
       pshs  a,b,x,y;
       bsr   calc_rise_run1;
       ldd   -4,s;
       aslb;
       rola;
       std   4,s;
       ldd   -6,s;
       aslb;
       rola;
       std   2,s;
       puls  a,b,x,y,pc;


/*
 * This routine is called each time a new mine level is
 * started.  It initializes everything necessary.
 */
init_RAM_for_new_level:
       lda   #0xD0;
       tfr   a,dp;
       jsr   $clear_sound_chip;
       lda   #0xC8;
       tfr   a,dp;
       clr   0x9C;           /* Clear all 4 indirect jump counters */
       clr   0x9F;
       clr   0xA2;
       clr   0xA5;
       ldx   #0xC90B;        /* Clear C90B - CB71 */
PE7FA: clr   ,x+;
       cmpx  #0xCB71;
       bne   PE7FA;
       ldd   #0x0000;
       std   0xDE;
       std   0xE0;
       std   0xE2;
       std   0xE4;
       sta   0xE7;
       sta   0xBD;           /* Clear cmd ship disabled flag */
       sta   0xBE;           /* Clear 'no more ships' flag */
       sta   0xEA;           /* Clear active bullet counter */
       sta   0xEB;
       sta   0xEC;           /* Clear cmd ship exploding flag */
       sta   0xF8;           /* Clear destroyed cmd ship scale factor */
       ldb   #0x40;
       stb   0xF7;           /* Init cmd ship exploding loop counter */
       sta   0xED;           /* Clear # of dot mines */
       sta   0xC0;           /* Clear mine activated during reseeding flag */
       ldx   #0x0800;
       stx   0xF0;           /* Set end of game loop counter */
       lda   #0x07;
       sta   0xBF;           /* Init # of mines to be reseeded */
       ldx   #ind_init_screen_seeding;
       stx   0xA3;           /* Init indirect jump location for reseeding */
       ldd   #0x0000;
       std   0xC8;           /* Clear the command ship's */
       std   0xCA;           /* position indicators. */

clear_cmd_ship_xformation:
       ldd   #0x0000;
       sta   0xD4;           /* Clear rotation counter */
       std   0xCC;
       std   0xCE;
       sta   0xD5;           /* Clear cmd ships velocity */
       sta   0xD6;
       std   0xD0;
       std   0xD2;
       sta   0xD7;
       sta   0xD8;

/*
 * This block of code takes the vector list describing the
 * command ship, and applies a rotation transformation to
 * them.  The current rotation value is in C8D4, and the
 * transformed vector list is stored in the buffer
 * starting at CB89.
 */
rotate_cmd_ship:
       lda   0xD4;
       ldx   #command_ship;
       ldu   #0xCB89;
       jsr   $rotate_vector_list1;

       lda   #0x7F;
       ldb   0xD4;
       jsr   $calc_rise_run2;
       sty   $C907;
       stx   $C909;
       rts;


/*
 * This routine is called after the active player clears
 * a mine field level.  This routine will slowly bring the
 * command ship back to the center of the screen.  As this
 * is being done, a series of dots will be drawn to simulate
 * motion.
 */
bring_ship_to_center:
       pshs  x,y;
       pshs  dp;
       jsr   $dptoD0;
       jsr   $clear_sound_chip;
       puls  dp;
       lda   #0xA0;
       sta   0x8F;           /* Use C88F as a loop counter */

PE876: lda   0xC8;
       beq   PE884;          /* Modify the y coordinate for the */
       bmi   PE87F;          /* command ship, in an effort to */
       deca;                 /* force it back to 0. */
       bra   PE880;
PE87F: inca;
PE880: sta   0xC8;
       clr   0xC9;

PE884: lda   0xCA;           /* Modify the x coordinate for the */
       beq   PE892;          /* command ship, in an effort to */
       bmi   PE88D;          /* force it back to 0. */
       deca;
       bra   PE88E;
PE88D: inca;
PE88E: sta   0xCA;
       clr   0xCB;

PE892: lda   0xD4;           /* Modify the rotation value for the */
       beq   PE8A2;          /* command ship, in an effort to */
       cmpa  #0x1F;          /* force it back to 0. */
       bgt   PE89D;
       deca;
       bra   PE89E;
PE89D: inca;
PE89E: anda  #0x3F;
       sta   0xD4;

PE8A2: jsr   $PE2F2;         /* This loop, repeated 8 times (once */
       ldx   #0xCB81;        /* for each scale factor in the array) */
       ldb   #0x08;          /* increments each of the scale factors */
PE8AA: lda   ,x;             /* for the motion dots, by 3. */
       adda  #0x03;
       sta   ,x+;
       decb;
       bne   PE8AA;

       pshs  dp;
       jsr   $dptoD0;
       jsr   $display_both_scores;
       clrb;
       lda   #0x20; /* " " */
       jsr   $simulate_motion1;
       jsr   $modify_motion_scales;
       puls  dp;

       /* Repeat the above until the ship is centered. */
       lda   0xC8;
       lbne  PE876;
       lda   0xCA;
       lbne  PE876;
       lda   0xD4;
       lbne  PE876;
       dec   0x8F;
       lbne  PE876;
       jsr   $init_RAM_for_new_level;
       puls  x,y,pc;


/*
 * This routine initializes the two arrays
 * (CB71 and CB81) which contain the data
 * needed to produce the motion dots (the
 * dots displayed as the ship moves from
 * one level to the next).  The 8 entries
 * in CB71 are pointers to the 8 sets of
 * required dots.  The 8 entries in CB81
 * are the corresponding scale factors.
 */
init_motion_dots:
       ldx   #motion_dots;
       ldy   #0xCB71;
       ldu   #0xCB81;
       ldb   #0x08;
       lda   #0x16;
PE8F1: stx   ,y++;
       leax  8,x;
       sta   ,u+;
       adda  #0x0F;
       decb;
       bne   PE8F1;
       rts;


/*
 * modify_motion_scales() increments each of the 8 motion
 * scale factors, and then draws the new motion dots.
 * simulate_motion1() and simulate_motion2() both
 * draw the current motion dots.  The motion dots will
 * only be drawn if the scale factor is > the value specified
 * in the 'a' register, and if (scale - 'b') > 0.
 */
modify_motion_scales:
       pshs  a,b,dp,x;
       ldx   #0xCB81;
       lda   #0x08;
PE904: inc   ,x+;            /* Increment each of the scale factors */
       deca;
       bne   PE904;
       bra   simulate_motion2;

simulate_motion1:
       pshs  a,b,dp,x;
simulate_motion2:
       lda   #0xD0;
       tfr   a,dp;
       lda   #0x09;          /* Use 'a' as a loop counter */
       pshs  a;
PE915: dec   ,s;
       bne   PE920;
       jsr   $reset0ref;
       puls  a;
       puls  a,b,dp,x,pc;
PE920: jsr   $reset0ref;
       lda   #0x03;          /* Use C823 to hold # of dots */
       sta   $C823;          /* to be drawn (4).  */
       lda   ,s;
       deca;
       ldx   #0xCB81;
       ldb   a,x;
       andb  #0x7F;
       cmpb  1,s;            /* Make sure scale factor is */
       bls   PE915;          /* within the specified range */
       subb  2,s;
       ble   PE915;
       stb   0x04;           /* Set the hardware scale factor */

       ldx   #0xCB71;        /* Draw the dot list */
       asla;                 /* Convert loop cntr to a word offset */
       ldx   a,x;
       jsr   $intensity_to_7F;
       jsr   $dot_list;
       bra   PE915;


/*
 * This routine is responsible for drawing the hyperspace dot
 * during a hyperspace.  It draws the 8 sets of motion dots,
 * using a decreasing scale factor.  At entry, the 'b' register
 * contains the minimum scale factor to be used.
 */
draw_hyperspace_motion_dots:
       pshs  a,b,dp,x;
       lda   #0xD0;
       tfr   a,dp;
       lda   #0x09;          /* Push the loop cntr on the stack */
       pshs  a;
next_set_of_dots:
       dec   ,s;
       bne   draw_the_dots;
       jsr   $reset0ref;
       puls  a;
       puls  a,b,dp,x,pc;

draw_the_dots:
       jsr   $reset0ref;
       lda   #0x03;
       sta   $C823;          /* Use C823 to hold # of dots to draw */
       ldx   #0xC8C8;
       jsr   $move_pen7F_no_inc;
       ldb   ,s;
       aslb;
       aslb;
       addb  2,s;            /* Calculate the scale factor */
       ble   next_set_of_dots;
       andb  #0x7F;
       stb   0x04;           /* Set scale factor */
       ldx   #0xCB71;
       lda   ,s;             /* Draw the appropriate set of dots */
       deca;
       asla;
       ldx   a,x;
       jsr   $intensity_to_7F;
       jsr   $dot_list;
       bra   next_set_of_dots;


/*
 * Generate 2 random numbers (1 byte each), and return
 * them in a and b.  The range for the two numbers is:
 *
 *      0x80 <= first #  <= 0x7F     (a register)
 *      0xA0 <= second # <= 0x60     (b register)
 */
MS_get_2_random_nums:
       pshs  a,b;
       jsr   $get_random_a;
       sta   ,s;
PE991: jsr   $get_random_a;
       cmpa  #0x60;
       bgt   PE991;
       cmpa  #0xA0;
       blt   PE991;
       sta   1,s;
       puls  a,b;
       rts;


/*
 * This routine randomly activates a single mine.
 * At entry, the 'a' register must contain the
 * type of mine to be activated, while the 'b'
 * register must contain the generation number
 * for the mine (i.e. large, medium, or small).
 */
activate_a_mine:
       pshs  a,b,x,y,u;
       lda   0xED;           /* Check C8ED to see if there are any */
       lbeq  PEA3C;          /* dot mines; if not, then return. */
       dec   0xED;

       jsr   $get_random_a;  /* Generate a random index into the */
       anda  #0x1F;          /* mine array. */
PE9B0: sta   0x8B;
       cmpa  #0x1B;
       bls   PE9BA;
       suba  #0x04;
       bra   PE9B0;

PE9BA: ldb   #0x12;          /* Multiple offset by element size */
       mul;
       addd  #0xC933;
       tfr   d,u;
       lda   ,u;                  /* Check to see if this mine is already */
       anda  #0xC0;               /* being used.  If it is, then check */
       bne   init_a_visible_mine; /* the next mine in the structure; else */
       inc   0x8B;                /* use this mine.  */
       lda   0x8B;
       cmpa  #0x1B;
       ble   PE9BA;
       clr   0x8B;
       clra;
       bra   PE9BA;

init_a_visible_mine:
       lda   ,s;             /* Store the mine type */
       sta   1,u;
       ldx   #mine_values;
       asla;
       ldy   a,x;
       sty   0x89;           /* Store mine's value in C889 */
       ldb   #0x20;
       stb   ,u;
       ldx   #mine_velocity;
       lda   1,s;            /* Save mine's velocity */
       ldb   a,x;
       stb   0x8B;
       ldx   #final_mine_scale_factor;
       ldb   a,x;
       stb   0x10,u;         /* Save mine's max scale factor */
       sta   3,u;            /* Save mine's generation number */
       ldx   #mine_sizes;
       asla;
       ldy   a,x;
       sty   0x12,u;         /* Save mine's size */
       ldx   #extra_mine_value;
       ldy   a,x;
       sty   0x87;           /* Get any extra value for mine's size */
       cmpa  #0x06;
       bne   PEA13;
       inc   0xF4;           /* Flag that a sound should be made */
PEA13: lda   0x88;
       adda  0x8A;
       daa;
       sta   0x15,u;         /* Generate lo byte of score */
       lda   0x87;
       adca  0x89;
       daa;
       sta   0x14,u;        /* Generate hi byte of score */
       lda   0x8B;
       jsr   $MS_random_num_4_to_3C;
       jsr   $calc_rise_run1;
       sty   8,u;           /* Save the rise */
       stx   10,u;          /* Save the run */
       inc   0xEB;          /* Increment 'active mine' counter */
       lda   0xC0;
       beq   PEA3C;
       lda   #0xFF;
       sta   0x9C;
       lda   #0x03;
       sta   0xC1;
PEA3C: puls  a,b,x,y,u,pc;


/*
 * Generate a random number between 4 and 0x3C.  The
 * result is returned in the b register.
 */
MS_random_num_4_to_3C:
       pshs  a,b;
       jsr   $get_random_a;
       tfr   a,b;
       anda  #0x30; /* "0" */
       sta   1,s;
       andb  #0x0F;
       cmpb  #0x04;
       bhs   PEA51;
       addb  #0x04;
PEA51: cmpb  #0x0C;
       bls   PEA57;
       subb  #0x04;
PEA57: addb  1,s;
       stb   1,s;
       puls  a,b,pc;


/*
 * Force the scale factor to 0x7F, then
 * draw a dot at the position contained
 * in the y register.
 */
draw_dot7F_at_y:
       pshs  a,b;
       lda   #0x7F;
       sta   0x04;
       tfr   y,d;
       jsr   $dot;
       jsr   $reset0ref;
       puls  a,b,pc;


/*
 * Force the scale factor to 0x7F, then draw a
 * dot at the position pointed to by the y
 * register (y coord = (0,y), x coord = (2,y)).
 */
draw_dot7F_ptr_in_y:
       pshs  a,b;
       lda   #0x7F;
       sta   0x04;
       lda   ,y;
       ldb   2,y;
       jsr   $dot;
       jsr   $reset0ref;
       puls  a,b,pc;


/*
 * Move the pen to the position specified
 * in the y register, then draw the vector
 * list pointed to by the x register; the
 * scale factor is in the b register.
 */
move_y_draw_x:
       pshs  a,b,x;
       tfr   y,d;
       jsr   $move_pen7F_to_d;
       ldb   1,s;
       jsr   $drawl1b;
       puls  a,b,x,pc;


/*
 * Move the pen to the position specified in the y
 * register, and draw the list of vectors pointed to
 * by the x register; the scale factor to be used is
 * in the b register. (y coord = (0,y), x coord = (x,y))
 */
move_y_draw_x2:
       pshs  a,b,x;
       tfr   y,x;
       jsr   $move_pen7F_no_inc;
       ldb   1,s;
       ldx   2,s;
       jsr   $drawl1b;
       puls  a,b,x,pc;


/*
 * Force the scale factor to 0x7F, then print
 * a single string (upto a 0x80).  The pointer
 * to the string block is contained in the
 * u register.
 */
MS_print_1_string7F:
       pshs  a,b,x,u;
       lda   #0x7F;
       sta   0x04;
       jsr   $print_1_string;
       puls  a,b,x,u,pc;


/*
 * Move the pen to the position specified in the
 * y register, then print a string.  The pointer
 * to the string (not a string block) is in the
 * u register.
 */
move_y_print_string:
       pshs  a,b,x,u;
       tfr   y,d;
       jsr   $move_pen7F_to_d;
       jsr   $display_string;
       puls  a,b,x,y,pc;


/*
 * Use the value in C89B (the active player) to
 * determine which players score to display,
 * and then display the score string.
 */
display_active_players_score:
       jsr   $intensity_to_7F;
       ldd   #0xFC38;
       std   $C82A;          /* Specify height and width */
       lda   $C89B;
       ldy   #score_string_positions;
       ldy   a,y;            /* Load string position into y */
       ldu   #score_string_pointers;
       ldu   a,u;            /* Load score string into u */
       bsr   move_y_print_string;
       rts;


/*
 * Display the score for both players
 */
display_both_scores:
       jsr   $intensity_to_7F;
       ldd   #0xFC38;
       std   $C82A;          /* Specify height and width */
       ldy   #0x7FA0;        /* Load y with y&x positions */
       ldu   #0xC8A8;        /* Load u with player 1 score */
       bsr   move_y_print_string;
       lda   $C879;          /* See if we need to display player 2 score */
       beq   PEAEF;
       ldy   #0x7F10;        /* Load y with y&x positions */
       ldu   #0xC8AF;        /* Load u with player 2 score */
       bsr   move_y_print_string;
PEAEF: rts;


/*
 * This routine is responsible for reading the current
 * states of the joystick and buttons.  Next, it will
 * check each of the four indirect jump counters, and
 * if any of them equal 0 after being decremented, then
 * the appropriate indirect handling routine will be
 * called.  The four indirect counters, and their corresponding
 * handler routines are shown below:
 *
 *         counter          handler
 *         -------          -------
 *           C89C           C89D-C89E
 *           C89F           C8A0-C8A1
 *           C8A2           C8A3-C8A4
 *           C8A5           C8A6-C8A7
 *
 */
process_indirect_jumps:
       jsr   $waitrecal;
       pshs  dp;
       jsr   $PF2E6;
       jsr   $display_active_players_score;

       /* Set mask (in C880) and read the switches */
       lda   $C880;
       jsr   $read_switches;

       /* Set enable flags (in C881) and read joystick */
       ldd   $C881;
       std   $C81F;
       std   $C821;
       jsr   $read_jstick;

       lda   #0xC8;
       tfr   a,dp;
       lda   0x9C;
       beq   PEB1D;
       dec   0x9C;
       bne   PEB1D;
       jsr   [C89D];   /* (UNKNOWN JUMP) */
PEB1D: lda   0x9F;
       beq   PEB29;
       dec   0x9F;
       bne   PEB29;
       jsr   [C8A0];   /* (UNKNOWN JUMP) */
PEB29: lda   0xA2;
       beq   PEB35;
       dec   0xA2;
       bne   PEB35;
       jsr   [C8A3];   /* (UNKNOWN JUMP) */
PEB35: lda   0xA5;
       beq   PEB41;
       dec   0xA5;
       bne   PEB41;
       jsr   [C8A6];   /* (UNKNOWN JUMP) */
PEB41: puls  dp,pc;


/*
 * This routine check to see if any of the
 * bullets have hit a mine or a fireball or
 * the enemy ship.  If something is hit, then
 * the active player's score will be modified.
 */
check_bullets_for_hits:
       lda   0xEA;           /* Don't bother checking if there are */
       beq   PEB59;          /* no active bullets. (C8EA = 0) */
       ldy   #0xC90B;
       lda   #0x04;
       sta   0x8F;           /* Use C88F as a loop counter */
check_for_active_bullet:
       tst   ,y;             /* See if this bullet is active */
       bne   check_enemy_ship_4_hit;
inc_bullet_ptr2:
       leay  10,y;           /* Increment ptr to next bullet */
       dec   0x8F;
       bne   check_for_active_bullet;
PEB59: rts;

check_enemy_ship_4_hit:
       lda   0xE7;                 /* Only check for a hit on the enemy */
       beq   check_mines_for_hits; /* ship if it is showing (C8E7 > 0). */
       pshs  y;
       lda   5,y;
       ldb   7,y;
       tfr   d,x;                   /* bullets position */
       ldd   #0x0616;               /* height/2 and width/2 of enemy ship */
       ldy   0xDC;                  /* position of enemy ship */
       jsr   $check_bullet_for_hit; /* See if the enemy ship was hit */
       puls  y;
       bhs   check_mines_for_hits;
       clr   ,y;             /* HIT - flag that bullet is dead */
       clr   0xE7;           /* Flag that enemy ship no longer there */
       clr   0xA2;           /* Clear 1 indirect jump counter */
       ldx   #score_string_pointers;
       lda   0x9B;
       ldx   a,x;
       ldd   #0x1000;        /* Inc players score by 1000 */
       jsr   $add_d_to_x_in_bcd;
       lda   #0x30;
       ldb   #0x70;
       ldx   0xDC;
       jsr   $add_an_explosion;
       dec   0xEA;           /* Decrement the # of active bullets */
       bra   PEB59;

/*
 * This routine checks to see if a bullet hit
 * any of the active mines or fireballs.
 */
check_mines_for_hit:
       ldu   #0xC933;        /* Load 'u' with ptr to mine info */
       lda   #0x1C;
       sta   0x90;           /* Use C890 as a counter */
check_for_active_mine:
       lda   ,u;
       anda  #0x3F;          /* Make sure mine is active */
       bne   check_this_mine;
inc_mine_ptr2:
       leau  0x12,u;           /* Inc ptr into mine structure */
       dec   0x90;
       bne   check_for_active_mine;
       bra   inc_bullet_ptr2;

check_this_mine:
       pshs  y;
       lda   5,y;
       ldb   7,y;
       tfr   d,x;                   /* bullet coordinates */
       lda   4,u;
       ldb   6,u;                   /* mine coordinates */
       tfr   d,y;
       ldd   12,u;                  /* height & width of mine */
       jsr   $check_bullet_for_hit; /* returns: carry set = hit, else miss */
       puls  y;
       bhs   inc_mine_ptr2;
       lda   1,u;            /* Check if this is a fireball mine */
       anda  #0x02;
       beq   not_a_fireball_mine;
       ldx   #score_string_pointers;
       lda   0x9B;
       ldx   a,x;
       ldd   14,u;           /* Add mines value to players score */
       jsr   $add_d_to_x_in_bcd;
       inc   0xF5;
       lda   4,u;
       ldb   6,u;
       tfr   d,x;
       lda   2,u;
       ldb   #0x20;
       jsr   $add_an_explosion;
       ldd   #0x0110;        /* Init score for the fireball */
       std   14,u;
       lda   0xC8;
       suba  4,u;
       ldb   0xCA;
       subb  6,u;
       jsr   $PF593;
       suba  #0x10;
       tfr   a,b;
       pshs  y;
       lda   #0x3F;
       jsr   $calc_rise_run1;
       sty   8,u;            /* Calculate rise & run for fireball */
       stx   10,u;
       puls  y;
       clr   ,y;             /* Flag that the bullet is dead */
       ldd   #0x0404;
       std   12,u;           /* Set height/2 & width/2 for fireball */
       lda   1,u;
       ldb   3,u;            /* Decrement the generation for this mine */
       decb;                 /* and don't start any more if it = 0 */
       beq   start_a_fireball;
       jsr   $activate_a_mine;
       jsr   $activate_a_mine;
start_a_fireball:
       lda   #0x04;          /* Flag that this is a fireball */
       sta   1,u;
       dec   0xEA;           /* Decrement active bullet counter */
       jmp   $inc_bullet_ptr2;

/*
 * This processes a hit on a non-fireball type mine.
 */
not_a_fireball_mine:
       lda   #0x01;
       sta   ,u;
       clr   ,y;             /* Flag that the bullet is dead */
       ldx   #score_string_pointers;
       lda   0x9B;
       ldx   a,x;            /* Add mines value to players score */
       ldd   14,u;
       jsr   $add_d_to_x_in_bcd;
       lda   4,u;
       ldb   6,u;
       tfr   d,x;
       lda   2,u;
       ldb   #0x40;
       jsr   $add_an_explosion;
       dec   0xEB;           /* Decrement active mine counter */
       dec   0xEA;           /* Decrement the active bullet counter */
       jmp   $inc_bullet_ptr2;


/*
 * This routine check each active mine to see if it has
 * collided with the command ship.
 */
check_ship_4_mine_collision:
       lda   0xBD;
       bne   PEC63;          /* Do only if cmd ship not already dead */
       lda   0xEE;
       bne   PEC63;          /* Do only if hyperspace not active */
       ldy   #0xC933;
       lda   #0x1C;
       sta   0x8F;           /* Set up a loop counter */
PEC56: lda   ,y;
       anda  #0x3F;
       bne   check_this_active_mine;
inc_mine_ptr3:
       leay  0x12,y;
       dec   0x8F;
       bne   PEC56;
PEC63: rts;

check_this_active_mine:
       pshs  y;
       lda   0xC8;
       ldb   0xCA;
       tfr   d,x;            /* Load cmd ship's position */
       lda   4,y;
       ldb   6,y;
       ldy   12,y;           /* Load mine's position */
       exg   y,d;
       jsr   $check_bullet_for_hit;
       puls  y;
       bhs   inc_mine_ptr3;
       clr   ,y;             /* Flag that the mine is dead */
       clr   0xED;
       lda   0xC8;
       ldb   0xCA;
       tfr   d,x;
       lda   2,y;
       ora   #0x80;
       ldb   #0x30;
       jsr   $add_an_explosion;
       inc   0xF3;           /* Flag for an explosion sound */
       dec   0xEB;           /* Decrement active mine counter */
       bra   PEC63;


/*
 * This routine checks to see if the command ship has collided
 * with the enemy ship during reseeding.
 */
check_ship_4_enemy_collision:
       lda   0xBD;           /* Do only if cmd ship not disabled */
       bne   PECB2;
       lda   0xEE;           /* Don't do if hyperspace active */
       bne   PECB2;
       lda   0xE7;           /* Check only if enemy ship visible */
       beq   PECB2;
       lda   0xC8;
       ldb   0xCA;
       tfr   d,x;            /* Command ship location */
       ldd   #0x0616;        /* Size of enemy ship */
       ldy   0xDC;           /* Enemy ship's location */
       jsr   $check_bullet_for_hit;
       blo   cmd_and_enemy_ship_collision;
PECB2: rts;

cmd_and_enemy_ship_collision:
       clr   0xE7;           /* Flag that enemy ship no longer visible */
       clr   0xA2;
       lda   0xC8;
       ldb   0xCA;
       tfr   d,x;
       lda   #0x08;
       ora   #0x80;
       ldb   #0x30;
       jsr   $add_an_explosion;
       inc   0xF3;           /* Enable explosion sound */
       rts;

/*
 * This routine is responsible for making miscellaneous sound,
 * such as when an explosion occurs, or a bullet is fired.
 */
make_misc_sounds:
PECC9: lda   $C8F2;
       beq   PECD6;
       clr   $C8F2;
       ldu   #cmd_ship_movement_sound; /* Make cmd ship movement sound */
       bra   make_the_misc_sound;
PECD6: lda   $C8F3;
       beq   PECE3;
       clr   $C8F3;
       ldu   #explosion_sound; /* Make explosion sound */
       bra   make_the_misc_sound;
PECE3: lda   $C8B6;
       beq   PECF0;
       clr   $C8B6;
       ldu   #bullet_sound;  /* Make bullet firing sound */
       bra   make_the_misc_sound;
PECF0: lda   $C8F4;
       beq   PED00;
PECF5: clr   $C8F4;
       clr   $C8F6;
       ldu   #mine_pop_sound; /* Make sound of mine 'popping' up */
       bra   make_the_misc_sound;
PED00: lda   $C8F6;
       bne   PECF5;          /* Make hyperspace sound */
       bra   PED0A;

make_the_misc_sound:
       jsr   $copy_bytes_2_sound_chip;
PED0A: ldb   $C800;
       addb  #0x10;
       cmpb  #0xA0;
       bhs   PED1A;
       lda   #0x00;
       jsr   $byte_to_sound_chip;
       bra   PED20;
PED1A: ldd   #0x0800;
       jsr   $byte_to_sound_chip;
PED20: ldb   $C802;
       addb  #0x20;
       cmpb  #0xF0;
       bhs   PED30;
       lda   #0x02;
       jsr   $byte_to_sound_chip;
       bra   PED36;
PED30: ldd   #0x0900;
       jsr   $byte_to_sound_chip;
PED36: rts;


cmd_ship_movement_sound:
       .byte 0x00;
       .byte 0x10;
       .byte 0x01;
       .byte 0x00;
       .byte 0x06;
       .byte 0x1F;
       .byte 0x07;
       .byte 0x06;
       .byte 0x08;
       .byte 0x0F;
       .byte 0xFF;

bullet_sound:
       .byte 0x02;
       .byte 0x39; /* "9" */
       .byte 0x03;
       .byte 0x00;
       .byte 0x06;
       .byte 0x1F;
       .byte 0x07;
       .byte 0x05;
       .byte 0x09;
       .byte 0x0F;
       .byte 0xFF;

explosion_sound:
       .byte 0x06;
       .byte 0x1F;
       .byte 0x07;
       .byte 0x07;
       .byte 0x0A;
       .byte 0x10;
       .byte 0x0B;
       .byte 0x00;
       .byte 0x0C;
       .byte 0x38; /* "8" */
       .byte 0x0D;
       .byte 0x00;
       .byte 0xFF;

mine_pop_sound:
SED5A: .byte 0x00;
       .byte 0x00;
       .byte 0x01;
       .byte 0x00;
       .byte 0x02;
       .byte 0x30; /* "0" */
       .byte 0x03;
       .byte 0x00;
       .byte 0x04;
       .byte 0x00;
       .byte 0x05;
       .byte 0x00;
       .byte 0x06;
       .byte 0x1F;
       .byte 0x07;
       .byte 0x3D; /* "=" */
       .byte 0x08;
       .byte 0x00;
       .byte 0x09;
       .byte 0x0F;
       .byte 0x0A;
       .byte 0x00;
       .byte 0x0B;
       .byte 0x00;
       .byte 0x0C;
       .byte 0x00;
       .byte 0x0D;
       .byte 0x00;
       .byte 0xFF;

/* Start of Mine Storm music block */
MS_music:
       .word MS_music_header1;
       .word music_header2_a;
       .byte 0x00;
       .byte 0x19;
       .byte 0x01;
       .byte 0x19;
       .byte 0x00;
       .byte 0x19;
       .byte 0x01;
       .byte 0x32;
       .byte 0x00;
       .byte 0x19;
       .byte 0x01;
       .byte 0x19;
       .byte 0x00;
       .byte 0x19;
       .byte 0x06;
       .byte 0x19;
       .byte 0x05;
       .byte 0x19;
       .byte 0x00;
       .byte 0x80;

MS_music_header1:
       .byte 0xFF;
       .byte 0xEE;
       .byte 0xDD;
       .byte 0xCC;
       .byte 0xBB;
       .byte 0xAA;
       .byte 0x99;
       .byte 0x88;
       .byte 0x77;
       .byte 0x77;
       .byte 0x77;
       .byte 0x77;
       .byte 0x77;
       .byte 0x77;
       .byte 0x77;
       .byte 0x77;

score_string_pointers:
       .word 0xC8A8;         /* Pointer to player 1 score string */
       .word 0xC8AF;         /* Pointer to player 2 score string */

score_string_positions:
       .byte 0x7F;           /* Player 1 rel y score position */
       .byte 0xA0;           /* Player 1 rel x score position */
       .byte 0x7F;           /* Player 2 rel y score position */
       .byte 0x10;           /* Player 2 rel x score position */

mine_field_level_pointers:
       .word 0xC8F9;         /* Pointer to player 1 mine field # string */
       .word 0xC900;         /* Pointer to player 2 mine field # string */

/*
 * This contains the information describing which mines
 * are to appear at the first 13 mine field levels.  The
 * values map a follows:
 *
 *  0 = dumb mine
 *  1 = magnetic mine
 *  2 = fireball mine
 *  3 = magnetic fireball mine
 *
 */
mines_at_level_x:
       .byte 0x00;           /* level 1 */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x02;           /* level 2 */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x01;           /* level 3 */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x03;           /* level 4 */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x02;           /* level 5 */
       .byte 0x01;
       .byte 0x00;
       .byte 0x00;
       .byte 0x02;           /* level 6 */
       .byte 0x03;
       .byte 0x00;
       .byte 0x00;
       .byte 0x01;           /* level 7 */
       .byte 0x03;
       .byte 0x00;
       .byte 0x00;
       .byte 0x02;           /* level 8 */
       .byte 0x02;
       .byte 0x00;
       .byte 0x00;
       .byte 0x01;           /* level 9 */
       .byte 0x01;
       .byte 0x00;
       .byte 0x00;
       .byte 0x03;           /* level 10 */
       .byte 0x03;
       .byte 0x00;
       .byte 0x00;
       .byte 0x02;           /* level 11 */
       .byte 0x02;
       .byte 0x02;
       .byte 0x00;
       .byte 0x01;           /* level 12 */
       .byte 0x01;
       .byte 0x01;
       .byte 0x00;
       .byte 0x03;           /* level 13 */
       .byte 0x03;
       .byte 0x03;
       .byte 0x00;
       .byte 0x80;

motion_dots:
       .byte 0xC8;
       .byte 0x40;
       .byte 0x3F;
       .byte 0x00;
       .byte 0x20;
       .byte 0x80;
       .byte 0x10;
       .byte 0x1F;
       .byte 0x3F;
       .byte 0x3F;
       .byte 0x00;
       .byte 0xBF;
       .byte 0xBF;
       .byte 0xBF;
       .byte 0xC0;
       .byte 0x20;
       .byte 0x48;
       .byte 0x08;
       .byte 0xF8;
       .byte 0x30;
       .byte 0xA8;
       .byte 0x10;
       .byte 0xD0;
       .byte 0xA0;
       .byte 0xBF;
       .byte 0xBF;
       .byte 0x00;
       .byte 0x3F;
       .byte 0x3F;
       .byte 0x48;
       .byte 0x20;
       .byte 0x80;
       .byte 0x00;
       .byte 0xB0;
       .byte 0x48;
       .byte 0x38;
       .byte 0xFB;
       .byte 0x38;
       .byte 0x80;
       .byte 0x28;
       .byte 0x30;
       .byte 0x48;
       .byte 0x80;
       .byte 0x80;
       .byte 0x45;
       .byte 0xF0;
       .byte 0x28;
       .byte 0x7F;
       .byte 0x3F;
       .byte 0xBF;
       .byte 0xA5;
       .byte 0x00;
       .byte 0xD0;
       .byte 0x60;
       .byte 0x20;
       .byte 0x28;
       .byte 0xB8;
       .byte 0x40;
       .byte 0x15;
       .byte 0x80;
       .byte 0x40;
       .byte 0xF8;
       .byte 0x40;
       .byte 0x18;

mine_field:
       .byte 0xFA;    /* height = -6 */
       .byte 0x38;    /* width = 56 */
       .byte 0xE0;    /* rel y = -32 */
       .byte 0xC8;    /* rel x =     */
       .byte "MINE FIELD", 0x80;

game_over:
       .byte 0xFA;    /* height = -6 */
       .byte 0x38;    /* width = 56 */
       .byte 0xE0;    /* rel y = -32 */
       .byte 0xD8;    /* rel x =     */
       .byte "GAME OVER",0x80;

dumb_mine:
       .byte 0x00;
       .byte 0x10;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x20;
       .byte 0xA0;
       .byte 0xFF;
       .byte 0xC0;
       .byte 0x40;
       .byte 0xFF;
       .byte 0x90;
       .byte 0x20;
       .byte 0xFF;
       .byte 0x70;
       .byte 0x20;
       .byte 0xFF;
       .byte 0x50;
       .byte 0x50;
       .byte 0xFF;
       .byte 0xD0;
       .byte 0x90;
       .byte 0x01;

magnetic_mine:
       .byte 0x00;
       .byte 0x20;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x30;
       .byte 0xB0;
       .byte 0xFF;
       .byte 0xB0;
       .byte 0x30;
       .byte 0xFF;
       .byte 0xB0;
       .byte 0xD0;
       .byte 0xFF;
       .byte 0x30;
       .byte 0x50;
       .byte 0xFF;
       .byte 0xD0;
       .byte 0x50;
       .byte 0xFF;
       .byte 0x50;
       .byte 0xD0;
       .byte 0xFF;
       .byte 0x50;
       .byte 0x30;
       .byte 0xFF;
       .byte 0xD0;
       .byte 0xB0;
       .byte 0x01;

fireball_mine:
       .byte 0xFF;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x30;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x10;
       .byte 0xC0;
       .byte 0xFF;
       .byte 0xC0;
       .byte 0x10;
       .byte 0xFF;
       .byte 0xC0;
       .byte 0xF0;
       .byte 0xFF;
       .byte 0x10;
       .byte 0x40;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0x40;
       .byte 0xFF;
       .byte 0x40;
       .byte 0xF0;
       .byte 0xFF;
       .byte 0x40;
       .byte 0x10;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0xC0;
       .byte 0x01;

magnetic_fireball_mine:
       .byte 0xFF;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xF0;
       .byte 0xD0;
       .byte 0xFF;
       .byte 0xC0;
       .byte 0x40;
       .byte 0xFF;
       .byte 0x20;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x40;
       .byte 0x40;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xE0;
       .byte 0xFF;
       .byte 0x40;
       .byte 0xC0;
       .byte 0xFF;
       .byte 0xE0;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xC0;
       .byte 0xC0;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x20;
       .byte 0x01;

fireball:
       .byte 0x00;
       .byte 0x3F;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x80;
       .byte 0x00;
       .byte 0x00;
       .byte 0x3F;
       .byte 0x3F;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x80;
       .byte 0x01;

explosion:
       .byte 0xFF;
       .byte 0x7F;
       .byte 0x20;
       .byte 0x00;
       .byte 0xC0;
       .byte 0x10;
       .byte 0xFF;
       .byte 0xC0;
       .byte 0xD0;
       .byte 0xFF;
       .byte 0x20;
       .byte 0x7F;
       .byte 0x00;
       .byte 0xE0;
       .byte 0xC0;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xC0;
       .byte 0xFF;
       .byte 0xE0;
       .byte 0x30;
       .byte 0x00;
       .byte 0xC0;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x60;
       .byte 0xCD;
       .byte 0xFF;
       .byte 0xA0;
       .byte 0x00;
       .byte 0x00;
       .byte 0x20;
       .byte 0xD0;
       .byte 0xFF;
       .byte 0x3C;
       .byte 0x30;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x82;
       .byte 0x00;
       .byte 0x30;
       .byte 0x30;
       .byte 0xFF;
       .byte 0xD0;
       .byte 0x50;
       .byte 0xFF;
       .byte 0x20;
       .byte 0xF0;
       .byte 0x01;

command_ship:
       .byte 0x00;
       .byte 0x3F;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xC4;
       .byte 0x08;
       .byte 0xFF;
       .byte 0xD8;
       .byte 0xD8;
       .byte 0xFF;
       .byte 0x20;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x40;
       .byte 0xFF;
       .byte 0xE0;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x28;
       .byte 0xD8;
       .byte 0xFF;
       .byte 0x3C;
       .byte 0x08;
       .byte 0x01;

cmd_ship_pt1:
       .byte 0x00;
       .byte 0x3F;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xC4;
       .byte 0x08;
       .byte 0x01;

cmd_ship_pt2:
       .byte 0x00;
       .byte 0x04;
       .byte 0x08;
       .byte 0xFF;
       .byte 0xD8;
       .byte 0xD8;
       .byte 0xFF;
       .byte 0x20;
       .byte 0x00;
       .byte 0x01;

cmd_ship_pt3:
       .byte 0x00;
       .byte 0x3F;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xC4;
       .byte 0xF8;
       .byte 0x01;

cmd_ship_pt4:
       .byte 0x00;
       .byte 0x04;
       .byte 0xF8;
       .byte 0xFF;
       .byte 0xD8;
       .byte 0x28;
       .byte 0xFF;
       .byte 0x20;
       .byte 0x00;
       .byte 0x01;

enemy_ship_pt1:
       .byte 0x00;
       .byte 0x20;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xD8;
       .byte 0xFF;
       .byte 0xD0;
       .byte 0xA8;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0x40;
       .byte 0xFF;
       .byte 0x08;
       .byte 0x18;
       .byte 0xFF;
       .byte 0x18;
       .byte 0xF0;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0xB8;
       .byte 0x00;
       .byte 0x10;
       .byte 0x48;
       .byte 0xFF;
       .byte 0x08;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xE8;
       .byte 0x10;
       .byte 0xFF;
       .byte 0xF8;
       .byte 0x00;
       .byte 0x00;
       .byte 0x08;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x06;
       .byte 0x00;
       .byte 0x10;
       .byte 0xFA;
       .byte 0xFF;
       .byte 0x08;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xF0;
       .byte 0x00;
       .byte 0x10;
       .byte 0x18;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0x08;
       .byte 0x01;

enemy_ship_pt2:
       .byte 0x00;
       .byte 0x20;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x28;
       .byte 0xFF;
       .byte 0xD0;
       .byte 0x58;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0xC0;
       .byte 0xFF;
       .byte 0x08;
       .byte 0xE8;
       .byte 0xFF;
       .byte 0x18;
       .byte 0x10;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0x48;
       .byte 0x00;
       .byte 0x10;
       .byte 0xB8;
       .byte 0xFF;
       .byte 0x08;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xE8;
       .byte 0xF0;
       .byte 0xFF;
       .byte 0xF8;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x08;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xFA;
       .byte 0x00;
       .byte 0x10;
       .byte 0x06;
       .byte 0xFF;
       .byte 0x08;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x10;
       .byte 0x00;
       .byte 0x10;
       .byte 0xE8;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0xF8;
       .byte 0x01;

enemy_ship_pt3:
       .byte 0xFF;
       .byte 0x00;
       .byte 0xD8;
       .byte 0xFF;
       .byte 0xE8;
       .byte 0x08;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x40;
       .byte 0xFF;
       .byte 0x18;
       .byte 0x08;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xD8;
       .byte 0x00;
       .byte 0x08;
       .byte 0xE0;
       .byte 0xFF;
       .byte 0x10;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x40;
       .byte 0xFF;
       .byte 0xF0;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xC0;
       .byte 0x01;

simple_enemy_ship:
       .byte 0x00;
       .byte 0x18;
       .byte 0x00;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x20;
       .byte 0xFF;
       .byte 0xC8;
       .byte 0x70;
       .byte 0xFF;
       .byte 0x10;
       .byte 0xA0;
       .byte 0xFF;
       .byte 0x00;
       .byte 0xA0;
       .byte 0xFF;
       .byte 0xEC;
       .byte 0xA4;
       .byte 0xFF;
       .byte 0x39;
       .byte 0x6D;
       .byte 0xFF;
       .byte 0x00;
       .byte 0x20;
       .byte 0x01;

/* The following is spare space in the ROM */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;

/*
 * The executive starts executing here, each time the system is reset
 * or powered up.
 */
start: lds   #0xCBEA;         /* Set up the stack pointer */
       jsr   $reinit;
       ldd   #0x7321;         /* Cold start only if CBFE != 0x7321 */
       cmpd  $CBFE;
       beq   PF06C;
       std   $CBFE;           /* Start the cold start here */
       inc   $C83B;           /* Flag not to display score */
       ldx   #0xCBEB;
       jsr   $set_dft_score;  /* Initialize the score string */
powerup_loop:
       jsr   $dptoC8;
       ldd   0x25;            /* Signal that it is OK to start playing */
       cmpd  #0x0101;         /* the music (set C856), after waitrecal() */
       bne   PF029;           /* has been called 257 times.            */
       stb   0x56;
PF029: asrb;                  /* Determine which line pattern to use */
       andb  #0x03;           /* for drawing the boundary lines.     */

       /* Load the line drawing pattern */
       ldx   #line_patterns;
       ldb   b,x;
       stb   0x29;
       ldb   #0x02;
       stb   0x24;           /*Set intro box redraw count to 2 */

       /* Play the introductory song */
       ldu   #intro_music;
       jsr   $init_sound;
       jsr   $waitrecal;
       jsr   $do_sound;
       jsr   $intensity_to_7F;

       /* Display the power-up Vectrex message */
       lda   $C826;
       ldu   #vectrex_string; /* Determine if we should show the double  */
       bita  #0x20;           /* or single high VECTREX message.  Double */
       beq   PF052;           /* if bit 0x20 of waitrecal() counter is 0 */
       leau  12,u;
PF052: jsr   $printu;
       ldx   #intro_box;      /* Draw a 4 sided box */
PF058: jsr   $move_penFF;
       lda   #0x03;
       jsr   $dwp_with_count;
       dec   $C824;
       bne   PF058;          /* Keep drawing box, until C824 = 0 */
       lda   $C825;          /* Keep performing the above, as long as */
       cmpa  #0x01;          /* the lower byte of the waitrecal() counter */
       bls   powerup_loop;   /* is <= 0.                                  */
PF06C: jsr   $dptoC8;
       lda   #0xCC;
       sta   0x29;           /* Set line blanking pattern to 11001100 */
       ldd   #gce_string;
       std   0x39;           /* Save pointer to gce string in C839 */
       clr   0x25;
       clr   0x26;           /* Clear the waitrecal() counter. */

       /* See if a valid rom is installed */
       ldu   #0x0000;
       ldx   #gce_string;
       ldb   #0x0B;
PF084: lda   ,u+;
       cmpa  ,x+;
       beq   PF097;
       cmpb  #0x01;
       beq   PF092;
       cmpb  #0x05;
       bls   PF097;

        /* Boot with the MineStorm rom */
PF092: ldu   #MS_header;
       bra   PF09E;

PF097: decb;
       bne   PF084;
       stb   0x39;           /* Clear C839-C83A, if using a plug-in */
       stb   0x3A;

        /* Prepare to start a new sound (C856 = 1) */
        /* Load music block pointer for game into u register */
PF09E: inc   0x56;
       stu   0x37;
       ldu   ,u;
PF0A4: jsr   $dptoC8;
       ldd   #0xF848;
       std   0x2A;

       /* Produce the specified tune */
       jsr   $init_sound;
       jsr   $waitrecal;
       jsr   $do_sound;

       /* Print the 'gce' copyright message */
       jsr   $intensity_to_7F;
       ldd   #0xC0C0;
       ldu   $C839;
       jsr   $print_at_d;

       /* Display the current high score, if any */
       lda   $C83B;
       bne   PF0D2;
       deca;
       ldu   #0xCBEB;
       sta   6,u;
       ldd   #0x68D0;
       jsr   $print_at_d;

       /* Display the name of the game cartridge */
PF0D2: ldu   $C837;
       leau  2,u;
       jsr   $printu;

       /* Keep playing,until C856 is cleared */
       lda   $C856;
       bne   PF0A4;
       ldx   $C825;
       cmpx  #0x007D;
       bls   PF0A4;

       /* Jump to the start of the game */
       jmp   1,u;      /* (UNKNOWN JUMP) */


intro_box:
       .byte 0x40; /* "@" */
       .byte 0xD6;
       .byte 0x00;
       .byte 0x56; /* "V" */
       .byte 0x81;
       .byte 0x00;
       .byte 0x00;
       .byte 0xA9;
       .byte 0x7E; /* "~" */
       .byte 0x00;

box2:
       .byte 0x39; /* "9" */
       .byte 0xDC;
       .byte 0x8E;
       .byte 0x00;
       .byte 0x00;
       .byte 0x4A; /* "J" */
       .byte 0x72; /* "r" */
       .byte 0x00;
       .byte 0x00;
       .byte 0xB6;

        /* Line patterns */
line_patterns:
       .byte 0xE0;  /* Dashes = 11100000 */
       .byte 0x38;  /* Dashes = 00111000 */
       .byte 0x0E;  /* Dashes = 00001110 */
       .byte 0x03;  /* Dashes = 00000011 */

gce_string:
       .byte "g GCE 1982",0x80;

vectrex_string:
       .byte 0xF1;  /* height = -15 */
       .byte 0x60;  /* width = 96 */
       .byte 0x27;  /* rel y = 39 */
       .byte 0xCF;  /* rel x =    */
       .byte "VECTREX",0x80;
       .byte 0xF3;  /* height = -13 */
       .byte 0x60;  /* width = 96 */
       .byte 0x26;  /* rel y = 38 */
       .byte 0xCF;  /* rel x =    */
       .byte "VECTREX",0x80;
       .byte 0xFC;  /* height = -4 */
       .byte 0x60;  /* width = 96 */
       .byte 0xDF;  /* rel y =    */
       .byte 0xE9;  /* rel x =    */
       .byte "GCE",0x80;
       .byte 0xFC;  /* height = -4 */
       .byte 0x38;  /* width = 56 */
       .byte 0xCC;  /* rel y =    */
       .byte 0xD1;  /* rel x =    */
       .byte "ENTERTAINING",0x80;
       .byte 0xFC;  /* height = -4 */
       .byte 0x38;  /* width = 56 */
       .byte 0xBC;  /* rel y =    */
       .byte 0xDC;  /* rel x =    */
       .byte "NEW IDEAS",0x80,0x00;


init_PIA_chip:
       bsr   dptoD0;
       ldd   #0x9FFF;
       std   0x02;
       ldd   #0x0100;
       std   0x00;
       ldd   #0x987F;
       sta   0x0B;
       stb   0x04;
       jsr   $reset0ref;
       bra   set_refresh;


/* Clear RAM locations C800-C87A */
clear_C800_C87A:
       bsr   dptoC8;
       ldb   #0x7A; /* "z" */
       ldx   #0xC800;
       jsr   $clear_blockxb;
       ldd   #0xC87D;
       std   0x7B;

/*
 * Delay until contents of C87D = 0, then
 * Initialize dot dwell time, refresh timer & joystick enable flags
 */
init_flags1:
       inc   0x7D;         /* Delay */
       beq   PF173;
       lda   #0x05;
       sta   0x28;         /* Set dot dwell time to 5 */
       ldd   #0x3075;
       std   0x3D;         /* Set refresh time to 0x3075 */
       ldd   #0x0103;
       std   0x1F;         /* Set joystick enable flags */
       ldd   #0x0507;
       std   0x21;         /* Set joystick enable flags */
       rts;


reinit:
       bsr   clear_C800_C87A;
       bsr   init_PIA_chip;
       jmp   $clear_sound_chip;

/*
 * Wait for t2 (the refresh timer) to timeout, then restart
 * it using the value in C83D.  Then, recalibrate the vector
 * generators to the origin (0,0).  This routine MUST be called
 * once every refresh cycle, or your vectors will get out of
 * whack.  This routine calls reset0ref, so the integrators
 * are left in zero mode.  Dp will be set to D0.
 */
waitrecal:
       ldx   $C825;
       leax  1,x;
       stx   $C825;          /* Increment the waitrecal() call counter */
       bsr   dptoD0;
       lda   #0x20;
PF19E: bita  0x0D;           /* Wait for the refresh timer to expire */
       beq   PF19E;

/*
 * This routine loads the refresh timer (t2), with the value in
 * C83D-C83E, and recalibrates the vector generators, thus
 * causing the pen to be left at the origin (0,0). The high
 * order byte for the timer is loaded from C83E, and the low
 * order byte is loaded from C83D.  The refresh rate is calculated
 * as follows:   rate = 1.5 mhz * (C83E)(C83D).
 * Dp must be D0.
 */
set_refresh:
       ldd   $C83D;
       std   0x08;
       jmp   $PF2E6;

/*
 * Sets the dp register to D0, so that all direct addresses
 * will start at D000 (the hardware I/O area).  The a
 * register is trashed.
 */
dptoD0:
       lda   #0xD0;
       tfr   a,dp;
       rts;

/*
 * Sets the Dp register to C8, so that all direct addresses
 * start at C800.  The a register is trashed.
 */
dptoC8:
       lda   #0xC8;
       tfr   a,dp;
       rts;

/*
 * Read the switch values for the two consoles.  The switch values
 * are returned in the following locations:
 *
 *      console 1, switch 1:    C812
 *                 switch 2:    C813
 *                 switch 3:    C814
 *                 switch 4:    C815
 *      console 2, switch 1:    C816
 *                 switch 2:    C817
 *                 switch 3:    C818
 *                 switch 4:    C819
 *
 * Before this routine is called, the a register must be set to
 * contain a mask, having the following format:
 *
 *      bit 0 = console 1, switch1;  etc.
 *
 * If a bit is 0, then the current state of the switch is to be
 * returned in the appropriate ram location (0 = up, 1 = down).
 *
 * If a bit is 1, then the appropriate ram location is set to 1
 * only on the depression transition of the button; additional
 * calls will return 0, until the switch is release and then
 * depressed again.
 *
 * Dp must be set to D0.
 */
read_switches:
       anda  $C80F;
       sta   $C80F;
       ldx   #0xC812;
       lda   -3,x;
       sta   -2,x;
       lda   #0x0E;
       sta   0x01;
       ldd   #0x1901;
       sta   0x00;
       nop;
       stb   0x00;
       clr   0x03;
       ldd   #0x0901;
       sta   0x00;
       nop;
       lda   0x01;
       coma;
       sta   -3,x;
       stb   0x00;
       ldb   #0xFF;
       stb   0x03;
       coma;
       ora   -2,x;
       coma;
       sta   -1,x;
       pshs  a;
       ldb   #0x01;
PF1EA: tfr   b,a;
       anda  ,s;
       sta   ,x+;
       aslb;
       bne   PF1EA;
       puls  a,pc;


PF1F5: dec $C823;

/*
 * Read the joystick positions of the two consoles.  This routine
 * requires some setup before it should be called.  First, C81F-C822
 * are enable flags, and all must be set to one of the following:
 *
 *      0  ignore.
 *      1  pot 0 (console 1 left/right)
 *      3  pot 1 (console 1 up/down)
 *      5  pot 2 (console 2 left/right)
 *      7  pot 3 (console 2 up/down)
 *
 * Locations C81B-C81E will be set with the pot values corresponding
 * to the enable flags.
 *
 * Location C823 is used to determine what kind of input conversion
 * should be performed.  The valid choices are:
 *
 *      >= 0    The return value will be:
 *                      < 0 if joystick is left or down of center.
 *                      = 0 if joystick is centered.
 *                      > 0 if joystick is right or up of center.
 *
 *      < 0     A successive approximation algorithm is used to
 *              read the actual value of the joystick pot, a
 *              signed value.  In this case, C81A must be set to
 *              power of 2, to control conversion resolution;
 *              0x80 i sleast accurate, and 0x00 is most accurate.
 *
 * Dp must be set to D0.
 * C823 is cleared before this routine returns.
 *
 */
read_jstick:
       ldx   #0xC81F;
next_pot:
       lda   ,x+;
       bne   process_a_pot;
check_4_done:
       cmpx  #0xC823;
       bne   next_pot;
       clr   ,x;
       lda   #0x01;
       sta   0x00;
       rts;
process_a_pot:
       sta   0x00;
       clr   0x01;
       dec   0x00;
       ldb   #0x60;
PF213: incb;
       bpl   PF213;          /* Delay */
       lda   $C823;          /* Get the joystick mode */
       bmi   use_approx;     /* Use successive approximation */
       lda   #0x20;
       inc   0x00;
       bita  0x00;
       beq   l_or_d;
       ldb   #0x40;
       stb   0x01;
       bita  0x00;
       bne   save_jstick_state;  /* joystick is right or up */
       bra   centered;           /* joystick is centered */
l_or_d:
       ldb   #0xC0;
       stb   0x01;
       bita  0x00;
       beq   save_jstick_state;  /* joystick is left or down */
centered:
       clrb;
save_jstick_state:
       stb   -5,x;
       bra   check_4_done;


try_again:
       tfr   b,a;
       ora   0x01;
       sta   0x01;
use_approx:
       lda   #0x20;
       bita  0x00;
       bne   check_resolution;
       tfr   b,a;
       eora  0x01;
       sta   0x01;
check_resolution:
       lsrb;
       cmpb  $C81A;          /* Get the approximation resolution */
       bne   try_again;
       ldb   0x01;
       bra   save_jstick_state;


/*
 * These routines cause a byte to be added to a sound
 * buffer.  At entry, 'x' = base address of RAM area of where to
 * store the sound byte.  'a' = offset into the 'x' register as
 * to where to store the byte.  'b' = byte to be processed.
 */
byte_2_sound_chip:
       ldx   #0xC800;
byte_2_sound_chip2:
       stb   a,x;
       sta   0x01;
       lda   #0x19;
       sta   0x00;
       lda   #0x01;
       sta   0x00;
       lda   0x01;
       stb   0x01;
       ldb   #0x11;
       stb   0x00;
       ldb   #0x01;
       stb   0x00;
       rts;


/*
 * This routine clear out the 15 byte sound buffer.
 */
clear_sound_chip:
       ldd   #0x0E00;
PF275: bsr   byte_to_sound_chip;
       deca;
       bpl   PF275;
       jmp   $init_music_buf;


/*
 * This routine copies a group of sound information into the
 * sound chip buffer, at C800.  At entry, 'u' = a pointer to
 * a list of sound pairs.  If the first byte >= 0, then it is
 * used as an index into the sound chip buffer as to where to
 * save the 2nd byte (the sound data).  If the 1st byte is < 0,
 * then the copy stops; dp must by D0.
 */
copy_bytes_2_sound_chip:
       ldx   #0xC800;
       bra   PF284;
PF282: bsr   byte_2_sound_chip2;
PF284: ldd   ,u++;
       bpl   PF282;
       rts;

/*
 * This will start making the sound which was set up by your
 * call to init_sound().  This should be called right after
 * your call to waitrecal().
 */
do_sound:
       ldx   #0xC800;
       ldu   #0xC83F;
       lda   #0x0D;
PF291: ldb   ,u+;
       cmpb  a,x;
       beq   PF299;
       bsr   byte_2_sound_chip2;
PF299: deca;
       bpl   PF291;
       rts;

/*
 * Sets the intensity (the z axis) to 1F, 3F, 5F or 7F, depending
 * upon which entry point is called.  The intensity must be
 * reloaded at least every refresh cycle.  However, it may be
 * changed on the fly, if desired.  The current intensity value
 * is saved in C827.  Dp must be D0.
 */
intensity_to_1F:
       lda   #0x1F;
       bra   intensity_to_a;

intensity_to_3F:
       lda   #0x3F; /* "?" */
       bra   intensity_to_a;

intensity_to_5F:
       lda   #0x5F; /* "_" */
       bra   intensity_to_a;

intensity_to_7F:
       lda   #0x7F;

intensity_to_a:
       sta   0x01;
       sta   $C827;
       ldd   #0x0504;
       sta   0x00;
       stb   0x00;
       stb   0x00;
       ldb   #0x01;
       stb   0x00;
       rts;

/*
 * Draw a dot at the relative y and relative x coordinates pointed
 * to by the x register, with an intensity proportional to the
 * value in the b register.  The x register is incremented by 2
 * afterwards.  The Dp must be D0.
 */
dotixb:
       stb   $C828;
dotix: ldd   ,x++;           /* Use current intensity value */
dot:   bsr   move_pen_d;     /* Use x&y already in d reg */
       lda   #0xFF;
       sta   0x0A;
       ldb   $C828;
PF2CC: decb;                 /* Use b (intensity) as loop counter */
       bne   PF2CC;
       clr   0x0A;
       rts;


/*
 * Draw a series of dots.  The x register points to a list of
 * relative y and relative x location pairs.  The number of
 * dots to be drawn is specified in RAM location C823.
 */
next_dot:
       dec   $C823;
dot_list:
       bsr   dotix;
       lda   $C823;
       bne   next_dot;
       bra   reset0ref;


/* Draw a series of dots.  The x register points to the array
 * of points.  The array has the following format:
 *
 *      mode, relative y position, relative x position
 *
 * If mode > 0, then the drawing ceases, and the integrators are reset.
 */
dotix_then_reset:
       lda   ,x+;
       bgt   reset0ref;
       bsr   dotix;
       bra   dotix_then_reset;


PF2E6: ldx   #0xF9F0;
       bsr   move_penFF;
       jsr   $PF36B;
       bsr   move_pen;
       bra   reset0ref;


/*
 * Set the scale factor to 0x7F, then move the pen to the location
 * pointed to by the x register (y coord = (0,x) x coord = (2,x)).
 * The x register is not incremented afterwards.
 */
move_pen7F_no_inc:
       ldb   #0x7F;
       stb   0x04;
       lda   ,x;
       ldb   2,x;
       bra   move_pen_d;


/*
 * Force the scale factor to 0x7F, then move the pen to the
 * position specified in the d register.
 */
move_pen7F_to_d:
       sta   0x01;           /* Set height for string */
       pshs  a,b;
       lda   #0x7F;
       sta   0x04;           /* Set scale factor to 0x7F */
       clr   0x00;
       bra   PF318;

/*
 * Move the pen to the relative y and relative x positions
 * pointed to by the x register.  The scale factor is set to
 * 0xFF (170 usec), and then left at this value at exit time.
 * Dp must be D0.  The x register is incremented by 2 before
 * exiting.
 */
move_penFF:
       ldb   #0xFF;
       bra   set_scale_factor;

/* Same as above, except scale factor is set to 0x7F (85 usec). */
move_pen7F:
       ldb   #0x7F;
set_scale_factor:
       stb   0x04;

/* Same as above, except the scale factor is not changed */
move_pen:
       ldd   ,x++;

/* Move pen to relative y (in a) and relative x (in b) */
move_pen_d:
       sta   0x01;
       clr   0x00;
       pshs  a,b;
PF318: lda   #0xCE;
       sta   0x0C;
       clr   0x0A;
       inc   0x00;
       stb   0x01;
       clr   0x05;
       puls  a,b;
       jsr   $check_ab_for_overflow;
       stb   -1,s;
       ora   -1,s;
       ldb   #0x40; /* "@" */
       cmpa  #0x40; /* "@" */
       bls   PF345;
       cmpa  #0x64; /* "d" */
       bls   PF33B;
       lda   #0x08;
       bra   PF33D;
PF33B: lda   #0x04;
PF33D: bitb  0x0D;
       beq   PF33D;
PF341: deca;
       bne   PF341;
       rts;
PF345: bitb  0x0D;
       beq   PF345;
       rts;


/* Set the dp to D0, then reset the integrators */
set_dp_and_reset0ref:
       jsr   $dptoD0;
       bra   reset0ref;

/*
 * If 0xC824 is non-zero, call reset0ref, else return.
 * Dp must be D0.
 */
check0ref:
       lda   $C824;
       beq   rtn1;

/*
 * This routine zeros the integrators. It resets the origin to
 * (0,0).  This routine leaves the integrators in zero mode, so
 * nothing can be drawn until a move is done, or 0xD00C is set
 * to 0xCE.  Dp must be D0.  This routine should be called
 * every once in awhile, to make sure your vectors don't get off.
 */
reset0ref:
       ldd   #0x00CC;
       stb   0x0C;
       sta   0x0A;
       ldd   #0x0302;
       clr   0x01;
       sta   0x00;
       stb   0x00;
       stb   0x00;
       ldb   #0x01;
       stb   0x00;
rtn1:  rts;


PF36B: ldd   #0x00CC;
       stb   0x0C;
       sta   0x0A;
       rts;


/*
 * The following are a series of subroutines which may be used to
 * accomplish several different methods of printing a string.
 * Each one expects the string (and parameter block) to be pointed
 * to by the u register.
 *
 *   print_1_string() - Prints a string (upto a 0x80).  The
 *                      header for the string must include the
 *                      height and width for the string, and
 *                      also the relative y & x positions.
 *
 *   print_with_dft_hw()- Prints a string (upto a 0x80).  The
 *                      header for the string must include
 *                      only the relative y & x positions.  The
 *                      current height & width is used.
 *
 *   print_at_d()      -Prints a string (upto a 0x80).  The
 *                      string contains no header.  The current
 *                      height & width are used. The rely & rel x
 *                      are specified in the d register.
 */
print_1_string:
       ldd   ,u++;           /* Save height and width */
       std   $C82A;
print_with_dft_hw:
       ldd   ,u++;           /* Get the rel y & rel x positions */
print_at_d:
       jsr   $move_pen7F_to_d; /* Move pen to starting positions */
       jsr   $delay_b_1;
       jmp   $display_string;/* Print string, until 0x80 encountered */
initiate_printing:
       bsr   print_1_string;

/*
 * Display the string whose block is pointed to by the u register.
 * Dp must be D0.  The block for the string must have the following
 * format:
 *
 *  string height, string width,
 *  rel y, rel x, STRING, 0x80,
 *  rel y, rel x, STRING, 0x80,
 *  0x00
 */
printu:
       lda   ,u;
       bne   initiate_printing;    /* Keep printing till 0x00 found */
       rts;


/*
 * Display  the string whose block is pointed to by the u register.
 * Dp must be D0.  The current height and width values for which
 * the hardware is set are used.  The block for the string must
 * have the following format:
 *
 *  rel y, rel x, STRING, 0x80,
 *  rel y, rel x, STRING, 0x80,
 *  0x00
 */
printu2:
       bsr   print_with_dft_hw:
       lda   ,u;             /* Stop when 0x00 encountered */
       bne   printu2;
       rts;


PF391: ldx   ,x;
       pshs  b;
       ldb   #0x80;
       leau  -8,s;
       pshu  a,b;
       puls  a;
       cmpa  #0x09;
       bls   PF3A3;
       lda   #0x3C; /* "<" */
PF3A3: adda  #0x30; /* "0" */
       ldb   #0x2D; /* "-" */
       pshu  a,b;
       pshu  x;
       bra   print_with_dft_hw:


PF3AD: lda   ,x+;
       bra   PF3B9;


PF3B1: stb   0x04;
       bra   move_to_pt;


PF3B5: ldd   ,x++;
       stb   0x04;
PF3B9: sta   $C823;

move_to_pt:
       ldd   ,x;
       sta   0x01;
       clr   0x00;
       leax  2,x;
       nop;
       inc   0x00;
       stb   0x01;
       ldd   #0x0000;    /* Set line pattern to invisible */
       bra   PF3ED;


PF3CE: lda   ,x+;
       bra   PF3DA;


PF3D2: stb   0x04;
       bra   draw_to_pt;


PF3D6: ldd   ,x++;
       stb   0x04;
PF3DA: sta   $C823;

draw_to_pt:
       ldd   ,x;
       sta   0x01;
       clr   0x00;
       leax  2,x;
       nop;
       inc   0x00;
       stb   0x01;
       ldd   #0xFF00;    /* Set line pattern to solid line */
PF3ED: sta   0x0A;
       stb   0x05;
       ldd   #0x0040;
PF3F4: bitb  0x0D;
       beq   PF3F4;
       nop;
       sta   0x0A;
       lda   $C823;
       deca;
       bpl   PF3DA;
       jmp   $check0ref;


PF404: ldb   #0xFF;
       bra   drawl1b;
PF408: ldb   #0x7F;
       bra   drawl1b;

/*
 * Draw a list of vectors.  The x register contains the pointer
 * to the vector list.  The form for the vector list is a follows:
 *
 *      .byte   scale factor
 *      .byte   mode, relative y, relative x
 *        .
 *        .
 *      .byte   mode, relative y, relative x
 *
 * where mode means the following:
 *
 *      < 0  visible vector.
 *      = 0  invissible vector.
 *      > 0  end of list.
 *
 */
drawl1:
       ldb   ,x+;

/* Same as drawl1, except scale factor is in b register */
drawl1b:
       stb   0x04;
next_pt:
       ldd   1,x;            /* Load d register with endpoints */
       sta   0x01;
       clr   0x00;
       lda   ,x;             /* Get the mode for this vector */
       leax  3,x;            /* Increment pointer to next pair */
       inc   0x00;
       stb   0x01;
       sta   0x0A;
       clr   0x05;
       ldd   #0x0040;
PF425: bitb  0x0D;
       beq   PF425;
       nop;
       sta   0x0A;
       lda   ,x;
       ble   next_pt;
       jmp   $check0ref;


/*
 * Draw a series of patterned vectors.  The x register points to
 * the list of endpoints, and the list has the following format:
 *
 *      relative y, relative x
 *
 * dwp_with_count() uses the value in the a register to determine
 * how many vectors to draw (number = a + 1), while draw_with_pattern()
 * uses the value in RAM location C823 to determine this.
 */
dwp_loop:
       deca;
dwp_with_count:
       sta   $C823;
draw_with_pattern:
       ldd   ,x;
       sta   0x01;
       clr   0x00;
       leax  2,x;
       inc   0x00;
       stb   0x01;
       lda   $C829;  /* Retrieve the line pattern */
       ldb   #0x40;
       sta   0x0A;
       clr   0x05;
       bitb  $D00D;
       beq   PF45C;
       clr   0x0A;
       lda   $C823;
       bne   dwp_loop;
       rts;
PF459: lda   $C829;
PF45C: sta   0x0A;
       nop;
       bitb  0x0D;
       beq   PF459;
       lda   $C823;
       clr   0x0A;
       tsta;
       bne   dwp_loop;
       jmp   $check0ref;

/*
 * Draw a list of vectors, pointed to by the x register.
 * The scale factor is not changed, and whatever the current
 * value is is used.  The list is organized as follows:
 *
 *      .byte   mode, relative y, relative x;
 *
 * where mode has the following meaning:
 *
 *      < 0  use mode value in 0xC829 ( 0 = invis; 0xFF is visible).
 *      = 0  invisible vector.
 *      = 1  end of list, so return.
 *      > 1  visible vector.
 *
 */
drawl2:
       lda   $C824;
       pshs  a;
       clr   $C824;    /* Temporarily clear check0ref() enable flag */
PF476: lda   ,x+;      /* Grab the drawing mode desired */
       bpl   move_or_draw;
       bsr   draw_with_pattern;
       bra   PF476;
move_or_draw:
       bne   draw_or_end;
       jsr   $move_to_pt;
       bra   PF476;
draw_or_end:
       deca;
       beq   end_drawl2;
       jsr   $draw_to_pt;
       bra   PF476;
end_drawl2:
       puls  a;
       sta   $C824;   /* Restore the check0ref() enable flag */
       jmp   $check0ref;


/*
 * This is the routine which does the actual printing of a string
 * onto the display.  The u register points to the start of the
 * string.  The end of the string is designated by the 0x80 byte.
 * The string is displayed by drawing 6 horizontal rows of dots.
 * The first row is drawn for each character, then the second, etc.
 * The character generation table is located at 0xF9D4 + 0x20.
 * NOTE: only characters 0x20 - 0x6F are defined, and lower case
 *       characters a-o produce special icons.
 */
display_string:
       stu   $C82C;          /* Save pointer to start of string */
       ldx   #0xF9D4;        /* Actual character table is at F9F4 */
       ldd   #0x1883;
       clr   0x01;
       sta   0x0B;
       ldx   #0xF9D4;
PF4A5: stb   0x00;
       dec   0x00;
       ldd   #0x8081;
       nop;
       inc   0x00;
       stb   0x00;
       sta   0x00;
       tst   $C800;
       inc   0x00;
       lda   $C82B;          /* Set the width */
       sta   0x01;
       ldd   #0x0100;
       ldu   $C82C;          /* Set u to point to 1st char */
       sta   0x00;
       bra   PF4CB;


PF4C7: lda   a,x;
       sta   0x0A;
PF4CB: lda   ,u+;
       bpl   PF4C7;          /* Display next row of pixels */
       lda   #0x81;
       sta   0x00;
       neg   0x01;
       lda   #0x01;
       sta   0x00;
       cmpx  #0xFBB4;        /* If we have not reached the end of the char */
       beq   PF50A;          /* table, then proceed to next row of pixels. */
       leax  0x50,x;
       tfr   u,d;
       subd  $C82C;          /* Point u back to the 1st character */
       subb  #0x02;
       aslb;
       brn   PF4EB;
PF4EB: lda   #0x81;          /* Timing loop */
       nop;
       decb;
       bne   PF4EB;
       sta   0x00;
       ldb   $C82A;          /* Grab the height */
       stb   0x01;
       dec   0x00;
       ldd   #0x8101;
       nop;
       sta   0x00;
       clr   0x01;
       stb   0x00;
       sta   0x00;
       ldb   #0x03;
       bra   PF4A5;          /* Repeat, using next row pixel patterns */
PF50A: lda   #0x98;
       sta   0x0B;           /* Done with this string */
       jmp   $reset0ref;


/*
 * Generate a random number, and place it into the a register.
 * This uses a different seed (contained in register b) than
 * get_random_a().
 */
get_random_a2:
       pshs  b,x;
       ldb   #0x02;
       bra   ran_start;

/*
 * Generate a random number, and place it into the a register.
 */
get_random_a:
       pshs  b,x;
       clrb;
ran_start:
       ldx   $C87B;
ran_loop:
       lda   1,x;
       rola;
       rola;
       rola;
       rola;
       eora  2,x;
       rora;
       rol   ,x;
       rol   1,x;
       rol   2,x;
       decb;
       bpl   ran_loop;
       lda   ,x;
       puls  b,x,pc;

/* Clear the block of memory C83F - C84C, then set C845 = 0x3F */
init_music_buf:
       ldb   #0x0D;
       ldx   #0xC83F;
       bsr   clear_blockxb;
       lda   #0x3F;
       sta   6,x;
       rts;

/*
 * Clear a block of memory.  The x register points to the
 * start of the memory block to be cleared, while the b
 * register specifies the number of bytes to be cleared.
 * The a register is altered.
 */
clear_blockxb:
       clra;
       bra   clear_block;

clear_C8_ram:
       ldx   #0xC800;
       ldd   #0x00FF;

clear_block:
       clr   d,x;
       subd  #0x0001;
       bpl   PF548;
       rts;

/*
 * Set the block of memory pointed to by the x register to 0x80.
 * The number of memory locations to be set is specified by the
 * b register + 1.
 */
clear_block_to_0x80:
       lda   #0x80;
PF552: sta   b,x;
       decb;
       bne   PF552;
       sta   ,x;
       rts;


/*
 * Decrement the specified counters
 */
decrement_counters_C82E_C830:
       ldb   #0x02;
       bra   PF560;
decrement_counters_C82E_C833:
       ldb   #0x05;
PF560: ldx   #0xC82E;
PF563: tst   b,x;
       beq   PF569;
       dec   b,x;
PF569: decb;
       bpl   PF563;
       rts;


/* Delay until the b register < 0 */
delay_b_3:
       ldb   #0x03;
       bra   start_b_delay;
delay_b_2:
       ldb   #0x02;
       bra   start_b_delay;
delay_b_1:
       ldb   #0x01;
       bra   start_b_delay;
delay_b_0:
       clrb;
start_b_delay:
       decb;
       bpl   start_b_delay;
       rts;


/*
 * On entry, the a register equals the bits number for which
 * a mask is desired.  On exit, the a register equals the
 * requested bit mask. For example:
 *
 *      Entry           Exit
 *      -----           ----
 *        0             0x01
 *        1             0x02
 *       etc            etc
 */
get_bit_mask:
       ldx   #bit_masks;
       lda   a,x;
       rts;


/*
 * If a is negative, then negate it and check to see if the
 * overflow bit is set; if it is, then decrement a.  Repeat for
 * the b register.  ( Overflow is set only if the # = 0x80).
 */
check_ab_for_overflow:
       tsta;
       bpl   PF58B;
       nega;
       bvc   PF58B;
       deca;
PF58B: tstb;
       bpl   PF592;
       negb;
       bvc   PF592;
       decb;
PF592: rts;


PF593: pshs  x;
       std   0x34;
       rolb;
       ldb   #0x00;
       rolb;
       rola;
       rolb;
       aslb;
       stb   0x36;
       ldd   0x34;
       bsr   check_ab_for_overflow;
       sta   0x34;
       cmpb  0x34;
       bls   PF5B2;
       inc   0x36;
       exg   a,b;
       bra   PF5B2;
PF5B0: lsra;
       lsrb;
PF5B2: cmpa  #0x09;
       bhi   PF5B0;
       std   0x34;
       ldb   0x36;
       ldx   #0xFC24;
       ldb   b,x;
       ldx   #0xFC2C;
       lda   a,x;
       adda  0x35;
       adda  #0x0A;
       bitb  #0x01;
       bne   PF5D0;
       addb  a,x;
       bra   PF5D3;
PF5D0: decb;
       subb  a,x;
PF5D3: stb   0x36;
       lda   0x36;
       puls  x,pc;


/*
 * get_2nd_index_pair() and get_1st_index_pair() are used
 * by the rotation algorithm.  They expect the rotation
 * value to be specified in the 'a' register.  Upon exit,
 * the rotation index pair is returned in the 'd' register.
 */
get_2nd_index_pair:
       adda  #0x10;
get_1st_index_pair:
       ldx   #0xFC6D;
       clrb;
       bita  #0x20;
       beq   PF5E5;
       ldb   #0x80;
PF5E5: anda  #0x1F;
       cmpa  #0x10;
       bne   PF5EC;
       incb;
PF5EC: lda   a,x;
       rts;


/*
 * This routine is called at at the beginning of the
 * rotation transformation process.  It is responsible
 * for generating the 2 rotation index pairs.  The
 * first rotation pair is saved in C837-C838, and the
 * second pair is aved in C839-C83A.  This routine
 * expects the rotation value to be stored in C836.
 */
get_rotation_index_pairs:
       pshs  x;
       lda   0x36;           /* get rotation value */
       bsr   get_1st_index_pair;
       std   0x37;           /* Save first rotation index pair */
       lda   0x36;           /* get rotation value */
       bsr   get_2nd_index_pair;
       std   0x39;           /* Save second rotation index pair */
       puls  x,pc;



/*
 * This routine is responsible for rotating a single
 * coordinate.  At entry, the 'b' register must contain
 * the rotation value, and the 'a' register must contain
 * the coordinate.  The value is returned in the 'd' register.
 */
PF5FF: subb  #0x10;
rotate_1_coordinate:
       stb   0x36;           /* Save rotation value */
       sta   0x3B;           /* Save the coordinate */
       bsr   get_rotation_index_pairs;
       bsr   xform_1a;
       nega;
       pshs  a;
       bsr   xform_2a;
       puls  b,pc;


/*
 * This routine rotates a vector list of length 'n', where
 * 'n' is specified by the 'b' register.  The 'a' register
 * contains the rotation value; the 'x' register contains
 * a pointer to the vector list to be transformed; and
 * the 'u' register containss a pointer to a buffer into
 * which the transformed points are to be saved.
 * The vector list is composed of only y,x pairs.
 */
rotate_vector_list2:
       sta   $C836;          /* Save the rotation value */
       stb   $C823;          /* Save the byte counter */
       pshs  dp;
       jsr   $dptoC8;
       bsr   get_rotation_index_pairs;
       bra   rotate_a_pt:    /* Process the vector list */


/*
 * This procedure is responible for rotating a vector list
 * having the following format:
 *
 *       mode, relative y, relative x,
 *                .
 *                .
 *       1
 *
 * At entry, the 'a' register must contain the rotation value,
 * the 'x' register must point to the vector list to be
 * transformed, and the 'u' register must point to a buffer
 * which is to be used to store the transformed coordinates.
 */
rotate_vector_list1:
       sta   $C836;          /* Save rotation value */
       pshs  dp;
       jsr   $dptoC8;
       sta   0x23;
       bsr   get_rotation_index_pairs;
process_next_point:
       lda   ,x+;            /* Copy the mode, and process the */
       sta   ,u+;            /* next point if mode <= 0.       */
       ble   rotate_a_pt:
       clr   0x23;
       puls  dp,pc;


dec_vl_counter:
       dec   0x23;           /* Decrement the vector list counter */
rotate_a_pt:
       lda   ,x+;            /* Load 'a' reg with the y coord */
       bsr   xform_2;
       sta   ,u;
       lda   ,x;             /* Load 'a' reg with the x coord */
       bsr   xform_1;
       adda  ,u;             /* Save transformed y coord */
       sta   ,u+;
       lda   -1,x;           /* Load 'a' reg with the y coord */
       bsr   xform_1;
       sta   ,u;
       lda   ,x+;            /* Load 'a' reg with the x coord */
       bsr   xform_2;
       suba  ,u;
       sta   ,u+;            /* Save transformed x coord */
       lda   0x23;
       bmi   process_next_point;
       bne   dec_vl_counter;
       puls  dp,pc;


/*
 * The following routines all do a transformation of a
 * point.  xform_1() and xform_2() expect the coordinate
 * to be specified in the 'a' register.  xform_1a() and
 * xform_2a() expect the coordinate to already be stored
 * in C83B.
 */
xform_1:
       sta   0x3B;
xform_1a:
       ldd   0x37;           /* Use table index values 1 */
       bra   PF665;
xform_2:
       sta   0x3B;
xform_2a:
       ldd   0x39;           /* Use table index values 2 */
PF665: stb   0x3C;
       bitb  #0x01;
       beq   PF66F;
       lda   0x3B;
       bra   PF679;
PF66F: ldb   0x3B;
       bpl   PF676;
       com   0x3C;
       negb;
PF676: mul;
       adca  #0x00;
PF679: ldb   0x3C;
       bpl   PF67E;
       nega;
PF67E: rts;


/*
 * Move a block of memory, starting at hi memory, and
 * working down to low memory.  The source address is
 * specified in the u register, and the destination is
 * specified in the x register.  The number of bytes
 * moved is equal to the value in the a register + 1.
 * The maximum value which can be specified in the a
 * register is 0x80.
 */
move_block:
       ldb   a,u;
       stb   a,x;
       deca;
       bpl   move_block;
rtn2:  rts;

/*
 * This should be called before you attempt to make a sound.
 * It should be called every refresh cycle, just before you
 * call waitrecal().  If you want to start a new sound, then
 * you must set C856 to 1, and point the u register to the
 * sound block.  If no sound is in progress (C856 = 0), then
 * it returns immediately.  While a sound is in progress, C856
 * will be set to 0x80.
 * This routine processes a single note at a time, and calculates
 * the amplitude and course/fine tuning values for the 3 sound
 * channels.  The values calculated are stored in the array located
 * at C83F-C84C; C83F = reg D, C840 = regC, C841 = regB, etc....
 * Dp must be set to C8.
 */
init_sound:
       lda   0x56;                /* See if a sound is in progress */
       bmi   continue_sound;      /* or if we should start a new one */
       beq   rtn2;
init_sound2:
       ldx   #music_stuff3;
       stx   0x4D;
       lda   #0x80;
       sta   0x56;           /* Flag that init_sound was called */
       ldd   ,u++;
       std   0x4F;           /* Save 1st param in music block */
       ldd   ,u++;
       std   0x51;           /* Save 2nd param in music block */
       stu   0x53;           /* Save ptr to block of music */
       jsr   $init_music_buf;
       ldd   #0x1F1F;
       std   0x5F;
       ldd   #0x0000;
       std   0x63;
       std   0x65;
       sta   0x55;
       bra   PF6EC;
continue_sound:
       ldu   #0xC85E;     /* Continue current sound */
       ldb   #0x02;
PF6B8: lda   b,u;
       cmpa  #0x1F;
       beq   PF6C0;
       inc   b,u;
PF6C0: decb;
       bpl   PF6B8;
       ldx   0x51;
       ldu   #0xC858;
       lda   #0x07;
PF6CA: inc   ,u;
       cmpa  ,u;
       bge   PF6D2;
       clr   ,u;
PF6D2: ldb   ,u+;
       andb  #0x07;
       ldb   b,x;
       stb   ,u+;
       inca;
       cmpa  #0x09;
       bls   PF6CA;
       dec   0x57;
       bne   PF74E;
music_delay:
       lda   0x55;           /* This does something like changing */
       deca;                 /* octives! I really am quessing */
       bpl   PF6EA;
       lda   #0x02;
PF6EA: sta   0x55;
PF6EC: ldb   [C853];              /* Load the next music note */
       ldu   #0xC85E;
       clr   a,u;
       bitb  #0x40; /* "@" */
       beq   PF712;
       ldx   #music_stuff1;
       lda   a,x;
       anda  0x45;
       sta   0x45;
       lda   0x55;
       adda  #0x03;
       lda   a,x;
       ora   0x45;
       sta   0x45;
       andb  #0x1F;
       stb   0x46;
       bra   PF735;
PF712: ldx   #music_stuff2;
       lda   a,x;
       anda  0x45;
       sta   0x45;
       lda   0x55;
       adda  #0x03;
       lda   a,x;
       ora   0x45;
       sta   0x45;
       lda   0x55;
       asla;
       adda  #0x03;
       leau  a,u;
       andb  #0x3F; /* "?" */
       aslb;
       ldx   0x4D;
       ldd   b,x;
       std   ,u;
PF735: ldx   0x53;           /* Grab next note, & update ptr */
       ldb   ,x+;
       stx   0x53;
       tstb;
       bmi   music_delay;    /* Negative note = ?? */
       ldb   ,x+;            /* Grab the duration */
       bpl   PF748;
       jsr   $init_music_buf;
       clr   0x56;           /* All done when duration = 0x80 */
       rts;
PF748: stx   0x53;
       andb  #0x3F; /* "?" */
       stb   0x57;
PF74E: ldy   0x4F;
       ldu   #0xC85E;
       ldx   #0xC842;
       lda   #0x02;
PF759: ldb   ,u+;
       bitb  #0x01;
       beq   PF766;
       lsrb;
       ldb   b,y;
       andb  #0x0F;
       bra   PF76D;
PF766: lsrb;
       ldb   b,y;
       lsrb;
       lsrb;
       lsrb;
       lsrb;
PF76D: stb   a,x;
       deca;
       bpl   PF759;
       ldu   #0xC867;
       ldx   #0xC847;
PF778: ldd   ,--u;
       tst   -8,u;
       bpl   PF788;
       neg   -8,u;
       subb  -8,u;
       sbca  #0x00;
       neg   -8,u;
       bra   PF78C;
PF788: addb  -8,u;
       adca  #0x00;
PF78C: std   ,x++;
       cmpx  #0xC84D;        /* Temporarily stop when we have filled */
       bne   PF778;          /* the music buffer completely.         */
PF793: rts;


player_string:
       .byte 0x20;  /* rel y = 32  (for score) */
       .byte 0xC0;  /* rel x = -64 (for score) */
       .byte 0x40;  /* rel y = 64  (player string) */
       .byte 0xC0;  /* rel x = -64 (player string) */
       .byte "PLAYER",0x80;

game_string:
       .byte 0xE0;  /* rel y  = -32 (for game #) */
       .byte 0xC0;  /* rel x = -64  (for game #) */
       .byte 0x01;  /* rel y = 1    (for game string) */
       .byte 0xC0;  /* rel x = -64  (for game string) */
       .byte " GAME",0x80;

/*
 * Ask the player for the number of players, and the game
 * desired to play.  The maximum number of players allowed
 * should be specified in the a register, and the maximum
 * game number should be specified in the b register.  If
 * either a or b is zero, then that question will not be
 * asked.  The number of players selected is returned in
 * C879, and the game number selected is returned in C87A.
 */
get_players_game:
       std   $C84F;
       tsta;
       beq   PF7B1;
       lda   #0x01;
PF7B1: tstb;
       beq   PF7B6;
       ldb   #0x01;
PF7B6: std   $C879;
       jsr   $dptoC8;
       ldd   #0xF850;
       std   0x2A;           /* Set string height & width */
       sta   0x3C;
       bra   handle_buttons;


/*
 * This routine allows the user a given amount of time to modiy
 * the game # and number of players.  Each time a button is pressed,
 * the timer will be reset.  Control will be relinquished when the
 * timer finally expires.
 */
button_handler_loop:
       jsr   $waitrecal;
       clra;
       jsr   $read_switches;  /* Read switches, & decrement loop counter */
       jsr   $decrement_counters_C82E_C830;

       jsr   $intensity_to_7F;
       lda   $C879;
       ldy   #player_string;
       bsr   display_option_string; /* Ask user for the number of players */
       lda   $C87A;
       ldy   #game_string;
       bsr   display_option_string; /* Ask user for the game number */

       jsr   $dptoC8;
       lda   0x3C;
       beq   check_loop_counter;
       lda   0x0F;
       bne   handle_buttons;
       clr   0x3C;           /* Reset loop counter when button pressed */

check_loop_counter:
       lda   0x2F;           /* Check counter in C82F and exit */
       beq   PF793;          /* when it reaches zero.          */
       lda   0x2E;
       bne   button_handler_loop;
       lda   0x15;           /* Start the game, if switch 4 has */
       bne   PF793;          /* been presses.                   */
       lda   0x12;
       beq   check_button2;  /* Increment the number of players */
       lda   0x79;           /* if switch 1 has been pressed. Be*/
       beq   check_button2;  /* sure to handle wrap.            */
       inca;
       cmpa  0x4F;
       bls   PF80C;
       lda   #0x01;
PF80C: sta   0x79;
       bra   handle_buttons;
check_button2:
       lda   0x7A;                /* If multiple games can be selected, */
       beq   button_handler_loop; /* then increment the game number if  */
       ldb   0x13;                /* switch 2 has been pressed.         */
       beq   check_button3;
       inca;
       cmpa  0x50;
       bls   PF82A;
       lda   #0x01;
       bra   PF82A;
check_button3:
       ldb   0x14;                /* Decrement the game number, if */
       beq   button_handler_loop; /* switch 3 has been pressed.    */
       deca;
       bne   PF82A;
       lda   0x50;
PF82A: sta   0x7A;

handle_buttons:
       lda   #0xF3;               /* Reset the loop counters.     */
       sta   0x2F;
       coma;
       sta   0x2E;
       bra   button_handler_loop;  /* Go back to start of loop.    */


/*
 * Display the player or game string, and the current
 * value for that option.  The a register must contain
 * the value of the option, and the y register must
 * point to a block of the following form:
 *
 *      rel y and rel x for value string
 *      rel y and rel x for player/game string
 *      player/game string
 *      0x80
 */
display_option_string:
       ldx   #0xC85E;        /* C85E is a temp work variable */
       pshs  a;
       bsr   set_dft_score;
       lda   ,s+;
       beq   dos_rtn;
       bsr   convert_a_to_bcd_and_add;
       tfr   x,u;
       ldd   ,y++;
       jsr   $print_at_d;
       tfr   y,u;
       jsr   $print_with_dft_hw:
dos_rtn:
       rts;


/*
 * Initialize the score string, pointed to by the x register,
 * to the string "     0",0x80 .
 */
set_dft_score:
       ldd   #0x2020;
       std   ,x;
       std   2,x;
       sta   4,x;
       ldd   #0x3080;
       std   5,x;
       rts;


/*
 * convert_a_to_bcd_and_add() takes the value in the a register, and
 * converts it to a string of BCD characters, which are then
 * added to the BCD string in the buffer pointed to by the x register.
 */
convert_a_to_bcd_and_add:
       ldu   #0x0000;
PF861: cmpa  #0x63;    /* 99 */
       bls   PF86D;
       suba  #0x64;    /* 100 */
       leau  0x0100,u;
       bra   PF861;
PF86D: cmpa  #0x09;    /*  9  */
       bls   PF878;
       suba  #0x0A;    /* 10  */
       leau  0x10,u;
       bra   PF86D;
PF878: leau  a,u;
       tfr   u,d;

/* Add the BCD value in d register to ascii string stored in x reg */
add_d_to_x_in_bcd:
       pshs  a;
       pshs  b;
       ldb   #0x05;
PF882: clra;
       cmpb  #0x01;
       bls   PF897;
       bitb  #0x01;
       beq   PF88F;
       lda   ,s;
       bra   PF895;
PF88F: lda   ,s+;
       lsra;
       lsra;
       lsra;
       lsra;
PF895: anda  #0x0F;
PF897: adda  $C823;
       clr   $C823;
       adda  b,x;
       cmpa  #0x2F; /* "/" */
       bgt   PF8A5;
       adda  #0x10;
PF8A5: cmpa  #0x39; /* "9" */
       bls   PF8AE;
       suba  #0x0A;
       inc   $C823;
PF8AE: sta   b,x;            /* Strip leading 0's */
       decb;
       bpl   PF882;
       clr   $C823;
       clrb;
PF8B7: lda   b,x;
       cmpa  #0x30;          /* Replace leading 0 with */
       bne   PF8C6;          /* a space.               */
       lda   #0x20;
       sta   b,x;
       incb;
       cmpb  #0x05;
       blt   PF8B7;
PF8C6: rts;


/*
 * This procedure compares the two score strings pointed to by the
 * x and u registers.  It returns one of the following values,
 * depending upon which score was higher:
 *
 *      1) The scores are the same: a = 0;
 *      2) x score > u score:       a = 1;
 *      3) x score <= u score:      a = 2;
 */
compare_scores:
       pshs  x,u;
       clra;
PF8CA: ldb   ,x+;
       bmi   PF8D6;
       cmpb  ,u+;
       beq   PF8CA;
       bhi   PF8D5;
       inca;
PF8D5: inca;
PF8D6: puls  x,u,pc;


/*
 * This procedure compares the two score string arrays pointed to
 * by the u and x registers.  The u register points to the current
 * hi score.  If the score pointed to by the x register is greater
 * than the current hi score, then it will be copies into the
 * array pointed to by the u register.
 */
check_4_new_hi_score:
       bsr   compare_scores;
       cmpa  #0x01;
       bne   PF8E4;
PF8DE: lda   ,x+;
       sta   ,u+;
       bpl   PF8DE;
PF8E4: rts;


/*
 * This routine modifies the position of the target,
 * before it checks to see if a bullet has hit it.
 * It takes the position of the target, in 'y', and
 * adds 0,u to the y position, and 1,u to the x position.
 * At entry, 'y' should contain the targets (y,x) position,
 * 'x' should contain the bullets (y,x) position, and 'd'
 * should contain the (height/2,width/2) of the target.
 * 'u' points to the modification values.
 */
PF8E5: pshs  y;
       pshs  a,b,x,y;
       ldd   4,s;
       adda  ,u;
       addb  1,u;
PF8EF: std   4,s;
       bra   check_bullet_for_hit2;


/*
 * This routine modifies the position of the target,
 * before it checks to see if a bullet has hit it.
 * It takes the position of the target, in 'y', and
 * adds to it the value in the 'u' register.
 * At entry, 'y' should contain the targets (y,x) position,
 * 'x' should contain the bullets (y,x) position, and 'd'
 * should contain the (height/2,width/2) of the target.
 * 'u' contains the modification values.
 */
PF8F3: pshs  y;
       pshs  a,b,x,y;
       tfr   u,d;
       adda  4,s;
       addb  5,s;
       bra   PF8EF;

/*
 * This routine checks to see if a bullet has hit a
 * target.  If the bullet has hit the target, then
 * the carry bit will be set; else, the carry bit
 * will be cleared.  A hit is checked for in the
 * following fashion:
 *
 *    if (target y - height/2) <= bullet y <= (target y + height/2)
 *                              and
 *       (target x - width/2)  <= bullet x <= (target x + width/2)
 *
 *    then the bullet hit, else it missed.
 *
 * At entry, 'x' must contain the bullet position, 'y' must contain
 * the target position, and 'd' must contain the (height/2,width/2)
 * pair.
 */
check_bullet_for_hit:
       pshs  y;
       pshs  a,b,x,y;
check_bullet_for_hit2:
       tfr   sp,x;
       clrb;                 /* Start by checking the y coordinate */
check_bullet_loop:
       abx;
       lda   4,x;            /* Add target y to height/2 (if b = 0) */
       adda  ,x;             /* Add target x to width/2 (if b = 1)  */
       bvc   check_bullet_pt1;
       lda   #0x7F;          /* Only goto edge of screen */
check_bullet_pt1:
       cmpa  2,x;            /* See if bullet is close enough */
       blt   flag_a_miss;
       lda   4,x;
       suba  ,x;
       bvc   check_bullet_pt2;
       lda   #0x80;          /* Only goto edge of screen */
check_bullet_pt2:
       cmpa  2,x;
       bgt   flag_a_miss;
       incb;                 /* go back and check the x coordinate */
       cmpb  #0x02;
       blo   check_bullet_loop;
       orcc  #0x01;          /* Flag a hit; set carry bit */
       bra   PF92A;
flag_a_miss:
       andcc #0xFE;          /* Flag a miss; clear carry bit */
PF92A: puls  a,b,x,y;
       puls  y,pc;


PF92E: lda   0x67;
       bpl   PF95B;
       anda  #0x7F;
       sta   0x67;
       ldx   #0xC858;
       lda   #0x04;
       jsr   $PF683;
       lsrb;
       lsrb;
       lsrb;
       orb   0x58;
       andb  #0x07;
       stb   0x54;
       ldb   0x58;
       andb  #0x38; /* "8" */
       stb   0x53;
       ldb   0x58;
       andb  #0x07;
       stb   0x5D;
       ldb   #0x02;
       stb   0x5C;
       lda   #0x7F;
       bra   PF968;
PF95B: lda   0x77;
       beq   PF9C9;
       suba  0x5B;
       bpl   PF968;
       clrb;
       stb   0x77;
       bra   PF9CA;
PF968: sta   0x77;
       lsra;
       lsra;
       ldb   0x53;
       beq   PF97D;
       sta   0x46;
       ldb   0x59;
       bmi   PF97B;
       beq   PF97D;
       tfr   a,b;
       coma;
PF97B: stb   0x46;
PF97D: lsra;
       cmpa  #0x07;
       bls   PF987;
       cmpa  #0x0F;
       beq   PF987;
       inca;
PF987: ldb   0x5A;
       bmi   PF991;
       beq   PF98F;
       eora  #0x0F;
PF98F: tfr   a,b;
PF991: bsr   PF9CA;
       ldb   0x5D;
       beq   PF9C2;
PF997: lda   0x5C;
       deca;
       bpl   PF99E;
       lda   #0x02;
PF99E: sta   0x5C;
       jsr   $get_bit_mask;
       bita  0x5D;
       beq   PF997;
       ldb   0x5C;
       aslb;
       negb;
       ldx   #0xC84B;
       leax  b,x;
       jsr   $PF517;
       anda  #0x0F;
       cmpa  #0x05;
       bhi   PF9BC;
       asla;
       adda  #0x05;
PF9BC: sta   ,x;
       lda   0x7E;
       sta   1,x;
PF9C2: lda   0x58;
       coma;
       anda  0x45;
       sta   0x45;
PF9C9: rts;
PF9CA: lda   0x54;
       ldx   #0xC845;
PF9CF: tsta;
       beq   PF9DB;
       leax  -1,x;
PF9D4: lsra;
       bhs   PF9CF;
       stb   ,x;
       bra   PF9CF;
PF9DB: rts;


bit_masks:
       .byte 0x01;
       .byte 0x02;
       .byte 0x04;
       .byte 0x08;
       .byte 0x10;
       .byte 0x20;
       .byte 0x40;
       .byte 0x80;

music_stuff1:
       .byte 0xF7;
       .byte 0xEF;
       .byte 0xDF;
       .byte 0x01;
       .byte 0x02;
       .byte 0x04;

music_stuff2:
       .byte 0xFE;
       .byte 0xFD;
       .byte 0xFB;
       .byte 0x08;
       .byte 0x10;
       .byte 0x20;

SF9F0: .byte 0x7F;
       .byte 0x7F;
       .byte 0x80;
       .byte 0x80;

/* This is the start of the character generation table used by
 * the string printing routine.  The table starts at F9F4,
 * and goes for the next 480 bytes.
 */
character_table:
       .byte 0x00;
       .byte 0x20;
       .byte 0x50;
       .byte 0x50;
       .byte 0x20;
       .byte 0xC8;
       .byte 0x20;
       .byte 0x10;
       .byte 0x10;
       .byte 0x40;

       .byte 0x20;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x08;
       .byte 0x30;
       .byte 0x20;
       .byte 0x70;
       .byte 0x70;

       .byte 0x10;
       .byte 0xF8;
       .byte 0x30;
       .byte 0xF8;
       .byte 0x70;
       .byte 0x70;
       .byte 0x00;
       .byte 0x60;
       .byte 0x00;
       .byte 0x00;

       .byte 0x00;
       .byte 0x70;
       .byte 0x70;
       .byte 0x20;
       .byte 0xF0;
       .byte 0x70;
       .byte 0xF0;
       .byte 0xF8;
       .byte 0xF8;
       .byte 0x78;

       .byte 0x88;
       .byte 0x70;
       .byte 0x08;
       .byte 0x88;
       .byte 0x80;
       .byte 0x88;
       .byte 0x88;
       .byte 0xF8;
       .byte 0xF0;
       .byte 0x70;

       .byte 0xF0;
       .byte 0x70;
       .byte 0xF8;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0xF8;
       .byte 0x70;

       .byte 0x80;
       .byte 0x70;
       .byte 0x20;
       .byte 0x00;
       .byte 0x00;
       .byte 0x20;
       .byte 0x08;
       .byte 0x20;
       .byte 0x00;
       .byte 0x00;

       .byte 0x00;
       .byte 0x38;
       .byte 0x10;
       .byte 0x20;
       .byte 0x44;
       .byte 0x44;
       .byte 0x00;
       .byte 0xFE;
       .byte 0xFF;
       .byte 0xFE;

       .byte 0x00;
       .byte 0x70;
       .byte 0x50;
       .byte 0x50;
       .byte 0x78;
       .byte 0xC8;
       .byte 0x50;
       .byte 0x20;
       .byte 0x20;
       .byte 0x20;

       .byte 0xA8;
       .byte 0x20;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x08;
       .byte 0x48;
       .byte 0x60;
       .byte 0x88;
       .byte 0x88;

       .byte 0x30;
       .byte 0x80;
       .byte 0x40;
       .byte 0x08;
       .byte 0x88;
       .byte 0x88;
       .byte 0x60;
       .byte 0x60;
       .byte 0x10;
       .byte 0x00;

       .byte 0x40;
       .byte 0x88;
       .byte 0x88;
       .byte 0x50;
       .byte 0x48;
       .byte 0x88;
       .byte 0x48;
       .byte 0x80;
       .byte 0x80;
       .byte 0x80;

       .byte 0x88;
       .byte 0x20;
       .byte 0x08;
       .byte 0x90;
       .byte 0x80;
       .byte 0xD8;
       .byte 0xC8;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;

       .byte 0x88;
       .byte 0x88;
       .byte 0xA8;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x08;
       .byte 0x40;

       .byte 0x80;
       .byte 0x08;
       .byte 0x50;
       .byte 0x00;
       .byte 0x00;
       .byte 0x70;
       .byte 0x0C;
       .byte 0x20;
       .byte 0x70;
       .byte 0x70;

       .byte 0x00;
       .byte 0x44;
       .byte 0x10;
       .byte 0x70;
       .byte 0x00;
       .byte 0x00;
       .byte 0x6C;
       .byte 0x82;
       .byte 0xFF;
       .byte 0xFE;

       .byte 0x00;
       .byte 0x70;
       .byte 0x50;
       .byte 0xF8;
       .byte 0xA0;
       .byte 0x10;
       .byte 0x50;
       .byte 0x40;
       .byte 0x40;
       .byte 0x10;

       .byte 0x70;
       .byte 0x20;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x10;
       .byte 0x48;
       .byte 0x20;
       .byte 0x08;
       .byte 0x08;

       .byte 0x50;
       .byte 0xF0;
       .byte 0x80;
       .byte 0x10;
       .byte 0x88;
       .byte 0x88;
       .byte 0x60;
       .byte 0x00;
       .byte 0x20;
       .byte 0x78;

       .byte 0x20;
       .byte 0x08;
       .byte 0xA8;
       .byte 0x88;
       .byte 0x48;
       .byte 0x80;
       .byte 0x48;
       .byte 0x80;
       .byte 0x80;
       .byte 0x80;

       .byte 0x88;
       .byte 0x20;
       .byte 0x08;
       .byte 0xA0;
       .byte 0x80;
       .byte 0xA8;
       .byte 0xA8;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;

       .byte 0x88;
       .byte 0x40;
       .byte 0x20;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x50;
       .byte 0x50;
       .byte 0x10;
       .byte 0x40;

       .byte 0x40;
       .byte 0x08;
       .byte 0x88;
       .byte 0x00;
       .byte 0x70;
       .byte 0xA8;
       .byte 0x0A;
       .byte 0x20;
       .byte 0x88;
       .byte 0xF8;

       .byte 0x60;
       .byte 0xBA;
       .byte 0x38;
       .byte 0x20;
       .byte 0x00;
       .byte 0x00;
       .byte 0x92;
       .byte 0x82;
       .byte 0xFF;
       .byte 0xFE;

       .byte 0x00;
       .byte 0x20;
       .byte 0x00;
       .byte 0x50;
       .byte 0x70;
       .byte 0x20;
       .byte 0x60;
       .byte 0x00;
       .byte 0x40;
       .byte 0x10;

       .byte 0xA8;
       .byte 0xF8;
       .byte 0x00;
       .byte 0x70;
       .byte 0x00;
       .byte 0x20;
       .byte 0x48;
       .byte 0x20;
       .byte 0x70;
       .byte 0x30;

       .byte 0x90;
       .byte 0x08;
       .byte 0xF0;
       .byte 0x20;
       .byte 0x70;
       .byte 0x78;
       .byte 0x00;
       .byte 0x60;
       .byte 0x40;
       .byte 0x00;

       .byte 0x10;
       .byte 0x10;
       .byte 0xB8;
       .byte 0x88;
       .byte 0x70;
       .byte 0x80;
       .byte 0x48;
       .byte 0xE0;
       .byte 0xE0;
       .byte 0x98;

       .byte 0xF8;
       .byte 0x20;
       .byte 0x08;
       .byte 0xC0;
       .byte 0x80;
       .byte 0xA8;
       .byte 0x98;
       .byte 0x88;
       .byte 0xF0;
       .byte 0x88;

       .byte 0xF0;
       .byte 0x20;
       .byte 0x20;
       .byte 0x88;
       .byte 0x50;
       .byte 0xA8;
       .byte 0x20;
       .byte 0x20;
       .byte 0x20;
       .byte 0x40;

       .byte 0x20;
       .byte 0x08;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0x20;
       .byte 0x08;
       .byte 0x20;
       .byte 0x88;
       .byte 0xF8;

       .byte 0xF0;
       .byte 0xA2;
       .byte 0x38;
       .byte 0xF8;
       .byte 0x82;
       .byte 0x38;
       .byte 0x92;
       .byte 0x82;
       .byte 0xFF;
       .byte 0xFE;

       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xF8;
       .byte 0x70;
       .byte 0x40;
       .byte 0xA8;
       .byte 0x00;
       .byte 0x40;
       .byte 0x10;

       .byte 0xA8;
       .byte 0x20;
       .byte 0x40;
       .byte 0x00;
       .byte 0x00;
       .byte 0x40;
       .byte 0x48;
       .byte 0x20;
       .byte 0x80;
       .byte 0x08;

       .byte 0xF8;
       .byte 0x08;
       .byte 0x88;
       .byte 0x40;
       .byte 0x88;
       .byte 0x08;
       .byte 0x60;
       .byte 0x60;
       .byte 0x20;
       .byte 0x78;

       .byte 0x20;
       .byte 0x20;
       .byte 0xB0;
       .byte 0xF8;
       .byte 0x48;
       .byte 0x80;
       .byte 0x48;
       .byte 0x80;
       .byte 0x80;
       .byte 0x88;

       .byte 0x88;
       .byte 0x20;
       .byte 0x08;
       .byte 0xA0;
       .byte 0x80;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x80;
       .byte 0xA8;

       .byte 0xA0;
       .byte 0x10;
       .byte 0x20;
       .byte 0x88;
       .byte 0x50;
       .byte 0xA8;
       .byte 0x50;
       .byte 0x20;
       .byte 0x40;
       .byte 0x40;

       .byte 0x10;
       .byte 0x08;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0x20;
       .byte 0x78;
       .byte 0xA8;
       .byte 0x88;
       .byte 0xF8;

       .byte 0xF0;
       .byte 0xBA;
       .byte 0x7C;
       .byte 0x20;
       .byte 0x44;
       .byte 0x44;
       .byte 0x6C;
       .byte 0x82;
       .byte 0xFF;
       .byte 0xFE;

       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x50;
       .byte 0x28;
       .byte 0x98;
       .byte 0x90;
       .byte 0x00;
       .byte 0x20;
       .byte 0x20;

       .byte 0x00;
       .byte 0x20;
       .byte 0x40;
       .byte 0x00;
       .byte 0x00;
       .byte 0x80;
       .byte 0x48;
       .byte 0x20;
       .byte 0x80;
       .byte 0x88;

       .byte 0x10;
       .byte 0x88;
       .byte 0x88;
       .byte 0x80;
       .byte 0x88;
       .byte 0x10;
       .byte 0x60;
       .byte 0x20;
       .byte 0x10;
       .byte 0x00;

       .byte 0x40;
       .byte 0x00;
       .byte 0x80;
       .byte 0x88;
       .byte 0x48;
       .byte 0x88;
       .byte 0x48;
       .byte 0x80;
       .byte 0x80;
       .byte 0x88;

       .byte 0x88;
       .byte 0x20;
       .byte 0x88;
       .byte 0x90;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x80;
       .byte 0x90;

       .byte 0x90;
       .byte 0x88;
       .byte 0x20;
       .byte 0x88;
       .byte 0x20;
       .byte 0xA8;
       .byte 0x88;
       .byte 0x20;
       .byte 0x80;
       .byte 0x40;

       .byte 0x08;
       .byte 0x08;
       .byte 0x00;
       .byte 0x00;
       .byte 0x48;
       .byte 0x20;
       .byte 0xF0;
       .byte 0x70;
       .byte 0x70;
       .byte 0x70;

       .byte 0x60;
       .byte 0x44;
       .byte 0x6C;
       .byte 0x50;
       .byte 0x38;
       .byte 0x82;
       .byte 0x00;
       .byte 0x82;
       .byte 0xFF;
       .byte 0xFE;
/* End of character generation table */

       .byte 0x00;
       .byte 0x20; /* " " */
       .byte 0x00;
       .byte 0x50; /* "P" */
       .byte 0xF8;
       .byte 0x98;
       .byte 0x68; /* "h" */
       .byte 0x00;
       .byte 0x10;
       .byte 0x40; /* "@" */
       .byte 0x00;
       .byte 0x00;
       .byte 0x80;
       .byte 0x00;
       .byte 0x80;
       .byte 0x80;
       .byte 0x30; /* "0" */
       .byte 0x70; /* "p" */
       .byte 0xF8;
       .byte 0x70; /* "p" */
       .byte 0x10;
       .byte 0x70; /* "p" */
       .byte 0x70; /* "p" */
       .byte 0x80;
       .byte 0x70; /* "p" */
       .byte 0x60; /* "`" */
       .byte 0x00;
       .byte 0x40; /* "@" */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x20; /* " " */
       .byte 0x78; /* "x" */
       .byte 0x88;
       .byte 0xF0;
       .byte 0x70; /* "p" */
       .byte 0xF0;
       .byte 0xF8;
       .byte 0x80;
       .byte 0x78; /* "x" */
       .byte 0x88;
       .byte 0x70; /* "p" */
       .byte 0x70; /* "p" */
       .byte 0x88;
       .byte 0xF8;
       .byte 0x88;
       .byte 0x88;
       .byte 0xF8;
       .byte 0x80;
       .byte 0x68; /* "h" */
       .byte 0x88;
       .byte 0x70; /* "p" */
       .byte 0x20; /* " " */
       .byte 0x70; /* "p" */
       .byte 0x20; /* " " */
       .byte 0x50; /* "P" */
       .byte 0x88;
       .byte 0x20; /* " " */
       .byte 0xF8;
       .byte 0x70; /* "p" */
       .byte 0x08;
       .byte 0x70; /* "p" */
       .byte 0x00;
       .byte 0xF8;
       .byte 0x00;
       .byte 0x20; /* " " */
       .byte 0x60; /* "`" */
       .byte 0x20; /* " " */
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x38; /* "8" */
       .byte 0x82;
       .byte 0x88;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0xFF;
       .byte 0xFE;
SFC24: .byte 0x00;
       .byte 0x11;
       .byte 0x41; /* "A" */
       .byte 0x30; /* "0" */
       .byte 0x21; /* "!" */
       .byte 0x10;
       .byte 0x20; /* " " */
       .byte 0x31; /* "1" */
SFC2C: .byte 0x00;
       .byte 0x01;
       .byte 0x03;
       .byte 0x06;
       .byte 0x0A;
       .byte 0x0F;
       .byte 0x15;
       .byte 0x1C;
       .byte 0x24; /* "$" */
       .byte 0x2D; /* "-" */
       .byte 0x08;
       .byte 0x10;
SFC38: .byte 0x08;
       .byte 0x10;
       .byte 0x0B;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0D;
       .byte 0x0A;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0E;
       .byte 0x0B;
       .byte 0x09;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0E;
       .byte 0x0C;
       .byte 0x0A;
       .byte 0x09;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0E;
       .byte 0x0D;
       .byte 0x0B;
       .byte 0x0A;
       .byte 0x09;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0F;
       .byte 0x0D;
       .byte 0x0C;
       .byte 0x0B;
       .byte 0x0A;
       .byte 0x09;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0F;
       .byte 0x0E;
       .byte 0x0C;
       .byte 0x0B;
       .byte 0x0A;
       .byte 0x09;
       .byte 0x09;
       .byte 0x08;
       .byte 0x10;
       .byte 0x0F;
       .byte 0x0E;
       .byte 0x0D;
       .byte 0x0C;
       .byte 0x0B;
       .byte 0x0A;
       .byte 0x09;
       .byte 0x09;
       .byte 0x08;
SFC6D: .byte 0x00;
       .byte 0x19;
       .byte 0x32; /* "2" */
       .byte 0x4A; /* "J" */
       .byte 0x62; /* "b" */
       .byte 0x79; /* "y" */
       .byte 0x8E;
       .byte 0xA2;
       .byte 0xB5;
       .byte 0xC6;
       .byte 0xD5;
       .byte 0xE2;
       .byte 0xED;
       .byte 0xF5;
       .byte 0xFB;
       .byte 0xFF;
       .byte 0xFF;
       .byte 0xFF;
       .byte 0xFB;
       .byte 0xF5;
       .byte 0xED;
       .byte 0xE2;
       .byte 0xD5;
       .byte 0xC6;
       .byte 0xB5;
       .byte 0xA2;
       .byte 0x8E;
       .byte 0x79; /* "y" */
       .byte 0x62; /* "b" */
       .byte 0x4A; /* "J" */
       .byte 0x32; /* "2" */
       .byte 0x19;

music_stuff3;
SFC8D: .byte 0x03;
       .byte 0xBD;
       .byte 0x03;
       .byte 0x87;
       .byte 0x03;
       .byte 0x54; /* "T" */
       .byte 0x03;
       .byte 0x24; /* "$" */
       .byte 0x02;
       .byte 0xF7;
       .byte 0x02;
       .byte 0xCD;
       .byte 0x02;
       .byte 0xA4;
       .byte 0x02;
       .byte 0x7E; /* "~" */
       .byte 0x02;
       .byte 0x5B; /* "[" */
       .byte 0x02;
       .byte 0x39; /* "9" */
       .byte 0x02;
       .byte 0x19;
       .byte 0x01;
       .byte 0xFB;
       .byte 0x01;
       .byte 0xDE;
       .byte 0x01;
       .byte 0xC3;
       .byte 0x01;
       .byte 0xAA;
       .byte 0x01;
       .byte 0x92;
       .byte 0x01;
       .byte 0x7C; /* "|" */
       .byte 0x01;
       .byte 0x66; /* "f" */
       .byte 0x01;
       .byte 0x52; /* "R" */
       .byte 0x01;
       .byte 0x3F; /* "?" */
       .byte 0x01;
       .byte 0x2D; /* "-" */
       .byte 0x01;
       .byte 0x1C;
       .byte 0x01;
       .byte 0x0C;
       .byte 0x00;
       .byte 0xFD;
       .byte 0x00;
       .byte 0xEF;
       .byte 0x00;
       .byte 0xE2;
       .byte 0x00;
       .byte 0xD5;
       .byte 0x00;
       .byte 0xC9;
       .byte 0x00;
       .byte 0xBE;
       .byte 0x00;
       .byte 0xB3;
       .byte 0x00;
       .byte 0xA9;
       .byte 0x00;
       .byte 0xA0;
       .byte 0x00;
       .byte 0x97;
       .byte 0x00;
       .byte 0x8E;
       .byte 0x00;
       .byte 0x86;
       .byte 0x00;
       .byte 0x7F;
       .byte 0x00;
       .byte 0x78; /* "x" */
       .byte 0x00;
       .byte 0x71; /* "q" */
       .byte 0x00;
       .byte 0x6B; /* "k" */
       .byte 0x00;
       .byte 0x65; /* "e" */
       .byte 0x00;
       .byte 0x5F; /* "_" */
       .byte 0x00;
       .byte 0x5A; /* "Z" */
       .byte 0x00;
       .byte 0x55; /* "U" */
       .byte 0x00;
       .byte 0x50; /* "P" */
       .byte 0x00;
       .byte 0x4B; /* "K" */
       .byte 0x00;
       .byte 0x47; /* "G" */
       .byte 0x00;
       .byte 0x43; /* "C" */
       .byte 0x00;
       .byte 0x3F; /* "?" */
       .byte 0x00;
       .byte 0x3C; /* "<" */
       .byte 0x00;
       .byte 0x38; /* "8" */
       .byte 0x00;
       .byte 0x35; /* "5" */
       .byte 0x00;
       .byte 0x32; /* "2" */
       .byte 0x00;
       .byte 0x2F; /* "/" */
       .byte 0x00;
       .byte 0x2D; /* "-" */
       .byte 0x00;
       .byte 0x2A; /* "*" */
       .byte 0x00;
       .byte 0x28; /* "(" */
       .byte 0x00;
       .byte 0x26; /* "&" */
       .byte 0x00;
       .byte 0x24; /* "$" */
       .byte 0x00;
       .byte 0x22; /* """ */
       .byte 0x00;
       .byte 0x20; /* " " */
       .byte 0x00;
       .byte 0x1E;
       .byte 0x00;
       .byte 0x1C;
       .byte 0x00;
       .byte 0x1B;
       .byte 0x00;
       .byte 0x00;

/* Vectrex introduction music */
intro_music:
       .word #intro_header_1;
       .word #music_header2_a;
       .byte 0x93;       /* delay */
       .byte 0x1F;
       .byte 0x0C;
       .byte 0x93;       /* delay */
       .byte 0x1F;
       .byte 0x06;
       .byte 0x98;       /* delay */
       .byte 0x9F;       /* delay */
       .byte 0x24;
       .byte 0x3C;
       .byte 0x11;
       .byte 0x80;       /* end of music block */

       .byte 0xFD;
       .byte 0x69; /* "i" */
       .byte 0xFD;
       .byte 0x79; /* "y" */
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x0E;
       .byte 0x99;
       .byte 0x9F;
       .byte 0x24; /* "$" */
       .byte 0x0E;
       .byte 0x95;
       .byte 0x9B;
       .byte 0x20; /* " " */
       .byte 0x0E;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x21; /* "!" */
       .byte 0x07;
       .byte 0x9D;
       .byte 0xA3;
       .byte 0x28; /* "(" */
       .byte 0x0E;
       .byte 0xA0;
       .byte 0xA6;
       .byte 0x2B; /* "+" */
       .byte 0x0E;
       .byte 0x22; /* """ */
       .byte 0x02;
       .byte 0x28; /* "(" */
       .byte 0x02;
       .byte 0x2D; /* "-" */
       .byte 0x02;
       .byte 0x28; /* "(" */
       .byte 0x02;
       .byte 0x22; /* """ */
       .byte 0x02;
       .byte 0x28; /* "(" */
       .byte 0x02;
       .byte 0x2D; /* "-" */
       .byte 0x02;
       .byte 0x28; /* "(" */
       .byte 0x02;
       .byte 0x22; /* """ */
       .byte 0x02;
       .byte 0x28; /* "(" */
       .byte 0x02;
       .byte 0x2D; /* "-" */
       .byte 0x02;
       .byte 0x28; /* "(" */
       .byte 0x02;
       .byte 0x2E; /* "." */
       .byte 0x02;
       .byte 0x2D; /* "-" */
       .byte 0x28; /* "(" */
       .byte 0x21; /* "!" */
       .byte 0x80;
       .byte 0xEF;
       .byte 0xFF;
       .byte 0xFE;
       .byte 0xDC;
       .byte 0xBA;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x01;
       .byte 0x02;
       .byte 0x01;
       .byte 0x00;
       .byte 0xFF;
       .byte 0xFE;
       .byte 0xFF;
       .byte 0xFD;
       .byte 0xC3;
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x51; /* "Q" */
       .byte 0x24; /* "$" */
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x0C;
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x18;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x0C;
       .byte 0x50; /* "P" */
       .byte 0x0C;
       .byte 0x50; /* "P" */
       .byte 0x24; /* "$" */
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x0C;
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x06;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x18;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x04;
       .byte 0x50; /* "P" */
       .byte 0x0C;
       .byte 0x50; /* "P" */
       .byte 0x18;
       .byte 0x26; /* "&" */
       .byte 0x80;
       .byte 0xFD;
       .byte 0xBA;
       .byte 0x98;
       .byte 0x76; /* "v" */
       .byte 0x55; /* "U" */
       .byte 0x44; /* "D" */
       .byte 0x33; /* "3" */
       .byte 0x22; /* """ */
       .byte 0x11;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0x28; /* "(" */
       .byte 0xFD;
       .byte 0x79; /* "y" */
       .byte 0x98;
       .byte 0x1C;
       .byte 0x10;
       .byte 0x3F; /* "?" */
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x04;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x04;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x10;
       .byte 0x3F; /* "?" */
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x04;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x04;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x93;
       .byte 0x18;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x9C;
       .byte 0x1F;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x93;
       .byte 0x18;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x93;
       .byte 0x18;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x9C;
       .byte 0x1F;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x93;
       .byte 0x18;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x93;
       .byte 0x18;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x9C;
       .byte 0x1F;
       .byte 0x08;
       .byte 0x98;
       .byte 0x1C;
       .byte 0x08;
       .byte 0x93;
       .byte 0x18;
       .byte 0x08;
       .byte 0x9C;
       .byte 0x1F;
       .byte 0x30; /* "0" */
       .byte 0x1A;
       .byte 0x80;
       .byte 0xFF;
       .byte 0xFE;
       .byte 0xDC;
       .byte 0xBA;
       .byte 0x98;
       .byte 0x76; /* "v" */
       .byte 0x54; /* "T" */
       .byte 0x32; /* "2" */
       .byte 0x10;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0x66; /* "f" */
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x0C;
       .byte 0x18;
       .byte 0x11;
       .byte 0x18;
       .byte 0x0C;
       .byte 0x18;
       .byte 0x11;
       .byte 0x18;
       .byte 0x0C;
       .byte 0x18;
       .byte 0x11;
       .byte 0x18;
       .byte 0x0C;
       .byte 0x12;
       .byte 0x0C;
       .byte 0x06;
       .byte 0x11;
       .byte 0x18;
       .byte 0x9D;
       .byte 0x21; /* "!" */
       .byte 0x18;
       .byte 0x9F;
       .byte 0x23; /* "#" */
       .byte 0x18;
       .byte 0xA1;
       .byte 0x24; /* "$" */
       .byte 0x18;
       .byte 0xA3;
       .byte 0x26; /* "&" */
       .byte 0x18;
       .byte 0x9F;
       .byte 0xA4;
       .byte 0x28; /* "(" */
       .byte 0x18;
       .byte 0x07;
       .byte 0x12;
       .byte 0x07;
       .byte 0x06;
       .byte 0x00;
       .byte 0x3C; /* "<" */
       .byte 0x18;
       .byte 0x80;
       .byte 0xDE;
       .byte 0xEF;
       .byte 0xFE;
       .byte 0xDC;
       .byte 0xBA;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0xB2;
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x18;
       .byte 0x06;
       .byte 0x1A;
       .byte 0x06;
       .byte 0x1C;
       .byte 0x0C;
       .byte 0x18;
       .byte 0x0C;
       .byte 0x1A;
       .byte 0x24; /* "$" */
       .byte 0x23; /* "#" */
       .byte 0x18;
       .byte 0x17;
       .byte 0x06;
       .byte 0x18;
       .byte 0x06;
       .byte 0x1A;
       .byte 0x0C;
       .byte 0x17;
       .byte 0x0C;
       .byte 0x18;
       .byte 0x24; /* "$" */
       .byte 0x24; /* "$" */
       .byte 0x18;
       .byte 0xA4;
       .byte 0x28; /* "(" */
       .byte 0x0C;
       .byte 0xA3;
       .byte 0x26; /* "&" */
       .byte 0x0C;
       .byte 0xA1;
       .byte 0x24; /* "$" */
       .byte 0x0C;
       .byte 0x9F;
       .byte 0x23; /* "#" */
       .byte 0x0C;
       .byte 0x9D;
       .byte 0x21; /* "!" */
       .byte 0x18;
       .byte 0x9A;
       .byte 0x1F;
       .byte 0x18;
       .byte 0x17;
       .byte 0x06;
       .byte 0x18;
       .byte 0x06;
       .byte 0x1A;
       .byte 0x0C;
       .byte 0x17;
       .byte 0x0C;
       .byte 0x18;
       .byte 0x24; /* "$" */
       .byte 0x24; /* "$" */
       .byte 0x24; /* "$" */
       .byte 0x18;
       .byte 0x80;
       .byte 0xFF;
       .byte 0xEE;
       .byte 0xDD;
       .byte 0xCC;

music_header2_a:
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0xE8;
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x96;
       .byte 0x9A;
       .byte 0x1D;
       .byte 0x1E;
       .byte 0x91;
       .byte 0x95;
       .byte 0x18;
       .byte 0x1E;
       .byte 0x94;
       .byte 0x98;
       .byte 0x1B;
       .byte 0x1E;
       .byte 0x8F;
       .byte 0x94;
       .byte 0x18;
       .byte 0x14;
       .byte 0x16;
       .byte 0x0A;
       .byte 0x8C;
       .byte 0x91;
       .byte 0x15;
       .byte 0x14;
       .byte 0x16;
       .byte 0x0A;
       .byte 0x91;
       .byte 0x95;
       .byte 0x18;
       .byte 0x32; /* "2" */
       .byte 0x18;
       .byte 0x80;

intro_header1:
       .byte 0xEE;
       .byte 0xFF;
       .byte 0xFF;
       .byte 0xEE;
       .byte 0xEE;
       .byte 0xDD;
       .byte 0xCC;
       .byte 0xBB;
       .byte 0xAA;
       .byte 0x99;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0x88;
       .byte 0xFF;
       .byte 0x16;
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x1C;
       .byte 0x06;
       .byte 0x1F;
       .byte 0x06;
SFF00: .byte 0x1C;
       .byte 0x06;
       .byte 0x18;
       .byte 0x06;
       .byte 0x1A;
       .byte 0x06;
       .byte 0x18;
       .byte 0x06;
       .byte 0x15;
       .byte 0x06;
       .byte 0x13;
       .byte 0x06;
       .byte 0x18;
       .byte 0x06;
       .byte 0x13;
       .byte 0x06;
       .byte 0x17;
       .byte 0x06;
       .byte 0x18;
       .byte 0x1E;
       .byte 0x18;
       .byte 0x80;
       .byte 0xFF;
       .byte 0xFF;
       .byte 0xEE;
       .byte 0xEE;
       .byte 0xDD;
       .byte 0xDD;
       .byte 0xCC;
       .byte 0xCC;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0x00;
       .byte 0xFE;
       .byte 0x28; /* "(" */
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x16;
       .byte 0x0F;
       .byte 0x16;
       .byte 0x05;
       .byte 0x16;
       .byte 0x05;
       .byte 0x16;
       .byte 0x05;
       .byte 0x1A;
       .byte 0x0F;
       .byte 0x16;
       .byte 0x0F;
       .byte 0x1D;
       .byte 0x0F;
       .byte 0x1D;
       .byte 0x05;
       .byte 0x1D;
       .byte 0x05;
       .byte 0x1D;
       .byte 0x05;
       .byte 0x21; /* "!" */
       .byte 0x0F;
       .byte 0x1D;
       .byte 0x32; /* "2" */
       .byte 0x1D;
       .byte 0x80;
       .byte 0xFE;
       .byte 0x28; /* "(" */
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x16;
       .byte 0x06;
       .byte 0x16;
       .byte 0x02;
       .byte 0x16;
       .byte 0x02;
       .byte 0x16;
       .byte 0x02;
       .byte 0x1A;
       .byte 0x06;
       .byte 0x16;
       .byte 0x06;
       .byte 0x1D;
       .byte 0x06;
       .byte 0x1D;
       .byte 0x02;
       .byte 0x1D;
       .byte 0x02;
       .byte 0x1D;
       .byte 0x02;
       .byte 0x21; /* "!" */
       .byte 0x06;
       .byte 0x1D;
       .byte 0x32; /* "2" */
       .byte 0x11;
       .byte 0x80;
       .byte 0xFE;
       .byte 0x28; /* "(" */
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x1B;
       .byte 0x0F;
       .byte 0x16;
       .byte 0x05;
       .byte 0x16;
       .byte 0x05;
       .byte 0x16;
       .byte 0x05;
       .byte 0x17;
       .byte 0x30; /* "0" */
       .byte 0x16;
       .byte 0x05;
       .byte 0x16;
       .byte 0x05;
       .byte 0x16;
       .byte 0x05;
       .byte 0x17;
       .byte 0x30; /* "0" */
       .byte 0x16;
       .byte 0x80;
       .byte 0xFD;
       .byte 0x69; /* "i" */
       .byte 0xFE;
       .byte 0xB6;
       .byte 0xA0;
       .byte 0x23; /* "#" */
       .byte 0x12;
       .byte 0xA0;
       .byte 0x23; /* "#" */
       .byte 0x0C;
       .byte 0x9C;
       .byte 0x20; /* " " */
       .byte 0x06;
       .byte 0x9E;
       .byte 0x21; /* "!" */
       .byte 0x12;
       .byte 0x9C;
       .byte 0x20; /* " " */
       .byte 0x32; /* "2" */
       .byte 0x13;
       .byte 0x80;
       .byte 0xFD;
       .byte 0xC3;
       .byte 0xFE;
       .byte 0xB6;
       .byte 0x16;
       .byte 0x04;
       .byte 0x16;
       .byte 0x04;
       .byte 0x16;
       .byte 0x04;
       .byte 0x16;
       .byte 0x04;
       .byte 0x1A;
       .byte 0x08;
       .byte 0x1C;
       .byte 0x80;
       .byte 0xA6;
       .byte 0xA0;
       .byte 0x20; /* " " */
       .byte 0x08;
       .byte 0xBD;
       .byte 0xF3;
       .byte 0xBE;
       .byte 0xB6;
       .byte 0xC8;
       .byte 0x80;
       .byte 0x84;
       .byte 0x7F;
       .byte 0xB7;
       .byte 0xC8;
       .byte 0x80;
       .byte 0x7A; /* "z" */
       .byte 0xC8;
       .byte 0x80;
       .byte 0xA6;
       .byte 0xA4;
       .byte 0x47; /* "G" */
       .byte 0x84;
       .byte 0xF8;
       .byte 0xE6;
       .byte 0xA0;
       .byte 0x58; /* "X" */
       .byte 0x58; /* "X" */
       .byte 0x58; /* "X" */
       .byte 0x58; /* "X" */
       .byte 0x57; /* "W" */
       .byte 0xC4;
       .byte 0xF8;
       .byte 0x7D; /* "}" */
       .byte 0xC8;
       .byte 0x80;
       .byte 0x2B; /* "+" */
       .byte 0xDF;
       .byte 0xBD;
       .byte 0xF3;
       .byte 0xDF;
       .byte 0xB6;
       .byte 0xC8;
       .byte 0x80;
       .byte 0x85;
       .byte 0x0F;
       .byte 0x26; /* "&" */
       .byte 0xE0;
       .byte 0x85;
       .byte 0x20;
       .byte 0x27; /* "'" */
       .byte 0xCD;
       .byte 0x39; /* "9" */
       .byte 0x4B; /* "K" */
       .byte 0x41; /* "A" */
       .byte 0x52; /* "R" */
       .byte 0x52; /* "R" */
       .byte 0x53; /* "S" */
       .byte 0x4F; /* "O" */
       .byte 0x46; /* "F" */
       .byte 0x54; /* "T" */
       .byte 0x38; /* "8" */
       .byte 0x32; /* "2" */
       .byte 0x4C; /* "L" */
       .byte 0x44; /* "D" */
       .byte 0x4D; /* "M" */
       .byte 0x43; /* "C" */
       .byte 0x42; /* "B" */
       .byte 0x43; /* "C" */
       .byte 0x4A; /* "J" */
       .byte 0x54; /* "T" */
       .byte 0x38; /* "8" */
       .byte 0x32; /* "2" */
       .byte 0x4C; /* "L" */
       .byte 0x44; /* "D" */
       .byte 0x4D; /* "M" */
       .byte 0x43; /* "C" */
       .byte 0x42; /* "B" */
       .byte 0x43; /* "C" */
       .byte 0x4A; /* "J" */

       /* 6809 interrupt and startup vectors */
       .word 0x0000;
       .word 0x0000;
       .word 0xCBF2;
       .word 0xCBF2;
       .word 0xCBF5;
       .word 0xCBF8;
       .word 0xCBFB;
       .word 0xCBFB;
       .word #start;

