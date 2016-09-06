/*
 * This work was originally done by Fred Taft (fred@hp-pcd.cv.hp.com).
 * Please forward any comments, corrections or additions back to Fred.
 *
 * Exec Rom
 */


                        .org  0xF000
                 /*
                  * The executive OS code starts running here, each time
                  * the system is reset or powered up.
                  */
                 start_of_OS_ROM:
F000   10CECBEA         lds   #0xCBEA;   /* Set up stack pointer. */
F004   BDF18B           jsr   $reinit;
F007   CC7321           ldd   #0x7321;
F00A   10B3CBFE         cmpd  $CBFE;     /* See if cold start is necessary. */
F00E   275C             beq   PF06C;
F010   FDCBFE           std   $CBFE;
F013   7CC83B           inc   $C83B;
F016   8ECBEB           ldx   #0xCBEB;
F019   BDF84F           jsr   $set_dft_score;

                 /* Start of initial powerup loop */
                 powerup_loop:
F01C   BDF1AF           jsr   $dptoC8;
F01F   DC25             ldd   0x25;
F021   10830101         cmpd  #0x0101;  /* Once we have looped 257 time, */
F025   2602             bne   PF029;    /* flag that it is alright to start */
F027   D756             stb   0x56;     /* playing the intro music.      */

                 /* Load the line pattern used for drawing boundary lines */
F029   57        PF029: asrb;
F02A   C403             andb  #0x03;
F02C   8EF0FD           ldx   #line_patterns;
F02F   E685             ldb   b,x;
F031   D729             stb   0x29;
F033   C602             ldb   #0x02;
F035   D724             stb   0x24;

                 /* Play the introductory song */
F037   CEFD0D           ldu   #intro_music_block;
F03A   BDF687           jsr   $init_sound;
F03D   BDF192           jsr   $waitrecal;
F040   BDF289           jsr   $do_sound;

                 /* Display the Vectrex power-up message */
F043   BDF2A9           jsr   $intensity_to_7F;
F046   B6C826           lda   $C826;
F049   CEF10C           ldu   #vectrex_string;
F04C   8520             bita  #0x20;     /* Determine if double or single */
F04E   2702             beq   PF052;     /* Vectrex string should be shown. */
F050   334C             leau  12,u;
F052   BDF385    PF052: jsr   $printu;

                 /* Draw the edge boundary boxes */
F055   8EF0E9           ldx   #intro_box;
F058   BDF308    PF058: jsr   $move_penFF;
F05B   8603             lda   #0x03;
F05D   BDF434           jsr   $dwp_with_count;
F060   7AC824           dec   $C824;
F063   26F3             bne   PF058;
F065   B6C825           lda   $C825;
F068   8101             cmpa  #0x01;
F06A   23B0             bls   powerup_loop;
                 /* End of initial powerup loop */

                 /* Prepare to check to see if a valid ROM is installed */
F06C   BDF1AF    PF06C: jsr   $dptoC8;
F06F   86CC             lda   #0xCC;
F071   9729             sta   0x29;
F073   CCF101           ldd   #gce_copyright_string;
F076   DD39             std   0x39;
F078   0F25             clr   0x25;
F07A   0F26             clr   0x26;

                 /* Check to see if a valid game ROM is installed */
F07C   CE0000           ldu   #0x0000;
F07F   8EF101           ldx   #gce_copyright_string;
F082   C60B             ldb   #0x0B;
F084   A6C0      PF084: lda   ,u+;
F086   A180             cmpa  ,x+;
F088   270D             beq   PF097;
F08A   C101             cmpb  #0x01;
F08C   2704             beq   PF092;
F08E   C105             cmpb  #0x05;
F090   2305             bls   PF097;
F092   CEE000    PF092: ldu   #0xE000;
F095   2007             bra   PF09E;
F097   5A        PF097: decb;
F098   26EA             bne   PF084;
F09A   D739             stb   0x39;     /* Save address of game cartridge's */
F09C   D73A             stb   0x3A;     /* copyright string.                */

                 /* Prepare to play the game's introductory tune */
F09E   0C56      PF09E: inc   0x56;
F0A0   DF37             stu   0x37;
F0A2   EEC4             ldu   ,u;

                 /* Start of second powerup loop */
                 powerup_loop2:
F0A4   BDF1AF           jsr   $dptoC8;
F0A7   CCF848           ldd   #0xF848;
F0AA   DD2A             std   0x2A;

                 /* Start playing the tune */
F0AC   BDF687           jsr   $init_sound;
F0AF   BDF192           jsr   $waitrecal;
F0B2   BDF289           jsr   $do_sound;

                 /* Display cartridges 'gce' copyright string */
F0B5   BDF2A9           jsr   $intensity_to_7F;
F0B8   CCC0C0           ldd   #0xC0C0;
F0BB   FEC839           ldu   $C839;
F0BE   BDF37A           jsr   $print_at_d;

                 /* Display the current high score, if any */
F0C1   B6C83B           lda   $C83B;
F0C4   260C             bne   PF0D2;
F0C6   4A               deca;
F0C7   CECBEB           ldu   #0xCBEB;
F0CA   A746             sta   6,u;
F0CC   CC68D0           ldd   #0x68D0;
F0CF   BDF37A           jsr   $print_at_d;

                 /* Display the name of the game cartridge */
F0D2   FEC837    PF0D2: ldu   $C837;
F0D5   3342             leau  2,u;
F0D7   BDF385           jsr   $printu;
F0DA   B6C856           lda   $C856;
F0DD   26C5             bne   powerup_loop2;
F0DF   BEC825           ldx   $C825;
F0E2   8C007D           cmpx  #0x007D;
F0E5   23BD             bls   powerup_loop2;
                 /* End of second powerup loop */

                 /* Jump to the start of the current game */
F0E7   6E41             jmp   1,u;


                 /* Vector list (y,x) for outer boundary box */
                 intro_box:
F0E9   40               .byte 0x40,0xD6;
F0EB   00               .byte 0x00,0x56;
F0ED   81               .byte 0x81,0x00;
F0EF   00               .byte 0x00,0xA9;
F0F1   7E               .byte 0x7E,0x00;

                 /* Vector list (y,x) for inner boundary box */
                 intro_box2:
F0F3   39               .byte 0x39,0xDC;
F0F5   8E               .byte 0x8E,0x00;
F0F7   00               .byte 0x00,0x4A;
F0F9   72               .byte 0x72,0x00;
F0FB   00               .byte 0x00,0xB6;

                 /* Line patterns used when drawing boundary boxes */
                 line_patterns:
F0FD   E0               .byte 0xE0;  /* Pattern = 11100000 */
F0FE   38               .byte 0x38;  /* Pattern = 00111000 */
F0FF   0E               .byte 0x0E;  /* Pattern = 00001110 */
F100   03               .byte 0x03;  /* Pattern = 00000011 */

                 /* Copyright string used to check for valid game ROM */
                 gce_copyright_string:
F101   67               .byte "g GCE 1982",0x80;

                 /* Introductory Vectrex title string */
                 vectrex_string:
F10C   F1               .byte 0xF1; /* height */
F10D   60               .byte 0x60; /* width  */
F10E   27               .byte 0x27; /* rel y  */
F10F   CF               .byte 0xCF; /* rel x  */
F110   56               .byte "VECTREX",0x80;
F118   F3               .byte 0xF3; /* height */
F119   60               .byte 0x60; /* width  */
F11A   26               .byte 0x26; /* rel y  */
F11B   CF               .byte 0xCF; /* rel x  */
F11C   56               .byte "VECTREX",0x80;
F124   FC               .byte 0xFC; /* height */
F125   60               .byte 0x60; /* width  */
F126   DF               .byte 0xDF; /* rel y  */
F127   E9               .byte 0xE9; /* rel x  */
F128   47               .byte "GCE",0x80;
F12C   FC               .byte 0xFC; /* height */
F12D   38               .byte 0x38; /* width  */
F12E   CC               .byte 0xCC; /* rel y  */
F12F   D1               .byte 0xD1; /* rel x  */
F130   45               .byte "ENTERTAINING",0x80;
F13D   FC               .byte 0xFC; /* height */
F13E   38               .byte 0x38; /* width  */
F13F   BC               .byte 0xBC; /* rel y  */
F140   DC               .byte 0xDC; /* rel x  */
F141   4E               .byte "NEW IDEAS",0x80, 0x00;


                 /*
                  * init_PIA_chip()
                  *
                  * This routine is invoked during powerup, to initialize
                  * the PIA chip.  Among other things, it initializes the
                  * scale factor to 0x7F, and set the direction for the
                  * A and B data lines.
                  *
                  * At exit:
                  *     Dp will be set to D0.
                  */
                 init_PIA_chip:
F14C   8D5C             bsr   dptoD0;
F14E   CC9FFF           ldd   #0x9FFF;
F151   DD02             std   0x02;
F153   CC0100           ldd   #0x0100;
F156   DD00             std   0x00;
F158   CC987F           ldd   #0x987F;
F15B   970B             sta   0x0B;
F15D   D704             stb   0x04;
F15F   BDF354           jsr   $reset0ref;
F162   203E             bra   set_refresh;


                 /*
                  * initialize_OS_RAM()
                  *
                  * This routine first clears the block of RAM in the
                  * range C800 to C87A, and then it initializes the
                  * dot dwell time, the refresh time, and the joystick
                  * enable flags.
                  *
                  * At exit:
                  *     Dp will be set to C8.
                  */
                 initialize_OS_RAM:
F164   8D49             bsr   dptoC8;
F166   C67A             ldb   #0x7A;
F168   8EC800           ldx   #0xC800;
F16B   BDF53F           jsr   $clear_blockxb;
F16E   CCC87D           ldd   #0xC87D;
F171   DD7B             std   0x7B;
                 init_flags1:
F173   0C7D             inc   0x7D;
F175   27FC             beq   init_flags1;
F177   8605             lda   #0x05;
F179   9728             sta   0x28;
F17B   CC3075           ldd   #0x3075;
F17E   DD3D             std   0x3D;
F180   CC0103           ldd   #0x0103;
F183   DD1F             std   0x1F;
F185   CC0507           ldd   #0x0507;
F188   DD21             std   0x21;
F18A   39               rts;


                 /*
                  * reinit()
                  *
                  * This routine is responsible for setting up the initial
                  * system state, each time the system is either reset or
                  * powered up.  It will initialize the OS RAM area,
                  * initialize the PIA chip, and then clear out all the
                  * registers on the sound chip.
                  *
                  * At exit:
                  *     Dp will be set to D0.
                  */
                 reinit:
F18B   8DD7             bsr   initialize_OS_RAM;
F18D   8DBD             bsr   init_PIA_chip;
F18F   7EF272           jmp   $clear_sound_chip;


                 /*
                  * waitrecal()
                  *
                  * Wait for t2 (the refresh timer) to timeout, then restart
                  * it using the value ic C83D.  then, recalibrate the
                  * vector generators to the origin (0,0).  This routine
                  * MUST be called once every refresh cycle, or your vectors
                  * will get out of whack.  This routine calls reset0ref,
                  * so the integrators are left in zero mode.
                  *
                  * At exit:
                  *     Dp will be set to D0.
                  */
                 waitrecal:
F192   BEC825           ldx   $C825;
F195   3001             leax  1,x;      /* Increment loop counter. */
F197   BFC825           stx   $C825;
F19A   8D0E             bsr   dptoD0;
F19C   8620             lda   #0x20;
F19E   950D      PF19E: bita  0x0D;
F1A0   27FC             beq   PF19E;


                 /*
                  * set_refresh()
                  *
                  * This routine loads the refresh timer (t2) with the value
                  * in C83D-C83E, and recalibrates the vector generators,
                  * thus causing the pen to be left at the origin (0,0).
                  * The high order byte for the timer is loaded from C83E,
                  * and the low order byte is loaded from C83D.  The
                  * refresh rate is calculated as follows:
                  *
                  *   rate = (C83E)(C83D) / 1.5 mhz
                  *
                  * At entry:
                  *     Dp must be D0.
                  */
                  set_refresh:
F1A2   FCC83D           ldd   $C83D;
F1A5   DD08             std   0x08;
F1A7   7EF2E6           jmp   $PF2E6;


                 /*
                  * dptoD0()
                  *
                  * Sets the dp register to D0, so that all direct addresses
                  * will start at D000 (the hardware I/O area).
                  *
                  * At exit:
                  *     Dp will be set to D0.
                  *     'a' will be trashed.
                  */
                 dptoD0:
F1AA   86D0             lda   #0xD0;
F1AC   1F8B             tfr   a,dp;
F1AE   39               rts;


                 /*
                  * dptoC8()
                  *
                  * Sets the Dp register to C8, so that all direct addresses
                  * start at C800 (OS RAM area).
                  *
                  * At exit:
                  *     Dp will be set to C8.
                  *     'a' will be trashed.
                  */
                 dptoC8:
F1AF   86C8             lda   #0xC8;
F1B1   1F8B             tfr   a,dp;
F1B3   39               rts;


                 /*
                  * read_switches()
                  * read_switches2()
                  *
                  * Both of these routines read the button states on the
                  * two consoles, and return their state in the following
                  * RAM locations:
                  *
                  *     console 1, button 1:    C812
                  *                button 2:    C813
                  *                button 3:    C814
                  *                button 4:    C815
                  *     console 2, button 1:    C816
                  *                button 2:    C817
                  *                button 3:    C818
                  *                button 4:    C819
                  *
                  * Also, these routines provide several other pieces of
                  * information which are useful:
                  *
                  *     C80F: Contains current state of all buttons;
                  *           1 = depressed, 0 = not depressed
                  *
                  *     C810: Contains state of all buttons from LAST
                  *           time these routines were called; if read_switches
                  *           was invoked, then this is AND'ed with the
                  *           passed in mask.
                  *
                  *     For the above 2 bytes, bit 1 is console1:button1.
                  *
                  * If read_switches2() is called, then the current state
                  * of all the buttons will be returned.
                  *
                  * If read_switches() is called, then a mask, passed in
                  * in the 'a' register and having the following format,
                  * will be used to determine how the buttons state info
                  * is returned:
                  *
                  *     bit 0 = console1:button1
                  *     bit 1 = console1:button2
                  *     etc
                  *
                  * If a bit is 0, then the current state of the button is
                  * to be returned in the appropriate RAM location;
                  * 0 = not pressed, and 1 = pressed.
                  *
                  * If a bit is 1, then the appropriate RAM location is set
                  * to 1 only on the depression transition of the button;
                  * additional calls will return 0, until the button is
                  * released and then depressed again.
                  *
                  * At entry:
                  *     Dp must be set to D0.
                  *     'a' must contain mask (for read_switches only)
                  */
                 read_switches:
F1B4   B4C80F           anda  $C80F;
F1B7   B7C80F           sta   $C80F;
                 read_switches2:
F1BA   8EC812           ldx   #0xC812;
F1BD   A61D             lda   -3,x;
F1BF   A71E             sta   -2,x;
F1C1   860E             lda   #0x0E;
F1C3   9701             sta   0x01;
F1C5   CC1901           ldd   #0x1901;
F1C8   9700             sta   0x00;
F1CA   12               nop;
F1CB   D700             stb   0x00;
F1CD   0F03             clr   0x03;
F1CF   CC0901           ldd   #0x0901;
F1D2   9700             sta   0x00;
F1D4   12               nop;
F1D5   9601             lda   0x01;
F1D7   43               coma;
F1D8   A71D             sta   -3,x;
F1DA   D700             stb   0x00;
F1DC   C6FF             ldb   #0xFF;
F1DE   D703             stb   0x03;
F1E0   43               coma;
F1E1   AA1E             ora   -2,x;
F1E3   43               coma;
F1E4   A71F             sta   -1,x;
F1E6   3402             pshs  a;
F1E8   C601             ldb   #0x01;
F1EA   1F98      PF1EA: tfr   b,a;
F1EC   A4E4             anda  ,s;
F1EE   A780             sta   ,x+;
F1F0   58               aslb;
F1F1   26F7             bne   PF1EA;
F1F3   3582             puls  a,pc;


F1F5   7AC823    PF1F5: dec   $C823;


                 /*
                  * read_jstick()
                  *
                  * This routine reads the current positions of the joysticks
                  * on the two consoles.  Before calling this routine, some
                  * prior setup is required.  Firstly, the joystick enable
                  * flags (C81F-C822) must be initialized to one of the
                  * following values:
                  *
                  *     0 - ignore; return no value.
                  *     1 - return state of console 1 left/right position.
                  *     3 - return state of console 1 up/down position.
                  *     5 - return state of console 2 left/right position.
                  *     7 - return state of console 2 up/down position.
                  *
                  * The joystick values are returned in C81B-C81E, where the
                  * value returned in C81B corresponds to the mask set in
                  * in C81F, and so on and so forth.
                  *
                  * Location C823 is used to determine what kind of input
                  * conversion should be performed, and how the data should
                  * be returned to the calling procedure.  Valid choices are:
                  *
                  *     >= 0    The return value will be:
                  *               < 0 if joystick is left of down of center.
                  *               = 0 if joystick is centered.
                  *               > 0 if joystick is right or up of center.
                  *
                  *     < 0     A successive approximation algorithm is used
                  *             read the actual value of the joystick pot, a
                  *             signed value.  In this case, C81A must be set
                  *             to a power of 2, to control conversion
                  *             resolution; 0x80 is least accurate, and 0x00
                  *             is most accurate.
                  *
                  * At entry:
                  *     Dp must be set to D0.
                  *
                  * At exit:
                  *     C823 is cleared.
                  */
                 read_jstick:
F1F8   8EC81F           ldx   #0xC81F;
                 next_pot:
F1FB   A680             lda   ,x+;
F1FD   260C             bne   process_a_pot;
                 check_4_done:
F1FF   8CC823           cmpx  #0xC823;
F202   26F7             bne   next_pot;
F204   6F84             clr   ,x;
F206   8601             lda   #0x01;
F208   9700             sta   0x00;
F20A   39               rts;
                 process_a_pot:
F20B   9700             sta   0x00;
F20D   0F01             clr   0x01;
F20F   0A00             dec   0x00;
F211   C660             ldb   #0x60; /* "`" */
F213   5C        PF213: incb;
F214   2AFD             bpl   PF213;
F216   B6C823           lda   $C823;
F219   2B25             bmi   use_approx;
F21B   8620             lda   #0x20; /* " " */
F21D   0C00             inc   0x00;
F21F   9500             bita  0x00;
F221   270A             beq   left_or_down;
F223   C640             ldb   #0x40; /* "@" */
F225   D701             stb   0x01;
F227   9500             bita  0x00;
F229   260B             bne   save_jstick_state;
F22B   2008             bra   centered;
                 left_or_down:
F22D   C6C0             ldb   #0xC0;
F22F   D701             stb   0x01;
F231   9500             bita  0x00;
F233   2701             beq   save_jstick_state;
                 centered:
F235   5F               clrb;
                 save_jstick_state:
F236   E71B             stb   -5,x;
F238   20C5             bra   check_4_done;
                 try_again:
F23A   1F98             tfr   b,a;
F23C   9A01             ora   0x01;
F23E   9701             sta   0x01;
                 use_approx:
F240   8620             lda   #0x20;
F242   9500             bita  0x00;
F244   2606             bne   check_resolution;
F246   1F98             tfr   b,a;
F248   9801             eora  0x01;
F24A   9701             sta   0x01;
                 check_resolution:
F24C   54               lsrb;
F24D   F1C81A           cmpb  $C81A;
F250   26E8             bne   try_again;
F252   D601             ldb   0x01;
F254   20E0             bra   save_jstick_state;


                 /*
                  * byte_2_sound_chip()
                  * byte_2_sound_chip2()
                  *
                  * Both of these routines cause a byte of music data to
                  * be written to the music chip, and also stored in the
                  * the appropriate RAM location in the range C800-C80E.
                  *
                  * At entry: (both)
                  *     'a' = indicates which one of the 15 music registers
                  *           is to be modified.
                  *     'b' = the byte of music data.
                  *
                  * At entry: (byte_2_sound_chip2 only)
                  *     'x' = base address of RAM area where a copy of music
                  *           data is to be stored.
                  *
                  * For byte_2_sound_chip(), the base address is forced to
                  * be C800.
                  *
                  * At entry, Dp must be set to D0.
                  */
                 byte_2_sound_chip:
F256   8EC800           ldx   #0xC800;
                 byte_2_sound_chip2:
F259   E786             stb   a,x;
F25B   9701             sta   0x01;
F25D   8619             lda   #0x19;
F25F   9700             sta   0x00;
F261   8601             lda   #0x01;
F263   9700             sta   0x00;
F265   9601             lda   0x01;
F267   D701             stb   0x01;
F269   C611             ldb   #0x11;
F26B   D700             stb   0x00;
F26D   C601             ldb   #0x01;
F26F   D700             stb   0x00;
F271   39               rts;


                 /*
                  * clear_sound_chip()
                  *
                  * This routine clears the 15 registers on the music chip
                  * and the soft copy of their values (C800-C80E), by writing
                  * a byte of 0 to each register.  This causes the sound chip
                  * to not make any sounds.
                  *
                  * At entry:
                  *     Dp must be set to D0.
                  */
                 clear_sound_chip:
