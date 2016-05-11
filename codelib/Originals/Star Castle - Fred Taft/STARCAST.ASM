; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti starcast.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html

;a bug in starcastle? search for: "malban <BUG?>"

*
* This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
* Please forward any comments, corrections or additions back to Fred.
* Star Castle

       include "taft.i"
move_to_pt equ $f3bc

       org $0000;
       direct -1
       noopt

       DB    "g GCE 1983",$80;
       DW    star_castle_music;

       DB    $F8;* height
       DB    $50;* width
       DB    $00;* rel y
       DB    $B0;* rel x
       DB    "STAR CASTLE",$80,$00;

star_castle:
       tst   $C83B;             * The following block of code is
       beq   restart_game;      * called only the first time the
       jsr   dptoD0;            * game is powered up, and only if
       jsr   read_switches2;    * buttons 1,2 & 4 are all
       lda   $C80F;             * simultaneously pressed.  This
       cmpa  #$0B;              * code will display the name of the
       bne   restart_game;      * programmer, until either the
       ldd   #$FB40;            * counter at C88A decrements to 0
       std   $C82A;             * or the buttons are no longer
P0036: ldu   #author;           * pressed.
       jsr   printu2;
       jsr   waitrecal;
       jsr   intensity_to_5F;
       dec   $C88A;
       bne   P0036;


* Initialize variables, and set the users score string
* to its default values.

restart_game:
       ldx   #$C880; * Initialize RAM area. /
       jsr   clear_256_bytes;
       jsr   dptoC8;
       lda   #$05;   * Set player 1's ship count.
       sta   <$9D;
       ldx   #$C8B0; * Init player 1's score string.
       jsr   set_dft_score;
       ldx   #$C8D0; * Init player 2's score string.
       jsr   set_dft_score;

* Fill in the user's data area to its initial values.
       ldx   #$C8CC; * Address of user 2's data area.
       lda   #$80;
       sta   -3,x;    * Set player 2 state to "inactive".
       ldd   #$E090;
       std   -13,x;   * Set initial (y,x) location.
       lda   #$30;
       sta   -16,x;   * Set initial cruiser rotation.
       ldx   #$C8AC; * Address of user 1's data area.
       ldd   #$1070;
       std   -13,x;   * Set initial (y,x) location.
       lda   #$10;
       sta   -16,x;   * Set initial cruiser rotation.

* Ask user for the game #, and number of players.
       ldd   #$0060; * Set initial ring rotation deltas.
       std   $C930;
       ldd   #$0202; *At first, allow 2 games & 2 players.
       clr   <$91;
       std   <$92;
       jsr   get_players_game;
       lsr   <$7A;    * Check which game was selected.
       blo   P0093;
P0090: lsr   $C931;   * Game 2;use slower rotation deltas.
P0093: clr   <$7A;
       lsr   <$79;    * If 2 players were selected, then
       beq   P00AE;   * allow the user to select one of 3
       lda   #$05;   * 2 person games.
       sta   <$BD;    * Init ship count for player 2.
       ldd   #$0003; * Allow 3 games.
       jsr   get_players_game;
       inc   <$79;
       dec   <$7A;   * Determine if 2 person, simultaneous
       lda   <$7A;   * play was chosen; i.e. if game 3 was
       lsra;         * selected.
       beq   P00AE;
       clr   <$C9;   * Flag simultaneous play.

P00AE: inc   <$24;
       ldd   #$C9C8;* Address of player 1 bullet buffer.
       std   <$AC;
       ldd   #$C9F4;* Address of player 2 bullet buffer.
       std   <$AE;
       std   <$CC;
       ldd   #$CA20;
       std   <$CE;
       dec   <$8F;   * Backup both players info data areas.
       jsr   change_player;
       dec   <$8F;
       ldd   $CA62;
       std   $C930;
       jsr   change_player;
       clr   <$E1;
P00D3: jsr   waitrecal;
       jsr   do_sound;
       lda   #$88;   * Set the button mask required
       ldb   $C88D;   * by the read_switches routine.
       beq   P00E1;
       coma;
P00E1: jsr   read_switches;
       jsr   read_jstick;
       jsr   intensity_to_3F;
       lda   $C88D;   * Check if the game is over.
       lbne  P0488;


* If player 1 is still alive, then transform his star
* cruiser, and draw it.

       ldy   #$C8AC;
       lda   -3,y;    * Check if player 1 is alive.
       bmi   P0114;
       lda   -16,y;   * Get cruiser's rotation value.
       ldb   #$08;   * Load the number of points (9).
       ldx   #star_cruiser1; * Addr of cruiser 1's V list.
       ldu   #$C932; * Addr of transformation buffer.
       jsr   rotate_vector_list2;
       ldd   -13,y;   * Location of player 1's cruiser.
       jsr   move_pen7F_to_d;
       ldd   #$080D; * (number of pts, scale factor).
       ldx   #$C932;
       jsr   move_then_draw_VL_with_count4;


* If player 2 is still alive, then transform his star
* cruiser, and draw it.

P0114: ldy   #$C8CC;
       lda   -3,y;    * Check if player 2 is alive.
       bmi   P0137;
       lda   -16,y;   * Get cruiser's rotation value.
       ldb   #$0A;   * Load the number of points (11).
       ldx   #star_cruiser2; * Addr of cruiser 2's V list.
       ldu   #$C932; * Addr of transformation buffer.
       jsr   rotate_vector_list2;
       ldd   -13,y;   * Location of player 2's cruiser.
       jsr   move_pen7F_to_d;
       ldd   #$0A0D; * (number of pts, scale factor).
       ldx   #$C932;
       jsr   move_then_draw_VL_with_count4;

* Update the position of all active bullets.
P0137: jsr   intensity_to_7F;
       ldx   #$C9C8; * Address of bullet buffer.
P013D: ldb   <<0,x;     * Check if bullet is active.
       beq   P0190;   * Bullet is inactive, so skip.
       bpl   P0169;   * Bullet is exploding.
       dec   9,x;     * Decrement life span, and continue
       beq   P018E;   * only if bullet is still 'alive'.
       ldd   5,x;     * Get original y position.
       exg   a,b;
       addd  1,x;     * Add the delta to it.
       exg   a,b;
       std   5,x;     * Update bullet's y position.
       ldd   7,x;     * Get original x position.
       addd  3,x;     * Add the delta to it.
       std   7,x;     * Update bullet's x position.
       pshs  x;
       leax  6,x;     * Draw a dot at the bullet's new
       lda   #$7F;   * position.
       sta   <$04;
       jsr   dotix;
       jsr   reset0ref;
       puls  x;
       bra   P0190;

* Bullet is exploding; so draw an explosion pattern
P0169: ldd   6,x;     * Move to bullets position.
       jsr   move_pen7F_to_d;
       ldb   10,x;
       addb  #$25;   * Increment the explosion scale
       stb   10,x;    * factor.
       blo   P018B;
       bpl   P0179;
       negb;
P0179: lsrb;         * Use the upper nibble of this
       lsrb;         * value as the scale factor.
       lsrb;
       lsrb;
       stb   <$04;
       pshs  x;
       ldx   #explosion_star;
       jsr   drawl2; * Draw the explosion pattern.
       puls  x;
       bra   P0190;

P018B: jsr   reset0ref;
P018E: clr   <<0,x;    * Flag that bullet is now inactive.
P0190: leax  11,x;   * Advance ptr to next bullet, and
       cmpx  #$CA20;* continue, if not at end of buffer.
       bne   P013D;

* Transform and draw the energy cannon
       lda   $C88E;   * Skip next block if energy cannon
       bne   P01C4;   * has exploded, or a new screen is
       lda   $C88F;   * being set up.
       lbne  P0257;
       jsr   intensity_to_3F;
       lda   $C8DE;   * Transform the energy cannon's
       ldb   #$0C;   * vector list.
       ldx   #energy_cannon;
       ldu   #$C932;
       jsr   rotate_vector_list2;
       lda   #$CE;
       sta   <$0C;
       ldd   #$0C0E; * Move to the origin, and then draw
       ldx   #$C932; * the transformed energy cannon.
       jsr   move_then_draw_VL_with_count4;
       jmp   P0257;

* Draw the energy cannon exploding
P01C4: bita  #$01;
       beq   P01EC;
       lda   #$CE;
       sta   <$0C;
       ldb   $C8DD;  * Increment the scale factor used
       addb  #$19;  * when drawing the explosion pattern.
       stb   $C8DD;
       blo   P01E3;
       bpl   P01D9;
       negb;
P01D9: stb   <$04;
       ldx   #explosion_star;
       jsr   drawl2;* Draw the explosion pattern.
       bra   P0257;

* Flag that the explosion is over
P01E3: clr   $C8DD;
       asl   $C88E;
       jsr   reset0ref;

* Collapse the 3 walls inward
P01EC: ldx   #$C8F3;
       clr   $C882;
