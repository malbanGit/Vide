; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti art.asm >error
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
* Art Master


       include "TAFT.I"
       noopt
       direct -1
       org   $0000;
       DB    "g GCE 1983",$80;

       DW    AM_music;
       DB    $F8;* height
       DB    $40;* width
       DB    $20;* rel y
       DB    $EC;* rel x
       DB    "ART", $80;
       DB    $F8;* height
       DB    $40;* width
       DB    $04;* rel y
       DB    $E0;* rel x
       DB    "MASTER", $80, $00;

*
* Art Master
*
* This is the entry point for the Art Master game.
* It initializes the RAM area used by the game, initializes
* the music buffer, sets up the indirect jump location
* in C8A7, and lastly, passes control to the main loop.

start: nop;
       jsr   am_clear_game_RAM;
       jsr   reinit;
       jsr   init_music_buf;
       clr   $C856;
       jsr   do_sound;
       ldx   #display_main_menu;
       stx   $C8A7;
       clr   $C81E;

*
* main_loop()
*
* This main loop is responsible for reading the buttons
* on the primary console, continuing any sounds which
* are in progress, and then calling whichever handling
* routine has been set up in the indirect jump location.
* After this, it recalibrates the integraters, and then
* repeats the above.

main_loop:
       jsr   read_switches2;
       jsr   check_for_end_of_sound;
P0040: jsr   do_sound;
       lda   $C81B;     * Keep track of the fact that
       sta   $C81E;     * a string was picked last pass
       clr   $C81B;     * thru the main loop.
       jsr   [$C8A7];
P0050: jsr   waitrecal;
       jmp   main_loop;


SM_ERASE_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $30;
       DW    $005C;
       DB    "ERASE",$80;

SM_MENU_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $50;
       DW    $0068;
       DB    "MENU", $80;

SM_NEXT_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $A0;
       DW    $0073;
       DB    "NEXT", $80;

SM_LAST_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $C0;
       DW    $007E;
       DB    "LAST", $80;

SM_PLAY_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $E0;
       DW    $0089;
       DB    "PLAY", $80;

SM_CREATE_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $28;
       DW    $0094;
       DB    "CREATE", $80;


*
* The next 3 blocks of code cause the three main
* menu items (sketch, connect and animate) to be
* displayed, until one of them is picked by the
* lightpen (a pick is indicated by C89E != 0).
* When a pick occurs, the counter in C888
* is set, and the jump location (C8A7) is set so that
* only the picked option is displayed.

display_main_menu:
       jsr   intensity_to_7F;
       ldu   #MM_SKETCH_STR;
       jsr   print_with_pick_check;
       tst   $C89E;
       beq   disp_mm_connect_str;
       lda   #$0A;
       sta   $C888;
       ldx   #disp_only_mm_sketch_str;
       stx   $C8A7;
       rts;

disp_mm_connect_str:
       ldu   #MM_CONNECT_STR;
       jsr   print_with_pick_check;
       tst   $C89E;
       beq   disp_mm_animate_str;
       lda   #$0A;
       sta   $C888;
       ldx   #disp_only_mm_connect_str;
       stx   $C8A7;
       rts;

disp_mm_animate_str:
       ldu   #MM_ANIMATE_STR;
       jsr   print_with_pick_check;
       tst   $C89E;
       beq   P00E3;
       ldx   #disp_only_mm_animate_str;
       stx   $C8A7;
       lda   #$0A;
       sta   $C888;
       rts;
P00E3: rts;


*
* Continue to display the ANIMATE main menu item,
* until either the loop counter (C888) decrements
* to zero (at which point the ANIMATE activity starts),
* or the string is no longer picked (then display the
* main menu again).

disp_only_mm_animate_str:
       jsr   intensity_to_7F;
       ldu   #MM_ANIMATE_STR;
       jsr   print_with_pick_check;
       tst   $C89E;
       bne   P00F9;
       ldx   #display_main_menu;
       stx   $C8A7;
       rts;

P00F9: dec   $C888;
       beq   P00FF;
       rts;

P00FF: jmp   start_of_animate;


*
* Continue to display the SKETCH main menu item,
* until either the loop counter (C888) decrements
* to zero (at which point the SKETCH activity starts),
* or the string is no longer picked (then display the
* main menu again).

disp_only_mm_sketch_str:
       jsr   intensity_to_7F;
       ldu   #MM_SKETCH_STR;
       jsr   print_with_pick_check;
       tst   $C89E;
       bne   P0117;
       ldx   #display_main_menu;
       stx   $C8A7;
       rts;

P0117: dec   $C888;
       beq   P011D;
       rts;

P011D: clr   $C8A6;     * Flag this is sketch mode
       ldx   #start_of_sketch_connect;
       stx   $C8A7;
       rts;


*
* Continue to display the CONNECT main menu item,
* until either the loop counter (C888) decrements
* to zero (at which point the CONNECT activity starts),
* or the string is no longer picked (then display the
* main menu again).

disp_only_mm_connect_str:
       jsr   intensity_to_7F;
       ldu   #MM_CONNECT_STR;
       jsr   print_with_pick_check;
       tst   $C89E;
       bne   P013C;
       ldx   #display_main_menu;
       stx   $C8A7;
       rts;

P013C: dec   $C888;
       beq   P0142;
       rts;

P0142: lda   #$FF;
       sta   $C8A6;    * CONNECT option
       sta   $C8A5;    * Do dots first
       ldx   #start_of_sketch_connect;
       stx   $C8A7;
       rts;


HDR_CREATE_STR:
       DB    $E8;
       DB    $40;
       DB    $7F;
       DB    $E8;
       DW    $0157;
       DB    "CREATE", $80;

HDR_EDIT_STR:
       DB    $E8;
       DB    $40;
       DB    $7F;
       DB    $F0;
       DW    $0164;
       DB    "EDIT", $80;

MM_SKETCH_STR:
       DB    $E0;
       DB    $40;
       DB    $40;
       DB    $E0;
       DW    $016F;
       DB    "SKETCH", $80;

MM_CONNECT_STR:
       DB    $E0;
       DB    $40;
       DB    $00;
       DB    $DC;
       DW    $017C;
       DB    "CONNECT", $80;

MM_ANIMATE_STR:
       DB    $E0;
       DB    $40;
       DB    $C0;
       DB    $DC;
       DW    $018A;
       DB    "ANIMATE", $80;

*
* This is the vector list which describes the box
* which is sometimes drawn around a selected point.
* The list has the following format:
*
*     line pattern, rel y, rel x
*
* A line pattern of 1 signals the end.

box:
       DB    $00;
       DB    $20;
       DB    $20;
       DB    $FF;
       DB    $00;
       DB    $C0;
       DB    $FF;
       DB    $C0;
       DB    $00;
       DB    $FF;
       DB    $00;
       DB    $40;
       DB    $FF;
       DB    $40;
       DB    $00;
       DB    $01;

*
* am_clear_game_RAM()
*
* Clear to zero, the block of RAM which is used
* by the Art Master game: C880 - CB7F

am_clear_game_RAM:
       ldx   #$C880;
P01A5: clr   ,x+;
       cmpx  #$CB80;
       bne   P01A5;
       rts;


*
* draw_previous_frame()
*
* This routine gets information for the previous frame
* during ANIMATE mode.  It will then use the new
* frame number to index into the structure starting
* at C977 (the vectors for this frame), using the
* following formula:
*
* C917 = (previous_frame_num* 64) + C977
*
* Afterwards, it will draw the vectors associated with
* this frame, using a small intensity, thus allowing the
* user to see the previous frame he made.

draw_previous_frame:
       lda   $C8A5;
       bne   P01B3;
       rts;
P01B3: deca;
       ldb   #$20;
       aslb;
       mul;
       ldx   #$C977;
       leax  d,x;
       stx   $C917;
       lda   #$48;
       jsr   intensity_to_a;
       jsr   draw_all_visible_lines;
       jsr   draw_points_without_pick;
       rts;


*
* select_a_frame (frame_num)
*
* This procedure selects a particular frame
* as the active frame, and returns a pointer
* to the vector list associated with that frame
* in the 'x' register.  At entry, the 'b' register
* specifies which frame is to be selected.

select_a_frame:
       aslb;
       lda   #$20; * " "
       mul;
       ldx   #$C977;
       leax  d,x;
       rts;


*
* This is the starting point for the
* ANIMATE main menu option.

start_of_animate:
       jsr   am_clear_game_RAM;
       jsr   init_animate_variables;
       clr   $C8A3;
       clr   $C8A6;
return_to_frame1:
       clr   $C8A5;
       ldd   #$FFFF;
       std   $C910;
       ldx   #animate_handler;
       stx   $C8A7;
       rts;


*
* advance_to_next_frame()
*
* This procedure first checks to see if we will be
* entering a virgin frame (C8A5 == C8A6), and if we
* are, then it copies the data in the current frames
* vector list area into the area associated with the
* next frame.  In any case, the frame counter is
* incremented, and if this is a virgin frame, then
* C8A6 is updated to reflect the fact that we have
* now advanced into a new frame.

advance_to_next_frame:
       ldb   $C8A5;   * If C8A5 == C8A6, then init
       cmpb  $C8A6;   * the new vector list area.
       bne   P020F;
       jsr   select_a_frame;
       clrb;
P01FE: lda   <<0,x;     * Copy vector list info from
       sta   $40,x;  * current frame to new frame.
       lda   1,x;
       sta   $41,x;
       leax  2,x;
       incb;
       cmpb  #$20;
       bne   P01FE;
P020F: inc   $C8A5;  * Increment the frame counter, and
       lda   $C8A5;  * update C8A6 if this is a virgin
       cmpa  $C8A6;  * frame being entered.
       ble   P021D;
       sta   $C8A6;
P021D: ldx   #edit_handler;
       stx   $C8A7;
       rts;


*
* animate_handler()
*
* This procedure is responsible for overseeing the
* work done by the ANIMATE command.  It is invoked
* through the indirect jump location.

animate_handler:
       jsr   display_frame_num;
       jsr   reset0ref;
       ldx   #$C977;            * Reset pointer to the
       stx   $C917;              * first frame.
       clr   $C914;
       jsr   intensity_to_7F;
       jsr   find_lightpen_pick;
       jsr   draw_all_visible_lines;
       jsr   reset0ref;
       ldu   #HDR_CREATE_STR;
       jsr   am_print_string;
       ldd   $C915;         * If a vector was picked, then
       cmpd  #$FFFF;       * highlight it, by redrawing
       beq   P0269;         * it several times.
       tfr   d,u;
       jsr   draw_line_between_2_points;
       jsr   draw_line_between_2_points;
       jsr   draw_line_between_2_points;
       tst   $C815;         * If button 4 (delete) is
       beq   P0269;         * pressed, then remove the
       tfr   u,x;           * indexes for this line from
