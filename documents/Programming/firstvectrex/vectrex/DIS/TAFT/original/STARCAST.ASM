/*
 * This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
 * Please forward any comments, corrections or additions back to Fred.
 *
 * Star Castle
 */


                        .org 0x0000;
0000   67               .byte "g GCE 1983",0x80;
000B   0D               .word star_castle_music;

000D   F8               .byte 0xF8; /* height */
000E   50               .byte 0x50; /* width  */
000F   00               .byte 0x00; /* rel y  */
0010   B0               .byte 0xB0; /* rel x  */
0011   53               .byte "STAR CASTLE",0x80,0x00;


                 star_castle:
001E   7DC83B           tst   $C83B;    /* The following block of code is */
0021   2724             beq   restart_game;/* called only the first time the */
0023   BDF1AA           jsr   $dptoD0;  /* game is powered up, and only if*/
0026   BDF1BA           jsr   $read_switches2;  /* buttons 1,2 & 4 are all*/
0029   B6C80F           lda   $C80F;    /* simultaneously pressed.  This  */
002C   810B             cmpa  #0x0B;    /* code will display the name of the */
002E   2617             bne   restart_game;/* programmer, until either the*/
0030   CCFB40           ldd   #0xFB40;  /* counter at C88A decrements to 0*/
0033   FDC82A           std   $C82A;    /* or the buttons are no longer   */
0036   CE0FA4    P0036: ldu   #author;  /* pressed.                       */
0039   BDF38A           jsr   $printu2;
003C   BDF192           jsr   $waitrecal;
003F   BDF2A5           jsr   $intensity_to_5F;
0042   7AC88A           dec   $C88A;
0045   26EF             bne   P0036;

                 /*
                  * Initialize variables, and set the users score string
                  * to its default values.
                  */
                 restart_game:
0047   8EC880           ldx   #0xC880;  /* Initialize RAM area. /
004A   BDF545           jsr   $clear_256_bytes;
004D   BDF1AF           jsr   $dptoC8;
0050   8605             lda   #0x05;    /* Set player 1's ship count. */
0052   979D             sta   0x9D;
0054   8EC8B0           ldx   #0xC8B0;  /* Init player 1's score string. */
0057   BDF84F           jsr   $set_dft_score;
005A   8EC8D0           ldx   #0xC8D0;  /* Init player 2's score string. */
005D   BDF84F           jsr   $set_dft_score;

                 /* Fill in the user's data area to its initial values. */
0060   8EC8CC           ldx   #0xC8CC;  /* Address of user 2's data area. */
0063   8680             lda   #0x80;
0065   A71D             sta   -3,x;     /* Set player 2 state to "inactive". */
0067   CCE090           ldd   #0xE090;
006A   ED13             std   -13,x;    /* Set initial (y,x) location. */
006C   8630             lda   #0x30;
006E   A710             sta   -16,x;    /* Set initial cruiser rotation. */
0070   8EC8AC           ldx   #0xC8AC;  /* Address of user 1's data area. */
0073   CC1070           ldd   #0x1070;
0076   ED13             std   -13,x;    /* Set initial (y,x) location. */
0078   8610             lda   #0x10;
007A   A710             sta   -16,x;    /* Set initial cruiser rotation. */

                   /* Ask user for the game #, and number of players. */
007C   CC0060           ldd   #0x0060;  /* Set initial ring rotation deltas. */
007F   FDC930           std   $C930;
0082   CC0202           ldd   #0x0202;  /*At first, allow 2 games & 2 players.*/
0085   0F91             clr   0x91;
0087   DD92             std   0x92;
0089   BDF7A9           jsr   $get_players_game;
008C   047A             lsr   0x7A;     /* Check which game was selected. */
008E   2503             blo   P0093;
0090   74C931    P0090: lsr   $C931;    /* Game 2;use slower rotation deltas. */
0093   0F7A      P0093: clr   0x7A;
0095   0479             lsr   0x79;     /* If 2 players were selected, then */
0097   2715             beq   P00AE;    /* allow the user to select one of 3*/
0099   8605             lda   #0x05;    /* 2 person games.                  */
009B   97BD             sta   0xBD;     /* Init ship count for player 2.    */
009D   CC0003           ldd   #0x0003;  /* Allow 3 games. */
00A0   BDF7A9           jsr   $get_players_game;
00A3   0C79             inc   0x79;
00A5   0A7A             dec   0x7A;    /* Determine if 2 person, simultaneous */
00A7   967A             lda   0x7A;    /* play was chosen; i.e. if game 3 was */
00A9   44               lsra;          /* selected.                           */
00AA   2702             beq   P00AE;
00AC   0FC9             clr   0xC9;    /* Flag simultaneous play.             */

00AE   0C24      P00AE: inc   0x24;
00B0   CCC9C8           ldd   #0xC9C8; /* Address of player 1 bullet buffer. */
00B3   DDAC             std   0xAC;
00B5   CCC9F4           ldd   #0xC9F4; /* Address of player 2 bullet buffer. */
00B8   DDAE             std   0xAE;
00BA   DDCC             std   0xCC;
00BC   CCCA20           ldd   #0xCA20;
00BF   DDCE             std   0xCE;
00C1   0A8F             dec   0x8F;    /* Backup both players info data areas.*/
00C3   BD0BD1           jsr   $change_player;
00C6   0A8F             dec   0x8F;
00C8   FCCA62           ldd   $CA62;
00CB   FDC930           std   $C930;
00CE   BD0BD1           jsr   $change_player;
00D1   0FE1             clr   0xE1;
00D3   BDF192    P00D3: jsr   $waitrecal;
00D6   BDF289           jsr   $do_sound;
00D9   8688             lda   #0x88;    /* Set the button mask required */
00DB   F6C88D           ldb   $C88D;    /* by the read_switches routine.*/
00DE   2701             beq   P00E1;
00E0   43               coma;
00E1   BDF1B4    P00E1: jsr   $read_switches;
00E4   BDF1F8           jsr   $read_jstick;
00E7   BDF2A1           jsr   $intensity_to_3F;
00EA   B6C88D           lda   $C88D;    /* Check if the game is over. */
00ED   10260397         lbne  P0488;

                 /*
                  * If player 1 is still alive, then transform his star
                  * cruiser, and draw it.
                  */
00F1   108EC8AC         ldy   #0xC8AC;
00F5   A63D             lda   -3,y;     /* Check if player 1 is alive. */
00F7   2B1B             bmi   P0114;
00F9   A630             lda   -16,y;    /* Get cruiser's rotation value. */
00FB   C608             ldb   #0x08;    /* Load the number of points (9).*/
00FD   8E0E1F           ldx   #star_cruiser1;  /* Addr of cruiser 1's V list.*/
0100   CEC932           ldu   #0xC932;  /* Addr of transformation buffer.*/
0103   BDF610           jsr   $rotate_vector_list2;
0106   EC33             ldd   -13,y;    /* Location of player 1's cruiser.*/
0108   BDF2FC           jsr   $move_pen7F_to_d;
010B   CC080D           ldd   #0x080D;  /* (number of pts, scale factor).*/
010E   8EC932           ldx   #0xC932;
0111   BDF3B7           jsr   $move_then_draw_VL_with_count4;

                 /*
                  * If player 2 is still alive, then transform his star
                  * cruiser, and draw it.
                  */
0114   108EC8CC  P0114: ldy   #0xC8CC;
0118   A63D             lda   -3,y;     /* Check if player 2 is alive. */
011A   2B1B             bmi   P0137;
011C   A630             lda   -16,y;    /* Get cruiser's rotation value. */
011E   C60A             ldb   #0x0A;    /* Load the number of points (11).*/
0120   8E0E31           ldx   #star_cruiser2;  /* Addr of cruiser 2's V list.*/
0123   CEC932           ldu   #0xC932;  /* Addr of transformation buffer.*/
0126   BDF610           jsr   $rotate_vector_list2;
0129   EC33             ldd   -13,y;    /* Location of player 2's cruiser.*/
012B   BDF2FC           jsr   $move_pen7F_to_d;
012E   CC0A0D           ldd   #0x0A0D;  /* (number of pts, scale factor).*/
0131   8EC932           ldx   #0xC932;
0134   BDF3B7           jsr   $move_then_draw_VL_with_count4;

                 /* Update the position of all active bullets. */
0137   BDF2A9    P0137: jsr   $intensity_to_7F;
013A   8EC9C8           ldx   #0xC9C8;  /* Address of bullet buffer. */
013D   E600      P013D: ldb   0,x;      /* Check if bullet is active. */
013F   274F             beq   P0190;    /* Bullet is inactive, so skip. */
0141   2A26             bpl   P0169;    /* Bullet is exploding.         */
0143   6A09             dec   9,x;      /* Decrement life span, and continue */
0145   2747             beq   P018E;    /* only if bullet is still 'alive'.  */
0147   EC05             ldd   5,x;      /* Get original y position. */
0149   1E89             exg   a,b;
014B   E301             addd  1,x;      /* Add the delta to it.     */
014D   1E89             exg   a,b;
014F   ED05             std   5,x;      /* Update bullet's y position. */
0151   EC07             ldd   7,x;      /* Get original x position. */
0153   E303             addd  3,x;      /* Add the delta to it.     */
0155   ED07             std   7,x;      /* Update bullet's x position. */
0157   3410             pshs  x;
0159   3006             leax  6,x;      /* Draw a dot at the bullet's new */
015B   867F             lda   #0x7F;    /* position.                      */
015D   9704             sta   0x04;
015F   BDF2C1           jsr   $dotix;
0162   BDF354           jsr   $reset0ref;
0165   3510             puls  x;
0167   2027             bra   P0190;

                 /* Bullet is exploding; so draw an explosion pattern */
0169   EC06      P0169: ldd   6,x;      /* Move to bullets position. */
016B   BDF2FC           jsr   $move_pen7F_to_d;
016E   E60A             ldb   10,x;
0170   CB25             addb  #0x25;    /* Increment the explosion scale */
0172   E70A             stb   10,x;     /* factor.                       */
0174   2515             blo   P018B;
0176   2A01             bpl   P0179;
0178   50               negb;
0179   54        P0179: lsrb;          /* Use the upper nibble of this */
017A   54               lsrb;          /* value as the scale factor.   */
017B   54               lsrb;
017C   54               lsrb;
017D   D704             stb   0x04;
017F   3410             pshs  x;
0181   8E0F55           ldx   #explosion_star;
0184   BDF46E           jsr   $drawl2;  /* Draw the explosion pattern. */
0187   3510             puls  x;
0189   2005             bra   P0190;

018B   BDF354    P018B: jsr   $reset0ref;
018E   6F00      P018E: clr   0,x;     /* Flag that bullet is now inactive. */
0190   300B      P0190: leax  11,x;    /* Advance ptr to next bullet, and   */
0192   8CCA20           cmpx  #0xCA20; /* continue, if not at end of buffer.*/
0195   26A6             bne   P013D;

                 /* Transform and draw the energy cannon */
0197   B6C88E           lda   $C88E;    /* Skip next block if energy cannon */
019A   2628             bne   P01C4;    /* has exploded, or a new screen is */
019C   B6C88F           lda   $C88F;    /* being set up.                    */
019F   102600B4         lbne  P0257;
01A3   BDF2A1           jsr   $intensity_to_3F;
01A6   B6C8DE           lda   $C8DE;    /* Transform the energy cannon's */
01A9   C60C             ldb   #0x0C;    /* vector list.                  */
01AB   8E0E47           ldx   #energy_cannon;
01AE   CEC932           ldu   #0xC932;
01B1   BDF610           jsr   $rotate_vector_list2;
01B4   86CE             lda   #0xCE;
01B6   970C             sta   0x0C;
01B8   CC0C0E           ldd   #0x0C0E;  /* Move to the origin, and then draw */
01BB   8EC932           ldx   #0xC932;  /* the transformed energy cannon.*/
01BE   BDF3B7           jsr   $move_then_draw_VL_with_count4;
01C1   7E0257           jmp   $P0257;

                 /* Draw the energy cannon exploding */
01C4   8501      P01C4: bita  #0x01;
01C6   2724             beq   P01EC;
01C8   86CE             lda   #0xCE;
01CA   970C             sta   0x0C;
01CC   F6C8DD           ldb   $C8DD;   /* Increment the scale factor used */
01CF   CB19             addb  #0x19;   /* when drawing the explosion pattern.*/
01D1   F7C8DD           stb   $C8DD;
01D4   250D             blo   P01E3;
01D6   2A01             bpl   P01D9;
01D8   50               negb;
01D9   D704      P01D9: stb   0x04;
01DB   8E0F55           ldx   #explosion_star;
01DE   BDF46E           jsr   $drawl2; /* Draw the explosion pattern. */
01E1   2074             bra   P0257;

                 /* Flag that the explosion is over */
01E3   7FC8DD    P01E3: clr   $C8DD;
01E6   78C88E           asl   $C88E;
01E9   BDF354           jsr   $reset0ref;

                 /* Collapse the 3 walls inward */
