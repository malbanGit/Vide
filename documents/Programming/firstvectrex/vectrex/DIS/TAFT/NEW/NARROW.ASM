; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti narrow.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html


*
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
*              $FF = yes.
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
*                      $01 = Normal game noise
*                      $02 = Enemy ship coming
*                      $08 = Player passed through fuel wall opening
*                      $10 = Player picked up fuel
*                      $20 = Player fired a bullet
*                      $40 = Player out of fuel
*                      $80 = Enemy ship hit or player hit fuel wall.
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
* C8A6         Boolean: flags whether we are drawing for the left eye ($FF)
*              or the right eye ($00).
*
* C8A7-C8AA    Unused.
*
* C8AB-C8AC    Indirect jump pointer; indicates main processing function.
*
* C8AD-C8AE    Counter.
*
* C8AF         Boolean: indicates whether the passage walls should be
*              drawn ($FF).  When player first enters a new level, the
*              walls are not initially drawn.
*
* C8B0         Boolean: indicates if player picked up fuel cannister ($FF).
*
* C8B1         During normal play, indicates the number of enemy ships
*              destroyed.  During battle with the warlord ship, indicates
*              the number of hits on the warlord ship.
*
* C8B2         Boolean: indicates that player has completed the current
*              level ($FF).  Used both for enemy levels, and fuel levels.
*
* C8B3         Unused.
*
* C8B4         Number of fuel components (walls and cannisters) created
*              so far.
*
* C8B5         Boolean: controls whether a fuel wall ($00) or a fuel
*              cannister ($FF) is drawn next.
*
* C8B6         Index in range 0-2; used during drawing of fuel walls and
*              cannisters to index into an array which specifies the color
*              used when drawing the fuel component.
*
* C8B7-C8B8    Alternate scale factor; used during drawing of when some
*              objects are exploding.
*
* C8B9         Boolean: indicates if the player's ship is done
*              exploding ($FF).
*
* C8BA         Boolean: flags if enemy ship and player have collided;
*              $00= no collision, $FF = collision.
*
* C8BB         Velocity of enemy star; used to update 'y' value.
*
* C8BC         Boolean: flags if enemy star and player have collided;
*              $00= no collision, $FF = collision.
*
* C8BD         Current level (0-?).  Also used to calculate the number of
*              enemy ships for the level (level + 6), and the number of
*              fuel cannisters ((level* 2) + 5).  Also used to control
*              which enemy ship is used for this level.
*
* C8BE-C8C5    String Buffer: Ship count. Default = "SHIPS 3",$80.
*
* C8C6-C8CC    String Buffer: Player's score. Default = "     0",$80.
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
* CA7D         Boolean: indicates if the user is completely out of fuel ($FF).
*
* CA7E         Boolean: flags that the player is low on fuel ($FF).
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
* CA86         Number of times the IRQ happed*after* the refresh timer
*              elapsed for this set of 8 samplings.
*
* CA87         Number of times the IRQ happed*after* the refresh timer
*              elapsed for (pass-1) set of 8 samplings.
*
* CA88         Number of times the IRQ happed*after* the refresh timer
*              elapsed for (pass-2) set of 8 samplings.
*
* CA89         Number of times the IRQ happed*after* the refresh timer
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
*              1E | Explosion happening flag ($FF = explosion)
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
*                      $01 = Blue
*                      $02 = Green
*                      $03 = Red
*                      $FF = End of frame stack
*                      or'ed with $10 = Frame not visible
*
* Note 3:      Player State
*
*              $00 = Player is in the enemy passage.
*              $FF = Player is in the fuel passage.
*
******************************************************************************
*

       include "taft.i"

       noopt
       org 0
       direct -1
       DB      "g GCE 1983",$80;

       DW    intro_music_block;

       DB    $F8;* height
       DB    $40;* width
       DB    $10;* rel y
       DB    $E0;* rel x
       DB      "NARROW",$80;
       DB    $F8;* height
       DB    $40;* width
       DB    $00;* rel y
       DB    $E0;* rel y
       DB      "ESCAPE",$80,$00;

start: jsr   reinit;
       jsr   init_music_buf;
       jsr   do_sound;
       lda   #$10;
       sta   $C81A;   * Set joystick approximation factor
       clr   $C821;   * Disable console 2 joysticks
       clr   $C822;   * Disable console 2 joysticks
       ldx   #StartupNewGame;
       stx   $C8AB;   * Set the indirect jump ptr
       clr   $C89B;   * Clear sound bitmask
       clr   $C89F;
       lda   #$01;
       sta   $C8A2;   * Set sound characteristics index
       ldd   #$00E0;
       std   $C83D;   * Set refresh timer = 0.0382 sec
       stb   $CA8E;
       ldd   #$0008;
       std   $CA86;
       stb   $CA8A;   * Init IRQ handler's loop counter
       clr   $CA8C;
       clr   $CA8D;
       ldd   #$7E82;
       sta   $CBF8;   * Set up IRQ interrupt vector: JMP
       stb   <$0E;
       ldd   #IRQ_Handler;
       std   $CBF9;   * Set IRQ interrupt function: Sync
       lda   #$CD;    * Force goggle index to trigger off
       sta   <$0C;    * positive edge.
       clr   $C891;   * Set loop counter = 0

* Wait for the goggle's disk to come upto speed*
P0076: ldd   $C83D;
       std   <$08;    * Set refresh timer
       ldb   $C845;   * Get current I/O enable setting
       andb  #$BF;
P0080: lda   #$07;
       jsr   $F25B;  * Config Port A as an input
       bsr   GetGoggleIndexState;
       sta   $CA7F;
P008A: ldb   $C845;   * Get current I/O enable setting
       orb   #$40;
       lda   #$07;
       jsr   $F25B;  * Config Port A as an output
       ldd   #$0E80; * Write $80 to Port A
       jsr   byte_2_sound_chip;
       ldb   #$60;   * Set timing loop value
P009C: decb;
       bne   P009C;   * Delay for awhile
       ldd   #$0EFF; * Write $FF to Port A
       jsr   byte_2_sound_chip;
       ldb   $C845;
       andb  #$BF;
       lda   #$07;
       jsr   $F25B;  * Set Port A as an input
       bsr   GetGoggleIndexState;
       tst   $CA7F;   * See if the goggle's sync line
       bne   P00B9;   * has gone from off to on.
       tsta;
       bne   P00BE;   * Sync line changed
P00B9: sta   $CA7F;
       bra   P008A;
P00BE: lda   <$0D;    * If the refresh timer elapsed, then
       bita  #$20;   * the goggle disk is not yet upto
       bne   P0076;   * speed; go thru another pass.
       inc   $C891;   * The disk is now upto speed; for
       lda   $C891;   * good measure, repeat, for a
       cmpa  #$03;   * total of 3 times.
       bne   P0076;
       bra   MainGameLoop;

*
* GetGoggleIndexState()
*
* Check to see if the color wheel index has been seen.
*
* Exit: a = state of goggle index signal
*           0 => index signal not seen
*           !=0 => index signal seen
*
GetGoggleIndexState:
       lda   #$0E;
       sta   <$01;
       ldd   #$1901;
       sta   <$00;
       nop;
       stb   <$00;
       clr   <$03;    * Set Port A lines as inputs
       ldd   #$0901;
       sta   <$00;
       nop;
       lda   <$01;    * Read Port A lines
       nop;
       stb   <$00;
       ldb   #$FF;
       stb   <$03;    * Set Port A lines as outputs
       anda  #$80;
       rts;

*
* Main loop for this game.  Reads buttons and joystick,
* does drawing, and then wait for the IRQ.
*
MainGameLoop:
       jsr   set_refresh;

ReturnFromIRQ:
       ldd   $C83D;
       std   <$08;    * Set refresh timer
       ldb   $C845;
       andb  #$BF;
       lda   #$07;
       jsr   $F25B;  * Config Port A as an input
       jsr   read_switches2;
       ldb   $C845;
       orb   #$40;
       lda   #$07;
       jsr   $F25B;  * Config Port A as an output
       ldd   #$0E80; * Write $80 to Port A
       jsr   byte_2_sound_chip;
       ldd   #$FF02;
       sta   $CA8B;
       stb   <$0D;    * Clear goggle index intrpt flag
       andcc #$EF;   * Enable goggle index intrpt (IRQ)
       ldd   $C825;
       addd  #$0001; * For each pass, increment the
       std   $C825;   * 'refresh timer expired' counter.
       jsr   DoDrawing;
       clr   $C823;   * Disable joystick approximation
       jsr   read_jstick;
       jsr   P0353;
       jsr   $F35B;
       ldb   #$10;
P0139: decb;          * Timing loop
       bne   P0139;
       clr   $CA8B;
       cwai  #$EF;   * Enable IRQ & wait for goggle index
                 ;   * interrupt.

P0141: jsr   do_sound;
       clr   $C856;
       jsr   dptoC8;
       jsr   P14EB;
       jsr   dptoD0;
       rts;

*
* DrawVectorList()
*
* Entry:
*   b = scale factor
*   x = ptr to vector list of form:
*
*             mode, y, x
*             mode, y, x
*              .
*             $01
*
*       where mode = $00 (move), $FF (draw) or $01 (end).
*
* This function draws a list of vectors.
*
*
DrawVectorList:
       stb   <$04;      * Save scale factor
P0153: ldd   1,x;       * Load the y position
       sta   <$01;      * Write y value
       clr   <$00;
       lda   0,x;       * Load the line pattern
       leax  3,x;
       inc   <$00;
       stb   <$01;      * Write x value
       sta   <$0A;      * Write the line pattern
       clr   <$05;
       ldd   #$0040;
P0168: bitb  <$0D;      * Wait for the timer interrupt
       beq   P0168;
       exg   x,x;
       sta   <$0A;      * Clear the line pattern
       lda   0,x;       * Check the mode for the next pt
       ble   P0153;     * Keep drawing, until mode = $01
       rts;

*
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
*             $01
*
*       where mode = $00 (move), $FF (draw) or $01 (end).
*
* This function uses a system loop counter (C826)/4 to
* determine which of the 4 vector lists to draw.  This
* formula causes the visuals to change every 4th time
* through the processing loop.
*
DrawAnimatedVectorList_Slow:
       lda   $C826;
       lsra;
       lsra;
P017A: anda  #$03;
       asla;
       ldx   a,x;
       bra   DrawVectorList;

*
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
*             $01
*
*       where mode = $00 (move), $FF (draw) or $01 (end).
*
* This function uses a system loop counter (C826) to
* determine which of the 4 vector lists to draw.  This
* formula causes the visuals to change every time
* through the processing loop.
*
DrawAnimatedVectorList_Fast:
       lda   $C826;
       bra   P017A;

*
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
*             $01
*
*       where mode = $00 (move), $FF (draw) $01 (end), or
*                    $02 (move using alternate scale factor)
*
* This function draws a series of vectors.  Usually, the
* incoming scale factor will be used.  However, if the
* mode is $02, then the alternate scale factor (in C8B7)
* is used, and the operation is treated as a 'move'.
*
DrawWithMixedScaleFactors:
       pshs  b;       * Save the incoming scale factor
P0188: ldb   0,s;     * Load the incoming scale factor
       stb   <$04;    * Write the scale factor
       ldd   1,x;     * Load the y,x values
       sta   <$01;    * Write the y value
       clr   <$00;
       lda   0,x;     * Load the mode value
       ble   P019C;   * Use alternate scale factor?
       lda   $C8B7;   * Yes
       sta   <$04;    * Write the alternate scale factor
       clra;          * Treat like a move request
P019C: leax  3,x;
       inc   <$00;
       stb   <$01;    * Write the x value
       sta   <$0A;    * Write the line pattern
       clr   <$05;
       ldd   #$0040;
P01A9: bitb  <$0D;    * Wait for the timer interrupt
       beq   P01A9;
       exg   x,x;
       sta   <$0A;    * Clear the line pattern
       lda   0,x;     * Look at mode for next endpoint
       cmpa  #$01;   * Time to quit?
       bne   P0188;
       puls  b;       * Yes
       jmp   P0353;

*
* NE_DrawDots()
*
* Entry:
*   b = scale factor
*   x = ptr to vector list, of the form:
*
*             mode, y, x
*             mode, y, x
*              .
*             $01
*
*       where mode = $01 (end), else all others (move and
*                    then draw a dot).
*
* This function ignores the 'mode' field, except for
* using it to tag the end of the vector list.  It will
* move to the indicated (y,x) position, and will then
* draw a dot.
*
NE_DrawDots:
       stb   <$04;     * Save the scale factor
P01BE: ldd   1,x;      * Load the y,x values
       sta   <$01;     * Write the y value
       clr   <$00;
       clra;           * Load the line pattern
       leax  3,x;      * Advance to next vector entry
       inc   <$00;
       stb   <$01;     * Write the x value
       sta   <$0A;     * Clear the line pattern
       clr   <$05;
       ldd   #$0040;
P01D2: bitb  <$0D;     * Wait for the timer interrupt
       beq   P01D2;
       exg   x,x;
       com   <$0A;     * Start drawing a dot
       nop;
       nop;
       com   <$0A;     * Stop drawing a dot
       lda   0,x;      * Check mode for next endpoint
       ble   P01BE;    * End of vector list?
       rts;            * Yes

DrawThenZeroIntegrators:
       bsr   Draw4ByteVectorLists;
       lda   #$CD;    * Set goggle index to trigger off
       sta   <$0C;     * of positive edge; also zero
       rts;            * the integrators.

*
* Draw4ByteVectorLists()
*
* Entry:
*   CA81 = frame's scale factor
*   x = ptr to vector list, of the form:
*
*             mode, y, x, counter
*             mode, y, x, counter
*              .
*             $01
*
*       where mode = $FF (draw), $00(move) or $01 (end).
*
* This function will draw the indicated vectors, using
* the passed-in 8-bit scale factor, unless the counter is
* >0, in which case, it will calculate a 16-bit scale
* factor to use.
*
Draw4ByteVectorLists:
       clr   <$00;
       lda   1,x;      * Load the y value
       sta   <$01;     * Write the y value
       ldb   3,x;      * Load the counter
       stb   $CA82;    * Save the counter
       ldb   #$55;
       stb   $CA83;
       ldb   $CA81;    * Load frame's scale factor
       clra;           * Assume hi-byte scale factor = 0
       dec   $CA82;    * If counter was <= 0, do normal
       bmi   P0211;    * drawing.
P0203: asl   $CA83;    * Calculate a 16 bit scale factor
       rolb;
       rola;
       addb  #$03;
       adca  #$00;
       dec   $CA82;
       bpl   P0203;
P0211: stb   <$04;     * Write the scale factor
       ldb   2,x;      * Load the x value
       inc   <$00;
       stb   <$01;     * Write the x value
       ldb   0,x;      * Load the drawing pattern
       orcc  #$10;    * Mask (disable) IRQ
       stb   <$0A;     * Write the drawing pattern
       sta   <$05;     * Write hi-byte of scale factore
       ldb   #$40;
P0223: bitb  <$0D;     * Wait for timer interrupt
       beq   P0223;
       leax  4,x;      * Advance to next endpoint
       leax  0,x;
       clr   <$0A;     * Clear the drawing pattern
       andcc #$EF;    * Unmask (reenable) IRQ
       lda   $CA8D;
       beq   P0238;
       cmpa  <$09;
       bhi   P023D;
P0238: lda   0,x;
       ble   DrawThenZeroIntegrators;
       rts;
P023D: ldd   #$0EFF;
       jsr   $F25B;   * Write $FF to Port A
       ldb   $C845;
       andb  #$BF;
       lda   #$07;
       jsr   $F25B;   * Config Port A as input
       clr   $CA8D;
       bra   P0238;

P0252: lda   $CA8D;
       bne   P0258;
       rts;
P0258: cmpa  <$09;
       bhi   P025D;
       rts;
P025D: ldd   #$0EFF;
       jsr   $F25B;   * Write $FF to Port A
       ldb   $C845;
       andb  #$BF;
       lda   #$07;
       jsr   $F25B;   * Config Port A as input
       clr   $CA8D;
       rts;

*
* IRQ_Handler()
*
* This code appears to try to detect if the goggle's
* disk has slowed down too much, thus allowing the
* refresh timeout to occur*before* the disk has
* made a revolution.  When too many failures occur,
* it appears to adjust some variables, apparently
* with the hope of giving the disk time to get
* back into sync again.
*
IRQ_Handler:
       clr   <$0A;     * Clear line drawing pattern
       lda   <$0D;
       bita  #$20;    * Did refresh timer already expire?
       bne   Timeout;  * Yes; so mark another timeout
       lda   $CA8E;
       sta   $CA8D;
       dec   $CA8A;    * Decrement the IRQ loop counter
       bgt   FinishIRQ;* Have we taken 8 samples?
       bra   ProcessSamples; * Yes; process the results
Timeout:
       lda   $CA8C;    * Refresh timer elapsed
       sta   $CA8D;
       inc   $CA86;    * Increment failure counter
       dec   $CA8A;    * Have we taken 8 samples?
       bgt   FinishIRQ;* Nope; do nothing
ProcessSamples:
       ldb   #$08;
       stb   $CA8A;    * Reset IRQ sample counter
       ldb   $CA86;    * Sum the # of failures for this
       addb  $CA87;    * pass and the previous pass.
       tfr   b,a;
       suba  #$0D;
       nega;
       cmpb  #$0D;
       beq   P02BC;
       bpl   P02B4;
       adda  $CA8C;
       blo   P02BC;
       sta   $CA8C;
       bra   P02BC;
P02B4: adda  $CA8C;
       bhs   P02BC;
       sta   $CA8C;
P02BC: addb  $CA88;    * Failures for (pass - 2)
       addb  $CA89;    * Failures for (pass - 3)
       subb  #$18;
       beq   P02E1;
       tfr   b,a;
       clrb;
       nega;
       asra;
       rorb;
       tsta;
       bmi   P02D9;
       addd  $CA8E;
       blo   P02E1;
       std   $CA8E;
       bra   P02E1;
P02D9: addd  $CA8E;
       bhs   P02E1;
       std   $CA8E;
P02E1: lda   $CA8E;
       suba  #$1A;
       suba  $CA8C;
       bhi   ShuffleFailureInfo;
       lda   $CA8C;
       adda  #$1A;
       sta   $CA8E;
ShuffleFailureInfo:
       ldd   $CA87;    * Shuffle down the failure results
       std   $CA88;    * information for the last 3 passes
       lda   $CA86;    * discarding the results for the
       sta   $CA87;    * oldest pass.
       clr   $CA86;    * Start w/ 0 failures for next pass
