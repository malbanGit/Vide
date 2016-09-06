/*
 * This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
 * Please forward any comments, corrections or additions back to Fred.
 *
 * Art Master
 */


                        .org 0x0000;
0000   67               .byte "g GCE 1983",0x80;

000B   0EEE             .word #AM_music;
000D   F8               .byte 0xF8;/* height */
000E   40               .byte 0x40;/* width  */
000F   20               .byte 0x20;/* rel y  */
0010   EC               .byte 0xEC;/* rel x  */
0011   41               .byte "ART", 0x80;
0015   F8               .byte 0xF8;/* height */
0016   40               .byte 0x40;/* width  */
0017   04               .byte 0x04;/* rel y  */
0018   E0               .byte 0xE0;/* rel x  */
0019   4D               .byte "MASTER", 0x80, 0x00;

                 /*
                  * Art Master
                  *
                  * This is the entry point for the Art Master game.
                  * It initializes the RAM area used by the game, initializes
                  * the music buffer, sets up the indirect jump location
                  * in C8A7, and lastly, passes control to the main loop.
                  */
0021   12        start: nop;
0022   BD01A2           jsr   $am_clear_game_RAM;
0025   BDF18B           jsr   $reinit;
0028   BDF533           jsr   $init_music_buf;
002B   7FC856           clr   $C856;
002E   BDF289           jsr   $do_sound;
0031   8E009B           ldx   #display_main_menu;
0034   BFC8A7           stx   $C8A7;
0037   7FC81E           clr   $C81E;

                 /*
                  * main_loop()
                  *
                  * This main loop is responsible for reading the buttons
                  * on the primary console, continuing any sounds which
                  * are in progress, and then calling whichever handling
                  * routine has been set up in the indirect jump location.
                  * After this, it recalibrates the integraters, and then
                  * repeats the above.
                  */
                 main_loop:
003A   BDF1BA           jsr   $read_switches2;
003D   BD0ECB           jsr   $check_for_end_of_sound;
0040   BDF289    P0040: jsr   $do_sound;
0043   B6C81B           lda   $C81B;     /* Keep track of the fact that */
0046   B7C81E           sta   $C81E;     /* a string was picked last pass */
0049   7FC81B           clr   $C81B;     /* thru the main loop.         */
004C   AD9FC8A7         jsr   [0xC8A7];
0050   BDF192    P0050: jsr   $waitrecal;
0053   7E003A           jmp   $main_loop;


                 SM_ERASE_STR:
0056   E8               .byte 0xE8;
0057   20               .byte 0x20;
0058   80               .byte 0x80;
0059   30               .byte 0x30;
005A   00               .word 0x005C;
005C   45               .byte "ERASE",0x80;

                 SM_MENU_STR:
0062   E8               .byte 0xE8;
0063   20               .byte 0x20;
0064   80               .byte 0x80;
0065   50               .byte 0x50;
0066   00               .word 0x0068;
0068   4D               .byte "MENU", 0x80;

                 SM_NEXT_STR:
006D   E8               .byte 0xE8;
006E   20               .byte 0x20;
006F   80               .byte 0x80;
0070   A0               .byte 0xA0;
0071   00               .word 0x0073;
0073   4E               .byte "NEXT", 0x80;

                 SM_LAST_STR:
0078   E8               .byte 0xE8;
0079   20               .byte 0x20;
007A   80               .byte 0x80;
007B   C0               .byte 0xC0;
007C   00               .word 0x007E;
007E   4C               .byte "LAST", 0x80;

                 SM_PLAY_STR:
0083   E8               .byte 0xE8;
0084   20               .byte 0x20;
0085   80               .byte 0x80;
0086   E0               .byte 0xE0;
0087   00               .word 0x0089;
0089   50               .byte "PLAY", 0x80;

                 SM_CREATE_STR:
008E   E8               .byte 0xE8;
008F   20               .byte 0x20;
0090   80               .byte 0x80;
0091   28               .byte 0x28;
0092   00               .word 0x0094;
0094   43               .byte "CREATE", 0x80;


                 /*
                  * The next 3 blocks of code cause the three main
                  * menu items (sketch, connect and animate) to be
                  * displayed, until one of them is picked by the
                  * lightpen (a pick is indicated by C89E != 0).
                  * When a pick occurs, the counter in C888
                  * is set, and the jump location (C8A7) is set so that
                  * only the picked option is displayed.
                  */
                 display_main_menu:
009B   BDF2A9           jsr   $intensity_to_7F;
009E   CE0169           ldu   #MM_SKETCH_STR;
00A1   BD0ACF           jsr   $print_with_pick_check;
00A4   7DC89E           tst   $C89E;
00A7   270C             beq   disp_mm_connect_str;
00A9   860A             lda   #0x0A;
00AB   B7C888           sta   $C888;
00AE   8E0102           ldx   #disp_only_mm_sketch_str;
00B1   BFC8A7           stx   $C8A7;
00B4   39               rts;

                 disp_mm_connect_str:
00B5   CE0176           ldu   #MM_CONNECT_STR;
00B8   BD0ACF           jsr   $print_with_pick_check;
00BB   7DC89E           tst   $C89E;
00BE   270C             beq   disp_mm_animate_str;
00C0   860A             lda   #0x0A;
00C2   B7C888           sta   $C888;
00C5   8E0127           ldx   #disp_only_mm_connect_str;
00C8   BFC8A7           stx   $C8A7;
00CB   39               rts;

                 disp_mm_animate_str:
00CC   CE0184           ldu   #MM_ANIMATE_STR;
00CF   BD0ACF           jsr   $print_with_pick_check;
00D2   7DC89E           tst   $C89E;
00D5   270C             beq   P00E3;
00D7   8E00E4           ldx   #disp_only_mm_animate_str;
00DA   BFC8A7           stx   $C8A7;
00DD   860A             lda   #0x0A;
00DF   B7C888           sta   $C888;
00E2   39               rts;
00E3   39        P00E3: rts;


                 /*
                  * Continue to display the ANIMATE main menu item,
                  * until either the loop counter (C888) decrements
                  * to zero (at which point the ANIMATE activity starts),
                  * or the string is no longer picked (then display the
                  * main menu again).
                  */
                 disp_only_mm_animate_str:
00E4   BDF2A9           jsr   $intensity_to_7F;
00E7   CE0184           ldu   #MM_ANIMATE_STR;
00EA   BD0ACF           jsr   $print_with_pick_check;
00ED   7DC89E           tst   $C89E;
00F0   2607             bne   P00F9;
00F2   8E009B           ldx   #display_main_menu;
00F5   BFC8A7           stx   $C8A7;
00F8   39               rts;

00F9   7AC888    P00F9: dec   $C888;
00FC   2701             beq   P00FF;
00FE   39               rts;

00FF   7E01D6    P00FF: jmp   $start_of_animate;


                 /*
                  * Continue to display the SKETCH main menu item,
                  * until either the loop counter (C888) decrements
                  * to zero (at which point the SKETCH activity starts),
                  * or the string is no longer picked (then display the
                  * main menu again).
                  */
                 disp_only_mm_sketch_str:
0102   BDF2A9           jsr   $intensity_to_7F;
0105   CE0169           ldu   #MM_SKETCH_STR;
0108   BD0ACF           jsr   $print_with_pick_check;
010B   7DC89E           tst   $C89E;
010E   2607             bne   P0117;
0110   8E009B           ldx   #display_main_menu;
0113   BFC8A7           stx   $C8A7;
0116   39               rts;

0117   7AC888    P0117: dec   $C888;
011A   2701             beq   P011D;
011C   39               rts;

011D   7FC8A6    P011D: clr   $C8A6;     /* Flag this is sketch mode */
0120   8E0BCF           ldx   #start_of_sketch_connect;
0123   BFC8A7           stx   $C8A7;
0126   39               rts;


                 /*
                  * Continue to display the CONNECT main menu item,
                  * until either the loop counter (C888) decrements
                  * to zero (at which point the CONNECT activity starts),
                  * or the string is no longer picked (then display the
                  * main menu again).
                  */
                 disp_only_mm_connect_str:
0127   BDF2A9           jsr   $intensity_to_7F;
012A   CE0176           ldu   #MM_CONNECT_STR;
012D   BD0ACF           jsr   $print_with_pick_check;
0130   7DC89E           tst   $C89E;
0133   2607             bne   P013C;
0135   8E009B           ldx   #display_main_menu;
0138   BFC8A7           stx   $C8A7;
013B   39               rts;

013C   7AC888    P013C: dec   $C888;
013F   2701             beq   P0142;
0141   39               rts;

0142   86FF      P0142: lda   #0xFF;
0144   B7C8A6           sta   $C8A6;    /* CONNECT option */
0147   B7C8A5           sta   $C8A5;    /* Do dots first */
014A   8E0BCF           ldx   #start_of_sketch_connect;
014D   BFC8A7           stx   $C8A7;
0150   39               rts;


                 HDR_CREATE_STR:
0151   E8               .byte 0xE8;
0152   40               .byte 0x40;
0153   7F               .byte 0x7F;
0154   E8               .byte 0xE8;
0155   01               .word 0x0157;
0157   43               .byte "CREATE", 0x80;

                 HDR_EDIT_STR:
015E   E8               .byte 0xE8;
015F   40               .byte 0x40;
0160   7F               .byte 0x7F;
0161   F0               .byte 0xF0;
0162   01               .word 0x0164;
0164   45               .byte "EDIT", 0x80;

                 MM_SKETCH_STR:
0169   E0               .byte 0xE0;
016A   40               .byte 0x40;
016B   40               .byte 0x40;
016C   E0               .byte 0xE0;
016D   01               .word 0x016F;
016F   53               .byte "SKETCH", 0x80;

                 MM_CONNECT_STR:
0176   E0               .byte 0xE0;
0177   40               .byte 0x40;
0178   00               .byte 0x00;
0179   DC               .byte 0xDC;
017A   01               .word 0x017C;
017C   43               .byte "CONNECT", 0x80;

                 MM_ANIMATE_STR:
0184   E0               .byte 0xE0;
0185   40               .byte 0x40;
0186   C0               .byte 0xC0;
0187   DC               .byte 0xDC;
0188   01               .word 0x018A;
018A   41               .byte "ANIMATE", 0x80;

                 /*
                  * This is the vector list which describes the box
                  * which is sometimes drawn around a selected point.
                  * The list has the following format:
                  *
                  *     line pattern, rel y, rel x
                  *
                  * A line pattern of 1 signals the end.
                  */
                 box:
0192   00               .byte 0x00;
0193   20               .byte 0x20;
0194   20               .byte 0x20;
0195   FF               .byte 0xFF;
0196   00               .byte 0x00;
0197   C0               .byte 0xC0;
0198   FF               .byte 0xFF;
0199   C0               .byte 0xC0;
019A   00               .byte 0x00;
019B   FF               .byte 0xFF;
019C   00               .byte 0x00;
019D   40               .byte 0x40;
019E   FF               .byte 0xFF;
019F   40               .byte 0x40;
01A0   00               .byte 0x00;
01A1   01               .byte 0x01;

                 /*
                  * am_clear_game_RAM()
                  *
                  * Clear to zero, the block of RAM which is used
                  * by the Art Master game: C880 - CB7F
                  */
                 am_clear_game_RAM:
01A2   8EC880           ldx   #0xC880;
01A5   6F80      P01A5: clr   ,x+;
01A7   8CCB80           cmpx  #0xCB80;
01AA   26F9             bne   P01A5;
01AC   39               rts;


                 /*
                  * draw_previous_frame()
                  *
                  * This routine gets information for the previous frame
                  * during ANIMATE mode.  It will then use the new
                  * frame number to index into the structure starting
                  * at C977 (the vectors for this frame), using the
                  * following formula:
                  *
                  * C917 = (previous_frame_num * 64) + C977
                  *
                  * Afterwards, it will draw the vectors associated with
                  * this frame, using a small intensity, thus allowing the
                  * user to see the previous frame he made.
                  */
                 draw_previous_frame:
01AD   B6C8A5           lda   $C8A5;
01B0   2601             bne   P01B3;
01B2   39               rts;
01B3   4A        P01B3: deca;
01B4   C620             ldb   #0x20;
01B6   58               aslb;
01B7   3D               mul;
01B8   8EC977           ldx   #0xC977;
01BB   308B             leax  d,x;
01BD   BFC917           stx   $C917;
01C0   8648             lda   #0x48;
01C2   BDF2AB           jsr   $intensity_to_a;
01C5   BD053C           jsr   $draw_all_visible_lines;
01C8   BD0507           jsr   $draw_points_without_pick;
01CB   39               rts;


                 /*
                  * select_a_frame (frame_num)
                  *
                  * This procedure selects a particular frame
                  * as the active frame, and returns a pointer
                  * to the vector list associated with that frame
                  * in the 'x' register.  At entry, the 'b' register
                  * specifies which frame is to be selected.
                  */
                 select_a_frame:
01CC   58               aslb;
01CD   8620             lda   #0x20; /* " " */
01CF   3D               mul;
01D0   8EC977           ldx   #0xC977;
01D3   308B             leax  d,x;
01D5   39               rts;


                 /*
                  * This is the starting point for the
                  * ANIMATE main menu option.
                  */
                 start_of_animate:
01D6   BD01A2           jsr   $am_clear_game_RAM;
01D9   BD056F           jsr   $init_animate_variables;
01DC   7FC8A3           clr   $C8A3;
01DF   7FC8A6           clr   $C8A6;
                 return_to_frame1:
01E2   7FC8A5           clr   $C8A5;
01E5   CCFFFF           ldd   #0xFFFF;
01E8   FDC910           std   $C910;
01EB   8E0224           ldx   #animate_handler;
01EE   BFC8A7           stx   $C8A7;
01F1   39               rts;


                 /*
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
                  */
                 advance_to_next_frame:
01F2   F6C8A5           ldb   $C8A5;   /* If C8A5 == C8A6, then init */
01F5   F1C8A6           cmpb  $C8A6;   /* the new vector list area.  */
01F8   2615             bne   P020F;
01FA   BD01CC           jsr   $select_a_frame;
01FD   5F               clrb;
01FE   A600      P01FE: lda   0,x;     /* Copy vector list info from */
0200   A78840           sta   0x40,x;  /* current frame to new frame. */
0203   A601             lda   1,x;
0205   A78841           sta   0x41,x;
0208   3002             leax  2,x;
020A   5C               incb;
020B   C120             cmpb  #0x20;
020D   26EF             bne   P01FE;
020F   7CC8A5    P020F: inc   $C8A5;  /* Increment the frame counter, and */
0212   B6C8A5           lda   $C8A5;  /* update C8A6 if this is a virgin  */
0215   B1C8A6           cmpa  $C8A6;  /* frame being entered.             */
0218   2F03             ble   P021D;
021A   B7C8A6           sta   $C8A6;
021D   8E02C7    P021D: ldx   #edit_handler;
0220   BFC8A7           stx   $C8A7;
0223   39               rts;


                 /*
                  * animate_handler()
                  *
                  * This procedure is responsible for overseeing the
                  * work done by the ANIMATE command.  It is invoked
                  * through the indirect jump location.
                  */
                 animate_handler:
0224   BD0306           jsr   $display_frame_num;
0227   BDF354           jsr   $reset0ref;
022A   8EC977           ldx   #0xC977;            /* Reset pointer to the */
022D   BFC917           stx   $C917;              /* first frame.         */
0230   7FC914           clr   $C914;
0233   BDF2A9           jsr   $intensity_to_7F;
0236   BD048C           jsr   $find_lightpen_pick;
0239   BD053C           jsr   $draw_all_visible_lines;
023C   BDF354           jsr   $reset0ref;
023F   CE0151           ldu   #HDR_CREATE_STR;
0242   BD0B19           jsr   $am_print_string;
0245   FCC915           ldd   $C915;         /* If a vector was picked, then */
0248   1083FFFF         cmpd  #0xFFFF;       /* highlight it, by redrawing   */
024C   271B             beq   P0269;         /* it several times.            */
024E   1F03             tfr   d,u;
0250   BD055B           jsr   $draw_line_between_2_points;
0253   BD055B           jsr   $draw_line_between_2_points;
0256   BD055B           jsr   $draw_line_between_2_points;
0259   7DC815           tst   $C815;         /* If button 4 (delete) is  */
025C   270B             beq   P0269;         /* pressed, then remove the */
025E   1F31             tfr   u,x;           /* indexes for this line from */
0260   EC02      P0260: ldd   2,x;           /* the line array.          */
0262   ED81             std   ,x++;
0264   8CC90D           cmpx  #0xC90D;
0267   26F7             bne   P0260;
0269   BD042D    P0269: jsr   $process_button1_and_2;
026C   4D               tsta;
026D   270B             beq   disp_sm_erase_str; /* If button 2 was pressed, */
026F   7DC813           tst   $C813;             /* then add the indexes for */
0272   2706             beq   disp_sm_erase_str; /* the line endpoints to the*/
0274   FCC910           ldd   $C910;             /* line array (C8A9-C90E).  */
0277   BD057C           jsr   $add_a_new_line;

                 /*
                  * disp_sm_erase_str()
                  *
                  * Display the ERASE sub-menu string, while the
                  * ANIMATE option is in CREATE mode.  If the
                  * string is picked (C89E != 0) while button 3
                  * is pressed (C814 != 0), then jump to the routine
                  * which re_initializes the animate buffers and
                  * variables; this erases the all current frames.
                  */
                 disp_sm_erase_str:
027A   BD03C2           jsr   $check_for_move_request;
027D   CE0056           ldu   #SM_ERASE_STR;
0280   BD0ACF           jsr   $print_with_pick_check;
0283   7DC814           tst   $C814;
0286   2708             beq   disp_sm_next_str;
0288   7DC89E           tst   $C89E;
028B   2703             beq   disp_sm_next_str;
028D   7E01D6           jmp   $start_of_animate;

                 /*
                  * disp_sm_next_str()
                  *
                  * Display the NEXT sub-menu string, while the
                  * ANIMATE option is in CREATE mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then advance to the next ANIMATE frame.
                  */
                 disp_sm_next_str:
0290   CE006D           ldu   #SM_NEXT_STR;
0293   BD0ACF           jsr   $print_with_pick_check;
0296   7DC814           tst   $C814;
0299   270F             beq   disp_sm_menu_str;
029B   7DC89E           tst   $C89E;
029E   270A             beq   disp_sm_menu_str;
02A0   BD01F2           jsr   $advance_to_next_frame;
02A3   7FC913           clr   $C913;
02A6   BD0ED8           jsr   $set_up_a_misc_sound1;
02A9   39               rts;

                 /*
                  * disp_sm_menu_str()
                  *
                  * Display the MENU sub-menu string, while the
                  * ANIMATE option is in CREATE mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then exit from ANIMATE mode, and return
                  * to the main menu.
                  */
                 disp_sm_menu_str:
02AA   CE0062           ldu   #SM_MENU_STR;
02AD   BD0ACF           jsr   $print_with_pick_check;
02B0   7DC814           tst   $C814;
02B3   270B             beq   P02C0;
02B5   7DC89E           tst   $C89E;
02B8   2706             beq   P02C0;
02BA   8E009B           ldx   #display_main_menu;
02BD   BFC8A7           stx   $C8A7;
02C0   39        P02C0: rts;


02C1   E8               .byte 0xE8;   /* height of FR string */
02C2   40               .byte 0x40;   /* width of FR string */
02C3   7F               .byte 0x7F;   /* rel y of FR string */
02C4   40               .byte 0x40;   /* rel x of FR string */
02C5   C92A             .word 0xC92A; /* pointer to start of FR string */


                 /*
                  * edit_handler()
                  *
                  * This procedure is responsible for processing the
                  * buttons during the EDIT portion of ANIMATE mode.
                  * It also displays the EDIT header, and the sub-menu
                  * items (if they have not bee disabled).  This is
                  * invoked only through the indirect jump location.
                  */
                 edit_handler:
02C7   7DC913           tst   $C913;   /* See if a background image */
02CA   2703             beq   P02CF;   /* needs to be displayed.    */
02CC   BD01AD           jsr   $draw_previous_frame;
02CF   F6C8A5    P02CF: ldb   $C8A5;
02D2   BD01CC           jsr   $select_a_frame;
02D5   BFC917           stx   $C917;
02D8   BDF2A9           jsr   $intensity_to_7F;
02DB   F6C8A5           ldb   $C8A5;
02DE   BD048C           jsr   $find_lightpen_pick;
02E1   BD053C           jsr   $draw_all_visible_lines;
02E4   BD03C2           jsr   $check_for_move_request;
02E7   7DC815           tst   $C815;   /* Check button 4 (background) */
02EA   2703             beq   P02EF;
02EC   73C913           com   $C913;   /* Toggle state of background flag */
02EF   7DC812    P02EF: tst   $C812;   /* Check button 1 (foreground) */
02F2   2703             beq   P02F7;
02F4   73C914           com   $C914;   /* Toggle state of foreground flag */
02F7   BDF354    P02F7: jsr   $reset0ref;
02FA   CE015E           ldu   #HDR_EDIT_STR;   /* Display EDIT screen header */
02FD   BD0B19           jsr   $am_print_string;
0300   7DC914           tst   $C914;   /* See if sub-menu should be displayed */
0303   2727             beq   disp_sm_menu_str2;
0305   39               rts;


                 /*
                  * display_frame_num()
                  *
                  * Display the frame number string:
                  *
                  *     "FR #",0x80
                  */
                 display_frame_num:
0306   8646             lda   #0x46; /* "F" */
0308   C652             ldb   #0x52; /* "R" */
030A   FDC92A           std   $C92A;
030D   8620             lda   #0x20; /* " " */
030F   B7C92C           sta   $C92C;
0312   8680             lda   #0x80;
0314   B7C92E           sta   $C92E;
0317   B6C8A5           lda   $C8A5;
031A   8B31             adda  #0x31; /* "1" */
031C   B7C92D           sta   $C92D;
031F   CE02C1           ldu   #0x02C1;
0322   BDF354           jsr   $reset0ref;
0325   BDF56D           jsr   $delay_b_3;
0328   BD0B19           jsr   $am_print_string;
032B   39               rts;


                 /*
                  * disp_sm_menu_str2()
                  *
                  * Display the MENU sub-menu string, while the
                  * ANIMATE option is in EDIT mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then exit from ANIMATE mode, and return
                  * to the main menu.
                  */
                 disp_sm_menu_str2:
032C   BD0306           jsr   $display_frame_num;
032F   CE0062           ldu   #SM_MENU_STR;
0332   BD0ACF           jsr   $print_with_pick_check;
0335   7DC814           tst   $C814;
0338   270C             beq   disp_sm_create_str;
033A   7DC89E           tst   $C89E;
033D   2707             beq   disp_sm_create_str;
033F   8E009B           ldx   #display_main_menu;
0342   BFC8A7           stx   $C8A7;
0345   39        P0345: rts;

                 /*
                  * disp_sm_create_str()
                  *
                  * Display the CREATE sub-menu string, while the
                  * ANIMATE option is in EDIT mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then exit from EDIT mode, and return
                  * to CREATE mode.
                  */
                 disp_sm_create_str:
0346   CE008E           ldu   #SM_CREATE_STR;
0349   BD0ACF           jsr   $print_with_pick_check;
034C   7DC814           tst   $C814;
034F   270E             beq   disp_sm_next_str2;
0351   7DC89E           tst   $C89E;
0354   2709             beq   disp_sm_next_str2;
0356   CE0056           ldu   #SM_ERASE_STR;
0359   FFC81C           stu   $C81C;
035C   7E01E2           jmp   $return_to_frame1;

                 /*
                  * disp_sm_next_str2()
                  *
                  * Display the NEXT sub-menu string, while the
                  * ANIMATE option is in EDIT mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then advance to the next frame, and
                  * make a sound also.
                  */
                 disp_sm_next_str2:
035F   B6C8A5           lda   $C8A5;   /* Only display this label if we */
0362   8108             cmpa  #0x08;   /* are not already at last frame */
0364   271E             beq   disp_sm_last_str;
0366   CE006D           ldu   #SM_NEXT_STR;
0369   BD0ACF           jsr   $print_with_pick_check;
036C   7DC814           tst   $C814;
036F   2713             beq   disp_sm_last_str;
0371   7DC89E           tst   $C89E;
0374   270E             beq   disp_sm_last_str;
0376   B6C8A5           lda   $C8A5;   /* Increment the frame counter */
0379   8108             cmpa  #0x08;
037B   2707             beq   disp_sm_last_str;
037D   BD01F2           jsr   $advance_to_next_frame;
0380   BD0ED8           jsr   $set_up_a_misc_sound1;
0383   39               rts;

                 /*
                  * disp_sm_last_str()
                  *
                  * Display the LAST sub-menu string, while the
                  * ANIMATE option is in EDIT mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then display the previous frame, and
                  * make a sound also.
                  */
                 disp_sm_last_str:
0384   7DC8A5           tst   $C8A5;      /* Only display this label if not */
0387   271F             beq   disp_sm_play_str;  /* already at first frame. */
0389   CE0078           ldu   #SM_LAST_STR;
038C   BD0ACF           jsr   $print_with_pick_check;
038F   7DC814           tst   $C814;
0392   2714             beq   disp_sm_play_str;
0394   7DC89E           tst   $C89E;
0397   270F             beq   disp_sm_play_str;
0399   7DC8A5           tst   $C8A5;
039C   270A             beq   disp_sm_play_str;
039E   7AC8A5           dec   $C8A5;   /* Decrement frame counter */
03A1   CC0040           ldd   #0x0040;
03A4   BD0EDB           jsr   $set_up_a_misc_sound2;
03A7   39               rts;

                 /*
                  * disp_sm_play_str()
                  *
                  * Display the PLAY sub-menu string, while the
                  * ANIMATE option is in EDIT mode.  If the string
                  * is picked (C89E != 0) while button 3 is pressed
                  * (C814 != 0), then prepare to start playing through
                  * the current set of defined frames.
                  */
                 disp_sm_play_str:
03A8   CE0083           ldu   #SM_PLAY_STR;
03AB   BD0ACF           jsr   $print_with_pick_check;
03AE   7DC814           tst   $C814;
03B1   270E             beq   P03C1;
03B3   7DC89E           tst   $C89E;
03B6   2709             beq   P03C1;
03B8   BD05D3           jsr   $init_play_variables;
03BB   8E059C           ldx   #play_handler;
03BE   BFC8A7           stx   $C8A7;
03C1   39        P03C1: rts;


                 /*
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
                  */
                 check_for_move_request:
03C2   B6C80F           lda   $C80F;   /* Check for button 3 transition */
03C5   8404             anda  #0x04;   /* Button 3 = move a point.      */
03C7   2604             bne   process_move;
03C9   7FC912           clr   $C912;
03CC   39               rts;

                 process_move:
03CD   7DC814           tst   $C814;   /* See if button 3 is now pressed */
03D0   2733             beq   continue_moving_point;
03D2   7DC90F           tst   $C90F;   /* Make sure a point is picked */
03D5   2A04             bpl   start_moving_point;
03D7   7FC912           clr   $C912;
03DA   39               rts;

                 start_moving_point:
03DB   86FF             lda   #0xFF;
03DD   B7C912           sta   $C912;    /* Flag that move is active */
03E0   CC7F81           ldd   #0x7F81;
03E3   FDC897           std   $C897;    /* Set up new cursor movement */
03E6   CC887F           ldd   #0x887F;  /* limits.                    */
03E9   FDC899           std   $C899;
03EC   F6C90F           ldb   $C90F;
03EF   58               aslb;
03F0   F7C89D           stb   $C89D;    /* Save index of moving point */
03F3   BEC917           ldx   $C917;
03F6   EC85             ldd   b,x;      /* Get point's coordinates */
03F8   FDC895           std   $C895;
03FB   CEC889           ldu   #0xC889;  /* Move cursor to this point */
03FE   8EC895           ldx   #0xC895;
0401   BD08ED           jsr   $set_cursor_structure;
0404   39               rts;

                 continue_moving_point:
0405   7DC912           tst   $C912;
0408   2601             bne   update_moving_point;
040A   39               rts;

                 update_moving_point:
040B   CEC889           ldu   #0xC889;             /* Replace the location of */
040E   BD0901           jsr   $update_cursor_position; /* the picked point */
0411   F6C89D           ldb   $C89D;                   /* in the vector list. */
0414   BEC917           ldx   $C917;
0417   FEC889           ldu   $C889;
041A   EF85             stu   b,x;
041C   BDF354           jsr   $reset0ref;
041F   1F30             tfr   u,d;
0421   BD0EB2           jsr   $am_move_to_d;
0424   8E0192           ldx   #box;       /* Draw the lightpen box */
0427   C610             ldb   #0x10;      /* around the picked point */
0429   BD07D6           jsr   $draw_with_pick_check;
042C   39               rts;


                 /*
                  * process_button1_and_2()
                  *
                  * This procedure checks to see if buttons 1 or 2 are
                  * during animate mode.  If neither button is pressed,
                  * then this routine returns without doing anything.
                  * However, if either button is pressed, then this routine
                  * attempts to 'locate' the lightpen.  If C90F != 0xFF,
                  * then this implies that the lightpen is already at a
                  * known place (on an existing point); if C90F == 0xFF,
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
                  */
                 process_button1_and_2:
042D   B6C812           lda   $C812;   /* Check if either button 1 or */
0430   BAC813           ora   $C813;   /* button 2 is pressed.        */
0433   2602             bne   P0437;
0435   4F               clra;          /* Lightpen not located */
0436   39               rts;

0437   B6C90F    P0437: lda   $C90F;   /* See if the lightpen is on an */
043A   2B0C             bmi   P0448;   /* existing point.              */
043C   F6C910           ldb   $C910;   /* YES it is, so save the index */
043F   F7C911           stb   $C911;   /* this point, and the previous */
0442   B7C910           sta   $C910;   /* point the lightpen picked.   */
0445   86FF             lda   #0xFF;
0447   39               rts;

0448   BD0460    P0448: jsr   $scan_screen_for_lightpen;
044B   4D               tsta;
044C   2602             bne   P0450;
044E   4F               clra;          /* Lightpen not located.        */
044F   39               rts;

0450   B6C910    P0450: lda   $C910;   /* Lightpen located, so save new */
0453   B7C911           sta   $C911;   /* cursor position index, and the */
0456   B6C8A3           lda   $C8A3;   /* previous lightpen position.   */
0459   4A               deca;
045A   B7C910           sta   $C910;
045D   86FF             lda   #0xFF;   /* Lightpen located */
045F   39               rts;


                 /*
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
                  *     'a' = 0xFF if lightpen was located.
                  */
                 scan_screen_for_lightpen:
0460   B6C8A3           lda   $C8A3;   /* See if this frame is already full */
0463   8120             cmpa  #0x20;
0465   2602             bne   P0469;
0467   4F               clra;
0468   39               rts;