01EC   8EC8F3    P01EC: ldx   #0xC8F3;
01EF   7FC882           clr   $C882;
01F2   A684      P01F2: lda   ,x;    /* When a rings scale factor reaches */
01F4   8104             cmpa  #0x04; /* 4, flag that the ring has completely*/
01F6   221A             bhi   P0212; /* collapsed, by incrementing C882.  */
01F8   7CC882           inc   $C882;
01FB   8104             cmpa  #0x04;
01FD   261A             bne   P0219;
01FF   3410             pshs  x;     /* Now clear all the patterns for this */
0201   3002             leax  2,x;   /* ring, so it will disappear.         */
0203   C607             ldb   #0x07;
0205   BDF53F           jsr   $clear_blockxb;
0208   30881E           leax  0x1E,x;
020B   C607             ldb   #0x07;
020D   BDF53F           jsr   $clear_blockxb;
0210   3510             puls  x;
0212   33881E    P0212: leau  0x1E,x;  /* Decrement the scale factor used */
0215   6AC4             dec   ,u;      /* to draw this ring.              */
0217   6A84             dec   ,x;
0219   300A      P0219: leax  10,x;    /* Go onto the next ring.          */
021B   8CC908           cmpx  #0xC908;
021E   25D2             blo   P01F2;

                 /* See if all 3 rings have finally collapsed inward */
0220   B6C882           lda   $C882;   /* If all 3 rings have collapsed, */
0223   8103             cmpa  #0x03;   /* then force an explosion sound, */
0225   2630             bne   P0257;   /* and have another explosion     */
0227   B6C877           lda   $C877;   /* pattern displayed.             */
022A   2708             beq   P0234;
022C   B6C890           lda   $C890;
022F   8A80             ora   #0x80;
0231   B7C890           sta   $C890;
0234   F6C8DD    P0234: ldb   $C8DD;   /* Calculate the scale factor to use */
0237   CB0A             addb  #0x0A;   /* when drawing the explosion pattern.*/
0239   F7C8DD           stb   $C8DD;
023C   2513             blo   P0251;
023E   D704             stb   0x04;
0240   86CE             lda   #0xCE;
0242   970C             sta   0x0C;
0244   860E             lda   #0x0E;
0246   B7C823           sta   $C823;
0249   8E0F86           ldx   #explosion_dots;
024C   BDF2D5           jsr   $dot_list;  /* Draw the explosion pattern. */
024F   2006             bra   P0257;

                 /* Flag that the level was cleared */
0251   7FC88E    P0251: clr   $C88E;
0254   7AC88F           dec   $C88F;

                 /* Process the fireball, if active */
0257   BDF2A1    P0257: jsr   $intensity_to_3F;
025A   B6C8E1           lda   $C8E1;
025D   10270076         lbeq  P02D7;   /* Fireball not active. */
0261   2A39             bpl   P029C;   /* Fireball exploding.  */
0263   B6C890           lda   $C890;   /* Fireball moving.     */
0266   8A40             ora   #0x40;
0268   B7C890           sta   $C890;   /* Force a fireball sound. */
026B   FCC8E6           ldd   $C8E6;
026E   1E89             exg   a,b;     /* Update y position of fireball, */
0270   F3C8E2           addd  $C8E2;   /* and check to see if it went off*/
0273   295F             bvs   P02D4;   /* the screen.                    */
0275   1E89             exg   a,b;
0277   FDC8E6           std   $C8E6;
027A   FCC8E8           ldd   $C8E8;   /* Update x position of fireball, */
027D   F3C8E4           addd  $C8E4;   /* and check to see if it went off*/
0280   2952             bvs   P02D4;   /* the screen.                    */
0282   FDC8E8           std   $C8E8;
0285   FCC8E7           ldd   $C8E7;   /* Move to fireball's position. */
0288   BDF2FC           jsr   $move_pen7F_to_d;
028B   8608             lda   #0x08;
028D   F6C8E0           ldb   $C8E0;   /* Draw the fireball. */
0290   54               lsrb;
0291   8E0E61           ldx   #fireball;
0294   BDF3B7           jsr   $move_then_draw_VL_with_count4;
0297   7CC8E0           inc   $C8E0;   /* Increment the scale factor. */
029A   203B             bra   P02D7;

                 /* Process the exploding firebal */
029C   FCC8E7    P029C: ldd   $C8E7;   /* Move to fireball's position. */
029F   BDF2FC           jsr   $move_pen7F_to_d;
02A2   F6C8EA           ldb   $C8EA;
02A5   CB14             addb  #0x14;   /* Increment explosion's scale factor.*/
02A7   F7C8EA           stb   $C8EA;
02AA   2512             blo   P02BE;
02AC   54               lsrb;
02AD   54               lsrb;
02AE   54               lsrb;
02AF   D704             stb   0x04;    /* Set scale factor. */
02B1   860E             lda   #0x0E;
02B3   B7C823           sta   $C823;
02B6   8E0F86           ldx   #explosion_dots;
02B9   BDF2D5           jsr   $dot_list;  /* Draw the explostion pattern. */
02BC   2019             bra   P02D7;

                 /* Clean up after the fireball explosion has finished */
02BE   BDF354    P02BE: jsr   $reset0ref;
02C1   7FC8EA           clr   $C8EA;   /* Clear explosion scale factor.*/
02C4   B6C89D           lda   $C89D;   /* If both player 1 & 2 are out */
02C7   BAC8BD           ora   $C8BD;   /* of cruisers, then set the    */
02CA   2605             bne   P02D1;   /* 'game over' flag (C88D).     */
02CC   7AC88D           dec   $C88D;
02CF   2003             bra   P02D4;

                 /* Get ready for the next player */
02D1   BD0382    P02D1: jsr   $P0382;
02D4   7FC8E1    P02D4: clr   $C8E1;   /* Disable the fireball. */

                 /* Transform the 3 rotating rings */
02D7   C608      P02D7: ldb   #0x08;    /* Number of vectors (9).   */
02D9   B6C8ED           lda   $C8ED;    /* Ring 1's rotation value. */
02DC   8E0F33           ldx   #ring;    /* Ptr to ring vector list. */
02DF   CEC932           ldu   #0xC932;  /* Ptr to xformation buffer.*/
02E2   BDF610           jsr   $rotate_vector_list2;
02E5   C608             ldb   #0x08;    /* Number of vectors (9).   */
02E7   B6C8EF           lda   $C8EF;    /* Ring 2's rotation value. */
02EA   8E0F33           ldx   #ring;    /* Ptr to ring vector list. */
02ED   BDF610           jsr   $rotate_vector_list2;
02F0   C608             ldb   #0x08;    /* Number of vectors (9).   */
02F2   B6C8F1           lda   $C8F1;    /* Ring 3's rotation value. */
02F5   8E0F33           ldx   #ring;    /* Ptr to ring vector list. */
02F8   BDF610           jsr   $rotate_vector_list2;

                 /* Draw the 3 rotating rings */
02FB   CEC8F3           ldu   #0xC8F3;  /* Ptr to scales & line patterns. */
02FE   8EC932           ldx   #0xC932;  /* Ptr to transformation buffer.  */
0301   BD0C4C           jsr   $draw_1_ring;   /* Draw ring 1. */
0304   BD0C4C           jsr   $draw_1_ring;   /* Draw ring 2. */
0307   BD0C4C           jsr   $draw_1_ring;   /* Draw ring 3. */
030A   BDF2A9           jsr   $intensity_to_7F;
030D   8EC932           ldx   #0xC932;  /* Hi-lite rings hit with 1 bullet. */
0310   BD0C4C           jsr   $draw_1_ring;   /* Draw ring 1. */
0313   BD0C4C           jsr   $draw_1_ring;   /* Draw ring 2. */
0316   BD0C4C           jsr   $draw_1_ring;   /* Draw ring 3. */
0319   BDF2A1           jsr   $intensity_to_3F;

                 /* START OF ENERGY BOMB PROCESSING LOOP */
                 /* Process energy bombs */
031C   CEC978           ldu   #0xC978;  /* Addr of energy bomb buffer. */
031F   BDF517    P031F: jsr   $get_random_a;
0322   8407             anda  #0x07;    /* Randomly select 1 of 8 vector */
0324   8E0E73           ldx   #energy_bomb_VL_table;
0327   48               asla;           /* lists to be used when drawing */
0328   AE86             ldx   a,x;      /* this energy bomb.             */
032A   A65D             lda   -3,u;     /* See if we should draw energy bomb */
032C   8540             bita  #0x40;    /* or an explosion pattern.          */
032E   2616             bne   P0346;
0330   4D               tsta;
0331   102B00D5         lbmi  P040A;    /* Energy bomb is not in use. */
0335   8117             cmpa  #0x17;
0337   235E             bls   P0397;    /* Energy bomb is still on a ring. */

                 /* Energy bomb is moving; draw its vector list */
0339   EC53             ldd   -13,u;    /* Move to position of energy bomb. */
033B   BDF2FC           jsr   $move_pen7F_to_d;
033E   C60B             ldb   #0x0B;
0340   BDF40E           jsr   $drawl1b; /* Draw the energy bomb. */
0343   7E040A           jmp   $P040A;

                 /* Draw an explosion pattern at position of energy bomb */
0346   EC53      P0346: ldd   -13,u;    /* Move to position of energy bomb. */
0348   BDF2FC           jsr   $move_pen7F_to_d;
034B   E65E             ldb   -2,u;
034D   CB14             addb  #0x14;    /* Increment explosion scale factor */
034F   E75E             stb   -2,u;     /* and stop when it overflows.      */
0351   2513             blo   P0366;
0353   54               lsrb;
0354   54               lsrb;
0355   54               lsrb;
0356   D704             stb   0x04;     /* Set the scale factor. */
0358   860E             lda   #0x0E;
035A   B7C823           sta   $C823;    /* Number of dots to draw. */
035D   8E0F86           ldx   #explosion_dots;
0360   BDF2D5           jsr   $dot_list; /* Draw the explosion dots. */
0363   7E040A           jmp   $P040A;

                 /* Clean up after an energy bomb explosion */
0366   BDF354    P0366: jsr   $reset0ref;
0369   6F5E             clr   -2,u;
036B   8680             lda   #0x80;   /* Flag that this slot is no longer */
036D   A75D             sta   -3,u;    /* in use.                          */
036F   B6C89D           lda   $C89D;
0372   BAC8BD           ora   $C8BD;   /* See if either player has any */
0375   2606             bne   P037D;   /* cruisers left.               */
0377   7AC88D           dec   $C88D;
037A   7E040A           jmp   $P040A;  /* Flag that game is over. */

                 /* See if "PLAYER X" string needs to be displayed */
037D   8E0394    P037D: ldx   #P0394;
0380   3410      P0380: pshs  x;
0382   B6C879    P0382: lda   $C879;   /* If a 2 person, non-simultaneous */
0385   270C             beq   P0393;   /* game is being played, then force*/
0387   B6C87A           lda   $C87A;   /* the "PLAYER X" string to be shown by*/
038A   44               lsra;          /* setting the 'change player' counter*/
038B   2606             bne   P0393;
038D   7FC88B           clr   $C88B;   /* Set 'change player' loop counter. */
0390   7AC88B           dec   $C88B;
0393   39        P0393: rts;
0394   7E040A    P0394: jmp   $P040A;

                 /* Draw the energy bomb on one of the rings */
0397   7FC824    P0397: clr   $C824;   /* Temporarily disable reset of 0ref. */
039A   BFC880           stx   $C880;   /* Save pointer to vector list. */
039D   C6CE             ldb   #0xCE;
039F   D70C             stb   0x0C;
03A1   108EC8F3         ldy   #0xC8F3;  /* Addr of ring line patterns.  */
03A5   8EC932           ldx   #0xC932;  /* Addr of xformed ring vectors.*/
03A8   44               lsra;
03A9   44               lsra;           /* Use lower 4 bits of the bomb state */
03AA   44               lsra;           /* to determine which ring the bomb */
03AB   B7C885           sta   $C885;    /* is on, & then point 'y' to the */
03AE   2708      P03AE: beq   P03B8;    /* patterns for the ring, and 'x' */
03B0   312A             leay  10,y;     /* to the vector list for the ring.*/
03B2   308812           leax  0x12,x;
03B5   4A               deca;
03B6   20F6             bra   P03AE;
03B8   A6A4      P03B8: lda   ,y;       /* Use the ring's scale factor. */
03BA   9704             sta   0x04;
03BC   B7C882           sta   $C882;
03BF   A65D             lda   -3,u;     /* Determine which ring section to */
03C1   8407             anda  #0x07;    /* put the energy bomb on.         */
03C3   B7C883           sta   $C883;
03C6   B7C884           sta   $C884;
03C9   BDF3BC    P03C9: jsr   $move_to_pt;
03CC   7AC883           dec   $C883;    /* Move to starting point for section.*/
03CF   2CF8             bge   P03C9;
03D1   B6C882           lda   $C882;
03D4   44               lsra;
03D5   9704             sta   0x04;     /* Now, move to center of section. */
03D7   BDF3BC           jsr   $move_to_pt;
03DA   BEC880           ldx   $C880;
03DD   7CC824           inc   $C824;    /* Draw the energy bomb here. */
03E0   C60B             ldb   #0x0B;
03E2   BDF40E           jsr   $drawl1b;
03E5   8EC8ED           ldx   #0xC8ED;
03E8   B6C885           lda   $C885;
03EB   4A        P03EB: deca;           /* Now, determine what the (y,x) */
03EC   2D04             blt   P03F2;    /* position is of this energy bomb. */
03EE   3002             leax  2,x;
03F0   20F9             bra   P03EB;
03F2   E684      P03F2: ldb   ,x;
03F4   86C8             lda   #0xC8;
03F6   1F8B             tfr   a,dp;
03F8   9684             lda   0x84;
03FA   CB08      P03FA: addb  #0x08;
03FC   4A               deca;
03FD   2CFB             bge   P03FA;
03FF   9682             lda   0x82;
0401   BDF5FF           jsr   $convert_abs_angle_to_rise_run;
0404   ED53      P0404: std   -13,u;    /* Save the calculated position. */
0406   86D0             lda   #0xD0;
0408   1F8B             tfr   a,dp;
040A   33C820    P040A: leau  0x20,u;   /* Process the next energy bomb */
040D   1183C9B8         cmpu  #0xC9B8;  /* entry, until no more left.   */
0411   1023FF0A         lbls  P031F;
                 /* END OF THE ENERGY BOMB PROCESSING LOOP */