P0260: ldd   2,x;           * the line array.
       std   ,x++;
       cmpx  #$C90D;
       bne   P0260;
P0269: jsr   process_button1_and_2;
       tsta;
       beq   disp_sm_erase_str; * If button 2 was pressed,
       tst   $C813;             * then add the indexes for
       beq   disp_sm_erase_str; * the line endpoints to the
       ldd   $C910;             * line array (C8A9-C90E).
       jsr   add_a_new_line;

*
* disp_sm_erase_str()
*
* Display the ERASE sub-menu string, while the
* ANIMATE option is in CREATE mode.  If the
* string is picked (C89E != 0) while button 3
* is pressed (C814 != 0), then jump to the routine
* which re_initializes the animate buffers and
* variables; this erases the all current frames.

disp_sm_erase_str:
       jsr   check_for_move_request;
       ldu   #SM_ERASE_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   disp_sm_next_str;
       tst   $C89E;
       beq   disp_sm_next_str;
       jmp   start_of_animate;

*
* disp_sm_next_str()
*
* Display the NEXT sub-menu string, while the
* ANIMATE option is in CREATE mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then advance to the next ANIMATE frame.

disp_sm_next_str:
       ldu   #SM_NEXT_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   disp_sm_menu_str;
       tst   $C89E;
       beq   disp_sm_menu_str;
       jsr   advance_to_next_frame;
       clr   $C913;
       jsr   set_up_a_misc_sound1;
       rts;

*
* disp_sm_menu_str()
*
* Display the MENU sub-menu string, while the
* ANIMATE option is in CREATE mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then exit from ANIMATE mode, and return
* to the main menu.

disp_sm_menu_str:
       ldu   #SM_MENU_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   P02C0;
       tst   $C89E;
       beq   P02C0;
       ldx   #display_main_menu;
       stx   $C8A7;
P02C0: rts;


       DB    $E8;   * height of FR string
       DB    $40;   * width of FR string
       DB    $7F;   * rel y of FR string
       DB    $40;   * rel x of FR string
       DW    $C92A; * pointer to start of FR string


*
* edit_handler()
*
* This procedure is responsible for processing the
* buttons during the EDIT portion of ANIMATE mode.
* It also displays the EDIT header, and the sub-menu
* items (if they have not bee disabled).  This is
* invoked only through the indirect jump location.

edit_handler:
       tst   $C913;   * See if a background image
       beq   P02CF;   * needs to be displayed.
       jsr   draw_previous_frame;
P02CF: ldb   $C8A5;
       jsr   select_a_frame;
       stx   $C917;
       jsr   intensity_to_7F;
       ldb   $C8A5;
       jsr   find_lightpen_pick;
       jsr   draw_all_visible_lines;
       jsr   check_for_move_request;
       tst   $C815;   * Check button 4 (background)
       beq   P02EF;
       com   $C913;   * Toggle state of background flag
P02EF: tst   $C812;   * Check button 1 (foreground)
       beq   P02F7;
       com   $C914;   * Toggle state of foreground flag
P02F7: jsr   reset0ref;
       ldu   #HDR_EDIT_STR;   * Display EDIT screen header
       jsr   am_print_string;
       tst   $C914;   * See if sub-menu should be displayed
       beq   disp_sm_menu_str2;
       rts;


*
* display_frame_num()
*
* Display the frame number string:
*
*     "FR #",$80

display_frame_num:
       lda   #$46; * "F"
       ldb   #$52; * "R"
       std   $C92A;
       lda   #$20; * " "
       sta   $C92C;
       lda   #$80;
       sta   $C92E;
       lda   $C8A5;
       adda  #$31; * "1"
       sta   $C92D;
       ldu   #$02C1;
       jsr   reset0ref;
       jsr   delay_b_3;
       jsr   am_print_string;
       rts;


*
* disp_sm_menu_str2()
*
* Display the MENU sub-menu string, while the
* ANIMATE option is in EDIT mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then exit from ANIMATE mode, and return
* to the main menu.

disp_sm_menu_str2:
       jsr   display_frame_num;
       ldu   #SM_MENU_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   disp_sm_create_str;
       tst   $C89E;
       beq   disp_sm_create_str;
       ldx   #display_main_menu;
       stx   $C8A7;
P0345: rts;

*
* disp_sm_create_str()
*
* Display the CREATE sub-menu string, while the
* ANIMATE option is in EDIT mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then exit from EDIT mode, and return
* to CREATE mode.

disp_sm_create_str:
       ldu   #SM_CREATE_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   disp_sm_next_str2;
       tst   $C89E;
       beq   disp_sm_next_str2;
       ldu   #SM_ERASE_STR;
       stu   $C81C;
       jmp   return_to_frame1;

*
* disp_sm_next_str2()
*
* Display the NEXT sub-menu string, while the
* ANIMATE option is in EDIT mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then advance to the next frame, and
* make a sound also.

disp_sm_next_str2:
       lda   $C8A5;   * Only display this label if we
       cmpa  #$08;   * are not already at last frame
       beq   disp_sm_last_str;
       ldu   #SM_NEXT_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   disp_sm_last_str;
       tst   $C89E;
       beq   disp_sm_last_str;
       lda   $C8A5;   * Increment the frame counter
       cmpa  #$08;
       beq   disp_sm_last_str;
       jsr   advance_to_next_frame;
       jsr   set_up_a_misc_sound1;
       rts;

*
* disp_sm_last_str()
*
* Display the LAST sub-menu string, while the
* ANIMATE option is in EDIT mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then display the previous frame, and
* make a sound also.

disp_sm_last_str:
       tst   $C8A5;      * Only display this label if not
       beq   disp_sm_play_str;  * already at first frame.
       ldu   #SM_LAST_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   disp_sm_play_str;
       tst   $C89E;
       beq   disp_sm_play_str;
       tst   $C8A5;
       beq   disp_sm_play_str;
       dec   $C8A5;   * Decrement frame counter
       ldd   #$0040;
       jsr   set_up_a_misc_sound2;
       rts;

*
* disp_sm_play_str()
*
* Display the PLAY sub-menu string, while the
* ANIMATE option is in EDIT mode.  If the string
* is picked (C89E != 0) while button 3 is pressed
* (C814 != 0), then prepare to start playing through
* the current set of defined frames.

disp_sm_play_str:
       ldu   #SM_PLAY_STR;
       jsr   print_with_pick_check;
       tst   $C814;
       beq   P03C1;
       tst   $C89E;
       beq   P03C1;
       jsr   init_play_variables;
       ldx   #play_handler;
       stx   $C8A7;
P03C1: rts;


*
* check_for_move_request()
*
* This routine is responsible for checking the state
* of button 3 (move a point) during ANIMATE mode.  This
* is called by the CREATE and EDIT handlers, for each
* pass through the handler loop.
*
* C912 indicates if a move request is currently active.
* C90F contains index of currently picked point.
* C917 points to the beginning of the vector list.
*

check_for_move_request:
       lda   $C80F;   * Check for button 3 transition
       anda  #$04;   * Button 3 = move a point.
       bne   process_move;
       clr   $C912;
       rts;

process_move:
       tst   $C814;   * See if button 3 is now pressed
       beq   continue_moving_point;
       tst   $C90F;   * Make sure a point is picked
       bpl   start_moving_point;
       clr   $C912;
       rts;

start_moving_point:
       lda   #$FF;
       sta   $C912;    * Flag that move is active
       ldd   #$7F81;
       std   $C897;    * Set up new cursor movement
       ldd   #$887F;  * limits.
       std   $C899;
       ldb   $C90F;
       aslb;
       stb   $C89D;    * Save index of moving point
       ldx   $C917;
       ldd   b,x;      * Get point's coordinates
       std   $C895;
       ldu   #$C889;  * Move cursor to this point
       ldx   #$C895;
       jsr   set_cursor_structure;
       rts;

continue_moving_point:
       tst   $C912;
       bne   update_moving_point;
       rts;

update_moving_point:
       ldu   #$C889;             * Replace the location of
       jsr   update_cursor_position; * the picked point
       ldb   $C89D;                   * in the vector list.
       ldx   $C917;
       ldu   $C889;
       stu   b,x;
       jsr   reset0ref;
       tfr   u,d;
       jsr   am_move_to_d;
       ldx   #box;       * Draw the lightpen box
       ldb   #$10;      * around the picked point
       jsr   draw_with_pick_check;
       rts;


*
* process_button1_and_2()
*
* This procedure checks to see if buttons 1 or 2 are
* during animate mode.  If neither button is pressed,
* then this routine returns without doing anything.
* However, if either button is pressed, then this routine
* attempts to 'locate' the lightpen.  If C90F != $FF,
* then this implies that the lightpen is already at a
* known place (on an existing point); if C90F == $FF,
* then a series of horizontal scan lines will be drawn,
* until the lightpen is located, or the whole screen is
* scanned.
*
* At entry:
*     (C8A3)-1 contains index of next available spot
*              in the vector list.
*
* At exit time:
*     'a' register =  0 => lightpen not located.
*     'a' register = FF => lightpen located, and
*         C910 is set to index of current point, and
*         C911 is set to index of previous point.

process_button1_and_2:
       lda   $C812;   * Check if either button 1 or
       ora   $C813;   * button 2 is pressed.
       bne   P0437;
       clra;          * Lightpen not located
       rts;

P0437: lda   $C90F;   * See if the lightpen is on an
       bmi   P0448;   * existing point.
       ldb   $C910;   * YES it is, so save the index
       stb   $C911;   * this point, and the previous
       sta   $C910;   * point the lightpen picked.
       lda   #$FF;
       rts;

P0448: jsr   scan_screen_for_lightpen;
       tsta;
       bne   P0450;
       clra;          * Lightpen not located.
       rts;

P0450: lda   $C910;   * Lightpen located, so save new
       sta   $C911;   * cursor position index, and the
       lda   $C8A3;   * previous lightpen position.
       deca;
       sta   $C910;
       lda   #$FF;   * Lightpen located
       rts;