F272   CC0E00           ldd   #0x0E00;
F275   8DDF      PF275: bsr   byte_2_sound_chip;
F277   4A               deca;
F278   2AFB             bpl   PF275;
F27A   7EF533           jmp   $init_music_buf;


                 /*
                  * copy_bytes_2_sound_chip()
                  *
                  * This routine copies a block of sound information into
                  * the sound chip buffer (at C800-C80E) and into the
                  * registers on the music chip.  The format for the block
                  * of sound data is as follows:
                  *
                  *   (register number), (music data),
                  *   (register number), (music data),
                  *         .                  .
                  *         .                  .
                  *       0xFF
                  *
                  * As long as the register number is >= 0, then the music
                  * data will be copied; however, as soon as a register
                  * number < 0 is encountered, the copy will stop.
                  *
                  * At entry:
                  *     'u' contains a pointer to the block of sound data.
                  *
                  * Dp must be set to D0.
                  */
                 copy_bytes_2_sound_chip:
F27D   8EC800           ldx   #0xC800;
F280   2002             bra   PF284;
F282   8DD5      PF282: bsr   byte_2_sound_chip2;
F284   ECC1      PF284: ldd   ,u++;
F286   2AFA             bpl   PF282;
F288   39               rts;


                 /*
                  * do_sound()
                  *
                  * This routine will start/continue making the sound which
                  * was first set up by your call to init_sound().  This
                  * routine should normally be called right after your call
                  * to waitrecal().  It takes the next music information,
                  * contained in the music buffer C83F-C84C, and updates only
                  * those registers which differ from the last data written
                  * to the sound chip.
                  *
                  * At entry, Dp must be set to D0.
                  */
                 do_sound:
F289   8EC800           ldx   #0xC800;
F28C   CEC83F           ldu   #0xC83F;
F28F   860D             lda   #0x0D;
F291   E6C0      PF291: ldb   ,u+;
F293   E186             cmpb  a,x;
F295   2702             beq   PF299;
F297   8DC0             bsr   byte_2_sound_chip2;
F299   4A        PF299: deca;
F29A   2AF5             bpl   PF291;
F29C   39               rts;


                 /*
                  * intensity_to_1F()
                  * intensity_to_3F()
                  * intensity_to_5F()
                  * intensity_to_7F()
                  * intensity_to_a()
                  *
                  * Each of these routines are responsible for setting the
                  * vector/dot intensity (commonly used to denote the z axis)
                  * to a specific value.  0x00 is the lowest intensity, and
                  * 0xFF is the brightest intensity.  The intensity must
                  * be reset to the desired value after each call to
                  * waitrecal(); however, it can also be changed at any other
                  * time.  A copy of the new intensity value is saved in
                  * C827.
                  *
                  * At entry: (for intensity_to_a() only)
                  *     'a' must contain the new intensity value.
                  *
                  * Dp must be set to D0.
                  */
                 intensity_to_1F:
F29D   861F             lda   #0x1F;
F29F   200A             bra   intensity_to_a;
                 intensity_to_3F:
F2A1   863F             lda   #0x3F;
F2A3   2006             bra   intensity_to_a;
                 intensity_to_5F:
F2A5   865F             lda   #0x5F;
F2A7   2002             bra   intensity_to_a;
                 intensity_to_7F:
F2A9   867F             lda   #0x7F;
                 intensity_to_a:
F2AB   9701             sta   0x01;
F2AD   B7C827           sta   $C827;
F2B0   CC0504           ldd   #0x0504;
F2B3   9700             sta   0x00;
F2B5   D700             stb   0x00;
F2B7   D700             stb   0x00;
F2B9   C601             ldb   #0x01;
F2BB   D700             stb   0x00;
F2BD   39               rts;


                 /*
                  * dotixb()
                  *
                  * This routine draws a dot at the relative y and
                  * relative x position pointed to by the 'x' register.
                  * Afterwards, the 'x' register is incremented by 2.
                  * The intensity to be used is passed in in the 'b'
                  * register, and this value is saved in C828.
                  *
                  * At entry:
                  *     'x' points to the (y,x) coordinate pair.
                  *     'b' contains intensity.
                  *
                  * At exit:
                  *     'x' has been incremented by 2.
                  *
                  * Dp must be set to D0.
                  */
                 dotixb:
F2BE   F7C828           stb   $C828;


                 /*
                  * dotix()
                  *
                  * This routine draws a dot at the relative y and
                  * relative x position pointed to by the 'x' register.
                  * Afterwards, the 'x' register is incremented by 2.
                  * The intensity used is the value already stored in C828.
                  *
                  * At entry:
                  *     'x' points to the (y,x) coordinate pair.
                  *
                  * At exit:
                  *     'x' has been incremented by 2.
                  *
                  * Dp must be set to D0.
                  */
                 dotix:
F2C1   EC81             ldd   ,x++;


                 /*
                  * dot_at_d()
                  *
                  * This routine draws a dot at the relative y and
                  * relative x position contained in the 'd' register.
                  * The intensity used is the value already stored in C828.
                  *
                  * At entry:
                  *     'a' contains the relative y coordinate.
                  *     'b' contains the relative x coordinate.
                  *
                  * Dp must be set to D0.
                  */
                 dot_at_d:
F2C3   8D4D             bsr   move_pen_d;


                 /*
                  * dot_at_current_position()
                  *
                  * This routine draws a dot at the current pen position.
                  * The intensity used is the value already stored in C828.
                  *
                  * Dp must be set to D0.
                  */
                 dot_at_current_position:
F2C5   86FF             lda   #0xFF;
F2C7   970A             sta   0x0A;
F2C9   F6C828           ldb   $C828;
F2CC   5A        PF2CC: decb;
F2CD   26FD             bne   PF2CC;
F2CF   0F0A             clr   0x0A;
F2D1   39               rts;


                 /*
                  * dot_list()
                  *
                  * This routine draws a series of dots, using the intensity
                  * already set up in C828.  The format for the dot list, which
                  * is pointed to by the 'x' register, is:
                  *
                  *     ( rel y, rel x), (rel y, rel x), .....
                  *
                  * The number of dots to draw is specified in C823.
                  *
                  * At entry:
                  *     'x' points to the list of dot coordinates.
                  *     C823 specifies the number of dots to draw.
                  *
                  * Dp must be set to D0.
                  */
                 next_dot:
F2D2   7AC823           dec   $C823;
                 dot_list:
F2D5   8DEA             bsr   PF2C1;
F2D7   B6C823           lda   $C823;
F2DA   26F6             bne   next_dot;
F2DC   2076             bra   reset0ref;


                 /*
                  * dotix_then_reset()
                  *
                  * This routine draws a series of dots, specified by the
                  * list pointed to by the 'x' register.  The list has the
                  * following format:
                  *
                  *     mode, relative y, relative x,
                  *     mode, relative y, relative x,
                  *       .      .           .
                  *       .      .           .
                  *     mode, relative y, relative x
                  *
                  * This routine will continue to traverse the list, until
                  * a mode > 0 is encountered; at that point, it will reset
                  * the 0 reference (the integrators).
                  *
                  * At entry:
                  *     'x' points to the dot list.
                  *
                  * At exit:
                  *     'x' will point to the relative y coordinate associated
                  *         with the mode which cause the routine to stop.
                  *
                  * Dp must be set to D0.
                  */
                 dotix_then_reset:
F2DE   A680             lda   ,x+;
F2E0   2E72             bgt   reset0ref;
F2E2   8DDD             bsr   PF2C1;
F2E4   20F8             bra   dotix_then_reset;


F2E6   8EF9F0    PF2E6: ldx   #0xF9F0;
F2E9   8D1D             bsr   move_penFF;
F2EB   BDF36B           jsr   $PF36B;
F2EE   8D20             bsr   move_pen;
F2F0   2062             bra   reset0ref;


                 /*
                  * move_pen_7F_no_inc()
                  *
                  * This routine forces the scale factor to 0x7F, and then
                  * moves the pen to the location pointed to by the 'x'
                  * register.  The relative y and relative x coordinates
                  * are both 2 byte quantities; however, only the most signicant
                  * byte of each is of any interest.  The values pointed to
                  * by the 'x' register have the following format:
                  *
                  *     'x' => (rel y hi),(rel y lo), (rel x hi), (rel x lo)
                  *
                  * The position moved to is obtained by y=(0,x) & x=(2,x).
                  *
                  * At entry:
                  *     'x' points to double sized coordinate pair.
                  *
                  * Dp must be set to D0.
                  */
                 move_pen7F_no_inc:
F2F2   C67F             ldb   #0x7F;
F2F4   D704             stb   0x04;
F2F6   A684             lda   ,x;
F2F8   E602             ldb   2,x;
F2FA   2016             bra   move_pen_d;


                 /*
                  * move_pen7F_to_d()
                  *
                  * This routine forces the scale factor to 0x7F, and then
                  * moves the pen to the position specified in the 'd'
                  * register.
                  *
                  * At entry:
                  *     'a' must contain the relative y coordinate.
                  *     'b' must contain the relative x coordinate.
                  *
                  * Dp must be set to D0.
                  */
                 move_pen7F_to_d:
F2FC   9701             sta   0x01;
F2FE   3406             pshs  a,b;
F300   867F             lda   #0x7F;
F302   9704             sta   0x04;
F304   0F00             clr   0x00;
F306   2010             bra   PF318;


                 /*
                  * move_penFF()
                  *
                  * This routine forces the scale factor to 0xFF, and then
                  * moves the pen to the (y,x) position pointed to by the
                  * 'x' register.  The 'x' register is then incremented by 2.
                  *
                  * At entry:
                  *     'x' points to the (y,x) coordinate pair.
                  *
                  * At exit:
                  *     'x' has been incremented by 2.
                  *
                  * Dp must be set to D0.
                  */
                 move_penFF:
F308   C6FF             ldb   #0xFF;
F30A   2002             bra   set_scale_factor;


                 /*
                  * move_pen7F()
                  *
                  * This routine forces the scale factor to 0x7F, and then
                  * moves the pen to the (y,x) position pointed to by the
                  * 'x' register.  The 'x' register is then incremented by 2.
                  *
                  * At entry:
                  *     'x' points to the (y,x) coordinate pair.
                  *
                  * At exit:
                  *     'x' has been incremented by 2.
                  *
                  * Dp must be set to D0.
                  */
                 move_pen7F:
F30C   C67F             ldb   #0x7F;
                 set_scale_factor:
F30E   D704             stb   0x04;


                 /*
                  * This routine uses the current scale factor, and
                  * moves the pen to the (y,x) position pointed to by the
                  * 'x' register.  The 'x' register is then incremented by 2.
                  *
                  * At entry:
                  *     'x' points to the (y,x) coordinate pair.
                  *
                  * At exit:
                  *     'x' has been incremented by 2.
                  *
                  * Dp must be set to D0.
                  */
                 move_pen:
F310   EC81             ldd   ,x++;


                 /* move_pen_d()
                  *
                  * This routine uses the current scale factor, and
                  * moves the pen to the (y,x) position specified in the
                  * 'd' register.  'a' contains the y coordinate, and 'b'
                  * contains the x coordinate.
                  *
                  * At entry:
                  *     'a' contains the y coordinate.
                  *     'b' contains the x coordinate.
                  *
                  * Dp must be set to D0.
                  */
                 move_pen_d:
F312   9701             sta   0x01;
F314   0F00             clr   0x00;
F316   3406             pshs  a,b;
F318   86CE      PF318: lda   #0xCE;
F31A   970C             sta   0x0C;
F31C   0F0A             clr   0x0A;
F31E   0C00             inc   0x00;
F320   D701             stb   0x01;
F322   0F05             clr   0x05;
F324   3506             puls  a,b;
F326   BDF584           jsr   $get_absolute_value_of_ab;
F329   E77F             stb   -1,s;
F32B   AA7F             ora   -1,s;
F32D   C640             ldb   #0x40;
F32F   8140             cmpa  #0x40;
F331   2312             bls   PF345;
F333   8164             cmpa  #0x64;
F335   2304             bls   PF33B;
F337   8608             lda   #0x08;
F339   2002             bra   PF33D;
F33B   8604      PF33B: lda   #0x04;
F33D   D50D      PF33D: bitb  0x0D;
F33F   27FC             beq   PF33D;
F341   4A        PF341: deca;
F342   26FD             bne   PF341;
F344   39               rts;
F345   D50D      PF345: bitb  0x0D;
F347   27FC             beq   PF345;
F349   39               rts;

                 /*
                  * set_dp_and_reset0ref()
                  *
                  * This routine sets the Dp register to D0, and then
                  * resets the integrators.
                  *
                  * At exit:
                  *     Dp will be set to D0.
                  */
                 set_dp_and_reset0ref:
F34A   BDF1AA           jsr   $dptoD0;
F34D   2005             bra   reset0ref;


                 /*
                  * check0ref()
                  *
                  * This routine will check to see if the reset0ref enable
                  * flag (C824) is set, and if it is, then it will reset the
                  * integrators, by calling reset0ref().
                  *
                  * At entry:
                  *     Dp must be set to D0.
                  */
                 check0ref:
F34F   B6C824           lda   $C824;
F352   2716             beq   PF36A;

                 /*
                  * reset0ref()
                  *
                  * This routine zeros the integrators, and resets the pen
                  * back to the origin.  It leaves the integrators in zero
                  * mode, so nothing can be drawn until a move is done, or
                  * D00C is set to 0xCE.  This routine must be called every
                  * so often, to prevent your vectors from getting out of
                  * whack.
                  *
                  * At entry:
                  *     Dp must be set to D0.
                  */
                 reset0ref:
F354   CC00CC           ldd   #0x00CC;
F357   D70C             stb   0x0C;
F359   970A             sta   0x0A;
F35B   CC0302           ldd   #0x0302;
F35E   0F01             clr   0x01;
F360   9700             sta   0x00;
F362   D700             stb   0x00;
F364   D700             stb   0x00;
F366   C601             ldb   #0x01;
F368   D700             stb   0x00;
F36A   39        PF36A: rts;


F36B   CC00CC    PF36B: ldd   #0x00CC;
F36E   D70C             stb   0x0C;
F370   970A             sta   0x0A;
F372   39               rts;


                 /*
                  * print_1_string()
                  *
                  * This routine prints a single string (upto a 0x80).
                  * The parameter block describing the string is pointed
                  * to by the 'u' register.  The format for the parameter
                  * block is as follows:
                  *
                  *     height, width, rel y, rel x, string, 0x80
                  *
                  * At entry:
                  *     'u' points to the string parameter block.
                  *
                  * At exit:
                  *     'u' points to byte after terminating 0x80.
                  *
                  * Dp must be set to D0.
                  */
                 print_1_string:
F373   ECC1             ldd   ,u++;     /* Save height & width */
F375   FDC82A           std   $C82A;


                 /*
                  * print_with_dft_hw()
                  *
                  * This routine prints a single string (upto a 0x80),
                  * using the default height and width, as stored in C82A.
                  * The parameter block describing the string is pointed
                  * to by the 'u' register.  The format for the parameter
                  * block is as follows:
                  *
                  *     rel y, rel x, string, 0x80
                  *
                  * At entry:
                  *     'u' points to the string parameter block.
                  *
                  * At exit:
                  *     'u' points to byte after the terminating 0x80.
                  *
                  * Dp must be set to D0.
                  */
                 print_with_dft_hw:
F378   ECC1             ldd   ,u++;     /* Get (y,x) position. */


                 /*
                  * print_at_d()
                  *
                  * This routine prints a single string (upto a 0x80),
                  * using the default height and width, as stored in C82A,
                  * and at the pen position specified in the 'd' register.
                  * The parameter block describing the string is pointed
                  * to by the 'u' register.  The format for the parameter
                  * block is as follows:
                  *
                  *     string, 0x80
                  *
                  * At entry:
                  *     'u' points to the string parameter block.
                  *     'a' contains relative y position.
                  *     'b' contains relative x position.
                  *
                  * At exit:
                  *     'u' points to byte after the terminating 0x80.
                  *
                  * Dp must be set to D0.
                  */
                 print_at_d:
F37A   BDF2FC           jsr   $move_pen7F_to_d;
F37D   BDF575           jsr   $delay_b_1;
F380   7EF495           jmp   $display_string;


                 /*
                  * printu()
                  *
                  * This displays the group of strings described by the
                  * parameter block which is pointed to by the 'u' register.
                  * The string parameter block has the following format:
                  *
                  *     height, width, rel y, rel x, string, 0x80,
                  *     height, width, rel y, rel x, string, 0x80,
                  *     0x00
                  *
                  * At entry:
                  *     'u' points to string parameter block.
                  *
                  * Dp must be set to D0.
                  */
                 initiate_printing:
F383   8DEE             bsr   print_1_string;
                 printu:
F385   A6C4             lda   ,u;
F387   26FA             bne   initiate_printing;
F389   39               rts;


                 /*
                  * printu2()
                  *
                  * This displays the group of strings described by the
                  * parameter block which is pointed to by the 'u' register.
                  * The string parameter block has the following format:
                  *
                  *     rel y, rel x, string, 0x80,
                  *     rel y, rel x, string, 0x80,
                  *     0x00
                  *
                  * The current string height and width to which the hardware
                  * is set will be used.
                  *
                  * This routine will first print the passed-in string, and
                  * THEN check for the end of the string block.
                  *
                  * At entry:
                  *     'u' points to string parameter block.
                  *
                  * Dp must be set to D0.
                  */
                 printu2:
F38A   8DEC             bsr   print_with_dft_hw;


                 /*
                  * printu3()
                  *
                  * This displays the group of strings described by the
                  * parameter block which is pointed to by the 'u' register.
                  * The string parameter block has the following format:
                  *
                  *     rel y, rel x, string, 0x80,
                  *     rel y, rel x, string, 0x80,
                  *     0x00
                  *
                  * The current string height and width to which the hardware
                  * is set will be used.
                  *
                  * This routine will first check for the end of the string
                  * block, and THEN will print the string if the end of the
                  * string block was not reached.
                  *
                  * At entry:
                  *     'u' points to string parameter block.
                  *
                  * Dp must be set to D0.
                  */
                 printu3:
F38C   A6C4             lda   ,u;
F38E   26FA             bne   printu2;
F390   39               rts;


                 /*
                  * print_b_minus_a()
                  *
                  * This routine displays one of the following strings,
                  * depending upon the passed in value in the 'b' register,
                  * using the current string height and width values:
                  *
                  *     value of 'b' "-" value of 'a'
                  *
                  * If 'b' > 9, then the infinity symbol is displayed.
                  * The 'x' register points to the (y,x) coordinates
                  * for where the string is to be displayed.
                  *
                  * At entry:
                  *     'x' points to string coordinates.
                  *     'a' contains a printable digit.
                  *     'b' contains any value.
                  *
                  * Dp must be set to D0.
                  */
                 print_b_minus_a:
F391   AE84             ldx   ,x;


                 /*
                  * print_b_minus_a2()
                  *
                  * This routine displays one of the following strings,
                  * depending upon the passed in value in the 'b' register,
                  * using the current string height and width values:
                  *
                  *     value of 'b' "-" value of 'a'
                  *
                  * If 'b' > 9, then the infinity symbol is displayed.
                  * The 'x' register contains the (y,x) coordinates
                  * for where the string is to be displayed.
                  *
                  * At entry:
                  *     'x' contains the string coordinates.
                  *     'a' contains a printable digit.
                  *     'b' contains any value.
                  *
                  * Dp must be set to D0.
                  */
                 print_b_minus_a2:
F393   3404             pshs  b;
F395   C680             ldb   #0x80;
F397   3378             leau  -8,s;
F399   3606             pshu  a,b;
F39B   3502             puls  a;
F39D   8109             cmpa  #0x09;
F39F   2302             bls   PF3A3;
F3A1   863C             lda   #0x3C; /* "<" */
F3A3   8B30      PF3A3: adda  #0x30; /* "0" */
F3A5   C62D             ldb   #0x2D; /* "-" */
F3A7   3606             pshu  a,b;
F3A9   3610             pshu  x;
F3AB   20CB             bra   print_with_dft_hw;


                 /*
                  * move_then_draw_VL_with_count1()
                  *
                  * This routine moves to the first location specified in
                  * vector list, and then draws lines between the rest of
                  * coordinates in the list.  The number of vectors to draw
                  * is specified as the first byte in the vector list.  The
                  * current scale factor is used.  The vector list must have
                  * the following format:
                  *
                  *     count, rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 move_then_draw_VL_with_count1:
F3AD   A680             lda   ,x+;
F3AF   2008             bra   move_then_draw_VL_with_count6;


                 /*
                  * move_then_draw_VL_with_count2()
                  *
                  * This routine moves to the first location specified in
                  * vector list, and then draws lines between the rest of
                  * coordinates in the list.  The number of vectors to draw
                  * must already be specified in C823.  The scale factor to
                  * use is specified in the 'b' register.  The vector list
                  * must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *     'b' contains the scale factor.
                  *
                  * Dp must be set to D0.
                  */
                 move_then_draw_VL_with_count2:
F3B1   D704             stb   0x04;
F3B3   2007             bra   move_then_draw_VL_with_count5;


                 /*
                  * move_then_draw_VL_with_count3()
                  *
                  * This routine moves to the first location specified in
                  * vector list, and then draws lines between the rest of
                  * coordinates in the list.  The number of vectors to draw
                  * is specified as the first byte in the vector list, and the
                  * scale factor is the second byte in teh vector list.  The
                  * vector list must have the following format:
                  *
                  *     count, scale, rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 move_then_draw_VL_with_count3:
F3B5   EC81             ldd   ,x++;


                 /*
                  * move_then_draw_VL_with_count4()
                  *
                  * This routine moves to the first location specified in
                  * vector list, and then draws lines between the rest of
                  * coordinates in the list.  The number of vectors to draw
                  * is specified in the 'a' register, and the scale factor is
                  * specified in the 'b' register.  The vector list must have
                  * the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *     'a' contains the number of vectors to draw.
                  *     'b' contains the scale factor to use.
                  *
                  * Dp must be set to D0.
                  */
                 move_then_draw_VL_with_count4:
F3B7   D704             stb   0x04;


                 /*
                  * move_then_draw_VL_with_count6()
                  *
                  * This routine moves to the first location specified in
                  * vector list, and then draws lines between the rest of
                  * coordinates in the list.  The number of vectors to draw
                  * is specified in the 'a' register; the current scale factor
                  * is used.  The vector list must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *     'a' contains the number of vectors to draw.
                  *
                  * Dp must be set to D0.
                  */
                 move_then_draw_VL_with_count6:
F3B9   B7C823           sta   $C823;


                 /*
                  * move_then_draw_VL_with_count5()
                  *
                  * This routine moves to the first location specified in
                  * vector list, and then draws lines between the rest of
                  * coordinates in the list.  The number of vectors to draw
                  * must be specified C823, and the current scale factor is
                  * used.  The vector list must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 move_then_draw_VL_with_count5:
F3BC   EC84             ldd   ,x;
F3BE   9701             sta   0x01;
F3C0   0F00             clr   0x00;
F3C2   3002             leax  2,x;
F3C4   12               nop;
F3C5   0C00             inc   0x00;
F3C7   D701             stb   0x01;
F3C9   CC0000           ldd   #0x0000;   /* Set line pattern to invisible. */
F3CC   201F             bra   PF3ED;


                 /*
                  * draw_VL_with_count4()
                  *
                  * This routine draws vectors between the set of (y,x)
                  * points pointed to by the 'x' register.  The number
                  * of vectors to draw is specified as the first byte
                  * in the vector list.  The current scale factor is used.
                  * The vector list must have the following format:
                  *
                  *     count, rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 draw_VL_with_count4:
F3CE   A680             lda   ,x+;
F3D0   2008             bra   draw_VL_with_count5;


                 /*
                  * draw_VL_with_count3()
                  *
                  * This routine draws vectors between the set of (y,x)
                  * points pointed to by the 'x' register.  The number
                  * of vectors to draw must already be specified in C823.
                  * The scale factor to be used must be in the 'b' register.
                  * The vector list must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *     'b' contains the scale factor.
                  *
                  * Dp must be set to D0.
                  */
                 draw_VL_with_count3:
F3D2   D704             stb   0x04;
F3D4   2007             bra   draw_VL_with_count1;


                 /*
                  * draw_VL_with_count2()
                  *
                  * This routine draws vectors between the set of (y,x)
                  * points pointed to by the 'x' register.  The number
                  * of vectors to draw is specified as the first byte
                  * in the vector list.  The scale factor is specified as
                  * the second byte in the vector list.
                  * The vector list must have the following format:
                  *
                  *     count, scale, rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 draw_VL_with_count2:
F3D6   EC81             ldd   ,x++;


                 /*
                  * draw_VL_with_count6()
                  *
                  * This routine draws vectors between the set of (y,x)
                  * points pointed to by the 'x' register.  The number
                  * of vectors to draw is specified in the 'a' register.
                  * The scale factor is specified in the 'b' register.
                  * The vector list must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *     'a' must contain the number of vectors to draw.
                  *     'b' contains the scale factor to use.
                  *
                  * Dp must be set to D0.
                  */
                 draw_VL_with_count6:
F3D8   D704             stb   0x04;


                 /*
                  * draw_VL_with_count5()
                  *
                  * This routine draws vectors between the set of (y,x)
                  * points pointed to by the 'x' register.  The number
                  * of vectors to draw is specified in the 'a' register.
                  * The current scale factor is used.
                  * The vector list must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *     'a' contains the number of vectors to draw.
                  *
                  * Dp must be set to D0.
                  */
                 draw_VL_with_count5:
F3DA   B7C823           sta   $C823;


                 /*
                  * draw_VL_with_count1()
                  *
                  * This routine draws vectors between the set of (y,x)
                  * points pointed to by the 'x' register.  The number
                  * of vectors to draw must already be specified in C823.
                  * The current scale factor is used.
                  * The vector list must have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 draw_VL_with_count1:
F3DD   EC84             ldd   ,x;


                 /*
                  * draw_to_d()
                  *
                  * This routine will draw a line from the current pen
                  * position, to the point specified by the (y,x) pair
                  * specified in the 'd' register.  The current scale
                  * factor is used.  Before calling this routine, you
                  * should set C823 to 0, so that only the one vector
                  * will be drawn.
                  *
                  * At entry:
                  *     'a' contains relative y position.
                  *     'b' contains relative x position.
                  *
                  * Dp must be set to D0.
                  */
                 draw_to_d:
F3DF   9701             sta   0x01;
F3E1   0F00             clr   0x00;
F3E3   3002             leax  2,x;
F3E5   12               nop;
F3E6   0C00             inc   0x00;
F3E8   D701             stb   0x01;
F3EA   CCFF00           ldd   #0xFF00;   /* Set up a solid line pattern. */
F3ED   970A      PF3ED: sta   0x0A;
F3EF   D705             stb   0x05;
F3F1   CC0040           ldd   #0x0040;
F3F4   D50D      PF3F4: bitb  0x0D;
F3F6   27FC             beq   PF3F4;
F3F8   12               nop;
F3F9   970A             sta   0x0A;
F3FB   B6C823           lda   $C823;
F3FE   4A               deca;
F3FF   2AD9             bpl   draw_VL_with_count5;
F401   7EF34F           jmp   $check0ref;


                 /*
                  * drawl1_scale_FF()
                  *
                  * This routine forces the scale factor to 0xFF, and then
                  * processes the vector list pointed to by the 'x' register.
                  * The vector list must have the following format:
                  *
                  *     mode, rel y, rel x
                  *     mode, rel y, rel x
                  *      .      .      .
                  *      .      .      .
                  *     mode, rel y, rel x
                  *     0x01
                  *
                  * where mode can mean one of the following:
                  *
                  *     < 0   draw a line to the specified point.
                  *     = 0   move to the specified point.
                  *     > 0   end of vector list
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 drawl1_scale_FF:
F404   C6FF             ldb   #0xFF;
F406   2006             bra   drawl1b;


                 /*
                  * drawl1_scale_7F()
                  *
                  * This routine forces the scale factor to 0x7F, and then
                  * processes the vector list pointed to by the 'x' register.
                  * The vector list must have the following format:
                  *
                  *     mode, rel y, rel x
                  *     mode, rel y, rel x
                  *      .      .      .
                  *      .      .      .
                  *     mode, rel y, rel x
                  *     0x01
                  *
                  * where mode can mean one of the following:
                  *
                  *     < 0   draw a line to the specified point.
                  *     = 0   move to the specified point.
                  *     > 0   end of vector list
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 drawl1_scale_7F:
F408   C67F             ldb   #0x7F;
F40A   2002             bra   drawl1b;


                 /*
                  * drawl1()
                  *
                  * This routine processes the vector list pointed to by the
                  * 'x' register.  The first byte in the vector list is the
                  * scale factor.  The vector list must have the following
                  * format:
                  *
                  *     scale factor,
                  *     mode, rel y, rel x
                  *     mode, rel y, rel x
                  *      .      .      .
                  *      .      .      .
                  *     mode, rel y, rel x
                  *     0x01
                  *
                  * where mode can mean one of the following:
                  *
                  *     < 0   draw a line to the specified point.
                  *     = 0   move to the specified point.
                  *     > 0   end of vector list
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 drawl1:
F40C   E680             ldb   ,x+;


                 /*
                  * drawl1b()
                  *
                  * This routine processes the vector list pointed to by the
                  * 'x' register.  The scale factor to use is passed in in the
                  * 'b' register.  The vector list must have the following
                  * format:
                  *
                  *     mode, rel y, rel x
                  *     mode, rel y, rel x
                  *      .      .      .
                  *      .      .      .
                  *     mode, rel y, rel x
                  *     0x01
                  *
                  * where mode can mean one of the following:
                  *
                  *     < 0   draw a line to the specified point.
                  *     = 0   move to the specified point.
                  *     > 0   end of vector list
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *     'b' contains scale factor to use.
                  *
                  * Dp must be set to D0.
                  */
                 drawl1b:
F40E   D704             stb   0x04;


                 /*
                  * next_pt()
                  *
                  * This routine processes the vector list pointed to by the
                  * 'x' register.  The current scale factor is used.
                  * The vector list must have the following format:
                  *
                  *     mode, rel y, rel x
                  *     mode, rel y, rel x
                  *      .      .      .
                  *      .      .      .
                  *     mode, rel y, rel x
                  *     0x01
                  *
                  * where mode can mean one of the following:
                  *
                  *     < 0   draw a line to the specified point.
                  *     = 0   move to the specified point.
                  *     > 0   end of vector list
                  *
                  * At entry:
                  *     'x' must point to the vector list.
                  *
                  * Dp must be set to D0.
                  */
                 next_pt:
F410   EC01             ldd   1,x;
F412   9701             sta   0x01;
F414   0F00             clr   0x00;
F416   A684             lda   ,x;
F418   3003             leax  3,x;
F41A   0C00             inc   0x00;
F41C   D701             stb   0x01;
F41E   970A             sta   0x0A;
F420   0F05             clr   0x05;
F422   CC0040           ldd   #0x0040;
F425   D50D      PF425: bitb  0x0D;
F427   27FC             beq   PF425;
F429   12               nop;
F42A   970A             sta   0x0A;
F42C   A684             lda   ,x;
F42E   2FE0             ble   next_pt;
F430   7EF34F           jmp   $check0ref;


                 /*
                  * dwp_with_count()
                  * draw_with_pattern()
                  *
                  * Both of these routines draw a series of patterned
                  * vectors.  The pattern to use must already be specified
                  * in C829.  When using draw_with_pattern(), the number
                  * of vectors to draw (minus 1) must be specified in C823;
                  * when using dwp_with_count(), the number of vectors to
                  * draw (minus 1) must be passed in in the 'a' register.
                  * The vector list, pointed to by the 'x' register, must
                  * have the following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *     'a' specifies number of vectors (dwp_with_count() only).
                  *
                  * Dp must be set to D0.
                  */
                 dwp_loop:
F433   4A               deca;
                 dwp_with_count:
F434   B7C823           sta   $C823;
                 draw_with_pattern:
F437   EC84             ldd   ,x;
F439   9701             sta   0x01;
F43B   0F00             clr   0x00;
F43D   3002             leax  2,x;
F43F   0C00             inc   0x00;
F441   D701             stb   0x01;
F443   B6C829           lda   $C829;
F446   C640             ldb   #0x40;
F448   970A             sta   0x0A;
F44A   0F05             clr   0x05;
F44C   F5D00D           bitb  $D00D;
F44F   270B             beq   PF45C;
F451   0F0A             clr   0x0A;
F453   B6C823           lda   $C823;
F456   26DB             bne   dwp_loop;
F458   39               rts;
F459   B6C829    PF459: lda   $C829;
F45C   970A      PF45C: sta   0x0A;
F45E   12               nop;
F45F   D50D             bitb  0x0D;
F461   27F6             beq   PF459;
F463   B6C823           lda   $C823;
F466   0F0A             clr   0x0A;
F468   4D               tsta;
F469   26C8             bne   dwp_loop;
F46B   7EF34F           jmp   $check0ref;


                 /*
                  * drawl2()
                  *
                  * This routine processes the vector list pointed to by
                  * the 'x' register.  The current scale factor is used.
                  * The vector list must have the following format:
                  *
                  *     mode, rel y, rel x,
                  *     mode, rel y, rel x,
                  *      .      .      .
                  *      .      .      .
                  *     mode, rel y, rel x,
                  *     0x01
                  *
                  * where mode has the following meaning:
                  *
                  *     < 0  use the pattern in C829.
                  *     = 0  move to specified endpoint.
                  *     = 1  end of list, so return.
                  *     > 1  draw to specified endpoint.
                  *
                  * At entry:
                  *     'x' points to the vector list.
                  *     C829 may need to be set up with a line pattern.
                  *
                  * Dp must be set to D0.
                  */
                 drawl2:
F46E   B6C824           lda   $C824;
F471   3402             pshs  a;
F473   7FC824           clr   $C824;
F476   A680      PF476: lda   ,x+;
F478   2A04             bpl   PF47E;
F47A   8DBB             bsr   draw_with_pattern;
F47C   20F8             bra   PF476;
F47E   2605      PF47E: bne   PF485;
F480   BDF3BC           jsr   $move_then_draw_VL_with_count5;
F483   20F1             bra   PF476;
F485   4A        PF485: deca;
F486   2705             beq   PF48D;
F488   BDF3DD           jsr   $draw_VL_with_count1;
F48B   20E9             bra   PF476;
F48D   3502      PF48D: puls  a;
F48F   B7C824           sta   $C824;
F492   7EF34F           jmp   $check0ref;


                 /*
                  * display_string()
                  *
                  * This is the routine which does the actual printing of a
                  * string.  The 'u' register points to the start of the
                  * string, while C82A contains the height of the character,
                  * cell, and C82B contains the width of the character cell.
                  * The end of the string must be terminated with a 0x80.
                  *
                  * The string is displayed by drawing 6 horizontal rows of
                  * dots.  The first row is drawn for each character, then
                  * the second, etc.  The character generation table is
                  * located at (0xF9D4 + 0x20).  Only characters 0x20-0x6F
                  * (upper case) are defined; the lower case character a-o
                  * produce special icons.
                  *
                  * At entry:
                  *     'u' points to the start of the string.
                  *     C82A contains character cell height.
                  *     C82B contains character cell width.
                  */
                 display_string:
F495   FFC82C           stu   $C82C;     /* Save pointer to start of string. */
F498   8EF9D4           ldx   #0xF9D4;
F49B   CC1883           ldd   #0x1883;
F49E   0F01             clr   0x01;
F4A0   970B             sta   0x0B;
F4A2   8EF9D4           ldx   #0xF9D4;
F4A5   D700      PF4A5: stb   0x00;
F4A7   0A00             dec   0x00;
F4A9   CC8081           ldd   #0x8081;
F4AC   12               nop;
F4AD   0C00             inc   0x00;
F4AF   D700             stb   0x00;
F4B1   9700             sta   0x00;
F4B3   7DC800           tst   $C800;
F4B6   0C00             inc   0x00;
F4B8   B6C82B           lda   $C82B;    /* Get the string width. */
F4BB   9701             sta   0x01;
F4BD   CC0100           ldd   #0x0100;
F4C0   FEC82C           ldu   $C82C;
F4C3   9700             sta   0x00;
F4C5   2004             bra   PF4CB;
F4C7   A686      PF4C7: lda   a,x;
F4C9   970A             sta   0x0A;
F4CB   A6C0      PF4CB: lda   ,u+;
F4CD   2AF8             bpl   PF4C7;    /* Display next row of pixels. */
F4CF   8681             lda   #0x81;
F4D1   9700             sta   0x00;
F4D3   0001             neg   0x01;
F4D5   8601             lda   #0x01;
F4D7   9700             sta   0x00;
F4D9   8CFBB4           cmpx  #0xFBB4;  /* If not at end of char table, then */
F4DC   272C             beq   PF50A;    /* proceed to next row of pixels.    */
F4DE   308850           leax  0x50,x;
F4E1   1F30             tfr   u,d;
F4E3   B3C82C           subd  $C82C;    /* Point back to first character. */
F4E6   C002             subb  #0x02;
F4E8   58               aslb;
F4E9   2100             brn   PF4EB;
F4EB   8681      PF4EB: lda   #0x81;
F4ED   12               nop;
F4EE   5A               decb;
F4EF   26FA             bne   PF4EB;
F4F1   9700             sta   0x00;
F4F3   F6C82A           ldb   $C82A;
F4F6   D701             stb   0x01;
F4F8   0A00             dec   0x00;
F4FA   CC8101           ldd   #0x8101;
F4FD   12               nop;
F4FE   9700             sta   0x00;
F500   0F01             clr   0x01;
F502   D700             stb   0x00;
F504   9700             sta   0x00;
F506   C603             ldb   #0x03;
F508   209B             bra   PF4A5;
F50A   8698      PF50A: lda   #0x98;
F50C   970B             sta   0x0B;
F50E   7EF354           jmp   $reset0ref;


                 /*
                  * get_random_a2()
                  *
                  * This routine generates a random 1-byte number, and places
                  * it in the 'a' register.  This uses a seed of 2 for the
                  * random number generator.
                  *
                  * At exit:
                  *     'a' contains the generated random number.
                  */
                 get_random_a2:
F511   3414             pshs  b,x;
F513   C602             ldb   #0x02;
F515   2003             bra   ran_start;


                 /*
                  * get_random_a()
                  *
                  * This routine generates a random 1-byte number, and places
                  * it in the 'a' register.  This uses a seed of 0 for the
                  * random number generator.
                  *
                  * At exit:
                  *     'a' contains the generated random number.
                  */
                 get_random_a:
F517   3414             pshs  b,x;
F519   5F               clrb;
                 ran_start:
F51A   BEC87B           ldx   $C87B;
                 ran_loop:
F51D   A601             lda   1,x;
F51F   49               rola;
F520   49               rola;
F521   49               rola;
F522   49               rola;
F523   A802             eora  2,x;
F525   46               rora;
F526   6984             rol   ,x;
F528   6901             rol   1,x;
F52A   6902             rol   2,x;
F52C   5A               decb;
F52D   2AEE             bpl   ran_loop;
F52F   A684             lda   ,x;
F531   3594             puls  b,x,pc;


                 /*
                  * init_music_buf()
                  *
                  * This routine clears out the music work buffer, located
                  * at C83F-C84C.
                  *
                  */
                 init_music_buf:
F533   C60D             ldb   #0x0D;
F535   8EC83F           ldx   #0xC83F;
F538   8D05             bsr   clear_blockxb;
F53A   863F             lda   #0x3F;
F53C   A706             sta   6,x;
F53E   39               rts;


                 /*
                  * clear_blockxb()
                  *
                  * This routine clears to 0 the block of memory starting
                  * at the address contained in the 'x' register, and
                  * continuing for the number of bytes specified by 'b'+1.
                  *
                  * At entry:
                  *     'x' points to the start of the RAM to be cleared.
                  *     'b' specifies number of bytes (minus 1) to clear.
                  */
                 clear_blockxb:
F53F   4F               clra;
F540   2006             bra   clear_block;


                 /*
                  * clear_C8_ram()
                  *
                  * This routine clears to 0 the block of memory in the
                  * range C800-C8FF.
                  */
                 clear_C8_ram:
F542   8EC800           ldx   #0xC800;


                 /*
                  * clear_256_bytes()
                  *
                  * This routine clears to 0 the 256 byte block of memory
                  * starting at the address contained in the 'x' register.
                  *
                  * At entry:
                  *     'x' points to the start of the RAM to be cleared.
                  */
                 clear_256_bytes:
F545   CC00FF           ldd   #0x00FF;
                 clear_block:
F548   6F8B             clr   d,x;
F54A   830001           subd  #0x0001;
F54D   2AF9             bpl   clear_block;
F54F   39               rts;


                 /*
                  * clear_block_to_0x80()
                  *
                  * This routine xsets to 0x80 the block of memory pointed to by
                  * the 'x' register.  The 'b' register specifies the number of
                  * bytes (minus 1) to be modified.
                  *
                  * At entry:
                  *     'x' specifies the start of the memory block.
                  *     'b' specifies the number of bytes (minus 1) to modify.
                  */
                 clear_block_to_0x80:
F550   8680             lda   #0x80;


                 /*
                  * clear_block_to_a()
                  *
                  * This routine sets to the value specified in the 'a'
                  * register, the block of memory pointed to by the 'x'
                  * register.  The 'b' register specifies the number of
                  * bytes (minus 1) to be modified.
                  *
                  * At entry:
                  *     'x' specifies the start of the memory block.
                  *     'b' specifies the number of bytes (minus 1) to modify.
                  *     'a' specifies value to be written to the memory block.
                  */
                 clear_block_to_a:
F552   A785             sta   b,x;
F554   5A               decb;
F555   26FB             bne   clear_block_to_a;
F557   A784             sta   ,x;
F559   39               rts;


                 /*
                  * decrement_counters_C82E_C830()
                  *
                  * This routine checks each of the 3 counters, and
                  * decrements those which are not already zero.
                  */
                 decrement_counters_C82E_C830:
F55A   C602             ldb   #0x02;
F55C   2002             bra   PF560;


                 /*
                  * decrement_counters_C82E_C833()
                  *
                  * This routine checks each of the 6 counters, and
                  * decrements those which are not already zero.
                  */
                 decrement_counters_C82E_C833:
F55E   C605             ldb   #0x05;
F560   8EC82E    PF560: ldx   #0xC82E;
F563   6D85      PF563: tst   b,x;
F565   2702             beq   PF569;
F567   6A85             dec   b,x;
F569   5A        PF569: decb;
F56A   2AF7             bpl   PF563;
F56C   39               rts;


                 /*
                  * delay_b_3()
                  * delay_b_2()
                  * delay_b_1()
                  * delay_b_0()
                  *
                  * Each of these routines loads the 'b' register with
                  * the indicated value, and then loops until the 'b'
                  * register value has decremented below zero.
                  */
                 delay_b_3:
F56D   C603             ldb   #0x03;
F56F   2009             bra   start_b_delay;
                 delay_b_2:
F571   C602             ldb   #0x02;
F573   2005             bra   start_b_delay;
                 delay_b_1:
F575   C601             ldb   #0x01;
F577   2001             bra   start_b_delay;
                 delay_b_0:
F579   5F               clrb;
                 start_b_delay:
F57A   5A               decb;
F57B   2AFD             bpl   start_b_delay;
F57D   39               rts;


                 /*
                  * get_bit_mask()
                  *
                  * This routine takes a bit number, specified in the 'a'
                  * register, and returns a bit mask with only the specified
                  * bit set.  This is shown in the table below:
                  *
                  *     Entry           Exit
                  *     -----           -----
                  *       0              0x01
                  *       1              0x02
                  *      etc             etc
                  *
                  * At entry:
                  *     'a' contains the bit number.
                  *
                  * At exit:
                  *     'a' contains the bit mask.
                  */
                 get_bit_mask:
F57E   8EF9DC           ldx   #bit_masks;
F581   A686             lda   a,x;
F583   39               rts;


                 /*
                  * get_absolute_value_of_ab()
                  *
                  * This routine returns the absolute value of the two
                  * single byte numbers passed in in the 'a' and 'b' register.
                  * There is a special case: 0x80 is returned as 0x7F.
                  *
                  * At entry:
                  *     'a' contains value 1.
                  *     'b' contains value 2.
                  *
                  * At exit:
                  *     'a' contains absolute value of value 1.
                  *     'b' contains absolute value of value 2.
                  */
                 get_absolute_value_of_ab:
F584   4D               tsta;
F585   2A04             bpl   PF58B;
F587   40               nega;
F588   2801             bvc   PF58B;
F58A   4A               deca;
F58B   5D        PF58B: tstb;
F58C   2A04             bpl   PF592;
F58E   50               negb;
F58F   2801             bvc   PF592;
F591   5A               decb;
F592   39        PF592: rts;


                 /*
                  * convert_rise_run_to_angle()
                  *
                  * Given a (rise,run) pair, this routine calculates the
                  * angle which corresponds to that (rise,run) pair.  The
                  * returned angle is relative to the x-axis (+ is CCW), so
                  * to convert it to a Vectrex angle (relative to the y-axis,
                  * + is CCW), you must subtract the number 0x10 (90 degrees)
                  * from the returned value.
                  *
                  * At entry:
                  *     'a' contains the rise value.
                  *     'b' contains the run value.
                  *
                  * At exit:
                  *     'a' contains the angle from the x-axis.
                  *     'b' contains the angle from the x-axis.
                  *
                  * Dp must be set to C8.
                  */
                 convert_rise_run_to_angle:
F593   3410             pshs  x;
F595   DD34             std   0x34;
F597   59               rolb;
F598   C600             ldb   #0x00;
F59A   59               rolb;
F59B   49               rola;
F59C   59               rolb;
F59D   58               aslb;
F59E   D736             stb   0x36;
F5A0   DC34             ldd   0x34;
F5A2   8DE0             bsr   get_absolute_value_of_ab;
F5A4   9734             sta   0x34;
F5A6   D134             cmpb  0x34;
F5A8   2308             bls   PF5B2;
F5AA   0C36             inc   0x36;
F5AC   1E89             exg   a,b;
F5AE   2002             bra   PF5B2;
F5B0   44        PF5B0: lsra;
F5B1   54               lsrb;
F5B2   8109      PF5B2: cmpa  #0x09;
F5B4   22FA             bhi   PF5B0;
F5B6   DD34             std   0x34;
F5B8   D636             ldb   0x36;
F5BA   8EFC24           ldx   #angle_data1;
F5BD   E685             ldb   b,x;
F5BF   8EFC2C           ldx   #angle_data2;
F5C2   A686             lda   a,x;
F5C4   9B35             adda  0x35;
F5C6   8B0A             adda  #0x0A;
F5C8   C501             bitb  #0x01;
F5CA   2604             bne   PF5D0;
F5CC   EB86             addb  a,x;
F5CE   2003             bra   PF5D3;
F5D0   5A        PF5D0: decb;
F5D1   E086             subb  a,x;
F5D3   D736      PF5D3: stb   0x36;
F5D5   9636             lda   0x36;
F5D7   3590             puls  x,pc;


                 /*
                  * get_2nd_index_pair()
                  * get_1st_index_pair()
                  *
                  * These routines are responsible for generating the
                  * two index pairs which are required by the rest of
                  * the rotation routines.  Each index pair is two bytes
                  * long, and has the following format:
                  *
                  *     The high byte is obtained by masking the angle
                  *     with 0x1F (this forces the angle to be between
                  *     0 and 180 degrees), and then using this value to
                  *     index into the multiplier table.
                  *
                  *     The lower byte contains information about whether
                  *     the angle lies along either the x or y axis, and
                  *     whether the rise/run will be positive or negative.
                  *
                  *             0 => positive rise, not on an axis, or
                  *                  negative run, not on an axis.
                  *          0x80 => negative rise, not on an axis, or
                  *                  positive run, not on an axis.
                  *          0x81 => negative rise, on an axis, or
                  *                  positive run, on an axis.
                  *             1 => positive rise, on an axis, or
                  *                  negative run, on an axis.
                  *
                  * get_1st_index_pair() returns the value for the run.
                  * get_2nd_index_pair() returns the value for the rise.
                  *
                  * At entry:
                  *     'a' must contain the angle value.
                  */
                 get_2nd_index_pair:
F5D9   8B10             adda  #0x10;
                 get_1st_index_pair:
F5DB   8EFC6D           ldx   #rotation_pair_table;
F5DE   5F               clrb;
F5DF   8520             bita  #0x20;
F5E1   2702             beq   PF5E5;
F5E3   C680             ldb   #0x80;
F5E5   841F      PF5E5: anda  #0x1F;
F5E7   8110             cmpa  #0x10;
F5E9   2601             bne   PF5EC;
F5EB   5C               incb;
F5EC   A686      PF5EC: lda   a,x;
F5EE   39               rts;


                 /*
                  * get_rotation_index_pairs()
                  *
                  * This routine gets the index pair for both the
                  * rise and run, using the passed-in angle value.
                  *
                  * At entry:
                  *     C836 must contain the angle value.
                  *
                  * At exit:
                  *     C837-C838 contains the index pair for the run.
                  *     C839-C83A contains the index pair for the rise.
                  *
                  * Dp must be set to C8.
                  */
                 get_rotation_index_pairs:
F5EF   3410             pshs  x;
F5F1   9636             lda   0x36;
F5F3   8DE6             bsr   get_1st_index_pair;
F5F5   DD37             std   0x37;
F5F7   9636             lda   0x36;
F5F9   8DDE             bsr   get_2nd_index_pair;
F5FB   DD39             std   0x39;
F5FD   3590             puls  x,pc;


                 /*
                  * convert_abs_angle_to_rise_run()
                  *
                  * This routine takes an angle value which is relative to
                  * the x-axis, converts it to an angle relative to the
                  * y-axis (by subtracting 0x10 [90 degrees] from the value),
                  * and then calculates the rise and run for that angle.
                  *
                  * At entry:
                  *     'b' contains the absolute angle value.
                  *     'a' contains the scalar velocity value.
                  *
                  * At exit:
                  *     'a' contains the rise value.
                  *     'b' contains the run value.
                  *
                  * Dp must be set to C8.
                  */
                 convert_abs_angle_to_rise_run:
F5FF   C010             subb  #0x10;


                 /*
                  * convert_angle_to_rise_run()
                  *
                  * This routine takes an angle value which is relative to
                  * the y-axis, and calculates the rise and run for that angle,
                  * relative to a passed-in scalar velocity value.  A large
                  * scalar value will cause an object to move quickly, while
                  * a small scalar value will cause an object to move more
                  * slowly.
                  *
                  * Keep in mind that most games store x & y coordinates as
                  * 2 bytes each, with the upper byte being the actual
                  * coordinate, and the lower byte being that which is
                  * usually added to the rise/run value; when the lower
                  * byte overflows into the hi byte, then the object will
                  * 'move'.  The rise/run values returned here are meant
                  * to be added to the low byte -- NOT the hi byte!!
                  *
                  * At entry:
                  *     'b' contains the Vectrex angle value.
                  *     'a' contains the scalar velocity value.
                  *
                  * At exit:
                  *     'a' contains the rise value.
                  *     'b' contains the run value.
                  *
                  * Dp must be set to C8.
                  */
                 convert_angle_to_rise_run:
F601   D736             stb   0x36;
F603   973B             sta   0x3B;
F605   8DE8             bsr   get_rotation_index_pairs;
F607   8D54             bsr   xform_a1;
F609   40               nega;
F60A   3402             pshs  a;
F60C   8D55             bsr   xform_2a;
F60E   3584             puls  b,pc;


                 /*
                  * rotate_vector_list2()
                  *
                  * This routine rotates a vector list of length 'n+1', where
                  * 'n' is specified by the value in the 'b' register.  The
                  * 'a' register contains the rotation value, and the 'x'
                  * contains a pointer to the vector list.  The 'u' register
                  * contains a pointer to a buffer into which the transformed
                  * points are to be saved.  The vector list must have the
                  * following format:
                  *
                  *     rel y, rel x, rel y, rel x, ...
                  *
                  * At entry:
                  *     'x' points to vector list.
                  *     'u' points to buffer to hold transformed points.
                  *     'a' contains the rotation angle value.
                  *     'b' contains the number of points (minus 1).
                  */
                 rotate_vector_list2:
F610   B7C836           sta   $C836;
F613   F7C823           stb   $C823;
F616   3408             pshs  dp;
F618   BDF1AF           jsr   $dptoC8;
F61B   8DD2             bsr   get_rotation_index_pairs;
F61D   2018             bra   transform_next_point;


                 /*
                  * rotate_vector_list1()
                  *
                  * This routine is responsible for rotation a vector list
                  * having the following format:
                  *
                  *     mode, rel y, rel x,
                  *     mode, rel y, rel x,
                  *       .     .      .
                  *       .     .      .
                  *     mode, rel y, rel x,
                  *     0x01
                  *
                  * The 'a' register contains the rotation value, and the 'x'
                  * contains a pointer to the vector list.  The 'u' register
                  * contains a pointer to a buffer into which the transformed
                  * points are to be saved.
                  *
                  * At entry:
                  *     'x' points to vector list.
                  *     'u' points to buffer to hold transformed points.
                  *     'a' contains the rotation angle value.
                  */
                 rotate_vector_list1:
F61F   B7C836           sta   $C836;
F622   3408             pshs  dp;
F624   BDF1AF           jsr   $dptoC8;
F627   9723             sta   0x23;
F629   8DC4             bsr   get_rotation_index_pairs;
                 rotate_vl1_loop:
F62B   A680             lda   ,x+;      /* Copy the mode byte. */
F62D   A7C0             sta   ,u+;
F62F   2F06             ble   transform_next_point;
F631   0F23             clr   0x23;
F633   3588             puls  dp,pc;


                 /*
                  * transform_next_point()
                  *
                  * This routine does the actual transformation of the
                  * endpoint pointed to by the 'x' register.  After the
                  * point has been transformed, and save in the buffer
                  * pointed to by the 'u' register, a check will be made
                  * to see if there are any more endpoints left.  If C823
                  * is 0, then we are done; if C823 > 0, then we were called
                  * by rotate_vector_list2(), so we should transform the
                  * next point; however, if C823 < 0, then we were called
                  * by rotate_vector_list1(), and so we should return control
                  * to that procedure, so that it can look at the mode for
                  * the next endpoint, and thus decide whether to continue
                  * or stop.
                  *
                  * At entry:
                  *     C823 indicates both endpoint count & who called us.
                  *     'x' points to next set of endpoints.
                  *     'u' points to transformation buffer.
                  */
                 decrement_vl_counter:
F635   0A23             dec   0x23;
                 transform_next_point:
F637   A680             lda   ,x+;      /* Get the y coordinate. */
F639   8D26             bsr   xform_2;
F63B   A7C4             sta   ,u;
F63D   A684             lda   ,x;       /* Get the x coordinate. */
F63F   8D1A             bsr   xform_1;
F641   ABC4             adda  ,u;
F643   A7C0             sta   ,u+;      /* Save transformed y coordinate. */
F645   A61F             lda   -1,x;     /* Get the y coordinate. */
F647   8D12             bsr   xform_1;
F649   A7C4             sta   ,u;
F64B   A680             lda   ,x+;      /* Get the x coordinate. */
F64D   8D12             bsr   xform_2;
F64F   A0C4             suba  ,u;
F651   A7C0             sta   ,u+;      /* Save transformed x coordinate. */
F653   9623             lda   0x23;
F655   2BD4             bmi   rotate_vl1_loop;
F657   26DC             bne   decrement_vl_counter;
F659   3588             puls  dp,pc;


                 /*
                  * xform_1()
                  * xform_1a()
                  *
                  * These two routines generate a rise/run value, using
                  * the index pair in C837-C838.  For xform_1() the scalar
                  * value is passed-in in the 'a' register, while for
                  * xform_1a(), the scalar value must already be in C83B.
                  * The transformed value is return in the 'a' register.
                  *
                  * Dp must be set to C8.
                  */
                 xform_1:
F65B   973B             sta   0x3B;
                 xform_1a:
F65D   DC37             ldd   0x37;
F65F   2004             bra   PF665;


                 /*
                  * xform_2()
                  * xform_2a()
                  *
                  * These two routines generate a rise/run value, using
                  * the index pair in C839-C83A.  For xform_2() the scalar
                  * value is passed-in in the 'a' register, while for
                  * xform_2a(), the scalar value must already be in C83B.
                  * The transformed value is return in the 'a' register.
                  *
                  * Dp must be set to C8.
                  */
                 xform_2:
F661   973B             sta   0x3B;
                 xform_2a:
F663   DC39             ldd   0x39;
F665   D73C      PF665: stb   0x3C;
F667   C501             bitb  #0x01;
F669   2704             beq   PF66F;
F66B   963B             lda   0x3B;
F66D   200A             bra   PF679;
F66F   D63B      PF66F: ldb   0x3B;
F671   2A03             bpl   PF676;
F673   033C             com   0x3C;
F675   50               negb;
F676   3D        PF676: mul;
F677   8900             adca  #0x00;
F679   D63C      PF679: ldb   0x3C;
F67B   2A01             bpl   PF67E;
F67D   40               nega;
F67E   39        PF67E: rts;


                 /*
                  * move_block()
                  *
                  * This routine copies a block of memory, starting at the
                  * hi address, and working down to the low address.  The
                  * base of the source address is specified in the 'u'
                  * register, and the base of the destination address is
                  * specified in the 'x' register.  The 'a' register contains
                  *  the number of bytes to copy (minus 1); 0x80 is the
                  * maximum value which can be specified.
                  *
                  * At entry:
                  *     'u' points to the source base.
                  *     'x' points to the destination base.
                  *     'a' contains the byte count (minus 1).
                  */
                 move_block:
F67F   E6C6             ldb   a,u;
F681   E786             stb   a,x;


                 /*
                  * move_block2()
                  *
                  * This routine copies a block of memory, starting at the
                  * hi address, and working down to the low address.  The
                  * base of the source address is specified in the 'u'
                  * register, and the base of the destination address is
                  * specified in the 'x' register.  The 'a' register contains
                  * the number of bytes to copy; 0x80 is the
                  * maximum value which can be specified.
                  *
                  * At entry:
                  *     'u' points to the source base.
                  *     'x' points to the destination base.
                  *     'a' contains the byte count.
                  */
                 move_block2:
F683   4A               deca;
F684   2AF9             bpl   move_block;
F686   39        PF686: rts;


                 /*
                  * init_sound()
                  * init_sound2()
                  *
                  * These routines are responsible for filling the music work
                  * buffer while a sound is being made.  It should be called
                  * once during each refresh cycle.  If you want to start a
                  * new sound, then you must set C856 to 0x01, and point the
                  * 'u' register to the sound block.  If no sound is in
                  * progress (C856 = 0), then it returns immediately (unless
                  * you called init_sound2(), which does not make this check).
                  * When a sound is in progress, C856 will be set to 0x80.
                  *
                  * These routines process a single note at a time, and
                  * calculate the amplitude and course/fine tuning values for
                  * the 3 sound channels.  The values calculated stored in
                  * the music work buffer, at C83F-C84C.
                  *
                  * At entry:
                  *     C856 may need to be set.
                  *     'u' should point to the start of a music block.
                  *
                  * Dp must be set to C8.
                  */
                 init_sound:
F687   9656             lda   0x56;
F689   2B28             bmi   continue_sound;
F68B   27F9             beq   PF686;
                 init_sound2:
F68D   8EFC8D           ldx   #music_routine_data;
F690   9F4D             stx   0x4D;
F692   8680             lda   #0x80;
F694   9756             sta   0x56;
F696   ECC1             ldd   ,u++;
F698   DD4F             std   0x4F;
F69A   ECC1             ldd   ,u++;
F69C   DD51             std   0x51;
F69E   DF53             stu   0x53;
F6A0   BDF533           jsr   $init_music_buf;
F6A3   CC1F1F           ldd   #0x1F1F;
F6A6   DD5F             std   0x5F;
F6A8   CC0000           ldd   #0x0000;
F6AB   DD63             std   0x63;
F6AD   DD65             std   0x65;
F6AF   9755             sta   0x55;
F6B1   2039             bra   PF6EC;
                 continue_sound:
F6B3   CEC85E           ldu   #0xC85E;
F6B6   C602             ldb   #0x02;
F6B8   A6C5      PF6B8: lda   b,u;
F6BA   811F             cmpa  #0x1F;
F6BC   2702             beq   PF6C0;
F6BE   6CC5             inc   b,u;
F6C0   5A        PF6C0: decb;
F6C1   2AF5             bpl   PF6B8;
F6C3   9E51             ldx   0x51;
F6C5   CEC858           ldu   #0xC858;
F6C8   8607             lda   #0x07;
F6CA   6CC4      PF6CA: inc   ,u;
F6CC   A1C4             cmpa  ,u;
F6CE   2C02             bge   PF6D2;
F6D0   6FC4             clr   ,u;
F6D2   E6C0      PF6D2: ldb   ,u+;
F6D4   C407             andb  #0x07;
F6D6   E685             ldb   b,x;
F6D8   E7C0             stb   ,u+;
F6DA   4C               inca;
F6DB   8109             cmpa  #0x09;
F6DD   23EB             bls   PF6CA;
F6DF   0A57             dec   0x57;
F6E1   266B             bne   PF74E;
F6E3   9655      PF6E3: lda   0x55;     /* This is changing octaves, or */
F6E5   4A               deca;           /* something like that.         */
F6E6   2A02             bpl   PF6EA;
F6E8   8602             lda   #0x02;
F6EA   9755      PF6EA: sta   0x55;
F6EC   E69FC853  PF6EC: ldb   [0xC853]; /* Grab the music note. */
F6F0   CEC85E           ldu   #0xC85E;
F6F3   6FC6             clr   a,u;
F6F5   C540             bitb  #0x40; /* "@" */
F6F7   2719             beq   PF712;
F6F9   8EF9E4           ldx   #music_stuff1;
F6FC   A686             lda   a,x;
F6FE   9445             anda  0x45;
F700   9745             sta   0x45;
F702   9655             lda   0x55;
F704   8B03             adda  #0x03;
F706   A686             lda   a,x;
F708   9A45             ora   0x45;
F70A   9745             sta   0x45;
F70C   C41F             andb  #0x1F;
F70E   D746             stb   0x46;
F710   2023             bra   PF735;
F712   8EF9EA    PF712: ldx   #music_stuff2;
F715   A686             lda   a,x;
F717   9445             anda  0x45;
F719   9745             sta   0x45;
F71B   9655             lda   0x55;
F71D   8B03             adda  #0x03;
F71F   A686             lda   a,x;
F721   9A45             ora   0x45;
F723   9745             sta   0x45;
F725   9655             lda   0x55;
F727   48               asla;
F728   8B03             adda  #0x03;
F72A   33C6             leau  a,u;
F72C   C43F             andb  #0x3F; /* "?" */
F72E   58               aslb;
F72F   9E4D             ldx   0x4D;
F731   EC85             ldd   b,x;
F733   EDC4             std   ,u;
F735   9E53      PF735: ldx   0x53;
F737   E680             ldb   ,x+;
F739   9F53             stx   0x53;
F73B   5D               tstb;
F73C   2BA5             bmi   PF6E3;
F73E   E680             ldb   ,x+;
F740   2A06             bpl   PF748;
F742   BDF533           jsr   $init_music_buf;
F745   0F56             clr   0x56;
F747   39               rts;
F748   9F53      PF748: stx   0x53;
F74A   C43F             andb  #0x3F; /* "?" */
F74C   D757             stb   0x57;
F74E   109E4F    PF74E: ldy   0x4F;
F751   CEC85E           ldu   #0xC85E;
F754   8EC842           ldx   #0xC842;
F757   8602             lda   #0x02;
F759   E6C0      PF759: ldb   ,u+;
F75B   C501             bitb  #0x01;
F75D   2707             beq   PF766;
F75F   54               lsrb;
F760   E6A5             ldb   b,y;
F762   C40F             andb  #0x0F;
F764   2007             bra   PF76D;
F766   54        PF766: lsrb;
F767   E6A5             ldb   b,y;
F769   54               lsrb;
F76A   54               lsrb;
F76B   54               lsrb;
F76C   54               lsrb;
F76D   E786      PF76D: stb   a,x;
F76F   4A               deca;
F770   2AE7             bpl   PF759;
F772   CEC867           ldu   #0xC867;
F775   8EC847           ldx   #0xC847;
F778   ECC3      PF778: ldd   ,--u;
F77A   6D58             tst   -8,u;
F77C   2A0A             bpl   PF788;
F77E   6058             neg   -8,u;
F780   E058             subb  -8,u;
F782   8200             sbca  #0x00;
F784   6058             neg   -8,u;
F786   2004             bra   PF78C;
F788   EB58      PF788: addb  -8,u;
F78A   8900             adca  #0x00;
F78C   ED81      PF78C: std   ,x++;
F78E   8CC84D           cmpx  #0xC84D;
F791   26E5             bne   PF778;    /* Temporarily stop when the work */
F793   39        PF793: rts;            /* buffer has been filled.        */


                 player_string:
F794   20               .byte 0x20; /* rel y for player number */
F795   C0               .byte 0xC0; /* rel x for player number  */
F796   40               .byte 0x40; /* rel y for player string  */
F797   C0               .byte 0xC0; /* rel x for player string  */
F798   50               .byte "PLAYER",0x80;

                 game_string:
F79F   E0               .byte 0xE0; /* rel y for game number */
F7A0   C0               .byte 0xC0; /* rel x for game number  */
F7A1   01               .byte 0x01; /* rel y for game string  */
F7A2   C0               .byte 0xC0; /* rel x for game string  */
F7A3   20               .byte " GAME",0x80;


                 /*
                  * get_players_game()
                  *
                  * This routine provides a game with the means for allowing
                  * the player to choose the game number he would like to
                  * play, and the number of players.  The game indicates
                  * the number of game versions available, by placing the
                  * value in the 'b' register.  The number of players allowed
                  * is specified in the 'a' register.  If a parameter is
                  * passed in with a value of 0, then the corresponding
                  * question will not be asked.  The number of players
                  * selected is returned in C879, while the game number
                  * selected is returned in C87A.
                  *
                  * At entry:
                  *     'a' indicates maximum number of players allowed.
                  *     'b' indicates the number of game versions available.
                  *
                  * At exit:
                  *     C879 contains number of players selected.
                  *     C87A contains the game version selected.
                  *
                  * Dp must be set to C8.
                  */
                 get_players_game:
F7A9   FDC84F           std   $C84F;
F7AC   4D               tsta;
F7AD   2702             beq   PF7B1;
F7AF   8601             lda   #0x01;
F7B1   5D        PF7B1: tstb;
F7B2   2702             beq   PF7B6;
F7B4   C601             ldb   #0x01;
F7B6   FDC879    PF7B6: std   $C879;
F7B9   BDF1AF           jsr   $dptoC8;
F7BC   CCF850           ldd   #0xF850;
F7BF   DD2A             std   0x2A;
F7C1   973C             sta   0x3C;
F7C3   2067             bra   handle_buttons;


                 /*
                  * handle_buttons()
                  *
                  * This routine performs most of the work involved in
                  * allowing the player to select a game version and the
                  * number of players.  It displays the game # and player
                  * options, and allows the player a certain amount of time
                  * to modify their values.  Anytime one of the buttons is
                  * to modify a value, the timer will be restarted.  When
                  * a button is pressed, the associated value is modified,
                  * and then redisplayed on the screen.  This routine will
                  * return when either the timer expires, or button 4 is
                  * pressed.
                  *
                  * At entry:
                  *     C879 contains maximum number of players allowed.
                  *     C87A contains number of game versions available.
                  *
                  * At exit:
                  *     C879 contains the number of players selected.
                  *     C87A contains the game version selected.
                  */
                 button_handler_loop:
F7C5   BDF192           jsr   $waitrecal;
F7C8   4F               clra;
F7C9   BDF1B4           jsr   $read_switches;
F7CC   BDF55A           jsr   $decrement_counters_C82E_C830;
F7CF   BDF2A9           jsr   $intensity_to_7F;
F7D2   B6C879           lda   $C879;
F7D5   108EF794         ldy   #player_string;
F7D9   8D5A             bsr   display_option_string;
F7DB   B6C87A           lda   $C87A;
F7DE   108EF79F         ldy   #game_string;
F7E2   8D51             bsr   display_option_string;
F7E4   BDF1AF           jsr   $dptoC8;
F7E7   963C             lda   0x3C;
F7E9   2706             beq   check_loop_counter;
F7EB   960F             lda   0x0F;
F7ED   263D             bne   handle_buttons;
F7EF   0F3C             clr   0x3C;
                 check_loop_counter:
F7F1   962F             lda   0x2F;
F7F3   279E             beq   PF793;
F7F5   962E             lda   0x2E;
F7F7   26CC             bne   button_handler_loop;
F7F9   9615             lda   0x15;    /* Start game if button 4 pressed. */
F7FB   2696             bne   PF793;
F7FD   9612             lda   0x12;    /* Check button 1. */
F7FF   270F             beq   PF810;
F801   9679             lda   0x79;
F803   270B             beq   PF810;
F805   4C               inca;          /* Increment player count. */
F806   914F             cmpa  0x4F;
F808   2302             bls   PF80C;
F80A   8601             lda   #0x01;
F80C   9779      PF80C: sta   0x79;
F80E   201C             bra   handle_buttons;
F810   967A      PF810: lda   0x7A;
F812   27B1             beq   button_handler_loop;
F814   D613             ldb   0x13;     /* Check button 2. */
F816   2709             beq   PF821;
F818   4C               inca;           /* Increment game number. */
F819   9150             cmpa  0x50;
F81B   230D             bls   PF82A;
F81D   8601             lda   #0x01;
F81F   2009             bra   PF82A;
F821   D614      PF821: ldb   0x14;     /* Check button 3. */
F823   27A0             beq   button_handler_loop;
F825   4A               deca;           /* Decrement game number. */
F826   2602             bne   PF82A;
F828   9650             lda   0x50;
F82A   977A      PF82A: sta   0x7A;

                 handle_buttons:
F82C   86F3             lda   #0xF3;    /* Reset loop counters. */
F82E   972F             sta   0x2F;
F830   43               coma;
F831   972E             sta   0x2E;
F833   2090             bra   button_handler_loop;


                 /*
                  * display_option_string()
                  *
                  * This routine displays the player or game option
                  * string, along with the current value for that
                  * option.  The 'a' register contains the value of
                  * the option, while the 'y' register must point
                  * to a block of the following form:
                  *
                  *     rel y, rel x,      ( for value )
                  *     rel y, rel x,      ( for option string)
                  *     option string,
                  *     0x80
                  *
                  * At entry:
                  *     'a' must contain option value.
                  *     'y' must point to string block.
                  */
                 display_option_string:
F835   8EC85E           ldx   #0xC85E;
F838   3402             pshs  a;
F83A   8D13             bsr   set_dft_score;
F83C   A6E0             lda   ,s+;
F83E   270E             beq   PF84E;
F840   8D1C             bsr   convert_a_to_bcd_and_add;
F842   1F13             tfr   x,u;
F844   ECA1             ldd   ,y++;
F846   BDF37A           jsr   $print_at_d;
F849   1F23             tfr   y,u;
F84B   BDF378           jsr   $print_with_dft_hw;
F84E   39        PF84E: rts;


                 /*
                  * set_dft_score()
                  *
                  * This routine will initialize the passed-in score string
                  * (pointed to by the 'x' register) to the following value:
                  *
                  *     "     0",0x80
                  *
                  * At entry:
                  *     'x' points to the string to be initialized.
                  */
                 set_dft_score:
F84F   CC2020           ldd   #0x2020;
F852   ED84             std   ,x;
F854   ED02             std   2,x;
F856   A704             sta   4,x;
F858   CC3080           ldd   #0x3080;
F85B   ED05             std   5,x;
F85D   39               rts;


                 /*
                  * convert_a_to_bcd_and_add()
                  *
                  * This routine takes the binary value specified in the
                  * 'a' register, and converts it to a BCD representation.
                  * This BCD value is then added to the BCD value which
                  * is in the buffer pointed to by the 'x' register.
                  *
                  * At entry:
                  *     'a' contains value to be converted.
                  *     'x' points to BCD to which new value is to be added.
                  */
                 convert_a_to_bcd_and_add:
F85E   CE0000           ldu   #0x0000;
F861   8163      PF861: cmpa  #0x63;   /* 99 */
F863   2308             bls   PF86D;
F865   8064             suba  #0x64;   /* 100 */
F867   33C90100         leau  0x0100,u;
F86B   20F4             bra   PF861;
F86D   8109      PF86D: cmpa  #0x09;   /* 9 */
F86F   2307             bls   PF878;
F871   800A             suba  #0x0A;   /* 10 */
F873   33C810           leau  0x10,u;
F876   20F5             bra   PF86D;
F878   33C6      PF878: leau  a,u;
F87A   1F30             tfr   u,d;


                 /*
                  * add_d_to_x_in_bcd()
                  *
                  * This routine takes the BCD value in the 'd' register,
                  * and adds it to the BCD value pointed by the 'x' register.
                  * The result is store in the location pointed to by the
                  * 'x' register.
                  *
                  * At entry:
                  *     'd' contains a BCD value.
                  *     'x' points to a second BCD value.
                  */
                 add_d_to_x_in_bcd:
F87C   3402             pshs  a;
F87E   3404             pshs  b;
F880   C605             ldb   #0x05;
F882   4F        PF882: clra;
F883   C101             cmpb  #0x01;
F885   2310             bls   PF897;
F887   C501             bitb  #0x01;
F889   2704             beq   PF88F;
F88B   A6E4             lda   ,s;
F88D   2006             bra   PF895;
F88F   A6E0      PF88F: lda   ,s+;
F891   44               lsra;
F892   44               lsra;
F893   44               lsra;
F894   44               lsra;
F895   840F      PF895: anda  #0x0F;
F897   BBC823    PF897: adda  $C823;
F89A   7FC823           clr   $C823;
F89D   AB85             adda  b,x;
F89F   812F             cmpa  #0x2F;
F8A1   2E02             bgt   PF8A5;
F8A3   8B10             adda  #0x10;
F8A5   8139      PF8A5: cmpa  #0x39;  /* Check for digit overflow. */
F8A7   2305             bls   PF8AE;
F8A9   800A             suba  #0x0A;
F8AB   7CC823           inc   $C823;
F8AE   A785      PF8AE: sta   b,x;
F8B0   5A               decb;
F8B1   2ACF             bpl   PF882;
F8B3   7FC823           clr   $C823;
F8B6   5F               clrb;
F8B7   A685      PF8B7: lda   b,x;    /* Strip leading zero's. */
F8B9   8130             cmpa  #0x30; /* "0" */
F8BB   2609             bne   PF8C6;
F8BD   8620             lda   #0x20;
F8BF   A785             sta   b,x;
F8C1   5C               incb;
F8C2   C105             cmpb  #0x05;
F8C4   2DF1             blt   PF8B7;
F8C6   39        PF8C6: rts;


                 /*
                  * compare_scores()
                  *
                  * This routine will compare two BCD score strings, to
                  * determine which one is higher.  The two strings are
                  * pointed to by the 'u' and 'x' registers.  Depending
                  * upon how the scores compare, one of the following
                  * values will be returned in the 'a' register:
                  *
                  *     1) The scores are the same: a = 0
                  *     2) 'x' score > 'u' score:   a = 1
                  *     3) 'u' score > 'x' score:   a = 2
                  *
                  * At entry:
                  *     'x' points to first score string.
                  *     'u' points to second score string.
                  *
                  * At exit:
                  *     'a' returns result of the compare.
                  */
                 compare_scores:
F8C7   3450             pshs  x,u;
F8C9   4F               clra;
F8CA   E680      PF8CA: ldb   ,x+;
F8CC   2B08             bmi   PF8D6;
F8CE   E1C0             cmpb  ,u+;
F8D0   27F8             beq   PF8CA;
F8D2   2201             bhi   PF8D5;
F8D4   4C               inca;
F8D5   4C        PF8D5: inca;
F8D6   35D0      PF8D6: puls  x,u,pc;


                 /*
                  * check_4_new_hi_score()
                  *
                  * This routine compares a players score string, pointed
                  * to by the 'x' register, to the current hi score, pointed
                  * by the 'u' register.  If the player's score is higher
                  * than the currently saved hi score, then the player's
                  * score will be copied into the hi score buffer pointed
                  * to by the 'u' register.
                  *
                  * At entry:
                  *     'x' points to a players BCD score string.
                  *     'u' points to the current hi score for the game.
                  */
                 check_4_new_hi_score:
F8D8   8DED             bsr   compare_scores;
F8DA   8101             cmpa  #0x01;
F8DC   2606             bne   PF8E4;
F8DE   A680      PF8DE: lda   ,x+;
F8E0   A7C0             sta   ,u+;
F8E2   2AFA             bpl   PF8DE;
F8E4   39        PF8E4: rts;


                 /*
                  * modify_target_and_check_4_hit1()
                  *
                  * This routine first modifies the position of the target,
                  * and then it checks to see if the bullet has hit the
                  * target.  The 'y' register contains the (y,x) position
                  * of the target, the 'u' register contains a pointer to
                  * the (y,x) modification values, the 'x' register contains
                  * the bullet (y,x) position, and the 'd' register contains
                  * the (height/2, width/2) of the target.
                  *
                  * (0,u) is added to the y position of the target, and (1,u)
                  * is added to the x position.
                  *
                  * At entry:
                  *     'y' contains position of the target.
                  *     'x' contains position of the bullet.
                  *     'u' points to target modification values.
                  *     'd' contains (h/2, w/2) size of target.
                  *
                  * At exit:
                  *     Carry bit set if the target & bullet have collided,
                  *     otherwise, the carry bit will be cleared.
                  */
                 modify_target_and_check_4_hit1:
F8E5   3420             pshs  y;
F8E7   3436             pshs  a,b,x,y;
F8E9   EC64             ldd   4,s;
F8EB   ABC4             adda  ,u;
F8ED   EB41             addb  1,u;
F8EF   ED64      PF8EF: std   4,s;
F8F1   2010             bra   check_bullet_for_hit2;


                 /*
                  * modify_target_and_check_4_hit2()
                  *
                  * This routine first modifies the position of the target,
                  * and then it checks to see if the bullet has hit the
                  * target.  The 'y' register contains the (y,x) position
                  * of the target, the 'u' register contains the (y,x)
                  * modification values, the 'x' register contains the
                  * bullet (y,x) position, and the 'd' register contains
                  * the (height/2, width/2) of the target.
                  *
                  * u(hi) is added to the y position of the target, and u(lo)
                  * is added to the x position.
                  *
                  * At entry:
                  *     'y' contains position of the target.
                  *     'x' contains position of the bullet.
                  *     'u' contains target modification values.
                  *     'd' contains (h/2, w/2) size of target.
                  *
                  * At exit:
                  *     Carry bit set if the target & bullet have collided,
                  *     otherwise, the carry bit will be cleared.
                  */
                 modify_target_and_check_4_hit2:
F8F3   3420             pshs  y;
F8F5   3436             pshs  a,b,x,y;
F8F7   1F30             tfr   u,d;
F8F9   AB64             adda  4,s;
F8FB   EB65             addb  5,s;
F8FD   20F0             bra   PF8EF;


                 /*
                  * check_bullet_for_hit()
                  * check_bullet_for_hit2()
                  *
                  * These routines check to see if a bullet has bit a target.
                  * If the bulet has hit the target, then the carry bit will
                  * be set; otherwise, the carry bit will be cleared.  A hit
                  * is checked for in the following fashion:
                  *
                  *   if (target y-height/2) <= bullet y <= (target y+height/2)
                  *                             and
                  *      (target x-width/2)  <= bullet x <= (target x+width/x)
                  *
                  *   then the bulet hist, otherwise it missed.
                  *
                  * At entry:
                  *     'x' contains the bullet position.
                  *     'y' contains the target position.
                  *     'd' contains the (height/2, width/2) of target.
                  *
                  * At exit:
                  *     Carry bit will be set if the bullet hit the target;
                  *     otherwise, the carry bit will be cleared.
                  */
                 check_bullet_for_hit:
F8FF   3420             pshs  y;
F901   3436             pshs  a,b,x,y;
                 check_bullet_for_hit2:
F903   1F41             tfr   sp,x;
F905   5F               clrb;        /* Start with the y coordinate. */
                 check_bullet_loop:
F906   3A               abx;
F907   A604             lda   4,x;   /* Target y + height/2, or */
F909   AB84             adda  ,x;    /* Target x + width/2      */
F90B   2802             bvc   check_bullet_pt1;
F90D   867F             lda   #0x7F;  /* Only goto edge of screen. */
                 check_bullet_pt1:
F90F   A102             cmpa  2,x;
F911   2D15             blt   flag_a_miss;
F913   A604             lda   4,x;
F915   A084             suba  ,x;
F917   2802             bvc   check_bullet_pt2;
F919   8680             lda   #0x80;
                 check_bullet_pt2:
F91B   A102             cmpa  2,x;
F91D   2E09             bgt   flag_a_miss;
F91F   5C               incb;
F920   C102             cmpb  #0x02;    /* Now, check x coordinate. */
F922   25E2             blo   check_bullet_loop;
F924   1A01             orcc  #0x01;    /* A hit; so set carry bit. */
F926   2002             bra   PF92A;
                 flag_a_miss:
F928   1CFE             andcc #0xFE;    /* A miss; so clear carry bit. */
F92A   3536      PF92A: puls  a,b,x,y;
F92C   35A0             puls  y,pc;


                 /*
                  * generate_explosion_sound()
                  *
                  * This routine appears to generate some type of an
                  * explosion sound, dependent upon the 4 bytes which
                  * are pointed to by the 'u' register.
                  *
                  * At entry:
                  *     'u' must point to a block of 4 bytes of data, which
                  *         somehow describe the type of sound to make.
                  *
                  * Dp must be set to C8.
                  */
                 generate_explosion_sound:
F92E   9667             lda   0x67;
F930   2A29             bpl   PF95B;
F932   847F             anda  #0x7F;
F934   9767             sta   0x67;
F936   8EC858           ldx   #0xC858;
F939   8604             lda   #0x04;
F93B   BDF683           jsr   $move_block2;
F93E   54               lsrb;
F93F   54               lsrb;
F940   54               lsrb;
F941   DA58             orb   0x58;
F943   C407             andb  #0x07;
F945   D754             stb   0x54;
F947   D658             ldb   0x58;
F949   C438             andb  #0x38; /* "8" */
F94B   D753             stb   0x53;
F94D   D658             ldb   0x58;
F94F   C407             andb  #0x07;
F951   D75D             stb   0x5D;
F953   C602             ldb   #0x02;
F955   D75C             stb   0x5C;
F957   867F             lda   #0x7F;
F959   200D             bra   PF968;
F95B   9677      PF95B: lda   0x77;
F95D   276A             beq   PF9C9;
F95F   905B             suba  0x5B;
F961   2A05             bpl   PF968;
F963   5F               clrb;
F964   D777             stb   0x77;
F966   2062             bra   PF9CA;
F968   9777      PF968: sta   0x77;
F96A   44               lsra;
F96B   44               lsra;
F96C   D653             ldb   0x53;
F96E   270D             beq   PF97D;
F970   9746             sta   0x46;
F972   D659             ldb   0x59;
F974   2B05             bmi   PF97B;
F976   2705             beq   PF97D;
F978   1F89             tfr   a,b;
F97A   53               comb;
F97B   D746      PF97B: stb   0x46;
F97D   44        PF97D: lsra;
F97E   8107             cmpa  #0x07;
F980   2305             bls   PF987;
F982   810F             cmpa  #0x0F;
F984   2701             beq   PF987;
F986   4C               inca;
F987   D65A      PF987: ldb   0x5A;
F989   2B06             bmi   PF991;
F98B   2702             beq   PF98F;
F98D   880F             eora  #0x0F;
F98F   1F89      PF98F: tfr   a,b;
F991   8D37      PF991: bsr   PF9CA;
F993   D65D             ldb   0x5D;
F995   272B             beq   PF9C2;
F997   965C      PF997: lda   0x5C;
F999   4A               deca;
F99A   2A02             bpl   PF99E;
F99C   8602             lda   #0x02;
F99E   975C      PF99E: sta   0x5C;
F9A0   BDF57E           jsr   $get_bit_mask;
F9A3   955D             bita  0x5D;
F9A5   27F0             beq   PF997;
F9A7   D65C             ldb   0x5C;
F9A9   58               aslb;
F9AA   50               negb;
F9AB   8EC84B           ldx   #0xC84B;
F9AE   3085             leax  b,x;
F9B0   BDF517           jsr   $get_random_a;
F9B3   840F             anda  #0x0F;
F9B5   8105             cmpa  #0x05;
F9B7   2203             bhi   PF9BC;
F9B9   48               asla;
F9BA   8B05             adda  #0x05;
F9BC   A784      PF9BC: sta   ,x;
F9BE   967E             lda   0x7E;
F9C0   A701             sta   1,x;
F9C2   9658      PF9C2: lda   0x58;
F9C4   43               coma;
F9C5   9445             anda  0x45;
F9C7   9745             sta   0x45;
F9C9   39        PF9C9: rts;
F9CA   9654      PF9CA: lda   0x54;
F9CC   8EC845           ldx   #0xC845;
F9CF   4D        PF9CF: tsta;
F9D0   2709             beq   PF9DB;
F9D2   301F             leax  -1,x;
F9D4   44        PF9D4: lsra;
F9D5   24F8             bhs   PF9CF;
F9D7   E784             stb   ,x;
F9D9   20F4             bra   PF9CF;
F9DB   39        PF9DB: rts;


                 bit_masks:
F9DC   01               .byte 0x01;
F9DD   02               .byte 0x02;
F9DE   04               .byte 0x04;
F9DF   08               .byte 0x08;
F9E0   10               .byte 0x10;
F9E1   20               .byte 0x20;
F9E2   40               .byte 0x40;
F9E3   80               .byte 0x80;


                 music_stuff1:
F9E4   F7               .byte 0xF7;
F9E5   EF               .byte 0xEF;
F9E6   DF               .byte 0xDF;
F9E7   01               .byte 0x01;
F9E8   02               .byte 0x02;
F9E9   04               .byte 0x04;


                 music_stuff2:
F9EA   FE               .byte 0xFE;
F9EB   FD               .byte 0xFD;
F9EC   FB               .byte 0xFB;
F9ED   08               .byte 0x08;
F9EE   10               .byte 0x10;
F9EF   20               .byte 0x20;


F9F0   7F        SF9F0: .byte 0x7F;
F9F1   7F               .byte 0x7F;
F9F2   80               .byte 0x80;
F9F3   80               .byte 0x80;


                 /*
                  * This is the start of the character generation table used
                  * by the string printing routine.  The table starts at
                  * F9F4, and goes for the next 480 bytes.
                  */
                 character_table:
F9F4   00               .byte 0x00;
F9F5   20               .byte 0x20;
F9F6   50               .byte 0x50;
F9F7   50               .byte 0x50;
F9F8   20               .byte 0x20;
F9F9   C8               .byte 0xC8;
F9FA   20               .byte 0x20;
F9FB   10               .byte 0x10;
F9FC   10               .byte 0x10;
F9FD   40               .byte 0x40;

F9FE   20               .byte 0x20;
F9FF   00               .byte 0x00;
FA00   00               .byte 0x00;
FA01   00               .byte 0x00;
FA02   00               .byte 0x00;
FA03   08               .byte 0x08;
FA04   30               .byte 0x30;
FA05   20               .byte 0x20;
FA06   70               .byte 0x70;
FA07   70               .byte 0x70;

FA08   10               .byte 0x10;
FA09   F8               .byte 0xF8;
FA0A   30               .byte 0x30;
FA0B   F8               .byte 0xF8;
FA0C   70               .byte 0x70;
FA0D   70               .byte 0x70;
FA0E   00               .byte 0x00;
FA0F   60               .byte 0x60;
FA10   00               .byte 0x00;
FA11   00               .byte 0x00;

FA12   00               .byte 0x00;
FA13   70               .byte 0x70;
FA14   70               .byte 0x70;
FA15   20               .byte 0x20;
FA16   F0               .byte 0xF0;
FA17   70               .byte 0x70;
FA18   F0               .byte 0xF0;
FA19   F8               .byte 0xF8;
FA1A   F8               .byte 0xF8;
FA1B   78               .byte 0x78;

FA1C   88               .byte 0x88;
FA1D   70               .byte 0x70;
FA1E   08               .byte 0x08;
FA1F   88               .byte 0x88;
FA20   80               .byte 0x80;
FA21   88               .byte 0x88;
FA22   88               .byte 0x88;
FA23   F8               .byte 0xF8;
FA24   F0               .byte 0xF0;
FA25   70               .byte 0x70;

FA26   F0               .byte 0xF0;
FA27   70               .byte 0x70;
FA28   F8               .byte 0xF8;
FA29   88               .byte 0x88;
FA2A   88               .byte 0x88;
FA2B   88               .byte 0x88;
FA2C   88               .byte 0x88;
FA2D   88               .byte 0x88;
FA2E   F8               .byte 0xF8;
FA2F   70               .byte 0x70;

FA30   80               .byte 0x80;
FA31   70               .byte 0x70;
FA32   20               .byte 0x20;
FA33   00               .byte 0x00;
FA34   00               .byte 0x00;
FA35   20               .byte 0x20;
FA36   08               .byte 0x08;
FA37   20               .byte 0x20;
FA38   00               .byte 0x00;
FA39   00               .byte 0x00;

FA3A   00               .byte 0x00;
FA3B   38               .byte 0x38;
FA3C   10               .byte 0x10;
FA3D   20               .byte 0x20;
FA3E   44               .byte 0x44;
FA3F   44               .byte 0x44;
FA40   00               .byte 0x00;
FA41   FE               .byte 0xFE;
FA42   FF               .byte 0xFF;
FA43   FE               .byte 0xFE;

FA44   00               .byte 0x00;
FA45   70               .byte 0x70;
FA46   50               .byte 0x50;
FA47   50               .byte 0x50;
FA48   78               .byte 0x78;
FA49   C8               .byte 0xC8;
FA4A   50               .byte 0x50;
FA4B   20               .byte 0x20;
FA4C   20               .byte 0x20;
FA4D   20               .byte 0x20;

FA4E   A8               .byte 0xA8;
FA4F   20               .byte 0x20;
FA50   00               .byte 0x00;
FA51   00               .byte 0x00;
FA52   00               .byte 0x00;
FA53   08               .byte 0x08;
FA54   48               .byte 0x48;
FA55   60               .byte 0x60;
FA56   88               .byte 0x88;
FA57   88               .byte 0x88;

FA58   30               .byte 0x30;
FA59   80               .byte 0x80;
FA5A   40               .byte 0x40;
FA5B   08               .byte 0x08;
FA5C   88               .byte 0x88;
FA5D   88               .byte 0x88;
FA5E   60               .byte 0x60;
FA5F   60               .byte 0x60;
FA60   10               .byte 0x10;
FA61   00               .byte 0x00;

FA62   40               .byte 0x40;
FA63   88               .byte 0x88;
FA64   88               .byte 0x88;
FA65   50               .byte 0x50;
FA66   48               .byte 0x48;
FA67   88               .byte 0x88;
FA68   48               .byte 0x48;
FA69   80               .byte 0x80;
FA6A   80               .byte 0x80;
FA6B   80               .byte 0x80;

FA6C   88               .byte 0x88;
FA6D   20               .byte 0x20;
FA6E   08               .byte 0x08;
FA6F   90               .byte 0x90;
FA70   80               .byte 0x80;
FA71   D8               .byte 0xD8;
FA72   C8               .byte 0xC8;
FA73   88               .byte 0x88;
FA74   88               .byte 0x88;
FA75   88               .byte 0x88;

FA76   88               .byte 0x88;
FA77   88               .byte 0x88;
FA78   A8               .byte 0xA8;
FA79   88               .byte 0x88;
FA7A   88               .byte 0x88;
FA7B   88               .byte 0x88;
FA7C   88               .byte 0x88;
FA7D   88               .byte 0x88;
FA7E   08               .byte 0x08;
FA7F   40               .byte 0x40;

FA80   80               .byte 0x80;
FA81   08               .byte 0x08;
FA82   50               .byte 0x50;
FA83   00               .byte 0x00;
FA84   00               .byte 0x00;
FA85   70               .byte 0x70;
FA86   0C               .byte 0x0C;
FA87   20               .byte 0x20;
FA88   70               .byte 0x70;
FA89   70               .byte 0x70;

FA8A   00               .byte 0x00;
FA8B   44               .byte 0x44;
FA8C   10               .byte 0x10;
FA8D   70               .byte 0x70;
FA8E   00               .byte 0x00;
FA8F   00               .byte 0x00;
FA90   6C               .byte 0x6C;
FA91   82               .byte 0x82;
FA92   FF               .byte 0xFF;
FA93   FE               .byte 0xFE;

FA94   00               .byte 0x00;
FA95   70               .byte 0x70;
FA96   50               .byte 0x50;
FA97   F8               .byte 0xF8;
FA98   A0               .byte 0xA0;
FA99   10               .byte 0x10;
FA9A   50               .byte 0x50;
FA9B   40               .byte 0x40;
FA9C   40               .byte 0x40;
FA9D   10               .byte 0x10;

FA9E   70               .byte 0x70;
FA9F   20               .byte 0x20;
FAA0   00               .byte 0x00;
FAA1   00               .byte 0x00;
FAA2   00               .byte 0x00;
FAA3   10               .byte 0x10;
FAA4   48               .byte 0x48;
FAA5   20               .byte 0x20;
FAA6   08               .byte 0x08;
FAA7   08               .byte 0x08;

FAA8   50               .byte 0x50;
FAA9   F0               .byte 0xF0;
FAAA   80               .byte 0x80;
FAAB   10               .byte 0x10;
FAAC   88               .byte 0x88;
FAAD   88               .byte 0x88;
FAAE   60               .byte 0x60;
FAAF   00               .byte 0x00;
FAB0   20               .byte 0x20;
FAB1   78               .byte 0x78;

FAB2   20               .byte 0x20;
FAB3   08               .byte 0x08;
FAB4   A8               .byte 0xA8;
FAB5   88               .byte 0x88;
FAB6   48               .byte 0x48;
FAB7   80               .byte 0x80;
FAB8   48               .byte 0x48;
FAB9   80               .byte 0x80;
FABA   80               .byte 0x80;
FABB   80               .byte 0x80;

FABC   88               .byte 0x88;
FABD   20               .byte 0x20;
FABE   08               .byte 0x08;
FABF   A0               .byte 0xA0;
FAC0   80               .byte 0x80;
FAC1   A8               .byte 0xA8;
FAC2   A8               .byte 0xA8;
FAC3   88               .byte 0x88;
FAC4   88               .byte 0x88;
FAC5   88               .byte 0x88;

FAC6   88               .byte 0x88;
FAC7   40               .byte 0x40;
FAC8   20               .byte 0x20;
FAC9   88               .byte 0x88;
FACA   88               .byte 0x88;
FACB   88               .byte 0x88;
FACC   50               .byte 0x50;
FACD   50               .byte 0x50;
FACE   10               .byte 0x10;
FACF   40               .byte 0x40;

FAD0   40               .byte 0x40;
FAD1   08               .byte 0x08;
FAD2   88               .byte 0x88;
FAD3   00               .byte 0x00;
FAD4   70               .byte 0x70;
FAD5   A8               .byte 0xA8;
FAD6   0A               .byte 0x0A;
FAD7   20               .byte 0x20;
FAD8   88               .byte 0x88;
FAD9   F8               .byte 0xF8;

FADA   60               .byte 0x60;
FADB   BA               .byte 0xBA;
FADC   38               .byte 0x38;
FADD   20               .byte 0x20;
FADE   00               .byte 0x00;
FADF   00               .byte 0x00;
FAE0   92               .byte 0x92;
FAE1   82               .byte 0x82;
FAE2   FF               .byte 0xFF;
FAE3   FE               .byte 0xFE;

FAE4   00               .byte 0x00;
FAE5   20               .byte 0x20;
FAE6   00               .byte 0x00;
FAE7   50               .byte 0x50;
FAE8   70               .byte 0x70;
FAE9   20               .byte 0x20;
FAEA   60               .byte 0x60;
FAEB   00               .byte 0x00;
FAEC   40               .byte 0x40;
FAED   10               .byte 0x10;

FAEE   A8               .byte 0xA8;
FAEF   F8               .byte 0xF8;
FAF0   00               .byte 0x00;
FAF1   70               .byte 0x70;
FAF2   00               .byte 0x00;
FAF3   20               .byte 0x20;
FAF4   48               .byte 0x48;
FAF5   20               .byte 0x20;
FAF6   70               .byte 0x70;
FAF7   30               .byte 0x30;

FAF8   90               .byte 0x90;
FAF9   08               .byte 0x08;
FAFA   F0               .byte 0xF0;
FAFB   20               .byte 0x20;
FAFC   70               .byte 0x70;
FAFD   78               .byte 0x78;
FAFE   00               .byte 0x00;
FAFF   60               .byte 0x60;
FB00   40               .byte 0x40;
FB01   00               .byte 0x00;

FB02   10               .byte 0x10;
FB03   10               .byte 0x10;
FB04   B8               .byte 0xB8;
FB05   88               .byte 0x88;
FB06   70               .byte 0x70;
FB07   80               .byte 0x80;
FB08   48               .byte 0x48;
FB09   E0               .byte 0xE0;
FB0A   E0               .byte 0xE0;
FB0B   98               .byte 0x98;

FB0C   F8               .byte 0xF8;
FB0D   20               .byte 0x20;
FB0E   08               .byte 0x08;
FB0F   C0               .byte 0xC0;
FB10   80               .byte 0x80;
FB11   A8               .byte 0xA8;
FB12   98               .byte 0x98;
FB13   88               .byte 0x88;
FB14   F0               .byte 0xF0;
FB15   88               .byte 0x88;

FB16   F0               .byte 0xF0;
FB17   20               .byte 0x20;
FB18   20               .byte 0x20;
FB19   88               .byte 0x88;
FB1A   50               .byte 0x50;
FB1B   A8               .byte 0xA8;
FB1C   20               .byte 0x20;
FB1D   20               .byte 0x20;
FB1E   20               .byte 0x20;
FB1F   40               .byte 0x40;

FB20   20               .byte 0x20;
FB21   08               .byte 0x08;
FB22   00               .byte 0x00;
FB23   00               .byte 0x00;
FB24   FE               .byte 0xFE;
FB25   20               .byte 0x20;
FB26   08               .byte 0x08;
FB27   20               .byte 0x20;
FB28   88               .byte 0x88;
FB29   F8               .byte 0xF8;

FB2A   F0               .byte 0xF0;
FB2B   A2               .byte 0xA2;
FB2C   38               .byte 0x38;
FB2D   F8               .byte 0xF8;
FB2E   82               .byte 0x82;
FB2F   38               .byte 0x38;
FB30   92               .byte 0x92;
FB31   82               .byte 0x82;
FB32   FF               .byte 0xFF;
FB33   FE               .byte 0xFE;

FB34   00               .byte 0x00;
FB35   00               .byte 0x00;
FB36   00               .byte 0x00;
FB37   F8               .byte 0xF8;
FB38   70               .byte 0x70;
FB39   40               .byte 0x40;
FB3A   A8               .byte 0xA8;
FB3B   00               .byte 0x00;
FB3C   40               .byte 0x40;
FB3D   10               .byte 0x10;

FB3E   A8               .byte 0xA8;
FB3F   20               .byte 0x20;
FB40   40               .byte 0x40;
FB41   00               .byte 0x00;
FB42   00               .byte 0x00;
FB43   40               .byte 0x40;
FB44   48               .byte 0x48;
FB45   20               .byte 0x20;
FB46   80               .byte 0x80;
FB47   08               .byte 0x08;

FB48   F8               .byte 0xF8;
FB49   08               .byte 0x08;
FB4A   88               .byte 0x88;
FB4B   40               .byte 0x40;
FB4C   88               .byte 0x88;
FB4D   08               .byte 0x08;
FB4E   60               .byte 0x60;
FB4F   60               .byte 0x60;
FB50   20               .byte 0x20;
FB51   78               .byte 0x78;

FB52   20               .byte 0x20;
FB53   20               .byte 0x20;
FB54   B0               .byte 0xB0;
FB55   F8               .byte 0xF8;
FB56   48               .byte 0x48;
FB57   80               .byte 0x80;
FB58   48               .byte 0x48;
FB59   80               .byte 0x80;
FB5A   80               .byte 0x80;
FB5B   88               .byte 0x88;

FB5C   88               .byte 0x88;
FB5D   20               .byte 0x20;
FB5E   08               .byte 0x08;
FB5F   A0               .byte 0xA0;
FB60   80               .byte 0x80;
FB61   88               .byte 0x88;
FB62   88               .byte 0x88;
FB63   88               .byte 0x88;
FB64   80               .byte 0x80;
FB65   A8               .byte 0xA8;

FB66   A0               .byte 0xA0;
FB67   10               .byte 0x10;
FB68   20               .byte 0x20;
FB69   88               .byte 0x88;
FB6A   50               .byte 0x50;
FB6B   A8               .byte 0xA8;
FB6C   50               .byte 0x50;
FB6D   20               .byte 0x20;
FB6E   40               .byte 0x40;
FB6F   40               .byte 0x40;

FB70   10               .byte 0x10;
FB71   08               .byte 0x08;
FB72   00               .byte 0x00;
FB73   00               .byte 0x00;
FB74   FE               .byte 0xFE;
FB75   20               .byte 0x20;
FB76   78               .byte 0x78;
FB77   A8               .byte 0xA8;
FB78   88               .byte 0x88;
FB79   F8               .byte 0xF8;

FB7A   F0               .byte 0xF0;
FB7B   BA               .byte 0xBA;
FB7C   7C               .byte 0x7C;
FB7D   20               .byte 0x20;
FB7E   44               .byte 0x44;
FB7F   44               .byte 0x44;
FB80   6C               .byte 0x6C;
FB81   82               .byte 0x82;
FB82   FF               .byte 0xFF;
FB83   FE               .byte 0xFE;

FB84   00               .byte 0x00;
FB85   00               .byte 0x00;
FB86   00               .byte 0x00;
FB87   50               .byte 0x50;
FB88   28               .byte 0x28;
FB89   98               .byte 0x98;
FB8A   90               .byte 0x90;
FB8B   00               .byte 0x00;
FB8C   20               .byte 0x20;
FB8D   20               .byte 0x20;

FB8E   00               .byte 0x00;
FB8F   20               .byte 0x20;
FB90   40               .byte 0x40;
FB91   00               .byte 0x00;
FB92   00               .byte 0x00;
FB93   80               .byte 0x80;
FB94   48               .byte 0x48;
FB95   20               .byte 0x20;
FB96   80               .byte 0x80;
FB97   88               .byte 0x88;

FB98   10               .byte 0x10;
FB99   88               .byte 0x88;
FB9A   88               .byte 0x88;
FB9B   80               .byte 0x80;
FB9C   88               .byte 0x88;
FB9D   10               .byte 0x10;
FB9E   60               .byte 0x60;
FB9F   20               .byte 0x20;
FBA0   10               .byte 0x10;
FBA1   00               .byte 0x00;

FBA2   40               .byte 0x40;
FBA3   00               .byte 0x00;
FBA4   80               .byte 0x80;
FBA5   88               .byte 0x88;
FBA6   48               .byte 0x48;
FBA7   88               .byte 0x88;
FBA8   48               .byte 0x48;
FBA9   80               .byte 0x80;
FBAA   80               .byte 0x80;
FBAB   88               .byte 0x88;

FBAC   88               .byte 0x88;
FBAD   20               .byte 0x20;
FBAE   88               .byte 0x88;
FBAF   90               .byte 0x90;
FBB0   88               .byte 0x88;
FBB1   88               .byte 0x88;
FBB2   88               .byte 0x88;
FBB3   88               .byte 0x88;
FBB4   80               .byte 0x80;
FBB5   90               .byte 0x90;

FBB6   90               .byte 0x90;
FBB7   88               .byte 0x88;
FBB8   20               .byte 0x20;
FBB9   88               .byte 0x88;
FBBA   20               .byte 0x20;
FBBB   A8               .byte 0xA8;
FBBC   88               .byte 0x88;
FBBD   20               .byte 0x20;
FBBE   80               .byte 0x80;
FBBF   40               .byte 0x40;

FBC0   08               .byte 0x08;
FBC1   08               .byte 0x08;
FBC2   00               .byte 0x00;
FBC3   00               .byte 0x00;
FBC4   48               .byte 0x48;
FBC5   20               .byte 0x20;
FBC6   F0               .byte 0xF0;
FBC7   70               .byte 0x70;
FBC8   70               .byte 0x70;
FBC9   70               .byte 0x70;

FBCA   60               .byte 0x60;
FBCB   44               .byte 0x44;
FBCC   6C               .byte 0x6C;
FBCD   50               .byte 0x50;
FBCE   38               .byte 0x38;
FBCF   82               .byte 0x82;
FBD0   00               .byte 0x00;
FBD1   82               .byte 0x82;
FBD2   FF               .byte 0xFF;
FBD3   FE               .byte 0xFE;

FBD4   00               .byte 0x00;
FBD5   20               .byte 0x20;
FBD6   00               .byte 0x00;
FBD7   50               .byte 0x50;
FBD8   F8               .byte 0xF8;
FBD9   98               .byte 0x98;
FBDA   68               .byte 0x68;
FBDB   00               .byte 0x00;
FBDC   10               .byte 0x10;
FBDD   40               .byte 0x40;