FinishIRQ:
       nop;
       ldd   #$0EFF;  * Write $FF to Port A
       jsr   byte_2_sound_chip;
       ldb   $C845;
       orb   #$40;
       lda   #$07;
       jsr   $F25B;   * Config Port A as an output
       jsr   reset0ref;
       lds   #$CBEA;
       jmp   ReturnFromIRQ;

*
* DrawOneEnemyPassageWall()
*
* Entry:
*   x = ptr to vector list.
*   y = ptr to scale factor.
*
* Draw a single wall in the enemy passage; the intensity
* used is based upon the value at (0,y).
*
DrawOneEnemyPassageWall:
       lda   0,y;      * Quit when the incoming scale
       cmpa  #$FF;    * factor is $FF.
       bne   P0324;
       rts;
P0324: pshs  x;
       ldb   #$1C;
       stb   <$04;     * Set scale factor = $1C
       ldd   ,x++;     * Load (y,x) values
       sta   <$01;     * Write y value
       clr   <$00;
       lda   #$CF;    * Un-zero integrators, and trigger
       sta   <$0C;     * IRQ on positive edge.
       inc   <$00;
       stb   <$01;     * Write x value
       ldb   #$40;
       clr   <$05;
P033C: bitb  <$0D;     * Wait for scale timer interrupt
       beq   P033C;
       lda   0,y;
       sta   $CA81;    * Save scale factor
       adda  #$40;    * Calculate intensity = scale+$40
       bpl   P034B;
       lda   #$7F;    * If rollover, use $7F (max).
P034B: jsr   intensity_to_a;
       jsr   DrawThenZeroIntegrators;
       puls  x;
P0353: lda   #$CD;    * Zero integrators, and trigger IRQ
       sta   <$0C;     * on positive edge.
       jsr   $F35B;
       jsr   $F57D;
       rts;

*
* DrawFuelWall()
*
* Entry:
*   x = ptr to 4-byte vector list.
*
* This function draws a fuel wall, including the appropriate
* embedded fuel wall opening.
*
DrawFuelWall:
       pshs  x;
       ldx   #FuelWall;
P0363: clr   <$00;
       lda   1,x;
       sta   <$01;     * Write the y value
       ldb   3,x;
       stb   $CA82;    * Set the loop counter
       ldb   #$55;
       stb   $CA83;
       ldb   $CA81;    * Get saved scale factor
       clra;
       dec   $CA82;
       bmi   P038A;
P037C: asl   $CA83;
       rolb;
P0380: rola;
       addb  #$03;
       adca  #$00;
       dec   $CA82;    * Decrement loop counter
       bpl   P037C;    * Are we done looping yet?
P038A: stb   <$04;     * Write scale factor
       ldb   2,x;
       inc   <$00;
       stb   <$01;     * Write x value
       ldb   0,x;      * Get the line drawing pattern
       orcc  #$10;    * Disable IRQ interrupts
       stb   <$0A;     * Write the line drawing pattern
       sta   <$05;     * Save hi byte of scale factor
       ldb   #$40;
P039C: bitb  <$0D;     * Wait for scale timer interrupt
       beq   P039C;
       leax  4,x;      * Advance ptr to next point
       leax  0,x;
       clr   <$0A;     * Clear line drawing pattern
       andcc #$EF;    * Reenable IRQ interrupts
       lda   $CA8D;
       beq   P03B1;
       cmpa  <$09;
       bhi   P03B7;
P03B1: lda   0,x;
       ble   P0363;
       bra   P03CC;
P03B7: ldd   #$0EFF;
       jsr   $F25B;   * Write $FF to Port A
       ldb   $C845;
       andb  #$BF;
       lda   #$07;
       jsr   $F25B;   * Config Port A as input
       clr   $CA8D;
       bra   P03B1;
P03CC: lda   #$CF;    * Un-zero integrators, & trigger
       sta   <$0C;     * IRQ off positive edge.
       ldd   $1C,y;   * Get position of embedded object
       sta   <$01;     * Write the y value
       clr   <$00;
       lda   5,y;      * Get embedded obj's scale factor
       sta   <$04;     * Write the scale factor
       exg   x,x;
       inc   <$00;
       stb   <$01;     * Write the x value
       ldb   #$40;
       clr   <$05;
P03E5: bitb  <$0D;     * Wait for scale timer interrupt
       beq   P03E5;
       puls  x;
       jsr   DrawThenZeroIntegrators;
       rts;

*
* DrawFrameContents()
*
* Entry:
*   x = frame ptr
*
* This function will draw the contents of the indicated
* frame.
*
DrawFrameContents:
       pshs  x,u;
       ldb   #$1C;
       stb   <$04;     * Write the scale factor
       ldb   2,x;
       negb;
       sex;
       addd  #$0060;
       clr   <$01;
       clr   <$00;
       lda   #$CF;    * Un-zero integrators, & trigger
       sta   <$0C;     * IRQ off positive edge.
       inc   <$00;
       tst   $C8A6;
       beq   P040C;
       negb;
P040C: stb   <$01;
       ldb   #$40;
       clr   <$05;
P0412: bitb  <$0D;     * Wait for timer interrupt
       beq   P0412;
       ldd   0,x;      * Load drawing (y,x) values
       sta   <$01;     * Write the y value
       clr   <$00;
       lda   3,x;      * Load scale factor
       sta   <$04;     * Write scale factor
       exg   x,x;
       inc   <$00;
       stb   <$01;     * Write the x value
       ldb   #$40;
       clr   <$05;
P042A: bitb  <$0D;     * Wait for timer interrupt
       beq   P042A;
       lda   5,x;      * Load embedded obj's scale factor
       sta   $CA81;    * Save embedded obj's scale factor
       tst   $1B,x;   * Is player in the eneny passage
       beq   P0459;    * or the fuel passage?
       ldd   9,x;      * In fuel passage
       cmpd  #FuelCannister; * Is this frame a fuel wall
       bne   P0459;    * or a fuel cannister?
       ldd   $1C,x;   * Load embedded objects (y,x)
       sta   <$01;     * Write y value
       clr   <$00;
       lda   5,x;      * Load embedded obj's scale factor
       sta   <$04;     * Write embedded obj's scale factor
       exg   x,x;
       inc   <$00;
       stb   <$01;     * Write x value
       ldb   #$40;
       clr   <$05;
P0455: bitb  <$0D;     * Wait for timer interrupt
       beq   P0455;
P0459: lda   8,x;      * Load intensity value
       jsr   intensity_to_a;
       leau  $20,x;   * Load address of drawing proc
       tfr   x,y;
       tst   $C8A6;
       beq   P046C;
       ldx   9,x;      * Load vector list # 1
       bra   P046E;
P046C: ldx   11,x;     * Load vector list # 2
P046E: stx   $C82C;    * Save vector list ptr
       ldb   $CA81;    * Retrieve scale factor
       jsr   [,u];     * (INDIRECT JUMP)
       puls  x,u;
       jmp   P0353;

*
* EP_DrawAllBlueFramesAndWalls_LeftEye()
*
* This function will draw all of the blue user frames,
* and when that completes, will draw any blue walls.
* This is only for the left eye.
*
EP_DABlueFramesAndWalls_LE:
       com   $C8A6;    * Flag we're drawing for left eye
       jsr   RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame;
P0481: lda   #$01;    * Request blue frame
       jsr   LocateSpecificFrame;
       tsta;           * Did we find a frame?
       bne   P0490;    * Yep; so draw it
       ldu   #LeftWalls_LeftEye;* Nope; draw left walls
       jsr   DrawEnemyPassageWalls;
       rts;
P0490: jsr   DrawFrameContents;
       bra   P0481;    * Check for another frame

LeftWalls_LeftEye:
       DW    LeftWallFar_LeftEye;
       DW    LeftWallNear_LeftEye;

*
* EP_DAGreenFramesAndWalls_LE  ; EP_DrawAllGreenFramesAndWalls_LeftEye()
*
* This function will draw all of the green user frames,
* and when that completes, will draw any green walls.
* This is only for the left eye.
*
EP_DAGreenFramesAndWalls_LE:  ; EP_DrawAllGreenFramesAndWalls_LeftEye:
       jsr   RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame;
P049C: lda   #$02;     * Request green frame
       jsr   LocateSpecificFrame;
       tsta;            * Did we find a frame?
       bne   P04AE;     * Yep; so draw it
       ldu   #RightWalls_LeftEye;* Nope; draw left walls
       jsr   DrawEnemyPassageWalls;
       jsr   P0141;    * Process sounds
       rts;
P04AE: jsr   DrawFrameContents;
       bra   P049C;

RightWalls_LeftEye:
       DW    RightWallFar_LeftEye;
       DW    RightWallNear_LeftEye;

*
* EP_DrawAllRedFrames_LeftEye()
*
* This function will draw all of the red user frames,
* and when that completes, will check to see if the
* player has hit an enemy ship or picked up fuel.
* The drawing done is only for the left eye.
*
EP_DrawAllRedFrames_LeftEye:
       jsr   RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame;
P04BA: lda   #$03;     * Request red frame
       jsr   LocateSpecificFrame;
       tsta;            * Did we find a frame?
       bne   P04FF;     * Yep; so draw it
       jsr   P0353;
       jsr   DrawFuelBar;
       ldd   $C886;       * Load BCD value of enemy ship
       tst   $C888;       * Was an enemy ship destroyed?
       bne   UpdateScore;
       ldd   #$0100;     * Load BCD value of fuel can
       tst   $C8B0;       * Did player pickup fuel can?
       beq   P04F8;
UpdateScore:
       ldx   #$C8C6;     * Yes; update player's score
       jsr   add_d_to_x_in_bcd;
       tst   $C881;       * Check if score > 20,000 only
       bne   P04F8;       * once per game.
       ldx   #$C8C6;     * See if player's score is
       ldu   #BonusScoreLevel;* > 20,000.
       jsr   compare_scores;
       cmpa  #$01;
       bne   P04F8;
       lda   #$FF;       * Score is > 20,000
       sta   $C881;       * Disable doing check again
       inc   $C8C4;       * Award a bonus ship
P04F8: clr   $C888;       * Clear 'enemy destroyed' flag
       clr   $C8B0;       * Clear 'fuel picked up' flag
       rts;
P04FF: jsr   DrawFrameContents;
       bra   P04BA;

* These appear to not be referenced*
       DW    $1ABD;
       DW    $1ABD;

BonusScoreLevel:
       DB      " 20000",$80;

*
* CheckForScoreOver20000()
*
* Entry:
*   d = value to add to player's score.
*
* Exit:
*   C881 = will be set to $FF, if the score is now
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
*
CheckForScoreOver20000:
       ldx   #$C8C6;
       jsr   add_d_to_x_in_bcd;
       tst   $C881;      * Bypass check, if the score
       bne   P052F;      * is already > 20,000.
       ldx   #$C8C6;
       ldu   #BonusScoreLevel;
       jsr   compare_scores;
       cmpa  #$01;
       bne   P052F;
       lda   #$FF;
       sta   $C881;      * Disable future checking
       inc   $C8C4;      * Award a bonus ship
P052F: rts;

*
* EP_DABlueFramesAndWalls_RE ; EP_DrawAllBlueFramesAndWalls_RightEye()
*
* This function will draw all of the blue user frames,
* and when that completes, will draw any blue walls.
* This is only for the right eye.
*
EP_DABlueFramesAndWalls_RE: ; EP_DrawAllBlueFramesAndWalls_RightEye:
       clr   $C8A6;      * Flag we're doing right eye
       jsr   RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame;
P0536: lda   #$01;      * Request blue frame
       jsr   LocateSpecificFrame;
       tsta;             * Did we find a frame?
       bne   P0548;      * Yep, so draw it
       ldu   #LeftWalls_RightEye;* Nope, so draw walls
       jsr   DrawEnemyPassageWalls;
       jsr   get_random_a2;
       rts;
P0548: jsr   DrawFrameContents;
       bra   P0536;      * Check for another frame

LeftWalls_RightEye:
       DW    LeftWallFar_RightEye;
       DW    LeftWallNear_RightEye;

*
* EP_DAGreenFramesAndWalls_RE ; EP_DrawAllGreenFramesAndWalls_RightEye()
*
* This function will draw all of the green user frames,
* and when that completes, will draw any green walls.
* This is only for the right eye.
*
EP_DAGreenFramesAndWalls_RE: ; EP_DrawAllGreenFramesAndWalls_RightEye:
       jsr   RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame;
P0554: lda   #$02;      * Request green frame
       jsr   LocateSpecificFrame;
       tsta;             * Did we find a frame?
       bne   P0572;      * Yep, so draw it
       ldu   #RightWalls_RightEye;* Nope, so draw walls
       jsr   DrawEnemyPassageWalls;
       ldx   #$F9F0;
       jsr   move_penFF;
       jsr   P0353;
       jsr   move_pen;
       jsr   P0353;
       rts;
P0572: jsr   DrawFrameContents;
       bra   P0554;      * Check for another wall

RightWalls_RightEye:
       DW    RightWallFar_RightEye;
       DW    RightWallNear_RightEye;

*
* EP_DrawAllRedFrames_RightEye()
*
* This function will draw all of the red user frames,
* and when that completes, will draw the fuel bar.
* This is only for the right eye.
*
EP_DrawAllRedFrames_RightEye:
       jsr   RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame;
P057E: lda   #$03;      * Request red frame
       jsr   LocateSpecificFrame;
       tsta;             * Did we find a frame?
       bne   P058D;      * Yep, so draw it
       jsr   P0353;     * Nope, so draw fuel bar
       jsr   DrawFuelBar;
       rts;
P058D: jsr   DrawFrameContents;
       bra   P057E;      * Check for another frame

* These appear to not be referenced*
       DW    $1AA6;
       DW    $1AA6;

*
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
*
NE_DisplayString:
       ldx   #$F9D4;
       ldd   #$1883;
       clr   <$01;
       sta   <$0B;
P05A0: stb   <$00;
       dec   <$00;
       ldd   #$8081;
       nop;
       inc   <$00;
       stb   <$00;
       sta   <$00;
       nop;
       nop;
       inc   <$00;
       lda   $C82B;
       sta   <$01;
       ldd   #$0100;
       ldu   $C82C;
       sta   <$00;
       bra   P05C5;
P05C1: lda   a,x;
       sta   <$0A;
P05C5: lda   ,u+;
       bpl   P05C1;
       lda   #$81;
       sta   <$00;
       neg   <$01;
       lda   #$01;
       sta   <$00;
       cmpx  #$FBB4;
       beq   P0604;
       leax  $50,x;
       tfr   u,d;
       subd  $C82C;
       subb  #$02;
       aslb;
       brn   P05E5;
P05E5: lda   #$81;
       nop;
       decb;
       bne   P05E5;
       sta   <$00;
       ldb   $C82A;
       stb   <$01;
       dec   <$00;
       ldd   #$8101;
       nop;
       sta   <$00;
       clr   <$01;
       stb   <$00;
       sta   <$00;
       ldb   #$03;
       bra   P05A0;
P0604: lda   #$98;
       sta   <$0B;
       jmp   P0353;

*
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
*
UpdatePlayersFuelLevel:
       lda   $C826;     * Every 32nd pass, subtract out
       anda  #$1F;     * some fuel from player's supply.
       bne   P0620;
       ldd   $CA77;     * Get player's fuel setting
       subd  $CA7A;     * Subtract some out
       std   $CA77;     * Save new fuel setting
       bpl   P0620;
       clr   $CA77;     * Can't have minus fuel; set to 0
P0620: tst   $CA7E;     * Is player already low on fuel?
       bne   P0644;
       lda   $CA77;     * Is player almost out of fuel?
       cmpa  #$0F;
       bhs   P0644;     * Are there >= 15 units left?
       lda   #$FF;     * Nope; running low
       sta   $CA7E;     * Flag that player is low on fuel
       lda   $C89B;
       ora   #$04;     * Make 'running low on fuel' sound
       sta   $C89B;
       lda   $C89F;
       ora   #$04;     * Enable the above sound
       sta   $C89F;
       lda   $CA77;
P0644: cmpa  #$01;     * Are there any fuel units left?
       bge   P0650;
       clr   $CA77;     * Nope; we're history
       lda   #$FF;
       sta   $CA7D;     * Flag that player is out of fuel
P0650: rts;

*
* DoDrawing()
*
* Entry:
*   C8AB = Processing function to invoke
*
* This function invokes the primary processing function,
* and then attempts to do some drawing.  Before doing the
* drawing, it will wait until the refresh counter has
* decremented to match a predefined checkpoint value.
*
DoDrawing:
       jsr   [$C8AB];* Call main processing function
       ldy   #FrameDrawingProcs;
       ldu   #RefreshCheckPoints;
P065C: ldd   0,u;     * Load next checkpoint value
       bne   P0661;
       rts;
P0661: jsr   P0252;
       ldd   0,u;     * Wait until the correct part of the
       cmpa  <$09;    * color wheel is visible, before
       bls   P0661;   * starting to draw.
       ldx   ,y++;
       pshs  y,u;
       jsr   0,x;     * Call drawing function
       puls  y,u;
       leau  2,u;     * Get next checkpoint
       bra   P065C;

P0676: lda   $C8D4;
       cmpa  #$80;
       bls   P0683;
       ldd   $C8D1;
       std   $C8D4;
P0683: ldx   #$C8D4;
       lda   $C882;
       bsr   P06E0;
       jsr   P0738;
       rts;

P068F: clr   $C8B2;
       lda   $C8D4;
       cmpa  #$80;
       bls   P06B8;
       lda   $C8D1;
       sta   $C8D4;
       cmpa  #$FF;
       bne   P06A7;
       com   $C8B2;
       rts;
P06A7: lda   $C8CE;
       cmpa  #$FF;
       beq   P06B5;
       lda   #$FF;
       sta   $C8CE;
       bra   P06B8;
P06B5: sta   $C8D1;
P06B8: ldx   #$C8D4;
       lda   $C882;
       bsr   P06E0;
       lda   $C8D4;
       ldb   #$50;
       mul;
       ldb   $C8D1;
       cmpb  #$FF;
       bne   P06CE;
       rts;
P06CE: sta   $C8D1;
       ldb   #$4A;
       mul;
       ldb   $C8CE;
       cmpb  #$FF;
       bne   P06DC;
       rts;
P06DC: sta   $C8CE;
       rts;

P06E0: pshs  a;
       ldd   0,x;
       bne   P06E9;
       puls  a;
       rts;
P06E9: lda   1,x;
       ldb   0,s;
       mul;
       adca  #$00;
       tfr   a,b;
       clra;
       std   $C891;
       lda   0,x;
       ldb   0,s;
       mul;
       addd  $C891;
       addd  0,x;
       std   0,x;
       puls  a;
       rts;

