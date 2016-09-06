/*
 * This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
 * Please forward any comments, corrections or additions back to Fred.
 *
 * Berzerk
 *
 ******************************************************************************
 *
 * The following are possible bugs discovered in this code:
 *
 *    DisplayBonusString
 *            When checking to see if the bonus strings should be displayed,
 *            the 'ble' command really should be a 'blt'!!  This explains why
 *            when a player clears a maze containing 10 robots, the bonus
 *            string was not displayed.  In this case the bonus string is
 *            "   100", and this fails the above check!
 *
 *    DisplayLives
 *            There is no check to see if the C8D8 buffer is overrun (this
 *            is the buffer used to display the number of lives a player has);
 *            what is the intended size of this buffer?
 *
 *    FireBullet
 *            There seems to be the potential to overwrite the stack when
 *            firing bullets.  The array of bullet entries can grow very
 *            quickly as a player gets better, since robots can fire more
 *            bullets (and fire them more quickly).  The end of the array
 *            only gets moved back when the last bullet hits something and
 *            becomes inactive.  It would be better to modify FireBullet()
 *            to only allow a certain number of bullets (or to do a better
 *            job of compacting the array).
 *
 ******************************************************************************
 *
 * The following is the memory map for Berzerk RAM usage:
 *
 * C880-C881     Points to player structure for the current player.
 *
 * C882          Number of players: 0 = 1 player, 1 = 2 players
 *
 * C883          Controls maximum number of bullets a robot can fire in a
 *               burst; takes a big jump when user's score surpasses 10,000
 *               points.
 *
 * C884          Velocity factor used when firing robot's bullets.
 *
 * C885          Work memory and loop counter.
 *
 * C886          Flag; don't draw player if set < 0
 *
 * C88F-C890     Player's position
 *
 * C891          Work memory
 *
 * C892          Work memory
 *
 * C893-C894     Otto's position (y,x)
 *
 * C895-C896     Player's position (starting position); used to seed Otto's
 *               initial position.
 *
 * C897          Counter; controls bouncing offset for Otto's 'y' position
 *
 * C898          Otto's movement velocity
 *
 * C899          After a point is mapped into a quadrant number, this contains
 *               the bitmask describing which walls are present in that
 *               quadrant:
 *
 *                      ---------------------------------
 *                      | 0 | 0 | 0 | 0 | B | T | R | L |
 *                      ---------------------------------
 *           Quadrant has Bottom Wall-----^
 *           Quadrant has Top Wall------------^
 *           Quadrant has Right Wall--------------^
 *           Quadrant has Left Wall-------------------^
 *
 * C89A          Quadrant into which a point falls:
 *
 *                   -100 -60 -20 +20 +60 +100
 *                     +---+---+---+---+---+ +96
 *                     | 0 | 1 | 2 | 3 | 4 |
 *                     +---o---o---o---o---+ +32
 *                     | 5 | 6 | 7 | 8 | 9 |
 *                     +---o---o---o---o---+ -32
 *                     |10 |11 |12 |13 |14 |
 *                     +---+---+---+---+---+ -96
 *
 * C89B-C89C     After a point is mapped into a quadrant number, this contains
 *               the point as a relative offset from the lower left corner
 *               of the quadrant.
 *
 * C89D          Work memory/counter
 *
 * C89E-C89F     During game, work memory; usually contains a position (y,x).
 *               After a game, C89F is a semaphore causing author's initials
 *               to be displayed;also used as a counter
 *
 * C8A1          Work memory and loop counter.
 *
 * C8A2          Work memory and loop counter.
 *
 * C8A7          Delay (placed in the robot's structure) between how often
 *               a robot is updated (moved, fire, etc); 0 = no delay.
 *
 * C8A8          Used while populating a level with robots; if the random
 *               number is < C8A8, then a robot is placed in the maze.
 *
 * C8A9          Used during robot processing.
 *
 * C8AA          Used during robot processing.
 *
 * C8AB-C8B2     Array of byte-long offsets, telling which walls are to be
 *               drawn from each of the 8 possible starting points within
 *               the maze (0=up, 2=down, 4=to right, 6=to left).  The 8
 *               possible starting points are shown below:
 *
 *                   -100 -60 -20 +20 +60 +100
 *                     +---+---+---+---+---+ +96
 *                     |                   |
 *                     +   o   o   o   o   + +32
 *                     |                   |
 *                     +   o   o   o   o   + -32
 *                     |                   |
 *                     +---+---+---+---+---+ -96
 *
 * C8B5-C8C3     Array of masks (1 per quadrant) indicating which walls are
 *               present in the quadrant.  The mask values are:
 *
 *                     0x01 = left wall
 *                     0x02 = right wall
 *                     0x04 = top wall
 *                     0x08 = bottom wall
 *
 *               C8B5 refers to quadrant 0, C8B6 to quadrant 1, etc.
 *
 * C8C5          Jump table index based on the player's current state:
 *
 *                     0 = player is alive
 *                     2 = player has left the maze
 *                     4 = player has died
 *
 * C8C6          Indicates if one of the maze doors should be closed off:
 *
 *                       ---------------------------------
 *                       | 0 | 0 | 0 | T | B | L | R | 0 |
 *                       ---------------------------------
 *                     Block Top Door--^
 *                     Block Bottom Door---^
 *                     Block Left Door---------^
 *                     Block Right Door------------^
 *
 * C8C7          Number of robots initially seeded into the maze
 *
 * C8C8          Number of robots still alive
 *
 * C8C9-C8CA     Indirect jump pointer
 *
 * C8CB          Intensity value used by DrawWithPossibleScrolling()
 *
 * C8CC          Index of the last bullet in use
 *
 * C8CD          Cleared in one place, then never again used.
 *
 * C8CE          Indicates state of player's legs:
 *
 *                     0 = player is standing still
 *                     2 = player is running right (wide legs)
 *                     4 = player is running right (close legs)
 *                     6 = player is running left (close legs)
 *                     8 = player is running left (wide legs)
 *
 * C8CF          Indicates the state of the player's arms:
 *
 *                  When player is running:
 *                     0x00 = arms moving to the right
 *                     0x02 = arms moving to the left
 *
 *                  When player is standing still:
 *                     0x00 = arms neutral
 *                     0x02 = arms shooting left
 *                     0x04 = arms shooting right
 *                     0x06 = arms shooting up
 *                     0x08 = arms shooting 45 degrees upper left
 *                     0x0A = arms shooting 45 degrees upper right
 *                     0x0C = arms shooting down
 *                     0x0E = arms shooting 45 degrees lower left
 *                     0x10 = arms shooting 45 degrees lower right
 *
 * C8D0          Intensity used when drawing a 'fried' player
 *
 * C8D1-C8D7     Bonus score string buffer
 *
 * C8D8-????     Buffer used when displaying number of lives a player has.
 *
 * C8DE          'y' delta between 2 points, as determined by
 *               DetermineDirectionToMove()
 *
 * C8DF          'x' delta between 2 points, as determined by
 *               DetermineDirectionToMove()
 *
 * C8E0          Used during scrolling; used to calculate 'y' delta
 *
 * C8E1          Used during scrolling; used to calculate 'x' delta
 *
 * C8E2-C8E3     Used during scrolling; delta added to 'y' drawing point
 *
 * C8E4-C8E5     Used during scrolling; delta added to 'x' drawing point
 *
 * C8E6          Used during scrolling; 0 if scrolling in a + direction (right
 *               or up), 0x80 if scrolling in a - direction (down or left)
 *
 * C8E7-C8E8     Work memory (used by DetermineDirectionToMove)
 *
 * C8E9          Loop counter
 *
 * C8EA          Mask showing joystick position and fire button state:
 *
 *                       ---------------------------------
 *                       | 0 | 0 | B | L | D | U | R | L |
 *                       ---------------------------------
 *                 Button Pressed--^
 *                 Joystick Left-------^---------------^
 *                 Joystick Down-----------^
 *                 Joystick Up-----------------^
 *                 Joystick Right------------------^
 *
 * C8EB          Direction current object is traveling (work memory):
 *
 *                       ---------------------------------
 *                       | 0 | 0 | 0 | L | D | U | R | L |
 *                       ---------------------------------
 *                 Joystick Left-------^---------------^
 *                 Joystick Down-----------^
 *                 Joystick Up-----------------^
 *                 Joystick Right------------------^
 *
 * C900-C90D     Player 1 structure
 * C90E-C91B     Player 2 structure
 *
 *               byte    meaning
 *               ----    -------
 *               0-6     player's score
 *               7       unused
 *               8       number of lives
 *               9       Flag specifying if 5000 point bonus was given
 *               10      player's y position
 *               11      player's x position
 *               12-13   unused
 *
 * C91C-C973     Array of robot structures (11 entries)
 *
 *               byte    meaning
 *               ----    -------
 *               0       robot's y position.
 *               1       robot's x position.
 *               2       flag: 0x80 = alive, 0 = gone, 0x0F = just killed
 *               3       direction of travel(0-10); indexes into extremities tbl
 *               4       Eye box to draw (0, 2, 4, 6)
 *               5       Delay before robot starts shooting (0-7)
 *               6       # of bullets robot can fire in a burst
 *               7       Delay between processing a robot (moving, firing, etc)
 *
 * C974-????     Array of bullet structures
 *
 *               byte    meaning
 *               ----    -------
 *               0       y position of bullet's tail
 *               1       x position of bullet's tail
 *               2       y delta between bullet's head and tail
 *               3       x delta between bullet's head and tail
 *               4       y position of bullet's head
 *               5       x position of bullet's head
 *               6       velocity factor
 *               7       direction of travel; anded w/ 0xF0 when hits something
 *
 ******************************************************************************
 */

                        .org 0x0000;
0000   67               .string "g GCE 1982",0x80;

000B   FD1D             .word #berzerk_music_block;

000D   F8               .byte 0xF8; /* height */
000E   50               .byte 0x50; /* width */
000F   20               .byte 0x20; /* rel y */
0010   D0               .byte 0xD0; /* rel x */
0011   42               .string "BERZERK",0x80,0x00;

                 /*
                  * Get the number of players: 1 or 2.
                  * C882 will be set to 0 for 1 player, and 1 for 2 players.
                  */
001A   CC0200    start: ldd   #0x0200;
001D   BDF7A9           jsr   $get_players_game;
0020   9679             lda   0x79;
0022   47               asra;
0023   9782             sta   0x82;

                 /*
                  * Disable 2 of the 4 joystick mask registers; the other
                  * 2 are enabled automatically by the ExecRom.
                  */
0025   0F21             clr   0x21;
0027   0F22             clr   0x22;
0029   BDF533           jsr   $init_music_buf;
002C   0F67             clr   0x67;

                 /*
                  * Initialize the 2 player's structures.
                  * Player 1 is C900-C90D, player 2 is C90E-C91B.
                  * The player's scores will be initialized, their
                  * number of lives set (3), and their initial positions
                  * set.
                  */
                 RestartBerzerk:
002E   BDF1AF           jsr   $dptoC8;
0031   0F9D             clr   0x9D;
0033   0C9D             inc   0x9D;
0035   8EC900           ldx   #0xC900;
0038   9F80             stx   0x80;
003A   8603      P003A: lda   #0x03;
003C   A708             sta   8,x;             /* Set number of lives */
003E   6F09             clr   9,x;             /* Clear 'bonus given' flag */
0040   BDF84F    P0040: jsr   $set_dft_score;  /* Set default score */
0043   8EC90E           ldx   #0xC90E;
0046   0A9D             dec   0x9D;
0048   2AF0             bpl   P003A;
004A   8EC900           ldx   #0xC900;
004D   CC00A5           ldd   #0x00A5;
0050   ED0A             std   10,x;            /* Set starting position */
0052   8EC90E           ldx   #0xC90E;
0055   CC005B           ldd   #0x005B;
0058   ED0A             std   10,x;            /* Set starting position */

                 /* Set initial robot attributes */
005A   86A0             lda   #0xA0;
005C   97A8             sta   0xA8;            /* Robot seeding threshold */
005E   8606             lda   #0x06;
0060   97A7      P0060: sta   0xA7;            /* Set robot processing delay */
0062   8601             lda   #0x01;           /* Start robot bullets with */
0064   9784             sta   0x84;            /* a low velocity factor */

                 /*
                  * This block takes care of setting up for the next turn,
                  * after a player has died.  It determines how the maze
                  * will look, displays the maze, the scores and the number
                  * of lives, and then does some music mucking.
                  */
                 StartNewTurn:
0066   863F             lda   #0x3F;         /* Set loop counter */
0068   9785             sta   0x85;
006A   8EC8C5           ldx   #0xC8C5;       /* Initialize game RAM */
006D   C626             ldb   #0x26;
006F   BDF53F           jsr   $clear_blockxb;
0072   BD0EF6           jsr   $DetermineMazeWalls;
0075   8EC8D1           ldx   #0xC8D1;       /* Initialize the bonus string */
0078   BDF84F           jsr   $set_dft_score;
007B   9E80             ldx   0x80;          /* Save the player's position */
007D   EC0A             ldd   10,x;
007F   DD8F             std   0x8F;
0081   A608             lda   8,x;           /* Display # of lives left */
0083   BD0315           jsr   $DisplayLives;

                 /*
                  * Display the maze, but not the player or the robots,
                  * and do some sound mucking; loop here for a while,
                  * before proceeding.
                  */
                 LoopWhileDisplayingMaze:
0086   0F86             clr   0x86;
0088   BD0D41           jsr   $DoUnknownSoundMucking;
008B   BDF687           jsr   $init_sound;
008E   9626             lda   0x26;
0090   8510             bita  #0x10;
0092   2602             bne   P0096;
0094   0A86             dec   0x86;
0096   BDF192    P0096: jsr   $waitrecal;
0099   BD0486           jsr   $DrawMaze;
009C   BDF289           jsr   $do_sound;
009F   BDF1AF           jsr   $dptoC8;
00A2   0A85             dec   0x85;
00A4   26E0             bne   LoopWhileDisplayingMaze;

                 /*
                  * Remove one of the player's lives, to take into account
                  * the life he is using now.
                  */
00A6   9E80             ldx   0x80;       /* Points to active player struct */
00A8   6A08             dec   8,x;
00AA   BDF533           jsr   $init_music_buf;
00AD   2006             bra   P00B5;

                 EnterNextMaze:
00AF   BDF1AF           jsr   $dptoC8;
00B2   BD0EF6           jsr   $DetermineMazeWalls;

00B5   862A      P00B5: lda   #0x2A;
00B7   9786             sta   0x86;
00B9   DE80             ldu   0x80;
00BB   EC4A             ldd   10,u;
00BD   DD8F             std   0x8F;      /* Save the player's position */
00BF   DD95             std   0x95;
00C1   8EC8E0           ldx   #0xC8E0;
00C4   C605             ldb   #0x05;
00C6   BDF53F           jsr   $clear_blockxb;
00C9   0F83             clr   0x83;
00CB   0A83             dec   0x83;

                 /*
                  * Based on the player's score, set the level of difficulty.
                  * If the score >= 10,000, then bump the difficulty by alot.
                  * After that, compare the 'thousands' portion of the score
                  * against the cutoff values in the table, and further bump
                  * for each cutoff value surpassed.
                  */
00CD   A641             lda   1,u;      /* Check if score >= 10,000 */
00CF   8120             cmpa  #0x20;
00D1   2704             beq   P00D7;
00D3   8606             lda   #0x06;    /* It is, so increase difficulty */
00D5   9783             sta   0x83;
00D7   EC42      P00D7: ldd   2,u;      /* Check the cutoff values */
00D9   8E0A2D           ldx   #SkillLevelCutoffs;
00DC   0C83      P00DC: inc   0x83;
00DE   6D84             tst   ,x;
00E0   2B05             bmi   P00E7;
00E2   10A381           cmpd  ,x++;
00E5   2CF5             bge   P00DC;

                 /*
                  * Initialize the bonus score string.
                  */
00E7   8EC8D1    P00E7: ldx   #0xC8D1;
00EA   BDF84F           jsr   $set_dft_score;

                 /*
                  * Do some processing based on the difficulty value calculated
                  * earlier (set the robot's bullet velocity and the robot
                  * processing delay).  Lastly, clear out the bullet structure.
                  */
00ED   9683             lda   0x83;         /* Max # of robot bullets */
00EF   8106             cmpa  #0x06;
00F1   2D02             blt   P00F5;
00F3   0C84             inc   0x84;         /* Robot bullet velocity factor */
00F5   47        P00F5: asra;
00F6   8006             suba  #0x06;
00F8   40               nega;
00F9   2A01             bpl   P00FC;
00FB   4F               clra;
00FC   97A7      P00FC: sta   0xA7;         /* Robot processing delay */
00FE   8EC974           ldx   #0xC974;      /* Init the bullet structure */
0101   BDF545           jsr   $clear_256_bytes;

                 /*
                  * This seeds the robot structure array.  It attempts to
                  * 'activate' a random number of robots.  If it fails to
                  * seed any robots, then it tries over again.
                  * The robot array is an array of structures, located
                  * at C91C-C973; there are 11 entries, each 8 bytes long.
                  * C8C7 keeps track of the number of robots initially
                  * seeded; C8C8 keeps track of the number of robots still
                  * alive.  A robot is seeded only if the generated random
                  * number is less than a pre-calculated threshold value.
                  */
0104   0FC7      P0104: clr   0xC7;
0106   C60B             ldb   #0x0B;
0108   8E0CE6           ldx   #RobotStartingPositionTable;
010B   CEC91C           ldu   #0xC91C;
010E   BDF517    P010E: jsr   $get_random_a;
0111   91A8             cmpa  0xA8;          /* Should we seed this robot? */
0113   2237             bhi   P014C;
0115   0CC7             inc   0xC7;          /* Bump the robot count */
0117   8680             lda   #0x80;
0119   A742             sta   2,u;           /* Flag the robot as alive */
011B   BDF517           jsr   $get_random_a;
011E   841F             anda  #0x1F;
0120   979D      P0120: sta   0x9D;
0122   8010             suba  #0x10;
0124   AB84             adda  ,x;
0126   A7C4             sta   ,u;            /* Set the y starting position */
0128   BDF517           jsr   $get_random_a;
012B   840F             anda  #0x0F;
012D   8008             suba  #0x08;
012F   AB01             adda  1,x;
0131   A741             sta   1,u;           /* Set the x starting position */
0133   6F43             clr   3,u;
0135   6F44             clr   4,u;
0137   BDF517           jsr   $get_random_a;
013A   8407             anda  #0x07;
013C   A745             sta   5,u;
013E   9683             lda   0x83;
0140   8106             cmpa  #0x06;
0142   2D02             blt   P0146;
0144   8006             suba  #0x06;
0146   A746      P0146: sta   6,u;
0148   6F47             clr   7,u;
014A   3348             leau  8,u;           /* Change ptr to the next robot */
014C   3002      P014C: leax  2,x;
014E   5A               decb;
014F   26BD             bne   P010E;
0151   96C7             lda   0xC7;
0153   27AF             beq   P0104;
0155   97C8             sta   0xC8;

                 /* Set value used during robot seeding */