P01F2: lda   ,x;   * When a rings scale factor reaches
       cmpa  #$04;* 4, flag that the ring has completely
       bhi   P0212;* collapsed, by incrementing C882.
       inc   $C882;
       cmpa  #$04;
       bne   P0219;
       pshs  x;    * Now clear all the patterns for this
       leax  2,x;  * ring, so it will disappear.
       ldb   #$07;
       jsr   clear_blockxb;
       leax  $1E,x;
       ldb   #$07;
       jsr   clear_blockxb;
       puls  x;
P0212: leau  $1E,x; * Decrement the scale factor used
       dec   ,u;     * to draw this ring.
       dec   ,x;
P0219: leax  10,x;   * Go onto the next ring.
       cmpx  #$C908;
       blo   P01F2;

* See if all 3 rings have finally collapsed inward
       lda   $C882;  * If all 3 rings have collapsed,
       cmpa  #$03;  * then force an explosion sound,
       bne   P0257;  * and have another explosion
       lda   $C877;  * pattern displayed.
       beq   P0234;
       lda   $C890;
       ora   #$80;
       sta   $C890;
P0234: ldb   $C8DD;  * Calculate the scale factor to use
       addb  #$0A;  * when drawing the explosion pattern.
       stb   $C8DD;
       blo   P0251;
       stb   <$04;
       lda   #$CE;
       sta   <$0C;
       lda   #$0E;
       sta   $C823;
       ldx   #explosion_dots;
       jsr   dot_list; * Draw the explosion pattern.
       bra   P0257;

* Flag that the level was cleared
P0251: clr   $C88E;
       dec   $C88F;

* Process the fireball, if active
P0257: jsr   intensity_to_3F;
       lda   $C8E1;
       lbeq  P02D7;  * Fireball not active.
       bpl   P029C;  * Fireball exploding.
       lda   $C890;  * Fireball moving.
       ora   #$40;
       sta   $C890;  * Force a fireball sound.
       ldd   $C8E6;
       exg   a,b;    * Update y position of fireball,
       addd  $C8E2;  * and check to see if it went off
       bvs   P02D4;  * the screen.
       exg   a,b;
       std   $C8E6;
       ldd   $C8E8;  * Update x position of fireball,
       addd  $C8E4;  * and check to see if it went off
       bvs   P02D4;  * the screen.
       std   $C8E8;
       ldd   $C8E7;  * Move to fireball's position.
       jsr   move_pen7F_to_d;
       lda   #$08;
       ldb   $C8E0;  * Draw the fireball.
       lsrb;
       ldx   #fireball;
       jsr   move_then_draw_VL_with_count4;
       inc   $C8E0;  * Increment the scale factor.
       bra   P02D7;

* Process the exploding firebal
P029C: ldd   $C8E7;  * Move to fireball's position.
       jsr   move_pen7F_to_d;
       ldb   $C8EA;
       addb  #$14;  * Increment explosion's scale factor.
       stb   $C8EA;
       blo   P02BE;
       lsrb;
       lsrb;
       lsrb;
       stb   <$04;   * Set scale factor.
       lda   #$0E;
       sta   $C823;
       ldx   #explosion_dots;
       jsr   dot_list; * Draw the explostion pattern.
       bra   P02D7;

* Clean up after the fireball explosion has finished
P02BE: jsr   reset0ref;
       clr   $C8EA;  * Clear explosion scale factor.
       lda   $C89D;  * If both player 1 & 2 are out
       ora   $C8BD;  * of cruisers, then set the
       bne   P02D1;  * 'game over' flag (C88D).
       dec   $C88D;
       bra   P02D4;

* Get ready for the next player
P02D1: jsr   P0382;
P02D4: clr   $C8E1;  * Disable the fireball.

* Transform the 3 rotating rings
P02D7: ldb   #$08;   * Number of vectors (9).
       lda   $C8ED;   * Ring 1's rotation value.
       ldx   #ring;   * Ptr to ring vector list.
       ldu   #$C932; * Ptr to xformation buffer.
       jsr   rotate_vector_list2;
       ldb   #$08;   * Number of vectors (9).
       lda   $C8EF;   * Ring 2's rotation value.
       ldx   #ring;   * Ptr to ring vector list.
       jsr   rotate_vector_list2;
       ldb   #$08;   * Number of vectors (9).
       lda   $C8F1;   * Ring 3's rotation value.
       ldx   #ring;   * Ptr to ring vector list.
       jsr   rotate_vector_list2;

* Draw the 3 rotating rings
       ldu   #$C8F3; * Ptr to scales & line patterns.
       ldx   #$C932; * Ptr to transformation buffer.
       jsr   draw_1_ring;  * Draw ring 1.
       jsr   draw_1_ring;  * Draw ring 2.
       jsr   draw_1_ring;  * Draw ring 3.
       jsr   intensity_to_7F;
       ldx   #$C932; * Hi-lite rings hit with 1 bullet.
       jsr   draw_1_ring;  * Draw ring 1.
       jsr   draw_1_ring;  * Draw ring 2.
       jsr   draw_1_ring;  * Draw ring 3.
       jsr   intensity_to_3F;

* START OF ENERGY BOMB PROCESSING LOOP
* Process energy bombs
       ldu   #$C978; * Addr of energy bomb buffer.
P031F: jsr   get_random_a;
       anda  #$07;   * Randomly select 1 of 8 vector
       ldx   #energy_bomb_VL_table;
       asla;          * lists to be used when drawing
       ldx   a,x;     * this energy bomb.
       lda   -3,u;    * See if we should draw energy bomb
       bita  #$40;   * or an explosion pattern.
       bne   P0346;
       tsta;
       lbmi  P040A;   * Energy bomb is not in use.
       cmpa  #$17;
       bls   P0397;   * Energy bomb is still on a ring.

* Energy bomb is moving; draw its vector list
       ldd   -13,u;   * Move to position of energy bomb.
       jsr   move_pen7F_to_d;
       ldb   #$0B;
       jsr   drawl1b;* Draw the energy bomb.
       jmp   P040A;

* Draw an explosion pattern at position of energy bomb
P0346: ldd   -13,u;   * Move to position of energy bomb.
       jsr   move_pen7F_to_d;
       ldb   -2,u;
       addb  #$14;   * Increment explosion scale factor
       stb   -2,u;    * and stop when it overflows.
       blo   P0366;
       lsrb;
       lsrb;
       lsrb;
       stb   <$04;    * Set the scale factor.
       lda   #$0E;
       sta   $C823;   * Number of dots to draw.
       ldx   #explosion_dots;
       jsr   dot_list;* Draw the explosion dots.
       jmp   P040A;

* Clean up after an energy bomb explosion
P0366: jsr   reset0ref;
       clr   -2,u;
       lda   #$80;  * Flag that this slot is no longer
       sta   -3,u;   * in use.
       lda   $C89D;
       ora   $C8BD;  * See if either player has any
       bne   P037D;  * cruisers left.
       dec   $C88D;
       jmp   P040A; * Flag that game is over.

* See if "PLAYER X" string needs to be displayed
P037D: ldx   #P0394;
P0380: pshs  x;
P0382: lda   $C879;  * If a 2 person, non-simultaneous
       beq   P0393;  * game is being played, then force
       lda   $C87A;  * the "PLAYER X" string to be shown by
       lsra;         * setting the 'change player' counter
       bne   P0393;
       clr   $C88B;  * Set 'change player' loop counter.
       dec   $C88B;
P0393: rts;
P0394: jmp   P040A;

* Draw the energy bomb on one of the rings
P0397: clr   $C824;  * Temporarily disable reset of 0ref.
       stx   $C880;  * Save pointer to vector list.
       ldb   #$CE;
       stb   <$0C;
       ldy   #$C8F3; * Addr of ring line patterns.
       ldx   #$C932; * Addr of xformed ring vectors.
       lsra;
       lsra;          * Use lower 4 bits of the bomb state
       lsra;          * to determine which ring the bomb
       sta   $C885;   * is on, & then point 'y' to the
P03AE: beq   P03B8;   * patterns for the ring, and 'x'
       leay  10,y;    * to the vector list for the ring.
       leax  $12,x;
       deca;
       bra   P03AE;
P03B8: lda   ,y;      * Use the ring's scale factor.
       sta   <$04;
       sta   $C882;
       lda   -3,u;    * Determine which ring section to
       anda  #$07;   * put the energy bomb on.
       sta   $C883;
       sta   $C884;
P03C9: jsr   move_to_pt;
       dec   $C883;   * Move to starting point for section.
       bge   P03C9;
       lda   $C882;
       lsra;
       sta   <$04;    * Now, move to center of section.
       jsr   move_to_pt;
       ldx   $C880;
       inc   $C824;   * Draw the energy bomb here.
       ldb   #$0B;
       jsr   drawl1b;
       ldx   #$C8ED;
       lda   $C885;
P03EB: deca;          * Now, determine what the (y,x)
       blt   P03F2;   * position is of this energy bomb.
       leax  2,x;
       bra   P03EB;
