; BERZERK 4KB ROM
;
; Note assembles 100% correct like it is, but with optimiziation
; it is quite a few bytes shorter... (but doesn't work :-))
;
; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti bios.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
 include "taft.i"

; This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
; Please forward any comments, corrections or additions back to Fred.
;
; Berzerk
;
;;
;
; The following are possible bugs discovered in this code:
;
;    DisplayBonusString
;            When checking to see if the bonus strings should be displayed,
;            the 'ble' command really should be a 'blt'!!  This explains why
;            when a player clears a maze containing 10 robots, the bonus
;            string was not displayed.  In this case the bonus string is
;            "   100", and this fails the above check!
;
;    DisplayLives
;            There is no check to see if the C8D8 buffer is overrun (this
;            is the buffer used to display the number of lives a player has)
;            what is the intended size of this buffer?
;
;    FireBullet
;            There seems to be the potential to overwrite the stack when
;            firing bullets.  The array of bullet entries can grow very
;            quickly as a player gets better, since robots can fire more
;            bullets (and fire them more quickly).  The end of the array
;            only gets moved back when the last bullet hits something and
;            becomes inactive.  It would be better to modify FireBullet()
;            to only allow a certain number of bullets (or to do a better
;            job of compacting the array).
;
;
;
; The following is the memory map for Berzerk RAM usage:
;
; C880-C881     Points to player structure for the current player.
;
; C882          Number of players: 0 = 1 player, 1 = 2 players
;
; C883          Controls maximum number of bullets a robot can fire in a
;               burst  takes a big jump when user's score surpasses 10,000
;               points.
;
; C884          Velocity factor used when firing robot's bullets.
;
; C885          Work memory and loop counter.
;
; C886          Flag  don't draw player if set < 0
;
; C88F-C890     Player's position
;
; C891          Work memory
;
; C892          Work memory
;
; C893-C894     Otto's position (y,x)
;
; C895-C896     Player's position (starting position)  used to seed Otto's
;               initial position.
;
; C897          Counter  controls bouncing offset for Otto's 'y' position
;
; C898          Otto's movement velocity
;
; C899          After a point is mapped into a quadrant number, this contains
;               the bitmask describing which walls are present in that
;               quadrant:
;
;                      ---------------------------------
;                      | 0 | 0 | 0 | 0 | B | T | R | L |
;                      ---------------------------------
;           Quadrant has Bottom Wall-----^
;           Quadrant has Top Wall------------^
;           Quadrant has Right Wall--------------^
;           Quadrant has Left Wall-------------------^
;
; C89A          Quadrant into which a point falls:
;
;                   -100 -60 -20 +20 +60 +100
;                     +---+---+---+---+---+ +96
;                     | 0 | 1 | 2 | 3 | 4 |
;                     +---o---o---o---o---+ +32
;                     | 5 | 6 | 7 | 8 | 9 |
;                     +---o---o---o---o---+ -32
;                     |10 |11 |12 |13 |14 |
;                     +---+---+---+---+---+ -96
;
; C89B-C89C     After a point is mapped into a quadrant number, this contains
;               the point as a relative offset from the lower left corner
;               of the quadrant.
;
; C89D          Work memory/counter
;
; C89E-C89F     During game, work memory  usually contains a position (y,x).
;               After a game, C89F is a semaphore causing author's initials
;               to be displayed also used as a counter
;
; C8A1          Work memory and loop counter.
;
; C8A2          Work memory and loop counter.
;
; C8A7          Delay (placed in the robot's structure) between how often
;               a robot is updated (moved, fire, etc)  0 = no delay.
;
; C8A8          Used while populating a level with robots  if the random
;               number is < C8A8, then a robot is placed in the maze.
;
; C8A9          Used during robot processing.
;
; C8AA          Used during robot processing.
;
; C8AB-C8B2     Array of byte-long offsets, telling which walls are to be
;               drawn from each of the 8 possible starting points within
;               the maze (0=up, 2=down, 4=to right, 6=to left).  The 8
;               possible starting points are shown below:
;
;                   -100 -60 -20 +20 +60 +100
;                     +---+---+---+---+---+ +96
;                     |                   |
;                     +   o   o   o   o   + +32
;                     |                   |
;                     +   o   o   o   o   + -32
;                     |                   |
;                     +---+---+---+---+---+ -96
;
; C8B5-C8C3     Array of masks (1 per quadrant) indicating which walls are
;               present in the quadrant.  The mask values are:
;
;                     $01 = left wall
;                     $02 = right wall
;                     $04 = top wall
;                     $08 = bottom wall
;
;               C8B5 refers to quadrant 0, C8B6 to quadrant 1, etc.
;
; C8C5          Jump table index based on the player's current state:
;
;                     0 = player is alive
;                     2 = player has left the maze
;                     4 = player has died
;
; C8C6          Indicates if one of the maze doors should be closed off:
;
;                       ---------------------------------
;                       | 0 | 0 | 0 | T | B | L | R | 0 |
;                       ---------------------------------
;                     Block Top Door--^
;                     Block Bottom Door---^
;                     Block Left Door---------^
;                     Block Right Door------------^
;
; C8C7          Number of robots initially seeded into the maze
;
; C8C8          Number of robots still alive
;
; C8C9-C8CA     Indirect jump pointer
;
; C8CB          Intensity value used by DrawWithPossibleScrolling()
;
; C8CC          Index of the last bullet in use
;
; C8CD          Cleared in one place, then never again used.
;
; C8CE          Indicates state of player's legs:
;
;                     0 = player is standing still
;                     2 = player is running right (wide legs)
;                     4 = player is running right (close legs)
;                     6 = player is running left (close legs)
;                     8 = player is running left (wide legs)
;
; C8CF          Indicates the state of the player's arms:
;
;                  When player is running:
;                     $00 = arms moving to the right
;                     $02 = arms moving to the left
;
;                  When player is standing still:
;                     $00 = arms neutral
;                     $02 = arms shooting left
;                     $04 = arms shooting right
;                     $06 = arms shooting up
;                     $08 = arms shooting 45 degrees upper left
;                     $0A = arms shooting 45 degrees upper right
;                     $0C = arms shooting down
;                     $0E = arms shooting 45 degrees lower left
;                     $10 = arms shooting 45 degrees lower right
;
; C8D0          Intensity used when drawing a 'fried' player
;
; C8D1-C8D7     Bonus score string buffer
;
; C8D8-????     Buffer used when displaying number of lives a player has.
;
; C8DE          'y' delta between 2 points, as determined by
;               DetermineDirectionToMove()
;
; C8DF          'x' delta between 2 points, as determined by
;               DetermineDirectionToMove()
;
; C8E0          Used during scrolling  used to calculate 'y' delta
;
; C8E1          Used during scrolling  used to calculate 'x' delta
;
; C8E2-C8E3     Used during scrolling  delta added to 'y' drawing point
;
; C8E4-C8E5     Used during scrolling  delta added to 'x' drawing point
;
; C8E6          Used during scrolling  0 if scrolling in a + direction (right
;               or up), $80 if scrolling in a - direction (down or left)
;
; C8E7-C8E8     Work memory (used by DetermineDirectionToMove)
;
; C8E9          Loop counter
;
; C8EA          Mask showing joystick position and fire button state:
;
;                       ---------------------------------
;                       | 0 | 0 | B | L | D | U | R | L |
;                       ---------------------------------
;                 Button Pressed--^
;                 Joystick Left-------^---------------^
;                 Joystick Down-----------^
;                 Joystick Up-----------------^
;                 Joystick Right------------------^
;
; C8EB          Direction current object is traveling (work memory):
;
;                       ---------------------------------
;                       | 0 | 0 | 0 | L | D | U | R | L |
;                       ---------------------------------
;                 Joystick Left-------^---------------^
;                 Joystick Down-----------^
;                 Joystick Up-----------------^
;                 Joystick Right------------------^
;
; C900-C90D     Player 1 structure
; C90E-C91B     Player 2 structure
;
;               byte    meaning
;               ----    -------
;               0-6     player's score
;               7       unused
;               8       number of lives
;               9       Flag specifying if 5000 point bonus was given
;               10      player's y position
;               11      player's x position
;               12-13   unused
;
; C91C-C973     Array of robot structures (11 entries)
;
;               byte    meaning
;               ----    -------
;               0       robot's y position.
;               1       robot's x position.
;               2       flag: $80 = alive, 0 = gone, $0F = just killed
;               3       direction of travel(0-10)  indexes into extremities tbl
;               4       Eye box to draw (0, 2, 4, 6)
;               5       Delay before robot starts shooting (0-7)
;               6       # of bullets robot can fire in a burst
;               7       Delay between processing a robot (moving, firing, etc)
;
; C974-????     Array of bullet structures
;
;               byte    meaning
;               ----    -------
;               0       y position of bullet's tail
;               1       x position of bullet's tail
;               2       y delta between bullet's head and tail
;               3       x delta between bullet's head and tail
;               4       y position of bullet's head
;               5       x position of bullet's head
;               6       velocity factor
;               7       direction of travel  anded w/ $F0 when hits something
;
;


       ORG $0000
       DB    "g GCE 1982",$80

       DW    berzerk_music_block

       DB    $F8 ; height
       DB    $50 ; width
       DB    $20 ; rel y
       DB    $D0 ; rel x
       DB    "BERZERK",$80,$00


; Get the number of players: 1 or 2.
; C882 will be set to 0 for 1 player, and 1 for 2 players.

       direct  $C8             ; pretty for optimizing to use a makro :-)
start: ldd   #$0200
       jsr   get_players_game
       lda   $C879
       asra
       sta   $C882


; Disable 2 of the 4 joystick mask registers  the other
; 2 are enabled automatically by the ExecRom.

       clr   $C821
       clr   $C822
       jsr   init_music_buf
       clr   $C867


; Initialize the 2 player's structures.
; Player 1 is C900-C90D, player 2 is C90E-C91B.
; The player's scores will be initialized, their
; number of lives set (3), and their initial positions
; set.

RestartBerzerk:
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       clr   $C89D
       inc   $C89D
       ldx   #$C900
       stx   $C880
P003A: lda   #$03
       sta   8,x             ; Set number of lives
       clr   9,x             ; Clear 'bonus given' flag
P0040: jsr   set_dft_score  ; Set default score
       ldx   #$C90E
       dec   $C89D
       bpl   P003A
       ldx   #$C900
       ldd   #$00A5
       std   10,x            ; Set starting position
       ldx   #$C90E
       ldd   #$005B
       std   10,x            ; Set starting position

;  Set initial robot attributes
       lda   #$A0
       sta   $C8A8            ; Robot seeding threshold
       lda   #$06
P0060: sta   $C8A7            ; Set robot processing delay
       lda   #$01           ; Start robot bullets with
       sta   $C884            ; a low velocity factor


; This block takes care of setting up for the next turn,
; after a player has died.  It determines how the maze
; will look, displays the maze, the scores and the number
; of lives, and then does some music mucking.

StartNewTurn:
       lda   #$3F         ; Set loop counter
       sta   $C885
       ldx   #$C8C5       ; Initialize game RAM
       ldb   #$26
       jsr   clear_blockxb
       jsr   DetermineMazeWalls
       ldx   #$C8D1       ; Initialize the bonus string
       jsr   set_dft_score
       ldx   $C880          ; Save the player's position
       ldd   10,x
       std   $C88F
       lda   8,x           ; Display # of lives left
       jsr   DisplayLives


; Display the maze, but not the player or the robots,
; and do some sound mucking  loop here for a while,
; before proceeding.

LoopWhileDisplayingMaze:
       clr   $C886
       jsr   DoUnknownSoundMucking
       jsr   init_sound
       lda   $C826
       bita  #$10
       bne   P0096
       dec   $C886
P0096: jsr   waitrecal
       direct  $D0             ; pretty for optimizing to use a makro :-)
       jsr   DrawMaze
       jsr   do_sound
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       dec   $C885
       bne   LoopWhileDisplayingMaze


; Remove one of the player's lives, to take into account
; the life he is using now.

       ldx   $C880       ; Points to active player struct
       dec   8,x
       jsr   init_music_buf
       bra   P00B5

EnterNextMaze:
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       jsr   DetermineMazeWalls

P00B5: lda   #$2A
       sta   $C886
       ldu   $C880
       ldd   10,u
       std   $C88F      ; Save the player's position
       std   $C895
       ldx   #$C8E0
       ldb   #$05
       jsr   clear_blockxb
       clr   $C883
       dec   $C883