*
* UpdateFramesScaleAndIntensity()
*
* Entry:
*   x = Frame ptr
*
* This function recalulates the scale factors and the
* intensity values for a frame.  The intensity is calculated
* as follows:
*
*     new intensity = new scale factor + $40
*     if (new intensity < 0)   [ check for rollover ]
*        new intensity = $7F (max)
*
UpdateFramesScaleAndIntensity:
       ldd   3,x;     * Load 16-bit scale factor
       bne   P070A;   * Skip, if scale factor = 0
       rts;
P070A: lda   4,x;     * Load hi-byte of scale factor
       ldb   #$1F;
       mul;
       adca  #$00;
       tfr   a,b;
       clra;
       pshs  a,b;
       lda   3,x;     * Load low-byte of scale factor
       ldb   #$1F;
       mul;
       addd  ,s++;
       subd  3,x;
       coma;
       comb;
       addd  #$0001;
       std   3,x;     * Save new 16-bit scale factor
       asla;
       asla;
       ldb   #$40;
       mul;
       sta   2,x;
       lda   3,x;     * Recalculate intensity
       adda  #$40;
       bpl   P0735;
       lda   #$7F;
P0735: sta   8,x;     * Save new intensity
       rts;

P0738: lda   $C8D4;
       ldb   #$50;
       mul;
       sta   $C8D1;
       ldb   #$4A;
       mul;
       sta   $C8CE;
       rts;

*
* LocateSpecificFrame()
*
* Entry:
*   a = Frame identifier
*   C875-C876 = Ptr to 1st frame to check
*
* Exit:
*   a = 0 (no match) or $FF (match found)
*   x = ptr to matching frame
*   C875-C876 = Ptr to next frame after matching one
*
* This function attempts to locate the next frame in the
* sequence, having the indicated frame identifier
* (1=blue, 2=green and 3=red).
*
LocateSpecificFrame:
       sta   $C892;    * Save incoming frame number
       jsr   P0252;
       lda   $C892;    * Load incoming frame number
       ldx   $CA75;    * Load addr of 1st frame
P0754: tst   7,x;      * Quit when last frame found
       bge   P075A;
       clra;           * Flag that no match was found
       rts;
P075A: cmpa  7,x;      * Do frame numbers match?
       bne   P0769;    * Nope; try next frame
       tfr   x,u;      * Yes, we want this frame
       leau  $22,u;   * Get address of next frame
       stu   $CA75;    * Save the address of next frame
       lda   #$FF;    * Flag that a match was found
       rts;
P0769: leax  $22,x;   * Get address of next frame
       bra   P0754;    * Keep trying

*
* RFPtrToPlayersFF ;ResetFramePtrToPlayersFirstFrame()
*
* Exit:
*   C875-C876 = Ptr to player's first frame (C8D7)
*
* This function sets the frame ptr (CA75) used by
* LocateSpecificFrame(), to point to the player's
* first frame (C8D7).
*
RFPtrToPlayersFF: ;ResetFramePtrToPlayersFirstFrame:
       ldx   #$C8D7;
       stx   $CA75;
       rts;

*
* UpdatePlayersPosition()
*
* This function uses the joystick positions to update
* the position of the player's ship.  The joystick must
* be moved past a certain threshold, in order for the
* ship's position to be affected.  In addition, it will
* not allow the ship to move past certain side, top and
* bottom boundaries: top = $60, bottom = $A0,
* left = $BC and right = $54.
*
* It should be noted that moving the joystick up causes
* the ship to move down.
*
* All information for the player's ship is kept in the
* frame C8D7.
*
UpdatePlayersPosition:
       ldx   #$C8D7;    * Load addr of players ship frame
       lda   0,x;        * Load current y value
       ldb   $C81C;      * Load joystick up/down value
       cmpb  #$30;      * Check value against threshold 1
       bgt   P078F;
       cmpb  #$D0;      * Check value against threshold 2
       bgt   P0797;
       cmpa  #$60;      * Update the y value only if the
       bge   P0797;      * ship is not already at top.
       adda  #$04;      * y = y + 4
       sta   0,x;        * Save new y value
       bra   P0797;
P078F: cmpa  #$A0;      * Update the y value only if the
       ble   P0797;      * ship is not already at bottom.
       adda  #$FC;      * y = y - 4
       sta   0,x;        * Save new y value
P0797: lda   1,x;        * Load current x value
       ldb   $C81B;      * Load joystick left/right value
       cmpb  #$D0;      * Check value against threshold 1
       blt   P07AE;
       cmpb  #$30;      * Check value against threshold 2
       blt   P07B6;
       cmpa  #$54;      * Update the x value only if the
       bge   P07B6;      * ship not already at right edge
       adda  #$04;      * x = x + 4
       sta   1,x;        * Save new x value
       bra   P07B6;
P07AE: cmpa  #$BC;      * Update the x value only if the
       ble   P07B6;      * ship not already at left edge
       adda  #$FC;      * x = x - 4
       sta   1,x;        * Save new x value
P07B6: rts;

*
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
*
ProcessEnemyStar:
       clr   $C8BC;    * Clear the 'collision' flag
       tst   $C889;    * Is enemy star active
       bne   P07C0;
       rts;
P07C0: ldx   #$C95F;  * Get ptr to enemy star frame
       lda   7,x;      * See if the enemy star is visible?
       bita  #$10;
       beq   P07E5;
       tst   $1E,x;   * No; restart a new one only if
       beq   P07CF;    * it did not collide with player
       rts;
P07CF: ldb   $C8D8;    * Restart new enemy star
       lda   #$80;    * Set x position = players position
       std   0,x;      * Force y = bottom of screen
       lda   #$03;
       sta   7,x;      * Frame # = 3 (Red)
       ldd   #EnemyStarVectorList;
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
       clr   $1E,x;   * Clear 'collision' flag
       rts;
P07E5: ldb   0,x;
       addb  $C8BB;    * Get velocity value
       stb   0,x;      * Update y value
       tst   $1E,x;
       beq   P080B;    * If the enemy star collided with
       dec   $1F,x;   * the player, then display an
       beq   P080F;    * explosion pattern for a while.
       ldu   #ExplosionVectorTable;
       lda   $C826;
       anda  #$03;    * Animate, by changing between 1
       asla;           * of 4 possible explosion patterns
       ldd   a,u;
       std   9,x;      * Set the explosion vector list
       std   11,x;     * Set the explosion vector list
       ldd   #NE_DrawDots;
       std   $20,x;   * Set the drawing function
P080B: cmpb  #$78;    * Has the enemy star reached the
       ble   P0814;    * top of the screen?
P080F: lda   #$13;    * Yes; so tag the frame as no
       sta   7,x;      * longer being visible.
       rts;
P0814: jsr   CheckForCollisionWithPlayer;
       tsta;
       bne   P081B;
       rts;
P081B: com   $C8BC;    * Flag collision with player
       com   $1E,x;   * Flag collision with player
       lda   #$18;    * Set timer value, which controls
       sta   $1F,x;   * duration of the explosion.
       rts;

*
* DrawPlayersShipExploding()
*
* This function drawing the player's ship exploding
* into multiple pieces.  It does this by incrementing
* the alternate scale factor (C8B7); drawing continues
* until the alternate scale factor reaches $3000, at
* which point we set a flag (C8B9) to indicate that we
* are done, and it is time to move onto the next phase.
*
DrawPlayersShipExploding:
       ldx   #$C8D7;  * Get addr of player's frame
       clr   $C8B9;    * Clear 'player done exploding flag
       ldd   $C8B7;    * Has scale factor surpassed the
       cmpd  #$3000;  * upper bound?
       bls   P083A;
       com   $C8B9;    * Flag that we are done
       rts;
P083A: addd  #$0180;
       std   $C8B7;     * Increment alternate scale factor
       ldd   #DrawWithMixedScaleFactors;
       std   $C8F7;     * Set drawing function
       ldd   #PlayersShipExploding_1;
       std   $C8E0;     * Set vector list 1
       ldd   #PlayersShipExploding_2;
       std   $C8E2;     * Set vector list 2
       rts;

*
* InitializePlayerFrame()
*
* This function initializes all of the important fields
* within the frame used to display the player's ship.
*
* All information about the players ship is kept in the
* frame C8D7.
*
InitializePlayerFrame:
       ldx   #$C8D7;   * Get addr of player's frame
       clr   $1B,x;    * Flag player in enemy passage
       lda   #$03;     * Set frame # = 3 (red)
       sta   7,x;
       ldd   #DrawVectorList;
       std   $20,x;    * Set drawing function
       lda   #$40;
       sta   2,x;
       lda   #$3F;
       sta   3,x;       * Set scale factor
       ldb   #$80;
       mul;
       asla;
       sta   2,x;
       lda   #$10;
       sta   5,x;       * Set embedded obj's scale factor
       lda   #$7F;
       sta   8,x;       * Set intensity
       ldd   #PlayersShip_2;
       std   9,x;       * Set vector list 1
       ldd   #PlayersShip_1;
       std   11,x;      * Set vector list 2
       clra;
       clrb;
       std   0,x;       * Set initial position = (0,0)
       clr   $1E,x;
       rts;

*
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
*
SetEnemyShipInfo:
       ldd   #$3000;
       std   $CA77;     * Give player $30 units of fuel
       clr   $CA7D;     * Clear 'out of fuel' flag
       clr   $CA7E;     * Clear 'low on fuel' flag
       ldd   #$0080;
       ldd   #$0100;
       std   $CA7A;     * Set fuel usage to 1 unit
SetEnemyShipInfo_2:
       lda   $C8BD;     * Calculate the number of fuel
       asla;            * objects for this next level.
       adda  #$05;     * # = (level* 2) + 5
       sta   $C883;
       ldb   #$04;     * Based on the current level,
       lda   $C8BD;     * set $C884 to either 4 or 5
       cmpa  #$05;
       bls   P08B3;
       incb;
P08B3: stb   $C884;
       lda   $C8BD;
       adda  #$06;
       sta   $C885;    * Enemy ship count = level + 6
       lda   $C8BD;    * Determine which enemy ship will
       cmpa  #$0E;    * used at this level: 0 - 14
       bls   P08C7;
       lda   #$0E;
P08C7: ldb   #$0D;    * $0D = size of each table entry
       mul;            * Get index into enemy ship array
       ldu   #EnemyShipInfoTable;
       leau  d,u;      * Get ptr to the enemy ship data
       ldd   ,u++;
       std   $C886;    * BCD value of enemy ship
       lda   ,u+;
       sta   $C882;
       lda   ,u+;
       sta   $C889;    * Flag; do/don't display enemy star
       ldd   ,u++;
       std   $C88A;    * Save vector list ptr
       ldd   ,u++;
       std   $C88D;    * Save x movement delta
       ldd   ,u++;
       std   $C88F;    * Save y movement delta
       lda   ,u+;
       sta   $C8A4;
       lda   ,u+;      * Number of hits needed to destroy
       sta   $C88C;    * the warlord ship.
       lda   ,u+;
       sta   $C880;    * Save contact tolerance value
       rts;

*
* The following is an array of 17 blocks of data, each block
* of which is $0D (13) bytes long.  It appears that the
* code only uses the first 16 blocks (0 - $0E).  Each block
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
*
EnemyShipInfoTable:
       DW    $0050;
       DB    $08;
       DB    $00;
       DW    EnemyShip1VectorTable;
       DW    $0000;
       DW    $0000;
       DB    $08;
       DB    $00;
       DB    $10;

       DW    $0100;
       DB    $0C;
       DB    $FF;
       DW    EnemyShip2VectorTable;
       DW    $0100;
       DW    $FF00;
       DB    $08;
       DB    $00;
       DB    $0E;

       DW    $0150;
       DB    $10;
       DB    $FF;
       DW    EnemyShip3VectorTable;
       DW    $FE00;
       DW    $0200;
       DB    $09;
       DB    $05;
       DB    $0C;

       DW    $0200;
       DB    $18;
       DB    $FF;
       DW    EnemyShip4VectorTable;
       DW    $0300;
       DW    $0300;
       DB    $09;
       DB    $00;
       DB    $0C;

       DW    $0250;
       DB    $20;
       DB    $FF;
       DW    EnemyShip1VectorTable;
       DW    $0400;
       DW    $0100;
       DB    $0A;
       DB    $00;
       DB    $0B;

       DW    $0300;
       DB    $30;
       DB    $FF;
       DW    EnemyShip2VectorTable;
       DW    $0200;
       DW    $0400;
       DB    $0A;
       DB    $07;
       DB    $0A;

       DW    $0350;
       DB    $48;
       DB    $FF;
       DW    EnemyShip3VectorTable;
       DW    $FC00;
       DW    $0100;
       DB    $0B;
       DB    $00;
       DB    $0A;

       DW    $0400;
       DB    $60;
       DB    $FF;
       DW    EnemyShip4VectorTable;
       DW    $0400;
       DW    $0300;
       DB    $0B;
       DB    $00;
       DB    $09;

       DW    $0450;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip1VectorTable;
       DW    $0200;
       DW    $0400;
       DB    $0C;
       DB    $09;
       DB    $09;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip2VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $00;
       DB    $08;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip3VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $00;
       DB    $08;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip4VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $0B;
       DB    $07;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip1VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $00;
       DB    $07;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip2VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $00;
       DB    $06;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip3VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $0D;
       DB    $06;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip4VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $0D;
       DB    $06;

       DW    $0500;
       DB    $7F;
       DB    $FF;
       DW    EnemyShip4VectorTable;
       DW    $0100;
       DW    $0400;
       DB    $0C;
       DB    $0D;
       DB    $06;

*
* InitEnemyStarFrame()
*
* This function fills in all of the important fields
* within the frame used to hold the enemy star information.
*
* All information about the enemy star is kept in the
* frame C95F.
*
InitEnemyStarFrame:
       lda   #$02;
       sta   $C8BB;    * Set enemy star velocity
       ldx   #$C95F;  * Get ptr to enemy star frame
       clr   $1B,x;   * Flag player in enemy passage
       lda   #$13;
       sta   7,x;      * Frame # = $13 (red,not visible
       tst   $C889;    * Enemy star enabled?
       bne   P09EF;
       rts;            * No
P09EF: ldd   #DrawVectorList;
       std   $20,x;   * Set drawing function
       lda   #$40;
       sta   2,x;
       lda   #$3F;
       sta   3,x;      * Set scale factor
       ldb   #$80;
       mul;
P0A00: asla;
       sta   2,x;
       lda   #$10;
       sta   5,x;      * Set embedded obj's scale factor
       lda   #$7F;
       sta   8,x;      * Set intensity
       clr   $1E,x;   * Clear collision flag
       rts;

*
* InitAllBulletFrames()
*
* This function fills in the important fields within the
* 3 frames used to hold information about bullets fired
* by the user.
*
* The 3 bullet frames are located at C8F9, C91B and C93D.
*
InitAllBulletFrames:
       ldx   #$C8F9;  * Ptr to first bullet frame
       lda   #$11;    * Frame # $11 = Blue,not visible
       jsr   InitOneBulletFrame;
       lda   #$12;    * Frame # $12 = Green,not visible
       jsr   InitOneBulletFrame;
       lda   #$13;    * Frame # $13 = Red,not visible
       jsr   InitOneBulletFrame;
       lda   #$FF;
       sta   7,x;      * Tag end of frame stack
       rts;

*
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
*
InitOneBulletFrame:
       sta   7,x;      * Set frame number
       ldd   #DrawVectorList;
       std   $20,x;   * Set drawing function
       clr   $1B,x;   * Flag player in enemy passage
       lda   #$10;
       sta   5,x;      * Set embedded obj's scale factor
       ldd   #BulletVectorList;
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
       leax  $22,x;   * Advance frame pointer
       rts;

*
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
*
InitEnemyShipFrame:
       ldx   #$C981;   * Ptr to enemy ship frame
       lda   #$12;
       sta   7,x;       * Frame# = $12 (green,not visible
       lda   #$01;
       sta   5,x;       * Set embedded obj's scale factor
       ldd   $C88A;
       std   9,x;       * Set vector list 1
       std   11,x;      * Set vector list 2
       ldd   #DrawVectorList;
       std   $20,x;    * Set drawing function
       ldd   $C88D;
       std   $11,x;    * Set x movement delta
       ldd   $C88F;
       std   $13,x;    * Set y movement delta
       ldd   #$0000;
       std   13,x;      * Set 16-bit x position
       std   15,x;      * Set 16-bit y position
       ldd   #$C03F;   * Bounding box limits: -64, -63
       std   $15,x;    * Set x bounding box limits
       std   $17,x;    * Set y bounding box limits
       leax  $22,x;    * Point to the next frame
       lda   #$FF;
       sta   7,x;       * Tag frame as end of stack frame
       rts;

*
* UpdateBulletFrames()
*
* This function updates the scale factor and the intensity
* for each of the 3 bullet frames.  It also checks to see
* if the player has requested that another bullet be fired.
*
* All information about the 3 bullets are kept in the
* frames located at C8F9, C91B and C93.
*
UpdateBulletFrames:
       ldx   #$C8F9;   * Get addr of 1st bullet frame
       bsr   UFStateAndCheckForFR; UpdateFrameStateAndCheckForFireRequest;
       leax  $22,x;    * Get addr of 2nd bullet frame
       bsr   UFStateAndCheckForFR; UpdateFrameStateAndCheckForFireRequest;
       leax  $22,x;    * Get addr of 3rd bullet frame
       bsr   UFStateAndCheckForFR; UpdateFrameStateAndCheckForFireRequest;
       rts;

*
* UFStateAndCheckForFR; UpdateFrameStateAndCheckForFireRequest()
*
* Entry:
*   x = ptr to bullet frame
*
* This function updates the scale factor and the intensity
* for one bullet frame.  It will also check to see if the
* player has requested that another bullet be fired; if
* so, then the next available frame will be used.  Only
* 1 bullet per pass will be fired.
*
UFStateAndCheckForFR: ; UpdateFrameStateAndCheckForFireRequest:
       ldb   7,x;
       bitb  #$10;    * Is frame visible?
       beq   P0AB4;    * Update only visible frames
       tst   $C815;    * If the frame is not visible, then
       beq   P0AB4;    * see if players is trying to fire.
       tst   $C8F5;    * Is player dead?
       bne   P0AB4;
       andb  #$0F;
       stb   7,x;      * No; flag frame as active again
       lda   #$3F;
       sta   3,x;      * Set scale factor
       ldd   $C8D7;
       std   0,x;      * Starting pos = player's pos
       clr   $C815;    * Only allow 1 bullet per pass
       lda   #$20;
       ora   $C89B;
       sta   $C89B;    * Force 'bullet fired' sound
