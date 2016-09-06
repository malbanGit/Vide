                                ORG     $F000

                *-----------------------------------------------------------------------*
                * This disassembly of the Vectrex ROM was done by Bruce Tomlin          *
                * (btomlin@aol.com), and is based in part on a disassembly done by      *
                * Fred Taft (fred@hp-pcd.cv.hp.com).                                    *
                *-----------------------------------------------------------------------*

                                INCLUDE VECTREX.INC

                *-----------------------------------------------------------------------*
                *       F000    Start                                                   *
                *                                                                       *
                * Jump here to restart the Vectrex and re-initialize the OS.  If the    *
                * cold start flag is correct (it should be unless you just turned the   *
                * Vectrex on), the cold start code is skipped.                          *
                *                                                                       *
                * On cold start, the high score is cleared, and the power-on screen     *
                * is displayed with the power-on music.                                 *
                *-----------------------------------------------------------------------*

F000=10CECBEA   Start:          LDS     #Vec_Default_Stk Set up stack pointer
F004 BDF18B                     JSR     Init_OS         Initialize system
F007 CC7321                     LDD     #$7321          Check cold start flag
F00A 10B3CBFE                   CMPD    Vec_Cold_Flag
F00E 275C                       BEQ     Warm_Start      Branch if warm start
F010 FDCBFE                     STD     Vec_Cold_Flag   Initialize cold start flag
F013 7CC83B                     INC     $C83B           Set high score invalid flag
F016 8ECBEB                     LDX     #Vec_High_Score Clear high score
F019 BDF84F                     JSR     Clear_Score

                *       First power-up loop.  This prints the "VECTREX"
                *       power-on screen and plays the power-on music.

F01C=BDF1AF     LF01C           JSR     DP_to_C8        DP to RAM
F01F DC25                       LDD     <Vec_Loop_Count When we have looped 257 times,
F021 10830101                   CMPD    #$0101
F025 2602                       BNE     LF029
F027 D756                       STB     <Vec_Music_Flag   start the intro music

                *       Get the line pattern for the boundary box lines

F029=57         LF029           ASRB                    Get line pattern from table
F02A C403                       ANDB    #$03
F02C 8EF0FD                     LDX     #DF0FD
F02F E685                       LDB     B,X
F031 D729                       STB     <Vec_Pattern    Store pattern

F033 C602                       LDB     #$02            Set up counter for two boxes
F035 D724                       STB     <$C824

                *       Play the intro music

F037 CEFD0D                     LDU     #Intro_Music    Get address of music
F03A BDF687                     JSR     Init_Music_chk  Initialize the music
F03D BDF192                     JSR     Wait_Recal      Wait for next frame
F040 BDF289                     JSR     Do_Sound        Play music if active

                *       Display power-up message

F043 BDF2A9                     JSR     Intensity_7F    Normal brightness
F046 B6C826                     LDA     $C826           Alternate size every 32 loops
F049 CEF10C                     LDU     #Vec_Title      Load address of double high text
F04C 8520                       BITA    #$20
F04E 2702                       BEQ     LF052
F050 334C                       LEAU    Vec_Title_2-Vec_Title,U  Skip double high text
F052=BDF385     LF052           JSR     Print_List_hw   Print startup text

                *       Draw the frame boxes

F055 8EF0E9                     LDX     #Intro_Boxes
F058=BDF308     LF058           JSR     Moveto_ix_FF    Move to start of line
F05B 8603                       LDA     #$03            Draw 4 lines
F05D BDF434                     JSR     Draw_Pat_VL_a
F060 7AC824                     DEC     $C824           Go back for next box
F063 26F3                       BNE     LF058
F065 B6C825                     LDA     Vec_Loop_Count
F068 8101                       CMPA    #$01            Repeat for 512 counts
F06A 23B0                       BLS     LF01C

                *-----------------------------------------------------------------------*
                *       F06C    Warm_Start                                              *
                *                                                                       *
                * Jump here to restart the Vectrex without re-initializing the OS.      *
                *-----------------------------------------------------------------------*

                *       Prepare for ROM check

F06C=BDF1AF     Warm_Start:     JSR     DP_to_C8        DP to RAM
F06F 86CC                       LDA     #$CC            Set new line pattern
F071 9729                       STA     <Vec_Pattern
F073 CCF101                     LDD     #Copyright_Str  Save copyright string addr
F076 DD39                       STD     <$C839
F078 0F25                       CLR     <Vec_Loop_Count Clear loop counter
F07A 0F26                       CLR     <$C826

                *       Check for valid cartridge ROM

F07C CE0000                     LDU     #$0000          Look at address zero
F07F 8EF101                     LDX     #Copyright_Str
F082 C60B                       LDB     #$0B            11 bytes long
F084=A6C0       LF084           LDA     ,U+             Compare next byte
F086 A180                       CMPA    ,X+
F088 270D                       BEQ     LF097           Okay if match
F08A C101                       CMPB    #$01            Not okay if last byte wrong
F08C 2704                       BEQ     LF092
F08E C105                       CMPB    #$05            Okay if date wrong
F090 2305                       BLS     LF097
F092=CEE000     LF092           LDU     #$E000          Bad cart; load Mine Storm addr
F095 2007                       BRA     LF09E

F097=5A         LF097           DECB                    Go back for next byte
F098 26EA                       BNE     LF084
F09A D739                       STB     <$C839          Store zero as address of
F09C D73A                       STB     <$C83A          copyright string

                *       Prepare to play game start-up music

F09E=0C56       LF09E           INC     <Vec_Music_Flag Set music enable flag
F0A0 DF37                       STU     <Vec_Run_Index  Save address of header
F0A2 EEC4                       LDU     ,U              Get address of music

                *       Second power-up loop.  This prints the name of the
                *       game, the copyright, and plays the start-up music

F0A4=BDF1AF     LF0A4           JSR     DP_to_C8        DP to RAM
F0A7 CCF848                     LDD     #$F848          ???
F0AA DD2A                       STD     <Vec_Text_HW
F0AC BDF687                     JSR     Init_Music_chk  Initialize the music
F0AF BDF192                     JSR     Wait_Recal      Wait for next frame
F0B2 BDF289                     JSR     Do_Sound        Play the music if active

                *       Display cartridge GCE copyright string

F0B5 BDF2A9                     JSR     Intensity_7F    Normal brightness
F0B8 CCC0C0                     LDD     #$C0C0          Print copyright string
F0BB FEC839                     LDU     $C839
F0BE BDF37A                     JSR     Print_Str_d

                *       Display current high score if any

F0C1 B6C83B                     LDA     $C83B           Skip if no high score
F0C4 260C                       BNE     LF0D2
F0C6 4A                         DECA
F0C7 CECBEB                     LDU     #Vec_High_Score
F0CA A746                       STA     6,U
F0CC CC68D0                     LDD     #$68D0
F0CF BDF37A                     JSR     Print_Str_d

                *       Display cartridge name

F0D2=FEC837     LF0D2           LDU     Vec_Run_Index   Get cartridge header addr
F0D5 3342                       LEAU    2,U             Skip music addr
F0D7 BDF385                     JSR     Print_List_hw   Print it
F0DA B6C856                     LDA     Vec_Music_Flag  Go back if music still playing
F0DD 26C5                       BNE     LF0A4
F0DF BEC825                     LDX     Vec_Loop_Count  Go back if count less than 126
F0E2 8C007D                     CMPX    #$007D
F0E5 23BD                       BLS     LF0A4
F0E7 6E41                       JMP     1,U             Jump into cartridge

                *       Outer box (y,x)

F0E9=40D6       Intro_Boxes:    FCB     $40,$D6
F0EB 0056                       FCB     $00,$56
F0ED 8100                       FCB     $81,$00
F0EF 00A9                       FCB     $00,$A9
F0F1 7E00                       FCB     $7E,$00

                *       Inner box (y,x)

F0F3 39DC                       FCB     $39,$DC
F0F5 8E00                       FCB     $8E,$00
F0F7 004A                       FCB     $00,$4A
F0F9 7200                       FCB     $72,$00
F0FB 00B6                       FCB     $00,$B6

                *       Line patterns for boundary boxes

F0FD=E0         DF0FD           FCB     %11100000
F0FE 38                         FCB     %00111000
F0FF 0E                         FCB     %00001110
F100 03                         FCB     %00000011

                *       Copyright string

F101=6720474345 Copyright_Str:  FCC     /g GCE 1982/
F10B 80                         FCB     $80
                Copyright_Len   EQU     *-Copyright_Str

                *       Title strings

F10C=F160       Vec_Title:      FCB     $F1,$60         Height, width
F10E 27CF                       FCB     $27,$CF         Y,X
F110 5645435452                 FCC     /VECTREX/
F117 80                         FCB     $80

F118 F360       Vec_Title_2:    FCB     $F3,$60         Height, width
F11A 26CF                       FCB     $26,$CF         Y,X
F11C 5645435452                 FCC     /VECTREX/
F123 80                         FCB     $80

F124 FC60                       FCB     $FC,$60         Height, width
F126 DFE9                       FCB     $DF,$E9         Y,X
F128 474345                     FCC     /GCE/
F12B 80                         FCB     $80

F12C FC38                       FCB     $FC,$38         Height, width
F12E CCD1                       FCB     $CC,$D1         Y,X
F130 454E544552                 FCC     /ENTERTAINING/
F13C 80                         FCB     $80

F13D FC38                       FCB     $FC,$38         Height, width
F13F BCDC                       FCB     $BC,$DC         Y,X
F141 4E45572049                 FCC     /NEW IDEAS/
F14A 80                         FCB     $80

F14B 00                         FCB     $00

                *-----------------------------------------------------------------------*
                *       F14C    INIT_VIA                                                *
                *                                                                       *
                * This routine is invoked during powerup, to initialize the VIA chip.   *
                * Among other things, it initializes the scale factor to 0x7F, and      *
                * sets up the direction for the port A and B data lines.                *
                *                                                                       *
                * EXIT: DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F14C=8D5C       Init_VIA:       BSR     DP_to_D0
F14E CC9FFF                     LDD     #$9FFF          Port A=all output
F151 DD02                       STD     <VIA_DDR_b      Port B=OIIOOOOO
F153 CC0100                     LDD     #$0100          Port B sound BDIR=1
F156 DD00                       STD     <VIA_port_b
F158 CC987F                     LDD     #$987F          ACR=$98 T1->PB7 enabled
F15B 970B                       STA     <VIA_shift_reg  shift reg CB2 clk2
F15D D704                       STB     <VIA_t1_cnt_lo  T1CL=$7F scale factor?
F15F BDF354                     JSR     Reset0Ref
F162 203E                       BRA     Set_Refresh

                *-----------------------------------------------------------------------*
                *       F164    Init_OS_RAM                                             *
                *                                                                       *
                * This routine first clears the block of RAM in the range $C800 to      *
                * $C87A, and then it initializes the dot dwell time, the refresh time,  *
                * and the joystick enable flags.                                        *
                *                                                                       *
                * EXIT: DP = $C8                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F164=8D49       Init_OS_RAM:    BSR     DP_to_C8        DP to RAM
F166 C67A                       LDB     #$7A            Clear $C800-$C87A
F168 8EC800                     LDX     #$C800
F16B BDF53F                     JSR     Clear_x_b
F16E CCC87D                     LDD     #Vec_Random_Seed Point $C87B to $C87D
F171 DD7B                       STD     <Vec_Seed_Ptr
F173=0C7D       LF173           INC     <Vec_Random_Seed Make sure random number
F175 27FC                       BEQ     LF173              seed is non-zero!
F177 8605                       LDA     #$05            Init dot dwell (brightness)
F179 9728                       STA     <Vec_Dot_Dwell
F17B CC3075                     LDD     #$3075          Init refresh time to $7530
F17E DD3D                       STD     <$C83D
F180 CC0103                     LDD     #$0103          Init joystick enable flags
F183 DD1F                       STD     <Vec_Joy_Mux_1_X
F185 CC0507                     LDD     #$0507
F188 DD21                       STD     <Vec_Joy_Mux_2_X
F18A 39                         RTS

                *-----------------------------------------------------------------------*
                *       F18B    Init_OS                                                 *
                *                                                                       *
                * This routine is responsible for setting up the initial system state,  *
                * each time the system is either reset or powered up.  It will          *
                * initialize the OS RAM area, initialize the VIA chip, and then clear   *
                * all the registers on the sound chip.                                  *
                *                                                                       *
                * EXIT: DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F18B=8DD7       Init_OS:        BSR     Init_OS_RAM
F18D 8DBD                       BSR     Init_VIA
F18F 7EF272                     JMP     Clear_Sound

                *-----------------------------------------------------------------------*
                *       F192    Wait_Recal                                              *
                *                                                                       *
                * Wait for t2 (the refresh timer) to timeout, then restart it using     *
                * the value in $C83D.  then, recalibrate the vector generators to the   *
                * origin (0,0).  This routine MUST be called once every refresh         *
                * cycle, or your vectors will get out of whack.  This routine calls     *
                * Reset0Ref, so the integrators are left in zero mode.                  *
                *                                                                       *
                * EXIT: DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F192=BEC825     Wait_Recal:     LDX     Vec_Loop_Count  Increment loop counter
F195 3001                       LEAX    1,X
F197 BFC825                     STX     Vec_Loop_Count
F19A 8D0E                       BSR     DP_to_D0        DP to I/O
F19C 8620                       LDA     #$20
F19E=950D       LF19E           BITA    <VIA_int_flags  Wait for timer t2
F1A0 27FC                       BEQ     LF19E

                *-----------------------------------------------------------------------*
                *       F1A2    Set_Refresh                                             *
                *                                                                       *
                * This routine loads the refresh timer (t2) with the value in $C83D-    *
                * $C83E, and recalibrates the vector generators, thus causing the pen   *
                * to be left at the origin (0,0).  The high order byte for the timer    *
                * is loaded from $C83E, and the low order byte is loaded from $C83D.    *
                * The refresh rate is calculated as follows:                            *
                *                                                                       *
                *   rate = (C83E)(C83D) / 1.5 mhz                                       *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg, A-reg trashed                                            *
                *-----------------------------------------------------------------------*

F1A2=FCC83D     Set_Refresh:    LDD     $C83D           Store refresh value
F1A5 DD08                       STD     <VIA_t2_lo      into timer t2
F1A7 7EF2E6                     JMP     Recalibrate

                *-----------------------------------------------------------------------*
                *       F1AA    DP_to_D0                                                *
                *                                                                       *
                * Sets the DP register to $D0, so that all direct page addressing will  *
                * start at $D000 (the hardware I/O area).                               *
                *                                                                       *
                * EXIT: DP = $D0                                                        *
                *       A-reg = $D0                                                     *
                *-----------------------------------------------------------------------*

F1AA=86D0       DP_to_D0:       LDA     #$D0
F1AC 1F8B                       TFR     A,DP
F1AE 39                         RTS

                *-----------------------------------------------------------------------*
                *       F1AF    DP_to_C8                                                *
                *                                                                       *
                * Sets the DP register to $C8, so that all direct page addressing will  *
                * start at $C800 (OS RAM area).                                         *
                *                                                                       *
                *                                                                       *
                * EXIT: DP = $C8                                                        *
                *       A-reg = $C8                                                     *
                *-----------------------------------------------------------------------*

F1AF=86C8       DP_to_C8:       LDA     #$C8
F1B1 1F8B                       TFR     A,DP
F1B3 39                         RTS

                *-----------------------------------------------------------------------*
                *       F1B4    Read_Btns_Mask                                          *
                *       F1BA    Read_Btns                                               *
                *                                                                       *
                * Both of these routines read the button states on the two joysticks,   *
                * and return their state in the following RAM locations:                *
                *                                                                       *
                *       joystick 1, button 1:  $C812 = $01                              *
                *                   button 2:  $C813 = $02                              *
                *                   button 3:  $C814 = $04                              *
                *                   button 4:  $C815 = $08                              *
                *       joystick 2, button 1:  $C816 = $10                              *
                *                   button 2:  $C817 = $20                              *
                *                   button 3:  $C818 = $40                              *
                *                   button 4:  $C819 = $80                              *
                *                                                                       *
                *       C80F: Contains current state of all buttons;                    *
                *             1 = depressed, 0 = not depressed                          *
                *                                                                       *
                *       C810: Contains state of all buttons from LAST time these        *
                *             routines were called; if Read_Btns_Mask was called,       *
                *             then this is AND'ed with the passed in mask.              *
                *                                                                       *
                *       C811: Contains the same information as $C812-$C819              *
                *                                                                       *
                *        Bit 7                                     Bit 0                *
                *       +-----+-----+-----+-----+-----+-----+-----+-----+               *
                *       | 2.4 | 2.3 | 2.2 | 2.1 | 1.4 | 2.3 | 1.2 | 1.1 |               *
                *       +-----+-----+-----+-----+-----+-----+-----+-----+               *
                *                                                                       *
                * If Read_Btns is called, the result will be the same as Read_Btns_Mask *
                * with a mask of $FF, and a 1 will only be returned if the button       *
                * has transitioned to being pressed.                                    *
                *                                                                       *
                * If Read_Btns_Mask is called, then a mask, passed in in the A-reg      *
                * will be used to determine how the button state info is returned:      *
                *                                                                       *
                * If a bit is 0, then the current state of the button is to be returned *
                * in the appropriate RAM location; 0 = not pressed, and 1 = pressed.    *
                *                                                                       *
                * If a bit is 1, then the appropriate RAM location is set to 1 only     *
                * on the depression transition of the button; additional calls will     *
                * return 0, until the button is released and then depressed again.      *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = mask (for Read_Btns_Mask only)                          *
                *                                                                       *
                * Exit: A-reg = button transition state (same as $C811)                 *
                *                                                                       *
                *       B-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*
Vec_Btn_State  = c80f
Vec_Prev_Btns  = c810
Vec_Buttons    = c811
Vec_Button_1_1 = c812