0157   1F30             tfr   u,d;
0159   83C924           subd  #0xC924;
015C   D7AA             stb   0xAA;

                 /* Initialize Otto information */
015E   DC95             ldd   0x95;
0160   DD91             std   0x91;         /* Set Otto's initial position */
0162   DD93             std   0x93;         /* Set Otto's initial position */
0164   8605             lda   #0x05;
0166   9730             sta   0x30;
0168   8620             lda   #0x20;
016A   9797             sta   0x97;         /* Set Otto's sound loop counter */
016C   8601             lda   #0x01;
016E   9798             sta   0x98;         /* Set Otto's initial velocity */

                 /* Set up some counters */
0170   96C7             lda   0xC7;
0172   C650             ldb   #0x50;
0174   3D               mul;
0175   4D               tsta;
0176   2603             bne   P017B;
0178   8602             lda   #0x02;
017A   5F               clrb;
017B   DD2E      P017B: std   0x2E;

                 /* Main processing loop */
017D   0FC5             clr   0xC5;  /* Set jump idx to 'player is alive' */
017F   BDF192    P017F: jsr   $waitrecal;
0182   BDF1F8           jsr   $read_jstick;
0185   BDF1BA           jsr   $read_switches2;
0188   BDF289           jsr   $do_sound;
018B   BD0486           jsr   $DrawMaze;
018E   BDF1AF           jsr   $dptoC8;
0191   8E0198           ldx   #MainJumpTable;
0194   96C5             lda   0xC5;
0196   6E96             jmp   [a,x];    /* (UNKNOWN JUMP) */

                 MainJumpTable:
0198   01               .word PlayerIsAlive;
019A   09               .word PlayerHasLeftMaze;
019C   03               .word PlayerHasDied;

                 MakeSoundThenGotoMainLoop:
019E   0D56             tst   0x56;
01A0   2702             beq   P01A4;
01A2   0F67             clr   0x67;
01A4   BDF687    P01A4: jsr   $init_sound;
01A7   BD0D41           jsr   $DoUnknownSoundMucking;
01AA   9E2E             ldx   0x2E;
01AC   2702             beq   P01B0;
01AE   301F             leax  -1,x;
01B0   9F2E      P01B0: stx   0x2E;
01B2   20CB             bra   P017F;

                 /*
                  * This is one of the 'indirect jump' functions.  It is the
                  * active jump function while the player is alive.  It uses
                  * the state of the buttons and the joystick to decide how
                  * to draw the player.  It also attempts to detect whenever
                  * the player leaves a quadrant, to determine if the player
                  * has left the maze, or run into a wall.
                 PlayerIsAlive:
01B4   8EC88F           ldx   #0xC88F;
01B7   96E9             lda   0xE9;
01B9   2704             beq   ProcessJoystickAndButtons;
01BB   0AE9             dec   0xE9;
01BD   2053             bra   DoNotUpdatePlayerMovement;

                 /*
                  * Based on the joystick and button values, the 'b' register
                  * is set to the following mask:
                  *
                  *         ---------------------------------
                  *         | 0 | 0 | B | L | D | U | R | L |
                  *         ---------------------------------
                  *   Button Pressed--^
                  *   Joystick Left-------^---------------^
                  *   Joystick Down-----------^
                  *   Joystick Up-----------------^
                  *   Joystick Right------------------^
                  */
                 ProcessJoystickAndButtons:
01BF   5F               clrb;
01C0   961C             lda   0x1C;    /* Get joystick up/down setting */
01C2   2A04             bpl   P01C8;   /* 0=u/d neutral, -=down, +=up */
01C4   CB08             addb  #0x08;   /* Down */
01C6   2004             bra   P01CC;
01C8   2702      P01C8: beq   P01CC;
01CA   CB04             addb  #0x04;   /* Up */
01CC   961B      P01CC: lda   0x1B;    /* Get joystick left/right setting */
01CE   2A04             bpl   P01D4;   /* 0=l/r neutral, -=left, +=right)
01D0   CB11             addb  #0x11;   /* Left */
01D2   2004             bra   P01D8;
01D4   2702      P01D4: beq   P01D8;
01D6   CB02             addb  #0x02;   /* Right */
01D8   960F      P01D8: lda   0x0F;    /* Load button states */
01DA   2727             beq   NoBtnsPressed;
01DC   CA20             orb   #0x20;   /* Button pressed, but if joystick is */
01DE   C50F             bitb  #0x0F;   /* neutral, then do nothing. */
01E0   2730             beq   DoNotUpdatePlayerMovement;

                 /*
                  * The joystick is not in the neutral position, and a button
                  * is pressed, so the player is firing.
                  */
01E2   D7EA             stb   0xEA;    /* Save the joystick/button mask */
01E4   8608             lda   #0x08;
01E6   97E9             sta   0xE9;
01E8   C40F             andb  #0x0F;
01EA   D7EB             stb   0xEB;    /* Save just the joystick mask */
01EC   8606             lda   #0x06;
01EE   BD0939           jsr   $CalculateUpdatedPosition;
01F1   DD9E             std   0x9E;
01F3   8EC89E           ldx   #0xC89E;
01F6   C603             ldb   #0x03;
01F8   BD0333           jsr   $FireBullet;
01FB   8601             lda   #0x01;
01FD   9A67             ora   0x67;
01FF   9767             sta   0x67;
0201   200F             bra   DoNotUpdatePlayerMovement;

                 NoBtnsPressed:
0203   D7EA             stb   0xEA;   /* Save the joystick/button mask */
0205   9626             lda   0x26;
0207   8502             bita  #0x02;
0209   2607             bne   DoNotUpdatePlayerMovement;
020B   8601             lda   #0x01;
020D   BD0939           jsr   $CalculateUpdatedPosition;
0210   ED84             std   ,x;

                 /*
                  * If none of the buttons are pressed, and if the joystick
                  * is in neutral, then reset the players arms and legs to
                  * the 'neutral' position.
                  */
                 DoNotUpdatePlayerMovement:
0212   96EA             lda   0xEA;
0214   2606             bne   CheckIfFiring;
0216   0FCE             clr   0xCE;
0218   0FCF             clr   0xCF;
021A   2027             bra   CheckForPlayerLeavingQuadrant;

                 /*
                  * If a button was pressed, then we know the player was
                  * firing, so we can force his legs to the neutral position,
                  * and can set his arms to be shooting in the appropriate
                  * direction.
                  */
                 CheckIfFiring:
021C   8520             bita  #0x20;
021E   270D             beq   NotFiringButMoving;
0220   0FCE             clr   0xCE;   /* Force player to stand still */
0222   CE0A3C           ldu   #ArmsShootingIndicesTable;
0225   840F             anda  #0x0F;
0227   E6C6             ldb   a,u;
0229   D7CF             stb   0xCF;   /* Set player's arms accordingly */
022B   2016             bra   CheckForPlayerLeavingQuadrant;

                 /*
                  * We know that the player is on the move.  We will therefore
                  * make his arms swing left and right, and we will draw his
                  * legs so it appears he is running in the desired direction.
                  * The timing for changing the arms and legs is controlled by
                  * bit 0x08 of C826, which is a counter controlled by the
                  * Exec Rom.
                  *
                  * For the arms:
                  *
                  *        0 = 'arms to the right'
                  *        2 = 'arms to the left'
                  *
                  * For the legs:
                  *
                  *        2 = 'running right with wide legs'
                  *        4 = 'running right with close legs'
                  *        6 = 'running left with wide legs'
                  *        8 = 'running left with close legs'
                  */
                 NotFiringButMoving:
022D   8410             anda  #0x10;   /* a = joystick/button mask */
022F   3402             pshs  a;
0231   9626             lda   0x26;
0233   8408             anda  #0x08;
0235   1F89             tfr   a,b;     /* Get a value of 0 or 2, to control */
0237   57               asrb;          /* which arms get drawn.             */
0238   57               asrb;
0239   D7CF             stb   0xCF;
023B   AAE0             ora   ,s+;     /* Get a value of 2, 4, 6 or 8, to */
023D   47               asra;          /* control which legs get drawn.   */
023E   47               asra;
023F   8B02             adda  #0x02;
0241   97CE             sta   0xCE;

                 /*
                  * Take the player's position, and map it into:
                  *
                  *   1) the quadrant the player is in (C89A),
                  *   2) the relative position within that quadrant (C89B-C89C)
                  *   3) the bitmask indicating which walls are present for
                  *      the quadrant (C899).
                  *
                  * If it is determined that there was contact with a wall,
                  * then do some special checks to see if the wall was really
                  * a door; if it was a door, and the door was not blocked off,
                  * then exit to the next maze.
                  */
                 CheckForPlayerLeavingQuadrant:
0243   DC8F             ldd   0x8F;
0245   BD0F98           jsr   $MapPointToQuadrantAndMakeRelative;
0248   8E0EEA           ldx   #PlayerThresholds;
024B   BD0EC7           jsr   $CheckForQuadrantEdgeCrossing;
024E   D599             bitb  0x99;
0250   2756             beq   NoContactWithWalls;

                  /* Check for passing out the top door */
0252   969A             lda   0x9A;
0254   8102             cmpa  #0x02;   /* If quad 2, check for up door */
0256   260C             bne   P0264;
0258   96C6             lda   0xC6;    /* Check if door is blocked */
025A   8510             bita  #0x10;
025C   263D             bne   PlayerHitWall;
025E   C404             andb  #0x04;   /* Top wall (door) passed thru? */
0260   2739             beq   PlayerHitWall;
0262   202E             bra   ExitMaze;

                 /* Check for passing out the left door */
0264   8105      P0264: cmpa  #0x05;   /* If quad 5, check for left door */
0266   260C             bne   P0274;
0268   96C6             lda   0xC6;
026A   8504             bita  #0x04;   /* Check if door is blocked */
026C   262D             bne   PlayerHitWall;
026E   C401             andb  #0x01;   /* Left wall (door) passed thru ? */
0270   2729             beq   PlayerHitWall;
0272   201E             bra   ExitMaze;

                 /* Check for passing out the right door */
0274   8109      P0274: cmpa  #0x09;   /* If quad 9, check for right door */
0276   260C             bne   P0284;
0278   96C6             lda   0xC6;
027A   8502             bita  #0x02;   /* Check if door is blocked */
027C   261D             bne   PlayerHitWall;
027E   C402             andb  #0x02;   /* Right wall (door) passed thru ? */
0280   2719             beq   PlayerHitWall;
0282   200E             bra   ExitMaze;

                 /* Check for passing out the bottom door */
0284   810C      P0284: cmpa  #0x0C;   /* If quad 12, check for bottom door */
0286   2613             bne   PlayerHitWall;
0288   96C6             lda   0xC6;
028A   8508             bita  #0x08;   /* Check if door is blocked */
028C   260D             bne   PlayerHitWall;
028E   C408             andb  #0x08;   /* Bottom wall (door) passed thru ? */
0290   2709             beq   PlayerHitWall;

                 /*
                  * The player has successfully exited from the maze; change
                  * the jump index so that the code is called which scrolls
                  * the maze off the display.
                  */
                 ExitMaze:
0292   D7EA             stb   0xEA;
0294   C602             ldb   #0x02;
0296   D7C5             stb   0xC5;
0298   7E019E           jmp   $MakeSoundThenGotoMainLoop;

                 /*
                  * The player died by walking into a wall; change the
                  * jump index so that the code which shows the player being
                  * fried, is called.
                  */
                 PlayerHitWall:
029B   8608             lda   #0x08;
029D   9A67             ora   0x67;
029F   9767             sta   0x67;
02A1   C604             ldb   #0x04;
02A3   D7C5             stb   0xC5;
02A5   7E019E           jmp   $MakeSoundThenGotoMainLoop;

                 /*
                  * The player did not make contact with any walls, so all
                  * is well.  Starting at the end of the bullet array, work
                  * back until we find an active bullet, then update the
                  * bullet counter in C8CC.
                  */
                 NoContactWithWalls:
02A8   BD0825           jsr   $ProcessAndUpdateBullets;
02AB   BD064A           jsr   $ProcessAndUpdateRobots;
02AE   D6CC             ldb   0xCC;
02B0   271A             beq   CheckForExtraLifeBonus;
02B2   5A               decb;
02B3   8608             lda   #0x08;
02B5   3D               mul;
02B6   8EC974           ldx   #0xC974;  /* Start at the end of the bullet */
02B9   3A               abx;            /* array. */
02BA   A607      P02BA: lda   7,x;
02BC   850F             bita  #0x0F;
02BE   260C             bne   CheckForExtraLifeBonus;
02C0   8580             bita  #0x80;
02C2   2700             beq   P02C4;
02C4   0ACC      P02C4: dec   0xCC;
02C6   2704             beq   CheckForExtraLifeBonus;
02C8   3018             leax  -8,x;
02CA   20EE             bra   P02BA;

                 /*
                  * Display the number lives the player has, and then check
                  * to see if the player has earned an extra life (awarded
                  * for each 5000 points); if so, then award the extra life,
                  * and play a little tune.  The bonus check happens by
                  * comparing the thousands digit of the score to ascii '5'.
                  */
                 CheckForExtraLifeBonus:
02CC   9E80             ldx   0x80;
02CE   A608             lda   8,x;
02D0   8D43             bsr   $DisplayLives;
02D2   6D09             tst   9,x;      /* Semaphore; only do once */
02D4   2610             bne   CheckForClearedLevelBonus;
02D6   8635             lda   #0x35; /* "5" */
02D8   A102             cmpa  2,x;
02DA   2E0A             bgt   CheckForClearedLevelBonus;
02DC   6C08             inc   8,x;      /* Award the extra life */
02DE   6C09             inc   9,x;      /* Set the semaphore */
02E0   CEFF44           ldu   #0xFF44;  /* Play a tune */
02E3   BDF68D           jsr   $init_sound2;

                 /*
                  * Check to see if the player has cleared out all of
                  * the robots; if so, then award a bonus, and display
                  * the bonus string.  Some fancy manipulation is done
                  * to convert the integer into a BCD string value.
                  */
                 CheckForClearedLevelBonus:
02E6   0DC8             tst   0xC8;    /* Any robots left? */
02E8   2628             bne   P0312;
02EA   8602             lda   #0x02;   /* All robots have been cleared out */
02EC   9598             bita  0x98;
02EE   2622             bne   P0312;
02F0   0C98             inc   0x98;    /* Increment Otto's velocity */
02F2   4F               clra;
02F3   D6C7             ldb   0xC7;    /* Get the starting count of robots */
02F5   C10A             cmpb  #0x0A;
02F7   2D04             blt   P02FD;
02F9   C00A             subb  #0x0A;   /* Handle counts >= 10 specially */
02FB   CA10             orb   #0x10;
02FD   58        P02FD: aslb;          /* Convert to BCD string value */
02FE   49               rola;
02FF   58               aslb;
0300   49        P0300: rola;
0301   58               aslb;
0302   49               rola;
0303   58               aslb;
0304   49               rola;
0305   3406             pshs  a,b;     /* Add bonus to player's score */
0307   BDF87C           jsr   $add_d_to_x_in_bcd;
030A   3506             puls  a,b;
030C   8EC8D1           ldx   #0xC8D1;  /* Place value into the bonus string */
030F   BDF87C           jsr   $add_d_to_x_in_bcd;
0312   7E019E    P0312: jmp   $MakeSoundThenGotoMainLoop;

                 /*
                  * DisplayLives()
                  *
                  * Entry:
                  *   a = number of lives
                  *
                  * Displays a string of 'little men', one for each live
                  * the user has.  The buffer into which the string is
                  * placed starts at C8D8.
                  *
                  *  BUG ALERT: there is no check to see if the C8D8 buffer
                  *             is overrun; what is the intended size of this
                  *             buffer?
                  */
                 DisplayLives:
0315   5F               clrb;
0316   CEC8D8           ldu   #0xC8D8;     /* String buffer */
0319   979D             sta   0x9D;
031B   2709             beq   P0326;
031D   8669             lda   #0x69;       /* 'little man' icon */
031F   A7C5      P031F: sta   b,u;
0321   5C               incb;
0322   D19D             cmpb  0x9D;
0324   2DF9             blt   P031F;
0326   8620      P0326: lda   #0x20;
0328   A7C5             sta   b,u;         /* Terminate string with 2 spaces */
032A   5C               incb;              /* and 0x80.                      */
032B   A7C5             sta   b,u;
032D   5C               incb;
032E   8680             lda   #0x80;
0330   A7C5             sta   b,u;
0332   39               rts;

                 /*
                  * FireBullet()
                  *
                  * This function attempts to fire a bullet from the indicated
                  * position, using the specified velocity.  However, if the
                  * bullet would immediately hit a wall, then it is not fired.
                  *
                  * Entry:
                  *    b = bullet's velocity factor (a value indicating how
                  *        often the bullet's position is updated for each
                  *        pass).
                  *    x = Bullet's starting position.
                  *    C8EB = direction of travel for the bullet.
                  */
                 FireBullet:
0333   D79D             stb   0x9D;
0335   3450             pshs  x,u;
0337   EC84             ldd   ,x;
0339   BD0F98           jsr   $MapPointToQuadrantAndMakeRelative;
033C   8E0EEE           ldx   #BulletThresholds;
033F   BD0EC7           jsr   $CheckForQuadrantEdgeCrossing;
0342   3510             puls  x;        /* Don't fire if bullet will */
0344   D599             bitb  0x99;     /* immediately hit a wall.   */
0346   2621             bne   P0369;
0348   D6CC             ldb   0xCC;     /* Point to the next available bullet */
034A   8608             lda   #0x08;
034C   3D               mul;
034D   CEC974           ldu   #0xC974;
0350   33C5             leau  b,u;
0352   96EB             lda   0xEB;
0354   A747             sta   7,u;      /* Store bullet's direction */
0356   969D             lda   0x9D;
0358   A746             sta   6,u;      /* Store velocity factor */
035A   EC84             ldd   ,x;
035C   EDC4             std   ,u;       /* Set bullet's tail position */
035E   D6EB             ldb   0xEB;
0360   8602             lda   #0x02;
0362   BD0939           jsr   $CalculateUpdatedPosition;
0365   ED44             std   4,u;      /* Set bullet's head position */
0367   0CCC             inc   0xCC;     /* Increment the bullet count */
0369   35C0      P0369: puls  u,pc;

                 /*
                  * This is one of the 'indirect jump' functions.  It is the
                  * active jump function when the player gets killed.  It
                  * will cause the player to be drawn with a variety of
                  * intensities (simulating electrocution), and will update
                  * the current high score, if necessary.  It then resets
                  * the starting positions for the players, and tries to
                  * determine whose turn it is next.  If there are two
                  * players, then it tries to switch to the other player,
                  * unless that player has 0 lives left; in that case, it
                  * will stick with the current player, unless he, too, has
                  * 0 lives left, at which point the game ends, and it
                  * waits for either the user to press a button to restart
                  * the game, or a timeout to elapse (to cold start the
                  * system).
                  */
                 PlayerHasDied:
036B   0FEA             clr   0xEA;
036D   0FCD             clr   0xCD;
036F   BD064A           jsr   $ProcessAndUpdateRobots;
0372   BD0825           jsr   $ProcessAndUpdateBullets;
0375   9686             lda   0x86;
0377   840F             anda  #0x0F;
0379   CE0D0B           ldu   #PlayerFriedIntensities;
037C   E6C6             ldb   a,u;
037E   D7D0             stb   0xD0;    /* Save off next intensity value */
0380   0A86             dec   0x86;
0382   102AFE18         lbpl  MakeSoundThenGotoMainLoop;
0386   86A0             lda   #0xA0;
0388   97A8             sta   0xA8;
038A   9E80             ldx   0x80;    /* Check for new high score */
038C   CECBEB           ldu   #0xCBEB;
038F   BDF8D8           jsr   $check_4_new_hi_score;

                 /* Loop, doing some music mucking */
0392   8650             lda   #0x50;
0394   9785             sta   0x85;
0396   0F86             clr   0x86;
0398   0A86             dec   0x86;
039A   BD0774    P039A: jsr   $CheckForOttoStart;
039D   BD0D41           jsr   $DoUnknownSoundMucking;
03A0   BDF192           jsr   $waitrecal;
03A3   BD0486           jsr   $DrawMaze;
03A6   BDF289           jsr   $do_sound;
03A9   BDF1AF           jsr   $dptoC8;
03AC   0A85             dec   0x85;
03AE   26EA             bne   P039A;

                  /* Reset player's starting positions */
03B0   8EC900           ldx   #0xC900;   /* Player 1 */
03B3   CC00A5           ldd   #0x00A5;
03B6   ED0A             std   10,x;
03B8   8EC90E           ldx   #0xC90E;   /* Player 2 */
03BB   CC005B           ldd   #0x005B;
03BE   ED0A             std   10,x;

                  /* Determine whose turn it is */
03C0   0FC6             clr   0xC6;    /* Start with no door blocked */
03C2   0D82             tst   0x82;    /* Two player game? */
03C4   2713             beq   P03D9;
03C6   8EC900           ldx   #0xC900; /* Yes */
03C9   0D81             tst   0x81;    /* Is player 2 the active player? */
03CB   2603             bne   P03D0;
03CD   8EC90E           ldx   #0xC90E; /* No, so change to player 2 */
03D0   6D08      P03D0: tst   8,x;     /* Does this player have any lives? */
03D2   2705             beq   P03D9;
03D4   9F80             stx   0x80;    /* Yep; so let this player play */
03D6   7E0066           jmp   $StartNewTurn
03D9   9E80      P03D9: ldx   0x80;    /* Nope; so see if original player */
03DB   6D08             tst   8,x;     /* had any lives left.             */
03DD   1026FC85         lbne  $StartNewTurn

                 /* The game is over; loop waiting for next game  */
03E1   0F9F             clr   0x9F;      /* Clear the Easter Egg semaphore */
03E3   8E0C00           ldx   #0x0C00;   /* How long to wait for restart */

                 LoopWaitingForRestart:
03E6   9F9D             stx   0x9D;
03E8   BD0D41           jsr   $DoUnknownSoundMucking;
03EB   BDF192           jsr   $waitrecal;
03EE   BDF2A5           jsr   $intensity_to_5F;
03F1   BDF289           jsr   $do_sound;
03F4   7DC89F           tst   $C89F;
03F7   2706             beq   $DisplayHighScore;

                 /* Display the Easter Egg */
03F9   CE0CDE           ldu   #AuthorsInitials;
03FC   BDF373           jsr   $print_1_string;

                 /*
                  * Display the current high score, along with the scores
                  * for players 1 and 2.
                  */
                 DisplayHighScore:
03FF   CE046D           ldu   #HighScoreString;
0402   BDF373           jsr   $print_1_string;
0405   CECBEB           ldu   #0xCBEB;          /* height & width */
0408   CC60E0           ldd   #0x60E0;          /* rel y & rel x */
040B   BDF37A           jsr   $print_at_d;
040E   BD0632           jsr   $DisplayBothPlayersScore;

                 /*
                  * Display "Got You Humanoid" 4 times.
                  */
0411   108E047C         ldy   #HumanoidStringPositions;
0415   ECA1             ldd   ,y++;
0417   FDC82A           std   $C82A;
041A   ECA1             ldd   ,y++;
041C   CE045C           ldu   #HumanoidString;
041F   3440             pshs  u;
0421   BDF37A           jsr   $print_at_d;
0424   3540             puls  u;
0426   ECA1             ldd   ,y++;
0428   BDF37A           jsr   $print_at_d;
042B   3440             pshs  u;
042D   ECA1             ldd   ,y++;
042F   BDF37A           jsr   $print_at_d;
0432   ECA1             ldd   ,y++;
0434   3540             puls  u;
0436   BDF37A           jsr   $print_at_d;

                 /*
                  * If only buttons 1, 3 and 4 are pressed, toggle the
                  * flag (C89F) which will cause the author's initials
                  * to be displayed (Easter Egg).  Otherwise, if any buttons
                  * are pressed, then restart the game.  If no buttons are
                  * pressed, then eventually (after a predetermined
                  * amount of time), jump back to the start of the
                  * Exec Rom.  Note that if the Easter Egg gets enabled,
                  * then pressing buttons will not restart a new game;
                  * you must wait for the timeout to expire.
                  */
0439   BDF1BA           jsr   $read_switches2;
043C   BDF1AF           jsr   $dptoC8;
043F   0D9F             tst   0x9F;          /* Bypass if Easter Egg active */
0441   2610             bne   P0453;
0443   960F             lda   0x0F;          /* Button states */
0445   880D             eora  #0x0D;         /* Mask for buttons 1, 3 and 4 */
0447   2604             bne   P044D;
0449   0C9F             inc   0x9F;          /* Turn on the Easter egg */
044B   2006             bra   P0453;
044D   960F      P044D: lda   0x0F;          /* Button states */
044F   1026FBDB         lbne  RestartBerzerk;
0453   9E9D      P0453: ldx   0x9D;          /* Decrement timer */
0455   301F             leax  -1,x;
0457   268D             bne   LoopWaitingForRestart;
0459   7EF000           jmp   $start_of_OS_ROM;

                 HumanoidString:
045C   47               .string "GOT YOU HUMANOID",0xFF;

                 HighScoreString:
046D   F8               .byte 0xF8; /* height */
046E   38               .byte 0x38; /* width */
046F   70               .byte 0x70; /* rel y */
0470   D8               .byte 0xD8; /* rel x */
0471   48               .string "HIGH SCORE ";

                 HumanoidStringPositions:
047C   F2               .byte 0xF2; /* rel y */
047D   4A               .byte 0x4A; /* rel x */
047E   22               .byte 0x22; /* rel y */
047F   D8               .byte 0xD8; /* rel x */
0480   20               .byte 0x20; /* rel y */
0481   D8               .byte 0xD8; /* rel x */
0482   00               .byte 0x00; /* rel y */
0483   CF               .byte 0xCF; /* rel x */
0484   FE               .byte 0xFE; /* rel y */
0485   CF               .byte 0xCF; /* rel x */

                 /*
                  * Draw the outer and inner maze walls, and if necessary,
                  * block off one of the maze doors.
                  */
                 DrawMaze:
0486   7CC824           inc   $C824;
0489   BDF2A5           jsr   $intensity_to_5F;
048C   8EF3DD           ldx   #draw_VL_with_count1;
048F   BFC8C9           stx   $C8C9;        /* Indirect jump pointer */
0492   867F             lda   #0x7F;
0494   B7C8CB           sta   $C8CB;        /* Drawing intensity */

                 /* Draw 4 sets of vectors making up outer maze walls */
0497   C604             ldb   #0x04;
0499   E771             stb   -15,s;        /* Loop counter */
049B   CE0B0B           ldu   #OutsideMazeWallData;
049E   8601      P049E: lda   #0x01;        /* Vector count - 1 */
04A0   B7C823           sta   $C823;
04A3   AE42             ldx   2,u;          /* Pointer to vector table */
04A5   BD08C7           jsr   $DrawWithPossibleScrolling;
04A8   3344             leau  4,u;          /* Process to next wall */
04AA   6A71             dec   -15,s;
04AC   26F0             bne   P049E;

                 /* Draw the 8 inner walls */
04AE   7FC823           clr   $C823;
04B1   8608             lda   #0x08;
04B3   A771             sta   -15,s;        /* Loop counter */
04B5   108EC8AB         ldy   #0xC8AB;      /* Array of wall indicies */
04B9   CE0B1B           ldu   #InnerWallPositionTable;
04BC   E6A0      P04BC: ldb   ,y+;
04BE   8E0B3B           ldx   #InnerWallVectorTable;
04C1   3A               abx;
04C2   BD08C7           jsr   $DrawWithPossibleScrolling;
04C5   3342             leau  2,u;          /* Process next segment */
04C7   6A71             dec   -15,s;
04C9   26F1             bne   P04BC;

                 /* Block off one door, if signaled to do so */
04CB   CE0AE9           ldu   #BlockedDoorVectorTable;
04CE   B6C8C6           lda   $C8C6;        /* Door to block, if any */
04D1   2708             beq   DisplayBonusString;
04D3   EEC6             ldu   a,u;
04D5   3042             leax  2,u;
04D7   4F               clra;
04D8   BD08C7           jsr   $DrawWithPossibleScrolling;

                 /*
                  * If the player killed all of the robots, then display
                  * a message telling them they got a bonus.  We can tell
                  * if we need to display the bonus string, by checking to
                  * to see if the second digit in the bonus string is not '0'
                  * ("    x0" is the default, where 'x' is initially set to
                  * a space, but will be a digit when the bonus string has
                  * been assigned a value).
                  *
                  * BUG ALERT: when the above check occurs, the 'ble' command
                  *            really should be a 'blt'!!  This explains why
                  *            when a player clears a maze containing 10
                  *            robots, the bonus string was not displayed.
                  *            In this case the bonus string is "   100",
                  *            and this fails the above check!
                  */
                 DisplayBonusString:
04DB   CCF838           ldd   #0xF838;
04DE   FDC82A           std   $C82A;          /* Set height & width */
04E1   B6C8D5           lda   $C8D5;
04E4   8130             cmpa  #0x30;
04E6   2F0F             ble   DrawActivePieces;
04E8   CE0AE1           ldu   #BonusString;
04EB   BDF378           jsr   $print_with_dft_hw;
04EE   CC70F0           ldd   #0x70F0;        /* rel y & rel x */
04F1   CEC8D1           ldu   #0xC8D1;        /* Bonus score buffer */
04F4   BDF37A           jsr   $print_at_d;

                 /*
                  * Display both player's scores, and depending upon the
                  * active player, display the number of lives for that
                  * player.
                  */
                 DrawActivePieces:
04F7   BD0632           jsr   $DisplayBothPlayersScore;
04FA   CCF820           ldd   #0xF820;        /* Set height & width */
04FD   FDC82A           std   $C82A;
0500   CEC8D8           ldu   #0xC8D8;        /* Display # of lives */
0503   7DC881           tst   $C881;
0506   2708             beq   P0510;
0508   CC9840           ldd   #0x9840;        /* Player 2 rel y & rel x */
050B   BDF37A           jsr   $print_at_d;
050E   2006             bra   DrawActiveBullets;
0510   CC98A0    P0510: ldd   #0x98A0;        /* Player 1 rel y & rel x */
0513   BDF37A           jsr   $print_at_d;

                 /* Draw all active bullets */
                 DrawActiveBullets:
0516   CEC974           ldu   #0xC974;        /* Bullet array */
0519   B6C8CC           lda   $C8CC;          /* Bullet count */
051C   2714      P051C: beq   DrawAliveRobots;
051E   A771             sta   -15,s;
0520   E647             ldb   7,u;
0522   C40F             andb  #0x0F;
0524   2705             beq   P052B;
0526   3042             leax  2,u;            /* Ptr to vector list */
0528   BD08C7           jsr   $DrawWithPossibleScrolling;
052B   3348      P052B: leau  8,u;
052D   A671             lda   -15,s;
052F   4A               deca;
0530   20EA             bra   P051C;

                 /*
                  * Draw All robots.  When drawing the robot, it is drawn
                  * in two halves; first the right half, and then the left
                  * half.  When each half is drawn, that half of the body
                  * outline is drawn, and then the extremities are drawn
                  * (legs and feet).  The extremities are dependent upon
                  * whether the robot is moving or standing still (searching
                  * for the player).  The last thing drawn is the robot's
                  * eye box; this, too, is dependent upon whether the robot
                  * moving or standing still.  When moving, the eye box is
                  * aimed in the direction of movement (exception is down,
                  * in which case no eye box is displayed).  When the robot
                  * is searching for the player, the eye box will shuffle
                  * through all of the available positions.
                  */
                 DrawAliveRobots:
0532   B6C8C7           lda   $C8C7;         /* Number of robots */
0535   102700AE         lbeq  DrawThePlayer;
0539   A771             sta   -15,s;
053B   CEC91C           ldu   #0xC91C;       /* Robot structure */
053E   6D47      P053E: tst   7,u;
0540   2702             beq   P0544;
0542   6A47             dec   7,u;
0544   A642      P0544: lda   2,u;
0546   10270074         lbeq  P05BE;
054A   2A4D             bpl   DrawRobotDisappearing;
054C   7FC824           clr   $C824;
054F   8604             lda   #0x04;
0551   B7C8CB           sta   $C8CB;       /* Set drawing intensity */
0554   108E0A67         ldy   #RobotExtremitiesVectorTable;
0558   A643             lda   3,u;
055A   48               asla;
055B   10AEA6           ldy   a,y;         /* Get correct robot extremities */
055E   8E0619           ldx   #DrawRobotRightHalf;
0561   BFC8C9           stx   $C8C9;       /* Set drawing function */
0564   BD08C7           jsr   $DrawWithPossibleScrolling;
0567   3126             leay  6,y;         /* Get correct robot extremities */
0569   8E0614           ldx   #DrawRobotLeftHalf;
056C   BFC8C9           stx   $C8C9;       /* Set drawing function */
056F   BD08C7           jsr   $DrawWithPossibleScrolling;
0572   3126             leay  6,y;
0574   7CC824           inc   $C824;
0577   8EF3BC           ldx   #move_then_draw_VL_with_count5;
057A   BFC8C9           stx   $C8C9;       /* Set drawing function */
057D   8604             lda   #0x04;       /* Vector count - 1 */
057F   B7C823           sta   $C823;
0582   A644             lda   4,u;         /* Get correct eye box to draw */
0584   8406             anda  #0x06;
0586   AEA6             ldx   a,y;
0588   EC84             ldd   ,x;
058A   2703             beq   P058F;
058C   BD08C7           jsr   $DrawWithPossibleScrolling;  /* Draw eye box */
058F   3348      P058F: leau  8,u;
0591   6A71             dec   -15,s;
0593   1026FFA7         lbne  P053E;
0597   202D             bra   P05C6;

                 /*
                  * When a robot is killed, it is replaced by a cloud of
                  * random dots.
                  */
                 DrawRobotDisappearing:
0599   BDF517           jsr   $get_random_a;
059C   1F89             tfr   a,b;
059E   4F               clra;
059F   1F01             tfr   d,x;
05A1   8606             lda   #0x06;
05A3   A779             sta   -7,s;
05A5   ECC4      P05A5: ldd   ,u;           /* Get the robot's position */
05A7   BDF2FC           jsr   $move_pen7F_to_d;
05AA   E680             ldb   ,x+;
05AC   C407             andb  #0x07;
05AE   A680             lda   ,x+;
05B0   8407             anda  #0x07;
05B2   BDF2C3           jsr   $dot_at_d;    /* Draw random dot */
05B5   BDF354           jsr   $reset0ref;
05B8   6A79             dec   -7,s;
05BA   26E9             bne   P05A5;
05BC   6A42             dec   2,u;          /* Prepare for next pass */

                 /* Process next robot structure */
05BE   3348      P05BE: leau  8,u;
05C0   6A71             dec   -15,s;
05C2   1026FF78         lbne  P053E;

                 /*
                  * If the player has been in the maze for a certain amount
                  * of time, then it's time to bring out 'Otto'!
                  */
05C6   7DC82E    P05C6: tst   $C82E;
05C9   261C             bne   DrawThePlayer;
05CB   7DC82F           tst   $C82F;
05CE   2617             bne   DrawThePlayer;
05D0   7CC824           inc   $C824;
05D3   8614             lda   #0x14;
05D5   B7C8CB           sta   $C8CB;       /* Drawing intensity */
05D8   8EF410           ldx   #next_pt;
05DB   BFC8C9           stx   $C8C9;       /* Drawing function */
05DE   8E0B99           ldx   #OttoVectors;
05E1   CEC893           ldu   #0xC893;     /* Otto's position */
05E4   BD08C7           jsr   $DrawWithPossibleScrolling;

                 /*
                  * Unless C886 < 0, draw the player.  If the player is in
                  * the middle of getting fried, then redraw the player again,
                  * using a higher intensity.
                  */
                 DrawThePlayer:
05E7   7DC886           tst   $C886;       /* Should player be drawn? */
05EA   2B27             bmi   P0613;
05EC   8E09EF           ldx   #DrawPlayerFunction;
05EF   BFC8C9           stx   $C8C9;       /* Drawing function */
05F2   8609             lda   #0x09;
05F4   B7C8CB           sta   $C8CB;       /* Drawin intensity */
05F7   CEC88F           ldu   #0xC88F;     /* Player's position */
05FA   BD08C7           jsr   $DrawWithPossibleScrolling; /* Draw the player */
05FD   BDF354           jsr   $reset0ref;
0600   B6C8C5           lda   $C8C5;       /* See if player is being fried */
0603   8104             cmpa  #0x04;
0605   260C             bne   P0613;
0607   B6C8D0           lda   $C8D0;       /* Being fried */
060A   B7C8CB           sta   $C8CB;       /* Set higher drawing intensity */
060D   BD08C7           jsr   $DrawWithPossibleScrolling; /* Draw player again*/
0610   BDF354           jsr   $reset0ref;
0613   39        P0613: rts;

                 /*
                  * DrawRobotLeftHalf()
                  * DrawRobotRightHalf()
                  *
                  * These functions draw the indicated half of a robot.
                  *
                  * Entry:
                  *    y = Ptr to robot extremity table
                  *    u = Ptr to robot structure
                  */

                 DrawRobotLeftHalf:
0614   8E0B5E           ldx   #RobotLeftHalf;
0617   2003             bra   P061C;

                 DrawRobotRightHalf:
0619   8E0B43           ldx   #RobotRightHalf;
061C   BDF3AD    P061C: jsr   $move_then_draw_VL_with_count1;
061F   A644             lda   4,u;
0621   8402             anda  #0x02;
0623   AEA6             ldx   a,y;             /* Robot legs */
0625   8601             lda   #0x01;           /* Vector count - 1 */
0627   BDF3DA           jsr   $draw_VL_with_count5;
062A   AE24             ldx   4,y;             /* Robot foot */
062C   BDF3DD           jsr   $draw_VL_with_count1;
062F   7EF354           jmp   $reset0ref;

                 /*
                  * DisplayBothPlayersScore()
                  *
                  * This displays player 1's score, and if 2 players are
                  * playing, then player 2's score also.
                  */
                 DisplayBothPlayersScore:
0632   CC7086           ldd   #0x7086;        /* rel y & rel x */
0635   CEC900           ldu   #0xC900;        /* player 1 structure */
0638   BDF37A           jsr   $print_at_d;
063B   7DC882           tst   $C882;          /* 2 players? */
063E   2709             beq   P0649;
0640   CC7024           ldd   #0x7024;        /* rel y & rel x */
0643   CEC90E           ldu   #0xC90E;        /* player 2 structue */
0646   BDF37A           jsr   $print_at_d;
0649   39        P0649: rts;

                 /*
                  * ProcessAndUpdateRobots()
                  *
                  * This function loops through each of the robots, and
                  * determines where the robot is relative to the player,
                  * and will alter the robot's position (based on some
                  * criteria), and will determine if it is safe to fire
                  * at the player.  It also checks to see if the robot has
                  * hit a wall, collided with another robot or collided with
                  * the player.  Lastly, it updates Otto's position, if
                  * necessary, and checks to see if Otto has collided with
                  * the player.
                  *
                  * The robot will only fire if either it is 90 degrees or
                  * 45 degrees from the player; 45 degrees occurs when
                  * |x delta| == |y delta|.
                  *
                  * As the robot is moving, if it is in a different quad
                  * from the player, then it will only update it's position
                  * (in an attempt to avoid running into walls) when it is
                  * not in the center of the quadrant.
                  */
                 ProcessAndUpdateRobots:
064A   96C8             lda   0xC8;      /* Check if any robots are left */
064C   10270124         lbeq  CheckForOttoStart;
0650   0F9D             clr   0x9D;
0652   96A9             lda   0xA9;
0654   CEC91C    P0654: ldu   #0xC91C;   /* Ptr to robot array */
0657   33C6             leau  a,u;
0659   8B08             adda  #0x08;
065B   91AA             cmpa  0xAA;
065D   230A             bls   P0669;
065F   0D9D             tst   0x9D;
0661   2703             beq   P0666;
0663   7E0774           jmp   $CheckForOttoStart;
0666   0C9D      P0666: inc   0x9D;
0668   4F               clra;
0669   97A9      P0669: sta   0xA9;
066B   6D42             tst   2,u;      /* Skip this robot if he is dead or */
066D   2AE5             bpl   P0654;    /* not displayed.                   */
066F   6D47             tst   7,u;
0671   102600FF         lbne  CheckForOttoStart; /* Check processing delay */
0675   96A7             lda   0xA7;
0677   A747             sta   7,u;      /* Reset the processing delay value */
0679   A645             lda   5,u;      /* See if the robot can now start */
067B   2702             beq   P067F;    /* shooting.                      */
067D   6A45             dec   5,u;
067F   6C44      P067F: inc   4,u;      /* Update to display next eye box */
0681   ECC4             ldd   ,u;       /* Where is robot relative to player? */
0683   BD0F65           jsr   $DetermineDirectionToMove;
0686   C520             bitb  #0x20;    /* Do they line up in at least 1 dim? */
0688   260B             bne   PrepareToFire;  /* Yes */
068A   96DE             lda   0xDE;     /* No, so see if the x and y deltas */
068C   91DF             cmpa  0xDF;     /* are the same; i.e. 45 degrees.   */
068E   2705             beq   PrepareToFire;
0690   40               nega;
0691   91DF             cmpa  0xDF;
0693   2631             bne   RobotMoving;

                 /*
                  * Only fire if the robot's delay counter has decremented
                  * to 0.  Once all bullets have been spent, reset the counter
                  * and the bullet count.  Robots have a delay, which controls
                  * how often they can fire, along with a bullet counter, which
                  * controls how many bullets they can fire in a burst.
                  */
                 PrepareToFire:
0695   A645             lda   5,u;      /* Check if shooting delay expired */
0697   262D             bne   RobotMoving; /* Nope */
0699   6A46             dec   6,u;      /* Dec robot's bullet burst counter */
069B   2A0A             bpl   RobotFiring;
069D   9683             lda   0x83;     /* Fired all we can for now. */
069F   A746             sta   6,u;      /* Reset bullet burst counter */
06A1   8603             lda   #0x03;
06A3   A745             sta   5,u;      /* Reset shooting delay */
06A5   201F             bra   RobotMoving;

                 /*
                  * The robot is firing.  Determine the starting position for
                  * the bullet, the direction and the velocity.  Lastly, make
                  * a sound.
                  */
                 RobotFiring:
06A7   CA80             orb   #0x80;
06A9   C40F             andb  #0x0F;
06AB   D7EB             stb   0xEB;     /* Save direction to fire bullet */
06AD   30C4             leax  ,u;       /* Determine starting position for */
06AF   8607             lda   #0x07;    /* bullet; a little away from robot */
06B1   BD0939           jsr   $CalculateUpdatedPosition;
06B4   DD9E             std   0x9E;
06B6   8EC89E           ldx   #0xC89E;  /* Starting position */
06B9   D684             ldb   0x84;     /* Velocity factor */
06BB   BD0333           jsr   $FireBullet;
06BE   8602             lda   #0x02;    /* Make a sound */
06C0   9A67             ora   0x67;
06C2   9767             sta   0x67;
06C4   2046             bra   CheckForRobotContactWithWall;

                 /*
                  * The robot is moving, and not firing.  Update the robot's
                  * extremities, based upon the direction of movement.  If
                  * the robot is in a different quadrant than the player,
                  * then attempt to avoid walls in the quadrant, only if the
                  * robot is not in the center of the quadrant.  Usually, the
                  * robot's direction of travel is determined by trying to
                  * avoid walls in the quadrant.
                  */
                 RobotMoving:
06C6   C40F             andb  #0x0F;
06C8   E743             stb   3,u;    /* Set robot's extremities */
06CA   DC8F             ldd   0x8F;   /* Get player's quadrant */
06CC   BD0F98           jsr   $MapPointToQuadrantAndMakeRelative;
06CF   969A             lda   0x9A;
06D1   3402             pshs  a;
06D3   ECC4             ldd   ,u;     /* Get robot's quadrant */
06D5   BD0F98           jsr   $MapPointToQuadrantAndMakeRelative;
06D8   3502             puls  a;
06DA   919A             cmpa  0x9A;   /* In same quadrant? */
06DC   2721             beq   MoveInCurrentDirection;  /* yes */
06DE   969B             lda   0x9B;   /* In different quadrants */
06E0   8112             cmpa  #0x12;  /* Avoid walls, if not in quad center */
06E2   2D10             blt   AttemptToAvoidWalls;
06E4   812E             cmpa  #0x2E;
06E6   2E0C             bgt   AttemptToAvoidWalls;
06E8   969C             lda   0x9C;
06EA   8112             cmpa  #0x12;
06EC   2D06             blt   AttemptToAvoidWalls;
06EE   8116             cmpa  #0x16;
06F0   2E02             bgt   AttemptToAvoidWalls;
06F2   200B             bra   MoveInCurrentDirection;

                 /*
                  * Take the mask indicating which walls are present in this
                  * quadrant, and complement it, to determine the direction
                  * to move to avoid the walls.  If the resulting direction
                  * is 0, then the robot is completely enclosed.
                  */
                 AttemptToAvoidWalls:
06F4   9699             lda   0x99;     /* Wall mask for quadrant */
06F6   43               coma;
06F7   840F             anda  #0x0F;
06F9   A443             anda  3,u;      /* Update robot's direction of travel */
06FB   A743             sta   3,u;
06FD   270D             beq   CheckForRobotContactWithWall; /* Enclosed room */

                 /*
                  * Don't update the robot's direction of travel, but
                  * instead, just keep moving it in its current direction.
                  */
                 MoveInCurrentDirection:
06FF   30C4             leax  ,u;       /* Get current position */
0701   8601             lda   #0x01;    /* Set velocity factor */
0703   E643             ldb   3,u;      /* Get current direction */
0705   BD0939           jsr   $CalculateUpdatedPosition;
0708   EDC4             std   ,u;       /* Update robot's position */
070A   6C44             inc   4,u;      /* Update eye box index */

                 /* See if the robot has run into a wall */
                 CheckForRobotContactWithWall:
070C   6D42             tst   2,u;    /* Skip if the robot is already dead */
070E   2A14             bpl   CheckForRobotCollision;
0710   ECC4             ldd   ,u;     /* Robot's position */
0712   BD0F98           jsr   $MapPointToQuadrantAndMakeRelative;
0715   8E0EE6           ldx   #RobotThresholds;
0718   BD0EC7           jsr   $CheckForQuadrantEdgeCrossing;
071B   D599             bitb  0x99;   /* Contact? */
071D   2705             beq   CheckForRobotCollision;
071F   1F31             tfr   u,x;
0721   BD080F           jsr   $CreditPlayerWithDeadRobot;

                 /* See if the robot has run into another robot. */
                 CheckForRobotCollision:
0724   8EC91C           ldx   #0xC91C;
0727   96C7             lda   0xC7;
0729   979D             sta   0x9D;
072B   ECC4      P072B: ldd   ,u;
072D   10A384           cmpd  ,x;       /* Don't compare against yourself */
0730   271B             beq   GetNextRobotPtr;
0732   6D02             tst   2,x;      /* Skip if next robot is dead */
0734   2A17             bpl   GetNextRobotPtr;
0736   6D42             tst   2,u;      /* Skip if current robot is now dead */
0738   2A13             bpl   GetNextRobotPtr;
073A   108E0D35         ldy   #RobotContactBounds;
073E   BD0D1B           jsr   $CheckForContact;
0741   240A             bhs   GetNextRobotPtr;    /* Contact? */
0743   BD080F           jsr   $CreditPlayerWithDeadRobot;
0746   1E13             exg   x,u;
0748   BD080F           jsr   $CreditPlayerWithDeadRobot;
074B   1E13             exg   x,u;
                 GetNextRobotPtr:
074D   3008             leax  8,x;      /* Get pointer to next robot */
074F   0A9D             dec   0x9D;
0751   26D8             bne   P072B;

                 /* See if robot collided with the player */
0753   A642             lda   2,u;
0755   2A1D             bpl   CheckForOttoStart;  /* Skip if robot is dead */
0757   ECC4             ldd   ,u;
0759   8EC88F           ldx   #0xC88F;
075C   108E0D39         ldy   #PlayerContactBounds;
0760   BD0D1B           jsr   $CheckForContact;
0763   240F             bhs   CheckForOttoStart;
0765   1F31             tfr   u,x;
0767   BD080F           jsr   $CreditPlayerWithDeadRobot;
076A   8604             lda   #0x04;      /* Tag player as dead */
076C   97C5             sta   0xC5;
076E   8608             lda   #0x08;
0770   9A67             ora   0x67;
0772   9767             sta   0x67;   /* Make some sound */

                 /* Wait for counters to expire, before starting Otto */
                 CheckForOttoStart:
0774   0D2E             tst   0x2E;
0776   2675             bne   P07ED;
0778   0D2F             tst   0x2F;
077A   2671             bne   P07ED;
077C   9626             lda   0x26;
077E   8503             bita  #0x03;
0780   2619             bne   P079B;

                 /*
                  * Determine Otto's position and direction, do some
                  * occassional sound mucking, and then see if Otto collided
                  * with the player.
                  */
0782   DC91             ldd   0x91;     /* Determine Otto's travel direction */
0784   BD0F65           jsr   $DetermineDirectionToMove;
0787   8EC891           ldx   #0xC891;  /* Otto's position */
078A   9698             lda   0x98;     /* Otto's velocity */
078C   BD0939           jsr   $CalculateUpdatedPosition;
078F   DD91             std   0x91;     /* Update Otto's position */
0791   D697             ldb   0x97;     /* Since Otto bounces up and down, */
0793   D098             subb  0x98;     /* determine how to offset his 'y' */
0795   2A02             bpl   P0799;    /* position.                       */
0797   C620             ldb   #0x20;
0799   D797      P0799: stb   0x97;
079B   D697      P079B: ldb   0x97;
079D   C11A             cmpb  #0x1A;
079F   2606             bne   P07A7;
07A1   8601             lda   #0x01;
07A3   9A76             ora   0x76;     /* Make some sound */
07A5   9776             sta   0x76;
07A7   9691      P07A7: lda   0x91;     /* Make Otto bounce up and down */
07A9   CE07EE           ldu   #OttoBounceOffsets;
07AC   ABC5             adda  b,u;
07AE   D692             ldb   0x92;
07B0   DD93             std   0x93;     /* Update Otto's position */
07B2   0DC5             tst   0xC5;     /* Is player still alive? */
07B4   2618             bne   $CheckForRobotHitByOtto;
07B6   8EC88F           ldx   #0xC88F;  /* Otto and player collide? */
07B9   108E0D39         ldy   #PlayerContactBounds;
07BD   BD0D1B           jsr   $CheckForContact;
07C0   240C             bhs   $CheckForRobotHitByOtto;
07C2   0C98             inc   0x98;     /* Increment Otto's velocity */
07C4   8608             lda   #0x08;
07C6   9A67             ora   0x67;
07C8   9767             sta   0x67;     /* Make a sound */
07CA   8604             lda   #0x04;
07CC   97C5             sta   0xC5;     /* Tag player as dead */

                 /* Kill off any robots which collide with Otto */
                 CheckForRobotHitByOtto:
07CE   8EC91C           ldx   #0xC91C;     /* Addr of robot array */
07D1   96C7             lda   0xC7;        /* Number of array entries */
07D3   979D             sta   0x9D;        /* Loop counter */
07D5   108E0D35         ldy   #RobotContactBounds;     /* 'Accuracy' table */
07D9   6D02      P07D9: tst   2,x;         /* Make sure robot is alive */
07DB   2A0A             bpl   P07E7;
07DD   DC93             ldd   0x93;        /* Get Otto's position */
07DF   BD0D1B           jsr   $CheckForContact;
07E2   2403             bhs   P07E7;
07E4   BD080F           jsr   $CreditPlayerWithDeadRobot;
07E7   3008      P07E7: leax  8,x;
07E9   0A9D             dec   0x9D;
07EB   26EC             bne   P07D9;
07ED   39        P07ED: rts;

                 OttoBounceOffsets:
07EE   00               .byte 0x00;
07EF   08               .byte 0x08;
07F0   0C               .byte 0x0C;
07F1   0E               .byte 0x0E;
07F2   10               .byte 0x10;
07F3   12               .byte 0x12;
07F4   12               .byte 0x12;
07F5   12               .byte 0x12;
07F6   14               .byte 0x14;
07F7   16               .byte 0x16;
07F8   16               .byte 0x16;
07F9   16               .byte 0x16;
07FA   16               .byte 0x16;
07FB   16               .byte 0x16;
07FC   14               .byte 0x14;
07FD   12               .byte 0x12;
07FE   12               .byte 0x12;
07FF   12               .byte 0x12;
0800   10               .byte 0x10;
0801   0E               .byte 0x0E;
0802   0C               .byte 0x0C;
0803   08               .byte 0x08;
0804   00               .byte 0x00;
0805   FC               .byte 0xFC;
0806   F8               .byte 0xF8;
0807   F4               .byte 0xF4;
0808   EE               .byte 0xEE;
0809   EA               .byte 0xEA;
080A   EE               .byte 0xEE;
080B   F4               .byte 0xF4;
080C   F8               .byte 0xF8;
080D   FC               .byte 0xFC;
080E   00               .byte 0x00;

                 /*
                  * CreditPlayerWithDeadRobot()
                  *
                  * This function decrements the number of active robots
                  * (C8C8), marks the robot as dead, and credits the player
                  * with 50 points.
                  *
                  * Entry:
                  *    x = pointer to dead robot structure.
                  */
                 CreditPlayerWithDeadRobot:
080F   0AC8             dec   0xC8;
0811   860F             lda   #0x0F;
0813   A702             sta   2,x;
0815   8604             lda   #0x04;
0817   9767             sta   0x67;
0819   3410             pshs  x;
081B   9E80             ldx   0x80;
081D   CC0050           ldd   #0x0050;
0820   BDF87C           jsr   $add_d_to_x_in_bcd;
0823   3590             puls  x,pc;

                 /*
                  * ProcessAndUpdateBullets()
                  *
                  * This function updates the head and tail of each bullet,
                  * and checks to see if a bullet has run into a wall,
                  * hit a robot, or hit the player.  A bullet's position
                  * is updated multiple times, based on its velocity setting;
                  * a higher velocity setting causes a bullet to be updated
                  * more often.  A bullet is a short vector made up of a
                  * head and a tail.
                  */
                 ProcessAndUpdateBullets:
0825   96CC             lda   0xCC;      /* Number of bullets */
0827   1027009B         lbeq  P08C6;
082B   97A2             sta   0xA2;      /* Set loop counter */
082D   CEC974           ldu   #0xC974;
0830   E647      P0830: ldb   7,u;
0832   C40F             andb  #0x0F;     /* Skip if bullet is not active */
0834   1027007E         lbeq  P08B6;
0838   D7EB             stb   0xEB;      /* Get the direction of travel */
083A   A646             lda   6,u;
083C   97A1             sta   0xA1;      /* Use velocity as loop counter */
083E   D6EB      P083E: ldb   0xEB;      /* Direction of travel */
0840   8601             lda   #0x01;     /* Velocity */
0842   30C4             leax  ,u;        /* Current tail position */
0844   BD0939           jsr   $CalculateUpdatedPosition;
0847   EDC4             std   ,u;        /* Update bullet's tail position */
0849   D6EB             ldb   0xEB;      /* Direction of travel */
084B   8601             lda   #0x01;     /* Velocity */
084D   3044             leax  4,u;       /* Current head position */
084F   BD0939           jsr   $CalculateUpdatedPosition;
0852   ED44             std   4,u;       /* Update bullet's head position */

                 /* See if bullet collided with a wall */
0854   EC44             ldd   4,u;       /* Bullet's head position */
0856   BD0F98           jsr   $MapPointToQuadrantAndMakeRelative;
0859   0D9A             tst   0x9A;
085B   2B06             bmi   P0863;
085D   8E0EF2           ldx   #BulletToWallThresholds;
0860   BD0EC7           jsr   $CheckForQuadrantEdgeCrossing;
0863   D599      P0863: bitb  0x99;      /* Contact with wall? */
0865   2706             beq   P086D;
0867   C6F0             ldb   #0xF0;
0869   E447             andb  7,u;
086B   E747             stb   7,u;       /* Flag bullet as hitting something */

                 /* See if bullet hit any of the robots */
