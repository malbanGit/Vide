; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti mine.asm >error
;
; NOTE: THIS IS THE BIOS ROM VERSION, CARTRIDGE STARTUP GCE gXXXX IS
;       NOT IN THIS FILE!
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
*
* This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
* Please forward any comments, corrections or additions back to Fred.
*
* Mine Storm

      include "taft.i"
      direct -1
      noopt
      org $E000

MS_header:
       DW    MS_music; * Mine Storm music block pointer
       DB    $F8;   * height = -8
       DB    $50;   * width = 80
       DB    $30;   * rel y = 48
       DB    $E8;   * rel x = -24
       DB    "MINE",$80;
       DB    $F8;   * height = -8
       DB    $50;   * width = 80
       DB    $00;   * rel y = 0
       DB    $DE;   * rel x = -34
       DB    "STORM",$80,$00;

* Start of the Mine Storm game
MS_start:
       ldx   #$C883;       * Clear C883 - CBC5
PE019: clr   ,x+;
       cmpx  #$CBC5;
       bne   PE019;

       jsr   init_motion_dots;
       inc   $C824;
       lda   #$BB;
       sta   $C880;         * Store console enable flags in C880
       ldx   #$0101;
       stx   $C881;         * Store jstick mak in C881

restart_game:
       ldx   #$C883;       * Clear C883 - CB70
PE034: clr   ,x+;
       cmpx  #$CB70;
       bne   PE034;
       bra   PE03D;

PE03D: jsr   dptoC8;
       ldd   #$0200;       * Ask for number of players
       jsr   get_players_game;
       dec   <$79;          * C879 contains # of players selected
       clr   <$56;
       clr   <$9B;          * C89B specifies which player is active

       ldx   #$C8A8;
       jsr   set_dft_score;* Initialize player 1 score
       ldx   #$C8AF;
       jsr   set_dft_score;* Initialize player 2 score
       ldx   #$C8F9;
       jsr   set_dft_score;* Initialize mine field # for player 1
       ldd   #$0001;
       jsr   add_d_to_x_in_bcd;
       ldx   #$C900;
       jsr   set_dft_score;* Initialize mine field # for player 2
       ldd   #$0001;
       jsr   add_d_to_x_in_bcd;

       ldx   #mines_at_level_x;* Initialize player 1 & 2's pointers
       stx   <$C4;             * into the structure describing which
       stx   <$C6;             * mines are at which level.

       lda   #$05;
       sta   <$D9;      * Initialize # of ships for active player
       sta   <$DA;      * Initialize # of ships for player 1
       sta   <$DB;      * Initialize # of ships for player 2
       bra   restart_same_level;


start_next_mine_level:
       jsr   bring_ship_to_center;
       ldy   #$C8C4;   * Increment the pointer into the struct
       lda   <$9B;      * describing which mines are at which
       ldx   a,y;       * level, for the active player.
       leax  4,x;
       stx   a,y;

       ldx   #mine_field_level_pointers;
       lda   <$9B;          * Check the mine field level for
       ldx   a,x;           * the active player, and if it is
       lda   5,x;           * a multiple of 4, then award that
       anda  #$03;         * player a bonus ship.
       bne   goto_next_mine_level;
       inc   <$D9;

goto_next_mine_level:
       ldd   #$0001;             * Increment active players mine
       jsr   add_d_to_x_in_bcd;  * field level indicator.
restart_same_level:
       jsr   init_RAM_for_new_level;
       ldx   #$C8C4;       * Use the pointer in C8C4 (player 1)
       lda   <$9B;          * or C8C6 (player 2) to determine
       ldx   a,x;           * which mines are at this level.
       lda   ,x;
       bmi   check_4_end_of_game;* After level 13, skip any level whose
       jsr   seed_the_screen;   * first byte is negative.
       bra   main_loop;

check_4_end_of_game:
       ldd   <$F0;          * If C8F0 counts down to 0, then
       subd  #$0001;       * start a new game; used as a delay
       std   <$F0;          * after a game is over.
       beq   start_a_new_game;

* Display 'game over' string, & both scores
       pshs  dp;
       jsr   dptoD0;
       jsr   display_both_scores;
       ldu   #game_over;
       jsr   MS_print_1_string7F;
       puls  dp;

       lda   <$0F;         * If no buttons pressed, then see if
       beq   main_loop;    * we should goto advanced levels.

*
* Find out if a new hi score is available,
* and then start up a new game.

start_a_new_game:
       ldx   #$C8A8;       * See if player 1 has new hi score
       ldu   #$CBEB;
       jsr   check_4_new_hi_score;
       ldx   #$C8AF;       * See if player 2 has new hi score
       ldu   #$CBEB;
       jsr   check_4_new_hi_score;
       ldd   <$F0;
       lbne  restart_game;  * Just start a new game
       jsr   reinit;
       clr   <$3B;          * Flag that a hi score should be displayed
       lds   #$CBEA;
       jmp   powerup_loop; * Go thru a complete reset sequence

*
* This is the main loop during a players turn.  Control will
* remain in this loop, until either a player clears a level,
* or has his ship destroyed.

main_loop:
       pshs  dp;
       jsr   process_indirect_jumps;
       jsr   draw_non_dead_mines;
       jsr   process_jstick_and_buttons;
       jsr   process_bullets;
       jsr   reseed_screen;
       puls  dp;
       jsr   check_bullets_for_hits;
       jsr   check_ship_4_mine_collision;
       jsr   check_ship_4_enemy_collision;
       jsr   display_explosion_pattern;
       blo   main_loop;
       lda   <$BD;          * See if cmd ship is disabled
       lbeq  start_next_mine_level;
       lda   <$BE;          * See if the game is over
       lbne  check_4_end_of_game;
       jmp   restart_same_level;


*
* This block of code is responsible for seeding the screen
* at the beginning of play.  It will draw the enemy ship
* as it moves from the top of the screen to the bottom.
* After the field has been completely seeded, the mine
* field number will be displayed.
* I think that the x register, at entry, points to a
* structure describing the types of mines for this level.

seed_the_screen:
       stx   <$C2;          * Save pointer to mine info
       ldd   #$7F00;
       std   <$DC;          * C8DC contains enemy ship coords
       sta   <$B7;          * C8B7 is used as loop cntr ($7F)
       lda   #$20;
       sta   <$9C;                  * Set up 1 of the indirect
       ldx   #generate_mine_coords; * jump ptrs, to generate some
       stx   <$9D;                  * mine coordinates.
       ldx   #$C933;       * Load mine buf addr into C8B9-C8BA
       stx   <$B9;
       lda   #$1D;         * Load # of mines into C8B8
       sta   <$B8;
       clr   <$56;
       ldu   #MS_music;
       jsr   init_sound2;
continue_seeding_screen:
       pshs  dp;
       jsr   PE711;        * Draw active players ship count
       jsr   init_sound;
       lda   <$26;          * Decrement our loop counter, C8B7
       bita  #$01;         * every other pass.
       bne   PE15C;
       dec   <$B7;
PE15C: jsr   process_indirect_jumps;

* This block draws the enemy ship
       jsr   display_both_scores;
       jsr   do_sound;
       jsr   draw_non_dead_mines;
       jsr   intensity_to_5F;
       ldb   $C8B7;            * Wait until screen is seeded,
       beq   activate_4_mines; * then activate 1st 4 mines.
       ldx   #enemy_ship_pt1;
       ldy   $C8DC;
       jsr   move_y_draw_x;   * Draw the enemy ship
       ldx   #enemy_ship_pt2;
       jsr   move_y_draw_x;
       ldx   #enemy_ship_pt3;
       jsr   move_y_draw_x;
       puls  dp;
       dec   <$DC;             * Decrement y coord for enemy ship
       bra   continue_seeding_screen;

*
* This routine is called at the beginning of a turn for the
* active player.  It will activate the first 4 mines for
* the level.  The type of mines activated are controlled
* by the array whose pointer is contained in C8C2.

activate_4_mines:
       puls  dp;
       clr   <$9C;
       lda   #$04;         * Use C8B7 as a loop counter
       sta   <$B7;          * Use C8B8 as a delay counter; when it
       lda   #$7F;         * = 0, stop displaying the mine field
       sta   <$B8;          * level, and activate 1st 4 mine.
PE198: lda   <$B7;
       beq   PE1E6;         * Exit when loop counter = 0
       ldb   <$B8;
       beq   PE1A4;      * Don't activate the mines until the
       dec   <$B8;       * counter in C8B8 = 0; this allows the
       bra   PE1B6;      * mine field level to stay displayed awhile
PE1A4: ldb   <$26;
       andb  #$1F;         * After every 31 times thru waitrecal(),
       bne   PE1B6;         * activate another mine.
       deca;
       sta   <$B7;          * Decrement loop counter
       ldx   <$C2;
       lda   a,x;           * Determine what type mine this should be
       ldb   #$03;         * Set generation number to 'largest'.
       jsr   activate_a_mine;
PE1B6: pshs  dp;
       jsr   process_indirect_jumps;

* Tell user what mine field number this is
       jsr   intensity_to_7F;
       ldu   #mine_field;
       jsr   MS_print_1_string7F;
       ldy   #$E0F8;
       ldu   #mine_field_level_pointers;
       lda   $C89B;
       ldu   a,u;
       jsr   move_y_print_string;

       jsr   draw_non_dead_mines;
       jsr   process_jstick_and_buttons;
       jsr   process_bullets;
       puls  dp;
       jsr   check_bullets_for_hits;
       jsr   display_explosion_pattern;
       bra   PE198;
PE1E6: rts;


*
* This block of code generates random coordinates
* for a single mine.  C8B9 contains a pointer to
* the appropriate entry in the mine structure.
* Before exiting, this routine will update the
* pointer in C8B9 to point to the next entry.