F1B4=B4C80F     Read_Btns_Mask: ANDA    Vec_Btn_State   Mask out "always" buttons
F1B7 B7C80F                     STA     Vec_Btn_State
F1BA 8EC812     Read_Btns:      LDX     #Vec_Button_1_1 Point to button flags
F1BD A61D                       LDA     -3,X            Save previous state
F1BF A71E                       STA     -2,X
F1C1 860E                       LDA     #$0E            Sound chip register 0E to port A
F1C3 9701                       STA     <VIA_port_a
F1C5 CC1901                     LDD     #$1901          sound BDIR on, BC1 on, mux off
F1C8 9700                       STA     <VIA_port_b
F1CA 12                         NOP                     pause
F1CB D700                       STB     <VIA_port_b     sound BDIR off, BC1 off, mux off
F1CD 0F03                       CLR     <VIA_DDR_a      DDR A to input
F1CF CC0901                     LDD     #$0901          sound BDIR off, BC1 on, mux off
F1D2 9700                       STA     <VIA_port_b
F1D4 12                         NOP                     pause
F1D5 9601                       LDA     <VIA_port_a     Read buttons
F1D7 43                         COMA                    Convert to active high
F1D8 A71D                       STA     -3,X            Save buttons
F1DA D700                       STB     <VIA_port_b     sound BDIR off, BC1 off, mux off
F1DC C6FF                       LDB     #$FF
F1DE D703                       STB     <VIA_port_a     DDR A to output
F1E0 43                         COMA                    Check for transitions
F1E1 AA1E                       ORA     -2,X
F1E3 43                         COMA
F1E4 A71F                       STA     -1,X            Store transition result
F1E6 3402                       PSHS    A               Save result for return value
F1E8 C601                       LDB     #$01            Initialize bit position
F1EA=1F98       LF1EA           TFR     B,A             Mask out bit
F1EC A4E4                       ANDA    ,S
F1EE A780                       STA     ,X+             Store masked bit
F1F0 58                         ASLB                    Go back for next bit
F1F1 26F7                       BNE     LF1EA
F1F3 3582                       PULS    A,PC            Get back transition bits and return

                *-----------------------------------------------------------------------*
                *       F1F5    Joy_Analog                                              *
                *       F1F8    Joy_Digital                                             *
                *                                                                       *
                * These routines read the current positions of the two joysticks.       *
                *                                                                       *
                * The joystick enable flags (C81F-C822) must be initialized to one of   *
                * the following values:                                                 *
                *                                                                       *
                *       0 - ignore; return no value.                                    *
                *       1 - return state of console 1 left/right position.              *
                *       3 - return state of console 1 up/down position.                 *
                *       5 - return state of console 2 left/right position.              *
                *       7 - return state of console 2 up/down position.                 *
                *                                                                       *
                * The joystick values are returned in $C81B-$C81E, where the value      *
                * returned in $C81B corresponds to the mask set in in $C81F, and so     *
                * on and so forth.                                                      *
                *                                                                       *
                * The joystick conversion is dependent on which routine is called.      *
                * Results for each routine are:                                         *
                *                                                                       *
                *       Joy_Digital:                                                    *
                *               The return value will be:                               *
                *                 < 0 if joystick is left of down of center.            *
                *                 = 0 if joystick is centered.                          *
                *                 > 0 if joystick is right or up of center.             *
                *                                                                       *
                *       Joy_Analog:                                                     *
                *               A successive approximation algorithm is used to read    *
                *               the actual value of the joystick pot, a signed value.   *
                *               In this case, $C81A must be set to a power of 2, to     *
                *               to control conversion resolution; 0x80 is least         *
                *               accurate, and 0x00is most accurate.                     *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F1F5=7AC823     Joy_Analog:     DEC     $C823           Set analog mode flag
F1F8 8EC81F     Joy_Digital:    LDX     #Vec_Joy_Mux_1_X Point to first pot
F1FB=A680       LF1FB           LDA     ,X+             Read it if enabled
F1FD 260C                       BNE     LF20B
F1FF=8CC823     LF1FF           CMPX    #$C823          Go back untl all pots read
F202 26F7                       BNE     LF1FB
F204 6F84                       CLR     ,X              X points to $C823, clear it
F206 8601                       LDA     #$01
F208 9700                       STA     <VIA_port_b     disable mux
F20A 39                         RTS

F20B=9700       LF20B           STA     <VIA_port_b     enable mux and select pot
F20D 0F01                       CLR     <VIA_port_a     output $00 to D/A
F20F 0A00                       DEC     <VIA_port_b     disable mux
F211 C660                       LDB     #$60            delay and end up with B=$80
F213=5C         LF213           INCB
F214 2AFD                       BPL     LF213
F216 B6C823                     LDA     $C823           check analog flag
F219 2B25                       BMI     LF240           branch if analog pot
F21B 8620                       LDA     #$20
F21D 0C00                       INC     <VIA_port_b     enable mux
F21F 9500                       BITA    <VIA_port_b     test comparator
F221 270A                       BEQ     LF22D
F223 C640                       LDB     #$40            output $40 to D/A
F225 D701                       STB     <VIA_port_a
F227 9500                       BITA    <VIA_port_b     test comparator
F229 260B                       BNE     LF236
F22B 2008                       BRA     LF235

F22D=C6C0       LF22D           LDB     #$C0            output $C0 to D/A
F22F D701                       STB     <VIA_port_a
F231 9500                       BITA    <VIA_port_b     test comparator
F233 2701                       BEQ     LF236
F235=5F         LF235           CLRB
F236=E71B       LF236           STB     -5,X            store A/D result
F238 20C5                       BRA     LF1FF           go back for next pot

F23A=1F98       LF23A           TFR     B,A
F23C 9A01                       ORA     <VIA_port_a
F23E 9701                       STA     <VIA_port_a
F240=8620       LF240           LDA     #$20            test comparator
F242 9500                       BITA    <VIA_port_b
F244 2606                       BNE     LF24C           branch to go lower?
F246 1F98                       TFR     B,A
F248 9801                       EORA    <VIA_port_a
F24A 9701                       STA     <VIA_port_a
F24C=54         LF24C           LSRB                    try next bit position
F24D F1C81A                     CMPB    Vec_Joy_Resltn  check for accuracy threshold
F250 26E8                       BNE     LF23A           go back if not finished
F252 D601                       LDB     <VIA_port_a     read D/A value
F254 20E0                       BRA     LF236           go back to store it

                *-----------------------------------------------------------------------*
                *       F256    Sound_Byte                                              *
                *       F259    Sound_Byte_x                                            *
                *       F25B    Sound_Byte_raw                                          *
                *                                                                       *
                * All of these routines cause a byte of music data to be written to     *
                * the music chip.  Sound_Byte stores a shadow copy of the data into     *
                * $C800-$C80E, and Sound_Byte_x stores a shadow copy into a 15 byte     *
                * area pointed to by the X register.  Sound_Byte_raw does not store a   *
                * shadow copy of the data at all.                                       *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = which of the 15 sound chip registers to modify          *
                *       B-reg = the byte of sound data                                  *
                *       X-reg = 15 byte shadow area (Sound_Byte_x only)                 *
                *                                                                       *
                * EXIT: X-reg = $C800 (Sound_Byte only)                                 *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F256=8EC800     Sound_Byte:     LDX     #Vec_Snd_Shadow point to shadow memory
F259=E786       Sound_Byte_x:   STB     A,X
F25B 9701       Sound_Byte_raw: STA     <VIA_port_a     store register select byte
F25D 8619                       LDA     #$19            sound BDIR on, BC1 on, mux off
F25F 9700                       STA     <VIA_port_b
F261 8601                       LDA     #$01            sound BDIR off, BC1 off, mux off
F263 9700                       STA     <VIA_port_b
F265 9601                       LDA     <VIA_port_a     read sound chip status (?)
F267 D701                       STB     <VIA_port_a     store data byte
F269 C611                       LDB     #$11            sound BDIR on, BC1 off, mux off
F26B D700                       STB     <VIA_port_b
F26D C601                       LDB     #$01            sound BDIR off, BC1 off, mux off
F26F D700                       STB     <VIA_port_b
F271 39                         RTS

                *-----------------------------------------------------------------------*
                *       F272    Clear_Sound                                             *
                *                                                                       *
                * This routine clears the 15 registers on the music chip and the soft   *
                * copy of their values (C800-C80E), by writing a byte of 0 to each      *
                * register.  This causes the sound chip to not make any sounds.         *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F272=CC0E00     Clear_Sound:    LDD     #$0E00
F275=8DDF       LF275           BSR     Sound_Byte
F277 4A                         DECA
F278 2AFB                       BPL     LF275
F27A 7EF533                     JMP     Init_Music_Buf

                *-----------------------------------------------------------------------*
                *       F27D    Sound_Bytes                                             *
                *       F284    Sound_Bytes_x? (apparently never used)                  *
                *                                                                       *
                * This routine copies a block of sound information into the sound       *
                * chip buffer (at $C800-$C80E) and into the registers on the music      *
                * chip.  The format for the block of sound data is as follows:          *
                *                                                                       *
                *   (register number), (music data),                                    *
                *   (register number), (music data),                                    *
                *         .                  .                                          *
                *         .                  .                                          *
                *       0xFF                                                            *
                *                                                                       *
                * As long as the register number is >= 0, then the music data will be   *
                * copied; however, as soon as a register number < 0 is encountered,     *
                * the copy will stop.                                                   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg = pointer to the block of sound data                      *
                *                                                                       *
                *       D-reg, X-reg, U-reg trashed                                     *
                *-----------------------------------------------------------------------*

F27D=8EC800     Sound_Bytes:    LDX     #Vec_Snd_Shadow Point to shadow memory
F280 2002                       BRA     Sound_Bytes_x

F282=8DD5       LF282           BSR     Sound_Byte_x    Update the sound register
F284=ECC1       Sound_Bytes_x:  LDD     ,U++            Get next next pair of bytes
F286 2AFA                       BPL     LF282           Go back if not end of list
F288 39                         RTS

                *-----------------------------------------------------------------------*
                *       F289    Do_Sound                                                *
                *       F28C    Do_Sound_x? (apparently never used)                     *
                *                                                                       *
                * This routine will start/continue making the sound which was first     *
                * set up by your call to Init_Music.  This routine should normally      *
                * be called right after your call to Wait_Recal.  It takes the next     *
                * music information, contained in the music buffer $C83F-$C84C, and     *
                * updates only those registers which differ from the last data written  *
                * to the sound chip.                                                    *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg, U-reg trashed                                     *
                *-----------------------------------------------------------------------*

F289=8EC800     Do_Sound:       LDX     #Vec_Snd_Shadow point to shadow memory
F28C CEC83F     Do_Sound_x:     LDU     #Vec_Music_Work point to sound buffer
F28F 860D                       LDA     #$0D            init count for 14 registers
F291=E6C0       LF291           LDB     ,U+             get next register
F293 E186                       CMPB    A,X             skip if unchanged
F295 2702                       BEQ     LF299
F297 8DC0                       BSR     Sound_Byte_x    else update register
F299=4A         LF299           DECA                    go back for next register
F29A 2AF5                       BPL     LF291
F29C 39                         RTS

                *-----------------------------------------------------------------------*
                *       F29D    Intensity_1F                                            *
                *       F2A1    Intensity_3F                                            *
                *       F2A5    Intensity_5F                                            *
                *       F2A9    Intensity_7F                                            *
                *       F2AB    Intensity_a                                             *
                *                                                                       *
                * Each of these routines are responsible for setting the vector/dot     *
                * intensity (commonly used to denote the z axis) to a specific value.   *
                * 0x00 is the lowest intensity, and 0xFF is the brightest intensity.    *
                * The intensity must be reset to the desired value after each call      *
                * to Wait_Recal; however, it can also be changed at any other time.     *
                * A copy of the new intensity value is saved in $C827.                  *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = intensity (Intensity_a only)                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F29D=861F       Intensity_1F:   LDA     #$1F
F29F 200A                       BRA     Intensity_a

F2A1=863F       Intensity_3F:   LDA     #$3F
F2A3 2006                       BRA     Intensity_a

F2A5=865F       Intensity_5F:   LDA     #$5F
F2A7 2002                       BRA     Intensity_a

F2A9=867F       Intensity_7F:   LDA     #$7F
F2AB=9701       Intensity_a:    STA     <VIA_port_a     Store intensity in D/A
F2AD B7C827                     STA     Vec_Brightness  Save intensity in $C827
F2B0 CC0504                     LDD     #$0504          mux disabled channel 2
F2B3 9700                       STA     <VIA_port_b
F2B5 D700                       STB     <VIA_port_b     mux enabled channel 2
F2B7 D700                       STB     <VIA_port_b     do it again just because
F2B9 C601                       LDB     #$01
F2BB D700                       STB     <VIA_port_b     turn off mux
F2BD 39                         RTS

                *-----------------------------------------------------------------------*
                *       F2BE    Dot_ix_b                                                *
                *       F2C1    Dot_ix                                                  *
                *                                                                       *
                * These routines draw a dot at the relative y and relative x            *
                * position pointed to by the X register.  Afterwards, the X register    *
                * is incremented by 2.                                                  *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the (y,x) coordinate pair                       *
                *       B-reg contains the intensity (Dot_ix_b only)                    *
                *       $C828 contains the intensity (Dot_ix only)                      *
                *                                                                       *
                * EXIT  X-reg incremented by 2                                          *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2BE=F7C828     Dot_ix_b:       STB     Vec_Dot_Dwell
F2C1=EC81       Dot_ix:         LDD     ,X++

                *-----------------------------------------------------------------------*
                *       F2C3    Dot_d                                                   *
                *                                                                       *
                * This routine draws a dot at the relative y and relative x position    *
                * contained in the D register.  The intensity used is the value         *
                * already stored in $C828.                                              *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = relative Y coordinate                                   *
                *       B-reg = relative X coordinate                                   *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2C3 8D4D       Dot_d:          BSR     Moveto_d

                *-----------------------------------------------------------------------*
                *       F2C5    Dot_here                                                *
                *                                                                       *
                * This routine draws a dot at the current pen position.                 *
                * The intensity used is the value already stored in $C828.              *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2C5 86FF       Dot_here:       LDA     #$FF            Set pattern to all 1's
F2C7 970A                       STA     <VIA_shift_reg  Store in VIA shift register
F2C9 F6C828                     LDB     Vec_Dot_Dwell   Get dot dwell (brightness)
F2CC=5A         LF2CC           DECB                    Delay leaving beam in place
F2CD 26FD                       BNE     LF2CC
F2CF 0F0A                       CLR     <VIA_shift_reg  Blank beam in VIA shift register
F2D1 39                         RTS

                *-----------------------------------------------------------------------*
                *       F2D5    Dot_List                                                *
                *                                                                       *
                * This routine draws a series of dots, using the intensity already      *
                * set up in $C828.  The format for the dot list, which is pointed to    *
                * by the X register, is:                                                *
                *                                                                       *
                *     ( rel y, rel x), (rel y, rel x), .....                            *
                *                                                                       *
                * The number of dots to draw is specified in $C823.                     *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the list of dot coordinates                     *
                *       $C823 specifies the number of dots to draw                      *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *       $C823 cleared                                                   *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2D2=7AC823     LF2D2           DEC     $C823           Decrement counter
F2D5=8DEA       Dot_List:       BSR     Dot_ix          Draw next dot
F2D7 B6C823                     LDA     $C823           Check counter
F2DA 26F6                       BNE     LF2D2           Go back until finished
F2DC 2076                       BRA     Reset0Ref       Go to Reset0Ref

                *-----------------------------------------------------------------------*
                *       F2DE    Dot_List_Reset                                          *
                *                                                                       *
                * This routine draws a series of dots, specified by the list pointed    *
                * to by the X register.  The list has the following format:             *
                *                                                                       *
                *     mode, relative y, relative x,                                     *
                *     mode, relative y, relative x,                                     *
                *       .      .           .                                            *
                *       .      .           .                                            *
                *     mode, relative y, relative x                                      *
                *     0x01                                                              *
                *                                                                       *
                * This routine will continue to traverse the list, until a mode > 0     *
                * is encountered; at that point, it will reset the zero reference       *
                * (the integrators).                                                    *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the dot list                                    *
                *                                                                       *
                * EXIT: X-reg points to next byte after the terminator                  *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2DE=A680       Dot_List_Reset: LDA     ,X+             get mode byte
F2E0 2E72                       BGT     Reset0Ref       if >0 go to Reset0Ref
F2E2 8DDD                       BSR     Dot_ix          plot the dot
F2E4 20F8                       BRA     Dot_List_Reset  dot_list@x_&_reset

                *-----------------------------------------------------------------------*
                *       F2E6    Recalibrate                                             *
                *                                                                       *
                *       Recalibrate the vector generators.                              *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F2E6=8EF9F0     Recalibrate:    LDX     #Recal_Points   $7F7F
F2E9 8D1D                       BSR     Moveto_ix_FF
F2EB BDF36B                     JSR     Reset0Int
F2EE 8D20                       BSR     Moveto_ix       $8080
F2F0 2062                       BRA     Reset0Ref

                *-----------------------------------------------------------------------*
                *       F2F2    Moveto_x_7F                                             *
                *                                                                       *
                * This routine forces the scale factor to 0x7F, and then moves the      *
                * pen to the location pointed to by the X register.  The relative y     *
                * and relative x coordinates are both 2 byte quantities; however,       *
                * only the most signicant byte of each is of any interest.  The values  *
                * pointed to by the X register have the following format:               *
                *                                                                       *
                *     X => (rel y hi),(rel y lo), (rel x hi), (rel x lo)                *
                *                                                                       *
                * The position moved to is obtained by y=(0,x) & x=(2,x).               *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to double-sized coordinate pair                    *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2F2=C67F       Moveto_x_7F:    LDB     #$7F            Set scale factor to $7F
F2F4 D704                       STB     <VIA_t1_cnt_lo
F2F6 A684                       LDA     ,X              Get y high
F2F8 E602                       LDB     2,X             Get x high
F2FA 2016                       BRA     Moveto_d

                *-----------------------------------------------------------------------*
                *       F2FC    Moveto_d_7F                                             *
                *                                                                       *
                * This routine forces the scale factor to 0x7F, and then moves the      *
                * pen to the position specified in the D register.                      *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = relative Y coordinate                                   *
                *       B-reg = relative X coordinate                                   *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F2FC=9701       Moveto_d_7F:    STA     <VIA_port_a     Store Y in D/A register
F2FE 3406                       PSHS    D               Save D-register on stack
F300 867F                       LDA     #$7F            Set scale factor to $7F
F302 9704                       STA     <VIA_t1_cnt_lo
F304 0F00                       CLR     <VIA_port_b     Enable mux
F306 2010                       BRA     LF318

                *-----------------------------------------------------------------------*
                *       F308    Moveto_ix_FF                                            *
                *       F30C    Moveto_ix_7F                                            *
                *       F30E    Moveto_ix_a                                             *
                *                                                                       *
                * These routineS force the scale factor to 0xFF, 0X7F, or the           *
                * A register, and then move the pen to the (y,x) position pointed to    *
                * by the X-register.  The X-register is then incremented by 2.          *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the (y,x) coordinate pair                       *
                *       A-reg contains the scale factor (Moveto_ix_a only)              *
                *                                                                       *
                * EXIT: X-reg has been incremented by 2                                 *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F308=C6FF       Moveto_ix_FF:   LDB     #$FF