*
* scan_screen_for_lightpen()
*
* If the current frame is not filled, then this routine
* will perform a full screen scan, in an attempt to
* locate the lightpen.  If the lightpen is located, then
* its position is saved in the next location in the vector
* list for all 9 frames.
*
* At entry:
*     C917 points to the start of the vector list.
*     C8A3 contains index into next available place
*          in the vector list.
*
* At exit:
*     'a' =    0 if lightpen was not located.
*     'a' = $FF if lightpen was located.

scan_screen_for_lightpen:
       lda   $C8A3;   * See if this frame is already full
       cmpa  #$20;
       bne   P0469;
       clra;
       rts;

P0469: jsr   search_screen_for_lightpen;
       tsta;
       bne   P0471;
       clra;          * Lightpen not found
       rts;

P0471: ldu   $C917;   * Lightpen was found
       ldb   $C8A3;
       aslb;
       stx   b,u;     * Save lightpen location.
       inc   $C8A3;   * Increment vector list index.
       lda   #$08;
       leau  b,u;
P0481: leau  $40,u;  * Add this point to each of the
       stx   <<0,u;     * 8 other frames.
       deca;
       bne   P0481;
       lda   #$FF;   * Lightpen was found
       rts;


*
* find_lightpen_pick()
*
* This routine draws a dot at each endpoint for every
* vector currently defined in the frame vector list.
* if a lightpen pick is detected when a dot is drawn,
* box will be drawn around that endpoint.  The cross
* will be drawn at the last known cursor position.
*
* At entry:
*     C8A3 contains index of next available spot in
*          the vector list.
*     C910 contains index of last known cursor position.
*
* At exit:
*     C90F contains index of picked point; $FF if
*          no point was picked.
*
* Work variables:
*     C915 flags if a point was already picked.
*     C880 contains index into the vector list for the
*          next endpoint to check.
*     C881 contains index of picked point.

find_lightpen_pick:
       clr   $C915;   * Clear 'point picked' flag
       jsr   intensity_to_7F;
       clr   $C880;   * Init vector list index to 0
       lda   #$FF;
       sta   $C881;   * Init picked point index to 0
P049A: lda   $C880;
       cmpa  $C8A3;   * See if we're at end of list
       bne   check_next_endpoint;
       lda   $C881;
       sta   $C90F;   * Return index of picked point
       rts;

check_next_endpoint:
       ldu   $C917;
       jsr   reset0ref;
       ldb   $C880;
       cmpb  $C910;   * Get the index for the next point
       bne   P04D0;   * to be checked, and see if it equals
       ldx   $C8A7;   * the index of the cursor position.
       cmpx  #animate_handler;
       bne   P04D0;   * If so, then draw the cross at this
       aslb;          * location.
       ldd   b,u;
       jsr   am_move_to_d;
       ldx   #cross;
       ldb   #$10;
       jsr   draw_with_pick_check;
       jsr   reset0ref;
P04D0: ldb   $C880;
       aslb;           * Draw dot at this endpoint, and see
       ldd   b,u;      * if it was picked by the lightpen
       std   $C882;
       jsr   am_move_to_d;
       ldx   #dot_pattern;
       ldb   #$08;
       jsr   draw_with_pick_check;
       tsta;           * Check for a lightpen pick
       bne   P0502;
       tst   $C915;    * Ignore, if previous pick occurred
       bne   P0502;
       tst   $C912;    * Ignore, if a move is active
       bne   P0502;
       ldx   #box;     * Draw a box around this endpoint
       ldb   #$10;
       jsr   draw_with_pick_check;
       ldb   $C880;
       stb   $C881;    * Save index of picked point.
       inc   $C915;    * Flag that a pick occurred.
P0502: inc   $C880;
       bra   P049A;    * Loop to next point


*
* draw_points_without_pick()
*
* This routine goes through the vector list for the
* current frame, and draws a dot at each endpoint.
* Lightpen picks are ignored.

draw_points_without_pick:
       clr   $C880;
P050A: lda   $C880;   * Keep processing, until we reach
       cmpa  $C8A3;   * the end of the vector list.
       bne   P0513;
       rts;

P0513: ldu   $C917;
       jsr   reset0ref;
       ldb   $C880;
       aslb;
       ldd   b,u;
       jsr   am_move_to_d;  * Move to next endpoint, and
       ldx   #dot_pattern;   * draw a dot there.
       ldb   #$08;
       jsr   draw_with_pick_check;
       inc   $C880;
       bra   P050A;


*
* This is a set of move and draw instructions,
* which result in a cross being displayed.

cross:
       DB    $00;  * move
       DB    $20;
       DB    $00;
       DB    $FF;  * draw
       DB    $C0;
       DB    $00;
       DB    $00;  * move
       DB    $20;
       DB    $E0;
       DB    $FF;  * draw
       DB    $00;
       DB    $40;
       DB    $01;  * end of list


*
* draw_all_visible_lines()
*
* This routine draws all of the visible lines in
* the current animate frame.  While these lines are
* being drawn, any lightpen picks are saved for later
* use.
*
*     C8A9 is start of array containing indexes of
*          endpoints for each visible line.
*
* At exit:
*     C915 points to the index pair, in the line array
*          (C8A9), of the vector which was picked; $FFFF
*          if none were picked.

draw_all_visible_lines:
       ldu   #$C8A9;    * Load addr of line index array
       ldx   #$FFFF;
       stx   $C915;      * Init picked vector pointer
P0545: ldb   <<0,u;
       bpl   P054A;
       rts;

P054A: cmpb  #$7F;
       beq   P0557;
       jsr   draw_line_between_2_points;
       tsta;            * Check to see if a pick occurred,
       beq   P0557;     * and save a pointer to the endpt
       stu   $C915;     * index pair in C915, if so.
P0557: leau  2,u;
       bra   P0545;


*
* draw_line_between_2_points()
*
* Draw a line between the 2 endpoints whose index are
* pointed to by the 'u' registe.  These 2 indexes are then
* then used to index into the vector list array.  While
* drawing the line, check for a lightpen pick.
*
* At entry:
*     'u' points to the index pairs describing the
*         starting and ending points for this line.
*         The indexes are in the following format:
*             (ending pt index, starting pt index)
*
* At exit:
*     'a' = 0 => vector was not picked.
*         otherwise, the vector was picked.

draw_line_between_2_points:
       ldb   <<0,u;
       aslb;
       ldx   $C917;  * Load 'y' with coordinates for
       leay  b,x;    * line's endpoint.
       ldb   1,u;
       aslb;
       ldx   $C917;  * Load 'x' with coordinates for
       leax  b,x;    * line's starting point.
       jsr   draw_vector_with_pick_check;
       rts;


*
* init_animate_variables()
*
* This procedure initializes the block of memory
* in the range C8A9-C90E to $FF.  It is called
* when ANIMATE mode is first entered.  This block
* of memory contains the line endpoint index pairs
* for all visible lines.

init_animate_variables:
       ldx   #$C8A9;
       lda   #$FF;
P0574: sta   ,x+;
       cmpx  #$C90F;
       bne   P0574;
       rts;


*
* add_a_new_line()
*
* This routine adds the index pairs describing the
* starting and ending points for a line, to the line
* endpoint array, at C8A9-C90C.  If either of the
* indexes is $FF, or if the indexes are the same, then
* this point is not added to the array.  The indexes are
* added to the next available location.
*
* At entry:
*     a = ending point index
*     b = starting point index
*

add_a_new_line:
       ldx   #$C8A9;
P057F: cmpx  #$C90D;    * Don't bother, if array
       bne   P0585;      * is full.
P0584: rts;

P0585: tsta;             * Verify that this is a
       bmi   P0584;      * valid set of endpoint
       tstb;             * indexes.
       bmi   P0584;
       pshs  b;
       cmpa  ,s+;
       beq   P0584;
       tst   <<0,x;        * See if spot is empty
       bpl   P0598;
       std   <<0,x;
       rts;

P0598: leax  2,x;        * Spot is taken, go onto
       bra   P057F;      * next entry location.


*
* play_handler()
*
* This is the start of the PLAY command handler.
* It will cause all currently defined ANIMATE
* frames to be played in succession.

play_handler:
       lda   $C91D;      * See if the current frame's
       cmpa  $C91E;      * display duration has been
       bne   P05AA;      * reached.
       clr   $C91D;      * Reset duration counter, & goto
       jsr   get_ptrs_to_playback_frames; * next frame.
P05AA: jsr   fill_playback_buffer; * Display playback buf.
       ldx   #$C933;
       stx   $C917;
       jsr   intensity_to_7F;
       jsr   draw_all_visible_lines;
       jsr   draw_points_without_pick;
       inc   $C91D;      * Increment duration counter
       jsr   check_playback_speed_buttons;
       jsr   reset0ref;
       lda   $C80F;      * If button 1 or 2 is pressed,
       anda  #$03;      * then enter the EDIT portion
       beq   P05D2;      * of the ANIMATE code.
       ldx   #edit_handler;
       stx   $C8A7;
P05D2: rts;


*
* init_play_variables()
*
* This routine is invoked when the user initiates
* an animate 'PLAY' request.  It will initialize
* some of the globals used by the PLAY routines.

init_play_variables:
       clr   $C91D;    * Clear frame duration counter.
       lda   #$04;
       sta   $C929;    * Set default playback speed.
       jsr   update_playback_variables;
       clr   $C920;    * Set up to display 1st frame.
       clr   $C921;    * Direction flag:0=>frwd,1=>bckwd
       jsr   get_ptrs_to_playback_frames;
       rts;


*
* check_playback_speed_buttons()
*
* This routine monitors buttons 3 (slow) and
* 4 (fast) during the PLAY mode portion of the
* animate option.  The current playback speed is
* kept in C929; 0 = fastest, 7 = slowest.

check_playback_speed_buttons:
       tst   $C814;
       bne   decrease_playback_speed;
       tst   $C815;
       bne   increase_playback_speed;
       rts;

*
* decrease_playback_speed()
*
* Decrease the playback speed (by incrementing C929)

decrease_playback_speed:
       lda   $C929;
       cmpa  #$07;
       bne   P05FB;
       rts;
P05FB: inc   $C929;
       lda   $C91D;
       asla;          * Increase duration counter for
       sta   $C91D;   * this frame.
       jsr   update_playback_variables;
       rts;

*
* increase_playback_speed()
*
* Increase the playback speed (by decrementing C929)

increase_playback_speed:
       tst   $C929;
       bne   P060F;
       rts;
P060F: dec   $C929;
       lda   $C91D;
       ASRA;          * Decrease duration counter
       sta   $C91D;   * for this frame.
       jsr   update_playback_variables;
       rts;