; Based on the player's score, set the level of difficulty.
; If the score >= 10,000, then bump the difficulty by alot.
; After that, compare the 'thousands' portion of the score
; against the cutoff values in the table, and further bump
; for each cutoff value surpassed.

       lda   1,u      ; Check if score >= 10,000
       cmpa  #$20
       beq   P00D7
       lda   #$06    ; It is, so increase difficulty
       sta   $C883
P00D7: ldd   2,u      ; Check the cutoff values
       ldx   #SkillLevelCutoffs
P00DC: inc   $C883
       tst   ,x
       bmi   P00E7
       cmpd  ,x++
       bge   P00DC


; Initialize the bonus score string.

P00E7: ldx   #$C8D1
       jsr   set_dft_score


; Do some processing based on the difficulty value calculated
; earlier (set the robot's bullet velocity and the robot
; processing delay).  Lastly, clear out the bullet structure.

       lda   $C883         ; Max # of robot bullets
       cmpa  #$06
       blt   P00F5
       inc   $C884         ; Robot bullet velocity factor
P00F5: asra
       suba  #$06
       nega
       bpl   P00FC
       clra
P00FC: sta   $C8A7         ; Robot processing delay
       ldx   #$C974      ; Init the bullet structure
       jsr   clear_256_bytes


; This seeds the robot structure array.  It attempts to
; 'activate' a random number of robots.  If it fails to
; seed any robots, then it tries over again.
; The robot array is an array of structures, located
; at C91C-C973  there are 11 entries, each 8 bytes long.
; C8C7 keeps track of the number of robots initially
; seeded  C8C8 keeps track of the number of robots still
; alive.  A robot is seeded only if the generated random
; number is less than a pre-calculated threshold value.

P0104: clr   $C8C7
       ldb   #$0B
       ldx   #RobotStartingPositionTable
       ldu   #$C91C
P010E: jsr   get_random_a
       cmpa  $C8A8          ; Should we seed this robot?
       bhi   P014C
       inc   $C8C7          ; Bump the robot count
       lda   #$80
       sta   2,u           ; Flag the robot as alive
       jsr   get_random_a
       anda  #$1F
P0120: sta   $C89D
       suba  #$10
       adda  ,x
       sta   ,u            ; Set the y starting position
       jsr   get_random_a
       anda  #$0F
       suba  #$08
       adda  1,x
       sta   1,u           ; Set the x starting position
       clr   3,u
       clr   4,u
       jsr   get_random_a
       anda  #$07
       sta   5,u
       lda   $C883
       cmpa  #$06
       blt   P0146
       suba  #$06
P0146: sta   6,u
       clr   7,u
       leau  8,u           ; Change ptr to the next robot
P014C: leax  2,x
       decb
       bne   P010E
       lda   $C8C7
       beq   P0104
       sta   $C8C8

;  Set value used during robot seeding
       tfr   u,d
       subd  #$C924
       stb   $C8AA

;  Initialize Otto information
       ldd   $C895
       std   $C891         ; Set Otto's initial position
       std   $C893         ; Set Otto's initial position
       lda   #$05
       sta   $C830
       lda   #$20
       sta   $C897         ; Set Otto's sound loop counter
       lda   #$01
       sta   $C898         ; Set Otto's initial velocity

;  Set up some counters
       lda   $C8C7
       ldb   #$50
       mul
       tsta
       bne   P017B
       lda   #$02
       clrb
P017B: std   $C82E

;  Main processing loop
       clr   $C8C5  ; Set jump idx to 'player is alive'
P017F: jsr   waitrecal
       direct  $D0             ; pretty for optimizing to use a makro :-)
       jsr   read_jstick
       jsr   read_switches2
       jsr   do_sound
       jsr   DrawMaze
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       ldx   #MainJumpTable
       lda   $C8C5
       jmp   [a,x]    ; (UNKNOWN JUMP)

MainJumpTable:
       DW    PlayerIsAlive
       DW    PlayerHasLeftMaze
       DW    PlayerHasDied

MakeSoundThenGotoMainLoop:
       tst   $C856
       beq   P01A4
       clr   $C867
P01A4: jsr   init_sound
       jsr   DoUnknownSoundMucking
       ldx   $C82E
       beq   P01B0
       leax  -1,x
P01B0: stx   $C82E
       bra   P017F


; This is one of the 'indirect jump' functions.  It is the
; active jump function while the player is alive.  It uses
; the state of the buttons and the joystick to decide how
; to draw the player.  It also attempts to detect whenever
; the player leaves a quadrant, to determine if the player
; has left the maze, or run into a wall.
PlayerIsAlive:
       ldx   #$C88F
       lda   $C8E9
       beq   ProcessJoystickAndButtons
       dec   $C8E9
       bra   DoNotUpdatePlayerMovement


; Based on the joystick and button values, the 'b' register
; is set to the following mask:
;
;         ---------------------------------
;         | 0 | 0 | B | L | D | U | R | L |
;         ---------------------------------
;   Button Pressed--^
;   Joystick Left-------^---------------^
;   Joystick Down-----------^
;   Joystick Up-----------------^
;   Joystick Right------------------^

ProcessJoystickAndButtons:
       clrb
       lda   $C81C    ; Get joystick up/down setting
       bpl   P01C8   ; 0=u/d neutral, -=down, +=up
       addb  #$08   ; Down
       bra   P01CC
P01C8: beq   P01CC
       addb  #$04   ; Up
P01CC: lda   $C81B    ; Get joystick left/right setting
       bpl   P01D4   ; 0=l/r neutral, -=left, +=right)
       addb  #$11   ; Left
       bra   P01D8
P01D4: beq   P01D8
       addb  #$02   ; Right
P01D8: lda   $C80F    ; Load button states
       beq   NoBtnsPressed
       orb   #$20   ; Button pressed, but if joystick is
       bitb  #$0F   ; neutral, then do nothing.
       beq   DoNotUpdatePlayerMovement


; The joystick is not in the neutral position, and a button
; is pressed, so the player is firing.

       stb   $C8EA    ; Save the joystick/button mask
       lda   #$08
       sta   $C8E9
       andb  #$0F
       stb   $C8EB    ; Save just the joystick mask
       lda   #$06
       jsr   CalculateUpdatedPosition
       std   $C89E
       ldx   #$C89E
       ldb   #$03
       jsr   FireBullet
       lda   #$01
       ora   $C867
       sta   $C867
       bra   DoNotUpdatePlayerMovement

NoBtnsPressed:
       stb   $C8EA   ; Save the joystick/button mask
       lda   $C826
       bita  #$02
       bne   DoNotUpdatePlayerMovement
       lda   #$01
       jsr   CalculateUpdatedPosition
       std   ,x


; If none of the buttons are pressed, and if the joystick
; is in neutral, then reset the players arms and legs to
; the 'neutral' position.

DoNotUpdatePlayerMovement:
       lda   $C8EA
       bne   CheckIfFiring
       clr   $C8CE
       clr   $C8CF
       bra   CheckForPlayerLeavingQuadrant


; If a button was pressed, then we know the player was
; firing, so we can force his legs to the neutral position,
; and can set his arms to be shooting in the appropriate
; direction.

CheckIfFiring:
       bita  #$20
       beq   NotFiringButMoving
       clr   $C8CE   ; Force player to stand still
       ldu   #ArmsShootingIndicesTable
       anda  #$0F
       ldb   a,u
       stb   $C8CF   ; Set player's arms accordingly
       bra   CheckForPlayerLeavingQuadrant


; We know that the player is on the move.  We will therefore
; make his arms swing left and right, and we will draw his
; legs so it appears he is running in the desired direction.
; The timing for changing the arms and legs is controlled by
; bit $08 of C826, which is a counter controlled by the
; Exec Rom.
;
; For the arms:
;
;        0 = 'arms to the right'
;        2 = 'arms to the left'
;
; For the legs:
;
;        2 = 'running right with wide legs'
;        4 = 'running right with close legs'
;        6 = 'running left with wide legs'
;        8 = 'running left with close legs'

NotFiringButMoving:
       anda  #$10   ; a = joystick/button mask
       pshs  a
       lda   $C826
       anda  #$08
       tfr   a,b     ; Get a value of 0 or 2, to control
       asrb          ; which arms get drawn.
       asrb
       stb   $C8CF
       ora   ,s+     ; Get a value of 2, 4, 6 or 8, to
       asra          ; control which legs get drawn.
       asra
       adda  #$02
       sta   $C8CE


; Take the player's position, and map it into:
;
;   1) the quadrant the player is in (C89A),
;   2) the relative position within that quadrant (C89B-C89C)
;   3) the bitmask indicating which walls are present for
;      the quadrant (C899).
;
; If it is determined that there was contact with a wall,
; then do some special checks to see if the wall was really
; a door  if it was a door, and the door was not blocked off,
; then exit to the next maze.

CheckForPlayerLeavingQuadrant:
       ldd   $C88F
       jsr   _MapPointT___
       ldx   #PlayerThresholds
       jsr   CheckForQuadrantEdgeCrossing
       bitb  $C899
       beq   NoContactWithWalls

; Check for passing out the top door
       lda   $C89A
       cmpa  #$02   ; If quad 2, check for up door
       bne   P0264
       lda   $C8C6    ; Check if door is blocked
       bita  #$10
       bne   PlayerHitWall
       andb  #$04   ; Top wall (door) passed thru?
       beq   PlayerHitWall
       bra   ExitMaze

;  Check for passing out the left door
P0264: cmpa  #$05   ; If quad 5, check for left door
       bne   P0274
       lda   $C8C6
       bita  #$04   ; Check if door is blocked
       bne   PlayerHitWall
       andb  #$01   ; Left wall (door) passed thru ?
       beq   PlayerHitWall
       bra   ExitMaze

;  Check for passing out the right door
P0274: cmpa  #$09   ; If quad 9, check for right door
       bne   P0284
       lda   $C8C6
       bita  #$02   ; Check if door is blocked
       bne   PlayerHitWall
       andb  #$02   ; Right wall (door) passed thru ?
       beq   PlayerHitWall
       bra   ExitMaze

;  Check for passing out the bottom door
P0284: cmpa  #$0C   ; If quad 12, check for bottom door
       bne   PlayerHitWall
       lda   $C8C6
       bita  #$08   ; Check if door is blocked
       bne   PlayerHitWall
       andb  #$08   ; Bottom wall (door) passed thru ?
       beq   PlayerHitWall


; The player has successfully exited from the maze  change
; the jump index so that the code is called which scrolls
; the maze off the display.

ExitMaze:
       stb   $C8EA
       ldb   #$02
       stb   $C8C5
       jmp   MakeSoundThenGotoMainLoop


; The player died by walking into a wall  change the
; jump index so that the code which shows the player being
; fried, is called.

PlayerHitWall:
       lda   #$08
       ora   $C867
       sta   $C867
       ldb   #$04
       stb   $C8C5
       jmp   MakeSoundThenGotoMainLoop


; The player did not make contact with any walls, so all
; is well.  Starting at the end of the bullet array, work
; back until we find an active bullet, then update the
; bullet counter in C8CC.

NoContactWithWalls:
       jsr   ProcessAndUpdateBullets
       jsr   ProcessAndUpdateRobots
       ldb   $C8CC
       beq   CheckForExtraLifeBonus
       decb
       lda   #$08
       mul
       ldx   #$C974  ; Start at the end of the bullet
       abx            ; array.
P02BA: lda   7,x
       bita  #$0F
       bne   CheckForExtraLifeBonus
       bita  #$80
       beq   P02C4
P02C4: dec   $C8CC
       beq   CheckForExtraLifeBonus
       leax  -8,x
       bra   P02BA


; Display the number lives the player has, and then check
; to see if the player has earned an extra life (awarded
; for each 5000 points)  if so, then award the extra life,
; and play a little tune.  The bonus check happens by
; comparing the thousands digit of the score to ascii '5'.

CheckForExtraLifeBonus:
       ldx   $C880
       lda   8,x
       bsr   DisplayLives
       tst   9,x      ; Semaphore  only do once
       bne   CheckForClearedLevelBonus
       lda   #$35 ; "5"
       cmpa  2,x
       bgt   CheckForClearedLevelBonus
       inc   8,x      ; Award the extra life
       inc   9,x      ; Set the semaphore
       ldu   #$FF44  ; Play a tune
       jsr   init_sound2


; Check to see if the player has cleared out all of
; the robots  if so, then award a bonus, and display
; the bonus string.  Some fancy manipulation is done
; to convert the integer into a BCD string value.

CheckForClearedLevelBonus:
       tst   $C8C8    ; Any robots left?
       bne   P0312
       lda   #$02   ; All robots have been cleared out
       bita  $C898
       bne   P0312
       inc   $C898    ; Increment Otto's velocity
       clra
       ldb   $C8C7    ; Get the starting count of robots
       cmpb  #$0A
       blt   P02FD
       subb  #$0A   ; Handle counts >= 10 specially
       orb   #$10