0415   BDF2A9           jsr   $intensity_to_7F;
0418   B6C88C           lda   $C88C;
041B   272A             beq   P0447;
041D   81FF             cmpa  #0xFF;
041F   2600             bne   P0421;

                 /* Display "GAME OVER PLAYER 1/2" */
0421   CCF950    P0421: ldd   #0xF950;   /* Set height & width of string. */
0424   FDC82A           std   $C82A;
0427   CE0FD4           ldu   #game_over;
042A   BDF378           jsr   $print_with_dft_hw;
042D   CE0FE0           ldu   #player1;
0430   8EC8AC           ldx   #0xC8AC;   /* Determine if player 1 or 2. */
0433   A611             lda   -15,x;
0435   2703             beq   P043A;
0437   CE0FEB           ldu   #player2;
043A   BDF378    P043A: jsr   $print_with_dft_hw;
043D   7AC88C           dec   $C88C;
0440   10260083         lbne  display_scores;
0444   160080           lbra  display_scores;

                 /* Prepare for the next player to start playing */
0447   B6C88E    P0447: lda   $C88E;   /* Skip if energy cannon exploding. */
044A   267B             bne   display_scores;
044C   B6C88B           lda   $C88B;   /* Display "PLAYER X" only if (while) */
044F   2776             beq   display_scores;  /* loop counter != 0.         */
0451   81FF             cmpa  #0xFF;
0453   2615             bne   P046A;
0455   BD0BD1           jsr   $change_player;  /* Backup dead players info. */
0458   8EC8AC           ldx   #0xC8AC;
045B   B6C8DC           lda   $C8DC;   /* Get pointer to data area for */
045E   2703             beq   P0463;   /* the next player.             */
0460   8EC8CC           ldx   #0xC8CC;
0463   A611      P0463: lda   -15,x;   /* If new player has no ships, then go */
0465   2E03             bgt   P046A;   /* back to the user who just died. */
0467   BD0BD1           jsr   $change_player;
046A   CCF950    P046A: ldd   #0xF950;
046D   FDC82A           std   $C82A;   /* Display "PLAYER X" string. */
0470   CE0FE0           ldu   #player1;
0473   B6C8DC           lda   $C8DC;
0476   2703             beq   P047B;
0478   CE0FEB           ldu   #player2;
047B   BDF378    P047B: jsr   $print_with_dft_hw;
047E   7AC88B           dec   $C88B;
0481   2744             beq   display_scores;   /* Decr the 'change player' */
0483   7AC88B           dec   $C88B;   /* counter.  Stop displaying "PLAYER X"*/
0486   203F             bra   display_scores;   /* string when it decrs to 0. */

                 /* Display "GAME OVER" & see if user wants a new game */
0488   BDF2A9    P0488: jsr   $intensity_to_7F;
048B   CCF950           ldd   #0xF950;   /* Set height & width of string. */
048E   FDC82A           std   $C82A;
0491   CE0FD6           ldu   #game_over2;
0494   CC00D0           ldd   #0x00D0;   /* Position for displaying string.  */
0497   BDF2FC           jsr   $move_pen7F_to_d;
049A   BDF495           jsr   $display_string;

049D   B6C879           lda   $C879;    /* Force both players scores to */
04A0   2705             beq   P04A7;    /* be displayed.                */
04A2   8602             lda   #0x02;
04A4   B7C87A           sta   $C87A;
04A7   7AC88A    P04A7: dec   $C88A;
04AA   260D             bne   P04B9;
04AC   7CC88A           inc   $C88A;
04AF   B6C811           lda   $C811;   /* Restart new game if either button */
04B2   8477             anda  #0x77;   /* 1, 2 or 3 is pressed on either    */
04B4   2703             beq   P04B9;   /* console.                          */
04B6   7E0047           jmp   $restart_game;

                 /* If a new game is not eventually started, go to OS ROM */
04B9   B6C826    P04B9: lda   $C826;
04BC   44               lsra;                  /* Everyother pass thru loop */
04BD   2408             bhs   display_scores;  /* decr counter; if it goes  */
04BF   7AC88D           dec   $C88D;           /* to 0, then pass control   */
04C2   2603             bne   display_scores;  /* back to OS ROM.           */
04C4   7EF000           jmp   $start_of_OS_ROM;


                 /* Display the individual or simultaneous player scores */
                 display_scores:
04C7   CCFC47           ldd   #0xFC47;  /* Set height & width of string. */
04CA   FDC82A           std   $C82A;
04CD   B6C879           lda   $C879;    /* Determine if both player's scores */
04D0   2735             beq   display_player1_score; /* are to be displayed  */
04D2   B6C87A           lda   $C87A;    /* (simul play) or if only a single */
04D5   44               lsra;           /* players score is to be displayed. */
04D6   2605             bne   display_player2_score;
04D8   B6C8DC           lda   $C8DC;    /* C8DC says who's turn it is.       */
04DB   272A             beq   display_player1_score;

                 /* Display player 2's score */
                 display_player2_score:
04DD   CC7F80           ldd   #0x7F80;   /* Position of score string. */
04E0   BDF2FC           jsr   $move_pen7F_to_d;
04E3   CEC8D0           ldu   #0xC8D0;   /* Addr of player 2's score string. */
04E6   BDF495           jsr   $display_string;

                 /* Display player 2's ship count */
04E9   BD0C0F           jsr   $init_ship_count_buffer;
04EC   B6C8BD           lda   $C8BD;     /* Get the ship count. */
04EF   BD0C20           jsr   $fill_ship_count_buffer;
04F2   CEC932           ldu   #0xC932;   /* Addr of ship count buffer. */
04F5   CCFD30           ldd   #0xFD30;   /* Height & width to use.     */
04F8   FDC82A           std   $C82A;
04FB   CC6F90           ldd   #0x6F90;   /* Position for displaying.   */
04FE   BDF37A           jsr   $print_at_d;

0501   B6C87A           lda   $C87A;   /* Display player 1's score only if */
0504   44               lsra;          /* game is over, or simultaneous play.*/
0505   272A             beq   P0531;

                 /* Display player 1's score */
                 display_player1_score:
0507   CC7F20           ldd   #0x7F20;   /* Position for displaying.   */
050A   BDF2FC           jsr   $move_pen7F_to_d;
050D   CEC8B0           ldu   #0xC8B0;   /* Addr of player 1's score string. */
0510   CCFC47           ldd   #0xFC47;   /* Height & width to use.     */
0513   FDC82A           std   $C82A;
0516   BDF495           jsr   $display_string;

                 /* Display player 1's ship count */
0519   BD0C0F           jsr   $init_ship_count_buffer;
051C   B6C89D           lda   $C89D;     /* Get the ship count. */
051F   BD0C20           jsr   $fill_ship_count_buffer;
0522   CEC932           ldu   #0xC932;   /* Addr of ship count buffer. */
0525   CCFD30           ldd   #0xFD30;   /* Height & width to use.     */
0528   FDC82A           std   $C82A;
052B   CC6F20           ldd   #0x6F20;   /* Position for displaying.   */
052E   BDF37A           jsr   $print_at_d;

                 /* Make game sounds */
0531   BDF1AF    P0531: jsr   $dptoC8;
0534   BD0C88           jsr   $make_game_sounds;

                 /* Don't process joystick or buttons if game is over */
0537   968D             lda   0x8D;
0539   1026FB96         lbne  P00D3;

                 /* Read joystick and buttons, for player 1 */
053D   CEC8AC           ldu   #0xC8AC;
0540   9611             lda   0x11;     /* Get console 1 button states. */
0542   D61B             ldb   0x1B;     /* Get joystick 1 state. */
0544   2708             beq   P054E;
0546   2B04             bmi   P054C;
0548   8A02             ora   #0x02;    /* Convert joystick movements */
054A   2002             bra   P054E;    /* into button presses, to make */
054C   8A01      P054C: ora   #0x01;    /* processing easier.         */
054E   A75B      P054E: sta   -5,u;     /* Save user 1's button states. */

                 /* Read joystick and buttons, for player 2 */
0550   9611             lda   0x11;     /* Get console 1 button states. */
0552   D61B             ldb   0x1B;     /* Get joystick 1 state. */
0554   0D7A             tst   0x7A;
0556   2706             beq   P055E;    /* If simultaneous play, then use */
0558   44               lsra;           /* the buttons on console 2 and   */
0559   44               lsra;           /* and read the joystick state on */
055A   44               lsra;           /* console 2 also.                */
055B   44               lsra;
055C   D61D             ldb   0x1D;
055E   5D        P055E: tstb;
055F   2708             beq   P0569;
0561   2B04             bmi   P0567;    /* Convert joystick movements to */
0563   8A02             ora   #0x02;    /* button presses, to help make  */
0565   2002             bra   P0569;    /* processing easier.            */
0567   8A01      P0567: ora   #0x01;
0569   A7C81B    P0569: sta   0x1B,u;   /* Save player 2's button states.*/

                 /* Once a player is dead, delay awhile before restarting him */
056C   A65D      P056C: lda   -3,u;
056E   2A37             bpl   P05A7;
0570   A651             lda   -15,u;    /* Check the user's ship count. */
0572   1027010C         lbeq  P0682;
0576   6A5F             dec   -1,u;     /* Reset player's data area once */
0578   2715             beq   P058F;    /* the restart counter goes to 0.*/
057A   6A5F             dec   -1,u;
057C   2711             beq   P058F;
057E   A65F             lda   -1,u;
0580   81F0             cmpa  #0xF0;
0582   102200FC         lbhi  P0682;
0586   9690             lda   0x90;
0588   8A02             ora   #0x02;
058A   9790             sta   0x90;
058C   7E0682           jmp   $P0682;

                 /* Reset the data area for this user */
058F   6F5D      P058F: clr   -3,u;
0591   8E1070           ldx   #0x1070;  /* Player 1 initial position. */
0594   8610             lda   #0x10;    /* Player 1 rotation value.   */
0596   1183C8CC         cmpu  #0xC8CC;  /* Is this player 2?          */
059A   2505             blo   P05A1;
059C   8EE090           ldx   #0xE090;  /* Player 2 initial position. */
059F   8630             lda   #0x30;    /* Player 2 rotation value.   */
05A1   AF53      P05A1: stx   -13,u;    /* Set cruiser's position.    */
05A3   A750             sta   -16,u;    /* Set cruiser's rotation.    */
05A5   6F5A             clr   -6,u;
05A7   86FF      P05A7: lda   #0xFF;
05A9   A75F             sta   -1,u;

                 /* Process the button states now */
                 /* Check for rotate left command */
05AB   A65B             lda   -5,u;
05AD   8501             bita  #0x01;    /* If button 1 was pressed, then   */
05AF   2702             beq   P05B3;    /* rotate the cruiser to the left. */
05B1   6C50             inc   -16,u;

                 /* Check for rotate right command */
05B3   8502      P05B3: bita  #0x02;    /* If button 2 was pressed, then   */
05B5   2702             beq   P05B9;    /* rotate the cruiser to the right.*/
05B7   6A50             dec   -16,u;

                 /* Check for a bullet fire request */
05B9   8508      P05B9: bita  #0x08;    /* If button 4 was pressed, then   */
05BB   2741             beq   P05FE;    /* search the bullet buffer for an */
05BD   D68E             ldb   0x8E;     /* available spot.                 */
05BF   DA8F             orb   0x8F;
05C1   263B             bne   P05FE;    /* Ignore, if energy cannon destroyed.*/
05C3   AE40             ldx   0,u;
05C5   E600      P05C5: ldb   0,x;      /* Find an available spot in buffer.*/
05C7   2708             beq   P05D1;
05C9   300B             leax  11,x;
05CB   AC42             cmpx  2,u;
05CD   26F6             bne   P05C5;
05CF   202D             bra   P05FE;
05D1   9690      P05D1: lda   0x90;
05D3   8A20             ora   #0x20;
05D5   9790             sta   0x90;
05D7   EC52             ldd   -14,u;   /* Use ship's y position as bullet's */
05D9   ED05             std   5,x;     /* initial y position.               */
05DB   EC54             ldd   -12,u;   /* Use ship's x position as bullet's */
05DD   ED07             std   7,x;     /* initial x position.               */
05DF   E650             ldb   -16,u;   /* Calculate rise & run for the bullet.*/
05E1   867F             lda   #0x7F;
05E3   BDF601           jsr   $convert_angle_to_rise_run;
05E6   DD85             std   0x85;
05E8   D685             ldb   0x85;
05EA   BD0C31           jsr   $mult_rise_run_by_9;
05ED   ED01             std   1,x;     /* Save the rise. */
05EF   D686             ldb   0x86;
05F1   BD0C31           jsr   $mult_rise_run_by_9;
05F4   ED03             std   3,x;     /* Save the run. */
05F6   8630             lda   #0x30;
05F8   A709             sta   9,x;     /* Set bullet's life span value. */
05FA   6300             com   0,x;     /* Flag that buffer spot is in use. */

                 /* Check for a thrust request */