P03F2: ldb   ,x;
       lda   #$C8;
       tfr   a,dp;
       lda   <$84;
P03FA: addb  #$08;
       deca;
       bge   P03FA;
       lda   <$82;
       jsr   convert_abs_angle_to_rise_run;
P0404: std   -13,u;   * Save the calculated position.
       lda   #$D0;
       tfr   a,dp;
P040A: leau  $20,u;  * Process the next energy bomb
       cmpu  #$C9B8; * entry, until no more left.
       lbls  P031F;
* END OF THE ENERGY BOMB PROCESSING LOOP

       jsr   intensity_to_7F;
       lda   $C88C;
       beq   P0447;
       cmpa  #$FF;
       bne   P0421;

* Display "GAME OVER PLAYER 1/2"
P0421: ldd   #$F950;  * Set height & width of string.
       std   $C82A;
       ldu   #game_over;
       jsr   print_with_dft_hw;
       ldu   #player1;
       ldx   #$C8AC;  * Determine if player 1 or 2.
       lda   -15,x;
       beq   P043A;
       ldu   #player2;
P043A: jsr   print_with_dft_hw;
       dec   $C88C;
       lbne  display_scores;
       lbra  display_scores;

* Prepare for the next player to start playing
P0447: lda   $C88E;  * Skip if energy cannon exploding.
       bne   display_scores;
       lda   $C88B;  * Display "PLAYER X" only if (while)
       beq   display_scores; * loop counter != 0.
       cmpa  #$FF;
       bne   P046A;
       jsr   change_player; * Backup dead players info.
       ldx   #$C8AC;
       lda   $C8DC;  * Get pointer to data area for
       beq   P0463;  * the next player.
       ldx   #$C8CC;
P0463: lda   -15,x;  * If new player has no ships, then go
       bgt   P046A;  * back to the user who just died.
       jsr   change_player;
P046A: ldd   #$F950;
       std   $C82A;  * Display "PLAYER X" string.
       ldu   #player1;
       lda   $C8DC;
       beq   P047B;
       ldu   #player2;
P047B: jsr   print_with_dft_hw;
       dec   $C88B;
       beq   display_scores;  * Decr the 'change player'
       dec   $C88B;  * counter.  Stop displaying "PLAYER X"
       bra   display_scores;  * string when it decrs to 0.

* Display "GAME OVER" & see if user wants a new game
P0488: jsr   intensity_to_7F;
       ldd   #$F950;  * Set height & width of string.
       std   $C82A;
       ldu   #game_over2;
       ldd   #$00D0;  * Position for displaying string.
       jsr   move_pen7F_to_d;
       jsr   display_string;

       lda   $C879;   * Force both players scores to
       beq   P04A7;   * be displayed.
       lda   #$02;
       sta   $C87A;
P04A7: dec   $C88A;
       bne   P04B9;
       inc   $C88A;
       lda   $C811;  * Restart new game if either button
       anda  #$77;  * 1, 2 or 3 is pressed on either
       beq   P04B9;  * console.
       jmp   restart_game;

* If a new game is not eventually started, go to OS ROM
P04B9: lda   $C826;
       lsra;                 * Everyother pass thru loop
       bhs   display_scores; * decr counter; if it goes
       dec   $C88D;          * to 0, then pass control
       bne   display_scores; * back to OS ROM.
       jmp   start_of_OS_ROM;


* Display the individual or simultaneous player scores
display_scores:
       ldd   #$FC47; * Set height & width of string.
       std   $C82A;
       lda   $C879;   * Determine if both player's scores
       beq   display_player1_score;* are to be displayed
       lda   $C87A;   * (simul play) or if only a single
       lsra;          * players score is to be displayed.
       bne   display_player2_score;
       lda   $C8DC;   * C8DC says who's turn it is.
       beq   display_player1_score;

* Display player 2's score
display_player2_score:
       ldd   #$7F80;  * Position of score string.
       jsr   move_pen7F_to_d;
       ldu   #$C8D0;  * Addr of player 2's score string.
       jsr   display_string;

* Display player 2's ship count
       jsr   init_ship_count_buffer;
       lda   $C8BD;    * Get the ship count.
       jsr   fill_ship_count_buffer;
       ldu   #$C932;  * Addr of ship count buffer.
       ldd   #$FD30;  * Height & width to use.
       std   $C82A;
       ldd   #$6F90;  * Position for displaying.
       jsr   print_at_d;

       lda   $C87A;  * Display player 1's score only if
       lsra;         * game is over, or simultaneous play.
       beq   P0531;

* Display player 1's score
display_player1_score:
       ldd   #$7F20;  * Position for displaying.
       jsr   move_pen7F_to_d;
       ldu   #$C8B0;  * Addr of player 1's score string.
       ldd   #$FC47;  * Height & width to use.
       std   $C82A;
       jsr   display_string;

* Display player 1's ship count
       jsr   init_ship_count_buffer;
       lda   $C89D;    * Get the ship count.
       jsr   fill_ship_count_buffer;
       ldu   #$C932;  * Addr of ship count buffer.
       ldd   #$FD30;  * Height & width to use.
       std   $C82A;
       ldd   #$6F20;  * Position for displaying.
       jsr   print_at_d;

* Make game sounds
P0531: jsr   dptoC8;
       jsr   make_game_sounds;

* Don't process joystick or buttons if game is over
       lda   <$8D;
       lbne  P00D3;

* Read joystick and buttons, for player 1
       ldu   #$C8AC;
       lda   <$11;    * Get console 1 button states.
       ldb   <$1B;    * Get joystick 1 state.
       beq   P054E;
       bmi   P054C;
       ora   #$02;   * Convert joystick movements
       bra   P054E;   * into button presses, to make
P054C: ora   #$01;   * processing easier.
P054E: sta   -5,u;    * Save user 1's button states.

* Read joystick and buttons, for player 2
       lda   <$11;    * Get console 1 button states.
       ldb   <$1B;    * Get joystick 1 state.
       tst   <$7A;
       beq   P055E;   * If simultaneous play, then use
       lsra;          * the buttons on console 2 and
       lsra;          * and read the joystick state on
       lsra;          * console 2 also.
       lsra;
       ldb   <$1D;
P055E: tstb;
       beq   P0569;
       bmi   P0567;   * Convert joystick movements to
       ora   #$02;   * button presses, to help make
       bra   P0569;   * processing easier.
P0567: ora   #$01;
P0569: sta   $1B,u;  * Save player 2's button states.

* Once a player is dead, delay awhile before restarting him
P056C: lda   -3,u;
       bpl   P05A7;
       lda   -15,u;   * Check the user's ship count.
       lbeq  P0682;
       dec   -1,u;    * Reset player's data area once
       beq   P058F;   * the restart counter goes to 0.
       dec   -1,u;
       beq   P058F;
       lda   -1,u;
       cmpa  #$F0;
       lbhi  P0682;
       lda   <$90;
       ora   #$02;
       sta   <$90;
       jmp   P0682;

* Reset the data area for this user
P058F: clr   -3,u;
       ldx   #$1070; * Player 1 initial position.
       lda   #$10;   * Player 1 rotation value.
       cmpu  #$C8CC; * Is this player 2?
       blo   P05A1;
       ldx   #$E090; * Player 2 initial position.
       lda   #$30;   * Player 2 rotation value.
P05A1: stx   -13,u;   * Set cruiser's position.
       sta   -16,u;   * Set cruiser's rotation.
       clr   -6,u;
P05A7: lda   #$FF;
       sta   -1,u;

* Process the button states now
* Check for rotate left command
       lda   -5,u;
       bita  #$01;   * If button 1 was pressed, then
       beq   P05B3;   * rotate the cruiser to the left.
       inc   -16,u;

* Check for rotate right command
P05B3: bita  #$02;   * If button 2 was pressed, then
       beq   P05B9;   * rotate the cruiser to the right.
       dec   -16,u;

* Check for a bullet fire request
P05B9: bita  #$08;   * If button 4 was pressed, then
       beq   P05FE;   * search the bullet buffer for an
       ldb   <$8E;    * available spot.
       orb   <$8F;
       bne   P05FE;   * Ignore, if energy cannon destroyed.
       ldx   <<0,u;
P05C5: ldb   <<0,x;     * Find an available spot in buffer.
       beq   P05D1;
       leax  11,x;
       cmpx  2,u;
       bne   P05C5;
       bra   P05FE;
P05D1: lda   <$90;
       ora   #$20;
       sta   <$90;
       ldd   -14,u;  * Use ship's y position as bullet's
       std   5,x;    * initial y position.
       ldd   -12,u;  * Use ship's x position as bullet's
       std   7,x;    * initial x position.
       ldb   -16,u;  * Calculate rise & run for the bullet.
       lda   #$7F;
       jsr   convert_angle_to_rise_run;
       std   <$85;
       ldb   <$85;
       jsr   mult_rise_run_by_9;
       std   1,x;    * Save the rise.
       ldb   <$86;
       jsr   mult_rise_run_by_9;
       std   3,x;    * Save the run.
       lda   #$30;
       sta   9,x;    * Set bullet's life span value.
       com   <<0,x;    * Flag that buffer spot is in use.