P02FD: aslb          ; Convert to BCD string value
       rola
       aslb
P0300: rola
       aslb
       rola
       aslb
       rola
       pshs  a,b     ; Add bonus to player's score
       jsr   add_d_to_x_in_bcd
       puls  a,b
       ldx   #$C8D1  ; Place value into the bonus string
       jsr   add_d_to_x_in_bcd
P0312: jmp   MakeSoundThenGotoMainLoop


; DisplayLives()
;
; Entry:
;   a = number of lives
;
; Displays a string of 'little men', one for each live
; the user has.  The buffer into which the string is
; placed starts at C8D8.
;
;  BUG ALERT: there is no check to see if the C8D8 buffer
;             is overrun  what is the intended size of this
;             buffer?

DisplayLives:
       clrb
       ldu   #$C8D8     ; String buffer
       sta   $C89D
       beq   P0326
       lda   #$69       ; 'little man' icon
P031F: sta   b,u
       incb
       cmpb  $C89D
       blt   P031F
P0326: lda   #$20
       sta   b,u         ; Terminate string with 2 spaces
       incb              ; and $80.
       sta   b,u
       incb
       lda   #$80
       sta   b,u
       rts


; FireBullet()
;
; This function attempts to fire a bullet from the indicated
; position, using the specified velocity.  However, if the
; bullet would immediately hit a wall, then it is not fired.
;
; Entry:
;    b = bullet's velocity factor (a value indicating how
;        often the bullet's position is updated for each
;        pass).
;    x = Bullet's starting position.
;    C8EB = direction of travel for the bullet.

FireBullet:
       stb   $C89D
       pshs  x,u
       ldd   ,x
       jsr   _MapPointT___
       ldx   #BulletThresholds
       jsr   CheckForQuadrantEdgeCrossing
       puls  x        ; Don't fire if bullet will
       bitb  $C899     ; immediately hit a wall.
       bne   P0369
       ldb   $C8CC     ; Point to the next available bullet
       lda   #$08
       mul
       ldu   #$C974
       leau  b,u
       lda   $C8EB
       sta   7,u      ; Store bullet's direction
       lda   $C89D
       sta   6,u      ; Store velocity factor
       ldd   ,x
       std   ,u       ; Set bullet's tail position
       ldb   $C8EB
       lda   #$02
       jsr   CalculateUpdatedPosition
       std   4,u      ; Set bullet's head position
       inc   $C8CC     ; Increment the bullet count
P0369: puls  u,pc


; This is one of the 'indirect jump' functions.  It is the
; active jump function when the player gets killed.  It
; will cause the player to be drawn with a variety of
; intensities (simulating electrocution), and will update
; the current high score, if necessary.  It then resets
; the starting positions for the players, and tries to
; determine whose turn it is next.  If there are two
; players, then it tries to switch to the other player,
; unless that player has 0 lives left  in that case, it
; will stick with the current player, unless he, too, has
; 0 lives left, at which point the game ends, and it
; waits for either the user to press a button to restart
; the game, or a timeout to elapse (to cold start the
; system).

PlayerHasDied:
       clr   $C8EA
       clr   $C8CD
       jsr   ProcessAndUpdateRobots
       jsr   ProcessAndUpdateBullets
       lda   $C886
       anda  #$0F
       ldu   #PlayerFriedIntensities
       ldb   a,u
       stb   $C8D0    ; Save off next intensity value
       dec   $C886
       lbpl  MakeSoundThenGotoMainLoop
       lda   #$A0
       sta   $C8A8
       ldx   $C880    ; Check for new high score
       ldu   #$CBEB
       jsr   check_4_new_hi_score

;  Loop, doing some music mucking
       lda   #$50
       sta   $C885
       clr   $C886
       dec   $C886
P039A: jsr   CheckForOttoStart
       jsr   DoUnknownSoundMucking
       jsr   waitrecal
       direct  $D0             ; pretty for optimizing to use a makro :-)
       jsr   DrawMaze
       jsr   do_sound
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       dec   $C885
       bne   P039A

; Reset player's starting positions
       ldx   #$C900   ; Player 1
       ldd   #$00A5
       std   10,x
       ldx   #$C90E   ; Player 2
       ldd   #$005B
       std   10,x

; Determine whose turn it is
       clr   $C8C6    ; Start with no door blocked
       tst   $C882    ; Two player game?
       beq   P03D9
       ldx   #$C900 ; Yes
       tst   $C881    ; Is player 2 the active player?
       bne   P03D0
       ldx   #$C90E ; No, so change to player 2
P03D0: tst   8,x     ; Does this player have any lives?
       beq   P03D9
       stx   $C880    ; Yep  so let this player play
       jmp   StartNewTurn
P03D9: ldx   $C880    ; Nope  so see if original player
       tst   8,x     ; had any lives left.
       lbne  StartNewTurn

;  The game is over  loop waiting for next game
       clr   $C89F      ; Clear the Easter Egg semaphore
       ldx   #$0C00   ; How long to wait for restart

LoopWaitingForRestart:
       stx   $C89D
       jsr   DoUnknownSoundMucking
       jsr   waitrecal
       direct  $D0             ; pretty for optimizing to use a makro :-)
       jsr   intensity_to_5F
       jsr   do_sound
       tst   $C89F
       beq   DisplayHighScore

;  Display the Easter Egg
       ldu   #AuthorsInitials
       jsr   print_1_string


; Display the current high score, along with the scores
; for players 1 and 2.

DisplayHighScore:
       ldu   #HighScoreString
       jsr   print_1_string
       ldu   #$CBEB          ; height & width
       ldd   #$60E0          ; rel y & rel x
       jsr   print_at_d
       jsr   DisplayBothPlayersScore


; Display "Got You Humanoid" 4 times.

       ldy   #HumanoidStringPositions
       ldd   ,y++
       std   $C82A
       ldd   ,y++
       ldu   #HumanoidString
       pshs  u
       jsr   print_at_d
       puls  u
       ldd   ,y++
       jsr   print_at_d
       pshs  u
       ldd   ,y++
       jsr   print_at_d
       ldd   ,y++
       puls  u
       jsr   print_at_d


; If only buttons 1, 3 and 4 are pressed, toggle the
; flag (C89F) which will cause the author's initials
; to be displayed (Easter Egg).  Otherwise, if any buttons
; are pressed, then restart the game.  If no buttons are
; pressed, then eventually (after a predetermined
; amount of time), jump back to the start of the
; Exec Rom.  Note that if the Easter Egg gets enabled,
; then pressing buttons will not restart a new game
; you must wait for the timeout to expire.

       jsr   read_switches2
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       tst   $C89F          ; Bypass if Easter Egg active
       bne   P0453
       lda   $C80F          ; Button states
       eora  #$0D         ; Mask for buttons 1, 3 and 4
       bne   P044D
       inc   $C89F          ; Turn on the Easter egg
       bra   P0453
P044D: lda   $C80F          ; Button states
       lbne  RestartBerzerk
P0453: ldx   $C89D          ; Decrement timer
       leax  -1,x
       bne   LoopWaitingForRestart
       jmp   start_of_OS_ROM

HumanoidString:
       DB    "GOT YOU",$FF,"HUMANOID",$FF

HighScoreString:
       DB    $F8 ; height
       DB    $38 ; width
       DB    $70 ; rel y
       DB    $D8 ; rel x
       DB    "HIGH SCORE "

HumanoidStringPositions:
       DB    $F2 ; rel y
       DB    $4A ; rel x
       DB    $22 ; rel y
       DB    $D8 ; rel x
       DB    $20 ; rel y
       DB    $D8 ; rel x
       DB    $00 ; rel y
       DB    $CF ; rel x
       DB    $FE ; rel y
       DB    $CF ; rel x


; Draw the outer and inner maze walls, and if necessary,
; block off one of the maze doors.

DrawMaze:
       NOOPT
       inc   $C824
       jsr   intensity_to_5F
       ldx   #draw_VL_with_count1
       stx   $C8C9        ; Indirect jump pointer
       lda   #$7F
       sta   $C8CB        ; Drawing intensity
;  Draw 4 sets of vectors making up outer maze walls
       ldb   #$04
       stb   -15,s        ; Loop counter
       ldu   #OutsideMazeWallData
P049E: lda   #$01        ; Vector count - 1
       sta   $C823
       ldx   2,u          ; Pointer to vector table
       jsr   DrawWithPossibleScrolling
       leau  4,u          ; Process to next wall
       dec   -15,s
       bne   P049E

;  Draw the 8 inner walls
       clr   $C823
       lda   #$08
       sta   -15,s        ; Loop counter
       ldy   #$C8AB      ; Array of wall indicies
       ldu   #InnerWallPositionTable
P04BC: ldb   ,y+
       ldx   #InnerWallVectorTable
       abx
       jsr   DrawWithPossibleScrolling
       leau  2,u          ; Process next segment
       dec   -15,s
       bne   P04BC

;  Block off one door, if signaled to do so
       ldu   #BlockedDoorVectorTable
       lda   $C8C6        ; Door to block, if any
       beq   DisplayBonusString
       ldu   a,u
       leax  2,u
       clra
       jsr   DrawWithPossibleScrolling


; If the player killed all of the robots, then display
; a message telling them they got a bonus.  We can tell
; if we need to display the bonus string, by checking to
; to see if the second digit in the bonus string is not '0'
; ("    x0" is the default, where 'x' is initially set to
; a space, but will be a digit when the bonus string has
; been assigned a value).
;
; BUG ALERT: when the above check occurs, the 'ble' command
;            really should be a 'blt'!!  This explains why
;            when a player clears a maze containing 10
;            robots, the bonus string was not displayed.
;            In this case the bonus string is "   100",
;            and this fails the above check!

DisplayBonusString:
       ldd   #$F838
       std   $C82A          ; Set height & width
       lda   $C8D5
       cmpa  #$30
       ble   DrawActivePieces
       ldu   #BonusString
       jsr   print_with_dft_hw
       ldd   #$70F0        ; rel y & rel x
       ldu   #$C8D1        ; Bonus score buffer
       jsr   print_at_d


; Display both player's scores, and depending upon the
; active player, display the number of lives for that
; player.

DrawActivePieces:
       jsr   DisplayBothPlayersScore
       ldd   #$F820        ; Set height & width
       std   $C82A
       ldu   #$C8D8        ; Display # of lives
       tst   $C881
       beq   P0510
       ldd   #$9840        ; Player 2 rel y & rel x
       jsr   print_at_d
       bra   DrawActiveBullets
P0510: ldd   #$98A0        ; Player 1 rel y & rel x
       jsr   print_at_d

;  Draw all active bullets
DrawActiveBullets:
       ldu   #$C974        ; Bullet array
       lda   $C8CC          ; Bullet count
P051C: beq   DrawAliveRobots
       sta   -15,s
       ldb   7,u
       andb  #$0F
       beq   P052B
       leax  2,u            ; Ptr to vector list
       jsr   DrawWithPossibleScrolling
P052B: leau  8,u
       lda   -15,s
       deca
       bra   P051C


; Draw All robots.  When drawing the robot, it is drawn
; in two halves  first the right half, and then the left
; half.  When each half is drawn, that half of the body
; outline is drawn, and then the extremities are drawn
; (legs and feet).  The extremities are dependent upon
; whether the robot is moving or standing still (searching
; for the player).  The last thing drawn is the robot's
; eye box  this, too, is dependent upon whether the robot
; moving or standing still.  When moving, the eye box is
; aimed in the direction of movement (exception is down,
; in which case no eye box is displayed).  When the robot
; is searching for the player, the eye box will shuffle
; through all of the available positions.

DrawAliveRobots:
       lda   $C8C7         ; Number of robots
       lbeq  DrawThePlayer
       sta   -15,s
       ldu   #$C91C       ; Robot structure
P053E: tst   7,u
       beq   P0544
       dec   7,u
P0544: lda   2,u
       lbeq  P05BE
       bpl   DrawRobotDisappearing
       clr   $C824
       lda   #$04
       sta   $C8CB       ; Set drawing intensity
       ldy   #RobotExtremitiesVectorTable
       lda   3,u
       asla
       ldy   a,y         ; Get correct robot extremities
       ldx   #DrawRobotRightHalf
       stx   $C8C9       ; Set drawing function
       jsr   DrawWithPossibleScrolling
       leay  6,y         ; Get correct robot extremities
       ldx   #DrawRobotLeftHalf
       stx   $C8C9       ; Set drawing function
       jsr   DrawWithPossibleScrolling
       leay  6,y
       inc   $C824
       ldx   #move_then_draw_VL_with_count5
       stx   $C8C9       ; Set drawing function
       lda   #$04       ; Vector count - 1
       sta   $C823
       lda   4,u         ; Get correct eye box to draw
       anda  #$06
       ldx   a,y
       ldd   ,x
       beq   P058F
       jsr   DrawWithPossibleScrolling  ; Draw eye box