*
* update_playback_variables()
*
* This routine uses the current playback speed, in C929,
* to index into the structure at 0632 (playback_speed_info).
* From this structure, two values are obtained: a 1 byte bit
* pattern, and a two byte jump address.  These two
* values are used by the playback routines.

update_playback_variables:
       ldx   #playback_speed_info;
       ldb   $C929;
       lda   #$03;
       mul;
       abx;
       lda   ,x+;
       sta   $C91E;
       ldd   ,x++;
       std   $C922;
       rts;

*
* Table with the following format:
*
*     1 byte value
*     2 byte subroutine address.
*
* The information here is used during the PLAY
* mode of ANIMATE.  The playback speed (in C929)
* is used to index into this structure.  An index
* of 7 is for slowest playback, and an index of 0
* is for fastest playback.

playback_speed_info:
       DB    $01;
       DW    $0720;
       DB    $02;
       DW    $071E;
       DB    $04;
       DW    $071C;
       DB    $08;
       DW    $071A;
       DB    $10;
       DW    $0718;
       DB    $20;
       DW    $0716;
       DB    $40;
       DW    $0714;
       DB    $80;
       DW    $0712;


*
* get_ptrs_to_playback_frames()
*
* This routine is used during the playback mode portion
* of animate.  If loads C924 with a pointer to the
* frame buffer for the current buffer, and C926 with a
* a pointer to the frame buffer for the next buffer to
* be displayed.  It will then increment the buffer index,
* in C920.
*
* At entry:
*     C920 contains the index of the current frame.
*
* At exit:
*     C920 is incremented to index next frame.
*     C924 points to frame buffer for current frame.
*     C926 points to frame buffer for next frame.
*

get_ptrs_to_playback_frames:
       lda   $C920;   * Load index of current frame.
       sta   $C91F;
       jsr   update_play_index_to_next_frame;
       ldx   #frame_buf_pointers;
       lda   $C91F;
       asla;
       ldd   a,x;     * Load C924 with ptr to frame buf
       std   $C924;   * for the current frame.
       lda   $C920;
       asla;
       ldd   a,x;     * Load C926 with ptr to frame buf
       std   $C926;   * for the next frame.
       rts;


*
* This is an array of word pointers.  These point
* to the beginning of the buffer area associated
* with each of the animate frames.  Each frame is
* 64 bytes long.

frame_buf_pointers:
       DW    $C977;
       DW    $C9B7;
       DW    $C9F7;
       DW    $CA37;
       DW    $CA77;
       DW    $CAB7;
       DW    $CAF7;
       DW    $CB37;
       DW    $CB77;
       DW    $CBB7;
       DW    $CBF7;


*
* update_play_index_to_next_frame()
*
* This routine updates the frame index (C920),
* to index the next frame to be displayed.  If we
* are currently displaying in the forward direction,
* then this will be incremented.  If we are currently
* displaying in the backward direction, then this will
* be decremented.  If we reach the first/last frame,
* then the direction will be changed.

update_play_index_to_next_frame:
       tst   $C921;  * Check 4 frwd/bkwd display order.
       bne   backward_order;
       lda   $C920;  * Increment, if not at last frame.
       cmpa  $C8A6;
       beq   start_backwards;
       inc   $C920;
       rts;

start_backwards:
       lda   #$FF;  * Set direction flag to 'backwards'.
       sta   $C921;
       dec   $C920;  * Decrement to previous frame.
       rts;

backward_order:
       tst   $C920;  * Decrement, if not at first frame.
       beq   start_forward;
       dec   $C920;
       rts;

start_forward
       clr   $C921;  * Set direction flag to 'forwards'.
       inc   $C920;  * Increment to next frame.
       rts;


*
* fill_playback_buffer()
*
* This routine fills the playback buffer (C933-????)
* with the (y,x) coordinate pairs for the currently
* visible frame.  It does this by taking each coordinate
* in the current frame, and the corresponding coordinate
* in the next frame, and doing some sort of extrapolation
* on them, to end up with the final endpoint.
*
* At entry:
*     C924 points to frame buffer for current frame.
*     C926 points to frame buffer for next frame.
*     C933 is start of playback buffer.
*     C8A3 specifies number of defined points in a frame.
*

fill_playback_buffer:
       ldx   $C924;    * Pointer to current frame.
       ldy   $C926;    * Ptr to next (transition) frame.
       ldu   #$C933;  * Addr of playback buffer.
       lda   $C8A3;    * # of points in frame buffer.
       sta   $C880;
P06B9: tst   $C880;
       beq   P06DB;
       lda   ,x+;      * Load both 'y' coordinates.
       ldb   ,y+;
       std   $C82E;
       jsr   merge_coordinates;
       stb   ,u+;      * Save final 'y' coordinate.
       lda   ,x+;      * Load both 'x' coordinates.
       ldb   ,y+;
       std   $C82E;
       jsr   merge_coordinates;
       stb   ,u+;      * Save final 'x' coordinate.
       dec   $C880;
       bra   P06B9;
P06DB: rts;


*
* merge_coordinates()
*
* This routine takes a pair of coordinates (2 'x' or
* 2 'y') and extrapolates a new value.  This new coordinate
* is what is displayed by the playback routine.
*
* At entry:
*     C82E has coordinate for current frame.
*     C82F has coordinate for next frame.
*
* At exit:
*     'b' contains modified coordinate.

merge_coordinates:
       ldb   $C82E;   * Get coord for current frame.
       sex;
       pshs  a,b;
       ldb   $C82F;   * Get coord for next frame.
       sex;
       subd  ,s++;
       bpl   P0701;
       negb;
       lda   $C91D;
       mul;
       jsr   [$C922];
       coma;
       comb;
       addd  #$0001;
       pshs  a,b;
       ldb   $C82E;
       sex;
       addd  ,s++;
       rts;

P0701: lda   $C91D;
       mul;
       jsr   [$C922];
       pshs  a,b;
       ldb   $C82E;
       sex;
       addd  ,s++;
       rts;


P0712: ASRA;
       rorb;
P0714: ASRA;
       rorb;
P0716: ASRA;
       rorb;
P0718: ASRA;
       rorb;
P071A: ASRA;
       rorb;
P071C: ASRA;
       rorb;
P071E: ASRA;
       rorb;
P0720: rts;


*
* search_screen_for_lightpen()
*
* This routine attempts to locate the location of the
* lightpen, by drawing a series of horizontal scan lines.
* Starting from the bottom of the display, a series of
* lines are drawn, until either a lightpen pick occurs,
* or the last scan line is drawn.  If a lightpen pick
* occurs, then that particular scan line will again be
* drawn, only this time, interrupts will be enabled, so
* that the exact location of the pick can be determined.
*
* At exit:
*     'a' =    0 if lightpen was not located.
*     'a' = $FF if lightpen was located.
*
* Work variables:
*     C881 contains the number of scan lines left to draw.
*     C882-C883 contain starting point for next scan line.

search_screen_for_lightpen:
       lda   #$7A;
       sta   $C881;    * Init # of scan lines to draw
       ldd   #$8880;
       std   $C882;    * Init start pt for first scan line
P072C: tst   $C881;
       bne   draw_scan_line;
       jsr   reset0ref;
       clra;           * If we make it to here, then the
       rts;            * lightpen was not found.

draw_scan_line:
       jsr   reset0ref;
       ldd   $C882;    * Move to start of scan line
       jsr   move_pen7F_to_d;
       clr   <$01;
       clr   <$00;
       ldb   #$FF;
       stb   <$04;
       inc   <$00;
       lda   #$7F;
       sta   <$01;
       ldd   #$FF40;
       sta   <$0A;     * Use solid line pattern.
       clr   <$05;
P0754: bitb  <$0D;
       beq   P0754;
       clr   <$0A;
       lda   #$02;    * Check for a lightpen pick
       bita  <$0D;
       bne   find_point_of_intersection;
       dec   $C881;    * No lightpen pick, so continue
       lda   $C882;    * to draw the next scan line.
       adda  #$02;    * Draw on everyother horz line.
       sta   $C882;
       bra   P072C;


*
* find_point_of_intersection()
*
* This routine is responsible for locating the exact
* location of the lightpen, after a pick has occurred
* while a scan line was being drawn.  It does this in
* the following manner:
*
*     The pen is moved back to the start of the previous
*     scan line, and lightpen interrupts are enabled.
*     Next, the scan line is redrawn; while this is going
*     on, a timing (counter) loop is executed.  If the
*     timing loop completes, then it implies that the
*     lightpen was not located; interrupts will be disabled,
*     and control will return to the procedure which had
*     originally invoked the scan line routine.
*     However, if the lightpen interrupts, then the timing
*     loop is interrupted, and the ISR handling routine is
*     called.  This handler will calculate the exact location
*     of the lightpen, using the value in the counter.  If
*     an interrupt occurs, control will never return to
*     this routine; control returns directly to the routine
*     which had invoked the scan line routine.  The location
*     of the 'pick' is returned in the 'x' register.

find_point_of_intersection:
       jsr   reset0ref;
       ldd   $C882;   * Move to start of scan line
       jsr   move_pen7F_to_d;
       andcc #$EF;   * Enable IRQ on 6809
       lda   #$82;   * Enable CA1 on PIA
       sta   <$0E;
       lda   #$7E;   * Set up IRQ handler
       sta   $CBF8;
       ldd   #ISR_handler;
       std   $CBF9;
       clr   <$01;    * Redraw the scan line
       clr   <$00;
       clr   <$04;
       nop;
       inc   <$00;
       lda   #$20;
       sta   <$01;
       lda   #$FF;
       sta   <$0A;
       ldb   #$7F;
       lda   #$05;
       sta   <$05;
P079E: decb;          * Wait for interrupt; counter loop
       brn   P079E;
       bne   P079E;
       clr   <$05;
       jsr   disable_interrupts;
       clra;          * Lightpen not found
       rts;


*
* disable_interrupts()
*
* This routine is responsible for disabling lightpen
* interrupts.
disable_interrupts:
       clra;
       sta   <$0E;  * Disable CA1 on PIA
       sta   <$01;
       sta   <$0D;
       orcc  #$10; * Disable IRQ on 6809
       jsr   reset0ref;
       rts;


*
* process_ISR()
*
* This procedure performs most of the work involved,
* whenever the lightpen generates an interrupt.  It
* uses the counter value, in the 'b' register, to
* calculate the x coordinate of the lightpen.  The
* intersection point is returned in the 'x' register.
* This routine returns to the routine which invoked
* the scan line search routine.