FBDE   00               .byte 0x00;
FBDF   00               .byte 0x00;
FBE0   80               .byte 0x80;
FBE1   00               .byte 0x00;
FBE2   80               .byte 0x80;
FBE3   80               .byte 0x80;
FBE4   30               .byte 0x30;
FBE5   70               .byte 0x70;
FBE6   F8               .byte 0xF8;
FBE7   70               .byte 0x70;

FBE8   10               .byte 0x10;
FBE9   70               .byte 0x70;
FBEA   70               .byte 0x70;
FBEB   80               .byte 0x80;
FBEC   70               .byte 0x70;
FBED   60               .byte 0x60;
FBEE   00               .byte 0x00;
FBEF   40               .byte 0x40;
FBF0   00               .byte 0x00;
FBF1   00               .byte 0x00;

FBF2   00               .byte 0x00;
FBF3   20               .byte 0x20;
FBF4   78               .byte 0x78;
FBF5   88               .byte 0x88;
FBF6   F0               .byte 0xF0;
FBF7   70               .byte 0x70;
FBF8   F0               .byte 0xF0;
FBF9   F8               .byte 0xF8;
FBFA   80               .byte 0x80;
FBFB   78               .byte 0x78;

FBFC   88               .byte 0x88;
FBFD   70               .byte 0x70;
FBFE   70               .byte 0x70;
FBFF   88               .byte 0x88;
FC00   F8               .byte 0xF8;
FC01   88               .byte 0x88;
FC02   88               .byte 0x88;
FC03   F8               .byte 0xF8;
FC04   80               .byte 0x80;
FC05   68               .byte 0x68;

FC06   88               .byte 0x88;
FC07   70               .byte 0x70;
FC08   20               .byte 0x20;
FC09   70               .byte 0x70;
FC0A   20               .byte 0x20;
FC0B   50               .byte 0x50;
FC0C   88               .byte 0x88;
FC0D   20               .byte 0x20;
FC0E   F8               .byte 0xF8;
FC0F   70               .byte 0x70;

FC10   08               .byte 0x08;
FC11   70               .byte 0x70;
FC12   00               .byte 0x00;
FC13   F8               .byte 0xF8;
FC14   00               .byte 0x00;
FC15   20               .byte 0x20;
FC16   60               .byte 0x60;
FC17   20               .byte 0x20;
FC18   00               .byte 0x00;
FC19   00               .byte 0x00;

FC1A   00               .byte 0x00;
FC1B   38               .byte 0x38;
FC1C   82               .byte 0x82;
FC1D   88               .byte 0x88;
FC1E   00               .byte 0x00;
FC1F   00               .byte 0x00;
FC20   00               .byte 0x00;
FC21   FE               .byte 0xFE;
FC22   FF               .byte 0xFF;
FC23   FE               .byte 0xFE;


                 angle_data1:
FC24   00               .byte 0x00;
FC25   11               .byte 0x11;
FC26   41               .byte 0x41;
FC27   30               .byte 0x30;
FC28   21               .byte 0x21;
FC29   10               .byte 0x10;
FC2A   20               .byte 0x20;
FC2B   31               .byte 0x31;

                 angle_data2:
FC2C   00               .byte 0x00;
FC2D   01               .byte 0x01;
FC2E   03               .byte 0x03;
FC2F   06               .byte 0x06;
FC30   0A               .byte 0x0A;
FC31   0F               .byte 0x0F;
FC32   15               .byte 0x15;
FC33   1C               .byte 0x1C;
FC34   24               .byte 0x24;
FC35   2D               .byte 0x2D;


FC36   08               .byte 0x08;
FC37   10               .byte 0x10;
FC38   08        SFC38: .byte 0x08;
FC39   10               .byte 0x10;
FC3A   0B               .byte 0x0B;
FC3B   08               .byte 0x08;
FC3C   10               .byte 0x10;
FC3D   0D               .byte 0x0D;
FC3E   0A               .byte 0x0A;
FC3F   08               .byte 0x08;
FC40   10               .byte 0x10;
FC41   0E               .byte 0x0E;
FC42   0B               .byte 0x0B;
FC43   09               .byte 0x09;
FC44   08               .byte 0x08;
FC45   10               .byte 0x10;
FC46   0E               .byte 0x0E;
FC47   0C               .byte 0x0C;
FC48   0A               .byte 0x0A;
FC49   09               .byte 0x09;
FC4A   08               .byte 0x08;
FC4B   10               .byte 0x10;
FC4C   0E               .byte 0x0E;
FC4D   0D               .byte 0x0D;
FC4E   0B               .byte 0x0B;
FC4F   0A               .byte 0x0A;
FC50   09               .byte 0x09;
FC51   08               .byte 0x08;
FC52   10               .byte 0x10;
FC53   0F               .byte 0x0F;
FC54   0D               .byte 0x0D;
FC55   0C               .byte 0x0C;
FC56   0B               .byte 0x0B;
FC57   0A               .byte 0x0A;
FC58   09               .byte 0x09;
FC59   08               .byte 0x08;
FC5A   10               .byte 0x10;
FC5B   0F               .byte 0x0F;
FC5C   0E               .byte 0x0E;
FC5D   0C               .byte 0x0C;
FC5E   0B               .byte 0x0B;
FC5F   0A               .byte 0x0A;
FC60   09               .byte 0x09;
FC61   09               .byte 0x09;
FC62   08               .byte 0x08;
FC63   10               .byte 0x10;
FC64   0F               .byte 0x0F;
FC65   0E               .byte 0x0E;
FC66   0D               .byte 0x0D;
FC67   0C               .byte 0x0C;
FC68   0B               .byte 0x0B;
FC69   0A               .byte 0x0A;
FC6A   09               .byte 0x09;
FC6B   09               .byte 0x09;
FC6C   08               .byte 0x08;

                 rotation_pair_table:
FC6D   00               .byte 0x00;
FC6E   19               .byte 0x19;
FC6F   32               .byte 0x32;
FC70   4A               .byte 0x4A;
FC71   62               .byte 0x62;
FC72   79               .byte 0x79;
FC73   8E               .byte 0x8E;
FC74   A2               .byte 0xA2;
FC75   B5               .byte 0xB5;
FC76   C6               .byte 0xC6;
FC77   D5               .byte 0xD5;
FC78   E2               .byte 0xE2;
FC79   ED               .byte 0xED;
FC7A   F5               .byte 0xF5;
FC7B   FB               .byte 0xFB;
FC7C   FF               .byte 0xFF;
FC7D   FF               .byte 0xFF;
FC7E   FF               .byte 0xFF;
FC7F   FB               .byte 0xFB;
FC80   F5               .byte 0xF5;
FC81   ED               .byte 0xED;
FC82   E2               .byte 0xE2;
FC83   D5               .byte 0xD5;
FC84   C6               .byte 0xC6;
FC85   B5               .byte 0xB5;
FC86   A2               .byte 0xA2;
FC87   8E               .byte 0x8E;
FC88   79               .byte 0x79;
FC89   62               .byte 0x62;
FC8A   4A               .byte 0x4A;
FC8B   32               .byte 0x32;
FC8C   19               .byte 0x19;

                 music_routine_data:
FC8D   03               .byte 0x03;
FC8E   BD               .byte 0xBD;
FC8F   03               .byte 0x03;
FC90   87               .byte 0x87;
FC91   03               .byte 0x03;
FC92   54               .byte 0x54;
FC93   03               .byte 0x03;
FC94   24               .byte 0x24;
FC95   02               .byte 0x02;
FC96   F7               .byte 0xF7;
FC97   02               .byte 0x02;
FC98   CD               .byte 0xCD;
FC99   02               .byte 0x02;
FC9A   A4               .byte 0xA4;
FC9B   02               .byte 0x02;
FC9C   7E               .byte 0x7E;
FC9D   02               .byte 0x02;
FC9E   5B               .byte 0x5B;
FC9F   02               .byte 0x02;
FCA0   39               .byte 0x39;
FCA1   02               .byte 0x02;
FCA2   19               .byte 0x19;
FCA3   01               .byte 0x01;
FCA4   FB               .byte 0xFB;
FCA5   01               .byte 0x01;
FCA6   DE               .byte 0xDE;
FCA7   01               .byte 0x01;
FCA8   C3               .byte 0xC3;
FCA9   01               .byte 0x01;
FCAA   AA               .byte 0xAA;
FCAB   01               .byte 0x01;
FCAC   92               .byte 0x92;
FCAD   01               .byte 0x01;
FCAE   7C               .byte 0x7C;
FCAF   01               .byte 0x01;
FCB0   66               .byte 0x66;
FCB1   01               .byte 0x01;
FCB2   52               .byte 0x52;
FCB3   01               .byte 0x01;
FCB4   3F               .byte 0x3F;
FCB5   01               .byte 0x01;
FCB6   2D               .byte 0x2D;
FCB7   01               .byte 0x01;
FCB8   1C               .byte 0x1C;
FCB9   01               .byte 0x01;
FCBA   0C               .byte 0x0C;
FCBB   00               .byte 0x00;
FCBC   FD               .byte 0xFD;
FCBD   00               .byte 0x00;
FCBE   EF               .byte 0xEF;
FCBF   00               .byte 0x00;
FCC0   E2               .byte 0xE2;
FCC1   00               .byte 0x00;
FCC2   D5               .byte 0xD5;
FCC3   00               .byte 0x00;
FCC4   C9               .byte 0xC9;
FCC5   00               .byte 0x00;
FCC6   BE               .byte 0xBE;
FCC7   00               .byte 0x00;
FCC8   B3               .byte 0xB3;
FCC9   00               .byte 0x00;
FCCA   A9               .byte 0xA9;
FCCB   00               .byte 0x00;
FCCC   A0               .byte 0xA0;
FCCD   00               .byte 0x00;
FCCE   97               .byte 0x97;
FCCF   00               .byte 0x00;
FCD0   8E               .byte 0x8E;
FCD1   00               .byte 0x00;
FCD2   86               .byte 0x86;
FCD3   00               .byte 0x00;
FCD4   7F               .byte 0x7F;
FCD5   00               .byte 0x00;
FCD6   78               .byte 0x78;
FCD7   00               .byte 0x00;
FCD8   71               .byte 0x71;
FCD9   00               .byte 0x00;
FCDA   6B               .byte 0x6B;
FCDB   00               .byte 0x00;
FCDC   65               .byte 0x65;
FCDD   00               .byte 0x00;
FCDE   5F               .byte 0x5F;
FCDF   00               .byte 0x00;
FCE0   5A               .byte 0x5A;
FCE1   00               .byte 0x00;
FCE2   55               .byte 0x55;
FCE3   00               .byte 0x00;
FCE4   50               .byte 0x50;
FCE5   00               .byte 0x00;
FCE6   4B               .byte 0x4B;
FCE7   00               .byte 0x00;
FCE8   47               .byte 0x47;
FCE9   00               .byte 0x00;
FCEA   43               .byte 0x43;
FCEB   00               .byte 0x00;
FCEC   3F               .byte 0x3F;
FCED   00               .byte 0x00;
FCEE   3C               .byte 0x3C;
FCEF   00               .byte 0x00;
FCF0   38               .byte 0x38;
FCF1   00               .byte 0x00;
FCF2   35               .byte 0x35;
FCF3   00               .byte 0x00;
FCF4   32               .byte 0x32;
FCF5   00               .byte 0x00;
FCF6   2F               .byte 0x2F;
FCF7   00               .byte 0x00;
FCF8   2D               .byte 0x2D;
FCF9   00               .byte 0x00;
FCFA   2A               .byte 0x2A;
FCFB   00               .byte 0x00;
FCFC   28               .byte 0x28;
FCFD   00               .byte 0x00;
FCFE   26               .byte 0x26;
FCFF   00               .byte 0x00;
FD00   24               .byte 0x24;
FD01   00               .byte 0x00;
FD02   22               .byte 0x22;
FD03   00               .byte 0x00;
FD04   20               .byte 0x20;
FD05   00               .byte 0x00;
FD06   1E               .byte 0x1E;
FD07   00               .byte 0x00;
FD08   1C               .byte 0x1C;
FD09   00               .byte 0x00;
FD0A   1B               .byte 0x1B;
FD0B   00               .byte 0x00;
FD0C   00               .byte 0x00;

                 intro_music_block:
FD0D   FEE8             .word music_header1b;
FD0F   FEB6             .word music_header2a;
FD11   93               .byte 0x93;
FD12   1F               .byte 0x1F;
FD13   0C               .byte 0x0C;
FD14   93               .byte 0x93;
FD15   1F               .byte 0x1F;
FD16   06               .byte 0x06;
FD17   98               .byte 0x98;
FD18   9F               .byte 0x9F;
FD19   24               .byte 0x24;
FD1A   3C               .byte 0x3C;
FD1B   11               .byte 0x11;
FD1C   80               .byte 0x80;

                berzerk_music_block:
FD1D   FD69             .word music_header1a;
FD1F   FD79             .word music_header2b;
FD21   21               .byte 0x21;
FD22   07               .byte 0x07;
FD23   21               .byte 0x21;
FD24   07               .byte 0x07;
FD25   21               .byte 0x21;
FD26   07               .byte 0x07;
FD27   21               .byte 0x21;
FD28   07               .byte 0x07;
FD29   21               .byte 0x21;
FD2A   07               .byte 0x07;
FD2B   21               .byte 0x21;
FD2C   07               .byte 0x07;
FD2D   21               .byte 0x21;
FD2E   0E               .byte 0x0E;
FD2F   99               .byte 0x99;
FD30   9F               .byte 0x9F;
FD31   24               .byte 0x24;
FD32   0E               .byte 0x0E;
FD33   95               .byte 0x95;
FD34   9B               .byte 0x9B;
FD35   20               .byte 0x20;
FD36   0E               .byte 0x0E;
FD37   21               .byte 0x21;
FD38   07               .byte 0x07;
FD39   21               .byte 0x21;
FD3A   07               .byte 0x07;
FD3B   21               .byte 0x21;
FD3C   07               .byte 0x07;
FD3D   21               .byte 0x21;
FD3E   07               .byte 0x07;
FD3F   21               .byte 0x21;
FD40   07               .byte 0x07;
FD41   21               .byte 0x21;
FD42   07               .byte 0x07;
FD43   9D               .byte 0x9D;
FD44   A3               .byte 0xA3;
FD45   28               .byte 0x28;
FD46   0E               .byte 0x0E;
FD47   A0               .byte 0xA0;
FD48   A6               .byte 0xA6;
FD49   2B               .byte 0x2B;
FD4A   0E               .byte 0x0E;
FD4B   22               .byte 0x22;
FD4C   02               .byte 0x02;
FD4D   28               .byte 0x28;
FD4E   02               .byte 0x02;
FD4F   2D               .byte 0x2D;
FD50   02               .byte 0x02;
FD51   28               .byte 0x28;
FD52   02               .byte 0x02;
FD53   22               .byte 0x22;
FD54   02               .byte 0x02;
FD55   28               .byte 0x28;
FD56   02               .byte 0x02;
FD57   2D               .byte 0x2D;
FD58   02               .byte 0x02;
FD59   28               .byte 0x28;
FD5A   02               .byte 0x02;
FD5B   22               .byte 0x22;
FD5C   02               .byte 0x02;
FD5D   28               .byte 0x28;
FD5E   02               .byte 0x02;
FD5F   2D               .byte 0x2D;
FD60   02               .byte 0x02;
FD61   28               .byte 0x28;
FD62   02               .byte 0x02;
FD63   2E               .byte 0x2E;
FD64   02               .byte 0x02;
FD65   2D               .byte 0x2D;
FD66   28               .byte 0x28;
FD67   21               .byte 0x21;
FD68   80               .byte 0x80;

                 music_header1a:
FD69   EF               .byte 0xEF;
FD6A   FF               .byte 0xFF;
FD6B   FE               .byte 0xFE;
FD6C   DC               .byte 0xDC;
FD6D   BA               .byte 0xBA;
FD6E   00               .byte 0x00;
FD6F   00               .byte 0x00;
FD70   00               .byte 0x00;
FD71   00               .byte 0x00;
FD72   00               .byte 0x00;
FD73   00               .byte 0x00;
FD74   00               .byte 0x00;
FD75   00               .byte 0x00;
FD76   00               .byte 0x00;
FD77   00               .byte 0x00;
FD78   00               .byte 0x00;

                 music_header2b:
FD79   00               .byte 0x00;
FD7A   01               .byte 0x01;
FD7B   02               .byte 0x02;
FD7C   01               .byte 0x01;
FD7D   00               .byte 0x00;
FD7E   FF               .byte 0xFF;
FD7F   FE               .byte 0xFE;
FD80   FF               .byte 0xFF;
FD81   FD               .byte 0xFD;
FD82   C3               .byte 0xC3;
FD83   FE               .byte 0xFE;
FD84   B6               .byte 0xB6;
FD85   51               .byte 0x51;
FD86   24               .byte 0x24;
FD87   50               .byte 0x50;
FD88   06               .byte 0x06;
FD89   50               .byte 0x50;
FD8A   06               .byte 0x06;
FD8B   50               .byte 0x50;
FD8C   0C               .byte 0x0C;
FD8D   50               .byte 0x50;
FD8E   06               .byte 0x06;
FD8F   50               .byte 0x50;
FD90   06               .byte 0x06;
FD91   50               .byte 0x50;
FD92   04               .byte 0x04;
FD93   50               .byte 0x50;
FD94   04               .byte 0x04;
FD95   50               .byte 0x50;
FD96   04               .byte 0x04;
FD97   50               .byte 0x50;
FD98   18               .byte 0x18;
FD99   50               .byte 0x50;
FD9A   04               .byte 0x04;
FD9B   50               .byte 0x50;
FD9C   04               .byte 0x04;
FD9D   50               .byte 0x50;
FD9E   04               .byte 0x04;
FD9F   50               .byte 0x50;
FDA0   0C               .byte 0x0C;
FDA1   50               .byte 0x50;
FDA2   0C               .byte 0x0C;
FDA3   50               .byte 0x50;
FDA4   24               .byte 0x24;
FDA5   50               .byte 0x50;
FDA6   06               .byte 0x06;
FDA7   50               .byte 0x50;
FDA8   06               .byte 0x06;
FDA9   50               .byte 0x50;
FDAA   0C               .byte 0x0C;
FDAB   50               .byte 0x50;
FDAC   06               .byte 0x06;
FDAD   50               .byte 0x50;
FDAE   06               .byte 0x06;
FDAF   50               .byte 0x50;
FDB0   04               .byte 0x04;
FDB1   50               .byte 0x50;
FDB2   04               .byte 0x04;
FDB3   50               .byte 0x50;
FDB4   04               .byte 0x04;
FDB5   50               .byte 0x50;
FDB6   18               .byte 0x18;
FDB7   50               .byte 0x50;
FDB8   04               .byte 0x04;
FDB9   50               .byte 0x50;
FDBA   04               .byte 0x04;
FDBB   50               .byte 0x50;
FDBC   04               .byte 0x04;
FDBD   50               .byte 0x50;
FDBE   0C               .byte 0x0C;
FDBF   50               .byte 0x50;
FDC0   18               .byte 0x18;
FDC1   26               .byte 0x26;
FDC2   80               .byte 0x80;
FDC3   FD               .byte 0xFD;
FDC4   BA               .byte 0xBA;
FDC5   98               .byte 0x98;
FDC6   76               .byte 0x76;
FDC7   55               .byte 0x55;
FDC8   44               .byte 0x44;
FDC9   33               .byte 0x33;
FDCA   22               .byte 0x22;
FDCB   11               .byte 0x11;
FDCC   00               .byte 0x00;
FDCD   00               .byte 0x00;
FDCE   00               .byte 0x00;
FDCF   00               .byte 0x00;
FDD0   00               .byte 0x00;
FDD1   00               .byte 0x00;
FDD2   00               .byte 0x00;
FDD3   FE               .byte 0xFE;
FDD4   28               .byte 0x28;
FDD5   FD               .byte 0xFD;
FDD6   79               .byte 0x79;
FDD7   98               .byte 0x98;
FDD8   1C               .byte 0x1C;
FDD9   10               .byte 0x10;
FDDA   3F               .byte 0x3F;
FDDB   08               .byte 0x08;
FDDC   98               .byte 0x98;
FDDD   1C               .byte 0x1C;
FDDE   04               .byte 0x04;
FDDF   98               .byte 0x98;
FDE0   1C               .byte 0x1C;
FDE1   04               .byte 0x04;
FDE2   98               .byte 0x98;
FDE3   1C               .byte 0x1C;
FDE4   10               .byte 0x10;
FDE5   3F               .byte 0x3F;
FDE6   08               .byte 0x08;
FDE7   98               .byte 0x98;
FDE8   1C               .byte 0x1C;
FDE9   04               .byte 0x04;
FDEA   98               .byte 0x98;
FDEB   1C               .byte 0x1C;
FDEC   04               .byte 0x04;
FDED   98               .byte 0x98;
FDEE   1C               .byte 0x1C;
FDEF   08               .byte 0x08;
FDF0   93               .byte 0x93;
FDF1   18               .byte 0x18;
FDF2   08               .byte 0x08;
FDF3   98               .byte 0x98;
FDF4   1C               .byte 0x1C;
FDF5   08               .byte 0x08;
FDF6   9C               .byte 0x9C;
FDF7   1F               .byte 0x1F;
FDF8   08               .byte 0x08;
FDF9   98               .byte 0x98;
FDFA   1C               .byte 0x1C;
FDFB   08               .byte 0x08;
FDFC   93               .byte 0x93;
FDFD   18               .byte 0x18;
FDFE   08               .byte 0x08;
FDFF   98               .byte 0x98;
FE00   1C               .byte 0x1C;
FE01   08               .byte 0x08;
FE02   93               .byte 0x93;
FE03   18               .byte 0x18;
FE04   08               .byte 0x08;
FE05   98               .byte 0x98;
FE06   1C               .byte 0x1C;
FE07   08               .byte 0x08;
FE08   9C               .byte 0x9C;
FE09   1F               .byte 0x1F;
FE0A   08               .byte 0x08;
FE0B   98               .byte 0x98;
FE0C   1C               .byte 0x1C;
FE0D   08               .byte 0x08;
FE0E   93               .byte 0x93;
FE0F   18               .byte 0x18;
FE10   08               .byte 0x08;
FE11   98               .byte 0x98;
FE12   1C               .byte 0x1C;
FE13   08               .byte 0x08;
FE14   93               .byte 0x93;
FE15   18               .byte 0x18;
FE16   08               .byte 0x08;
FE17   98               .byte 0x98;
FE18   1C               .byte 0x1C;
FE19   08               .byte 0x08;
FE1A   9C               .byte 0x9C;
FE1B   1F               .byte 0x1F;
FE1C   08               .byte 0x08;
FE1D   98               .byte 0x98;
FE1E   1C               .byte 0x1C;
FE1F   08               .byte 0x08;
FE20   93               .byte 0x93;
FE21   18               .byte 0x18;
FE22   08               .byte 0x08;
FE23   9C               .byte 0x9C;
FE24   1F               .byte 0x1F;
FE25   30               .byte 0x30;
FE26   1A               .byte 0x1A;
FE27   80               .byte 0x80;
FE28   FF               .byte 0xFF;
FE29   FE               .byte 0xFE;
FE2A   DC               .byte 0xDC;
FE2B   BA               .byte 0xBA;
FE2C   98               .byte 0x98;
FE2D   76               .byte 0x76;
FE2E   54               .byte 0x54;
FE2F   32               .byte 0x32;
FE30   10               .byte 0x10;
FE31   00               .byte 0x00;
FE32   00               .byte 0x00;
FE33   00               .byte 0x00;
FE34   00               .byte 0x00;
FE35   00               .byte 0x00;
FE36   00               .byte 0x00;
FE37   00               .byte 0x00;
FE38   FE               .byte 0xFE;
FE39   66               .byte 0x66;
FE3A   FE               .byte 0xFE;
FE3B   B6               .byte 0xB6;
FE3C   0C               .byte 0x0C;
FE3D   18               .byte 0x18;
FE3E   11               .byte 0x11;
FE3F   18               .byte 0x18;
FE40   0C               .byte 0x0C;
FE41   18               .byte 0x18;
FE42   11               .byte 0x11;
FE43   18               .byte 0x18;
FE44   0C               .byte 0x0C;
FE45   18               .byte 0x18;
FE46   11               .byte 0x11;
FE47   18               .byte 0x18;
FE48   0C               .byte 0x0C;
FE49   12               .byte 0x12;
FE4A   0C               .byte 0x0C;
FE4B   06               .byte 0x06;
FE4C   11               .byte 0x11;
FE4D   18               .byte 0x18;
FE4E   9D               .byte 0x9D;
FE4F   21               .byte 0x21;
FE50   18               .byte 0x18;
FE51   9F               .byte 0x9F;
FE52   23               .byte 0x23;
FE53   18               .byte 0x18;
FE54   A1               .byte 0xA1;
FE55   24               .byte 0x24;
FE56   18               .byte 0x18;
FE57   A3               .byte 0xA3;
FE58   26               .byte 0x26;
FE59   18               .byte 0x18;
FE5A   9F               .byte 0x9F;
FE5B   A4               .byte 0xA4;
FE5C   28               .byte 0x28;
FE5D   18               .byte 0x18;
FE5E   07               .byte 0x07;
FE5F   12               .byte 0x12;
FE60   07               .byte 0x07;
FE61   06               .byte 0x06;
FE62   00               .byte 0x00;
FE63   3C               .byte 0x3C;
FE64   18               .byte 0x18;
FE65   80               .byte 0x80;
FE66   DE               .byte 0xDE;
FE67   EF               .byte 0xEF;
FE68   FE               .byte 0xFE;
FE69   DC               .byte 0xDC;
FE6A   BA               .byte 0xBA;
FE6B   00               .byte 0x00;
FE6C   00               .byte 0x00;
FE6D   00               .byte 0x00;
FE6E   00               .byte 0x00;
FE6F   00               .byte 0x00;
FE70   00               .byte 0x00;
FE71   00               .byte 0x00;
FE72   00               .byte 0x00;
FE73   00               .byte 0x00;
FE74   00               .byte 0x00;
FE75   00               .byte 0x00;
FE76   FE               .byte 0xFE;
FE77   B2               .byte 0xB2;
FE78   FE               .byte 0xFE;
FE79   B6               .byte 0xB6;
FE7A   18               .byte 0x18;
FE7B   06               .byte 0x06;
FE7C   1A               .byte 0x1A;
FE7D   06               .byte 0x06;
FE7E   1C               .byte 0x1C;
FE7F   0C               .byte 0x0C;
FE80   18               .byte 0x18;
FE81   0C               .byte 0x0C;
FE82   1A               .byte 0x1A;
FE83   24               .byte 0x24;
FE84   23               .byte 0x23;
FE85   18               .byte 0x18;
FE86   17               .byte 0x17;
FE87   06               .byte 0x06;
FE88   18               .byte 0x18;
FE89   06               .byte 0x06;
FE8A   1A               .byte 0x1A;
FE8B   0C               .byte 0x0C;
FE8C   17               .byte 0x17;
FE8D   0C               .byte 0x0C;
FE8E   18               .byte 0x18;
FE8F   24               .byte 0x24;
FE90   24               .byte 0x24;
FE91   18               .byte 0x18;
FE92   A4               .byte 0xA4;
FE93   28               .byte 0x28;
FE94   0C               .byte 0x0C;
FE95   A3               .byte 0xA3;
FE96   26               .byte 0x26;
FE97   0C               .byte 0x0C;
FE98   A1               .byte 0xA1;
FE99   24               .byte 0x24;
FE9A   0C               .byte 0x0C;
FE9B   9F               .byte 0x9F;
FE9C   23               .byte 0x23;
FE9D   0C               .byte 0x0C;
FE9E   9D               .byte 0x9D;
FE9F   21               .byte 0x21;
FEA0   18               .byte 0x18;
FEA1   9A               .byte 0x9A;
FEA2   1F               .byte 0x1F;
FEA3   18               .byte 0x18;
FEA4   17               .byte 0x17;
FEA5   06               .byte 0x06;
FEA6   18               .byte 0x18;
FEA7   06               .byte 0x06;
FEA8   1A               .byte 0x1A;
FEA9   0C               .byte 0x0C;
FEAA   17               .byte 0x17;
FEAB   0C               .byte 0x0C;
FEAC   18               .byte 0x18;
FEAD   24               .byte 0x24;
FEAE   24               .byte 0x24;
FEAF   24               .byte 0x24;
FEB0   18               .byte 0x18;
FEB1   80               .byte 0x80;
FEB2   FF               .byte 0xFF;
FEB3   EE               .byte 0xEE;
FEB4   DD               .byte 0xDD;
FEB5   CC               .byte 0xCC;

                 music_header2a:
FEB6   00               .byte 0x00;
FEB7   00               .byte 0x00;
FEB8   00               .byte 0x00;
FEB9   00               .byte 0x00;
FEBA   00               .byte 0x00;
FEBB   00               .byte 0x00;
FEBC   00               .byte 0x00;
FEBD   00               .byte 0x00;
FEBE   00               .byte 0x00;
FEBF   00               .byte 0x00;
FEC0   00               .byte 0x00;
FEC1   00               .byte 0x00;
FEC2   00               .byte 0x00;
FEC3   00               .byte 0x00;
FEC4   00               .byte 0x00;
FEC5   00               .byte 0x00;
FEC6   FE               .byte 0xFE;
FEC7   E8               .byte 0xE8;
FEC8   FE               .byte 0xFE;
FEC9   B6               .byte 0xB6;
FECA   96               .byte 0x96;
FECB   9A               .byte 0x9A;
FECC   1D               .byte 0x1D;
FECD   1E               .byte 0x1E;
FECE   91               .byte 0x91;
FECF   95               .byte 0x95;
FED0   18               .byte 0x18;
FED1   1E               .byte 0x1E;
FED2   94               .byte 0x94;
FED3   98               .byte 0x98;
FED4   1B               .byte 0x1B;
FED5   1E               .byte 0x1E;
FED6   8F               .byte 0x8F;
FED7   94               .byte 0x94;
FED8   18               .byte 0x18;
FED9   14               .byte 0x14;
FEDA   16               .byte 0x16;
FEDB   0A               .byte 0x0A;
FEDC   8C               .byte 0x8C;
FEDD   91               .byte 0x91;
FEDE   15               .byte 0x15;
FEDF   14               .byte 0x14;
FEE0   16               .byte 0x16;
FEE1   0A               .byte 0x0A;
FEE2   91               .byte 0x91;
FEE3   95               .byte 0x95;
FEE4   18               .byte 0x18;
FEE5   32               .byte 0x32;
FEE6   18               .byte 0x18;
FEE7   80               .byte 0x80;

                 music_header1b:
FEE8   EE               .byte 0xEE;
FEE9   FF               .byte 0xFF;
FEEA   FF               .byte 0xFF;
FEEB   EE               .byte 0xEE;
FEEC   EE               .byte 0xEE;
FEED   DD               .byte 0xDD;
FEEE   CC               .byte 0xCC;
FEEF   BB               .byte 0xBB;
FEF0   AA               .byte 0xAA;
FEF1   99               .byte 0x99;
FEF2   88               .byte 0x88;
FEF3   88               .byte 0x88;
FEF4   88               .byte 0x88;
FEF5   88               .byte 0x88;
FEF6   88               .byte 0x88;
FEF7   88               .byte 0x88;
FEF8   FF               .byte 0xFF;
FEF9   16               .byte 0x16;
FEFA   FE               .byte 0xFE;
FEFB   B6               .byte 0xB6;
FEFC   1C               .byte 0x1C;
FEFD   06               .byte 0x06;
FEFE   1F               .byte 0x1F;
FEFF   06               .byte 0x06;
FF00   1C               .byte 0x1C;
FF01   06               .byte 0x06;
FF02   18               .byte 0x18;
FF03   06               .byte 0x06;
FF04   1A               .byte 0x1A;
FF05   06               .byte 0x06;
FF06   18               .byte 0x18;
FF07   06               .byte 0x06;
FF08   15               .byte 0x15;
FF09   06               .byte 0x06;
FF0A   13               .byte 0x13;
FF0B   06               .byte 0x06;
FF0C   18               .byte 0x18;
FF0D   06               .byte 0x06;
FF0E   13               .byte 0x13;
FF0F   06               .byte 0x06;
FF10   17               .byte 0x17;
FF11   06               .byte 0x06;
FF12   18               .byte 0x18;
FF13   1E               .byte 0x1E;
FF14   18               .byte 0x18;
FF15   80               .byte 0x80;
FF16   FF               .byte 0xFF;
FF17   FF               .byte 0xFF;
FF18   EE               .byte 0xEE;
FF19   EE               .byte 0xEE;
FF1A   DD               .byte 0xDD;
FF1B   DD               .byte 0xDD;
FF1C   CC               .byte 0xCC;
FF1D   CC               .byte 0xCC;
FF1E   00               .byte 0x00;
FF1F   00               .byte 0x00;
FF20   00               .byte 0x00;
FF21   00               .byte 0x00;
FF22   00               .byte 0x00;
FF23   00               .byte 0x00;
FF24   00               .byte 0x00;
FF25   00               .byte 0x00;
FF26   FE               .byte 0xFE;
FF27   28               .byte 0x28;
FF28   FE               .byte 0xFE;
FF29   B6               .byte 0xB6;
FF2A   16               .byte 0x16;
FF2B   0F               .byte 0x0F;
FF2C   16               .byte 0x16;
FF2D   05               .byte 0x05;
FF2E   16               .byte 0x16;
FF2F   05               .byte 0x05;
FF30   16               .byte 0x16;
FF31   05               .byte 0x05;
FF32   1A               .byte 0x1A;
FF33   0F               .byte 0x0F;
FF34   16               .byte 0x16;
FF35   0F               .byte 0x0F;
FF36   1D               .byte 0x1D;
FF37   0F               .byte 0x0F;
FF38   1D               .byte 0x1D;
FF39   05               .byte 0x05;
FF3A   1D               .byte 0x1D;
FF3B   05               .byte 0x05;
FF3C   1D               .byte 0x1D;
FF3D   05               .byte 0x05;
FF3E   21               .byte 0x21;
FF3F   0F               .byte 0x0F;
FF40   1D               .byte 0x1D;
FF41   32               .byte 0x32;
FF42   1D               .byte 0x1D;
FF43   80               .byte 0x80;
FF44   FE               .byte 0xFE;
FF45   28               .byte 0x28;
FF46   FE               .byte 0xFE;
FF47   B6               .byte 0xB6;
FF48   16               .byte 0x16;
FF49   06               .byte 0x06;
FF4A   16               .byte 0x16;
FF4B   02               .byte 0x02;
FF4C   16               .byte 0x16;
FF4D   02               .byte 0x02;
FF4E   16               .byte 0x16;
FF4F   02               .byte 0x02;
FF50   1A               .byte 0x1A;
FF51   06               .byte 0x06;
FF52   16               .byte 0x16;
FF53   06               .byte 0x06;
FF54   1D               .byte 0x1D;
FF55   06               .byte 0x06;
FF56   1D               .byte 0x1D;
FF57   02               .byte 0x02;
FF58   1D               .byte 0x1D;
FF59   02               .byte 0x02;
FF5A   1D               .byte 0x1D;
FF5B   02               .byte 0x02;
FF5C   21               .byte 0x21;
FF5D   06               .byte 0x06;
FF5E   1D               .byte 0x1D;
FF5F   32               .byte 0x32;
FF60   11               .byte 0x11;
FF61   80               .byte 0x80;
FF62   FE               .byte 0xFE;
FF63   28               .byte 0x28;
FF64   FE               .byte 0xFE;
FF65   B6               .byte 0xB6;
FF66   1B               .byte 0x1B;
FF67   0F               .byte 0x0F;
FF68   16               .byte 0x16;
FF69   05               .byte 0x05;
FF6A   16               .byte 0x16;
FF6B   05               .byte 0x05;
FF6C   16               .byte 0x16;
FF6D   05               .byte 0x05;
FF6E   17               .byte 0x17;
FF6F   30               .byte 0x30;
FF70   16               .byte 0x16;
FF71   05               .byte 0x05;
FF72   16               .byte 0x16;
FF73   05               .byte 0x05;
FF74   16               .byte 0x16;
FF75   05               .byte 0x05;
FF76   17               .byte 0x17;
FF77   30               .byte 0x30;
FF78   16               .byte 0x16;
FF79   80               .byte 0x80;
FF7A   FD               .byte 0xFD;
FF7B   69               .byte 0x69;
FF7C   FE               .byte 0xFE;
FF7D   B6               .byte 0xB6;
FF7E   A0               .byte 0xA0;
FF7F   23               .byte 0x23;
FF80   12               .byte 0x12;
FF81   A0               .byte 0xA0;
FF82   23               .byte 0x23;
FF83   0C               .byte 0x0C;
FF84   9C               .byte 0x9C;
FF85   20               .byte 0x20;
FF86   06               .byte 0x06;
FF87   9E               .byte 0x9E;
FF88   21               .byte 0x21;
FF89   12               .byte 0x12;
FF8A   9C               .byte 0x9C;
FF8B   20               .byte 0x20;
FF8C   32               .byte 0x32;
FF8D   13               .byte 0x13;
FF8E   80               .byte 0x80;
FF8F   FD               .byte 0xFD;
FF90   C3               .byte 0xC3;
FF91   FE               .byte 0xFE;
FF92   B6               .byte 0xB6;
FF93   16               .byte 0x16;
FF94   04               .byte 0x04;
FF95   16               .byte 0x16;
FF96   04               .byte 0x04;
FF97   16               .byte 0x16;
FF98   04               .byte 0x04;
FF99   16               .byte 0x16;
FF9A   04               .byte 0x04;
FF9B   1A               .byte 0x1A;
FF9C   08               .byte 0x08;
FF9D   1C               .byte 0x1C;
FF9E   80               .byte 0x80;
FF9F   A6               .byte 0xA6;
FFA0   A0               .byte 0xA0;
FFA1   20               .byte 0x20;
FFA2   08               .byte 0x08;
FFA3   BD               .byte 0xBD;
FFA4   F3               .byte 0xF3;
FFA5   BE               .byte 0xBE;
FFA6   B6               .byte 0xB6;
FFA7   C8               .byte 0xC8;
FFA8   80               .byte 0x80;
FFA9   84               .byte 0x84;
FFAA   7F               .byte 0x7F;
FFAB   B7               .byte 0xB7;
FFAC   C8               .byte 0xC8;
FFAD   80               .byte 0x80;
FFAE   7A               .byte 0x7A;
FFAF   C8               .byte 0xC8;
FFB0   80               .byte 0x80;
FFB1   A6               .byte 0xA6;
FFB2   A4               .byte 0xA4;
FFB3   47               .byte 0x47;
FFB4   84               .byte 0x84;
FFB5   F8               .byte 0xF8;
FFB6   E6               .byte 0xE6;
FFB7   A0               .byte 0xA0;
FFB8   58               .byte 0x58;
FFB9   58               .byte 0x58;
FFBA   58               .byte 0x58;
FFBB   58               .byte 0x58;
FFBC   57               .byte 0x57;
FFBD   C4               .byte 0xC4;
FFBE   F8               .byte 0xF8;
FFBF   7D               .byte 0x7D;
FFC0   C8               .byte 0xC8;
FFC1   80               .byte 0x80;
FFC2   2B               .byte 0x2B;
FFC3   DF               .byte 0xDF;
FFC4   BD               .byte 0xBD;
FFC5   F3               .byte 0xF3;
FFC6   DF               .byte 0xDF;
FFC7   B6               .byte 0xB6;
FFC8   C8               .byte 0xC8;
FFC9   80               .byte 0x80;
FFCA   85               .byte 0x85;
FFCB   0F               .byte 0x0F;
FFCC   26               .byte 0x26;
FFCD   E0               .byte 0xE0;
FFCE   85               .byte 0x85;
FFCF   20               .byte 0x20;
FFD0   27               .byte 0x27;
FFD1   CD               .byte 0xCD;
FFD2   39               .byte 0x39; /* "9" */
FFD3   4B               .byte 0x4B; /* "K" */
FFD4   41               .byte 0x41; /* "A" */
FFD5   52               .byte 0x52; /* "R" */
FFD6   52               .byte 0x52; /* "R" */
FFD7   53               .byte 0x53; /* "S" */
FFD8   4F               .byte 0x4F; /* "O" */
FFD9   46               .byte 0x46; /* "F" */
FFDA   54               .byte 0x54; /* "T" */
FFDB   38               .byte 0x38; /* "8" */
FFDC   32               .byte 0x32; /* "2" */
FFDD   4C               .byte 0x4C; /* "L" */
FFDE   44               .byte 0x44; /* "D" */
FFDF   4D               .byte 0x4D; /* "M" */
FFE0   43               .byte 0x43; /* "C" */
FFE1   42               .byte 0x42; /* "B" */
FFE2   43               .byte 0x43; /* "C" */
FFE3   4A               .byte 0x4A; /* "J" */
FFE4   54               .byte 0x54; /* "T" */
FFE5   38               .byte 0x38; /* "8" */
FFE6   32               .byte 0x32; /* "2" */
FFE7   4C               .byte 0x4C; /* "L" */
FFE8   44               .byte 0x44; /* "D" */
FFE9   4D               .byte 0x4D; /* "M" */
FFEA   43               .byte 0x43; /* "C" */
FFEB   42               .byte 0x42; /* "B" */
FFEC   43               .byte 0x43; /* "C" */
FFED   4A               .byte 0x4A; /* "J" */

                 /* 6809 interrupt and startup vectors */
FFEE   0000             .word 0x0000;
FFF0   0000             .word 0x0000;
FFF2   CBF2             .word 0xCBF2;   /* SW3 */
FFF4   CBF2             .word 0xCBF2;   /* SW2 */
FFF6   CBF5             .word 0xCBF5;   /* FIRQ */
FFF8   CBF8             .word 0xCBF8;   /* IRQ */
FFFA   CBFB             .word 0xCBFB;   /* SW1 */
FFFC   CBFB             .word 0xCBFB;   /* NMI */
FFFE   F000             .word start_of_OS_ROM;  /* RESET */