P058F: leau  8,u
       dec   -15,s
       lbne  P053E
       bra   P05C6


; When a robot is killed, it is replaced by a cloud of
; random dots.

DrawRobotDisappearing:
       jsr   get_random_a
       tfr   a,b
       clra
       tfr   d,x
       lda   #$06
       sta   -7,s
P05A5: ldd   ,u           ; Get the robot's position
       jsr   move_pen7F_to_d
       ldb   ,x+
       andb  #$07
       lda   ,x+
       anda  #$07
       jsr   dot_at_d    ; Draw random dot
       jsr   reset0ref
       dec   -7,s
       bne   P05A5
       dec   2,u          ; Prepare for next pass

;  Process next robot structure
P05BE: leau  8,u
       dec   -15,s
       lbne  P053E


; If the player has been in the maze for a certain amount
; of time, then it's time to bring out 'Otto'!

P05C6: tst   $C82E
       bne   DrawThePlayer
       tst   $C82F
       bne   DrawThePlayer
       inc   $C824
       lda   #$14
       sta   $C8CB       ; Drawing intensity
       ldx   #next_pt
       stx   $C8C9       ; Drawing function
       ldx   #OttoVectors
       ldu   #$C893     ; Otto's position
       jsr   DrawWithPossibleScrolling


; Unless C886 < 0, draw the player.  If the player is in
; the middle of getting fried, then redraw the player again,
; using a higher intensity.

DrawThePlayer:
       tst   $C886       ; Should player be drawn?
       bmi   P0613
       ldx   #DrawPlayerFunction
       stx   $C8C9       ; Drawing function
       lda   #$09
       sta   $C8CB       ; Drawin intensity
       ldu   #$C88F     ; Player's position
       jsr   DrawWithPossibleScrolling ; Draw the player
       jsr   reset0ref
       lda   $C8C5       ; See if player is being fried
       cmpa  #$04
       bne   P0613
       lda   $C8D0       ; Being fried
       sta   $C8CB       ; Set higher drawing intensity
       jsr   DrawWithPossibleScrolling ; Draw player again /
       jsr   reset0ref
P0613: rts


; DrawRobotLeftHalf()
; DrawRobotRightHalf()
;
; These functions draw the indicated half of a robot.
;
; Entry:
;    y = Ptr to robot extremity table
;    u = Ptr to robot structure


DrawRobotLeftHalf:
       ldx   #RobotLeftHalf
       bra   P061C

DrawRobotRightHalf:
       ldx   #RobotRightHalf
P061C: jsr   move_then_draw_VL_with_count1
       lda   4,u
       anda  #$02
       ldx   a,y             ; Robot legs
       lda   #$01           ; Vector count - 1
       jsr   draw_VL_with_count5
       ldx   4,y             ; Robot foot
       jsr   draw_VL_with_count1
       jmp   reset0ref


; DisplayBothPlayersScore()
;
; This displays player 1's score, and if 2 players are
; playing, then player 2's score also.

DisplayBothPlayersScore:
       ldd   #$7086        ; rel y & rel x
       ldu   #$C900        ; player 1 structure
       jsr   print_at_d
       tst   $C882          ; 2 players?
       beq   P0649
       ldd   #$7024        ; rel y & rel x
       ldu   #$C90E        ; player 2 structue
       jsr   print_at_d
P0649: rts


; ProcessAndUpdateRobots()
;
; This function loops through each of the robots, and
; determines where the robot is relative to the player,
; and will alter the robot's position (based on some
; criteria), and will determine if it is safe to fire
; at the player.  It also checks to see if the robot has
; hit a wall, collided with another robot or collided with
; the player.  Lastly, it updates Otto's position, if
; necessary, and checks to see if Otto has collided with
; the player.
;
; The robot will only fire if either it is 90 degrees or
; 45 degrees from the player  45 degrees occurs when
; |x delta| == |y delta|.
;
; As the robot is moving, if it is in a different quad
; from the player, then it will only update it's position
; (in an attempt to avoid running into walls) when it is
; not in the center of the quadrant.
       OPT
ProcessAndUpdateRobots:
       lda   $C8C8      ; Check if any robots are left
       lbeq  CheckForOttoStart
       clr   $C89D
       lda   $C8A9
P0654: ldu   #$C91C   ; Ptr to robot array
       leau  a,u
       adda  #$08
       cmpa  $C8AA
       bls   P0669
       tst   $C89D
       beq   P0666
       jmp   CheckForOttoStart
P0666: inc   $C89D
       clra
P0669: sta   $C8A9
       tst   2,u      ; Skip this robot if he is dead or
       bpl   P0654    ; not displayed.
       tst   7,u
       lbne  CheckForOttoStart ; Check processing delay
       lda   $C8A7
       sta   7,u      ; Reset the processing delay value
       lda   5,u      ; See if the robot can now start
       beq   P067F    ; shooting.
       dec   5,u
P067F: inc   4,u      ; Update to display next eye box
       ldd   ,u       ; Where is robot relative to player?
       jsr   DetermineDirectionToMove
       bitb  #$20    ; Do they line up in at least 1 dim?
       bne   PrepareToFire  ; Yes
       lda   $C8DE     ; No, so see if the x and y deltas
       cmpa  $C8DF     ; are the same  i.e. 45 degrees.
       beq   PrepareToFire
       nega
       cmpa  $C8DF
       bne   RobotMoving


; Only fire if the robot's delay counter has decremented
; to 0.  Once all bullets have been spent, reset the counter
; and the bullet count.  Robots have a delay, which controls
; how often they can fire, along with a bullet counter, which
; controls how many bullets they can fire in a burst.

PrepareToFire:
       lda   5,u      ; Check if shooting delay expired
       bne   RobotMoving ; Nope
       dec   6,u      ; Dec robot's bullet burst counter
       bpl   RobotFiring
       lda   $C883     ; Fired all we can for now.
       sta   6,u      ; Reset bullet burst counter
       lda   #$03
       sta   5,u      ; Reset shooting delay
       bra   RobotMoving


; The robot is firing.  Determine the starting position for
; the bullet, the direction and the velocity.  Lastly, make
; a sound.

RobotFiring:
       orb   #$80
       andb  #$0F
       stb   $C8EB     ; Save direction to fire bullet
       leax  ,u       ; Determine starting position for
       lda   #$07    ; bullet  a little away from robot
       jsr   CalculateUpdatedPosition
       std   $C89E
       ldx   #$C89E  ; Starting position
       ldb   $C884     ; Velocity factor
       jsr   FireBullet
       lda   #$02    ; Make a sound
       ora   $C867
       sta   $C867
       bra   CheckForRobotContactWithWall


; The robot is moving, and not firing.  Update the robot's
; extremities, based upon the direction of movement.  If
; the robot is in a different quadrant than the player,
; then attempt to avoid walls in the quadrant, only if the
; robot is not in the center of the quadrant.  Usually, the
; robot's direction of travel is determined by trying to
; avoid walls in the quadrant.

RobotMoving:
       andb  #$0F
       stb   3,u    ; Set robot's extremities
       ldd   $C88F   ; Get player's quadrant
       jsr   _MapPointT___
       lda   $C89A
       pshs  a
       ldd   ,u     ; Get robot's quadrant
       jsr   _MapPointT___
       puls  a
       cmpa  $C89A   ; In same quadrant?
       beq   MoveInCurrentDirection  ; yes
       lda   $C89B   ; In different quadrants
       cmpa  #$12  ; Avoid walls, if not in quad center
       blt   AttemptToAvoidWalls
       cmpa  #$2E
       bgt   AttemptToAvoidWalls
       lda   $C89C
       cmpa  #$12
       blt   AttemptToAvoidWalls
       cmpa  #$16
       bgt   AttemptToAvoidWalls
       bra   MoveInCurrentDirection


; Take the mask indicating which walls are present in this
; quadrant, and complement it, to determine the direction
; to move to avoid the walls.  If the resulting direction
; is 0, then the robot is completely enclosed.

AttemptToAvoidWalls:
       lda   $C899     ; Wall mask for quadrant
       coma
       anda  #$0F
       anda  3,u      ; Update robot's direction of travel
       sta   3,u
       beq   CheckForRobotContactWithWall ; Enclosed room


; Don't update the robot's direction of travel, but
; instead, just keep moving it in its current direction.

MoveInCurrentDirection:
       leax  ,u       ; Get current position
       lda   #$01    ; Set velocity factor
       ldb   3,u      ; Get current direction
       jsr   CalculateUpdatedPosition
       std   ,u       ; Update robot's position
       inc   4,u      ; Update eye box index

;  See if the robot has run into a wall
CheckForRobotContactWithWall:
       tst   2,u    ; Skip if the robot is already dead
       bpl   CheckForRobotCollision
       ldd   ,u     ; Robot's position
       jsr   _MapPointT___
       ldx   #RobotThresholds
       jsr   CheckForQuadrantEdgeCrossing
       bitb  $C899   ; Contact?
       beq   CheckForRobotCollision
       tfr   u,x
       jsr   CreditPlayerWithDeadRobot

;  See if the robot has run into another robot.
CheckForRobotCollision:
       ldx   #$C91C
       lda   $C8C7
       sta   $C89D
P072B: ldd   ,u
       cmpd  ,x       ; Don't compare against yourself
       beq   GetNextRobotPtr
       tst   2,x      ; Skip if next robot is dead
       bpl   GetNextRobotPtr
       tst   2,u      ; Skip if current robot is now dead
       bpl   GetNextRobotPtr
       ldy   #RobotContactBounds
       jsr   CheckForContact
       bhs   GetNextRobotPtr    ; Contact?
       jsr   CreditPlayerWithDeadRobot
       exg   x,u
       jsr   CreditPlayerWithDeadRobot
       exg   x,u
GetNextRobotPtr:
       leax  8,x      ; Get pointer to next robot
       dec   $C89D
       bne   P072B

;  See if robot collided with the player
       lda   2,u
       bpl   CheckForOttoStart  ; Skip if robot is dead
       ldd   ,u
       ldx   #$C88F
       ldy   #PlayerContactBounds
       jsr   CheckForContact
       bhs   CheckForOttoStart
       tfr   u,x
       jsr   CreditPlayerWithDeadRobot
       lda   #$04      ; Tag player as dead
       sta   $C8C5
       lda   #$08
       ora   $C867
       sta   $C867   ; Make some sound

;  Wait for counters to expire, before starting Otto
CheckForOttoStart:
       tst   $C82E
       bne   P07ED
       tst   $C82F
       bne   P07ED
       lda   $C826
       bita  #$03
       bne   P079B


; Determine Otto's position and direction, do some
; occassional sound mucking, and then see if Otto collided
; with the player.

       ldd   $C891     ; Determine Otto's travel direction
       jsr   DetermineDirectionToMove
       ldx   #$C891  ; Otto's position
       lda   $C898     ; Otto's velocity
       jsr   CalculateUpdatedPosition
       std   $C891     ; Update Otto's position
       ldb   $C897     ; Since Otto bounces up and down,
       subb  $C898     ; determine how to offset his 'y'
       bpl   P0799    ; position.
       ldb   #$20
P0799: stb   $C897
P079B: ldb   $C897
       cmpb  #$1A
       bne   P07A7
       lda   #$01
       ora   $C876     ; Make some sound
       sta   $C876
P07A7: lda   $C891     ; Make Otto bounce up and down
       ldu   #OttoBounceOffsets
       adda  b,u
       ldb   $C892
       std   $C893     ; Update Otto's position
       tst   $C8C5     ; Is player still alive?
       bne   CheckForRobotHitByOtto
       ldx   #$C88F  ; Otto and player collide?
       ldy   #PlayerContactBounds
       jsr   CheckForContact
       bhs   CheckForRobotHitByOtto
       inc   $C898     ; Increment Otto's velocity
       lda   #$08
       ora   $C867
       sta   $C867     ; Make a sound
       lda   #$04
       sta   $C8C5     ; Tag player as dead

;  Kill off any robots which collide with Otto
CheckForRobotHitByOtto:
       ldx   #$C91C     ; Addr of robot array
       lda   $C8C7        ; Number of array entries
       sta   $C89D        ; Loop counter
       ldy   #RobotContactBounds     ; 'Accuracy' table