process_ISR:
       com   <$0A;
       clr   <$05;
       subb  #$7F;   * Calculate x coordinate
       negb;
       aslb;
       sex;
       subd  #$0080;
       lda   $C882;   * Retrieve y coordinate
       tfr   d,x;
       jsr   disable_interrupts;
       lda   #$FF;   * Lightpen found
       rts;


*
* ISR_handler()
*
* This is the entry point called by the OS, whenever the
* lightpen generates an IRQ interrupt.  This procedure
* discards the 12 bytes of saved state information
* placed on the stack by the 6809, including the return
* address for the interrupted routine.  Then it calls the
* process_ISR() routine, to process the IRQ request.

ISR_handler:
       com   <$0A;
       leas  12,s;
       jmp   process_ISR;
       DB    $12;


*
* draw_with_pick_check(vector_list, scale)
*
* This procedure will perform a series of move and
* draw requests, as specified in the passed in vector
* list.  The vector list must have the following format:
*
*     mode, rel y, rel x
*      |      |       |
*      |      |       relative x position
*      |      relative y positon
*      FF - draw
*       0 - move
*       1 - end o list
*
* NOTE: the mode also acts as the line pattern.
*
* At entry: 'x' contains pointer to the vector list.
*           'b' contains the scale factor to be used.
*
* At exit:  'a' contains the index of the point being
*               drawn when the lightpen detected a pick.
*               $FF if no pick occurred.

draw_with_pick_check:
       clr   -1,s;   * Temporary storage of current pt #
       lda   #$FF;
       sta   -2,s;   * Temporary storage of last pt picked
       stb   <$04;
P07DE: ldd   1,x;
       sta   <$01;   * Set rel y position.
       clr   <$00;
       lda   <<0,x;    * Get the mode.
       leax  3,x;    * Increment ptr to next entry.
       inc   <$00;
       stb   <$01;   * Set rel x position.
       sta   <$0A;   * Set line pattern.
       clr   <$05;
       ldd   #$0040;
P07F3: bitb  <$0D;
       beq   P07F3;
       exg   x,x;
       sta   <$0A;
       lda   <$0D;   * Check for a lightpen pick
       anda  #$02;
       beq   P0805;
       lda   -1,s;
       sta   -2,s;   * Save the current pt #.
P0805: inc   -1,s;   * Increment the current pt #
       lda   <<0,x;
       ble   P07DE;
       lda   -2,s;   * Return index if any pt picked.
       rts;


*
* This routine appears to not be used anywhere!!

P080E: sta   -2,s;
       clr   -1,s;
       stb   <$04;
P0814: ldd   1,x;
       sta   <$01;
       clr   <$00;
       lda   <<0,x;
       leax  3,x;
       inc   <$00;
       stb   <$01;
       ldb   -2,s;
       cmpb  -1,s;
       beq   P082A;
       clrb;
       clra;
P082A: sta   <$0A;
       clr   <$05;
       ldd   #$0040;
P0831: bitb  <$0D;
       beq   P0831;
       exg   x,x;
       sta   <$0A;
       inc   -1,s;
       lda   <<0,x;
       ble   P0814;
       rts;


*
* draw_vector_with_pick_check()
*
* This routine draws a vector, starting at (y,x) endpoint
* pointed to by the 'x' register, to the (y,x) endpoint
* pointed to by the 'y' register.  A value is returned
* which indicates whether or not a lightpen pick occurred
* while the vector was being drawn.
*
* At entry:
*     'x' points to (y,x) pair for starting point.
*     'y' points to (y,x) pair for ending point.
*
* At exit:
*     'a' = 0 => no pick
*                otherwise a pick occurred.

draw_vector_with_pick_check:
       jsr   reset0ref;
       lda   #$FF;
       sta   $C880;
       lda   #$01;
       sta   $C883;
       lda   <<0,x;     * Move to starting point
       sta   <$01;
       clr   <$00;
       lda   1,x;
       ldb   #$7F;
       stb   <$04;
       ldb   #$CE;
       stb   <$0C;
       inc   <$00;
       sta   <$01;
       clr   <$05;
       jsr   calculate_vector_endpoint;
       ldx   #am_scale_factors;
       ldb   b,x;
       lda   #$40;
P086D: bita  <$0D;
       beq   P086D;
       ldx   #$C880;
       jsr   draw_with_pick_check;
       coma;
       rts;


*
* calculate_vector_endpoint()
*
* This routine takes an absolute starting point, and an
* absolute ending point, and calculates the relative
* (y,x) pair for the vector between these two points.
* It also returns an index into the scale factor array,
* indicating which scale factor should be used when
* drawing the vector.
*
* At entry:
*     'y' points to (y,x) endpoint.
*     'x' points to (y,x) starting point.
*
* At exit:
*     C881-C882 contain relative (y,x) endpoint.
*     'b' contains the index of the scale factor to use.

calculate_vector_endpoint:
       lda   <<0,y;    * Determine delta y.
       suba  <<0,x;
       lbvs  P08BA;
       ldb   1,y;    * Determine delta x.
       subb  1,x;
       lbvs  P08BA;
       std   $C881;
       jsr   get_absolute_value_of_ab;
       pshs  b;
       cmpa  ,s+;
       bhs   P0897;
       tfr   b,a;
P0897: cmpa  #$3F;
       bls   P089E;
       ldb   #$02;
       rts;

P089E: cmpa  #$1F;
       bls   P08AD;
       ldd   $C881;
       asla;
       aslb;
       std   $C881;
       ldb   #$03;
       rts;

P08AD: ldd   $C881;
       asla;
       asla;
       aslb;
       aslb;
       std   $C881;
       ldb   #$04;
       rts;

P08BA: ldb   <<0,x;
       sex;
       pshs  a,b;
       ldb   <<0,y;
       sex;
       subd  ,s++;
       pshs  a,b;
       ldb   1,x;
       sex;
       pshs  a,b;
       ldb   1,y;
       sex;
       subd  ,s++;
       lsra;
       rorb;
       tfr   d,x;
       puls  a,b;
       lsra;
       rorb;
       tfr   d,y;
       tfr   y,d;
       stb   $C881;
       tfr   x,d;
       stb   $C882;
       ldb   #$01;
       rts;


am_scale_factors:
       DB    $00;
       DB    $FF;
       DB    $7F;
       DB    $3E;
       DB    $1E;

       DB    $0D;

*
* set_cursor_structure (cursor_ptr, data_ptr)
*
* This routine appears to copy the data pointer to
* by the 'x' register into the cursor structure, which
* is pointed to by the 'u' register.
* The cursor struct is 12 bytes long, and is laid out
* as follows:
*
*    ************************
*    * cursor rel y pos    *
*    ************************
*    * cursor rel x pos    *
*    ************************
*    * found this pass flag*
*    ************************\
*    * cursor y delta      * \
*    ************************  > Used when moving cursor
*    * cursor x delta      * /  to follow light pen
*    ***********************
*    * found last pass flag*
*    ************************
*    * max y position      *
*    ************************
*    * min x position      *
*    ************************
*    * min y position      *
*    ************************
*    * max x position      *
*    ************************
*    * ptr to line pattern *
*    ** array used when   **
*    * drawing search webs *
*    ************************

set_cursor_structure:
       ldd   ,x++;
       std   <<0,u;
       ldd   ,x++;
       std   6,u;
       ldd   ,x++;
       std   8,u;
       ldd   #whole_search_pattern;
       std   10,u;
       clr   5,u;
       rts;


*
* update_cursor_position()
*
* This routine attempts to move the cursor so that
* it 'stays' with  the lightpen.  First, it sees if
* the lightpen is still within 'sight' of the cursor.
* This is done by draw a series of 'spider web' patterns,
* until the lightpen is found, or the max web is drawn.
* Then it takes the deltas calculated by the search routine,
* adds them to the current cursor position, performs some
* bounds checks, and updates the line patterns used when
* drawing the search webs.

update_cursor_position:
       jsr   find_lightpen;  * Try to find lightpen.
       lda   2,u;     * Proceed only if the lightpen
       cmpa  #$FF;   * is currently at the cursor.
       bne   P0983;
       ldb   <<0,u;     * Get y position, & extend to 16 bits
       sex;
       pshs  a,b;
       ldb   3,u;     * Get new y delta
       sex;
       addd  ,s++;    * Add together
       pshs  a,b;
       ldb   6,u;     * Compare new coordinate to max y
       sex;           * value.  Use max y value, if new
       cmpd  <<0,s;     * coordinate is too big.
       bgt   P092B;
       leas  2,s;
       ldx   #lower_search_pattern;
       stx   10,u;    * Use lower search pattern
       lda   6,u;
       sta   <<0,u;
       bra   P0949;

P092B: ldb   8,u;     * Compare new coordinate to min y
       sex;           * value.  Use min y value if new
       cmpd  <<0,s;     * cordinate is too small.
       blt   P0940;
       leas  2,s;
       ldx   #upper_search_pattern;
       stx   10,u;    * Use upper search pattern
       lda   8,u;
       sta   <<0,u;
       bra   P0949;

P0940: ldd   ,s++;    * Save new y coordinate in the
       stb   <<0,u;     * cursor structure.
       ldx   #whole_search_pattern;
       stx   10,u;    * Use whole search pattern.
P0949: ldb   1,u;     * Load current x coordinate, and
       sex;           * extend it to 16 bits.
       pshs  a,b;
       ldb   4,u;
       sex;
       addd  ,s++;    * Add the new x delta.
       pshs  a,b;
       ldb   9,u;     * Compare new x coordinate to max x
       sex;           * value.  Use max value if new coord
       cmpd  <<0,s;     * is too big.
       bgt   P096A;
       leas  2,s;
       ldx   #left_search_pattern;
       stx   10,u;    * Use left search pattern
       lda   9,u;
       sta   1,u;
       bra   P0983;

P096A: ldb   7,u;     * Compare new coordinate to min x
       sex;           * value.  Use min value, if new
       cmpd  <<0,s;     * coordinate is too small.
       blt   P097F;
       leas  2,s;
       ldx   #right_search_pattern;
       stx   10,u;    * Use right search pattern
       lda   7,u;
       sta   1,u;
       bra   P0983;

P097F: ldd   ,s++;    * Save new x coordinate
       stb   1,u;
P0983: rts;