* Check for a thrust request
       lda   -5,u;
P05FE: bita  #$04;  * If button 3 was pressed, then
       beq   P0621;  * update the cruiser's velocity, and
       lda   <$90;   * update the cruiser's position.
       ora   #$04;
       sta   <$90;   * Force a ship movement sound.
       lda   -6,u;
       cmpa  #$0F;
       bhs   P0621;
       inc   -6,u;   * Increment cruisers velocity.
       ldb   <$26;
       lsrb;
       lsrb;
       bhs   P0618;
       inc   -6,u;
P0618: ldb   -16,u;  * Calulate new rise & run values.
       lda   #$7F;
       jsr   convert_angle_to_rise_run;
       std   -9,u;
P0621: lda   <$26;   * Decrement velocity every so ofter.
       bita  #$03;
       bne   P0629;
       dec   -6,u;

* Modify cruiser position, if velocity > 0
P0629: lda   -6,u;   * Calculate new y position.
       ble   P0680;
       lsra;
       ldb   -9,u;
       jsr   mult_rise_run_by_a;
       ldd   -14,u;  * Multiply velocity* rise, and
       exg   a,b;    * add it to old y position.
       addd  <$80;
       exg   a,b;
       std   -14,u;  * Save new y position.
       lda   -6,u;   * Calculate new x position.
       ldb   -8,u;
       lsra;
       jsr   mult_rise_run_by_a;
       ldd   -12,u;  * Multiply velocity* run, and
       addd  <$80;   * add it to old x position.
       std   -12,u;  * Save new x position.

* See if the cruiser is trying to enter the ring area
       ldd   -13,u;
       jsr   get_absolute_value_of_ab;
       std   <$80;
       ldb   <$80;    * Calculate x*x + y*y.
       mul;
       std   <$82;
       lda   <$81;
       ldb   <$81;
       mul;
       addd  <$82;    * Compare absolute ship position
       cmpd  #$0384; * to the outer ring dimensions.
       bhi   P0682;

* Cruise has attempted to enter ring area; turn it around
       ldd   -13,u;  * Calc angle of cruiser from origin.
       jsr   convert_rise_run_to_angle;
       subb  #$0A;  * Convert angle to Vectrex reference.
       stb   -16,u;  * Set new angle for cruiser.
       lda   #$7F;
       jsr   convert_angle_to_rise_run;
       std   -9,u;   * Save rise & run deltas.
       lda   #$06;
       sta   -6,u;   * Force velocity to 6.
       lda   <$90;
       ora   #$10;  * Force a sound.
       sta   <$90;
       bra   P0682;

* Force ships velocity to 0
P0680: clr   -6,u;

* See if the fireball has hit a star cruiser
P0682: ldx   -13,u;
       lda   -3,u;
       bmi   P06F8;
       lda   <$E1;
       bpl   P069A;
       ldy   <$E7;   * Fireball position.
       lda   <$E0;   * Use scale* 2 as the size
       ldb   <$E0;   * of the fireball.
       lsra;
       lsrb;
       jsr   check_bullet_for_hit;
       blo   P06C5;

* Check to see if an energy bomb has hit a star cruiser
P069A: pshs  u;
       ldu   #$C978;  * Addr of energy bomb buffer.
P069F: lda   -3,u;
       bita  #$20;
       beq   P06B0;
       ldy   -13,u;    * Position of energy bomb.
       ldd   #$0404;
       jsr   check_bullet_for_hit;
       blo   P06BD;    * Branch, if a hit.
P06B0: leau  $20,u;   * Check next energy bomb.
       cmpu  #$C9B8;  * Stop, when last bomb checked.
       bls   P069F;
       puls  u;
       bra   P06F8;

* Star cruiser was hit by an energy bomb
P06BD: lda   #$C0;
       sta   -3,u;
       puls  u;
       bra   P06C7;
P06C5: sta   <$E1;   * Force explosion at fireball (y,x).
P06C7: com   -3,u;   * Flag player as dead.
       lda   <$90;
       ora   #$80;  * Force an explosion sound.
       sta   <$90;
       lda   #$02;
       sta   <$9B;
       dec   -1,u;   * Set the restart timer.
       dec   -15,u;  * Decrement players cruiser count.
       bne   P06F1;
       pshs  u;      * Game over for this player, so see
       leax  4,u;    * if his score is a new hi score.
       ldu   #$CBEB;
       jsr   check_4_new_hi_score;
       puls  u;
       lda   <$79;
       beq   P06F1;  * If neither player has any cruisers
       lda   <$9D;   * left, then flag that the game is
       ora   <$BD;   * over.
       beq   P06F1;
       dec   <$8C;
P06F1: ldx   <<0,u;    * Clear out users bullet buffer.
       ldb   #$2B;
       jsr   clear_blockxb;
P06F8: leau  $20,u; * Process next player.
       cmpu  #$C8CC;
       lbls  P056C;


* START OF ENERGY BOMB STATE AND POSITION PROCESSING LOOP
* Update the position and states of all energy bombs
       lda   <$AB;
       sta   <$95;    * Determine which player has the
       lda   <$CB;    * slower ring rotation delta.
       cmpa  <$95;    * Save it in C895.
       bhi   P070F;
       sta   <$95;
P070F: lda   <$7A;    * If not simultaneous play, then
       lsra;          * determine who the next player is
       bne   P0722;   * and set up his restart counter.
       ldx   #$C8AC;
       lda   <$DC;
       bne   P071E;
       ldx   #$C8CC;
P071E: lda   #$FF;   * Restart counter is set here.
       sta   -1,x;
P0722: ldx   #$C978;
       lda   <$8E;    * Make sure the game is not in
       ora   <$8F;    * the middle of setting up a
       beq   P072E;   * new level.
       jmp   P0912;

* Determine state of energy bomb, and handle accordingly
P072E: lda   -3,x;
       lbmi  P08C2;   * Bomb is not in use.
       cmpa  #$17;
       lbls  P08E2;   * Bomb is still on a ring.

* Energy bomb is moving; so draw it towards a cruiser
       ldd   -13,x;
       ASRA;
       asrb;
       std   <$80;
       ldd   <$9F;    * Determine the delta between player
       ASRA;          * 1's cruiser, and the energy bomb.
       asrb;
       suba  <$80;
       subb  <$81;
       std   <$82;
       ldd   <$BF;    * Determine the delta between player
       ASRA;          * 2's cruiser, and the energy bomb.
       asrb;
       suba  <$80;
       subb  <$81;
       std   <$84;
       lda   <$A9;    * If both players are dead, then
       bita  <$C9;    * draw the energy bomb back towards
       bpl   P0762;   * the rings.
       ldd   <$80;
       nega;
       negb;
       std   <$82;
       bra   P079A;

* The following block is for simultaneous play only
* Determine which cruiser is closer to the energy bomb
P0762: tsta;
       bmi   P0796;   * See if player 1 is alive.
       lda   <$C9;
       bmi   P079A;   * See if player 2 is alive.
       ldd   <$82;
       jsr   get_absolute_value_of_ab;
       std   <$80;
       ldb   <$80;
       mul;
       std   <$86;
       lda   <$81;
       ldb   <$81;
       mul;
       addd  <$86;
       std   <$86;
       ldd   <$84;
       jsr   get_absolute_value_of_ab;
       std   <$80;
       ldb   <$80;
       mul;
       std   <$88;
       lda   <$81;
       ldb   <$81;
       mul;
       addd  <$88;
       cmpd  <$86;
       bhi   P079A;
P0796: ldd   <$84;    * Use player 2's position.
       std   <$82;

* Determine the angle between energy bomb & cruiser
P079A: ldd   <$82;
       jsr   convert_rise_run_to_angle;
       sta   <$80;
       lda   -16,x;
       anda  #$3F;
       suba  <$80;
       sta   <$81;
       jsr   get_absolute_value_of_ab;
       anda  #$3F;
       sta   <$82;
       sta   <$83;
       nega;
       anda  #$3F;
       cmpa  <$82;
       bhs   P07BB;
       sta   <$82;

* If small delta, then aim bomb at cruiser
P07BB: lda   $C930;
       cmpa  <$82;    * If delta is < ring rotation,
       blo   P07C8;   * set energy bombs angle of travel
       lda   <$80;    * equal to delta angle.
       sta   -16,x;
       bra   P07E2;

* If large delta, then gradually draw bomb towards cruiser
P07C8: lda   #$20;
       cmpa  <$81;   * If delta is > ring rotation,
       bls   P07D8;  * draw the energy bomb towards
       ldd   -16,x;  * the cruiser, by modifying its
       subd  $C930;  * angle of travel by +- the ring
       subd  $C930;  * rotation delta.
       bra   P07E0;