P07D9: tst   2,x         ; Make sure robot is alive
       bpl   P07E7
       ldd   $C893        ; Get Otto's position
       jsr   CheckForContact
       bhs   P07E7
       jsr   CreditPlayerWithDeadRobot
P07E7: leax  8,x
       dec   $C89D
       bne   P07D9
P07ED: rts

OttoBounceOffsets:
       DB    $00
       DB    $08
       DB    $0C
       DB    $0E
       DB    $10
       DB    $12
       DB    $12
       DB    $12
       DB    $14
       DB    $16
       DB    $16
       DB    $16
       DB    $16
       DB    $16
       DB    $14
       DB    $12
       DB    $12
       DB    $12
       DB    $10
       DB    $0E
       DB    $0C
       DB    $08
       DB    $00
       DB    $FC
       DB    $F8
       DB    $F4
       DB    $EE
       DB    $EA
       DB    $EE
       DB    $F4
       DB    $F8
       DB    $FC
       DB    $00


; CreditPlayerWithDeadRobot()
;
; This function decrements the number of active robots
; (C8C8), marks the robot as dead, and credits the player
; with 50 points.
;
; Entry:
;    x = pointer to dead robot structure.

CreditPlayerWithDeadRobot:
       dec   $C8C8
       lda   #$0F
       sta   2,x
       lda   #$04
       sta   $C867
       pshs  x
       ldx   $C880
       ldd   #$0050
       jsr   add_d_to_x_in_bcd
       puls  x,pc


; ProcessAndUpdateBullets()
;
; This function updates the head and tail of each bullet,
; and checks to see if a bullet has run into a wall,
; hit a robot, or hit the player.  A bullet's position
; is updated multiple times, based on its velocity setting
; a higher velocity setting causes a bullet to be updated
; more often.  A bullet is a short vector made up of a
; head and a tail.

ProcessAndUpdateBullets:
       lda   $C8CC      ; Number of bullets
       lbeq  P08C6
       sta   $C8A2      ; Set loop counter
       ldu   #$C974
P0830: ldb   7,u
       andb  #$0F     ; Skip if bullet is not active
       lbeq  P08B6
       stb   $C8EB      ; Get the direction of travel
       lda   6,u
       sta   $C8A1      ; Use velocity as loop counter
P083E: ldb   $C8EB      ; Direction of travel
       lda   #$01     ; Velocity
       leax  ,u        ; Current tail position
       jsr   CalculateUpdatedPosition
       std   ,u        ; Update bullet's tail position
       ldb   $C8EB      ; Direction of travel
       lda   #$01     ; Velocity
       leax  4,u       ; Current head position
       jsr   CalculateUpdatedPosition
       std   4,u       ; Update bullet's head position

;  See if bullet collided with a wall
       ldd   4,u       ; Bullet's head position
       jsr   _MapPointT___
       tst   $C89A
       bmi   P0863
       ldx   #BulletToWallThresholds
       jsr   CheckForQuadrantEdgeCrossing
P0863: bitb  $C899      ; Contact with wall?
       beq   P086D
       ldb   #$F0
       andb  7,u
       stb   7,u       ; Flag bullet as hitting something

;  See if bullet hit any of the robots
P086D: ldx   #$C91C
       lda   $C8C7
       sta   $C89D
P0874: lda   2,x       ; Skip robot if already dead
       bpl   P088C
       ldy   #RobotContactBounds
       ldd   4,u       ; Position of bullet's head
       jsr   CheckForContact
       bhs   P088C
       NOOPT
       jsr   CreditPlayerWithDeadRobot
       OPT
       ldb   #$F0     ; Flag bullet as hitting something
       andb  7,u
       stb   7,u
P088C: leax  8,x
       dec   $C89D
       bne   P0874

;  See if bullet hit the player
       ldd   4,u       ; Position of bullet's head
       ldx   #$C88F   ; Check for contact with player ?
       ldy   #PlayerContactBounds2
       jsr   CheckForContact
       bhs   P08B2
       tst   $C8C5      ; Do nothing if player is already
       bne   P08B2     ; dead or has left the maze.
       lda   #$08
       sta   $C867      ; Make a sound
       lda   #$04
       sta   $C8C5      ; Flag player as dead
       ldb   #$F0
       andb  7,u       ; Flag bullet as hitting something
       stb   7,u

;  Keep processing this bullet, based on its velocity
P08B2: dec   $C8A1
       bne   P083E

;  Update the delta between the head and tail of bullet
P08B6: ldd   4,u
       suba  ,u
       subb  1,u
       std   2,u

;  Loop until all bullets have been processed
       leau  8,u
       dec   $C8A2
       lbne  P0830
P08C6: rts


; DrawWithPossibleScrolling()
;
; This function draws an object at its scrolled position,
; until the starting point for the object being drawn
; scrolls off, at which point, the object is no longer
; drawn.  The scrolling offsets are incremented each time
; PlayerHasLeftMaze() is called.  Most of the code below
; is trying to determine if the starting point has
; scrolled off in the expected direction.
;
; Entry:
;   x = ptr to vector list (for generic draw functions)
;   u = ptr to drawing position
;   C8C9 = drawing function to call

DrawWithPossibleScrolling:
       jsr   dptoC8
       direct  $C8             ; pretty for optimizing to use a makro :-)
       ldb   ,u
       sex
       addd  $C8E2
       stb   $C89D   ; starting y pos + scrolling offset
       bpl   P08E6
       coma
       bne   DoNoDrawing
       tst   $C8E6
       bmi   P08F7
       tst   ,u
       bpl   DoNoDrawing
       lda   #$3F
       cmpa  $C8E0
       blt   DoNoDrawing
       bra   P08F7
P08E6: tsta
       bne   DoNoDrawing
       tst   $C8E6
       bpl   P08F7
       tst   ,u
       bmi   DoNoDrawing
       lda   #$C1
       cmpa  $C8E0
       bge   DoNoDrawing
P08F7: ldb   1,u
       sex
       addd  $C8E4
       stb   $C89E  ; starting x pos + scrolling offset
       bpl   P0913
       coma
       bne   DoNoDrawing
       tst   $C8E6
       bmi   P0924
       tst   1,u
       bpl   DoNoDrawing
       lda   #$3F
       cmpa  $C8E1
       blt   DoNoDrawing
       bra   P0924
P0913: tsta
       bne   DoNoDrawing
       tst   $C8E6
       bpl   P0924
       tst   1,u
       bmi   DoNoDrawing
       lda   #$C1
       cmpa  $C8E1
       bge   DoNoDrawing
P0924: jsr   dptoD0
       direct  $D0             ; pretty for optimizing to use a makro :-)
       ldd   $C89D        ; Goto modified drawing origin
       jsr   move_pen7F_to_d
       lda   $C8CB        ; Set drawing intensity
       sta   $D004
       jsr   [$C8C9]     ; Jump to drawing function /

DoNoDrawing:
       direct  $D0             ; pretty for optimizing to use a makro :-)
       jmp   dptoD0
       direct  $D0             ; pretty for optimizing to use a makro :-)


; CalculateUpdatedPosition()
;
; This function updates a position, based upon a direction
; of travel, and a velocity setting.  The velocity is
; broken up into a rise and a run value, and added to the
; incoming position.
;
; Entry:
;   b = direction of travel
;   a = velocity setting
;   x = pointer to a position
;
; Exit:
;   d = updated position (y,x)

CalculateUpdatedPosition:
       bitb  #$03
       beq   AddVelocityToEndpoints
       bitb  #$0C
       beq   AddVelocityToEndpoints

;  Break up velocity into rise and run components
       pshs  b
       ldb   #$03
       mul
       asrb
       bhs   P094A
       incb
P094A: asrb
       bhs   P094E
       incb
P094E: tfr   b,a
       puls  b

AddVelocityToEndpoints:
       direct  $C8             ; pretty for optimizing to use a makro :-)
       sta   $C89D   ; Save adjusted velocity
       bitb  #$11
       beq   P095B
       nega         ; Going left  - velocity
       bra   P0960
P095B: bitb  #$02
       bne   P0960  ; Going right  + velocity
       clra         ; No movement in x direction
P0960: adda  1,x    ; Update the x position
       pshs  a
       lda   $C89D   ; Reload adjusted velocity
       bitb  #$08
       beq   P096D
       nega         ; Going down  - velocity
       bra   P0972
P096D: bitb  #$04
       bne   P0972  ; Going up  + velocity
       clra         ; No movement in y direction
P0972: adda  ,x     ; Update the y position
       puls  b,pc


; This is one of the 'indirect jump' functions.  It is the
; active jump function when the player successfully leaves
; a maze.  When the player exits from a door in the maze,
; the maze will then scroll off in the opposite direction
; i.e. If the player exits through the left door, the maze
; will scroll off to the right.  Each time this function
; is called, it will bump the scrolling deltas  this
; continues until scrolling is complete.  It also sets
; the player's starting position in the next maze  if the
; player exited from the left, then he will start at the
; right edge of the next maze, and the door through which
; he exited will be blocked.

PlayerHasLeftMaze:
       ldb   #$80
       stb   $C8E6
       ldb   $C8EA   ; Determine door player exited thru
       bitb  #$01
       beq   P0986
       clr   $C8E6   ; Left door, so scroll right
       inc   $C8E1
       bra   P09B2
P0986: bitb  #$02
       beq   P098E
       dec   $C8E1   ; Right door, so scroll left
       bra   P09A0
P098E: bitb  #$04
       beq   P0996
       dec   $C8E0   ; Top door, so scroll down
       bra   P09A0
P0996: bitb  #$08
       beq   P09A0
       clr   $C8E6   ; Bottom door, so scroll up
       inc   $C8E0
       bra   P09B2


; This block checks to see if we have finished scrolling,
; and if so, prepares us for entering the next maze.
; It will also set the player's starting position in the
; next maze.

P09A0: bmi   SaveScrollingDeltas
       bitb  #$02
       beq   P09AC   ; Exited thru right door?
       lda   $C88F
       ldb   #$A5   ; Yes  start at left edge
       bra   P09C2
P09AC: lda   #$B0   ; Exited thru top door
       ldb   $C890    ; Start at bottom
       bra   P09C2
P09B2: bpl   SaveScrollingDeltas
       bitb  #$08   ; Exited thru bottom door?
       beq   P09BE
       lda   #$54   ; Yes  start at top edge
       ldb   $C890
       bra   P09C2
P09BE: lda   $C88F    ; Exited thru left door
       ldb   #$5B   ; Start at right edge
P09C2: ldx   $C880
       std   10,x    ; Update player's position
       lda   $C8EA    ; This tells the exit door
       anda  #$0F
       asla
       sta   $C8C6    ; Block door player exited thru
       lda   #$3F
       sta   $C885    ; Set a loop counter
       lda   #$A0   ; Reset the threshold used to
       tst   $C8D1    ; determine if a robot is placed in
       bne   P09D9   ; the maze.
       lda   #$50
P09D9: sta   $C8A8
       jmp   EnterNextMaze


; This block saves the x and y delta values, which are
; then used by the drawing function, to offset all
; drawing origins.

SaveScrollingDeltas:
       ldb   $C8E0
       sex
       aslb
       rola
       std   $C8E2   ; Save 16-bit y delta
       ldb   $C8E1
       sex
       aslb
       rola
       std   $C8E4   ; Save 16-bit x delta
       jmp   MakeSoundThenGotoMainLoop


; DrawPlayerFunction()
;
; This function draws the player's body, and then the
; arms and legs  the types of arms and legs is dependent
; upon whether the player is standing still, running
; or shooting.  (C8CE) is the index indicating movement,
; while (C8CF) is the index indicating arm position
; (running, standing still or shooting).

        NOOPT
DrawPlayerFunction:
       clr   $C824
       lda   #$0A           ; Draw the player's body
       ldx   #PlayersBody
       jsr   draw_VL_with_count5
       ldb   $C8CE           ; Running or standing still?
       beq   PlayerStandingStill
       ldx   #PlayerLegsVectorTable
       ldx   b,x
       jsr   next_pt
       ldx   #PlayerMovingArmsVectorTable
       ldb   $C8CF
       ldx   b,x
       inc   $C824
       jmp   next_pt

PlayerStandingStill:
       ldx   #StationaryLegs   ; Draw legs standing still
       jsr   move_then_draw_VL_with_count1
       ldx   #PlayerArmsVectorTable
       ldb   $C8CF
       beq   PlayerNotShooting
       ldx   b,x            ; Player is shooting
       jmp   move_then_draw_VL_with_count1

PlayerNotShooting:
       ldx   ,x             ; Draw arms at side
       jmp   next_pt