generate_mine_coords:
       dec   <$B8;          * Decrement the mine counter (C8B8)
       beq   PE239;         * and exit when it equals 0.
       inc   <$ED;          * Inc mine dot counter
       jsr   get_random_a;
       anda  #$07;         * Reset the ind jump counter, to
       adda  #$04;         * generate the next set of mine
       sta   <$9C;          * coordinates.
       ldu   <$B9;          * Load u register w/ mine structure ptr
       lda   #$80;         * Flag that a mine is in this slot
       sta   ,u;            * Get the coordinates of enemy ship
       ldd   <$DC;
       adda  #$08;
       sta   4,u;           * Save y coordinate in 4th slot
       clr   5,u;
       stb   6,u;           * Save x coordinate in 6th slot
       clr   7,u;
generate_final_x_for_mine:
       jsr   get_random_a; * Generate the final x position for
       tsta;                * this mine.
       bmi   PE21A;
       cmpa  #$10;
       bge   PE214;
       adda  #$0C;
PE214: cmpa  #$60;
       ble   PE226;
       bra   generate_final_x_for_mine;
PE21A: cmpa  #$F0;
       ble   PE220;
       suba  #$0C;
PE220: cmpa  #$A0;
       bge   PE226;
       bra   generate_final_x_for_mine;

PE226: sta   $11,u;
       tfr   a,b;           * Determine what the delta movement
       sex;                 * value will be for this mine: -1 or 1
       ora   #$01;
       sta   $10,u;
       clr   2,u;           * Start with a scale factor of 0
       leay  $12,u;        * Update C8B9 to point to next entry
       sty   <$B9;
PE239: rts;

final_mine_scale_factor:
       DB    $00;
       DB    $02;          * Small
       DB    $07;          * Medium
       DB    $10;          * Large

mine_velocity:
       DB    $00;
       DB    $20;          * Small
       DB    $18;          * Medium
       DB    $10;          * Large

mine_values:
       DB    $01;          * dumb mine = BCD 100
       DB    $00;
       DB    $05;          * magnetic mine = BCD 500
       DB    $00;
       DB    $03;          * fireball mine = BCD 325
       DB    $25;
       DB    $07;          * magnetic fireball mine = BCD 750
       DB    $50;

extra_mine_value:
       DB    $00;
       DB    $00;
       DB    $01;          * Small (100)
       DB    $00;
       DB    $00;          * Medium (35)
       DB    $35;
       DB    $00;          * Large (0)
       DB    $00;

mine_sizes:
       DB    $00;
       DB    $00;
       DB    $04;          * Small
       DB    $04;
       DB    $08;          * Medium
       DB    $08;
       DB    $0D;          * Large
       DB    $0D;

* Table of pointers to mine vectors
mine_vector_ptrs:
       DW    dumb_mine;
       DW    magnetic_mine;
       DW    fireball_mine;
       DW    magnetic_fireball_mine;


*
* This block of code processe the hyperspace and move
* buttons.  It also checks the state of the joystick,
* and updates the command ship rotation value, kept
* in C8D4, if the joystick is not centered.  If the
* joystick is left, then the rotation value is
* incremented; if it is to the right, then the rotation
* value is decremented.  After updating the rotation
* value, the command ship will be redrawn at its
* current position (specified in C8C8-C8C9).

process_jstick_and_buttons:
       pshs  dp;
       lda   #$C8;
       tfr   a,dp;
       lda   <$BD;          * Skip if cmd ship disabled
       lbne  PE30A;
       lda   <$EE;          * Continue hyperspace, if active
       lbne  continue_hyperspace;
       lda   <$13;          * Check the hyperspace button (2)
       lbne  hyperspace;
       lda   <$14;          * Check the move button (3)
       beq   no_ship_movement;

*
* The following block of code takes care of
* generating the new command coordinates,
* because it is moving.  It attempts to make
* all turns into smooth motion.

       lda   <$D4;
       cmpa  <$D6;
       beq   PE2A0;
       cmpa  <$D8;
       beq   PE290;
       lda   <$D5;
       beq   PE2A0;
       lda   <$D7;
       bne   no_ship_movement;
PE290: lda   <$D7;
       adda  #$0C;
       cmpa  #$7F;
       bhi   no_ship_movement;
       sta   <$D7;
       lda   <$D4;
       sta   <$D8;
       bra   PE2AE;
PE2A0: lda   <$D5;
       adda  #$0C;
       cmpa  #$7F;
       bhi   no_ship_movement;
       sta   <$D5;
       lda   <$D4;
       sta   <$D6;
PE2AE: inc   <$F2;          * Flag that a sound should be made

no_ship_movement:
       lda   <$D5;
       beq   PE2C2;
       suba  #$02;
       sta   <$D5;
       ldb   <$D6;
       jsr   calc_rise_run1;
       sty   <$CC;
       stx   <$CE;
PE2C2: lda   <$D7;
       beq   PE2D4;
       suba  #$02;
       sta   <$D7;
       ldb   <$D8;
       jsr   calc_rise_run1;* Generate new rise & run
       sty   <$D0;
       stx   <$D2;
PE2D4: ldd   <$C8;          * Update cmd ships y coord
       addd  <$CC;
       addd  <$D0;
       std   <$C8;
       ldd   <$CA;          * Update cmd ships x coord
       addd  <$CE;
       addd  <$D2;
       std   <$CA;

* Check joystick state (in C81B)
       lda   <$1B;
       beq   draw_cmd_ship1;* Joystick is centered
       bmi   PE2EE;
       dec   <$D4;          * Joystick to right
       bra   draw_cmd_ship2;
PE2EE: inc   <$D4;          * Joystick to left
       bra   draw_cmd_ship2;
PE2F2: pshs  dp;

*
* draw_cmd_ship2() runs the command ships coordinates
* thru a rotation transformation, and then draws the
* command ship using the transforms coordinates.
* draw_cmd_ship1() draws the command ship using the
* current transformed ship coordinates.

draw_cmd_ship2:
       jsr   rotate_cmd_ship;* Rotate the command ship
draw_cmd_ship1:
       lda   #$D0;
       tfr   a,dp;
       jsr   intensity_to_5F;
       ldb   #$0C;
       ldy   #$C8C8;       * Draw the xformed command ship
       ldx   #$CB89;
       jsr   move_y_draw_x2;
PE30A: puls  dp,pc;


* This routine handles the hyperspace request
hyperspace:
       lda   #$80;
       sta   <$EE;
       jsr   get_random_a;
       anda  #$03;
       adda  #$03;
       sta   <$EF;
       inc   <$F6;
continue_hyperspace:
       lda   <$EE;
       bpl   process_hyperspace_dots;
       dec   <$EF;
       beq   PE330;
       jsr   MS_get_2_random_nums;
       sta   <$C8;
       clr   <$C9;          * Generate new coordinates
       stb   <$CA;          * for the command ship.
       clr   <$CB;
       puls  dp,pc;
PE330: lsr   <$EE;
       lda   #$1F;
       sta   <$EF;
       puls  dp,pc;


*
* This code draws the ever decreasing hyperspace dots
* during an active hyperspace.  The scale factor for
* the hyperspace dots, stored in C8EF, is decremented,
* and when it finally reaches a minimum value, the
* hyperspace is complete.

process_hyperspace_dots:
       ldb   <$EF;          * See if scale factor has reached
       cmpb  #$E0;         * the limit.
       ble   hyperspace_complete;
       lda   <$EF;
       suba  #$04;         * Decrement the scale factor
       sta   <$EF;
       clra;
       jsr   draw_hyperspace_motion_dots;
       puls  dp,pc;

hyperspace_complete:
       clr   <$EF;
       clr   <$EE;
       jsr   clear_cmd_ship_xformation;
       puls  dp,pc;


*
* After the player has cleared all but the small mines
* from a layer, the enemy ship will again appear, and
* attempt to reseed the screen.  This code checks to
* see if the enemy ship is visible (C8E7), and if it
* is, then it generates new coordinates for it, and
* then moves it.

reseed_screen:
       lda   $C8E7;
       beq   PE383;         * Do only if ship is visible
       pshs  dp;
       lda   #$C8;
       tfr   a,dp;
       lda   <$E7;
       beq   PE383;
       ldd   <$DE;
       addd  <$E2;
       std   <$DE;
       sta   <$DC;          * New y coordinate
       ldd   <$E0;
       addd  <$E4;
       std   <$E0;
       sta   <$DD;          * New x coordinate
       puls  dp;
       jsr   intensity_to_5F;
       ldb   #$08;
       ldy   $C8DC;
       ldx   #simple_enemy_ship;
       jsr   move_y_draw_x; * Draw the enemy ship
PE383: rts;


*
* This procedure is invoked only through the indirect jump
* pointers.  After only small mines are left, this routine
* will eventually be called.  It will determine which way
* the enemy ship will move, and will also set up another
* indirect jump to the routine which does the actual
* reseeding of the screen.

ind_init_screen_reseeding:
       ldx   #ind_reseed_screen;
       stx   <$A3;          * Set up next indirect jump ptr
       jsr   get_random_a;
       ldx   #$E448;       * Determine where enemy ship will move
       anda  #$06;
       ldx   a,x;
       ldd   ,x++;
       std   <$DC;          * Save enemy ships new coordinates
       sta   <$DE;
       clr   <$DF;
       stb   <$E0;
       clr   <$E1;
       bra   PE3F9;


*
* This routine is invoked only through the indirect jump
* mechanism.  It will continue to be called, until either
* the enemy ship is destroyed, or until the screen has
* been reseeded.  It will reseed upto 7 new mines.

ind_reseed_screen:
       lda   <$BF;          * See if all mines have been seeded
       bne   PE3BE;
PE3A5: jsr   get_random_a;
       anda  #$7F;
       adda  #$30;         * Set up the indirect jump counter 4
       sta   <$A2;          * the next pass.
       jsr   get_random_a;
       anda  #$3F;
       sta   <$E6;
       jsr   get_random_a;
       adda  #$10;
       sta   <$E7;
       bra   PE407;
PE3BE: lda   <$BD;
       bne   PE3A5;