P07D8: ldd   -16,x;
       addd  $C930;
       addd  $C930;
P07E0: std   -16,x;

* Now, update position, and position delta for the bomb
P07E2: lda   $C931;
       coma;
       sta   -4,x;
       lda   #$3F;
       ldb   -16,x;  * Calculate rise & run.
       jsr   convert_abs_angle_to_rise_run;
       std   -9,x;
       lda   $C931;  * Scale rise & run by ring rotation
       lsra;         * value; as ring rotates faster, the
       lsra;         * energy bombs will also travel
       lsra;         * faster.
       lsra;
       sta   <$86;
       jsr   mult_rise_run_by_a;
       ldd   -12,x;  * Update the x position, and check
       addd  <$80;   * for screen wrap.
       lbvs  P08C2;
       std   -12,x;
       lda   <$86;
       ldb   -9,x;
       jsr   mult_rise_run_by_a;
       ldd   -14,x;  * Update the y position, and check
       exg   a,b;    * for screen wrap.
       addd  <$80;
       lbvs  P08C2;
       exg   a,b;
       std   -14,x;

* If bomb is back in ring area, then reattach it
       ldd   -13,x;
       jsr   get_absolute_value_of_ab;
       std   <$86;
       ldb   <$86;
       mul;
       std   <$84;
       lda   <$87;
       ldb   <$87;
       mul;
       addd  <$84;
       std   <$84;
       cmpd  #$0384; * See if the bomb is within the
       blo   P084C;   * confines of the center ring area.
       dec   <<0,x;
       beq   P0848;   * If bomb is still moving, then make
       lda   <$90;    * a sound, and decrement it's life
       ora   #$08;   * span counter.
       sta   <$90;
       lda   #$20;   * Flag that bomb is still moving.
P0843: sta   -3,x;
       jmp   P0908;

* Flag that bomb is no longer in use; lifespan expired
P0848: lda   #$80;
       bra   P0843;

* Determine which ring to attach energy bomb to
P084C: ldu   #$C8F3;
       ldy   #$C8ED;
       clr   <$80;
P0855: lda   ,u;   * Determine if the energy bomb is
       deca;       * within the confines of the ring
       tfr   a,b;  * being checked.
       mul;
       cmpd  <$84;
       blo   P08B0;
       lda   ,u;
       suba  #$08;
       tfr   a,b;
       mul;
       cmpd  <$84;
       bhi   P08B0;

* Determine which ring section to energy attach bomb to
       ldd   -13,x;
       jsr   convert_rise_run_to_angle;
       suba  ,y;
       lsra;
       lsra;
       anda  #$0F;
       pshs  x;
       ldx   #$0F45;
       lda   a,x;

* Determine if this section still exists.
       leax  $1E,u;
       ldb   a,u;
       orb   a,x;
       puls  x;
       beq   P08B0;

* See if any other bomb is already on this section
       suba  #$02;
       ora   <$80;
       sta   <$81;
       ldb   $C975;   * Check bomb 1.
       andb  #$1F;
       cmpb  <$81;
       beq   P08B0;
       ldb   $C995;   * Check bomb 2.
       andb  #$1F;
       cmpb  <$81;
       beq   P08B0;
       ldb   $C9B5;   * Check bomb 3.
       andb  #$1F;
       cmpb  <$81;
       beq   P08B0;
       sta   -3,x;    * Available; place bomb here.
       clr   <<0,x;
       bra   P0908;

* Section not available or occupied, so check next ring
P08B0: lda   <$80;
       adda  #$08;
       sta   <$80;
       leau  10,u;
       leay  2,y;
       cmpy  #$C8F1;
       bls   P0855;
       bra   P0908;

* See if we need to start up another energy bomb
P08C2: lda   -3,x;
       bita  #$40;
       bne   P0908;
       dec   <$EB;  * Decrement reseed counter.
       bne   P0908; * Restart new bomb when it goes to 0.
       ldb   $C931;
       lsrb;
       stb   <$EB;  * Reset the reseed counter.
       lda   #$20;
       sta   -3,x;  * Flag bomb state as 'moving'.
       lda   <$DE;
       sta   -16,x; * Use energy cannons angle.
       clra;
       clrb;
       std   -13,x; * Start bomb from origin.
       sta   <<0,x;   * Clear lifespan.
       bra   P0908;

* See if time to force energy bomb off a ring
P08E2: ldu   #$C8F3;
       lsra;        * Use state/8 to determine which
       lsra;        * ring energy bomb is attached to.
       lsra;
P08E8: beq   P08EF;
       leau  10,u;
       deca;
       bra   P08E8;
P08EF: leau  2,u;   * If the ring no longer exists, or if
       leay  $1E,u;* the 'time to move' counter has gone
       lda   -3,x;  * to 0, then force the energy bomb to
       anda  #$07; * start moving outwards, until it
       ldb   a,y;   * hits a cruiser, or comes within the
       orb   a,u;   * confines of another ring.
       beq   P0902;
       dec   -4,x;  * Update 'time to move' counter.
       bne   P0908;
P0902: lda   -3,x;
       ora   #$20; * Force energy bomb to start moving.
       sta   -3,x;
P0908: leax  $20,x;  * Advance pointer to next energy
       cmpx  #$C9B8; * bomb.  Stop when last on processed.
       lbls  P072E;
* END OF ENERGY BOMB STATE & POSITION PROCESSING LOOP

* Determin the confines of a given ring
P0912: ldy   #$C8F3; * Ptr to ring line patterns.
       ldx   #$C8ED; * Addr of ring 1 rotation value.
       clr   <$91;
       lda   <$8E;
       ora   <$8F;
       lbne  P0A40;
       lda   <$90;
       ora   #$01;
       sta   <$90;
P0929: lda   ,y;
       deca;
       tfr   a,b;
       mul;
       std   <$80;
       lda   ,y;
       suba  #$08;
       tfr   a,b;
       mul;
       std   <$82;

* Check each bullet for a hit on the energy cannon
       ldu   #$C9C8; * Addr of player 1's bullet buffer.
P093D: lda   <<0,u;     * See if bullet is active.
       lbpl  P0A2B;
       pshs  x,y;
       ldx   6,u;     * Bullet's position.
       ldy   #$0000; * Energy cannon's position.
       ldd   #$0303; * Size of energy cannon.
       jsr   check_bullet_for_hit;
       puls  x,y;
       bhs   P0983;

* Energy cannon destroyed by a bullet
       lda   #$80;   * Energy cannon destroyed.
       sta   $C975;   * Disable energy bomb 1.
       sta   $C995;   * Disable energy bomb 2.
       sta   $C9B5;   * Disable energy bomb 3.
       ora   <$90;
       sta   <$90;    * Force an explosion sound.
       lda   #$02;
       sta   <$9B;
       dec   <$8E;    * Flag energy cannon is exploding.
       clr   <<0,u;     * Flag that bullet no longer in use.
       lda   $C931;   * Slightly increase ring rotation
       adda  #$10;   * value.
       blo   P0976;
       sta   $C931;
P0976: ldd   #$1400; * Score a cannon hit for the player.
       jsr   update_players_score;
       leax  -4,x;
       inc   -15,x;   * Give the player another cruiser.
       jmp   P0A85;

* See if the bullet hit one of the energy bombs
P0983: pshs  y;
       ldy   #$C978; * Addr of energy bomb buffer.
P0989: lda   -3,y;
       bita  #$20;
       beq   P09A0;
       pshs  x,y;
       ldx   6,u;     * Position of bullet.
       ldy   -13,y;   * Position of energy bomb.
       ldd   #$0202; * Size of energy bomb.
       jsr   check_bullet_for_hit;
       puls  x,y;
       blo   P09AD;
P09A0: leay  $20,y;  * Check next energy bomb.
       cmpy  #$C9B8;
       bls   P0989;
       puls  y;
       bra   P09C1;

* Energy bomb was destroyed by a bullet
P09AD: lda   #$80;
       sta   -3,y;   * Flag bullet no longer in use.
       ora   <$90;
       sta   <$90;   * Force an explosion sound.
       lda   #$03;
       sta   <$9B;
       lda   #$01;  * Force an explosion pattern to be
       sta   <<0,u;    * displayed at bullet's position.
       puls  y;
       bra   P0A2B;

* See if the bullet hit a wall section
P09C1: ldd   6,u;
       jsr   get_absolute_value_of_ab;
       stb   <$86;
       tfr   a,b;    * See if the bullet is within the
       mul;          * confines of a ring.
       std   <$84;
       lda   <$86;
       ldb   <$86;
       mul;
       addd  <$84;
       cmpd  <$80;
       bhi   P0A2B;
       cmpd  <$82;
       blo   P0A2B;

* Determine which section of the wall we are at
       ldd   6,u;     * Bullet position.
       jsr   convert_rise_run_to_angle;
       suba  ,x;
       lsra;
       lsra;
       anda  #$0F;
       pshs  x;
       ldx   #$0F45;
       lda   a,x;