; Whenever the player's score passes certain cutoff level,
; the game becomes more challenging.  The cutoff levels are:
; 3000, 15000, 30000, 45000, 50000, 60000 and 75000

SkillLevelCutoffs:
       DW    $2033 ; " 3"
       DW    $3135 ; "15"
       DW    $3330 ; "30"
       DW    $3435 ; "45"
       DW    $3530 ; "50"
       DW    $3630 ; "60"
       DW    $3735 ; "75"
       DB    $80


; This table is used to fill in the player's arm
; movement value (C8CF), when standing still.  The
; value is obtained from this array, by indexing into
; it using the joystick state:
;
;         ---------------------------------
;         | 0 | 0 | B | L | D | U | R | L |
;         ---------------------------------
;   Button Pressed--^
;   Joystick Left-------^---------------^
;   Joystick Down-----------^
;   Joystick Up-----------------^
;   Joystick Right------------------^

ArmsShootingIndicesTable:
       DB    $80     ; idx = $00  Invalid setting
       DB    $02     ; idx = $01  shooting left
       DB    $04     ; idx = $02  shooting right
       DB    $80     ; idx = $03  Invalid setting
       DB    $06     ; idx = $04  shooting up
       DB    $08     ; idx = $05  shooting upper left
       DB    $0A     ; idx = $06  shooting upper right
       DB    $80     ; idx = $07  Invalid setting
       DB    $0C     ; idx = $08  shooting down
       DB    $0E     ; idx = $09  shooting lower left
       DB    $10     ; idx = $0A  shooting lower right


; As the player runs, the legs either move in a left or
; right direction.  The value in C8CE is used to index
; into this table.

PlayerLegsVectorTable:
       DW    StationaryLegs
       DW    LegsRunningRight1
       DW    LegsRunningRight2
       DW    LegsRunningLeft1
       DW    LegsRunningLeft2


; As the player moves, his arms swing back and forth.
; The value in C8CF is used to index into this table.

PlayerMovingArmsVectorTable:
       DW    MovingArms1
       DW    MovingArms2


; When a player is standing still, they are either shooting
; or not shooting.  The value in C8CF is used to index into
; this table.

PlayerArmsVectorTable:
       DW    NeutralArms
       DW    ShootingLeft
       DW    ShootingRight
       DW    ShootingUp
       DW    ShootingUpperLeft
       DW    ShootingUpperRight
       DW    ShootingDown
       DW    ShootingLowerLeft
       DW    ShootingLowerRight


; Depending upon what a robot is doing, his extremities
; (legs and eye boxes) may be drawn differently.  Each
; entry in this table points to another structure, which
; defines how the extremities should be drawn.  Each robot
; structure has a field which is used to index into this
; table.

RobotExtremitiesVectorTable:
       DW    RobotStandingStill
       DW    RobotMovingLeft
       DW    RobotMovingRight
       DW    RobotStandingStill
       DW    RobotMovingUp
       DW    RobotMovingLeft
       DW    RobotMovingRight
       DW    RobotStandingStill
       DW    RobotMovingDown
       DW    RobotMovingLeft
       DW    RobotMovingRight


; Each of the following 5 structures describe how the
; extremities should be drawn for a robot, while in a
; particular state.  The structure is defined as follows:
;
;   {
;       ptr to first right leg vector list
;       ptr to second right leg vector list
;       ptr to right foot vector list
;       ptr to first left leg vector list
;       ptr to second left leg vector list
;       ptr to left foot vector list
;       ptr to eye box 1 vector list
;       ptr to eye box 2 vector list
;       ptr to eye box 3 vector list
;       ptr to eye box 4 vector list
;   }
;
; As the robot is drawn, it will cycle through the 2
; right leg and 2 left leg vector list  it will also
; cycle through the 4 eye box vector lists.  In some
; cases, values will be the same  this implies that no
; motion is occurring (i.e. if the robot is not moving,
; then the legs shouldn't be moving either).
;
; When a robot is moving left, the eye box and both feet
; point to the left.  When the robot is moving right, then
; the eye box and both feed point right.  When the robot
; is moving up, then the eye box points up.  When the robot
; moves down, no eye box is displayed.  When the robot is
; standing still, the eye box will appear to rotate.

RobotStandingStill:
       DW    RobotRightLeg1
       DW    RobotRightLeg1
       DW    RobotRightFoot
       DW    RobotLeftLeg1
       DW    RobotLeftLeg1
       DW    RobotLeftFoot
       DW    RobotEyeBoxCentered
       DW    RobotEyeBoxRight
       DW    RobotEyeBoxInvisible
       DW    RobotEyeBoxLeft

RobotMovingRight:
       DW    RobotRightLeg1
       DW    RobotRightLeg2
       DW    RobotRightFoot
       DW    RobotLeftLeg1
       DW    RobotLeftLeg2
       DW    RobotRightFoot
       DW    RobotEyeBoxRight
       DW    RobotEyeBoxRight
       DW    RobotEyeBoxRight
       DW    RobotEyeBoxRight

RobotMovingLeft:
       DW    RobotRightLeg1
       DW    RobotRightLeg2
       DW    RobotLeftFoot
       DW    RobotLeftLeg1
       DW    RobotLeftLeg2
       DW    RobotLeftFoot
       DW    RobotEyeBoxLeft
       DW    RobotEyeBoxLeft
       DW    RobotEyeBoxLeft
       DW    RobotEyeBoxLeft

RobotMovingUp:
       DW    RobotRightLeg1
       DW    RobotRightLeg3
       DW    RobotRightFoot
       DW    RobotLeftLeg3
       DW    RobotLeftLeg1
       DW    RobotLeftFoot
       DW    RobotEyeBoxCentered
       DW    RobotEyeBoxCentered
       DW    RobotEyeBoxCentered
       DW    RobotEyeBoxCentered

RobotMovingDown:
       DW    RobotRightLeg1
       DW    RobotRightLeg3
       DW    RobotRightFoot
       DW    RobotLeftLeg3
       DW    RobotLeftLeg1
       DW    RobotLeftFoot
       DW    RobotEyeBoxInvisible
       DW    RobotEyeBoxInvisible
       DW    RobotEyeBoxInvisible
       DW    RobotEyeBoxInvisible

BonusString:
       DB    $70 ; rel y
       DB    $DA ; rel x
       DB    "BONUS",$FF


; As the player gets better, the game will start to
; block off one of the maze doors.  The value in C8C6
; is used to index into this array, when the value > 0.
; The value in C8C6 has the following format:
;
;         ---------------------------------
;         | 0 | 0 | 0 | T | B | L | R | 0 |
;         ---------------------------------
;   Block Top Door------^
;   Block Bottom Door-------^
;   Block Left Door-------------^
;   Block Right Door----------------^

BlockedDoorVectorTable:
       DW    BlockedDoorVectorTable  ; idx = 0  Invalid
       DW    RightDoorVectors        ; idx = 2
       DW    LeftDoorVectors         ; idx = 4
       DW    BlockedDoorVectorTable  ; idx = 6  Invalid
       DW    BottomDoorVectors       ; idx = 8
       DW    BlockedDoorVectorTable  ; idx = 10  Invalid
       DW    BlockedDoorVectorTable  ; idx = 12  Invalid
       DW    BlockedDoorVectorTable  ; idx = 14  Invalid
       DW    TopDoorVectors          ; idx = 16


; Each of the following tables contain the relative (y,x)
; point to move to, followed by the (y,x) point to draw to.

RightDoorVectors:
       DB    $E0   ; move to absolute y
       DB    $64   ; move to absolute x
       DB    $40   ; vector rel y
       DB    $00   ; vector rel x

LeftDoorVectors:
       DB    $E0   ; move to absolute y
       DB    $9C   ; move to absolute x
       DB    $40   ; vector rel y
       DB    $00   ; vector rel x

TopDoorVectors:
       DB    $60   ; move to absolute y
       DB    $EC   ; move to absolute x
       DB    $00   ; vector rel y
       DB    $28   ; vector rel x

BottomDoorVectors:
       DB    $A0   ; move to absolute y
       DB    $EC   ; move to absolute x
       DB    $00   ; vector rel y
       DB    $28   ; vector rel x


; This structure contains 4 entries  1 for each of the
; sections of outer wall which must be drawn.  Each
; entry contains an absolute (y,x) position, to which
; the pen should be moved before doing any drawing, and
; a pointer to the appropriate vector list.

OutsideMazeWallData:
       DB    $60  ; absolute y
       DB    $EC  ; absolute x
       DW    UpperLeftWall
       DB    $A0  ; absolute y
       DB    $EC  ; absolute x
       DW    LowerLeftWall
       DB    $A0  ; absolute y
       DB    $14  ; absolute x
       DW    LowerRightWall
       DB    $60  ; absolute y
       DB    $14  ; absolute x
       DW    UpperRightWall


; The following is a table of 8 (y,x) points, which
; represent the starting points for all interior maze
; walls.  The maze is divided into 15 quadrants, and
; these points represent the points where 4 quadrants
; meet (as indicated by the '+' character:
;
;     -100 -60 -20 +20 +60 +100
;       --------------------- +96
;       | 0 | 1 | 2 | 3 | 4 |
;       ----+---+---+---+---- +32
;       | 5 | 6 | 7 | 8 | 9 |
;       ----+---+---+---+---- -32
;       |10 |11 |12 |13 |14 |
;       --------------------- -96

InnerWallPositionTable:
       DB    $20
       DB    $C4
       DB    $20
       DB    $EC
       DB    $20
       DB    $14
       DB    $20
       DB    $3C
       DB    $E0
       DB    $C4
       DB    $E0
       DB    $EC
       DB    $E0
       DB    $14
       DB    $E0
       DB    $3C


; The following 4 structures contain the (y,x) points
; needed to draw 2 of the outer maze walls.

UpperLeftWall:
       DB    $00
       DB    $B0
       DB    $C0
       DB    $00

LowerLeftWall:
       DB    $00
       DB    $B0
       DB    $40
       DB    $00

LowerRightWall:
       DB    $00
       DB    $50
       DB    $40
       DB    $00

UpperRightWall:
       DB    $00
       DB    $50
       DB    $C0
       DB    $00


; The following is a table of 4 single vectors, each
; representing a posible vector which might be drawn
; as an inner wall.  From any one of the inner points,
; a wall could be drawn:
;
;   1) upward
;   2) downward
;   3) to the right
;   4) to the left
;
; When drawing the maze, the 8 byte array C8AB-C8B2
; (which contains one entry for each of the 8 possible
; inner wall positions) indicates which of the segments
; should be drawn  the index is either 0, 2, 4 or 6.

InnerWallVectorTable:
       DB    $40 ; Draw upward from point
       DB    $00
       DB    $C0 ; Draw downward from point
       DB    $00
       DB    $00 ; Draw right from point
       DB    $28
       DB    $00 ; Draw left from point
       DB    $D8


; Vector list comprising right half of the robot's body.

RobotRightHalf:
       DB    $05 ; vector count - 1
       DB    $64 ; rel y
       DB    $00 ; rel x
       DB    $00
       DB    $28
       DB    $E8
       DB    $28
       DB    $84
       DB    $00
       DB    $00
       DB    $EC
       DB    $30
       DB    $00

RobotRightLeg1:
       DB    $00
       DB    $E4
       DB    $9C
       DB    $00

RobotRightLeg2:
       DB    $00
       DB    $D0
       DB    $9C
       DB    $00

RobotRightLeg3:
       DB    $00
       DB    $E4
       DB    $8D
       DB    $00

RobotRightFoot:
       DB    $00
       DB    $1C


; Vector list comprising left half of the robot's body.

RobotLeftHalf:
       DB    $05 ; vector count - 1
       DB    $64 ; rel y
       DB    $00 ; rel x
       DB    $00
       DB    $D8
       DB    $E8
       DB    $D8
       DB    $84
       DB    $00
       DB    $00
       DB    $14
       DB    $30
       DB    $00

RobotLeftLeg1:
       DB    $00
       DB    $1C
       DB    $9C
       DB    $00

RobotLeftLeg2:
       DB    $00
       DB    $30
       DB    $9C
       DB    $00

RobotLeftLeg3:
       DB    $00
       DB    $1C
       DB    $8D
       DB    $00

RobotLeftFoot:
       DB    $00
       DB    $E4

RobotEyeBoxCentered:
       DB    $30
       DB    $28
       DB    $1C
       DB    $00
       DB    $00
       DB    $B0
       DB    $E4
       DB    $00
       DB    $00
       DB    $50

RobotEyeBoxRight:
       DB    $30
       DB    $14
       DB    $00
       DB    $3C
       DB    $1C
       DB    $00
       DB    $00
       DB    $C4
       DB    $E4
       DB    $00