*
* Load the b register with the number of mines (28),
* and load the u register with the pointer to the
* mine structure.  Then look through the mine structure
* for an available slot, and fill it with the newly
* seeded mine.

       ldb   #$1C;
       ldu   #$C933;
PE3C7: lda   ,u;            * Look for an unused mine
       beq   found_avail_mine;
       leau  $12,u;
       decb;
       bne   PE3C7;
       bra   PE407;

found_avail_mine:
       inc   <$ED;          * Incr the # of mines which R dots
       dec   <$BF;          * Decrement the reseed counter
       ldx   <$DE;
       stx   4,u;           * Set y coordinate for mine
       ldx   <$E0;
       stx   6,u;           * Set x coordinate for mine
       lda   #$40;
       sta   ,u;            * Flag that mine is a stationary dot.
       lda   <$C0;          * See if this is 1st mine activated.
       bne   PE3F7;
       ldx   #ind_start_large_mine;
       stx   <$9D;                 * Set things up to eventually
       jsr   get_random_a;        * activate 1 large mine.
       anda  #$7F;
       adda  #$40;
       sta   <$9C;
       inc   <$C0;          * Flag that 1st mine has been activated
PE3F7: ldx   <$E8;
PE3F9: lda   ,x+;
       sta   <$A2;
       lda   ,x+;
       sta   <$E6;
       lda   ,x+;
       sta   <$E7;
       stx   <$E8;
PE407: ldb   <$E6;
       jsr   calc_rise_run1;* Generate rise & run for mine
       sty   <$E2;
       stx   <$E4;
       rts;

*
* This routine is called only thru the indirect jump
* handler.  It is responsible for activating a single
* large mine.  The type of mine is indicated by the
* first entry in the table of mines for this level.

ind_start_large_mine:
       ldu   #$C8C4;
       lda   <$9B;
       ldu   a,u;
       lda   ,u;            * Determine the type of mine
       ldb   #$03;         * Set generation to 'largest'
       jsr   activate_a_mine;
       ldx   #ind_activate_rangen_mine;
       stx   <$9D;
       rts;

*
* This routine decrements the counter in C8C1, and if
* it equal 0, then it activates a mine with a random
* generation number; else, it sets the indirect counter
* in C89C to -1, and returns.  This routine is called
* only thru the indirect jump handler.

ind_activate_rangen_mine:
       dec   <$C1;
       beq   PE430;
       lda   #$FF;
       sta   <$9C;
       bra   PE447;
PE430: jsr   get_random_a;
       tfr   a,b;
       andb  #$03;
       bne   PE43B;
       addb  #$01;
PE43B: ldu   #$C8C4;
       lda   <$9B;
       ldu   a,u;
       lda   ,u;
       jsr   activate_a_mine;
PE447: rts;


* Some sort of pointer table
SE448: DW    SE450;
       DW    SE46A;
       DW    SE484;
       DW    SE49E;

SE450: DB    $7F;
       DB    $00;
       DB    $28;
       DB    $20;
       DB    $30;
       DB    $40;
       DB    $28;
       DB    $30;
       DB    $28;
       DB    $00;
       DB    $10;
       DB    $30;
       DB    $10;
       DB    $40;
       DB    $18;
       DB    $20;
       DB    $50;
       DB    $40;
       DB    $30;
       DB    $28;
       DB    $30;
       DB    $08;
       DB    $60;
       DB    $7F;
       DB    $38;
       DB    $70;

SE46A: DB    $80;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $30;
       DB    $20;
       DB    $10;
       DB    $50;
       DB    $20;
       DB    $28;
       DB    $40;
       DB    $30;
       DB    $3E;
       DB    $70;
       DB    $18;
       DB    $30;
       DB    $60;
       DB    $20;
       DB    $18;
       DB    $40;
       DB    $30;
       DB    $24;
       DB    $50;
       DB    $7F;
       DB    $06;
       DB    $70;

SE484: DB    $00;
       DB    $7F;
       DB    $40;
       DB    $10;
       DB    $60;
       DB    $28;
       DB    $38;
       DB    $30;
       DB    $28;
       DB    $08;
       DB    $40;
       DB    $30;
       DB    $28;
       DB    $7F;
       DB    $20;
       DB    $18;
       DB    $30;
       DB    $30;
       DB    $08;
       DB    $68;
       DB    $40;
       DB    $20;
       DB    $50;
       DB    $7F;
       DB    $38;
       DB    $70;

SE49E: DB    $00;
       DB    $80;
       DB    $40;
       DB    $30;
       DB    $60;
       DB    $38;
       DB    $18;
       DB    $30;
       DB    $30;
       DB    $20;
       DB    $18;
       DB    $20;
       DB    $38;
       DB    $40;
       DB    $28;
       DB    $10;
       DB    $60;
       DB    $20;
       DB    $00;
       DB    $30;
       DB    $40;
       DB    $38;
       DB    $50;
       DB    $7F;
       DB    $1C;
       DB    $70;


*
* This routine is responsible for displaying any active
* bullets, and also for firing new bullets, when an
* available spot in the bullet structure becomes available.
* The maximum number of active bullets is 4.  The 40 byte
* bullet structure starts at C90B.  A bullet will remain
* 'active' for at most $18 passes thru this routine.

process_bullets:
       lda   #$04;         * Loop counter = 4
       ldu   #$C90B;       * Bullet buffer
       ldx   #$C815;       * State of fire button (4)
       sta   $C88F;
       jsr   intensity_to_7F;
next_bullet:
       lda   ,u;               * If the current spot is empty, then
       beq   check_fire_button;* see if a new bullet should be fired
       dec   9,u;           * Decrement the cycle counter for the
       beq   erase_bullet;  * and erase bullet if it = 0.
       ldd   5,u;
       addd  1,u;   * y
       std   5,u;           * Increment bullet coordinates
       ldd   7,u;
       addd  3,u;   * x
       std   7,u;
       leay  5,u;
       jsr   draw_dot7F_ptr_in_y;    * Draw bullet
update_bufr_ptr:
       leau  10,u;
       dec   $C88F;         * Point to next entry
       bne   next_bullet;
       rts;

erase_bullet:
       clr   ,u;
       dec   $C8EA;         * Decrement active bullet counter
check_fire_button:
       lda   $C8BD;
       bne   update_bufr_ptr;
       lda   $C8EE;
       bne   update_bufr_ptr;
       lda   ,x;            * Check the 'fire' button state
       beq   update_bufr_ptr;

*
* This code 'fires' a new bullet, and fills the
* available spot in the bullet structure.

       clr   ,x;
       inc   $C8B6;         * Flag that a bullet sound should be made
       inc   ,u;
       ldd   $C8C8;         * Get ships coordinates
       std   5,u;
       ldd   $C8CA;
       std   7,u;
       ldd   $C907;         * Get ship rise
       std   1,u;
       ldd   $C909;         * Get ship run
       std   3,u;
       lda   #$18;         * # of passes before bullet expires
       sta   9,u;
       inc   $C8EA;         * Increment active bullet counter
       bra   update_bufr_ptr;


*
* This procedure processes each mine which has not been
* destroyed.  If the mine is a moving dot, then its position
* is updated; if the mine is a dot, then it is draw in its
* appropriate place; if the mine is active, then the appropriate
* mine is drawn; if it is a fireball, then the fireball is drawn.
* The state of the mine is determined by the first byte in the
* mine structure.  The following values are valid:
*
*      $00 - Mine is dead.
*      $01 - Mine is in process of being destroyed.
*      $08 - Mine is visible and moving.
*      $10 - Mine is visible, but not moving.
*      $20 - Mine is just becoming visible.
*      $40 - Mine is a stationary dot.
*      $80 - Mine is still moving to final resting place.
*

draw_non_dead_mines:
       lda   #$1C;
       sta   $C88F;         * Use C88F as a loop counter
       ldu   #$C933;       * Put mine pointer into u register
PE526: lda   ,u;
       bne   non_dead_mine;
update_mine_ptr:
       leau  $12,u;
       dec   $C88F;
       bne   PE526;
       rts;

non_dead_mine:
       lbmi  move_mine_dot;
       bita  #$40;
       lbne  draw_mine_as_dot;
       bita  #$20;
       lbne  mine_becoming_visible;
       bita  #$10;
       lbne  delay_B4_moving_mine;
       bita  #$01;
       lbne  process_destroyed_mine;
       lda   1,u;
       cmpa  #$04;         * See if this is a fireball
       beq   process_fireball;
       bita  #$01;         * Code below moves visible mine
       beq   non_magnetic_mine;
       lda   $C8EE;         * Skip below if hyperspace active
       bne   non_magnetic_mine;
       lda   $C8BD;         * Skip below if cmd ship disabled
       bne   non_magnetic_mine;
       pshs  dp;
       jsr   dptoC8;
       lda   <$C8;          * Draw the mine towards the cmd ship
       suba  4,u;
       ldb   <$CA;
       subb  6,u;
       jsr   $F593;
       suba  #$10;
       sta   <$83;
       ldx   #mine_velocity;
       ldb   3,u;
       lda   b,x;
       ldb   <$83;
       jsr   calc_rise_run1;* Calculate new rise and run values
       sty   8,u;
       stx   10,u;
       puls  dp;
non_magnetic_mine:
       ldd   4,u;           * This block update mine coordinates
       addd  8,u;
       std   4,u;
       ldd   6,u;
       addd  10,u;
       std   6,u;

*
* This block of code draws a mine, using information in
* the mine structure element pointed to by the u register.

draw_a_visible_mine:
       jsr   intensity_to_5F;
       ldx   #mine_vector_ptrs;
       lda   1,u;           * byte 1 = mine type
       asla;
       ldx   a,x;           * Set x = ptr to mine vector list
       leay  4,u;           * Set y = mine coordinates.
       ldb   2,u;           * Set b = scale factor.
       jsr   move_y_draw_x2;
       jmp   update_mine_ptr;

*
* This routine appears to be processing a fireball.
* It checks to see if the fireball has reached the
* edge of the display, and if it has, then the
* fireball is removed; else, the fireball is drawn
* on the display.