F30A 2002                       BRA     Moveto_x_a

F30C=C67F       Moveto_ix_7F:   LDB     #$7F
F30E=D704       Moveto_ix_a:    STB     <VIA_t1_cnt_lo  Set scale factor

                *-----------------------------------------------------------------------*
                *       F310    Moveto_ix                                               *
                *                                                                       *
                * This routine uses the current scale factor, and moves the pen to the  *
                * (y,x) position pointed to by the X register.  The X register is then  *
                * incremented by 2.                                                     *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the (y,x) coordinate pair                       *
                *                                                                       *
                * EXIT: X-reg has been incremented by 2                                 *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F310=EC81       Moveto_ix:      LDD     ,X++

                *-----------------------------------------------------------------------*
                *       F312    Moveto_d                                                *
                *                                                                       *
                * This routine uses the current scale factor, and moves the pen to the  *
                * (y,x) position specified in D register.                               *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = Y coordinate                                            *
                *       B-reg = X coordinate                                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F312=9701       Moveto_d:       STA     <VIA_port_a     Store Y in D/A register
F314 0F00                       CLR     <VIA_port_b     Enable mux
F316 3406                       PSHS    D               Save D-register on stack
F318=86CE       LF318           LDA     #$CE            Blank low, zero high?
F31A 970C                       STA     <VIA_cntl
F31C 0F0A                       CLR     <VIA_shift_reg  Clear shift regigster
F31E 0C00                       INC     <VIA_port_b     Disable mux
F320 D701                       STB     <VIA_port_a     Store X in D/A register
F322 0F05                       CLR     <VIA_t1_cnt_lo  timer 1 count high
F324 3506                       PULS    D               Get back D-reg
F326 BDF584                     JSR     Abs_a_b
F329 E77F                       STB     -1,S
F32B AA7F                       ORA     -1,S
F32D C640                       LDB     #$40
F32F 8140                       CMPA    #$40
F331 2312                       BLS     LF345
F333 8164                       CMPA    #$64
F335 2304                       BLS     LF33B
F337 8608                       LDA     #$08
F339 2002                       BRA     LF33D

F33B=8604       LF33B           LDA     #$04            Wait for timer 1
F33D=D50D       LF33D           BITB    <VIA_int_flags
F33F 27FC                       BEQ     LF33D
F341=4A         LF341           DECA                    Delay a moment
F342 26FD                       BNE     LF341
F344 39                         RTS

F345=D50D       LF345           BITB    <VIA_int_flags  Wait for timer 1
F347 27FC                       BEQ     LF345
F349 39                         RTS

                *-----------------------------------------------------------------------*
                *       F34A    Reset0Ref_D0                                            *
                *                                                                       *
                * This routine sets the DP register to D0, and then resets the          *
                * integrators.                                                          *
                *                                                                       *
                * EXIT: DP = $D0                                                        *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F34A=BDF1AA     Reset0Ref_D0:   JSR     DP_to_D0
F34D 2005                       BRA     Reset0Ref

                *-----------------------------------------------------------------------*
                *       F34F    Check0Ref                                               *
                *                                                                       *
                * This routine will check to see if the Reset0Ref enable flag ($C824)   *
                * is set, and if it is, then it will reset the integrators by calling   *
                * Reset0Ref.                                                            *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       $C824 = enable flag                                             *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F34F=B6C824     Check0Ref:      LDA     Vec_0Ref_Enable
F352 2716                       BEQ     LF36A_RTS

                *-----------------------------------------------------------------------*
                *       F354    Reset0Ref                                               *
                *                                                                       *
                * This routine zeros the integrators, and resets the pen back to the    *
                * origin.  It leaves the integrators in zero mode, so nothing can be    *
                * drawn until a move is done, or $D00C is set to 0xCE to bring /ZERO    *
                * high.  This routine must be called every so often, to prevent your    *
                * vectors from getting out of whack.                                    *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F354=CC00CC     Reset0Ref:      LDD     #$00CC
F357 D70C                       STB     <VIA_cntl       /BLANK low and /ZERO low
F359 970A                       STA     <VIA_shift_reg  clear shift register
                *-----------------------------------------------------------------------*
                *       F35B    Reset_Pen                                               *
                *                                                                       *
                *       Reset the pen to the origin.                                    *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F35B=CC0302     Reset_Pen:      LDD     #$0302
F35E 0F01                       CLR     <VIA_port_a     clear D/A register
F360 9700                       STA     <VIA_port_b     mux=1, disable mux
F362 D700                       STB     <VIA_port_b     mux=1, enable mux
F364 D700                       STB     <VIA_port_b     do it again
F366 C601                       LDB     #$01
F368 D700                       STB     <VIA_port_b     disable mux
F36A=39         LF36A_RTS       RTS

                *-----------------------------------------------------------------------*
                *       F36B    Reset0Int                                               *
                *                                                                       *
                * This routine resets the integrators to zero.  It leaves the           *
                * integrators in zero mode, so nothing can be drawn until a move is     *
                * done, or D00C is set to 0xCE.                                         *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F36B=CC00CC     Reset0Int:      LDD     #$00CC
F36E D70C                       STB     <VIA_cntl       blank low and zero low
F370 970A                       STA     <VIA_shift_reg  clear shift register
F372 39                         RTS

                *-----------------------------------------------------------------------*
                *       F373    Print_Str_hwyx                                          *
                *                                                                       *
                * This routine prints a single string (up to an 0x80).  The parameter   *
                * block describing the string is pointed to by the U register.  The     *
                * format for the parameter block is as follows:                         *
                *                                                                       *
                *       height, width, rel y, rel x, string, 0x80                       *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg points to the string list                                 *
                *                                                                       *
                * EXIT: U-reg points to the byte after the terminating 0x80             *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F373=ECC1       Print_Str_hwyx: LDD     ,U++
F375 FDC82A                     STD     Vec_Text_HW

                *-----------------------------------------------------------------------*
                *       F378    Print_Str_yx                                            *
                *                                                                       *
                * This routine prints a single string (up to an 0x80), using the        *
                * default height and width, as stored in $C82A.  The parameter block    *
                * describing the string is pointed to by the U register.  The format    *
                * for the parameter block is as follows:                                *
                *                                                                       *
                *       rel y, rel x, string, 0x80                                      *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg points to the string list                                 *
                *                                                                       *
                * EXIT: U-reg points to the byte after the terminating 0x80             *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F378=ECC1       Print_Str_yx:   LDD     ,U++

                *-----------------------------------------------------------------------*
                *       F37A    Print_Str_d                                             *
                *                                                                       *
                * This routine prints a single string (up to an 0x80), using the        *
                * default height and width, as stored in $C82A, and at the pen position *
                * specified in the D register.  The parameter block describing the      *
                * string is pointed to by the U register.  The format for the           *
                * parameter block is as follows:                                        *
                *                                                                       *
                *     string, 0x80                                                      *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg points to string list                                     *
                *       A-reg = relative Y position                                     *
                *       B-reg = relative X position                                     *
                *                                                                       *
                * EXIT: U-reg points to the byte after the terminating 0x80             *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F37A=BDF2FC     Print_Str_d:    JSR     Moveto_d_7F
F37D BDF575                     JSR     Delay_1
F380 7EF495                     JMP     Print_Str

                *-----------------------------------------------------------------------*
                *       F385    Print_List_hw                                           *
                *                                                                       *
                * This displays the group of strings described by the parameter block   *
                * which is pointed to by the U register.  The string parameter block    *
                * has the following format:                                             *
                *                                                                       *
                *     height, width, rel y, rel x, string, 0x80,                        *
                *     height, width, rel y, rel x, string, 0x80,                        *
                *     0x00                                                              *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg points to string list                                     *
                *                                                                       *
                * EXIT: U-reg points to null terminator byte                            *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F383=8DEE       LF383           BSR     Print_Str_hwyx
F385=A6C4       Print_List_hw:  LDA     ,U
F387 26FA                       BNE     LF383
F389 39                         RTS

                *-----------------------------------------------------------------------*
                *       F38A    Print_List                                              *
                *       F38C    Print_List_chk                                          *
                *                                                                       *
                * This displays the group of strings described by the parameter block   *
                * which is pointed to by the U register.  The string parameter block    *
                * has the following format:                                             *
                *                                                                       *
                *       rel y, rel x, string, 0x80,                                     *
                *       rel y, rel x, string, 0x80,                                     *
                *       0x00                                                            *
                *                                                                       *
                * The current string height and width to which the hardware is set will *
                * be used.                                                              *
                *                                                                       *
                * Print_List routine will first print the passed-in string, and THEN    *
                * check for the end of the string list.  Print_List_Chk will check for  *
                * the end of the string list first.                                     *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg points to string list                                     *
                *                                                                       *
                * EXIT: U-reg points to null terminator byte                            *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F38A=8DEC       Print_List:     BSR     Print_Str_yx
F38C=A6C4       Print_List_Chk: LDA     ,U
F38E 26FA                       BNE     Print_List
F390 39                         RTS

                *-----------------------------------------------------------------------*
                *       F391    Print_Ships_x                                           *
                *       F393    Print_Ships                                             *
                *                                                                       *
                * This routine displays the number of ships passed in the B register    *
                * followed by a minus sign and the ship icon character passed in the    *
                * A register at the (y,x) coordinates passed in the X register.  If     *
                * the B-register > 9, then the infinity symbol is displayed.            *
                *                                                                       *
                * Note: This routine uses bytes at a negative offset from the stack as  *
                *       temporary storage, so hopefully an IRQ won't happen until the   *
                *       string is finished bring printed!                               *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = ship icon character                                     *
                *       B-reg = number of ships                                         *
                *       X-reg = (y,x) coordinates (Print_Ships only)                    *
                *       X-reg points to (y,x) coordinates (Print_Ships_x only)          *
                *                                                                       *
                *       D-reg, X-reg, U-reg trashed                                     *
                *-----------------------------------------------------------------------*

F391=AE84       Print_Ships_x:  LDX     ,X
F393=3404       Print_Ships:    PSHS    B               Save B-reg
F395 C680                       LDB     #$80
F397 3378                       LEAU    -8,S            Point U into the stack
F399 3606                       PSHU    D               Save A-reg and a terminator
F39B 3502                       PULS    A               Get back B-reg
F39D 8109                       CMPA    #$09            If B-reg >9 then
F39F 2302                       BLS     LF3A3
F3A1 863C                       LDA     #$6C-$30          load $6C = infinty symbol
F3A3=8B30       LF3A3           ADDA    #$30
F3A5 C62D                       LDB     #'-'
F3A7 3606                       PSHU    D               Push digit and minus sign
F3A9 3610                       PSHU    X               Push (y,x) coordinates
F3AB 20CB                       BRA     Print_Str_yx    Print it

                *-----------------------------------------------------------------------*
                *       F3AD    Mov_Draw_VLc_a                                          *
                *                                                                       *
                * This routine moves to the first location specified in vector list,    *
                * and then draws lines between the rest of coordinates in the list.     *
                * The number of vectors to draw is specified as the first byte in the   *
                * vector list.  The current scale factor is used.  The vector list has  *
                * the following format:                                                 *
                *                                                                       *
                *       count, rel y, rel x, rel y, rel x, ...                          *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3AD=A680       Mov_Draw_VLc_a: LDA     ,X+
F3AF 2008                       BRA     Draw_VL_a

                *-----------------------------------------------------------------------*
                *       F3B1    Mov_Draw_VL_b                                           *
                *                                                                       *
                * This routine moves to the first location specified in vector list,    *
                * and then draws lines between the rest of coordinates in the list.     *
                * The vector list has the following format:                             *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       B-reg = scale factor                                            *
                *       $C823 = number of vectors to draw                               *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: $C823 is cleared                                                *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3B1=D704       Mov_Draw_VL_b:  STB     <VIA_t1_cnt_lo  Set scale factor
F3B3 2007                       BRA     Draw_VL

                *-----------------------------------------------------------------------*
                *       F3B5    Mov_Draw_VLcs                                           *
                *                                                                       *
                * This routine moves to the first location specified in vector list,    *
                * and then draws lines between the rest of coordinates in the list.     *
                * The number of vectors to draw is specified as the first byte in the   *
                * vector list, and the scale factor is the second byte in the vector    *
                * list.  The vector list has the following format:                      *
                *                                                                       *
                *       count, scale, rel y, rel x, rel y, rel x, ...                   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3B5=EC81       Mov_Draw_VLcs:  LDD     ,X++

                *-----------------------------------------------------------------------*
                *       F3B7    Mov_Draw_VL_ab                                          *
                *       F3B9    Mov_Draw_VL_a                                           *
                *                                                                       *
                * This routine moves to the first location specified in vector list,    *
                * and then draws lines between the rest of coordinates in the list.     *
                * The vector list has the  following format:                            *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = number of vectors to draw                               *
                *       B-reg = scale factor to use (Draw_VL_ab only)                   *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3B7=D704       Mov_Draw_VL_ab: STB     <VIA_t1_cnt_lo  Set scale factor
F3B9=B7C823     Mov_Draw_VL_a:  STA     $C823

                *-----------------------------------------------------------------------*
                *       F3BC    Mov_Draw_VL                                             *
                *       F3BE    Mov_Draw_VL_d                                           *
                *                                                                       *
                * This routine moves to the first location specified in vector list,    *
                * and then draws lines between the rest of coordinates in the list.     *
                * The vector list has the following format:                             *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * Draw_VL_d starts at the (y,x) coordinates specified in the D register *
                * and ignores the first pair of coordinates in the vector list.         *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       $C823 = number of vectors to draw                               *
                *       D-reg = start coordinate (Draw_VL_d only)                       *
                *       X-reg points to the vector list (2,X for Mov_Draw_VL_d)         *
                *                                                                       *
                * EXIT: $C823 is cleared                                                *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3BC=EC84       Mov_Draw_VL:    LDD     ,X              Get next coordinate pair
F3BE=9701       Mov_Draw_VL_d:  STA     <VIA_port_a     Send Y to A/D
F3C0 0F00                       CLR     <VIA_port_b     Enable mux
F3C2 3002                       LEAX    2,X             Point to next coordinate pair
F3C4 12                         NOP                     Wait a moment
F3C5 0C00                       INC     <VIA_port_b     Disable mux
F3C7 D701                       STB     <VIA_port_a     Send X to A/D
F3C9 CC0000                     LDD     #$0000          Shift reg=0 (no draw), T1H=0
F3CC 201F                       BRA     LF3ED           A->D00A, B->D005

                *-----------------------------------------------------------------------*
                *       F3CE    Draw_VLc                                                *
                *                                                                       *
                * This routine draws vectors between the set of (y,x) points pointed    *
                * to by the X register.  The number of vectors to draw is specified     *
                * as the first byte in the vector list.  The current scale factor is    *
                * used.  The vector list has the following format:                      *
                *                                                                       *
                *       count, rel y, rel x, rel y, rel x, ...                          *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3CE=A680       Draw_VLc:       LDA     ,X+
F3D0 2008                       BRA     Draw_VL_a

                *-----------------------------------------------------------------------*
                *       F3D2    Draw_VL_b                                               *
                *                                                                       *
                * This routine draws vectors between the set of (y,x) points pointed to *
                * by the X register.  The vector list has the following format:         *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       B-reg = the scale factor                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3D2=D704       Draw_VL_b:      STB     <VIA_t1_cnt_lo  Set scale factor
F3D4 2007                       BRA     Draw_VL

                *-----------------------------------------------------------------------*
                *       F3D6    Draw_VLcs                                               *
                *                                                                       *
                * This routine draws vectors between the set of (y,x) points pointed    *
                * to by the X register.  The number of vectors to draw is specified     *
                * as the first byte in the vector list.  The scale factor is specified  *
                * as the second byte in the vector list. The vector list has the        *
                * following format:                                                     *
                *                                                                       *
                *       count, scale, rel y, rel x, rel y, rel x, ...                   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3D6=EC81       Draw_VLcs:      LDD     ,X++

                *-----------------------------------------------------------------------*
                *       F3D8    Draw_VL_ab                                              *
                *                                                                       *
                * This routine draws vectors between the set of (y,x) points pointed    *
                * to by the X register.  The vector list has the following format:      *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = the number of vectors to draw                           *
                *       B-reg = the scale factor                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3D8=D704       Draw_VL_ab:     STB     <VIA_t1_cnt_lo

                *-----------------------------------------------------------------------*
                *       F3DA    Draw_VL_a                                               *
                *                                                                       *
                * This routine draws vectors between the set of (y,x) points pointed    *
                * to by the register.  The current scale factor is used.  The vector    *
                * list has the following format:                                        *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = the number of vectors to draw                           *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3DA=B7C823     Draw_VL_a:      STA     $C823

                *-----------------------------------------------------------------------*
                *       F3DD    Draw_VL                                                 *
                *                                                                       *
                * This routine draws vectors between the set of (y,x) points pointed    *
                * to by the X register.  The number of vectors to draw must already be  *
                * specified in $C823.  The current scale factor is used.  The vector    *
                * list has the following format:                                        *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3DD=EC84       Draw_VL:        LDD     ,X

                *-----------------------------------------------------------------------*
                *       F3DF    Draw_Line_d                                             *
                *                                                                       *
                * This routine will draw a line from the current pen position, to the   *
                * point specified by the (y,x) pair specified in the D register.  The   *
                * current scale factor is used.  Before calling this routine, $C823     *
                * should be = 0, so that only the one vector will be drawn.             *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       A-reg = relative y position                                     *
                *       B-reg = relative x position                                     *
                *                                                                       *
                * EXIT: X-reg is incremented by 2                                       *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F3DF=9701       Draw_Line_d     STA     <VIA_port_a     Send Y to A/D