*
* find_lightpen()
*
* This routine is used by a portion of the animate code
* to locate the lightpen, so that the cursor may track
* it.  It does this in the following manner:
*
*     Firstly, it moves to the last known location of
*     the cursor, and draws a dot.  It a lightpen pick
*     occurs, then no further searching is needed; the
*     lightpen has not moved.  However, if the lightpen
*     has moved, then we must perform a more extensive
*     search.  However, if the lightpen was not found
*     the last time we searched for it, then we won't
*     bother searching for it now; we don't want to
*     continually clutter the screen with our search
*     patterns!
*
*     Secondly, we will draw a series of ever increasing
*     8 sided spider webs.  If, while drawing one of these
*     search patterns, a lightpen pick is detected, then
*     we will determine which vector of the pattern was
*     picked, and we will calculate a cursor movement
*     delta dependent upon the scale factor used and the
*     vector picked.
*
*     Depending upon the vector picked, the base delta
*     value will be either -1, <<0, or +1.  This will then
*     be multiplied by a scale value, which is obtained
*     by using the scale factor index to index into a
*     multiplier array.  The new deltas are saved in the
*     cursor structure.

find_lightpen:
       clr   2,u;     * Clear "found this pass" flag
       jsr   intensity_to_7F;
       jsr   reset0ref;
       ldd   <<0,u;     * Move to last known location
       jsr   move_pen7F_to_d;
       ldx   #dot_pattern; * Draw a dot; check for pick
       ldb   #$04;
       jsr   draw_with_pick_check;
       tsta;
       bne   search_4_lightpen;
       inc   2,u;     * Lightpen was found
       lda   #$FF;
       sta   5,u;
       rts;

search_4_lightpen:
       tst   5,u;     * Don't bother searching if lightpen
       bne   continue_lightpen_search;   * wasn't found
       rts;                              * last pass.

continue_lightpen_search:
       jsr   reset0ref;  * Draw the spider web, with an
       ldx   #small_search_pattern_vl; * increasing scale
       lda   2,u;         * factor, until either the light
       cmpa  #$04;       * pen is found, or the last scale
       blt   P09B7;       * factor is reached.
       ldx   #large_search_pattern_vl;
P09B7: ldd   <<0,u;
       jsr   move_pen7F_to_d;
       ldy   #search_pattern_scale_factors;
       lda   2,u;
       ldb   a,y;
       bne   draw_search_pattern;
       jsr   reset0ref;
       clr   2,u;          * Flag that cursor is 'lost'
       clr   5,u;          * to the lightpen.
       rts;

draw_search_pattern:
       ldy   10,u;    * Get line pattern array pointer
       jsr   display_search_pattern;
       cmpa  #$FF;   * Check for a pick.
       bne   lightpen_found;
       inc   2,u;     * Increment the scale factor.
       bra   search_4_lightpen;

lightpen_found:
       ldx   #cursor_deltas;
       deca;          * Decrement the index of the picked
       asla;          * point, & convert to word index.
       ldd   a,x;     * Load x & y delta values, and save
       std   3,u;     * in the cursor structure.
       ldx   #delta_multipliers;
       ldb   2,u;     * Use the scale factor index to get
       lda   b,x;     * the correct delta multiplier.
       pshs  a;
       ldb   3,u;     * Generate new y delta.
       jsr   generate_new_cursor_coordinate;
       stb   3,u;
       puls  a;
       ldb   4,u;     *  Generate new x delta.
       jsr   generate_new_cursor_coordinate;
       stb   4,u;
       lda   #$FF;   * Flag that the cursor is picked
       sta   2,u;
       sta   5,u;
       rts;


*
* generate_new_cursor_coordinate()
*
* This routine calulates the new cursor delta,
* by multiplying a delta value (-1, <<0, +1) by
* a scale multiplier.
*
* At entry:
*     'b' = coordinate delta.
*     'a' = scale multiplier.

generate_new_cursor_coordinate:
       pshs  b;
       tstb;
       bpl   P0A0B;
       negb;
P0A0B: mul;
       puls  a;
       tsta;
       bpl   P0A12;
       negb;
P0A12: rts;


*
* display_search_pattern()
*
* This routine draws the series of vectors, specified in
* the structure pointed to by they 'x' register.  The 'y'
* 'y' register points to an array of line patterns
* associated with each vector.  The scale factor to be used
* is specified in 'b'.  A pattern of '1' terminates this
* routine.  If a pick is detected, then the index of the
* vector being drawn is returned in the 'a' register;
* if no pick occurred, then $FF is returned.  This is used
* when drawing the spider web search patterns.
*
* At entry:
*     'b' = scale factor
*     'x' = vector list ptr (rel y, rel x)
*     'y' = line pattern array ptr
*
* At exit:
*     'a' = $FF => no pick occurred.
*           otherwise, indicates which vector was picked.

display_search_pattern:
       lda   #$FF;
       sta   $0000;
       clr   -1,s;    * Keeps track of current vector index
       lda   #$FF;
       sta   -2,s;    * Keeps index of picked vector
       stb   <$04;
P0A20: ldd   <<0,x;
       sta   <$01;
       clr   <$00;
       leax  2,x;
       inc   <$00;
       stb   <$01;
       lda   ,y+;
       sta   <$0A;
       clr   <$05;
       ldd   #$0040;
P0A35: bitb  <$0D;
       beq   P0A35;
       exg   x,x;
       sta   <$0A;
       lda   <$0D;    * Check for a lightpen pick
       anda  #$02;
       beq   P0A47;
       lda   -1,s;
       sta   -2,s;    * Save index of picked vector.
P0A47: inc   -1,s;    * Increment index.
       lda   <<0,y;
       ble   P0A20;
       lda   -2,s;    * Return index of picked vector.
       rts;


dot_pattern:
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $01;

*
* The following 5 arrays contain the line patterns
* used when drawing the spider web search pattern.
* Depending upon which set of line patterns are used,
* either the whole pattern, the left side, or right side,
* or upper portion, or lower portion will be drawn.

whole_search_pattern:
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $01;

lower_search_pattern:
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $01;

upper_search_pattern:
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $01;

right_search_pattern:
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $01;

left_search_pattern:
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $FF;
       DB    $01;

small_search_pattern_vl:
       DB    $10;
       DB    $08;
       DB    $F8;
       DB    $08;
       DB    $F0;
       DB    $00;
       DB    $F8;
       DB    $F8;
       DB    $00;
       DB    $F0;
       DB    $08;
       DB    $F8;
       DB    $10;
       DB    $00;
       DB    $08;
       DB    $08;
       DB    $00;
       DB    $10;

large_search_pattern_vl:
       DB    $40;
       DB    $20;
       DB    $E0;
       DB    $20;
       DB    $C0;
       DB    $00;
       DB    $E0;
       DB    $E0;
       DB    $00;
       DB    $C0;
       DB    $20;
       DB    $E0;
       DB    $40;
       DB    $00;
       DB    $20;
       DB    $20;
       DB    $00;
       DB    $40;

*
* These are (y,x) delta pairs, which are added
* to the cursor position, to line the cursor up
* with the lightpen.  The pair used depends upon
* which vector of the search pattern was picked.

cursor_deltas:
       DB    $01;
       DB    $01;
       DB    $00;
       DB    $01;
       DB    $FF;
       DB    $01;
       DB    $FF;
       DB    $00;
       DB    $FF;
       DB    $FF;
       DB    $00;
       DB    $FF;
       DB    $01;
       DB    $FF;
       DB    $01;
       DB    $00;

*
* This is an array of multiplier values, used when
* updating the cursors position so that is tracks
* the lightpen.  The scale factor index used to
* draw the search pattern is also used to index into
* this byte array.  As the scale factor increases, so
* does the multiplier value.

delta_multipliers:
       DB    $01;
       DB    $02;
       DB    $03;
       DB    $05;
       DB    $08;
       DB    $0B;
       DB    $0E;
       DB    $12;
       DB    $16;
       DB    $1C;

*
* This array contains the scale factors to be used
* when drawing the search patterns.

search_pattern_scale_factors:
       DB    $08;
       DB    $12;
       DB    $1E;
       DB    $2C;
       DB    $0E;
       DB    $14;
       DB    $1A;
       DB    $22;
       DB    $2C;
       DB    $38;
       DB    $00;


*
* print_with_pick_check(string_ptr)
*
* This procedure checks to see if a pick occurred
* on the previous pass through the main loop (C81E != 0).
* If a pick did not occur, then the passed in string
* is displayed.  However, if a pick did occur on the
* previous pass, then a check is made to see if this
* is the string which was picked (the string address
* is compared against that which was saved in C81C).
* If this is not the string which was last picked, then
* this string will not be displayed.  If this was the
* string which was picked, then we will display it.
* If we do display the string, then afterwards, we will
* check to see if a pick occurred, and if so, then we
* will hi-light the string, and save its address in C81C.
*
* This routine is useful for display menus with multiple
* choices.  When one choice is selected, the others will
* not be displayed.  Once a string is no longer selected,
* then all of the choices will once again be displayed.
*
* At entry: 'u' must point to the string block.

print_with_pick_check:
       inc   $C820;
       jsr   reset0ref;
       stu   $C880;
       tst   $C81E;
       beq   P0AE4;
       tfr   u,x;
       cmpx  $C81C;
       bne   P0AEC;
P0AE4: jsr   am_print_string;
       tst   $C89E;
       bne   hilite_string;
P0AEC: rts;


*
* hilite_string()
*
* This routine is used by print_with_pick_check() to
* hi-lite a string once it is picked, and to set several
* globals, so that other routine will know a pick occurred.
* The address of the string block is in C880.  A copy of
* this address will then be saved in C81C, and C89E and
* C81B will be set to one (to flag that a pick occurred).

hilite_string:
       stu   $C882;
       ldu   $C880;
       stu   $C81C;
       jsr   am_print_string;
       ldu   $C880;
       jsr   am_print_string;
       ldu   $C880;
       jsr   am_print_string;
       ldu   $C880;
       jsr   am_print_string;
       lda   #$01;
       sta   $C89E;
       sta   $C81B;
       ldu   $C882;
       tfr   u,x;
       rts;


*
* am_print_string()
*
* Prints a string of character, terminated by $80.
* At entry, the 'u' register must point to a block
* having the following format:
*
*     1 byte height of string
*     1 byte width of string
*     1 byte rel y location
*     1 byte rel x location
*     2 byte pointer to start of string
*
* At exit: C89E will be set if a pick occurred.

am_print_string:
       ldd   ,u++;
       std   $C82A;
       ldd   ,u++;
       jsr   move_pen7F_to_d;
       ldu   <<0,u;
       stu   $C82C;
       leau  -1,u;
       stu   $C84F;
       clr   <$0D;
       clr   $C89E;
       ldx   #$F9D4;
       ldd   #$1883;
       clr   <$01;
       sta   <$0B;
