/*
 * This work was originally done by Fred Taft (fred@.cv.hp.com).
 * Please forward any comments, corrections or additions back to Fred.
 *
 * Note that the work here is incomplete, especially in the area of the
 * headset control and the sound code.  If you can decipher this code further,
 * please repost it, so that the rest of us can benefit from your knowledge.
 *
 * Narrow Escape
 *
 ******************************************************************************
 *
 * OVERVIEW:
 * ---------
 *
 * Unlike all previous games, which simply drew lines in any order, and
 * incorporated color using an overlay, Narrow Escape was one of the first
 * games to use the headset and a color wheel to give the impression that
 * red, green or blue lines were simultaneously being drawn, without the
 * use of an overlay.  In a nutshell, the color wheel is designed such
 * that only one eye sees what is being drawn at any given time.  For
 * the viewing eye, the color wheel is partitioned into a red, a green and
 * a blue section.  When the red section is in front of the player's eye,
 * the Vectrex will draw the red vectors for the given eye; when the green
 * section comes in front of the eye, the game will then draw the green
 * vectors for that eye.  If a color requires a large number of vectors to
 * be drawn, then that color will occupy a greater portion of the color wheel.
 * The order in which things are drawn are:
 *
 *              1) Right eye blue.
 *              2) Right eye green.
 *              3) Right eye red.
 *              4) Left eye blue.
 *              5) Left eye green.
 *              6) Left eye red.
 *
 * The main drawing function determines when to start drawing a particular
 * color, by comparing the refresh timer value against a table of known
 * values; since they known (ideally) how long it should take for a segment
 * of the color wheel to become visible, they can use hardcoded values.
 *
 * To accomplish the drawing described above, this game implements the
 * concept of 'frames'.  This games uses approximately 10 of these frames.
 * Each frame contains all of the information needed to draw a given item;
 * i.e. a string, or part of a figure.  Some frames have dedicated uses,
 * while others may be used for different things, depending upon the state
 * of the game; i.e. the frame used to contain the vector list for the
 * Warship side fins is not used for anything else; however, the frame
 * used to display the first bullet fired by the player, is also used at
 * times to display the player's ship count, or the "Game Over" string.
 *
 * During a particular pass, the game will, for instance, ask for the next
 * red frame; if one if found, then its contents are drawn; if one is not
 * found, then it will wait to move onto the next color or next eye.
 *
 * HEADSET CONTROL:
 * ----------------
 *
 * I put a lot of effort into trying to decipher the code which controls
 * the headset.  In some areas I succeeded in figuring out what was happening,
 * but in others, I failed.  I do know that it uses a PID algorithm
 * (Proportional/Integral/Differential) for controlling the velocity of
 * the color wheel.  It appears to take a collection of samplings, to
 * determine if the wheel is spinning too fast or too slow, and based upon
 * this collection of samplings, and the previous 3 samplings, adjusts the
 * rate at which the colorwheel spins.
 *
 ******************************************************************************
 *
 * The following the the memory map for Narrow Escape RAM usage:
 *
 * C875-C876    Pointer to the next player frame.
 *
 * C880         Tolerance value; used during collision detection.  If the
 *              distance between two objects is within the tolerance range,
 *              then they are considered to have collided.
 *
 * C881         Boolean: flags if bonus has been given for score > 20000.
 *
 * C882         Unknown usage contains some info about enemy ship.
 *
 * C883         Number of fuel cannisters (and walls) for current level.
 *
 * C884         Unknown use: set to 4, if level <= 5, else set to 5.
 *
 * C885         Number of enemy ships for current level.
 *
 * C886-C887    BCD value associated with current enemy ship.
 *
 * C888         Boolean: indicates if player destroyed an enemy.
 *
 * C889         Boolean: indicates whether an enemy start is visible; 0 = no,
 *              0xFF = yes.
 *
 * C88A-C88B    Pointer to enemy ship vector list.
 *
 * C88C         Indicates the number of hits needed to destroy the warlord ship.
 *
 * C88D-C88E    16-bit x movement delta for enemy ship.
 *
 * C88F-C890    16-bit y movement delta for enemy ship.
 *
 * C891         Work memory.
 *
 * C892         Work memory.
 *
 * C893-C894    Work memory.
 *
 * C895-C896    Unused.
 *
 * C897         Loop counter.
 *
 * C898-C89A    Unused.
 *
 * C89B         Bitmask: appears to indicate which sounds should be made:
 *
 *                      0x01 = Normal game noise
 *                      0x02 = Enemy ship coming
 *                      0x08 = Player passed through fuel wall opening
 *                      0x10 = Player picked up fuel
 *                      0x20 = Player fired a bullet
 *                      0x40 = Player out of fuel
 *                      0x80 = Enemy ship hit or player hit fuel wall.
 *
 * C89C         Used somehow by the sound functions.
 *
 * C89D         Used somehow by the sound functions.
 *
 * C89E         Used somehow by the sound functions.
 *
 * C89F         Bitmask: appears to indicate which sounds are currently
 *              allowed; assumes same meaning as C89B.
 *
 * C8A0         Used somehow by the sound functions.
 *
 * C8A1         Used somehow by the sound functions.
 *
 * C8A2         Controls sound characteristics (0,1).
 *
 * C8A3         Used somehow by the sound functions.
 *
 * C8A4         Unknown usage contains some info about enemy ship.
 *
 * C8A5         Boolean: appears to also indicate if player has collided with
 *              the enemy ship (see C8BA).
 *
 * C8A6         Boolean: flags whether we are drawing for the left eye (0xFF)
 *              or the right eye (0x00).
 *
 * C8A7-C8AA    Unused.
 *
 * C8AB-C8AC    Indirect jump pointer; indicates main processing function.
 *
 * C8AD-C8AE    Counter.
 *
 * C8AF         Boolean: indicates whether the passage walls should be
 *              drawn (0xFF).  When player first enters a new level, the
 *              walls are not initially drawn.
 *
 * C8B0         Boolean: indicates if player picked up fuel cannister (0xFF).
 *
 * C8B1         During normal play, indicates the number of enemy ships
 *              destroyed.  During battle with the warlord ship, indicates
 *              the number of hits on the warlord ship.
 *
 * C8B2         Boolean: indicates that player has completed the current
 *              level (0xFF).  Used both for enemy levels, and fuel levels.
 *
 * C8B3         Unused.
 *
 * C8B4         Number of fuel components (walls and cannisters) created
 *              so far.
 *
 * C8B5         Boolean: controls whether a fuel wall (0x00) or a fuel
 *              cannister (0xFF) is drawn next.
 *
 * C8B6         Index in range 0-2; used during drawing of fuel walls and
 *              cannisters to index into an array which specifies the color
 *              used when drawing the fuel component.
 *
 * C8B7-C8B8    Alternate scale factor; used during drawing of when some
 *              objects are exploding.
 *
 * C8B9         Boolean: indicates if the player's ship is done
 *              exploding (0xFF).
 *
 * C8BA         Boolean: flags if enemy ship and player have collided;
 *              0x00= no collision, 0xFF = collision.
 *
 * C8BB         Velocity of enemy star; used to update 'y' value.
 *
 * C8BC         Boolean: flags if enemy star and player have collided;
 *              0x00= no collision, 0xFF = collision.
 *
 * C8BD         Current level (0-?).  Also used to calculate the number of
 *              enemy ships for the level (level + 6), and the number of
 *              fuel cannisters ((level * 2) + 5).  Also used to control
 *              which enemy ship is used for this level.
 *
 * C8BE-C8C5    String Buffer: Ship count. Default = "SHIPS 3",0x80.
 *
 * C8C6-C8CC    String Buffer: Player's score. Default = "     0",0x80.
 *
 * C8CD         Unused.
 *
 * C8CE         Unknown usage.
 *
 * C8CF-C8D0    Unused.
 *
 * C8D1-C8D2    Unknown usage.
 *
 * C8D3         Unused.
 *
 * C8D4         Unknown usage.
 *
 * C8D5-C8D6    Unused.
 *
 * C8D7-C8F8    34 byte Frame buffer; see note 1 below.
 *
 *              Player's ship.
 *
 * C8F9-C91A    34 byte Frame buffer; see note 1 below.
 *
 *              Players first bullet.
 *              "Game Over" string (after game ends).
 *              Player's ship count.
 *
 * C91B-C93C    34 byte Frame buffer; see note 1 below.
 *
 *              Players second bullet.
 *              Player's last score (after game ends, or between levels).
 *
 * C93D-C95E    34 byte Frame buffer; see note 1 below.
 *
 *              Players third bullet.
 *
 * C95F-C980    34 byte Frame buffer; see note 1 below.
 *
 *              Enemy star.
 *              Warlord ship's bullet.
 *
 * C981-C9A2    34 byte Frame buffer; see note 1 below.
 *
 *              Enemy ship.
 *              Warlord ship's target area.
 *              Player's ship count
 *
 * C9A3-C9C4    34 byte Frame buffer; see note 1 below.
 *
 *              Warlord ship's body.
 *              Player's score.
 *
 * C9C5-C9E6    34 byte Frame buffer; see note 1 below.
 *
 *              Warlord ship's body.
 *
 * C9E7-CA08    34 byte Frame buffer; see note 1 below.
 *
 *              Warlord ship's top and bottom fins.
 *
 * CA09-CA2A    34 byte Frame buffer; see note 1 below.
 *
 *              Warlord ship's side fins.
 *
 * CA2B-CA32    8  byte end-of-frame stack indicator.
 *
 * CA33-CA74    Unused.
 *
 * CA75-CA76    Frame Pointer: points to the next drawing frame to be processed.
 *
 * CA77         Number of units of fuel the player has; also used as the
 *              scale factor when drawing the fuel bar.
 *
 * CA78-CA79    Unused.
 *
 * CA7A         Indicates the number of fuel units consumed per pass through
 *              the game's main loop.
 *
 * CA7B-CA7C    Unused.
 *
 * CA7D         Boolean: indicates if the user is completely out of fuel (0xFF).
 *
 * CA7E         Boolean: flags that the player is low on fuel (0xFF).
 *
 * CA7F         Boolean: indicates if goggle sync has been received.
 *
 * CA80         Unused.
 *
 * CA81         Scale factor used by some of the drawing functions.
 *
 * CA82         Loop counter used during some drawing.
 *
 * CA83         Scale factor used by some drawing functions.
 *
 * CA84-CA85    Unused.
 *
 * CA86         Number of times the IRQ happed *after* the refresh timer
 *              elapsed for this set of 8 samplings.
 *
 * CA87         Number of times the IRQ happed *after* the refresh timer
 *              elapsed for (pass-1) set of 8 samplings.
 *
 * CA88         Number of times the IRQ happed *after* the refresh timer
 *              elapsed for (pass-2) set of 8 samplings.
 *
 * CA89         Number of times the IRQ happed *after* the refresh timer
 *              elapsed for (pass-3) set of 8 samplings.
 *
 * CA8A         Loop counter used by IRQ handler; starts at 8, and decrements
 *              each time IRQ triggers.  Main portion of IRQ code only
 *              executes when this decrements to 0.  Allows a group of
 *              'samplings' to be taken, before attempting to modify the
 *              velocity of the headset.
 *
 * CA8B         Assigned a value, but never reference.
 *
 * CA8C         Used by IRQ handler to adjust headset velocity.
 *
 * CA8D         Used by IRQ handler to adjust headset velocity.
 *
 * CA8E         Used by IRQ handler.
 *
 * CA90-????    Buffer used by sound routines.
 *
 ******************************************************************************
 *
 * NOTES:
 * ------
 *
 * Note 1:      Frame Structure
 *
 *                 ----------------
 *              0  | Initial y drawing position
 *                 -
 *              1  | Initial x drawing position
 *                 ----------------
 *              2  | Unknown
 *                 ----------------
 *              3  | Scale Factor used when moving to above position,
 *                 -
 *              4  | and for during some drawing.
 *                 ----------------
 *              5  | Scale Factor used for some drawing, such as embedded
 *                 -
 *              6  | objects (fuel cells and fuel wall openings)
 *                 ----------------
 *              7  | Frame identifier (See Note 2)
 *                 ----------------
 *              8  | Intensity
 *                 ----------------
 *              9  | Vector table or vector list or string address
 *                 -
 *              A  | for the left eye
 *                 ----------------
 *              B  | Vector table vector list or string address
 *                 -
 *              C  | for the right eye
 *                 ----------------
 *              D  | 16-bit X position,
 *                 -
 *              E  | for enemy ship
 *                 ----------------
 *              F  | 16-bit Y position,
 *                 -
 *              10 | for enemy ship
 *                 ----------------
 *              11 | 16-bit X movement delta,
 *                 -
 *              12 | for enemy ship
 *                 ----------------
 *              13 | 16-bit Y movement delta,
 *                 -
 *              14 | for enemy ship
 *                 ----------------
 *              15 | X bounding box min
 *                 ----------------
 *              16 | X bounding box max
 *                 ----------------
 *              17 | Y bounding box min
 *                 ----------------
 *              18 | Y bounding box max
 *                 ----------------
 *              19 | Unused
 *                 ----------------
 *              1A | Unused
 *                 ----------------
 *              1B | Player State (See Note 3)
 *                 ----------------
 *              1C | Embedded object (y,x) location; used for fuel
 *                 -
 *              1D | wall openings and fuel cells.
 *                 ----------------
 *              1E | Explosion happening flag (0xFF = explosion)
 *                 ----------------
 *              1F | Explosion duration counter
 *                 ----------------
 *              20 | Pointer to the drawing function
 *                 -
 *              21 | associated with this frame object
 *                 ----------------
 *
 * Note 2:      Frame Identifier
 *
 *              Each frame has an identifier, which indicates what color
 *              it should be drawn with, and whether or not it is still
 *              visible.
 *
 *                      0x01 = Blue
 *                      0x02 = Green
 *                      0x03 = Red
 *                      0xFF = End of frame stack
 *                      or'ed with 0x10 = Frame not visible
 *
 * Note 3:      Player State
 *
 *              0x00 = Player is in the enemy passage.
 *              0xFF = Player is in the fuel passage.
 *
 ******************************************************************************
 */

                        .org 0x0000;
0000   67               .string "g GCE 1983",0x80;

000B   FD0D             .word #intro_music_block;

000F   10               .byte 0xF8; /* height */
0010   E0               .byte 0x40; /* width */
000F   10               .byte 0x10; /* rel y */
0010   E0               .byte 0xE0; /* rel x */
0011   4E               .string "NARROW",0x80;
0018   F8               .byte 0xF8; /* height */
0019   40               .byte 0x40; /* width */
001A   00               .byte 0x00; /* rel y */
001B   E0               .byte 0xE0; /* rel y */
001C   45               .string "ESCAPE",0x80,0x00;

0024   BDF18B    start: jsr   $reinit;
0027   BDF533           jsr   $init_music_buf;
002A   BDF289           jsr   $do_sound;
002D   8610             lda   #0x10;
002F   B7C81A           sta   $C81A;    /* Set joystick approximation factor */
0032   7FC821           clr   $C821;    /* Disable console 2 joysticks */
0035   7FC822           clr   $C822;    /* Disable console 2 joysticks */
0038   8E0C0E           ldx   #StartupNewGame;
003B   BFC8AB           stx   $C8AB;    /* Set the indirect jump ptr */
003E   7FC89B           clr   $C89B;    /* Clear sound bitmask */
0041   7FC89F           clr   $C89F;
0044   8601             lda   #0x01;
0046   B7C8A2           sta   $C8A2;    /* Set sound characteristics index */
0049   CC00E0           ldd   #0x00E0;
004C   FDC83D           std   $C83D;    /* Set refresh timer = 0.0382 sec */
004F   F7CA8E           stb   $CA8E;
0052   CC0008           ldd   #0x0008;
0055   FDCA86           std   $CA86;
0058   F7CA8A           stb   $CA8A;    /* Init IRQ handler's loop counter */
005B   7FCA8C           clr   $CA8C;
005E   7FCA8D           clr   $CA8D;
0061   CC7E82           ldd   #0x7E82;
0064   B7CBF8           sta   $CBF8;    /* Set up IRQ interrupt vector: JMP */
0067   D70E             stb   0x0E;
0069   CC0271           ldd   #IRQ_Handler;
006C   FDCBF9           std   $CBF9;    /* Set IRQ interrupt function: Sync */
006F   86CD             lda   #0xCD;    /* Force goggle index to trigger off */
0071   970C             sta   0x0C;     /* positive edge. */
0073   7FC891           clr   $C891;    /* Set loop counter = 0 */

                 /* Wait for the goggle's disk to come upto speed */
0076   FCC83D    P0076: ldd   $C83D;
0079   DD08             std   0x08;     /* Set refresh timer */
007B   F6C845           ldb   $C845;    /* Get current I/O enable setting */
007E   C4BF             andb  #0xBF;
0080   8607      P0080: lda   #0x07;
0082   BDF25B           jsr   $PF25B;   /* Config Port A as an input */
0085   8D49             bsr   GetGoggleIndexState;
0087   B7CA7F           sta   $CA7F;
008A   F6C845    P008A: ldb   $C845;    /* Get current I/O enable setting */
008D   CA40             orb   #0x40;
008F   8607             lda   #0x07;
0091   BDF25B           jsr   $PF25B;   /* Config Port A as an output */
0094   CC0E80           ldd   #0x0E80;  /* Write 0x80 to Port A */
0097   BDF256           jsr   $byte_2_sound_chip;
009A   C660             ldb   #0x60;    /* Set timing loop value */
009C   5A        P009C: decb;
009D   26FD             bne   P009C;    /* Delay for awhile */
009F   CC0EFF           ldd   #0x0EFF;  /* Write 0xFF to Port A */
00A2   BDF256           jsr   $byte_2_sound_chip;
00A5   F6C845           ldb   $C845;
00A8   C4BF             andb  #0xBF;
00AA   8607             lda   #0x07;
00AC   BDF25B           jsr   $PF25B;   /* Set Port A as an input */
00AF   8D1F             bsr   GetGoggleIndexState;
00B1   7DCA7F           tst   $CA7F;    /* See if the goggle's sync line */
00B4   2603             bne   P00B9;    /* has gone from off to on. */
00B6   4D               tsta;
00B7   2605             bne   P00BE;    /* Sync line changed */
00B9   B7CA7F    P00B9: sta   $CA7F;
00BC   20CC             bra   P008A;
00BE   960D      P00BE: lda   0x0D;     /* If the refresh timer elapsed, then */
00C0   8520             bita  #0x20;    /* the goggle disk is not yet upto */
00C2   26B2             bne   P0076;    /* speed; go thru another pass. */
00C4   7CC891           inc   $C891;    /* The disk is now upto speed; for */
00C7   B6C891           lda   $C891;    /* good measure, repeat, for a */
00CA   8103             cmpa  #0x03;    /* total of 3 times. */
00CC   26A8             bne   P0076;
00CE   2020             bra   MainGameLoop;

                 /*
                  * GetGoggleIndexState()
                  *
                  * Check to see if the color wheel index has been seen.
                  *
                  * Exit: a = state of goggle index signal
                  *           0 => index signal not seen
                  *           !=0 => index signal seen
                  */
                 GetGoggleIndexState:
00D0   860E             lda   #0x0E;
00D2   9701             sta   0x01;
00D4   CC1901           ldd   #0x1901;
00D7   9700             sta   0x00;
00D9   12               nop;
00DA   D700             stb   0x00;
00DC   0F03             clr   0x03;     /* Set Port A lines as inputs */
00DE   CC0901           ldd   #0x0901;
00E1   9700             sta   0x00;
00E3   12               nop;
00E4   9601             lda   0x01;     /* Read Port A lines */
00E6   12               nop;
00E7   D700             stb   0x00;
00E9   C6FF             ldb   #0xFF;
00EB   D703             stb   0x03;     /* Set Port A lines as outputs */
00ED   8480             anda  #0x80;
00EF   39               rts;

                 /*
                  * Main loop for this game.  Reads buttons and joystick,
                  * does drawing, and then wait for the IRQ.
                  */
                 MainGameLoop:
00F0   BDF1A2           jsr   $set_refresh;

                 ReturnFromIRQ:
00F3   FCC83D           ldd   $C83D;
00F6   DD08             std   0x08;     /* Set refresh timer */
00F8   F6C845           ldb   $C845;
00FB   C4BF             andb  #0xBF;
00FD   8607             lda   #0x07;
00FF   BDF25B           jsr   $PF25B;   /* Config Port A as an input */
0102   BDF1BA           jsr   $read_switches2;
0105   F6C845           ldb   $C845;
0108   CA40             orb   #0x40;
010A   8607             lda   #0x07;
010C   BDF25B           jsr   $PF25B;   /* Config Port A as an output */
010F   CC0E80           ldd   #0x0E80;  /* Write 0x80 to Port A */
0112   BDF256           jsr   $byte_2_sound_chip;
0115   CCFF02           ldd   #0xFF02;
0118   B7CA8B           sta   $CA8B;
011B   D70D             stb   0x0D;     /* Clear goggle index intrpt flag */
011D   1CEF             andcc #0xEF;    /* Enable goggle index intrpt (IRQ) */
011F   FCC825           ldd   $C825;
0122   C30001           addd  #0x0001;  /* For each pass, increment the */
0125   FDC825           std   $C825;    /* 'refresh timer expired' counter. */
0128   BD0651           jsr   $DoDrawing;
012B   7FC823           clr   $C823;    /* Disable joystick approximation */
012E   BDF1F8           jsr   $read_jstick;
0131   BD0353           jsr   $P0353;
0134   BDF35B           jsr   $PF35B;
0137   C610             ldb   #0x10;
0139   5A        P0139: decb;           /* Timing loop */
013A   26FD             bne   P0139;
013C   7FCA8B           clr   $CA8B;
013F   3CEF             cwai  #0xEF;    /* Enable IRQ & wait for goggle index */
                                        /* interrupt. */

0141   BDF289    P0141: jsr   $do_sound;
0144   7FC856           clr   $C856;
0147   BDF1AF           jsr   $dptoC8;
014A   BD14EB           jsr   $P14EB;
014D   BDF1AA           jsr   $dptoD0;
0150   39               rts;

                 /*
                  * DrawVectorList()
                  *
                  * Entry:
                  *   b = scale factor
                  *   x = ptr to vector list of form:
                  *
                  *             mode, y, x
                  *             mode, y, x
                  *              .
                  *             0x01
                  *
                  *       where mode = 0x00 (move), 0xFF (draw) or 0x01 (end).
                  *
                  * This function draws a list of vectors.
                  *
                  */
                 DrawVectorList:
0151   D704             stb   0x04;       /* Save scale factor */
0153   EC01      P0153: ldd   1,x;        /* Load the y position */
0155   9701             sta   0x01;       /* Write y value */
0157   0F00             clr   0x00;
0159   A600             lda   0,x;        /* Load the line pattern */
015B   3003             leax  3,x;
015D   0C00             inc   0x00;
015F   D701             stb   0x01;       /* Write x value */
0161   970A             sta   0x0A;       /* Write the line pattern */
0163   0F05             clr   0x05;
0165   CC0040           ldd   #0x0040;
0168   D50D      P0168: bitb  0x0D;       /* Wait for the timer interrupt */
016A   27FC             beq   P0168;
016C   1E11             exg   x,x;
016E   970A             sta   0x0A;       /* Clear the line pattern */
0170   A600             lda   0,x;        /* Check the mode for the next pt */
0172   2FDF             ble   P0153;      /* Keep drawing, until mode = 0x01 */
0174   39               rts;

                 /*
                  * DrawAnimatedVectorList_Slow()
                  *
                  * Entry:
                  *   b = scale factor
                  *   x = ptr to 4 entry table of vector ptrs; each of the
                  *       entries points to a vector list having the following
                  *       form:
                  *
                  *             mode, y, x
                  *             mode, y, x
                  *              .
                  *             0x01
                  *
                  *       where mode = 0x00 (move), 0xFF (draw) or 0x01 (end).
                  *
                  * This function uses a system loop counter (C826)/4 to
                  * determine which of the 4 vector lists to draw.  This
                  * formula causes the visuals to change every 4th time
                  * through the processing loop.
                  */
                 DrawAnimatedVectorList_Slow:
0175   B6C826           lda   $C826;
0178   44               lsra;
0179   44               lsra;
017A   8403      P017A: anda  #0x03;
017C   48               asla;
017D   AE86             ldx   a,x;
017F   20D0             bra   DrawVectorList;

                 /*
                  * DrawAnimatedVectorList_Fast()
                  *
                  * Entry:
                  *   b = scale factor
                  *   x = ptr to 4 entry table of vector ptrs; each of the
                  *       entries points to a vector list having the following
                  *       form:
                  *
                  *             mode, y, x
                  *             mode, y, x
                  *              .
                  *             0x01
                  *
                  *       where mode = 0x00 (move), 0xFF (draw) or 0x01 (end).
                  *
                  * This function uses a system loop counter (C826) to
                  * determine which of the 4 vector lists to draw.  This
                  * formula causes the visuals to change every time
                  * through the processing loop.
                  */
                 DrawAnimatedVectorList_Fast:
0181   B6C826           lda   $C826;
0184   20F4             bra   P017A;

                 /*
                  * DrawWithMixedScaleFactors()
                  *
                  * Entry:
                  *   b = scale factor
                  *   C8B7 = alternate scale factor
                  *   x = ptr to vector list, of the form:
                  *
                  *             mode, y, x
                  *             mode, y, x
                  *              .
                  *             0x01
                  *
                  *       where mode = 0x00 (move), 0xFF (draw) 0x01 (end), or
                  *                    0x02 (move using alternate scale factor)
                  *
                  * This function draws a series of vectors.  Usually, the
                  * incoming scale factor will be used.  However, if the
                  * mode is 0x02, then the alternate scale factor (in C8B7)
                  * is used, and the operation is treated as a 'move'.
                  */
                 DrawWithMixedScaleFactors:
0186   3404             pshs  b;        /* Save the incoming scale factor */
0188   E660      P0188: ldb   0,s;      /* Load the incoming scale factor */
018A   D704             stb   0x04;     /* Write the scale factor */
018C   EC01             ldd   1,x;      /* Load the y,x values */
018E   9701             sta   0x01;     /* Write the y value */
0190   0F00             clr   0x00;
0192   A600             lda   0,x;      /* Load the mode value */
0194   2F06             ble   P019C;    /* Use alternate scale factor? */
0196   B6C8B7           lda   $C8B7;    /* Yes */
0199   9704             sta   0x04;     /* Write the alternate scale factor */
019B   4F               clra;           /* Treat like a move request */
019C   3003      P019C: leax  3,x;
019E   0C00             inc   0x00;
01A0   D701             stb   0x01;     /* Write the x value */
01A2   970A             sta   0x0A;     /* Write the line pattern */
01A4   0F05             clr   0x05;
01A6   CC0040           ldd   #0x0040;
01A9   D50D      P01A9: bitb  0x0D;     /* Wait for the timer interrupt */
01AB   27FC             beq   P01A9;
01AD   1E11             exg   x,x;
01AF   970A             sta   0x0A;     /* Clear the line pattern */
01B1   A600             lda   0,x;      /* Look at mode for next endpoint */
01B3   8101             cmpa  #0x01;    /* Time to quit? */
01B5   26D1             bne   P0188;
01B7   3504             puls  b;        /* Yes */
01B9   7E0353           jmp   $P0353;

                 /*
                  * NE_DrawDots()
                  *
                  * Entry:
                  *   b = scale factor
                  *   x = ptr to vector list, of the form:
                  *
                  *             mode, y, x
                  *             mode, y, x
                  *              .
                  *             0x01
                  *
                  *       where mode = 0x01 (end), else all others (move and
                  *                    then draw a dot).
                  *
                  * This function ignores the 'mode' field, except for
                  * using it to tag the end of the vector list.  It will
                  * move to the indicated (y,x) position, and will then
                  * draw a dot.
                  */
                 NE_DrawDots:
01BC   D704             stb   0x04;      /* Save the scale factor */
01BE   EC01      P01BE: ldd   1,x;       /* Load the y,x values */
01C0   9701             sta   0x01;      /* Write the y value */
01C2   0F00             clr   0x00;
01C4   4F               clra;            /* Load the line pattern */
01C5   3003             leax  3,x;       /* Advance to next vector entry */
01C7   0C00             inc   0x00;
01C9   D701             stb   0x01;      /* Write the x value */
01CB   970A             sta   0x0A;      /* Clear the line pattern */
01CD   0F05             clr   0x05;
01CF   CC0040           ldd   #0x0040;
01D2   D50D      P01D2: bitb  0x0D;      /* Wait for the timer interrupt */
01D4   27FC             beq   P01D2;
01D6   1E11             exg   x,x;
01D8   030A             com   0x0A;      /* Start drawing a dot */
01DA   12               nop;
01DB   12               nop;
01DC   030A             com   0x0A;      /* Stop drawing a dot */
01DE   A600             lda   0,x;       /* Check mode for next endpoint */
01E0   2FDC             ble   P01BE;     /* End of vector list? */
01E2   39               rts;             /* Yes */

                 DrawThenZeroIntegrators:
01E3   8D05             bsr   Draw4ByteVectorLists;
01E5   86CD             lda   #0xCD;     /* Set goggle index to trigger off */
01E7   970C             sta   0x0C;      /* of positive edge; also zero */
01E9   39               rts;             /* the integrators. */

                 /*
                  * Draw4ByteVectorLists()
                  *
                  * Entry:
                  *   CA81 = frame's scale factor
                  *   x = ptr to vector list, of the form:
                  *
                  *             mode, y, x, counter
                  *             mode, y, x, counter
                  *              .
                  *             0x01
                  *
                  *       where mode = 0xFF (draw), 0x00(move) or 0x01 (end).
                  *
                  * This function will draw the indicated vectors, using
                  * the passed-in 8-bit scale factor, unless the counter is
                  * >0, in which case, it will calculate a 16-bit scale
                  * factor to use.
                  */
                 Draw4ByteVectorLists:
01EA   0F00             clr   0x00;
01EC   A601             lda   1,x;       /* Load the y value */
01EE   9701             sta   0x01;      /* Write the y value */
01F0   E603             ldb   3,x;       /* Load the counter */
01F2   F7CA82           stb   $CA82;     /* Save the counter */
01F5   C655             ldb   #0x55;
01F7   F7CA83           stb   $CA83;
01FA   F6CA81           ldb   $CA81;     /* Load frame's scale factor */
01FD   4F               clra;            /* Assume hi-byte scale factor = 0 */
01FE   7ACA82           dec   $CA82;     /* If counter was <= 0, do normal */
0201   2B0E             bmi   P0211;     /* drawing.                       */
0203   78CA83    P0203: asl   $CA83;     /* Calculate a 16 bit scale factor */
0206   59               rolb;
0207   49               rola;
0208   CB03             addb  #0x03;
020A   8900             adca  #0x00;
020C   7ACA82           dec   $CA82;
020F   2AF2             bpl   P0203;
0211   D704      P0211: stb   0x04;      /* Write the scale factor */
0213   E602             ldb   2,x;       /* Load the x value */
0215   0C00             inc   0x00;
0217   D701             stb   0x01;      /* Write the x value */
0219   E600             ldb   0,x;       /* Load the drawing pattern */
021B   1A10             orcc  #0x10;     /* Mask (disable) IRQ */
021D   D70A             stb   0x0A;      /* Write the drawing pattern */
021F   9705             sta   0x05;      /* Write hi-byte of scale factore */
0221   C640             ldb   #0x40;
0223   D50D      P0223: bitb  0x0D;      /* Wait for timer interrupt */
0225   27FC             beq   P0223;
0227   3004             leax  4,x;       /* Advance to next endpoint */
0229   3000             leax  0,x;
022B   0F0A             clr   0x0A;      /* Clear the drawing pattern */
022D   1CEF             andcc #0xEF;     /* Unmask (reenable) IRQ */
022F   B6CA8D           lda   $CA8D;
0232   2704             beq   P0238;
0234   9109             cmpa  0x09;
0236   2205             bhi   P023D;
0238   A600      P0238: lda   0,x;
023A   2FA7             ble   DrawThenZeroIntegrators;
023C   39               rts;
023D   CC0EFF    P023D: ldd   #0x0EFF;
0240   BDF25B           jsr   $PF25B;    /* Write 0xFF to Port A */
0243   F6C845           ldb   $C845;
0246   C4BF             andb  #0xBF;
0248   8607             lda   #0x07;
024A   BDF25B           jsr   $PF25B;    /* Config Port A as input */
024D   7FCA8D           clr   $CA8D;
0250   20E6             bra   P0238;

0252   B6CA8D    P0252: lda   $CA8D;
0255   2601             bne   P0258;
0257   39               rts;
0258   9109      P0258: cmpa  0x09;
025A   2201             bhi   P025D;
025C   39               rts;
025D   CC0EFF    P025D: ldd   #0x0EFF;
0260   BDF25B           jsr   $PF25B;    /* Write 0xFF to Port A */
0263   F6C845           ldb   $C845;
0266   C4BF             andb  #0xBF;
0268   8607             lda   #0x07;
026A   BDF25B           jsr   $PF25B;    /* Config Port A as input */
026D   7FCA8D           clr   $CA8D;
0270   39               rts;

                 /*
                  * IRQ_Handler()
                  *
                  * This code appears to try to detect if the goggle's
                  * disk has slowed down too much, thus allowing the
                  * refresh timeout to occur *before* the disk has
                  * made a revolution.  When too many failures occur,
                  * it appears to adjust some variables, apparently
                  * with the hope of giving the disk time to get
                  * back into sync again.
                  */
                 IRQ_Handler:
0271   0F0A             clr   0x0A;      /* Clear line drawing pattern */
0273   960D             lda   0x0D;
0275   8520             bita  #0x20;     /* Did refresh timer already expire? */
0277   260D             bne   Timeout;   /* Yes; so mark another timeout */
0279   B6CA8E           lda   $CA8E;
027C   B7CA8D           sta   $CA8D;
027F   7ACA8A           dec   $CA8A;     /* Decrement the IRQ loop counter */
0282   2E7E             bgt   FinishIRQ; /* Have we taken 8 samples? */
0284   200E             bra   ProcessSamples;  /* Yes; process the results */
                 Timeout:
0286   B6CA8C           lda   $CA8C;     /* Refresh timer elapsed */
0289   B7CA8D           sta   $CA8D;
028C   7CCA86           inc   $CA86;     /* Increment failure counter */
028F   7ACA8A           dec   $CA8A;     /* Have we taken 8 samples? */
0292   2E6E             bgt   FinishIRQ; /* Nope; do nothing */
                 ProcessSamples:
0294   C608             ldb   #0x08;
0296   F7CA8A           stb   $CA8A;     /* Reset IRQ sample counter */
0299   F6CA86           ldb   $CA86;     /* Sum the # of failures for this */
029C   FBCA87           addb  $CA87;     /* pass and the previous pass. */
029F   1F98             tfr   b,a;
02A1   800D             suba  #0x0D;
02A3   40               nega;
02A4   C10D             cmpb  #0x0D;
02A6   2714             beq   P02BC;
02A8   2A0A             bpl   P02B4;
02AA   BBCA8C           adda  $CA8C;
02AD   250D             blo   P02BC;
02AF   B7CA8C           sta   $CA8C;
02B2   2008             bra   P02BC;
02B4   BBCA8C    P02B4: adda  $CA8C;
02B7   2403             bhs   P02BC;
02B9   B7CA8C           sta   $CA8C;
02BC   FBCA88    P02BC: addb  $CA88;     /* Failures for (pass - 2) */
02BF   FBCA89           addb  $CA89;     /* Failures for (pass - 3) */
02C2   C018             subb  #0x18;
02C4   271B             beq   P02E1;
02C6   1F98             tfr   b,a;
02C8   5F               clrb;
02C9   40               nega;
02CA   47               asra;
02CB   56               rorb;
02CC   4D               tsta;
02CD   2B0A             bmi   P02D9;
02CF   F3CA8E           addd  $CA8E;
02D2   250D             blo   P02E1;
02D4   FDCA8E           std   $CA8E;
02D7   2008             bra   P02E1;
02D9   F3CA8E    P02D9: addd  $CA8E;
02DC   2403             bhs   P02E1;
02DE   FDCA8E           std   $CA8E;
02E1   B6CA8E    P02E1: lda   $CA8E;
02E4   801A             suba  #0x1A;
02E6   B0CA8C           suba  $CA8C;
02E9   2208             bhi   ShuffleFailureInfo;
02EB   B6CA8C           lda   $CA8C;
02EE   8B1A             adda  #0x1A;
02F0   B7CA8E           sta   $CA8E;
                 ShuffleFailureInfo:
02F3   FCCA87           ldd   $CA87;     /* Shuffle down the failure results */
02F6   FDCA88           std   $CA88;     /* information for the last 3 passes */
02F9   B6CA86           lda   $CA86;     /* discarding the results for the */
02FC   B7CA87           sta   $CA87;     /* oldest pass. */
02FF   7FCA86           clr   $CA86;     /* Start w/ 0 failures for next pass */
                 FinishIRQ:
0302   12               nop;
0303   CC0EFF           ldd   #0x0EFF;   /* Write 0xFF to Port A */
0306   BDF256           jsr   $byte_2_sound_chip;
0309   F6C845           ldb   $C845;
030C   CA40             orb   #0x40;
030E   8607             lda   #0x07;
0310   BDF25B           jsr   $PF25B;    /* Config Port A as an output */
0313   BDF354           jsr   $reset0ref;
0316   10CECBEA         lds   #0xCBEA;
031A   7E00F3           jmp   $ReturnFromIRQ;

                 /*
                  * DrawOneEnemyPassageWall()
                  *
                  * Entry:
                  *   x = ptr to vector list.
                  *   y = ptr to scale factor.
                  *
                  * Draw a single wall in the enemy passage; the intensity
                  * used is based upon the value at (0,y).
                  */
                 DrawOneEnemyPassageWall:
031D   A620             lda   0,y;       /* Quit when the incoming scale */
031F   81FF             cmpa  #0xFF;     /* factor is 0xFF. */
0321   2601             bne   P0324;
0323   39               rts;
0324   3410      P0324: pshs  x;
0326   C61C             ldb   #0x1C;
0328   D704             stb   0x04;      /* Set scale factor = 0x1C */
032A   EC81             ldd   ,x++;      /* Load (y,x) values */
032C   9701             sta   0x01;      /* Write y value */
032E   0F00             clr   0x00;
0330   86CF             lda   #0xCF;     /* Un-zero integrators, and trigger */
0332   970C             sta   0x0C;      /* IRQ on positive edge. */
0334   0C00             inc   0x00;
0336   D701             stb   0x01;      /* Write x value */
0338   C640             ldb   #0x40;
033A   0F05             clr   0x05;
033C   D50D      P033C: bitb  0x0D;      /* Wait for scale timer interrupt */
033E   27FC             beq   P033C;
0340   A620             lda   0,y;
0342   B7CA81           sta   $CA81;     /* Save scale factor */
0345   8B40             adda  #0x40;     /* Calculate intensity = scale+0x40 */
0347   2A02             bpl   P034B;
0349   867F             lda   #0x7F;     /* If rollover, use 0x7F (max). */
034B   BDF2AB    P034B: jsr   $intensity_to_a;
034E   BD01E3           jsr   $DrawThenZeroIntegrators;
0351   3510             puls  x;
0353   86CD      P0353: lda   #0xCD;     /* Zero integrators, and trigger IRQ */
0355   970C             sta   0x0C;      /* on positive edge. */
0357   BDF35B           jsr   $PF35B;
035A   BDF57D           jsr   $PF57D;
035D   39               rts;

                 /*
                  * DrawFuelWall()
                  *
                  * Entry:
                  *   x = ptr to 4-byte vector list.
                  *
                  * This function draws a fuel wall, including the appropriate
                  * embedded fuel wall opening.
                  */
                 DrawFuelWall:
035E   3410             pshs  x;
0360   8E148E           ldx   #FuelWall;
0363   0F00      P0363: clr   0x00;
0365   A601             lda   1,x;
0367   9701             sta   0x01;      /* Write the y value */
0369   E603             ldb   3,x;
036B   F7CA82           stb   $CA82;     /* Set the loop counter */
036E   C655             ldb   #0x55;
0370   F7CA83           stb   $CA83;
0373   F6CA81           ldb   $CA81;     /* Get saved scale factor */
0376   4F               clra;
0377   7ACA82           dec   $CA82;
037A   2B0E             bmi   P038A;
037C   78CA83    P037C: asl   $CA83;
037F   59               rolb;
0380   49        P0380: rola;
0381   CB03             addb  #0x03;
0383   8900             adca  #0x00;
0385   7ACA82           dec   $CA82;     /* Decrement loop counter */
0388   2AF2             bpl   P037C;     /* Are we done looping yet? */
038A   D704      P038A: stb   0x04;      /* Write scale factor */
038C   E602             ldb   2,x;
038E   0C00             inc   0x00;
0390   D701             stb   0x01;      /* Write x value */
0392   E600             ldb   0,x;       /* Get the line drawing pattern */
0394   1A10             orcc  #0x10;     /* Disable IRQ interrupts */
0396   D70A             stb   0x0A;      /* Write the line drawing pattern */
0398   9705             sta   0x05;      /* Save hi byte of scale factor */
039A   C640             ldb   #0x40;
039C   D50D      P039C: bitb  0x0D;      /* Wait for scale timer interrupt */
039E   27FC             beq   P039C;
03A0   3004             leax  4,x;       /* Advance ptr to next point */
03A2   3000             leax  0,x;
03A4   0F0A             clr   0x0A;      /* Clear line drawing pattern */
03A6   1CEF             andcc #0xEF;     /* Reenable IRQ interrupts */
03A8   B6CA8D           lda   $CA8D;
03AB   2704             beq   P03B1;
03AD   9109             cmpa  0x09;
03AF   2206             bhi   P03B7;
03B1   A600      P03B1: lda   0,x;
03B3   2FAE             ble   P0363;
03B5   2015             bra   P03CC;
03B7   CC0EFF    P03B7: ldd   #0x0EFF;
03BA   BDF25B           jsr   $PF25B;    /* Write 0xFF to Port A */
03BD   F6C845           ldb   $C845;
03C0   C4BF             andb  #0xBF;
03C2   8607             lda   #0x07;
03C4   BDF25B           jsr   $PF25B;    /* Config Port A as input */
03C7   7FCA8D           clr   $CA8D;
03CA   20E5             bra   P03B1;
03CC   86CF      P03CC: lda   #0xCF;     /* Un-zero integrators, & trigger */
03CE   970C             sta   0x0C;      /* IRQ off positive edge. */
03D0   ECA81C           ldd   0x1C,y;    /* Get position of embedded object */
03D3   9701             sta   0x01;      /* Write the y value */
03D5   0F00             clr   0x00;
03D7   A625             lda   5,y;       /* Get embedded obj's scale factor */
03D9   9704             sta   0x04;      /* Write the scale factor */
03DB   1E11             exg   x,x;
03DD   0C00             inc   0x00;
03DF   D701             stb   0x01;      /* Write the x value */
03E1   C640             ldb   #0x40;
03E3   0F05             clr   0x05;
03E5   D50D      P03E5: bitb  0x0D;      /* Wait for scale timer interrupt */
03E7   27FC             beq   P03E5;
03E9   3510             puls  x;
03EB   BD01E3           jsr   $DrawThenZeroIntegrators;
03EE   39               rts;

                 /*
                  * DrawFrameContents()
                  *
                  * Entry:
                  *   x = frame ptr
                  *
                  * This function will draw the contents of the indicated
                  * frame.
                  */
                 DrawFrameContents:
03EF   3450             pshs  x,u;
03F1   C61C             ldb   #0x1C;
03F3   D704             stb   0x04;      /* Write the scale factor */
03F5   E602             ldb   2,x;
03F7   50               negb;
03F8   1D               sex;
03F9   C30060           addd  #0x0060;
03FC   0F01             clr   0x01;
03FE   0F00             clr   0x00;
0400   86CF             lda   #0xCF;     /* Un-zero integrators, & trigger */
0402   970C             sta   0x0C;      /* IRQ off positive edge. */
0404   0C00             inc   0x00;
0406   7DC8A6           tst   $C8A6;
0409   2701             beq   P040C;
040B   50               negb;
040C   D701      P040C: stb   0x01;
040E   C640             ldb   #0x40;
0410   0F05             clr   0x05;
0412   D50D      P0412: bitb  0x0D;      /* Wait for timer interrupt */
0414   27FC             beq   P0412;
0416   EC00             ldd   0,x;       /* Load drawing (y,x) values */
0418   9701             sta   0x01;      /* Write the y value */
041A   0F00             clr   0x00;
041C   A603             lda   3,x;       /* Load scale factor */
041E   9704             sta   0x04;      /* Write scale factor */
0420   1E11             exg   x,x;
0422   0C00             inc   0x00;
0424   D701             stb   0x01;      /* Write the x value */
0426   C640             ldb   #0x40;
0428   0F05             clr   0x05;
042A   D50D      P042A: bitb  0x0D;      /* Wait for timer interrupt */
042C   27FC             beq   P042A;
042E   A605             lda   5,x;       /* Load embedded obj's scale factor */
0430   B7CA81           sta   $CA81;     /* Save embedded obj's scale factor */
0433   6D881B           tst   0x1B,x;    /* Is player in the eneny passage */
0436   2721             beq   P0459;     /* or the fuel passage? */
0438   EC09             ldd   9,x;       /* In fuel passage */
043A   10831479         cmpd  #FuelCannister;  /* Is this frame a fuel wall */
043E   2619             bne   P0459;     /* or a fuel cannister? */
0440   EC881C           ldd   0x1C,x;    /* Load embedded objects (y,x) */
0443   9701             sta   0x01;      /* Write y value */
0445   0F00             clr   0x00;
0447   A605             lda   5,x;       /* Load embedded obj's scale factor */
0449   9704             sta   0x04;      /* Write embedded obj's scale factor */
044B   1E11             exg   x,x;
044D   0C00             inc   0x00;
044F   D701             stb   0x01;      /* Write x value */
0451   C640             ldb   #0x40;
0453   0F05             clr   0x05;
0455   D50D      P0455: bitb  0x0D;      /* Wait for timer interrupt */
0457   27FC             beq   P0455;
0459   A608      P0459: lda   8,x;       /* Load intensity value */
045B   BDF2AB           jsr   $intensity_to_a;
045E   338820           leau  0x20,x;    /* Load address of drawing proc */
0461   1F12             tfr   x,y;
0463   7DC8A6           tst   $C8A6;
0466   2704             beq   P046C;
0468   AE09             ldx   9,x;       /* Load vector list # 1 */
046A   2002             bra   P046E;
046C   AE0B      P046C: ldx   11,x;      /* Load vector list # 2 */
046E   BFC82C    P046E: stx   $C82C;     /* Save vector list ptr */
0471   F6CA81           ldb   $CA81;     /* Retrieve scale factor */
0474   ADD4             jsr   [,u];      /* (INDIRECT JUMP) */
0476   3550             puls  x,u;
0478   7E0353           jmp   $P0353;

                 /*
                  * EP_DrawAllBlueFramesAndWalls_LeftEye()
                  *
                  * This function will draw all of the blue user frames,
                  * and when that completes, will draw any blue walls.
                  * This is only for the left eye.
                  */
                 EP_DrawAllBlueFramesAndWalls_LeftEye:
047B   73C8A6           com   $C8A6;     /* Flag we're drawing for left eye */
047E   BD076E           jsr   $ResetFramePtrToPlayersFirstFrame;
0481   8601      P0481: lda   #0x01;     /* Request blue frame */
0483   BD0748           jsr   $LocateSpecificFrame;
0486   4D               tsta;            /* Did we find a frame? */
0487   2607             bne   P0490;     /* Yep; so draw it */
0489   CE0495           ldu   #LeftWalls_LeftEye; /* Nope; draw left walls */
048C   BD1146           jsr   $DrawEnemyPassageWalls;
048F   39               rts;
0490   BD03EF    P0490: jsr   $DrawFrameContents;
0493   20EC             bra   P0481;     /* Check for another frame */

                 LeftWalls_LeftEye:
0495   19               .word LeftWallFar_LeftEye;
0497   19               .word LeftWallNear_LeftEye;

                 /*
                  * EP_DrawAllGreenFramesAndWalls_LeftEye()
                  *
                  * This function will draw all of the green user frames,
                  * and when that completes, will draw any green walls.
                  * This is only for the left eye.
                  */
                 EP_DrawAllGreenFramesAndWalls_LeftEye:
0499   BD076E           jsr   $ResetFramePtrToPlayersFirstFrame;
049C   8602      P049C: lda   #0x02;      /* Request green frame */
049E   BD0748           jsr   $LocateSpecificFrame;
04A1   4D               tsta;             /* Did we find a frame? */
04A2   260A             bne   P04AE;      /* Yep; so draw it */
04A4   CE04B3           ldu   #RightWalls_LeftEye; /* Nope; draw left walls */
04A7   BD1146           jsr   $DrawEnemyPassageWalls;
04AA   BD0141           jsr   $P0141;     /* Process sounds */
04AD   39               rts;
04AE   BD03EF    P04AE: jsr   $DrawFrameContents;
04B1   20E9             bra   P049C;

                 RightWalls_LeftEye:
04B3   1A               .word RightWallFar_LeftEye;
04B5   1A               .word RightWallNear_LeftEye;

                 /*
                  * EP_DrawAllRedFrames_LeftEye()
                  *
                  * This function will draw all of the red user frames,
                  * and when that completes, will check to see if the
                  * player has hit an enemy ship or picked up fuel.
                  * The drawing done is only for the left eye.
                  */
                 EP_DrawAllRedFrames_LeftEye:
04B7   BD076E           jsr   $ResetFramePtrToPlayersFirstFrame;
04BA   8603      P04BA: lda   #0x03;      /* Request red frame */
04BC   BD0748           jsr   $LocateSpecificFrame;
04BF   4D               tsta;             /* Did we find a frame? */
04C0   263D             bne   P04FF;      /* Yep; so draw it */
04C2   BD0353           jsr   $P0353;
04C5   BD1170           jsr   $DrawFuelBar;
04C8   FCC886           ldd   $C886;        /* Load BCD value of enemy ship */
04CB   7DC888           tst   $C888;        /* Was an enemy ship destroyed? */
04CE   2608             bne   UpdateScore;
04D0   CC0100           ldd   #0x0100;      /* Load BCD value of fuel can */
04D3   7DC8B0           tst   $C8B0;        /* Did player pickup fuel can? */
04D6   2720             beq   P04F8;
                 UpdateScore:
04D8   8EC8C6           ldx   #0xC8C6;      /* Yes; update player's score */
04DB   BDF87C           jsr   $add_d_to_x_in_bcd;
04DE   7DC881           tst   $C881;        /* Check if score > 20,000 only */
04E1   2615             bne   P04F8;        /* once per game.               */
04E3   8EC8C6           ldx   #0xC8C6;      /* See if player's score is */
04E6   CE0508           ldu   #BonusScoreLevel; /* > 20,000.                */
04E9   BDF8C7           jsr   $compare_scores;
04EC   8101             cmpa  #0x01;
04EE   2608             bne   P04F8;
04F0   86FF             lda   #0xFF;        /* Score is > 20,000 */
04F2   B7C881           sta   $C881;        /* Disable doing check again */
04F5   7CC8C4           inc   $C8C4;        /* Award a bonus ship */
04F8   7FC888    P04F8: clr   $C888;        /* Clear 'enemy destroyed' flag */
04FB   7FC8B0           clr   $C8B0;        /* Clear 'fuel picked up' flag */
04FE   39               rts;
04FF   BD03EF    P04FF: jsr   $DrawFrameContents;
0502   20B6             bra   P04BA;

                 /* These appear to not be referenced */
0504   1A               .word 0x1ABD;
0506   1A               .word 0x1ABD;

                 BonusScoreLevel:
0508   20               .string " 20000",0x80;

                 /*
                  * CheckForScoreOver20000()
                  *
                  * Entry:
                  *   d = value to add to player's score.
                  *
                  * Exit:
                  *   C881 = will be set to 0xFF, if the score is now
                  *          above 20,000; this is a flag which prevents
                  *          this check from happening again, after the
                  *          score goes over 20,000.
                  *   C8C4 = will be incremented, once the score goes
                  *          above 20,000; this awards an extra ship to
                  *          the player.
                  *
                  * This function adds the specified value to the player's
                  * score, and then checks to see if the player's score
                  * is now above 20,000.
                  */
                 CheckForScoreOver20000:
050F   8EC8C6           ldx   #0xC8C6;
0512   BDF87C           jsr   $add_d_to_x_in_bcd;
0515   7DC881           tst   $C881;       /* Bypass check, if the score */
0518   2615             bne   P052F;       /* is already > 20,000.       */
051A   8EC8C6           ldx   #0xC8C6;
051D   CE0508           ldu   #BonusScoreLevel;
0520   BDF8C7           jsr   $compare_scores;
0523   8101             cmpa  #0x01;
0525   2608             bne   P052F;
0527   86FF             lda   #0xFF;
0529   B7C881           sta   $C881;       /* Disable future checking */
052C   7CC8C4           inc   $C8C4;       /* Award a bonus ship */
052F   39        P052F: rts;

                 /*
                  * EP_DrawAllBlueFramesAndWalls_RightEye()
                  *
                  * This function will draw all of the blue user frames,
                  * and when that completes, will draw any blue walls.
                  * This is only for the right eye.
                  */
                 EP_DrawAllBlueFramesAndWalls_RightEye:
0530   7FC8A6           clr   $C8A6;       /* Flag we're doing right eye */
0533   BD076E           jsr   $ResetFramePtrToPlayersFirstFrame;
0536   8601      P0536: lda   #0x01;       /* Request blue frame */
0538   BD0748           jsr   $LocateSpecificFrame;
053B   4D               tsta;              /* Did we find a frame? */
053C   260A             bne   P0548;       /* Yep, so draw it */
053E   CE054D           ldu   #LeftWalls_RightEye; /* Nope, so draw walls */
0541   BD1146           jsr   $DrawEnemyPassageWalls;
0544   BDF511           jsr   $get_random_a2;
0547   39               rts;
0548   BD03EF    P0548: jsr   $DrawFrameContents;
054B   20E9             bra   P0536;       /* Check for another frame */

                 LeftWalls_RightEye:
054D   1A               .word LeftWallFar_RightEye;
054F   1A               .word LeftWallNear_RightEye;

                 /*
                  * EP_DrawAllGreenFramesAndWalls_RightEye()
                  *
                  * This function will draw all of the green user frames,
                  * and when that completes, will draw any green walls.
                  * This is only for the right eye.
                  */
                 EP_DrawAllGreenFramesAndWalls_RightEye:
0551   BD076E           jsr   $ResetFramePtrToPlayersFirstFrame;
0554   8602      P0554: lda   #0x02;       /* Request green frame */
0556   BD0748           jsr   $LocateSpecificFrame;
0559   4D               tsta;              /* Did we find a frame? */
055A   2616             bne   P0572;       /* Yep, so draw it */
055C   CE0577           ldu   #RightWalls_RightEye; /* Nope, so draw walls */
055F   BD1146           jsr   $DrawEnemyPassageWalls;
0562   8EF9F0           ldx   #0xF9F0;
0565   BDF308           jsr   $move_penFF;
0568   BD0353           jsr   $P0353;
056B   BDF310           jsr   $move_pen;
056E   BD0353           jsr   $P0353;
0571   39               rts;
0572   BD03EF    P0572: jsr   $DrawFrameContents;
0575   20DD             bra   P0554;       /* Check for another wall */

                 RightWalls_RightEye:
0577   1A               .word RightWallFar_RightEye;
0579   1A               .word RightWallNear_RightEye;

                 /*
                  * EP_DrawAllRedFrames_RightEye()
                  *
                  * This function will draw all of the red user frames,
                  * and when that completes, will draw the fuel bar.
                  * This is only for the right eye.
                  */
                 EP_DrawAllRedFrames_RightEye:
057B   BD076E           jsr   $ResetFramePtrToPlayersFirstFrame;
057E   8603      P057E: lda   #0x03;       /* Request red frame */
0580   BD0748           jsr   $LocateSpecificFrame;
0583   4D               tsta;              /* Did we find a frame? */
0584   2607             bne   P058D;       /* Yep, so draw it */
0586   BD0353           jsr   $P0353;      /* Nope, so draw fuel bar */
0589   BD1170           jsr   $DrawFuelBar;
058C   39               rts;
058D   BD03EF    P058D: jsr   $DrawFrameContents;
0590   20EC             bra   P057E;       /* Check for another frame */

                 /* These appear to not be referenced */
0592   1A               .word 0x1AA6;
0594   1A               .word 0x1AA6;

                 /*
                  * NE_DisplayString()
                  *
                  * Entry:
                  *   C82A = character cell height
                  *   C82B = character cell width
                  *   C82C-C82D = string ptr
                  *
                  * This function displays a character string at the current
                  * position.  It is basically identical to the string
                  * function in the ExecRom, with the only major difference
                  * being what is done after the drawing is completed.
                  */
                 NE_DisplayString:
0596   8EF9D4           ldx   #0xF9D4;
0599   CC1883           ldd   #0x1883;
059C   0F01             clr   0x01;
059E   970B             sta   0x0B;
05A0   D700      P05A0: stb   0x00;
05A2   0A00             dec   0x00;
05A4   CC8081           ldd   #0x8081;
05A7   12               nop;
05A8   0C00             inc   0x00;
05AA   D700             stb   0x00;
05AC   9700             sta   0x00;
05AE   12               nop;
05AF   12               nop;
05B0   0C00             inc   0x00;
05B2   B6C82B           lda   $C82B;
05B5   9701             sta   0x01;
05B7   CC0100           ldd   #0x0100;
05BA   FEC82C           ldu   $C82C;
05BD   9700             sta   0x00;
05BF   2004             bra   P05C5;
05C1   A686      P05C1: lda   a,x;
05C3   970A             sta   0x0A;
05C5   A6C0      P05C5: lda   ,u+;
05C7   2AF8             bpl   P05C1;
05C9   8681             lda   #0x81;
05CB   9700             sta   0x00;
05CD   0001             neg   0x01;
05CF   8601             lda   #0x01;
05D1   9700             sta   0x00;
05D3   8CFBB4           cmpx  #0xFBB4;
05D6   272C             beq   P0604;
05D8   308850           leax  0x50,x;
05DB   1F30             tfr   u,d;
05DD   B3C82C           subd  $C82C;
05E0   C002             subb  #0x02;
05E2   58               aslb;
05E3   2100             brn   P05E5;
05E5   8681      P05E5: lda   #0x81;
05E7   12               nop;
05E8   5A               decb;
05E9   26FA             bne   P05E5;
05EB   9700             sta   0x00;
05ED   F6C82A           ldb   $C82A;
05F0   D701             stb   0x01;
05F2   0A00             dec   0x00;
05F4   CC8101           ldd   #0x8101;
05F7   12               nop;
05F8   9700             sta   0x00;
05FA   0F01             clr   0x01;
05FC   D700             stb   0x00;
05FE   9700             sta   0x00;
0600   C603             ldb   #0x03;
0602   209C             bra   P05A0;
0604   8698      P0604: lda   #0x98;
0606   970B             sta   0x0B;
0608   7E0353           jmp   $P0353;

                 /*
                  * UpdatePlayersFuelLevel()
                  *
                  * Entry:
                  *    CA77 = player's fuel supply
                  *    CA7A = fuel consumption rate
                  *
                  * Every 32nd pass through the mainloop, this function will
                  * subtract some fuel from the player's supply.  If the
                  * player starts running low on fuel, set a flag, which will
                  * cause the fuel bar to start flashing.  If the player is
                  * out of fuel, then set a different flag, which will
                  * prevent the fuel bar from drawing at all.
                  */
                 UpdatePlayersFuelLevel:
060B   B6C826           lda   $C826;      /* Every 32nd pass, subtract out */
060E   841F             anda  #0x1F;      /* some fuel from player's supply. */
0610   260E             bne   P0620;
0612   FCCA77           ldd   $CA77;      /* Get player's fuel setting */
0615   B3CA7A           subd  $CA7A;      /* Subtract some out */
0618   FDCA77           std   $CA77;      /* Save new fuel setting */
061B   2A03             bpl   P0620;
061D   7FCA77           clr   $CA77;      /* Can't have minus fuel; set to 0*/
0620   7DCA7E    P0620: tst   $CA7E;      /* Is player already low on fuel? */
0623   261F             bne   P0644;
0625   B6CA77           lda   $CA77;      /* Is player almost out of fuel? */
0628   810F             cmpa  #0x0F;
062A   2418             bhs   P0644;      /* Are there >= 15 units left? */
062C   86FF             lda   #0xFF;      /* Nope; running low */
062E   B7CA7E           sta   $CA7E;      /* Flag that player is low on fuel */
0631   B6C89B           lda   $C89B;
0634   8A04             ora   #0x04;      /* Make 'running low on fuel' sound */
0636   B7C89B           sta   $C89B;
0639   B6C89F           lda   $C89F;
063C   8A04             ora   #0x04;      /* Enable the above sound */
063E   B7C89F           sta   $C89F;
0641   B6CA77           lda   $CA77;
0644   8101      P0644: cmpa  #0x01;      /* Are there any fuel units left? */
0646   2C08             bge   P0650;
0648   7FCA77           clr   $CA77;      /* Nope; we're history */
064B   86FF             lda   #0xFF;
064D   B7CA7D           sta   $CA7D;      /* Flag that player is out of fuel */
0650   39        P0650: rts;

                 /*
                  * DoDrawing()
                  *
                  * Entry:
                  *   C8AB = Processing function to invoke
                  *
                  * This function invokes the primary processing function,
                  * and then attempts to do some drawing.  Before doing the
                  * drawing, it will wait until the refresh counter has
                  * decremented to match a predefined checkpoint value.
                  */
                 DoDrawing:
0651   AD9FC8AB         jsr   [0xC8AB]; /* Call main processing function */
0655   108E14DF         ldy   #FrameDrawingProcs;
0659   CE14D1           ldu   #RefreshCheckPoints;
065C   EC40      P065C: ldd   0,u;      /* Load next checkpoint value */
065E   2601             bne   P0661;
0660   39               rts;
0661   BD0252    P0661: jsr   $P0252;
0664   EC40             ldd   0,u;      /* Wait until the correct part of the */
0666   9109             cmpa  0x09;     /* color wheel is visible, before */
0668   23F7             bls   P0661;    /* starting to draw. */
066A   AEA1             ldx   ,y++;
066C   3460             pshs  y,u;
066E   AD00             jsr   0,x;      /* Call drawing function */
0670   3560             puls  y,u;
0672   3342             leau  2,u;      /* Get next checkpoint */
0674   20E6             bra   P065C;

0676   B6C8D4    P0676: lda   $C8D4;
0679   8180             cmpa  #0x80;
067B   2306             bls   P0683;
067D   FCC8D1           ldd   $C8D1;
0680   FDC8D4           std   $C8D4;
0683   8EC8D4    P0683: ldx   #0xC8D4;
0686   B6C882           lda   $C882;
0689   8D55             bsr   P06E0;
068B   BD0738           jsr   $P0738;
068E   39               rts;

068F   7FC8B2    P068F: clr   $C8B2;
0692   B6C8D4           lda   $C8D4;
0695   8180             cmpa  #0x80;
0697   231F             bls   P06B8;
0699   B6C8D1           lda   $C8D1;
069C   B7C8D4           sta   $C8D4;
069F   81FF             cmpa  #0xFF;
06A1   2604             bne   P06A7;
06A3   73C8B2           com   $C8B2;
06A6   39               rts;
06A7   B6C8CE    P06A7: lda   $C8CE;
06AA   81FF             cmpa  #0xFF;
06AC   2707             beq   P06B5;
06AE   86FF             lda   #0xFF;
06B0   B7C8CE           sta   $C8CE;
06B3   2003             bra   P06B8;
06B5   B7C8D1    P06B5: sta   $C8D1;
06B8   8EC8D4    P06B8: ldx   #0xC8D4;
06BB   B6C882           lda   $C882;
06BE   8D20             bsr   P06E0;
06C0   B6C8D4           lda   $C8D4;
06C3   C650             ldb   #0x50;
06C5   3D               mul;
06C6   F6C8D1           ldb   $C8D1;
06C9   C1FF             cmpb  #0xFF;
06CB   2601             bne   P06CE;
06CD   39               rts;
06CE   B7C8D1    P06CE: sta   $C8D1;
06D1   C64A             ldb   #0x4A;
06D3   3D               mul;
06D4   F6C8CE           ldb   $C8CE;
06D7   C1FF             cmpb  #0xFF;
06D9   2601             bne   P06DC;
06DB   39               rts;
06DC   B7C8CE    P06DC: sta   $C8CE;
06DF   39               rts;

06E0   3402      P06E0: pshs  a;
06E2   EC00             ldd   0,x;
06E4   2603             bne   P06E9;
06E6   3502             puls  a;
06E8   39               rts;
06E9   A601      P06E9: lda   1,x;
06EB   E660             ldb   0,s;
06ED   3D               mul;
06EE   8900             adca  #0x00;
06F0   1F89             tfr   a,b;
06F2   4F               clra;
06F3   FDC891           std   $C891;
06F6   A600             lda   0,x;
06F8   E660             ldb   0,s;
06FA   3D               mul;
06FB   F3C891           addd  $C891;
06FE   E300             addd  0,x;
0700   ED00             std   0,x;
0702   3502             puls  a;
0704   39               rts;

                 /*
                  * UpdateFramesScaleAndIntensity()
                  *
                  * Entry:
                  *   x = Frame ptr
                  *
                  * This function recalulates the scale factors and the
                  * intensity values for a frame.  The intensity is calculated
                  * as follows:
                  *
                  *     new intensity = new scale factor + 0x40
                  *     if (new intensity < 0)   [ check for rollover ]
                  *        new intensity = 0x7F (max)
                  */
                 UpdateFramesScaleAndIntensity:
0705   EC03             ldd   3,x;      /* Load 16-bit scale factor */
0707   2601             bne   P070A;    /* Skip, if scale factor = 0 */
0709   39               rts;
070A   A604      P070A: lda   4,x;      /* Load hi-byte of scale factor */
070C   C61F             ldb   #0x1F;
070E   3D               mul;
070F   8900             adca  #0x00;
0711   1F89             tfr   a,b;
0713   4F               clra;
0714   3406             pshs  a,b;
0716   A603             lda   3,x;      /* Load low-byte of scale factor */
0718   C61F             ldb   #0x1F;
071A   3D               mul;
071B   E3E1             addd  ,s++;
071D   A303             subd  3,x;
071F   43               coma;
0720   53               comb;
0721   C30001           addd  #0x0001;
0724   ED03             std   3,x;      /* Save new 16-bit scale factor */
0726   48               asla;
0727   48               asla;
0728   C640             ldb   #0x40;
072A   3D               mul;
072B   A702             sta   2,x;
072D   A603             lda   3,x;      /* Recalculate intensity */
072F   8B40             adda  #0x40;
0731   2A02             bpl   P0735;
0733   867F             lda   #0x7F;
0735   A708      P0735: sta   8,x;      /* Save new intensity */
0737   39               rts;

0738   B6C8D4    P0738: lda   $C8D4;
073B   C650             ldb   #0x50;
073D   3D               mul;
073E   B7C8D1           sta   $C8D1;
0741   C64A             ldb   #0x4A;
0743   3D               mul;
0744   B7C8CE           sta   $C8CE;
0747   39               rts;

                 /*
                  * LocateSpecificFrame()
                  *
                  * Entry:
                  *   a = Frame identifier
                  *   C875-C876 = Ptr to 1st frame to check
                  *
                  * Exit:
                  *   a = 0 (no match) or 0xFF (match found)
                  *   x = ptr to matching frame
                  *   C875-C876 = Ptr to next frame after matching one
                  *
                  * This function attempts to locate the next frame in the
                  * sequence, having the indicated frame identifier
                  * (1=blue, 2=green and 3=red).
                  */
                 LocateSpecificFrame:
0748   B7C892           sta   $C892;     /* Save incoming frame number */
074B   BD0252           jsr   $P0252;
074E   B6C892           lda   $C892;     /* Load incoming frame number */
0751   BECA75           ldx   $CA75;     /* Load addr of 1st frame */
0754   6D07      P0754: tst   7,x;       /* Quit when last frame found */
0756   2C02             bge   P075A;
0758   4F               clra;            /* Flag that no match was found */
0759   39               rts;
075A   A107      P075A: cmpa  7,x;       /* Do frame numbers match? */
075C   260B             bne   P0769;     /* Nope; try next frame */
075E   1F13             tfr   x,u;       /* Yes, we want this frame */
0760   33C822           leau  0x22,u;    /* Get address of next frame */
0763   FFCA75           stu   $CA75;     /* Save the address of next frame */
0766   86FF             lda   #0xFF;     /* Flag that a match was found */
0768   39               rts;
0769   308822    P0769: leax  0x22,x;    /* Get address of next frame */
076C   20E6             bra   P0754;     /* Keep trying */

                 /*
                  * ResetFramePtrToPlayersFirstFrame()
                  *
                  * Exit:
                  *   C875-C876 = Ptr to player's first frame (C8D7)
                  *
                  * This function sets the frame ptr (CA75) used by
                  * LocateSpecificFrame(), to point to the player's
                  * first frame (C8D7).
                  */
                 ResetFramePtrToPlayersFirstFrame:
076E   8EC8D7           ldx   #0xC8D7;
0771   BFCA75           stx   $CA75;
0774   39               rts;

                 /*
                  * UpdatePlayersPosition()
                  *
                  * This function uses the joystick positions to update
                  * the position of the player's ship.  The joystick must
                  * be moved past a certain threshold, in order for the
                  * ship's position to be affected.  In addition, it will
                  * not allow the ship to move past certain side, top and
                  * bottom boundaries: top = 0x60, bottom = 0xA0,
                  * left = 0xBC and right = 0x54.
                  *
                  * It should be noted that moving the joystick up causes
                  * the ship to move down.
                  *
                  * All information for the player's ship is kept in the
                  * frame C8D7.
                  */
                 UpdatePlayersPosition:
0775   8EC8D7           ldx   #0xC8D7;     /* Load addr of players ship frame */
0778   A600             lda   0,x;         /* Load current y value */
077A   F6C81C           ldb   $C81C;       /* Load joystick up/down value */
077D   C130             cmpb  #0x30;       /* Check value against threshold 1 */
077F   2E0E             bgt   P078F;
0781   C1D0             cmpb  #0xD0;       /* Check value against threshold 2 */
0783   2E12             bgt   P0797;
0785   8160             cmpa  #0x60;       /* Update the y value only if the */
0787   2C0E             bge   P0797;       /* ship is not already at top.    */
0789   8B04             adda  #0x04;       /* y = y + 4 */
078B   A700             sta   0,x;         /* Save new y value */
078D   2008             bra   P0797;
078F   81A0      P078F: cmpa  #0xA0;       /* Update the y value only if the */
0791   2F04             ble   P0797;       /* ship is not already at bottom. */
0793   8BFC             adda  #0xFC;       /* y = y - 4 */
0795   A700             sta   0,x;         /* Save new y value */
0797   A601      P0797: lda   1,x;         /* Load current x value */
0799   F6C81B           ldb   $C81B;       /* Load joystick left/right value */
079C   C1D0             cmpb  #0xD0;       /* Check value against threshold 1 */
079E   2D0E             blt   P07AE;
07A0   C130             cmpb  #0x30;       /* Check value against threshold 2 */
07A2   2D12             blt   P07B6;
07A4   8154             cmpa  #0x54;       /* Update the x value only if the */
07A6   2C0E             bge   P07B6;       /* ship not already at right edge */
07A8   8B04             adda  #0x04;       /* x = x + 4 */
07AA   A701             sta   1,x;         /* Save new x value */
07AC   2008             bra   P07B6;
07AE   81BC      P07AE: cmpa  #0xBC;       /* Update the x value only if the */
07B0   2F04             ble   P07B6;       /* ship not already at left edge  */
07B2   8BFC             adda  #0xFC;       /* x = x - 4 */
07B4   A701             sta   1,x;         /* Save new x value */
07B6   39        P07B6: rts;

                 /*
                  * ProcessEnemyStar()
                  *
                  * Entry:
                  *   C8BB = Enemy ship velocity
                  *
                  * This function takes care of processing the enemy star.
                  * If the enemy star is visible, then it will update its
                  * position, and check to see if it has moved off of the
                  * top of the display, or if it has collided with the
                  * player's ship.  If it has moved off of the top of the
                  * display, then a new enemy star will start up.  When
                  * a collision occurs, an explosion pattern is displayed.
                  *
                  * All information about the enemy star is kept in the
                  * frame C95F.
                  */
                 ProcessEnemyStar:
07B7   7FC8BC           clr   $C8BC;     /* Clear the 'collision' flag */
07BA   7DC889           tst   $C889;     /* Is enemy star active */
07BD   2601             bne   P07C0;
07BF   39               rts;
07C0   8EC95F    P07C0: ldx   #0xC95F;   /* Get ptr to enemy star frame */
07C3   A607             lda   7,x;       /* See if the enemy star is visible? */
07C5   8510             bita  #0x10;
07C7   271C             beq   P07E5;
07C9   6D881E           tst   0x1E,x;    /* No; restart a new one only if */
07CC   2701             beq   P07CF;     /* it did not collide with player */
07CE   39               rts;
07CF   F6C8D8    P07CF: ldb   $C8D8;     /* Restart new enemy star */
07D2   8680             lda   #0x80;     /* Set x position = players position */
07D4   ED00             std   0,x;       /* Force y = bottom of screen */
07D6   8603             lda   #0x03;
07D8   A707             sta   7,x;       /* Frame # = 3 (Red) */
07DA   CC16F7           ldd   #EnemyStarVectorList;
07DD   ED09             std   9,x;       /* Set vector list 1 */
07DF   ED0B             std   11,x;      /* Set vector list 2 */
07E1   6F881E           clr   0x1E,x;    /* Clear 'collision' flag */
07E4   39               rts;
07E5   E600      P07E5: ldb   0,x;
07E7   FBC8BB           addb  $C8BB;     /* Get velocity value */
07EA   E700             stb   0,x;       /* Update y value */
07EC   6D881E           tst   0x1E,x;
07EF   271A             beq   P080B;     /* If the enemy star collided with */
07F1   6A881F           dec   0x1F,x;    /* the player, then display an     */
07F4   2719             beq   P080F;     /* explosion pattern for a while.  */
07F6   CE1AD4           ldu   #ExplosionVectorTable;
07F9   B6C826           lda   $C826;
07FC   8403             anda  #0x03;     /* Animate, by changing between 1 */
07FE   48               asla;            /* of 4 possible explosion patterns */
07FF   ECC6             ldd   a,u;
0801   ED09             std   9,x;       /* Set the explosion vector list */
0803   ED0B             std   11,x;      /* Set the explosion vector list */
0805   CC01BC           ldd   #NE_DrawDots;
0808   ED8820           std   0x20,x;    /* Set the drawing function */
080B   C178      P080B: cmpb  #0x78;     /* Has the enemy star reached the */
080D   2F05             ble   P0814;     /* top of the screen?             */
080F   8613      P080F: lda   #0x13;     /* Yes; so tag the frame as no */
0811   A707             sta   7,x;       /* longer being visible.       */
0813   39               rts;
0814   BD1224    P0814: jsr   $CheckForCollisionWithPlayer;
0817   4D               tsta;
0818   2601             bne   P081B;
081A   39               rts;
081B   73C8BC    P081B: com   $C8BC;     /* Flag collision with player */
081E   63881E           com   0x1E,x;    /* Flag collision with player */
0821   8618             lda   #0x18;     /* Set timer value, which controls */
0823   A7881F           sta   0x1F,x;    /* duration of the explosion. */
0826   39               rts;

                 /*
                  * DrawPlayersShipExploding()
                  *
                  * This function drawing the player's ship exploding
                  * into multiple pieces.  It does this by incrementing
                  * the alternate scale factor (C8B7); drawing continues
                  * until the alternate scale factor reaches 0x3000, at
                  * which point we set a flag (C8B9) to indicate that we
                  * are done, and it is time to move onto the next phase.
                  */
                 DrawPlayersShipExploding:
0827   8EC8D7           ldx   #0xC8D7;   /* Get addr of player's frame */
082A   7FC8B9           clr   $C8B9;     /* Clear 'player done exploding flag */
082D   FCC8B7           ldd   $C8B7;     /* Has scale factor surpassed the */
0830   10833000         cmpd  #0x3000;   /* upper bound?                   */
0834   2304             bls   P083A;
0836   73C8B9           com   $C8B9;     /* Flag that we are done */
0839   39               rts;
083A   C30180    P083A: addd  #0x0180;
083D   FDC8B7           std   $C8B7;      /* Increment alternate scale factor */
0840   CC0186           ldd   #DrawWithMixedScaleFactors;
0843   FDC8F7           std   $C8F7;      /* Set drawing function */
0846   CC1941           ldd   #PlayersShipExploding_1;
0849   FDC8E0           std   $C8E0;      /* Set vector list 1 */
084C   CC1981           ldd   #PlayersShipExploding_2;
084F   FDC8E2           std   $C8E2;      /* Set vector list 2 */
0852   39               rts;

                 /*
                  * InitializePlayerFrame()
                  *
                  * This function initializes all of the important fields
                  * within the frame used to display the player's ship.
                  *
                  * All information about the players ship is kept in the
                  * frame C8D7.
                  */
                 InitializePlayerFrame:
0853   8EC8D7           ldx   #0xC8D7;    /* Get addr of player's frame */
0856   6F881B           clr   0x1B,x;     /* Flag player in enemy passage */
0859   8603             lda   #0x03;      /* Set frame # = 3 (red) */
085B   A707             sta   7,x;
085D   CC0151           ldd   #DrawVectorList;
0860   ED8820           std   0x20,x;     /* Set drawing function */
0863   8640             lda   #0x40;
0865   A702             sta   2,x;
0867   863F             lda   #0x3F;
0869   A703             sta   3,x;        /* Set scale factor */
086B   C680             ldb   #0x80;
086D   3D               mul;
086E   48               asla;
086F   A702             sta   2,x;
0871   8610             lda   #0x10;
0873   A705             sta   5,x;        /* Set embedded obj's scale factor */
0875   867F             lda   #0x7F;
0877   A708             sta   8,x;        /* Set intensity */
0879   CC190D           ldd   #PlayersShip_2;
087C   ED09             std   9,x;        /* Set vector list 1 */
087E   CC18D9           ldd   #PlayersShip_1;
0881   ED0B             std   11,x;       /* Set vector list 2 */
0883   4F               clra;
0884   5F               clrb;
0885   ED00             std   0,x;        /* Set initial position = (0,0) */
0887   6F881E           clr   0x1E,x;
088A   39               rts;

                 /*
                  * SetEnemyShipInfo()
                  * SetEnemyShipInfo_2()
                  *
                  * These function determines which enemy ship needs to be
                  * displayed for this level, along with the characteristics
                  * of the enemy ship.  It loads all of these characteristics
                  * into memory locations, which are used by other functions.
                  *
                  * SetEnemyShipInfo() also initializes some of the player's
                  * flags, and is usually called at the start of a new turn
                  * for the player (i.e. after a crash).  SetEnemyShipInfo_2()
                  * does not initialize the player's flags, and is usually
                  * called when the player has completed travel through
                  * the fuel passage, and is about to enter the next enemy
                  * passage.
                  *
                  * All information about the players ship is kept in the
                  * frame C8D7.
                  */
                 SetEnemyShipInfo:
088B   CC3000           ldd   #0x3000;
088E   FDCA77           std   $CA77;      /* Give player 0x30 units of fuel */
0891   7FCA7D           clr   $CA7D;      /* Clear 'out of fuel' flag */
0894   7FCA7E           clr   $CA7E;      /* Clear 'low on fuel' flag */
0897   CC0080           ldd   #0x0080;
089A   CC0100           ldd   #0x0100;
089D   FDCA7A           std   $CA7A;      /* Set fuel usage to 1 unit */
                 SetEnemyShipInfo_2:
08A0   B6C8BD           lda   $C8BD;      /* Calculate the number of fuel */
08A3   48               asla;             /* objects for this next level. */
08A4   8B05             adda  #0x05;      /* # = (level * 2) + 5 */
08A6   B7C883           sta   $C883;
08A9   C604             ldb   #0x04;      /* Based on the current level, */
08AB   B6C8BD           lda   $C8BD;      /* set $C884 to either 4 or 5 */
08AE   8105             cmpa  #0x05;
08B0   2301             bls   P08B3;
08B2   5C               incb;
08B3   F7C884    P08B3: stb   $C884;
08B6   B6C8BD           lda   $C8BD;
08B9   8B06             adda  #0x06;
08BB   B7C885           sta   $C885;     /* Enemy ship count = level + 6 */
08BE   B6C8BD           lda   $C8BD;     /* Determine which enemy ship will */
08C1   810E             cmpa  #0x0E;     /* used at this level: 0 - 14      */
08C3   2302             bls   P08C7;
08C5   860E             lda   #0x0E;
08C7   C60D      P08C7: ldb   #0x0D;     /* 0x0D = size of each table entry */
08C9   3D               mul;             /* Get index into enemy ship array */
08CA   CE08FD           ldu   #EnemyShipInfoTable;
08CD   33CB             leau  d,u;       /* Get ptr to the enemy ship data */
08CF   ECC1             ldd   ,u++;
08D1   FDC886           std   $C886;     /* BCD value of enemy ship */
08D4   A6C0             lda   ,u+;
08D6   B7C882           sta   $C882;
08D9   A6C0             lda   ,u+;
08DB   B7C889           sta   $C889;     /* Flag; do/don't display enemy star */
08DE   ECC1             ldd   ,u++;
08E0   FDC88A           std   $C88A;     /* Save vector list ptr */
08E3   ECC1             ldd   ,u++;
08E5   FDC88D           std   $C88D;     /* Save x movement delta */
08E8   ECC1             ldd   ,u++;
08EA   FDC88F           std   $C88F;     /* Save y movement delta */
08ED   A6C0             lda   ,u+;
08EF   B7C8A4           sta   $C8A4;
08F2   A6C0             lda   ,u+;       /* Number of hits needed to destroy */
08F4   B7C88C           sta   $C88C;     /* the warlord ship. */
08F7   A6C0             lda   ,u+;
08F9   B7C880           sta   $C880;     /* Save contact tolerance value */
08FC   39               rts;

                 /*
                  * The following is an array of 17 blocks of data, each block
                  * of which is 0x0D (13) bytes long.  It appears that the
                  * code only uses the first 16 blocks (0 - 0x0E).  Each block
                  * contains the following information:
                  *
                  *      ------------------------
                  *    0 |    BCD Value of      |
                  *      ---                  ---
                  *    1 |     Enemy Ship       |
                  *      ------------------------
                  *    2 |                      |
                  *      ------------------------
                  *    3 |  Display Enemy Star  |
                  *      ------------------------
                  *    4 |     Enemy Ship       |
                  *      ---                  ---
                  *    5 |    Vector Table      |
                  *      ------------------------
                  *    6 |     X Movement       |
                  *      ---                  ---
                  *    7 |       Delta          |
                  *      ------------------------
                  *    8 |     Y Movement       |
                  *      ---                  ---
                  *    9 |       Delta          |
                  *      ------------------------
                  *   10 |                      |
                  *      ------------------------
                  *   11 | Number of hits to    |
                  *      | destroy warlord ship |
                  *      ------------------------
                  *   12 |  Contact Tolerance   |
                  *      ------------------------
                  */
                 EnemyShipInfoTable:
08FD   00               .word 0x0050;
08FF   08               .byte 0x08;
0900   00               .byte 0x00;
0901   17               .word EnemyShip1VectorTable;
0903   00               .word 0x0000;
0905   00               .word 0x0000;
0907   08               .byte 0x08;
0908   00               .byte 0x00;
0909   10               .byte 0x10;

090A   01               .word 0x0100;
090C   0C               .byte 0x0C;
090D   FF               .byte 0xFF;
090E   17               .word EnemyShip2VectorTable;
0910   01               .word 0x0100;
0912   FF               .word 0xFF00;
0914   08               .byte 0x08;
0915   00               .byte 0x00;
0916   0E               .byte 0x0E;

0917   01               .word 0x0150;
0919   10               .byte 0x10;
091A   FF               .byte 0xFF;
091B   17               .word EnemyShip3VectorTable;
091D   FE               .word 0xFE00;
091F   02               .word 0x0200;
0921   09               .byte 0x09;
0922   05               .byte 0x05;
0923   0C               .byte 0x0C;

0924   02               .word 0x0200;
0926   18               .byte 0x18;
0927   FF               .byte 0xFF;
0928   18               .word EnemyShip4VectorTable;
092A   03               .word 0x0300;
092C   03               .word 0x0300;
092E   09               .byte 0x09;
092F   00               .byte 0x00;
0930   0C               .byte 0x0C;

0931   02               .word 0x0250;
0933   20               .byte 0x20;
0934   FF               .byte 0xFF;
0935   17               .word EnemyShip1VectorTable;
0937   04               .word 0x0400;
0939   01               .word 0x0100;
093B   0A               .byte 0x0A;
093C   00               .byte 0x00;
093D   0B               .byte 0x0B;

093E   03               .word 0x0300;
0940   30               .byte 0x30;
0941   FF               .byte 0xFF;
0942   17               .word EnemyShip2VectorTable;
0944   02               .word 0x0200;
0946   04               .word 0x0400;
0948   0A               .byte 0x0A;
0949   07               .byte 0x07;
094A   0A               .byte 0x0A;

094B   03               .word 0x0350;
094D   48               .byte 0x48;
094E   FF               .byte 0xFF;
094F   17               .word EnemyShip3VectorTable;
0951   FC               .word 0xFC00;
0953   01               .word 0x0100;
0955   0B               .byte 0x0B;
0956   00               .byte 0x00;
0957   0A               .byte 0x0A;

0958   04               .word 0x0400;
095A   60               .byte 0x60;
095B   FF               .byte 0xFF;
095C   18               .word EnemyShip4VectorTable;
095E   04               .word 0x0400;
0960   03               .word 0x0300;
0962   0B               .byte 0x0B;
0963   00               .byte 0x00;
0964   09               .byte 0x09;

0965   04               .word 0x0450;
0967   7F               .byte 0x7F;
0968   FF               .byte 0xFF;
0969   17               .word EnemyShip1VectorTable;
096B   02               .word 0x0200;
096D   04               .word 0x0400;
096F   0C               .byte 0x0C;
0970   09               .byte 0x09;
0971   09               .byte 0x09;

0972   05               .word 0x0500;
0974   7F               .byte 0x7F;
0975   FF               .byte 0xFF;
0976   17               .word EnemyShip2VectorTable;
0978   01               .word 0x0100;
097A   04               .word 0x0400;
097C   0C               .byte 0x0C;
097D   00               .byte 0x00;
097E   08               .byte 0x08;

097F   05               .word 0x0500;
0981   7F               .byte 0x7F;
0982   FF               .byte 0xFF;
0983   17               .word EnemyShip3VectorTable;
0985   01               .word 0x0100;
0987   04               .word 0x0400;
0989   0C               .byte 0x0C;
098A   00               .byte 0x00;
098B   08               .byte 0x08;

098C   05               .word 0x0500;
098E   7F               .byte 0x7F;
098F   FF               .byte 0xFF;
0990   18               .word EnemyShip4VectorTable;
0992   01               .word 0x0100;
0994   04               .word 0x0400;
0996   0C               .byte 0x0C;
0997   0B               .byte 0x0B;
0998   07               .byte 0x07;

0999   05               .word 0x0500;
099B   7F               .byte 0x7F;
099C   FF               .byte 0xFF;
099D   17               .word EnemyShip1VectorTable;
099F   01               .word 0x0100;
09A1   04               .word 0x0400;
09A3   0C               .byte 0x0C;
09A4   00               .byte 0x00;
09A5   07               .byte 0x07;

09A6   05               .word 0x0500;
09A8   7F               .byte 0x7F;
09A9   FF               .byte 0xFF;
09AA   17               .word EnemyShip2VectorTable;
09AC   01               .word 0x0100;
09AE   04               .word 0x0400;
09B0   0C               .byte 0x0C;
09B1   00               .byte 0x00;
09B2   06               .byte 0x06;

09B3   05               .word 0x0500;
09B5   7F               .byte 0x7F;
09B6   FF               .byte 0xFF;
09B7   17               .word EnemyShip3VectorTable;
09B9   01               .word 0x0100;
09BB   04               .word 0x0400;
09BD   0C               .byte 0x0C;
09BE   0D               .byte 0x0D;
09BF   06               .byte 0x06;

09C0   05               .word 0x0500;
09C2   7F               .byte 0x7F;
09C3   FF               .byte 0xFF;
09C4   18               .word EnemyShip4VectorTable;
09C6   01               .word 0x0100;
09C8   04               .word 0x0400;
09CA   0C               .byte 0x0C;
09CB   0D               .byte 0x0D;
09CC   06               .byte 0x06;

09CD   05               .word 0x0500;
09CF   7F               .byte 0x7F;
09D0   FF               .byte 0xFF;
09D1   18               .word EnemyShip4VectorTable;
09D3   01               .word 0x0100;
09D5   04               .word 0x0400;
09D7   0C               .byte 0x0C;
09D8   0D               .byte 0x0D;
09D9   06               .byte 0x06;

                 /*
                  * InitEnemyStarFrame()
                  *
                  * This function fills in all of the important fields
                  * within the frame used to hold the enemy star information.
                  *
                  * All information about the enemy star is kept in the
                  * frame C95F.
                  */
                 InitEnemyStarFrame:
09DA   8602             lda   #0x02;
09DC   B7C8BB           sta   $C8BB;     /* Set enemy star velocity */
09DF   8EC95F           ldx   #0xC95F;   /* Get ptr to enemy star frame */
09E2   6F881B           clr   0x1B,x;    /* Flag player in enemy passage */
09E5   8613             lda   #0x13;
09E7   A707             sta   7,x;       /* Frame # = 0x13 (red,not visible */
09E9   7DC889           tst   $C889;     /* Enemy star enabled? */
09EC   2601             bne   P09EF;
09EE   39               rts;             /* No */
09EF   CC0151    P09EF: ldd   #DrawVectorList;
09F2   ED8820           std   0x20,x;    /* Set drawing function */
09F5   8640             lda   #0x40;
09F7   A702             sta   2,x;
09F9   863F             lda   #0x3F;
09FB   A703             sta   3,x;       /* Set scale factor */
09FD   C680             ldb   #0x80;
09FF   3D               mul;
0A00   48        P0A00: asla;
0A01   A702             sta   2,x;
0A03   8610             lda   #0x10;
0A05   A705             sta   5,x;       /* Set embedded obj's scale factor */
0A07   867F             lda   #0x7F;
0A09   A708             sta   8,x;       /* Set intensity */
0A0B   6F881E           clr   0x1E,x;    /* Clear collision flag */
0A0E   39               rts;

                 /*
                  * InitAllBulletFrames()
                  *
                  * This function fills in the important fields within the
                  * 3 frames used to hold information about bullets fired
                  * by the user.
                  *
                  * The 3 bullet frames are located at C8F9, C91B and C93D.
                  */
                 InitAllBulletFrames:
0A0F   8EC8F9           ldx   #0xC8F9;   /* Ptr to first bullet frame */
0A12   8611             lda   #0x11;     /* Frame # 0x11 = Blue,not visible */
0A14   BD0A26           jsr   $InitOneBulletFrame;
0A17   8612             lda   #0x12;     /* Frame # 0x12 = Green,not visible */
0A19   BD0A26           jsr   $InitOneBulletFrame;
0A1C   8613             lda   #0x13;     /* Frame # 0x13 = Red,not visible */
0A1E   BD0A26           jsr   $InitOneBulletFrame;
0A21   86FF             lda   #0xFF;
0A23   A707             sta   7,x;       /* Tag end of frame stack */
0A25   39               rts;

                 /*
                  * InitOneBulletFrame()
                  *
                  * Entry:
                  *   a = frame identifier (color & visibility)
                  *   x = frame ptr
                  *
                  * Exit:
                  *   x = ptr to next frame in stack
                  *
                  * This function fills in the important fields within the
                  * next frame used to hold information about a bullet
                  */
                 InitOneBulletFrame:
0A26   A707             sta   7,x;       /* Set frame number */
0A28   CC0151           ldd   #DrawVectorList;
0A2B   ED8820           std   0x20,x;    /* Set drawing function */
0A2E   6F881B           clr   0x1B,x;    /* Flag player in enemy passage */
0A31   8610             lda   #0x10;
0A33   A705             sta   5,x;       /* Set embedded obj's scale factor */
0A35   CC0AC3           ldd   #BulletVectorList;
0A38   ED09             std   9,x;       /* Set vector list 1 */
0A3A   ED0B             std   11,x;      /* Set vector list 2 */
0A3C   308822           leax  0x22,x;    /* Advance frame pointer */
0A3F   39               rts;

                 /*
                  * InitEnemyShipFrame()
                  *
                  * Entry:
                  *   C88A-C88B = ptr to enemy ship vector list
                  *   C88D-C88E = x movement delta
                  *   C88F-C890 = y movement delta
                  *
                  * This function fills in the important fields within the
                  * frame used to hold information about the enemy ship.
                  *
                  * All information about the enemy ship is kept in the
                  * frame located at C981.
                  */
                 InitEnemyShipFrame:
0A40   8EC981           ldx   #0xC981;    /* Ptr to enemy ship frame */
0A43   8612             lda   #0x12;
0A45   A707             sta   7,x;        /* Frame# = 0x12 (green,not visible */
0A47   8601             lda   #0x01;
0A49   A705             sta   5,x;        /* Set embedded obj's scale factor */
0A4B   FCC88A           ldd   $C88A;
0A4E   ED09             std   9,x;        /* Set vector list 1 */
0A50   ED0B             std   11,x;       /* Set vector list 2 */
0A52   CC0151           ldd   #DrawVectorList;
0A55   ED8820           std   0x20,x;     /* Set drawing function */
0A58   FCC88D           ldd   $C88D;
0A5B   ED8811           std   0x11,x;     /* Set x movement delta */
0A5E   FCC88F           ldd   $C88F;
0A61   ED8813           std   0x13,x;     /* Set y movement delta */
0A64   CC0000           ldd   #0x0000;
0A67   ED0D             std   13,x;       /* Set 16-bit x position */
0A69   ED0F             std   15,x;       /* Set 16-bit y position */
0A6B   CCC03F           ldd   #0xC03F;    /* Bounding box limits: -64, -63 */
0A6E   ED8815           std   0x15,x;     /* Set x bounding box limits */
0A71   ED8817           std   0x17,x;     /* Set y bounding box limits */
0A74   308822           leax  0x22,x;     /* Point to the next frame */
0A77   86FF             lda   #0xFF;
0A79   A707             sta   7,x;        /* Tag frame as end of stack frame */
0A7B   39               rts;

                 /*
                  * UpdateBulletFrames()
                  *
                  * This function updates the scale factor and the intensity
                  * for each of the 3 bullet frames.  It also checks to see
                  * if the player has requested that another bullet be fired.
                  *
                  * All information about the 3 bullets are kept in the
                  * frames located at C8F9, C91B and C93.
                  */
                 UpdateBulletFrames:
0A7C   8EC8F9           ldx   #0xC8F9;    /* Get addr of 1st bullet frame */
0A7F   8D0B             bsr   UpdateFrameStateAndCheckForFireRequest;
0A81   308822           leax  0x22,x;     /* Get addr of 2nd bullet frame */
0A84   8D06             bsr   UpdateFrameStateAndCheckForFireRequest;
0A86   308822           leax  0x22,x;     /* Get addr of 3rd bullet frame */
0A89   8D01             bsr   UpdateFrameStateAndCheckForFireRequest;
0A8B   39               rts;

                 /*
                  * UpdateFrameStateAndCheckForFireRequest()
                  *
                  * Entry:
                  *   x = ptr to bullet frame
                  *
                  * This function updates the scale factor and the intensity
                  * for one bullet frame.  It will also check to see if the
                  * player has requested that another bullet be fired; if
                  * so, then the next available frame will be used.  Only
                  * 1 bullet per pass will be fired.
                  */
                 UpdateFrameStateAndCheckForFireRequest:
0A8C   E607             ldb   7,x;
0A8E   C510             bitb  #0x10;     /* Is frame visible? */
0A90   2722             beq   P0AB4;     /* Update only visible frames */
0A92   7DC815           tst   $C815;     /* If the frame is not visible, then */
0A95   271D             beq   P0AB4;     /* see if players is trying to fire. */
0A97   7DC8F5           tst   $C8F5;     /* Is player dead? */
0A9A   2618             bne   P0AB4;
0A9C   C40F             andb  #0x0F;
0A9E   E707             stb   7,x;       /* No; flag frame as active again */
0AA0   863F             lda   #0x3F;
0AA2   A703             sta   3,x;       /* Set scale factor */
0AA4   FCC8D7           ldd   $C8D7;
0AA7   ED00             std   0,x;       /* Starting pos = player's pos */
0AA9   7FC815           clr   $C815;     /* Only allow 1 bullet per pass */
0AAC   8620             lda   #0x20;
0AAE   BAC89B           ora   $C89B;
0AB1   B7C89B           sta   $C89B;     /* Force 'bullet fired' sound */
0AB4   A603      P0AB4: lda   3,x;       /* Update the scale factor and */
0AB6   8101             cmpa  #0x01;     /* intensity, unless scale = 1 */
0AB8   2304             bls   P0ABE;     /* which means no longer visible */
0ABA   BD0705           jsr   $UpdateFramesScaleAndIntensity;
0ABD   39               rts;
0ABE   CA10      P0ABE: orb   #0x10;
0AC0   E707             stb   7,x;       /* Tag frame as no longer visible */
0AC2   39               rts;

                 BulletVectorList:
0AC3   FF               .byte 0xFF;
0AC4   00               .byte 0x00;
0AC5   00               .byte 0x00;
0AC6   01               .byte 0x01;

                 /*
                  * ProcessEnemyShip()
                  *
                  * This function takes care of updating the information in
                  * the enemy ship frame (C981).  If the enemy ship is not
                  * currently visible, then it will start a new one going.
                  * If the enemy ship has collided with the player or a
                  * bullet, then it will display an explosion pattern for
                  * a given period of time.  It will update the position,
                  * scale factor and intensity for the frame, to give it
                  * the appearance of moving towards the player.  When the
                  * enemy ship reaches the front of the display, it will
                  * stop being displayed.
                  */
                 ProcessEnemyShip:
0AC7   7FC888           clr   $C888;      /* Clear 'enemy destroyed' flag */
0ACA   7FC8BA           clr   $C8BA;      /* Clear the collision flag */
0ACD   8EC981           ldx   #0xC981;
0AD0   E607             ldb   7,x;        /* If the frame is not visible, */
0AD2   C510             bitb  #0x10;      /* then we may need to restart  */
0AD4   2750             beq   P0B26;      /* the next enemy ship.         */
0AD6   10BEC8AB         ldy   $C8AB;
0ADA   108C0DE2         cmpy  #InEnemyPassage;
0ADE   2701             beq   P0AE1;
0AE0   39               rts;
0AE1   C40F      P0AE1: andb  #0x0F;      /* Start a new enemy ship */
0AE3   E707             stb   7,x;        /* Reset frame to be visible */
0AE5   CC0175           ldd   #DrawAnimatedVectorList_Slow;
0AE8   ED8820           std   0x20,x;     /* Set drawing function */
0AEB   CC0100           ldd   #0x0100;
0AEE   ED03             std   3,x;        /* Set 16-bit scale factor */
0AF0   B6C89B           lda   $C89B;
0AF3   8A02             ora   #0x02;
0AF5   B7C89B           sta   $C89B;      /* Force sound to be made */
0AF8   B6C89F           lda   $C89F;
0AFB   8A02             ora   #0x02;
0AFD   B7C89F           sta   $C89F;
0B00   B6C87D           lda   $C87D;      /* Use the system loop counter to */
0B03   843F             anda  #0x3F;      /* generate a y value in the range */
0B05   7DC87D           tst   $C87D;      /* of +-0x3F. */
0B08   2B01             bmi   P0B0B;
0B0A   40               nega;
0B0B   F6C87E    P0B0B: ldb   $C87E;      /* Use the system loop counter to */
0B0E   C43F             andb  #0x3F;      /* generate an x value in the range */
0B10   7DC87E           tst   $C87E;      /* of +-0x3F. */
0B13   2B01             bmi   P0B16;
0B15   50               negb;
0B16   ED00      P0B16: std   0,x;       /* Set (y,x) position */
0B18   A70F             sta   15,x;      /* Set backup y position */
0B1A   E70D             stb   13,x;      /* Set backup x position */
0B1C   6F881E           clr   0x1E,x;
0B1F   FCC88A           ldd   $C88A;     /* Get ememy ship vector list ptr */
0B22   ED09             std   9,x;       /* Set vector list 1 */
0B24   ED0B             std   11,x;      /* Set vector list 2 */
0B26   3410      P0B26: pshs  x;
0B28   3003             leax  3,x;
0B2A   B6C8A4           lda   $C8A4;
0B2D   BD06E0           jsr   $P06E0;
0B30   3510             puls  x;
0B32   A603             lda   3,x;
0B34   E603             ldb   3,x;
0B36   50               negb;
0B37   C010             subb  #0x10;
0B39   F7C8A3           stb   $C8A3;
0B3C   8190             cmpa  #0x90;     /* If the scale factor > 0x90, then */
0B3E   230F             bls   P0B4F;     /* stop displaying the frame.       */
0B40   A607             lda   7,x;
0B42   8A10             ora   #0x10;
0B44   A707             sta   7,x;       /* Tag frame as no longer visible */
0B46   B6C89F           lda   $C89F;
0B49   84FD             anda  #0xFD;
0B4B   B7C89F           sta   $C89F;
0B4E   39               rts;
0B4F   C680      P0B4F: ldb   #0x80;
0B51   3D               mul;
0B52   48               asla;
0B53   A702             sta   2,x;
0B55   A603             lda   3,x;       /* Calculate the new intensity = */
0B57   8B40             adda  #0x40;     /* (scale + 0x40);  if rollover  */
0B59   2A02             bpl   P0B5D;     /* occurs, then use 0x7F.        */
0B5B   867F             lda   #0x7F;
0B5D   A708      P0B5D: sta   8,x;       /* Set the intensity */
0B5F   A603             lda   3,x;
0B61   44               lsra;
0B62   44               lsra;
0B63   A705             sta   5,x;       /* Set embedded obj's intensity */
0B65   6D881E           tst   0x1E,x;    /* Collision with player? */
0B68   271C             beq   P0B86;
0B6A   6A881F           dec   0x1F,x;    /* Yes; has the explosion timer */
0B6D   2710             beq   P0B7F;     /* finished?                    */
0B6F   CE1AD4           ldu   #ExplosionVectorTable;
0B72   B6C826           lda   $C826;     /* Keep displaying the explosion */
0B75   8403             anda  #0x03;     /* pattern, rotating between the */
0B77   48               asla;            /* 4 possible patterns.          */
0B78   ECC6             ldd   a,u;
0B7A   ED09             std   9,x;       /* Set vector list 1 */
0B7C   ED0B             std   11,x;      /* Set vector list 2 */
0B7E   39               rts;
0B7F   A607      P0B7F: lda   7,x;
0B81   8A10             ora   #0x10;
0B83   A707             sta   7,x;       /* Tag frame as no longer visible */
0B85   39               rts;
0B86   BD11C8    P0B86: jsr   $CheckForCollisionWithBullets;
0B89   4D               tsta;
0B8A   260C             bne   P0B98;
0B8C   BD1224           jsr   $CheckForCollisionWithPlayer;
0B8F   4D               tsta;
0B90   2601             bne   P0B93;
0B92   39               rts;
0B93   86FF      P0B93: lda   #0xFF;     /* Collided with the player */
0B95   B7C8BA           sta   $C8BA;
0B98   B6C89B    P0B98: lda   $C89B;     /* Collided with player or bullet */
0B9B   8A80             ora   #0x80;
0B9D   B7C89B           sta   $C89B;     /* Force a sound to occur */
0BA0   7FC8A2           clr   $C8A2;     /* Set sound characteristics index */
0BA3   63881E           com   0x1E,x;    /* Flag that a collision occurred */
0BA6   8612             lda   #0x12;
0BA8   A7881F           sta   0x1F,x;    /* Set explosion duration timer */
0BAB   CC1ADC           ldd   #ExplosionPattern_1;
0BAE   ED09             std   9,x;       /* Set vector list 1 */
0BB0   ED0B             std   11,x;      /* Set vector list 2 */
0BB2   CC01BC           ldd   #NE_DrawDots;
0BB5   ED8820           std   0x20,x;    /* Set the drawing function */
0BB8   7CC8B1           inc   $C8B1;     /* Bump 'enemy ships destroyed' cntr */
0BBB   73C888           com   $C888;     /* Flag that enemy was destroyed */
0BBE   39               rts;

                 /*
                  * UpdateEnemyShipPosition()
                  *
                  * Entry:
                  *   x = ptr to enemy ship frame
                  *
                  * This function calculates the new position for the current
                  * enemy ship.  As it turns out, enemy ships are restricted
                  * to the box defined by the points [ in (y,x) format]:
                  *
                  *      (63,63),(-63,63),(-63,-63),(63,-63)
                  *
                  * The frame structure contains working copies of the
                  * current 16-bit x position (13,x) and the 16-bit y
                  * position (15,x), along with the 16-bit x delta
                  * value (0x11,x) and the 16-bit y delta value (0x13,x).
                  * The bounding box for the enemy ship is defined in the
                  * frame structure [x min in (0x15,x), x max in (0x16,x),
                  * y min in (0x17,x) and y max in (0x18,x)].  Each pass
                  * through, the deltas are added (or subtracted) from
                  * the current position, and if the edge of the bounding
                  * box is reached, the delta is negated, thus forcing
                  * the ship to start moving in the other direction.
                  */
                 UpdateEnemyShipPosition:
0BBF   EC8811           ldd   0x11,x;     /* Load x movement delta */
0BC2   2C16             bge   P0BDA;
0BC4   E30D             addd  13,x;       /* Subtract delta from current x */
0BC6   ED0D             std   13,x;       /* position. */
0BC8   A18815           cmpa  0x15,x;     /* Surpassed lower x bounds? */
0BCB   2E16             bgt   P0BE3;      /* No */
0BCD   EC8811    P0BCD: ldd   0x11,x;     /* Yes; so we need to negate */
0BD0   43               coma;             /* the x movement delta, to */
0BD1   53               comb;             /* force movement back in the */
0BD2   C30001           addd  #0x0001;    /* other direction. */
0BD5   ED8811           std   0x11,x;
0BD8   2009             bra   P0BE3;
0BDA   E30D      P0BDA: addd  13,x;       /* Add delta to current x position */
0BDC   ED0D             std   13,x;
0BDE   A18816           cmpa  0x16,x;     /* Surpassed upper x bounds? */
0BE1   2CEA             bge   P0BCD;      /* Yes; so negate x movement delta */
0BE3   EC8813    P0BE3: ldd   0x13,x;     /* Load y movement delta */
0BE6   2C16             bge   P0BFE;
0BE8   E30F             addd  15,x;       /* Subtract delta from current y */
0BEA   ED0F             std   15,x;       /* position. */
0BEC   A18817           cmpa  0x17,x;     /* Surpassed lower y bounds? */
0BEF   2E16             bgt   P0C07;      /* No */
0BF1   EC8813    P0BF1: ldd   0x13,x;     /* Yes; so we need to negate */
0BF4   43               coma;             /* the y movement delta, to */
0BF5   53               comb;             /* force movement back in the */
0BF6   C30001           addd  #0x0001;    /* other direction. */
0BF9   ED8813           std   0x13,x;
0BFC   2009             bra   P0C07;
0BFE   E30F      P0BFE: addd  15,x;       /* Add delta to current y position */
0C00   ED0F      P0C00: std   15,x;
0C02   A18818           cmpa  0x18,x;     /* Surpassed upper y bounds? */
0C05   2CEA             bge   P0BF1;      /* Yes; so negate y movement delta */
0C07   A60F      P0C07: lda   15,x;       /* Load the updated y position */
0C09   E60D             ldb   13,x;       /* Load the updated x position */
0C0B   ED00             std   0,x;        /* Update the frame's position */
0C0D   39               rts;

                 /*
                  * StartupNewGame()
                  *
                  * This function takes care of starting the ball rolling
                  * when a new game is to be started.
                  */
                 StartupNewGame:
0C0E   8601             lda   #0x01;
0C10   B7C89B           sta   $C89B;   /* Force background noise */
0C13   7FC89F           clr   $C89F;
0C16   7FC881           clr   $C881;
0C19   7FC8B1           clr   $C8B1;   /* Clear 'enemy ships destroyed cntr */
0C1C   7FC8BD           clr   $C8BD;
0C1F   BD111B           jsr   $InitPlayersScoreAndShipCount;
0C22   8E0D4F           ldx   #PrepareToEnterEnemyPassage;
0C25   BFC8AB           stx   $C8AB;   /* Set the indirect jump ptr */
0C28   7E0D4F           jmp   $PrepareToEnterEnemyPassage;

                 /*
                  * PrepareToFightWarlordShip()
                  *
                  * This function simply initializes the bullet buffers and
                  * the Warlord ship frames, before the player faces off
                  * with the Warlord ship.
                  */
                 PrepareToFightWarlordShip:
0C2B   86FF             lda   #0xFF;
0C2D   B7CA7D           sta   $CA7D;   /* Flag that player is out of fuel */
0C30   7FC8AF           clr   $C8AF;   /* Don't draw enemy passage walls */
0C33   BD0A0F           jsr   $InitAllBulletFrames;
0C36   BD1D42           jsr   $InitWarlordShipBulletFrame;
0C39   BD1C5E           jsr   $InitWarlordShipFrames;
0C3C   39               rts;

                 /*
                  * PlayerFightingWarlordShip()
                  *
                  * This is the main processing function for when the user is
                  * fighting the Warlord ship.  It checks for the player
                  * firing, and updates all bullet, player and Warlord ship
                  * positions.  It also checks for collisions and for
                  * destruction of the Warlord ship.
                  */
                 PlayerFightingWarlordShip:
0C3D   BD0775           jsr   $UpdatePlayersPosition;
0C40   BD0A7C           jsr   $UpdateBulletFrames;
0C43   BD1B7C           jsr   $UpdateWarlordShipFrames;
0C46   BD1CE5           jsr   $ProcessWarlordShipBullet;
0C49   8EC95F           ldx   #0xC95F;   /* Warlord ship bullet hit player? */
0C4C   BD1224           jsr   $CheckForCollisionWithPlayer;
0C4F   4D               tsta;
0C50   262C             bne   P0C7E;
0C52   B6C984           lda   $C984;     /* No; see if the warlord ship has */
0C55   B1C8DA           cmpa  $C8DA;     /* collided with the player. */
0C58   2424             bhs   P0C7E;
0C5A   B6C8B1           lda   $C8B1;     /* No; has player hit warlord ship */
0C5D   B1C88C           cmpa  $C88C;     /* enough times to destroy it? */
0C60   2534             blo   P0C96;
0C62   CC0500           ldd   #0x0500;   /* Yes; add 500 to player's score */
0C65   BD050F           jsr   $CheckForScoreOver20000;
0C68   4F               clra;
0C69   5F               clrb;
0C6A   FDC8B7           std   $C8B7;     /* Clear alternate scale factor */
0C6D   8E0C97           ldx   #WarlordShipDestroyed;
0C70   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0C73   B6C8C4           lda   $C8C4;     /* See if a bonus ship can be */
0C76   8139             cmpa  #0x39;     /* awarded; it will be, only if */
0C78   2403             bhs   P0C7D;     /* the player currently has < 9 */
0C7A   7CC8C4           inc   $C8C4;     /* ships.                       */
0C7D   39        P0C7D: rts;
0C7E   4F        P0C7E: clra;            /* Player hit by warlord ship bullet */
0C7F   5F               clrb;            /* or collided with warlord ship. */
0C80   FDC8B7           std   $C8B7;     /* Clear alternate scale factor */
0C83   8E0CE5           ldx   #PlayerCollidedWithWarlordShip;
0C86   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0C89   8680             lda   #0x80;
0C8B   BAC89B           ora   $C89B;
0C8E   B7C89B           sta   $C89B;     /* Force noise to occur */
0C91   8601             lda   #0x01;
0C93   B7C8A2           sta   $C8A2;     /* Set sound characteristics index */
0C96   39        P0C96: rts;

                 /*
                  * WarlordShipDestroyed()
                  *
                  * This is the main processing function for when the player
                  * has destroyed the Warlord ship.  It draws the Warlord
                  * ship exploding into pieces.  Once that completes, it
                  * prepares the player for the fuel passage.
                  */
                 WarlordShipDestroyed:
0C97   BD0775           jsr   $UpdatePlayersPosition;
0C9A   BD0A7C           jsr   $UpdateBulletFrames;
0C9D   8610             lda   #0x10;
0C9F   B7C966           sta   $C966;
0CA2   FCC8B7           ldd   $C8B7;
0CA5   C30001           addd  #0x0001;
0CA8   FDC8B7           std   $C8B7;     /* Increment alternate scale factor */
0CAB   10830020         cmpd  #0x0020;
0CAF   230A             bls   P0CBB;     /* Draw exploding Warlord ship */
0CB1   7FCA7D           clr   $CA7D;     /* Clear 'out of fuel' flag */
0CB4   7FC8B1           clr   $C8B1;     /* Clear warlord ship hit counter */
0CB7   7E0F92           jmp   $PrepareForFuelPassage;  /* Goto fuel passage */
0CBA   39        P0CBA: rts;
0CBB   B6C826    P0CBB: lda   $C826;     /* Update the warlord ship frames */
0CBE   8401             anda  #0x01;     /* only on every other pass. */
0CC0   2701             beq   P0CC3;
0CC2   39               rts;
0CC3   CE0CDB    P0CC3: ldu   #WarlordShipBeingDestroyedOffsets;
0CC6   8EC981           ldx   #0xC981;   /* Get warship target frame */
0CC9   A607      P0CC9: lda   7,x;       /* Is the frame visible? */
0CCB   2C01             bge   P0CCE;
0CCD   39               rts;             /* No */
0CCE   EC00      P0CCE: ldd   0,x;       /* Yes; force the warlord ship */
0CD0   ABC0             adda  ,u+;       /* pieces to drift apart, since */
0CD2   EBC0             addb  ,u+;       /* it has been destroyed.  Do this */
0CD4   ED00             std   0,x;       /* by un-syncing the (y,x) values */
0CD6   308822           leax  0x22,x;    /* for the warlord ship frames. */
0CD9   20EE             bra   P0CC9;

                 WarlordShipBeingDestroyedOffsets:
0CDB   00               .byte 0x00;      /* Warlord ship frame 1 y offset */
0CDC   00               .byte 0x00;      /* Warlord ship frame 1 x offset */
0CDD   FC               .byte 0xFC;      /* Warlord ship frame 2 y offset */
0CDE   FC               .byte 0xFC;      /* Warlord ship frame 2 x offset */
0CDF   FC               .byte 0xFC;      /* Warlord ship frame 3 y offset */
0CE0   FC               .byte 0xFC;      /* Warlord ship frame 3 x offset */
0CE1   03               .byte 0x03;      /* Warlord ship frame 4 y offset */
0CE2   03               .byte 0x03;      /* Warlord ship frame 4 x offset */
0CE3   00               .byte 0x00;      /* Warlord ship frame 5 y offset */
0CE4   FD               .byte 0xFD;      /* Warlord ship frame 5 x offset */

                 /*
                  * PlayerCollidedWithWarlordShip()
                  *
                  * This is the main processing function for when the player
                  * has collided with the Warlord ship.  It removes all
                  * bullets and shows both the player and the Warlord ship
                  * as exploding.  Otherwise, if the player has any ships
                  * left, it prepares the player to again face off against
                  * the Warship.  If the game is over, then it checks for
                  * a new high score, and waits to start a new game.
                  *
                  */
                 PlayerCollidedWithWarlordShip:
0CE5   BD0827           jsr   $DrawPlayersShipExploding;
0CE8   BD1B7C           jsr   $UpdateWarlordShipFrames;
0CEB   8610             lda   #0x10;
0CED   B7C900           sta   $C900;     /* Force bullet 1 frame invisible */
0CF0   B7C922           sta   $C922;     /* Force bullet 2 frame invisible */
0CF3   B7C944           sta   $C944;     /* Force bullet 3 frame invisible */
0CF6   B7C966           sta   $C966;     /* Force warlord bullet invisible */
0CF9   7DC8B9           tst   $C8B9;     /* Player done exploding */
0CFC   2719             beq   P0D17;
0CFE   BD0853           jsr   $InitializePlayerFrame;  /* Yes; restart player */
0D01   B6C8C4           lda   $C8C4;     /* If the player has no more ships */
0D04   8130             cmpa  #0x30;     /* left, then enter a waiting state */
0D06   2710             beq   P0D18;     /* waiting for new game to start. */
0D08   7AC8C4           dec   $C8C4;     /* Decrement player's ship count */
0D0B   CC0070           ldd   #0x0070;
0D0E   FDC8AD           std   $C8AD;     /* Set startup delay timer */
0D11   8E0D34           ldx   #RestartPlayerAgainstWarlordShip;
0D14   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0D17   39        P0D17: rts;
0D18   BD0853    P0D18: jsr   $InitializePlayerFrame;  /* Game Over */
0D1B   8E0ED3           ldx   #WaitForGameRestart;
0D1E   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0D21   CECBEB           ldu   #0xCBEB;
0D24   8EC8C6           ldx   #0xC8C6;   /* See if player had new hi score */
0D27   BDF8D8           jsr   $check_4_new_hi_score;
0D2A   CC0460           ldd   #0x0460;
0D2D   FDC8AD           std   $C8AD;     /* Set startup delay timer */
0D30   7FC89F           clr   $C89F;
0D33   39               rts;

                 /*
                  * RestartPlayerAgainstWarlordShip()
                  *
                  * This is the main processing function for when the player
                  * has been killed by the Warship, and is again about to
                  * face off against the Warship.  It delays briefly, before
                  * moving onto the next stage.
                  */
                 RestartPlayerAgainstWarlordShip:
0D34   BD0775           jsr   $UpdatePlayersPosition;
0D37   BD10A7           jsr   $InitScoreAndShipCountFrames_2;
0D3A   FCC8AD           ldd   $C8AD;     /* Decrement startup delay timer */
0D3D   830001           subd  #0x0001;   /* Don't start the action until */
0D40   FDC8AD           std   $C8AD;     /* the delay timer has expired. */
0D43   2609             bne   P0D4E;
0D45   BD0C2B           jsr   $PrepareToFightWarlordShip;
0D48   8E0C3D           ldx   #PlayerFightingWarlordShip;
0D4B   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0D4E   39        P0D4E: rts;

                 /*
                  * PrepareToEnterEnemyPassage()
                  *
                  * This is the main processing function for when the user
                  * is just entering the enemy passage.  It initializes the
                  * player frames, sets up a delay timer, and flags that the
                  * passage walls should not initially be drawn.  It then
                  * moves the player onto the next state, which is entering
                  * the enemy passage.
                  */
                 PrepareToEnterEnemyPassage:
0D4F   BD0853           jsr   $InitializePlayerFrame;
0D52   BD088B           jsr   $SetEnemyShipInfo;
0D55   BD10A7           jsr   $InitScoreAndShipCountFrames_2;
0D58   CC0070           ldd   #0x0070;
0D5B   FDC8AD           std   $C8AD;     /* Set startup delay timer */
0D5E   7FC8AF           clr   $C8AF;     /* Don't draw enemy passage walls */
0D61   8E0D68           ldx   #ApproachEnemyPassage;
0D64   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0D67   39               rts;

                 /*
                  * ApproachEnemyPassage()
                  *
                  * This is the main processing function for when the player
                  * is approaching the enemy passage area.  Initially, only
                  * the player's ship is drawn.  After some delay, the
                  * state will be changed to the next state, which will
                  * enable the drawing of the passage walls.
                  */
                 ApproachEnemyPassage:
0D68   BD0775           jsr   $UpdatePlayersPosition;
0D6B   BD08A0           jsr   $SetEnemyShipInfo_2;
0D6E   FCC8AD           ldd   $C8AD;    /* Decrement startup delay timer */
0D71   830001           subd  #0x0001;  /* Don't start the action until */
0D74   FDC8AD           std   $C8AD;    /* the delay timer has expired. */
0D77   261D             bne   P0D96;
0D79   8E0D97    P0D79: ldx   #EnterEnemyPassage;
0D7C   BFC8AB           stx   $C8AB;    /* Set the indirect jump ptr */
0D7F   73C8AF           com   $C8AF;    /* Enable drawing enemy passage walls */
0D82   4F               clra;
0D83   5F               clrb;
0D84   FDC8CE           std   $C8CE;
0D87   FDC8D1           std   $C8D1;
0D8A   CC0300           ldd   #0x0300;
0D8D   FDC8D4           std   $C8D4;
0D90   BD0676           jsr   $P0676;
0D93   BD0A0F           jsr   $InitAllBulletFrames;
0D96   39        P0D96: rts;

                 /*
                  * EnterEnemyPassage()
                  *
                  * This is the main processing function for when the player
                  * is entering into the enemy passage area.  It updates
                  * any bullets fired by the player, and updates the position
                  * of both the enemy ship and the enemy star, before moving
                  * onto the next state (in the enemy passage).
                  */
                 EnterEnemyPassage:
0D97   BD0775           jsr   $UpdatePlayersPosition;
0D9A   BD0676           jsr   $P0676;
0D9D   B6C8D4           lda   $C8D4;
0DA0   8180             cmpa  #0x80;
0DA2   2318             bls   P0DBC;
0DA4   BD0A0F           jsr   $InitAllBulletFrames;
0DA7   BD09DA           jsr   $InitEnemyStarFrame;
0DAA   BD0A40           jsr   $InitEnemyShipFrame;
0DAD   BD0A7C           jsr   $UpdateBulletFrames;
0DB0   BD07B7           jsr   $ProcessEnemyStar;
0DB3   BD0AC7           jsr   $ProcessEnemyShip;
0DB6   8E0DE2           ldx   #InEnemyPassage;
0DB9   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0DBC   39        P0DBC: rts;

                 /*
                  * PlayerHasRunOutOfFuel()
                  *
                  * This is the main processing function for when the player
                  * has completely run out of fuel, while in the enemy
                  * passage.  It continues to update any bullets fired by
                  * the player, and the positions of the enemy star and ship.
                  * It also forces the player's ship to slowly sink downward,
                  * due to lack of fuel, and to explode, when it comes in
                  * contact with the ground.
                  */
                 PlayerHasRunOutOfFuel:
0DBD   BD0676           jsr   $P0676;
0DC0   BD07B7           jsr   $ProcessEnemyStar;
0DC3   BD0AC7           jsr   $ProcessEnemyShip;
0DC6   BD0A7C           jsr   $UpdateBulletFrames;
0DC9   7AC8D7           dec   $C8D7;      /* Force player to sink towards */
0DCC   B6C8D7           lda   $C8D7;      /* ground (he has no fuel).  When */
0DCF   81A0             cmpa  #0xA0;      /* the ship reaches the ground, */
0DD1   2C0E             bge   P0DE1;      /* it's all over. */
0DD3   4F               clra;
0DD4   5F               clrb;
0DD5   FDC8B7           std   $C8B7;      /* Clear alternate scale factor */
0DD8   8E0E7B           ldx   #PlayerCollidedWithEnemyShip;
0DDB   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0DDE   BD0E3F           jsr   $P0E3F;
0DE1   39        P0DE1: rts;

                 /*
                  * InEnemyPassage()
                  *
                  * This is the main processing function for when the player
                  * is in the enemy passage.  It updates everything on the
                  * display (bullets, player, enemy star, enemy ship, fuel
                  * levels, etc).  It also checks to see if there have been
                  * any collisions, or if the player has destroyed the last
                  * enemy ship for this level (at which point you advance to
                  * to the next state).
                  */
                 InEnemyPassage:
0DE2   7FC8A5           clr   $C8A5;
0DE5   BD060B           jsr   $UpdatePlayersFuelLevel;
0DE8   BD0676           jsr   $P0676;
0DEB   BD0775           jsr   $UpdatePlayersPosition;
0DEE   BD07B7           jsr   $ProcessEnemyStar;
0DF1   BD0A7C           jsr   $UpdateBulletFrames;
0DF4   7DCA7D           tst   $CA7D;      /* Is player out of fuel? */
0DF7   270F             beq   P0E08;
0DF9   B6C89B           lda   $C89B;      /* Yes */
0DFC   8A40             ora   #0x40;
0DFE   B7C89B           sta   $C89B;      /* Force a sound to occur */
0E01   8E0DBD           ldx   #PlayerHasRunOutOfFuel;
0E04   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0E07   39        P0E07: rts;
0E08   BD0AC7    P0E08: jsr   $ProcessEnemyShip;
0E0B   8EC981           ldx   #0xC981;    /* Get ptr to enemy ship frame */
0E0E   BD0BBF    P0E0E: jsr   $UpdateEnemyShipPosition;
0E11   7DC8BA           tst   $C8BA;     /* Did player collide w/ enemy ship? */
0E14   261B             bne   P0E31;
0E16   7DC8BC           tst   $C8BC;     /* Did player collide w/ enemy star? */
0E19   2616             bne   P0E31;
0E1B   B6C8D7           lda   $C8D7;     /* Check to see if the player has */
0E1E   8150             cmpa  #0x50;     /* run into a passage wall, or has */
0E20   2C33             bge   P0E55;     /* run aground. */
0E22   81BC             cmpa  #0xBC;
0E24   2F2F             ble   P0E55;
0E26   B6C8D8           lda   $C8D8;
0E29   8154             cmpa  #0x54;
0E2B   2C04             bge   P0E31;
0E2D   81BC             cmpa  #0xBC;
0E2F   2E24             bgt   P0E55;
0E31   73C8A5    P0E31: com   $C8A5;     /* Impact has occurred! */
0E34   4F               clra;
0E35   5F               clrb;
0E36   FDC8B7           std   $C8B7;      /* Clear alternate scale factor */
0E39   8E0E7B           ldx   #PlayerCollidedWithEnemyShip;
0E3C   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0E3F   8680      P0E3F: lda   #0x80;
0E41   BAC89B           ora   $C89B;
0E44   B7C89B           sta   $C89B;      /* Force a sound to occur */
0E47   8601             lda   #0x01;
0E49   B7C8A2           sta   $C8A2;      /* Set sound characteristics index */
0E4C   B6C89F    P0E4C: lda   $C89F;
0E4F   84FB             anda  #0xFB;
0E51   B7C89F           sta   $C89F;
0E54   39               rts;
0E55   B6C8B1    P0E55: lda   $C8B1;
0E58   B1C885           cmpa  $C885;      /* All enemy ships destroyed? */
0E5B   251D             blo   P0E7A;
0E5D   7FC8B1           clr   $C8B1;      /* Clear enemy destroyed counter */
0E60   BD08A0           jsr   $SetEnemyShipInfo_2;
0E63   7CC8BD           inc   $C8BD;
0E66   BD0E4C           jsr   $P0E4C;
0E69   8E0F63           ldx   #LevelCompleted;
0E6C   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0E6F   CC008C           ldd   #0x008C;
0E72   FDC8AD           std   $C8AD;      /* Set the delay timer */
0E75   86FF             lda   #0xFF;
0E77   B7C900           sta   $C900;
0E7A   39        P0E7A: rts;

                 /*
                  * PlayerCollidedWithEnemyShip()
                  *
                  * This is the main processing function for when the player
                  * has collided with something.  It draws the player's ship
                  * exploding, and then determines whether the player should
                  * reenter the enemy passage (if he has any ships left), or
                  * whether the game is over, and we should wait to start
                  * a new one.
                  */
                 PlayerCollidedWithEnemyShip:
0E7B   8681             lda   #0x81;      /* Disable all but normal game */
0E7D   B4C89F           anda  $C89F;      /* noise & 'player hit' sound. */
0E80   B7C89F    P0E80: sta   $C89F;
0E83   7DC8A5           tst   $C8A5;
0E86   2603             bne   P0E8B;
0E88   BD0676           jsr   $P0676;
0E8B   BD0827    P0E8B: jsr   $DrawPlayersShipExploding;
0E8E   BD0AC7           jsr   $ProcessEnemyShip;
0E91   BD07B7           jsr   $ProcessEnemyStar;
0E94   BD0A7C           jsr   $UpdateBulletFrames;
0E97   7DC8B9           tst   $C8B9;      /* Is the player's ship done */
0E9A   2710             beq   P0EAC;      /* exploding? */
0E9C   B6C8C4           lda   $C8C4;      /* If the player's ship count */
0E9F   8130             cmpa  #0x30;      /* is now 0, then the game is */
0EA1   270A             beq   P0EAD;      /* over.  Otherwise, prepare  */
0EA3   7AC8C4           dec   $C8C4;      /* to try again.              */
0EA6   8E0D4F           ldx   #PrepareToEnterEnemyPassage;
0EA9   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0EAC   39        P0EAC: rts;
0EAD   BD0853    P0EAD: jsr   $InitializePlayerFrame;
0EB0   8E0ED3           ldx   #WaitForGameRestart;
0EB3   BFC8AB           stx   $C8AB;      /* Set the indirect jump ptr */
0EB6   CECBEB           ldu   #0xCBEB;    /* See if the player set a new */
0EB9   8EC8C6           ldx   #0xC8C6;    /* high score for the game.  */
0EBC   BDF8D8           jsr   $check_4_new_hi_score;
0EBF   CC0460           ldd   #0x0460;
0EC2   FDC8AD           std   $C8AD;      /* Set the restart delay timer */
0EC5   7FC89F           clr   $C89F;      /* Disable all sounds */
0EC8   39               rts;

                 GameOverString:
0EC9   47               .string "GAME OVER",0x80;

                 /*
                  * WaitForGameRestart()
                  *
                  * This function waits until either the restart delay timer
                  * expires, or the player presses a button, at which time it
                  * will start up a new game.  While it is waiting for the
                  * timer to expire or the player to press a button, it will
                  * display the last player's score (in frame C91B), the
                  * 'GAME OVER' string (in frame C8F9) * and the player's
                  * ship (in frame C8D7).
                  */
                 WaitForGameRestart:
0ED3   B6C80F           lda   $C80F;     /* If any buttons are pressed, */
0ED6   840F             anda  #0x0F;     /* then restart game.          */
0ED8   260B             bne   P0EE5;
0EDA   FCC8AD           ldd   $C8AD;     /* Decrement restart delay timer, */
0EDD   830001           subd  #0x0001;   /* and restart game when it goes  */
0EE0   FDC8AD           std   $C8AD;     /* to 0.                          */
0EE3   2607             bne   P0EEC;
0EE5   8E0C0E    P0EE5: ldx   #StartupNewGame;
0EE8   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0EEB   39               rts;
0EEC   7FC8AF    P0EEC: clr   $C8AF;     /* Don't draw enemy passage walls */
0EEF   86FF             lda   #0xFF;
0EF1   B7CA7D           sta   $CA7D;     /* Flag that player is out of fuel */
0EF4   B7CA7E           sta   $CA7E;     /* Flag that player is low on fuel */
0EF7   CCF840           ldd   #0xF840;
0EFA   FDC82A           std   $C82A;     /* Set string height and width */
0EFD   8EC8F9           ldx   #0xC8F9;   /* Get ptr to frame C8F9 */
0F00   6F881B           clr   0x1B,x;    /* Flag player in enemy passage */
0F03   8602      P0F03: lda   #0x02;
0F05   A707             sta   7,x;       /* Frame # = 2 (green) */
0F07   CC0596           ldd   #NE_DisplayString;
0F0A   ED8820           std   0x20,x;    /* Set drawing function */
0F0D   8620             lda   #0x20;
0F0F   A702             sta   2,x;
0F11   867F             lda   #0x7F;
0F13   A703             sta   3,x;       /* Set scale factor */
0F15   8610             lda   #0x10;
0F17   A705             sta   5,x;       /* Set embedded obj's scale factor */
0F19   867F             lda   #0x7F;
0F1B   A708             sta   8,x;       /* Set intensity */
0F1D   CC0EC9           ldd   #GameOverString;
0F20   ED09             std   9,x;       /* Set vector list 1 */
0F22   CC0EC9           ldd   #GameOverString;
0F25   ED0B             std   11,x;      /* Set vector list 2 */
0F27   CCE0D0           ldd   #0xE0D0;
0F2A   ED00             std   0,x;       /* Set (y,x) position */
0F2C   308822           leax  0x22,x;    /* Get ptr to next frame */
0F2F   6F881B           clr   0x1B,x;    /* Flag player in enemy passage */
0F32   8601             lda   #0x01;
0F34   A707             sta   7,x;       /* Frame # = 1 (blue) */
0F36   CC0596           ldd   #NE_DisplayString;
0F39   ED8820           std   0x20,x;    /* Set drawing function */
0F3C   8620             lda   #0x20;
0F3E   A702             sta   2,x;
0F40   867F             lda   #0x7F;
0F42   A703             sta   3,x;       /* Set scale factor */
0F44   8610             lda   #0x10;
0F46   A705             sta   5,x;       /* Set embedded obj's scale factor */
0F48   867F             lda   #0x7F;
0F4A   A708             sta   8,x;       /* Set intensity */
0F4C   CCC8C6           ldd   #0xC8C6;   /* Player's score string */
0F4F   ED09             std   9,x;       /* Set vector list 1 */
0F51   CCC8C6           ldd   #0xC8C6;   /* Player's score string */
0F54   ED0B             std   11,x;      /* Set vector list 2 */
0F56   CC6020           ldd   #0x6020;
0F59   ED00             std   0,x;       /* Set (y,x) position */
0F5B   308822           leax  0x22,x;    /* Get ptr to next frame */
0F5E   86FF             lda   #0xFF;     /* Mark the next frame as the */
0F60   A707             sta   7,x;       /* end of the active frame stack */
0F62   39               rts;

                 /*
                  * LevelCompleted()
                  *
                  * This is the main processing function for when the player
                  * has completed a level.  It determines whether the player
                  * will enter the fuel passage, or go up against the
                  * Warlord ship.
                  */
                 LevelCompleted:
0F63   B6C89F           lda   $C89F;
0F66   84FD             anda  #0xFD;
0F68   B7C89F           sta   $C89F;
0F6B   B6C89B           lda   $C89B;
0F6E   84FD             anda  #0xFD;
0F70   B7C89B           sta   $C89B;     /* Force off enemy ship sound */
0F73   86FF             lda   #0xFF;
0F75   B7C900           sta   $C900;     /* Force off player's bullet frames */
0F78   BD068F           jsr   $P068F;
0F7B   7DC8B2           tst   $C8B2;
0F7E   2727             beq   P0FA7;
0F80   7DC88C           tst   $C88C;
0F83   270D             beq   PrepareForFuelPassage;
0F85   7FC8B1           clr   $C8B1;     /* Clear 'warlord hit' counter */
0F88   BD0C2B           jsr   $PrepareToFightWarlordShip;
0F8B   8E0C3D           ldx   #PlayerFightingWarlordShip;
0F8E   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0F91   39               rts;

                 /*
                  * PrepareForFuelPassage()
                  *
                  * This function prepares for the player to enter the fuel
                  * passage.  It sets up the frames used for drawing the
                  * fuel walls and cannisters, and moves the player into
                  * the next state (in the fuel passage).
                  */
                 PrepareForFuelPassage:
0F92   BD1440           jsr   $InitAllFuelFrames;
0F95   BD1381           jsr   $UpdateAllFuelFrames;
0F98   8E0FA8           ldx   #PlayerInFuelPassage;
0F9B   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
0F9E   7FC8AF           clr   $C8AF;     /* Don't draw enemy passage walls */
0FA1   7FC8B4           clr   $C8B4;     /* Clear fuel object counter */
0FA4   7FC8B3           clr   $C8B3;
0FA7   39        P0FA7: rts;

                 /*
                  * PlayerInFuelPassage()
                  *
                  * This is the main processing function for when the
                  * player is in the fuel passage.
                  * When the user has destroyed all of the enemy ships
                  * in the enemy passage, he will advance to the next
                  * fuel passage.  This function takes care up updating
                  * the player's position, checking to see if he has
                  * picked up any fuel cannisters, and checking to see
                  * if the player has flown through a fuel wall opening,
                  * or been destroyed by flying into a fuel wall.  It
                  * will also detect when the user has completed the fuel
                  * passage, and will advance the user onto the next enemy
                  * passage level.
                  */
                 PlayerInFuelPassage:
0FA8   7FCA7E           clr   $CA7E;     /* Prevent fuel bar from flashing */
0FAB   7FC8B0           clr   $C8B0;     /* Clear 'fuel picked up' flag */
0FAE   7FC8B2           clr   $C8B2;     /* Clear 'player thru level' flag */
0FB1   BD0775           jsr   $UpdatePlayersPosition;
0FB4   BD1260           jsr   $CheckForContactWithFuelObjects;
0FB7   2C19             bge   P0FD2;     /* Did player hit a fuel wall? */
0FB9   CC100A           ldd   #PlayerHitFuelWall;   /* Yes; ship destroyed */
0FBC   FDC8AB           std   $C8AB;     /* Set the indirect jump ptr */
0FBF   4F               clra;
0FC0   5F               clrb;
0FC1   FDC8B7           std   $C8B7;     /* Clear alternate scale factor */
0FC4   8680             lda   #0x80;
0FC6   BAC89B           ora   $C89B;
0FC9   B7C89B           sta   $C89B;     /* Force sound to occur */
0FCC   8601             lda   #0x01;
0FCE   B7C8A2           sta   $C8A2;     /* Set sound characteristics index */
0FD1   39               rts;
0FD2   8102      P0FD2: cmpa  #0x02;     /* Did player pickup fuel cannister? */
0FD4   2619             bne   P0FEF;
0FD6   73C8B0           com   $C8B0;     /* Yes; flag that fuel was picked up */
0FD9   B6C89B           lda   $C89B;
0FDC   8A10             ora   #0x10;
0FDE   B7C89B           sta   $C89B;     /* Force sound to occur */
0FE1   B6CA77           lda   $CA77;
0FE4   8B05             adda  #0x05;     /* Add 5 units of fuel to the */
0FE6   8160             cmpa  #0x60;     /* player's reserves, upto a max */
0FE8   2302             bls   P0FEC;     /* of 0x60 fuel units. */
0FEA   8660             lda   #0x60;
0FEC   B7CA77    P0FEC: sta   $CA77;
0FEF   8101      P0FEF: cmpa  #0x01;     /* Did player pass thru opening? */
0FF1   2608             bne   P0FFB;
0FF3   B6C89B           lda   $C89B;     /* Yes */
0FF6   8A08             ora   #0x08;
0FF8   B7C89B           sta   $C89B;     /* Force sound to occur */
0FFB   BD1381    P0FFB: jsr   $UpdateAllFuelFrames;
0FFE   7DC8B2           tst   $C8B2;     /* Did player complete fuel passage? */
1001   2706             beq   P1009;
1003   BD08A0           jsr   $SetEnemyShipInfo_2;  /* Yes; move onto next */
1006   7E0D79           jmp   $P0D79;    /* enemy passage level. */
1009   39        P1009: rts;

                 /*
                  * PlayerHitFuelWall()
                  *
                  * This is the main processing function for when the
                  * player has collided with one of the fuel walls.
                  * It displays the exploding player's ship.
                  * When the explosion finishes, it decides whether the
                  * the game is over (player has no more ships), or
                  * whether the player can reenter the fuel passage.  If
                  * the player is going to reenter the fuel passage, then
                  * all of the fuel objects will be temporarily forced off,
                  * to give the illusion that the player is reentering
                  * where he left off; the fuel object will eventually be
                  * redisplayed.
                  */
                 PlayerHitFuelWall:
100A   BD0827           jsr   $DrawPlayersShipExploding;
100D   7DC8B9           tst   $C8B9;     /* Ship done exploding? */
1010   2738             beq   P104A;
1012   B6C8C4           lda   $C8C4;     /* Yes; see if the player has any */
1015   8130             cmpa  #0x30;     /* ships left.  If not, then the */
1017   2603             bne   P101C;     /* game is over.                 */
1019   7E0EAD           jmp   $P0EAD;    /* Game Over */
101C   7AC8C4    P101C: dec   $C8C4;     /* Decrement player's ship count */
101F   8E1059           ldx   #PrepareToReenterFuelPassage;
1022   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
1025   BD0853           jsr   $InitializePlayerFrame;
1028   8630             lda   #0x30;
102A   B7CA77           sta   $CA77;     /* Start player with 0x30 fuel units */
102D   BD10A2           jsr   $InitScoreAndShipCountFrames_1;
1030   CC0070           ldd   #0x0070;
1033   FDC8AD           std   $C8AD;     /* Set delay timer */
1036   8EC900           ldx   #0xC900;   /* Force all 4 fuel frames invisible */
1039   8D10             bsr   ForceFuelWallFrameInvisible;
103B   308822           leax  0x22,x;
103E   8D0B             bsr   ForceFuelWallFrameInvisible;
1040   308822           leax  0x22,x;
1043   8D06             bsr   ForceFuelWallFrameInvisible;
1045   308822           leax  0x22,x;
1048   8D01             bsr   ForceFuelWallFrameInvisible;
104A   39        P104A: rts;

                 /*
                  * ForceFuelWallFrameInvisible()
                  *
                  * Entry:
                  *   x = ptr to frame #
                  *
                  * After the player hits a fuel wall, we want to temporarily
                  * turn off the remaining fuel objects; after the user
                  * restarts in the fuel passage, the fuel objects will
                  * again become visible (though with different scale factors).
                  *
                  * This function looks at the incoming frame #, and if it
                  * is the 'end of frame stack' marker, then it changes the
                  * frame # from 0xFF to 0x1F.  Otherwise, it simply makes
                  * the frame invisible, by or'ing in 0x10.  By changing the
                  * 'end of frame stack' marker, this code will allow the
                  * frames beyond it to be displayed; in this case, the
                  * frames beyond contain the players ship count & score.
                  */
                 ForceFuelWallFrameInvisible:
104B   A600             lda   0,x;
104D   2C05             bge   P1054;
104F   861F             lda   #0x1F;
1051   A700             sta   0,x;
1053   39               rts;
1054   8A10      P1054: ora   #0x10;
1056   A700             sta   0,x;
1058   39               rts;

                 /*
                  * PrepareToReenterFuelPassage()
                  *
                  * This is the main processing function for when
                  * the player is preparing to reenter the fuel passage,
                  * after the player has crashed into one of the fuel walls.
                  * Before entering the fuel passage, it
                  * will wait for the delay timer to elapse, at which
                  * point it will reenable all of the fuel object frames.
                  * It will also reset the scale factor for the first
                  * fuel object (the wall into which the player crashed)
                  * so that the fuel wall starts slightly back down the
                  * fuel passage; it will also update all of the other
                  * fuel object frames, so that they too are proportionally
                  * back down the fuel passage.
                  */
                 PrepareToReenterFuelPassage:
1059   BD0775           jsr   $UpdatePlayersPosition;
105C   FCC8AD           ldd   $C8AD;     /* Decrement the delay timer, and */
105F   830001           subd  #0x0001;   /* do nothing until the timer     */
1062   FDC8AD           std   $C8AD;     /* counts down to 0.              */
1065   262A             bne   P1091;
1067   8EC900           ldx   #0xC900;   /* Reenable the 4 fuel object frames */
106A   8D26             bsr   RestoreFuelWallFrameStatus;
106C   308822           leax  0x22,x;
106F   8D21             bsr   RestoreFuelWallFrameStatus;
1071   308822           leax  0x22,x;
1074   8D1C             bsr   RestoreFuelWallFrameStatus;
1076   308822           leax  0x22,x;
1079   8D17             bsr   RestoreFuelWallFrameStatus;
107B   308822           leax  0x22,x;
107E   86FF             lda   #0xFF;     /* Set the 'end of frame stack' */
1080   A700             sta   0,x;
1082   CC0800           ldd   #0x0800;   /* Reset 1st fuel wall's scale */
1085   FDC8FE           std   $C8FE;     /* factor. */
1088   BD1381           jsr   $UpdateAllFuelFrames;
108B   8E0FA8           ldx   #PlayerInFuelPassage;
108E   BFC8AB           stx   $C8AB;     /* Set the indirect jump ptr */
1091   39        P1091: rts;

                 /*
                  * RestoreFuelWallFrameStatus()
                  *
                  * Entry:
                  *   x = ptr to frame #
                  *
                  * This function will cause the fuel object frames to again
                  * become visible.  This happens after the player has crashed,
                  * and has then started to reenter the fuel passage.
                  *
                  * This function looks at the incoming frame #, and if it
                  * is set to the special tag 0x1F, then it resets it to 0xFF
                  * (the 'end of frame stack' marker).  Otherwise, it forces
                  * the frame to again be visible, by and'ing the frame
                  * number with 0x0F.
                  */
                 RestoreFuelWallFrameStatus:
1092   A600             lda   0,x;
1094   811F             cmpa  #0x1F;      /* Former end of frame stack? */
1096   2705             beq   P109D;
1098   840F             anda  #0x0F;      /* Nope, so make visible again */
109A   A700             sta   0,x;
109C   39               rts;
109D   86FF      P109D: lda   #0xFF;      /* Yes, so retag as end of stack */
109F   A700             sta   0,x;
10A1   39               rts;

                 /*
                  * InitScoreAndShipCountFrames_1()
                  * InitScoreAndShipCountFrames_2()
                  *
                  * These functions both fill in 2 frames with information
                  * for displaying the player's ship count and score.  The
                  * ship count goes into the first frame (in blue), while
                  * the score goes into the second frame (in green).
                  * InitScoreAndShipCountFrames_1() uses frames C981 & C9A3,
                  * while InitScoreAndShipCountFrames_2() uses frames C8F9 &
                  * C91B.
                  */
                 InitScoreAndShipCountFrames_1:
10A2   8EC981           ldx   #0xC981;    /* Use frames C981 & C9A3 */
10A5   2003             bra   P10AA;
                 InitScoreAndShipCountFrames_2:
10A7   8EC8F9           ldx   #0xC8F9;    /* Use frames C8F9 & C91B */
10AA   CCF840    P10AA: ldd   #0xF840;
10AD   FDC82A           std   $C82A;      /* Set string height & width */
10B0   6F881B           clr   0x1B,x;     /* Flag player in enemy passage */
10B3   8601             lda   #0x01;
10B5   A707             sta   7,x;        /* Frame # = 1 (blue) */
10B7   CC0596           ldd   #NE_DisplayString;
10BA   ED8820           std   0x20,x;     /* Set drawing function */
10BD   8620             lda   #0x20;
10BF   A702             sta   2,x;
10C1   867F             lda   #0x7F;
10C3   A703             sta   3,x;        /* Set scale factor */
10C5   8610             lda   #0x10;
10C7   A705             sta   5,x;        /* Set embedded obj's scale factor */
10C9   867F             lda   #0x7F;
10CB   A708             sta   8,x;        /* Set intensity */
10CD   CCC8BE           ldd   #0xC8BE;    /* Ptr to ship count string */
10D0   ED09             std   9,x;        /* Set vector list 1 */
10D2   CCC8BE           ldd   #0xC8BE;    /* Ptr to ship count string */
10D5   ED0B             std   11,x;       /* Set vector list 2 */
10D7   CC60B0           ldd   #0x60B0;
10DA   ED00             std   0,x;        /* Set (y,x) position */
10DC   308822           leax  0x22,x;     /* Get ptr to next frame */
10DF   6F881B           clr   0x1B,x;     /* Flag player in enemy passage */
10E2   8602             lda   #0x02;
10E4   A707             sta   7,x;        /* Frame # = 2 (green) */
10E6   CC0596           ldd   #NE_DisplayString;
10E9   ED8820           std   0x20,x;     /* Set drawing function */
10EC   8620             lda   #0x20;
10EE   A702             sta   2,x;
10F0   867F             lda   #0x7F;
10F2   A703             sta   3,x;        /* Set scale factor */
10F4   8610             lda   #0x10;
10F6   A705             sta   5,x;        /* Set embedded obj's scale factor */
10F8   867F             lda   #0x7F;
10FA   A708             sta   8,x;        /* Set intensity */
10FC   CCC8C6           ldd   #0xC8C6;    /* Ptr to player's score */
10FF   ED09             std   9,x;        /* Set vector list 1 */
1101   CCC8C6           ldd   #0xC8C6;    /* Ptr to player's score */
1104   ED0B             std   11,x;       /* Set vector list 2 */
1106   CC6020           ldd   #0x6020;
1109   ED00             std   0,x;        /* Set (y,x) position */
110B   308822           leax  0x22,x;     /* Get ptr to next frame */
110E   86FF             lda   #0xFF;
1110   A707             sta   7,x;        /* Tag as 'End of frame stack' */
1112   39               rts;

                 ShipCountString:
1113   53               .string "SHIPS 3",0x80;

                 /*
                  * InitPlayersScoreAndShipCount()
                  *
                  * This function initializes the buffers holding the player's
                  * ship count (C8BE), and the player's score (C8C6).
                  */
                 InitPlayersScoreAndShipCount:
111B   7FC8CD           clr   $C8CD;
111E   8E1113           ldx   #ShipCountString;
1121   CEC8BE           ldu   #0xC8BE;     /* Ptr to ship count buffer */
1124   EC81             ldd   ,x++;
1126   EDC1             std   ,u++;
1128   EC81             ldd   ,x++;
112A   EDC1             std   ,u++;
112C   EC81             ldd   ,x++;
112E   EDC1             std   ,u++;
1130   EC81             ldd   ,x++;
1132   EDC1             std   ,u++;        /* Set buffer to "SHIPS 3",0x80 */
1134   CC2020           ldd   #0x2020;
1137   8EC8C6           ldx   #0xC8C6;     /* Ptr to player's score buffer */
113A   ED81             std   ,x++;
113C   ED81             std   ,x++;
113E   A780             sta   ,x+;
1140   CC3080           ldd   #0x3080;
1143   ED00             std   0,x;         /* Set buffer to "     0",0x80 */
1145   39               rts;

                 /*
                  * DrawEnemyPassageWalls()
                  *
                  * Entry:
                  *   u = ptr to array of 2 ptrs, each pointing to a vector
                  *       list.
                  *
                  * This function draws the side walls within the enemy
                  * passage.  It only draws the walls on one side of the
                  * passage, since the color of the walls on the other
                  * side of the passage are a different color.  When drawing
                  * the walls (there are usually three), it will use the
                  * first vector ptr in the array, unless the scale factor
                  * for the segment is > 0x60, at which point it will draw
                  * using the second vector ptr.  The first vector ptr
                  * represents the full wall, while the second vector ptr
                  * is used when a wall is all the way up front, and is about
                  * to go off the front of the screen (thus, only a portion of
                  * the wall is still visible).
                  */
                 DrawEnemyPassageWalls:
1146   7DC8AF           tst   $C8AF;       /* Should enemy walls be drawn? */
1149   2601             bne   P114C;
114B   39               rts;               /* No */
114C   3420      P114C: pshs  y;           /* Yes */
114E   8603             lda   #0x03;
1150   B7C891           sta   $C891;       /* Set loop counter; 3 walls */
1153   108EC8D4         ldy   #0xC8D4;
1157   AE40      P1157: ldx   0,u;
1159   A620             lda   0,y;
115B   2709             beq   P1166;
115D   8160             cmpa  #0x60;       /* If scale <= 0x60 then draw */
115F   2302             bls   P1163;       /* the full wall, else draw only */
1161   AE42             ldx   2,u;         /* the partial wall */
1163   BD031D    P1163: jsr   $DrawOneEnemyPassageWall;
1166   313D      P1166: leay  -3,y;
1168   7AC891           dec   $C891;       /* Decrement loop counter */
116B   26EA             bne   P1157;       /* More walls to draw? */
116D   3520             puls  y;
116F   39               rts;

                 /*
                  * DrawFuelBar()
                  *
                  * This function draws the player's fuel bar (gauge).
                  * If the player is out of fuel, then the bar is not drawn.
                  * If the player is low on fuel, then the fuel bar will
                  * be forced to flash (by not drawing it on every pass
                  * through this function.  The amount of fuel the player
                  * has (in CA77) is actually the scale factor used to
                  * draw the fuel bar.
                  */
                 DrawFuelBar:
1170   7DCA7D           tst   $CA7D;       /* Is player out of fuel? */
1173   2701             beq   P1176;
1175   39               rts;               /* Yes */
1176   7DCA7E    P1176: tst   $CA7E;       /* No, but is player low on fuel? */
1179   2708             beq   P1183;
117B   B6C826           lda   $C826;       /* Yes; therefore, force the fuel */
117E   8410             anda  #0x10;       /* bar to flash, by not drawing */
1180   2701             beq   P1183;       /* it on every pass. */
1182   39               rts;
1183   BDF2A9    P1183: jsr   $intensity_to_7F;
1186   C660             ldb   #0x60;
1188   D704             stb   0x04;        /* Write scale factor (0x60) */
118A   CC80D0           ldd   #0x80D0;     /* Drawing position is based on */
118D   7DC8A6           tst   $C8A6;       /* whether we are drawing for the */
1190   2603             bne   P1195;       /* left or right eye. */
1192   CC80F0           ldd   #0x80F0;
1195   9701      P1195: sta   0x01;        /* Write y value (0x80) */
1197   0F00             clr   0x00;
1199   86CF             lda   #0xCF;       /* Un-zero integrators, & trigger */
119B   970C             sta   0x0C;        /* IRQ off positive edge. */
119D   0C00             inc   0x00;
119F   D701             stb   0x01;        /* Write x value (0xD0 or 0xF0) */
11A1   C640             ldb   #0x40;
11A3   0F05             clr   0x05;
11A5   D50D      P11A5: bitb  0x0D;        /* Wait for timer interrupt */
11A7   27FC             beq   P11A5;       /* Display the player's fuel bar */
11A9   0F01             clr   0x01;        /* Write y value (0) */
11AB   0F00             clr   0x00;
11AD   B6CA77           lda   $CA77;       /* Get player's fuel units */
11B0   9704             sta   0x04;        /* Write scale factor */
11B2   C67F             ldb   #0x7F;
11B4   0C00             inc   0x00;
11B6   D701             stb   0x01;        /* Write x value (0x7F) */
11B8   C640             ldb   #0x40;
11BA   0F05             clr   0x05;
11BC   030A             com   0x0A;
11BE   D50D      P11BE: bitb  0x0D;        /* Wait for timer interrupt */
11C0   27FC             beq   P11BE;
11C2   0F0A             clr   0x0A;        /* Clear line drawing pattern */
11C4   BD0353           jsr   $P0353;
11C7   39               rts;

                 /*
                  * CheckForCollisionWithBullets()
                  *
                  * Entry:
                  *   x = Frame ptr
                  *   C880 = Contact tolerance value
                  *
                  * Exit:
                  *   a = 0x00 (no contact) or 0xFF (contact occurred)
                  *
                  * This function checks each of the player's bullets, to see
                  * if one of them have hit the object in the incoming frame.
                  * The 'tolerance' value controls how close two objects
                  * must be, in order for them to be considered as having
                  * collided.  Before checking to see if two objects have
                  * collided, the two frames must have similar scale factor
                  * values (their difference must be <= 2).
                  */
                 CheckForCollisionWithBullets:
11C8   CEC8F9           ldu   #0xC8F9;     /* Get ptr to first bullet frame */
11CB   A603             lda   3,x;         /* Get scale for incoming frame */
11CD   C610             ldb   #0x10;
11CF   E547             bitb  7,u;         /* Skip this bullet frame, if */
11D1   2609             bne   P11DC;       /* it is not visible.         */
11D3   A043             suba  3,u;         /* Calculate the absolute value */
11D5   2A01             bpl   P11D8;       /* of the difference between the */
11D7   40               nega;              /* 2 frame's scale factors. */
11D8   8102      P11D8: cmpa  #0x02;       /* Skip this bullet, if the scale */
11DA   2328             bls   P1204;       /* factors are not within 2. */
11DC   33C822    P11DC: leau  0x22,u;      /* Get ptr to next bullet frame */
11DF   E547             bitb  7,u;         /* Skip this bullet frame, if */
11E1   260B             bne   P11EE;       /* it is not visible.         */
11E3   A603             lda   3,x;         /* Calculate the absolute value */
11E5   A043             suba  3,u;         /* of the difference between the */
11E7   2A01             bpl   P11EA;       /* 2 frame's scale factors. */
11E9   40               nega;
11EA   8102      P11EA: cmpa  #0x02;       /* Skip this bullet, if the scale */
11EC   2316             bls   P1204;       /* factors are not within 2. */
11EE   33C822    P11EE: leau  0x22,u;      /* Get ptr to next bullet frame */
11F1   E547             bitb  7,u;         /* Skip this bullet frame, if */
11F3   2702             beq   P11F7;       /* it is not visible.         */
11F5   4F               clra;              /* Bail out; no contact occurred */
11F6   39               rts;
11F7   A603      P11F7: lda   3,x;         /* Calculate the absolute value */
11F9   A043             suba  3,u;         /* of the difference between the */
11FB   2A01             bpl   P11FE;       /* 2 frame's scale factors. */
11FD   40               nega;
11FE   8102      P11FE: cmpa  #0x02;       /* Skip this bullet, if the scale */
1200   2302             bls   P1204;       /* factors are not within 2. */
1202   4F               clra;              /* Bail out; no contact occurred */
1203   39               rts;
1204   EC00      P1204: ldd   0,x;         /* Calulate the absolute value of */
1206   A040             suba  0,u;         /* the difference in the 2 frame's */
1208   E041             subb  1,u;         /* x and y values. */
120A   BDF584           jsr   $get_absolute_value_of_ab;
120D   B1C880           cmpa  $C880;       /* Proceed only if the y values */
1210   2D02             blt   P1214;       /* are within the tolerance level */
1212   4F               clra;              /* Bail out; no contact occurred */
1213   39               rts;
1214   F1C880    P1214: cmpb  $C880;       /* Proceed only if the x values */
1217   2D02             blt   P121B;       /* are within the tolerance level */
1219   4F               clra;              /* Bail out; no contact occurred */
121A   39               rts;
121B   86FF      P121B: lda   #0xFF;       /* Contact!! */
121D   E647             ldb   7,u;
121F   CA10             orb   #0x10;
1221   E747             stb   7,u;         /* Tag bullet frame as invisible */
1223   39               rts;

                 /*
                  * CheckForCollisionWithPlayer()
                  *
                  * Entry:
                  *   x = Frame ptr
                  *
                  * Exit:
                  *   a = 0x00 (no contact) or 0xFF (contact occurred)
                  *
                  * This function checks to see if the incoming frame object
                  * has collided with the player's ship. Before checking to
                  * see if two objects have collided, the two frames must
                  * have similar scale factor values (their difference must
                  * be <= 3).  The 'y' tolerance value is 0x08, while the 'x'
                  * tolerance value is 0x1E (30).
                  */
                 CheckForCollisionWithPlayer:
1224   4F               clra;            /* Initially assume no contact */
1225   E607             ldb   7,x        /* Skip check, if the incoming */
1227   C510             bitb  #0x10;     /* frame is not visible. */
1229   2701             beq   P122C;
122B   39               rts;
122C   6D881E    P122C: tst   0x1E,x;    /* Skip check, if the incoming */
122F   2701             beq   P1232;     /* frame is already exploding. */
1231   39               rts;
1232   CEC8D7    P1232: ldu   #0xC8D7;   /* Get ptr to player's frame */
1235   6DC81E           tst   0x1E,u;    /* Skip if already exploding. */
1238   2701             beq   P123B;
123A   39               rts;
123B   A603      P123B: lda   3,x;       /* Calculate the absolute value */
123D   A043             suba  3,u;       /* of the difference between the */
123F   2A01             bpl   P1242;     /* 2 frame's scale factors. */
1241   40               nega;
1242   8103      P1242: cmpa  #0x03;     /* No possible contact if the */
1244   2302             bls   P1248;     /* scale factors difference > 3 */
1246   4F               clra;            /* Bail out; no contact occurred */
1247   39               rts;
1248   EC00      P1248: ldd   0,x;       /* Calculate the x & y deltas for */
124A   A040             suba  0,u;       /* the two frames. */
124C   E041             subb  1,u;
124E   BDF584           jsr   $get_absolute_value_of_ab;
1251   8108             cmpa  #0x08;     /* Proceed only if the y delta */
1253   2D02             blt   P1257;     /* is < 8 */
1255   4F               clra;            /* Bail out; no contact occurred */
1256   39               rts;
1257   C11E      P1257: cmpb  #0x1E;     /* Proceed only if the x delta */
1259   2D02             blt   P125D;     /* is < 0x1E (30). */
125B   4F               clra;            /* Bail out; no contact occurred */
125C   39               rts;
125D   86FF      P125D: lda   #0xFF;     /* Contact!! */
125F   39               rts;

                 /*
                  * CheckForContactWithFuelObjects:
                  *
                  * Exit:
                  *    a = 0x00 (No contact)
                  *        0x01 (Passed through fuel wall opening)
                  *        0x02 (Picked up fuel cannister)
                  *        0xFF (Hit fuel wall)
                  *
                  * This function checks to see if the player's ship has
                  * passed through a fuel wall opening, collided with a
                  * fuel wall, or picked up a fuel cannister.  It will
                  * run through each of the fuel object frames, until it
                  * finds one which is within range; to be within range,
                  * the difference between the player's scale factor and
                  * the fuel object's scale factor must be <= 1.  Once an
                  * in-range frame is located (there may not be one), it
                  * will check to see if the (y,x) position for the player's
                  * ship is within the appropriate range to consider success;
                  * success when dealing with a fuel cannister means the
                  * player picked it up, while success for a fuel wall means
                  * the player passed through the opening.
                  */
                 CheckForContactWithFuelObjects:
1260   8EC8F9           ldx   #0xC8F9;   /* Get ptr to 1st fuel object frame */
1263   6D07      P1263: tst   7,x;       /* Skip, if this frame is marked */
1265   2C02             bge   P1269;     /* as the end of the frame stack. */
1267   4F               clra;            /* No contact */
1268   39               rts;
1269   A605      P1269: lda   5,x;       /* If the fuel object and player's */
126B   803F             suba  #0x3F;     /* scale factors are within 1, then */
126D   2C01             bge   P1270;     /* check for pass-thru (fuel wall) */
126F   40               nega;            /* or collection (fuel cannister). */
1270   8101      P1270: cmpa  #0x01;
1272   2305             bls   P1279;
1274   308822           leax  0x22,x;    /* Check the next frame */
1277   20EA             bra   P1263;
1279   F6C8D7    P1279: ldb   $C8D7;     /* Get the difference between the */
127C   1D               sex;             /* the player's y position and the */
127D   FDC891           std   $C891;     /* fuel object's y position.  Save */
1280   E6881C           ldb   0x1C,x;    /* the 16-bit value in C891-C892 */
1283   1D               sex;
1284   B3C891           subd  $C891;
1287   2C05             bge   P128E;
1289   43               coma;
128A   53               comb;
128B   C30001           addd  #0x0001;
128E   FDC891    P128E: std   $C891;
1291   F6C8D8           ldb   $C8D8;     /* Get the difference between the */
1294   1D               sex;             /* the player's x position and the */
1295   FDC893           std   $C893;     /* fuel object's x position.  Save */
1298   E6881D           ldb   0x1D,x;    /* the 16-bit value in C893-C894 */
129B   1D               sex;
129C   B3C893           subd  $C893;
129F   2C05             bge   P12A6;
12A1   43               coma;
12A2   53               comb;
12A3   C30001           addd  #0x0001;
12A6   FDC893    P12A6: std   $C893;
12A9   EC09             ldd   9,x;       /* Fuel cannister or fuel wall? */
12AB   10831479         cmpd  #FuelCannister;
12AF   261D             bne   P12CE;
12B1   FCC891           ldd   $C891;     /* Fuel cannister.  Is */
12B4   1083000F         cmpd  #0x000F;   /* |y delta| <= 15 ? */
12B8   2302             bls   P12BC;
12BA   4F               clra;            /* Nope; missed the cannister */
12BB   39               rts;
12BC   FCC893    P12BC: ldd   $C893;     /* Is |x delta| <= 15 ? */
12BF   1083000F         cmpd  #0x000F;
12C3   2302             bls   P12C7;
12C5   4F               clra;            /* Nope; missed the cannister */
12C6   39               rts;
12C7   8610      P12C7: lda   #0x10;     /* Picked up the fuel cannister; */
12C9   A707             sta   7,x;       /* tag frame as no longer visible. */
12CB   8602             lda   #0x02;
12CD   39               rts;
12CE   EC09      P12CE: ldd   9,x;       /* Large or small wall opening? */
12D0   108314A7         cmpd  #FuelWallOpening_Large;
12D4   261B             bne   P12F1;
12D6   FCC891           ldd   $C891;     /* Large opening */
12D9   1083000C         cmpd  #0x000C;   /* Is |y delta| <= 12 ? */
12DD   2303             bls   P12E2;
12DF   86FF             lda   #0xFF;     /* Nope; hit the wall */
12E1   39               rts;
12E2   FCC893    P12E2: ldd   $C893;     /* Is |x delta| <= 12 ? */
12E5   1083000C         cmpd  #0x000C;
12E9   2303             bls   P12EE;
12EB   86FF             lda   #0xFF;     /* Nope; hit the wall */
12ED   39               rts;
12EE   8601      P12EE: lda   #0x01;     /* Successfully passed thru opening */
12F0   39               rts;
12F1   FCC891    P12F1: ldd   $C891;     /* Small opening */
12F4   10830008         cmpd  #0x0008;   /* Is |y delta| <= 8 ? */
12F8   2303             bls   P12FD;
12FA   86FF             lda   #0xFF;     /* Nope; hit the wall */
12FC   39               rts;
12FD   FCC893    P12FD: ldd   $C893;     /* Is |x delta| <= 4 ? */
1300   10830004         cmpd  #0x0004;
1304   2303             bls   P1309;
1306   86FF             lda   #0xFF;     /* Nope; hit the wall */
1308   39               rts;
1309   8601      P1309: lda   #0x01;     /* Successfully passed thru opening */
130B   39               rts;

                 /*
                  * InitFuelWallOrCannisterFrame()
                  *
                  * Entry:
                  *    x = frame ptr
                  *
                  * This function fills in the incoming frame with information
                  * for either a fuel wall or a fuel cannister; if C8B5 is
                  * 0x00, then a fuel wall is initialized, otherwise, the
                  * fuel cannister is initialized.  The system loop counter
                  * (C87D) is used to generate a random index, which is
                  * used to index into an array of positions (used to control
                  * the placement of the wall opening, or the fuel cannister).
                  * C8B4 keeps track of how many fuel objects (walls or
                  * cannisters) have been displayed; after a certain number
                  * of fuel objects have been displayed, the opening in the
                  * fuel walls will get smaller.  C8B6 contains an index,
                  * in the range 0-2, which is used to control the color
                  * of the next fuel object.
                  */
                 InitFuelWallOrCannisterFrame:
130C   B6C87D           lda   $C87D;      /* Use the system loop counter */
130F   841E             anda  #0x1E;      /* to generate a random index */
1311   CE1361           ldu   #EmbeddedObjectPositions;  /* into the */
1314   ECC6             ldd   a,u;        /* embedded object position array. */
1316   ED881C           std   0x1C,x;     /* Save the embedded objs position */
1319   7DC8B5           tst   $C8B5;      /* Fuel wall or fuel cannister? */
131C   270F             beq   P132D;
131E   CC1479           ldd   #FuelCannister;
1321   ED09             std   9,x;        /* Save vector list 1 */
1323   ED0B             std   11,x;       /* Save vector list 2 */
1325   CC01E3           ldd   #DrawThenZeroIntegrators;
1328   ED8820           std   0x20,x;     /* Set drawing function */
132B   2017             bra   P1344;
132D   CC035E    P132D: ldd   #DrawFuelWall;
1330   ED8820           std   0x20,x;     /* Set drawing function */
1333   CE14A7           ldu   #FuelWallOpening_Large;
1336   B6C8B4           lda   $C8B4;      /* See if a large or small fuel */
1339   8106             cmpa  #0x06;      /* wall opening is required. */
133B   2303             bls   P1340;
133D   CE14BC           ldu   #FuelWallOpening_Small;
1340   EF09      P1340: stu   9,x;        /* Set vector list 1 */
1342   EF0B             stu   11,x;       /* Set vector list 2 */
1344   73C8B5    P1344: com   $C8B5;      /* Set up for next pass */
1347   B6C8B6           lda   $C8B6;      /* Use C8B6 to generate an index */
134A   8103             cmpa  #0x03;      /* which will be used to obtain */
134C   2601             bne   P134F;      /* the frame number (color) for */
134E   4F               clra;             /* this frame. */
134F   CE135E    P134F: ldu   #FuelWallFrameColors;
1352   E6C6             ldb   a,u;
1354   4C               inca;
1355   B7C8B6           sta   $C8B6;      /* Update index for next pass */
1358   E707             stb   7,x;        /* Set the frame # (color) */
135A   7CC8B4           inc   $C8B4;      /* Inc fuel object counter */
135D   39               rts;

                 FuelWallFrameColors:
135E   01               .byte 0x01;       /* blue */
135F   02               .byte 0x02;       /* green */
1360   03               .byte 0x03;       /* red */

                 /*
                  * This array of (y,x) pairs is used to control the
                  * positions of the embedded objects; i.e. fuel cannisters
                  * and fuel wall openings.
                  */
                 EmbeddedObjectPositions:
1361   00               .word 0x0000;
1363   00               .word 0x0048;
1365   00               .word 0x00B8;
1367   48               .word 0x4800;
1369   B8               .word 0xB800;
136B   48               .word 0x4848;
136D   48               .word 0x48B8;
136F   B8               .word 0xB848;
1371   B8               .word 0xB8B8;
1373   00               .word 0x0020;
1375   00               .word 0x00E0;
1377   20               .word 0x2000;
1379   E0               .word 0xE000;
137B   20               .word 0x2020;
137D   20               .word 0x20E0;
137F   E0               .word 0xE020;

                 /*
                  * UpdateAllFuelFrames()
                  *
                  * This function is responsible for updating the scale
                  * factor in each of the fuel object frames.  When the
                  * frontmost fuel object reaches the front of the screen
                  * (when its scale factor >= 0x6F), then that object will
                  * be removed, and all the other fuel objects will be
                  * shuffled up in the frame stack.  Then, if there are
                  * still more fuel objects waiting, the last of the fuel
                  * frames will be initialized to contain the new object.
                  * If all of the fuel objects have moved off the front of
                  * the screen, then the player has completed passage thru the
                  * fuel passage, and the flag in C8B2 will be set.
                  *
                  * If the frontmost fuel object has not reached the front
                  * of the screen, then we only need to update the scale
                  * factors and intensities for the fuel object frames.
                  */
                 UpdateAllFuelFrames:
1381   B6C8FE           lda   $C8FE;     /* Has the front-most fuel object */
1384   816F             cmpa  #0x6F;     /* reached the front of the screen? */
1386   10250075         lblo  P13FF;
138A   FCC920           ldd   $C920;     /* Yes; so shuffle up other frames */
138D   FDC8FE           std   $C8FE;     /* Frame 2 scale => frame 1 */
1390   B6C922           lda   $C922;
1393   B7C900           sta   $C900;     /* Frame 2 frame # => frame 1 */
1396   B6C944           lda   $C944;
1399   B7C922           sta   $C922;     /* Frame 3 frame # => frame 2 */
139C   B6C966           lda   $C966;
139F   B7C944           sta   $C944;     /* Frame 4 frame # => frame 3 */
13A2   FCC924           ldd   $C924;
13A5   FDC902           std   $C902;     /* Frame 2 vector list => frame 1 */
13A8   FDC904           std   $C904;     /* Frame 2 vector list => frame 1 */
13AB   FCC946           ldd   $C946;
13AE   FDC924           std   $C924;     /* Frame 3 vector list => frame 2 */
13B1   FDC926           std   $C926;     /* Frame 3 vector list => frame 2 */
13B4   FCC968           ldd   $C968;
13B7   FDC946           std   $C946;     /* Frame 4 vector list => frame 3 */
13BA   FDC948           std   $C948;     /* Frame 4 vector list => frame 3 */
13BD   FCC93B           ldd   $C93B;
13C0   FDC919           std   $C919;     /* Frame 2 drawing func => frame 1 */
13C3   FCC95D           ldd   $C95D;
13C6   FDC93B           std   $C93B;     /* Frame 3 drawing func => frame 2 */
13C9   FCC97F           ldd   $C97F;
13CC   FDC95D           std   $C95D;     /* Frame 4 drawing func => frame 3 */
13CF   FCC937           ldd   $C937;
13D2   FDC915           std   $C915;     /* Frame 2 emb-obj pos => frame 1 */
13D5   FCC959           ldd   $C959;
13D8   FDC937           std   $C937;     /* Frame 3 emb-obj pos => frame 2 */
13DB   FCC97B           ldd   $C97B;
13DE   FDC959           std   $C959;     /* Frame 4 emb-obj pos => frame 3 */
13E1   F6C8B4           ldb   $C8B4;     /* Either start another fuel object */
13E4   F1C883           cmpb  $C883;     /* or disable the last frame. */
13E7   2307             bls   P13F0;
13E9   86FF             lda   #0xFF;     /* We don't need to start another */
13EB   B7C966           sta   $C966;     /* fuel obj; so disable last frame */
13EE   2006             bra   P13F6;
13F0   8EC95F    P13F0: ldx   #0xC95F;   /* Start another fuel object */
13F3   BD130C           jsr   $InitFuelWallOrCannisterFrame;
13F6   7DC900    P13F6: tst   $C900;     /* Are there any active frames left? */
13F9   2C04             bge   P13FF;
13FB   73C8B2           com   $C8B2;     /* No; player is done */
13FE   39               rts;
13FF   8EC8FE    P13FF: ldx   #0xC8FE;   /* Update the secondary scale */
1402   B6C884           lda   $C884;     /* factor for frame 1. */
1405   BD06E0           jsr   $P06E0;
1408   B6C8FE           lda   $C8FE;
140B   C67F             ldb   #0x7F;     /* Update the secondary scale */
140D   3D               mul;             /* factor for frame 2. */
140E   B7C920           sta   $C920;
1411   C67F             ldb   #0x7F;     /* Update the secondary scale */
1413   3D               mul;             /* factor for frame 3. */
1414   B7C942           sta   $C942;
1417   C67F             ldb   #0x7F;     /* Update the secondary scale */
1419   3D               mul;             /* factor for frame 4. */
141A   B7C964           sta   $C964
141D   8604             lda   #0x04;
141F   B7C891           sta   $C891;     /* Set loop counter */
1422   8EC8F9           ldx   #0xC8F9;   /* Get fuel obj 1 frame ptr */
1425   A605      P1425: lda   5,x;       /* Get embedded obj's intensity */
1427   C680             ldb   #0x80;
1429   3D               mul;
142A   48               asla;
142B   A702             sta   2,x;
142D   A605             lda   5,x;       /* Calculate intensity = */
142F   8B40             adda  #0x40;     /* embedded obj scale factor+0x40 */
1431   2A02             bpl   P1435;     /* If rollover occurs, then use */
1433   867F             lda   #0x7F;     /* max intensity (0x7F). */
1435   A708      P1435: sta   8,x;       /* Set intensity */
1437   308822           leax  0x22,x;    /* Point to next frame */
143A   7AC891           dec   $C891;     /* Decrement loop counter */
143D   26E6             bne   P1425;     /* Done processing the frames? */
143F   39               rts;

                 /*
                  * InitAllFuelFrames()
                  *
                  * This function initializes the fuel passage variables,
                  * along with the 5 frames used to display the fuel objects
                  * (4 of the frames display fuel objects, while the 5th
                  * frame is used to tag the end of the frame stack).  The
                  * frame ptrs used are: C8F9, C91B, C93D, C95F and C981.
                  */
                 InitAllFuelFrames:
1440   CC0800           ldd   #0x0800;     /* Force the secondary scale for */
1443   FDC8FE           std   $C8FE;       /* fuel object 1 to 0x08000 */
1446   8EC8F9           ldx   #0xC8F9;     /* Get ptr to fuel obj 1 frame */
1449   7FC8B4           clr   $C8B4;       /* Clear the fuel object counter */
144C   7FC8B5           clr   $C8B5;       /* Force fuel wall to draw first */
144F   7FC8B6           clr   $C8B6;       /* Init fuel object color index */
1452   8604             lda   #0x04;       /* Init the 1st 4 fuel objects */
1454   B7C897           sta   $C897;       /* Set loop counter */
1457   C6FF      P1457: ldb   #0xFF;
1459   E7881B           stb   0x1B,x;      /* Flag player in fuel passage */
145C   BD130C           jsr   $InitFuelWallOrCannisterFrame;
145F   BDF517           jsr   $get_random_a;
1462   CC0000           ldd   #0x0000;
1465   ED00             std   0,x;         /* Set frame (y,x) to (0,0) */
1467   CC0001           ldd   #0x0001;
146A   ED03             std   3,x;         /* Set scale factor */
146C   308822           leax  0x22,x;      /* Get ptr to next frame */
146F   7AC897           dec   $C897;       /* Decrement loop counter */
1472   26E3             bne   P1457;       /* Done processing the frames? */
1474   86FF             lda   #0xFF;
1476   A707             sta   7,x;         /* Tag the end of the frame stack */
1478   39               rts;

                 /* Vector list, 4 bytes per endpoint */
                 FuelCannister:
1479   00               .byte 0x00;
147A   10               .byte 0x10;
147B   00               .byte 0x00;
147C   00               .byte 0x00;
147D   FF               .byte 0xFF;
147E   F0               .byte 0xF0;
147F   10               .byte 0x10;
1480   00               .byte 0x00;
1481   FF               .byte 0xFF;
1482   F0               .byte 0xF0;
1483   F0               .byte 0xF0;
1484   00               .byte 0x00;
1485   FF               .byte 0xFF;
1486   10               .byte 0x10;
1487   F0               .byte 0xF0;
1488   00               .byte 0x00;
1489   FF               .byte 0xFF;
148A   10               .byte 0x10;
148B   10               .byte 0x10;
148C   00               .byte 0x00;
148D   01               .byte 0x01;

                 /* Vector list, 4 bytes per endpoint */
                 FuelWall:
148E   00               .byte 0x00;
148F   7F               .byte 0x7F;
1490   7F               .byte 0x7F;
1491   00               .byte 0x00;
1492   FF               .byte 0xFF;
1493   00               .byte 0x00;
1494   81               .byte 0x81;
1495   01               .byte 0x01;
1496   FF               .byte 0xFF;
1497   81               .byte 0x81;
1498   00               .byte 0x00;
1499   01               .byte 0x01;
149A   FF               .byte 0xFF;
149B   00               .byte 0x00;
149C   7F               .byte 0x7F;
149D   01               .byte 0x01;
149E   FF               .byte 0xFF;
149F   7F               .byte 0x7F;
14A0   00               .byte 0x00;
14A1   01               .byte 0x01;
14A2   00               .byte 0x00;
14A3   81               .byte 0x81;
14A4   81               .byte 0x81;
14A5   00               .byte 0x00;
14A6   01               .byte 0x01;

                 /* Vector list, 4 bytes per endpoint */
                 FuelWallOpening_Large:
14A7   00               .byte 0x00;
14A8   18               .byte 0x18;
14A9   30               .byte 0x30;
14AA   00               .byte 0x00;
14AB   FF               .byte 0xFF;
14AC   00               .byte 0x00;
14AD   A0               .byte 0xA0;
14AE   00               .byte 0x00;
14AF   FF               .byte 0xFF;
14B0   D0               .byte 0xD0;
14B1   00               .byte 0x00;
14B2   00               .byte 0x00;
14B3   FF               .byte 0xFF;
14B4   00               .byte 0x00;
14B5   60               .byte 0x60;
14B6   00               .byte 0x00;
14B7   FF               .byte 0xFF;
14B8   30               .byte 0x30;
14B9   00               .byte 0x00;
14BA   00               .byte 0x00;
14BB   01               .byte 0x01;

                 /* Vector list, 4 bytes per endpoint */
                 FuelWallOpening_Small:
14BC   00               .byte 0x00;
14BD   14               .byte 0x14;
14BE   20               .byte 0x20;
14BF   00               .byte 0x00;
14C0   FF               .byte 0xFF;
14C1   00               .byte 0x00;
14C2   C0               .byte 0xC0;
14C3   00               .byte 0x00;
14C4   FF               .byte 0xFF;
14C5   D8               .byte 0xD8;
14C6   00               .byte 0x00;
14C7   00               .byte 0x00;
14C8   FF               .byte 0xFF;
14C9   00               .byte 0x00;
14CA   40               .byte 0x40;
14CB   00               .byte 0x00;
14CC   FF               .byte 0xFF;
14CD   28               .byte 0x28;
14CE   00               .byte 0x00;
14CF   00               .byte 0x00;
14D0   01               .byte 0x01;

                 RefreshCheckPoints:
14D1   F0               .word 0xF000;
14D3   BD               .word 0xBD00;
14D5   96               .word 0x9600;
14D7   68               .word 0x6800;
14D9   40               .word 0x4000;
14DB   20               .word 0x2000;
14DD   00               .word 0x0000;

                 FrameDrawingProcs:
14DF   05               .word EP_DrawAllBlueFramesAndWalls_RightEye;
14E1   05               .word EP_DrawAllGreenFramesAndWalls_RightEye;
14E3   05               .word EP_DrawAllRedFrames_RightEye;
14E5   04               .word EP_DrawAllBlueFramesAndWalls_LeftEye;
14E7   04               .word EP_DrawAllGreenFramesAndWalls_LeftEye;
14E9   04               .word EP_DrawAllRedFrames_LeftEye;

14EB   BDF533    P14EB: jsr   $init_music_buf;
14EE   0F45             clr   0x45;
14F0   108ECA90         ldy   #0xCA90;
14F4   CE153F           ldu   #0x153F;
14F7   CC0380           ldd   #0x0380;
14FA   DD9C             std   0x9C;
14FC   0F9E             clr   0x9E;
14FE   969B             lda   0x9B;      /* Load the sound bitmask */
1500   9A9F             ora   0x9F;
1502   97A0             sta   0xA0;
1504   969D      P1504: lda   0x9D;
1506   94A0             anda  0xA0;
1508   2722             beq   P152C;
150A   1F89             tfr   a,b;
150C   9A9E             ora   0x9E;
150E   979E             sta   0x9E;
1510   D59B             bitb  0x9B;
1512   2604             bne   P1518;
1514   D49F             andb  0x9F;
1516   260E             bne   P1526;
1518   EC42      P1518: ldd   2,u;
151A   EDA4             std   ,y;
151C   EC44             ldd   4,u;
151E   ED22             std   2,y;
1520   861F             lda   #0x1F;
1522   97A1             sta   0xA1;
1524   9746             sta   0x46;
1526   ADD4      P1526: jsr   [,u];     /* (INDIRECT JUMP) */
1528   969C             lda   0x9C;
152A   2708             beq   P1534;
152C   3347      P152C: leau  7,u;
152E   3124             leay  4,y;
1530   049D             lsr   0x9D;
1532   26D0             bne   P1504;
1534   969F      P1534: lda   0x9F;
1536   8407             anda  #0x07;
1538   9A9E             ora   0x9E;
153A   979F             sta   0x9F;
153C   0F9B             clr   0x9B;      /* Clear the sound bitmask */
153E   39               rts;

                 /*
                  * The following is an array of 8 entries, each composed
                  * of 7 bytes, and having the following meaning:
                  *
                  *       -------------------
                  *     0 |     Function    |
                  *       ---             ---
                  *     1 |     Pointer     |
                  *       -------------------
                  *     2 |                 |
                  *       -------------------
                  *     3 |                 |
                  *       -------------------
                  *     4 |                 |
                  *       -------------------
                  *     5 |                 |
                  *       -------------------
                  *     6 |                 |
                  *       -------------------
                  *     7 |                 |
                  *       -------------------
                  */
153F   16        S153F: .word 0x16AC;
1541   01               .byte 0x01;
1542   A0               .byte 0xA0;
1543   00               .byte 0x00;
1544   00               .byte 0x00;
1545   FF               .byte 0xFF;

1546   15               .word 0x15D4;
1548   00               .byte 0x00;
1549   10               .byte 0x10;
154A   0E               .byte 0x0E;
154B   0E               .byte 0x0E;
154C   00               .byte 0x00;

154D   15               .word 0x1583;
154F   00               .byte 0x00;
1550   00               .byte 0x00;
1551   0F               .byte 0x0F;
1552   18               .byte 0x18;
1553   FF               .byte 0xFF;

1554   16               .word 0x161D;
1556   02               .byte 0x02;
1557   00               .byte 0x00;
1558   0C               .byte 0x0C;
1559   05               .byte 0x05;
155A   FF               .byte 0xFF;

155B   16               .word 0x1640;
155D   0F               .byte 0x0F;
155E   FF               .byte 0xFF;
155F   10               .byte 0x10;
1560   18               .byte 0x18;
1561   FF               .byte 0xFF;

1562   15               .word 0x1577;
1564   00               .byte 0x00;
1565   55               .byte 0x55;
1566   10               .byte 0x10;
1567   00               .byte 0x00;
1568   00               .byte 0x00;

1569   16               .word 0x1667;
156B   00               .byte 0x00;
156C   70               .byte 0x70;
156D   0A               .byte 0x0A;
156E   01               .byte 0x01;
156F   00               .byte 0x00;

1570   16               .word 0x1653;
1572   0C               .byte 0x0C;
1573   00               .byte 0x00;
1574   0D               .byte 0x0D;
1575   18               .byte 0x18;
1576   00               .byte 0x00;

1577   CC1040    P1577: ldd   #0x1040;
157A   DD40             std   0x40;
157C   8608             lda   #0x08;
157E   973F             sta   0x3F;
1580   7E1680           jmp   $P1680;

1583   3460      P1583: pshs  y,u;
1585   108ECAB0         ldy   #0xCAB0;
1589   969B             lda   0x9B;        /* Load the sound bitmask */
158B   949D             anda  0x9D;
158D   2711             beq   P15A0;
158F   CC0000           ldd   #0x0000;
1592   EDA4             std   ,y;
1594   CC0003           ldd   #0x0003;
1597   ED24             std   4,y;
1599   CC0F18           ldd   #0x0F18;
159C   ED22             std   2,y;
159E   ED26             std   6,y;
15A0   CE16D7    P15A0: ldu   #0x16D7;
15A3   CC00A0           ldd   #0x00A0;
15A6   DD40             std   0x40;
15A8   0F46             clr   0x46;
15AA   860E             lda   #0x0E;
15AC   973F             sta   0x3F;
15AE   8D0D             bsr   P15BD;
15B0   3124             leay  4,y;
15B2   3341             leau  1,u;
15B4   8D07             bsr   P15BD;
15B6   3124             leay  4,y;
15B8   3341             leau  1,u;
15BA   3560             puls  y,u;
15BC   39               rts;

15BD   6A23      P15BD: dec   3,y;
15BF   102700E1         lbeq  P16A4;
15C3   A623             lda   3,y;
15C5   810E             cmpa  #0x0E;
15C7   2E02             bgt   P15CB;
15C9   A722             sta   2,y;
15CB   AEA4      P15CB: ldx   ,y;
15CD   3002             leax  2,x;
15CF   AFA4             stx   ,y;
15D1   7E1680           jmp   $P1680;

15D4   108ECABC  P15D4: ldy   #0xCABC;
15D8   969B             lda   0x9B;        /* Load the sound bitmask */
15DA   959D             bita  0x9D;
15DC   2727             beq   P1605;
15DE   96A0             lda   0xA0;
15E0   84FD             anda  #0xFD;
15E2   97A0             sta   0xA0;
15E4   969F             lda   0x9F;
15E6   84FD             anda  #0xFD;
15E8   979F             sta   0x9F;
15EA   CC0010           ldd   #0x0010;
15ED   EDA4             std   ,y;
15EF   ED24             std   4,y;
15F1   CC0E0E           ldd   #0x0E0E;
15F4   ED22             std   2,y;
15F6   CC0000           ldd   #0x0000;
15F9   ED28             std   8,y;
15FB   CC0E07           ldd   #0x0E07;
15FE   ED26             std   6,y;
1600   CC0F03           ldd   #0x0F03;
1603   ED2A             std   10,y;
1605   8D06      P1605: bsr   P160D;
1607   3124             leay  4,y;
1609   8D02             bsr   P160D;
160B   3124             leay  4,y;
160D   6A23      P160D: dec   3,y;
160F   266F             bne   P1680;
1611   8603             lda   #0x03;
1613   A723             sta   3,y;
1615   AE20             ldx   0,y;
1617   3001             leax  1,x;
1619   AF20             stx   0,y;
161B   2063             bra   P1680;

161D   96A0      P161D: lda   0xA0;
161F   84FD             anda  #0xFD;
1621   97A0             sta   0xA0;
1623   969F             lda   0x9F;
1625   84FD             anda  #0xFD;
1627   979F             sta   0x9F;
1629   EC20             ldd   0,y;
162B   830030           subd  #0x0030;
162E   ED20             std   0,y;
1630   0AA1             dec   0xA1;
1632   96A1             lda   0xA1;
1634   9746             sta   0x46;
1636   810F             cmpa  #0x0F;
1638   2E02             bgt   P163C;
163A   A722             sta   2,y;
163C   2642      P163C: bne   P1680;
163E   2064             bra   P16A4;
1640   CC2F40    P1640: ldd   #0x2F40;
1643   DD40             std   0x40;
1645   8603             lda   #0x03;
1647   973F             sta   0x3F;
1649   6A23             dec   3,y;
164B   2633             bne   P1680;
164D   8602             lda   #0x02;
164F   973F             sta   0x3F;
1651   2051             bra   P16A4;
1653   EC20      P1653: ldd   0,y;
1655   830003           subd  #0x0003;
1658   ED20             std   0,y;
165A   10830A00         cmpd  #0x0A00;
165E   2220             bhi   P1680;
1660   CC0C00           ldd   #0x0C00;
1663   ED20             std   0,y;
1665   2019             bra   P1680;
1667   6A23      P1667: dec   3,y;
1669   260A             bne   P1675;
166B   8604             lda   #0x04;
166D   A723             sta   3,y;
166F   96A3             lda   0xA3;
1671   A721             sta   1,y;
1673   200B             bra   P1680;
1675   8604      P1675: lda   #0x04;
1677   A023             suba  3,y;
1679   48               asla;
167A   48               asla;
167B   40               nega;
167C   AB21             adda  1,y;
167E   A721             sta   1,y;
1680   8EC842    P1680: ldx   #0xC842;
1683   0A9C             dec   0x9C;
1685   969C             lda   0x9C;
1687   E622             ldb   2,y;
1689   E786             stb   a,x;
168B   48               asla;
168C   8B05             adda  #0x05;
168E   3086             leax  a,x;
1690   ECA4             ldd   ,y;
1692   ED84             std   ,x;
1694   8E16D7           ldx   #0x16D7;
1697   A646             lda   6,u;
1699   2B08             bmi   P16A3;
169B   9B9C             adda  0x9C;
169D   A686             lda   a,x;
169F   9A45             ora   0x45;
16A1   9745             sta   0x45;
16A3   39        P16A3: rts;
16A4   969D      P16A4: lda   0x9D;
16A6   43               coma;
16A7   949E             anda  0x9E;
16A9   979E             sta   0x9E;
16AB   39               rts;

16AC   969B      P16AC: lda   0x9B;      /* Get the explosion bitmask */
16AE   949D             anda  0x9D;
16B0   2702             beq   P16B4;
16B2   9767             sta   0x67;
16B4   3440      P16B4: pshs  u;
16B6   96A2             lda   0xA2;      /* Use sound characteristic index */
16B8   CE16CF           ldu   #SoundCharacteristics;
16BB   48               asla;
16BC   48               asla;
16BD   33C6             leau  a,u;
16BF   A641             lda   1,u;
16C1   9746             sta   0x46;
16C3   BDF92E           jsr   $generate_explosion_sound;
16C6   0F9C             clr   0x9C;
16C8   3540             puls  u;
16CA   9677             lda   0x77;
16CC   27D6             beq   P16A4;
16CE   39               rts;

                 /*
                  * Array of 2 entries, each 4 bytes long.
                  */
                 SoundCharacteristics:
16CF   38               .byte 0x38;
16D0   10               .byte 0x10;
16D1   00               .byte 0x00;
16D2   08               .byte 0x08;

16D3   3F               .byte 0x3F;
16D4   03               .byte 0x03;
16D5   00               .byte 0x00;
16D6   04               .byte 0x04;

16D7   20        S16D7: .byte 0x20;
16D8   10               .byte 0x10;
16D9   08               .byte 0x08;
16DA   04               .byte 0x04;
16DB   02               .byte 0x02;
16DC   01               .byte 0x01;
16DD   FF               .byte 0xFF;
16DE   00               .byte 0x00;
16DF   00               .byte 0x00;
16E0   00               .byte 0x00;
16E1   00               .byte 0x00;
16E2   28               .byte 0x28;
16E3   3C               .byte 0x3C;
16E4   FF               .byte 0xFF;
16E5   14               .byte 0x14;
16E6   C4               .byte 0xC4;
16E7   FF               .byte 0xFF;
16E8   D8               .byte 0xD8;
16E9   EC               .byte 0xEC;
16EA   FF               .byte 0xFF;
16EB   EC               .byte 0xEC;
16EC   D8               .byte 0xD8;
16ED   FF               .byte 0xFF;
16EE   D8               .byte 0xD8;
16EF   28               .byte 0x28;
16F0   FF               .byte 0xFF;
16F1   14               .byte 0x14;
16F2   3C               .byte 0x3C;
16F3   FF               .byte 0xFF;
16F4   3C               .byte 0x3C;
16F5   14               .byte 0x14;
16F6   01               .byte 0x01;

                 EnemyStarVectorList:
16F7   00               .byte 0x00;
16F8   32               .byte 0x32;
16F9   32               .byte 0x32;
16FA   FF               .byte 0xFF;
16FB   EC               .byte 0xEC;
16FC   C4               .byte 0xC4;
16FD   FF               .byte 0xFF;
16FE   14               .byte 0x14;
16FF   D8               .byte 0xD8;
1700   FF               .byte 0xFF;
1701   CE               .byte 0xCE;
1702   1E               .byte 0x1E;
1703   FF               .byte 0xFF;
1704   CE               .byte 0xCE;
1705   E2               .byte 0xE2;
1706   FF               .byte 0xFF;
1707   14               .byte 0x14;
1708   1E               .byte 0x1E;
1709   FF               .byte 0xFF;
170A   EC               .byte 0xEC;
170B   46               .byte 0x46;
170C   FF               .byte 0xFF;
170D   28               .byte 0x28;
170E   D8               .byte 0xD8;
170F   FF               .byte 0xFF;
1710   3C               .byte 0x3C;
1711   28               .byte 0x28;
1712   01               .byte 0x01;

                 EnemyShip1VectorTable:
1713   17               .word EnemyShip1_1;
1715   17               .word EnemyShip1_2;
1717   17               .word EnemyShip1_3;
1719   17               .word EnemyShip1_4;

                 EnemyShip1_1:
171B   FF               .byte 0xFF;
171C   20               .byte 0x20;
171D   40               .byte 0x40;
171E   FF               .byte 0xFF;
171F   C0               .byte 0xC0;
1720   00               .byte 0x00;
1721   FF               .byte 0xFF;
1722   20               .byte 0x20;
1723   C0               .byte 0xC0;
1724   FF               .byte 0xFF;
1725   20               .byte 0x20;
1726   C0               .byte 0xC0;
1727   FF               .byte 0xFF;
1728   C0               .byte 0xC0;
1729   00               .byte 0x00;
172A   FF               .byte 0xFF;
172B   20               .byte 0x20;
172C   40               .byte 0x40;
172D   01               .byte 0x01;

                 EnemyShip1_2:
172E   FF               .byte 0xFF;
172F   28               .byte 0x28;
1730   38               .byte 0x38;
1731   FF               .byte 0xFF;
1732   B0               .byte 0xB0;
1733   00               .byte 0x00;
1734   FF               .byte 0xFF;
1735   28               .byte 0x28;
1736   C8               .byte 0xC8;
1737   FF               .byte 0xFF;
1738   28               .byte 0x28;
1739   C8               .byte 0xC8;
173A   FF               .byte 0xFF;
173B   B0               .byte 0xB0;
173C   00               .byte 0x00;
173D   FF               .byte 0xFF;
173E   28               .byte 0x28;
173F   38               .byte 0x38;
1740   01               .byte 0x01;

                 EnemyShip1_3:
1741   FF               .byte 0xFF;
1742   30               .byte 0x30;
1743   30               .byte 0x30;
1744   FF               .byte 0xFF;
1745   A0               .byte 0xA0;
1746   00               .byte 0x00;
1747   FF               .byte 0xFF;
1748   30               .byte 0x30;
1749   D0               .byte 0xD0;
174A   FF               .byte 0xFF;
174B   30               .byte 0x30;
174C   D0               .byte 0xD0;
174D   FF               .byte 0xFF;
174E   A0               .byte 0xA0;
174F   00               .byte 0x00;
1750   FF               .byte 0xFF;
1751   30               .byte 0x30;
1752   30               .byte 0x30;
1753   01               .byte 0x01;

                 EnemyShip1_4:
1754   FF               .byte 0xFF;
1755   38               .byte 0x38;
1756   28               .byte 0x28;
1757   FF               .byte 0xFF;
1758   90               .byte 0x90;
1759   00               .byte 0x00;
175A   FF               .byte 0xFF;
175B   38               .byte 0x38;
175C   D8               .byte 0xD8;
175D   FF               .byte 0xFF;
175E   38               .byte 0x38;
175F   D8               .byte 0xD8;
1760   FF               .byte 0xFF;
1761   90               .byte 0x90;
1762   00               .byte 0x00;
1763   FF               .byte 0xFF;
1764   38               .byte 0x38;
1765   28               .byte 0x28;
1766   01               .byte 0x01;

                 EnemyShip2VectorTable:
1767   17               .word EnemyShip2_1;
1769   17               .word EnemyShip2_2;
176B   17               .word EnemyShip2_3;
176D   17               .word EnemyShip2_4;

                 EnemyShip2_1:
176F   00               .byte 0x00;
1770   CE               .byte 0xCE;
1771   32               .byte 0x32;
1772   FF               .byte 0xFF;
1773   32               .byte 0x32;
1774   9C               .byte 0x9C;
1775   FF               .byte 0xFF;
1776   32               .byte 0x32;
1777   64               .byte 0x64;
1778   00               .byte 0x00;
1779   00               .byte 0x00;
177A   9C               .byte 0x9C;
177B   FF               .byte 0xFF;
177C   CE               .byte 0xCE;
177D   64               .byte 0x64;
177E   FF               .byte 0xFF;
177F   CE               .byte 0xCE;
1780   9C               .byte 0x9C;
1781   01               .byte 0x01;

                 EnemyShip2_2:
1782   00               .byte 0x00;
1783   CE               .byte 0xCE;
1784   32               .byte 0x32;
1785   FF               .byte 0xFF;
1786   32               .byte 0x32;
1787   B0               .byte 0xB0;
1788   FF               .byte 0xFF;
1789   32               .byte 0x32;
178A   50               .byte 0x50;
178B   00               .byte 0x00;
178C   00               .byte 0x00;
178D   9C               .byte 0x9C;
178E   FF               .byte 0xFF;
178F   CE               .byte 0xCE;
1790   50               .byte 0x50;
1791   FF               .byte 0xFF;
1792   CE               .byte 0xCE;
1793   B0               .byte 0xB0;
1794   01               .byte 0x01;

                 EnemyShip2_3:
1795   00               .byte 0x00;
1796   CE               .byte 0xCE;
1797   32               .byte 0x32;
1798   FF               .byte 0xFF;
1799   32               .byte 0x32;
179A   C4               .byte 0xC4;
179B   FF               .byte 0xFF;
179C   32               .byte 0x32;
179D   3C               .byte 0x3C;
179E   00               .byte 0x00;
179F   00               .byte 0x00;
17A0   9C               .byte 0x9C;
17A1   FF               .byte 0xFF;
17A2   CE               .byte 0xCE;
17A3   3C               .byte 0x3C;
17A4   FF               .byte 0xFF;
17A5   CE               .byte 0xCE;
17A6   CE               .byte 0xCE;
17A7   01               .byte 0x01;

                 EnemyShip2_4:
17A8   00               .byte 0x00;
17A9   CE               .byte 0xCE;
17AA   32               .byte 0x32;
17AB   FF               .byte 0xFF;
17AC   32               .byte 0x32;
17AD   D8               .byte 0xD8;
17AE   FF               .byte 0xFF;
17AF   32               .byte 0x32;
17B0   28               .byte 0x28;
17B1   00               .byte 0x00;
17B2   00               .byte 0x00;
17B3   9C               .byte 0x9C;
17B4   FF               .byte 0xFF;
17B5   CE               .byte 0xCE;
17B6   28               .byte 0x28;
17B7   FF               .byte 0xFF;
17B8   CE               .byte 0xCE;
17B9   D8               .byte 0xD8;
17BA   01               .byte 0x01;

                 EnemyShip3VectorTable:
17BB   17               .word EnemyShip3_1;
17BD   17               .word EnemyShip3_2;
17BF   18               .word EnemyShip3_3;
17C1   18               .word EnemyShip3_4;

                 EnemyShip3_1:
17C3   FF               .byte 0xFF;
17C4   CE               .byte 0xCE;
17C5   CE               .byte 0xCE;
17C6   FF               .byte 0xFF;
17C7   14               .byte 0x14;
17C8   00               .byte 0x00;
17C9   FF               .byte 0xFF;
17CA   EC               .byte 0xEC;
17CB   32               .byte 0x32;
17CC   FF               .byte 0xFF;
17CD   14               .byte 0x14;
17CE   32               .byte 0x32;
17CF   FF               .byte 0xFF;
17D0   EC               .byte 0xEC;
17D1   00               .byte 0x00;
17D2   FF               .byte 0xFF;
17D3   00               .byte 0x00;
17D4   9C               .byte 0x9C;
17D5   FF               .byte 0xFF;
17D6   64               .byte 0x64;
17D7   64               .byte 0x64;
17D8   FF               .byte 0xFF;
17D9   00               .byte 0x00;
17DA   9C               .byte 0x9C;
17DB   FF               .byte 0xFF;
17DC   EC               .byte 0xEC;
17DD   32               .byte 0x32;
17DE   FF               .byte 0xFF;
17DF   14               .byte 0x14;
17E0   32               .byte 0x32;
17E1   00               .byte 0x00;
17E2   00               .byte 0x00;
17E3   9C               .byte 0x9C;
17E4   FF               .byte 0xFF;
17E5   9C               .byte 0x9C;
17E6   64               .byte 0x64;
17E7   01               .byte 0x01;

                 EnemyShip3_2:
17E8   FF               .byte 0xFF;
17E9   D8               .byte 0xD8;
17EA   D8               .byte 0xD8;
17EB   FF               .byte 0xFF;
17EC   1E               .byte 0x1E;
17ED   00               .byte 0x00;
17EE   FF               .byte 0xFF;
17EF   EC               .byte 0xEC;
17F0   28               .byte 0x28;
17F1   FF               .byte 0xFF;
17F2   14               .byte 0x14;
17F3   28               .byte 0x28;
17F4   FF               .byte 0xFF;
17F5   E2               .byte 0xE2;
17F6   00               .byte 0x00;
17F7   FF               .byte 0xFF;
17F8   00               .byte 0x00;
17F9   B0               .byte 0xB0;
17FA   00               .byte 0x00;
17FB   00               .byte 0x00;
17FC   50               .byte 0x50;
17FD   FF               .byte 0xFF;
17FE   50               .byte 0x50;
17FF   B0               .byte 0xB0;
1800   FF               .byte 0xFF;
1801   E2               .byte 0xE2;
1802   28               .byte 0x28;
1803   FF               .byte 0xFF;
1804   1E               .byte 0x1E;
1805   28               .byte 0x28;
1806   FF               .byte 0xFF;
1807   00               .byte 0x00;
1808   B0               .byte 0xB0;
1809   00               .byte 0x00;
180A   D8               .byte 0xD8;
180B   28               .byte 0x28;
180C   FF               .byte 0xFF;
180D   28               .byte 0x28;
180E   28               .byte 0x28;
180F   01               .byte 0x01;

                 EnemyShip3_3:
1810   00               .byte 0x00;
1811   F6               .byte 0xF6;
1812   00               .byte 0x00;
1813   FF               .byte 0xFF;
1814   28               .byte 0x28;
1815   D8               .byte 0xD8;
1816   FF               .byte 0xFF;
1817   00               .byte 0x00;
1818   50               .byte 0x50;
1819   FF               .byte 0xFF;
181A   D8               .byte 0xD8;
181B   D8               .byte 0xD8;
181C   00               .byte 0x00;
181D   EC               .byte 0xEC;
181E   00               .byte 0x00;
181F   FF               .byte 0xFF;
1820   28               .byte 0x28;
1821   D8               .byte 0xD8;
1822   FF               .byte 0xFF;
1823   CE               .byte 0xCE;
1824   00               .byte 0x00;
1825   FF               .byte 0xFF;
1826   00               .byte 0x00;
1827   50               .byte 0x50;
1828   FF               .byte 0xFF;
1829   32               .byte 0x32;
182A   00               .byte 0x00;
182B   FF               .byte 0xFF;
182C   D8               .byte 0xD8;
182D   D8               .byte 0xD8;
182E   01               .byte 0x01;

                 EnemyShip3_4:
182F   00               .byte 0x00;
1830   14               .byte 0x14;
1831   28               .byte 0x28;
1832   FF               .byte 0xFF;
1833   CE               .byte 0xCE;
1834   00               .byte 0x00;
1835   FF               .byte 0xFF;
1836   00               .byte 0x00;
1837   B0               .byte 0xB0;
1838   FF               .byte 0xFF;
1839   32               .byte 0x32;
183A   00               .byte 0x00;
183B   FF               .byte 0xFF;
183C   D8               .byte 0xD8;
183D   28               .byte 0x28;
183E   FF               .byte 0xFF;
183F   28               .byte 0x28;
1840   28               .byte 0x28;
1841   FF               .byte 0xFF;
1842   00               .byte 0x00;
1843   B0               .byte 0xB0;
1844   01               .byte 0x01;

                 EnemyShip4VectorTable:
1845   18               .word EnemyShip4_1;
1847   18               .word EnemyShip4_2;
1849   18               .word EnemyShip4_3;
184B   18               .word EnemyShip4_4;

                 EnemyShip4_1:
184D   00               .byte 0x00;
184E   F6               .byte 0xF6;
184F   0A               .byte 0x0A;
1850   FF               .byte 0xFF;
1851   00               .byte 0x00;
1852   EC               .byte 0xEC;
1853   FF               .byte 0xFF;
1854   14               .byte 0x14;
1855   00               .byte 0x00;
1856   FF               .byte 0xFF;
1857   00               .byte 0x00;
1858   14               .byte 0x14;
1859   FF               .byte 0xFF;
185A   EC               .byte 0xEC;
185B   00               .byte 0x00;
185C   00               .byte 0x00;
185D   F6               .byte 0xF6;
185E   0A               .byte 0x0A;
185F   FF               .byte 0xFF;
1860   00               .byte 0x00;
1861   D8               .byte 0xD8;
1862   FF               .byte 0xFF;
1863   28               .byte 0x28;
1864   00               .byte 0x00;
1865   FF               .byte 0xFF;
1866   00               .byte 0x00;
1867   28               .byte 0x28;
1868   FF               .byte 0xFF;
1869   D8               .byte 0xD8;
186A   00               .byte 0x00;
186B   01               .byte 0x01;

                 EnemyShip4_2:
186C   00               .byte 0x00;
186D   EC               .byte 0xEC;
186E   EC               .byte 0xEC;
186F   FF               .byte 0xFF;
1870   28               .byte 0x28;
1871   00               .byte 0x00;
1872   FF               .byte 0xFF;
1873   00               .byte 0x00;
1874   28               .byte 0x28;
1875   FF               .byte 0xFF;
1876   D8               .byte 0xD8;
1877   00               .byte 0x00;
1878   FF               .byte 0xFF;
1879   00               .byte 0x00;
187A   D8               .byte 0xD8;
187B   00               .byte 0x00;
187C   F6               .byte 0xF6;
187D   F6               .byte 0xF6;
187E   FF               .byte 0xFF;
187F   00               .byte 0x00;
1880   3C               .byte 0x3C;
1881   FF               .byte 0xFF;
1882   3C               .byte 0x3C;
1883   00               .byte 0x00;
1884   FF               .byte 0xFF;
1885   00               .byte 0x00;
1886   C4               .byte 0xC4;
1887   FF               .byte 0xFF;
1888   C4               .byte 0xC4;
1889   00               .byte 0x00;
188A   01               .byte 0x01;

                 EnemyShip4_3:
188B   00               .byte 0x00;
188C   1E               .byte 0x1E;
188D   E2               .byte 0xE2;
188E   FF               .byte 0xFF;
188F   00               .byte 0x00;
1890   3C               .byte 0x3C;
1891   FF               .byte 0xFF;
1892   C4               .byte 0xC4;
1893   00               .byte 0x00;
1894   FF               .byte 0xFF;
1895   00               .byte 0x00;
1896   C4               .byte 0xC4;
1897   FF               .byte 0xFF;
1898   3C               .byte 0x3C;
1899   00               .byte 0x00;
189A   00               .byte 0x00;
189B   0A               .byte 0x0A;
189C   F6               .byte 0xF6;
189D   FF               .byte 0xFF;
189E   B0               .byte 0xB0;
189F   00               .byte 0x00;
18A0   FF               .byte 0xFF;
18A1   00               .byte 0x00;
18A2   50               .byte 0x50;
18A3   FF               .byte 0xFF;
18A4   50               .byte 0x50;
18A5   00               .byte 0x00;
18A6   FF               .byte 0xFF;
18A7   00               .byte 0x00;
18A8   B0               .byte 0xB0;
18A9   01               .byte 0x01;

                 EnemyShip4_4:
18AA   00               .byte 0x00;
18AB   28               .byte 0x28;
18AC   28               .byte 0x28;
18AD   FF               .byte 0xFF;
18AE   B0               .byte 0xB0;
18AF   00               .byte 0x00;
18B0   FF               .byte 0xFF;
18B1   00               .byte 0x00;
18B2   B0               .byte 0xB0;
18B3   FF               .byte 0xFF;
18B4   50               .byte 0x50;
18B5   00               .byte 0x00;
18B6   FF               .byte 0xFF;
18B7   00               .byte 0x00;
18B8   50               .byte 0x50;
18B9   00               .byte 0x00;
18BA   0A               .byte 0x0A;
18BB   0A               .byte 0x0A;
18BC   FF               .byte 0xFF;
18BD   9C               .byte 0x9C;
18BE   00               .byte 0x00;
18BF   FF               .byte 0xFF;
18C0   00               .byte 0x00;
18C1   9C               .byte 0x9C;
18C2   FF               .byte 0xFF;
18C3   64               .byte 0x64;
18C4   00               .byte 0x00;
18C5   FF               .byte 0xFF;
18C6   00               .byte 0x00;
18C7   64               .byte 0x64;
18C8   01               .byte 0x01;

                  FuelBarrier:             /* Referenced from where??? */
18C9   00               .byte 0x00;
18CA   40               .byte 0x40;
18CB   40               .byte 0x40;
18CC   FF               .byte 0xFF;
18CD   81               .byte 0x81;
18CE   00               .byte 0x00;
18CF   FF               .byte 0xFF;
18D0   00               .byte 0x00;
18D1   81               .byte 0x81;
18D2   FF               .byte 0xFF;
18D3   7F               .byte 0x7F;
18D4   00               .byte 0x00;
18D5   FF               .byte 0xFF;
18D6   00               .byte 0x00;
18D7   7F               .byte 0x7F;
18D8   01               .byte 0x01;

                 PlayersShip_1:
18D9   00               .byte 0x00;
18DA   E2               .byte 0xE2;
18DB   00               .byte 0x00;
18DC   FF               .byte 0xFF;
18DD   32               .byte 0x32;
18DE   14               .byte 0x14;
18DF   FF               .byte 0xFF;
18E0   C4               .byte 0xC4;
18E1   64               .byte 0x64;
18E2   FF               .byte 0xFF;
18E3   0A               .byte 0x0A;
18E4   88               .byte 0x88;
18E5   FF               .byte 0xFF;
18E6   F6               .byte 0xF6;
18E7   88               .byte 0x88;
18E8   FF               .byte 0xFF;
18E9   3C               .byte 0x3C;
18EA   64               .byte 0x64;
18EB   FF               .byte 0xFF;
18EC   CE               .byte 0xCE;
18ED   14               .byte 0x14;
18EE   00               .byte 0x00;
18EF   1E               .byte 0x1E;
18F0   0A               .byte 0x0A;
18F1   FF               .byte 0xFF;
18F2   00               .byte 0x00;
18F3   1E               .byte 0x1E;
18F4   FF               .byte 0xFF;
18F5   D8               .byte 0xD8;
18F6   00               .byte 0x00;
18F7   FF               .byte 0xFF;
18F8   00               .byte 0x00;
18F9   E2               .byte 0xE2;
18FA   FF               .byte 0xFF;
18FB   28               .byte 0x28;
18FC   00               .byte 0x00;
18FD   00               .byte 0x00;
18FE   00               .byte 0x00;
18FF   E2               .byte 0xE2;
1900   FF               .byte 0xFF;
1901   00               .byte 0x00;
1902   E2               .byte 0xE2;
1903   FF               .byte 0xFF;
1904   D8               .byte 0xD8;
1905   00               .byte 0x00;
1906   FF               .byte 0xFF;
1907   00               .byte 0x00;
1908   1E               .byte 0x1E;
1909   FF               .byte 0xFF;
190A   28               .byte 0x28;
190B   00               .byte 0x00;
190C   01               .byte 0x01;

                 PlayersShip_2:
190D   00               .byte 0x00;
190E   E2               .byte 0xE2;
190F   00               .byte 0x00;
1910   FF               .byte 0xFF;
1911   32               .byte 0x32;
1912   14               .byte 0x14;
1913   FF               .byte 0xFF;
1914   C4               .byte 0xC4;
1915   64               .byte 0x64;
1916   FF               .byte 0xFF;
1917   0A               .byte 0x0A;
1918   88               .byte 0x88;
1919   FF               .byte 0xFF;
191A   F6               .byte 0xF6;
191B   88               .byte 0x88;
191C   FF               .byte 0xFF;
191D   3C               .byte 0x3C;
191E   64               .byte 0x64;
191F   FF               .byte 0xFF;
1920   CE               .byte 0xCE;
1921   14               .byte 0x14;
1922   00               .byte 0x00;
1923   1E               .byte 0x1E;
1924   14               .byte 0x14;
1925   FF               .byte 0xFF;
1926   00               .byte 0x00;
1927   1E               .byte 0x1E;
1928   FF               .byte 0xFF;
1929   D8               .byte 0xD8;
192A   00               .byte 0x00;
192B   FF               .byte 0xFF;
192C   00               .byte 0x00;
192D   E2               .byte 0xE2;
192E   FF               .byte 0xFF;
192F   28               .byte 0x28;
1930   00               .byte 0x00;
1931   00               .byte 0x00;
1932   00               .byte 0x00;
1933   E2               .byte 0xE2;
1934   FF               .byte 0xFF;
1935   00               .byte 0x00;
1936   E2               .byte 0xE2;
1937   FF               .byte 0xFF;
1938   D8               .byte 0xD8;
1939   00               .byte 0x00;
193A   FF               .byte 0xFF;
193B   00               .byte 0x00;
193C   1E               .byte 0x1E;
193D   FF               .byte 0xFF;
193E   28               .byte 0x28;
193F   00               .byte 0x00;
1940   01               .byte 0x01;

                 PlayersShipExploding_1:
1941   00               .byte 0x00;
1942   E2               .byte 0xE2;
1943   00               .byte 0x00;
1944   02               .byte 0x02;
1945   14               .byte 0x14;
1946   28               .byte 0x28;
1947   FF               .byte 0xFF;
1948   32               .byte 0x32;
1949   14               .byte 0x14;
194A   FF               .byte 0xFF;
194B   C4               .byte 0xC4;
194C   64               .byte 0x64;
194D   FF               .byte 0xFF;
194E   0A               .byte 0x0A;
194F   88               .byte 0x88;
1950   02               .byte 0x02;
1951   00               .byte 0x00;
1952   D8               .byte 0xD8;
1953   FF               .byte 0xFF;
1954   F6               .byte 0xF6;
1955   88               .byte 0x88;
1956   FF               .byte 0xFF;
1957   3C               .byte 0x3C;
1958   64               .byte 0x64;
1959   FF               .byte 0xFF;
195A   CE               .byte 0xCE;
195B   14               .byte 0x14;
195C   02               .byte 0x02;
195D   D8               .byte 0xD8;
195E   28               .byte 0x28;
195F   00               .byte 0x00;
1960   1E               .byte 0x1E;
1961   0A               .byte 0x0A;
1962   FF               .byte 0xFF;
1963   00               .byte 0x00;
1964   1E               .byte 0x1E;
1965   FF               .byte 0xFF;
1966   D8               .byte 0xD8;
1967   00               .byte 0x00;
1968   FF               .byte 0xFF;
1969   00               .byte 0x00;
196A   E2               .byte 0xE2;
196B   FF               .byte 0xFF;
196C   28               .byte 0x28;
196D   00               .byte 0x00;
196E   02               .byte 0x02;
196F   D8               .byte 0xD8;
1970   D8               .byte 0xD8;
1971   00               .byte 0x00;
1972   00               .byte 0x00;
1973   E2               .byte 0xE2;
1974   FF               .byte 0xFF;
1975   00               .byte 0x00;
1976   E2               .byte 0xE2;
1977   FF               .byte 0xFF;
1978   D8               .byte 0xD8;
1979   00               .byte 0x00;
197A   FF               .byte 0xFF;
197B   00               .byte 0x00;
197C   1E               .byte 0x1E;
197D   FF               .byte 0xFF;
197E   28               .byte 0x28;
197F   00               .byte 0x00;
1980   01               .byte 0x01;

                 PlayersShipExploding_2:
1981   00               .byte 0x00;
1982   E2               .byte 0xE2;
1983   00               .byte 0x00;
1984   02               .byte 0x02;
1985   14               .byte 0x14;
1986   28               .byte 0x28;
1987   FF               .byte 0xFF;
1988   32               .byte 0x32;
1989   14               .byte 0x14;
198A   FF               .byte 0xFF;
198B   C4               .byte 0xC4;
198C   64               .byte 0x64;
198D   FF               .byte 0xFF;
198E   0A               .byte 0x0A;
198F   88               .byte 0x88;
1990   02               .byte 0x02;
1991   14               .byte 0x14;
1992   D8               .byte 0xD8;
1993   FF               .byte 0xFF;
1994   F6               .byte 0xF6;
1995   88               .byte 0x88;
1996   FF               .byte 0xFF;
1997   3C               .byte 0x3C;
1998   64               .byte 0x64;
1999   FF               .byte 0xFF;
199A   CE               .byte 0xCE;
199B   14               .byte 0x14;
199C   02               .byte 0x02;
199D   D8               .byte 0xD8;
199E   28               .byte 0x28;
199F   00               .byte 0x00;
19A0   1E               .byte 0x1E;
19A1   14               .byte 0x14;
19A2   FF               .byte 0xFF;
19A3   00               .byte 0x00;
19A4   1E               .byte 0x1E;
19A5   FF               .byte 0xFF;
19A6   D8               .byte 0xD8;
19A7   00               .byte 0x00;
19A8   FF               .byte 0xFF;
19A9   00               .byte 0x00;
19AA   E2               .byte 0xE2;
19AB   FF               .byte 0xFF;
19AC   28               .byte 0x28;
19AD   00               .byte 0x00;
19AE   02               .byte 0x02;
19AF   D8               .byte 0xD8;
19B0   D8               .byte 0xD8;
19B1   00               .byte 0x00;
19B2   00               .byte 0x00;
19B3   E2               .byte 0xE2;
19B4   FF               .byte 0xFF;
19B5   00               .byte 0x00;
19B6   E2               .byte 0xE2;
19B7   FF               .byte 0xFF;
19B8   D8               .byte 0xD8;
19B9   00               .byte 0x00;
19BA   FF               .byte 0xFF;
19BB   00               .byte 0x00;
19BC   1E               .byte 0x1E;
19BD   FF               .byte 0xFF;
19BE   28               .byte 0x28;
19BF   00               .byte 0x00;
19C0   01               .byte 0x01;

                 UnknownCrossHair:      /* Referenced from where??? */
19C1   00               .byte 0x00;
19C2   28               .byte 0x28;
19C3   00               .byte 0x00;
19C4   FF               .byte 0xFF;
19C5   B0               .byte 0xB0;
19C6   00               .byte 0x00;
19C7   00               .byte 0x00;
19C8   28               .byte 0x28;
19C9   28               .byte 0x28;
19CA   FF               .byte 0xFF;
19CB   00               .byte 0x00;
19CC   B0               .byte 0xB0;
19CD   01               .byte 0x01;

                 LeftWallFar_LeftEye:
19CE   00               .byte 0x00;
19CF   A0               .byte 0xA0;
19D0   00               .byte 0x00;
19D1   68               .byte 0x68;
19D2   8A               .byte 0x8A;
19D3   00               .byte 0x00;
19D4   FF               .byte 0xFF;
19D5   D0               .byte 0xD0;
19D6   36               .byte 0x36;
19D7   00               .byte 0x00;
19D8   FF               .byte 0xFF;
19D9   90               .byte 0x90;
19DA   00               .byte 0x00;
19DB   00               .byte 0x00;
19DC   FF               .byte 0xFF;
19DD   D0               .byte 0xD0;
19DE   CA               .byte 0xCA;
19DF   00               .byte 0x00;
19E0   FF               .byte 0xFF;
19E1   00               .byte 0x00;
19E2   B6               .byte 0xB6;
19E3   00               .byte 0x00;
19E4   00               .byte 0x00;
19E5   00               .byte 0x00;
19E6   4A               .byte 0x4A;
19E7   00               .byte 0x00;
19E8   FF               .byte 0xFF;
19E9   68               .byte 0x68;
19EA   00               .byte 0x00;
19EB   01               .byte 0x01;
19EC   FF               .byte 0xFF;
19ED   00               .byte 0x00;
19EE   B6               .byte 0xB6;
19EF   00               .byte 0x00;
19F0   01               .byte 0x01;

                 LeftWallNear_LeftEye:
19F1   00               .byte 0x00;
19F2   A0               .byte 0xA0;
19F3   00               .byte 0x00;
19F4   68               .byte 0x68;
19F5   8A               .byte 0x8A;
19F6   00               .byte 0x00;
19F7   FF               .byte 0xFF;
19F8   D0               .byte 0xD0;
19F9   36               .byte 0x36;
19FA   00               .byte 0x00;
19FB   FF               .byte 0xFF;
19FC   90               .byte 0x90;
19FD   00               .byte 0x00;
19FE   00               .byte 0x00;
19FF   FF               .byte 0xFF;
1A00   D0               .byte 0xD0;
1A01   CA               .byte 0xCA;
1A02   00               .byte 0x00;
1A03   01               .byte 0x01;

                 RightWallFar_RightEye:
1A04   00               .byte 0x00;
1A05   60               .byte 0x60;
1A06   00               .byte 0x00;
1A07   68               .byte 0x68;
1A08   76               .byte 0x76;
1A09   00               .byte 0x00;
1A0A   FF               .byte 0xFF;
1A0B   D0               .byte 0xD0;
1A0C   CA               .byte 0xCA;
1A0D   00               .byte 0x00;
1A0E   FF               .byte 0xFF;
1A0F   90               .byte 0x90;
1A10   00               .byte 0x00;
1A11   00               .byte 0x00;
1A12   FF               .byte 0xFF;
1A13   D0               .byte 0xD0;
1A14   36               .byte 0x36;
1A15   00               .byte 0x00;
1A16   FF               .byte 0xFF;
1A17   00               .byte 0x00;
1A18   4A               .byte 0x4A;
1A19   00               .byte 0x00;
1A1A   00               .byte 0x00;
1A1B   00               .byte 0x00;
1A1C   B6               .byte 0xB6;
1A1D   00               .byte 0x00;
1A1E   FF               .byte 0xFF;
1A1F   68               .byte 0x68;
1A20   00               .byte 0x00;
1A21   01               .byte 0x01;
1A22   FF               .byte 0xFF;
1A23   00               .byte 0x00;
1A24   4A               .byte 0x4A;
1A25   00               .byte 0x00;
1A26   01               .byte 0x01;

                RightWallNear_RightEye:
1A27   00               .byte 0x00;
1A28   60               .byte 0x60;
1A29   00               .byte 0x00;
1A2A   68               .byte 0x68;
1A2B   76               .byte 0x76;
1A2C   00               .byte 0x00;
1A2D   FF               .byte 0xFF;
1A2E   D0               .byte 0xD0;
1A2F   CA               .byte 0xCA;
1A30   00               .byte 0x00;
1A31   FF               .byte 0xFF;
1A32   90               .byte 0x90;
1A33   00               .byte 0x00;
1A34   00               .byte 0x00;
1A35   FF               .byte 0xFF;
1A36   D0               .byte 0xD0;
1A37   36               .byte 0x36;
1A38   00               .byte 0x00;
1A39   01               .byte 0x01;

                RightWallFar_LeftEye:
1A3A   00               .byte 0x00;
1A3B   A0               .byte 0xA0;
1A3C   00               .byte 0x00;
1A3D   34               .byte 0x34;
1A3E   61               .byte 0x61;
1A3F   01               .byte 0x01;
1A40   FF               .byte 0xFF;
1A41   D0               .byte 0xD0;
1A42   A6               .byte 0xA6;
1A43   00               .byte 0x00;
1A44   FF               .byte 0xFF;
1A45   90               .byte 0x90;
1A46   00               .byte 0x00;
1A47   00               .byte 0x00;
1A48   FF               .byte 0xFF;
1A49   D0               .byte 0xD0;
1A4A   5A               .byte 0x5A;
1A4B   00               .byte 0x00;
1A4C   FF               .byte 0xFF;
1A4D   00               .byte 0x00;
1A4E   6A               .byte 0x6A;
1A4F   00               .byte 0x00;
1A50   00               .byte 0x00;
1A51   00               .byte 0x00;
1A52   96               .byte 0x96;
1A53   00               .byte 0x00;
1A54   FF               .byte 0xFF;
1A55   68               .byte 0x68;
1A56   00               .byte 0x00;
1A57   01               .byte 0x01;
1A58   FF               .byte 0xFF;
1A59   00               .byte 0x00;
1A5A   6A               .byte 0x6A;
1A5B   00               .byte 0x00;
1A5C   01               .byte 0x01;

                RightWallNear_LeftEye:
1A5D   00               .byte 0x00;
1A5E   A0               .byte 0xA0;
1A5F   00               .byte 0x00;
1A60   34               .byte 0x34;
1A61   61               .byte 0x61;
1A62   01               .byte 0x01;
1A63   FF               .byte 0xFF;
1A64   D0               .byte 0xD0;
1A65   A6               .byte 0xA6;
1A66   00               .byte 0x00;
1A67   FF               .byte 0xFF;
1A68   90               .byte 0x90;
1A69   00               .byte 0x00;
1A6A   00               .byte 0x00;
1A6B   FF               .byte 0xFF;
1A6C   D0               .byte 0xD0;
1A6D   5A               .byte 0x5A;
1A6E   00               .byte 0x00;
1A6F   01               .byte 0x01;

                LeftWallFar_RightEye:
1A70   00               .byte 0x00;
1A71   60               .byte 0x60;
1A72   00               .byte 0x00;
1A73   34               .byte 0x34;
1A74   9F               .byte 0x9F;
1A75   01               .byte 0x01;
1A76   FF               .byte 0xFF;
1A77   D0               .byte 0xD0;
1A78   5A               .byte 0x5A;
1A79   00               .byte 0x00;
1A7A   FF               .byte 0xFF;
1A7B   90               .byte 0x90;
1A7C   00               .byte 0x00;
1A7D   00               .byte 0x00;
1A7E   FF               .byte 0xFF;
1A7F   D0               .byte 0xD0;
1A80   A6               .byte 0xA6;
1A81   00               .byte 0x00;
1A82   FF               .byte 0xFF;
1A83   00               .byte 0x00;
1A84   96               .byte 0x96;
1A85   00               .byte 0x00;
1A86   00               .byte 0x00;
1A87   00               .byte 0x00;
1A88   6A               .byte 0x6A;
1A89   00               .byte 0x00;
1A8A   FF               .byte 0xFF;
1A8B   68               .byte 0x68;
1A8C   00               .byte 0x00;
1A8D   01               .byte 0x01;
1A8E   FF               .byte 0xFF;
1A8F   00               .byte 0x00;
1A90   96               .byte 0x96;
1A91   00               .byte 0x00;
1A92   01               .byte 0x01;

                 LeftWallNear_RightEye:
1A93   00               .byte 0x00;
1A94   60               .byte 0x60;
1A95   00               .byte 0x00;
1A96   34               .byte 0x34;
1A97   9F               .byte 0x9F;
1A98   01               .byte 0x01;
1A99   FF               .byte 0xFF;
1A9A   D0               .byte 0xD0;
1A9B   5A               .byte 0x5A;
1A9C   00               .byte 0x00;
1A9D   FF               .byte 0xFF;
1A9E   90               .byte 0x90;
1A9F   00               .byte 0x00;
1AA0   00               .byte 0x00;
1AA1   FF               .byte 0xFF;
1AA2   D0               .byte 0xD0;
1AA3   A6               .byte 0xA6;
1AA4   00               .byte 0x00;
1AA5   01               .byte 0x01;

1AA6   00               .byte 0x00;
1AA7   60               .byte 0x60;
1AA8   00               .byte 0x00;
1AA9   B7               .byte 0xB7;
1AAA   3B               .byte 0x3B;
1AAB   01               .byte 0x01;
1AAC   FF               .byte 0xFF;
1AAD   42               .byte 0x42;
1AAE   CA               .byte 0xCA;
1AAF   00               .byte 0x00;
1AB0   FF               .byte 0xFF;
1AB1   00               .byte 0x00;
1AB2   AC               .byte 0xAC;
1AB3   01               .byte 0x01;
1AB4   FF               .byte 0xFF;
1AB5   BE               .byte 0xBE;
1AB6   A6               .byte 0xA6;
1AB7   00               .byte 0x00;
1AB8   FF               .byte 0xFF;
1AB9   00               .byte 0x00;
1ABA   4E               .byte 0x4E;
1ABB   02               .byte 0x02;
1ABC   01               .byte 0x01;

1ABD   00               .byte 0x00;
1ABE   A0               .byte 0xA0;
1ABF   00               .byte 0x00;
1AC0   B7               .byte 0xB7;
1AC1   C5               .byte 0xC5;
1AC2   01               .byte 0x01;
1AC3   FF               .byte 0xFF;
1AC4   42               .byte 0x42;
1AC5   36               .byte 0x36;
1AC6   00               .byte 0x00;
1AC7   FF               .byte 0xFF;
1AC8   00               .byte 0x00;
1AC9   54               .byte 0x54;
1ACA   01               .byte 0x01;
1ACB   FF               .byte 0xFF;
1ACC   BE               .byte 0xBE;
1ACD   5A               .byte 0x5A;
1ACE   00               .byte 0x00;
1ACF   FF               .byte 0xFF;
1AD0   00               .byte 0x00;
1AD1   B2               .byte 0xB2;
1AD2   02               .byte 0x02;
1AD3   01               .byte 0x01;

                 ExplosionVectorTable:
1AD4   1A               .word ExplosionPattern_1;
1AD6   1A               .word ExplosionPattern_2;
1AD8   1B               .word ExplosionPattern_3;
1ADA   1B               .word ExplosionPattern_4;

                 ExplosionPattern_1:
1ADC   FF               .byte 0xFF;
1ADD   3C               .byte 0x3C;
1ADE   00               .byte 0x00;
1ADF   FF               .byte 0xFF;
1AE0   F1               .byte 0xF1;
1AE1   2D               .byte 0x2D;
1AE2   FF               .byte 0xFF;
1AE3   D3               .byte 0xD3;
1AE4   0F               .byte 0x0F;
1AE5   FF               .byte 0xFF;
1AE6   D3               .byte 0xD3;
1AE7   F1               .byte 0xF1;
1AE8   FF               .byte 0xFF;
1AE9   F1               .byte 0xF1;
1AEA   D3               .byte 0xD3;
1AEB   FF               .byte 0xFF;
1AEC   0F               .byte 0x0F;
1AED   D3               .byte 0xD3;
1AEE   FF               .byte 0xFF;
1AEF   2D               .byte 0x2D;
1AF0   F1               .byte 0xF1;
1AF1   FF               .byte 0xFF;
1AF2   2D               .byte 0x2D;
1AF3   0F               .byte 0x0F;
1AF4   01               .byte 0x01;

                 ExplosionPattern_2:
1AF5   FF               .byte 0xFF;
1AF6   64               .byte 0x64;
1AF7   32               .byte 0x32;
1AF8   FF               .byte 0xFF;
1AF9   CE               .byte 0xCE;
1AFA   32               .byte 0x32;
1AFB   FF               .byte 0xFF;
1AFC   9C               .byte 0x9C;
1AFD   00               .byte 0x00;
1AFE   FF               .byte 0xFF;
1AFF   CE               .byte 0xCE;
1B00   CE               .byte 0xCE;
1B01   FF               .byte 0xFF;
1B02   00               .byte 0x00;
1B03   9C               .byte 0x9C;
1B04   FF               .byte 0xFF;
1B05   32               .byte 0x32;
1B06   CE               .byte 0xCE;
1B07   FF               .byte 0xFF;
1B08   64               .byte 0x64;
1B09   00               .byte 0x00;
1B0A   FF               .byte 0xFF;
1B0B   32               .byte 0x32;
1B0C   32               .byte 0x32;
1B0D   01               .byte 0x01;

                 ExplosionPattern_3:
1B0E   FF               .byte 0xFF;
1B0F   78               .byte 0x78;
1B10   00               .byte 0x00;
1B11   FF               .byte 0xFF;
1B12   E2               .byte 0xE2;
1B13   5A               .byte 0x5A;
1B14   FF               .byte 0xFF;
1B15   A6               .byte 0xA6;
1B16   1E               .byte 0x1E;
1B17   FF               .byte 0xFF;
1B18   A6               .byte 0xA6;
1B19   E2               .byte 0xE2;
1B1A   FF               .byte 0xFF;
1B1B   E2               .byte 0xE2;
1B1C   A6               .byte 0xA6;
1B1D   FF               .byte 0xFF;
1B1E   1E               .byte 0x1E;
1B1F   A6               .byte 0xA6;
1B20   FF               .byte 0xFF;
1B21   5A               .byte 0x5A;
1B22   E2               .byte 0xE2;
1B23   FF               .byte 0xFF;
1B24   5A               .byte 0x5A;
1B25   1E               .byte 0x1E;
1B26   01               .byte 0x01;

                 ExplosionPattern_4:
1B27   FF               .byte 0xFF;
1B28   50               .byte 0x50;
1B29   28               .byte 0x28;
1B2A   FF               .byte 0xFF;
1B2B   D8               .byte 0xD8;
1B2C   28               .byte 0x28;
1B2D   FF               .byte 0xFF;
1B2E   B0               .byte 0xB0;
1B2F   00               .byte 0x00;
1B30   FF               .byte 0xFF;
1B31   D8               .byte 0xD8;
1B32   D8               .byte 0xD8;
1B33   FF               .byte 0xFF;
1B34   00               .byte 0x00;
1B35   B0               .byte 0xB0;
1B36   FF               .byte 0xFF;
1B37   28               .byte 0x28;
1B38   D8               .byte 0xD8;
1B39   FF               .byte 0xFF;
1B3A   50               .byte 0x50;
1B3B   00               .byte 0x00;
1B3C   FF               .byte 0xFF;
1B3D   28               .byte 0x28;
1B3E   28               .byte 0x28;
1B3F   01               .byte 0x01;

                 WarlordShipBulletVectorTable:
1B40   1B               .word WarlordShipBullet_1;
1B42   1B               .word WarlordShipBullet_2;
1B44   1B               .word WarlordShipBullet_3;
1B46   1B               .word WarlordShipBullet_4;

                 WarlordShipBullet_1:
1B48   00               .byte 0x00;
1B49   28               .byte 0x28;
1B4A   00               .byte 0x00;
1B4B   FF               .byte 0xFF;
1B4C   B0               .byte 0xB0;
1B4D   00               .byte 0x00;
1B4E   00               .byte 0x00;
1B4F   28               .byte 0x28;
1B50   28               .byte 0x28;
1B51   FF               .byte 0xFF;
1B52   00               .byte 0x00;
1B53   B0               .byte 0xB0;
1B54   01               .byte 0x01;

                 WarlordShipBullet_2:
1B55   00               .byte 0x00;
1B56   3C               .byte 0x3C;
1B57   3C               .byte 0x3C;
1B58   FF               .byte 0xFF;
1B59   88               .byte 0x88;
1B5A   88               .byte 0x88;
1B5B   00               .byte 0x00;
1B5C   00               .byte 0x00;
1B5D   78               .byte 0x78;
1B5E   FF               .byte 0xFF;
1B5F   78               .byte 0x78;
1B60   88               .byte 0x88;
1B61   01               .byte 0x01;

                 WarlordShipBullet_3:
1B62   00               .byte 0x00;
1B63   3C               .byte 0x3C;
1B64   00               .byte 0x00;
1B65   FF               .byte 0xFF;
1B66   88               .byte 0x88;
1B67   00               .byte 0x00;
1B68   00               .byte 0x00;
1B69   3C               .byte 0x3C;
1B6A   3C               .byte 0x3C;
1B6B   FF               .byte 0xFF;
1B6C   00               .byte 0x00;
1B6D   88               .byte 0x88;
1B6E   01               .byte 0x01;

                 WarlordShipBullet_4:
1B6F   00               .byte 0x00;
1B70   28               .byte 0x28;
1B71   28               .byte 0x28;
1B72   FF               .byte 0xFF;
1B73   B0               .byte 0xB0;
1B74   B0               .byte 0xB0;
1B75   00               .byte 0x00;
1B76   00               .byte 0x00;
1B77   50               .byte 0x50;
1B78   FF               .byte 0xFF;
1B79   50               .byte 0x50;
1B7A   B0               .byte 0xB0;
1B7B   01               .byte 0x01;

                 /*
                  * UpdateWarlordShipFrames()
                  *
                  * This function is responsible for updating the information
                  * within the warlord ship frames (C981, C9A3, C9C5, C9E7,
                  * and CA09).  It will update the position of the warlord
                  * ship, recalculating the x and y delta values when the
                  * ship has moved to the edge of its bounding box.  It will
                  * also update the intensity and scale, to make the ship
                  * appear to get closer.  Afterwards, it will check to see
                  * if any of the player's bullets have hit the warlord ship's
                  * target.  If one has, then an explosion is generated, and
                  * then play continues.
                  */
                 UpdateWarlordShipFrames:
1B7C   8601             lda   #0x01;
1B7E   8EC984           ldx   #0xC984;     /* Get addr of frame's scale */
1B81   BD06E0           jsr   $P06E0;
1B84   8EC981           ldx   #0xC981;     /* Get frame addr (Warlord target) */
1B87   A603             lda   3,x;         /* If the scale factor is >= 0x50 */
1B89   8150             cmpa  #0x50;       /* then force it back to 1. */
1B8B   2504             blo   P1B91;
1B8D   8601             lda   #0x01;
1B8F   A703             sta   3,x;
1B91   EC00      P1B91: ldd   0,x;         /* Load current position */
1B93   BDF584           jsr   $get_absolute_value_of_ab;
1B96   C13F             cmpb  #0x3F;       /* If the x position is now out */
1B98   230F             bls   P1BA9;       /* bounds ( |x|>0x3F ), then we */
1B9A   F6C87D           ldb   $C87D;       /* need to generate a new x */
1B9D   C407             andb  #0x07;       /* movement delta.  Force the */
1B9F   CA02             orb   #0x02;       /* movement value to move the */
1BA1   6D01             tst   1,x;         /* ship in the opposite direction. */
1BA3   2F01             ble   P1BA6;
1BA5   50               negb;
1BA6   E78811    P1BA6: stb   0x11,x;     /* Set new x movement delta */
1BA9   813F      P1BA9: cmpa  #0x3F;      /* If the y position is now out */
1BAB   230F             bls   P1BBC;      /* bounds ( |y|>0x3F ), then we */
1BAD   B6C87E           lda   $C87E;      /* need to generate a new y */
1BB0   8407             anda  #0x07;      /* movement delta.  Force the */
1BB2   8A02             ora   #0x02;      /* movement value to move the */
1BB4   6D00             tst   0,x;        /* ship in the opposite direction. */
1BB6   2F01             ble   P1BB9;
1BB8   40               nega;
1BB9   A78813    P1BB9: sta   0x13,x;    /* Set new y movement delta */
1BBC   B6C826    P1BBC: lda   $C826;     /* Update the position only on */
1BBF   8401             anda  #0x01;     /* every other pass. */
1BC1   270A             beq   P1BCD;
1BC3   EC00             ldd   0,x;       /* Load current position */
1BC5   AB8813           adda  0x13,x;    /* y += y movement delta */
1BC8   EB8811           addb  0x11,x;    /* x += x movement delta */
1BCB   ED00             std   0,x;       /* Save new position */
1BCD   A603      P1BCD: lda   3,x;       /* Shuffle down the scale factors */
1BCF   A705             sta   5,x;
1BD1   A702             sta   2,x;
1BD3   A603             lda   3,x;       /* Calculate intensity=scale+0x40 */
1BD5   8B40             adda  #0x40;     /* If rollover, use 0x7F (max) */
1BD7   2A02             bpl   P1BDB;
1BD9   867F             lda   #0x7F;
1BDB   A708      P1BDB: sta   8,x;       /* Set new intensity */
1BDD   CEC9A3           ldu   #0xC9A3;   /* Ptr to other warlord frames */
1BE0   A647      P1BE0: lda   7,u;       /* Sync all warlord ship frames */
1BE2   102C0052         lbge  P1C38;     /* with the warlord's main frame */
1BE6   8EC981           ldx   #0xC981;   /* Get frame ptr (Warlord target) */
1BE9   6D881E           tst   0x1E,x;    /* Check for bullet hit only if */
1BEC   2633             bne   P1C21;     /* explosion not already happening. */
1BEE   BD11C8           jsr   $CheckForCollisionWithBullets;
1BF1   4D               tsta;
1BF2   2601             bne   P1BF5;
1BF4   39               rts;             /* No bullets hit the target */
1BF5   B6C89B    P1BF5: lda   $C89B;     /* A bullet hit the target */
1BF8   8A80             ora   #0x80;
1BFA   B7C89B           sta   $C89B;     /* Force sound to occur */
1BFD   8601             lda   #0x01;
1BFF   B7C8A2           sta   $C8A2;     /* Set sound characteristics index */
1C02   63881E           com   0x1E,x;    /* Tag that explosion is happening */
1C05   8612             lda   #0x12;
1C07   A7881F           sta   0x1F,x;    /* Set explosion duration timer */
1C0A   CC1AD4           ldd   #ExplosionVectorTable;
1C0D   ED09             std   9,x;       /* Set vector list 1 */
1C0F   ED0B             std   11,x;      /* Set vector list 2 */
1C11   CC1C52           ldd   #NE_DrawAnimatedDots;
1C14   ED8820           std   0x20,x;    /* Set drawing function */
1C17   7CC8B1           inc   $C8B1;     /* Increment hit count on warlord */
1C1A   CC0100           ldd   #0x0100;   /* Award 100 pts to the player */
1C1D   BD050F           jsr   $CheckForScoreOver20000;
1C20   39               rts;
1C21   6A881F    P1C21: dec   0x1F,x;    /* Keep displaying explosion, until */
1C24   2701             beq   P1C27;     /* duration timer goes to 0. */
1C26   39               rts;
1C27   6F881E    P1C27: clr   0x1E,x;    /* Redisplay warlord ship target */
1C2A   CC0175           ldd   #DrawAnimatedVectorList_Slow;
1C2D   ED8820           std   0x20,x;    /* Set drawing function */
1C30   CC1D5A           ldd   #WarlordShipTargetVectorTable;
1C33   ED09             std   9,x;       /* Set vector list 1 */
1C35   ED0B             std   11,x;      /* Set vector list 2 */
1C37   39               rts;
1C38   A608      P1C38: lda   8,x;       /* The following block syncs the */
1C3A   A748             sta   8,u;       /* incoming warlord frame info (u) */
1C3C   A603             lda   3,x;       /* with that of the warlord ships */
1C3E   A743             sta   3,u;       /* target frame (x=C981).  This */
1C40   A605             lda   5,x;       /* includes intensities, scale */
1C42   A745             sta   5,u;       /* factors and positions. */
1C44   EC00             ldd   0,x;
1C46   ED40             std   0,u;
1C48   A602             lda   2,x;
1C4A   A742             sta   2,u;
1C4C   33C822           leau  0x22,u;    /* Point to next warlord frame */
1C4F   7E1BE0           jmp   $P1BE0;    /* Process the next frame */

                 /*
                  * NE_DrawAnimatedDots()
                  *
                  * Entry:
                  *   b = scale factor
                  *   x = vector table ptr containing 4 vector list pointers
                  *
                  * This function cycles through a table of vector pointers
                  * (actually, just endpoints, since only dots are drawn),
                  * drawing the indicated collection of dots.  The result is
                  * what appears to be a bunch of animated dots being drawn.
                  */
                 NE_DrawAnimatedDots:
1C52   B6C826           lda   $C826;     /* Use the system loop counter to */
1C55   8403             anda  #0x03;     /* determine which of the 4 dot */
1C57   48               asla;            /* lists to draw. */
1C58   AE86             ldx   a,x;
1C5A   BD01BC           jsr   $NE_DrawDots;
1C5D   39               rts;

                 /*
                  * InitWarlordShipFrames()
                  *
                  * This function fills in the frames used to display the
                  * warlord ship.  The frames are used in the following
                  * fashion:
                  *
                  *    C981 = warlord ship target area
                  *    C9A3 = warlord ship body
                  *    C9C5 = warlord ship body
                  *    C9E7 = warlord ship top/bottom fins
                  *    CA09 = warlord ship side fins
                  *    CA2B = end of frame stack
                  */
                 InitWarlordShipFrames:
1C5E   8EC981           ldx   #0xC981;   /* Get ptr to warlord target frame */
1C61   CE1CC0           ldu   #WarlordShipFrameInfo;
1C64   ECC1      P1C64: ldd   ,u++;      /* Process each entry, until 0x00 */
1C66   2605             bne   P1C6D;     /* encountered. */
1C68   86FF             lda   #0xFF;     /* Mark last frame as the end of */
1C6A   A707             sta   7,x;       /* the frame stack. */
1C6C   39               rts;
1C6D   ED8820    P1C6D: std   0x20,x;    /* Set drawing function */
1C70   ECC1             ldd   ,u++;
1C72   ED0B             std   11,x;      /* Set vector list 2 */
1C74   ECC1             ldd   ,u++;
1C76   ED09             std   9,x;       /* Set vector list 1 */
1C78   A6C0             lda   ,u+;
1C7A   A707             sta   7,x;       /* Set frame number (i.e. color) */
1C7C   6F881E           clr   0x1E,x;    /* Clear explosion flag */
1C7F   6F881B           clr   0x1B,x;    /* Flag player in enemy passage */
1C82   FCC87D           ldd   $C87D;     /* Use the system loop counter to */
1C85   843F             anda  #0x3F;     /* generate a random (y,x) position */
1C87   C43F             andb  #0x3F;     /* where each coordinate is in the */
1C89   7DC87D           tst   $C87D;     /* range of +-0x3F. */
1C8C   2B01             bmi   P1C8F;     /* Determine sign of y value */
1C8E   40               nega;
1C8F   7DC87E    P1C8F: tst   $C87E;
1C92   2B01             bmi   P1C95;     /* Determine sign of x value */
1C94   50               negb;
1C95   ED00      P1C95: std   0,x;       /* Set initial (y,x) position */
1C97   FCC87D           ldd   $C87D;     /* Use the system loop counter to */
1C9A   8407             anda  #0x07;     /* generate random x and y movement */
1C9C   8A02             ora   #0x02;     /* delta values, in the range of */
1C9E   C407             andb  #0x07;     /* 2 - 7 */
1CA0   CA02             orb   #0x02;
1CA2   A78811           sta   0x11,x;    /* Set x movement delta */
1CA5   E78813           stb   0x13,x;    /* Set y movement delta */
1CA8   8601             lda   #0x01;
1CAA   A703             sta   3,x;       /* Set scale factor */
1CAC   A705             sta   5,x;       /* Set embedded obj's scale factor */
1CAE   A702             sta   2,x;
1CB0   A603             lda   3,x;       /* Calculate intensity = scale+0x40 */
1CB2   8B40             adda  #0x40;     /* If rollover occurs, then simply */
1CB4   2A02             bpl   P1CB8;     /* use 0x7F (max). */
1CB6   867F             lda   #0x7F;
1CB8   A708      P1CB8: sta   8,x;       /* Set intensity */
1CBA   308822           leax  0x22,x;    /* Get ptr to next frame */
1CBD   7E1C64           jmp   $P1C64;    /* Continue processing */

                 /*
                  * The following is an array having 6 entries.  Each
                  * entry (with the exception of the last one, which
                  * merely marks the end of the array) is composed of
                  * the following 7 bytes of information:
                  *
                  *        ------------------
                  *      0 |    Drawing     |
                  *        ---            ---
                  *      2 |    Function    |
                  *        ------------------
                  *      3 |    Vector      |
                  *        ---            ---
                  *      4 |  List/Table 1  |
                  *        ------------------
                  *      5 |    Vector      |
                  *        ---            ---
                  *      6 |  List/Table 2  |
                  *        ------------------
                  *      7 | Frame # (color)|
                  *        ------------------
                  */
                 WarlordShipFrameInfo:
1CC0   01               .word DrawAnimatedVectorList_Slow;
1CC2   1D               .word WarlordShipTargetVectorTable;
1CC4   1D               .word WarlordShipTargetVectorTable;
1CC6   02               .byte 0x02;

1CC7   01               .word DrawVectorList;
1CC9   1D               .word WarlordShipBody;
1CCB   1D               .word WarlordShipBody;
1CCD   01               .byte 0x01;

1CCE   01               .word DrawVectorList;
1CD0   1D               .word WarlordShipBody;
1CD2   1D               .word WarlordShipBody;
1CD4   02               .byte 0x02;

1CD5   01               .word DrawVectorList;
1CD7   1D               .word WarlordShipTopBottom;
1CD9   1D               .word WarlordShipTopBottom;
1CDB   03               .byte 0x03;

1CDC   01               .word DrawAnimatedVectorList_Slow;
1CDE   1D               .word WarlordShipSideFinVectorTable_1;
1CE0   1E               .word WarlordShipSideFinVectorTable_2;
1CE2   01               .byte 0x01;

1CE3   00               .word 0x0000;

                 /*
                  * ProcessWarlordShipBullet()
                  *
                  * This function takes care of processing the warlord ship's
                  * single bullet frame.  If the bullet is visible, then
                  * it will update its scale and intensity values, so that
                  * the bullet appears to be coming at the player.  Once the
                  * bullet reaches the front of the screen, is will stop
                  * being displayed; on a later pass, it will attempt to
                  * fire another bullet.
                  */
                 ProcessWarlordShipBullet:
1CE5   8610             lda   #0x10;     /* See if the warship's bullet frame */
1CE7   B5C966           bita  $C966;     /* is visible or invisible. */
1CEA   2724             beq   P1D10;
1CEC   B6C984           lda   $C984;     /* Get warship target's scale factor */
1CEF   8120             cmpa  #0x20;
1CF1   2301             bls   P1CF4;
1CF3   39               rts;
1CF4   B6C87D    P1CF4: lda   $C87D;     /* Use the system loop counter to */
1CF7   81E0             cmpa  #0xE0;     /* control how often to fire a new */
1CF9   2201             bhi   P1CFC;     /* warlord ship bullet. */
1CFB   39               rts;
1CFC   860F      P1CFC: lda   #0x0F;     /* Fire a new warlord ship bullet */
1CFE   B4C966           anda  $C966;
1D01   B7C966           sta   $C966;     /* Retag frame as being visible. */
1D04   FCC8D7           ldd   $C8D7;     /* Set warlord's bullet position the */
1D07   FDC95F           std   $C95F;     /* same as the player's ship. */
1D0A   B6C984           lda   $C984;     /* Start with same scale factor as */
1D0D   B7C962           sta   $C962;     /* the warlord's target area. */
1D10   8EC962    P1D10: ldx   #0xC962;   /* Point to bullet's scale factor. */
1D13   861C             lda   #0x1C;
1D15   BD06E0           jsr   $P06E0;
1D18   8EC95F           ldx   #0xC95F;   /* Point to warlord's bullet frame. */
1D1B   A603             lda   3,x;       /* Get the scale factor. */
1D1D   8170             cmpa  #0x70;     /* Once the scale factor is > 0x70, */
1D1F   2307             bls   P1D28;     /* then the bullet has reached the */
1D21   8610             lda   #0x10;     /* front of the screen, so tag it */
1D23   AA07             ora   7,x;       /* as no longer visible. */
1D25   A707             sta   7,x;
1D27   39               rts;
1D28   A603      P1D28: lda   3,x;       /* Adjust bullets scale & intensity */
1D2A   44               lsra;            /* values, so it appears to grow & */
1D2B   44               lsra;            /* get brighter as it approaches */
1D2C   44               lsra;            /* the front of the screen */
1D2D   A705             sta   5,x;
1D2F   A603             lda   3,x;
1D31   C680             ldb   #0x80;
1D33   3D               mul;
1D34   48               asla;
1D35   A702             sta   2,x;
1D37   A603             lda   3,x;       /* Calculate intensity = scale+0x40 */
1D39   8B40             adda  #0x40;     /* If rollover occurs, then use */
1D3B   2A02             bpl   P1D3F;     /* 0x7F (max). */
1D3D   867F             lda   #0x7F;
1D3F   A708      P1D3F: sta   8,x;       /* Set intensity */
1D41   39               rts;

                 /*
                  * InitWarlordShipBulletFrame()
                  *
                  * This function initializes the frame (C95F) used to
                  * display the warlord ship's single bullet.
                  */
                 InitWarlordShipBulletFrame:
1D42   8EC95F           ldx   #0xC95F;     /* Ptr to warlord bullet frame */
1D45   8612             lda   #0x12;
1D47   A707             sta   7,x;         /* Frame #=0x12 (green,invisible) */
1D49   CC1B40           ldd   #WarlordShipBulletVectorTable;
1D4C   ED09             std   9,x;         /* Set vector list 1 */
1D4E   ED0B             std   11,x;        /* Set vector list 2 */
1D50   CC0181           ldd   #DrawAnimatedVectorList_Fast;
1D53   ED8820           std   0x20,x;      /* Set drawing function */
1D56   6F881E           clr   0x1E,x;      /* Clear explosion flag */
1D59   39               rts;

                 WarlordShipTargetVectorTable:
1D5A   1D               .word WarlordShipTarget_1;
1D5C   1D               .word WarlordShipTarget_2;
1D5E   1D               .word WarlordShipTarget_3;
1D60   1D               .word WarlordShipTarget_4;

                 WarlordShipTarget_1:
1D62   00               .byte 0x00;
1D63   10               .byte 0x10;
1D64   10               .byte 0x10;
1D65   FF               .byte 0xFF;
1D66   00               .byte 0x00;
1D67   E0               .byte 0xE0;
1D68   FF               .byte 0xFF;
1D69   E0               .byte 0xE0;
1D6A   00               .byte 0x00;
1D6B   FF               .byte 0xFF;
1D6C   00               .byte 0x00;
1D6D   20               .byte 0x20;
1D6E   FF               .byte 0xFF;
1D6F   20               .byte 0x20;
1D70   00               .byte 0x00;
1D71   01               .byte 0x01;

                 WarlordShipTarget_2:
1D72   00               .byte 0x00;
1D73   0C               .byte 0x0C;
1D74   0C               .byte 0x0C;
1D75   FF               .byte 0xFF;
1D76   00               .byte 0x00;
1D77   E8               .byte 0xE8;
1D78   FF               .byte 0xFF;
1D79   E8               .byte 0xE8;
1D7A   00               .byte 0x00;
1D7B   FF               .byte 0xFF;
1D7C   00               .byte 0x00;
1D7D   18               .byte 0x18;
1D7E   FF               .byte 0xFF;
1D7F   18               .byte 0x18;
1D80   00               .byte 0x00;
1D81   01               .byte 0x01;

                 WarlordShipTarget_3:
1D82   00               .byte 0x00;
1D83   08               .byte 0x08;
1D84   08               .byte 0x08;
1D85   FF               .byte 0xFF;
1D86   00               .byte 0x00;
1D87   F0               .byte 0xF0;
1D88   FF               .byte 0xFF;
1D89   F0               .byte 0xF0;
1D8A   00               .byte 0x00;
1D8B   FF               .byte 0xFF;
1D8C   00               .byte 0x00;
1D8D   10               .byte 0x10;
1D8E   FF               .byte 0xFF;
1D8F   10               .byte 0x10;
1D90   00               .byte 0x00;
1D91   01               .byte 0x01;

                 WarlordShipTarget_4:
1D92   00               .byte 0x00;
1D93   04               .byte 0x04;
1D94   04               .byte 0x04;
1D95   FF               .byte 0xFF;
1D96   00               .byte 0x00;
1D97   F8               .byte 0xF8;
1D98   FF               .byte 0xFF;
1D99   F8               .byte 0xF8;
1D9A   00               .byte 0x00;
1D9B   FF               .byte 0xFF;
1D9C   00               .byte 0x00;
1D9D   08               .byte 0x08;
1D9E   FF               .byte 0xFF;
1D9F   08               .byte 0x08;
1DA0   00               .byte 0x00;
1DA1   01               .byte 0x01;

                 WarlordShipBody:
1DA2   00               .byte 0x00;
1DA3   7F               .byte 0x7F;
1DA4   7F               .byte 0x7F;
1DA5   FF               .byte 0xFF;
1DA6   81               .byte 0x81;
1DA7   40               .byte 0x40;
1DA8   FF               .byte 0xFF;
1DA9   81               .byte 0x81;
1DAA   C0               .byte 0xC0;
1DAB   FF               .byte 0xFF;
1DAC   00               .byte 0x00;
1DAD   81               .byte 0x81;
1DAE   FF               .byte 0xFF;
1DAF   00               .byte 0x00;
1DB0   81               .byte 0x81;
1DB1   FF               .byte 0xFF;
1DB2   7F               .byte 0x7F;
1DB3   C0               .byte 0xC0;
1DB4   FF               .byte 0xFF;
1DB5   7F               .byte 0x7F;
1DB6   40               .byte 0x40;
1DB7   FF               .byte 0xFF;
1DB8   00               .byte 0x00;
1DB9   7F               .byte 0x7F;
1DBA   FF               .byte 0xFF;
1DBB   00               .byte 0x00;
1DBC   7F               .byte 0x7F;
1DBD   01               .byte 0x01;

                 WarlordShipTopBottom:
1DBE   00               .byte 0x00;
1DBF   7F               .byte 0x7F;
1DC0   C0               .byte 0xC0;
1DC1   FF               .byte 0xFF;
1DC2   00               .byte 0x00;
1DC3   7F               .byte 0x7F;
1DC4   FF               .byte 0xFF;
1DC5   7F               .byte 0x7F;
1DC6   C0               .byte 0xC0;
1DC7   FF               .byte 0xFF;
1DC8   81               .byte 0x81;
1DC9   C0               .byte 0xC0;
1DCA   00               .byte 0x00;
1DCB   80               .byte 0x80;
1DCC   00               .byte 0x00;
1DCD   00               .byte 0x00;
1DCE   80               .byte 0x80;
1DCF   00               .byte 0x00;
1DD0   FF               .byte 0xFF;
1DD1   00               .byte 0x00;
1DD2   7F               .byte 0x7F;
1DD3   FF               .byte 0xFF;
1DD4   81               .byte 0x81;
1DD5   C0               .byte 0xC0;
1DD6   FF               .byte 0xFF;
1DD7   7F               .byte 0x7F;
1DD8   C0               .byte 0xC0;
1DD9   01               .byte 0x01;

                 WarlordShipSideFinVectorTable_1:
1DDA   1D               .word WarlordShipSideFins_1;
1DDC   1E               .word WarlordShipSideFins_2;
1DDE   1E               .word WarlordShipSideFins_3;
1DE0   1E               .word WarlordShipSideFins_4;

                 WarlordShipSideFins_1:
1DE2   00               .byte 0x00;
1DE3   00               .byte 0x00;
1DE4   40               .byte 0x40;
1DE5   00               .byte 0x00;
1DE6   00               .byte 0x00;
1DE7   7F               .byte 0x7F;
1DE8   FF               .byte 0xFF;
1DE9   D0               .byte 0xD0;
1DEA   60               .byte 0x60;
1DEB   FF               .byte 0xFF;
1DEC   60               .byte 0x60;
1DED   00               .byte 0x00;
1DEE   FF               .byte 0xFF;
1DEF   D0               .byte 0xD0;
1DF0   A0               .byte 0xA0;
1DF1   00               .byte 0x00;
1DF2   00               .byte 0x00;
1DF3   81               .byte 0x81;
1DF4   00               .byte 0x00;
1DF5   00               .byte 0x00;
1DF6   81               .byte 0x81;
1DF7   00               .byte 0x00;
1DF8   00               .byte 0x00;
1DF9   81               .byte 0x81;
1DFA   FF               .byte 0xFF;
1DFB   D0               .byte 0xD0;
1DFC   A0               .byte 0xA0;
1DFD   FF               .byte 0xFF;
1DFE   60               .byte 0x60;
1DFF   00               .byte 0x00;
1E00   FF               .byte 0xFF;
1E01   D0               .byte 0xD0;
1E02   60               .byte 0x60;
1E03   01               .byte 0x01;

                 WarlordShipSideFins_2:
1E04   00               .byte 0x00;
1E05   00               .byte 0x00;
1E06   40               .byte 0x40;
1E07   00               .byte 0x00;
1E08   00               .byte 0x00;
1E09   7F               .byte 0x7F;
1E0A   FF               .byte 0xFF;
1E0B   DA               .byte 0xDA;
1E0C   5A               .byte 0x5A;
1E0D   FF               .byte 0xFF;
1E0E   4C               .byte 0x4C;
1E0F   0D               .byte 0x0D;
1E10   FF               .byte 0xFF;
1E11   DA               .byte 0xDA;
1E12   9A               .byte 0x9A;
1E13   00               .byte 0x00;
1E14   00               .byte 0x00;
1E15   81               .byte 0x81;
1E16   00               .byte 0x00;
1E17   00               .byte 0x00;
1E18   81               .byte 0x81;
1E19   00               .byte 0x00;
1E1A   00               .byte 0x00;
1E1B   81               .byte 0x81;
1E1C   FF               .byte 0xFF;
1E1D   DA               .byte 0xDA;
1E1E   9A               .byte 0x9A;
1E1F   FF               .byte 0xFF;
1E20   4C               .byte 0x4C;
1E21   0D               .byte 0x0D;
1E22   FF               .byte 0xFF;
1E23   DA               .byte 0xDA;
1E24   5A               .byte 0x5A;
1E25   01               .byte 0x01;

                  WarlordShipSideFins_3:
1E26   00               .byte 0x00;
1E27   00               .byte 0x00;
1E28   40               .byte 0x40;
1E29   00               .byte 0x00;
1E2A   00               .byte 0x00;
1E2B   7F               .byte 0x7F;
1E2C   FF               .byte 0xFF;
1E2D   EA               .byte 0xEA;
1E2E   54               .byte 0x54;
1E2F   FF               .byte 0xFF;
1E30   2C               .byte 0x2C;
1E31   18               .byte 0x18;
1E32   FF               .byte 0xFF;
1E33   EA               .byte 0xEA;
1E34   94               .byte 0x94;
1E35   00               .byte 0x00;
1E36   00               .byte 0x00;
1E37   81               .byte 0x81;
1E38   00               .byte 0x00;
1E39   00               .byte 0x00;
1E3A   81               .byte 0x81;
1E3B   00               .byte 0x00;
1E3C   00               .byte 0x00;
1E3D   81               .byte 0x81;
1E3E   FF               .byte 0xFF;
1E3F   EA               .byte 0xEA;
1E40   94               .byte 0x94;
1E41   FF               .byte 0xFF;
1E42   2C               .byte 0x2C;
1E43   18               .byte 0x18;
1E44   FF               .byte 0xFF;
1E45   EA               .byte 0xEA;
1E46   54               .byte 0x54;
1E47   01               .byte 0x01;

                 WarlordShipSideFins_4:
1E48   00               .byte 0x00;
1E49   00               .byte 0x00;
1E4A   40               .byte 0x40;
1E4B   00               .byte 0x00;
1E4C   00               .byte 0x00;
1E4D   7F               .byte 0x7F;
1E4E   FF               .byte 0xFF;
1E4F   FE               .byte 0xFE;
1E50   50               .byte 0x50;
1E51   FF               .byte 0xFF;
1E52   05               .byte 0x05;
1E53   20               .byte 0x20;
1E54   FF               .byte 0xFF;
1E55   FE               .byte 0xFE;
1E56   90               .byte 0x90;
1E57   00               .byte 0x00;
1E58   00               .byte 0x00;
1E59   81               .byte 0x81;
1E5A   00               .byte 0x00;
1E5B   00               .byte 0x00;
1E5C   81               .byte 0x81;
1E5D   00               .byte 0x00;
1E5E   00               .byte 0x00;
1E5F   81               .byte 0x81;
1E60   FF               .byte 0xFF;
1E61   FE               .byte 0xFE;
1E62   90               .byte 0x90;
1E63   FF               .byte 0xFF;
1E64   05               .byte 0x05;
1E65   20               .byte 0x20;
1E66   FF               .byte 0xFF;
1E67   FE               .byte 0xFE;
1E68   50               .byte 0x50;
1E69   01               .byte 0x01;

                 WarlordShipSideFinVectorTable_2:
1E6A   1E               .word WarlordShipSideFin_5;
1E6C   1E               .word WarlordShipSideFin_6;
1E6E   1E               .word WarlordShipSideFin_7;
1E70   1E               .word WarlordShipSideFin_8;

                 WarlordShipSideFin_5:
1E72   00               .byte 0x00;
1E73   00               .byte 0x00;
1E74   40               .byte 0x40;
1E75   00               .byte 0x00;
1E76   00               .byte 0x00;
1E77   7F               .byte 0x7F;
1E78   FF               .byte 0xFF;
1E79   D0               .byte 0xD0;
1E7A   60               .byte 0x60;
1E7B   FF               .byte 0xFF;
1E7C   60               .byte 0x60;
1E7D   00               .byte 0x00;
1E7E   FF               .byte 0xFF;
1E7F   D0               .byte 0xD0;
1E80   A0               .byte 0xA0;
1E81   00               .byte 0x00;
1E82   00               .byte 0x00;
1E83   81               .byte 0x81;
1E84   00               .byte 0x00;
1E85   00               .byte 0x00;
1E86   81               .byte 0x81;
1E87   00               .byte 0x00;
1E88   00               .byte 0x00;
1E89   81               .byte 0x81;
1E8A   FF               .byte 0xFF;
1E8B   D0               .byte 0xD0;
1E8C   A0               .byte 0xA0;
1E8D   FF               .byte 0xFF;
1E8E   60               .byte 0x60;
1E8F   00               .byte 0x00;
1E90   FF               .byte 0xFF;
1E91   D0               .byte 0xD0;
1E92   60               .byte 0x60;
1E93   01               .byte 0x01;

                 WarlordShipSideFin_6:
1E94   00               .byte 0x00;
1E95   00               .byte 0x00;
1E96   40               .byte 0x40;
1E97   00               .byte 0x00;
1E98   00               .byte 0x00;
1E99   7F               .byte 0x7F;
1E9A   FF               .byte 0xFF;
1E9B   DA               .byte 0xDA;
1E9C   66               .byte 0x66;
1E9D   FF               .byte 0xFF;
1E9E   4C               .byte 0x4C;
1E9F   F3               .byte 0xF3;
1EA0   FF               .byte 0xFF;
1EA1   DA               .byte 0xDA;
1EA2   A6               .byte 0xA6;
1EA3   00               .byte 0x00;
1EA4   00               .byte 0x00;
1EA5   81               .byte 0x81;
1EA6   00               .byte 0x00;
1EA7   00               .byte 0x00;
1EA8   81               .byte 0x81;
1EA9   00               .byte 0x00;
1EAA   00               .byte 0x00;
1EAB   81               .byte 0x81;
1EAC   FF               .byte 0xFF;
1EAD   DA               .byte 0xDA;
1EAE   A6               .byte 0xA6;
1EAF   FF               .byte 0xFF;
1EB0   4C               .byte 0x4C;
1EB1   F3               .byte 0xF3;
1EB2   FF               .byte 0xFF;
1EB3   DA               .byte 0xDA;
1EB4   66               .byte 0x66;
1EB5   01               .byte 0x01;

                 WarlordShipSideFin_7:
1EB6   00               .byte 0x00;
1EB7   00               .byte 0x00;
1EB8   40               .byte 0x40;
1EB9   00               .byte 0x00;
1EBA   00               .byte 0x00;
1EBB   7F               .byte 0x7F;
1EBC   FF               .byte 0xFF;
1EBD   EA               .byte 0xEA;
1EBE   6C               .byte 0x6C;
1EBF   FF               .byte 0xFF;
1EC0   2C               .byte 0x2C;
1EC1   E8               .byte 0xE8;
1EC2   FF               .byte 0xFF;
1EC3   EA               .byte 0xEA;
1EC4   AC               .byte 0xAC;
1EC5   00               .byte 0x00;
1EC6   00               .byte 0x00;
1EC7   81               .byte 0x81;
1EC8   00               .byte 0x00;
1EC9   00               .byte 0x00;
1ECA   81               .byte 0x81;
1ECB   00               .byte 0x00;
1ECC   00               .byte 0x00;
1ECD   81               .byte 0x81;
1ECE   FF               .byte 0xFF;
1ECF   EA               .byte 0xEA;
1ED0   AC               .byte 0xAC;
1ED1   FF               .byte 0xFF;
1ED2   2C               .byte 0x2C;
1ED3   E8               .byte 0xE8;
1ED4   FF               .byte 0xFF;
1ED5   EA               .byte 0xEA;
1ED6   6C               .byte 0x6C;
1ED7   01               .byte 0x01;

                 WarlordShipSideFin_8:
1ED8   00               .byte 0x00;
1ED9   00               .byte 0x00;
1EDA   40               .byte 0x40;
1EDB   00               .byte 0x00;
1EDC   00               .byte 0x00;
1EDD   7F               .byte 0x7F;
1EDE   FF               .byte 0xFF;
1EDF   FE               .byte 0xFE;
1EE0   70               .byte 0x70;
1EE1   FF               .byte 0xFF;
1EE2   05               .byte 0x05;
1EE3   E0               .byte 0xE0;
1EE4   FF               .byte 0xFF;
1EE5   FE               .byte 0xFE;
1EE6   B0               .byte 0xB0;
1EE7   00               .byte 0x00;
1EE8   00               .byte 0x00;
1EE9   81               .byte 0x81;
1EEA   00               .byte 0x00;
1EEB   00               .byte 0x00;
1EEC   81               .byte 0x81;
1EED   00               .byte 0x00;
1EEE   00               .byte 0x00;
1EEF   81               .byte 0x81;
1EF0   FF               .byte 0xFF;
1EF1   FE               .byte 0xFE;
1EF2   B0               .byte 0xB0;
1EF3   FF               .byte 0xFF;
1EF4   05               .byte 0x05;
1EF5   E0               .byte 0xE0;
1EF6   FF               .byte 0xFF;
1EF7   FE               .byte 0xFE;
1EF8   70               .byte 0x70;
1EF9   01               .byte 0x01;

             /* Open space = 1EFA - 1FFF */