F3E1 0F00                       CLR     <VIA_port_b     Enable mux
F3E3 3002                       LEAX    2,X             Point to next coordinate pair
F3E5 12                         NOP                     Wait a moment
F3E6 0C00                       INC     <VIA_port_b     Disable mux
F3E8 D701                       STB     <VIA_port_a     Send X to A/D
F3EA CCFF00                     LDD     #$FF00          Shift reg=$FF (solid line), T1H=0
F3ED=970A       LF3ED           STA     <VIA_shift_reg  Put pattern in shift register
F3EF D705                       STB     <VIA_t1_cnt_lo  Set T1H (scale factor?)
F3F1 CC0040                     LDD     #$0040          B-reg = T1 interrupt bit
F3F4=D50D       LF3F4           BITB    <VIA_int_flags  Wait for T1 to time out
F3F6 27FC                       BEQ     LF3F4
F3F8 12                         NOP                     Wait a moment more
F3F9 970A                       STA     <VIA_shift_reg  Clear shift register (blank output)
F3FB B6C823                     LDA     $C823           Decrement line count
F3FE 4A                         DECA
F3FF 2AD9                       BPL     Draw_VL_a       Go back for more points
F401 7EF34F                     JMP     Check0Ref       Reset zero reference if necessary

                *-----------------------------------------------------------------------*
                *       F404    Draw_VLp_FF                                             *
                *       F408    Draw_VLp_7F                                             *
                *                                                                       *
                * These routines force the scale factor to 0xFF or 0x7F, and then       *
                * process the vector list pointed to by the X register.  The vector     *
                * list has the following format:                                        *
                *                                                                       *
                *       pattern, rel y, rel x                                           *
                *       pattern, rel y, rel x                                           *
                *          .      .      .                                              *
                *          .      .      .                                              *
                *       pattern, rel y, rel x                                           *
                *       0x01                                                            *
                *                                                                       *
                * The list is terminated by a pattern byte with the high bit cleared.   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to the terminator byte                             *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F404=C6FF       Draw_VLp_FF:    LDB     #$FF
F406 2006                       BRA     Draw_VLp_b

F408=C67F       Draw_VLp_7F:    LDB     #$7F
F40A 2002                       BRA     Draw_VLp_b

                *-----------------------------------------------------------------------*
                *       F40C    Draw_VLp_scale                                          *
                *                                                                       *
                * This routine processes the vector list pointed to by the X register.  *
                * The first byte in the vector list is the scale factor.  The vector    *
                * list has the following format:                                        *
                *                                                                       *
                *       scale                                                           *
                *       pattern, rel y, rel x                                           *
                *       pattern, rel y, rel x                                           *
                *          .      .      .                                              *
                *          .      .      .                                              *
                *       pattern, rel y, rel x                                           *
                *       0x01                                                            *
                *                                                                       *
                * The list is terminated by a pattern byte with the high bit cleared.   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to the terminator byte                             *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F40C=E680       Draw_VLp_scale: LDB     ,X+

                *-----------------------------------------------------------------------*
                *       F40E    Draw_VLp_b                                              *
                *                                                                       *
                * This routine draws patterned lines using the vector list pointed to   *
                * by the X register.  The vector list has the following format:         *
                *                                                                       *
                *       pattern, rel y, rel x                                           *
                *       pattern, rel y, rel x                                           *
                *          .      .      .                                              *
                *          .      .      .                                              *
                *       pattern, rel y, rel x                                           *
                *       0x01                                                            *
                *                                                                       *
                * The list is terminated by a pattern byte with the high bit cleared.   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       B-reg = the scale factor                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to the terminator byte                             *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F40E=D704       Draw_VLp_b:     STB     <VIA_t1_cnt_lo  Set scale factor

                *-----------------------------------------------------------------------*
                *       F410    Draw_VLp                                                *
                *                                                                       *
                * This routine draws patterned lines using the vector list pointed to   *
                * by the X-register.  The current scale factor is used.  The vector     *
                *list has the following format:                                         *
                *                                                                       *
                *       pattern, rel y, rel x                                           *
                *       pattern, rel y, rel x                                           *
                *          .      .      .                                              *
                *          .      .      .                                              *
                *       pattern, rel y, rel x                                           *
                *       0x01                                                            *
                *                                                                       *
                * The list is terminated by a pattern byte with the high bit cleared.   *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *                                                                       *
                * EXIT: X-reg points to the terminator byte                             *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F410=EC01       Draw_VLp:       LDD     1,X             Get next coordinate pair
F412 9701                       STA     <VIA_port_a     Send Y to A/D
F414 0F00                       CLR     <VIA_port_b     Enable mux
F416 A684                       LDA     ,X              Get pattern byte?
F418 3003                       LEAX    3,X             Advance to next point in list
F41A 0C00                       INC     <VIA_port_b     Disable mux
F41C D701                       STB     <VIA_port_a     Send X to A/D
F41E 970A                       STA     <VIA_shift_reg  Store pattern in shift register
F420 0F05                       CLR     <VIA_t1_cnt_lo  Clear T1H
F422 CC0040                     LDD     #$0040          B-reg = T1 interrupt bit
F425=D50D       LF425           BITB    <VIA_int_flags  Wait for T1 to time out
F427 27FC                       BEQ     LF425
F429 12                         NOP                     Wait a moment more
F42A 970A                       STA     <VIA_shift_reg  Clear shift register (blank output)
F42C A684                       LDA     ,X              Get next pattern byte
F42E 2FE0                       BLE     Draw_VLp        Go back if high bit of pattern is set
F430 7EF34F                     JMP     Check0Ref

                *-----------------------------------------------------------------------*
                *       F434    Draw_Pat_VL_a                                           *
                *       F437    Draw_Pat_VL                                             *
                *       F439    Draw_Pat_VL_d                                           *
                *                                                                       *
                * All of these routines draw a series of patterned vectors.  The        *
                * pattern to use must already be specified in $C829.  When using        *
                * Draw_Pat_VL or Draw_Pat_VL_d, the number of vectors to draw minus 1   *
                * must be specified in $C823; when using Draw_Pat_VL_a, the number of   *
                * vectors to draw minus 1 must be passed in in the A register.          *
                * The vector list, pointed to by the X register, has the following      *
                * format:                                                               *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * Draw_Pat_VL_d starts at the (y,x) coordinates specified in the        *
                * D register and ignores the first pair of coordinates in the vector    *
                * list.                                                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *       A-reg = the number of vectors to draw (Draw_Pat_VL_a only)      *
                *       D-reg = start                                                   *
                *       $C829 contains the line pattern.                                *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F433=4A         LF433           DECA
F434=B7C823     Draw_Pat_VL_a:  STA     $C823
F437=EC84       Draw_Pat_VL:    LDD     ,X              Get next coordinate pair
F439=9701       Draw_Pat_VL_d:  STA     <VIA_port_a     Send Y to A/D
F43B 0F00                       CLR     <VIA_port_b     Enable mux
F43D 3002                       LEAX    2,X             Point to next coordinate pair
F43F 0C00                       INC     <VIA_port_b     Disable mux
F441 D701                       STB     <VIA_port_a     Send X to A/D
F443 B6C829                     LDA     Vec_Pattern     Get default pattern
F446 C640                       LDB     #$40            B-reg = T1 interrupt bit
F448 970A                       STA     <VIA_shift_reg  Put pattern in shift register
F44A 0F05                       CLR     <VIA_t1_cnt_lo  Clear T1H (scale factor?)
F44C F5D00D                     BITB    VIA_int_flags   Check if T1 timed out (note wasted byte)
F44F 270B                       BEQ     LF45C           Update pattern if not

                *               Don't reset the zero reference if last line is really short?

F451 0F0A                       CLR     <VIA_shift_reg  Clear shift register (blank output)
F453 B6C823                     LDA     $C823           Get line counter
F456 26DB                       BNE     LF433           Go back for more points
F458 39                         RTS

                *               This code is for lines that are not really short lines

F459=B6C829     LF459           LDA     Vec_Pattern     Get default pattern
F45C=970A       LF45C           STA     <VIA_shift_reg  Update pattern register
F45E 12                         NOP                     Wait a moment
F45F D50D                       BITB    <VIA_int_flags  Check if T1 timed out
F461 27F6                       BEQ     LF459           Update pattern again if not
F463 B6C823                     LDA     $C823           Get line counter
F466 0F0A                       CLR     <VIA_shift_reg  Clear shift register (blank output)
F468 4D                         TSTA                    Go back if more lines to draw
F469 26C8                       BNE     LF433
F46B 7EF34F                     JMP     Check0Ref       Reset zero reference if necessary

                *-----------------------------------------------------------------------*
                *       F46E    Draw_VL_mode                                            *
                *                                                                       *
                * This routine processes the vector list pointed to by the X register.  *
                * The current scale factor is used.  The vector list has the following  *
                * format:                                                               *
                *                                                                       *
                *       mode, rel y, rel x,                                             *
                *       mode, rel y, rel x,                                             *
                *        .      .      .                                                *
                *        .      .      .                                                *
                *       mode, rel y, rel x,                                             *
                *       0x01                                                            *
                *                                                                       *
                * where mode has the following meaning:                                 *
                *                                                                       *
                *       < 0  use the pattern in $C829                                   *
                *       = 0  move to specified endpoint                                 *
                *       = 1  end of list, so return                                     *
                *       > 1  draw to specified endpoint                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       X-reg points to the vector list                                 *
                *       $C829 contains the line pattern.                                *
                *                                                                       *
                * EXIT: X-reg points to next byte after terminator                      *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F46E=B6C824     Draw_VL_mode:   LDA     Vec_0Ref_Enable Save old Check0Ref flag
F471 3402                       PSHS    A
F473 7FC824                     CLR     Vec_0Ref_Enable Don't reset the zero reference yet
F476=A680       LF476           LDA     ,X+             Get the next mode byte
F478 2A04                       BPL     LF47E
F47A 8DBB                       BSR     Draw_Pat_VL     If <0, draw a patterned line
F47C 20F8                       BRA     LF476

F47E=2605       LF47E           BNE     LF485
F480 BDF3BC                     JSR     Mov_Draw_VL     If =0, move to the next point
F483 20F1                       BRA     LF476

F485=4A         LF485           DECA
F486 2705                       BEQ     LF48D
F488 BDF3DD                     JSR     Draw_VL         If <>1, draw a solid line
F48B 20E9                       BRA     LF476

F48D=3502       LF48D           PULS    A               If =1, exit
F48F B7C824                     STA     Vec_0Ref_Enable Restore old Check0Ref flag
F492 7EF34F                     JMP     Check0Ref       Reset zero reference if necessary

                *-----------------------------------------------------------------------*
                *       F495    Print_Str                                               *
                *                                                                       *
                * This is the routine which does the actual printing of a string.  The  *
                * U register points to the start of the string, while $C82A contains    *
                * the height of the character, cell, and $C82B contains the width of    *
                * the character cell.  The string is terminated with an 0x80.           *
                *                                                                       *
                * The string is displayed by drawing 7 horizontal rows of dots.  The    *
                * first row is drawn for each character, then the second, etc.  The     *
                * character generation table is located at ($F9D4 + $20).  Only         *
                * characters 0x20-0x6F (upper case) are defined; the lower case         *
                * characters a-o produce special icons.                                 *
                *                                                                       *
                * ENTRY DP = $D0                                                        *
                *       U-reg points to the start of the string                         *
                *                                                                       *
                * EXIT: U-reg points to next byte after terminator                      *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F495=FFC82C     Print_Str:      STU     Vec_Str_Ptr     Save string pointer
F498 8EF9D4                     LDX     #Char_Table-$20 Point to start of chargen bitmaps
F49B CC1883                     LDD     #$1883          $8x = enable RAMP?
F49E 0F01                       CLR     <VIA_port_a     Clear D/A output
F4A0 970B                       STA     <VIA_shift_reg  Shift reg mode = 110, T1 PB7 enabled
F4A2 8EF9D4                     LDX     #Char_Table-$20 Point to start of chargen bitmaps
F4A5=D700       LF4A5           STB     <VIA_port_b     Update RAMP, set mux to channel 1
F4A7 0A00                       DEC     <VIA_port_b     Enable mux
F4A9 CC8081                     LDD     #$8081
F4AC 12                         NOP                     Wait a moment
F4AD 0C00                       INC     <VIA_port_b     Disable mux
F4AF D700                       STB     <VIA_port_b     Enable RAMP, set mux to channel 0
F4B1 9700                       STA     <VIA_port_b     Enable mux
F4B3 7DC800                     TST     $C800           I think this is a delay only
F4B6 0C00                       INC     <VIA_port_b     Enable RAMP, disable mux
F4B8 B6C82B                     LDA     Vec_Text_Width  Get text width
F4BB 9701                       STA     <VIA_port_a     Send it to the D/A
F4BD CC0100                     LDD     #$0100
F4C0 FEC82C                     LDU     Vec_Str_Ptr     Point to start of text string
F4C3 9700                       STA     <VIA_port_b     Disable RAMP, disable mux
F4C5 2004                       BRA     LF4CB

F4C7=A686       LF4C7           LDA     A,X             Get bitmap from chargen table
F4C9 970A                       STA     <VIA_shift_reg  Save in shift register
F4CB=A6C0       LF4CB           LDA     ,U+             Get next character
F4CD 2AF8                       BPL     LF4C7           Go back if not terminator
F4CF 8681                       LDA     #$81
F4D1 9700                       STA     <VIA_port_b     Enable RAMP, disable mux
F4D3 0001                       NEG     <VIA_port_a     Negate text width to D/A
F4D5 8601                       LDA     #$01
F4D7 9700                       STA     <VIA_port_b     Disable RAMP, disable mux
F4D9 8CFBB4                     CMPX    #Char_Table_End-$20     Check for last row
F4DC 272C                       BEQ     LF50A           Branch if last row
F4DE 308850                     LEAX    $50,X           Point to next chargen row
F4E1 1F30                       TFR     U,D             Get string length
F4E3 B3C82C                     SUBD    Vec_Str_Ptr
F4E6 C002                       SUBB    #$02              - 2
F4E8 58                         ASLB                      * 2
F4E9 2100                       BRN     LF4EB           Delay a moment
F4EB=8681       LF4EB           LDA     #$81
F4ED 12                         NOP
F4EE 5A                         DECB
F4EF 26FA                       BNE     LF4EB           Delay some more in a loop
F4F1 9700                       STA     <VIA_port_b     Enable RAMP, disable mux
F4F3 F6C82A                     LDB     Vec_Text_Height Get text height
F4F6 D701                       STB     <VIA_port_a     Store text height in D/A
F4F8 0A00                       DEC     <VIA_port_b     Enable mux
F4FA CC8101                     LDD     #$8101
F4FD 12                         NOP                     Wait a moment
F4FE 9700                       STA     <VIA_port_b     Enable RAMP, disable mux
F500 0F01                       CLR     <VIA_port_a     Clear D/A
F502 D700                       STB     <VIA_port_b     Disable RAMP, disable mux
F504 9700                       STA     <VIA_port_b     Enable RAMP, disable mux
F506 C603                       LDB     #$03            $0x = disable RAMP?
F508 209B                       BRA     LF4A5           Go back for next scan line

F50A=8698       LF50A           LDA     #$98
F50C 970B                       STA     <VIA_shift_reg  T1->PB7 enabled
F50E 7EF354                     JMP     Reset0Ref       Reset the zero reference

                *-----------------------------------------------------------------------*
                *       F511    Random_3                                                *
                *       F517    Random                                                  *
                *                                                                       *
                * This routine generates a random 1-byte number, and places it in the   *
                * A register.  Random_3 runs through the random number generator        *
                * algorithm three times.  The random number seed is stored in the       *
                * three bytes pointed to by $C87B.                                      *
                *                                                                       *
                * EXIT: A-reg contains the generated random number                      *
                *                                                                       *
                *       All other registers are preserved.                              *
                *-----------------------------------------------------------------------*

F511=3414       Random_3:       PSHS    B,X
F513 C602                       LDB     #$02
F515 2003                       BRA     LF51A

F517=3414       Random:         PSHS    B,X
F519 5F                         CLRB
F51A=BEC87B     LF51A           LDX     Vec_Seed_Ptr
F51D=A601       LF51D           LDA     1,X
F51F 49                         ROLA
F520 49                         ROLA
F521 49                         ROLA
F522 49                         ROLA
F523 A802                       EORA    2,X
F525 46                         RORA
F526 6984                       ROL     ,X
F528 6901                       ROL     1,X
F52A 6902                       ROL     2,X
F52C 5A                         DECB
F52D 2AEE                       BPL     LF51D
F52F A684                       LDA     ,X
F531 3594                       PULS    B,X,PC

                *-----------------------------------------------------------------------*
                *       F533    Init_Music_Buf                                          *
                *                                                                       *
                * This routine clears out the music work buffer, located at             *
                * $C83F-$C84C.                                                          *
                *                                                                       *
                *       X-reg, D-reg trashed                                            *
                *-----------------------------------------------------------------------*

F533=C60D       Init_Music_Buf: LDB     #$0D
F535 8EC83F                     LDX     #Vec_Music_Work
F538 8D05                       BSR     Clear_x_b
F53A 863F                       LDA     #$3F
F53C A706                       STA     6,X
F53E 39                         RTS

                *-----------------------------------------------------------------------*
                *       F53F    Clear_x_b                                               *
                *                                                                       *
                * This routine clears to 0 the block of memory starting at the          *
                * address contained in the X register, and continuing for the number    *
                * of bytes specified by B+1.                                            *
                *                                                                       *
                * ENTRY X-reg points to the start of the RAM to be cleared.             *
                *       B-reg = number of bytes minus 1 to clear.                       *
                *                                                                       *
                * EXIT: D-reg = $FFFF                                                   *
                *-----------------------------------------------------------------------*

F53F=4F         Clear_x_b:      CLRA
F540 2006                       BRA     Clear_x_d

                *-----------------------------------------------------------------------*
                *       F542    Clear_C8_RAM    (never used by GCE carts?)              *
                *                                                                       *
                * This routine clears to 0 the block of memory in the range             *
                * $C800-$C8FF.                                                          *
                *                                                                       *
                * EXIT: X-reg = $C800                                                   *
                *       D-reg = $FFFF                                                   *
                *-----------------------------------------------------------------------*

F542=8EC800     Clear_C8_RAM:   LDX     #$C800

                *-----------------------------------------------------------------------*
                *       F545    Clear_x_256                                             *
                *       F548    Clear_x_d                                               *
                *                                                                       *
                * This routine clears the block of memory starting at the contained     *
                * in the X register to zero.                                            *
                *                                                                       *
                * ENTRY X-reg points to the start of RAM to be cleared                  *
                *       D-reg = number of bytes to clear minus 1 (Clear_x_d only)       *
                *                                                                       *
                * EXIT: D-reg = $FFFF                                                   *
                *-----------------------------------------------------------------------*