05FC   A65B             lda   -5,u;
05FE   8504      P05FE: bita  #0x04;   /* If button 3 was pressed, then */
0600   271F             beq   P0621;   /* update the cruiser's velocity, and */
0602   9690             lda   0x90;    /* update the cruiser's position.*/
0604   8A04             ora   #0x04;
0606   9790             sta   0x90;    /* Force a ship movement sound. */
0608   A65A             lda   -6,u;
060A   810F             cmpa  #0x0F;
060C   2413             bhs   P0621;
060E   6C5A             inc   -6,u;    /* Increment cruisers velocity. */
0610   D626             ldb   0x26;
0612   54               lsrb;
0613   54               lsrb;
0614   2402             bhs   P0618;
0616   6C5A             inc   -6,u;
0618   E650      P0618: ldb   -16,u;   /* Calulate new rise & run values. */
061A   867F             lda   #0x7F;
061C   BDF601           jsr   $convert_angle_to_rise_run;
061F   ED57             std   -9,u;
0621   9626      P0621: lda   0x26;    /* Decrement velocity every so ofter. */
0623   8503             bita  #0x03;
0625   2602             bne   P0629;
0627   6A5A             dec   -6,u;

                 /* Modify cruiser position, if velocity > 0 */
0629   A65A      P0629: lda   -6,u;    /* Calculate new y position. */
062B   2F53             ble   P0680;
062D   44               lsra;
062E   E657             ldb   -9,u;
0630   BD0C33           jsr   $mult_rise_run_by_a;
0633   EC52             ldd   -14,u;   /* Multiply velocity * rise, and */
0635   1E89             exg   a,b;     /* add it to old y position.     */
0637   D380             addd  0x80;
0639   1E89             exg   a,b;
063B   ED52             std   -14,u;   /* Save new y position. */
063D   A65A             lda   -6,u;    /* Calculate new x position. */
063F   E658             ldb   -8,u;
0641   44               lsra;
0642   BD0C33           jsr   $mult_rise_run_by_a;
0645   EC54             ldd   -12,u;   /* Multiply velocity * run, and */
0647   D380             addd  0x80;    /* add it to old x position.    */
0649   ED54             std   -12,u;   /* Save new x position. */

                 /* See if the cruiser is trying to enter the ring area */
064B   EC53             ldd   -13,u;
064D   BDF584           jsr   $get_absolute_value_of_ab;
0650   DD80             std   0x80;
0652   D680             ldb   0x80;     /* Calculate x*x + y*y. */
0654   3D               mul;
0655   DD82             std   0x82;
0657   9681             lda   0x81;
0659   D681             ldb   0x81;
065B   3D               mul;
065C   D382             addd  0x82;     /* Compare absolute ship position */
065E   10830384         cmpd  #0x0384;  /* to the outer ring dimensions.  */
0662   221E             bhi   P0682;

                 /* Cruise has attempted to enter ring area; turn it around */
0664   EC53             ldd   -13,u;   /* Calc angle of cruiser from origin. */
0666   BDF593           jsr   $convert_rise_run_to_angle;
0669   C00A             subb  #0x0A;   /* Convert angle to Vectrex reference.*/
066B   E750             stb   -16,u;   /* Set new angle for cruiser. */
066D   867F             lda   #0x7F;
066F   BDF601           jsr   $convert_angle_to_rise_run;
0672   ED57             std   -9,u;    /* Save rise & run deltas. */
0674   8606             lda   #0x06;
0676   A75A             sta   -6,u;    /* Force velocity to 6. */
0678   9690             lda   0x90;
067A   8A10             ora   #0x10;   /* Force a sound. */
067C   9790             sta   0x90;
067E   2002             bra   P0682;

                 /* Force ships velocity to 0 */
0680   6F5A      P0680: clr   -6,u;

                 /* See if the fireball has hit a star cruiser */
0682   AE53      P0682: ldx   -13,u;
0684   A65D             lda   -3,u;
0686   2B70             bmi   P06F8;
0688   96E1             lda   0xE1;
068A   2A0E             bpl   P069A;
068C   109EE7           ldy   0xE7;    /* Fireball position. */
068F   96E0             lda   0xE0;    /* Use scale * 2 as the size */
0691   D6E0             ldb   0xE0;    /* of the fireball.          */
0693   44               lsra;
0694   54               lsrb;
0695   BDF8FF           jsr   $check_bullet_for_hit;
0698   252B             blo   P06C5;

                 /* Check to see if an energy bomb has hit a star cruiser */
069A   3440      P069A: pshs  u;
069C   CEC978           ldu   #0xC978;   /* Addr of energy bomb buffer. */
069F   A65D      P069F: lda   -3,u;
06A1   8520             bita  #0x20;
06A3   270B             beq   P06B0;
06A5   10AE53           ldy   -13,u;     /* Position of energy bomb. */
06A8   CC0404           ldd   #0x0404;
06AB   BDF8FF           jsr   $check_bullet_for_hit;
06AE   250D             blo   P06BD;     /* Branch, if a hit. */
06B0   33C820    P06B0: leau  0x20,u;    /* Check next energy bomb. */
06B3   1183C9B8         cmpu  #0xC9B8;   /* Stop, when last bomb checked. */
06B7   23E6             bls   P069F;
06B9   3540             puls  u;
06BB   203B             bra   P06F8;

                 /* Star cruiser was hit by an energy bomb */
06BD   86C0      P06BD: lda   #0xC0;
06BF   A75D             sta   -3,u;
06C1   3540             puls  u;
06C3   2002             bra   P06C7;
06C5   97E1      P06C5: sta   0xE1;    /* Force explosion at fireball (y,x). */
06C7   635D      P06C7: com   -3,u;    /* Flag player as dead. */
06C9   9690             lda   0x90;
06CB   8A80             ora   #0x80;   /* Force an explosion sound. */
06CD   9790             sta   0x90;
06CF   8602             lda   #0x02;
06D1   979B             sta   0x9B;
06D3   6A5F             dec   -1,u;    /* Set the restart timer. */
06D5   6A51             dec   -15,u;   /* Decrement players cruiser count. */
06D7   2618             bne   P06F1;
06D9   3440             pshs  u;       /* Game over for this player, so see */
06DB   3044             leax  4,u;     /* if his score is a new hi score.   */
06DD   CECBEB           ldu   #0xCBEB;
06E0   BDF8D8           jsr   $check_4_new_hi_score;
06E3   3540             puls  u;
06E5   9679             lda   0x79;
06E7   2708             beq   P06F1;   /* If neither player has any cruisers */
06E9   969D             lda   0x9D;    /* left, then flag that the game is   */
06EB   9ABD             ora   0xBD;    /* over.                              */
06ED   2702             beq   P06F1;
06EF   0A8C             dec   0x8C;
06F1   AE40      P06F1: ldx   0,u;     /* Clear out users bullet buffer. */
06F3   C62B             ldb   #0x2B;
06F5   BDF53F           jsr   $clear_blockxb;
06F8   33C820    P06F8: leau  0x20,u;  /* Process next player. */
06FB   1183C8CC         cmpu  #0xC8CC;
06FF   1023FE69         lbls  P056C;


                 /* START OF ENERGY BOMB STATE AND POSITION PROCESSING LOOP */
                 /* Update the position and states of all energy bombs */
0703   96AB             lda   0xAB;
0705   9795             sta   0x95;     /* Determine which player has the */
0707   96CB             lda   0xCB;     /* slower ring rotation delta.    */
0709   9195             cmpa  0x95;     /* Save it in C895. */
070B   2202             bhi   P070F;
070D   9795             sta   0x95;
070F   967A      P070F: lda   0x7A;     /* If not simultaneous play, then */
0711   44               lsra;           /* determine who the next player is */
0712   260E             bne   P0722;    /* and set up his restart counter. */
0714   8EC8AC           ldx   #0xC8AC;
0717   96DC             lda   0xDC;
0719   2603             bne   P071E;
071B   8EC8CC           ldx   #0xC8CC;
071E   86FF      P071E: lda   #0xFF;    /* Restart counter is set here. */
0720   A71F             sta   -1,x;
0722   8EC978    P0722: ldx   #0xC978;
0725   968E             lda   0x8E;     /* Make sure the game is not in */
0727   9A8F             ora   0x8F;     /* the middle of setting up a   */
0729   2703             beq   P072E;    /* new level.                   */
072B   7E0912           jmp   $P0912;

                 /* Determine state of energy bomb, and handle accordingly */
072E   A61D      P072E: lda   -3,x;
0730   102B018E         lbmi  P08C2;    /* Bomb is not in use. */
0734   8117             cmpa  #0x17;
0736   102301A8         lbls  P08E2;    /* Bomb is still on a ring. */

                 /* Energy bomb is moving; so draw it towards a cruiser */
073A   EC13             ldd   -13,x;
073C   47               ASRA;
073D   57               asrb;
073E   DD80             std   0x80;
0740   DC9F             ldd   0x9F;     /* Determine the delta between player */
0742   47               ASRA;           /* 1's cruiser, and the energy bomb. */
0743   57               asrb;
0744   9080             suba  0x80;
0746   D081             subb  0x81;
0748   DD82             std   0x82;
074A   DCBF             ldd   0xBF;     /* Determine the delta between player */
074C   47               ASRA;           /* 2's cruiser, and the energy bomb. */
074D   57               asrb;
074E   9080             suba  0x80;
0750   D081             subb  0x81;
0752   DD84             std   0x84;
0754   96A9             lda   0xA9;     /* If both players are dead, then */
0756   95C9             bita  0xC9;     /* draw the energy bomb back towards */
0758   2A08             bpl   P0762;    /* the rings.                     */
075A   DC80             ldd   0x80;
075C   40               nega;
075D   50               negb;
075E   DD82             std   0x82;
0760   2038             bra   P079A;

                 /* The following block is for simultaneous play only */
                 /* Determine which cruiser is closer to the energy bomb */
0762   4D        P0762: tsta;
0763   2B31             bmi   P0796;    /* See if player 1 is alive. */
0765   96C9             lda   0xC9;
0767   2B31             bmi   P079A;    /* See if player 2 is alive. */
0769   DC82             ldd   0x82;
076B   BDF584           jsr   $get_absolute_value_of_ab;
076E   DD80             std   0x80;
0770   D680             ldb   0x80;
0772   3D               mul;
0773   DD86             std   0x86;
0775   9681             lda   0x81;
0777   D681             ldb   0x81;
0779   3D               mul;
077A   D386             addd  0x86;
077C   DD86             std   0x86;
077E   DC84             ldd   0x84;
0780   BDF584           jsr   $get_absolute_value_of_ab;
0783   DD80             std   0x80;
0785   D680             ldb   0x80;
0787   3D               mul;
0788   DD88             std   0x88;
078A   9681             lda   0x81;
078C   D681             ldb   0x81;
078E   3D               mul;
078F   D388             addd  0x88;
0791   109386           cmpd  0x86;
0794   2204             bhi   P079A;
0796   DC84      P0796: ldd   0x84;     /* Use player 2's position. */
0798   DD82             std   0x82;

                 /* Determine the angle between energy bomb & cruiser */
079A   DC82      P079A: ldd   0x82;
079C   BDF593           jsr   $convert_rise_run_to_angle;
079F   9780             sta   0x80;
07A1   A610             lda   -16,x;
07A3   843F             anda  #0x3F;
07A5   9080             suba  0x80;
07A7   9781             sta   0x81;
07A9   BDF584           jsr   $get_absolute_value_of_ab;
07AC   843F             anda  #0x3F;
07AE   9782             sta   0x82;
07B0   9783             sta   0x83;
07B2   40               nega;
07B3   843F             anda  #0x3F;
07B5   9182             cmpa  0x82;
07B7   2402             bhs   P07BB;
07B9   9782             sta   0x82;

                 /* If small delta, then aim bomb at cruiser */
07BB   B6C930    P07BB: lda   $C930;
07BE   9182             cmpa  0x82;     /* If delta is < ring rotation, */
07C0   2506             blo   P07C8;    /* set energy bombs angle of travel */
07C2   9680             lda   0x80;     /* equal to delta angle.        */
07C4   A710             sta   -16,x;
07C6   201A             bra   P07E2;

                 /* If large delta, then gradually draw bomb towards cruiser */
07C8   8620      P07C8: lda   #0x20;
07CA   9181             cmpa  0x81;    /* If delta is > ring rotation, */
07CC   230A             bls   P07D8;   /* draw the energy bomb towards */
07CE   EC10             ldd   -16,x;   /* the cruiser, by modifying its*/
07D0   B3C930           subd  $C930;   /* angle of travel by +- the ring */
07D3   B3C930           subd  $C930;   /* rotation delta.              */
07D6   2008             bra   P07E0;
07D8   EC10      P07D8: ldd   -16,x;
07DA   F3C930           addd  $C930;
07DD   F3C930           addd  $C930;
07E0   ED10      P07E0: std   -16,x;

                 /* Now, update position, and position delta for the bomb */
07E2   B6C931    P07E2: lda   $C931;
07E5   43               coma;
07E6   A71C             sta   -4,x;
07E8   863F             lda   #0x3F;
07EA   E610             ldb   -16,x;   /* Calculate rise & run. */
07EC   BDF5FF           jsr   $convert_abs_angle_to_rise_run;
07EF   ED17             std   -9,x;
07F1   B6C931           lda   $C931;   /* Scale rise & run by ring rotation */
07F4   44               lsra;          /* value; as ring rotates faster, the*/
07F5   44               lsra;          /* energy bombs will also travel     */
07F6   44               lsra;          /* faster.                           */
07F7   44               lsra;
07F8   9786             sta   0x86;
07FA   BD0C33           jsr   $mult_rise_run_by_a;
07FD   EC14             ldd   -12,x;   /* Update the x position, and check */
07FF   D380             addd  0x80;    /* for screen wrap.                 */
0801   102900BD         lbvs  P08C2;
0805   ED14             std   -12,x;
0807   9686             lda   0x86;
0809   E617             ldb   -9,x;
080B   BD0C33           jsr   $mult_rise_run_by_a;
080E   EC12             ldd   -14,x;   /* Update the y position, and check */
0810   1E89             exg   a,b;     /* for screen wrap.                 */
0812   D380             addd  0x80;
0814   102900AA         lbvs  P08C2;
0818   1E89             exg   a,b;
081A   ED12             std   -14,x;

                 /* If bomb is back in ring area, then reattach it */