* Determine if this section exists or is already destroyed
       leax  $1E,y;
       ldb   a,y;
       orb   a,x;
       beq   P0A29;

* Add value of wall section to players score
       pshs  a,x;
       ldx   #$C8F3; * Addr of ring pattern arrays.
       ldb   #$10;   * Value of outer wall section.
       lda   ,y;
P0A02: cmpa  ,x;      * This loop calculates the value
       bhs   P0A08;   * of the wall section hit.
       addb  #$10;
P0A08: leax  10,x;
       cmpx  #$C908;
P0A0D: blo   P0A02;
       clra;
       jsr   update_players_score;
       puls  a,x;
       clr   <<0,u;  * Flag bullet no longer in use.
       clr   a,y;  * Clear pattern for section hit(0 hit).
       com   a,x;  * Clr/set pattern 4 section hit(1 hit).
       bne   P0A29;
       inc   <<0,u;
       lda   #$80; * Section destroyed, so force an
       ora   <$90;  * explosion sound. (hit 2 times)
       sta   <$90;
       lda   #$03;
       sta   <$9B;
P0A29: puls  x;

P0A2B: leau  11,u;    * Advance ptr to next bullet.
       cmpu  #$CA20; * Stop when last bullet processed.
       lblo  P093D;
       leay  10,y;    * Get ptr to next ring's patterns.
       leax  2,x;     * Get ptr to next ring's rotation.
       cmpx  #$C8F1; * Stop when last ring processed.
       lbls  P0929;

* A certain amount of time after the energy cannon was
* destroyed, reset the ring scale/pattern structure
P0A40: lda   #$20;
       cmpa  <$8F;
       blo   P0A85;
       bhi   P0A4B;
       jsr   init_ring_scale_factors;

* See if we need to expand the inner walls
P0A4B: ldx   #$C8F3; * Search the scale/pattern array,
       lda   #$1E;   * and find out which entry is for
       cmpa  ,x;      * the outermost wall; it will have
       beq   P0A60;   * a scale factor of $1E.  The 'x'
       leax  10,x;    * register will point to the entry
       cmpa  ,x;      * once it is found.
       beq   P0A60;
       leax  10,x;
       cmpa  ,x;
       bne   P0A85;

P0A60: leax  2,x;     * Skip over the scale factor and the
       leau  $1E,x;  * first line pattern for this ring.
       ldb   #$07;
P0A67: lda   b,x;     * This loop counts the number of
       ora   b,u;     * visible sections still left on
       beq   P0A6F;   * the outermost ring.  The number
       inc   <$91;    * of visible sections is saved in
P0A6F: decb;          * C891.
       bge   P0A67;

       lda   <$91;    * See if any sections were left.
       bne   P0A85;   * Branch, if sections are still left.
       lda   #$06;   * Set up a new scale factor for this
       sta   -2,x;    * ring (6), and make it the inner
       sta   -2,u;    * most ring.
       lda   #$FF;   * Reset all the line patterns for
       ldb   #$07;   * this ring to $FF.
       jsr   clear_block_to_a;
       sta   <$EC;    * Set the 'wall expanding' flag.

* Update rotation value, so each ring rotates faster
P0A85: ldd   $C930;
       addd  <$F1;    * Update rotation for ring 1.
       std   <$F1;
       ldd   $C930;
       coma;
       comb;
       addd  <$EF;    * Update rotation for ring 2.
       std   <$EF;
       ldd   $C930;
       aslb;
       rola;
       addd  <$ED;    * Update rotation for ring 3.
       std   <$ED;
       lda   <$26;    * Expand rings everyother pass.
       lsra;
       bhs   P0AD1;

* Continue expanding rings, if necessary
       ldb   <$EC;   * If the 'expanding wall' flag
       beq   P0AD1;  * (C8EC) is set, then increment the
       lda   #$1E;  * scale factor for each of the 3
       ldx   #$C8F3;* rings, until the outermost one
       inc   ,x;     * has a scale actor of $1E; at
       inc   $1E,x; * that point, clear the 'expanding
       cmpa  ,x;     * wall' flag.
       bne   P0AB7;
       clr   <$EC;
P0AB7: leax  10,x;   * Increment the scale for the
       inc   ,x;     * next ring.
       inc   $1E,x;
       cmpa  ,x;
       bne   P0AC4;
       clr   <$EC;   * Clear the 'expanding walls' flag.
P0AC4: leax  10,x;   * Increment the scale for the
       inc   ,x;     * next ring.
       inc   $1E,x;
       cmpa  ,x;
       bne   P0AD1;
       clr   <$EC;   * Clear the 'expanding walls' flag.

P0AD1: lda   <$8E;  * Don't continue, if the energy cannon
       lbne  P00D3; * is being destroyed, or a new screen
       lda   <$8F;  * is being displayed.
       beq   P0AE0;
       dec   <$8F;
       jmp   P00D3;


* Have the energy cannon track one of the cruiser
P0AE0: ldd   <$9F;   * Player 1 cruiser position.
       jsr   convert_rise_run_to_angle;
       sta   <$80;
       ldd   <$BF;   * Player 2 cruiser position.
       jsr   convert_rise_run_to_angle;
       sta   <$81;
       lda   <$DE;  * Determine angle delta between
       anda  #$3F; * cannon and cruiser 1.
       suba  <$80;
       anda  #$3F;
       sta   <$82;
       lda   <$DE;  * Determine angle delta between
       anda  #$3F; * cannon and cruiser 2.
       suba  <$81;
       anda  #$3F;
       ldb   <$A9;  * If game is over, then just rotate
       bitb  <$C9;  * cannon around.
       bpl   P0B0C;
       lda   #$05;
       sta   <$82;
       bra   P0B1F;

* Determine which cruiser to track
P0B0C: tstb;        * One player is dead, so determine
       bne   P0B17; * which one is still alive, so we
       ldb   <$C9;  * can track him.
       bne   P0B1D;
       cmpa  <$82;
       bgt   P0B1D;
P0B17: sta   <$82;
       lda   <$81;
       bra   P0B1F;
P0B1D: lda   <$80;

* Determine how to track one of the cruiser
P0B1F: ldb   <$82;
       sta   <$80;
       jsr   get_absolute_value_of_ab;
       andb  #$3F;
       stb   <$81;
       stb   <$83;
       negb;
       andb  #$3F;
       cmpb  <$81;
       bhs   P0B35;
       stb   <$81;

* Determine speed at which to track the cruiser
P0B35: lda   $C930;  * Ring rotation delta.
       cmpa  <$81;
       blo   P0B8F;
       lda   <$80;
       anda  #$3F;  * Small delta; so track quickly.
       sta   <$DE;

* See if opening exists in the 3 rings in front of cannon
       ldu   #$C8F3;* Addr of ring pattern array.
       ldx   #$C8ED;* Addr of ring 1 rotation value.
P0B48: lda   <$DE;
       suba  ,x++;
       lsra;
       lsra;
       anda  #$0F;  * Determine which segment of the
       ldy   #$0F45;* ring is faced by the cannon.
       lda   a,y;
       leay  $1E,u; * If both patterns are 0, then the
       ldb   a,u;    * segment is open.
       orb   a,y;
       bne   P0BA3;   * No opening exists.
       leau  10,u;    * Opening exists in this ring; go
       cmpx  #$C8F1; * check the next one also.
       bls   P0B48;

* Fire a fireball at one of the star cruisers
       lda   <$E1;
       bne   P0BA3;  * See if fireball is already in use.
       com   <$E1;
       clra;
       clrb;
       std   <$E6;   * Set initial y position to 0.
       std   <$E8;   * Set initial x position to 0.
       ldb   <$DE;
       lda   #$7F;
       jsr   convert_abs_angle_to_rise_run;
       std   <$85;
       ldb   <$85;
       jsr   mult_rise_run_by_9;
       std   <$E2;   * Save rise value.
       ldb   <$86;
       jsr   mult_rise_run_by_9;
       std   <$E4;   * Save run value.
       lda   #$06;
       sta   <$E0;   * Set initial scale factor.
       bra   P0BA3;

* Slowly turn energy cannon, to track a cruiser
P0B8F: lda   #$20;
       cmpa  <$82;   * If the delta between the cannon
       bls   P0B9C;  * and the cruiser is > the ring
       ldd   <$DE;   * rotation delta, then update the
       subd  $C930;  * cannons angle by the ring rotation
       bra   P0BA1;  * delta only; as this increases, so
P0B9C: ldd   <$DE;   * will the tracking speed of the
       addd  $C930;  * energy cannon.
P0BA1: std   <$DE;
P0BA3: jmp   P00D3;