F545=CC00FF     Clear_x_256:    LDD     #$00FF
F548=6F8B       Clear_x_d:      CLR     D,X
F54A 830001                     SUBD    #$0001
F54D 2AF9                       BPL     Clear_x_d
F54F 39                         RTS

                *-----------------------------------------------------------------------*
                *       F550    Clear_x_b_80                                            *
                *       F552    Clear_x_b_a                                             *
                *                                                                       *
                * This routine sets the block of memory pointed to by the X register    *
                * to $80 or the A register.  The B register specifies the number of     *
                * bytes to be cleared.                                                  *
                *                                                                       *
                * ENTRY A-reg = byte to be stored (Clear_x_b_a only)                    *
                *       B-reg = number of bytes to clear ($00 = 256)                    *
                *       X-reg points to start of memory block to clear                  *
                *                                                                       *
                * EXIT: A-reg = $80 (Clear_x_b_80 only)                                 *
                *       B-reg = $00                                                     *
                *                                                                       *
                *       All other registers preserved.                                  *
                *-----------------------------------------------------------------------*

F550=8680       Clear_x_b_80:   LDA     #$80
F552=A785       Clear_x_b_a:    STA     B,X
F554 5A                         DECB
F555 26FB                       BNE     Clear_x_b_a
F557 A784                       STA     ,X
F559 39                         RTS

                *-----------------------------------------------------------------------*
                *       F55A    Dec_3_Counters                                          *
                *       F55E    Dec_6_Counters                                          *
                *                                                                       *
                * These routines check either the first three or all
                * six of the default counters at $C82E-$C833 and
                * decrements those which are not already zero.
                *                                                                       *
                * EXIT: X-reg points to the default counters at $C82E
                *       B-reg = $FF                                     *
                *                                                                       *
                *       All other registers preserved.                                  *
                *-----------------------------------------------------------------------*

F55A=C602       Dec_3_Counters: LDB     #$02
F55C 2002                       BRA     LF560

F55E=C605       Dec_6_Counters: LDB     #$05
F560=8EC82E     LF560           LDX     #Vec_Counters

                *-----------------------------------------------------------------------*
                *       F563    Dec_Counters                                            *
                *                                                                       *
                * This routine checks the counters pointed to by the X register and     *
                * decrements those which are not already zero.                          *
                *                                                                       *
                * ENTRY B-reg = number of counters minus 1                              *
                *       X-reg points to counter bytes                                   *
                *                                                                       *
                * EXIT: B-reg = $FF                                                     *
                *                                                                       *
                *       All other registers preserved.                                  *
                *-----------------------------------------------------------------------*

F563=6D85       Dec_Counters:   TST     B,X
F565 2702                       BEQ     LF569
F567 6A85                       DEC     B,X
F569=5A         LF569           DECB
F56A 2AF7                       BPL     Dec_Counters
F56C 39                         RTS

                *-----------------------------------------------------------------------*
                *       F56D    Delay_3         30 cycles                               *
                *       F571    Delay_2         25 cycles                               *
                *       F575    Delay_1         20 cycles                               *
                *       F579    Delay_0         12 cycles                               *
                *       F57A    Delay_b         5*B + 10 cycles                         *
                *       F57D    Delay_RTS       5 cycles                                *
                *                                                                       *
                * Each of these routines loads the B-register with the indicated        *
                * value, and then loops until the B register value has decremented      *
                * below zero.  Delay_RTS is just an RTS instruction, but at least       *
                * one GCE cartridge calls it.                                           *
                *                                                                       *
                * Cycle counts do not include timing of the instructions used to        *
                * call the delay routines.                                              *
                *                                                                       *
                * ENTRY B-reg = delay count (Delay_b only)                              *
                *                                                                       *
                * EXIT: B-reg = $FF (except Delay_RTS)                                  *
                *-----------------------------------------------------------------------*

F56D=C603       Delay_3:        LDB     #$03            2 cycles
F56F 2009                       BRA     Delay_b         3 cycles

F571=C602       Delay_2:        LDB     #$02            2 cycles
F573 2005                       BRA     Delay_b         3 cycles

F575=C601       Delay_1:        LDB     #$01            2 cycles
F577 2001                       BRA     Delay_b         3 cycles

F579=5F         Delay_0:        CLRB                    2 cycles
F57A=5A         Delay_b:        DECB                    2 cycles
F57B 2AFD                       BPL     Delay_b         3 cycles
F57D 39         Delay_RTS:      RTS                     5 cycles

                *-----------------------------------------------------------------------*
                *       F57E    Bitmask_a                                               *
                *                                                                       *
                * This routine takes a bit number, specified in the A register, and     *
                * returns a bit mask with only the specified bit set.                   *
                *                                                                       *
                * ENTRY A-reg contains the bit number                                   *
                *                                                                       *
                * EXIT: A-reg contains the bit mask                                     *
                *                                                                       *
                *       X-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F57E=8EF9DC     Bitmask_a:      LDX     #Bit_Masks
F581 A686                       LDA     A,X
F583 39                         RTS

                *-----------------------------------------------------------------------*
                *       F584    Abs_a_b                                                 *
                *       F58B    Abs_b                                                   *
                *                                                                       *
                * This routine returns the absolute value of the two single byte        *
                * numbers passed in in the A and B registers.  Abs_b only uses the B    *
                * register.  There is a special case: 0x80 is returned as 0x7F.         *
                *                                                                       *
                * ENTRY A-reg contains first value                                      *
                *       B-reg contains second value (Abs_a_b only)                      *
                *                                                                       *
                * EXIT: A-reg contains absolute value of first value                    *
                *       B-reg contains absolute value of second value (Abs_a_b only)    *
                *                                                                       *
                *       All other registers preserved.                                  *
                *-----------------------------------------------------------------------*

F584=4D         Abs_a_b:        TSTA
F585 2A04                       BPL     Abs_b
F587 40                         NEGA
F588 2801                       BVC     Abs_b
F58A 4A                         DECA
F58B=5D         Abs_b           TSTB
F58C 2A04                       BPL     LF592
F58E 50                         NEGB
F58F 2801                       BVC     LF592
F591 5A                         DECB
F592=39         LF592           RTS

                *-----------------------------------------------------------------------*
                *       F593    Rise_Run_Angle                                          *
                *                                                                       *
                * Given a (rise,run) pair, this routine calculates the angle which      *
                * corresponds to that (rise,run) pair.  The returned angle is relative  *
                * to the x-axis (+ is CCW), so to convert it to a Vectrex angle         *
                * (relative to the y-axis, + is CCW), you must subtract the number 0x10 *
                * (90 degrees) from the returned value.                                 *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       A-reg = rise value                                              *
                *       B-reg = run value                                               *
                *                                                                       *
                * EXIT: A-reg = the angle from the x-axis                               *
                *       B-reg = the angle from the x-axis                               *
                *                                                                       *
                *       All other registers preserved.                                  *
                *-----------------------------------------------------------------------*

F593=3410       Rise_Run_Angle: PSHS    X
F595 DD34                       STD     <Vec_RiseRun_Tmp
F597 59                         ROLB
F598 C600                       LDB     #$00
F59A 59                         ROLB
F59B 49                         ROLA
F59C 59                         ROLB
F59D 58                         ASLB
F59E D736                       STB     <Vec_Angle
F5A0 DC34                       LDD     <Vec_RiseRun_Tmp
F5A2 8DE0                       BSR     Abs_a_b
F5A4 9734                       STA     <Vec_RiseRun_Tmp
F5A6 D134                       CMPB    <Vec_RiseRun_Tmp
F5A8 2308                       BLS     LF5B2
F5AA 0C36                       INC     <Vec_Angle
F5AC 1E89                       EXG     A,B
F5AE 2002                       BRA     LF5B2

F5B0=44         LF5B0           LSRA
F5B1 54                         LSRB
F5B2=8109       LF5B2           CMPA    #$09
F5B4 22FA                       BHI     LF5B0
F5B6 DD34                       STD     <Vec_RiseRun_Tmp
F5B8 D636                       LDB     <Vec_Angle
F5BA 8EFC24                     LDX     #DFC24
F5BD E685                       LDB     B,X
F5BF 8EFC2C                     LDX     #DFC2C
F5C2 A686                       LDA     A,X
F5C4 9B35                       ADDA    <$C835
F5C6 8B0A                       ADDA    #$0A
F5C8 C501                       BITB    #$01
F5CA 2604                       BNE     LF5D0
F5CC EB86                       ADDB    A,X
F5CE 2003                       BRA     LF5D3

F5D0=5A         LF5D0           DECB
F5D1 E086                       SUBB    A,X
F5D3=D736       LF5D3           STB     <Vec_Angle
F5D5 9636                       LDA     <Vec_Angle
F5D7 3590                       PULS    X,PC

                *-----------------------------------------------------------------------*
                *       F5D9    Get_Rise_Idx                                            *
                *       F5DB    Get_Run_Idx                                             *
                *                                                                       *
                * These routines are responsible for generating the two index pairs     *
                * which are required by the rest of the rotation routines.  Each index  *
                * pair is two bytes long, and has the following format:                 *
                *                                                                       *
                *       The high byte is obtained by masking the anglewith 0x1F (this   *
                *       forces the angle to be between 0 and 180 degrees), and then     *
                *       using this value to index into the multiplier table.            *
                *                                                                       *
                *       The lower byte contains information about whether the angle     *
                *       lies along either the x or y axis, and whether the rise/run     *
                *       will be positive or negative.                                   *
                *                                                                       *
                *               0 => positive rise, not on an axis, or                  *
                *                    negative run, not on an axis.                      *
                *            0x80 => negative rise, not on an axis, or                  *
                *                    positive run, not on an axis.                      *
                *               1 => positive rise, on an axis, or                      *
                *                    negative run, on an axis.                          *
                *            0x81 => negative rise, on an axis, or                      *
                *                    positive run, on an axis.                          *
                *                                                                       *
                * ENTRY A-reg = the angle value                                         *
                *                                                                       *
                * EXIT: A-reg = slope?                                                  *
                *       B-reg = slope direction?                                        *
                *                                                                       *
                *       X-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F5D9=8B10       Get_Rise_Idx:   ADDA    #$10            Offset angle by 90 degrees
F5DB=8EFC6D     Get_Run_Idx:    LDX     #DFC6D          Get address of slope table
F5DE 5F                         CLRB
F5DF 8520                       BITA    #$20            If angle in 180-360,
F5E1 2702                       BEQ     LF5E5
F5E3 C680                       LDB     #$80              flag negative rise or positive run
F5E5=841F       LF5E5           ANDA    #$1F            Mask to multiple of 180 degrees
F5E7 8110                       CMPA    #$10            If 90 degrees
F5E9 2601                       BNE     LF5EC
F5EB 5C                         INCB                      then rise or run is on an axis
F5EC=A686       LF5EC           LDA     A,X             Get slope from slope table
F5EE 39                         RTS

                *-----------------------------------------------------------------------*
                *       F5EF    Get_Rise_Run                                            *
                *                                                                       *
                * This routine gets the index pair for both the rise and run, using     *
                * the passed-in angle value.                                            *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       $C836 contains the angle value                                  *
                *                                                                       *
                * EXIT: $C837-$C838 contains the index pair for the run                 *
                *       $C839-$C83A contains the index pair for the rise                *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F5EF=3410       Rise_Run_Idx:   PSHS    X               Save X-reg
F5F1 9636                       LDA     <Vec_Angle      Get angle
F5F3 8DE6                       BSR     Get_Run_Idx     Get run index pair for angle
F5F5 DD37                       STD     <Vec_Run_Index
F5F7 9636                       LDA     <Vec_Angle      Get angle
F5F9 8DDE                       BSR     Get_Rise_Idx    Get rise index pair for angle
F5FB DD39                       STD     <Vec_Rise_Index
F5FD 3590                       PULS    X,PC            Restore X-reg and return

                *-----------------------------------------------------------------------*
                *       F5FF    Rise_Run_X                                              *
                *       F601    Rise_Run_Y                                              *
                *       F603    Rise_Run_Len                                            *
                *                                                                       *
                * This routine takes an angle value which is relative to the x- or      *
                * y-axis, and calculates the rise and run for that angle, relative to a *
                * passed-in scalar velocity value.  A large scalar value will cause an  *
                * object to move quickly, while a small scalar value will cause an      *
                * object to move more slowly.                                           *
                *                                                                       *
                * Keep in mind that most games store x & y coordinates as 2 bytes each, *
                * with the upper byte being the actual coordinate, and the lower byte   *
                * being that which is usually added to the rise/run value; when the     *
                * lower byte overflows into the hi byte, then the object will 'move'.   *
                * The rise/run values returned here are meant to be added to the low    *
                * byte -- NOT the hi byte!!                                             *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       A-reg = the scalar velocity value (except Rise_Run_Len)         *
                *       B-reg = the Vectrex angle value                                 *
                *                                                                       *
                * EXIT: A-reg = the rise value                                          *
                *       B-reg = the run value                                           *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F5FF=C010       Rise_Run_X:     SUBB    #$10
F601=D736       Rise_Run_Y:     STB     <Vec_Angle
F603=973B       Rise_Run_Len:   STA     <Vec_RiseRun_Len
F605 8DE8                       BSR     Rise_Run_Idx    Get index pair of angle
F607 8D54                       BSR     Xform_Run       Get run value
F609 40                         NEGA
F60A 3402                       PSHS    A               Save run value
F60C 8D55                       BSR     Xform_Rise      Get rise value
F60E 3584                       PULS    B,PC            Restore run value and return

                *-----------------------------------------------------------------------*
                *       F610    Rot_VL_ab                                               *
                *       F616    Rot_VL                                                  *
                *                                                                       *
                * This routine rotates a vector list of length 'n+1', where 'n' is      *
                * specified by the value in the B register.  The A register contains    *
                * the rotation value, and the X contains a pointer to the vector list.  *
                * The U register contains a pointer to a buffer into which the          *
                * transformed points are to be saved.  The vector list has the          *
                * following format:                                                     *
                *                                                                       *
                *       rel y, rel x, rel y, rel x, ...                                 *
                *                                                                       *
                * ENTRY A-reg = rotation angle value (Rot_VL_ab only)                   *
                *       $C836 = rotation angle value (Rot_VL only)                      *
                *       B-reg = number of points - 1 (Rot_VL_ab only)                   *
                *       $C823 = number of points - 1 (Rot_VL only)                      *
                *       X-reg points to original vector list                            *
                *       U-reg points to rotated vector list                             *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *       U-reg points to next byte after rotated list                    *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F610=B7C836     Rot_VL_ab:      STA     Vec_Angle
F613 F7C823                     STB     $C823
F616=3408       Rot_VL:         PSHS    DP
F618 BDF1AF                     JSR     DP_to_C8
F61B 8DD2                       BSR     Rise_Run_Idx
F61D 2018                       BRA     LF637

                *-----------------------------------------------------------------------*
                *       F61F    Rot_VL_Mode                                             *
                *       F62B    Rot_VL_M_dft                                            *
                *                                                                       *
                * This routine rotates a vector list having the following format:       *
                *                                                                       *
                *       mode, rel y, rel x,                                             *
                *       mode, rel y, rel x,                                             *
                *         .     .      .                                                *
                *         .     .      .                                                *
                *       mode, rel y, rel x,                                             *
                *       0x01                                                            *
                *                                                                       *
                * The A register contains the rotation value, and the X contains a      *
                * pointer to the vector list.  The U register contains a pointer to a   *
                * buffer into which the transformed points are to be saved.             *
                *                                                                       *
                * ENTRY A-reg = rotation angle value (Rot_VL_Mode only)                 *
                *       X-reg points to original vector list                            *
                *       U-reg points to rotated vector list                             *
                *                                                                       *
                * EXIT: X-reg points to next byte after list                            *
                *       U-reg points to next byte after rotated list                    *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F61F=B7C836     Rot_VL_Mode:    STA     Vec_Angle       Save angle
F622 3408                       PSHS    DP              Save DP register
F624 BDF1AF                     JSR     DP_to_C8        DP to RAM
F627 9723                       STA     <$C823          Store $C8 (negative value) into $C823
F629 8DC4                       BSR     Rise_Run_Idx    Get index pair of angle
F62B=A680       Rot_VL_M_dft:   LDA     ,X+             Get mode byte
F62D A7C0                       STA     ,U+             Copy to destination
F62F 2F06                       BLE     LF637           Rotate if not end of list
F631 0F23                       CLR     <$C823          Exit with $C823 cleared
F633 3588                       PULS    DP,PC           Restore DP register and return

F635=0A23       LF635           DEC     <$C823          Decrement count for (y,x) list
F637=A680       LF637           LDA     ,X+             Get y coordinate
F639 8D26                       BSR     Xform_Rise_a
F63B A7C4                       STA     ,U              Store partial y coordinate
F63D A684                       LDA     ,X              Get x coordinate
F63F 8D1A                       BSR     Xform_Run_a
F641 ABC4                       ADDA    ,U              Add to partial y coordinate
F643 A7C0                       STA     ,U+             Store rotated y coordinate
F645 A61F                       LDA     -1,X            Get y coordinate
F647 8D12                       BSR     Xform_Run_a
F649 A7C4                       STA     ,U              Store partial x coordinate
F64B A680                       LDA     ,X+             Get x coordinate
F64D 8D12                       BSR     Xform_Rise_a
F64F A0C4                       SUBA    ,U              Add to partial x coordinate
F651 A7C0                       STA     ,U+             Store rotated x coordinate
F653 9623                       LDA     <$C823          Get counter
F655 2BD4                       BMI     Rot_VL_M_dft    If negative, go back to mode list loop
F657 26DC                       BNE     LF635           If non-zero, go back to (y,x) list loop
F659 3588                       PULS    DP,PC

                *-----------------------------------------------------------------------*
                *       F65B    Xform_Run_a                                             *
                *       F65D    Xform_Run                                               *
                *                                                                       *
                * These two routines generate a run value, using the run index pair in  *
                * $C837-$C838.  For Xform_Run_a the scalar value is passed in the       *
                * A register, while for Xform_Run, the scalar value must already be in  *
                * $C83B.  The transformed value is return in the A register.            *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       A-reg = length for rise/run (Xform_Rise_a only)                 *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F65B=973B       Xform_Run_a:    STA     <Vec_RiseRun_Len