0469   BD0721    P0469: jsr   $search_screen_for_lightpen;
046C   4D               tsta;
046D   2602             bne   P0471;
046F   4F               clra;          /* Lightpen not found */
0470   39               rts;

0471   FEC917    P0471: ldu   $C917;   /* Lightpen was found */
0474   F6C8A3           ldb   $C8A3;
0477   58               aslb;
0478   AFC5             stx   b,u;     /* Save lightpen location. */
047A   7CC8A3           inc   $C8A3;   /* Increment vector list index. */
047D   8608             lda   #0x08;
047F   33C5             leau  b,u;
0481   33C840    P0481: leau  0x40,u;  /* Add this point to each of the */
0484   AF40             stx   0,u;     /* 8 other frames.               */
0486   4A               deca;
0487   26F8             bne   P0481;
0489   86FF             lda   #0xFF;   /* Lightpen was found */
048B   39               rts;


                 /*
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
                  *     C90F contains index of picked point; 0xFF if
                  *          no point was picked.
                  *
                  * Work variables:
                  *     C915 flags if a point was already picked.
                  *     C880 contains index into the vector list for the
                  *          next endpoint to check.
                  *     C881 contains index of picked point.
                  */
                 find_lightpen_pick:
048C   7FC915           clr   $C915;   /* Clear 'point picked' flag */
048F   BDF2A9           jsr   $intensity_to_7F;
0492   7FC880           clr   $C880;   /* Init vector list index to 0 */
0495   86FF             lda   #0xFF;
0497   B7C881           sta   $C881;   /* Init picked point index to 0 */
049A   B6C880    P049A: lda   $C880;
049D   B1C8A3           cmpa  $C8A3;   /* See if we're at end of list */
04A0   2607             bne   check_next_endpoint;
04A2   B6C881           lda   $C881;
04A5   B7C90F           sta   $C90F;   /* Return index of picked point */
04A8   39               rts;

                 check_next_endpoint:
04A9   FEC917           ldu   $C917;
04AC   BDF354           jsr   $reset0ref;
04AF   F6C880           ldb   $C880;
04B2   F1C910           cmpb  $C910;   /* Get the index for the next point */
04B5   2619             bne   P04D0;   /* to be checked, and see if it equals */
04B7   BEC8A7           ldx   $C8A7;   /* the index of the cursor position. */
04BA   8C0224           cmpx  #animate_handler;
04BD   2611             bne   P04D0;   /* If so, then draw the cross at this */
04BF   58               aslb;          /* location.                          */
04C0   ECC5             ldd   b,u;
04C2   BD0EB2           jsr   $am_move_to_d;
04C5   8E052F           ldx   #cross;
04C8   C610             ldb   #0x10;
04CA   BD07D6           jsr   $draw_with_pick_check;
04CD   BDF354           jsr   $reset0ref;
04D0   F6C880    P04D0: ldb   $C880;
04D3   58               aslb;           /* Draw dot at this endpoint, and see */
04D4   ECC5             ldd   b,u;      /* if it was picked by the lightpen */
04D6   FDC882           std   $C882;
04D9   BD0EB2           jsr   $am_move_to_d;
04DC   8E0A50           ldx   #dot_pattern;
04DF   C608             ldb   #0x08;
04E1   BD07D6           jsr   $draw_with_pick_check;
04E4   4D               tsta;           /* Check for a lightpen pick */
04E5   261B             bne   P0502;
04E7   7DC915           tst   $C915;    /* Ignore, if previous pick occurred */
04EA   2616             bne   P0502;
04EC   7DC912           tst   $C912;    /* Ignore, if a move is active */
04EF   2611             bne   P0502;
04F1   8E0192           ldx   #box;     /* Draw a box around this endpoint */
04F4   C610             ldb   #0x10;
04F6   BD07D6           jsr   $draw_with_pick_check;
04F9   F6C880           ldb   $C880;
04FC   F7C881           stb   $C881;    /* Save index of picked point. */
04FF   7CC915           inc   $C915;    /* Flag that a pick occurred.  */
0502   7CC880    P0502: inc   $C880;
0505   2093             bra   P049A;    /* Loop to next point */


                 /*
                  * draw_points_without_pick()
                  *
                  * This routine goes through the vector list for the
                  * current frame, and draws a dot at each endpoint.
                  * Lightpen picks are ignored.
                  */
                 draw_points_without_pick:
0507   7FC880           clr   $C880;
050A   B6C880    P050A: lda   $C880;   /* Keep processing, until we reach */
050D   B1C8A3           cmpa  $C8A3;   /* the end of the vector list.     */
0510   2601             bne   P0513;
0512   39               rts;

0513   FEC917    P0513: ldu   $C917;
0516   BDF354           jsr   $reset0ref;
0519   F6C880           ldb   $C880;
051C   58               aslb;
051D   ECC5             ldd   b,u;
051F   BD0EB2           jsr   $am_move_to_d;  /* Move to next endpoint, and */
0522   8E0A50           ldx   #dot_pattern;   /* draw a dot there.          */
0525   C608             ldb   #0x08;
0527   BD07D6           jsr   $draw_with_pick_check;
052A   7CC880           inc   $C880;
052D   20DB             bra   P050A;


                 /*
                  * This is a set of move and draw instructions,
                  * which result in a cross being displayed.
                  */
                 cross:
052F   00               .byte 0x00;  /* move */
0530   20               .byte 0x20;
0531   00               .byte 0x00;
0532   FF               .byte 0xFF;  /* draw */
0533   C0               .byte 0xC0;
0534   00               .byte 0x00;
0535   00               .byte 0x00;  /* move */
0536   20               .byte 0x20;
0537   E0               .byte 0xE0;
0538   FF               .byte 0xFF;  /* draw */
0539   00               .byte 0x00;
053A   40               .byte 0x40;
053B   01               .byte 0x01;  /* end of list */


                 /*
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
                  *          (C8A9), of the vector which was picked; 0xFFFF
                  *          if none were picked.
                  */
                 draw_all_visible_lines:
053C   CEC8A9           ldu   #0xC8A9;    /* Load addr of line index array */
053F   8EFFFF           ldx   #0xFFFF;
0542   BFC915           stx   $C915;      /* Init picked vector pointer */
0545   E640      P0545: ldb   0,u;
0547   2A01             bpl   P054A;
0549   39               rts;

054A   C17F      P054A: cmpb  #0x7F;
054C   2709             beq   P0557;
054E   BD055B           jsr   $draw_line_between_2_points;
0551   4D               tsta;            /* Check to see if a pick occurred, */
0552   2703             beq   P0557;     /* and save a pointer to the endpt  */
0554   FFC915           stu   $C915;     /* index pair in C915, if so.       */
0557   3342      P0557: leau  2,u;
0559   20EA             bra   P0545;


                 /*
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
                  */
                 draw_line_between_2_points:
055B   E640             ldb   0,u;
055D   58               aslb;
055E   BEC917           ldx   $C917;  /* Load 'y' with coordinates for */
0561   3185             leay  b,x;    /* line's endpoint.              */
0563   E641             ldb   1,u;
0565   58               aslb;
0566   BEC917           ldx   $C917;  /* Load 'x' with coordinates for */
0569   3085             leax  b,x;    /* line's starting point.        */
056B   BD0840           jsr   $draw_vector_with_pick_check;
056E   39               rts;


                 /*
                  * init_animate_variables()
                  *
                  * This procedure initializes the block of memory
                  * in the range C8A9-C90E to 0xFF.  It is called
                  * when ANIMATE mode is first entered.  This block
                  * of memory contains the line endpoint index pairs
                  * for all visible lines.
                  */
                 init_animate_variables:
056F   8EC8A9           ldx   #0xC8A9;
0572   86FF             lda   #0xFF;
0574   A780      P0574: sta   ,x+;
0576   8CC90F           cmpx  #0xC90F;
0579   26F9             bne   P0574;
057B   39               rts;


                 /*
                  * add_a_new_line()
                  *
                  * This routine adds the index pairs describing the
                  * starting and ending points for a line, to the line
                  * endpoint array, at C8A9-C90C.  If either of the
                  * indexes is 0xFF, or if the indexes are the same, then
                  * this point is not added to the array.  The indexes are
                  * added to the next available location.
                  *
                  * At entry:
                  *     a = ending point index
                  *     b = starting point index
                  *
                  */
                 add_a_new_line:
057C   8EC8A9           ldx   #0xC8A9;
057F   8CC90D    P057F: cmpx  #0xC90D;    /* Don't bother, if array */
0582   2601             bne   P0585;      /* is full.               */
0584   39        P0584: rts;

0585   4D        P0585: tsta;             /* Verify that this is a */
0586   2BFC             bmi   P0584;      /* valid set of endpoint */
0588   5D               tstb;             /* indexes.              */
0589   2BF9             bmi   P0584;
058B   3404             pshs  b;
058D   A1E0             cmpa  ,s+;
058F   27F3             beq   P0584;
0591   6D00             tst   0,x;        /* See if spot is empty */
0593   2A03             bpl   P0598;
0595   ED00             std   0,x;
0597   39               rts;

0598   3002      P0598: leax  2,x;        /* Spot is taken, go onto */
059A   20E3             bra   P057F;      /* next entry location.   */


                 /*
                  * play_handler()
                  *
                  * This is the start of the PLAY command handler.
                  * It will cause all currently defined ANIMATE
                  * frames to be played in succession.
                  */
                 play_handler:
059C   B6C91D           lda   $C91D;      /* See if the current frame's */
059F   B1C91E           cmpa  $C91E;      /* display duration has been  */
05A2   2606             bne   P05AA;      /* reached.                   */
05A4   7FC91D           clr   $C91D;      /* Reset duration counter, & goto */
05A7   BD064A           jsr   $get_ptrs_to_playback_frames; /* next frame.  */
05AA   BD06A9    P05AA: jsr   $fill_playback_buffer; /* Display playback buf. */
05AD   8EC933           ldx   #0xC933;
05B0   BFC917           stx   $C917;
05B3   BDF2A9           jsr   $intensity_to_7F;
05B6   BD053C           jsr   $draw_all_visible_lines;
05B9   BD0507           jsr   $draw_points_without_pick;
05BC   7CC91D           inc   $C91D;      /* Increment duration counter */
05BF   BD05E8           jsr   $check_playback_speed_buttons;
05C2   BDF354           jsr   $reset0ref;
05C5   B6C80F           lda   $C80F;      /* If button 1 or 2 is pressed, */
05C8   8403             anda  #0x03;      /* then enter the EDIT portion  */
05CA   2706             beq   P05D2;      /* of the ANIMATE code.         */
05CC   8E02C7           ldx   #edit_handler;
05CF   BFC8A7           stx   $C8A7;
05D2   39        P05D2: rts;


                 /*
                  * init_play_variables()
                  *
                  * This routine is invoked when the user initiates
                  * an animate 'PLAY' request.  It will initialize
                  * some of the globals used by the PLAY routines.
                  */
                 init_play_variables:
05D3   7FC91D           clr   $C91D;    /* Clear frame duration counter. */
05D6   8604             lda   #0x04;
05D8   B7C929           sta   $C929;    /* Set default playback speed.   */
05DB   BD061D           jsr   $update_playback_variables;
05DE   7FC920           clr   $C920;    /* Set up to display 1st frame.  */
05E1   7FC921           clr   $C921;    /* Direction flag:0=>frwd,1=>bckwd */
05E4   BD064A           jsr   $get_ptrs_to_playback_frames;
05E7   39               rts;


                 /*
                  * check_playback_speed_buttons()
                  *
                  * This routine monitors buttons 3 (slow) and
                  * 4 (fast) during the PLAY mode portion of the
                  * animate option.  The current playback speed is
                  * kept in C929; 0 = fastest, 7 = slowest.
                  */
                 check_playback_speed_buttons:
05E8   7DC814           tst   $C814;
05EB   2606             bne   decrease_playback_speed;
05ED   7DC815           tst   $C815;
05F0   2617             bne   increase_playback_speed;
05F2   39               rts;

                 /*
                  * decrease_playback_speed()
                  *
                  * Decrease the playback speed (by incrementing C929)
                  */
                 decrease_playback_speed:
05F3   B6C929           lda   $C929;
05F6   8107             cmpa  #0x07;
05F8   2601             bne   P05FB;
05FA   39               rts;
05FB   7CC929    P05FB: inc   $C929;
05FE   B6C91D           lda   $C91D;
0601   48               asla;          /* Increase duration counter for */
0602   B7C91D           sta   $C91D;   /* this frame.                   */
0605   BD061D           jsr   $update_playback_variables;
0608   39               rts;

                 /*
                  * increase_playback_speed()
                  *
                  * Increase the playback speed (by decrementing C929)
                  */
                 increase_playback_speed:
0609   7DC929           tst   $C929;
060C   2601             bne   P060F;
060E   39               rts;
060F   7AC929    P060F: dec   $C929;
0612   B6C91D           lda   $C91D;
0615   47               ASRA;          /* Decrease duration counter */
0616   B7C91D           sta   $C91D;   /* for this frame.           */
0619   BD061D           jsr   $update_playback_variables;
061C   39               rts;


                 /*
                  * update_playback_variables()
                  *
                  * This routine uses the current playback speed, in C929,
                  * to index into the structure at 0632 (playback_speed_info).
                  * From this structure, two values are obtained: a 1 byte bit
                  * pattern, and a two byte jump address.  These two
                  * values are used by the playback routines.
                  */
                 update_playback_variables:
061D   8E0632           ldx   #playback_speed_info;
0620   F6C929           ldb   $C929;
0623   8603             lda   #0x03;
0625   3D               mul;
0626   3A               abx;
0627   A680             lda   ,x+;
0629   B7C91E           sta   $C91E;
062C   EC81             ldd   ,x++;
062E   FDC922           std   $C922;
0631   39               rts;

                 /*
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
                  */
                 playback_speed_info:
0632   01               .byte 0x01;
0633   07               .word 0x0720;
0635   02               .byte 0x02;
0636   07               .word 0x071E;
0638   04               .byte 0x04;
0639   07               .word 0x071C;
063B   08               .byte 0x08;
063C   07               .word 0x071A;
063E   10               .byte 0x10;
063F   07               .word 0x0718;
0641   20               .byte 0x20;
0642   07               .word 0x0716;
0644   40               .byte 0x40;
0645   07               .word 0x0714;
0647   80               .byte 0x80;
0648   07               .word 0x0712;


                 /*
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
                  */
                 get_ptrs_to_playback_frames:
064A   B6C920           lda   $C920;   /* Load index of current frame. */
064D   B7C91F           sta   $C91F;
0650   BD067F           jsr   $update_play_index_to_next_frame;
0653   8E0669           ldx   #frame_buf_pointers;
0656   B6C91F           lda   $C91F;
0659   48               asla;
065A   EC86             ldd   a,x;     /* Load C924 with ptr to frame buf */
065C   FDC924           std   $C924;   /* for the current frame.          */
065F   B6C920           lda   $C920;
0662   48               asla;
0663   EC86             ldd   a,x;     /* Load C926 with ptr to frame buf */
0665   FDC926           std   $C926;   /* for the next frame.             */
0668   39               rts;


                 /*
                  * This is an array of word pointers.  These point
                  * to the beginning of the buffer area associated
                  * with each of the animate frames.  Each frame is
                  * 64 bytes long.
                  */
                 frame_buf_pointers:
0669   C9               .word 0xC977;
066B   C9               .word 0xC9B7;
066D   C9               .word 0xC9F7;
066F   CA               .word 0xCA37;
0671   CA               .word 0xCA77;
0673   CA               .word 0xCAB7;
0675   CA               .word 0xCAF7;
0677   CB               .word 0xCB37;
0679   CB               .word 0xCB77;
067B   CB               .word 0xCBB7;
067D   CB               .word 0xCBF7;


                 /*
                  * update_play_index_to_next_frame()
                  *
                  * This routine updates the frame index (C920),
                  * to index the next frame to be displayed.  If we
                  * are currently displaying in the forward direction,
                  * then this will be incremented.  If we are currently
                  * displaying in the backward direction, then this will
                  * be decremented.  If we reach the first/last frame,
                  * then the direction will be changed.
                  */
                 update_play_index_to_next_frame:
067F   7DC921           tst   $C921;  /* Check 4 frwd/bkwd display order. */
0682   2615             bne   backward_order;
0684   B6C920           lda   $C920;  /* Increment, if not at last frame. */
0687   B1C8A6           cmpa  $C8A6;
068A   2704             beq   start_backwards;
068C   7CC920           inc   $C920;
068F   39               rts;

                 start_backwards:
0690   86FF             lda   #0xFF;  /* Set direction flag to 'backwards'. */
0692   B7C921           sta   $C921;
0695   7AC920           dec   $C920;  /* Decrement to previous frame. */
0698   39               rts;

                 backward_order:
0699   7DC920           tst   $C920;  /* Decrement, if not at first frame. */
069C   2704             beq   start_forward;
069E   7AC920           dec   $C920;
06A1   39               rts;

                 start_forward
06A2   7FC921           clr   $C921;  /* Set direction flag to 'forwards'. */
06A5   7CC920           inc   $C920;  /* Increment to next frame.          */
06A8   39               rts;


                 /*
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
                  */
                 fill_playback_buffer:
06A9   BEC924           ldx   $C924;    /* Pointer to current frame. */
06AC   10BEC926         ldy   $C926;    /* Ptr to next (transition) frame. */
06B0   CEC933           ldu   #0xC933;  /* Addr of playback buffer.  */
06B3   B6C8A3           lda   $C8A3;    /* # of points in frame buffer. */
06B6   B7C880           sta   $C880;
06B9   7DC880    P06B9: tst   $C880;
06BC   271D             beq   P06DB;
06BE   A680             lda   ,x+;      /* Load both 'y' coordinates. */
06C0   E6A0             ldb   ,y+;
06C2   FDC82E           std   $C82E;
06C5   BD06DC           jsr   $merge_coordinates;
06C8   E7C0             stb   ,u+;      /* Save final 'y' coordinate. */
06CA   A680             lda   ,x+;      /* Load both 'x' coordinates. */
06CC   E6A0             ldb   ,y+;
06CE   FDC82E           std   $C82E;
06D1   BD06DC           jsr   $merge_coordinates;
06D4   E7C0             stb   ,u+;      /* Save final 'x' coordinate. */
06D6   7AC880           dec   $C880;
06D9   20DE             bra   P06B9;
06DB   39        P06DB: rts;


                 /*
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
                  */
                 merge_coordinates:
06DC   F6C82E           ldb   $C82E;   /* Get coord for current frame. */
06DF   1D               sex;
06E0   3406             pshs  a,b;
06E2   F6C82F           ldb   $C82F;   /* Get coord for next frame. */
06E5   1D               sex;
06E6   A3E1             subd  ,s++;
06E8   2A17             bpl   P0701;
06EA   50               negb;
06EB   B6C91D           lda   $C91D;
06EE   3D               mul;
06EF   AD9FC922         jsr   [0xC922];
06F3   43               coma;
06F4   53               comb;
06F5   C30001           addd  #0x0001;
06F8   3406             pshs  a,b;
06FA   F6C82E           ldb   $C82E;
06FD   1D               sex;
06FE   E3E1             addd  ,s++;
0700   39               rts;

0701   B6C91D    P0701: lda   $C91D;
0704   3D               mul;
0705   AD9FC922         jsr   [0xC922];
0709   3406             pshs  a,b;
070B   F6C82E           ldb   $C82E;
070E   1D               sex;
070F   E3E1             addd  ,s++;
0711   39               rts;


0712   47        P0712: ASRA;
0713   56               rorb;
0714   47        P0714: ASRA;
0715   56               rorb;
0716   47        P0716: ASRA;
0717   56               rorb;
0718   47        P0718: ASRA;
0719   56               rorb;
071A   47        P071A: ASRA;
071B   56               rorb;
071C   47        P071C: ASRA;
071D   56               rorb;
071E   47        P071E: ASRA;
071F   56               rorb;
0720   39        P0720: rts;


                 /*
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
                  *     'a' = 0xFF if lightpen was located.
                  *
                  * Work variables:
                  *     C881 contains the number of scan lines left to draw.
                  *     C882-C883 contain starting point for next scan line.
                  */
                 search_screen_for_lightpen:
0721   867A             lda   #0x7A;
0723   B7C881           sta   $C881;    /* Init # of scan lines to draw */
0726   CC8880           ldd   #0x8880;
0729   FDC882           std   $C882;    /* Init start pt for first scan line */
072C   7DC881    P072C: tst   $C881;
072F   2605             bne   draw_scan_line;
0731   BDF354           jsr   $reset0ref;
0734   4F               clra;           /* If we make it to here, then the */
0735   39               rts;            /* lightpen was not found.         */

                 draw_scan_line:
0736   BDF354           jsr   $reset0ref;
0739   FCC882           ldd   $C882;    /* Move to start of scan line */
073C   BDF2FC           jsr   $move_pen7F_to_d;
073F   0F01             clr   0x01;
0741   0F00             clr   0x00;
0743   C6FF             ldb   #0xFF;
0745   D704             stb   0x04;
0747   0C00             inc   0x00;
0749   867F             lda   #0x7F;
074B   9701             sta   0x01;
074D   CCFF40           ldd   #0xFF40;
0750   970A             sta   0x0A;     /* Use solid line pattern. */
0752   0F05             clr   0x05;
0754   D50D      P0754: bitb  0x0D;
0756   27FC             beq   P0754;
0758   0F0A             clr   0x0A;
075A   8602             lda   #0x02;    /* Check for a lightpen pick */
075C   950D             bita  0x0D;
075E   260D             bne   find_point_of_intersection;
0760   7AC881           dec   $C881;    /* No lightpen pick, so continue */
0763   B6C882           lda   $C882;    /* to draw the next scan line.   */
0766   8B02             adda  #0x02;    /* Draw on everyother horz line. */
0768   B7C882           sta   $C882;
076B   20BF             bra   P072C;


                 /*
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
                  */
                 find_point_of_intersection:
076D   BDF354           jsr   $reset0ref;
0770   FCC882           ldd   $C882;   /* Move to start of scan line */
0773   BDF2FC           jsr   $move_pen7F_to_d;
0776   1CEF             andcc #0xEF;   /* Enable IRQ on 6809 */
0778   8682             lda   #0x82;   /* Enable CA1 on PIA  */
077A   970E             sta   0x0E;
077C   867E             lda   #0x7E;   /* Set up IRQ handler */
077E   B7CBF8           sta   $CBF8;
0781   CC07CE           ldd   #ISR_handler;
0784   FDCBF9           std   $CBF9;
0787   0F01             clr   0x01;    /* Redraw the scan line */
0789   0F00             clr   0x00;
078B   0F04             clr   0x04;
078D   12               nop;
078E   0C00             inc   0x00;
0790   8620             lda   #0x20;
0792   9701             sta   0x01;
0794   86FF             lda   #0xFF;
0796   970A             sta   0x0A;
0798   C67F             ldb   #0x7F;
079A   8605             lda   #0x05;
079C   9705             sta   0x05;
079E   5A        P079E: decb;          /* Wait for interrupt; counter loop */
079F   21FD             brn   P079E;
07A1   26FB             bne   P079E;
07A3   0F05             clr   0x05;
07A5   BD07AA           jsr   $disable_interrupts;
07A8   4F               clra;          /* Lightpen not found */
07A9   39               rts;


                 /*
                  * disable_interrupts()
                  *
                  * This routine is responsible for disabling lightpen
                  * interrupts.
                  */
07AA   4F               clra;
07AB   970E             sta   0x0E;  /* Disable CA1 on PIA */
07AD   9701             sta   0x01;
07AF   970D             sta   0x0D;
07B1   1A10             orcc  #0x10; /* Disable IRQ on 6809 */
07B3   BDF354           jsr   $reset0ref;
07B6   39               rts;


                 /*
                  * process_ISR()
                  *
                  * This procedure performs most of the work involved,
                  * whenever the lightpen generates an interrupt.  It
                  * uses the counter value, in the 'b' register, to
                  * calculate the x coordinate of the lightpen.  The
                  * intersection point is returned in the 'x' register.
                  * This routine returns to the routine which invoked
                  * the scan line search routine.
                  */
                 process_ISR:
07B7   030A             com   0x0A;
07B9   0F05             clr   0x05;
07BB   C07F             subb  #0x7F;   /* Calculate x coordinate */
07BD   50               negb;
07BE   58               aslb;
07BF   1D               sex;
07C0   830080           subd  #0x0080;
07C3   B6C882           lda   $C882;   /* Retrieve y coordinate */
07C6   1F01             tfr   d,x;
07C8   BD07AA           jsr   $disable_interrupts;
07CB   86FF             lda   #0xFF;   /* Lightpen found */
07CD   39               rts;


                 /*
                  * ISR_handler()
                  *
                  * This is the entry point called by the OS, whenever the
                  * lightpen generates an IRQ interrupt.  This procedure
                  * discards the 12 bytes of saved state information
                  * placed on the stack by the 6809, including the return
                  * address for the interrupted routine.  Then it calls the
                  * process_ISR() routine, to process the IRQ request.
                  */
                 ISR_handler:
07CE   030A             com   0x0A;
07D0   326C             leas  12,s;
07D2   7E07B7           jmp   $process_ISR;
07D5   12               .byte 0x12;


                 /*
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
                  *               0xFF if no pick occurred.
                  */
                 draw_with_pick_check:
07D6   6F7F             clr   -1,s;   /* Temporary storage of current pt # */
07D8   86FF             lda   #0xFF;
07DA   A77E             sta   -2,s;   /* Temporary storage of last pt picked */
07DC   D704             stb   0x04;
07DE   EC01      P07DE: ldd   1,x;
07E0   9701             sta   0x01;   /* Set rel y position. */
07E2   0F00             clr   0x00;
07E4   A600             lda   0,x;    /* Get the mode. */
07E6   3003             leax  3,x;    /* Increment ptr to next entry. */
07E8   0C00             inc   0x00;
07EA   D701             stb   0x01;   /* Set rel x position. */
07EC   970A             sta   0x0A;   /* Set line pattern.   */
07EE   0F05             clr   0x05;
07F0   CC0040           ldd   #0x0040;
07F3   D50D      P07F3: bitb  0x0D;
07F5   27FC             beq   P07F3;
07F7   1E11             exg   x,x;
07F9   970A             sta   0x0A;
07FB   960D             lda   0x0D;   /* Check for a lightpen pick  */
07FD   8402             anda  #0x02;
07FF   2704             beq   P0805;
0801   A67F             lda   -1,s;
0803   A77E             sta   -2,s;   /* Save the current pt #.     */
0805   6C7F      P0805: inc   -1,s;   /* Increment the current pt # */
0807   A600             lda   0,x;
0809   2FD3             ble   P07DE;
080B   A67E             lda   -2,s;   /* Return index if any pt picked. */
080D   39               rts;


                 /*
                  * This routine appears to not be used anywhere!!
                  */
080E   A77E      P080E: sta   -2,s;
0810   6F7F             clr   -1,s;
0812   D704             stb   0x04;
0814   EC01      P0814: ldd   1,x;
0816   9701             sta   0x01;
0818   0F00             clr   0x00;
081A   A600             lda   0,x;
081C   3003             leax  3,x;
081E   0C00             inc   0x00;
0820   D701             stb   0x01;
0822   E67E             ldb   -2,s;
0824   E17F             cmpb  -1,s;
0826   2702             beq   P082A;
0828   5F               clrb;
0829   4F               clra;
082A   970A      P082A: sta   0x0A;
082C   0F05             clr   0x05;
082E   CC0040           ldd   #0x0040;
0831   D50D      P0831: bitb  0x0D;
0833   27FC             beq   P0831;
0835   1E11             exg   x,x;
0837   970A             sta   0x0A;
0839   6C7F             inc   -1,s;
083B   A600             lda   0,x;
083D   2FD5             ble   P0814;
083F   39               rts;


                 /*
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
                  */
                 draw_vector_with_pick_check:
0840   BDF354           jsr   $reset0ref;
0843   86FF             lda   #0xFF;
0845   B7C880           sta   $C880;
0848   8601             lda   #0x01;
084A   B7C883           sta   $C883;
084D   A600             lda   0,x;     /* Move to starting point */
084F   9701             sta   0x01;
0851   0F00             clr   0x00;
0853   A601             lda   1,x;
0855   C67F             ldb   #0x7F;
0857   D704             stb   0x04;
0859   C6CE             ldb   #0xCE;
085B   D70C             stb   0x0C;
085D   0C00             inc   0x00;
085F   9701             sta   0x01;
0861   0F05             clr   0x05;
0863   BD0879           jsr   $calculate_vector_endpoint;
0866   8E08E7           ldx   #am_scale_factors;
0869   E685             ldb   b,x;
086B   8640             lda   #0x40;
086D   950D      P086D: bita  0x0D;
086F   27FC             beq   P086D;
0871   8EC880           ldx   #0xC880;
0874   BD07D6           jsr   $draw_with_pick_check;
0877   43               coma;
0878   39               rts;


                 /*
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
                  */
                 calculate_vector_endpoint:
0879   A620             lda   0,y;    /* Determine delta y. */
087B   A000             suba  0,x;
087D   10290039         lbvs  P08BA;
0881   E621             ldb   1,y;    /* Determine delta x. */
0883   E001             subb  1,x;
0885   10290031         lbvs  P08BA;
0889   FDC881           std   $C881;
088C   BDF584           jsr   $get_absolute_value_of_ab;
088F   3404             pshs  b;
0891   A1E0             cmpa  ,s+;
0893   2402             bhs   P0897;
0895   1F98             tfr   b,a;
0897   813F      P0897: cmpa  #0x3F;
0899   2303             bls   P089E;
089B   C602             ldb   #0x02;
089D   39               rts;

089E   811F      P089E: cmpa  #0x1F;
08A0   230B             bls   P08AD;
08A2   FCC881           ldd   $C881;
08A5   48               asla;
08A6   58               aslb;
08A7   FDC881           std   $C881;
08AA   C603             ldb   #0x03;
08AC   39               rts;

08AD   FCC881    P08AD: ldd   $C881;
08B0   48               asla;
08B1   48               asla;
08B2   58               aslb;
08B3   58               aslb;
08B4   FDC881           std   $C881;
08B7   C604             ldb   #0x04;
08B9   39               rts;

08BA   E600      P08BA: ldb   0,x;
08BC   1D               sex;
08BD   3406             pshs  a,b;
08BF   E620             ldb   0,y;
08C1   1D               sex;
08C2   A3E1             subd  ,s++;
08C4   3406             pshs  a,b;
08C6   E601             ldb   1,x;
08C8   1D               sex;
08C9   3406             pshs  a,b;
08CB   E621             ldb   1,y;
08CD   1D               sex;
08CE   A3E1             subd  ,s++;
08D0   44               lsra;
08D1   56               rorb;
08D2   1F01             tfr   d,x;
08D4   3506             puls  a,b;
08D6   44               lsra;
08D7   56               rorb;
08D8   1F02             tfr   d,y;
08DA   1F20             tfr   y,d;
08DC   F7C881           stb   $C881;
08DF   1F10             tfr   x,d;
08E1   F7C882           stb   $C882;
08E4   C601             ldb   #0x01;
08E6   39               rts;


                 am_scale_factors:
08E7   00               .byte 0x00;
08E8   FF               .byte 0xFF;
08E9   7F               .byte 0x7F;
08EA   3E               .byte 0x3E;
08EB   1E               .byte 0x1E;

08EC   0D               .byte 0x0D;

                 /*
                  * set_cursor_structure (cursor_ptr, data_ptr)
                  *
                  * This routine appears to copy the data pointer to
                  * by the 'x' register into the cursor structure, which
                  * is pointed to by the 'u' register.
                  * The cursor struct is 12 bytes long, and is laid out
                  * as follows:
                  *
                  *     ************************
                  *     * cursor rel y pos     *
                  *     ************************
                  *     * cursor rel x pos     *
                  *     ************************
                  *     * found this pass flag *
                  *     ************************\
                  *     * cursor y delta       * \
                  *     ************************  > Used when moving cursor
                  *     * cursor x delta       * /  to follow light pen
                  *     ************************/
                  *     * found last pass flag *
                  *     ************************
                  *     * max y position       *
                  *     ************************
                  *     * min x position       *
                  *     ************************
                  *     * min y position       *
                  *     ************************
                  *     * max x position       *
                  *     ************************
                  *     * ptr to line pattern  *
                  *     ** array used when    **
                  *     * drawing search webs  *
                  *     ************************
                  */
                 set_cursor_structure:
08ED   EC81             ldd   ,x++;
08EF   ED40             std   0,u;
08F1   EC81             ldd   ,x++;
08F3   ED46             std   6,u;
08F5   EC81             ldd   ,x++;
08F7   ED48             std   8,u;
08F9   CC0A54           ldd   #whole_search_pattern;
08FC   ED4A             std   10,u;
08FE   6F45             clr   5,u;
0900   39               rts;


                 /*
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
                  */
                 update_cursor_position:
0901   BD0984           jsr   $find_lightpen;  /* Try to find lightpen. */
0904   A642             lda   2,u;     /* Proceed only if the lightpen */
0906   81FF             cmpa  #0xFF;   /* is currently at the cursor. */
0908   2679             bne   P0983;
090A   E640             ldb   0,u;     /* Get y position, & extend to 16 bits */
090C   1D               sex;
090D   3406             pshs  a,b;
090F   E643             ldb   3,u;     /* Get new y delta */
0911   1D               sex;
0912   E3E1             addd  ,s++;    /* Add together */
0914   3406             pshs  a,b;
0916   E646             ldb   6,u;     /* Compare new coordinate to max y */
0918   1D               sex;           /* value.  Use max y value, if new */
0919   10A360           cmpd  0,s;     /* coordinate is too big.          */
091C   2E0D             bgt   P092B;
091E   3262             leas  2,s;
0920   8E0A5E           ldx   #lower_search_pattern;
0923   AF4A             stx   10,u;    /* Use lower search pattern */
0925   A646             lda   6,u;
0927   A740             sta   0,u;
0929   201E             bra   P0949;

092B   E648      P092B: ldb   8,u;     /* Compare new coordinate to min y */
092D   1D               sex;           /* value.  Use min y value if new  */
092E   10A360           cmpd  0,s;     /* cordinate is too small.         */
0931   2D0D             blt   P0940;
0933   3262             leas  2,s;
0935   8E0A68           ldx   #upper_search_pattern;
0938   AF4A             stx   10,u;    /* Use upper search pattern */
093A   A648             lda   8,u;
093C   A740             sta   0,u;
093E   2009             bra   P0949;

0940   ECE1      P0940: ldd   ,s++;    /* Save new y coordinate in the */
0942   E740             stb   0,u;     /* cursor structure.            */
0944   8E0A54           ldx   #whole_search_pattern;
0947   AF4A             stx   10,u;    /* Use whole search pattern. */
0949   E641      P0949: ldb   1,u;     /* Load current x coordinate, and */
094B   1D               sex;           /* extend it to 16 bits.          */
094C   3406             pshs  a,b;
094E   E644             ldb   4,u;
0950   1D               sex;
0951   E3E1             addd  ,s++;    /* Add the new x delta. */
0953   3406             pshs  a,b;
0955   E649             ldb   9,u;     /* Compare new x coordinate to max x */
0957   1D               sex;           /* value.  Use max value if new coord */
0958   10A360           cmpd  0,s;     /* is too big.                       */
095B   2E0D             bgt   P096A;
095D   3262             leas  2,s;
095F   8E0A7C           ldx   #left_search_pattern;
0962   AF4A             stx   10,u;    /* Use left search pattern */
0964   A649             lda   9,u;
0966   A741             sta   1,u;
0968   2019             bra   P0983;

096A   E647      P096A: ldb   7,u;     /* Compare new coordinate to min x */
096C   1D               sex;           /* value.  Use min value, if new   */
096D   10A360           cmpd  0,s;     /* coordinate is too small.        */
0970   2D0D             blt   P097F;
0972   3262             leas  2,s;
0974   8E0A72           ldx   #right_search_pattern;
0977   AF4A             stx   10,u;    /* Use right search pattern */
0979   A647             lda   7,u;
097B   A741             sta   1,u;
097D   2004             bra   P0983;

097F   ECE1      P097F: ldd   ,s++;    /* Save new x coordinate */
0981   E741             stb   1,u;
0983   39        P0983: rts;


                 /*
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
                  *     value will be either -1, 0, or +1.  This will then
                  *     be multiplied by a scale value, which is obtained
                  *     by using the scale factor index to index into a
                  *     multiplier array.  The new deltas are saved in the
                  *     cursor structure.
                  */
                 find_lightpen:
0984   6F42             clr   2,u;     /* Clear "found this pass" flag */
0986   BDF2A9           jsr   $intensity_to_7F;
0989   BDF354           jsr   $reset0ref;
098C   EC40             ldd   0,u;     /* Move to last known location */
098E   BDF2FC           jsr   $move_pen7F_to_d;
0991   8E0A50           ldx   #dot_pattern; /* Draw a dot; check for pick */
0994   C604             ldb   #0x04;
0996   BD07D6           jsr   $draw_with_pick_check;
0999   4D               tsta;
099A   2607             bne   search_4_lightpen;
099C   6C42             inc   2,u;     /* Lightpen was found */
099E   86FF             lda   #0xFF;
09A0   A745             sta   5,u;
09A2   39               rts;

                 search_4_lightpen:
09A3   6D45             tst   5,u;     /* Don't bother searching if lightpen */
09A5   2601             bne   continue_lightpen_search;   /* wasn't found */
09A7   39               rts;                              /* last pass. */

                 continue_lightpen_search:
09A8   BDF354           jsr   $reset0ref;  /* Draw the spider web, with an */
09AB   8E0A86           ldx   #small_search_pattern_vl; /* increasing scale */
09AE   A642             lda   2,u;         /* factor, until either the light */
09B0   8104             cmpa  #0x04;       /* pen is found, or the last scale */
09B2   2D03             blt   P09B7;       /* factor is reached.           */
09B4   8E0A98           ldx   #large_search_pattern_vl;
09B7   EC40      P09B7: ldd   0,u;
09B9   BDF2FC           jsr   $move_pen7F_to_d;
09BC   108E0AC4         ldy   #search_pattern_scale_factors;
09C0   A642             lda   2,u;
09C2   E6A6             ldb   a,y;
09C4   2608             bne   draw_search_pattern;
09C6   BDF354           jsr   $reset0ref;
09C9   6F42             clr   2,u;          /* Flag that cursor is 'lost' */
09CB   6F45             clr   5,u;          /* to the lightpen.           */
09CD   39               rts;

                 draw_search_pattern:
09CE   10AE4A           ldy   10,u;    /* Get line pattern array pointer */
09D1   BD0A13           jsr   $display_search_pattern;
09D4   81FF             cmpa  #0xFF;   /* Check for a pick. */
09D6   2604             bne   lightpen_found;
09D8   6C42             inc   2,u;     /* Increment the scale factor. */
09DA   20C7             bra   search_4_lightpen;

                 lightpen_found:
09DC   8E0AAA           ldx   #cursor_deltas;
09DF   4A               deca;          /* Decrement the index of the picked */
09E0   48               asla;          /* point, & convert to word index.   */
09E1   EC86             ldd   a,x;     /* Load x & y delta values, and save */
09E3   ED43             std   3,u;     /* in the cursor structure.          */
09E5   8E0ABA           ldx   #delta_multipliers;
09E8   E642             ldb   2,u;     /* Use the scale factor index to get */
09EA   A685             lda   b,x;     /* the correct delta multiplier.     */
09EC   3402             pshs  a;
09EE   E643             ldb   3,u;     /* Generate new y delta. */
09F0   BD0A05           jsr   $generate_new_cursor_coordinate;
09F3   E743             stb   3,u;
09F5   3502             puls  a;
09F7   E644             ldb   4,u;     /*  Generate new x delta. */
09F9   BD0A05           jsr   $generate_new_cursor_coordinate;
09FC   E744             stb   4,u;
09FE   86FF             lda   #0xFF;   /* Flag that the cursor is picked */
0A00   A742             sta   2,u;
0A02   A745             sta   5,u;
0A04   39               rts;


                 /*
                  * generate_new_cursor_coordinate()
                  *
                  * This routine calulates the new cursor delta,
                  * by multiplying a delta value (-1, 0, +1) by
                  * a scale multiplier.
                  *
                  * At entry:
                  *     'b' = coordinate delta.
                  *     'a' = scale multiplier.
                  */
                 generate_new_cursor_coordinate:
0A05   3404             pshs  b;
0A07   5D               tstb;
0A08   2A01             bpl   P0A0B;
0A0A   50               negb;
0A0B   3D        P0A0B: mul;
0A0C   3502             puls  a;
0A0E   4D               tsta;
0A0F   2A01             bpl   P0A12;
0A11   50               negb;
0A12   39        P0A12: rts;


                 /*
                  * display_search_pattern()
                  *
                  * This routine draws the series of vectors, specified in
                  * the structure pointed to by they 'x' register.  The 'y'
                  * 'y' register points to an array of line patterns
                  * associated with each vector.  The scale factor to be used
                  * is specified in 'b'.  A pattern of '1' terminates this
                  * routine.  If a pick is detected, then the index of the
                  * vector being drawn is returned in the 'a' register;
                  * if no pick occurred, then 0xFF is returned.  This is used
                  * when drawing the spider web search patterns.
                  *
                  * At entry:
                  *     'b' = scale factor
                  *     'x' = vector list ptr (rel y, rel x)
                  *     'y' = line pattern array ptr
                  *
                  * At exit:
                  *     'a' = 0xFF => no pick occurred.
                  *           otherwise, indicates which vector was picked.
                  */
                 display_search_pattern:
0A13   86FF             lda   #0xFF;
0A15   B70000           sta   $0000;
0A18   6F7F             clr   -1,s;    /* Keeps track of current vector index */
0A1A   86FF             lda   #0xFF;
0A1C   A77E             sta   -2,s;    /* Keeps index of picked vector */
0A1E   D704             stb   0x04;
0A20   EC00      P0A20: ldd   0,x;
0A22   9701             sta   0x01;
0A24   0F00             clr   0x00;
0A26   3002             leax  2,x;
0A28   0C00             inc   0x00;
0A2A   D701             stb   0x01;
0A2C   A6A0             lda   ,y+;
0A2E   970A             sta   0x0A;
0A30   0F05             clr   0x05;
0A32   CC0040           ldd   #0x0040;
0A35   D50D      P0A35: bitb  0x0D;
0A37   27FC             beq   P0A35;
0A39   1E11             exg   x,x;
0A3B   970A             sta   0x0A;
0A3D   960D             lda   0x0D;    /* Check for a lightpen pick */
0A3F   8402             anda  #0x02;
0A41   2704             beq   P0A47;
0A43   A67F             lda   -1,s;
0A45   A77E             sta   -2,s;    /* Save index of picked vector. */
0A47   6C7F      P0A47: inc   -1,s;    /* Increment index. */
0A49   A620             lda   0,y;
0A4B   2FD3             ble   P0A20;
0A4D   A67E             lda   -2,s;    /* Return index of picked vector. */
0A4F   39               rts;


                 dot_pattern:
0A50   FF               .byte 0xFF;
0A51   00               .byte 0x00;
0A52   00               .byte 0x00;
0A53   01               .byte 0x01;

                 /*
                  * The following 5 arrays contain the line patterns
                  * used when drawing the spider web search pattern.
                  * Depending upon which set of line patterns are used,
                  * either the whole pattern, the left side, or right side,
                  * or upper portion, or lower portion will be drawn.
                  */
                 whole_search_pattern:
0A54   00               .byte 0x00;
0A55   FF               .byte 0xFF;
0A56   FF               .byte 0xFF;
0A57   FF               .byte 0xFF;
0A58   FF               .byte 0xFF;
0A59   FF               .byte 0xFF;
0A5A   FF               .byte 0xFF;
0A5B   FF               .byte 0xFF;
0A5C   FF               .byte 0xFF;
0A5D   01               .byte 0x01;

                 lower_search_pattern:
0A5E   00               .byte 0x00;
0A5F   00               .byte 0x00;
0A60   FF               .byte 0xFF;
0A61   FF               .byte 0xFF;
0A62   FF               .byte 0xFF;
0A63   FF               .byte 0xFF;
0A64   FF               .byte 0xFF;
0A65   00               .byte 0x00;
0A66   00               .byte 0x00;
0A67   01               .byte 0x01;

                 upper_search_pattern:
0A68   00               .byte 0x00;
0A69   FF               .byte 0xFF;
0A6A   FF               .byte 0xFF;
0A6B   00               .byte 0x00;
0A6C   00               .byte 0x00;
0A6D   00               .byte 0x00;
0A6E   FF               .byte 0xFF;
0A6F   FF               .byte 0xFF;
0A70   FF               .byte 0xFF;
0A71   01               .byte 0x01;

                 right_search_pattern:
0A72   00               .byte 0x00;
0A73   FF               .byte 0xFF;
0A74   FF               .byte 0xFF;
0A75   FF               .byte 0xFF;
0A76   FF               .byte 0xFF;
0A77   00               .byte 0x00;
0A78   00               .byte 0x00;
0A79   00               .byte 0x00;
0A7A   FF               .byte 0xFF;
0A7B   01               .byte 0x01;

                 left_search_pattern:
0A7C   00               .byte 0x00;
0A7D   00               .byte 0x00;
0A7E   00               .byte 0x00;
0A7F   00               .byte 0x00;
0A80   FF               .byte 0xFF;
0A81   FF               .byte 0xFF;
0A82   FF               .byte 0xFF;
0A83   FF               .byte 0xFF;
0A84   FF               .byte 0xFF;
0A85   01               .byte 0x01;

                 small_search_pattern_vl:
0A86   10               .byte 0x10;
0A87   08               .byte 0x08;
0A88   F8               .byte 0xF8;
0A89   08               .byte 0x08;
0A8A   F0               .byte 0xF0;
0A8B   00               .byte 0x00;
0A8C   F8               .byte 0xF8;
0A8D   F8               .byte 0xF8;
0A8E   00               .byte 0x00;
0A8F   F0               .byte 0xF0;
0A90   08               .byte 0x08;
0A91   F8               .byte 0xF8;
0A92   10               .byte 0x10;
0A93   00               .byte 0x00;
0A94   08               .byte 0x08;
0A95   08               .byte 0x08;
0A96   00               .byte 0x00;
0A97   10               .byte 0x10;

                 large_search_pattern_vl:
0A98   40               .byte 0x40;
0A99   20               .byte 0x20;
0A9A   E0               .byte 0xE0;
0A9B   20               .byte 0x20;
0A9C   C0               .byte 0xC0;
0A9D   00               .byte 0x00;
0A9E   E0               .byte 0xE0;
0A9F   E0               .byte 0xE0;
0AA0   00               .byte 0x00;
0AA1   C0               .byte 0xC0;
0AA2   20               .byte 0x20;
0AA3   E0               .byte 0xE0;
0AA4   40               .byte 0x40;
0AA5   00               .byte 0x00;
0AA6   20               .byte 0x20;
0AA7   20               .byte 0x20;
0AA8   00               .byte 0x00;
0AA9   40               .byte 0x40;

                 /*
                  * These are (y,x) delta pairs, which are added
                  * to the cursor position, to line the cursor up
                  * with the lightpen.  The pair used depends upon
                  * which vector of the search pattern was picked.
                  */
                 cursor_deltas:
0AAA   01               .byte 0x01;
0AAB   01               .byte 0x01;
0AAC   00               .byte 0x00;
0AAD   01               .byte 0x01;
0AAE   FF               .byte 0xFF;
0AAF   01               .byte 0x01;
0AB0   FF               .byte 0xFF;
0AB1   00               .byte 0x00;
0AB2   FF               .byte 0xFF;
0AB3   FF               .byte 0xFF;
0AB4   00               .byte 0x00;
0AB5   FF               .byte 0xFF;
0AB6   01               .byte 0x01;
0AB7   FF               .byte 0xFF;
0AB8   01               .byte 0x01;
0AB9   00               .byte 0x00;

                 /*
                  * This is an array of multiplier values, used when
                  * updating the cursors position so that is tracks
                  * the lightpen.  The scale factor index used to
                  * draw the search pattern is also used to index into
                  * this byte array.  As the scale factor increases, so
                  * does the multiplier value.
                  */
                 delta_multipliers:
0ABA   01               .byte 0x01;
0ABB   02               .byte 0x02;
0ABC   03               .byte 0x03;
0ABD   05               .byte 0x05;
0ABE   08               .byte 0x08;
0ABF   0B               .byte 0x0B;
0AC0   0E               .byte 0x0E;
0AC1   12               .byte 0x12;
0AC2   16               .byte 0x16;
0AC3   1C               .byte 0x1C;

                 /*
                  * This array contains the scale factors to be used
                  * when drawing the search patterns.
                  */
                 search_pattern_scale_factors:
0AC4   08               .byte 0x08;
0AC5   12               .byte 0x12;
0AC6   1E               .byte 0x1E;
0AC7   2C               .byte 0x2C;
0AC8   0E               .byte 0x0E;
0AC9   14               .byte 0x14;
0ACA   1A               .byte 0x1A;
0ACB   22               .byte 0x22;
0ACC   2C               .byte 0x2C;
0ACD   38               .byte 0x38;
0ACE   00               .byte 0x00;


                 /*
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
                  */
                 print_with_pick_check:
0ACF   7CC820           inc   $C820;
0AD2   BDF354           jsr   $reset0ref;
0AD5   FFC880           stu   $C880;
0AD8   7DC81E           tst   $C81E;
0ADB   2707             beq   P0AE4;
0ADD   1F31             tfr   u,x;
0ADF   BCC81C           cmpx  $C81C;
0AE2   2608             bne   P0AEC;
0AE4   BD0B19    P0AE4: jsr   $am_print_string;
0AE7   7DC89E           tst   $C89E;
0AEA   2601             bne   hilite_string;
0AEC   39        P0AEC: rts;


                 /*
                  * hilite_string()
                  *
                  * This routine is used by print_with_pick_check() to
                  * hi-lite a string once it is picked, and to set several
                  * globals, so that other routine will know a pick occurred.
                  * The address of the string block is in C880.  A copy of
                  * this address will then be saved in C81C, and C89E and
                  * C81B will be set to one (to flag that a pick occurred).
                  */
                 hilite_string:
0AED   FFC882           stu   $C882;
0AF0   FEC880           ldu   $C880;
0AF3   FFC81C           stu   $C81C;
0AF6   BD0B19           jsr   $am_print_string;
0AF9   FEC880           ldu   $C880;
0AFC   BD0B19           jsr   $am_print_string;
0AFF   FEC880           ldu   $C880;
0B02   BD0B19           jsr   $am_print_string;
0B05   FEC880           ldu   $C880;
0B08   BD0B19           jsr   $am_print_string;
0B0B   8601             lda   #0x01;
0B0D   B7C89E           sta   $C89E;
0B10   B7C81B           sta   $C81B;
0B13   FEC882           ldu   $C882;
0B16   1F31             tfr   u,x;
0B18   39               rts;


                 /*
                  * am_print_string()
                  *
                  * Prints a string of character, terminated by 0x80.
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
                  */
                 am_print_string:
0B19   ECC1             ldd   ,u++;
0B1B   FDC82A           std   $C82A;
0B1E   ECC1             ldd   ,u++;
0B20   BDF2FC           jsr   $move_pen7F_to_d;
0B23   EE40             ldu   0,u;
0B25   FFC82C           stu   $C82C;
0B28   335F             leau  -1,u;
0B2A   FFC84F           stu   $C84F;
0B2D   0F0D             clr   0x0D;
0B2F   7FC89E           clr   $C89E;
0B32   8EF9D4           ldx   #0xF9D4;
0B35   CC1883           ldd   #0x1883;
0B38   0F01             clr   0x01;
0B3A   970B             sta   0x0B;
0B3C   D700      P0B3C: stb   0x00;
0B3E   0A00             dec   0x00;
0B40   CC8081           ldd   #0x8081;
0B43   12               nop;
0B44   0C00             inc   0x00;
0B46   D700             stb   0x00;
0B48   9700             sta   0x00;
0B4A   7DC800           tst   $C800;
0B4D   0C00             inc   0x00;
0B4F   B6C82B           lda   $C82B;
0B52   9701             sta   0x01;
0B54   CC0100           ldd   #0x0100;
0B57   FEC82C           ldu   $C82C;
0B5A   9700             sta   0x00;
0B5C   2004             bra   P0B62;
0B5E   A686      P0B5E: lda   a,x;
0B60   970A             sta   0x0A;
0B62   A6C0      P0B62: lda   ,u+;
0B64   2AF8             bpl   P0B5E;
0B66   960D             lda   0x0D;    /* Record any picks. */
0B68   8402             anda  #0x02;
0B6A   BAC89E           ora   $C89E;
0B6D   B7C89E           sta   $C89E;
0B70   12               nop;
0B71   8681             lda   #0x81;
0B73   9700             sta   0x00;
0B75   0001             neg   0x01;
0B77   8601             lda   #0x01;
0B79   9700             sta   0x00;
0B7B   8CFBB4           cmpx  #0xFBB4;
0B7E   272D             beq   P0BAD;
0B80   308850           leax  0x50,x;
0B83   1F30             tfr   u,d;
0B85   B3C84F           subd  $C84F;
0B88   C002             subb  #0x02;
0B8A   58               aslb;
0B8B   2100             brn   P0B8D;
0B8D   8681      P0B8D: lda   #0x81;
0B8F   12               nop;
0B90   5A               decb;
0B91   26FA             bne   P0B8D;
0B93   9700             sta   0x00;
0B95   F6C82A           ldb   $C82A;
0B98   D701             stb   0x01;
0B9A   0A00             dec   0x00;
0B9C   CC8101           ldd   #0x8101;
0B9F   12               nop;
0BA0   9700             sta   0x00;
0BA2   0F01             clr   0x01;
0BA4   D700             stb   0x00;
0BA6   9700             sta   0x00;
0BA8   C683             ldb   #0x83;
0BAA   7E0B3C           jmp   $P0B3C;
0BAD   8698      P0BAD: lda   #0x98;
0BAF   970B             sta   0x0B;
0BB1   7EF354           jmp   $reset0ref;


                 SM_DOT_STR:
0BB4   E8               .byte 0xE8;
0BB5   20               .byte 0x20;
0BB6   80               .byte 0x80;
0BB7   C0               .byte 0xC0;
0BB8   0B               .byte 0x0B;
0BB9   BA               .byte 0xBA;
0BBA   44               .byte "DOT", 0x80;

                 SM_LINE_STR:
0BBE   E8               .byte 0xE8;
0BBF   20               .byte 0x20;
0BC0   80               .byte 0x80;
0BC1   C0               .byte 0xC0;
0BC2   0B               .byte 0x0B;
0BC3   C4               .byte 0xC4;
0BC4   4C               .byte LINE", 0x80;


                 /*
                  * This describes the initial cursor state.
                  */
                 initial_cursor_state:
0BC9   00               .byte 0x00;
0BCA   00               .byte 0x00;
0BCB   78               .byte 0x78;
0BCC   88               .byte 0x88;
0BCD   90               .byte 0x90;
0BCE   78               .byte 0x78;


                 /*
                  * start_of_sketch_connect()
                  *
                  * This is the starting point for the SKETCH and
                  * the CONNECT main menu items.
                  */
                 start_of_sketch_connect:
0BCF   BD0E1F           jsr   $init_sketch_connect_variables;
0BD2   CEC889           ldu   #0xC889;
0BD5   8E0BC9           ldx   #initial_cursor_state;
0BD8   BD08ED           jsr   $set_cursor_structure;
0BDB   8E0BE1           ldx   #sketch_connect_handler;
0BDE   BFC8A7           stx   $C8A7;

                 /*
                  * sketch_connect_handler()
                  *
                  * This is the real main loop routine for the sketch
                  * and connect operatons.  It takes care of reading
                  * the buttons, and calling any button handlers, as
                  * needed.  It is invoked only through the indirect
                  * jump location, by the main loop.
                  */
                 sketch_connect_handler:
0BE1   7FC82E           clr   $C82E;
0BE4   7DC8A6           tst   $C8A6;   /* Check button 4, iff in connect mode */
0BE7   2708             beq   P0BF1;
0BE9   7DC815           tst   $C815;   /* Check button 4;(dot/lines) */
0BEC   2703             beq   P0BF1;
0BEE   73C8A5           com   $C8A5;   /* Complement dot/connect flag */
0BF1   BD0D27    P0BF1: jsr   $display_sc_menu;
0BF4   BD0E38           jsr   $sketch_connect_draw_vector_list;
0BF7   8E0C95           ldx   #fan_handler;
0BFA   7DC812           tst   $C812;   /* Check button 1;(draw) */
0BFD   2610             bne   sc_start_draw;
0BFF   7DC8A6           tst   $C8A6;   /* Check button 4, iff in sketch mode */
0C02   2605             bne   P0C09;
0C04   7DC815           tst   $C815;   /* Check button 4;(fan) */
0C07   2609             bne   sc_start_fan;
0C09   7DC813    P0C09: tst   $C813;   /* Check button 2;(rubber band line) */
0C0C   2638             bne   sc_start_rubber_band_line;
0C0E   39               rts;

                 /*
                  * sc_start_draw()
                  * sc_start_fan()
                  *
                  * These two entry points are responsible for initializing
                  * things when either button 1 (draw) or button 4 (fan)
                  * are pressed during SKETCH or CONNECT modes.  They will
                  * set up a new indirect jump handler, save the current
                  * cursor position, and initialize some variables.
                  */
                 sc_start_draw:
0C0F   8E0C5B           ldx   #sc_draw_handler;
                 sc_start_fan:
0C12   B6C8A3           lda   $C8A3;   /* Don't bother, if the vector */
0C15   81FB             cmpa  #0xFB;   /* list is already full.       */
0C17   2501             blo   P0C1A;
0C19   39               rts;

0C1A   BFC8A7    P0C1A: stx   $C8A7;   /* Save new indirect jump handler. */
0C1D   C603             ldb   #0x03;
0C1F   8EC8A9           ldx   #0xC8A9; /* Load 'x' with pointer to next */
0C22   3D               mul;           /* free spot in the vector list  */
0C23   308B             leax  d,x;     /* buffer.                       */
0C25   6F00             clr   0,x;
0C27   FCC889           ldd   $C889;   /* Fill this spot, using the current */
0C2A   ED01             std   1,x;     /* cursor position.              */
0C2C   7CC8A3           inc   $C8A3;   /* Increment the vector counter. */
0C2F   8605             lda   #0x05;   /* # of pts to draw relative 2 starting*/
0C31   B7C8A4           sta   $C8A4;   /* pt, be4 forcing new absolute ref pt.*/
0C34   FCC889           ldd   $C889;   /* Save current cursor position. */
0C37   FDC89B           std   $C89B;
0C3A   FDC82F           std   $C82F;
0C3D   8608             lda   #0x08;
0C3F   B7C896           sta   $C896;   /* Stores reset value for counter. */
0C42   B7C895           sta   $C895;   /* Active counter; endpoint is fixed */
0C45   39               rts;           /* when this goes to 0.            */


                 /*
                  * sc_start_rubber_band_line()
                  *
                  * This entry point is responsible for setting up the
                  * indirect jump location, and initializing variables
                  * when button 2 (rubber band line) is pressed during
                  * either SKETCH or CONNECT mode.
                  */
                 sc_start_rubber_band_line:
0C46   FCC889           ldd   $C889;   /* Save current cursor position. */
0C49   FDC89B           std   $C89B;
0C4C   8E0CDA           ldx   #rubber_band_line_handler;
0C4F   B6C8A3           lda   $C8A3;   /* Don't bother if the vector list */
0C52   81FB             cmpa  #0xFB;   /* is already full.              */
0C54   2501             blo   P0C57;
0C56   39               rts;
0C57   BFC8A7    P0C57: stx   $C8A7;   /* Save new indirect jump handler. */
0C5A   39               rts;


                 /*
                  * sc_draw_handler()
                  *
                  * This is the routine which draws lines/dots when
                  * button 1 is depressed.  It is invoked only through
                  * the indirect jump location.  It is used only when
                  * either SKETCH or CONNECT modes are active.
                  */
                 sc_draw_handler:
0C5B   BD0D27           jsr   $display_sc_menu;
0C5E   BD0E38           jsr   $sketch_connect_draw_vector_list;
0C61   B6C80F           lda   $C80F;   /* Check if button 1 is still pressed. */
0C64   8401             anda  #0x01;
0C66   260A             bne   P0C72;
0C68   BD0DFA           jsr   $get_new_endpoint;
0C6B   8E0BE1           ldx   #sketch_connect_handler;
0C6E   BFC8A7           stx   $C8A7;
0C71   39               rts;

0C72   FCC89B    P0C72: ldd   $C89B;  /* Don't continue, if the cursor has */
0C75   10B3C889         cmpd  $C889;  /* not moved since last point.       */
0C79   2601             bne   fix_endpoint;
0C7B   39               rts;

                 fix_endpoint:
0C7C   7DC895           tst   $C895;  /* Wait for counter (C895) to decrement */
0C7F   2704             beq   P0C85;  /* to zero, before fixing endpoint.  */
0C81   7AC895           dec   $C895;
0C84   39               rts;