RobotEyeBoxLeft:
       DB    $30
       DB    $EC
       DB    $1C
       DB    $00
       DB    $00
       DB    $C4
       DB    $E4
       DB    $00
       DB    $00
       DB    $3C

RobotEyeBoxInvisible:
       DB    $00
       DB    $00

OttoVectors:
       DB    $00
       DB    $18
       DB    $0A
       DB    $FF
       DB    $F2
       DB    $0E
       DB    $FF
       DB    $EC
       DB    $00
       DB    $FF
       DB    $F2
       DB    $F2
       DB    $FF
       DB    $00
       DB    $EC
       DB    $FF
       DB    $0E
       DB    $F2
       DB    $FF
       DB    $14
       DB    $00
       DB    $FF
       DB    $0E
       DB    $0E
       DB    $FF
       DB    $00
       DB    $14
       DB    $00
       DB    $F4
       DB    $03
       DB    $FF
       DB    $FD
       DB    $FB
       DB    $00
       DB    $00
       DB    $F2
       DB    $FF
       DB    $03
       DB    $FB
       DB    $00
       DB    $EC
       DB    $00
       DB    $FF
       DB    $FD
       DB    $05
       DB    $FF
       DB    $00
       DB    $0E
       DB    $FF
       DB    $03
       DB    $05
       DB    $01

PlayersBody:
       DB    $00
       DB    $14
       DB    $C4
       DB    $00
       DB    $00
       DB    $D8
       DB    $3C
       DB    $00
       DB    $00
       DB    $14
       DB    $0F
       DB    $14
       DB    $0A
       DB    $00
       DB    $0A
       DB    $EC
       DB    $F6
       DB    $EC
       DB    $F6
       DB    $00
       DB    $F1
       DB    $14
       DB    $01

LegsRunningRight1:
       DB    $00
       DB    $C4
       DB    $0C
       DB    $FF
       DB    $E0
       DB    $16
       DB    $FF
       DB    $EA
       DB    $06
       DB    $FF
       DB    $FE
       DB    $08
       DB    $00
       DB    $10
       DB    $98
       DB    $FF
       DB    $0A
       DB    $04
       DB    $FF
       DB    $08
       DB    $20
       DB    $FF
       DB    $16
       DB    $08
       DB    $01

LegsRunningRight2:
       DB    $00
       DB    $C4
       DB    $08
       DB    $FF
       DB    $E0
       DB    $0A
       DB    $FF
       DB    $E6
       DB    $F8
       DB    $FF
       DB    $00
       DB    $08
       DB    $00
       DB    $00
       DB    $DC
       DB    $FF
       DB    $02
       DB    $F8
       DB    $FF
       DB    $1A
       DB    $08
       DB    $FF
       DB    $1E
       DB    $02
       DB    $01

LegsRunningLeft1:
       DB    $00
       DB    $C4
       DB    $08
       DB    $FF
       DB    $E2
       DB    $FE
       DB    $FF
       DB    $E6
       DB    $0E
       DB    $FF
       DB    $FE
       DB    $FC
       DB    $00
       DB    $00
       DB    $DC
       DB    $FF
       DB    $00
       DB    $08
       DB    $FF
       DB    $1A
       DB    $FA
       DB    $FF
       DB    $20
       DB    $0A
       DB    $01

LegsRunningLeft2:
       DB    $00
       DB    $C4
       DB    $08
       DB    $FF
       DB    $EA
       DB    $08
       DB    $FF
       DB    $F8
       DB    $20
       DB    $FF
       DB    $F6
       DB    $04
       DB    $00
       DB    $F0
       DB    $9C
       DB    $FF
       DB    $02
       DB    $08
       DB    $FF
       DB    $16
       DB    $06
       DB    $FF
       DB    $20
       DB    $16
       DB    $01

NeutralArms:
       DB    $00
       DB    $32
       DB    $1E
       DB    $FF
       DB    $F6
       DB    $14
       DB    $FF
       DB    $E6
       DB    $00
       DB    $00
       DB    $24
       DB    $C4
       DB    $FF
       DB    $F6
       DB    $EC
       DB    $FF
       DB    $E6
       DB    $00
       DB    $01

StationaryLegs:
       DB    $05
       DB    $C4
       DB    $0A
       DB    $D8
       DB    $00
       DB    $FC
       DB    $0A
       DB    $FC
       DB    $F6
       DB    $00
       DB    $EC
       DB    $30
       DB    $00

ShootingRight:
       DB    $03
       DB    $32
       DB    $1E
       DB    $00
       DB    $28
       DB    $F0
       DB    $C0
       DB    $10
       DB    $F0

ShootingLeft:
       DB    $03
       DB    $32
       DB    $1E
       DB    $F0
       DB    $F0
       DB    $10
       DB    $C0
       DB    $00
       DB    $28

ShootingUp:
       DB    $04
       DB    $32
       DB    $1E
       DB    $0A
       DB    $14
       DB    $24
       DB    $00
       DB    $C4
       DB    $E2
       DB    $0E
       DB    $E2

ShootingDown:
       DB    $04
       DB    $32
       DB    $1E
       DB    $EC
       DB    $D0
       DB    $E4
       DB    $F4
       DB    $24
       DB    $00
       DB    $0A
       DB    $14

ShootingUpperLeft:
       DB    $04
       DB    $32
       DB    $1E
       DB    $F0
       DB    $F0
       DB    $30
       DB    $C0
       DB    $D0
       DB    $18
       DB    $10
       DB    $10

ShootingLowerLeft:
       DB    $03
       DB    $32
       DB    $1E
       DB    $E8
       DB    $10
       DB    $E0
       DB    $D0
       DB    $3A
       DB    $1A

ShootingUpperRight:
       DB    $04
       DB    $32
       DB    $1E
       DB    $F0
       DB    $10
       DB    $30
       DB    $18
       DB    $D0
       DB    $C0
       DB    $10
       DB    $F0

ShootingLowerRight:
       DB    $03
       DB    $32
       DB    $1E
       DB    $C4
       DB    $18
       DB    $20
       DB    $D0
       DB    $18
       DB    $F0

MovingArms1:
       DB    $00
       DB    $32
       DB    $1E
       DB    $FF
       DB    $F0
       DB    $10
       DB    $FF
       DB    $EA
       DB    $F8
       DB    $00
       DB    $04
       DB    $BC
       DB    $FF
       DB    $18
       DB    $00
       DB    $FF
       DB    $06
       DB    $14
       DB    $01

MovingArms2:
       DB    $00
       DB    $32
       DB    $22
       DB    $FF
       DB    $FA
       DB    $14
       DB    $FF
       DB    $E4
       DB    $00
       DB    $00
       DB    $FC
       DB    $BC
       DB    $FF
       DB    $16
       DB    $F8
       DB    $FF
       DB    $10
       DB    $10
       DB    $01

AuthorsInitials:
       DB    $F8 ; height
       DB    $30 ; width
       DB    $A0 ; y
       DB    $30 ; x
       DB    "CMK",$80


; This contains the starting positions for
; robots  a random number is used to index into this
; table.  It is formated as (y, x) pairs.

RobotStartingPositionTable:
       DB    $40
       DB    $B0
       DB    $C0
       DB    $B0
       DB    $40
       DB    $D8
       DB    $00
       DB    $D8
       DB    $C0
       DB    $D8
       DB    $00
       DB    $00
       DB    $40
       DB    $28
       DB    $00
       DB    $28
       DB    $C0
       DB    $28
       DB    $40
       DB    $50
       DB    $C0
       DB    $50


; By default, certain quadrants within the maze;always
; have certain walls present  i.e. any of the outside
; quadrants.  This maze contains the default 'wall mask'
; values, which are used to seed the array C8B5-C8C3.
; That array is then further modified as the interior
; walls are added.  The mask values have the following
; meaning:
;
;              ---------------------------------
;              | 0 | 0 | 0 | 0 | B | T | R | L |
;              ---------------------------------
;   Quadrant has Bottom Wall-----^
;   Quadrant has Top Wall------------^
;   Quadrant has Right Wall--------------^
;   Quadrant has Left Wall-------------------^
;
; The quadrants are defined as follows:
;
;       ---------------------
;       | 0 | 1 | 2 | 3 | 4 |
;       ----+---+---+---+----
;       | 5 | 6 | 7 | 8 | 9 |
;       ----+---+---+---+----
;       |10 |11 |12 |13 |14 |
;       ---------------------

DefaultMazeWallsPerQuadrant:
       DB    $05   ; left and top walls
       DB    $04   ; top wall
       DB    $04   ; top wall
       DB    $04   ; top wall
       DB    $06   ; top and right walls
       DB    $01   ; left wall
       DB    $00   ; no walls
       DB    $00   ; no walls
       DB    $00   ; no walls
       DB    $02   ; right wall
       DB    $09   ; bottom and left wall
       DB    $08   ; bottom wall
       DB    $08   ; bottom wall
       DB    $08   ; bottom wall
       DB    $0A   ; bottom and right walls

PlayerFriedIntensities:
       DB    $08
       DB    $07
       DB    $06
       DB    $05
       DB    $05
       DB    $05
       DB    $06
       DB    $07
       DB    $08
       DB    $09
       DB    $08
       DB    $07
       DB    $06
       DB    $05
       DB    $06
       DB    $07