P0AB4: lda   3,x;      * Update the scale factor and
       cmpa  #$01;    * intensity, unless scale = 1
       bls   P0ABE;    * which means no longer visible
       jsr   UpdateFramesScaleAndIntensity;
       rts;
P0ABE: orb   #$10;
       stb   7,x;      * Tag frame as no longer visible
       rts;

BulletVectorList:
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $01;

*
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
*
ProcessEnemyShip:
       clr   $C888;     * Clear 'enemy destroyed' flag
       clr   $C8BA;     * Clear the collision flag
       ldx   #$C981;
       ldb   7,x;       * If the frame is not visible,
       bitb  #$10;     * then we may need to restart
       beq   P0B26;     * the next enemy ship.
       ldy   $C8AB;
       cmpy  #InEnemyPassage;
       beq   P0AE1;
       rts;
P0AE1: andb  #$0F;     * Start a new enemy ship
       stb   7,x;       * Reset frame to be visible
       ldd   #DrawAnimatedVectorList_Slow;
       std   $20,x;    * Set drawing function
       ldd   #$0100;
       std   3,x;       * Set 16-bit scale factor
       lda   $C89B;
       ora   #$02;
       sta   $C89B;     * Force sound to be made
       lda   $C89F;
       ora   #$02;
       sta   $C89F;
       lda   $C87D;     * Use the system loop counter to
       anda  #$3F;     * generate a y value in the range
       tst   $C87D;     * of +-$3F.
       bmi   P0B0B;
       nega;
P0B0B: ldb   $C87E;     * Use the system loop counter to
       andb  #$3F;     * generate an x value in the range
       tst   $C87E;     * of +-$3F.
       bmi   P0B16;
       negb;
P0B16: std   0,x;      * Set (y,x) position
       sta   15,x;     * Set backup y position
       stb   13,x;     * Set backup x position
       clr   $1E,x;
       ldd   $C88A;    * Get ememy ship vector list ptr
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
P0B26: pshs  x;
       leax  3,x;
       lda   $C8A4;
       jsr   P06E0;
       puls  x;
       lda   3,x;
       ldb   3,x;
       negb;
       subb  #$10;
       stb   $C8A3;
       cmpa  #$90;    * If the scale factor > $90, then
       bls   P0B4F;    * stop displaying the frame.
       lda   7,x;
       ora   #$10;
       sta   7,x;      * Tag frame as no longer visible
       lda   $C89F;
       anda  #$FD;
       sta   $C89F;
       rts;
P0B4F: ldb   #$80;
       mul;
       asla;
       sta   2,x;
       lda   3,x;      * Calculate the new intensity =
       adda  #$40;    * (scale + $40);  if rollover
       bpl   P0B5D;    * occurs, then use $7F.
       lda   #$7F;
P0B5D: sta   8,x;      * Set the intensity
       lda   3,x;
       lsra;
       lsra;
       sta   5,x;      * Set embedded obj's intensity
       tst   $1E,x;   * Collision with player?
       beq   P0B86;
       dec   $1F,x;   * Yes; has the explosion timer
       beq   P0B7F;    * finished?
       ldu   #ExplosionVectorTable;
       lda   $C826;    * Keep displaying the explosion
       anda  #$03;    * pattern, rotating between the
       asla;           * 4 possible patterns.
       ldd   a,u;
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
       rts;
P0B7F: lda   7,x;
       ora   #$10;
       sta   7,x;      * Tag frame as no longer visible
       rts;
P0B86: jsr   CheckForCollisionWithBullets;
       tsta;
       bne   P0B98;
       jsr   CheckForCollisionWithPlayer;
       tsta;
       bne   P0B93;
       rts;
P0B93: lda   #$FF;    * Collided with the player
       sta   $C8BA;
P0B98: lda   $C89B;    * Collided with player or bullet
       ora   #$80;
       sta   $C89B;    * Force a sound to occur
       clr   $C8A2;    * Set sound characteristics index
       com   $1E,x;   * Flag that a collision occurred
       lda   #$12;
       sta   $1F,x;   * Set explosion duration timer
       ldd   #ExplosionPattern_1;
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
       ldd   #NE_DrawDots;
       std   $20,x;   * Set the drawing function
       inc   $C8B1;    * Bump 'enemy ships destroyed' cntr
       com   $C888;    * Flag that enemy was destroyed
       rts;

*
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
* value ($11,x) and the 16-bit y delta value ($13,x).
* The bounding box for the enemy ship is defined in the
* frame structure [x min in ($15,x), x max in ($16,x),
* y min in ($17,x) and y max in ($18,x)].  Each pass
* through, the deltas are added (or subtracted) from
* the current position, and if the edge of the bounding
* box is reached, the delta is negated, thus forcing
* the ship to start moving in the other direction.
*
UpdateEnemyShipPosition:
       ldd   $11,x;    * Load x movement delta
       bge   P0BDA;
       addd  13,x;      * Subtract delta from current x
       std   13,x;      * position.
       cmpa  $15,x;    * Surpassed lower x bounds?
       bgt   P0BE3;     * No
P0BCD: ldd   $11,x;    * Yes; so we need to negate
       coma;            * the x movement delta, to
       comb;            * force movement back in the
       addd  #$0001;   * other direction.
       std   $11,x;
       bra   P0BE3;
P0BDA: addd  13,x;      * Add delta to current x position
       std   13,x;
       cmpa  $16,x;    * Surpassed upper x bounds?
       bge   P0BCD;     * Yes; so negate x movement delta
P0BE3: ldd   $13,x;    * Load y movement delta
       bge   P0BFE;
       addd  15,x;      * Subtract delta from current y
       std   15,x;      * position.
       cmpa  $17,x;    * Surpassed lower y bounds?
       bgt   P0C07;     * No
P0BF1: ldd   $13,x;    * Yes; so we need to negate
       coma;            * the y movement delta, to
       comb;            * force movement back in the
       addd  #$0001;   * other direction.
       std   $13,x;
       bra   P0C07;
P0BFE: addd  15,x;      * Add delta to current y position
P0C00: std   15,x;
       cmpa  $18,x;    * Surpassed upper y bounds?
       bge   P0BF1;     * Yes; so negate y movement delta
P0C07: lda   15,x;      * Load the updated y position
       ldb   13,x;      * Load the updated x position
       std   0,x;       * Update the frame's position
       rts;

*
* StartupNewGame()
*
* This function takes care of starting the ball rolling
* when a new game is to be started.
*
StartupNewGame:
       lda   #$01;
       sta   $C89B;  * Force background noise
       clr   $C89F;
       clr   $C881;
       clr   $C8B1;  * Clear 'enemy ships destroyed cntr
       clr   $C8BD;
       jsr   InitPlayersScoreAndShipCount;
       ldx   #PrepareToEnterEnemyPassage;
       stx   $C8AB;  * Set the indirect jump ptr
       jmp   PrepareToEnterEnemyPassage;

*
* PrepareToFightWarlordShip()
*
* This function simply initializes the bullet buffers and
* the Warlord ship frames, before the player faces off
* with the Warlord ship.
*
PrepareToFightWarlordShip:
       lda   #$FF;
       sta   $CA7D;  * Flag that player is out of fuel
       clr   $C8AF;  * Don't draw enemy passage walls
       jsr   InitAllBulletFrames;
       jsr   InitWarlordShipBulletFrame;
       jsr   InitWarlordShipFrames;
       rts;

*
* PlayerFightingWarlordShip()
*
* This is the main processing function for when the user is
* fighting the Warlord ship.  It checks for the player
* firing, and updates all bullet, player and Warlord ship
* positions.  It also checks for collisions and for
* destruction of the Warlord ship.
*
PlayerFightingWarlordShip:
       jsr   UpdatePlayersPosition;
       jsr   UpdateBulletFrames;
       jsr   UpdateWarlordShipFrames;
       jsr   ProcessWarlordShipBullet;
       ldx   #$C95F;  * Warlord ship bullet hit player?
       jsr   CheckForCollisionWithPlayer;
       tsta;
       bne   P0C7E;
       lda   $C984;    * No; see if the warlord ship has
       cmpa  $C8DA;    * collided with the player.
       bhs   P0C7E;
       lda   $C8B1;    * No; has player hit warlord ship
       cmpa  $C88C;    * enough times to destroy it?
       blo   P0C96;
       ldd   #$0500;  * Yes; add 500 to player's score
       jsr   CheckForScoreOver20000;
       clra;
       clrb;
       std   $C8B7;    * Clear alternate scale factor
       ldx   #WarlordShipDestroyed;
       stx   $C8AB;    * Set the indirect jump ptr
       lda   $C8C4;    * See if a bonus ship can be
       cmpa  #$39;    * awarded; it will be, only if
       bhs   P0C7D;    * the player currently has < 9
       inc   $C8C4;    * ships.
P0C7D: rts;
P0C7E: clra;           * Player hit by warlord ship bullet
       clrb;           * or collided with warlord ship.
       std   $C8B7;    * Clear alternate scale factor
       ldx   #PlayerCollidedWithWarlordShip;
       stx   $C8AB;    * Set the indirect jump ptr
       lda   #$80;
       ora   $C89B;
       sta   $C89B;    * Force noise to occur
       lda   #$01;
       sta   $C8A2;    * Set sound characteristics index
P0C96: rts;

*
* WarlordShipDestroyed()
*
* This is the main processing function for when the player
* has destroyed the Warlord ship.  It draws the Warlord
* ship exploding into pieces.  Once that completes, it
* prepares the player for the fuel passage.
*
WarlordShipDestroyed:
       jsr   UpdatePlayersPosition;
       jsr   UpdateBulletFrames;
       lda   #$10;
       sta   $C966;
       ldd   $C8B7;
       addd  #$0001;
       std   $C8B7;    * Increment alternate scale factor
       cmpd  #$0020;
       bls   P0CBB;    * Draw exploding Warlord ship
       clr   $CA7D;    * Clear 'out of fuel' flag
       clr   $C8B1;    * Clear warlord ship hit counter
       jmp   PrepareForFuelPassage; * Goto fuel passage
P0CBA: rts;
P0CBB: lda   $C826;    * Update the warlord ship frames
       anda  #$01;    * only on every other pass.
       beq   P0CC3;
       rts;
P0CC3: ldu   #WarlordShipIsDestroyedO; WarlordShipBeingDestroyedOffsets;
       ldx   #$C981;  * Get warship target frame
P0CC9: lda   7,x;      * Is the frame visible?
       bge   P0CCE;
       rts;            * No
P0CCE: ldd   0,x;      * Yes; force the warlord ship
       adda  ,u+;      * pieces to drift apart, since
       addb  ,u+;      * it has been destroyed.  Do this
       std   0,x;      * by un-syncing the (y,x) values
       leax  $22,x;   * for the warlord ship frames.
       bra   P0CC9;

WarlordShipIsDestroyedO:; WarlordShipBeingDestroyedOffsets:
       DB    $00;     * Warlord ship frame 1 y offset
       DB    $00;     * Warlord ship frame 1 x offset
       DB    $FC;     * Warlord ship frame 2 y offset
       DB    $FC;     * Warlord ship frame 2 x offset
       DB    $FC;     * Warlord ship frame 3 y offset
       DB    $FC;     * Warlord ship frame 3 x offset
       DB    $03;     * Warlord ship frame 4 y offset
       DB    $03;     * Warlord ship frame 4 x offset
       DB    $00;     * Warlord ship frame 5 y offset
       DB    $FD;     * Warlord ship frame 5 x offset

*
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
*
PlayerCollidedWithWarlordShip:
       jsr   DrawPlayersShipExploding;
       jsr   UpdateWarlordShipFrames;
       lda   #$10;
       sta   $C900;    * Force bullet 1 frame invisible
       sta   $C922;    * Force bullet 2 frame invisible
       sta   $C944;    * Force bullet 3 frame invisible
       sta   $C966;    * Force warlord bullet invisible
       tst   $C8B9;    * Player done exploding
       beq   P0D17;
       jsr   InitializePlayerFrame; * Yes; restart player
       lda   $C8C4;    * If the player has no more ships
       cmpa  #$30;    * left, then enter a waiting state
       beq   P0D18;    * waiting for new game to start.
       dec   $C8C4;    * Decrement player's ship count
       ldd   #$0070;
       std   $C8AD;    * Set startup delay timer
       ldx   #RestartPlayerAgainstWarlordShip;
       stx   $C8AB;    * Set the indirect jump ptr
P0D17: rts;
P0D18: jsr   InitializePlayerFrame; * Game Over
       ldx   #WaitForGameRestart;
       stx   $C8AB;    * Set the indirect jump ptr
       ldu   #$CBEB;
       ldx   #$C8C6;  * See if player had new hi score
       jsr   check_4_new_hi_score;
       ldd   #$0460;
       std   $C8AD;    * Set startup delay timer
       clr   $C89F;
       rts;

*
* RestartPlayerAgainstWarlordShip()
*
* This is the main processing function for when the player
* has been killed by the Warship, and is again about to
* face off against the Warship.  It delays briefly, before
* moving onto the next stage.
*
RestartPlayerAgainstWarlordShip:
       jsr   UpdatePlayersPosition;
       jsr   InitScoreAndShipCountFrames_2;
       ldd   $C8AD;    * Decrement startup delay timer
       subd  #$0001;  * Don't start the action until
       std   $C8AD;    * the delay timer has expired.
       bne   P0D4E;
       jsr   PrepareToFightWarlordShip;
       ldx   #PlayerFightingWarlordShip;
       stx   $C8AB;    * Set the indirect jump ptr
P0D4E: rts;

*
* PrepareToEnterEnemyPassage()
*
* This is the main processing function for when the user
* is just entering the enemy passage.  It initializes the
* player frames, sets up a delay timer, and flags that the
* passage walls should not initially be drawn.  It then
* moves the player onto the next state, which is entering
* the enemy passage.
*
PrepareToEnterEnemyPassage:
       jsr   InitializePlayerFrame;
       jsr   SetEnemyShipInfo;
       jsr   InitScoreAndShipCountFrames_2;
       ldd   #$0070;
       std   $C8AD;    * Set startup delay timer
       clr   $C8AF;    * Don't draw enemy passage walls
       ldx   #ApproachEnemyPassage;
       stx   $C8AB;    * Set the indirect jump ptr
       rts;

*
* ApproachEnemyPassage()
*
* This is the main processing function for when the player
* is approaching the enemy passage area.  Initially, only
* the player's ship is drawn.  After some delay, the
* state will be changed to the next state, which will
* enable the drawing of the passage walls.
*
ApproachEnemyPassage:
       jsr   UpdatePlayersPosition;
       jsr   SetEnemyShipInfo_2;
       ldd   $C8AD;   * Decrement startup delay timer
       subd  #$0001; * Don't start the action until
       std   $C8AD;   * the delay timer has expired.
       bne   P0D96;
P0D79: ldx   #EnterEnemyPassage;
       stx   $C8AB;   * Set the indirect jump ptr
       com   $C8AF;   * Enable drawing enemy passage walls
       clra;
       clrb;
       std   $C8CE;
       std   $C8D1;
       ldd   #$0300;
       std   $C8D4;
       jsr   P0676;
       jsr   InitAllBulletFrames;
P0D96: rts;

*
* EnterEnemyPassage()
*
* This is the main processing function for when the player
* is entering into the enemy passage area.  It updates
* any bullets fired by the player, and updates the position
* of both the enemy ship and the enemy star, before moving
* onto the next state (in the enemy passage).
*
EnterEnemyPassage:
       jsr   UpdatePlayersPosition;
       jsr   P0676;
       lda   $C8D4;
       cmpa  #$80;
       bls   P0DBC;
       jsr   InitAllBulletFrames;
       jsr   InitEnemyStarFrame;
       jsr   InitEnemyShipFrame;
       jsr   UpdateBulletFrames;
       jsr   ProcessEnemyStar;
       jsr   ProcessEnemyShip;
       ldx   #InEnemyPassage;
       stx   $C8AB;     * Set the indirect jump ptr
P0DBC: rts;

*
* PlayerHasRunOutOfFuel()
*
* This is the main processing function for when the player
* has completely run out of fuel, while in the enemy
* passage.  It continues to update any bullets fired by
* the player, and the positions of the enemy star and ship.
* It also forces the player's ship to slowly sink downward,
* due to lack of fuel, and to explode, when it comes in
* contact with the ground.
*
PlayerHasRunOutOfFuel:
       jsr   P0676;
       jsr   ProcessEnemyStar;
       jsr   ProcessEnemyShip;
       jsr   UpdateBulletFrames;
       dec   $C8D7;     * Force player to sink towards
       lda   $C8D7;     * ground (he has no fuel).  When
       cmpa  #$A0;     * the ship reaches the ground,
       bge   P0DE1;     * it's all over.
       clra;
       clrb;
       std   $C8B7;     * Clear alternate scale factor
       ldx   #PlayerCollidedWithEnemyShip;
       stx   $C8AB;     * Set the indirect jump ptr
       jsr   P0E3F;
P0DE1: rts;

*
* InEnemyPassage()
*
* This is the main processing function for when the player
* is in the enemy passage.  It updates everything on the
* display (bullets, player, enemy star, enemy ship, fuel
* levels, etc).  It also checks to see if there have been
* any collisions, or if the player has destroyed the last
* enemy ship for this level (at which point you advance to
* to the next state).
*
InEnemyPassage:
       clr   $C8A5;
       jsr   UpdatePlayersFuelLevel;
       jsr   P0676;
       jsr   UpdatePlayersPosition;
       jsr   ProcessEnemyStar;
       jsr   UpdateBulletFrames;
       tst   $CA7D;     * Is player out of fuel?
       beq   P0E08;
       lda   $C89B;     * Yes
       ora   #$40;
       sta   $C89B;     * Force a sound to occur
       ldx   #PlayerHasRunOutOfFuel;
       stx   $C8AB;     * Set the indirect jump ptr
P0E07: rts;
P0E08: jsr   ProcessEnemyShip;
       ldx   #$C981;   * Get ptr to enemy ship frame
P0E0E: jsr   UpdateEnemyShipPosition;
       tst   $C8BA;    * Did player collide w/ enemy ship?
       bne   P0E31;
       tst   $C8BC;    * Did player collide w/ enemy star?
       bne   P0E31;
       lda   $C8D7;    * Check to see if the player has
       cmpa  #$50;    * run into a passage wall, or has
       bge   P0E55;    * run aground.
       cmpa  #$BC;
       ble   P0E55;
       lda   $C8D8;
       cmpa  #$54;
       bge   P0E31;
       cmpa  #$BC;
       bgt   P0E55;