P0B3C: stb   <$00;
       dec   <$00;
       ldd   #$8081;
       nop;
       inc   <$00;
       stb   <$00;
       sta   <$00;
       tst   $C800;
       inc   <$00;
       lda   $C82B;
       sta   <$01;
       ldd   #$0100;
       ldu   $C82C;
       sta   <$00;
       bra   P0B62;
P0B5E: lda   a,x;
       sta   <$0A;
P0B62: lda   ,u+;
       bpl   P0B5E;
       lda   <$0D;    * Record any picks.
       anda  #$02;
       ora   $C89E;
       sta   $C89E;
       nop;
       lda   #$81;
       sta   <$00;
       neg   <$01;
       lda   #$01;
       sta   <$00;
       cmpx  #$FBB4;
       beq   P0BAD;
       leax  $50,x;
       tfr   u,d;
       subd  $C84F;
       subb  #$02;
       aslb;
       brn   P0B8D;
P0B8D: lda   #$81;
       nop;
       decb;
       bne   P0B8D;
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
       ldb   #$83;
       jmp   P0B3C;
P0BAD: lda   #$98;
       sta   <$0B;
       jmp   reset0ref;


SM_DOT_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $C0;
       DB    $0B;
       DB    $BA;
       DB    "DOT", $80;

SM_LINE_STR:
       DB    $E8;
       DB    $20;
       DB    $80;
       DB    $C0;
       DB    $0B;
       DB    $C4;
       DB    "LINE", $80;


*
* This describes the initial cursor state.

initial_cursor_state:
       DB    $00;
       DB    $00;
       DB    $78;
       DB    $88;
       DB    $90;
       DB    $78;


*
* start_of_sketch_connect()
*
* This is the starting point for the SKETCH and
* the CONNECT main menu items.

start_of_sketch_connect:
       jsr   init_sketch_connect_variables;
       ldu   #$C889;
       ldx   #initial_cursor_state;
       jsr   set_cursor_structure;
       ldx   #sketch_connect_handler;
       stx   $C8A7;

*
* sketch_connect_handler()
*
* This is the real main loop routine for the sketch
* and connect operatons.  It takes care of reading
* the buttons, and calling any button handlers, as
* needed.  It is invoked only through the indirect
* jump location, by the main loop.

sketch_connect_handler:
       clr   $C82E;
       tst   $C8A6;   * Check button 4, iff in connect mode
       beq   P0BF1;
       tst   $C815;   * Check button 4;(dot/lines)
       beq   P0BF1;
       com   $C8A5;   * Complement dot/connect flag
P0BF1: jsr   display_sc_menu;
       jsr   sketch_connect_draw_vector_list;
       ldx   #fan_handler;
       tst   $C812;   * Check button 1;(draw)
       bne   sc_start_draw;
       tst   $C8A6;   * Check button 4, iff in sketch mode
       bne   P0C09;
       tst   $C815;   * Check button 4;(fan)
       bne   sc_start_fan;
P0C09: tst   $C813;   * Check button 2;(rubber band line)
       bne   sc_start_rubber_band_line;
       rts;

*
* sc_start_draw()
* sc_start_fan()
*
* These two entry points are responsible for initializing
* things when either button 1 (draw) or button 4 (fan)
* are pressed during SKETCH or CONNECT modes.  They will
* set up a new indirect jump handler, save the current
* cursor position, and initialize some variables.

sc_start_draw:
       ldx   #sc_draw_handler;
sc_start_fan:
       lda   $C8A3;   * Don't bother, if the vector
       cmpa  #$FB;   * list is already full.
       blo   P0C1A;
       rts;

P0C1A: stx   $C8A7;   * Save new indirect jump handler.
       ldb   #$03;
       ldx   #$C8A9; * Load 'x' with pointer to next
       mul;           * free spot in the vector list
       leax  d,x;     * buffer.
       clr   <<0,x;
       ldd   $C889;   * Fill this spot, using the current
       std   1,x;     * cursor position.
       inc   $C8A3;   * Increment the vector counter.
       lda   #$05;   * # of pts to draw relative 2 starting
       sta   $C8A4;   * pt, be4 forcing new absolute ref pt.
       ldd   $C889;   * Save current cursor position.
       std   $C89B;
       std   $C82F;
       lda   #$08;
       sta   $C896;   * Stores reset value for counter.
       sta   $C895;   * Active counter; endpoint is fixed
       rts;           * when this goes to 0.


*
* sc_start_rubber_band_line()
*
* This entry point is responsible for setting up the
* indirect jump location, and initializing variables
* when button 2 (rubber band line) is pressed during
* either SKETCH or CONNECT mode.

sc_start_rubber_band_line:
       ldd   $C889;   * Save current cursor position.
       std   $C89B;
       ldx   #rubber_band_line_handler;
       lda   $C8A3;   * Don't bother if the vector list
       cmpa  #$FB;   * is already full.
       blo   P0C57;
       rts;
P0C57: stx   $C8A7;   * Save new indirect jump handler.
       rts;


*
* sc_draw_handler()
*
* This is the routine which draws lines/dots when
* button 1 is depressed.  It is invoked only through
* the indirect jump location.  It is used only when
* either SKETCH or CONNECT modes are active.

sc_draw_handler:
       jsr   display_sc_menu;
       jsr   sketch_connect_draw_vector_list;
       lda   $C80F;   * Check if button 1 is still pressed.
       anda  #$01;
       bne   P0C72;
       jsr   get_new_endpoint;
       ldx   #sketch_connect_handler;
       stx   $C8A7;
       rts;

P0C72: ldd   $C89B;  * Don't continue, if the cursor has
       cmpd  $C889;  * not moved since last point.
       bne   fix_endpoint;
       rts;

fix_endpoint:
       tst   $C895;  * Wait for counter (C895) to decrement
       beq   P0C85;  * to zero, before fixing endpoint.
       dec   $C895;
       rts;

P0C85: jsr   get_new_endpoint;
       ldd   $C889;  * Move the starting point for next
       std   $C89B;  * vector to previous vectors endpt.
       lda   $C896;
       sta   $C895;  * Reset 'fix endpoint' counter.
       rts;


*
* fan_handler()
*
* As long as the user has button 4 pressed, a fan
* pattern will be drawn.  Once button 4 is released,
* control will return to the sketch/connect handler.

fan_handler:
       lda   #$FF;   * Flag that 'fan' is being done.
       sta   $C82E;
       clr   $C8A4;
       jsr   display_sc_menu;
       jsr   sketch_connect_draw_vector_list;
       lda   $C80F;   * Check if button 4 is still pressed
       anda  #$08;
       bne   continue_drawing_fan;
       jsr   get_new_endpoint;
       ldx   #sketch_connect_handler;
       stx   $C8A7;
       clr   $C82E;
       rts;

continue_drawing_fan:
       ldd   $C89B;   * Don't add a new line, unless
       cmpd  $C889;   * the cursor position has changed.
       bne   P0CC1;
       rts;

P0CC1: tst   $C895;   * Don't fix next fan endpt, until
       beq   P0CCA;   * 'fix point' counter has decremented
       dec   $C895;   * to zero.
       rts;

P0CCA: jsr   get_new_endpoint;
       ldd   $C889;   * Set starting point for next vector
       std   $C89B;   * equal to last vectors endpoint.
       lda   $C896;
       sta   $C895;   * Reset 'fix endpoint' counter.
       rts;


*
* rubber_band_line_handler()
*
* This is the handler routine while the user is
* drawing a rubber band line during sketch or connect
* modes.  The rubber band line will continue until the
* user stops pressing button 2.  This routine is only
* invoked through the indirect jump location.

rubber_band_line_handler:
       jsr   display_sc_menu;
       jsr   sketch_connect_draw_vector_list;
       lda   $C80F;   * See if button 2 still depressed
       anda  #$02;
       bne   continue_rb_line;
       clr   $C8A4;   * Clear the relative point counter.
       jsr   get_new_endpoint;
       ldx   #sketch_connect_handler;
       stx   $C8A7;
       rts;

continue_rb_line:
       tst   $C8A6;  * Draw the rubber band line from the
       beq   P0CFE;  * originat point to the current cursor
       tst   $C8A5;  * position, unless in DOT mode.
       bne   P0D0B;
P0CFE: jsr   intensity_to_7F;
       ldx   #$C89B;
       ldy   #$C889;
       jsr   draw_vector_with_pick_check;
P0D0B: rts;


HDR_CONNECT_STR:
       DB    $E8;
       DB    $40;
       DB    $7F;
       DB    $E8;
       DB    $0D;
       DB    $12;
       DB    "CONNECT", $80;

HDR_SKETCH_STR:
       DB    $E8;
       DB    $40;
       DB    $7F;
       DB    $E8;
       DB    $0D;
       DB    $20;
       DB    "SKETCH", $80;


*
* display_sc_menu()
*
* This procedure displays either the SKETCH or CONNECT
* header (as an unpickable string), and then also displays
* the ERASE, MENU and DOT/LINE sub-items (as pickable strings)
* It then checks to see if any of these items were picked,
* and handles them is they were. Also displays the cursor.

display_sc_menu:
       jsr   intensity_to_7F;
       jsr   reset0ref;
       tst   $C8A6;   * See if in sketch or connect mode
       beq   P0D48;
       ldu   #HDR_CONNECT_STR;    * CONNECT mode
       jsr   am_print_string;
       ldu   #SM_DOT_STR;   * Display DOT or LINE item
       tst   $C8A5;
       bne   P0D43;
       ldu   #SM_LINE_STR;
P0D43: jsr   am_print_string;
       bra   P0D4E;

P0D48: ldu   #HDR_SKETCH_STR;    * SKETCH mode
       jsr   am_print_string;
P0D4E: lda   #$60;           * Draw cursor at current
       jsr   intensity_to_a; * position.
       ldd   $C889;
       jsr   am_move_to_d;
       ldx   #cross;
       ldb   #$0A;
       jsr   draw_with_pick_check;
       jsr   intensity_to_7F;
       ldu   #$C889;         * If cursor is picked, then
       tst   2,u;             * draw it brighter.
       beq   P0D7C;
       jsr   reset0ref;
       ldd   $C889;
       jsr   am_move_to_d;
       ldb   #$0A;
       ldx   #cross;
       jsr   draw_with_pick_check;