; CheckForContact()
;
; This function checks to see if two objects have come
; into contact (such as a bullet and a robot, a bullet
; and the player, or a robot and the player.  The 2
; objects do not need to come into exact contact, but
; rather, they only need to come within a prespecified
; distance.
;
; Entry:
;   x = ptr to object to which contact is being checked.
;   a = y position to check for contact with object.
;   b = x position to check for contact with object.
;   y = ptr to table telling how close contact must be.
;
; Exit:
;   The carry bit will be set if contact was made.

CheckForContact:
       suba  ,x
       subb  1,x
       cmpa  ,y
       bgt   P0D32
       cmpa  1,y
       blt   P0D32
       cmpb  2,y
       bgt   P0D32
       cmpb  3,y
       blt   P0D32
       orcc  #$01
       rts
P0D32: andcc #$FE
       rts


; The following 3 tables define the bounding box around
; some figure (robot, player).  It is used to determine
; when something has hit the figure.  Each table contains
; the following values:
;
;     + y delta
;     - y delta
;     + x delta
;     - x delta

RobotContactBounds:
       DB    $06
       DB    $FA
       DB    $06
       DB    $FA

PlayerContactBounds:
       DB    $05
       DB    $F7
       DB    $05
       DB    $FB

PlayerContactBounds2:
       DB    $05
       DB    $FB
       DB    $05
       DB    $FB


; This function appears to do some random mucking relating
; to sound.
        OPT
DoUnknownSoundMucking:
       inc   $C877
       lda   #$0E
       sta   $C844
       sta   $C843
       sta   $C842
       lda   $C867
       bita  #$80
       beq   P0D54
       jmp   P0DF2
P0D54: bita  #$08
P0D56: beq   P0D62
       ldd   #$0080
       sta   $C877
       stb   $C867
       jmp   P0DEB
P0D62: bita  #$40
       beq   P0D69
       jmp   P0E32
P0D69: bita  #$04
       beq   P0D77
       ldd   #$0040
       sta   $C877
       stb   $C867
       jmp   P0E22
P0D77: bita  #$02
       beq   P0D85
       ldd   #$0020
       sta   $C877
       stb   $C867
       NOOPT
       jmp   P0DB2
       OPT
P0D85: bita  #$20
       beq   P0D8C
       NOOPT
       jmp   P0DC3
       OPT
P0D8C: bita  #$01
       beq   P0D9A
       ldd   #$0010
       sta   $C877
       stb   $C867
       NOOPT
       jmp   DoUnknownSoundMucking3
       OPT
P0D9A: bita  #$10
       beq   P0DA1
       NOOPT
       jmp   DoUnknownSoundMucking4
       OPT
P0DA1: lda   $C876
       bita  #$10
       beq   P0DAA
       NOOPT
       jmp   P0EAB
       OPT
P0DAA: bita  #$01
       beq   P0DB1
       NOOPT
       jmp   P0E99
       OPT
P0DB1: rts
P0DB2: ldd   #$0039
       std   $C84B
       ldd   #$0030
       std   $C849
       ldd   #$0100
       std   $C847
       bra   P0DD8
P0DC3: ldd   $C84B
       addd  #$0014
       std   $C84B
       ldd   $C849
       addd  #$0024
       std   $C849
       ldd   $C847
       addd  #$0060
       std   $C847
P0DD8: lda   #$24
P0DDA: cmpa  $C877
       bls   P0DE2
       lda   #$38
       bra   P0DE8
P0DE2: lda   #$3F
       clr   $C867
       clr   $C876
P0DE8: sta   $C845
       rts
P0DEB: ldd   #$00C0
       std   $C84B
       clr   $C86A
P0DF2: lda   $C877
       bita  #$01
       beq   P0DFF
       ldd   $C84B
       addd  #$0010
       bra   P0E04
P0DFF: ldd   $C84B
       subd  #$0013
P0E04: std   $C84B
       ldb   $C86A
       incb
       cmpb  #$08
       bls   P0E0F
       ldb   #$06
P0E0F: stb   $C86A
       lda   #$50
       mul
       std   $C849
       ldb   $C86A
       lda   #$31
       mul
       std   $C847
       lda   #$2C
       NOOPT
       jmp   P0DDA
       OPT
P0E22: ldd   #$0030
       std   $C84B
       ldd   #$0000
       std   $C849
       ldd   #$0120
       std   $C847
       rts
P0E32: ldx   #$C84B
       bsr   DoUnknownSoundMucking2
       ldx   #$C849
       bsr   DoUnknownSoundMucking2
       lda   #$18
       NOOPT
       jmp   P0DDA
       OPT


; This function appears to do some random mucking relating
; to sound.

DoUnknownSoundMucking2:
       lda   $C877
       bita  #$01
       beq   P0E4E
       ldd   ,x
       addd  #$0023
       bra   P0E53
P0E4E: ldd   ,x
       subd  #$0010
P0E53: std   ,x
       rts


; This function appears to do some random mucking relating
; to sound.

DoUnknownSoundMucking3:
       lda   #$03
       sta   $C86A
       ldd   #$0039
       std   $C84B
       ldd   #$0030
       std   $C849
       ldd   #$0040
       std   $C847
       rts


; This function appears to do some random mucking relating
; to sound.

DoUnknownSoundMucking4:
       lda   $C86A
       bmi   P0E7F
       ldb   $C877
       cmpb  #$04
       bls   P0E7F
       clr   $C877
       dec   $C86A
       ldd   #$0039
       std   $C84B
       bra   P0E86
P0E7F: ldd   $C84B
       addd  #$001A
       std   $C84B
P0E86: ldd   $C849
       addd  #$0024
       std   $C849
       ldd   $C847
       addd  #$0024
       std   $C847
       lda   #$1C
       jmp   P0DDA
P0E99: lda   #$10
       clr   $C867
       clr   $C877
       sta   $C876
       ldd   #$0000
       std   $C847
       ldd   #$0300
       std   $C84B
P0EAB: lda   $C877
       cmpa  #$06
       bls   P0EBC
       cmpa  #$0C
       bhi   P0EBC
       ldd   $C84B
       subd  #$0040
       std   $C84B
P0EBC: ldd   $C84B
       lsra
       rorb
       std   $C849
       lda   #$18
       jmp   P0DDA


; CheckForQuadrantEdgeCrossing()
;
; This function determines whether an object has crossed
; over the edge of a quadrant  this helps to determine
; when a player runs into a wall, or exits through an
; open door.  It returns a mask, which indicates which
; edge (or edges) have been crossed.
;
; Entry:
;   d = a point in the quadrant, relative to the lower left
;       corner of the quadrant.
;   x = pointer to a table of boundary conditions, which
;       tell how close the point must be to the actual
;       edge, to consider an edge crossing as having
;       occurred (these offsets are relative to the lower
;       left corner of the quadrant).  The values in this
;       table are:
;
;             yLeft, yRight, xLeft, xRight
;
; Exit:
;   b = mask (having the following meaning):
;
;         ---------------------------------
;         | 0 | 0 | 0 | 0 | B | T | R | L |
;         ---------------------------------
;
;   Bottom Edge Crossing----^
;   Top Edge Crossing-----------^
;   Right Edge Crossing-------------^
;   Left Edge Crossing------------------^

CheckForQuadrantEdgeCrossing:
       clrb
       cmpa  ,x
       bge   P0ED0
       orb   #$08
       bra   P0ED6
P0ED0: cmpa  1,x
       ble   P0ED6
       orb   #$04
P0ED6: lda   $C89C
       cmpa  2,x
       ble   P0EDF
       orb   #$02
       rts
P0EDF: cmpa  3,x
       bge   P0EE5
       orb   #$01
P0EE5: rts



; The following are all threshold tables, used when
; calling CheckForQuadrantEdgeContact()  a different
; table is used, depending upon what object is represented
; by the point (a robot, the player, a bullet, etc).
; Quadrants are all 40 wide x 64 high.
; Each of the tables is composed of the following values:
;
;     y left threshold
;     y right threshold
;     x left threshold
;     x right threshold

RobotThresholds:
       DB    $08
       DB    $38
       DB    $20
       DB    $08

PlayerThresholds:
       DB    $0A
       DB    $3C
       DB    $24
       DB    $04

BulletThresholds:
       DB    $04
       DB    $3C
       DB    $24
       DB    $04

BulletToWallThresholds:
       DB    $01
       DB    $3F
       DB    $27
       DB    $01


; DetermineMazeWalls()
;
; This function calculates the 8 walls (and the optional
; door) which are present in a maze.  The maze has 8
; internal points from which a wall can start, and fromright
; each point, the wall can go either upwards, downwards,
; to the right or to the left.  The array at C8AB will be
; filled with an integer index telling which walls are to
; be drawn (0=up, 2=down, 4=to right, 6=to left).  The
; array at C8B5 is a collection of bitmasks, indicating
; which walls are present for each quadrant (there is one
; entry in the array per quadrant).  The mask has the
; following format:
;
;              ---------------------------------
;              | 0 | 0 | 0 | 0 | B | T | R | L |
;              ---------------------------------
;   Quadrant has Bottom Wall-----^
;   Quadrant has Top Wall------------^
;   Quadrant has Right Wall--------------^
;   Quadrant has Left Wall-------------------^

DetermineMazeWalls:
       lda   #$0F
       ldu   #DefaultMazeWallsPerQuadrant
       ldx   #$C8B5
       leay  ,x
       jsr   move_block2
       leax  ,y
       ldb   #$08
       stb   $C89F
       ldu   #$C8AB
P0F0C: jsr   get_random_a
       anda  #$03
       cmpa  #$03
       blt   P0F23
       ldb   ,x       ; Draw to the left from point
       orb   #$08    ; This quad has a bottom wall, and
       stb   ,x
       ldb   5,x
       orb   #$04    ; the quad below it has a top wall
       stb   5,x
       bra   P0F53
P0F23: cmpa  #$02
       blt   P0F35
       ldb   1,x     ; Draw to the right from point
       orb   #$08   ; Next quad has a bottom wall, and
       stb   1,x
       ldb   6,x
       orb   #$04   ; Quad below it has a top wall
       stb   6,x
       bra   P0F53
P0F35: cmpa  #$01
       blt   P0F47
       ldb   5,x     ; Draw downwards from point
       orb   #$02   ; Quad below has a right wall, and
       stb   5,x
       ldb   6,x
       orb   #$01   ; quad next to it has a left wall
       stb   6,x
       bra   P0F53
P0F47: ldb   ,x      ; Draw upwards from point
       orb   #$02   ; This quad has a right wall, and
       stb   ,x
       ldb   1,x
       orb   #$01   ; quad next to it has a left wall
       stb   1,x
P0F53: asla
       sta   ,u+     ; Save the wall index
       ldb   #$05
       cmpb  $C89F
       bne   P0F5E
       leax  1,x
P0F5E: leax  1,x
       dec   $C89F
       bne   P0F0C
       rts


; DetermineDirectionToMove()
;
; This function takes a point, and returns a mask
; indicating the direction the point must travel, in
; in order to reach the player.  It also returns the
; distance (rise and run) describing how far away the
; point is from the player.
;
; Entry:
;   a = y position
;   b = x position
;
; Exit:
;   C8DE: y distance between point and player.
;   C8DF: x distance between point and player.
;   b = mask, indicating desired direction of travel
;
;              ---------------------------------
;              | 0 | 0 | x | 0 | x | x | x | x |
;              ---------------------------------
;   x and/or y is same --^
;   Down ------------------------^
;   Up ------------------------------^
;   Right -------------------------------^
;   Left ------------------------------------^

DetermineDirectionToMove:
       adda  #$80
       addb  #$80
       std   $C8E7
       lda   $C88F
       adda  #$80
       clrb
       suba  $C8E7
       beq   P0F7A
       blo   P0F7E
       orb   #$04
       bra   P0F80
P0F7A: orb   #$20
       bra   P0F80
P0F7E: orb   #$08
P0F80: nega
       sta   $C8DE
       lda   $C890
       adda  #$80
       suba  $C8E8
       sta   $C8DF
       beq   P0F92
       blo   P0F95
       orb   #$02
       rts
P0F92: orb   #$20
       rts
P0F95: orb   #$01
       rts



; MapPointToQuadrantAndMakeRelative()
;
; This function takes a point, and determines which of
; 15 quadrants it falls into.  It also maps the point
; so that it is relative to the lower left corner of the
; quadrant, and returns the bitmask indicating which walls
; are defined for this quadrant.
;
; Entry:
;   d = (y,x) position
;
; Exit:
;   C89A = quadrant (0 - 15)
;   C899 = wall bitmask
;   C89B-C89C = point, relative to lower left quad corner
;   d = point, relative to lower left quad corner
;
; where the bitmask has the following format:
;
;              ---------------------------------
;              | 0 | 0 | 0 | 0 | B | T | R | L |
;              ---------------------------------
;   Quadrant has Bottom Wall-----^
;   Quadrant has Top Wall------------^
;   Quadrant has Right Wall--------------^
;   Quadrant has Left Wall-------------------^
;
; and the quadrants are defined as follows:
;
;     -100 -60 -20 +20 +60 +100
;       --------------------- +96
;       | 0 | 1 | 2 | 3 | 4 |
;       ----+---+---+---+---- +32
;       | 5 | 6 | 7 | 8 | 9 |
;       ----+---+---+---+---- -32
;       |10 |11 |12 |13 |14 |
;       --------------------- -96

_MapPointT___:
       std   $C89B
       clrb
       cmpa  #$E0  ; -32
       bgt   P0FA3
       addb  #$0A
       bra   P0FA9
P0FA3: cmpa  #$20  ; 32
       bgt   P0FA9
       addb  #$05
P0FA9: lda   $C89C
       cmpa  #$C4  ; -60
       ble   P0FBF
       incb
       cmpa  #$EC  ; -20
       ble   P0FBF
       incb
       cmpa  #$14  ; 20
       ble   P0FBF
       incb
       cmpa  #$3C  ; 60
       ble   P0FBF
       incb
P0FBF: stb   $C89A      ; Save the quadrant number
       ldx   #$C8B5
       lda   b,x
       sta   $C899      ; Save the wall bitmask
       ldx   #RelativeOffsetConversionTable
       aslb
       ldd   b,x
       addd  $C89B
       std   $C89B      ; Make into a relative point
       rts

RelativeOffsetConversionTable:
       DB    $E0  ; Quad 0 y
       DB    $64  ; Quad 0 x
       DB    $E0  ; Quad 1 y
       DB    $3C  ; Quad 1 x
       DB    $E0  ; Quad 2 y
       DB    $14  ; Quad 2 x
       DB    $E0  ; Quad 3 y
       DB    $EC  ; Quad 3 x
       DB    $E0  ; Quad 4 y
       DB    $C4  ; Quad 4 x
       DB    $20  ; Quad 5 y
       DB    $64  ; Quad 5 x
       DB    $20  ; Quad 6 y
       DB    $3C  ; Quad 6 x
       DB    $20  ; Quad 7 y
       DB    $14  ; Quad 7 x
       DB    $20  ; Quad 8 y
       DB    $EC  ; Quad 8 x
       DB    $20  ; Quad 9 y
       DB    $C4  ; Quad 9 x
       DB    $60  ; Quad 10 y
       DB    $64  ; Quad 10 x
       DB    $60  ; Quad 11 y
       DB    $3C  ; Quad 11 x
       DB    $60  ; Quad 12 y
       DB    $14  ; Quad 12 x
       DB    $60  ; Quad 13 y
       DB    $EC  ; Quad 13 x
       DB    $60  ; Quad 14 y
       DB    $C4  ; Quad 14 x

; These appear to be unused bytes
       DB    $01
       DB    $6C
       DB    $DD
       DB    $74
       DB    $DD
       DB    $47
       DB    $96
       DB    $67
       DB    $84
       DB    $03
       DB    $97
       DB    $68
       DB    $0F
       DB    $67
       DB    $39