P0E31: com   $C8A5;    * Impact has occurred!
       clra;
       clrb;
       std   $C8B7;     * Clear alternate scale factor
       ldx   #PlayerCollidedWithEnemyShip;
       stx   $C8AB;     * Set the indirect jump ptr
P0E3F: lda   #$80;
       ora   $C89B;
       sta   $C89B;     * Force a sound to occur
       lda   #$01;
       sta   $C8A2;     * Set sound characteristics index
P0E4C: lda   $C89F;
       anda  #$FB;
       sta   $C89F;
       rts;
P0E55: lda   $C8B1;
       cmpa  $C885;     * All enemy ships destroyed?
       blo   P0E7A;
       clr   $C8B1;     * Clear enemy destroyed counter
       jsr   SetEnemyShipInfo_2;
       inc   $C8BD;
       jsr   P0E4C;
       ldx   #LevelCompleted;
       stx   $C8AB;     * Set the indirect jump ptr
       ldd   #$008C;
       std   $C8AD;     * Set the delay timer
       lda   #$FF;
       sta   $C900;
P0E7A: rts;

*
* PlayerCollidedWithEnemyShip()
*
* This is the main processing function for when the player
* has collided with something.  It draws the player's ship
* exploding, and then determines whether the player should
* reenter the enemy passage (if he has any ships left), or
* whether the game is over, and we should wait to start
* a new one.
*
PlayerCollidedWithEnemyShip:
       lda   #$81;     * Disable all but normal game
       anda  $C89F;     * noise & 'player hit' sound.
P0E80: sta   $C89F;
       tst   $C8A5;
       bne   P0E8B;
       jsr   P0676;
P0E8B: jsr   DrawPlayersShipExploding;
       jsr   ProcessEnemyShip;
       jsr   ProcessEnemyStar;
       jsr   UpdateBulletFrames;
       tst   $C8B9;     * Is the player's ship done
       beq   P0EAC;     * exploding?
       lda   $C8C4;     * If the player's ship count
       cmpa  #$30;     * is now 0, then the game is
       beq   P0EAD;     * over.  Otherwise, prepare
       dec   $C8C4;     * to try again.
       ldx   #PrepareToEnterEnemyPassage;
       stx   $C8AB;     * Set the indirect jump ptr
P0EAC: rts;
P0EAD: jsr   InitializePlayerFrame;
       ldx   #WaitForGameRestart;
       stx   $C8AB;     * Set the indirect jump ptr
       ldu   #$CBEB;   * See if the player set a new
       ldx   #$C8C6;   * high score for the game.
       jsr   check_4_new_hi_score;
       ldd   #$0460;
       std   $C8AD;     * Set the restart delay timer
       clr   $C89F;     * Disable all sounds
       rts;

GameOverString:
       DB      "GAME OVER",$80;

*
* WaitForGameRestart()
*
* This function waits until either the restart delay timer
* expires, or the player presses a button, at which time it
* will start up a new game.  While it is waiting for the
* timer to expire or the player to press a button, it will
* display the last player's score (in frame C91B), the
* 'GAME OVER' string (in frame C8F9)* and the player's
* ship (in frame C8D7).
*
WaitForGameRestart:
       lda   $C80F;    * If any buttons are pressed,
       anda  #$0F;    * then restart game.
       bne   P0EE5;
       ldd   $C8AD;    * Decrement restart delay timer,
       subd  #$0001;  * and restart game when it goes
       std   $C8AD;    * to 0.
       bne   P0EEC;
P0EE5: ldx   #StartupNewGame;
       stx   $C8AB;    * Set the indirect jump ptr
       rts;
P0EEC: clr   $C8AF;    * Don't draw enemy passage walls
       lda   #$FF;
       sta   $CA7D;    * Flag that player is out of fuel
       sta   $CA7E;    * Flag that player is low on fuel
       ldd   #$F840;
       std   $C82A;    * Set string height and width
       ldx   #$C8F9;  * Get ptr to frame C8F9
       clr   $1B,x;   * Flag player in enemy passage
P0F03: lda   #$02;
       sta   7,x;      * Frame # = 2 (green)
       ldd   #NE_DisplayString;
       std   $20,x;   * Set drawing function
       lda   #$20;
       sta   2,x;
       lda   #$7F;
       sta   3,x;      * Set scale factor
       lda   #$10;
       sta   5,x;      * Set embedded obj's scale factor
       lda   #$7F;
       sta   8,x;      * Set intensity
       ldd   #GameOverString;
       std   9,x;      * Set vector list 1
       ldd   #GameOverString;
       std   11,x;     * Set vector list 2
       ldd   #$E0D0;
       std   0,x;      * Set (y,x) position
       leax  $22,x;   * Get ptr to next frame
       clr   $1B,x;   * Flag player in enemy passage
       lda   #$01;
       sta   7,x;      * Frame # = 1 (blue)
       ldd   #NE_DisplayString;
       std   $20,x;   * Set drawing function
       lda   #$20;
       sta   2,x;
       lda   #$7F;
       sta   3,x;      * Set scale factor
       lda   #$10;
       sta   5,x;      * Set embedded obj's scale factor
       lda   #$7F;
       sta   8,x;      * Set intensity
       ldd   #$C8C6;  * Player's score string
       std   9,x;      * Set vector list 1
       ldd   #$C8C6;  * Player's score string
       std   11,x;     * Set vector list 2
       ldd   #$6020;
       std   0,x;      * Set (y,x) position
       leax  $22,x;   * Get ptr to next frame
       lda   #$FF;    * Mark the next frame as the
       sta   7,x;      * end of the active frame stack
       rts;

*
* LevelCompleted()
*
* This is the main processing function for when the player
* has completed a level.  It determines whether the player
* will enter the fuel passage, or go up against the
* Warlord ship.
*
LevelCompleted:
       lda   $C89F;
       anda  #$FD;
       sta   $C89F;
       lda   $C89B;
       anda  #$FD;
       sta   $C89B;    * Force off enemy ship sound
       lda   #$FF;
       sta   $C900;    * Force off player's bullet frames
       jsr   P068F;
       tst   $C8B2;
       beq   P0FA7;
       tst   $C88C;
       beq   PrepareForFuelPassage;
       clr   $C8B1;    * Clear 'warlord hit' counter
       jsr   PrepareToFightWarlordShip;
       ldx   #PlayerFightingWarlordShip;
       stx   $C8AB;    * Set the indirect jump ptr
       rts;

*
* PrepareForFuelPassage()
*
* This function prepares for the player to enter the fuel
* passage.  It sets up the frames used for drawing the
* fuel walls and cannisters, and moves the player into
* the next state (in the fuel passage).
*
PrepareForFuelPassage:
       jsr   InitAllFuelFrames;
       jsr   UpdateAllFuelFrames;
       ldx   #PlayerInFuelPassage;
       stx   $C8AB;    * Set the indirect jump ptr
       clr   $C8AF;    * Don't draw enemy passage walls
       clr   $C8B4;    * Clear fuel object counter
       clr   $C8B3;
P0FA7: rts;

*
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
*
PlayerInFuelPassage:
       clr   $CA7E;    * Prevent fuel bar from flashing
       clr   $C8B0;    * Clear 'fuel picked up' flag
       clr   $C8B2;    * Clear 'player thru level' flag
       jsr   UpdatePlayersPosition;
       jsr   CheckForContactWithFuelObjects;
       bge   P0FD2;    * Did player hit a fuel wall?
       ldd   #PlayerHitFuelWall;  * Yes; ship destroyed
       std   $C8AB;    * Set the indirect jump ptr
       clra;
       clrb;
       std   $C8B7;    * Clear alternate scale factor
       lda   #$80;
       ora   $C89B;
       sta   $C89B;    * Force sound to occur
       lda   #$01;
       sta   $C8A2;    * Set sound characteristics index
       rts;
P0FD2: cmpa  #$02;    * Did player pickup fuel cannister?
       bne   P0FEF;
       com   $C8B0;    * Yes; flag that fuel was picked up
       lda   $C89B;
       ora   #$10;
       sta   $C89B;    * Force sound to occur
       lda   $CA77;
       adda  #$05;    * Add 5 units of fuel to the
       cmpa  #$60;    * player's reserves, upto a max
       bls   P0FEC;    * of $60 fuel units.
       lda   #$60;
P0FEC: sta   $CA77;
P0FEF: cmpa  #$01;    * Did player pass thru opening?
       bne   P0FFB;
       lda   $C89B;    * Yes
       ora   #$08;
       sta   $C89B;    * Force sound to occur
P0FFB: jsr   UpdateAllFuelFrames;
       tst   $C8B2;    * Did player complete fuel passage?
       beq   P1009;
       jsr   SetEnemyShipInfo_2; * Yes; move onto next
       jmp   P0D79;   * enemy passage level.
P1009: rts;

*
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

PlayerHitFuelWall:
       jsr   DrawPlayersShipExploding;
       tst   $C8B9;    * Ship done exploding?
       beq   P104A;
       lda   $C8C4;    * Yes; see if the player has any
       cmpa  #$30;    * ships left.  If not, then the
       bne   P101C;    * game is over.
       jmp   P0EAD;   * Game Over
P101C: dec   $C8C4;    * Decrement player's ship count
       ldx   #PrepareToReenterFuelPassage;
       stx   $C8AB;    * Set the indirect jump ptr
       jsr   InitializePlayerFrame;
       lda   #$30;
       sta   $CA77;    * Start player with $30 fuel units
       jsr   InitScoreAndShipCountFrames_1;
       ldd   #$0070;
       std   $C8AD;    * Set delay timer
       ldx   #$C900;  * Force all 4 fuel frames invisible
       bsr   ForceFuelWallFrameInvisible;
       leax  $22,x;
       bsr   ForceFuelWallFrameInvisible;
       leax  $22,x;
       bsr   ForceFuelWallFrameInvisible;
       leax  $22,x;
       bsr   ForceFuelWallFrameInvisible;
P104A: rts;

*
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
* frame # from $FF to $1F.  Otherwise, it simply makes
* the frame invisible, by or'ing in $10.  By changing the
* 'end of frame stack' marker, this code will allow the
* frames beyond it to be displayed; in this case, the
* frames beyond contain the players ship count & score.

ForceFuelWallFrameInvisible:
       lda   0,x;
       bge   P1054;
       lda   #$1F;
       sta   0,x;
       rts;
P1054: ora   #$10;
       sta   0,x;
       rts;

*
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

PrepareToReenterFuelPassage:
       jsr   UpdatePlayersPosition;
       ldd   $C8AD;    * Decrement the delay timer, and
       subd  #$0001;  * do nothing until the timer
       std   $C8AD;    * counts down to 0.
       bne   P1091;
       ldx   #$C900;  * Reenable the 4 fuel object frames
       bsr   RestoreFuelWallFrameStatus;
       leax  $22,x;
       bsr   RestoreFuelWallFrameStatus;
       leax  $22,x;
       bsr   RestoreFuelWallFrameStatus;
       leax  $22,x;
       bsr   RestoreFuelWallFrameStatus;
       leax  $22,x;
       lda   #$FF;    * Set the 'end of frame stack'
       sta   0,x;
       ldd   #$0800;  * Reset 1st fuel wall's scale
       std   $C8FE;    * factor.
       jsr   UpdateAllFuelFrames;
       ldx   #PlayerInFuelPassage;
       stx   $C8AB;    * Set the indirect jump ptr
P1091: rts;

*
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
* is set to the special tag $1F, then it resets it to $FF
* (the 'end of frame stack' marker).  Otherwise, it forces
* the frame to again be visible, by and'ing the frame
* number with $0F.

RestoreFuelWallFrameStatus:
       lda   0,x;
       cmpa  #$1F;     * Former end of frame stack?
       beq   P109D;
       anda  #$0F;     * Nope, so make visible again
       sta   0,x;
       rts;
P109D: lda   #$FF;     * Yes, so retag as end of stack
       sta   0,x;
       rts;

*
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

InitScoreAndShipCountFrames_1:
       ldx   #$C981;   * Use frames C981 & C9A3
       bra   P10AA;
InitScoreAndShipCountFrames_2:
       ldx   #$C8F9;   * Use frames C8F9 & C91B
P10AA: ldd   #$F840;
       std   $C82A;     * Set string height & width
       clr   $1B,x;    * Flag player in enemy passage
       lda   #$01;
       sta   7,x;       * Frame # = 1 (blue)
       ldd   #NE_DisplayString;
       std   $20,x;    * Set drawing function
       lda   #$20;
       sta   2,x;
       lda   #$7F;
       sta   3,x;       * Set scale factor
       lda   #$10;
       sta   5,x;       * Set embedded obj's scale factor
       lda   #$7F;
       sta   8,x;       * Set intensity
       ldd   #$C8BE;   * Ptr to ship count string
       std   9,x;       * Set vector list 1
       ldd   #$C8BE;   * Ptr to ship count string
       std   11,x;      * Set vector list 2
       ldd   #$60B0;
       std   0,x;       * Set (y,x) position
       leax  $22,x;    * Get ptr to next frame
       clr   $1B,x;    * Flag player in enemy passage
       lda   #$02;
       sta   7,x;       * Frame # = 2 (green)
       ldd   #NE_DisplayString;
       std   $20,x;    * Set drawing function
       lda   #$20;
       sta   2,x;
       lda   #$7F;
       sta   3,x;       * Set scale factor
       lda   #$10;
       sta   5,x;       * Set embedded obj's scale factor
       lda   #$7F;
       sta   8,x;       * Set intensity
       ldd   #$C8C6;   * Ptr to player's score
       std   9,x;       * Set vector list 1
       ldd   #$C8C6;   * Ptr to player's score
       std   11,x;      * Set vector list 2
       ldd   #$6020;
       std   0,x;       * Set (y,x) position
       leax  $22,x;    * Get ptr to next frame
       lda   #$FF;
       sta   7,x;       * Tag as 'End of frame stack'
       rts;

ShipCountString:
       DB      "SHIPS 3",$80;

*
* InitPlayersScoreAndShipCount()
*
* This function initializes the buffers holding the player's
* ship count (C8BE), and the player's score (C8C6).

InitPlayersScoreAndShipCount:
       clr   $C8CD;
       ldx   #ShipCountString;
       ldu   #$C8BE;    * Ptr to ship count buffer
       ldd   ,x++;
       std   ,u++;
       ldd   ,x++;
       std   ,u++;
       ldd   ,x++;
       std   ,u++;
       ldd   ,x++;
       std   ,u++;       * Set buffer to "SHIPS 3",$80
       ldd   #$2020;
       ldx   #$C8C6;    * Ptr to player's score buffer
       std   ,x++;
       std   ,x++;
       sta   ,x+;
       ldd   #$3080;
       std   0,x;        * Set buffer to "     0",$80
       rts;

*
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
* for the segment is > $60, at which point it will draw
* using the second vector ptr.  The first vector ptr
* represents the full wall, while the second vector ptr
* is used when a wall is all the way up front, and is about
* to go off the front of the screen (thus, only a portion of
* the wall is still visible).

DrawEnemyPassageWalls:
       tst   $C8AF;      * Should enemy walls be drawn?
       bne   P114C;
       rts;              * No
P114C: pshs  y;          * Yes
       lda   #$03;
       sta   $C891;      * Set loop counter; 3 walls
       ldy   #$C8D4;
P1157: ldx   0,u;
       lda   0,y;
       beq   P1166;
       cmpa  #$60;      * If scale <= $60 then draw
       bls   P1163;      * the full wall, else draw only
       ldx   2,u;        * the partial wall
P1163: jsr   DrawOneEnemyPassageWall;
P1166: leay  -3,y;
       dec   $C891;      * Decrement loop counter
       bne   P1157;      * More walls to draw?
       puls  y;
       rts;