086D   8EC91C    P086D: ldx   #0xC91C;
0870   96C7             lda   0xC7;
0872   979D             sta   0x9D;
0874   A602      P0874: lda   2,x;       /* Skip robot if already dead */
0876   2A14             bpl   P088C;
0878   108E0D35         ldy   #RobotContactBounds;
087C   EC44             ldd   4,u;       /* Position of bullet's head */
087E   BD0D1B           jsr   $CheckForContact;
0881   2409             bhs   P088C;
0883   BD080F           jsr   $CreditPlayerWithDeadRobot;
0886   C6F0             ldb   #0xF0;     /* Flag bullet as hitting something */
0888   E447             andb  7,u;
088A   E747             stb   7,u;
088C   3008      P088C: leax  8,x;
088E   0A9D             dec   0x9D;
0890   26E2             bne   P0874;

                 /* See if bullet hit the player */
0892   EC44             ldd   4,u;       /* Position of bullet's head */
0894   8EC88F           ldx   #0xC88F;   /* Check for contact with player ? */
0897   108E0D3D         ldy   #PlayerContactBounds2;
089B   BD0D1B           jsr   $CheckForContact;
089E   2412             bhs   P08B2;
08A0   0DC5             tst   0xC5;      /* Do nothing if player is already */
08A2   260E             bne   P08B2;     /* dead or has left the maze.      */
08A4   8608             lda   #0x08;
08A6   9767             sta   0x67;      /* Make a sound */
08A8   8604             lda   #0x04;
08AA   97C5             sta   0xC5;      /* Flag player as dead */
08AC   C6F0             ldb   #0xF0;
08AE   E447             andb  7,u;       /* Flag bullet as hitting something */
08B0   E747             stb   7,u;

                 /* Keep processing this bullet, based on its velocity */
08B2   0AA1      P08B2: dec   0xA1;
08B4   2688             bne   P083E;

                 /* Update the delta between the head and tail of bullet */
08B6   EC44      P08B6: ldd   4,u;
08B8   A0C4             suba  ,u;
08BA   E041             subb  1,u;
08BC   ED42             std   2,u;

                 /* Loop until all bullets have been processed */
08BE   3348             leau  8,u;
08C0   0AA2             dec   0xA2;
08C2   1026FF6A         lbne  P0830;
08C6   39        P08C6: rts;

                 /*
                  * DrawWithPossibleScrolling()
                  *
                  * This function draws an object at its scrolled position,
                  * until the starting point for the object being drawn
                  * scrolls off, at which point, the object is no longer
                  * drawn.  The scrolling offsets are incremented each time
                  * PlayerHasLeftMaze() is called.  Most of the code below
                  * is trying to determine if the starting point has
                  * scrolled off in the expected direction.
                  *
                  * Entry:
                  *   x = ptr to vector list (for generic draw functions)
                  *   u = ptr to drawing position
                  *   C8C9 = drawing function to call
                  */
                 DrawWithPossibleScrolling:
08C7   BDF1AF           jsr   $dptoC8;
08CA   E6C4             ldb   ,u;
08CC   1D               sex;
08CD   D3E2             addd  0xE2;
08CF   D79D             stb   0x9D;   /* starting y pos + scrolling offset */
08D1   2A13             bpl   P08E6;
08D3   43               coma;
08D4   2660             bne   DoNoDrawing;
08D6   0DE6             tst   0xE6;
08D8   2B1D             bmi   P08F7;
08DA   6DC4             tst   ,u;
08DC   2A58             bpl   DoNoDrawing;
08DE   863F             lda   #0x3F;
08E0   91E0             cmpa  0xE0;
08E2   2D52             blt   DoNoDrawing;
08E4   2011             bra   P08F7;
08E6   4D        P08E6: tsta;
08E7   264D             bne   DoNoDrawing;
08E9   0DE6             tst   0xE6;
08EB   2A0A             bpl   P08F7;
08ED   6DC4             tst   ,u;
08EF   2B45             bmi   DoNoDrawing;
08F1   86C1             lda   #0xC1;
08F3   91E0             cmpa  0xE0;
08F5   2C3F             bge   DoNoDrawing;
08F7   E641      P08F7: ldb   1,u;
08F9   1D               sex;
08FA   D3E4             addd  0xE4;
08FC   D79E             stb   0x9E;  /* starting x pos + scrolling offset */
08FE   2A13             bpl   P0913;
0900   43               coma;
0901   2633             bne   DoNoDrawing;
0903   0DE6             tst   0xE6;
0905   2B1D             bmi   P0924;
0907   6D41             tst   1,u;
0909   2A2B             bpl   DoNoDrawing;
090B   863F             lda   #0x3F;
090D   91E1             cmpa  0xE1;
090F   2D25             blt   DoNoDrawing;
0911   2011             bra   P0924;
0913   4D        P0913: tsta;
0914   2620             bne   DoNoDrawing;
0916   0DE6             tst   0xE6;
0918   2A0A             bpl   P0924;
091A   6D41             tst   1,u;
091C   2B18             bmi   DoNoDrawing;
091E   86C1             lda   #0xC1;
0920   91E1             cmpa  0xE1;
0922   2C12             bge   DoNoDrawing;
0924   BDF1AA    P0924: jsr   $dptoD0;
0927   FCC89D           ldd   $C89D;        /* Goto modified drawing origin */
092A   BDF2FC           jsr   $move_pen7F_to_d;
092D   B6C8CB           lda   $C8CB;        /* Set drawing intensity */
0930   9704             sta   0x04;
0932   AD9FC8C9         jsr   [0xC8C9];     /* Jump to drawing function*/

                 DoNoDrawing:
0936   7EF1AA           jmp   $dptoD0;

                 /*
                  * CalculateUpdatedPosition()
                  *
                  * This function updates a position, based upon a direction
                  * of travel, and a velocity setting.  The velocity is
                  * broken up into a rise and a run value, and added to the
                  * incoming position.
                  *
                  * Entry:
                  *   b = direction of travel
                  *   a = velocity setting
                  *   x = pointer to a position
                  *
                  * Exit:
                  *   d = updated position (y,x)
                  */
                 CalculateUpdatedPosition:
0939   C503             bitb  #0x03;
093B   2715             beq   AddVelocityToEndpoints;
093D   C50C             bitb  #0x0C;
093F   2711             beq   AddVelocityToEndpoints;

                 /* Break up velocity into rise and run components */
0941   3404             pshs  b;
0943   C603             ldb   #0x03;
0945   3D               mul;
0946   57               asrb;
0947   2401             bhs   P094A;
0949   5C               incb;
094A   57        P094A: asrb;
094B   2401             bhs   P094E;
094D   5C               incb;
094E   1F98      P094E: tfr   b,a;
0950   3504             puls  b;

                 AddVelocityToEndpoints:
0952   979D             sta   0x9D;   /* Save adjusted velocity */
0954   C511             bitb  #0x11;
0956   2703             beq   P095B;
0958   40               nega;         /* Going left; - velocity */
0959   2005             bra   P0960;
095B   C502      P095B: bitb  #0x02;
095D   2601             bne   P0960;  /* Going right; + velocity */
095F   4F               clra          /* No movement in x direction */
0960   AB01      P0960: adda  1,x;    /* Update the x position */
0962   3402             pshs  a;
0964   969D             lda   0x9D;   /* Reload adjusted velocity */
0966   C508             bitb  #0x08;
0968   2703             beq   P096D;
096A   40               nega;         /* Going down; - velocity */
096B   2005             bra   P0972;
096D   C504      P096D: bitb  #0x04;
096F   2601             bne   P0972;  /* Going up; + velocity */
0971   4F               clra;         /* No movement in y direction */
0972   AB84      P0972: adda  ,x;     /* Update the y position */
0974   3584             puls  b,pc;

                 /*
                  * This is one of the 'indirect jump' functions.  It is the
                  * active jump function when the player successfully leaves
                  * a maze.  When the player exits from a door in the maze,
                  * the maze will then scroll off in the opposite direction;
                  * i.e. If the player exits through the left door, the maze
                  * will scroll off to the right.  Each time this function
                  * is called, it will bump the scrolling deltas; this
                  * continues until scrolling is complete.  It also sets
                  * the player's starting position in the next maze; if the
                  * player exited from the left, then he will start at the
                  * right edge of the next maze, and the door through which
                  * he exited will be blocked.
                  */
                 PlayerHasLeftMaze:
0976   C680             ldb   #0x80;
0978   D7E6             stb   0xE6;
097A   D6EA             ldb   0xEA;   /* Determine door player exited thru */
097C   C501             bitb  #0x01;
097E   2706             beq   P0986;
0980   0FE6             clr   0xE6;   /* Left door, so scroll right */
0982   0CE1             inc   0xE1;
0984   202C             bra   P09B2;
0986   C502      P0986: bitb  #0x02;
0988   2704             beq   P098E;
098A   0AE1             dec   0xE1;   /* Right door, so scroll left */
098C   2012             bra   P09A0;
098E   C504      P098E: bitb  #0x04;
0990   2704             beq   P0996;
0992   0AE0             dec   0xE0;   /* Top door, so scroll down */
0994   200A             bra   P09A0;
0996   C508      P0996: bitb  #0x08;
0998   2706             beq   P09A0;
099A   0FE6             clr   0xE6;   /* Bottom door, so scroll up */
099C   0CE0             inc   0xE0;
099E   2012             bra   P09B2;

                 /*
                  * This block checks to see if we have finished scrolling,
                  * and if so, prepares us for entering the next maze.
                  * It will also set the player's starting position in the
                  * next maze.
                  */
09A0   2B3C      P09A0: bmi   SaveScrollingDeltas;
09A2   C502             bitb  #0x02;
09A4   2706             beq   P09AC;   /* Exited thru right door? */
09A6   968F             lda   0x8F;
09A8   C6A5             ldb   #0xA5;   /* Yes; start at left edge */
09AA   2016             bra   P09C2;
09AC   86B0      P09AC: lda   #0xB0;   /* Exited thru top door */
09AE   D690             ldb   0x90;    /* Start at bottom */
09B0   2010             bra   P09C2;
09B2   2A2A      P09B2: bpl   SaveScrollingDeltas;
09B4   C508             bitb  #0x08;   /* Exited thru bottom door? */
09B6   2706             beq   P09BE;
09B8   8654             lda   #0x54;   /* Yes; start at top edge */
09BA   D690             ldb   0x90;
09BC   2004             bra   P09C2;
09BE   968F      P09BE: lda   0x8F;    /* Exited thru left door */
09C0   C65B             ldb   #0x5B;   /* Start at right edge */
09C2   9E80      P09C2: ldx   0x80;
09C4   ED0A             std   10,x;    /* Update player's position */
09C6   96EA             lda   0xEA;    /* This tells the exit door */
09C8   840F             anda  #0x0F;
09CA   48               asla;
09CB   97C6             sta   0xC6;    /* Block door player exited thru */
09CD   863F             lda   #0x3F;
09CF   9785             sta   0x85;    /* Set a loop counter */
09D1   86A0             lda   #0xA0;   /* Reset the threshold used to       */
09D3   0DD1             tst   0xD1;    /* determine if a robot is placed in */
09D5   2602             bne   P09D9;   /* the maze.                         */
09D7   8650             lda   #0x50;
09D9   97A8      P09D9: sta   0xA8;
09DB   7E00AF           jmp   $EnterNextMaze;

                 /*
                  * This block saves the x and y delta values, which are
                  * then used by the drawing function, to offset all
                  * drawing origins.
                  */
                 SaveScrollingDeltas:
09DE   D6E0             ldb   0xE0;
09E0   1D               sex;
09E1   58               aslb;
09E2   49               rola;
09E3   DDE2             std   0xE2;   /* Save 16-bit y delta */
09E5   D6E1             ldb   0xE1;
09E7   1D               sex;
09E8   58               aslb;
09E9   49               rola;
09EA   DDE4             std   0xE4;   /* Save 16-bit x delta */
09EC   7E019E           jmp   $MakeSoundThenGotoMainLoop;

                 /*
                  * DrawPlayerFunction()
                  *
                  * This function draws the player's body, and then the
                  * arms and legs; the types of arms and legs is dependent
                  * upon whether the player is standing still, running
                  * or shooting.  (C8CE) is the index indicating movement,
                  * while (C8CF) is the index indicating arm position
                  * (running, standing still or shooting).
                  */
                 DrawPlayerFunction:
09EF   7FC824           clr   $C824;
09F2   860A             lda   #0x0A;           /* Draw the player's body */
09F4   8E0BCD           ldx   #PlayersBody;
09F7   BDF3DA           jsr   $draw_VL_with_count5;
09FA   F6C8CE           ldb   $C8CE;           /* Running or standing still? */
09FD   2716             beq   PlayerStandingStill;
09FF   8E0A47           ldx   #PlayerLegsVectorTable;
0A02   AE85             ldx   b,x;
0A04   BDF410           jsr   $next_pt;
0A07   8E0A51           ldx   #PlayerMovingArmsVectorTable;
0A0A   F6C8CF           ldb   $C8CF;
0A0D   AE85             ldx   b,x;
0A0F   7CC824           inc   $C824;
0A12   7EF410           jmp   $next_pt;

                 PlayerStandingStill:
0A15   8E0C5B           ldx   #StationaryLegs;   /* Draw legs standing still */
0A18   BDF3AD           jsr   $move_then_draw_VL_with_count1;
0A1B   8E0A55           ldx   #PlayerArmsVectorTable;
0A1E   F6C8CF           ldb   $C8CF;
0A21   2705             beq   PlayerNotShooting;
0A23   AE85             ldx   b,x;            /* Player is shooting */
0A25   7EF3AD           jmp   $move_then_draw_VL_with_count1;

                 PlayerNotShooting:
0A28   AE84             ldx   ,x;             /* Draw arms at side */
0A2A   7EF410           jmp   $next_pt;

                 /*
                  * Whenever the player's score passes certain cutoff level,
                  * the game becomes more challenging.  The cutoff levels are:
                  * 3000, 15000, 30000, 45000, 50000, 60000 and 75000
                  */
                 SkillLevelCutoffs:
0A2D   20               .word 0x2033; /* " 3" */
0A2F   31               .word 0x3135; /* "15" */
0A31   33               .word 0x3330; /* "30" */
0A33   34               .word 0x3435; /* "45" */
0A35   35               .word 0x3530; /* "50" */
0A37   36               .word 0x3630; /* "60" */
0A39   37               .word 0x3735; /* "75" */
0A3B   80               .byte 0x80;

                 /*
                  * This table is used to fill in the player's arm
                  * movement value (C8CF), when standing still.  The
                  * value is obtained from this array, by indexing into
                  * it using the joystick state:
                  *
                  *         ---------------------------------
                  *         | 0 | 0 | B | L | D | U | R | L |
                  *         ---------------------------------
                  *   Button Pressed--^
                  *   Joystick Left-------^---------------^
                  *   Joystick Down-----------^
                  *   Joystick Up-----------------^
                  *   Joystick Right------------------^
                  */
                 ArmsShootingIndicesTable:
0A3C   80               .byte 0x80;     /* idx = 0x00; Invalid setting */
0A3D   02               .byte 0x02;     /* idx = 0x01; shooting left */
0A3E   04               .byte 0x04;     /* idx = 0x02; shooting right */
0A3F   80               .byte 0x80;     /* idx = 0x03; Invalid setting */
0A40   06               .byte 0x06;     /* idx = 0x04; shooting up */
0A41   08               .byte 0x08;     /* idx = 0x05; shooting upper left */
0A42   0A               .byte 0x0A;     /* idx = 0x06; shooting upper right */
0A43   80               .byte 0x80;     /* idx = 0x07; Invalid setting */
0A44   0C               .byte 0x0C;     /* idx = 0x08; shooting down */
0A45   0E               .byte 0x0E;     /* idx = 0x09; shooting lower left */
0A46   10               .byte 0x10;     /* idx = 0x0A; shooting lower right */

                 /*
                  * As the player runs, the legs either move in a left or
                  * right direction.  The value in C8CE is used to index
                  * into this table.
                  */
                 PlayerLegsVectorTable:
0A47   0C               .word StationaryLegs;
0A49   0B               .word LegsRunningRight1;
0A4B   0B               .word LegsRunningRight2;
0A4D   0C               .word LegsRunningLeft1;
0A4F   0C               .word LegsRunningLeft2;

                 /*
                  * As the player moves, his arms swing back and forth.
                  * The value in C8CF is used to index into this table.
                  */
                 PlayerMovingArmsVectorTable:
0A51   0C               .word MovingArms1;
0A53   0C               .word MovingArms2;

                 /*
                  * When a player is standing still, they are either shooting
                  * or not shooting.  The value in C8CF is used to index into
                  * this table.
                  */
                 PlayerArmsVectorTable:
0A55   0C               .word NeutralArms;
0A57   0C               .word ShootingLeft;
0A59   0C               .word ShootingRight;
0A5B   0C               .word ShootingUp;
0A5D   0C               .word ShootingUpperLeft;
0A5F   0C               .word ShootingUpperRight;
0A61   0C               .word ShootingDown;
0A63   0C               .word ShootingLowerLeft;
0A65   0C               .word ShootingLowerRight;

                 /*
                  * Depending upon what a robot is doing, his extremities
                  * (legs and eye boxes) may be drawn differently.  Each
                  * entry in this table points to another structure, which
                  * defines how the extremities should be drawn.  Each robot
                  * structure has a field which is used to index into this
                  * table.
                  */
                 RobotExtremitiesVectorTable:
0A67   0A               .word RobotStandingStill;
0A69   0A               .word RobotMovingLeft;
0A6B   0A               .word RobotMovingRight;
0A6D   0A               .word RobotStandingStill;
0A6F   0A               .word RobotMovingUp;
0A71   0A               .word RobotMovingLeft;
0A73   0A               .word RobotMovingRight;
0A75   0A               .word RobotStandingStill;
0A77   0A               .word RobotMovingDown;
0A79   0A               .word RobotMovingLeft;
0A7B   0A               .word RobotMovingRight;

                 /*
                  * Each of the following 5 structures describe how the
                  * extremities should be drawn for a robot, while in a
                  * particular state.  The structure is defined as follows:
                  *
                  *   {
                  *       ptr to first right leg vector list
                  *       ptr to second right leg vector list
                  *       ptr to right foot vector list
                  *       ptr to first left leg vector list
                  *       ptr to second left leg vector list
                  *       ptr to left foot vector list
                  *       ptr to eye box 1 vector list
                  *       ptr to eye box 2 vector list
                  *       ptr to eye box 3 vector list
                  *       ptr to eye box 4 vector list
                  *   }
                  *
                  * As the robot is drawn, it will cycle through the 2
                  * right leg and 2 left leg vector list; it will also
                  * cycle through the 4 eye box vector lists.  In some
                  * cases, values will be the same; this implies that no
                  * motion is occurring (i.e. if the robot is not moving,
                  * then the legs shouldn't be moving either).
                  *
                  * When a robot is moving left, the eye box and both feet
                  * point to the left.  When the robot is moving right, then
                  * the eye box and both feed point right.  When the robot
                  * is moving up, then the eye box points up.  When the robot
                  * moves down, no eye box is displayed.  When the robot is
                  * standing still, the eye box will appear to rotate.
                  */
                 RobotStandingStill:
0A7D   0B               .word RobotRightLeg1;
0A7F   0B               .word RobotRightLeg1;
0A81   0B               .word RobotRightFoot;
0A83   0B               .word RobotLeftLeg1;
0A85   0B               .word RobotLeftLeg1;
0A87   0B               .word RobotLeftFoot;
0A89   0B               .word RobotEyeBoxCentered;
0A8B   0B               .word RobotEyeBoxRight;
0A8D   0B               .word RobotEyeBoxInvisible;
0A8F   0B               .word RobotEyeBoxLeft;

                 RobotMovingRight:
0A91   0B               .word RobotRightLeg1;
0A93   0B               .word RobotRightLeg2;
0A95   0B               .word RobotRightFoot;
0A97   0B               .word RobotLeftLeg1;
0A99   0B               .word RobotLeftLeg2;
0A9B   0B               .word RobotRightFoot;
0A9D   0B               .word RobotEyeBoxRight;
0A9F   0B               .word RobotEyeBoxRight;
0AA1   0B               .word RobotEyeBoxRight;
0AA3   0B               .word RobotEyeBoxRight;

                 RobotMovingLeft:
0AA5   0B               .word RobotRightLeg1;
0AA7   0B               .word RobotRightLeg2;
0AA9   0B               .word RobotLeftFoot;
0AAB   0B               .word RobotLeftLeg1;
0AAD   0B               .word RobotLeftLeg2;
0AAF   0B               .word RobotLeftFoot;
0AB1   0B               .word RobotEyeBoxLeft;
0AB3   0B               .word RobotEyeBoxLeft;
0AB5   0B               .word RobotEyeBoxLeft;
0AB7   0B               .word RobotEyeBoxLeft;

                 RobotMovingUp:
0AB9   0B               .word RobotRightLeg1;
0ABB   0B               .word RobotRightLeg3;
0ABD   0B               .word RobotRightFoot;
0ABF   0B               .word RobotLeftLeg3;
0AC1   0B               .word RobotLeftLeg1;
0AC3   0B               .word RobotLeftFoot;
0AC5   0B               .word RobotEyeBoxCentered;
0AC7   0B               .word RobotEyeBoxCentered;
0AC9   0B               .word RobotEyeBoxCentered;
0ACB   0B               .word RobotEyeBoxCentered;

                 RobotMovingDown:
0ACD   0B               .word RobotRightLeg1;
0ACF   0B               .word RobotRightLeg3;
0AD1   0B               .word RobotRightFoot;
0AD3   0B               .word RobotLeftLeg3;
0AD5   0B               .word RobotLeftLeg1;
0AD7   0B               .word RobotLeftFoot;
0AD9   0B               .word RobotEyeBoxInvisible;
0ADB   0B               .word RobotEyeBoxInvisible;
0ADD   0B               .word RobotEyeBoxInvisible;
0ADF   0B               .word RobotEyeBoxInvisible;

                 BonusString:
0AE1   70               .byte 0x70; /* rel y */
0AE2   DA               .byte 0xDA; /* rel x */
0AE3   42               .string "BONUS",0xFF;

                 /*
                  * As the player gets better, the game will start to
                  * block off one of the maze doors.  The value in C8C6
                  * is used to index into this array, when the value > 0.
                  * The value in C8C6 has the following format:
                  *
                  *         ---------------------------------
                  *         | 0 | 0 | 0 | T | B | L | R | 0 |
                  *         ---------------------------------
                  *   Block Top Door------^
                  *   Block Bottom Door-------^
                  *   Block Left Door-------------^
                  *   Block Right Door----------------^
                  */
                 BlockedDoorVectorTable:
0AE9   0A               .word BlockedDoorVectorTable;  /* idx = 0; Invalid */
0AEB   0A               .word RightDoorVectors;        /* idx = 2 */
0AED   0A               .word LeftDoorVectors;         /* idx = 4 */
0AEF   0A               .word BlockedDoorVectorTable;  /* idx = 6; Invalid */
0AF1   0B               .word BottomDoorVectors;       /* idx = 8 */
0AF3   0A               .word BlockedDoorVectorTable;  /* idx = 10; Invalid */
0AF5   0A               .word BlockedDoorVectorTable;  /* idx = 12; Invalid */
0AF7   0A               .word BlockedDoorVectorTable;  /* idx = 14; Invalid */
0AF9   0B               .word TopDoorVectors;          /* idx = 16 */

                 /*
                  * Each of the following tables contain the relative (y,x)
                  * point to move to, followed by the (y,x) point to draw to.
                  */
                 RightDoorVectors:
0AFB   E0               .byte 0xE0;   /* move to absolute y */
0AFC   64               .byte 0x64;   /* move to absolute x */
0AFD   40               .byte 0x40;   /* vector rel y */
0AFE   00               .byte 0x00;   /* vector rel x */

                 LeftDoorVectors:
0AFF   E0               .byte 0xE0;   /* move to absolute y */
0B00   9C               .byte 0x9C;   /* move to absolute x */
0B01   40               .byte 0x40;   /* vector rel y */
0B02   00               .byte 0x00;   /* vector rel x */

                 TopDoorVectors:
0B03   60               .byte 0x60;   /* move to absolute y */
0B04   EC               .byte 0xEC;   /* move to absolute x */
0B05   00               .byte 0x00;   /* vector rel y */
0B06   28               .byte 0x28;   /* vector rel x */

                 BottomDoorVectors:
0B07   A0               .byte 0xA0;   /* move to absolute y */
0B08   EC               .byte 0xEC;   /* move to absolute x */
0B09   00               .byte 0x00;   /* vector rel y */
0B0A   28               .byte 0x28;   /* vector rel x */

                 /*
                  * This structure contains 4 entries; 1 for each of the
                  * sections of outer wall which must be drawn.  Each
                  * entry contains an absolute (y,x) position, to which
                  * the pen should be moved before doing any drawing, and
                  * a pointer to the appropriate vector list.
                  */
                 OutsideMazeWallData:
0B0B   60               .byte 0x60;  /* absolute y */
0B0C   EC               .byte 0xEC;  /* absolute x */
0B0D   0B               .word UpperLeftWall;
0B0F   A0               .byte 0xA0;  /* absolute y */
0B10   EC               .byte 0xEC;  /* absolute x */
0B11   0B               .word LowerLeftWall;
0B13   A0               .byte 0xA0;  /* absolute y */
0B14   14               .byte 0x14;  /* absolute x */
0B15   0B               .word LowerRightWall;
0B17   60               .byte 0x60;  /* absolute y */
0B18   14               .byte 0x14;  /* absolute x */
0B19   0B               .word UpperRightWall;

                 /*
                  * The following is a table of 8 (y,x) points, which
                  * represent the starting points for all interior maze
                  * walls.  The maze is divided into 15 quadrants, and
                  * these points represent the points where 4 quadrants
                  * meet (as indicated by the '+' character:
                  *
                  *     -100 -60 -20 +20 +60 +100
                  *       --------------------- +96
                  *       | 0 | 1 | 2 | 3 | 4 |
                  *       ----+---+---+---+---- +32
                  *       | 5 | 6 | 7 | 8 | 9 |
                  *       ----+---+---+---+---- -32
                  *       |10 |11 |12 |13 |14 |
                  *       --------------------- -96
                  */
                 InnerWallPositionTable:
0B1B   20               .byte 0x20;
0B1C   C4               .byte 0xC4;
0B1D   20               .byte 0x20;
0B1E   EC               .byte 0xEC;
0B1F   20               .byte 0x20;
0B20   14               .byte 0x14;
0B21   20               .byte 0x20;
0B22   3C               .byte 0x3C;
0B23   E0               .byte 0xE0;
0B24   C4               .byte 0xC4;
0B25   E0               .byte 0xE0;
0B26   EC               .byte 0xEC;
0B27   E0               .byte 0xE0;
0B28   14               .byte 0x14;
0B29   E0               .byte 0xE0;
0B2A   3C               .byte 0x3C;

                 /*
                  * The following 4 structures contain the (y,x) points
                  * needed to draw 2 of the outer maze walls.
                  */
                 UpperLeftWall:
0B2B   00               .byte 0x00;
0B2C   B0               .byte 0xB0;
0B2D   C0               .byte 0xC0;
0B2E   00               .byte 0x00;

                 LowerLeftWall:
0B2F   00               .byte 0x00;
0B30   B0               .byte 0xB0;
0B31   40               .byte 0x40;
0B32   00               .byte 0x00;

                 LowerRightWall:
0B33   00               .byte 0x00;
0B34   50               .byte 0x50;
0B35   40               .byte 0x40;
0B36   00               .byte 0x00;

                 UpperRightWall:
0B37   00               .byte 0x00;
0B38   50               .byte 0x50;
0B39   C0               .byte 0xC0;
0B3A   00               .byte 0x00;

                 /*
                  * The following is a table of 4 single vectors, each
                  * representing a posible vector which might be drawn
                  * as an inner wall.  From any one of the inner points,
                  * a wall could be drawn:
                  *
                  *   1) upward
                  *   2) downward
                  *   3) to the right
                  *   4) to the left
                  *
                  * When drawing the maze, the 8 byte array C8AB-C8B2
                  * (which contains one entry for each of the 8 possible
                  * inner wall positions) indicates which of the segments
                  * should be drawn; the index is either 0, 2, 4 or 6.
                  */
                 InnerWallVectorTable:
0B3B   40               .byte 0x40; /* Draw upward from point */
0B3C   00               .byte 0x00;
0B3D   C0               .byte 0xC0; /* Draw downward from point */
0B3E   00               .byte 0x00;
0B3F   00               .byte 0x00; /* Draw right from point */
0B40   28               .byte 0x28;
0B41   00               .byte 0x00; /* Draw left from point */
0B42   D8               .byte 0xD8;

                 /*
                  * Vector list comprising right half of the robot's body.
                  */
                 RobotRightHalf:
0B43   05               .byte 0x05; /* vector count - 1 */
0B44   64               .byte 0x64; /* rel y */
0B45   00               .byte 0x00; /* rel x */
0B46   00               .byte 0x00;
0B47   28               .byte 0x28;
0B48   E8               .byte 0xE8;
0B49   28               .byte 0x28;
0B4A   84               .byte 0x84;
0B4B   00               .byte 0x00;
0B4C   00               .byte 0x00;
0B4D   EC               .byte 0xEC;
0B4E   30               .byte 0x30;
0B4F   00               .byte 0x00;

                 RobotRightLeg1:
0B50   00               .byte 0x00;
0B51   E4               .byte 0xE4;
0B52   9C               .byte 0x9C;
0B53   00               .byte 0x00;

                 RobotRightLeg2:
0B54   00               .byte 0x00;
0B55   D0               .byte 0xD0;
0B56   9C               .byte 0x9C;
0B57   00               .byte 0x00;

                 RobotRightLeg3:
0B58   00               .byte 0x00;
0B59   E4               .byte 0xE4;
0B5A   8D               .byte 0x8D;
0B5B   00               .byte 0x00;

                 RobotRightFoot:
0B5C   00               .byte 0x00;
0B5D   1C               .byte 0x1C;

                 /*
                  * Vector list comprising left half of the robot's body.
                  */
                 RobotLeftHalf:
0B5E   05               .byte 0x05; /* vector count - 1 */
0B5F   64               .byte 0x64; /* rel y */
0B60   00               .byte 0x00; /* rel x */
0B61   00               .byte 0x00;
0B62   D8               .byte 0xD8;
0B63   E8               .byte 0xE8;
0B64   D8               .byte 0xD8;
0B65   84               .byte 0x84;
0B66   00               .byte 0x00;
0B67   00               .byte 0x00;
0B68   14               .byte 0x14;
0B69   30               .byte 0x30;
0B6A   00               .byte 0x00;

                 RobotLeftLeg1:
0B6B   00               .byte 0x00;
0B6C   1C               .byte 0x1C;
0B6D   9C               .byte 0x9C;
0B6E   00               .byte 0x00;

                 RobotLeftLeg2:
0B6F   00               .byte 0x00;
0B70   30               .byte 0x30;
0B71   9C               .byte 0x9C;
0B72   00               .byte 0x00;

                 RobotLeftLeg3:
0B73   00               .byte 0x00;
0B74   1C               .byte 0x1C;
0B75   8D               .byte 0x8D;
0B76   00               .byte 0x00;

                 RobotLeftFoot:
0B77   00               .byte 0x00;
0B78   E4               .byte 0xE4;

                 RobotEyeBoxCentered:
0B79   30               .byte 0x30;
0B7A   28               .byte 0x28;
0B7B   1C               .byte 0x1C;
0B7C   00               .byte 0x00;
0B7D   00               .byte 0x00;
0B7E   B0               .byte 0xB0;
0B7F   E4               .byte 0xE4;
0B80   00               .byte 0x00;
0B81   00               .byte 0x00;
0B82   50               .byte 0x50;

                 RobotEyeBoxRight:
0B83   30               .byte 0x30;
0B84   14               .byte 0x14;
0B85   00               .byte 0x00;
0B86   3C               .byte 0x3C;
0B87   1C               .byte 0x1C;
0B88   00               .byte 0x00;
0B89   00               .byte 0x00;
0B8A   C4               .byte 0xC4;
0B8B   E4               .byte 0xE4;
0B8C   00               .byte 0x00;

                 RobotEyeBoxLeft:
0B8D   30               .byte 0x30;
0B8E   EC               .byte 0xEC;
0B8F   1C               .byte 0x1C;
0B90   00               .byte 0x00;
0B91   00               .byte 0x00;
0B92   C4               .byte 0xC4;
0B93   E4               .byte 0xE4;
0B94   00               .byte 0x00;
0B95   00               .byte 0x00;
0B96   3C               .byte 0x3C;

                 RobotEyeBoxInvisible:
0B97   00               .byte 0x00;
0B98   00               .byte 0x00;

                 OttoVectors:
0B99   00               .byte 0x00;
0B9A   18               .byte 0x18;
0B9B   0A               .byte 0x0A;
0B9C   FF               .byte 0xFF;
0B9D   F2               .byte 0xF2;
0B9E   0E               .byte 0x0E;
0B9F   FF               .byte 0xFF;
0BA0   EC               .byte 0xEC;
0BA1   00               .byte 0x00;
0BA2   FF               .byte 0xFF;
0BA3   F2               .byte 0xF2;
0BA4   F2               .byte 0xF2;
0BA5   FF               .byte 0xFF;
0BA6   00               .byte 0x00;
0BA7   EC               .byte 0xEC;
0BA8   FF               .byte 0xFF;
0BA9   0E               .byte 0x0E;
0BAA   F2               .byte 0xF2;
0BAB   FF               .byte 0xFF;
0BAC   14               .byte 0x14;
0BAD   00               .byte 0x00;
0BAE   FF               .byte 0xFF;
0BAF   0E               .byte 0x0E;
0BB0   0E               .byte 0x0E;
0BB1   FF               .byte 0xFF;
0BB2   00               .byte 0x00;
0BB3   14               .byte 0x14;
0BB4   00               .byte 0x00;
0BB5   F4               .byte 0xF4;
0BB6   03               .byte 0x03;
0BB7   FF               .byte 0xFF;
0BB8   FD               .byte 0xFD;
0BB9   FB               .byte 0xFB;
0BBA   00               .byte 0x00;
0BBB   00               .byte 0x00;
0BBC   F2               .byte 0xF2;
0BBD   FF               .byte 0xFF;
0BBE   03               .byte 0x03;
0BBF   FB               .byte 0xFB;
0BC0   00               .byte 0x00;
0BC1   EC               .byte 0xEC;
0BC2   00               .byte 0x00;
0BC3   FF               .byte 0xFF;
0BC4   FD               .byte 0xFD;
0BC5   05               .byte 0x05;
0BC6   FF               .byte 0xFF;
0BC7   00               .byte 0x00;
0BC8   0E               .byte 0x0E;
0BC9   FF               .byte 0xFF;
0BCA   03               .byte 0x03;
0BCB   05               .byte 0x05;
0BCC   01               .byte 0x01;

                 PlayersBody:
0BCD   00               .byte 0x00;
0BCE   14               .byte 0x14;
0BCF   C4               .byte 0xC4;
0BD0   00               .byte 0x00;
0BD1   00               .byte 0x00;
0BD2   D8               .byte 0xD8;
0BD3   3C               .byte 0x3C;
0BD4   00               .byte 0x00;
0BD5   00               .byte 0x00;
0BD6   14               .byte 0x14;
0BD7   0F               .byte 0x0F;
0BD8   14               .byte 0x14;
0BD9   0A               .byte 0x0A;
0BDA   00               .byte 0x00;
0BDB   0A               .byte 0x0A;
0BDC   EC               .byte 0xEC;
0BDD   F6               .byte 0xF6;
0BDE   EC               .byte 0xEC;
0BDF   F6               .byte 0xF6;
0BE0   00               .byte 0x00;
0BE1   F1               .byte 0xF1;
0BE2   14               .byte 0x14;
0BE3   01               .byte 0x01;

                 LegsRunningRight1:
0BE4   00               .byte 0x00;
0BE5   C4               .byte 0xC4;
0BE6   0C               .byte 0x0C;
0BE7   FF               .byte 0xFF;
0BE8   E0               .byte 0xE0;
0BE9   16               .byte 0x16;
0BEA   FF               .byte 0xFF;
0BEB   EA               .byte 0xEA;
0BEC   06               .byte 0x06;
0BED   FF               .byte 0xFF;
0BEE   FE               .byte 0xFE;
0BEF   08               .byte 0x08;
0BF0   00               .byte 0x00;
0BF1   10               .byte 0x10;
0BF2   98               .byte 0x98;
0BF3   FF               .byte 0xFF;
0BF4   0A               .byte 0x0A;
0BF5   04               .byte 0x04;
0BF6   FF               .byte 0xFF;
0BF7   08               .byte 0x08;
0BF8   20               .byte 0x20;
0BF9   FF               .byte 0xFF;
0BFA   16               .byte 0x16;
0BFB   08               .byte 0x08;
0BFC   01               .byte 0x01;

                 LegsRunningRight2:
0BFD   00               .byte 0x00;
0BFE   C4               .byte 0xC4;
0BFF   08               .byte 0x08;
0C00   FF               .byte 0xFF;
0C01   E0               .byte 0xE0;
0C02   0A               .byte 0x0A;
0C03   FF               .byte 0xFF;
0C04   E6               .byte 0xE6;
0C05   F8               .byte 0xF8;
0C06   FF               .byte 0xFF;
0C07   00               .byte 0x00;
0C08   08               .byte 0x08;
0C09   00               .byte 0x00;
0C0A   00               .byte 0x00;
0C0B   DC               .byte 0xDC;
0C0C   FF               .byte 0xFF;
0C0D   02               .byte 0x02;
0C0E   F8               .byte 0xF8;
0C0F   FF               .byte 0xFF;
0C10   1A               .byte 0x1A;
0C11   08               .byte 0x08;
0C12   FF               .byte 0xFF;
0C13   1E               .byte 0x1E;
0C14   02               .byte 0x02;
0C15   01               .byte 0x01;

                 LegsRunningLeft1:
0C16   00               .byte 0x00;
0C17   C4               .byte 0xC4;
0C18   08               .byte 0x08;
0C19   FF               .byte 0xFF;
0C1A   E2               .byte 0xE2;
0C1B   FE               .byte 0xFE;
0C1C   FF               .byte 0xFF;
0C1D   E6               .byte 0xE6;
0C1E   0E               .byte 0x0E;
0C1F   FF               .byte 0xFF;
0C20   FE               .byte 0xFE;
0C21   FC               .byte 0xFC;
0C22   00               .byte 0x00;
0C23   00               .byte 0x00;
0C24   DC               .byte 0xDC;
0C25   FF               .byte 0xFF;
0C26   00               .byte 0x00;
0C27   08               .byte 0x08;
0C28   FF               .byte 0xFF;
0C29   1A               .byte 0x1A;
0C2A   FA               .byte 0xFA;
0C2B   FF               .byte 0xFF;
0C2C   20               .byte 0x20;
0C2D   0A               .byte 0x0A;
0C2E   01               .byte 0x01;

                 LegsRunningLeft2:
0C2F   00               .byte 0x00;
0C30   C4               .byte 0xC4;
0C31   08               .byte 0x08;
0C32   FF               .byte 0xFF;
0C33   EA               .byte 0xEA;
0C34   08               .byte 0x08;
0C35   FF               .byte 0xFF;
0C36   F8               .byte 0xF8;
0C37   20               .byte 0x20;
0C38   FF               .byte 0xFF;
0C39   F6               .byte 0xF6;
0C3A   04               .byte 0x04;
0C3B   00               .byte 0x00;
0C3C   F0               .byte 0xF0;
0C3D   9C               .byte 0x9C;
0C3E   FF               .byte 0xFF;
0C3F   02               .byte 0x02;
0C40   08               .byte 0x08;
0C41   FF               .byte 0xFF;
0C42   16               .byte 0x16;
0C43   06               .byte 0x06;
0C44   FF               .byte 0xFF;
0C45   20               .byte 0x20;
0C46   16               .byte 0x16;
0C47   01               .byte 0x01;

                 NeutralArms:
0C48   00               .byte 0x00;
0C49   32               .byte 0x32;
0C4A   1E               .byte 0x1E;
0C4B   FF               .byte 0xFF;
0C4C   F6               .byte 0xF6;
0C4D   14               .byte 0x14;
0C4E   FF               .byte 0xFF;
0C4F   E6               .byte 0xE6;
0C50   00               .byte 0x00;
0C51   00               .byte 0x00;
0C52   24               .byte 0x24;
0C53   C4               .byte 0xC4;
0C54   FF               .byte 0xFF;
0C55   F6               .byte 0xF6;
0C56   EC               .byte 0xEC;
0C57   FF               .byte 0xFF;
0C58   E6               .byte 0xE6;
0C59   00               .byte 0x00;
0C5A   01               .byte 0x01;

                 StationaryLegs:
0C5B   05               .byte 0x05;
0C5C   C4               .byte 0xC4;
0C5D   0A               .byte 0x0A;
0C5E   D8               .byte 0xD8;
0C5F   00               .byte 0x00;
0C60   FC               .byte 0xFC;
0C61   0A               .byte 0x0A;
0C62   FC               .byte 0xFC;
0C63   F6               .byte 0xF6;
0C64   00               .byte 0x00;
0C65   EC               .byte 0xEC;
0C66   30               .byte 0x30;
0C67   00               .byte 0x00;

                 ShootingRight:
0C68   03               .byte 0x03;
0C69   32               .byte 0x32;
0C6A   1E               .byte 0x1E;
0C6B   00               .byte 0x00;
0C6C   28               .byte 0x28;
0C6D   F0               .byte 0xF0;
0C6E   C0               .byte 0xC0;
0C6F   10               .byte 0x10;
0C70   F0               .byte 0xF0;

               ShootingLeft:
0C71   03               .byte 0x03;
0C72   32               .byte 0x32;
0C73   1E               .byte 0x1E;
0C74   F0               .byte 0xF0;
0C75   F0               .byte 0xF0;
0C76   10               .byte 0x10;
0C77   C0               .byte 0xC0;
0C78   00               .byte 0x00;
0C79   28               .byte 0x28;

               ShootingUp:
0C7A   04               .byte 0x04;
0C7B   32               .byte 0x32;
0C7C   1E               .byte 0x1E;
0C7D   0A               .byte 0x0A;
0C7E   14               .byte 0x14;
0C7F   24               .byte 0x24;
0C80   00               .byte 0x00;
0C81   C4               .byte 0xC4;
0C82   E2               .byte 0xE2;
0C83   0E               .byte 0x0E;
0C84   E2               .byte 0xE2;

                ShootingDown:
0C85   04               .byte 0x04;
0C86   32               .byte 0x32;
0C87   1E               .byte 0x1E;
0C88   EC               .byte 0xEC;
0C89   D0               .byte 0xD0;
0C8A   E4               .byte 0xE4;
0C8B   F4               .byte 0xF4;
0C8C   24               .byte 0x24;
0C8D   00               .byte 0x00;
0C8E   0A               .byte 0x0A;
0C8F   14               .byte 0x14;

                ShootingUpperLeft:
0C90   04               .byte 0x04;
0C91   32               .byte 0x32;
0C92   1E               .byte 0x1E;
0C93   F0               .byte 0xF0;
0C94   F0               .byte 0xF0;
0C95   30               .byte 0x30;
0C96   C0               .byte 0xC0;
0C97   D0               .byte 0xD0;
0C98   18               .byte 0x18;
0C99   10               .byte 0x10;
0C9A   10               .byte 0x10;

                ShootingLowerLeft:
0C9B   03               .byte 0x03;
0C9C   32               .byte 0x32;
0C9D   1E               .byte 0x1E;
0C9E   E8               .byte 0xE8;
0C9F   10               .byte 0x10;
0CA0   E0               .byte 0xE0;
0CA1   D0               .byte 0xD0;
0CA2   3A               .byte 0x3A;
0CA3   1A               .byte 0x1A;

                ShootingUpperRight:
0CA4   04               .byte 0x04;
0CA5   32               .byte 0x32;
0CA6   1E               .byte 0x1E;
0CA7   F0               .byte 0xF0;
0CA8   10               .byte 0x10;
0CA9   30               .byte 0x30;
0CAA   18               .byte 0x18;
0CAB   D0               .byte 0xD0;
0CAC   C0               .byte 0xC0;
0CAD   10               .byte 0x10;
0CAE   F0               .byte 0xF0;

                ShootingLowerRight:
0CAF   03               .byte 0x03;
0CB0   32               .byte 0x32;
0CB1   1E               .byte 0x1E;
0CB2   C4               .byte 0xC4;
0CB3   18               .byte 0x18;
0CB4   20               .byte 0x20;
0CB5   D0               .byte 0xD0;
0CB6   18               .byte 0x18;
0CB7   F0               .byte 0xF0;

                MovingArms1:
0CB8   00               .byte 0x00;
0CB9   32               .byte 0x32;
0CBA   1E               .byte 0x1E;
0CBB   FF               .byte 0xFF;
0CBC   F0               .byte 0xF0;
0CBD   10               .byte 0x10;
0CBE   FF               .byte 0xFF;
0CBF   EA               .byte 0xEA;
0CC0   F8               .byte 0xF8;
0CC1   00               .byte 0x00;
0CC2   04               .byte 0x04;
0CC3   BC               .byte 0xBC;
0CC4   FF               .byte 0xFF;
0CC5   18               .byte 0x18;
0CC6   00               .byte 0x00;
0CC7   FF               .byte 0xFF;
0CC8   06               .byte 0x06;
0CC9   14               .byte 0x14;
0CCA   01               .byte 0x01;

                MovingArms2:
0CCB   00               .byte 0x00;
0CCC   32               .byte 0x32;
0CCD   22               .byte 0x22;
0CCE   FF               .byte 0xFF;
0CCF   FA               .byte 0xFA;
0CD0   14               .byte 0x14;
0CD1   FF               .byte 0xFF;
0CD2   E4               .byte 0xE4;
0CD3   00               .byte 0x00;
0CD4   00               .byte 0x00;
0CD5   FC               .byte 0xFC;
0CD6   BC               .byte 0xBC;
0CD7   FF               .byte 0xFF;
0CD8   16               .byte 0x16;
0CD9   F8               .byte 0xF8;
0CDA   FF               .byte 0xFF;
0CDB   10               .byte 0x10;
0CDC   10               .byte 0x10;
0CDD   01               .byte 0x01;

                 AuthorsInitials:
0CDE   F8               .byte 0xF8; /* height */
0CDF   30               .byte 0x30; /* width */
0CE0   A0               .byte 0xA0; /* y */
0CE1   30               .byte 0x30; /* x */
0CE2   43               .string "CMK",0x80;

                 /*
                  * This contains the starting positions for
                  * robots; a random number is used to index into this
                  * table.  It is formated as (y, x) pairs.
                  */
                 RobotStartingPositionTable:
0CE6   40               .byte 0x40;
0CE7   B0               .byte 0xB0;
0CE8   C0               .byte 0xC0;
0CE9   B0               .byte 0xB0;
0CEA   40               .byte 0x40;
0CEB   D8               .byte 0xD8;
0CEC   00               .byte 0x00;
0CED   D8               .byte 0xD8;
0CEE   C0               .byte 0xC0;
0CEF   D8               .byte 0xD8;
0CF0   00               .byte 0x00;
0CF1   00               .byte 0x00;
0CF2   40               .byte 0x40;
0CF3   28               .byte 0x28;
0CF4   00               .byte 0x00;
0CF5   28               .byte 0x28;
0CF6   C0               .byte 0xC0;
0CF7   28               .byte 0x28;
0CF8   40               .byte 0x40;
0CF9   50               .byte 0x50;
0CFA   C0               .byte 0xC0;
0CFB   50               .byte 0x50;

                 /*
                  * By default, certain quadrants within the maze *always*
                  * have certain walls present; i.e. any of the outside
                  * quadrants.  This maze contains the default 'wall mask'
                  * values, which are used to seed the array C8B5-C8C3.
                  * That array is then further modified as the interior
                  * walls are added.  The mask values have the following
                  * meaning:
                  *
                  *              ---------------------------------
                  *              | 0 | 0 | 0 | 0 | B | T | R | L |
                  *              ---------------------------------
                  *   Quadrant has Bottom Wall-----^
                  *   Quadrant has Top Wall------------^
                  *   Quadrant has Right Wall--------------^
                  *   Quadrant has Left Wall-------------------^
                  *
                  * The quadrants are defined as follows:
                  *
                  *       ---------------------
                  *       | 0 | 1 | 2 | 3 | 4 |
                  *       ----+---+---+---+----
                  *       | 5 | 6 | 7 | 8 | 9 |
                  *       ----+---+---+---+----
                  *       |10 |11 |12 |13 |14 |
                  *       ---------------------
                  */
                 DefaultMazeWallsPerQuadrant:
0CFC   05               .byte 0x05;   /* left and top walls */
0CFD   04               .byte 0x04;   /* top wall */
0CFE   04               .byte 0x04;   /* top wall */
0CFF   04               .byte 0x04;   /* top wall */
0D00   06               .byte 0x06;   /* top and right walls */
0D01   01               .byte 0x01;   /* left wall */
0D02   00               .byte 0x00;   /* no walls */
0D03   00               .byte 0x00;   /* no walls */
0D04   00               .byte 0x00;   /* no walls */
0D05   02               .byte 0x02;   /* right wall */
0D06   09               .byte 0x09;   /* bottom and left wall */
0D07   08               .byte 0x08;   /* bottom wall */
0D08   08               .byte 0x08;   /* bottom wall */
0D09   08               .byte 0x08;   /* bottom wall */
0D0A   0A               .byte 0x0A;   /* bottom and right walls */

                 PlayerFriedIntensities:
0D0B   08               .byte 0x08;
0D0C   07               .byte 0x07;
0D0D   06               .byte 0x06;
0D0E   05               .byte 0x05;
0D0F   05               .byte 0x05;
0D10   05               .byte 0x05;
0D11   06               .byte 0x06;
0D12   07               .byte 0x07;
0D13   08               .byte 0x08;
0D14   09               .byte 0x09;
0D15   08               .byte 0x08;
0D16   07               .byte 0x07;
0D17   06               .byte 0x06;
0D18   05               .byte 0x05;
0D19   06               .byte 0x06;
0D1A   07               .byte 0x07;

                 /*
                  * CheckForContact()
                  *
                  * This function checks to see if two objects have come
                  * into contact (such as a bullet and a robot, a bullet
                  * and the player, or a robot and the player.  The 2
                  * objects do not need to come into exact contact, but
                  * rather, they only need to come within a prespecified
                  * distance.
                  *
                  * Entry:
                  *   x = ptr to object to which contact is being checked.
                  *   a = y position to check for contact with object.
                  *   b = x position to check for contact with object.
                  *   y = ptr to table telling how close contact must be.
                  *
                  * Exit:
                  *   The carry bit will be set if contact was made.
                  */
                 CheckForContact:
0D1B   A084             suba  ,x;
0D1D   E001             subb  1,x;
0D1F   A1A4             cmpa  ,y;
0D21   2E0F             bgt   P0D32;
0D23   A121             cmpa  1,y;
0D25   2D0B             blt   P0D32;
0D27   E122             cmpb  2,y;
0D29   2E07             bgt   P0D32;
0D2B   E123             cmpb  3,y;
0D2D   2D03             blt   P0D32;
0D2F   1A01             orcc  #0x01;
0D31   39               rts;
0D32   1CFE      P0D32: andcc #0xFE;
0D34   39               rts;

                 /*
                  * The following 3 tables define the bounding box around
                  * some figure (robot, player).  It is used to determine
                  * when something has hit the figure.  Each table contains
                  * the following values:
                  *
                  *     + y delta
                  *     - y delta
                  *     + x delta
                  *     - x delta
                  */
                 RobotContactBounds:
0D35   06               .byte 0x06;
0D36   FA               .byte 0xFA;
0D37   06               .byte 0x06;
0D38   FA               .byte 0xFA;

                 PlayerContactBounds:
0D39   05               .byte 0x05;
0D3A   F7               .byte 0xF7;
0D3B   05               .byte 0x05;
0D3C   FB               .byte 0xFB;

                 PlayerContactBounds2:
0D3D   05               .byte 0x05;
0D3E   FB               .byte 0xFB;
0D3F   05               .byte 0x05;
0D40   FB               .byte 0xFB;

                 /*
                  * This function appears to do some random mucking relating
                  * to sound.
                  */
                 DoUnknownSoundMucking:
0D41   0C77             inc   0x77;
0D43   860E             lda   #0x0E;
0D45   9744             sta   0x44;
0D47   9743             sta   0x43;
0D49   9742             sta   0x42;
0D4B   9667             lda   0x67;
0D4D   8580             bita  #0x80;
0D4F   2703             beq   P0D54;
0D51   7E0DF2           jmp   $P0DF2;
0D54   8508      P0D54: bita  #0x08;
0D56   270A      P0D56: beq   P0D62;
0D58   CC0080           ldd   #0x0080;
0D5B   9777             sta   0x77;
0D5D   D767             stb   0x67;
0D5F   7E0DEB           jmp   $P0DEB;
0D62   8540      P0D62: bita  #0x40;
0D64   2703             beq   P0D69;
0D66   7E0E32           jmp   $P0E32;
0D69   8504      P0D69: bita  #0x04;
0D6B   270A             beq   P0D77;
0D6D   CC0040           ldd   #0x0040;
0D70   9777             sta   0x77;
0D72   D767             stb   0x67;
0D74   7E0E22           jmp   $P0E22;
0D77   8502      P0D77: bita  #0x02;
0D79   270A             beq   P0D85;
0D7B   CC0020           ldd   #0x0020;
0D7E   9777             sta   0x77;
0D80   D767             stb   0x67;
0D82   7E0DB2           jmp   $P0DB2;
0D85   8520      P0D85: bita  #0x20;
0D87   2703             beq   P0D8C;
0D89   7E0DC3           jmp   $P0DC3;
0D8C   8501      P0D8C: bita  #0x01;
0D8E   270A             beq   P0D9A;
0D90   CC0010           ldd   #0x0010;
0D93   9777             sta   0x77;
0D95   D767             stb   0x67;
0D97   7E0E56           jmp   $DoUnknownSoundMucking3;
0D9A   8510      P0D9A: bita  #0x10;
0D9C   2703             beq   P0DA1;
0D9E   7E0E6A           jmp   $DoUnknownSoundMucking4;
0DA1   9676      P0DA1: lda   0x76;
0DA3   8510             bita  #0x10;
0DA5   2703             beq   P0DAA;
0DA7   7E0EAB           jmp   $P0EAB;
0DAA   8501      P0DAA: bita  #0x01;
0DAC   2703             beq   P0DB1;
0DAE   7E0E99           jmp   $P0E99;
0DB1   39        P0DB1: rts;
0DB2   CC0039    P0DB2: ldd   #0x0039;
0DB5   DD4B             std   0x4B;
0DB7   CC0030           ldd   #0x0030;
0DBA   DD49             std   0x49;
0DBC   CC0100           ldd   #0x0100;
0DBF   DD47             std   0x47;
0DC1   2015             bra   P0DD8;
0DC3   DC4B      P0DC3: ldd   0x4B;
0DC5   C30014           addd  #0x0014;
0DC8   DD4B             std   0x4B;
0DCA   DC49             ldd   0x49;
0DCC   C30024           addd  #0x0024;
0DCF   DD49             std   0x49;
0DD1   DC47             ldd   0x47;
0DD3   C30060           addd  #0x0060;
0DD6   DD47             std   0x47;
0DD8   8624      P0DD8: lda   #0x24;
0DDA   9177      P0DDA: cmpa  0x77;
0DDC   2304             bls   P0DE2;
0DDE   8638             lda   #0x38;
0DE0   2006             bra   P0DE8;
0DE2   863F      P0DE2: lda   #0x3F;
0DE4   0F67             clr   0x67;
0DE6   0F76             clr   0x76;
0DE8   9745      P0DE8: sta   0x45;
0DEA   39               rts;
0DEB   CC00C0    P0DEB: ldd   #0x00C0;
0DEE   DD4B             std   0x4B;
0DF0   0F6A             clr   0x6A;
0DF2   9677      P0DF2: lda   0x77;
0DF4   8501             bita  #0x01;
0DF6   2707             beq   P0DFF;
0DF8   DC4B             ldd   0x4B;
0DFA   C30010           addd  #0x0010;
0DFD   2005             bra   P0E04;
0DFF   DC4B      P0DFF: ldd   0x4B;
0E01   830013           subd  #0x0013;
0E04   DD4B      P0E04: std   0x4B;
0E06   D66A             ldb   0x6A;
0E08   5C               incb;
0E09   C108             cmpb  #0x08;
0E0B   2302             bls   P0E0F;
0E0D   C606             ldb   #0x06;
0E0F   D76A      P0E0F: stb   0x6A;
0E11   8650             lda   #0x50;
0E13   3D               mul;
0E14   DD49             std   0x49;
0E16   D66A             ldb   0x6A;
0E18   8631             lda   #0x31;
0E1A   3D               mul;
0E1B   DD47             std   0x47;
0E1D   862C             lda   #0x2C;
0E1F   7E0DDA           jmp   $P0DDA;
0E22   CC0030    P0E22: ldd   #0x0030;
0E25   DD4B             std   0x4B;
0E27   CC0000           ldd   #0x0000;
0E2A   DD49             std   0x49;
0E2C   CC0120           ldd   #0x0120;
0E2F   DD47             std   0x47;
0E31   39               rts;
0E32   8EC84B    P0E32: ldx   #0xC84B;
0E35   8D0A             bsr   DoUnknownSoundMucking2;
0E37   8EC849           ldx   #0xC849;
0E3A   8D05             bsr   DoUnknownSoundMucking2;
0E3C   8618             lda   #0x18;
0E3E   7E0DDA           jmp   $P0DDA;

                 /*
                  * This function appears to do some random mucking relating
                  * to sound.
                  */
                 DoUnknownSoundMucking2:
0E41   9677             lda   0x77;
0E43   8501             bita  #0x01;
0E45   2707             beq   P0E4E;
0E47   EC84             ldd   ,x;
0E49   C30023           addd  #0x0023;
0E4C   2005             bra   P0E53;
0E4E   EC84      P0E4E: ldd   ,x;
0E50   830010           subd  #0x0010;
0E53   ED84      P0E53: std   ,x;
0E55   39               rts;

                 /*
                  * This function appears to do some random mucking relating
                  * to sound.
                  */
                 DoUnknownSoundMucking3:
0E56   8603             lda   #0x03;
0E58   976A             sta   0x6A;
0E5A   CC0039           ldd   #0x0039;
0E5D   DD4B             std   0x4B;
0E5F   CC0030           ldd   #0x0030;
0E62   DD49             std   0x49;
0E64   CC0040           ldd   #0x0040;
0E67   DD47             std   0x47;
0E69   39               rts;

                 /*
                  * This function appears to do some random mucking relating
                  * to sound.
                  */
                 DoUnknownSoundMucking4:
0E6A   966A             lda   0x6A;
0E6C   2B11             bmi   P0E7F;
0E6E   D677             ldb   0x77;
0E70   C104             cmpb  #0x04;
0E72   230B             bls   P0E7F;
0E74   0F77             clr   0x77;
0E76   0A6A             dec   0x6A;
0E78   CC0039           ldd   #0x0039;
0E7B   DD4B             std   0x4B;
0E7D   2007             bra   P0E86;
0E7F   DC4B      P0E7F: ldd   0x4B;
0E81   C3001A           addd  #0x001A;
0E84   DD4B             std   0x4B;
0E86   DC49      P0E86: ldd   0x49;
0E88   C30024           addd  #0x0024;
0E8B   DD49             std   0x49;
0E8D   DC47             ldd   0x47;
0E8F   C30024           addd  #0x0024;
0E92   DD47             std   0x47;
0E94   861C             lda   #0x1C;
0E96   7E0DDA           jmp   $P0DDA;
0E99   8610      P0E99: lda   #0x10;
0E9B   0F67             clr   0x67;
0E9D   0F77             clr   0x77;
0E9F   9776             sta   0x76;
0EA1   CC0000           ldd   #0x0000;
0EA4   DD47             std   0x47;
0EA6   CC0300           ldd   #0x0300;
0EA9   DD4B             std   0x4B;
0EAB   9677      P0EAB: lda   0x77;
0EAD   8106             cmpa  #0x06;
0EAF   230B             bls   P0EBC;
0EB1   810C             cmpa  #0x0C;
0EB3   2207             bhi   P0EBC;
0EB5   DC4B             ldd   0x4B;
0EB7   830040           subd  #0x0040;
0EBA   DD4B             std   0x4B;
0EBC   DC4B      P0EBC: ldd   0x4B;
0EBE   44               lsra;
0EBF   56               rorb;
0EC0   DD49             std   0x49;
0EC2   8618             lda   #0x18;
0EC4   7E0DDA           jmp   $P0DDA;

                 /*
                  * CheckForQuadrantEdgeCrossing()
                  *
                  * This function determines whether an object has crossed
                  * over the edge of a quadrant; this helps to determine
                  * when a player runs into a wall, or exits through an
                  * open door.  It returns a mask, which indicates which
                  * edge (or edges) have been crossed.
                  *
                  * Entry:
                  *   d = a point in the quadrant, relative to the lower left
                  *       corner of the quadrant.
                  *   x = pointer to a table of boundary conditions, which
                  *       tell how close the point must be to the actual
                  *       edge, to consider an edge crossing as having
                  *       occurred (these offsets are relative to the lower
                  *       left corner of the quadrant).  The values in this
                  *       table are:
                  *
                  *             yLeft, yRight, xLeft, xRight
                  *
                  * Exit:
                  *   b = mask (having the following meaning):
                  *
                  *         ---------------------------------
                  *         | 0 | 0 | 0 | 0 | B | T | R | L |
                  *         ---------------------------------
                  *
                  *   Bottom Edge Crossing----^
                  *   Top Edge Crossing-----------^
                  *   Right Edge Crossing-------------^
                  *   Left Edge Crossing------------------^
                  */
                 CheckForQuadrantEdgeCrossing:
0EC7   5F               clrb;
0EC8   A184             cmpa  ,x;
0ECA   2C04             bge   P0ED0;
0ECC   CA08             orb   #0x08;
0ECE   2006             bra   P0ED6;
0ED0   A101      P0ED0: cmpa  1,x;
0ED2   2F02             ble   P0ED6;
0ED4   CA04             orb   #0x04;
0ED6   969C      P0ED6: lda   0x9C;
0ED8   A102             cmpa  2,x;
0EDA   2F03             ble   P0EDF;
0EDC   CA02             orb   #0x02;
0EDE   39               rts;
0EDF   A103      P0EDF: cmpa  3,x;
0EE1   2C02             bge   P0EE5;
0EE3   CA01             orb   #0x01;
0EE5   39        P0EE5: rts;


                 /*
                  * The following are all threshold tables, used when
                  * calling CheckForQuadrantEdgeContact(); a different
                  * table is used, depending upon what object is represented
                  * by the point (a robot, the player, a bullet, etc).
                  * Quadrants are all 40 wide x 64 high.
                  * Each of the tables is composed of the following values:
                  *
                  *     y left threshold
                  *     y right threshold
                  *     x left threshold
                  *     x right threshold
                  */
                 RobotThresholds:
0EE6   08               .byte 0x08;
0EE7   38               .byte 0x38;
0EE8   20               .byte 0x20;
0EE9   08               .byte 0x08;

                 PlayerThresholds:
0EEA   0A               .byte 0x0A;
0EEB   3C               .byte 0x3C;
0EEC   24               .byte 0x24;
0EED   04               .byte 0x04;

                 BulletThresholds:
0EEE   04               .byte 0x04;
0EEF   3C               .byte 0x3C;
0EF0   24               .byte 0x24;
0EF1   04               .byte 0x04;

                 BulletToWallThresholds:
0EF2   01               .byte 0x01;
0EF3   3F               .byte 0x3F;
0EF4   27               .byte 0x27;
0EF5   01               .byte 0x01;

                 /*
                  * DetermineMazeWalls()
                  *
                  * This function calculates the 8 walls (and the optional
                  * door) which are present in a maze.  The maze has 8
                  * internal points from which a wall can start, and fromright
                  * each point, the wall can go either upwards, downwards,
                  * to the right or to the left.  The array at C8AB will be
                  * filled with an integer index telling which walls are to
                  * be drawn (0=up, 2=down, 4=to right, 6=to left).  The
                  * array at C8B5 is a collection of bitmasks, indicating
                  * which walls are present for each quadrant (there is one
                  * entry in the array per quadrant).  The mask has the
                  * following format:
                  *
                  *              ---------------------------------
                  *              | 0 | 0 | 0 | 0 | B | T | R | L |
                  *              ---------------------------------
                  *   Quadrant has Bottom Wall-----^
                  *   Quadrant has Top Wall------------^
                  *   Quadrant has Right Wall--------------^
                  *   Quadrant has Left Wall-------------------^
                  */
                 DetermineMazeWalls:
0EF6   860F             lda   #0x0F;
0EF8   CE0CFC           ldu   #DefaultMazeWallsPerQuadrant;
0EFB   8EC8B5           ldx   #0xC8B5;
0EFE   3184             leay  ,x;
0F00   BDF683           jsr   $move_block2;
0F03   30A4             leax  ,y;
0F05   C608             ldb   #0x08;
0F07   D79F             stb   0x9F;
0F09   CEC8AB           ldu   #0xC8AB;
0F0C   BDF517    P0F0C: jsr   $get_random_a;
0F0F   8403             anda  #0x03;
0F11   8103             cmpa  #0x03;
0F13   2D0E             blt   P0F23;
0F15   E684             ldb   ,x;       /* Draw to the left from point */
0F17   CA08             orb   #0x08;    /* This quad has a bottom wall, and */
0F19   E784             stb   ,x;
0F1B   E605             ldb   5,x;
0F1D   CA04             orb   #0x04;    /* the quad below it has a top wall */
0F1F   E705             stb   5,x;
0F21   2030             bra   P0F53;
0F23   8102      P0F23: cmpa  #0x02;
0F25   2D0E             blt   P0F35;
0F27   E601             ldb   1,x;     /* Draw to the right from point */
0F29   CA08             orb   #0x08;   /* Next quad has a bottom wall, and */
0F2B   E701             stb   1,x;
0F2D   E606             ldb   6,x;
0F2F   CA04             orb   #0x04;   /* Quad below it has a top wall */
0F31   E706             stb   6,x;
0F33   201E             bra   P0F53;
0F35   8101      P0F35: cmpa  #0x01;
0F37   2D0E             blt   P0F47;
0F39   E605             ldb   5,x;     /* Draw downwards from point */
0F3B   CA02             orb   #0x02;   /* Quad below has a right wall, and */
0F3D   E705             stb   5,x;
0F3F   E606             ldb   6,x;
0F41   CA01             orb   #0x01;   /* quad next to it has a left wall */
0F43   E706             stb   6,x;
0F45   200C             bra   P0F53;
0F47   E684      P0F47: ldb   ,x;      /* Draw upwards from point */
0F49   CA02             orb   #0x02;   /* This quad has a right wall, and */
0F4B   E784             stb   ,x;
0F4D   E601             ldb   1,x;
0F4F   CA01             orb   #0x01;   /* quad next to it has a left wall */
0F51   E701             stb   1,x;
0F53   48        P0F53: asla;
0F54   A7C0             sta   ,u+;     /* Save the wall index */
0F56   C605             ldb   #0x05;
0F58   D19F             cmpb  0x9F;
0F5A   2602             bne   P0F5E;
0F5C   3001             leax  1,x;
0F5E   3001      P0F5E: leax  1,x;
0F60   0A9F             dec   0x9F;
0F62   26A8             bne   P0F0C;
0F64   39               rts;

                 /*
                  * DetermineDirectionToMove()
                  *
                  * This function takes a point, and returns a mask
                  * indicating the direction the point must travel, in
                  * in order to reach the player.  It also returns the
                  * distance (rise and run) describing how far away the
                  * point is from the player.
                  *
                  * Entry:
                  *   a = y position
                  *   b = x position
                  *
                  * Exit:
                  *   C8DE: y distance between point and player.
                  *   C8DF: x distance between point and player.
                  *   b = mask, indicating desired direction of travel
                  *
                  *              ---------------------------------
                  *              | 0 | 0 | x | 0 | x | x | x | x |
                  *              ---------------------------------
                  *   x and/or y is same --^
                  *   Down ------------------------^
                  *   Up ------------------------------^
                  *   Right -------------------------------^
                  *   Left ------------------------------------^
                  */
                 DetermineDirectionToMove:
0F65   8B80             adda  #0x80;
0F67   CB80             addb  #0x80;
0F69   DDE7             std   0xE7;
0F6B   968F             lda   0x8F;
0F6D   8B80             adda  #0x80;
0F6F   5F               clrb;
0F70   90E7             suba  0xE7;
0F72   2706             beq   P0F7A;
0F74   2508             blo   P0F7E;
0F76   CA04             orb   #0x04;
0F78   2006             bra   P0F80;
0F7A   CA20      P0F7A: orb   #0x20;
0F7C   2002             bra   P0F80;
0F7E   CA08      P0F7E: orb   #0x08;
0F80   40        P0F80: nega;
0F81   97DE             sta   0xDE;
0F83   9690             lda   0x90;
0F85   8B80             adda  #0x80;
0F87   90E8             suba  0xE8;
0F89   97DF             sta   0xDF;
0F8B   2705             beq   P0F92;
0F8D   2506             blo   P0F95;
0F8F   CA02             orb   #0x02;
0F91   39               rts;
0F92   CA20      P0F92: orb   #0x20;
0F94   39               rts;
0F95   CA01      P0F95: orb   #0x01;
0F97   39               rts;


                 /*
                  * MapPointToQuadrantAndMakeRelative()
                  *
                  * This function takes a point, and determines which of
                  * 15 quadrants it falls into.  It also maps the point
                  * so that it is relative to the lower left corner of the
                  * quadrant, and returns the bitmask indicating which walls
                  * are defined for this quadrant.
                  *
                  * Entry:
                  *   d = (y,x) position
                  *
                  * Exit:
                  *   C89A = quadrant (0 - 15)
                  *   C899 = wall bitmask
                  *   C89B-C89C = point, relative to lower left quad corner
                  *   d = point, relative to lower left quad corner
                  *
                  * where the bitmask has the following format:
                  *
                  *              ---------------------------------
                  *              | 0 | 0 | 0 | 0 | B | T | R | L |
                  *              ---------------------------------
                  *   Quadrant has Bottom Wall-----^
                  *   Quadrant has Top Wall------------^
                  *   Quadrant has Right Wall--------------^
                  *   Quadrant has Left Wall-------------------^
                  *
                  * and the quadrants are defined as follows:
                  *
                  *     -100 -60 -20 +20 +60 +100
                  *       --------------------- +96
                  *       | 0 | 1 | 2 | 3 | 4 |
                  *       ----+---+---+---+---- +32
                  *       | 5 | 6 | 7 | 8 | 9 |
                  *       ----+---+---+---+---- -32
                  *       |10 |11 |12 |13 |14 |
                  *       --------------------- -96
                  */
                 MapPointToQuadrantAndMakeRelative:
0F98   DD9B             std   0x9B;
0F9A   5F               clrb;
0F9B   81E0             cmpa  #0xE0;  /* -32 */
0F9D   2E04             bgt   P0FA3;
0F9F   CB0A             addb  #0x0A;
0FA1   2006             bra   P0FA9;
0FA3   8120      P0FA3: cmpa  #0x20;  /* 32 */
0FA5   2E02             bgt   P0FA9;
0FA7   CB05             addb  #0x05;
0FA9   969C      P0FA9: lda   0x9C;
0FAB   81C4             cmpa  #0xC4;  /* -60 */
0FAD   2F10             ble   P0FBF;
0FAF   5C               incb;
0FB0   81EC             cmpa  #0xEC;  /* -20 */
0FB2   2F0B             ble   P0FBF;
0FB4   5C               incb;
0FB5   8114             cmpa  #0x14;  /* 20 */
0FB7   2F06             ble   P0FBF;
0FB9   5C               incb;
0FBA   813C             cmpa  #0x3C;  /* 60 */
0FBC   2F01             ble   P0FBF;
0FBE   5C               incb;
0FBF   D79A      P0FBF: stb   0x9A;      /* Save the quadrant number */
0FC1   8EC8B5           ldx   #0xC8B5;
0FC4   A685             lda   b,x;
0FC6   9799             sta   0x99;      /* Save the wall bitmask */
0FC8   8E0FD3           ldx   #RelativeOffsetConversionTable;
0FCB   58               aslb;
0FCC   EC85             ldd   b,x;
0FCE   D39B             addd  0x9B;
0FD0   DD9B             std   0x9B;      /* Make into a relative point */
0FD2   39               rts;

                 RelativeOffsetConversionTable:
0FD3   E0               .byte 0xE0;  /* Quad 0 y */
0FD4   64               .byte 0x64;  /* Quad 0 x */
0FD5   E0               .byte 0xE0;  /* Quad 1 y */
0FD6   3C               .byte 0x3C;  /* Quad 1 x */
0FD7   E0               .byte 0xE0;  /* Quad 2 y */
0FD8   14               .byte 0x14;  /* Quad 2 x */
0FD9   E0               .byte 0xE0;  /* Quad 3 y */
0FDA   EC               .byte 0xEC;  /* Quad 3 x */
0FDB   E0               .byte 0xE0;  /* Quad 4 y */
0FDC   C4               .byte 0xC4;  /* Quad 4 x */
0FDD   20               .byte 0x20;  /* Quad 5 y */
0FDE   64               .byte 0x64;  /* Quad 5 x */
0FDF   20               .byte 0x20;  /* Quad 6 y */
0FE0   3C               .byte 0x3C;  /* Quad 6 x */
0FE1   20               .byte 0x20;  /* Quad 7 y */
0FE2   14               .byte 0x14;  /* Quad 7 x */
0FE3   20               .byte 0x20;  /* Quad 8 y */
0FE4   EC               .byte 0xEC;  /* Quad 8 x */
0FE5   20               .byte 0x20;  /* Quad 9 y */
0FE6   C4               .byte 0xC4;  /* Quad 9 x */
0FE7   60               .byte 0x60;  /* Quad 10 y */
0FE8   64               .byte 0x64;  /* Quad 10 x */
0FE9   60               .byte 0x60;  /* Quad 11 y */
0FEA   3C               .byte 0x3C;  /* Quad 11 x */
0FEB   60               .byte 0x60;  /* Quad 12 y */
0FEC   14               .byte 0x14;  /* Quad 12 x */
0FED   60               .byte 0x60;  /* Quad 13 y */
0FEE   EC               .byte 0xEC;  /* Quad 13 x */
0FEF   60               .byte 0x60;  /* Quad 14 y */
0FF0   C4               .byte 0xC4;  /* Quad 14 x */

                /* These appear to be unused bytes */
0FF1   01               .byte 0x01;
0FF2   6C               .byte 0x6C;
0FF3   DD               .byte 0xDD;
0FF4   74               .byte 0x74;
0FF5   DD               .byte 0xDD;
0FF6   47               .byte 0x47;
0FF7   96               .byte 0x96;
0FF8   67               .byte 0x67;
0FF9   84               .byte 0x84;
0FFA   03               .byte 0x03;
0FFB   97               .byte 0x97;
0FFC   68               .byte 0x68;
0FFD   0F               .byte 0x0F;
0FFE   67               .byte 0x67;
0FFF   39               .byte 0x39;