081C   EC13             ldd   -13,x;
081E   BDF584           jsr   $get_absolute_value_of_ab;
0821   DD86             std   0x86;
0823   D686             ldb   0x86;
0825   3D               mul;
0826   DD84             std   0x84;
0828   9687             lda   0x87;
082A   D687             ldb   0x87;
082C   3D               mul;
082D   D384             addd  0x84;
082F   DD84             std   0x84;
0831   10830384         cmpd  #0x0384;  /* See if the bomb is within the */
0835   2515             blo   P084C;    /* confines of the center ring area. */
0837   6A00             dec   0,x;
0839   270D             beq   P0848;    /* If bomb is still moving, then make */
083B   9690             lda   0x90;     /* a sound, and decrement it's life */
083D   8A08             ora   #0x08;    /* span counter.                    */
083F   9790             sta   0x90;
0841   8620             lda   #0x20;    /* Flag that bomb is still moving. */
0843   A71D      P0843: sta   -3,x;
0845   7E0908           jmp   $P0908;

                 /* Flag that bomb is no longer in use; lifespan expired */
0848   8680      P0848: lda   #0x80;
084A   20F7             bra   P0843;

                 /* Determine which ring to attach energy bomb to */
084C   CEC8F3    P084C: ldu   #0xC8F3;
084F   108EC8ED         ldy   #0xC8ED;
0853   0F80             clr   0x80;
0855   A6C4      P0855: lda   ,u;    /* Determine if the energy bomb is */
0857   4A               deca;        /* within the confines of the ring */
0858   1F89             tfr   a,b;   /* being checked.                  */
085A   3D               mul;
085B   109384           cmpd  0x84;
085E   2550             blo   P08B0;
0860   A6C4             lda   ,u;
0862   8008             suba  #0x08;
0864   1F89             tfr   a,b;
0866   3D               mul;
0867   109384           cmpd  0x84;
086A   2244             bhi   P08B0;

                 /* Determine which ring section to energy attach bomb to */
086C   EC13             ldd   -13,x;
086E   BDF593           jsr   $convert_rise_run_to_angle;
0871   A0A4             suba  ,y;
0873   44               lsra;
0874   44               lsra;
0875   840F             anda  #0x0F;
0877   3410             pshs  x;
0879   8E0F45           ldx   #0x0F45;
087C   A686             lda   a,x;

                 /* Determine if this section still exists. */
087E   30C81E           leax  0x1E,u;
0881   E6C6             ldb   a,u;
0883   EA86             orb   a,x;
0885   3510             puls  x;
0887   2727             beq   P08B0;

                 /* See if any other bomb is already on this section */
0889   8002             suba  #0x02;
088B   9A80             ora   0x80;
088D   9781             sta   0x81;
088F   F6C975           ldb   $C975;    /* Check bomb 1. */
0892   C41F             andb  #0x1F;
0894   D181             cmpb  0x81;
0896   2718             beq   P08B0;
0898   F6C995           ldb   $C995;    /* Check bomb 2. */
089B   C41F             andb  #0x1F;
089D   D181             cmpb  0x81;
089F   270F             beq   P08B0;
08A1   F6C9B5           ldb   $C9B5;    /* Check bomb 3. */
08A4   C41F             andb  #0x1F;
08A6   D181             cmpb  0x81;
08A8   2706             beq   P08B0;
08AA   A71D             sta   -3,x;     /* Available; place bomb here. */
08AC   6F00             clr   0,x;
08AE   2058             bra   P0908;

                 /* Section not available or occupied, so check next ring */
08B0   9680      P08B0: lda   0x80;
08B2   8B08             adda  #0x08;
08B4   9780             sta   0x80;
08B6   334A             leau  10,u;
08B8   3122             leay  2,y;
08BA   108CC8F1         cmpy  #0xC8F1;
08BE   2395             bls   P0855;
08C0   2046             bra   P0908;

                 /* See if we need to start up another energy bomb */
08C2   A61D      P08C2: lda   -3,x;
08C4   8540             bita  #0x40;
08C6   2640             bne   P0908;
08C8   0AEB             dec   0xEB;   /* Decrement reseed counter. */
08CA   263C             bne   P0908;  /* Restart new bomb when it goes to 0. */
08CC   F6C931           ldb   $C931;
08CF   54               lsrb;
08D0   D7EB             stb   0xEB;   /* Reset the reseed counter. */
08D2   8620             lda   #0x20;
08D4   A71D             sta   -3,x;   /* Flag bomb state as 'moving'. */
08D6   96DE             lda   0xDE;
08D8   A710             sta   -16,x;  /* Use energy cannons angle. */
08DA   4F               clra;
08DB   5F               clrb;
08DC   ED13             std   -13,x;  /* Start bomb from origin. */
08DE   A700             sta   0,x;    /* Clear lifespan. */
08E0   2026             bra   P0908;

                 /* See if time to force energy bomb off a ring */
08E2   CEC8F3    P08E2: ldu   #0xC8F3;
08E5   44               lsra;         /* Use state/8 to determine which  */
08E6   44               lsra;         /* ring energy bomb is attached to.*/
08E7   44               lsra;
08E8   2705      P08E8: beq   P08EF;
08EA   334A             leau  10,u;
08EC   4A               deca;
08ED   20F9             bra   P08E8;
08EF   3342      P08EF: leau  2,u;    /* If the ring no longer exists, or if */
08F1   31C81E           leay  0x1E,u; /* the 'time to move' counter has gone */
08F4   A61D             lda   -3,x;   /* to 0, then force the energy bomb to */
08F6   8407             anda  #0x07;  /* start moving outwards, until it     */
08F8   E6A6             ldb   a,y;    /* hits a cruiser, or comes within the */
08FA   EAC6             orb   a,u;    /* confines of another ring.           */
08FC   2704             beq   P0902;
08FE   6A1C             dec   -4,x;   /* Update 'time to move' counter. */
0900   2606             bne   P0908;
0902   A61D      P0902: lda   -3,x;
0904   8A20             ora   #0x20;  /* Force energy bomb to start moving. */
0906   A71D             sta   -3,x;
0908   308820    P0908: leax  0x20,x;   /* Advance pointer to next energy */
090B   8CC9B8           cmpx  #0xC9B8;  /* bomb.  Stop when last on processed.*/
090E   1023FE1C         lbls  P072E;
                 /* END OF ENERGY BOMB STATE & POSITION PROCESSING LOOP */

                 /* Determin the confines of a given ring */
0912   108EC8F3  P0912: ldy   #0xC8F3;  /* Ptr to ring line patterns. */
0916   8EC8ED           ldx   #0xC8ED;  /* Addr of ring 1 rotation value. */
0919   0F91             clr   0x91;
091B   968E             lda   0x8E;
091D   9A8F             ora   0x8F;
091F   1026011D         lbne  P0A40;
0923   9690             lda   0x90;
0925   8A01             ora   #0x01;
0927   9790             sta   0x90;
0929   A6A4      P0929: lda   ,y;
092B   4A               deca;
092C   1F89             tfr   a,b;
092E   3D               mul;
092F   DD80             std   0x80;
0931   A6A4             lda   ,y;
0933   8008             suba  #0x08;
0935   1F89             tfr   a,b;
0937   3D               mul;
0938   DD82             std   0x82;

                 /* Check each bullet for a hit on the energy cannon */
093A   CEC9C8           ldu   #0xC9C8;  /* Addr of player 1's bullet buffer. */
093D   A640      P093D: lda   0,u;      /* See if bullet is active. */
093F   102A00E8         lbpl  P0A2B;
0943   3430             pshs  x,y;
0945   AE46             ldx   6,u;      /* Bullet's position. */
0947   108E0000         ldy   #0x0000;  /* Energy cannon's position. */
094B   CC0303           ldd   #0x0303;  /* Size of energy cannon. */
094E   BDF8FF           jsr   $check_bullet_for_hit;
0951   3530             puls  x,y;
0953   242E             bhs   P0983;

                 /* Energy cannon destroyed by a bullet */
0955   8680             lda   #0x80;    /* Energy cannon destroyed. */
0957   B7C975           sta   $C975;    /* Disable energy bomb 1. */
095A   B7C995           sta   $C995;    /* Disable energy bomb 2. */
095D   B7C9B5           sta   $C9B5;    /* Disable energy bomb 3. */
0960   9A90             ora   0x90;
0962   9790             sta   0x90;     /* Force an explosion sound. */
0964   8602             lda   #0x02;
0966   979B             sta   0x9B;
0968   0A8E             dec   0x8E;     /* Flag energy cannon is exploding. */
096A   6F40             clr   0,u;      /* Flag that bullet no longer in use.*/
096C   B6C931           lda   $C931;    /* Slightly increase ring rotation */
096F   8B10             adda  #0x10;    /* value.                          */
0971   2503             blo   P0976;
0973   B7C931           sta   $C931;
0976   CC1400    P0976: ldd   #0x1400;  /* Score a cannon hit for the player. */
0979   BD0C77           jsr   $update_players_score;
097C   301C             leax  -4,x;
097E   6C11             inc   -15,x;    /* Give the player another cruiser. */
0980   7E0A85           jmp   $P0A85;

                 /* See if the bullet hit one of the energy bombs */
0983   3420      P0983: pshs  y;
0985   108EC978         ldy   #0xC978;  /* Addr of energy bomb buffer. */
0989   A63D      P0989: lda   -3,y;
098B   8520             bita  #0x20;
098D   2711             beq   P09A0;
098F   3430             pshs  x,y;
0991   AE46             ldx   6,u;      /* Position of bullet. */
0993   10AE33           ldy   -13,y;    /* Position of energy bomb. */
0996   CC0202           ldd   #0x0202;  /* Size of energy bomb. */
0999   BDF8FF           jsr   $check_bullet_for_hit;
099C   3530             puls  x,y;
099E   250D             blo   P09AD;
09A0   31A820    P09A0: leay  0x20,y;   /* Check next energy bomb. */
09A3   108CC9B8         cmpy  #0xC9B8;
09A7   23E0             bls   P0989;
09A9   3520             puls  y;
09AB   2014             bra   P09C1;

                 /* Energy bomb was destroyed by a bullet */
09AD   8680      P09AD: lda   #0x80;
09AF   A73D             sta   -3,y;    /* Flag bullet no longer in use. */
09B1   9A90             ora   0x90;
09B3   9790             sta   0x90;    /* Force an explosion sound. */
09B5   8603             lda   #0x03;
09B7   979B             sta   0x9B;
09B9   8601             lda   #0x01;   /* Force an explosion pattern to be */
09BB   A740             sta   0,u;     /* displayed at bullet's position.  */
09BD   3520             puls  y;
09BF   206A             bra   P0A2B;

                 /* See if the bullet hit a wall section */
09C1   EC46      P09C1: ldd   6,u;
09C3   BDF584           jsr   $get_absolute_value_of_ab;
09C6   D786             stb   0x86;
09C8   1F89             tfr   a,b;     /* See if the bullet is within the */
09CA   3D               mul;           /* confines of a ring.             */
09CB   DD84             std   0x84;
09CD   9686             lda   0x86;
09CF   D686             ldb   0x86;
09D1   3D               mul;
09D2   D384             addd  0x84;
09D4   109380           cmpd  0x80;
09D7   2252             bhi   P0A2B;
09D9   109382           cmpd  0x82;
09DC   254D             blo   P0A2B;

                 /* Determine which section of the wall we are at */
09DE   EC46             ldd   6,u;      /* Bullet position. */
09E0   BDF593           jsr   $convert_rise_run_to_angle;
09E3   A084             suba  ,x;
09E5   44               lsra;
09E6   44               lsra;
09E7   840F             anda  #0x0F;
09E9   3410             pshs  x;
09EB   8E0F45           ldx   #0x0F45;
09EE   A686             lda   a,x;

                 /* Determine if this section exists or is already destroyed */
09F0   30A81E           leax  0x1E,y;
09F3   E6A6             ldb   a,y;
09F5   EA86             orb   a,x;
09F7   2730             beq   P0A29;

                 /* Add value of wall section to players score */
09F9   3412             pshs  a,x;
09FB   8EC8F3           ldx   #0xC8F3;  /* Addr of ring pattern arrays. */
09FE   C610             ldb   #0x10;    /* Value of outer wall section. */
0A00   A6A4             lda   ,y;
0A02   A184      P0A02: cmpa  ,x;       /* This loop calculates the value */
0A04   2402             bhs   P0A08;    /* of the wall section hit.       */
0A06   CB10             addb  #0x10;
0A08   300A      P0A08: leax  10,x;
0A0A   8CC908           cmpx  #0xC908;
0A0D   25F3      P0A0D: blo   P0A02;
0A0F   4F               clra;
0A10   BD0C77           jsr   $update_players_score;
0A13   3512             puls  a,x;
0A15   6F40             clr   0,u;   /* Flag bullet no longer in use. */
0A17   6FA6             clr   a,y;   /* Clear pattern for section hit(0 hit).*/
0A19   6386             com   a,x;   /* Clr/set pattern 4 section hit(1 hit). */
0A1B   260C             bne   P0A29;
0A1D   6C40             inc   0,u;
0A1F   8680             lda   #0x80;  /* Section destroyed, so force an */
0A21   9A90             ora   0x90;   /* explosion sound. (hit 2 times) */
0A23   9790             sta   0x90;
0A25   8603             lda   #0x03;
0A27   979B             sta   0x9B;
0A29   3510      P0A29: puls  x;