*
* DrawFuelBar()
*
* This function draws the player's fuel bar (gauge).
* If the player is out of fuel, then the bar is not drawn.
* If the player is low on fuel, then the fuel bar will
* be forced to flash (by not drawing it on every pass
* through this function.  The amount of fuel the player
* has (in CA77) is actually the scale factor used to
* draw the fuel bar.

DrawFuelBar:
       tst   $CA7D;      * Is player out of fuel?
       beq   P1176;
       rts;              * Yes
P1176: tst   $CA7E;      * No, but is player low on fuel?
       beq   P1183;
       lda   $C826;      * Yes; therefore, force the fuel
       anda  #$10;      * bar to flash, by not drawing
       beq   P1183;      * it on every pass.
       rts;
P1183: jsr   intensity_to_7F;
       ldb   #$60;
       stb   <$04;       * Write scale factor ($60)
       ldd   #$80D0;    * Drawing position is based on
       tst   $C8A6;      * whether we are drawing for the
       bne   P1195;      * left or right eye.
       ldd   #$80F0;
P1195: sta   <$01;       * Write y value ($80)
       clr   <$00;
       lda   #$CF;      * Un-zero integrators, & trigger
       sta   <$0C;       * IRQ off positive edge.
       inc   <$00;
       stb   <$01;       * Write x value ($D0 or $F0)
       ldb   #$40;
       clr   <$05;
P11A5: bitb  <$0D;       * Wait for timer interrupt
       beq   P11A5;      * Display the player's fuel bar
       clr   <$01;       * Write y value (0)
       clr   <$00;
       lda   $CA77;      * Get player's fuel units
       sta   <$04;       * Write scale factor
       ldb   #$7F;
       inc   <$00;
       stb   <$01;       * Write x value ($7F)
       ldb   #$40;
       clr   <$05;
       com   <$0A;
P11BE: bitb  <$0D;       * Wait for timer interrupt
       beq   P11BE;
       clr   <$0A;       * Clear line drawing pattern
       jsr   P0353;
       rts;

*
* CheckForCollisionWithBullets()
*
* Entry:
*   x = Frame ptr
*   C880 = Contact tolerance value
*
* Exit:
*   a = $00 (no contact) or $FF (contact occurred)
*
* This function checks each of the player's bullets, to see
* if one of them have hit the object in the incoming frame.
* The 'tolerance' value controls how close two objects
* must be, in order for them to be considered as having
* collided.  Before checking to see if two objects have
* collided, the two frames must have similar scale factor
* values (their difference must be <= 2).

CheckForCollisionWithBullets:
       ldu   #$C8F9;    * Get ptr to first bullet frame
       lda   3,x;        * Get scale for incoming frame
       ldb   #$10;
       bitb  7,u;        * Skip this bullet frame, if
       bne   P11DC;      * it is not visible.
       suba  3,u;        * Calculate the absolute value
       bpl   P11D8;      * of the difference between the
       nega;             * 2 frame's scale factors.
P11D8: cmpa  #$02;      * Skip this bullet, if the scale
       bls   P1204;      * factors are not within 2.
P11DC: leau  $22,u;     * Get ptr to next bullet frame
       bitb  7,u;        * Skip this bullet frame, if
       bne   P11EE;      * it is not visible.
       lda   3,x;        * Calculate the absolute value
       suba  3,u;        * of the difference between the
       bpl   P11EA;      * 2 frame's scale factors.
       nega;
P11EA: cmpa  #$02;      * Skip this bullet, if the scale
       bls   P1204;      * factors are not within 2.
P11EE: leau  $22,u;     * Get ptr to next bullet frame
       bitb  7,u;        * Skip this bullet frame, if
       beq   P11F7;      * it is not visible.
       clra;             * Bail out; no contact occurred
       rts;
P11F7: lda   3,x;        * Calculate the absolute value
       suba  3,u;        * of the difference between the
       bpl   P11FE;      * 2 frame's scale factors.
       nega;
P11FE: cmpa  #$02;      * Skip this bullet, if the scale
       bls   P1204;      * factors are not within 2.
       clra;             * Bail out; no contact occurred
       rts;
P1204: ldd   0,x;        * Calulate the absolute value of
       suba  0,u;        * the difference in the 2 frame's
       subb  1,u;        * x and y values.
       jsr   get_absolute_value_of_ab;
       cmpa  $C880;      * Proceed only if the y values
       blt   P1214;      * are within the tolerance level
       clra;             * Bail out; no contact occurred
       rts;
P1214: cmpb  $C880;      * Proceed only if the x values
       blt   P121B;      * are within the tolerance level
       clra;             * Bail out; no contact occurred
       rts;
P121B: lda   #$FF;      * Contact!!
       ldb   7,u;
       orb   #$10;
       stb   7,u;        * Tag bullet frame as invisible
       rts;

*
* CheckForCollisionWithPlayer()
*
* Entry:
*   x = Frame ptr
*
* Exit:
*   a = $00 (no contact) or $FF (contact occurred)
*
* This function checks to see if the incoming frame object
* has collided with the player's ship. Before checking to
* see if two objects have collided, the two frames must
* have similar scale factor values (their difference must
* be <= 3).  The 'y' tolerance value is $08, while the 'x'
* tolerance value is $1E (30).

CheckForCollisionWithPlayer:
       clra;           * Initially assume no contact
       ldb   7,x;       * Skip check, if the incoming
       bitb  #$10;    * frame is not visible.
       beq   P122C;
       rts;
P122C: tst   $1E,x;   * Skip check, if the incoming
       beq   P1232;    * frame is already exploding.
       rts;
P1232: ldu   #$C8D7;  * Get ptr to player's frame
       tst   $1E,u;   * Skip if already exploding.
       beq   P123B;
       rts;
P123B: lda   3,x;      * Calculate the absolute value
       suba  3,u;      * of the difference between the
       bpl   P1242;    * 2 frame's scale factors.
       nega;
P1242: cmpa  #$03;    * No possible contact if the
       bls   P1248;    * scale factors difference > 3
       clra;           * Bail out; no contact occurred
       rts;
P1248: ldd   0,x;      * Calculate the x & y deltas for
       suba  0,u;      * the two frames.
       subb  1,u;
       jsr   get_absolute_value_of_ab;
       cmpa  #$08;    * Proceed only if the y delta
       blt   P1257;    * is < 8
       clra;           * Bail out; no contact occurred
       rts;
P1257: cmpb  #$1E;    * Proceed only if the x delta
       blt   P125D;    * is < $1E (30).
       clra;           * Bail out; no contact occurred
       rts;
P125D: lda   #$FF;    * Contact!!
       rts;

*
* CheckForContactWithFuelObjects:
*
* Exit:
*    a = $00 (No contact)
*        $01 (Passed through fuel wall opening)
*        $02 (Picked up fuel cannister)
*        $FF (Hit fuel wall)
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

CheckForContactWithFuelObjects:
       ldx   #$C8F9;  * Get ptr to 1st fuel object frame
P1263: tst   7,x;      * Skip, if this frame is marked
       bge   P1269;    * as the end of the frame stack.
       clra;           * No contact
       rts;
P1269: lda   5,x;      * If the fuel object and player's
       suba  #$3F;    * scale factors are within 1, then
       bge   P1270;    * check for pass-thru (fuel wall)
       nega;           * or collection (fuel cannister).
P1270: cmpa  #$01;
       bls   P1279;
       leax  $22,x;   * Check the next frame
       bra   P1263;
P1279: ldb   $C8D7;    * Get the difference between the
       sex;            * the player's y position and the
       std   $C891;    * fuel object's y position.  Save
       ldb   $1C,x;   * the 16-bit value in C891-C892
       sex;
       subd  $C891;
       bge   P128E;
       coma;
       comb;
       addd  #$0001;
P128E: std   $C891;
       ldb   $C8D8;    * Get the difference between the
       sex;            * the player's x position and the
       std   $C893;    * fuel object's x position.  Save
       ldb   $1D,x;   * the 16-bit value in C893-C894
       sex;
       subd  $C893;
       bge   P12A6;
       coma;
       comb;
       addd  #$0001;
P12A6: std   $C893;
       ldd   9,x;      * Fuel cannister or fuel wall?
       cmpd  #FuelCannister;
       bne   P12CE;
       ldd   $C891;    * Fuel cannister.  Is
       cmpd  #$000F;  * |y delta| <= 15 ?
       bls   P12BC;
       clra;           * Nope; missed the cannister
       rts;
P12BC: ldd   $C893;    * Is |x delta| <= 15 ?
       cmpd  #$000F;
       bls   P12C7;
       clra;           * Nope; missed the cannister
       rts;
P12C7: lda   #$10;    * Picked up the fuel cannister;
       sta   7,x;      * tag frame as no longer visible.
       lda   #$02;
       rts;
P12CE: ldd   9,x;      * Large or small wall opening?
       cmpd  #FuelWallOpening_Large;
       bne   P12F1;
       ldd   $C891;    * Large opening
       cmpd  #$000C;  * Is |y delta| <= 12 ?
       bls   P12E2;
       lda   #$FF;    * Nope; hit the wall
       rts;
P12E2: ldd   $C893;    * Is |x delta| <= 12 ?
       cmpd  #$000C;
       bls   P12EE;
       lda   #$FF;    * Nope; hit the wall
       rts;
P12EE: lda   #$01;    * Successfully passed thru opening
       rts;
P12F1: ldd   $C891;    * Small opening
       cmpd  #$0008;  * Is |y delta| <= 8 ?
       bls   P12FD;
       lda   #$FF;    * Nope; hit the wall
       rts;
P12FD: ldd   $C893;    * Is |x delta| <= 4 ?
       cmpd  #$0004;
       bls   P1309;
       lda   #$FF;    * Nope; hit the wall
       rts;
P1309: lda   #$01;    * Successfully passed thru opening
       rts;

*
* InitFuelWallOrCannisterFrame()
*
* Entry:
*    x = frame ptr
*
* This function fills in the incoming frame with information
* for either a fuel wall or a fuel cannister; if C8B5 is
* $00, then a fuel wall is initialized, otherwise, the
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

InitFuelWallOrCannisterFrame:
       lda   $C87D;     * Use the system loop counter
       anda  #$1E;     * to generate a random index
       ldu   #EmbeddedObjectPositions; * into the
       ldd   a,u;       * embedded object position array.
       std   $1C,x;    * Save the embedded objs position
       tst   $C8B5;     * Fuel wall or fuel cannister?
       beq   P132D;
       ldd   #FuelCannister;
       std   9,x;       * Save vector list 1
       std   11,x;      * Save vector list 2
       ldd   #DrawThenZeroIntegrators;
       std   $20,x;    * Set drawing function
       bra   P1344;
P132D: ldd   #DrawFuelWall;
       std   $20,x;    * Set drawing function
       ldu   #FuelWallOpening_Large;
       lda   $C8B4;     * See if a large or small fuel
       cmpa  #$06;     * wall opening is required.
       bls   P1340;
       ldu   #FuelWallOpening_Small;
P1340: stu   9,x;       * Set vector list 1
       stu   11,x;      * Set vector list 2
P1344: com   $C8B5;     * Set up for next pass
       lda   $C8B6;     * Use C8B6 to generate an index
       cmpa  #$03;     * which will be used to obtain
       bne   P134F;     * the frame number (color) for
       clra;            * this frame.
P134F: ldu   #FuelWallFrameColors;
       ldb   a,u;
       inca;
       sta   $C8B6;     * Update index for next pass
       stb   7,x;       * Set the frame # (color)
       inc   $C8B4;     * Inc fuel object counter
       rts;

FuelWallFrameColors:
       DB    $01;      * blue
       DB    $02;      * green
       DB    $03;      * red

*
* This array of (y,x) pairs is used to control the
* positions of the embedded objects; i.e. fuel cannisters
* and fuel wall openings.

EmbeddedObjectPositions:
       DW    $0000;
       DW    $0048;
       DW    $00B8;
       DW    $4800;
       DW    $B800;
       DW    $4848;
       DW    $48B8;
       DW    $B848;
       DW    $B8B8;
       DW    $0020;
       DW    $00E0;
       DW    $2000;
       DW    $E000;
       DW    $2020;
       DW    $20E0;
       DW    $E020;

*
* UpdateAllFuelFrames()
*
* This function is responsible for updating the scale
* factor in each of the fuel object frames.  When the
* frontmost fuel object reaches the front of the screen
* (when its scale factor >= $6F), then that object will
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

UpdateAllFuelFrames:
       lda   $C8FE;    * Has the front-most fuel object
       cmpa  #$6F;    * reached the front of the screen?
       lblo  P13FF;
       ldd   $C920;    * Yes; so shuffle up other frames
       std   $C8FE;    * Frame 2 scale => frame 1
       lda   $C922;
       sta   $C900;    * Frame 2 frame # => frame 1
       lda   $C944;
       sta   $C922;    * Frame 3 frame # => frame 2
       lda   $C966;
       sta   $C944;    * Frame 4 frame # => frame 3
       ldd   $C924;
       std   $C902;    * Frame 2 vector list => frame 1
       std   $C904;    * Frame 2 vector list => frame 1
       ldd   $C946;
       std   $C924;    * Frame 3 vector list => frame 2
       std   $C926;    * Frame 3 vector list => frame 2
       ldd   $C968;
       std   $C946;    * Frame 4 vector list => frame 3
       std   $C948;    * Frame 4 vector list => frame 3
       ldd   $C93B;
       std   $C919;    * Frame 2 drawing func => frame 1
       ldd   $C95D;
       std   $C93B;    * Frame 3 drawing func => frame 2
       ldd   $C97F;
       std   $C95D;    * Frame 4 drawing func => frame 3
       ldd   $C937;
       std   $C915;    * Frame 2 emb-obj pos => frame 1
       ldd   $C959;
       std   $C937;    * Frame 3 emb-obj pos => frame 2
       ldd   $C97B;
       std   $C959;    * Frame 4 emb-obj pos => frame 3
       ldb   $C8B4;    * Either start another fuel object
       cmpb  $C883;    * or disable the last frame.
       bls   P13F0;
       lda   #$FF;    * We don't need to start another
       sta   $C966;    * fuel obj; so disable last frame
       bra   P13F6;
P13F0: ldx   #$C95F;  * Start another fuel object
       jsr   InitFuelWallOrCannisterFrame;
P13F6: tst   $C900;    * Are there any active frames left?
       bge   P13FF;
       com   $C8B2;    * No; player is done
       rts;
P13FF: ldx   #$C8FE;  * Update the secondary scale
       lda   $C884;    * factor for frame 1.
       jsr   P06E0;
       lda   $C8FE;
       ldb   #$7F;    * Update the secondary scale
       mul;            * factor for frame 2.
       sta   $C920;
       ldb   #$7F;    * Update the secondary scale
       mul;            * factor for frame 3.
       sta   $C942;
       ldb   #$7F;    * Update the secondary scale
       mul;            * factor for frame 4.
       sta   $C964
       lda   #$04;
       sta   $C891;    * Set loop counter
       ldx   #$C8F9;  * Get fuel obj 1 frame ptr
P1425: lda   5,x;      * Get embedded obj's intensity
       ldb   #$80;
       mul;
       asla;
       sta   2,x;
       lda   5,x;      * Calculate intensity =
       adda  #$40;    * embedded obj scale factor+$40
       bpl   P1435;    * If rollover occurs, then use
       lda   #$7F;    * max intensity ($7F).
P1435: sta   8,x;      * Set intensity
       leax  $22,x;   * Point to next frame
       dec   $C891;    * Decrement loop counter
       bne   P1425;    * Done processing the frames?
       rts;

*
* InitAllFuelFrames()
*
* This function initializes the fuel passage variables,
* along with the 5 frames used to display the fuel objects
* (4 of the frames display fuel objects, while the 5th
* frame is used to tag the end of the frame stack).  The
* frame ptrs used are: C8F9, C91B, C93D, C95F and C981.

InitAllFuelFrames:
       ldd   #$0800;    * Force the secondary scale for
       std   $C8FE;      * fuel object 1 to $08000
       ldx   #$C8F9;    * Get ptr to fuel obj 1 frame
       clr   $C8B4;      * Clear the fuel object counter
       clr   $C8B5;      * Force fuel wall to draw first
       clr   $C8B6;      * Init fuel object color index
       lda   #$04;      * Init the 1st 4 fuel objects
       sta   $C897;      * Set loop counter
P1457: ldb   #$FF;
       stb   $1B,x;     * Flag player in fuel passage
       jsr   InitFuelWallOrCannisterFrame;
       jsr   get_random_a;
       ldd   #$0000;
       std   0,x;        * Set frame (y,x) to (0,0)
       ldd   #$0001;
       std   3,x;        * Set scale factor
       leax  $22,x;     * Get ptr to next frame
       dec   $C897;      * Decrement loop counter
       bne   P1457;      * Done processing the frames?
       lda   #$FF;
       sta   7,x;        * Tag the end of the frame stack
       rts;

* Vector list, 4 bytes per endpoint
FuelCannister:
       DB    $00;
       DB    $10;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $F0;
       DB    $10;
       DB    $00;
       DB    $FF;
       DB    $F0;
       DB    $F0;
       DB    $00;
       DB    $FF;
       DB    $10;
       DB    $F0;
       DB    $00;
       DB    $FF;
       DB    $10;
       DB    $10;
       DB    $00;
       DB    $01;

* Vector list, 4 bytes per endpoint
FuelWall:
       DB    $00;
       DB    $7F;
       DB    $7F;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $81;
       DB    $01;
       DB    $FF;
       DB    $81;
       DB    $00;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $7F;
       DB    $01;
       DB    $FF;
       DB    $7F;
       DB    $00;
       DB    $01;
       DB    $00;
       DB    $81;
       DB    $81;
       DB    $00;
       DB    $01;

* Vector list, 4 bytes per endpoint
FuelWallOpening_Large:
       DB    $00;
       DB    $18;
       DB    $30;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $A0;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $60;
       DB    $00;
       DB    $FF;
       DB    $30;
       DB    $00;
       DB    $00;
       DB    $01;

* Vector list, 4 bytes per endpoint
FuelWallOpening_Small:
       DB    $00;
       DB    $14;
       DB    $20;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $C0;
       DB    $00;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $00;
       DB    $01;

RefreshCheckPoints:
       DW    $F000;
       DW    $BD00;
       DW    $9600;
       DW    $6800;
       DW    $4000;
       DW    $2000;
       DW    $0000;

FrameDrawingProcs:
       DW    EP_DABlueFramesAndWalls_RE ; EP_DrawAllBlueFramesAndWalls_RightEye;
       DW    EP_DAGreenFramesAndWalls_RE ; EP_DrawAllGreenFramesAndWalls_RightEye;
       DW    EP_DrawAllRedFrames_RightEye;
       DW    EP_DABlueFramesAndWalls_LE;  ; EP_DrawAllBlueFramesAndWalls_LeftEye;
       DW    EP_DAGreenFramesAndWalls_LE  ; EP_DrawAllGreenFramesAndWalls_LeftEye;
       DW    EP_DrawAllRedFrames_LeftEye;

P14EB: jsr   init_music_buf;
       clr   <$45;
       ldy   #$CA90;
       ldu   #$153F;
       ldd   #$0380;
       std   <$9C;
       clr   <$9E;
       lda   <$9B;     * Load the sound bitmask
       ora   <$9F;
       sta   <$A0;
P1504: lda   <$9D;
       anda  <$A0;
       beq   P152C;
       tfr   a,b;
       ora   <$9E;
       sta   <$9E;
       bitb  <$9B;
       bne   P1518;
       andb  <$9F;
       bne   P1526;
P1518: ldd   2,u;
       std   ,y;
       ldd   4,u;
       std   2,y;
       lda   #$1F;
       sta   <$A1;
       sta   <$46;
P1526: jsr   [,u];    * (INDIRECT JUMP)
       lda   <$9C;
       beq   P1534;
P152C: leau  7,u;
       leay  4,y;
       lsr   <$9D;
       bne   P1504;
P1534: lda   <$9F;
       anda  #$07;
       ora   <$9E;
       sta   <$9F;
       clr   <$9B;     * Clear the sound bitmask
       rts;

*
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

S153F: DW    $16AC;
       DB    $01;
       DB    $A0;
       DB    $00;
       DB    $00;
       DB    $FF;

       DW    $15D4;
       DB    $00;
       DB    $10;
       DB    $0E;
       DB    $0E;
       DB    $00;

       DW    $1583;
       DB    $00;
       DB    $00;
       DB    $0F;
       DB    $18;
       DB    $FF;

       DW    $161D;
       DB    $02;
       DB    $00;
       DB    $0C;
       DB    $05;
       DB    $FF;

       DW    $1640;
       DB    $0F;
       DB    $FF;
       DB    $10;
       DB    $18;
       DB    $FF;

       DW    $1577;
       DB    $00;
       DB    $55;
       DB    $10;
       DB    $00;
       DB    $00;

       DW    $1667;
       DB    $00;
       DB    $70;
       DB    $0A;
       DB    $01;
       DB    $00;

       DW    $1653;
       DB    $0C;
       DB    $00;
       DB    $0D;
       DB    $18;
       DB    $00;

P1577: ldd   #$1040;
       std   <$40;
       lda   #$08;
       sta   <$3F;
       jmp   P1680;

P1583: pshs  y,u;
       ldy   #$CAB0;
       lda   <$9B;       * Load the sound bitmask
       anda  <$9D;
       beq   P15A0;
       ldd   #$0000;
       std   ,y;
       ldd   #$0003;
       std   4,y;
       ldd   #$0F18;
       std   2,y;
       std   6,y;
P15A0: ldu   #$16D7;
       ldd   #$00A0;
       std   <$40;
       clr   <$46;
       lda   #$0E;
       sta   <$3F;
       bsr   P15BD;
       leay  4,y;
       leau  1,u;
       bsr   P15BD;
       leay  4,y;
       leau  1,u;
       puls  y,u;
       rts;

P15BD: dec   3,y;
       lbeq  P16A4;
       lda   3,y;
       cmpa  #$0E;
       bgt   P15CB;
       sta   2,y;
P15CB: ldx   ,y;
       leax  2,x;
       stx   ,y;
       jmp   P1680;

P15D4: ldy   #$CABC;
       lda   <$9B;       * Load the sound bitmask
       bita  <$9D;
       beq   P1605;
       lda   <$A0;
       anda  #$FD;
       sta   <$A0;
       lda   <$9F;
       anda  #$FD;
       sta   <$9F;
       ldd   #$0010;
       std   ,y;
       std   4,y;
       ldd   #$0E0E;
       std   2,y;
       ldd   #$0000;
       std   8,y;
       ldd   #$0E07;
       std   6,y;
       ldd   #$0F03;
       std   10,y;
P1605: bsr   P160D;
       leay  4,y;
       bsr   P160D;
       leay  4,y;
P160D: dec   3,y;
       bne   P1680;
       lda   #$03;
       sta   3,y;
       ldx   0,y;
       leax  1,x;
       stx   0,y;
       bra   P1680;

P161D: lda   <$A0;
       anda  #$FD;
       sta   <$A0;
       lda   <$9F;
       anda  #$FD;
       sta   <$9F;
       ldd   0,y;
       subd  #$0030;
       std   0,y;
       dec   <$A1;
       lda   <$A1;
       sta   <$46;
       cmpa  #$0F;
       bgt   P163C;
       sta   2,y;
P163C: bne   P1680;
       bra   P16A4;
P1640: ldd   #$2F40;
       std   <$40;
       lda   #$03;
       sta   <$3F;
       dec   3,y;
       bne   P1680;
       lda   #$02;
       sta   <$3F;
       bra   P16A4;
P1653: ldd   0,y;
       subd  #$0003;
       std   0,y;
       cmpd  #$0A00;
       bhi   P1680;
       ldd   #$0C00;
       std   0,y;
       bra   P1680;
P1667: dec   3,y;
       bne   P1675;
       lda   #$04;
       sta   3,y;
       lda   <$A3;
       sta   1,y;
       bra   P1680;
P1675: lda   #$04;
       suba  3,y;
       asla;
       asla;
       nega;
       adda  1,y;
       sta   1,y;
P1680: ldx   #$C842;
       dec   <$9C;
       lda   <$9C;
       ldb   2,y;
       stb   a,x;
       asla;
       adda  #$05;
       leax  a,x;
       ldd   ,y;
       std   ,x;
       ldx   #$16D7;
       lda   6,u;
       bmi   P16A3;
       adda  <$9C;
       lda   a,x;
       ora   <$45;
       sta   <$45;
P16A3: rts;
P16A4: lda   <$9D;
       coma;
       anda  <$9E;
       sta   <$9E;
       rts;

P16AC: lda   <$9B;     * Get the explosion bitmask
       anda  <$9D;
       beq   P16B4;
       sta   <$67;
P16B4: pshs  u;
       lda   <$A2;     * Use sound characteristic index
       ldu   #SoundCharacteristics;
       asla;
       asla;
       leau  a,u;
       lda   1,u;
       sta   <$46;
       jsr   generate_explosion_sound;
       clr   <$9C;
       puls  u;
       lda   <$77;
       beq   P16A4;
       rts;

*
* Array of 2 entries, each 4 bytes long.

SoundCharacteristics:
       DB    $38;
       DB    $10;
       DB    $00;
       DB    $08;

       DB    $3F;
       DB    $03;
       DB    $00;
       DB    $04;

S16D7: DB    $20;
       DB    $10;
       DB    $08;
       DB    $04;
       DB    $02;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $28;
       DB    $3C;
       DB    $FF;
       DB    $14;
       DB    $C4;
       DB    $FF;
       DB    $D8;
       DB    $EC;
       DB    $FF;
       DB    $EC;
       DB    $D8;
       DB    $FF;
       DB    $D8;
       DB    $28;
       DB    $FF;
       DB    $14;
       DB    $3C;
       DB    $FF;
       DB    $3C;
       DB    $14;
       DB    $01;

EnemyStarVectorList:
       DB    $00;
       DB    $32;
       DB    $32;
       DB    $FF;
       DB    $EC;
       DB    $C4;
       DB    $FF;
       DB    $14;
       DB    $D8;
       DB    $FF;
       DB    $CE;
       DB    $1E;
       DB    $FF;
       DB    $CE;
       DB    $E2;
       DB    $FF;
       DB    $14;
       DB    $1E;
       DB    $FF;
       DB    $EC;
       DB    $46;
       DB    $FF;
       DB    $28;
       DB    $D8;
       DB    $FF;
       DB    $3C;
       DB    $28;
       DB    $01;

EnemyShip1VectorTable:
       DW    EnemyShip1_1;
       DW    EnemyShip1_2;
       DW    EnemyShip1_3;
       DW    EnemyShip1_4;

EnemyShip1_1:
       DB    $FF;
       DB    $20;
       DB    $40;
       DB    $FF;
       DB    $C0;
       DB    $00;
       DB    $FF;
       DB    $20;
       DB    $C0;
       DB    $FF;
       DB    $20;
       DB    $C0;
       DB    $FF;
       DB    $C0;
       DB    $00;
       DB    $FF;
       DB    $20;
       DB    $40;
       DB    $01;

EnemyShip1_2:
       DB    $FF;
       DB    $28;
       DB    $38;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $C8;
       DB    $FF;
       DB    $28;
       DB    $C8;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $38;
       DB    $01;

EnemyShip1_3:
       DB    $FF;
       DB    $30;
       DB    $30;
       DB    $FF;
       DB    $A0;
       DB    $00;
       DB    $FF;
       DB    $30;
       DB    $D0;
       DB    $FF;
       DB    $30;
       DB    $D0;
       DB    $FF;
       DB    $A0;
       DB    $00;
       DB    $FF;
       DB    $30;
       DB    $30;
       DB    $01;

EnemyShip1_4:
       DB    $FF;
       DB    $38;
       DB    $28;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $FF;
       DB    $38;
       DB    $D8;
       DB    $FF;
       DB    $38;
       DB    $D8;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $FF;
       DB    $38;
       DB    $28;
       DB    $01;

EnemyShip2VectorTable:
       DW    EnemyShip2_1;
       DW    EnemyShip2_2;
       DW    EnemyShip2_3;
       DW    EnemyShip2_4;

EnemyShip2_1:
       DB    $00;
       DB    $CE;
       DB    $32;
       DB    $FF;
       DB    $32;
       DB    $9C;
       DB    $FF;
       DB    $32;
       DB    $64;
       DB    $00;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $CE;
       DB    $64;
       DB    $FF;
       DB    $CE;
       DB    $9C;
       DB    $01;

EnemyShip2_2:
       DB    $00;
       DB    $CE;
       DB    $32;
       DB    $FF;
       DB    $32;
       DB    $B0;
       DB    $FF;
       DB    $32;
       DB    $50;
       DB    $00;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $CE;
       DB    $50;
       DB    $FF;
       DB    $CE;
       DB    $B0;
       DB    $01;

EnemyShip2_3:
       DB    $00;
       DB    $CE;
       DB    $32;
       DB    $FF;
       DB    $32;
       DB    $C4;
       DB    $FF;
       DB    $32;
       DB    $3C;
       DB    $00;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $CE;
       DB    $3C;
       DB    $FF;
       DB    $CE;
       DB    $CE;
       DB    $01;

EnemyShip2_4:
       DB    $00;
       DB    $CE;
       DB    $32;
       DB    $FF;
       DB    $32;
       DB    $D8;
       DB    $FF;
       DB    $32;
       DB    $28;
       DB    $00;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $CE;
       DB    $28;
       DB    $FF;
       DB    $CE;
       DB    $D8;
       DB    $01;

EnemyShip3VectorTable:
       DW    EnemyShip3_1;
       DW    EnemyShip3_2;
       DW    EnemyShip3_3;
       DW    EnemyShip3_4;

EnemyShip3_1:
       DB    $FF;
       DB    $CE;
       DB    $CE;
       DB    $FF;
       DB    $14;
       DB    $00;
       DB    $FF;
       DB    $EC;
       DB    $32;
       DB    $FF;
       DB    $14;
       DB    $32;
       DB    $FF;
       DB    $EC;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $64;
       DB    $64;
       DB    $FF;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $EC;
       DB    $32;
       DB    $FF;
       DB    $14;
       DB    $32;
       DB    $00;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $9C;
       DB    $64;
       DB    $01;

EnemyShip3_2:
       DB    $FF;
       DB    $D8;
       DB    $D8;
       DB    $FF;
       DB    $1E;
       DB    $00;
       DB    $FF;
       DB    $EC;
       DB    $28;
       DB    $FF;
       DB    $14;
       DB    $28;
       DB    $FF;
       DB    $E2;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $00;
       DB    $00;
       DB    $50;
       DB    $FF;
       DB    $50;
       DB    $B0;
       DB    $FF;
       DB    $E2;
       DB    $28;
       DB    $FF;
       DB    $1E;
       DB    $28;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $00;
       DB    $D8;
       DB    $28;
       DB    $FF;
       DB    $28;
       DB    $28;
       DB    $01;

EnemyShip3_3:
       DB    $00;
       DB    $F6;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $D8;
       DB    $FF;
       DB    $00;
       DB    $50;
       DB    $FF;
       DB    $D8;
       DB    $D8;
       DB    $00;
       DB    $EC;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $D8;
       DB    $FF;
       DB    $CE;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $50;
       DB    $FF;
       DB    $32;
       DB    $00;
       DB    $FF;
       DB    $D8;
       DB    $D8;
       DB    $01;

EnemyShip3_4:
       DB    $00;
       DB    $14;
       DB    $28;
       DB    $FF;
       DB    $CE;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $FF;
       DB    $32;
       DB    $00;
       DB    $FF;
       DB    $D8;
       DB    $28;
       DB    $FF;
       DB    $28;
       DB    $28;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $01;

EnemyShip4VectorTable:
       DW    EnemyShip4_1;
       DW    EnemyShip4_2;
       DW    EnemyShip4_3;
       DW    EnemyShip4_4;

EnemyShip4_1:
       DB    $00;
       DB    $F6;
       DB    $0A;
       DB    $FF;
       DB    $00;
       DB    $EC;
       DB    $FF;
       DB    $14;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $14;
       DB    $FF;
       DB    $EC;
       DB    $00;
       DB    $00;
       DB    $F6;
       DB    $0A;
       DB    $FF;
       DB    $00;
       DB    $D8;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $28;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $01;

EnemyShip4_2:
       DB    $00;
       DB    $EC;
       DB    $EC;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $28;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $D8;
       DB    $00;
       DB    $F6;
       DB    $F6;
       DB    $FF;
       DB    $00;
       DB    $3C;
       DB    $FF;
       DB    $3C;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $C4;
       DB    $FF;
       DB    $C4;
       DB    $00;
       DB    $01;

EnemyShip4_3:
       DB    $00;
       DB    $1E;
       DB    $E2;
       DB    $FF;
       DB    $00;
       DB    $3C;
       DB    $FF;
       DB    $C4;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $C4;
       DB    $FF;
       DB    $3C;
       DB    $00;
       DB    $00;
       DB    $0A;
       DB    $F6;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $50;
       DB    $FF;
       DB    $50;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $01;

EnemyShip4_4:
       DB    $00;
       DB    $28;
       DB    $28;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $FF;
       DB    $50;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $50;
       DB    $00;
       DB    $0A;
       DB    $0A;
       DB    $FF;
       DB    $9C;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $64;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $64;
       DB    $01;

FuelBarrier:            ;* Referenced from where???
       DB    $00;
       DB    $40;
       DB    $40;
       DB    $FF;
       DB    $81;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $7F;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $7F;
       DB    $01;

PlayersShip_1:
       DB    $00;
       DB    $E2;
       DB    $00;
       DB    $FF;
       DB    $32;
       DB    $14;
       DB    $FF;
       DB    $C4;
       DB    $64;
       DB    $FF;
       DB    $0A;
       DB    $88;
       DB    $FF;
       DB    $F6;
       DB    $88;
       DB    $FF;
       DB    $3C;
       DB    $64;
       DB    $FF;
       DB    $CE;
       DB    $14;
       DB    $00;
       DB    $1E;
       DB    $0A;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $01;

PlayersShip_2:
       DB    $00;
       DB    $E2;
       DB    $00;
       DB    $FF;
       DB    $32;
       DB    $14;
       DB    $FF;
       DB    $C4;
       DB    $64;
       DB    $FF;
       DB    $0A;
       DB    $88;
       DB    $FF;
       DB    $F6;
       DB    $88;
       DB    $FF;
       DB    $3C;
       DB    $64;
       DB    $FF;
       DB    $CE;
       DB    $14;
       DB    $00;
       DB    $1E;
       DB    $14;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $01;

PlayersShipExploding_1:
       DB    $00;
       DB    $E2;
       DB    $00;
       DB    $02;
       DB    $14;
       DB    $28;
       DB    $FF;
       DB    $32;
       DB    $14;
       DB    $FF;
       DB    $C4;
       DB    $64;
       DB    $FF;
       DB    $0A;
       DB    $88;
       DB    $02;
       DB    $00;
       DB    $D8;
       DB    $FF;
       DB    $F6;
       DB    $88;
       DB    $FF;
       DB    $3C;
       DB    $64;
       DB    $FF;
       DB    $CE;
       DB    $14;
       DB    $02;
       DB    $D8;
       DB    $28;
       DB    $00;
       DB    $1E;
       DB    $0A;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $02;
       DB    $D8;
       DB    $D8;
       DB    $00;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $01;

PlayersShipExploding_2:
       DB    $00;
       DB    $E2;
       DB    $00;
       DB    $02;
       DB    $14;
       DB    $28;
       DB    $FF;
       DB    $32;
       DB    $14;
       DB    $FF;
       DB    $C4;
       DB    $64;
       DB    $FF;
       DB    $0A;
       DB    $88;
       DB    $02;
       DB    $14;
       DB    $D8;
       DB    $FF;
       DB    $F6;
       DB    $88;
       DB    $FF;
       DB    $3C;
       DB    $64;
       DB    $FF;
       DB    $CE;
       DB    $14;
       DB    $02;
       DB    $D8;
       DB    $28;
       DB    $00;
       DB    $1E;
       DB    $14;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $02;
       DB    $D8;
       DB    $D8;
       DB    $00;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $00;
       DB    $E2;
       DB    $FF;
       DB    $D8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $1E;
       DB    $FF;
       DB    $28;
       DB    $00;
       DB    $01;

UnknownCrossHair:     ; * Referenced from where???
       DB    $00;
       DB    $28;
       DB    $00;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $00;
       DB    $28;
       DB    $28;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $01;

LeftWallFar_LeftEye:
       DB    $00;
       DB    $A0;
       DB    $00;
       DB    $68;
       DB    $8A;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $36;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $CA;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $B6;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $4A;
       DB    $00;
       DB    $FF;
       DB    $68;
       DB    $00;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $B6;
       DB    $00;
       DB    $01;

LeftWallNear_LeftEye:
       DB    $00;
       DB    $A0;
       DB    $00;
       DB    $68;
       DB    $8A;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $36;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $CA;
       DB    $00;
       DB    $01;

RightWallFar_RightEye:
       DB    $00;
       DB    $60;
       DB    $00;
       DB    $68;
       DB    $76;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $CA;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $36;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $4A;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $B6;
       DB    $00;
       DB    $FF;
       DB    $68;
       DB    $00;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $4A;
       DB    $00;
       DB    $01;

RightWallNear_RightEye:
       DB    $00;
       DB    $60;
       DB    $00;
       DB    $68;
       DB    $76;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $CA;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $36;
       DB    $00;
       DB    $01;

RightWallFar_LeftEye:
       DB    $00;
       DB    $A0;
       DB    $00;
       DB    $34;
       DB    $61;
       DB    $01;
       DB    $FF;
       DB    $D0;
       DB    $A6;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $5A;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $6A;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $96;
       DB    $00;
       DB    $FF;
       DB    $68;
       DB    $00;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $6A;
       DB    $00;
       DB    $01;

RightWallNear_LeftEye:
       DB    $00;
       DB    $A0;
       DB    $00;
       DB    $34;
       DB    $61;
       DB    $01;
       DB    $FF;
       DB    $D0;
       DB    $A6;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $5A;
       DB    $00;
       DB    $01;

LeftWallFar_RightEye:
       DB    $00;
       DB    $60;
       DB    $00;
       DB    $34;
       DB    $9F;
       DB    $01;
       DB    $FF;
       DB    $D0;
       DB    $5A;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $A6;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $96;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $6A;
       DB    $00;
       DB    $FF;
       DB    $68;
       DB    $00;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $96;
       DB    $00;
       DB    $01;

LeftWallNear_RightEye:
       DB    $00;
       DB    $60;
       DB    $00;
       DB    $34;
       DB    $9F;
       DB    $01;
       DB    $FF;
       DB    $D0;
       DB    $5A;
       DB    $00;
       DB    $FF;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $A6;
       DB    $00;
       DB    $01;

       DB    $00;
       DB    $60;
       DB    $00;
       DB    $B7;
       DB    $3B;
       DB    $01;
       DB    $FF;
       DB    $42;
       DB    $CA;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $AC;
       DB    $01;
       DB    $FF;
       DB    $BE;
       DB    $A6;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $4E;
       DB    $02;
       DB    $01;

       DB    $00;
       DB    $A0;
       DB    $00;
       DB    $B7;
       DB    $C5;
       DB    $01;
       DB    $FF;
       DB    $42;
       DB    $36;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $54;
       DB    $01;
       DB    $FF;
       DB    $BE;
       DB    $5A;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $B2;
       DB    $02;
       DB    $01;

ExplosionVectorTable:
       DW    ExplosionPattern_1;
       DW    ExplosionPattern_2;
       DW    ExplosionPattern_3;
       DW    ExplosionPattern_4;

ExplosionPattern_1:
       DB    $FF;
       DB    $3C;
       DB    $00;
       DB    $FF;
       DB    $F1;
       DB    $2D;
       DB    $FF;
       DB    $D3;
       DB    $0F;
       DB    $FF;
       DB    $D3;
       DB    $F1;
       DB    $FF;
       DB    $F1;
       DB    $D3;
       DB    $FF;
       DB    $0F;
       DB    $D3;
       DB    $FF;
       DB    $2D;
       DB    $F1;
       DB    $FF;
       DB    $2D;
       DB    $0F;
       DB    $01;

ExplosionPattern_2:
       DB    $FF;
       DB    $64;
       DB    $32;
       DB    $FF;
       DB    $CE;
       DB    $32;
       DB    $FF;
       DB    $9C;
       DB    $00;
       DB    $FF;
       DB    $CE;
       DB    $CE;
       DB    $FF;
       DB    $00;
       DB    $9C;
       DB    $FF;
       DB    $32;
       DB    $CE;
       DB    $FF;
       DB    $64;
       DB    $00;
       DB    $FF;
       DB    $32;
       DB    $32;
       DB    $01;

ExplosionPattern_3:
       DB    $FF;
       DB    $78;
       DB    $00;
       DB    $FF;
       DB    $E2;
       DB    $5A;
       DB    $FF;
       DB    $A6;
       DB    $1E;
       DB    $FF;
       DB    $A6;
       DB    $E2;
       DB    $FF;
       DB    $E2;
       DB    $A6;
       DB    $FF;
       DB    $1E;
       DB    $A6;
       DB    $FF;
       DB    $5A;
       DB    $E2;
       DB    $FF;
       DB    $5A;
       DB    $1E;
       DB    $01;

ExplosionPattern_4:
       DB    $FF;
       DB    $50;
       DB    $28;
       DB    $FF;
       DB    $D8;
       DB    $28;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $FF;
       DB    $D8;
       DB    $D8;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $FF;
       DB    $28;
       DB    $D8;
       DB    $FF;
       DB    $50;
       DB    $00;
       DB    $FF;
       DB    $28;
       DB    $28;
       DB    $01;

WarlordShipBulletVectorTable:
       DW    WarlordShipBullet_1;
       DW    WarlordShipBullet_2;
       DW    WarlordShipBullet_3;
       DW    WarlordShipBullet_4;

WarlordShipBullet_1:
       DB    $00;
       DB    $28;
       DB    $00;
       DB    $FF;
       DB    $B0;
       DB    $00;
       DB    $00;
       DB    $28;
       DB    $28;
       DB    $FF;
       DB    $00;
       DB    $B0;
       DB    $01;

WarlordShipBullet_2:
       DB    $00;
       DB    $3C;
       DB    $3C;
       DB    $FF;
       DB    $88;
       DB    $88;
       DB    $00;
       DB    $00;
       DB    $78;
       DB    $FF;
       DB    $78;
       DB    $88;
       DB    $01;

WarlordShipBullet_3:
       DB    $00;
       DB    $3C;
       DB    $00;
       DB    $FF;
       DB    $88;
       DB    $00;
       DB    $00;
       DB    $3C;
       DB    $3C;
       DB    $FF;
       DB    $00;
       DB    $88;
       DB    $01;

WarlordShipBullet_4:
       DB    $00;
       DB    $28;
       DB    $28;
       DB    $FF;
       DB    $B0;
       DB    $B0;
       DB    $00;
       DB    $00;
       DB    $50;
       DB    $FF;
       DB    $50;
       DB    $B0;
       DB    $01;

*
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

UpdateWarlordShipFrames:
       lda   #$01;
       ldx   #$C984;    * Get addr of frame's scale
       jsr   P06E0;
       ldx   #$C981;    * Get frame addr (Warlord target)
       lda   3,x;        * If the scale factor is >= $50
       cmpa  #$50;      * then force it back to 1.
       blo   P1B91;
       lda   #$01;
       sta   3,x;
P1B91: ldd   0,x;        * Load current position
       jsr   get_absolute_value_of_ab;
       cmpb  #$3F;      * If the x position is now out
       bls   P1BA9;      * bounds ( |x|>$3F ), then we
       ldb   $C87D;      * need to generate a new x
       andb  #$07;      * movement delta.  Force the
       orb   #$02;      * movement value to move the
       tst   1,x;        * ship in the opposite direction.
       ble   P1BA6;
       negb;
P1BA6: stb   $11,x;    * Set new x movement delta
P1BA9: cmpa  #$3F;     * If the y position is now out
       bls   P1BBC;     * bounds ( |y|>$3F ), then we
       lda   $C87E;     * need to generate a new y
       anda  #$07;     * movement delta.  Force the
       ora   #$02;     * movement value to move the
       tst   0,x;       * ship in the opposite direction.
       ble   P1BB9;
       nega;
P1BB9: sta   $13,x;   * Set new y movement delta
P1BBC: lda   $C826;    * Update the position only on
       anda  #$01;    * every other pass.
       beq   P1BCD;
       ldd   0,x;      * Load current position
       adda  $13,x;   * y += y movement delta
       addb  $11,x;   * x += x movement delta
       std   0,x;      * Save new position
P1BCD: lda   3,x;      * Shuffle down the scale factors
       sta   5,x;
       sta   2,x;
       lda   3,x;      * Calculate intensity=scale+$40
       adda  #$40;    * If rollover, use $7F (max)
       bpl   P1BDB;
       lda   #$7F;
P1BDB: sta   8,x;      * Set new intensity
       ldu   #$C9A3;  * Ptr to other warlord frames
P1BE0: lda   7,u;      * Sync all warlord ship frames
       lbge  P1C38;    * with the warlord's main frame
       ldx   #$C981;  * Get frame ptr (Warlord target)
       tst   $1E,x;   * Check for bullet hit only if
       bne   P1C21;    * explosion not already happening.
       jsr   CheckForCollisionWithBullets;
       tsta;
       bne   P1BF5;
       rts;            * No bullets hit the target
P1BF5: lda   $C89B;    * A bullet hit the target
       ora   #$80;
       sta   $C89B;    * Force sound to occur
       lda   #$01;
       sta   $C8A2;    * Set sound characteristics index
       com   $1E,x;   * Tag that explosion is happening
       lda   #$12;
       sta   $1F,x;   * Set explosion duration timer
       ldd   #ExplosionVectorTable;
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
       ldd   #NE_DrawAnimatedDots;
       std   $20,x;   * Set drawing function
       inc   $C8B1;    * Increment hit count on warlord
       ldd   #$0100;  * Award 100 pts to the player
       jsr   CheckForScoreOver20000;
       rts;
P1C21: dec   $1F,x;   * Keep displaying explosion, until
       beq   P1C27;    * duration timer goes to 0.
       rts;
P1C27: clr   $1E,x;   * Redisplay warlord ship target
       ldd   #DrawAnimatedVectorList_Slow;
       std   $20,x;   * Set drawing function
       ldd   #WarlordShipTargetVectorTable;
       std   9,x;      * Set vector list 1
       std   11,x;     * Set vector list 2
       rts;
P1C38: lda   8,x;      * The following block syncs the
       sta   8,u;      * incoming warlord frame info (u)
       lda   3,x;      * with that of the warlord ships
       sta   3,u;      * target frame (x=C981).  This
       lda   5,x;      * includes intensities, scale
       sta   5,u;      * factors and positions.
       ldd   0,x;
       std   0,u;
       lda   2,x;
       sta   2,u;
       leau  $22,u;   * Point to next warlord frame
       jmp   P1BE0;   * Process the next frame

*
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

NE_DrawAnimatedDots:
       lda   $C826;    * Use the system loop counter to
       anda  #$03;    * determine which of the 4 dot
       asla;           * lists to draw.
       ldx   a,x;
       jsr   NE_DrawDots;
       rts;

*
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

InitWarlordShipFrames:
       ldx   #$C981;  * Get ptr to warlord target frame
       ldu   #WarlordShipFrameInfo;
P1C64: ldd   ,u++;     * Process each entry, until $00
       bne   P1C6D;    * encountered.
       lda   #$FF;    * Mark last frame as the end of
       sta   7,x;      * the frame stack.
       rts;
P1C6D: std   $20,x;   * Set drawing function
       ldd   ,u++;
       std   11,x;     * Set vector list 2
       ldd   ,u++;
       std   9,x;      * Set vector list 1
       lda   ,u+;
       sta   7,x;      * Set frame number (i.e. color)
       clr   $1E,x;   * Clear explosion flag
       clr   $1B,x;   * Flag player in enemy passage
       ldd   $C87D;    * Use the system loop counter to
       anda  #$3F;    * generate a random (y,x) position
       andb  #$3F;    * where each coordinate is in the
       tst   $C87D;    * range of +-$3F.
       bmi   P1C8F;    * Determine sign of y value
       nega;
P1C8F: tst   $C87E;
       bmi   P1C95;    * Determine sign of x value
       negb;
P1C95: std   0,x;      * Set initial (y,x) position
       ldd   $C87D;    * Use the system loop counter to
       anda  #$07;    * generate random x and y movement
       ora   #$02;    * delta values, in the range of
       andb  #$07;    * 2 - 7
       orb   #$02;
       sta   $11,x;   * Set x movement delta
       stb   $13,x;   * Set y movement delta
       lda   #$01;
       sta   3,x;      * Set scale factor
       sta   5,x;      * Set embedded obj's scale factor
       sta   2,x;
       lda   3,x;      * Calculate intensity = scale+$40
       adda  #$40;    * If rollover occurs, then simply
       bpl   P1CB8;    * use $7F (max).
       lda   #$7F;
P1CB8: sta   8,x;      * Set intensity
       leax  $22,x;   * Get ptr to next frame
       jmp   P1C64;   * Continue processing

*
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

WarlordShipFrameInfo:
       DW    DrawAnimatedVectorList_Slow;
       DW    WarlordShipTargetVectorTable;
       DW    WarlordShipTargetVectorTable;
       DB    $02;

       DW    DrawVectorList;
       DW    WarlordShipBody;
       DW    WarlordShipBody;
       DB    $01;

       DW    DrawVectorList;
       DW    WarlordShipBody;
       DW    WarlordShipBody;
       DB    $02;

       DW    DrawVectorList;
       DW    WarlordShipTopBottom;
       DW    WarlordShipTopBottom;
       DB    $03;

       DW    DrawAnimatedVectorList_Slow;
       DW    WarlordShipSideFinVectorTable_1;
       DW    WarlordShipSideFinVectorTable_2;
       DB    $01;

       DW    $0000;

*
* ProcessWarlordShipBullet()
*
* This function takes care of processing the warlord ship's
* single bullet frame.  If the bullet is visible, then
* it will update its scale and intensity values, so that
* the bullet appears to be coming at the player.  Once the
* bullet reaches the front of the screen, is will stop
* being displayed; on a later pass, it will attempt to
* fire another bullet.

ProcessWarlordShipBullet:
       lda   #$10;    * See if the warship's bullet frame
       bita  $C966;    * is visible or invisible.
       beq   P1D10;
       lda   $C984;    * Get warship target's scale factor
       cmpa  #$20;
       bls   P1CF4;
       rts;
P1CF4: lda   $C87D;    * Use the system loop counter to
       cmpa  #$E0;    * control how often to fire a new
       bhi   P1CFC;    * warlord ship bullet.
       rts;
P1CFC: lda   #$0F;    * Fire a new warlord ship bullet
       anda  $C966;
       sta   $C966;    * Retag frame as being visible.
       ldd   $C8D7;    * Set warlord's bullet position the
       std   $C95F;    * same as the player's ship.
       lda   $C984;    * Start with same scale factor as
       sta   $C962;    * the warlord's target area.
P1D10: ldx   #$C962;  * Point to bullet's scale factor.
       lda   #$1C;
       jsr   P06E0;
       ldx   #$C95F;  * Point to warlord's bullet frame.
       lda   3,x;      * Get the scale factor.
       cmpa  #$70;    * Once the scale factor is > $70,
       bls   P1D28;    * then the bullet has reached the
       lda   #$10;    * front of the screen, so tag it
       ora   7,x;      * as no longer visible.
       sta   7,x;
       rts;
P1D28: lda   3,x;      * Adjust bullets scale & intensity
       lsra;           * values, so it appears to grow &
       lsra;           * get brighter as it approaches
       lsra;           * the front of the screen
       sta   5,x;
       lda   3,x;
       ldb   #$80;
       mul;
       asla;
       sta   2,x;
       lda   3,x;      * Calculate intensity = scale+$40
       adda  #$40;    * If rollover occurs, then use
       bpl   P1D3F;    * $7F (max).
       lda   #$7F;
P1D3F: sta   8,x;      * Set intensity
       rts;

*
* InitWarlordShipBulletFrame()
*
* This function initializes the frame (C95F) used to
* display the warlord ship's single bullet.

InitWarlordShipBulletFrame:
       ldx   #$C95F;    * Ptr to warlord bullet frame
       lda   #$12;
       sta   7,x;        * Frame #=$12 (green,invisible)
       ldd   #WarlordShipBulletVectorTable;
       std   9,x;        * Set vector list 1
       std   11,x;       * Set vector list 2
       ldd   #DrawAnimatedVectorList_Fast;
       std   $20,x;     * Set drawing function
       clr   $1E,x;     * Clear explosion flag
       rts;

WarlordShipTargetVectorTable:
       DW    WarlordShipTarget_1;
       DW    WarlordShipTarget_2;
       DW    WarlordShipTarget_3;
       DW    WarlordShipTarget_4;

WarlordShipTarget_1:
       DB    $00;
       DB    $10;
       DB    $10;
       DB    $FF;
       DB    $00;
       DB    $E0;
       DB    $FF;
       DB    $E0;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $20;
       DB    $FF;
       DB    $20;
       DB    $00;
       DB    $01;

WarlordShipTarget_2:
       DB    $00;
       DB    $0C;
       DB    $0C;
       DB    $FF;
       DB    $00;
       DB    $E8;
       DB    $FF;
       DB    $E8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $18;
       DB    $FF;
       DB    $18;
       DB    $00;
       DB    $01;

WarlordShipTarget_3:
       DB    $00;
       DB    $08;
       DB    $08;
       DB    $FF;
       DB    $00;
       DB    $F0;
       DB    $FF;
       DB    $F0;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $10;
       DB    $FF;
       DB    $10;
       DB    $00;
       DB    $01;

WarlordShipTarget_4:
       DB    $00;
       DB    $04;
       DB    $04;
       DB    $FF;
       DB    $00;
       DB    $F8;
       DB    $FF;
       DB    $F8;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $08;
       DB    $FF;
       DB    $08;
       DB    $00;
       DB    $01;

WarlordShipBody:
       DB    $00;
       DB    $7F;
       DB    $7F;
       DB    $FF;
       DB    $81;
       DB    $40;
       DB    $FF;
       DB    $81;
       DB    $C0;
       DB    $FF;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $7F;
       DB    $C0;
       DB    $FF;
       DB    $7F;
       DB    $40;
       DB    $FF;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $00;
       DB    $7F;
       DB    $01;

WarlordShipTopBottom:
       DB    $00;
       DB    $7F;
       DB    $C0;
       DB    $FF;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $7F;
       DB    $C0;
       DB    $FF;
       DB    $81;
       DB    $C0;
       DB    $00;
       DB    $80;
       DB    $00;
       DB    $00;
       DB    $80;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $81;
       DB    $C0;
       DB    $FF;
       DB    $7F;
       DB    $C0;
       DB    $01;

WarlordShipSideFinVectorTable_1:
       DW    WarlordShipSideFins_1;
       DW    WarlordShipSideFins_2;
       DW    WarlordShipSideFins_3;
       DW    WarlordShipSideFins_4;

WarlordShipSideFins_1:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $D0;
       DB    $60;
       DB    $FF;
       DB    $60;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $A0;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $D0;
       DB    $A0;
       DB    $FF;
       DB    $60;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $60;
       DB    $01;

WarlordShipSideFins_2:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $DA;
       DB    $5A;
       DB    $FF;
       DB    $4C;
       DB    $0D;
       DB    $FF;
       DB    $DA;
       DB    $9A;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $DA;
       DB    $9A;
       DB    $FF;
       DB    $4C;
       DB    $0D;
       DB    $FF;
       DB    $DA;
       DB    $5A;
       DB    $01;

WarlordShipSideFins_3:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $EA;
       DB    $54;
       DB    $FF;
       DB    $2C;
       DB    $18;
       DB    $FF;
       DB    $EA;
       DB    $94;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $EA;
       DB    $94;
       DB    $FF;
       DB    $2C;
       DB    $18;
       DB    $FF;
       DB    $EA;
       DB    $54;
       DB    $01;

WarlordShipSideFins_4:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $FE;
       DB    $50;
       DB    $FF;
       DB    $05;
       DB    $20;
       DB    $FF;
       DB    $FE;
       DB    $90;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $FE;
       DB    $90;
       DB    $FF;
       DB    $05;
       DB    $20;
       DB    $FF;
       DB    $FE;
       DB    $50;
       DB    $01;

WarlordShipSideFinVectorTable_2:
       DW    WarlordShipSideFin_5;
       DW    WarlordShipSideFin_6;
       DW    WarlordShipSideFin_7;
       DW    WarlordShipSideFin_8;

WarlordShipSideFin_5:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $D0;
       DB    $60;
       DB    $FF;
       DB    $60;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $A0;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $D0;
       DB    $A0;
       DB    $FF;
       DB    $60;
       DB    $00;
       DB    $FF;
       DB    $D0;
       DB    $60;
       DB    $01;

WarlordShipSideFin_6:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $DA;
       DB    $66;
       DB    $FF;
       DB    $4C;
       DB    $F3;
       DB    $FF;
       DB    $DA;
       DB    $A6;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $DA;
       DB    $A6;
       DB    $FF;
       DB    $4C;
       DB    $F3;
       DB    $FF;
       DB    $DA;
       DB    $66;
       DB    $01;

WarlordShipSideFin_7:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $EA;
       DB    $6C;
       DB    $FF;
       DB    $2C;
       DB    $E8;
       DB    $FF;
       DB    $EA;
       DB    $AC;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $EA;
       DB    $AC;
       DB    $FF;
       DB    $2C;
       DB    $E8;
       DB    $FF;
       DB    $EA;
       DB    $6C;
       DB    $01;

WarlordShipSideFin_8:
       DB    $00;
       DB    $00;
       DB    $40;
       DB    $00;
       DB    $00;
       DB    $7F;
       DB    $FF;
       DB    $FE;
       DB    $70;
       DB    $FF;
       DB    $05;
       DB    $E0;
       DB    $FF;
       DB    $FE;
       DB    $B0;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $00;
       DB    $00;
       DB    $81;
       DB    $FF;
       DB    $FE;
       DB    $B0;
       DB    $FF;
       DB    $05;
       DB    $E0;
       DB    $FF;
       DB    $FE;
       DB    $70;
       DB    $01;

* Open space = 1EFA - 1FFF
       DS      $2000 - $1efa