* init_ring_scale_factors()
*
* This routine clears the scale/pattern buffer used
* to describe the 3 rings, and then sets the initial
* scale factors ($0E, $16, $1E) for each of the rings.
*
* The pattern buffer is 60 bytes long (6 x 10 bytes),
* and uses RAM locations C8F3-C92F.  The first 3 entries
* describe those ring sections which have no hits on them,
* while the second 3 entries describe those ring sections
* which have 1 hit on them (and are thus hi-lited).
*
* The format of the pattern buffer is as follows:
*
*    scale, < 9 line patterns>,     [Ring 1, no hits]
*    scale, < 9 line patterns>,     [Ring 2, no hits]
*    scale, < 9 line patterns>,     [Ring 3, no hits]
*    scale, < 9 line patterns>,     [Ring 1, 1 hit]
*    scale, < 9 line patterns>,     [Ring 2, 1 hit]
*    scale, < 9 line patterns>      [Ring 3, 1 hit]

init_ring_scale_factors:
       ldx   #$C8F3;  * Clear the pattern buffer.
       ldb   #$3C;
       jsr   clear_blockxb;
       ldx   #$C8F3;
       ldd   #$0E00;  * Set ring 1's scale factor.
       std   ,x;
       std   $1E,x;
       leax  10,x;
       ldd   #$1600;  * Set ring 2's scale factor.
       std   ,x;
       std   $1E,x;
       leax  10,x;
       ldd   #$1E00;  * Set ring 3's scale factor.
       std   ,x;
       std   $1E,x;
       sta   $28,x;
       rts;



* change_player()
*
* This routine is called after a players cruiser has
* been destroyed.  It will disable of of the energy
* bombs and bullets.  It will also save a copy of the
* dead players game information in his backup area.
* Lastly, it will switch the active player indicator
* (C8DC), and copy the other players game info out
* of his backup area and into the active player area.
* The info backed up and restored is the ring patterns
* and rotation values.

change_player:
       lda   #$80;
       sta   $C975;  * Disable energy bomb 1
       sta   $C995;  * Disable energy bomb 2
       sta   $C9B5;  * Disable energy bomb 3
       lda   $C88F;  * Re-init ring patterns, if energy
       beq   P0BE3;  * cannon was destroyed.
       bsr   init_ring_scale_factors;
P0BE3: clr   $C88F;
       ldx   #$C9C8; * Clear the bullet buffer.
       ldb   #$58;
       jsr   clear_blockxb;
       bsr   prepare_for_backup;
       stb   $C8DC;  * Save next player indicator.
       jsr   move_block2;
       bsr   prepare_for_backup;
       exg   u,x;
       jmp   move_block2;



* prepare_for_backup()
*
* This procedure initializes the 'a' register with the
* count of the number of bytes to backup, the 'u' register
* with the address of the active players ring pattern array,
* and the 'x' register with the address of the backup area
* associated with the player being backed up; C8DC indicates
* which player is being backed up.

prepare_for_backup:
       ldu   #$C8F3;  * Load 'u' w/ ptr to ring patterns.
       ldx   #$CA25;
       lda   #$3F;
       ldb   $C8DC;
       beq   P0C0D;
       ldx   #$CA64;
P0C0D: comb;           * Switch flag to show other user
P0C0E: rts;            * is now active.



* init_ship_count_buffer()
*
* Initialize the buffer used to display the number of
* ships left for a user to the following:
*
*   "   ",$80,$80,$80,$80,$80,$80,$80
*
* The buffer starts at C932

init_ship_count_buffer:
       ldx   #$C932;
       ldb   #$09;
       jsr   clear_block_to_0x80;
       lda   #$20;
       sta   ,x;
       sta   1,x;
       sta   2,x;
P0C1F: rts;



* fill_ship_count_buffer()
*
* Fill the ship count buffer with a little spaceship
* figure, one for each ship the user has left.  If he
* has more than 9 ships left, then display "X" instead
* of the spaceship.
*
* At entry:
*     'a' = number of ships.

fill_ship_count_buffer:
       ldb   #$68; * Code for small spaceship figure.
       cmpa  #$09;
       bls   P0C2A;
       lda   #$09;
       subb  #$10;  * Use "X" instead.
P0C2A: deca;
       ble   P0C1F;
       stb   ,x+;    * Fill the buffer.
       bra   P0C2A;



* mult_rise_run_by_9()
* mult_rise_run_by_a()
*
* This routine takes a rise or run value (in 'b')
* and either multiples it by 9 or by the value in
* the 'a' register.
*
* At entry:
*     'b' = rise or run value.
*     'a' = multiplier (for mult_rise_run_by_a only).
*
* At exit:
*     'd' contains the result of the multiplication,
*         and so does C880.

mult_rise_run_by_9:
       lda   #$09;
mult_rise_run_by_a:
       clr   <$83;
       tstb;
       bpl   P0C3A;
       inc   <$83;   * Keep track if value is negative.
P0C3A: jsr   get_absolute_value_of_ab;
       mul;
       std   <$80;
       lsr   <$83;
       bhs   P0C4B;
       coma;         * If the rise/run value was negative
       comb;         * then take twos complement, to make
       addd  #$0001;* the result negative also.
       std   <$80;
P0C4B: rts;


* draw_1_ring()
*
* This routine will draw one of the 3 rings (castle walls).
*
* At entry:
*     'x' points to (y,x) vector list for this ring.
*     'u' points to scale/pattern buffer for this ring.
*
* Drawing will cease when a pattern > 0 is encountered.

draw_1_ring:
       lda   #$CE;
       sta   <$0C;
       ldb   ,u+;    * Grab the scale factor.
       stb   <$04;
P0C54: ldd   ,x;     * Grab the vector endpoint.
       sta   <$01;
       clr   <$00;
       lda   ,u+;    * Grab the line pattern to use.
       leax  2,x;
       inc   <$00;
       stb   <$01;
       sta   <$0A;
       clr   <$05;
       ldd   #$0040;
P0C69: bitb  <$0D;
       beq   P0C69;
       nop;
       sta   <$0A;
       lda   ,u;     * Stop, when end of pattern list is
       ble   P0C54;  * reached (pattern > 0).
       jmp   check0ref;



* update_players_score()
*
* This routine takes a value, and adds it to the
* appropriate user's score string.
*
* At entry:
*     'd' contains the BCD value to be added to a score.
*     'u' points to bullet entry which scored a hit.
*
* The address of the bullet entry is used to determine
* whether to add the BCD value to player 1 or 2's score.

update_players_score:
       ldx   #$C8AC;
       cmpu  #$C9F4; * Determine which player to credit
       blo   P0C83;   * with the hit.
       ldx   #$C8CC;
P0C83: leax  4,x;     * Get addr of player's score string.
       jmp   add_d_to_x_in_bcd;



* make_game_sounds()
*
* This routine is responsible for making all of the
* sound associated with the game.  It uses a bit mask
* in C890 to decide which sounds to make at any given
* moment.

make_game_sounds:
       jsr   init_music_buf;
       clr   <$45;
       ldy   #$CAA3;
       ldu   #$0CE0;
       ldd   #$0380;
       std   <$96;
       lda   #$B1;
       anda  <$99;
       sta   <$99;
       lda   <$8D;
       sta   <$98;
       bne   P0CD9;
       lda   <$90;
       ora   <$99;
       sta   <$9A;
P0CAB: lda   <$97;
       anda  <$9A;
       beq   P0CD1;
       tfr   a,b;
       ora   <$98;
       sta   <$98;
       bitb  <$90;
       bne   P0CBF;
       andb  <$99;
       bne   P0CC7;
P0CBF: ldd   2,u;
       std   ,y;
       ldd   4,u;
       std   2,y;
P0CC7: jsr   [,u];* (UNKNOWN JUMP)
       lda   <$96;
       beq   P0CD9;
       lda   #$08;
       sta   <$46;
P0CD1: leau  7,u;
       leay  4,y;
       lsr   <$97;
       bne   P0CAB;
P0CD9: lda   <$98;
       sta   <$99;
       clr   <$90;
       rts;



* Table of sound routine addresses, and data
*
*     2 byte subroutine address.
*     5 bytes of data.

S0CE0: DW    $0DBF;
       DB    $00,$00,$00,$00,$FF;
       DW    $0D93;
       DB    $0A,$00,$0E,$08,$FF;
       DW    $0D6C;
       DB    $02,$80,$0C,$0B,$00;
       DW    $0D85;
       DB    $00,$90,$0E,$08,$FF;
       DW    $0D60;
       DB    $00,$90,$09,$00,$00;
       DW    $0D93;
       DB    $00,$00,$09,$00,$03;
       DW    $0D54;
       DB    $00,$90,$0C,$08,$00;
       DW    $0D18;
       DB    $08,$80,$0D,$60,$00;

P0D18: ldx   <$92;
       stx   ,y;
       pshs  u;
       lda   <$91;
       deca;
       anda  #$06;
       ldu   #$0DEE;
       ldd   a,u;
       cmpd  ,y;
       bhi   P0D33;
       clr   <$94;
       leax  -4,x;
       bra   P0D4C;