0A2B   334B      P0A2B: leau  11,u;     /* Advance ptr to next bullet. */
0A2D   1183CA20         cmpu  #0xCA20;  /* Stop when last bullet processed. */
0A31   1025FF08         lblo  P093D;
0A35   312A             leay  10,y;     /* Get ptr to next ring's patterns. */
0A37   3002             leax  2,x;      /* Get ptr to next ring's rotation. */
0A39   8CC8F1           cmpx  #0xC8F1;  /* Stop when last ring processed. */
0A3C   1023FEE9         lbls  P0929;

                 /* A certain amount of time after the energy cannon was */
                 /* destroyed, reset the ring scale/pattern structure    */
0A40   8620      P0A40: lda   #0x20;
0A42   918F             cmpa  0x8F;
0A44   253F             blo   P0A85;
0A46   2203             bhi   P0A4B;
0A48   BD0BA6           jsr   $init_ring_scale_factors;

                 /* See if we need to expand the inner walls */
0A4B   8EC8F3    P0A4B: ldx   #0xC8F3;  /* Search the scale/pattern array, */
0A4E   861E             lda   #0x1E;    /* and find out which entry is for */
0A50   A184             cmpa  ,x;       /* the outermost wall; it will have*/
0A52   270C             beq   P0A60;    /* a scale factor of 0x1E.  The 'x'*/
0A54   300A             leax  10,x;     /* register will point to the entry*/
0A56   A184             cmpa  ,x;       /* once it is found.               */
0A58   2706             beq   P0A60;
0A5A   300A             leax  10,x;
0A5C   A184             cmpa  ,x;
0A5E   2625             bne   P0A85;

0A60   3002      P0A60: leax  2,x;      /* Skip over the scale factor and the */
0A62   33881E           leau  0x1E,x;   /* first line pattern for this ring.  */
0A65   C607             ldb   #0x07;
0A67   A685      P0A67: lda   b,x;      /* This loop counts the number of */
0A69   AAC5             ora   b,u;      /* visible sections still left on */
0A6B   2702             beq   P0A6F;    /* the outermost ring.  The number*/
0A6D   0C91             inc   0x91;     /* of visible sections is saved in*/
0A6F   5A        P0A6F: decb;           /* C891.                          */
0A70   2CF5             bge   P0A67;

0A72   9691             lda   0x91;     /* See if any sections were left. */
0A74   260F             bne   P0A85;    /* Branch, if sections are still left.*/
0A76   8606             lda   #0x06;    /* Set up a new scale factor for this */
0A78   A71E             sta   -2,x;     /* ring (6), and make it the inner */
0A7A   A75E             sta   -2,u;     /* most ring.                      */
0A7C   86FF             lda   #0xFF;    /* Reset all the line patterns for */
0A7E   C607             ldb   #0x07;    /* this ring to 0xFF.              */
0A80   BDF552           jsr   $clear_block_to_a;
0A83   97EC             sta   0xEC;     /* Set the 'wall expanding' flag.  */

                 /* Update rotation value, so each ring rotates faster */
0A85   FCC930    P0A85: ldd   $C930;
0A88   D3F1             addd  0xF1;     /* Update rotation for ring 1. */
0A8A   DDF1             std   0xF1;
0A8C   FCC930           ldd   $C930;
0A8F   43               coma;
0A90   53               comb;
0A91   D3EF             addd  0xEF;     /* Update rotation for ring 2. */
0A93   DDEF             std   0xEF;
0A95   FCC930           ldd   $C930;
0A98   58               aslb;
0A99   49               rola;
0A9A   D3ED             addd  0xED;     /* Update rotation for ring 3. */
0A9C   DDED             std   0xED;
0A9E   9626             lda   0x26;     /* Expand rings everyother pass. */
0AA0   44               lsra;
0AA1   242E             bhs   P0AD1;

                 /* Continue expanding rings, if necessary */
0AA3   D6EC             ldb   0xEC;    /* If the 'expanding wall' flag  */
0AA5   272A             beq   P0AD1;   /* (C8EC) is set, then increment the */
0AA7   861E             lda   #0x1E;   /* scale factor for each of the 3 */
0AA9   8EC8F3           ldx   #0xC8F3; /* rings, until the outermost one */
0AAC   6C84             inc   ,x;      /* has a scale actor of 0x1E; at  */
0AAE   6C881E           inc   0x1E,x;  /* that point, clear the 'expanding */
0AB1   A184             cmpa  ,x;      /* wall' flag.                    */
0AB3   2602             bne   P0AB7;
0AB5   0FEC             clr   0xEC;
0AB7   300A      P0AB7: leax  10,x;    /* Increment the scale for the */
0AB9   6C84             inc   ,x;      /* next ring.                  */
0ABB   6C881E           inc   0x1E,x;
0ABE   A184             cmpa  ,x;
0AC0   2602             bne   P0AC4;
0AC2   0FEC             clr   0xEC;    /* Clear the 'expanding walls' flag. */
0AC4   300A      P0AC4: leax  10,x;    /* Increment the scale for the */
0AC6   6C84             inc   ,x;      /* next ring.                  */
0AC8   6C881E           inc   0x1E,x;
0ACB   A184             cmpa  ,x;
0ACD   2602             bne   P0AD1;
0ACF   0FEC             clr   0xEC;    /* Clear the 'expanding walls' flag. */

0AD1   968E      P0AD1: lda   0x8E;   /* Don't continue, if the energy cannon */
0AD3   1026F5FC         lbne  P00D3;  /* is being destroyed, or a new screen  */
0AD7   968F             lda   0x8F;   /* is being displayed.                  */
0AD9   2705             beq   P0AE0;
0ADB   0A8F             dec   0x8F;
0ADD   7E00D3           jmp   $P00D3;


                 /* Have the energy cannon track one of the cruiser */
0AE0   DC9F      P0AE0: ldd   0x9F;    /* Player 1 cruiser position. */
0AE2   BDF593           jsr   $convert_rise_run_to_angle;
0AE5   9780             sta   0x80;
0AE7   DCBF             ldd   0xBF;    /* Player 2 cruiser position. */
0AE9   BDF593           jsr   $convert_rise_run_to_angle;
0AEC   9781             sta   0x81;
0AEE   96DE             lda   0xDE;   /* Determine angle delta between */
0AF0   843F             anda  #0x3F;  /* cannon and cruiser 1.         */
0AF2   9080             suba  0x80;
0AF4   843F             anda  #0x3F;
0AF6   9782             sta   0x82;
0AF8   96DE             lda   0xDE;   /* Determine angle delta between */
0AFA   843F             anda  #0x3F;  /* cannon and cruiser 2.         */
0AFC   9081             suba  0x81;
0AFE   843F             anda  #0x3F;
0B00   D6A9             ldb   0xA9;   /* If game is over, then just rotate */
0B02   D5C9             bitb  0xC9;   /* cannon around.                    */
0B04   2A06             bpl   P0B0C;
0B06   8605             lda   #0x05;
0B08   9782             sta   0x82;
0B0A   2013             bra   P0B1F;

                 /* Determine which cruiser to track */
0B0C   5D        P0B0C: tstb;         /* One player is dead, so determine */
0B0D   2608             bne   P0B17;  /* which one is still alive, so we  */
0B0F   D6C9             ldb   0xC9;   /* can track him.                   */
0B11   260A             bne   P0B1D;
0B13   9182             cmpa  0x82;
0B15   2E06             bgt   P0B1D;
0B17   9782      P0B17: sta   0x82;
0B19   9681             lda   0x81;
0B1B   2002             bra   P0B1F;
0B1D   9680      P0B1D: lda   0x80;

                 /* Determine how to track one of the cruiser */
0B1F   D682      P0B1F: ldb   0x82;
0B21   9780             sta   0x80;
0B23   BDF584           jsr   $get_absolute_value_of_ab;
0B26   C43F             andb  #0x3F;
0B28   D781             stb   0x81;
0B2A   D783             stb   0x83;
0B2C   50               negb;
0B2D   C43F             andb  #0x3F;
0B2F   D181             cmpb  0x81;
0B31   2402             bhs   P0B35;
0B33   D781             stb   0x81;

                 /* Determine speed at which to track the cruiser */
0B35   B6C930    P0B35: lda   $C930;   /* Ring rotation delta. */
0B38   9181             cmpa  0x81;
0B3A   2553             blo   P0B8F;
0B3C   9680             lda   0x80;
0B3E   843F             anda  #0x3F;   /* Small delta; so track quickly. */
0B40   97DE             sta   0xDE;

                 /* See if opening exists in the 3 rings in front of cannon */
0B42   CEC8F3           ldu   #0xC8F3; /* Addr of ring pattern array. */
0B45   8EC8ED           ldx   #0xC8ED; /* Addr of ring 1 rotation value. */
0B48   96DE      P0B48: lda   0xDE;
0B4A   A081             suba  ,x++;
0B4C   44               lsra;
0B4D   44               lsra;
0B4E   840F             anda  #0x0F;   /* Determine which segment of the */
0B50   108E0F45         ldy   #0x0F45; /* ring is faced by the cannon.   */
0B54   A6A6             lda   a,y;
0B56   31C81E           leay  0x1E,u;  /* If both patterns are 0, then the */
0B59   E6C6             ldb   a,u;     /* segment is open.                 */
0B5B   EAA6             orb   a,y;
0B5D   2644             bne   P0BA3;    /* No opening exists. */
0B5F   334A             leau  10,u;     /* Opening exists in this ring; go */
0B61   8CC8F1           cmpx  #0xC8F1;  /* check the next one also.        */
0B64   23E2             bls   P0B48;

                 /* Fire a fireball at one of the star cruisers */
0B66   96E1             lda   0xE1;
0B68   2639             bne   P0BA3;   /* See if fireball is already in use. */
0B6A   03E1             com   0xE1;
0B6C   4F               clra;
0B6D   5F               clrb;
0B6E   DDE6             std   0xE6;    /* Set initial y position to 0. */
0B70   DDE8             std   0xE8;    /* Set initial x position to 0. */
0B72   D6DE             ldb   0xDE;
0B74   867F             lda   #0x7F;
0B76   BDF5FF           jsr   $convert_abs_angle_to_rise_run;
0B79   DD85             std   0x85;
0B7B   D685             ldb   0x85;
0B7D   BD0C31           jsr   $mult_rise_run_by_9;
0B80   DDE2             std   0xE2;    /* Save rise value. */
0B82   D686             ldb   0x86;
0B84   BD0C31           jsr   $mult_rise_run_by_9;
0B87   DDE4             std   0xE4;    /* Save run value. */
0B89   8606             lda   #0x06;
0B8B   97E0             sta   0xE0;    /* Set initial scale factor. */
0B8D   2014             bra   P0BA3;

                 /* Slowly turn energy cannon, to track a cruiser */
0B8F   8620      P0B8F: lda   #0x20;
0B91   9182             cmpa  0x82;    /* If the delta between the cannon */
0B93   2307             bls   P0B9C;   /* and the cruiser is > the ring   */
0B95   DCDE             ldd   0xDE;    /* rotation delta, then update the */
0B97   B3C930           subd  $C930;   /* cannons angle by the ring rotation */
0B9A   2005             bra   P0BA1;   /* delta only; as this increases, so */
0B9C   DCDE      P0B9C: ldd   0xDE;    /* will the tracking speed of the */
0B9E   F3C930           addd  $C930;   /* energy cannon.                 */
0BA1   DDDE      P0BA1: std   0xDE;
0BA3   7E00D3    P0BA3: jmp   $P00D3;

                 /*
                  * init_ring_scale_factors()
                  *
                  * This routine clears the scale/pattern buffer used
                  * to describe the 3 rings, and then sets the initial
                  * scale factors (0x0E, 0x16, 0x1E) for each of the rings.
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
                  */
                 init_ring_scale_factors:
0BA6   8EC8F3           ldx   #0xC8F3;   /* Clear the pattern buffer. */
0BA9   C63C             ldb   #0x3C;
0BAB   BDF53F           jsr   $clear_blockxb;
0BAE   8EC8F3           ldx   #0xC8F3;
0BB1   CC0E00           ldd   #0x0E00;   /* Set ring 1's scale factor. */
0BB4   ED84             std   ,x;
0BB6   ED881E           std   0x1E,x;
0BB9   300A             leax  10,x;
0BBB   CC1600           ldd   #0x1600;   /* Set ring 2's scale factor. */
0BBE   ED84             std   ,x;
0BC0   ED881E           std   0x1E,x;
0BC3   300A             leax  10,x;
0BC5   CC1E00           ldd   #0x1E00;   /* Set ring 3's scale factor. */
0BC8   ED84             std   ,x;
0BCA   ED881E           std   0x1E,x;
0BCD   A78828           sta   0x28,x;
0BD0   39               rts;


                 /*
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
                  */
                 change_player:
0BD1   8680             lda   #0x80;
0BD3   B7C975           sta   $C975;   /* Disable energy bomb 1 */
0BD6   B7C995           sta   $C995;   /* Disable energy bomb 2 */
0BD9   B7C9B5           sta   $C9B5;   /* Disable energy bomb 3 */
0BDC   B6C88F           lda   $C88F;   /* Re-init ring patterns, if energy */
0BDF   2702             beq   P0BE3;   /* cannon was destroyed. */
0BE1   8DC3             bsr   init_ring_scale_factors;
0BE3   7FC88F    P0BE3: clr   $C88F;
0BE6   8EC9C8           ldx   #0xC9C8;  /* Clear the bullet buffer. */
0BE9   C658             ldb   #0x58;
0BEB   BDF53F           jsr   $clear_blockxb;
0BEE   8D0D             bsr   prepare_for_backup;
0BF0   F7C8DC           stb   $C8DC;   /* Save next player indicator. */
0BF3   BDF683           jsr   $move_block2;
0BF6   8D05             bsr   prepare_for_backup;
0BF8   1E31             exg   u,x;
0BFA   7EF683           jmp   $move_block2;


                 /*
                  * prepare_for_backup()
                  *
                  * This procedure initializes the 'a' register with the
                  * count of the number of bytes to backup, the 'u' register
                  * with the address of the active players ring pattern array,
                  * and the 'x' register with the address of the backup area
                  * associated with the player being backed up; C8DC indicates
                  * which player is being backed up.
                  */
                 prepare_for_backup:
0BFD   CEC8F3           ldu   #0xC8F3;   /* Load 'u' w/ ptr to ring patterns.*/
0C00   8ECA25           ldx   #0xCA25;
0C03   863F             lda   #0x3F;
0C05   F6C8DC           ldb   $C8DC;
0C08   2703             beq   P0C0D;
0C0A   8ECA64           ldx   #0xCA64;
0C0D   53        P0C0D: comb;            /* Switch flag to show other user */
0C0E   39        P0C0E: rts;             /* is now active.                 */


                 /*
                  * init_ship_count_buffer()
                  *
                  * Initialize the buffer used to display the number of
                  * ships left for a user to the following:
                  *
                  *   "   ",0x80,0x80,0x80,0x80,0x80,0x80,0x80
                  *
                  * The buffer starts at C932
                  */
                 init_ship_count_buffer:
0C0F   8EC932           ldx   #0xC932;
0C12   C609             ldb   #0x09;
0C14   BDF550           jsr   $clear_block_to_0x80;
0C17   8620             lda   #0x20;
0C19   A784             sta   ,x;
0C1B   A701             sta   1,x;
0C1D   A702             sta   2,x;
0C1F   39        P0C1F: rts;


                 /*
                  * fill_ship_count_buffer()
                  *
                  * Fill the ship count buffer with a little spaceship
                  * figure, one for each ship the user has left.  If he
                  * has more than 9 ships left, then display "X" instead
                  * of the spaceship.
                  *
                  * At entry:
                  *     'a' = number of ships.
                  */
                 fill_ship_count_buffer:
0C20   C668             ldb   #0x68;  /* Code for small spaceship figure. */
0C22   8109             cmpa  #0x09;
0C24   2304             bls   P0C2A;
0C26   8609             lda   #0x09;
0C28   C010             subb  #0x10;   /* Use "X" instead. */
0C2A   4A        P0C2A: deca;
0C2B   2FF2             ble   P0C1F;
0C2D   E780             stb   ,x+;     /* Fill the buffer. */
0C2F   20F9             bra   P0C2A;


                 /*
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
                  */
                 mult_rise_run_by_9:
0C31   8609             lda   #0x09;
                 mult_rise_run_by_a:
0C33   0F83             clr   0x83;
0C35   5D               tstb;
0C36   2A02             bpl   P0C3A;
0C38   0C83             inc   0x83;    /* Keep track if value is negative. */
0C3A   BDF584    P0C3A: jsr   $get_absolute_value_of_ab;
0C3D   3D               mul;
0C3E   DD80             std   0x80;
0C40   0483             lsr   0x83;
0C42   2407             bhs   P0C4B;
0C44   43               coma;          /* If the rise/run value was negative */
0C45   53               comb;          /* then take twos complement, to make */
0C46   C30001           addd  #0x0001; /* the result negative also.          */
0C49   DD80             std   0x80;
0C4B   39        P0C4B: rts;

                 /*
                  * draw_1_ring()
                  *
                  * This routine will draw one of the 3 rings (castle walls).
                  *
                  * At entry:
                  *     'x' points to (y,x) vector list for this ring.
                  *     'u' points to scale/pattern buffer for this ring.
                  *
                  * Drawing will cease when a pattern > 0 is encountered.
                  */
                 draw_1_ring:
0C4C   86CE             lda   #0xCE;
0C4E   970C             sta   0x0C;
0C50   E6C0             ldb   ,u+;     /* Grab the scale factor. */
0C52   D704             stb   0x04;
0C54   EC84      P0C54: ldd   ,x;      /* Grab the vector endpoint. */
0C56   9701             sta   0x01;
0C58   0F00             clr   0x00;
0C5A   A6C0             lda   ,u+;     /* Grab the line pattern to use. */
0C5C   3002             leax  2,x;
0C5E   0C00             inc   0x00;
0C60   D701             stb   0x01;
0C62   970A             sta   0x0A;
0C64   0F05             clr   0x05;
0C66   CC0040           ldd   #0x0040;
0C69   D50D      P0C69: bitb  0x0D;
0C6B   27FC             beq   P0C69;
0C6D   12               nop;
0C6E   970A             sta   0x0A;
0C70   A6C4             lda   ,u;      /* Stop, when end of pattern list is */
0C72   2FE0             ble   P0C54;   /* reached (pattern > 0).            */
0C74   7EF34F           jmp   $check0ref;


                 /*
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
                  */
                 update_players_score:
0C77   8EC8AC           ldx   #0xC8AC;
0C7A   1183C9F4         cmpu  #0xC9F4;  /* Determine which player to credit */
0C7E   2503             blo   P0C83;    /* with the hit.                    */
0C80   8EC8CC           ldx   #0xC8CC;
0C83   3004      P0C83: leax  4,x;      /* Get addr of player's score string. */
0C85   7EF87C           jmp   $add_d_to_x_in_bcd;


                 /*
                  * make_game_sounds()
                  *
                  * This routine is responsible for making all of the
                  * sound associated with the game.  It uses a bit mask
                  * in C890 to decide which sounds to make at any given
                  * moment.
                  */
                 make_game_sounds:
0C88   BDF533           jsr   $init_music_buf;
0C8B   0F45             clr   0x45;
0C8D   108ECAA3         ldy   #0xCAA3;
0C91   CE0CE0           ldu   #0x0CE0;
0C94   CC0380           ldd   #0x0380;
0C97   DD96             std   0x96;
0C99   86B1             lda   #0xB1;
0C9B   9499             anda  0x99;
0C9D   9799             sta   0x99;
0C9F   968D             lda   0x8D;
0CA1   9798             sta   0x98;
0CA3   2634             bne   P0CD9;
0CA5   9690             lda   0x90;
0CA7   9A99             ora   0x99;
0CA9   979A             sta   0x9A;
0CAB   9697      P0CAB: lda   0x97;
0CAD   949A             anda  0x9A;
0CAF   2720             beq   P0CD1;
0CB1   1F89             tfr   a,b;
0CB3   9A98             ora   0x98;
0CB5   9798             sta   0x98;
0CB7   D590             bitb  0x90;
0CB9   2604             bne   P0CBF;
0CBB   D499             andb  0x99;
0CBD   2608             bne   P0CC7;
0CBF   EC42      P0CBF: ldd   2,u;
0CC1   EDA4             std   ,y;
0CC3   EC44             ldd   4,u;
0CC5   ED22             std   2,y;
0CC7   ADD4      P0CC7: jsr   [,u];/* (UNKNOWN JUMP) */
0CC9   9696             lda   0x96;
0CCB   270C             beq   P0CD9;
0CCD   8608             lda   #0x08;
0CCF   9746             sta   0x46;
0CD1   3347      P0CD1: leau  7,u;
0CD3   3124             leay  4,y;
0CD5   0497             lsr   0x97;
0CD7   26D2             bne   P0CAB;
0CD9   9698      P0CD9: lda   0x98;
0CDB   9799             sta   0x99;
0CDD   0F90             clr   0x90;
0CDF   39               rts;


                 /*
                  * Table of sound routine addresses, and data
                  *
                  *     2 byte subroutine address.
                  *     5 bytes of data.
                  */
0CE0   0D        S0CE0: .word 0x0DBF;
0CE2   00               .byte 0x00,0x00,0x00,x000,0xFF;
0CE7   0D               .word 0x0D93;
0CE9   0A               .byte 0x0A,0x00,0x0E,0x08,0xFF;
0CEE   0D               .word 0x0D6C;
0CF0   02               .byte 0x02,0x80,0x0C,0x0B,0x00;
0CF5   0D               .word 0x0D85;
0CF7   00               .byte 0x00,0x90,0x0E,0x08,0xFF;
0CFC   0D               .word 0x0D60;
0CFE   00               .byte 0x00,0x90,0x09,0x00,0x00;
0D03   0D               .word 0x0D93;
0D05   00               .byte 0x00,0x00,0x09,0x00,0x03;
0D0A   0D               .word 0x0D54;
0D0C   00               .byte 0x00,0x90,0x0C,0x08,0x00;
0D11   0D               .word 0x0D18;
0D13   08               .byte 0x08,0x80,0x0D,0x60,0x00;

0D18   9E92      P0D18: ldx   0x92;
0D1A   AFA4             stx   ,y;
0D1C   3440             pshs  u;
0D1E   9691             lda   0x91;
0D20   4A               deca;
0D21   8406             anda  #0x06;
0D23   CE0DEE           ldu   #0x0DEE;
0D26   ECC6             ldd   a,u;
0D28   10A3A4           cmpd  ,y;
0D2B   2206             bhi   P0D33;
0D2D   0F94             clr   0x94;
0D2F   301C             leax  -4,x;
0D31   2019             bra   P0D4C;
0D33   830080    P0D33: subd  #0x0080;
0D36   10A3A4           cmpd  ,y;
0D39   220B             bhi   P0D46;
0D3B   8604             lda   #0x04;
0D3D   D694             ldb   0x94;
0D3F   2B01             bmi   P0D42;
0D41   40               nega;
0D42   3086      P0D42: leax  a,x;
0D44   2006             bra   P0D4C;
0D46   4F        P0D46: clra;
0D47   43               coma;
0D48   9794             sta   0x94;
0D4A   3004             leax  4,x;
0D4C   AFA4      P0D4C: stx   ,y;
0D4E   9F92             stx   0x92;
0D50   3540             puls  u;
0D52   203F             bra   P0D93;
0D54   4F        P0D54: clra;
0D55   D695             ldb   0x95;
0D57   8E0090           ldx   #0x0090;
0D5A   308B             leax  d,x;
0D5C   AFA4             stx   ,y;
0D5E   2033             bra   P0D93;
0D60   9626      P0D60: lda   0x26;
0D62   841E             anda  #0x1E;
0D64   8A14             ora   #0x14;
0D66   48               asla;
0D67   48               asla;
0D68   A721             sta   1,y;
0D6A   2027             bra   P0D93;
0D6C   AEA4      P0D6C: ldx   ,y;
0D6E   6A23             dec   3,y;
0D70   2745             beq   P0DB7;
0D72   A623             lda   3,y;
0D74   810A             cmpa  #0x0A;
0D76   2409             bhs   P0D81;
0D78   8107             cmpa  #0x07;
0D7A   2603             bne   P0D7F;
0D7C   8E0080           ldx   #0x0080;
0D7F   300A      P0D7F: leax  10,x;
0D81   AFA4      P0D81: stx   ,y;
0D83   200E             bra   P0D93;
0D85   AEA4      P0D85: ldx   ,y;
0D87   6A23             dec   3,y;
0D89   272C             beq   P0DB7;
0D8B   4F               clra;
0D8C   9746             sta   0x46;
0D8E   308810           leax  0x10,x;
0D91   AFA4             stx   ,y;
0D93   8EC842    P0D93: ldx   #0xC842;
0D96   0A96             dec   0x96;
0D98   9696             lda   0x96;
0D9A   E622             ldb   2,y;
0D9C   E786             stb   a,x;
0D9E   48               asla;
0D9F   8B05             adda  #0x05;
0DA1   3086             leax  a,x;
0DA3   ECA4             ldd   ,y;
0DA5   ED84             std   ,x;
0DA7   8E0DF6           ldx   #0x0DF6;
0DAA   A646             lda   6,u;
0DAC   2B08             bmi   P0DB6;
0DAE   9B96             adda  0x96;
0DB0   A686             lda   a,x;
0DB2   9A45             ora   0x45;
0DB4   9745             sta   0x45;
0DB6   39        P0DB6: rts;
0DB7   9697      P0DB7: lda   0x97;
0DB9   43               coma;
0DBA   9498             anda  0x98;
0DBC   9798             sta   0x98;
0DBE   39               rts;


0DBF   9690      P0DBF: lda   0x90;
0DC1   9497             anda  0x97;
0DC3   2702             beq   P0DC7;
0DC5   9767             sta   0x67;
0DC7   3440      P0DC7: pshs  u;
0DC9   8603             lda   #0x03;
0DCB   9746             sta   0x46;
0DCD   969B             lda   0x9B;
0DCF   CE0DDE           ldu   #0x0DDE;
0DD2   48               asla;
0DD3   48               asla;
0DD4   33C6             leau  a,u;
0DD6   BDF92E           jsr   $generate_explosion_sound;
0DD9   0F96             clr   0x96;
0DDB   3540             puls  u;
0DDD   9677             lda   0x77;
0DDF   27D6             beq   P0DB7;
0DE1   39               rts;

                 /* Data describing the explosion sounds */