P0D7C: jsr   update_cursor_position;
       ldu   #SM_ERASE_STR;    * Print ERASE item
       jsr   print_with_pick_check;
       lda   $C80F;            * Check if button 3
       anda  #$04;            * is pressed and item is
       beq   P0D98;            * picked.
       tst   $C89E;
       beq   P0D98;
       ldx   #start_of_sketch_connect;
       stx   $C8A7;
       rts;

P0D98: ldu   #SM_MENU_STR;     * Print MENU item
       jsr   print_with_pick_check;
       lda   $C80F;            * Check if button 3 is
       anda  #$04;            * pressed and item is picked
       beq   P0DB0;
       tst   $C89E;
       beq   P0DB0;
       ldx   #display_main_menu;
       stx   $C8A7;
P0DB0: rts;


       DB    $39; * "9"


*
* gen_vec_endpoint_recal ;generate_vector_endpoint_and_recalibrate()
*
* This routine generates an endpoint for a vector.
* If the relative point counter (C8A4) has decremented
* to zero, then we will add an absolute reference point
* to the vector list, to prevent our vectors from getting
* too far out of whack; this is done after every 5 points.
*
* At entry:
*     C8A4 contains the relative point counter.
*     'a' has index of next available spot in vector list.
*     C89B contains starting point for this vector.
*     C82F contains starting point for the fan.
*     C82E flags DRAW .vs. FAN mode.
*     C8A3 has index of next available spot in vector list.
*
* At exit:
*     C881-C882 contains new vector endpoint.
*     'u' points to next available spot in vector list.

gen_vec_endpoint_recal: ;generate_vector_endpoint_and_recalibrate
       tst   $C8A4;  * If the relative pt counter has gone
       bne   P0DD6;  * to zero, then force another absolute
       ldb   #$03;  * ref point.
       ldx   #$C8A9;
       mul;
       leax  d,x;
       clr   <<0,x;    * Flag an absolute reference point.
       ldd   $C89B;  * Get starting pt for this vector; if
       tst   $C82E;  * DRAW mode, then use last cursor
       beq   P0DCC;  * position; else, use cursor position
       ldd   $C82F;  * for beginning of fan.
P0DCC: std   1,x;    * Save abs ref point.
       inc   $C8A3;  * Increment vector counter.
       lda   #$05;  * Reset the relative point counter.
       sta   $C8A4;
P0DD6: ldu   #$C8A9;
       lda   $C8A3;  * Load 'u' with pointer to current
       ldb   #$03;  * work spot in the vector list.
       mul;
       leau  d,u;
       ldx   #$C89B; * Calculate endpt for this vector.
       ldy   #$C889;
       tst   $C82E;
       beq   P0DF0;
       ldx   #$C82F;
P0DF0: jsr   calculate_vector_endpoint;
       inc   $C8A3;  * Increment vector list counter.
       dec   $C8A4;  * Decrement relative point counter.
       rts;


*
* get_new_endpoint()
*
* This routine checks to see how many vectors or dots
* we have available for use.  The current number of
* vectors or dots drawn is stored in C8A3.  If we
* have already reached the limit, then return without
* doing anything.  Otherwise, if we are close to the
* limit, then make a sound, and flag that we are close,
* by setting C829; this flag will prevent us from making
* the sound more than once.  Also, it will generate the
* scale factor and coordinates for the current vector.
* These pieces of information are then stored in the
* vector list.

get_new_endpoint:
       lda   $C8A3;   * See if we have surpassed limit
       cmpa  #$FD;
       blo   P0E02;
       rts;
P0E02: tst   $C829;   * Don't make sound more than once
       bne   P0E14;
       cmpa  #$EE;   * See if we're near limit
       blo   P0E14;
       inc   $C829;
       jsr   set_up_a_misc_sound1;
       lda   $C8A3;
P0E14: jsr   gen_vec_endpoint_recal ;generate_vector_endpoint_and_recalibrate;
       stb   <<0,u;     * Save scale factor.
       ldd   $C881;
       std   1,u;     * Save vector endpoints.
       rts;


*
* init_sketch_connect_variables()
*
* This routine is invoked when the sketch/connect
* handler is first called.  It is responsible for
* initializing the vector list residing in RAM at
* C8A9-CBA5 to $FF.  It also initializes some RAM
* locations to 0.

init_sketch_connect_variables:
       ldx   #$C8A9;
       lda   #$FF;
P0E24: sta   ,x+;
       cmpx  #$CBA6;
       bne   P0E24;
       clr   $C8A3;   * Vector counter.
       clr   $C8A4;   * Relative point counter.
       clr   $C829;   * Buffer almost full flag.
       clr   $C856;   * Sound duration.
       rts;


*
* sketch_connect_draw_vector_list()
*
* This routine goes through the vector list, performing
* all of the move and draw requests currently therein.
* It does this by drawing all of the points relative to
* to the last absolute reference point, until a new
* absolute reference point is encountered.  At this point
* it will recalibrate things, and then move to the new
* absolute reference point, and continue drawing.  This
* will continue until the end of the vector list is
* encountered.  The vector list has the following format:
*
*   scale, rel y, rel x
*
* If 'scale' is $FF, then this is the end of the list.
* If 'scale' is $00, then the corresponding (y,x) are
*     really a new absolute reference point, not relative
*     points.
* If 'scale' is positive, then draw to new point.
* If 'scale' is negative, then move to new point.

sketch_connect_draw_vector_list:
       lda   #$60;    * Set up vector intensity.
       jsr   intensity_to_a;
       ldx   #$C8A9;  * Start drawing vector list.
P0E40: jsr   draw_relative_points;
       tsta;
       beq   move_to_abs_ref_point;
       jsr   reset0ref;
       rts;

move_to_abs_ref_point:
       jsr   reset0ref;  * Reset zero reference.
       ldd   ,x++;        * Move to abs ref point.
       jsr   am_move_to_d;
       bra   P0E40;


*
* draw_relative_points()
*
* This routine draw all of the vector in the vector
* list, which are relative to the current absolute
* reference point.  When the end of the vector list
* or a new absolute reference point is encountered,
* this routine will return.
*
* At entry:
*     'x' points to the vector list.
*
* At exit:
*     'a' contains scale factor for terminating point.

draw_relative_points:
       lda   ,x+;    * Load scale factor; return if it
       bne   P0E59;  * flags a new abs reference point.
       rts;

P0E59: cmpa  #$FF;  * Check 4 the end of the vector list.
       bne   P0E5E;
       rts;

P0E5E: tst   $C8A6;  * Check for LINE or DOT mode.
       beq   sc_draw_to_point;
       tst   $C8A5;
       bne   sc_move_to_point;
sc_draw_to_point:
       tsta;         * Check for move/draw operation.
       bmi   sc_move_to_point;
       ldb   #$FF;
       stb   $C880;
       jsr   am_draw_with_pattern;
       bra   draw_relative_points;
sc_move_to_point:
       com   <$0A;
       exg   x,x;
       exg   x,x;
       com   <$0A;
       anda  #$7F;
       clr   $C880;   * Clear vector pattern.
       jsr   am_draw_with_pattern;
       com   <$0A;
       exg   x,x;
       exg   x,x;
       clr   <$0A;
       bra   draw_relative_points;


*
* am_draw_with_pattern (point, scale_index, pattern)
*
* This moves the cursor to a particular point,
* using one of several scale factors, and a line
* pattern specified in C880.
* At entry:   'x' points to vector list of rel y, relx.
*             'a' has index into scale factor array.
*             C880 has line pattern.

am_draw_with_pattern:
       ldu   #am_scale_factors;
       lda   a,u;     * Load the scale factor
       sta   <$04;
       ldd   ,x++;    * Load vector endpoints
       sta   <$01;
       clr   <$00;
       lda   $C880;   * Load line pattern from C880
       inc   <$00;
       stb   <$01;
       clr   <$05;
       sta   <$0A;
       lda   #$40;
P0EA9: bita  <$0D;
       beq   P0EA9;
       nop;
       nop;
       clr   <$0A;    * Clear the line pattern
       rts;


*
* am_move_to_d()
*
* This routine does a quick move to the point
* specified in the 'd' register (a = rel y,
* b = rel x).  A scale factor of $7F is used.

am_move_to_d:
       sta   <$01;
       clr   <$00;
       lda   #$7F;
       sta   <$04;
       lda   #$CE;
       sta   <$0C;
       lda   #$40; * "@"
       inc   <$00;
       stb   <$01;
       clr   <$05;
P0EC6: bita  <$0D;
       beq   P0EC6;
       rts;


*
* check_for_end_of_sound()
*
* This routine checks to see if the current
* miscellaneous sound has completed, by checking
* the value in C856.  When it reaches zero, the
* sound is done.

check_for_end_of_sound:
       tst   $C856;
       bne   P0ED4;
       jsr   init_music_buf;
       rts;
P0ED4: dec   $C856;
       rts;


*
* set_up_a_misc_sound1()
* set_up_a_misc_sound2(sound)
*
* Both of these routines cause a sound to be
* made.  If set_up_a_misc_sound1() is used,
* then the sound to be made is defined by
* writing the value $0050 to reg 0 & reg 1
* on the sound chip.  If set_up_a_misc_sound2()
* is used, then the value passed in in the 'd'
* register defines the sound.  The duration of
* the sound is stored in C856.

set_up_a_misc_sound1:
       ldd   #$0050;
set_up_a_misc_sound2:
       std   $C84B;
       lda   #$3E; * ">"
       sta   $C845;
       lda   #$0A;
       sta   $C844;
       lda   #$05;
       sta   $C856;
       rts;


AM_music:
        DW    $FE28;
        DW    $FEB6;
        DB    $A6;
        DB    $0A;
        DB    $10;
        DB    $98;
        DB    $0A;
        DB    $0C;
        DB    $96;
        DB    $0A;
        DB    $04;
        DB    $98;
        DB    $0C;
        DB    $10;
        DB    $96;
        DB    $0C;
        DB    $0C;
        DB    $95;
        DB    $0C;
        DB    $04;
        DB    $96;
        DB    $07;
        DB    $10;
        DB    $95;
        DB    $07;
        DB    $0C;
        DB    $93;
        DB    $07;
        DB    $04;
        DB    $95;
        DB    $1A;
        DB    $10;
        DB    $92;
        DB    $1A;
        DB    $10;
        DB    $3F; * "?"
        DB    $80;

        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $33; * "3"
        DB    $00;
        DB    $69; * "i"
        DB    $84;
        DB    $00;
        DB    $69; * "i"
        DB    $84;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"
        DB    $00;
        DB    $3B; * ";"