P0D33: subd  #$0080;
       cmpd  ,y;
       bhi   P0D46;
       lda   #$04;
       ldb   <$94;
       bmi   P0D42;
       nega;
P0D42: leax  a,x;
       bra   P0D4C;
P0D46: clra;
       coma;
       sta   <$94;
       leax  4,x;
P0D4C: stx   ,y;
       stx   <$92;
       puls  u;
       bra   P0D93;
P0D54: clra;
       ldb   <$95;
       ldx   #$0090;
       leax  d,x;
       stx   ,y;
       bra   P0D93;
P0D60: lda   <$26;
       anda  #$1E;
       ora   #$14;
       asla;
       asla;
       sta   1,y;
       bra   P0D93;
P0D6C: ldx   ,y;
       dec   3,y;
       beq   P0DB7;
       lda   3,y;
       cmpa  #$0A;
       bhs   P0D81;
       cmpa  #$07;
       bne   P0D7F;
       ldx   #$0080;
P0D7F: leax  10,x;
P0D81: stx   ,y;
       bra   P0D93;
P0D85: ldx   ,y;
       dec   3,y;
       beq   P0DB7;
       clra;
       sta   <$46;
       leax  $10,x;
       stx   ,y;
P0D93: ldx   #$C842;
       dec   <$96;
       lda   <$96;
       ldb   2,y;
       stb   a,x;
       asla;
       adda  #$05;
       leax  a,x;
       ldd   ,y;
       std   ,x;
       ldx   #$0DF6;
       lda   6,u;
       bmi   P0DB6;
       adda  <$96;
       lda   a,x;
       ora   <$45;
       sta   <$45;
P0DB6: rts;
P0DB7: lda   <$97;
       coma;
       anda  <$98;
       sta   <$98;
       rts;


P0DBF: lda   <$90;
       anda  <$97;
       beq   P0DC7;
       sta   <$67;
P0DC7: pshs  u;
       lda   #$03;
       sta   <$46;
       lda   <$9B;
       ldu   #$0DDE;             <--I original $0dde
;       ldu   #explosion_sound_data;$0DDE;             <--I original $0dde
       asla;                                             I seems to be wrong,
       asla;                                             I a bug in starcastle?
       leau  a,u;                                        I
       jsr   generate_explosion_sound;                   I
       clr   <$96;                                       I
       puls  u;                                          I
       lda   <$77; between this instruction is $0dde  <--I   malban <BUG?>
       beq   P0DB7;
       rts;

* Data describing the explosion sounds
; malban: here is $0de2
explosion_sound_data:
       DB    $38, $3F, $00, $01;
       DB    $19, $3F, $00, $02;
       DB    $38, $3F, $00, $10;

S0DEE: DB    $04;
       DB    $00;
       DB    $07;
       DB    $00;
       DB    $09;
       DB    $00;
       DB    $0A;
       DB    $00;

S0DF6: DB    $20;
       DB    $10;
       DB    $08;
       DB    $04;
       DB    $02;
       DB    $01;

star_castle_music:
       DW    $FEE8;
       DW    $FEB6;
       DB    $90;
       DB    $18;
       DB    $12;
       DB    $18;
       DB    $06;
       DB    $93;
       DB    $18;
       DB    $06;
       DB    $90;
       DB    $18;
       DB    $06;
       DB    $84;
       DB    $87;
       DB    $18;
       DB    $12;
       DB    $80;
       DB    $90;
       DB    $13;
       DB    $12;
       DB    $87;
       DB    $17;
       DB    $0C;
       DB    $85;
       DB    $15;
       DB    $06;
       DB    $84;
       DB    $8C;
       DB    $13;
       DB    $30;
       DB    $07;
       DB    $80;


* Vector list for player 1's star cruiser
star_cruiser1:
       DB    $1C,$F8;
       DB    $CE,$FC;
       DB    $1C,$08;
       DB    $DC,$E8;
       DB    $14,$1C;
       DB    $EC,$1C;
       DB    $24,$E8;
       DB    $E4,$08;
       DB    $32,$FC;


* Vector list for player 2's star cruiser
star_cruiser2:
       DB    $1C,$F8;
       DB    $CE,$FC;
       DB    $1C,$08;
       DB    $EC,$E8;
       DB    $F8,$0C;
       DB    $0C,$10;
       DB    $F4,$10;
       DB    $08,$0C;
       DB    $14,$E8;
       DB    $E4,$04;
       DB    $32,$FC;


* Vector list for the energy cannon
energy_cannon:
       DB    $04,$18;
       DB    $04,$E0;
       DB    $14,$F8;
       DB    $FC,$14;
       DB    $F4,$08;
       DB    $08,$DC;
       DB    $EC,$0C;
       DB    $EC,$F4;
       DB    $08,$24;
       DB    $F4,$F8;
       DB    $FC,$EC;
       DB    $14,$08;
       DB    $04,$20;


fireball:
       DB    $EC,$EC;
       DB    $30,$14;
       DB    $D0,$14;
       DB    $14,$D0;
       DB    $14,$30;
       DB    $D0,$EC;
       DB    $30,$EC;
       DB    $EC,$30;
       DB    $EC,$D0;



* Table of pointers to vector lists, having the
* following format:
*
*  line pattern, rel y, rel x,
*  line pattern, rel y, rel x,
*         .
*         .
*  $01
*
* These look like they are vector lists for the energy
* bombs.  By displaying these various patterns, you
* get the impression that the bomb is twinkling.

energy_bomb_VL_table:
       DW    $0E83;
       DW    $0E99;
       DW    $0EAF;
       DW    $0EC5;
       DW    $0EDB;
       DW    $0EF1;
       DW    $0F07;
       DW    $0F1D;


S0E83: DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$0C,$F4;
       DB    $FF,$04,$FC;
       DB    $01;

E99:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$0A,$06;
       DB    $FF,$0C,$08;
       DB    $01;

EAF:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$FE,$06;
       DB    $FF,$04,$0C;
       DB    $01;

EC5:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$FA,$08;
       DB    $FF,$04,$04;
       DB    $01;

EDB:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$F6,$06;
       DB    $FF,$F8,$04;
       DB    $01;

EF1:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$F4,$F8;
       DB    $FF,$FC,$08;
       DB    $01;

F07:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$F4,$F4;
       DB    $FF,$F8,$F8;
       DB    $01;

F1D:   DB    $FF,$0A,$F6;
       DB    $00,$00,$14;
       DB    $FF,$EC,$EC;
       DB    $00,$00,$14;
       DB    $FF,$0A,$F6;
       DB    $00,$06,$F4;
       DB    $FF,$FC,$FC;
       DB    $01;


* Vector list for a ring (castle wall)
ring:
       DB    $28,$64;
       DB    $3C,$C4;
       DB    $00,$B0;
       DB    $C4,$C4;
       DB    $B0,$00;
       DB    $C4,$3C;
       DB    $00,$50;
       DB    $3C,$3C;
       DB    $50,$00;


S0F45: DB    $09;
       DB    $02;
       DB    $02;
       DB    $03;
       DB    $03;
       DB    $04;
       DB    $04;
       DB    $05;
       DB    $05;
       DB    $06;
       DB    $06;
       DB    $07;
       DB    $07;
       DB    $08;
       DB    $08;
       DB    $09;


explosion_star:
       DB    $FF,$40,$00;
       DB    $00,$C0,$00;
       DB    $FF,$00,$40;
       DB    $00,$00,$C0;
       DB    $FF,$C0,$00;
       DB    $00,$40,$00;
       DB    $FF,$00,$C0;
       DB    $00,$00,$40;
       DB    $FF,$40,$40;
       DB    $00,$C0,$C0;
       DB    $FF,$C0,$40;
       DB    $00,$40,$C0;
       DB    $FF,$C0,$C0;
       DB    $00,$40,$40;
       DB    $FF,$40,$C0;
       DB    $00,$C0,$40;
       DB    $01;

explosion_dots:
       DB    $35,$00;
       DB    $F3,$0D;
       DB    $F3,$FF;
       DB    $E1,$26;
       DB    $EC,$03;
       DB    $F3,$E6;
       DB    $EB,$00;
       DB    $F1,$EC;
       DB    $10,$F1;
       DB    $FA,$EE;
       DB    $1D,$F8;
       DB    $0F,$E4;
       DB    $0F,$12;
       DB    $19,$F7;
       DB    $06,$1A;

author:
       DB    $20;
       DB    $90;
       DB    "PROGRAMMED BY",$80;
       DB    $E0;
       DB    $90;
       DB    "WILLIAM HAWKINS",$80;
       DB    $90;
       DB    $C0;
       DB    "GT 1983   ",$80,$00;

game_over:
       DB    $58;
       DB    $D0;
game_over2:
       DB    "GAME OVER",$80;

player1:
       DB    $48;
       DB    $D0;
       DB    "PLAYER 1",$80;

player2:
       DB    $48;
       DB    $D0;
       DB    "PLAYER 2",$80;

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