F65D=DC37       Xform_Run:      LDD     <Vec_Run_Index
F65F 2004                       BRA     LF665

                *-----------------------------------------------------------------------*
                *       F661    Xform_Rise_a                                            *
                *       F663    Xform_Rise                                              *
                *                                                                       *
                * These two routines generate a rise value, using the rise index pair   *
                * in $C839-$C83A.  For Xform_Rise_a the scalar value is passed in the   *
                * A register, while for Xform_Rise, the scalar value must already be    *
                * in $C83B.  The transformed value is return in the A register.         *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       A-reg = length for rise/run (Xform_Run_a only)                  *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F661=973B       Xform_Rise_a:   STA     <Vec_RiseRun_Len
F663=DC39       Xform_Rise:     LDD     <Vec_Rise_Index
F665=D73C       LF665           STB     <$C83C
F667 C501                       BITB    #$01
F669 2704                       BEQ     LF66F
F66B 963B                       LDA     <Vec_RiseRun_Len
F66D 200A                       BRA     LF679

F66F=D63B       LF66F           LDB     <Vec_RiseRun_Len
F671 2A03                       BPL     LF676
F673 033C                       COM     <$C83C
F675 50                         NEGB
F676=3D         LF676           MUL
F677 8900                       ADCA    #$00
F679=D63C       LF679           LDB     <$C83C
F67B 2A01                       BPL     LF67E
F67D 40                         NEGA
F67E=39         LF67E           RTS

                *-----------------------------------------------------------------------*
                *       F67F    Move_Mem_a_1                                            *
                *       F683    Move_Mem_a                                              *
                *                                                                       *
                * This routine copies a block of memory, starting at the hi address,    *
                * and working down to the low address.  The base of the source address  *
                * is specified in the U register, and the base of the destination       *
                * address is  specified in the X register.  The A register contains     *
                * the number of bytes to copy; 0x80 is the maximum value which can      *
                * be specified.                                                         *
                *                                                                       *
                * ENTRY A-reg = byte count (Move_Mem_a only)                            *
                *       A-reg = byte count minus 1 (Move_Mem_a_1 only)                  *
                *       X-reg points to the destination                                 *
                *       U-reg points to the source                                      *
                *                                                                       *
                * EXIT  A-reg = $FF                                                     *
                *       B-reg = first byte of source                                    *
                *-----------------------------------------------------------------------*

F67F=E6C6       Move_Mem_a_1:   LDB     A,U             Copy the byte
F681 E786                       STB     A,X
F683=4A         Move_Mem_a:     DECA                    Decrement the count
F684 2AF9                       BPL     Move_Mem_a_1    Go back until finished
F686=39         LF686           RTS

                *-----------------------------------------------------------------------*
                *       F687    Init_Music_chk                                          *
                *       F68D    Init_Music                                              *
                *       F692    Init_Music_x                                            *
                *                                                                       *
                * These routines are responsible for filling the music work buffer      *
                * while a sound is being made.  It should be called once during each    *
                * refresh cycle.  If you want to start a new sound, then you must set   *
                * $C856 to 0x01, and point the U-register to the sound block.  If no    *
                * sound is in progress ($C856 = 0), then it returns immediately         *
                * (unless you called Init_Music or Init_Music_dft, which do not make    *
                * this check).  When a sound is in progress, $C856 will be set to 0x80. *
                *                                                                       *
                * These routines process a single note at a time, and calculate the     *
                * amplitude and course/fine tuning values for the 3 sound channels.     *
                * The values calculated are stored in the music work buffer, at         *
                * $C83F-$C84C.                                                          *
                *                                                                       *
                * Music data format:                                                    *
                *                                                                       *
                *       header word -> $C84F  32 nibble ADSR table                      *
                *       header word -> $C851  8-byte "twang" table                      *
                *       data bytes                                                      *
                *                                                                       *
                * The ADSR table is simply 32 nibbles (16 bytes) of amplitude values.   *
                *                                                                       *
                * The twang table is 8 signed bytes to modify the base frequency of     *
                * each note being played.  Each channel has a different limit to its    *
                * twang table index (6-8) to keep them out of phase to each other.      *
                *                                                                       *
                * Music data bytes:                                                     *
                *       Bits 0-5 = frequency                                            *
                *       Bit 6 clear = tone                                              *
                *       Bit 6 set = noise                                               *
                *       Bit 7 set = next music data byte is for next channel            *
                *       Bit 7 clear, play note with duration in next music data byte:   *
                *               bits 0-5 = duration                                     *
                *               bit 6 = unused                                          *
                *               bit 7 set = end of music                                *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       U-reg points to the start of the music data                     *
                *       $C84D points to note table (Init_Music_dft only)                *
                *       C856 may need to be set.                                        *
                *                                                                       *
                *       D-reg, X-reg, Y-reg, U-reg trashed                              *
                *-----------------------------------------------------------------------*

F687=9656       Init_Music_chk: LDA     <Vec_Music_Flag Test sound active flag
F689 2B28                       BMI     LF6B3           Continue sound if active
F68B 27F9                       BEQ     LF686           Return if sound not active
F68D 8EFC8D     Init_Music:     LDX     #Freq_Table     Save pointer to frequency table
F690 9F4D                       STX     <Vec_Freq_Table
F692 8680       Init_Music_dft: LDA     #$80            Set sound active flag
F694 9756                       STA     <Vec_Music_Flag
F696 ECC1                       LDD     ,U++            Save address of ADSR table
F698 DD4F                       STD     <Vec_ADSR_Table
F69A ECC1                       LDD     ,U++            Save address of twang table
F69C DD51                       STD     <Vec_Twang_Table
F69E DF53                       STU     <Vec_Music_Ptr  Save pointer to music data
F6A0 BDF533                     JSR     Init_Music_Buf  Initialize music buffer
F6A3 CC1F1F                     LDD     #$1F1F
F6A6 DD5F                       STD     <Vec_ADSR_Timers+1 Init ADSR timers of chans 2 & 3
F6A8 CC0000                     LDD     #$0000
F6AB DD63                       STD     <Vec_Music_Freq+2 Clear frequency of channel 2
F6AD DD65                       STD     <Vec_Music_Freq+4 Clear frequency of channel 3
F6AF 9755                       STA     <Vec_Music_Chan A-reg = 0 (sound channel number?)
F6B1 2039                       BRA     LF6EC

                * Continue currently playing sound here

F6B3=CEC85E     LF6B3           LDU     #Vec_ADSR_Timers Get address of ADSR timers
F6B6 C602                       LDB     #$02            Count for three channels
F6B8=A6C5       LF6B8           LDA     B,U             Get the channel's ADSR timer
F6BA 811F                       CMPA    #$1F
F6BC 2702                       BEQ     LF6C0           Skip if at maximum
F6BE 6CC5                       INC     B,U             Else increment the timer
F6C0=5A         LF6C0           DECB                    Go back for the other channels
F6C1 2AF5                       BPL     LF6B8
F6C3 9E51                       LDX     <Vec_Twang_Table
F6C5 CEC858                     LDU     #Vec_Music_Twang
F6C8 8607                       LDA     #$07            Twang limit is 6-8 depending on channel
F6CA=6CC4       LF6CA           INC     ,U              Increment twang counter
F6CC A1C4                       CMPA    ,U              Check against limit
F6CE 2C02                       BGE     LF6D2
F6D0 6FC4                       CLR     ,U              Clear it if limit exceeded
F6D2=E6C0       LF6D2           LDB     ,U+             Get twang count
F6D4 C407                       ANDB    #$07            Mask out low 3 bits
F6D6 E685                       LDB     B,X             Get twang value from table
F6D8 E7C0                       STB     ,U+             Update current twang value
F6DA 4C                         INCA                    Increment twang limit
F6DB 8109                       CMPA    #$09
F6DD 23EB                       BLS     LF6CA           Go back until all three channels done
F6DF 0A57                       DEC     <Vec_Duration   Decrement the duration timer
F6E1 266B                       BNE     LF74E           Update ADSR while note still playing
F6E3=9655       LF6E3           LDA     <Vec_Music_Chan Go to next music channel
F6E5 4A                         DECA
F6E6 2A02                       BPL     LF6EA           If < 0, set it to 2
F6E8 8602                       LDA     #$02
F6EA=9755       LF6EA           STA     <Vec_Music_Chan
F6EC=E69FC853   LF6EC           LDB     [Vec_Music_Ptr] Get next byte of music data
F6F0 CEC85E                     LDU     #Vec_ADSR_Timers Clear ADSR timer for this channel
F6F3 6FC6                       CLR     A,U
F6F5 C540                       BITB    #$40            If $40 bit of music data set,
F6F7 2719                       BEQ     LF712             we're going to make some noise
F6F9 8EF9E4                     LDX     #Music_Table_1  Get bit mask for this channel
F6FC A686                       LDA     A,X
F6FE 9445                       ANDA    <Vec_Music_Wk_7 Turn channel bit off for register 7
F700 9745                       STA     <Vec_Music_Wk_7
F702 9655                       LDA     <Vec_Music_Chan Set current channel bit in register 7
F704 8B03                       ADDA    #$03
F706 A686                       LDA     A,X
F708 9A45                       ORA     <Vec_Music_Wk_7
F70A 9745                       STA     <Vec_Music_Wk_7
F70C C41F                       ANDB    #$1F            Mask off low 5 bits of music data
F70E D746                       STB     <Vec_Music_Wk_6   and store in register 6
F710 2023                       BRA     LF735

F712=8EF9EA     LF712           LDX     #Music_Table_2  If $40 bit of music data was cleared,
F715 A686                       LDA     A,X             Get bit mask for this channel
F717 9445                       ANDA    <Vec_Music_Wk_7 Turn channel bit off for register 7
F719 9745                       STA     <Vec_Music_Wk_7
F71B 9655                       LDA     <Vec_Music_Chan Set current channel bit in register 7
F71D 8B03                       ADDA    #$03
F71F A686                       LDA     A,X
F721 9A45                       ORA     <Vec_Music_Wk_7
F723 9745                       STA     <Vec_Music_Wk_7
F725 9655                       LDA     <Vec_Music_Chan Get $C855 * 2 + 3
F727 48                         ASLA
F728 8B03                       ADDA    #Vec_Music_Freq-Vec_ADSR_Timers
F72A 33C6                       LEAU    A,U             Point U-reg to #$C861 + $C855 * 2
F72C C43F                       ANDB    #$3F            Mask off low 6 bits of music data,
F72E 58                         ASLB                      multiply by 2
F72F 9E4D                       LDX     <Vec_Freq_Table Get pointer to note-to-frequency table
F731 EC85                       LDD     B,X             Get note table data
F733 EDC4                       STD     ,U              Store in word at $C861-$C866
F735=9E53       LF735           LDX     <Vec_Music_Ptr  Re-get byte of music data
F737 E680                       LDB     ,X+
F739 9F53                       STX     <Vec_Music_Ptr  Update music data pointer
F73B 5D                         TSTB
F73C 2BA5                       BMI     LF6E3           If byte>=$80, advance to next channel
F73E E680                       LDB     ,X+             Get second byte of music data
F740 2A06                       BPL     LF748           If >=$80, (terminator)
F742 BDF533                     JSR     Init_Music_Buf    clear music buffer,
F745 0F56                       CLR     <Vec_Music_Flag   clear music flag,
F747 39                         RTS                       and exit

F748=9F53       LF748           STX     <Vec_Music_Ptr  Update music data pointer
F74A C43F                       ANDB    #$3F            Duration in low 6 bits of second byte
F74C D757                       STB     <Vec_Duration   Store duration counter
F74E=109E4F     LF74E           LDY     <Vec_ADSR_Table Get pointer to ADSR table
F751 CEC85E                     LDU     #Vec_ADSR_Timers Point to ADSR timer table
F754 8EC842                     LDX     #Vec_Music_Wk_A
F757 8602                       LDA     #$02            Count for three channels
F759=E6C0       LF759           LDB     ,U+             Get channel timer?
F75B C501                       BITB    #$01            Test low bit of ADSR index
F75D 2707                       BEQ     LF766
F75F 54                         LSRB                    If odd, divide ADSR index by by 2
F760 E6A5                       LDB     B,Y             Get low nibble from ADSR table
F762 C40F                       ANDB    #$0F
F764 2007                       BRA     LF76D

F766=54         LF766           LSRB                    If even, divide ADSR index by 2
F767 E6A5                       LDB     B,Y             Get high nibble from ADSR table
F769 54                         LSRB
F76A 54                         LSRB
F76B 54                         LSRB
F76C 54                         LSRB
F76D=E786       LF76D           STB     A,X             Store ADSR value in regs 10-12
F76F 4A                         DECA                    Decrement channel counter
F770 2AE7                       BPL     LF759           Go back for next channel
F772 CEC867                     LDU     #Vec_Music_Freq+6 Point to base frequency table
F775 8EC847                     LDX     #Vec_Music_Wk_5 Point to twang table
F778=ECC3       LF778           LDD     ,--U            Get next base frequency
F77A 6D58                       TST     -8,U            Test twang value
F77C 2A0A                       BPL     LF788
F77E 6058                       NEG     -8,U            If <0, negate twang table entry
F780 E058                       SUBB    -8,U            Subtract negated value from frequency
F782 8200                       SBCA    #$00            Propagate borrow to high byte
F784 6058                       NEG     -8,U            Un-negate twang entry
F786 2004                       BRA     LF78C

F788=EB58       LF788           ADDB    -8,U            If >0 add twang to base frequency
F78A 8900                       ADCA    #$00            Propagate carry to high byte
F78C=ED81       LF78C           STD     ,X++            Store freq in regs 5/4, 3/2, 1/0
F78E 8CC84D                     CMPX    #Vec_Music_Work+14
F791 26E5                       BNE     LF778
F793=39         LF793_RTS       RTS

                *-----------------------------------------------------------------------*
                *       F7A9    Select_Game                                             *
                *                                                                       *
                * This routine provides a game with the means for allowing the player   *
                * to choose the game number he would like to play, and the number of    *
                * players.  The game indicates the number of game versions available,   *
                * by placing the  value in the B register.  The number of players       *
                * allowed is specified in the A register.  If a parameter is passed in  *
                * with a value of 0, then the corresponding question will not be asked. *
                * The number of players selected is returned in $C879, while the game   *
                * number selected is returned in $C87A.                                 *
                *                                                                       *
                * This routine performs most of the work involved in allowing the       *
                * player to select a game version and the number of players.  It        *
                * displays the game # and player options, and allows the player a       *
                * certain amount of time to modify their values.  Anytime one of the    *
                * buttons is used to modify a value, the timer will be restarted.       *
                * When a button is pressed, the associated value is modified,           *
                * and then redisplayed on the screen.  This routine will return when    *
                * either the timer expires, or button 4 is pressed.                     *
                *                                                                       *
                * ENTRY A-reg = maximum number of players allowed                       *
                *       B-reg = number of game versions available                       *
                *                                                                       *
                * EXIT: DP = $C8                                                        *
                *       $C879 contains number of players selected                       *
                *       $C87A contains the game version selected                        *
                *                                                                       *
                *       D-reg, X-reg, Y-reg trashed                                     *
                *-----------------------------------------------------------------------*

F794=20C0       Player_Str:     FDB     $20C0
F796 40C0                       FDB     $40C0
F798 504C415945                 FCC     /PLAYER/
F79E 80                         FCB     $80

F79F=E0C0       Game_Str:       FDB     $E0C0
F7A1 01C0                       FDB     $01C0
F7A3 2047414D45                 FCC     / GAME/
F7A8 80                         FCB     $80

F7A9=FDC84F     Select_Game:    STD     Vec_Max_Players Save max players and games
F7AC 4D                         TSTA                    If non-zero players specified,
F7AD 2702                       BEQ     LF7B1
F7AF 8601                       LDA     #$01              set selection to 1
F7B1=5D         LF7B1           TSTB                    If non-zero games specified,
F7B2 2702                       BEQ     LF7B6
F7B4 C601                       LDB     #$01              set selection to 1
F7B6=FDC879     LF7B6           STD     Vec_Num_Players Save default selection
F7B9 BDF1AF                     JSR     DP_to_C8        DP to RAM
F7BC CCF850                     LDD     #$F850
F7BF DD2A                       STD     <Vec_Text_HW
F7C1 973C                       STA     <$C83C          Set $C83C flag to non-zero
F7C3 2067                       BRA     LF82C

F7C5=BDF192     LF7C5           JSR     Wait_Recal      Start with a fresh frame, DP to I/O
F7C8 4F                         CLRA                    Read buttons, all in direct mode
F7C9 BDF1B4                     JSR     Read_Btns_Mask
F7CC BDF55A                     JSR     Dec_3_Counters
F7CF BDF2A9                     JSR     Intensity_7F    Brightness to normal
F7D2 B6C879                     LDA     Vec_Num_Players Display number of players
F7D5 108EF794                   LDY     #Player_Str
F7D9 8D5A                       BSR     Display_Option
F7DB B6C87A                     LDA     Vec_Num_Game    Display currently selected game
F7DE 108EF79F                   LDY     #Game_Str
F7E2 8D51                       BSR     Display_Option
F7E4 BDF1AF                     JSR     DP_to_C8        DP to RAM
F7E7 963C                       LDA     <$C83C          If $C83C=0, check buttons
F7E9 2706                       BEQ     LF7F1
F7EB 960F                       LDA     <Vec_Btn_State
F7ED 263D                       BNE     LF82C           If any button pressed, reset timers
F7EF 0F3C                       CLR     <$C83C          Clear $C83C flag
F7F1=962F       LF7F1           LDA     <Vec_Counter_2  Return if counter 2 timed out
F7F3 279E                       BEQ     LF793_RTS
F7F5 962E                       LDA     <Vec_Counter_1  If repeat timer not timed out,
F7F7 26CC                       BNE     LF7C5             ignore the buttons
F7F9 9615                       LDA     <Vec_Button_1_4
F7FB 2696                       BNE     LF793_RTS       Return if button 4 pressed
F7FD 9612                       LDA     <Vec_Button_1_1
F7FF 270F                       BEQ     LF810
F801 9679                       LDA     <Vec_Num_Players Ignore if no players option
F803 270B                       BEQ     LF810           If button 1 pressed,
F805 4C                         INCA                       increment number of players
F806 914F                       CMPA    <Vec_Max_Players
F808 2302                       BLS     LF80C
F80A 8601                       LDA     #$01            Reset to 1 if max players exceeded
F80C=9779       LF80C           STA     <Vec_Num_Players Update number of players
F80E 201C                       BRA     LF82C           Update timers and go back to the loop