0C85   BD0DFA    P0C85: jsr   $get_new_endpoint;
0C88   FCC889           ldd   $C889;  /* Move the starting point for next */
0C8B   FDC89B           std   $C89B;  /* vector to previous vectors endpt.*/
0C8E   B6C896           lda   $C896;
0C91   B7C895           sta   $C895;  /* Reset 'fix endpoint' counter.    */
0C94   39               rts;


                 /*
                  * fan_handler()
                  *
                  * As long as the user has button 4 pressed, a fan
                  * pattern will be drawn.  Once button 4 is released,
                  * control will return to the sketch/connect handler.
                  */
                 fan_handler:
0C95   86FF             lda   #0xFF;   /* Flag that 'fan' is being done. */
0C97   B7C82E           sta   $C82E;
0C9A   7FC8A4           clr   $C8A4;
0C9D   BD0D27           jsr   $display_sc_menu;
0CA0   BD0E38           jsr   $sketch_connect_draw_vector_list;
0CA3   B6C80F           lda   $C80F;   /* Check if button 4 is still pressed */
0CA6   8408             anda  #0x08;
0CA8   260D             bne   continue_drawing_fan;
0CAA   BD0DFA           jsr   $get_new_endpoint;
0CAD   8E0BE1           ldx   #sketch_connect_handler;
0CB0   BFC8A7           stx   $C8A7;
0CB3   7FC82E           clr   $C82E;
0CB6   39               rts;

                 continue_drawing_fan:
0CB7   FCC89B           ldd   $C89B;   /* Don't add a new line, unless */
0CBA   10B3C889         cmpd  $C889;   /* the cursor position has changed. */
0CBE   2601             bne   P0CC1;
0CC0   39               rts;

0CC1   7DC895    P0CC1: tst   $C895;   /* Don't fix next fan endpt, until */
0CC4   2704             beq   P0CCA;   /* 'fix point' counter has decremented */
0CC6   7AC895           dec   $C895;   /* to zero.                        */
0CC9   39               rts;

0CCA   BD0DFA    P0CCA: jsr   $get_new_endpoint;
0CCD   FCC889           ldd   $C889;   /* Set starting point for next vector */
0CD0   FDC89B           std   $C89B;   /* equal to last vectors endpoint. */
0CD3   B6C896           lda   $C896;
0CD6   B7C895           sta   $C895;   /* Reset 'fix endpoint' counter.  */
0CD9   39               rts;


                 /*
                  * rubber_band_line_handler()
                  *
                  * This is the handler routine while the user is
                  * drawing a rubber band line during sketch or connect
                  * modes.  The rubber band line will continue until the
                  * user stops pressing button 2.  This routine is only
                  * invoked through the indirect jump location.
                  */
                 rubber_band_line_handler:
0CDA   BD0D27           jsr   $display_sc_menu;
0CDD   BD0E38           jsr   $sketch_connect_draw_vector_list;
0CE0   B6C80F           lda   $C80F;   /* See if button 2 still depressed */
0CE3   8402             anda  #0x02;
0CE5   260D             bne   continue_rb_line;
0CE7   7FC8A4           clr   $C8A4;   /* Clear the relative point counter. */
0CEA   BD0DFA           jsr   $get_new_endpoint;
0CED   8E0BE1           ldx   #sketch_connect_handler;
0CF0   BFC8A7           stx   $C8A7;
0CF3   39               rts;

                 continue_rb_line:
0CF4   7DC8A6           tst   $C8A6;  /* Draw the rubber band line from the */
0CF7   2705             beq   P0CFE;  /* originat point to the current cursor */
0CF9   7DC8A5           tst   $C8A5;  /* position, unless in DOT mode.      */
0CFC   260D             bne   P0D0B;
0CFE   BDF2A9    P0CFE: jsr   $intensity_to_7F;
0D01   8EC89B           ldx   #0xC89B;
0D04   108EC889         ldy   #0xC889;
0D08   BD0840           jsr   $draw_vector_with_pick_check;
0D0B   39        P0D0B: rts;


                 HDR_CONNECT_STR:
0D0C   E8               .byte 0xE8;
0D0D   40               .byte 0x40;
0D0E   7F               .byte 0x7F;
0D0F   E8               .byte 0xE8;
0D10   0D               .byte 0x0D;
0D11   12               .byte 0x12;
0D12   43               .byte "CONNECT", 0x80;

                 HDR_SKETCH_STR:
0D1A   E8               .byte 0xE8;
0D1B   40               .byte 0x40;
0D1C   7F               .byte 0x7F;
0D1D   E8               .byte 0xE8;
0D1E   0D               .byte 0x0D;
0D1F   20               .byte 0x20;
0D20   53               .byte "SKETCH", 0x80;


                 /*
                  * display_sc_menu()
                  *
                  * This procedure displays either the SKETCH or CONNECT
                  * header (as an unpickable string), and then also displays
                  * the ERASE, MENU and DOT/LINE sub-items (as pickable strings)
                  * It then checks to see if any of these items were picked,
                  * and handles them is they were. Also displays the cursor.
                  */
                 display_sc_menu:
0D27   BDF2A9           jsr   $intensity_to_7F;
0D2A   BDF354           jsr   $reset0ref;
0D2D   7DC8A6           tst   $C8A6;   /* See if in sketch or connect mode */
0D30   2716             beq   P0D48;
0D32   CE0D0C           ldu   #HDR_CONNECT_STR;    /* CONNECT mode */
0D35   BD0B19           jsr   $am_print_string;
0D38   CE0BB4           ldu   #SM_DOT_STR;   /* Display DOT or LINE item */
0D3B   7DC8A5           tst   $C8A5;
0D3E   2603             bne   P0D43;
0D40   CE0BBE           ldu   #SM_LINE_STR;
0D43   BD0B19    P0D43: jsr   $am_print_string;
0D46   2006             bra   P0D4E;

0D48   CE0D1A    P0D48: ldu   #HDR_SKETCH_STR;    /* SKETCH mode */
0D4B   BD0B19           jsr   $am_print_string;
0D4E   8660      P0D4E: lda   #0x60;           /* Draw cursor at current */
0D50   BDF2AB           jsr   $intensity_to_a; /* position.              */
0D53   FCC889           ldd   $C889;
0D56   BD0EB2           jsr   $am_move_to_d;
0D59   8E052F           ldx   #cross;
0D5C   C60A             ldb   #0x0A;
0D5E   BD07D6           jsr   $draw_with_pick_check;
0D61   BDF2A9           jsr   $intensity_to_7F;
0D64   CEC889           ldu   #0xC889;         /* If cursor is picked, then */
0D67   6D42             tst   2,u;             /* draw it brighter.         */
0D69   2711             beq   P0D7C;
0D6B   BDF354           jsr   $reset0ref;
0D6E   FCC889           ldd   $C889;
0D71   BD0EB2           jsr   $am_move_to_d;
0D74   C60A             ldb   #0x0A;
0D76   8E052F           ldx   #cross;
0D79   BD07D6           jsr   $draw_with_pick_check;
0D7C   BD0901    P0D7C: jsr   $update_cursor_position;
0D7F   CE0056           ldu   #SM_ERASE_STR;    /* Print ERASE item */
0D82   BD0ACF           jsr   $print_with_pick_check;
0D85   B6C80F           lda   $C80F;            /* Check if button 3 */
0D88   8404             anda  #0x04;            /* is pressed and item is */
0D8A   270C             beq   P0D98;            /* picked. */
0D8C   7DC89E           tst   $C89E;
0D8F   2707             beq   P0D98;
0D91   8E0BCF           ldx   #start_of_sketch_connect;
0D94   BFC8A7           stx   $C8A7;
0D97   39               rts;

0D98   CE0062    P0D98: ldu   #SM_MENU_STR;     /* Print MENU item */
0D9B   BD0ACF           jsr   $print_with_pick_check;
0D9E   B6C80F           lda   $C80F;            /* Check if button 3 is */
0DA1   8404             anda  #0x04;            /* pressed and item is picked */
0DA3   270B             beq   P0DB0;
0DA5   7DC89E           tst   $C89E;
0DA8   2706             beq   P0DB0;
0DAA   8E009B           ldx   #display_main_menu;
0DAD   BFC8A7           stx   $C8A7;
0DB0   39        P0DB0: rts;


0DB1   39               .byte 0x39; /* "9" */


                 /*
                  * generate_vector_endpoint_and_recalibrate()
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
                  */
                 generate_vector_endpoint_and_recalibrate:
0DB2   7DC8A4           tst   $C8A4;  /* If the relative pt counter has gone */
0DB5   261F             bne   P0DD6;  /* to zero, then force another absolute*/
0DB7   C603             ldb   #0x03;  /* ref point.                          */
0DB9   8EC8A9           ldx   #0xC8A9;
0DBC   3D               mul;
0DBD   308B             leax  d,x;
0DBF   6F00             clr   0,x;    /* Flag an absolute reference point. */
0DC1   FCC89B           ldd   $C89B;  /* Get starting pt for this vector; if */
0DC4   7DC82E           tst   $C82E;  /* DRAW mode, then use last cursor   */
0DC7   2703             beq   P0DCC;  /* position; else, use cursor position */
0DC9   FCC82F           ldd   $C82F;  /* for beginning of fan.             */
0DCC   ED01      P0DCC: std   1,x;    /* Save abs ref point.               */
0DCE   7CC8A3           inc   $C8A3;  /* Increment vector counter.         */
0DD1   8605             lda   #0x05;  /* Reset the relative point counter. */
0DD3   B7C8A4           sta   $C8A4;
0DD6   CEC8A9    P0DD6: ldu   #0xC8A9;
0DD9   B6C8A3           lda   $C8A3;  /* Load 'u' with pointer to current  */
0DDC   C603             ldb   #0x03;  /* work spot in the vector list.     */
0DDE   3D               mul;
0DDF   33CB             leau  d,u;
0DE1   8EC89B           ldx   #0xC89B; /* Calculate endpt for this vector. */
0DE4   108EC889         ldy   #0xC889;
0DE8   7DC82E           tst   $C82E;
0DEB   2703             beq   P0DF0;
0DED   8EC82F           ldx   #0xC82F;
0DF0   BD0879    P0DF0: jsr   $calculate_vector_endpoint;
0DF3   7CC8A3           inc   $C8A3;  /* Increment vector list counter. */
0DF6   7AC8A4           dec   $C8A4;  /* Decrement relative point counter. */
0DF9   39               rts;


                 /*
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
                  */
                 get_new_endpoint:
0DFA   B6C8A3           lda   $C8A3;   /* See if we have surpassed limit */
0DFD   81FD             cmpa  #0xFD;
0DFF   2501             blo   P0E02;
0E01   39               rts;
0E02   7DC829    P0E02: tst   $C829;   /* Don't make sound more than once */
0E05   260D             bne   P0E14;
0E07   81EE             cmpa  #0xEE;   /* See if we're near limit */
0E09   2509             blo   P0E14;
0E0B   7CC829           inc   $C829;
0E0E   BD0ED8           jsr   $set_up_a_misc_sound1;
0E11   B6C8A3           lda   $C8A3;
0E14   BD0DB2    P0E14: jsr   $generate_vector_endpoint_and_recalibrate;
0E17   E740             stb   0,u;     /* Save scale factor. */
0E19   FCC881           ldd   $C881;
0E1C   ED41             std   1,u;     /* Save vector endpoints. */
0E1E   39               rts;


                 /*
                  * init_sketch_connect_variables()
                  *
                  * This routine is invoked when the sketch/connect
                  * handler is first called.  It is responsible for
                  * initializing the vector list residing in RAM at
                  * C8A9-CBA5 to 0xFF.  It also initializes some RAM
                  * locations to 0.
                  */
                 init_sketch_connect_variables:
0E1F   8EC8A9           ldx   #0xC8A9;
0E22   86FF             lda   #0xFF;
0E24   A780      P0E24: sta   ,x+;
0E26   8CCBA6           cmpx  #0xCBA6;
0E29   26F9             bne   P0E24;
0E2B   7FC8A3           clr   $C8A3;   /* Vector counter. */
0E2E   7FC8A4           clr   $C8A4;   /* Relative point counter. */
0E31   7FC829           clr   $C829;   /* Buffer almost full flag. */
0E34   7FC856           clr   $C856;   /* Sound duration. */
0E37   39               rts;


                 /*
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
                  * If 'scale' is 0xFF, then this is the end of the list.
                  * If 'scale' is 0x00, then the corresponding (y,x) are
                  *     really a new absolute reference point, not relative
                  *     points.
                  * If 'scale' is positive, then draw to new point.
                  * If 'scale' is negative, then move to new point.
                  */
                 sketch_connect_draw_vector_list:
0E38   8660             lda   #0x60;    /* Set up vector intensity. */
0E3A   BDF2AB           jsr   $intensity_to_a;
0E3D   8EC8A9           ldx   #0xC8A9;  /* Start drawing vector list. */
0E40   BD0E54    P0E40: jsr   $draw_relative_points;
0E43   4D               tsta;
0E44   2704             beq   move_to_abs_ref_point;
0E46   BDF354           jsr   $reset0ref;
0E49   39               rts;

                 move_to_abs_ref_point:
0E4A   BDF354           jsr   $reset0ref;  /* Reset zero reference.  */
0E4D   EC81             ldd   ,x++;        /* Move to abs ref point. */
0E4F   BD0EB2           jsr   $am_move_to_d;
0E52   20EC             bra   P0E40;


                 /*
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
                  */
                 draw_relative_points:
0E54   A680             lda   ,x+;    /* Load scale factor; return if it */
0E56   2601             bne   P0E59;  /* flags a new abs reference point.*/
0E58   39               rts;

0E59   81FF      P0E59: cmpa  #0xFF;  /* Check 4 the end of the vector list. */
0E5B   2601             bne   P0E5E;
0E5D   39               rts;

0E5E   7DC8A6    P0E5E: tst   $C8A6;  /* Check for LINE or DOT mode. */
0E61   2705             beq   sc_draw_to_point;
0E63   7DC8A5           tst   $C8A5;
0E66   260D             bne   sc_move_to_point;
                 sc_draw_to_point:
0E68   4D               tsta;         /* Check for move/draw operation. */
0E69   2B0A             bmi   sc_move_to_point;
0E6B   C6FF             ldb   #0xFF;
0E6D   F7C880           stb   $C880;
0E70   BD0E8F           jsr   $am_draw_with_pattern;
0E73   20DF             bra   draw_relative_points;
                 sc_move_to_point:
0E75   030A             com   0x0A;
0E77   1E11             exg   x,x;
0E79   1E11             exg   x,x;
0E7B   030A             com   0x0A;
0E7D   847F             anda  #0x7F;
0E7F   7FC880           clr   $C880;   /* Clear vector pattern. */
0E82   BD0E8F           jsr   $am_draw_with_pattern;
0E85   030A             com   0x0A;
0E87   1E11             exg   x,x;
0E89   1E11             exg   x,x;
0E8B   0F0A             clr   0x0A;
0E8D   20C5             bra   draw_relative_points;


                 /*
                  * am_draw_with_pattern (point, scale_index, pattern)
                  *
                  * This moves the cursor to a particular point,
                  * using one of several scale factors, and a line
                  * pattern specified in C880.
                  * At entry:   'x' points to vector list of rel y, relx.
                  *             'a' has index into scale factor array.
                  *             C880 has line pattern.
                  */
                 am_draw_with_pattern:
0E8F   CE08E7           ldu   #am_scale_factors;
0E92   A6C6             lda   a,u;     /* Load the scale factor */
0E94   9704             sta   0x04;
0E96   EC81             ldd   ,x++;    /* Load vector endpoints */
0E98   9701             sta   0x01;
0E9A   0F00             clr   0x00;
0E9C   B6C880           lda   $C880;   /* Load line pattern from C880 */
0E9F   0C00             inc   0x00;
0EA1   D701             stb   0x01;
0EA3   0F05             clr   0x05;
0EA5   970A             sta   0x0A;
0EA7   8640             lda   #0x40;
0EA9   950D      P0EA9: bita  0x0D;
0EAB   27FC             beq   P0EA9;
0EAD   12               nop;
0EAE   12               nop;
0EAF   0F0A             clr   0x0A;    /* Clear the line pattern */
0EB1   39               rts;


                 /*
                  * am_move_to_d()
                  *
                  * This routine does a quick move to the point
                  * specified in the 'd' register (a = rel y,
                  * b = rel x).  A scale factor of 0x7F is used.
                  */
                 am_move_to_d:
0EB2   9701             sta   0x01;
0EB4   0F00             clr   0x00;
0EB6   867F             lda   #0x7F;
0EB8   9704             sta   0x04;
0EBA   86CE             lda   #0xCE;
0EBC   970C             sta   0x0C;
0EBE   8640             lda   #0x40; /* "@" */
0EC0   0C00             inc   0x00;
0EC2   D701             stb   0x01;
0EC4   0F05             clr   0x05;
0EC6   950D      P0EC6: bita  0x0D;
0EC8   27FC             beq   P0EC6;
0ECA   39               rts;


                 /*
                  * check_for_end_of_sound()
                  *
                  * This routine checks to see if the current
                  * miscellaneous sound has completed, by checking
                  * the value in C856.  When it reaches zero, the
                  * sound is done.
                  */
                 check_for_end_of_sound:
0ECB   7DC856           tst   $C856;
0ECE   2604             bne   P0ED4;
0ED0   BDF533           jsr   $init_music_buf;
0ED3   39               rts;
0ED4   7AC856    P0ED4: dec   $C856;
0ED7   39               rts;


                 /*
                  * set_up_a_misc_sound1()
                  * set_up_a_misc_sound2(sound)
                  *
                  * Both of these routines cause a sound to be
                  * made.  If set_up_a_misc_sound1() is used,
                  * then the sound to be made is defined by
                  * writing the value 0x0050 to reg 0 & reg 1
                  * on the sound chip.  If set_up_a_misc_sound2()
                  * is used, then the value passed in in the 'd'
                  * register defines the sound.  The duration of
                  * the sound is stored in C856.
                  */
                 set_up_a_misc_sound1:
0ED8   CC0050           ldd   #0x0050;
                 set_up_a_misc_sound2:
0EDB   FDC84B           std   $C84B;
0EDE   863E             lda   #0x3E; /* ">" */
0EE0   B7C845           sta   $C845;
0EE3   860A             lda   #0x0A;
0EE5   B7C844           sta   $C844;
0EE8   8605             lda   #0x05;
0EEA   B7C856           sta   $C856;
0EED   39               rts;


                AM_music:
0EEE   FE               .word 0xFE28;
0EF0   FE               .word 0xFEB6;
0EF2   A6               .byte 0xA6;
0EF3   0A               .byte 0x0A;
0EF4   10               .byte 0x10;
0EF5   98               .byte 0x98;
0EF6   0A               .byte 0x0A;
0EF7   0C               .byte 0x0C;
0EF8   96               .byte 0x96;
0EF9   0A               .byte 0x0A;
0EFA   04               .byte 0x04;
0EFB   98               .byte 0x98;
0EFC   0C               .byte 0x0C;
0EFD   10               .byte 0x10;
0EFE   96               .byte 0x96;
0EFF   0C               .byte 0x0C;
0F00   0C               .byte 0x0C;
0F01   95               .byte 0x95;
0F02   0C               .byte 0x0C;
0F03   04               .byte 0x04;
0F04   96               .byte 0x96;
0F05   07               .byte 0x07;
0F06   10               .byte 0x10;
0F07   95               .byte 0x95;
0F08   07               .byte 0x07;
0F09   0C               .byte 0x0C;
0F0A   93               .byte 0x93;
0F0B   07               .byte 0x07;
0F0C   04               .byte 0x04;
0F0D   95               .byte 0x95;
0F0E   1A               .byte 0x1A;
0F0F   10               .byte 0x10;
0F10   92               .byte 0x92;
0F11   1A               .byte 0x1A;
0F12   10               .byte 0x10;
0F13   3F               .byte 0x3F; /* "?" */
0F14   80               .byte 0x80;

0F15   3B               .byte 0x3B; /* ";" */
0F16   00               .byte 0x00;
0F17   3B               .byte 0x3B; /* ";" */
0F18   00               .byte 0x00;
0F19   3B               .byte 0x3B; /* ";" */
0F1A   00               .byte 0x00;
0F1B   3B               .byte 0x3B; /* ";" */
0F1C   00               .byte 0x00;
0F1D   3B               .byte 0x3B; /* ";" */
0F1E   00               .byte 0x00;
0F1F   3B               .byte 0x3B; /* ";" */
0F20   00               .byte 0x00;
0F21   3B               .byte 0x3B; /* ";" */
0F22   00               .byte 0x00;
0F23   3B               .byte 0x3B; /* ";" */
0F24   00               .byte 0x00;
0F25   3B               .byte 0x3B; /* ";" */
0F26   00               .byte 0x00;
0F27   3B               .byte 0x3B; /* ";" */
0F28   00               .byte 0x00;
0F29   3B               .byte 0x3B; /* ";" */
0F2A   00               .byte 0x00;
0F2B   3B               .byte 0x3B; /* ";" */
0F2C   00               .byte 0x00;
0F2D   3B               .byte 0x3B; /* ";" */
0F2E   00               .byte 0x00;
0F2F   3B               .byte 0x3B; /* ";" */
0F30   00               .byte 0x00;
0F31   3B               .byte 0x3B; /* ";" */
0F32   00               .byte 0x00;
0F33   3B               .byte 0x3B; /* ";" */
0F34   00               .byte 0x00;
0F35   3B               .byte 0x3B; /* ";" */
0F36   00               .byte 0x00;
0F37   3B               .byte 0x3B; /* ";" */
0F38   00               .byte 0x00;
0F39   3B               .byte 0x3B; /* ";" */
0F3A   00               .byte 0x00;
0F3B   3B               .byte 0x3B; /* ";" */
0F3C   00               .byte 0x00;
0F3D   3B               .byte 0x3B; /* ";" */
0F3E   00               .byte 0x00;
0F3F   3B               .byte 0x3B; /* ";" */
0F40   00               .byte 0x00;
0F41   3B               .byte 0x3B; /* ";" */
0F42   00               .byte 0x00;
0F43   3B               .byte 0x3B; /* ";" */
0F44   00               .byte 0x00;
0F45   3B               .byte 0x3B; /* ";" */
0F46   00               .byte 0x00;
0F47   3B               .byte 0x3B; /* ";" */
0F48   00               .byte 0x00;
0F49   3B               .byte 0x3B; /* ";" */
0F4A   00               .byte 0x00;
0F4B   3B               .byte 0x3B; /* ";" */
0F4C   00               .byte 0x00;
0F4D   3B               .byte 0x3B; /* ";" */
0F4E   00               .byte 0x00;
0F4F   3B               .byte 0x3B; /* ";" */
0F50   00               .byte 0x00;
0F51   3B               .byte 0x3B; /* ";" */
0F52   00               .byte 0x00;
0F53   3B               .byte 0x3B; /* ";" */
0F54   00               .byte 0x00;
0F55   3B               .byte 0x3B; /* ";" */
0F56   00               .byte 0x00;
0F57   3B               .byte 0x3B; /* ";" */
0F58   00               .byte 0x00;
0F59   3B               .byte 0x3B; /* ";" */
0F5A   00               .byte 0x00;
0F5B   3B               .byte 0x3B; /* ";" */
0F5C   00               .byte 0x00;
0F5D   3B               .byte 0x3B; /* ";" */
0F5E   00               .byte 0x00;
0F5F   3B               .byte 0x3B; /* ";" */
0F60   00               .byte 0x00;
0F61   3B               .byte 0x3B; /* ";" */
0F62   00               .byte 0x00;
0F63   3B               .byte 0x3B; /* ";" */
0F64   00               .byte 0x00;
0F65   3B               .byte 0x3B; /* ";" */
0F66   00               .byte 0x00;
0F67   3B               .byte 0x3B; /* ";" */
0F68   00               .byte 0x00;
0F69   3B               .byte 0x3B; /* ";" */
0F6A   00               .byte 0x00;
0F6B   3B               .byte 0x3B; /* ";" */
0F6C   00               .byte 0x00;
0F6D   3B               .byte 0x3B; /* ";" */
0F6E   00               .byte 0x00;
0F6F   3B               .byte 0x3B; /* ";" */
0F70   00               .byte 0x00;
0F71   3B               .byte 0x3B; /* ";" */
0F72   00               .byte 0x00;
0F73   3B               .byte 0x3B; /* ";" */
0F74   00               .byte 0x00;
0F75   3B               .byte 0x3B; /* ";" */
0F76   00               .byte 0x00;
0F77   3B               .byte 0x3B; /* ";" */
0F78   00               .byte 0x00;
0F79   3B               .byte 0x3B; /* ";" */
0F7A   00               .byte 0x00;
0F7B   3B               .byte 0x3B; /* ";" */
0F7C   00               .byte 0x00;
0F7D   3B               .byte 0x3B; /* ";" */
0F7E   33               .byte 0x33; /* "3" */
0F7F   00               .byte 0x00;
0F80   69               .byte 0x69; /* "i" */
0F81   84               .byte 0x84;
0F82   00               .byte 0x00;
0F83   69               .byte 0x69; /* "i" */
0F84   84               .byte 0x84;
0F85   3B               .byte 0x3B; /* ";" */
0F86   00               .byte 0x00;
0F87   3B               .byte 0x3B; /* ";" */
0F88   00               .byte 0x00;
0F89   3B               .byte 0x3B; /* ";" */
0F8A   00               .byte 0x00;
0F8B   3B               .byte 0x3B; /* ";" */
0F8C   00               .byte 0x00;
0F8D   3B               .byte 0x3B; /* ";" */
0F8E   00               .byte 0x00;
0F8F   3B               .byte 0x3B; /* ";" */
0F90   00               .byte 0x00;
0F91   3B               .byte 0x3B; /* ";" */
0F92   00               .byte 0x00;
0F93   3B               .byte 0x3B; /* ";" */
0F94   00               .byte 0x00;
0F95   3B               .byte 0x3B; /* ";" */
0F96   00               .byte 0x00;
0F97   3B               .byte 0x3B; /* ";" */
0F98   00               .byte 0x00;
0F99   3B               .byte 0x3B; /* ";" */
0F9A   00               .byte 0x00;
0F9B   3B               .byte 0x3B; /* ";" */
0F9C   00               .byte 0x00;
0F9D   3B               .byte 0x3B; /* ";" */
0F9E   00               .byte 0x00;
0F9F   3B               .byte 0x3B; /* ";" */
0FA0   00               .byte 0x00;
0FA1   3B               .byte 0x3B; /* ";" */
0FA2   00               .byte 0x00;
0FA3   3B               .byte 0x3B; /* ";" */
0FA4   00               .byte 0x00;
0FA5   3B               .byte 0x3B; /* ";" */
0FA6   00               .byte 0x00;
0FA7   3B               .byte 0x3B; /* ";" */
0FA8   00               .byte 0x00;
0FA9   3B               .byte 0x3B; /* ";" */
0FAA   00               .byte 0x00;
0FAB   3B               .byte 0x3B; /* ";" */
0FAC   00               .byte 0x00;
0FAD   3B               .byte 0x3B; /* ";" */
0FAE   00               .byte 0x00;
0FAF   3B               .byte 0x3B; /* ";" */
0FB0   00               .byte 0x00;
0FB1   3B               .byte 0x3B; /* ";" */
0FB2   00               .byte 0x00;
0FB3   3B               .byte 0x3B; /* ";" */
0FB4   00               .byte 0x00;
0FB5   3B               .byte 0x3B; /* ";" */
0FB6   00               .byte 0x00;
0FB7   3B               .byte 0x3B; /* ";" */
0FB8   00               .byte 0x00;
0FB9   3B               .byte 0x3B; /* ";" */
0FBA   00               .byte 0x00;
0FBB   3B               .byte 0x3B; /* ";" */
0FBC   00               .byte 0x00;
0FBD   3B               .byte 0x3B; /* ";" */
0FBE   00               .byte 0x00;
0FBF   3B               .byte 0x3B; /* ";" */
0FC0   00               .byte 0x00;
0FC1   3B               .byte 0x3B; /* ";" */
0FC2   00               .byte 0x00;
0FC3   3B               .byte 0x3B; /* ";" */
0FC4   00               .byte 0x00;
0FC5   3B               .byte 0x3B; /* ";" */
0FC6   00               .byte 0x00;
0FC7   3B               .byte 0x3B; /* ";" */
0FC8   00               .byte 0x00;
0FC9   3B               .byte 0x3B; /* ";" */
0FCA   00               .byte 0x00;
0FCB   3B               .byte 0x3B; /* ";" */
0FCC   00               .byte 0x00;
0FCD   3B               .byte 0x3B; /* ";" */
0FCE   00               .byte 0x00;
0FCF   3B               .byte 0x3B; /* ";" */
0FD0   00               .byte 0x00;
0FD1   3B               .byte 0x3B; /* ";" */
0FD2   00               .byte 0x00;
0FD3   3B               .byte 0x3B; /* ";" */
0FD4   00               .byte 0x00;
0FD5   3B               .byte 0x3B; /* ";" */
0FD6   00               .byte 0x00;
0FD7   3B               .byte 0x3B; /* ";" */
0FD8   00               .byte 0x00;
0FD9   3B               .byte 0x3B; /* ";" */
0FDA   00               .byte 0x00;
0FDB   3B               .byte 0x3B; /* ";" */
0FDC   00               .byte 0x00;
0FDD   3B               .byte 0x3B; /* ";" */
0FDE   00               .byte 0x00;
0FDF   3B               .byte 0x3B; /* ";" */
0FE0   00               .byte 0x00;
0FE1   3B               .byte 0x3B; /* ";" */
0FE2   00               .byte 0x00;
0FE3   3B               .byte 0x3B; /* ";" */
0FE4   00               .byte 0x00;
0FE5   3B               .byte 0x3B; /* ";" */
0FE6   00               .byte 0x00;
0FE7   3B               .byte 0x3B; /* ";" */
0FE8   00               .byte 0x00;
0FE9   3B               .byte 0x3B; /* ";" */
0FEA   00               .byte 0x00;
0FEB   3B               .byte 0x3B; /* ";" */
0FEC   00               .byte 0x00;
0FED   3B               .byte 0x3B; /* ";" */
0FEE   00               .byte 0x00;
0FEF   3B               .byte 0x3B; /* ";" */
0FF0   00               .byte 0x00;
0FF1   3B               .byte 0x3B; /* ";" */
0FF2   00               .byte 0x00;
0FF3   3B               .byte 0x3B; /* ";" */
0FF4   00               .byte 0x00;
0FF5   3B               .byte 0x3B; /* ";" */
0FF6   00               .byte 0x00;
0FF7   3B               .byte 0x3B; /* ";" */
0FF8   00               .byte 0x00;
0FF9   3B               .byte 0x3B; /* ";" */
0FFA   00               .byte 0x00;
0FFB   3B               .byte 0x3B; /* ";" */
0FFC   00               .byte 0x00;
0FFD   3B               .byte 0x3B; /* ";" */
0FFE   00               .byte 0x00;
0FFF   3B               .byte 0x3B; /* ";" */