process_fireball:
       ldd   4,u;           * See if the fireball has
       addd  8,u;           * reached the edge of the
       bvs   remove_fireball; * display.
       std   4,u;
       ldd   6,u;
       addd  10,u;
       bvs   remove_fireball;
       std   6,u;
       jsr   intensity_to_7F;
       leay  4,u;           * Draw the fireball
       ldx   #$CBA7;
       ldb   #$04;
       jsr   move_y_draw_x2;
       jmp   update_mine_ptr;

remove_fireball:
       clr   ,u;            * Flag that the fireball has
       dec   $C8EB;         * been removed.
       jmp   update_mine_ptr;


*
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

move_mine_dot:
       lda   6,u;             * Update the mines x coordinate,
       adda  $10,u;          * and check to see if it has reached
       sta   6,u;             * its final resting place.
       cmpa  $11,u;
       bne   draw_mine_as_dot;* Flag that the mine dot is at its
       lsr   ,u;              * final resting place.
draw_mine_as_dot:
       jsr   intensity_to_5F;
       leay  4,u;
       jsr   draw_dot7F_ptr_in_y;
       jmp   update_mine_ptr;


*
* This procedure is called when a mine first becomes visible.
* If the mine is not a large mine, then the mine is drawn at
* full scale factor; otherwise, if the mine is a large mine,
* then it will be drawn with a steadily increasing scale factor.
* This gives the effect of the mine 'popping' up.

mine_becoming_visible:
       lda   3,u;
       cmpa  #$03;         * See if this is a large mine
       bne   use_max_scale_factor;
       lda   2,u;
       cmpa  $10,u;
       bge   use_max_scale_factor;
       adda  #$08;
       sta   2,u;           * Increment the scale factor
       bra   PE61A;
use_max_scale_factor:
       lsr   ,u;            * Flag that mine is full size & visible
       lda   $10,u;
       sta   2,u;           * Set final scale factor
       lda   #$18;
       sta   $10,u;        * Set up a delay
       lda   $C8ED;
       bne   PE61A;         * Check to see if any more mine dots left
       lda   $C8C0;
       bne   PE61A;         * See if re-seeding already in progress.
       lda   #$7F;         * Set up indirect counter for reseeding
       sta   $C8A2;         * since only small mines are left.
PE61A: jmp   draw_a_visible_mine;


*
* This procedure is used to delay the movement of a mine
* right after it become visible.  After the delay is over,
* the mine will start moving.

delay_B4_moving_mine:
       dec   $10,u;        * Decrement delay counter
       bne   PE624;
       lsr   ,u;
PE624: jmp   draw_a_visible_mine;


*
* This procedure processes the activation of 2 new mines
* after a mine has been destroyed.  If the destroyed mine
* was a small mine, or a fireball, then 2 new mines will
* not be activated.  At entry time, the 'a' register must
* contain the type of mine to be started up.

process_destroyed_mine:
       clr   ,u;            * Flag that this mine is gone
       lda   1,u;
       cmpa  #$04;         * If this was a fireball, then don't
       beq   PE644;         * start up 2 new mines.
       ldb   3,u;
       decb;                * If this was a small mine, then don't
       beq   PE644;         * start up 2 new mines.
       pshs  a,dp;
       lda   #$C8;
       tfr   a,dp;
       lda   ,s;            * Get the type of mine
       jsr   activate_a_mine;
       jsr   activate_a_mine;
       puls  a,dp;
PE644: jmp   update_mine_ptr;


*
* This routine is responsible for displaying the explosion
* pattern for all active explosions.  If the command ship
* is sexploding, then it will also switch over to the
* next player (eventually).

display_explosion_pattern:
       pshs  dp;
       jsr   dptoD0;
       jsr   intensity_to_7F;
       ldu   #$CB2B;       * Get pointer to the explosion struct
       lda   #$0E;
       sta   $C88F;         * Use C88F as a loop counter
check_next_explosion:
       lda   ,u;
       lbeq  inc_expl_ptr;
       ldb   4,u;           * If the scale factor for the explosion
       cmpb  1,u;           * has not surpassed the max value, then
       bhs   chk_4_cmd_ship_explosion;   * increment it.
       addb  #$03;
       stb   4,u;
       ldy   2,u;
       ldx   #explosion;    * Draw the explosion pattern
       jsr   move_y_draw_x;

chk_4_cmd_ship_explosion:
       tsta;                * This is a cmd ship explosion if bit
       lbpl  check_4_expired_explosion;* $80 is set.
       dec   $C8F7;         * Stop displaying explosion when C8F7
       lbeq  dead_ship;     * reaches zero.
       lda   $C826;
       anda  #$01;             * Every other pass through the loop,
       bne   draw_expl_cmd_ship;* increment the scale factor used to
       inc   $C8F8;             * draw the destroyed command ship.

draw_expl_cmd_ship:
       lda   $C8F8;         * Draw the cmd ship in pieces.
       ldy   #$7F00;
       ldx   #cmd_ship_pt1;
       jsr   draw_cmd_ship_fragment;
       ldy   #$6080;
       ldx   #cmd_ship_pt2;
       jsr   draw_cmd_ship_fragment;
       ldy   #$8050;
       ldx   #cmd_ship_pt3;
       jsr   draw_cmd_ship_fragment;
       ldy   #$A080;
       ldx   #cmd_ship_pt4;
       jsr   draw_cmd_ship_fragment;
       bra   inc_expl_ptr;

*
* This routine is called after a ship has been destroyed.
* The number of ships for the active player, kept in C8D9,
* will be decremented.  If more than one player is playing,
* then save the active players ship count in a memory
* location (C8DA for player 1, and C8DB for player 2),
* and then determine who's turn it now is.

dead_ship:
       dec   $C8D9;         * Decrement the number of ships
       clr   $C8EB;
       clr   $C8ED;

       lda   $C879;           * If more than 1 player is playing,
       beq   check_ship_count;* then save the active players ship
       lda   $C89B;           * ship count in RAM.
       lsra;
       ldx   #$C8DA;
       ldb   $C8D9;
       stb   a,x;

       lda   $C8DA;         * See who's turn it is.  Skip a player
       bne   next_player;   * if he has no more ships.
       lda   $C8DB;
       beq   flag_no_ships_left;

next_player:
       lda   $C89B;         * Increment active player indicator
       adda  #$02;
       anda  #$02;
       sta   $C89B;

       lsra;                * Load the ship count for new player
       ldx   #$C8DA;
       ldb   a,x;
       stb   $C8D9;
       beq   next_player;

*
* This routine checks to see if the active player has any ships
* left, after the command ship has exploded.

check_ship_count:
       lda   $C8D9;
       bne   explosion_expired;
flag_no_ships_left:
       lda   #$01;
       sta   $C8BE;         * Set C8BE when no ships left
       bra   explosion_expired;

*
* This routine checks to see if the explosion has expired.
* An explosion expires when its scale factor surpasses a
* preset maximum value.

check_4_expired_explosion:
       ldb   4,u;           * See if scale factor has reached
       cmpb  1,u;           * the maximum value allowed.
       blo   inc_expl_ptr;
explosion_expired:
       clr   ,u;
       dec   $C8EC;         * Flag completion of cmd ship explosion

inc_expl_ptr:
       leau  5,u;
       dec   $C88F;
       lbne  check_next_explosion;
       jsr   make_misc_sounds;
       bra   draw_tiny_ship;

* Draw the tiny ships in lower righthand corner
PE711: pshs  dp;
       jsr   dptoD0;
draw_tiny_ship:
       jsr   intensity_to_5F;
       ldx   #$8038;
       stx   $C890;                  * Position for first ship
       lda   $C8D9;                  * Don't bother, if the active
       beq   rotate_fireball_vectors;* player has no ships left.
       sta   $C88F;
PE727: dec   $C88F;
       beq   rotate_fireball_vectors;* Exit when all ships drawn
       lda   $C891;
       adda  #$06;         * Increment x coordinate
       sta   $C891;
       ldb   #$04;
       ldy   $C890;
       ldx   #command_ship;
       jsr   move_y_draw_x;* Draw the tiny command ship
       bra   PE727;

*
* This routine rotates the fireball vector list.  Also,
* it checks to see whether this level has been cleared.

rotate_fireball_vectors:
       puls  dp;
       lda   <$26;
       anda  #$01;
       asla;
       asla;
       asla;
       ldx   #fireball;
       ldu   #$CBA7;
       jsr   rotate_vector_list1;