F810=967A       LF810           LDA     <Vec_Num_Game   Return to the loop if no game options
F812 27B1                       BEQ     LF7C5
F814 D613                       LDB     <Vec_Button_1_2
F816 2709                       BEQ     LF821
F818 4C                         INCA                    If button 2 down, increment game
F819 9150                       CMPA    <Vec_Max_Games
F81B 230D                       BLS     LF82A
F81D 8601                       LDA     #$01            Reset to 1 if maximum exceeded
F81F 2009                       BRA     LF82A

F821=D614       LF821           LDB     <Vec_Button_1_3
F823 27A0                       BEQ     LF7C5
F825 4A                         DECA                    If button 3 down, decrement game
F826 2602                       BNE     LF82A
F828 9650                       LDA     <Vec_Max_Games  Reset to max if zero reached
F82A=977A       LF82A           STA     <Vec_Num_Game
F82C=86F3       LF82C           LDA     #$F3            Reset timers
F82E 972F                       STA     <Vec_Counter_2
F830 43                         COMA
F831 972E                       STA     <Vec_Counter_1
F833 2090                       BRA     LF7C5           Go back to the loop

                *-----------------------------------------------------------------------*
                *       F835    Display_Option  (not called by GCE cartridges)          *
                *                                                                       *
                * This routine displays the player or game option string, along with    *
                * the current value for that option.  The A-register contains the       *
                * value of the option, while the Y-register points to a block of the    *
                * following form:                                                       *
                *                                                                       *
                *       rel y, rel x,      ( for value )                                *
                *       rel y, rel x,      ( for option string)                         *
                *       option string,                                                  *
                *       0x80                                                            *
                *                                                                       *
                * ENTRY A-reg=the option value.                                         *
                *       Y-reg points to the string block.                               *
                *                                                                       *
                *       D-reg, U-reg, X-reg trashed                                     *
                *-----------------------------------------------------------------------*

F835=8EC85E     Display_Option: LDX     #$C85E          Point to temp storage
F838 3402                       PSHS    A               Save option
F83A 8D13                       BSR     Clear_Score     Clear scratch score accumulator
F83C A6E0                       LDA     ,S+             Get option back
F83E 270E                       BEQ     LF84E           Exit printing nothing if option = zero
F840 8D1C                       BSR     Add_Score_a     Put option in scratch score accumulator
F842 1F13                       TFR     X,U             Transfer X to be printed
F844 ECA1                       LDD     ,Y++            Get (y,x) of value
F846 BDF37A                     JSR     Print_Str_d     Print value
F849 1F23                       TFR     Y,U             Transfer Y to be printed
F84B BDF378                     JSR     Print_Str_yx    Print option string
F84E=39         LF84E           RTS

                *-----------------------------------------------------------------------*
                *       F84F    Clear_Score                                             *
                *                                                                       *
                * This routine will initialize the passed-in score string (pointed to   *
                * by the X-register) to the following value:                            *
                *                                                                       *
                *       "     0",0x80                                                   *
                *                                                                       *
                * ENTRY X-reg points to seven byte score accumulator                    *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F84F=CC2020     Clear_Score:    LDD     #' '*256+' '    Store the leading blanks
F852 ED84                       STD     ,X
F854 ED02                       STD     2,X
F856 A704                       STA     4,X
F858 CC3080                     LDD     #'0'*256+$80    Store the zero and terminator byte
F85B ED05                       STD     5,X
F85D 39                         RTS

                *-----------------------------------------------------------------------*
                *       F85E    Add_Score_a                                             *
                *       F87C    Add_Score_d                                             *
                *                                                                       *
                * These routines take the BCD value in the D-register or the binary     *
                * value in the A-register, and add it to the 6-byte ASCII number        *
                * pointed by the X-register.                                            *
                *                                                                       *
                * ENTRY A-reg = binary value (Add_Score_a only)                         *
                *       D-reg = BCD value (Add_Score_d only)                            *
                *       U-reg = BCD conversion of A-reg (Add_Score_a only)              *
                *       X-reg points to six byte ASCII score accumulator                *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F85E=CE0000     Add_Score_a:    LDU     #$0000          Initialize BCD result to zero
F861=8163       LF861           CMPA    #99             Add in the hundreds
F863 2308                       BLS     LF86D
F865 8064                       SUBA    #100
F867 33C90100                   LEAU    $0100,U
F86B 20F4                       BRA     LF861

F86D=8109       LF86D           CMPA    #9              Add in the tens
F86F 2307                       BLS     LF878
F871 800A                       SUBA    #10
F873 33C810                     LEAU    $10,U
F876 20F5                       BRA     LF86D

F878=33C6       LF878           LEAU    A,U             Add in the ones
F87A 1F30                       TFR     U,D             Move it to the D-register

F87C=3402       Add_Score_d:    PSHS    A               Save BCD on stack in reverse order
F87E 3404                       PSHS    B
F880 C605                       LDB     #$05
F882=4F         LF882           CLRA                    Add zero to 10000 and 100000 digits
F883 C101                       CMPB    #$01
F885 2310                       BLS     LF897
F887 C501                       BITB    #$01            Add right nibble to hundreds and ones
F889 2704                       BEQ     LF88F
F88B A6E4                       LDA     ,S
F88D 2006                       BRA     LF895

F88F=A6E0       LF88F           LDA     ,S+             Add left nibble to thousands and tens
F891 44                         LSRA
F892 44                         LSRA
F893 44                         LSRA
F894 44                         LSRA
F895=840F       LF895           ANDA    #$0F            Isolate desired nibble
F897=BBC823     LF897           ADDA    $C823           Add in carry ($C823 is normally zero)
F89A 7FC823                     CLR     $C823           Clear carry
F89D AB85                       ADDA    B,X             Add to digit
F89F 812F                       CMPA    #'0'-1          If digit was a blank,
F8A1 2E02                       BGT     LF8A5
F8A3 8B10                       ADDA    #$10              promote the result to a digit
F8A5=8139       LF8A5           CMPA    #'9'            If a carry has occurred,
F8A7 2305                       BLS     LF8AE
F8A9 800A                       SUBA    #10               subtract ten
F8AB 7CC823                     INC     $C823             and set carry flag
F8AE=A785       LF8AE           STA     B,X             Store resulting digit
F8B0 5A                         DECB                    Go back for more digits
F8B1 2ACF                       BPL     LF882
F8B3 7FC823                     CLR     $C823           Clear $C823 back to zero
F8B6 5F                         CLRB

                *-----------------------------------------------------------------------*
                *       F8B7    Strip_Zeros                                             *
                *                                                                       *
                * This routine strips the leading zeros from a score accumulator.       *
                *                                                                       *
                * ENTRY B-reg = first digit to start with (usually zero)                *
                *       X-reg points to six byte ASCII score accumulator                *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F8B7=A685       Strip_Zeros:    LDA     B,X             Test current digit
F8B9 8130                       CMPA    #'0'
F8BB 2609                       BNE     LF8C6           Exit if not zero
F8BD 8620                       LDA     #' '            Change it to a blank
F8BF A785                       STA     B,X
F8C1 5C                         INCB
F8C2 C105                       CMPB    #$05
F8C4 2DF1                       BLT     Strip_Zeros
F8C6=39         LF8C6           RTS

                *-----------------------------------------------------------------------*
                *       F8C7    Compare_Score                                           *
                *                                                                       *
                * This routine will compare two BCD score strings, to determine which   *
                * one is higher.  The two strings are pointed to by the U and X         *
                * registers.  Depending upon how the scores compare, one of the         *
                * following values will be returned in the A-register:                  *
                *                                                                       *
                *       1) The scores are the same: a = 0                               *
                *       2) X score > U score:   a = 1                                   *
                *       3) U score > X score:   a = 2                                   *
                *                                                                       *
                * ENTRY X-reg points to first score string (terminated with $80)        *
                *       U-reg points to second score string                             *
                *                                                                       *
                * EXIT: A-reg returns result fo the compare                             *
                *                                                                       *
                *       B-reg trashed                                                   *
                *-----------------------------------------------------------------------*

F8C7=3450       Compare_Score:  PSHS    X,U             Save score pointers
F8C9 4F                         CLRA                    Default to scores are the same
F8CA=E680       LF8CA           LDB     ,X+
F8CC 2B08                       BMI     LF8D6           Return if end of string
F8CE E1C0                       CMPB    ,U+
F8D0 27F8                       BEQ     LF8CA           Continue if byte is the same
F8D2 2201                       BHI     LF8D5           Return 1 if X > U
F8D4 4C                         INCA                    Return 2 if U > X
F8D5=4C         LF8D5           INCA
F8D6=35D0       LF8D6           PULS    X,U,PC          Restore pointers and return

                *-----------------------------------------------------------------------*
                *       F8D8    New_High_Score                                          *
                *                                                                       *
                * This routine compares a players score string, pointed to by the       *
                * X register, to the current hi score, pointed by the U register.  If   *
                * the player's score is higher than the currently saved hi score, then  *
                * the player's score will be copied into the hi score buffer pointed    *
                * to by the U register.                                                 *
                *                                                                       *
                * ENTRY X-reg points to a player's score string                         *
                *       U-reg points to the high score string (usually $CBEB?)          *
                *                                                                       *
                *       X-reg, U-reg, D-reg trashed                                     *
                *-----------------------------------------------------------------------*

F8D8=8DED       New_High_Score: BSR     Compare_Score   Compare the scores
F8DA 8101                       CMPA    #$01
F8DC 2606                       BNE     LF8E4           Return if X is not > U
F8DE=A680       LF8DE           LDA     ,X+             Copy the new high score
F8E0 A7C0                       STA     ,U+
F8E2 2AFA                       BPL     LF8DE             until end of string encountered
F8E4=39         LF8E4           RTS

                *-----------------------------------------------------------------------*
                *       F8E5    Obj_Will_Hit_u                                          *
                *       F8F3    Obj_Will_Hit                                            *
                *                                                                       *
                * This routine first modifies the position of the object, and then it   *
                * checks to see if the missile has hit the object.  The Y register      *
                * contains the (y,x) position of the object, the U register contains    *
                * a pointer to the (y,x) modification values, the X register contains   *
                * the missile (y,x) position, and the D register contains the           *
                * (height/2, width/2) of the object.                                    *
                *                                                                       *
                * (0,u) is temporarily added to the y position of the object, and       *
                * (1,u) is temporarily added to the x position.                         *
                *                                                                       *
                * ENTRY Y-reg = (y,x) position of the object                            *
                *       X-reg = (y,x) position of the missile                           *
                *       U-reg points to movement (y,x) (Mov_Obj_Hit_u only)             *
                *       U-reg = movement (y,x) (Mov_Obj_Hit only)                       *
                *       D-reg = (h/2,w/2) size of object                                *
                *                                                                       *
                * EXIT: Carry bit set if the object & missile have collided             *
                *                                                                       *
                *       ALL registers saved.  Even the original Y-register.             *
                *-----------------------------------------------------------------------*

F8E5=3420       Obj_Will_Hit_u: PSHS    Y               Save regs for the hit-test code
F8E7 3436                       PSHS    D,X,Y
F8E9 EC64                       LDD     4,S             Get object position
F8EB ABC4                       ADDA    ,U              Add it to the modification values
F8ED EB41                       ADDB    1,U
F8EF=ED64       LF8EF           STD     4,S             Put updated object position back
F8F1 2010                       BRA     LF903           Go do the hit-test

F8F3=3420       Obj_Will_Hit:   PSHS    Y               Save regs for the hit-test code
F8F5 3436                       PSHS    D,X,Y
F8F7 1F30                       TFR     U,D             Get modification values
F8F9 AB64                       ADDA    4,S             Add them to the object position
F8FB EB65                       ADDB    5,S
F8FD 20F0                       BRA     LF8EF           Put update position back and hit-test

                *-----------------------------------------------------------------------*
                *       F8FF    Obj_Hit                                                 *
                *                                                                       *
                * Thit routine checks to see if a missile hashit an object.  If the     *
                * missile has hit the object, then the carry bit will be set;           *
                * otherwise, the carry bit will be cleared.  A hit is checked for in    *
                * the following fashion:                                                *
                *                                                                       *
                *   if (object y-height/2) <= missile y <= (object y+height/2)          *
                *                               and                                     *
                *      (object x-width/2)  <= missile x <= (object x+width/x)           *
                *                                                                       *
                *   then the missile hit, otherwise it missed.                          *
                *                                                                       *
                * ENTRY Y-reg = (y,x) position of the object                            *
                *       X-reg = (y,x) position of the missile                           *
                *       D-reg = (h/2,w/2) size of object                                *
                *                                                                       *
                * EXIT: Carry bit set if the object & missile have collided             *
                *                                                                       *
                *       All registers preserved.                                        *
                *-----------------------------------------------------------------------*

F8FF=3420       Obj_Hit:        PSHS    Y               Save some regs
F901 3436                       PSHS    D,X,Y
F903=1F41       LF903           TFR     S,X             Point X to the stack
F905 5F                         CLRB                    Offset to point to y
F906=3A         LF906           ABX
F907 A604                       LDA     4,X             Get height/2
F909 AB84                       ADDA    ,X              Add object y
F90B 2802                       BVC     LF90F
F90D 867F                       LDA     #$7F            Set to $7F if overflow
F90F=A102       LF90F           CMPA    2,X             Branch if missile out of range
F911 2D15                       BLT     LF928
F913 A604                       LDA     4,X             Get height/2
F915 A084                       SUBA    ,X              Subtract object y
F917 2802                       BVC     LF91B
F919 8680                       LDA     #$80            Set to $80 if overflow
F91B=A102       LF91B           CMPA    2,X             Branch if missile out of range
F91D 2E09                       BGT     LF928
F91F 5C                         INCB                    Offset to point to x
F920 C102                       CMPB    #$02
F922 25E2                       BCS     LF906           Go back for x
F924 1A01                       ORCC    #$01            Object in range, set carry
F926 2002                       BRA     LF92A

F928=1CFE       LF928           ANDCC   #$FE            Object not in range, clear carry
F92A=3536       LF92A           PULS    D,X,Y
F92C 35A0                       PULS    Y,PC

                *-----------------------------------------------------------------------*
                *       F92E    Explosion_Snd                                           *
                *                                                                       *
                * This routine appears to generate some type of an explosion sound,     *
                * dependent upon the 4 bytes which are pointed to by the U register.    *
                * You will probably need to call Do_Sound for this to do anything.      *
                *                                                                       *
                * The format of the 4-byte block is:                                    *
                *       1)      Bits 0-2 = ?    Stored in $C85D                         *
                *               Bits 3-5 = ?    Stored in $C853                         *
                *               Bits 6-7 = 0                                            *
                *               Bits 0-2 and 3-5 are ORed and stored in bits 0-2 of     *
                *                                                               $C854   *
                *       2)      <0 = ?          Something to do with register 6         *
                *               =0 = ?                                                  *
                *               >0 = ?                                                  *
                *       3)      <0 = ?                                                  *
                *               =0 = ?                                                  *
                *               >0 = ?                                                  *
                *       4)      Speed?  Higher values = lower duration?                 *
                *                                                                       *
                * ENTRY DP = $C8                                                        *
                *       U-reg points to 4-byte block of data if $C867 high bit set      *
                *                                                                       *
                *       D-reg, X-reg trashed                                            *
                *-----------------------------------------------------------------------*

F92E=9667       Explosion_Snd:  LDA     <Vec_Expl_Flag
F930 2A29                       BPL     LF95B
F932 847F                       ANDA    #$7F
F934 9767                       STA     <Vec_Expl_Flag
F936 8EC858                     LDX     #Vec_Expl_1     Copy 4 bytes from U-reg to $C858
F939 8604                       LDA     #$04
F93B BDF683                     JSR     Move_Mem_a
F93E 54                         LSRB                    Divide first byte by 8
F93F 54                         LSRB
F940 54                         LSRB
F941 DA58                       ORB     <Vec_Expl_1     OR with first byte
F943 C407                       ANDB    #$07            AND with 7
F945 D754                       STB     <Vec_Expl_Chans store in $C854
F947 D658                       LDB     <Vec_Expl_1     Get first byte
F949 C438                       ANDB    #$38            Mask off bits 3-5
F94B D753                       STB     <Vec_Expl_ChanA store in $C853
F94D D658                       LDB     <Vec_Expl_1     Get first byte
F94F C407                       ANDB    #$07            AND with 7
F951 D75D                       STB     <Vec_Expl_ChanB store in $C85D
F953 C602                       LDB     #$02            Start with channel number 2
F955 D75C                       STB     <Vec_Expl_Chan
F957 867F                       LDA     #$7F            Initialize time count
F959 200D                       BRA     LF968

F95B=9677       LF95B           LDA     <Vec_Expl_Timer
F95D 276A                       BEQ     LF9C9_RTS
F95F 905B                       SUBA    <Vec_Expl_4
F961 2A05                       BPL     LF968
F963 5F                         CLRB
F964 D777                       STB     <Vec_Expl_Timer
F966 2062                       BRA     LF9CA

F968=9777       LF968           STA     <Vec_Expl_Timer
F96A 44                         LSRA
F96B 44                         LSRA
F96C D653                       LDB     <Vec_Expl_ChanA
F96E 270D                       BEQ     LF97D
F970 9746                       STA     <Vec_Music_Wk_6
F972 D659                       LDB     <Vec_Expl_2
F974 2B05                       BMI     LF97B
F976 2705                       BEQ     LF97D
F978 1F89                       TFR     A,B
F97A 53                         COMB
F97B=D746       LF97B           STB     <Vec_Music_Wk_6
F97D=44         LF97D           LSRA
F97E 8107                       CMPA    #$07
F980 2305                       BLS     LF987
F982 810F                       CMPA    #$0F
F984 2701                       BEQ     LF987
F986 4C                         INCA
F987=D65A       LF987           LDB     <Vec_Expl_3
F989 2B06                       BMI     LF991
F98B 2702                       BEQ     LF98F
F98D 880F                       EORA    #$0F
F98F=1F89       LF98F           TFR     A,B
F991=8D37       LF991           BSR     LF9CA
F993 D65D                       LDB     <Vec_Expl_ChanB
F995 272B                       BEQ     LF9C2
F997=965C       LF997           LDA     <Vec_Expl_Chan  Get channel number
F999 4A                         DECA                    Decrement channel number
F99A 2A02                       BPL     LF99E
F99C 8602                       LDA     #$02            Reset to 2 if less than zero
F99E=975C       LF99E           STA     <Vec_Expl_Chan  Save channel number
F9A0 BDF57E                     JSR     Bitmask_a       Get bit mask of the channel
F9A3 955D                       BITA    <Vec_Expl_ChanB
F9A5 27F0                       BEQ     LF997           Go back if not in for $C85D
F9A7 D65C                       LDB     <Vec_Expl_Chan
F9A9 58                         ASLB                    Negative of channel number * 2
F9AA 50                         NEGB
F9AB 8EC84B                     LDX     #Vec_Music_Wk_1   (registers 1, 3, and 5)
F9AE 3085                       LEAX    B,X
F9B0 BDF517                     JSR     Random
F9B3 840F                       ANDA    #$0F
F9B5 8105                       CMPA    #$05
F9B7 2203                       BHI     LF9BC
F9B9 48                         ASLA
F9BA 8B05                       ADDA    #$05
F9BC=A784       LF9BC           STA     ,X
F9BE 967E                       LDA     <Vec_Random_Seed+1
F9C0 A701                       STA     1,X
F9C2=9658       LF9C2           LDA     <Vec_Expl_1
F9C4 43                         COMA
F9C5 9445                       ANDA    <Vec_Music_Wk_7
F9C7 9745                       STA     <Vec_Music_Wk_7
F9C9=39         LF9C9_RTS       RTS