0DE2   38               .byte 0x38, 0x3F, 0x00, 0x01;
0DE6   19               .byte 0x19, 0x3F, 0x00, 0x02;
0DEA   38               .byte 0x38, 0x3F, 0x00, 0x10;

0DEE   04        S0DEE: .byte 0x04;
0DEF   00               .byte 0x00;
0DF0   07               .byte 0x07;
0DF1   00               .byte 0x00;
0DF2   09               .byte 0x09;
0DF3   00               .byte 0x00;
0DF4   0A               .byte 0x0A;
0DF5   00               .byte 0x00;

0DF6   20        S0DF6: .byte 0x20;
0DF7   10               .byte 0x10;
0DF8   08               .byte 0x08;
0DF9   04               .byte 0x04;
0DFA   02               .byte 0x02;
0DFB   01               .byte 0x01;

                star_castle_music:
0DFC   FE               .word 0xFEE8;
0DFE   FE               .word 0xFEB6;
0E00   90               .byte 0x90;
0E01   18               .byte 0x18;
0E02   12               .byte 0x12;
0E03   18               .byte 0x18;
0E04   06               .byte 0x06;
0E05   93               .byte 0x93;
0E06   18               .byte 0x18;
0E07   06               .byte 0x06;
0E08   90               .byte 0x90;
0E09   18               .byte 0x18;
0E0A   06               .byte 0x06;
0E0B   84               .byte 0x84;
0E0C   87               .byte 0x87;
0E0D   18               .byte 0x18;
0E0E   12               .byte 0x12;
0E0F   80               .byte 0x80;
0E10   90               .byte 0x90;
0E11   13               .byte 0x13;
0E12   12               .byte 0x12;
0E13   87               .byte 0x87;
0E14   17               .byte 0x17;
0E15   0C               .byte 0x0C;
0E16   85               .byte 0x85;
0E17   15               .byte 0x15;
0E18   06               .byte 0x06;
0E19   84               .byte 0x84;
0E1A   8C               .byte 0x8C;
0E1B   13               .byte 0x13;
0E1C   30               .byte 0x30;
0E1D   07               .byte 0x07;
0E1E   80               .byte 0x80;


                 /* Vector list for player 1's star cruiser */
                 star_cruiser1:
0E1F   1C               .byte 0x1C,0xF8;
0E21   CE               .byte 0xCE,0xFC;
0E23   1C               .byte 0x1C,0x08;
0E25   DC               .byte 0xDC,0xE8;
0E27   14               .byte 0x14,0x1C;
0E29   EC               .byte 0xEC,0x1C;
0E2B   24               .byte 0x24,0xE8;
0E2D   E4               .byte 0xE4,0x08;
0E2F   32               .byte 0x32,0xFC;


                 /* Vector list for player 2's star cruiser */
                 star_cruiser2:
0E31   1C               .byte 0x1C,0xF8;
0E33   CE               .byte 0xCE,0xFC;
0E35   1C               .byte 0x1C,0x08;
0E37   EC               .byte 0xEC,0xE8;
0E39   F8               .byte 0xF8,0x0C;
0E3B   0C               .byte 0x0C,0x10;
0E3D   F4               .byte 0xF4,0x10;
0E3F   08               .byte 0x08,0x0C;
0E41   14               .byte 0x14,0xE8;
0E43   E4               .byte 0xE4,0x04;
0E45   32               .byte 0x32,0xFC;


                 /* Vector list for the energy cannon */
                 energy_cannon:
0E47   04               .byte 0x04,0x18;
0E49   04               .byte 0x04,0xE0;
0E4B   14               .byte 0x14,0xF8;
0E4D   FC               .byte 0xFC,0x14;
0E4F   F4               .byte 0xF4,0x08;
0E51   08               .byte 0x08,0xDC;
0E53   EC               .byte 0xEC,0x0C;
0E55   EC               .byte 0xEC,0xF4;
0E57   08               .byte 0x08,0x24;
0E59   F4               .byte 0xF4,0xF8;
0E5B   FC               .byte 0xFC,0xEC;
0E5D   14               .byte 0x14,0x08;
0E5F   04               .byte 0x04,0x20;


                 fireball:
0E61   EC               .byte 0xEC,0xEC;
0E63   30               .byte 0x30,0x14;
0E65   D0               .byte 0xD0,0x14;
0E67   14               .byte 0x14,0xD0;
0E69   14               .byte 0x14,0x30;
0E6B   D0               .byte 0xD0,0xEC;
0E6D   30               .byte 0x30,0xEC;
0E6F   EC               .byte 0xEC,0x30;
0E71   EC               .byte 0xEC,0xD0;


                 /*
                  * Table of pointers to vector lists, having the
                  * following format:
                  *
                  *  line pattern, rel y, rel x,
                  *  line pattern, rel y, rel x,
                  *         .
                  *         .
                  *  0x01
                  *
                  * These look like they are vector lists for the energy
                  * bombs.  By displaying these various patterns, you
                  * get the impression that the bomb is twinkling.
                  */
                 energy_bomb_VL_table:
0E73   0E               .word 0x0E83;
0E75   0E               .word 0x0E99;
0E77   0E               .word 0x0EAF;
0E79   0E               .word 0x0EC5;
0E7B   0E               .word 0x0EDB;
0E7D   0E               .word 0x0EF1;
0E7F   0F               .word 0x0F07;
0E81   0F               .word 0x0F1D;


0E83   FF        S0E83: .byte 0xFF,0x0A,0xF6;
0E86   00               .byte 0x00,0x00,0x14;
0E89   FF               .byte 0xFF,0xEC,0xEC;
0E8C   00               .byte 0x00,0x00,0x14;
0E8F   FF               .byte 0xFF,0x0A,0xF6;
0E92   00               .byte 0x00,0x0C,0xF4;
0E95   FF               .byte 0xFF,0x04,0xFC;
0E98   01               .byte 0x01;

0E99   FF       S0E99:  .byte 0xFF,0x0A,0xF6;
0E9C   00               .byte 0x00,0x00,0x14;
0E9F   FF               .byte 0xFF,0xEC,0xEC;
0EA2   00               .byte 0x00,0x00,0x14;
0EA5   FF               .byte 0xFF,0x0A,0xF6;
0EA8   00               .byte 0x00,0x0A,0x06;
0EAB   FF               .byte 0xFF,0x0C,0x08;
0EAE   01               .byte 0x01;

0EAF   FF      S0EAF:   .byte 0xFF,0x0A,0xF6;
0EB2   00               .byte 0x00,0x00,0x14;
0EB5   FF               .byte 0xFF,0xEC,0xEC;
0EB8   00               .byte 0x00,0x00,0x14;
0EBB   FF               .byte 0xFF,0x0A,0xF6;
0EBE   00               .byte 0x00,0xFE,0x06;
0EC1   FF               .byte 0xFF,0x04,0x0C;
0EC4   01               .byte 0x01;

0EC5   FF      S0EC5:   .byte 0xFF,0x0A,0xF6;
0EC8   00               .byte 0x00,0x00,0x14;
0ECB   FF               .byte 0xFF,0xEC,0xEC;
0ECE   00               .byte 0x00,0x00,0x14;
0ED1   FF               .byte 0xFF,0x0A,0xF6;
0ED4   00               .byte 0x00,0xFA,0x08;
0ED7   FF               .byte 0xFF,0x04,0x04;
0EDA   01               .byte 0x01;

0EDB   FF      S0EDB:   .byte 0xFF,0x0A,0xF6;
0EDE   00               .byte 0x00,0x00,0x14;
0EE1   FF               .byte 0xFF,0xEC,0xEC;
0EE4   00               .byte 0x00,0x00,0x14;
0EE7   FF               .byte 0xFF,0x0A,0xF6;
0EEA   00               .byte 0x00,0xF6,0x06;
0EED   FF               .byte 0xFF,0xF8,0x04;
0EF0   01               .byte 0x01;

0EF1   FF      S0EF1:   .byte 0xFF,0x0A,0xF6;
0EF4   00               .byte 0x00,0x00,0x14;
0EF7   FF               .byte 0xFF,0xEC,0xEC;
0EFA   00               .byte 0x00,0x00,0x14;
0EFD   FF               .byte 0xFF,0x0A,0xF6;
0F00   00               .byte 0x00,0xF4,0xF8;
0F03   FF               .byte 0xFF,0xFC,0x08;
0F06   01               .byte 0x01;

0F07   FF      S0F07:   .byte 0xFF,0x0A,0xF6;
0F0A   00               .byte 0x00,0x00,0x14;
0F0D   FF               .byte 0xFF,0xEC,0xEC;
0F10   00               .byte 0x00,0x00,0x14;
0F13   FF               .byte 0xFF,0x0A,0xF6;
0F16   00               .byte 0x00,0xF4,0xF4;
0F19   FF               .byte 0xFF,0xF8,0xF8;
0F1C   01               .byte 0x01;

0F1D   FF      S0F1D:   .byte 0xFF,0x0A,0xF6;
0F20   00               .byte 0x00,0x00,0x14;
0F23   FF               .byte 0xFF,0xEC,0xEC;
0F26   00               .byte 0x00,0x00,0x14;
0F29   FF               .byte 0xFF,0x0A,0xF6;
0F2C   00               .byte 0x00,0x06,0xF4;
0F2F   FF               .byte 0xFF,0xFC,0xFC;
0F32   01               .byte 0x01;


                 /* Vector list for a ring (castle wall) */
                 ring:
0F33   28               .byte 0x28,0x64;
0F35   3C               .byte 0x3C,0xC4;
0F37   00               .byte 0x00,0xB0;
0F39   C4               .byte 0xC4,0xC4;
0F3B   B0               .byte 0xB0,0x00;
0F3D   C4               .byte 0xC4,0x3C;
0F3F   00               .byte 0x00,0x50;
0F41   3C               .byte 0x3C,0x3C;
0F43   50               .byte 0x50,0x00;


0F45   09        S0F45: .byte 0x09;
0F46   02               .byte 0x02;
0F47   02               .byte 0x02;
0F48   03               .byte 0x03;
0F49   03               .byte 0x03;
0F4A   04               .byte 0x04;
0F4B   04               .byte 0x04;
0F4C   05               .byte 0x05;
0F4D   05               .byte 0x05;
0F4E   06               .byte 0x06;
0F4F   06               .byte 0x06;
0F50   07               .byte 0x07;
0F51   07               .byte 0x07;
0F52   08               .byte 0x08;
0F53   08               .byte 0x08;
0F54   09               .byte 0x09;


                 explosion_star:
0F55   FF               .byte 0xFF,0x40,0x00;
0F58   00               .byte 0x00,0xC0,0x00;
0F5B   FF               .byte 0xFF,0x00,0x40;
0F5E   00               .byte 0x00,0x00,0xC0;
0F61   FF               .byte 0xFF,0xC0,0x00;
0F64   00               .byte 0x00,0x40,0x00;
0F67   FF               .byte 0xFF,0x00,0xC0;
0F6A   00               .byte 0x00,0x00,0x40;
0F6D   FF               .byte 0xFF,0x40,0x40;
0F70   00               .byte 0x00,0xC0,0xC0;
0F73   FF               .byte 0xFF,0xC0,0x40;
0F76   00               .byte 0x00,0x40,0xC0;
0F79   FF               .byte 0xFF,0xC0,0xC0;
0F7C   00               .byte 0x00,0x40,0x40;
0F7F   FF               .byte 0xFF,0x40,0xC0;
0F82   00               .byte 0x00,0xC0,0x40;
0F85   01               .byte 0x01;

                 explosion_dots:
0F86   35               .byte 0x35,0x00;
0F88   F3               .byte 0xF3,0x0D;
0F8A   F3               .byte 0xF3,0xFF;
0F8C   E1               .byte 0xE1,0x26;
0F8E   EC               .byte 0xEC,0x03;
0F90   F3               .byte 0xF3,0xE6;
0F92   EB               .byte 0xEB,0x00;
0F94   F1               .byte 0xF1,0xEC;
0F96   10               .byte 0x10,0xF1;
0F98   FA               .byte 0xFA,0xEE;
0F9A   1D               .byte 0x1D,0xF8;
0F9C   0F               .byte 0x0F,0xE4;
0F9E   0F               .byte 0x0F,0x12;
0FA0   19               .byte 0x19,0xF7;
0FA2   06               .byte 0x06,0x1A;

                 author:
0FA4   20               .byte 0x20;
0FA5   90               .byte 0x90;
0FA6   50               .byte "PROGRAMMED BY",0x80;
0FB4   E0               .byte 0xE0;
0FB5   90               .byte 0x90;
0FB6   57               .byte "WILLIAM HAWKINS",0x80;
0FC6   90               .byte 0x90;
0FC7   C0               .byte 0xC0;
0FC8   47               .byte "GT 1983   ",0x80,0x00;

                 game_over:
0FD4   58               .byte 0x58;
0FD5   D0               .byte 0xD0;
                 game_over2:
0FD6   47               .byte "GAME OVER",0x80;

                 player1:
0FE0   48               .byte 0x48;
0FE1   D0               .byte 0xD0;
0FE2   50               .byte "PLAYER 1",0x80;

                 player2:
0FEB   48               .byte 0x48;
0FEC   D0               .byte 0xD0;
0FED   50               .byte "PLAYER 2",0x80;

0FF6   00               .byte 0x00;
0FF7   00               .byte 0x00;
0FF8   00               .byte 0x00;
0FF9   00               .byte 0x00;
0FFA   00               .byte 0x00;
0FFB   00               .byte 0x00;
0FFC   00               .byte 0x00;
0FFD   00               .byte 0x00;
0FFE   00               .byte 0x00;
0FFF   00               .byte 0x00;