*
* This block of code determines whether or not the main
* loop should be exited.  If the cmd ship is disabled, or
* if the player has cleared the level, then the main loop
* will be exited (this is flagged by clearing the carry bit.

       ldb   <$EC;          * See if cmd ship is being exploded
       bne   PE767;
       lda   <$BD;          * See if cmd ship is disabled
       bne   PE764;
       ldb   <$EB;          * check # of active mines
       bne   PE767;
       ldb   <$ED;          * check # of dot mines
       bne   PE767;
PE764: andcc #$FE;         * Says 'exit main loop'
       rts;
PE767: orcc  #$01;         * Says 'do not exit main loop'
       rts;


*
* This routine is responsible for drawing a single fragment
* of the exploding command ship.  At entry, 'a' = scale factor,
* 'y' = pen position, and 'x' = ptr to vector list.

draw_cmd_ship_fragment:
       pshs  a,x,y;
       ldx   #$C8C8;       * Move pen to cmd ships location
       jsr   move_pen7F_no_inc;
       lda   ,s;
       sta   <$04;          * Set scale factor = a register
       tfr   y,d;
       jsr   move_pen_d;   * Move pen to position in y register
       ldb   #$0C;
       ldx   1,s;
       jsr   drawl1b;      * Draw vector list pointed to by x reg
       puls  a,x,y,pc;


*
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

add_an_explosion:
       pshs  a,b,x;
       ldx   #$CB2B;
       lda   #$0E;
PE78B: ldb   ,x;            * Find an empty spot in structure
       beq   found_empty_exp_slot;
       leax  5,x;
       deca;
       bne   PE78B;
       bra   PE7B3;

found_empty_exp_slot:
       lda   ,s;            * Save the explosion type
       anda  #$80;
       inca;
       sta   ,x;            * See if this is a cmd ship explosion
       bpl   PE7A1;
       inc   <$BD;          * Flag that cmd ship is disabled
PE7A1: lda   ,s;
       anda  #$7F;
       sta   4,x;           * Save starting scale factor
       lda   1,s;
       sta   1,x;
       ldd   2,s;
       std   2,x;           * Save maximum scale factor
       inc   <$EC;          * Flag that cmd ship is exploding
       inc   <$F3;          * Flag that explosion sound should be made
PE7B3: puls  a,b,x,pc;


*
* This routine is responsible for calculating a rise and run
* for an object whose angle of travel is in the 'b' register,
* and whose velocity is in the 'a' register.
* The rise is returned in the 'y' register, and the run is
* returned in the 'x' register.

calc_rise_run1:
       pshs  a,b,x,y;
       jsr   convert_angle_to_rise_run;rotate_1_coordinate;
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


*
* This routine also calculates some sort of rise & run pair.
* The same parameters are expected at entry time, and the
* values are returned in the same registers.

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


*
* This routine is called each time a new mine level is
* started.  It initializes everything necessary.

init_RAM_for_new_level:
       lda   #$D0;
       tfr   a,dp;
       jsr   clear_sound_chip;
       lda   #$C8;
       tfr   a,dp;
       clr   <$9C;          * Clear all 4 indirect jump counters
       clr   <$9F;
       clr   <$A2;
       clr   <$A5;
       ldx   #$C90B;       * Clear C90B - CB71
PE7FA: clr   ,x+;
       cmpx  #$CB71;
       bne   PE7FA;
       ldd   #$0000;
       std   <$DE;
       std   <$E0;
       std   <$E2;
       std   <$E4;
       sta   <$E7;
       sta   <$BD;          * Clear cmd ship disabled flag
       sta   <$BE;          * Clear 'no more ships' flag
       sta   <$EA;          * Clear active bullet counter
       sta   <$EB;
       sta   <$EC;          * Clear cmd ship exploding flag
       sta   <$F8;          * Clear destroyed cmd ship scale factor
       ldb   #$40;
       stb   <$F7;          * Init cmd ship exploding loop counter
       sta   <$ED;          * Clear # of dot mines
       sta   <$C0;          * Clear mine activated during reseeding flag
       ldx   #$0800;
       stx   <$F0;          * Set end of game loop counter
       lda   #$07;
       sta   <$BF;          * Init # of mines to be reseeded
       ldx   #ind_init_screen_reseeding;
       stx   <$A3;          * Init indirect jump location for reseeding
       ldd   #$0000;
       std   <$C8;          * Clear the command ship's
       std   <$CA;          * position indicators.

clear_cmd_ship_xformation:
       ldd   #$0000;
       sta   <$D4;          * Clear rotation counter
       std   <$CC;
       std   <$CE;
       sta   <$D5;          * Clear cmd ships velocity
       sta   <$D6;
       std   <$D0;
       std   <$D2;
       sta   <$D7;
       sta   <$D8;

*
* This block of code takes the vector list describing the
* command ship, and applies a rotation transformation to
* them.  The current rotation value is in C8D4, and the
* transformed vector list is stored in the buffer
* starting at CB89.

rotate_cmd_ship:
       lda   <$D4;
       ldx   #command_ship;
       ldu   #$CB89;
       jsr   rotate_vector_list1;

       lda   #$7F;
       ldb   <$D4;
       jsr   calc_rise_run2;
       sty   $C907;
       stx   $C909;
       rts;


*
* This routine is called after the active player clears
* a mine field level.  This routine will slowly bring the
* command ship back to the center of the screen.  As this
* is being done, a series of dots will be drawn to simulate
* motion.

bring_ship_to_center:
       pshs  x,y;
       pshs  dp;
       jsr   dptoD0;
       jsr   clear_sound_chip;
       puls  dp;
       lda   #$A0;
       sta   <$8F;          * Use C88F as a loop counter

PE876: lda   <$C8;
       beq   PE884;         * Modify the y coordinate for the
       bmi   PE87F;         * command ship, in an effort to
       deca;                * force it back to 0.
       bra   PE880;
PE87F: inca;
PE880: sta   <$C8;
       clr   <$C9;

PE884: lda   <$CA;          * Modify the x coordinate for the
       beq   PE892;         * command ship, in an effort to
       bmi   PE88D;         * force it back to 0.
       deca;
       bra   PE88E;
PE88D: inca;
PE88E: sta   <$CA;
       clr   <$CB;

PE892: lda   <$D4;          * Modify the rotation value for the
       beq   PE8A2;         * command ship, in an effort to
       cmpa  #$1F;         * force it back to 0.
       bgt   PE89D;
       deca;
       bra   PE89E;
PE89D: inca;
PE89E: anda  #$3F;
       sta   <$D4;

PE8A2: jsr   PE2F2;        * This loop, repeated 8 times (once
       ldx   #$CB81;       * for each scale factor in the array)
       ldb   #$08;         * increments each of the scale factors
PE8AA: lda   ,x;            * for the motion dots, by 3.
       adda  #$03;
       sta   ,x+;
       decb;
       bne   PE8AA;

       pshs  dp;
       jsr   dptoD0;
       jsr   display_both_scores;
       clrb;
       lda   #$20;* " "
       jsr   simulate_motion1;
       jsr   modify_motion_scales;
       puls  dp;

* Repeat the above until the ship is centered.
       lda   <$C8;
       lbne  PE876;
       lda   <$CA;
       lbne  PE876;
       lda   <$D4;
       lbne  PE876;
       dec   <$8F;
       lbne  PE876;
       jsr   init_RAM_for_new_level;
       puls  x,y,pc;


*
* This routine initializes the two arrays
* (CB71 and CB81) which contain the data
* needed to produce the motion dots (the
* dots displayed as the ship moves from
* one level to the next).  The 8 entries
* in CB71 are pointers to the 8 sets of
* required dots.  The 8 entries in CB81
* are the corresponding scale factors.

init_motion_dots:
       ldx   #motion_dots;
       ldy   #$CB71;
       ldu   #$CB81;
       ldb   #$08;
       lda   #$16;
PE8F1: stx   ,y++;
       leax  8,x;
       sta   ,u+;
       adda  #$0F;
       decb;
       bne   PE8F1;
       rts;


*
* modify_motion_scales() increments each of the 8 motion
* scale factors, and then draws the new motion dots.
* simulate_motion1() and simulate_motion2() both
* draw the current motion dots.  The motion dots will
* only be drawn if the scale factor is > the value specified
* in the 'a' register, and if (scale - 'b') > 0.

modify_motion_scales:
       pshs  a,b,dp,x;
       ldx   #$CB81;
       lda   #$08;
PE904: inc   ,x+;           * Increment each of the scale factors
       deca;
       bne   PE904;
       bra   simulate_motion2;

simulate_motion1:
       pshs  a,b,dp,x;
simulate_motion2:
       lda   #$D0;
       tfr   a,dp;
       lda   #$09;         * Use 'a' as a loop counter
       pshs  a;
PE915: dec   ,s;
       bne   PE920;
       jsr   reset0ref;
       puls  a;
       puls  a,b,dp,x,pc;
PE920: jsr   reset0ref;
       lda   #$03;         * Use C823 to hold # of dots
       sta   $C823;         * to be drawn (4).
       lda   ,s;
       deca;
       ldx   #$CB81;
       ldb   a,x;
       andb  #$7F;
       cmpb  1,s;           * Make sure scale factor is
       bls   PE915;         * within the specified range
       subb  2,s;
       ble   PE915;
       stb   <$04;          * Set the hardware scale factor

       ldx   #$CB71;       * Draw the dot list
       asla;                * Convert loop cntr to a word offset
       ldx   a,x;
       jsr   intensity_to_7F;
       jsr   dot_list;
       bra   PE915;


*
* This routine is responsible for drawing the hyperspace dot
* during a hyperspace.  It draws the 8 sets of motion dots,
* using a decreasing scale factor.  At entry, the 'b' register
* contains the minimum scale factor to be used.

draw_hyperspace_motion_dots:
       pshs  a,b,dp,x;
       lda   #$D0;
       tfr   a,dp;
       lda   #$09;         * Push the loop cntr on the stack
       pshs  a;
next_set_of_dots:
       dec   ,s;
       bne   draw_the_dots;
       jsr   reset0ref;
       puls  a;
       puls  a,b,dp,x,pc;

draw_the_dots:
       jsr   reset0ref;
       lda   #$03;
       sta   $C823;         * Use C823 to hold # of dots to draw
       ldx   #$C8C8;
       jsr   move_pen7F_no_inc;
       ldb   ,s;
       aslb;
       aslb;
       addb  2,s;           * Calculate the scale factor
       ble   next_set_of_dots;
       andb  #$7F;
       stb   <$04;          * Set scale factor
       ldx   #$CB71;
       lda   ,s;            * Draw the appropriate set of dots
       deca;
       asla;
       ldx   a,x;
       jsr   intensity_to_7F;
       jsr   dot_list;
       bra   next_set_of_dots;


*
* Generate 2 random numbers (1 byte each), and return
* them in a and b.  The range for the two numbers is:
*
*      $80 <= first #  <= $7F     (a register)
*      $A0 <= second # <= $60     (b register)

MS_get_2_random_nums:
       pshs  a,b;
       jsr   get_random_a;
       sta   ,s;
PE991: jsr   get_random_a;
       cmpa  #$60;
       bgt   PE991;
       cmpa  #$A0;
       blt   PE991;
       sta   1,s;
       puls  a,b;
       rts;


*
* This routine randomly activates a single mine.
* At entry, the 'a' register must contain the
* type of mine to be activated, while the 'b'
* register must contain the generation number
* for the mine (i.e. large, medium, or small).

activate_a_mine:
       pshs  a,b,x,y,u;
       lda   <$ED;          * Check C8ED to see if there are any
       lbeq  PEA3C;         * dot mines; if not, then return.
       dec   <$ED;

       jsr   get_random_a; * Generate a random index into the
       anda  #$1F;         * mine array.
PE9B0: sta   <$8B;
       cmpa  #$1B;
       bls   PE9BA;
       suba  #$04;
       bra   PE9B0;

PE9BA: ldb   #$12;         * Multiple offset by element size
       mul;
       addd  #$C933;
       tfr   d,u;
       lda   ,u;                 * Check to see if this mine is already
       anda  #$C0;              * being used.  If it is, then check
       bne   init_a_visible_mine;* the next mine in the structure; else
       inc   <$8B;               * use this mine.
       lda   <$8B;
       cmpa  #$1B;
       ble   PE9BA;
       clr   <$8B;
       clra;
       bra   PE9BA;

init_a_visible_mine:
       lda   ,s;            * Store the mine type
       sta   1,u;
       ldx   #mine_values;
       asla;
       ldy   a,x;
       sty   <$89;          * Store mine's value in C889
       ldb   #$20;
       stb   ,u;
       ldx   #mine_velocity;
       lda   1,s;           * Save mine's velocity
       ldb   a,x;
       stb   <$8B;
       ldx   #final_mine_scale_factor;
       ldb   a,x;
       stb   $10,u;        * Save mine's max scale factor
       sta   3,u;           * Save mine's generation number
       ldx   #mine_sizes;
       asla;
       ldy   a,x;
       sty   <<12,u;        * Save mine's size
       ldx   #extra_mine_value;
       ldy   a,x;
       sty   <$87;          * Get any extra value for mine's size
       cmpa  #$06;
       bne   PEA13;
       inc   <$F4;          * Flag that a sound should be made
PEA13: lda   <$88;
       adda  <$8A;
       daa;
       sta   15,u;        * Generate lo byte of score
       lda   <$87;
       adca  <$89;
       daa;
       sta   14,u;       * Generate hi byte of score
       lda   <$8B;
       jsr   MS_random_num_4_to_3C;
       jsr   calc_rise_run1;
       sty   8,u;          * Save the rise
       stx   10,u;         * Save the run
       inc   <$EB;         * Increment 'active mine' counter
       lda   <$C0;
       beq   PEA3C;
       lda   #$FF;
       sta   <$9C;
       lda   #$03;
       sta   <$C1;
PEA3C: puls  a,b,x,y,u,pc;


*
* Generate a random number between 4 and $3C.  The
* result is returned in the b register.

MS_random_num_4_to_3C:
       pshs  a,b;
       jsr   get_random_a;
       tfr   a,b;
       anda  #$30;* "0"
       sta   1,s;
       andb  #$0F;
       cmpb  #$04;
       bhs   PEA51;
       addb  #$04;
PEA51: cmpb  #$0C;
       bls   PEA57;
       subb  #$04;
PEA57: addb  1,s;
       stb   1,s;
       puls  a,b,pc;


*
* Force the scale factor to $7F, then
* draw a dot at the position contained
* in the y register.

draw_dot7F_at_y:
       pshs  a,b;
       lda   #$7F;
       sta   <$04;
       tfr   y,d;
       jsr   dot_at_d;
       jsr   reset0ref;
       puls  a,b,pc;


*
* Force the scale factor to $7F, then draw a
* dot at the position pointed to by the y
* register (y coord = (0,y), x coord = (2,y)).

draw_dot7F_ptr_in_y:
       pshs  a,b;
       lda   #$7F;
       sta   <$04;
       lda   ,y;
       ldb   2,y;
       jsr   dot_at_d;
       jsr   reset0ref;
       puls  a,b,pc;


*
* Move the pen to the position specified
* in the y register, then draw the vector
* list pointed to by the x register; the
* scale factor is in the b register.

move_y_draw_x:
       pshs  a,b,x;
       tfr   y,d;
       jsr   move_pen7F_to_d;
       ldb   1,s;
       jsr   drawl1b;
       puls  a,b,x,pc;


*
* Move the pen to the position specified in the y
* register, and draw the list of vectors pointed to
* by the x register; the scale factor to be used is
* in the b register. (y coord = (0,y), x coord = (x,y))

move_y_draw_x2:
       pshs  a,b,x;
       tfr   y,x;
       jsr   move_pen7F_no_inc;
       ldb   1,s;
       ldx   2,s;
       jsr   drawl1b;
       puls  a,b,x,pc;


*
* Force the scale factor to $7F, then print
* a single string (upto a $80).  The pointer
* to the string block is contained in the
* u register.

MS_print_1_string7F:
       pshs  a,b,x,u;
       lda   #$7F;
       sta   <$04;
       jsr   print_1_string;
       puls  a,b,x,u,pc;


*
* Move the pen to the position specified in the
* y register, then print a string.  The pointer
* to the string (not a string block) is in the
* u register.

move_y_print_string:
       pshs  a,b,x,u;
       tfr   y,d;
       jsr   move_pen7F_to_d;
       jsr   display_string;
       puls  a,b,x,y,pc;


*
* Use the value in C89B (the active player) to
* determine which players score to display,
* and then display the score string.

display_active_players_score:
       jsr   intensity_to_7F;
       ldd   #$FC38;
       std   $C82A;         * Specify height and width
       lda   $C89B;
       ldy   #score_string_positions;
       ldy   a,y;           * Load string position into y
       ldu   #score_string_pointers;
       ldu   a,u;           * Load score string into u
       bsr   move_y_print_string;
       rts;


*
* Display the score for both players

display_both_scores:
       jsr   intensity_to_7F;
       ldd   #$FC38;
       std   $C82A;         * Specify height and width
       ldy   #$7FA0;       * Load y with y&x positions
       ldu   #$C8A8;       * Load u with player 1 score
       bsr   move_y_print_string;
       lda   $C879;         * See if we need to display player 2 score
       beq   PEAEF;
       ldy   #$7F10;       * Load y with y&x positions
       ldu   #$C8AF;       * Load u with player 2 score
       bsr   move_y_print_string;
PEAEF: rts;


*
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

process_indirect_jumps:
       jsr   waitrecal;
       pshs  dp;
       jsr   $F2E6;
       jsr   display_active_players_score;

* Set mask (in C880) and read the switches
       lda   $C880;
       jsr   read_switches;

* Set enable flags (in C881) and read joystick
       ldd   $C881;
       std   $C81F;
       std   $C821;
       jsr   read_jstick;

       lda   #$C8;
       tfr   a,dp;
       lda   <$9C;
       beq   PEB1D;
       dec   <$9C;
       bne   PEB1D;
       jsr   [$C89D];  * (UNKNOWN JUMP)
PEB1D: lda   <$9F;
       beq   PEB29;
       dec   <$9F;
       bne   PEB29;
       jsr   [$C8A0];  * (UNKNOWN JUMP)
PEB29: lda   <$A2;
       beq   PEB35;
       dec   <$A2;
       bne   PEB35;
       jsr   [$C8A3];  * (UNKNOWN JUMP)
PEB35: lda   <$A5;
       beq   PEB41;
       dec   <$A5;
       bne   PEB41;
       jsr   [$C8A6];  * (UNKNOWN JUMP)
PEB41: puls  dp,pc;


*
* This routine check to see if any of the
* bullets have hit a mine or a fireball or
* the enemy ship.  If something is hit, then
* the active player's score will be modified.

check_bullets_for_hits:
       lda   <$EA;          * Don't bother checking if there are
       beq   PEB59;         * no active bullets. (C8EA = 0)
       ldy   #$C90B;
       lda   #$04;
       sta   <$8F;          * Use C88F as a loop counter
check_for_active_bullet:
       tst   ,y;            * See if this bullet is active
       bne   check_enemy_ship_4_hit;
inc_bullet_ptr2:
       leay  10,y;          * Increment ptr to next bullet
       dec   <$8F;
       bne   check_for_active_bullet;
PEB59: rts;

check_enemy_ship_4_hit:
       lda   <$E7;                * Only check for a hit on the enemy
       beq   check_mines_for_hits;* ship if it is showing (C8E7 > 0).
       pshs  y;
       lda   5,y;
       ldb   7,y;
       tfr   d,x;                  * bullets position
       ldd   #$0616;              * height/2 and width/2 of enemy ship
       ldy   <$DC;                 * position of enemy ship
       jsr   check_bullet_for_hit;* See if the enemy ship was hit
       puls  y;
       bhs   check_mines_for_hits;
       clr   ,y;            * HIT - flag that bullet is dead
       clr   <$E7;          * Flag that enemy ship no longer there
       clr   <$A2;          * Clear 1 indirect jump counter
       ldx   #score_string_pointers;
       lda   <$9B;
       ldx   a,x;
       ldd   #$1000;       * Inc players score by 1000
       jsr   add_d_to_x_in_bcd;
       lda   #$30;
       ldb   #$70;
       ldx   <$DC;
       jsr   add_an_explosion;
       dec   <$EA;          * Decrement the # of active bullets
       bra   PEB59;

*
* This routine checks to see if a bullet hit
* any of the active mines or fireballs.

check_mines_for_hits:
       ldu   #$C933;       * Load 'u' with ptr to mine info
       lda   #$1C;
       sta   <$90;          * Use C890 as a counter
check_for_active_mine:
       lda   ,u;
       anda  #$3F;         * Make sure mine is active
       bne   check_this_mine;
inc_mine_ptr2:
       leau  $12,u;          * Inc ptr into mine structure
       dec   <$90;
       bne   check_for_active_mine;
       bra   inc_bullet_ptr2;

check_this_mine:
       pshs  y;
       lda   5,y;
       ldb   7,y;
       tfr   d,x;                  * bullet coordinates
       lda   4,u;
       ldb   6,u;                  * mine coordinates
       tfr   d,y;
       ldd   12,u;                 * height & width of mine
       jsr   check_bullet_for_hit;* returns: carry set = hit, else miss
       puls  y;
       bhs   inc_mine_ptr2;
       lda   1,u;           * Check if this is a fireball mine
       anda  #$02;
       beq   not_a_fireball_mine;
       ldx   #score_string_pointers;
       lda   <$9B;
       ldx   a,x;
       ldd   14,u;          * Add mines value to players score
       jsr   add_d_to_x_in_bcd;
       inc   <$F5;
       lda   4,u;
       ldb   6,u;
       tfr   d,x;
       lda   2,u;
       ldb   #$20;
       jsr   add_an_explosion;
       ldd   #$0110;       * Init score for the fireball
       std   14,u;
       lda   <$C8;
       suba  4,u;
       ldb   <$CA;
       subb  6,u;
       jsr   $F593;
       suba  #$10;
       tfr   a,b;
       pshs  y;
       lda   #$3F;
       jsr   calc_rise_run1;
       sty   8,u;           * Calculate rise & run for fireball
       stx   10,u;
       puls  y;
       clr   ,y;            * Flag that the bullet is dead
       ldd   #$0404;
       std   12,u;          * Set height/2 & width/2 for fireball
       lda   1,u;
       ldb   3,u;           * Decrement the generation for this mine
       decb;                * and don't start any more if it = 0
       beq   start_a_fireball;
       jsr   activate_a_mine;
       jsr   activate_a_mine;
start_a_fireball:
       lda   #$04;         * Flag that this is a fireball
       sta   1,u;
       dec   <$EA;          * Decrement active bullet counter
       jmp   inc_bullet_ptr2;

*
* This processes a hit on a non-fireball type mine.

not_a_fireball_mine:
       lda   #$01;
       sta   ,u;
       clr   ,y;            * Flag that the bullet is dead
       ldx   #score_string_pointers;
       lda   <$9B;
       ldx   a,x;           * Add mines value to players score
       ldd   14,u;
       jsr   add_d_to_x_in_bcd;
       lda   4,u;
       ldb   6,u;
       tfr   d,x;
       lda   2,u;
       ldb   #$40;
       jsr   add_an_explosion;
       dec   <$EB;          * Decrement active mine counter
       dec   <$EA;          * Decrement the active bullet counter
       jmp   inc_bullet_ptr2;


*
* This routine check each active mine to see if it has
* collided with the command ship.

check_ship_4_mine_collision:
       lda   <$BD;
       bne   PEC63;         * Do only if cmd ship not already dead
       lda   <$EE;
       bne   PEC63;         * Do only if hyperspace not active
       ldy   #$C933;
       lda   #$1C;
       sta   <$8F;          * Set up a loop counter
PEC56: lda   ,y;
       anda  #$3F;
       bne   check_this_active_mine;
inc_mine_ptr3:
       leay  $12,y;
       dec   <$8F;
       bne   PEC56;
PEC63: rts;

check_this_active_mine:
       pshs  y;
       lda   <$C8;
       ldb   <$CA;
       tfr   d,x;           * Load cmd ship's position
       lda   4,y;
       ldb   6,y;
       ldy   12,y;          * Load mine's position
       exg   y,d;
       jsr   check_bullet_for_hit;
       puls  y;
       bhs   inc_mine_ptr3;
       clr   ,y;            * Flag that the mine is dead
       clr   <$ED;
       lda   <$C8;
       ldb   <$CA;
       tfr   d,x;
       lda   2,y;
       ora   #$80;
       ldb   #$30;
       jsr   add_an_explosion;
       inc   <$F3;          * Flag for an explosion sound
       dec   <$EB;          * Decrement active mine counter
       bra   PEC63;


*
* This routine checks to see if the command ship has collided
* with the enemy ship during reseeding.

check_ship_4_enemy_collision:
       lda   <$BD;          * Do only if cmd ship not disabled
       bne   PECB2;
       lda   <$EE;          * Don't do if hyperspace active
       bne   PECB2;
       lda   <$E7;          * Check only if enemy ship visible
       beq   PECB2;
       lda   <$C8;
       ldb   <$CA;
       tfr   d,x;           * Command ship location
       ldd   #$0616;       * Size of enemy ship
       ldy   <$DC;          * Enemy ship's location
       jsr   check_bullet_for_hit;
       blo   cmd_and_enemy_ship_collision;
PECB2: rts;

cmd_and_enemy_ship_collision:
       clr   <$E7;          * Flag that enemy ship no longer visible
       clr   <$A2;
       lda   <$C8;
       ldb   <$CA;
       tfr   d,x;
       lda   #$08;
       ora   #$80;
       ldb   #$30;
       jsr   add_an_explosion;
       inc   <$F3;          * Enable explosion sound
       rts;

*
* This routine is responsible for making miscellaneous sound,
* such as when an explosion occurs, or a bullet is fired.

make_misc_sounds:
PECC9: lda   $C8F2;
       beq   PECD6;
       clr   $C8F2;
       ldu   #cmd_ship_movement_sound;* Make cmd ship movement sound
       bra   make_the_misc_sound;
PECD6: lda   $C8F3;
       beq   PECE3;
       clr   $C8F3;
       ldu   #explosion_sound;* Make explosion sound
       bra   make_the_misc_sound;
PECE3: lda   $C8B6;
       beq   PECF0;
       clr   $C8B6;
       ldu   #bullet_sound; * Make bullet firing sound
       bra   make_the_misc_sound;
PECF0: lda   $C8F4;
       beq   PED00;
PECF5: clr   $C8F4;
       clr   $C8F6;
       ldu   #mine_pop_sound;* Make sound of mine 'popping' up
       bra   make_the_misc_sound;
PED00: lda   $C8F6;
       bne   PECF5;         * Make hyperspace sound
       bra   PED0A;

make_the_misc_sound:
       jsr   copy_bytes_2_sound_chip;
PED0A: ldb   $C800;
       addb  #$10;
       cmpb  #$A0;
       bhs   PED1A;
       lda   #$00;
       jsr   byte_2_sound_chip;
       bra   PED20;
PED1A: ldd   #$0800;
       jsr   byte_2_sound_chip;
PED20: ldb   $C802;
       addb  #$20;
       cmpb  #$F0;
       bhs   PED30;
       lda   #$02;
       jsr   byte_2_sound_chip;
       bra   PED36;
PED30: ldd   #$0900;
       jsr   byte_2_sound_chip;
PED36: rts;


cmd_ship_movement_sound:
       DB    $00;
       DB    $10;
       DB    $01;
       DB    $00;
       DB    $06;
       DB    $1F;
       DB    $07;
       DB    $06;
       DB    $08;
       DB    $0F;
       DB    $FF;

bullet_sound:
       DB    $02;
       DB    $39;* "9"
       DB    $03;
       DB    $00;
       DB    $06;
       DB    $1F;
       DB    $07;
       DB    $05;
       DB    $09;
       DB    $0F;
       DB    $FF;

explosion_sound:
       DB    $06;
       DB    $1F;
       DB    $07;
       DB    $07;
       DB    $0A;
       DB    $10;
       DB    $0B;
       DB    $00;
       DB    $0C;
       DB    $38;* "8"
       DB    $0D;
       DB    $00;
       DB    $FF;

mine_pop_sound:
SED5A: DB    $00;
       DB    $00;
       DB    $01;
       DB    $00;
       DB    $02;
       DB    $30;* "0"
       DB    $03;
       DB    $00;
       DB    $04;
       DB    $00;
       DB    $05;
       DB    $00;
       DB    $06;
       DB    $1F;
       DB    $07;
       DB    $3D;* "="
       DB    $08;
       DB    $00;
       DB    $09;
       DB    $0F;
       DB    $0A;
       DB    $00;
       DB    $0B;
       DB    $00;
       DB    $0C;
       DB    $00;
       DB    $0D;
       DB    $00;
       DB    $FF;

* Start of Mine Storm music block
MS_music:
       DW    MS_music_header1;
       DW    music_header2a;
       DB    $00;
       DB    $19;
       DB    $01;
       DB    $19;
       DB    $00;
       DB    $19;
       DB    $01;
       DB    $32;
       DB    $00;
       DB    $19;
       DB    $01;
       DB    $19;
       DB    $00;
       DB    $19;
       DB    $06;
       DB    $19;
       DB    $05;
       DB    $19;
       DB    $00;
       DB    $80;

MS_music_header1:
       DB    $FF;
       DB    $EE;
       DB    $DD;
       DB    $CC;
       DB    $BB;
       DB    $AA;
       DB    $99;
       DB    $88;
       DB    $77;
       DB    $77;
       DB    $77;
       DB    $77;
       DB    $77;
       DB    $77;
       DB    $77;
       DB    $77;

score_string_pointers:
       DW    $C8A8;        * Pointer to player 1 score string
       DW    $C8AF;        * Pointer to player 2 score string

score_string_positions:
       DB    $7F;          * Player 1 rel y score position
       DB    $A0;          * Player 1 rel x score position
       DB    $7F;          * Player 2 rel y score position
       DB    $10;          * Player 2 rel x score position

mine_field_level_pointers:
       DW    $C8F9;        * Pointer to player 1 mine field # string
       DW    $C900;        * Pointer to player 2 mine field # string

*
* This contains the information describing which mines
* are to appear at the first 13 mine field levels.  The
* values map a follows:
*
*  0 = dumb mine
*  1 = magnetic mine
*  2 = fireball mine
*  3 = magnetic fireball mine
*

mines_at_level_x:
       DB    $00;          * level 1
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $02;          * level 2
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $01;          * level 3
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $03;          * level 4
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $02;          * level 5
       DB    $01;
       DB    $00;
       DB    $00;
       DB    $02;          * level 6
       DB    $03;
       DB    $00;
       DB    $00;
       DB    $01;          * level 7
       DB    $03;
       DB    $00;
       DB    $00;
       DB    $02;          * level 8
       DB    $02;
       DB    $00;
       DB    $00;
       DB    $01;          * level 9
       DB    $01;
       DB    $00;
       DB    $00;
       DB    $03;          * level 10
       DB    $03;
       DB    $00;
       DB    $00;
       DB    $02;          * level 11
       DB    $02;
       DB    $02;
       DB    $00;
       DB    $01;          * level 12
       DB    $01;
       DB    $01;
       DB    $00;
       DB    $03;          * level 13
       DB    $03;
       DB    $03;
       DB    $00;
       DB    $80;

motion_dots:
       DB    $C8;
       DB    $40;
       DB    $3F;
       DB    $00;
       DB    $20;
       DB    $80;
       DB    $10;
       DB    $1F;
       DB    $3F;
       DB    $3F;
       DB    $00;
       DB    $BF;
       DB    $BF;
       DB    $BF;
       DB    $C0;
       DB    $20;
       DB    $48;
       DB    $08;
       DB    $F8;
       DB    $30;
       DB    $A8;
       DB    $10;
       DB    $D0;
       DB    $A0;
       DB    $BF;
       DB    $BF;
       DB    $00;
       DB    $3F;
       DB    $3F;
       DB    $48;
       DB    $20;
       DB    $80;
       DB    $00;
       DB    $B0;
       DB    $48;
       DB    $38;
       DB    $FB;
       DB    $38;
       DB    $80;
       DB    $28;
       DB    $30;
       DB    $48;
       DB    $80;
       DB    $80;
       DB    $45;
       DB    $F0;
       DB    $28;
       DB    $7F;
       DB    $3F;
       DB    $BF;
       DB    $A5;
       DB    $00;
       DB    $D0;
       DB    $60;
       DB    $20;
       DB    $28;
       DB    $B8;
       DB    $40;
       DB    $15;
       DB    $80;
       DB    $40;
       DB    $F8;
       DB    $40;
       DB    $18;

mine_field:
       DB    $FA;   * height = -6
       DB    $38;   * width = 56
       DB    $E0;   * rel y = -32
       DB    $C8;   * rel x =
       DB    "MINE FIELD", $80;

game_over:
       DB    $FA;   * height = -6
       DB    $38;   * width = 56
       DB    $E0;   * rel y = -32
       DB    $D8;   * rel x =
       DB    "GAME OVER",$80;

dumb_mine:
       DB    $00;
       DB    $10;
       DB    $00;
       DB    $FF;
       DB    $20;
       DB    $A0;
       DB    $FF;
       DB    $C0;
       DB    $40;
       DB    $FF;
       DB    $90;
       DB    $20;
       DB    $FF;
       DB    $70;
       DB    $20;
       DB    $FF;
       DB    $50;
       DB    $50;
       DB    $FF;
       DB    $D0;
       DB    $90;
       DB    $01;

magnetic_mine:
       DB    $00;
       DB    $20;
       DB    $00;
       DB    $FF;
       DB    $30;
       DB    $B0;
       DB    $FF;
       DB    $B0;
       DB    $30;
       DB    $FF;
       DB    $B0;
       DB    $D0;
       DB    $FF;
       DB    $30;
       DB    $50;
       DB    $FF;
       DB    $D0;
       DB    $50;
       DB    $FF;
       DB    $50;
       DB    $D0;
       DB    $FF;
       DB    $50;
       DB    $30;
       DB    $FF;
       DB    $D0;
       DB    $B0;
       DB    $01;

fireball_mine:
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $30;
       DB    $00;
       DB    $FF;
       DB    $10;
       DB    $C0;
       DB    $FF;
       DB    $C0;
       DB    $10;
       DB    $FF;
       DB    $C0;
       DB    $F0;
       DB    $FF;
       DB    $10;
       DB    $40;
       DB    $FF;
       DB    $F0;
       DB    $40;
       DB    $FF;
       DB    $40;
       DB    $F0;
       DB    $FF;
       DB    $40;
       DB    $10;
       DB    $FF;
       DB    $F0;
       DB    $C0;
       DB    $01;

magnetic_fireball_mine:
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $F0;
       DB    $D0;
       DB    $FF;
       DB    $C0;
       DB    $40;
       DB    $FF;
       DB    $20;
       DB    $00;
       DB    $FF;
       DB    $40;
       DB    $40;
       DB    $FF;
       DB    $00;
       DB    $E0;
       DB    $FF;
       DB    $40;
       DB    $C0;
       DB    $FF;
       DB    $E0;
       DB    $00;
       DB    $FF;
       DB    $C0;
       DB    $C0;
       DB    $FF;
       DB    $00;
       DB    $20;
       DB    $01;

fireball:
       DB    $00;
       DB    $3F;
       DB    $00;
       DB    $FF;
       DB    $80;
       DB    $00;
       DB    $00;
       DB    $3F;
       DB    $3F;
       DB    $FF;
       DB    $00;
       DB    $80;
       DB    $01;

explosion:
       DB    $FF;
       DB    $7F;
       DB    $20;
       DB    $00;
       DB    $C0;
       DB    $10;
       DB    $FF;
       DB    $C0;
       DB    $D0;
       DB    $FF;
       DB    $20;
       DB    $7F;
       DB    $00;
       DB    $E0;
       DB    $C0;
       DB    $FF;
       DB    $00;
       DB    $C0;
       DB    $FF;
       DB    $E0;
       DB    $30;
       DB    $00;
       DB    $C0;
       DB    $00;
       DB    $FF;
       DB    $60;
       DB    $CD;
       DB    $FF;
       DB    $A0;
       DB    $00;
       DB    $00;
       DB    $20;
       DB    $D0;
       DB    $FF;
       DB    $3C;
       DB    $30;
       DB    $FF;
       DB    $00;
       DB    $82;
       DB    $00;
       DB    $30;
       DB    $30;
       DB    $FF;
       DB    $D0;
       DB    $50;
       DB    $FF;
       DB    $20;
       DB    $F0;
       DB    $01;

command_ship:
       DB    $00;
       DB    $3F;
       DB    $00;
       DB    $FF;
       DB    $C4;
       DB    $08;
       DB    $FF;
       DB    $D8;
       DB    $D8;
       DB    $FF;
       DB    $20;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $FF;
       DB    $E0;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $D8;
       DB    $FF;
       DB    $3C;
       DB    $08;
       DB    $01;

cmd_ship_pt1:
       DB    $00;
       DB    $3F;
       DB    $00;
       DB    $FF;
       DB    $C4;
       DB    $08;
       DB    $01;

cmd_ship_pt2:
       DB    $00;
       DB    $04;
       DB    $08;
       DB    $FF;
       DB    $D8;
       DB    $D8;
       DB    $FF;
       DB    $20;
       DB    $00;
       DB    $01;

cmd_ship_pt3:
       DB    $00;
       DB    $3F;
       DB    $00;
       DB    $FF;
       DB    $C4;
       DB    $F8;
       DB    $01;

cmd_ship_pt4:
       DB    $00;
       DB    $04;
       DB    $F8;
       DB    $FF;
       DB    $D8;
       DB    $28;
       DB    $FF;
       DB    $20;
       DB    $00;
       DB    $01;

enemy_ship_pt1:
       DB    $00;
       DB    $20;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $D8;
       DB    $FF;
       DB    $D0;
       DB    $A8;
       DB    $FF;
       DB    $F0;
       DB    $40;
       DB    $FF;
       DB    $08;
       DB    $18;
       DB    $FF;
       DB    $18;
       DB    $F0;
       DB    $FF;
       DB    $F0;
       DB    $B8;
       DB    $00;
       DB    $10;
       DB    $48;
       DB    $FF;
       DB    $08;
       DB    $00;
       DB    $FF;
       DB    $E8;
       DB    $10;
       DB    $FF;
       DB    $F8;
       DB    $00;
       DB    $00;
       DB    $08;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $06;
       DB    $00;
       DB    $10;
       DB    $FA;
       DB    $FF;
       DB    $08;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $F0;
       DB    $00;
       DB    $10;
       DB    $18;
       DB    $FF;
       DB    $F0;
       DB    $08;
       DB    $01;

enemy_ship_pt2:
       DB    $00;
       DB    $20;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $28;
       DB    $FF;
       DB    $D0;
       DB    $58;
       DB    $FF;
       DB    $F0;
       DB    $C0;
       DB    $FF;
       DB    $08;
       DB    $E8;
       DB    $FF;
       DB    $18;
       DB    $10;
       DB    $FF;
       DB    $F0;
       DB    $48;
       DB    $00;
       DB    $10;
       DB    $B8;
       DB    $FF;
       DB    $08;
       DB    $00;
       DB    $FF;
       DB    $E8;
       DB    $F0;
       DB    $FF;
       DB    $F8;
       DB    $00;
       DB    $FF;
       DB    $08;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $FA;
       DB    $00;
       DB    $10;
       DB    $06;
       DB    $FF;
       DB    $08;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $10;
       DB    $00;
       DB    $10;
       DB    $E8;
       DB    $FF;
       DB    $F0;
       DB    $F8;
       DB    $01;

enemy_ship_pt3:
       DB    $FF;
       DB    $00;
       DB    $D8;
       DB    $FF;
       DB    $E8;
       DB    $08;
       DB    $FF;
       DB    $00;
       DB    $40;
       DB    $FF;
       DB    $18;
       DB    $08;
       DB    $FF;
       DB    $00;
       DB    $D8;
       DB    $00;
       DB    $08;
       DB    $E0;
       DB    $FF;
       DB    $10;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $40;
       DB    $FF;
       DB    $F0;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $C0;
       DB    $01;

simple_enemy_ship:
       DB    $00;
       DB    $18;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $20;
       DB    $FF;
       DB    $C8;
       DB    $70;
       DB    $FF;
       DB    $10;
       DB    $A0;
       DB    $FF;
       DB    $00;
       DB    $A0;
       DB    $FF;
       DB    $EC;
       DB    $A4;
       DB    $FF;
       DB    $39;
       DB    $6D;
       DB    $FF;
       DB    $00;
       DB    $20;
       DB    $01;

* The following is spare space in the ROM
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;