F9CA=9654       LF9CA           LDA     <Vec_Expl_Chans
F9CC 8EC845                     LDX     #Vec_Music_Wk_7
F9CF=4D         LF9CF           TSTA                    Exit if all channels done
F9D0 2709                       BEQ     LF9DB_RTS
F9D2 301F                       LEAX    -1,X            Point to next register (8-10)
F9D4 44                         LSRA
F9D5 24F8                       BCC     LF9CF
F9D7 E784                       STB     ,X              Store noise value if chan in use
F9D9 20F4                       BRA     LF9CF

F9DB=39         LF9DB_RTS       RTS

F9DC=0102040810 Bit_Masks:      FCB     $01,$02,$04,$08,$10,$20,$40,$80 For Bitmask_a

F9E4=F7EFDF0102 Music_Table_1:  FCB     $F7,$EF,$DF,$01,$02,$04         For noise

F9EA=FEFDFB0810 Music_Table_2:  FCB     $FE,$FD,$FB,$08,$10,$20         For music

F9F0=7F7F8080   Recal_Points:   FDB     $7F7F,$8080                     For Recalibrate

F9F4=0020505020 Char_Table:     FDB     $0020,$5050,$20C8,$2010,$1040,$2000,$0000,$0008
FA04 3020707010                 FDB     $3020,$7070,$10F8,$30F8,$7070,$0060,$0000,$0070
FA14 7020F070F0                 FDB     $7020,$F070,$F0F8,LF878,$8870,$0888,$8088,$88F8
FA24 F070F070F8                 FDB     $F070,$F070,$F888,$8888,$8888,$F870,$8070,$2000
FA34 0020082000                 FDB     $0020,$0820,$0000,$0038,$1020,$4444,$00FE,$FFFE

FA44 0070505078                 FDB     $0070,$5050,$78C8,$5020,$2020,$A820,$0000,$0008
FA54 4860888830                 FDB     $4860,$8888,$3080,$4008,$8888,$6060,$1000,$4088
FA64 8850488848                 FDB     $8850,$4888,$4880,$8080,$8820,$0890,$80D8,$C888
FA74 88888888A8                 FDB     $8888,$8888,$A888,$8888,$8888,$0840,$8008,$5000
FA84 00700C2070                 FDB     $0070,$0C20,$7070,$0044,$1070,$0000,$6C82,$FFFE

FA94 007050F8A0                 FDB     $0070,$50F8,$A010,$5040,$4010,$7020,$0000,$0010
FAA4 4820080850                 FDB     $4820,$0808,$50F0,$8010,$8888,$6000,$2078,$2008
FAB4 A888488048                 FDB     $A888,$4880,$4880,$8080,$8820,$08A0,$80A8,$A888
FAC4 8888884020                 FDB     $8888,$8840,$2088,$8888,$5050,$1040,$4008,$8800
FAD4 70A80A2088                 FDB     $70A8,$0A20,$88F8,$60BA,$3820,$0000,$9282,$FFFE

FAE4 0020005070                 FDB     $0020,$0050,$7020,$6000,$4010,$A8F8,$0070,$0020
FAF4 4820703090                 FDB     $4820,$7030,$9008,$F020,$7078,$0060,$4000,$1010
FB04 B888708048                 FDB     $B888,$7080,$48E0,$E098,$F820,$08C0,$80A8,$9888
FB14 F088F02020                 FDB     $F088,$F020,$2088,$50A8,$2020,$2040,$2008,$0000
FB24 FE20082088                 FDB     $FE20,$0820,$88F8,$F0A2,$38F8,$8238,$9282,$FFFE

FB34 000000F870                 FDB     $0000,$00F8,$7040,$A800,$4010,$A820,$4000,$0040
FB44 48208008F8                 FDB     $4820,$8008,$F808,$8840,$8808,$6060,$2078,$2020
FB54 B0F8488048                 FDB     $B0F8,$4880,$4880,$8088,$8820,$08A0,$8088,$8888
FB64 80A8A01020                 FDB     $80A8,$A010,$2088,$50A8,$5020,$4040,$1008,$0000
FB74 FE2078A888                 FDB     $FE20,$78A8,$88F8,$F0BA,$7C20,$4444,$6C82,$FFFE

FB84 0000005028                 FDB     $0000,$0050,$2898,$9000,$2020,$0020,$4000,$0080
FB94 4820808810                 FDB     $4820,$8088,$1088,$8880,$8810,$6020,$1000,$4000
FBA4 8088488848                 FDB     $8088,$4888,$4880,$8088,$8820,$8890,$8888,$8888
FBB4 8090908820                 FDB     $8090,$9088,$2088,$20A8,$8820,$8040,$0808,$0000
FBC4 4820F07070                 FDB     $4820,$F070,$7070,$6044,$6C50,$3882,$0082,$FFFE

FBD4 00200050F8 Char_Table_End: FDB     $0020,$0050,$F898,$6800,$1040,$0000,$8000,$8080
FBE4 3070F87010                 FDB     $3070,$F870,$1070,$7080,$7060,$0040,$0000,$0020
FBF4 7888F070F0                 FDB     $7888,$F070,$F0F8,$8078,$8870,$7088,$F888,$88F8
FC04 8068887020                 FDB     $8068,$8870,$2070,$2050,$8820,$F870,$0870,$00F8
FC14 0020602000                 FDB     $0020,$6020,$0000,$0038,$8288,$0000,$00FE,$FFFE

                *       These tables are used by the rise/run calculations

FC24=0011413021 DFC24           FDB     $0011,$4130,$2110,$2031

FC2C=000103060A DFC2C           FDB     $0001,$0306,$0A0F,$151C,$242D,$0810,$0810,$0B08
FC3C 100D0A0810                 FDB     $100D,$0A08,$100E,$0B09,$0810,$0E0C,$0A09,$0810
FC4C 0E0D0B0A09                 FDB     $0E0D,$0B0A,$0908,$100F,$0D0C,$0B0A,$0908,$100F
FC5C 0E0C0B0A09                 FDB     $0E0C,$0B0A,$0909,$0810,$0F0E,$0D0C,$0B0A,$0909
FC6C 08                         FCB     $08

FC6D=0019324A62 DFC6D           FDB     $0019,$324A,$6279,$8EA2,$B5C6,$D5E2,$EDF5,$FBFF
FC7D FFFFFBF5ED                 FDB     $FFFF,$FBF5,$EDE2,$D5C6,$B5A2,$8E79,$624A,$3219

                *       Music note to frequency table

FC8D=03BD038703 Freq_Table:     FDB     $03BD,$0387,$0354,$0324,$02F7,$02CD,$02A4,$027E
FC9D 025B023902                 FDB     $025B,$0239,$0219,$01FB,$01DE,$01C3,$01AA,$0192
FCAD 017C016601                 FDB     $017C,$0166,$0152,$013F,$012D,$011C,$010C,$00FD
FCBD 00EF00E200                 FDB     $00EF,$00E2,$00D5,$00C9,$00BE,$00B3,$00A9,$00A0
FCCD 0097008E00                 FDB     $0097,$008E,$0086,$007F,$0078,$0071,$006B,$0065
FCDD 005F005A00                 FDB     $005F,$005A,$0055,$0050,$004B,$0047,$0043,$003F
FCED 003C003800                 FDB     $003C,$0038,$0035,$0032,$002F,$002D,$002A,$0028
FCFD 0026002400                 FDB     $0026,$0024,$0022,$0020,$001E,$001C,$001B,$0000

                *       FD0D = power-on music and music for Crazy Coaster and Narrow Escape

FD0D=FEE8FEB693 Intro_Music:    FDB     DFEE8,DFEB6,$931F,$0C93,$1F06,$989F,$243C,$1180

                *       FD1D = music for Berzerk?

FD1D=FD69FD7921 DFD1D           FDB     DFD69,DFD79,$2107,$2107,$2107,$2107,$2107,$2107
FD2D 210E999F24                 FDB     $210E,$999F,$240E,$959B,$200E,$2107,$2107,$2107
FD3D 2107210721                 FDB     $2107,$2107,$2107,$9DA3,$280E,$A0A6,$2B0E,$2202
FD4D 28022D0228                 FDB     $2802,$2D02,$2802,$2202,$2802,$2D02,$2802,$2202
FD5D 28022D0228                 FDB     $2802,$2D02,$2802,$2E02,$2D28,$2180

                *       FD69 = ADSR table for Berzerk and FF7A

FD69=EFFFFEDCBA DFD69           FDB     $EFFF,$FEDC,$BA00,$0000,$0000,$0000,$0000,$0000

                *       FD79 = twang table for Berzerk and Scramble

FD79=0001020100 DFD79           FDB     $0001,$0201,$00FF,$FEFF

                *       FD81 = music

FD81=FDC3FEB651 DFD81           FDB     DFDC3,DFEB6,$5124,$5006,$5006,$500C,$5006,$5006
FD91 5004500450                 FDB     $5004,$5004,$5004,$5018,$5004,$5004,$5004,$500C
FDA1 500C502450                 FDB     $500C,$5024,$5006,$5006,$500C,$5006,$5006,$5004
FDB1 5004500450                 FDB     $5004,$5004,$5018,$5004,$5004,$5004,$500C,$5018
FDC1 2680                       FDB     $2680

                *       FDC3 = ADSR table for FD81 and FF8F

FDC3=FDBA987655 DFDC3           FDB     $FDBA,$9876,$5544,$3322,$1100,$0000,$0000,$0000

                *       FDD3 = music for Scramble

FDD3=FE28FD7998 DFDD3           FDB     DFE28,DFD79,$981C,$103F,$0898,$1C04,$981C,$0498
FDE3 1C103F0898                 FDB     $1C10,$3F08,$981C,$0498,$1C04,$981C,$0893,$1808
FDF3 981C089C1F                 FDB     $981C,$089C,$1F08,$981C,$0893,$1808,$981C,$0893
FE03 1808981C08                 FDB     $1808,$981C,$089C,$1F08,$981C,$0893,$1808,$981C
FE13 0893180898                 FDB     $0893,$1808,$981C,$089C,$1F08,$981C,$0893,$1808
FE23 9C1F301A80                 FCB     $9C,$1F,$30,$1A,$80

                *       FE28 = ADSR table for Scramble, FF26, FF44, FF62

FE28=FFFEDCBA98 DFE28           FDB     $FFFE,$DCBA,$9876,$5432,$1000,$0000,$0000,$0000

                *       FE38 = music for Solar Quest

FE38=FE66FEB60C DFE38           FDB     DFE66,DFEB6,$0C18,$1118,$0C18,$1118,$0C18,$1118
FE48 0C120C0611                 FDB     $0C12,$0C06,$1118,$9D21,$189F,$2318,$A124,$18A3
FE58 26189FA428                 FDB     $2618,$9FA4,$2818,$0712,$0706,$003C,$1880

                *       FE66 = ADSR table for Solar Quest

FE66=DEEFFEDCBA DFE66           FDB     $DEEF,$FEDC,$BA00,$0000,$0000,$0000,$0000,$0000

                *       FE76 = music

FE76=FEB2FEB618 DFE76           FDB     DFEB2,DFEB6,$1806,$1A06,$1C0C,$180C,$1A24,$2318
FE86 170618061A                 FDB     $1706,$1806,$1A0C,$170C,$1824,$2418,$A428,$0CA3
FE96 260CA1240C                 FDB     $260C,$A124,$0C9F,$230C,$9D21,$189A,$1F18,$1706
FEA6 18061A0C17                 FDB     $1806,$1A0C,$170C,$1824,$2424,$1880

                *       FEB2 = ADSR table for FE76

FEB2=FFEEDDCC   DFEB2           FDB     $FFEE,$DDCC

                *       FEB6 = "flat" twang table

FEB6=0000000000 DFEB6           FDB     $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

                *       FEC6 = music

FEC6=FEE8FEB696 DFEC6           FDB     DFEE8,DFEB6,$969A,$1D1E,$9195,$181E,$9498,$1B1E
FED6 8F94181416                 FDB     $8F94,$1814,$160A,$8C91,$1514,$160A,$9195,$1832
FEE6 1880                       FDB     $1880

                *       FEE8 = ADSR table for FEC6

FEE8=EEFFFFEEEE DFEE8           FDB     $EEFF,$FFEE,$EEDD,$CCBB,$AA99,$8888,$8888,$8888

                *       FEF8 = music for Melody Master

FEF8=FF16FEB61C DFEF8           FDB     DFF16,DFEB6,$1C06,$1F06,$1C06,$1806,$1A06,$1806
FF08 1506130618                 FDB     $1506,$1306,$1806,$1306,$1706,$181E,$1880

                *       FF16 = ADSR table for FEF8

FF16=FFFFEEEEDD DFF16           FDB     $FFFF,$EEEE,$DDDD,$CCCC,$0000,$0000,$0000,$0000

                *       FF26 = music

FF26=FE28FEB616 DFF26           FDB     DFE28,DFEB6,$160F,$1605,$1605,$1605,$1A0F,$160F
FF36 1D0F1D051D                 FDB     $1D0F,$1D05,$1D05,$1D05,$210F,$1D32,$1D80

                *       FF44 = music

FF44=FE28FEB616 DFF44           FDB     DFE28,DFEB6,$1606,$1602,$1602,$1602,$1A06,$1606
FF54 1D061D021D                 FDB     $1D06,$1D02,$1D02,$1D02,$2106,$1D32,$1180

                *       FF62 = music

FF62=FE28FEB61B DFF62           FDB     DFE28,DFEB6,$1B0F,$1605,$1605,$1605,$1730,$1605
FF72 1605160517                 FDB     $1605,$1605,$1730,$1680

                *       FF7A = music

FF7A=FD69FEB6A0 DFF7A           FDB     DFD69,DFEB6,$A023,$12A0,$230C,$9C20,$069E,$2112
FF8A 9C20321380                 FCB     $9C,20,$32,$13,$80

                *       FF8F = music

FF8F=FDC3FEB616 DFF8F           FDB     DFDC3,DFEB6,$1604,$1604,$1604,$1604,$1A08,$1C80

                *-----------------------------------------------------------------------*
                *       FF9F    Draw_Grid_VL                                            *
                *                                                                       *
                * This routine apparently will draw a vector list using a 16x16 grid,   *
                * and occassionally using regular vector lists too.                     *
                *                                                                       *
                * The master vector list contains multiple sublists that start with     *
                * a flag byte:                                                          *
                *       Bit 7 = draw the next regular vector list (from X-reg) first    *
                *       Bit 6 = this is the last sublist in the master vector list      *
                *       Bits 5,4 = unused                                               *
                *       Bits 3-0 = number of points in this sublist (1-16)              *
                *                                                                       *
                * The points are stored as a pair of nibbles:                           *
                *       Bits 7-4 = Y coordinate (?)                                     *
                *       Bits 3-0 = X coordinate (?)                                     *
                *                                                                       *
                * ENTRY X-reg points to regular vector lists                            *
                *       Y-reg points to master vector list                              *
                *                                                                       *
                * EXIT: X-reg points to next byte after last regular vector list used   *
                *       Y-reg points to next byte after end of master vector list       *
                *                                                                       *
                *       D-reg trashed                                                   *
                *-----------------------------------------------------------------------*

FF9F=A6A0       Draw_Grid_VL:   LDA     ,Y+             Get flag byte
FFA1 2008                       BRA     LFFAB           Jump into loop

FFA3=BDF3BE     LFFA3           JSR     Mov_Draw_VL_d   Draw a regular vector list
FFA6 B6C880                     LDA     $C880           Clear vector list flag
FFA9 847F                       ANDA    #$7F
FFAB=B7C880     LFFAB           STA     $C880           Save flag byte for vector count
FFAE=7AC880     LFFAE           DEC     $C880           Decrement vector count
FFB1 A6A4                       LDA     ,Y              Get Y of next point
FFB3 47                         ASRA
FFB4 84F8                       ANDA    #$F8
FFB6 E6A0                       LDB     ,Y+             Get X of next point
FFB8 58                         ASLB
FFB9 58                         ASLB
FFBA 58                         ASLB
FFBB 58                         ASLB
FFBC 57                         ASRB
FFBD C4F8                       ANDB    #$F8
FFBF 7DC880                     TST     $C880           Draw a regular vector list?
FFC2 2BDF                       BMI     LFFA3           Go back if so
FFC4 BDF3DF                     JSR     Draw_Line_d     Draw a line to the new point
FFC7 B6C880                     LDA     $C880           Check vector counter
FFCA 850F                       BITA    #$0F
FFCC 26E0                       BNE     LFFAE           Go back if more vectors to draw
FFCE 8520                       BITA    #$20            Check for end of list
FFD0 27CD                       BEQ     Draw_Grid_VL    Go back if more lists to draw
FFD2 39                         RTS

FFD3 4B41525253                 FCC     /KARRSOFT82LDMCBCJT82LDMCBCJ/

FFEE 00000000                   FDB     0,0             Unused

FFF2 CBF2                       FDB     $CBF2           SWI3 vector
FFF4 CBF2                       FDB     $CBF2           SWI2 vector
FFF6 CBF5                       FDB     $CBF5           FIRQ vector
FFF8 CBF8                       FDB     $CBF8           IRQ vector
FFFA CBFB                       FDB     $CBFB           SWI vector
FFFC CBFB                       FDB     $CBFB           NMI vector
FFFE F000                       FDB     Start           Reset vector

                                END
