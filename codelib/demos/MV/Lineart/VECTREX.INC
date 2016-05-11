Vec_Snd_Shadow  equ     $C800   ; Shadow of sound chip registers (15 bytes)
Vec_Btn_State   equ     $C80F   ; Current state of all joystick buttons
Vec_Prev_Btns   equ     $C810   ; Previous state of all joystick buttons
Vec_Buttons     equ     $C811   ; Current toggle state of all buttons
Vec_Button_1_1  equ     $C812   ; Current toggle state of stick 1 button 1
Vec_Button_1_2  equ     $C813   ; Current toggle state of stick 1 button 2
Vec_Button_1_3  equ     $C814   ; Current toggle state of stick 1 button 3
Vec_Button_1_4  equ     $C815   ; Current toggle state of stick 1 button 4
Vec_Button_2_1  equ     $C816   ; Current toggle state of stick 2 button 1
Vec_Button_2_2  equ     $C817   ; Current toggle state of stick 2 button 2
Vec_Button_2_3  equ     $C818   ; Current toggle state of stick 2 button 3
Vec_Button_2_4  equ     $C819   ; Current toggle state of stick 2 button 4
Vec_Joy_Resltn  equ     $C81A   ; Joystick A/D resolution ($80=min $00=max)
Vec_Joy_1_X     equ     $C81B   ; Joystick 1 left/right
Vec_Joy_1_Y     equ     $C81C   ; Joystick 1 up/down
Vec_Joy_2_X     equ     $C81D   ; Joystick 2 left/right
Vec_Joy_2_Y     equ     $C81E   ; Joystick 2 up/down
Vec_Joy_Mux     equ     $C81F   ; Joystick enable/mux flags (4 bytes)
Vec_Joy_Mux_1_X equ     $C81F   ; Joystick 1 X enable/mux flag (=1)
Vec_Joy_Mux_1_Y equ     $C820   ; Joystick 1 Y enable/mux flag (=3)
Vec_Joy_Mux_2_X equ     $C821   ; Joystick 2 X enable/mux flag (=5)
Vec_Joy_Mux_2_Y equ     $C822   ; Joystick 2 Y enable/mux flag (=7)
Vec_Misc_Count  equ     $C823   ; Misc counter/flag byte, zero when not in use
Vec_0Ref_Enable equ     $C824   ; Check0Ref enable flag
Vec_Loop_Count  equ     $C825   ; Loop counter word (incremented in Wait_Recal)
Vec_Brightness  equ     $C827   ; Default brightness
Vec_Dot_Dwell   equ     $C828   ; Dot dwell time?
Vec_Pattern     equ     $C829   ; Dot pattern (bits)
Vec_Text_HW     equ     $C82A   ; Default text height and width
Vec_Text_Height equ     $C82A   ; Default text height
Vec_Text_Width  equ     $C82B   ; Default text width
Vec_Str_Ptr     equ     $C82C   ; Temporary string pointer for Print_Str
Vec_Counters    equ     $C82E   ; Six bytes of counters
Vec_Counter_1   equ     $C82E   ; First  counter byte
Vec_Counter_2   equ     $C82F   ; Second counter byte
Vec_Counter_3   equ     $C830   ; Third  counter byte
Vec_Counter_4   equ     $C831   ; Fourth counter byte
Vec_Counter_5   equ     $C832   ; Fifth  counter byte
Vec_Counter_6   equ     $C833   ; Sixth  counter byte
Vec_RiseRun_Tmp equ     $C834   ; Temp storage word for rise/run
Vec_Angle       equ     $C836   ; Angle for rise/run and rotation calculations
Vec_Run_Index   equ     $C837   ; Index pair for run
*                       $C839   ; Pointer to copyright string during startup
Vec_Rise_Index  equ     $C839   ; Index pair for rise
*                       $C83B   ; High score cold-start flag (=0 if valid)
Vec_RiseRun_Len equ     $C83B   ; length for rise/run
*                       $C83C   ; temp byte
Vec_Rfrsh       equ     $C83D   ; Refresh time (divided by 1.5MHz)
Vec_Rfrsh_lo    equ     $C83D   ; Refresh time low byte
Vec_Rfrsh_hi    equ     $C83E   ; Refresh time high byte
Vec_Music_Work  equ     $C83F   ; Music work buffer (14 bytes, backwards?)
Vec_Music_Wk_A  equ     $C842   ;         register 10
*                       $C843   ;         register 9
*                       $C844   ;         register 8
Vec_Music_Wk_7  equ     $C845   ;         register 7
Vec_Music_Wk_6  equ     $C846   ;         register 6
Vec_Music_Wk_5  equ     $C847   ;         register 5
*                       $C848   ;         register 4
*                       $C849   ;         register 3
*                       $C84A   ;         register 2
Vec_Music_Wk_1  equ     $C84B   ;         register 1
*                       $C84C   ;         register 0
Vec_Freq_Table  equ     $C84D   ; Pointer to note-to-frequency table (normally $FC8D)
Vec_Max_Players equ     $C84F   ; Maximum number of players for Select_Game
Vec_Max_Games   equ     $C850   ; Maximum number of games for Select_Game
Vec_ADSR_Table  equ     $C84F   ; Storage for first music header word (ADSR table)
Vec_Twang_Table equ     $C851   ; Storage for second music header word ('twang' table)
Vec_Music_Ptr   equ     $C853   ; Music data pointer
Vec_Expl_ChanA  equ     $C853   ; Used by Explosion_Snd - bit for first channel used?
Vec_Expl_Chans  equ     $C854   ; Used by Explosion_Snd - bits for all channels used?
Vec_Music_Chan  equ     $C855   ; Current sound channel number for Init_Music
Vec_Music_Flag  equ     $C856   ; Music active flag ($00=off $01=start $80=on)
Vec_Duration    equ     $C857   ; Duration counter for Init_Music
Vec_Music_Twang equ     $C858   ; 3 word 'twang' table used by Init_Music
Vec_Expl_1      equ     $C858   ; Four bytes copied from Explosion_Snd's U-reg parameters
Vec_Expl_2      equ     $C859
Vec_Expl_3      equ     $C85A
Vec_Expl_4      equ     $C85B
Vec_Expl_Chan   equ     $C85C   ; Used by Explosion_Snd - channel number in use?
Vec_Expl_ChanB  equ     $C85D   ; Used by Explosion_Snd - bit for second channel used?
Vec_ADSR_Timers equ     $C85E   ; ADSR timers for each sound channel (3 bytes)
Vec_Music_Freq  equ     $C861   ; Storage for base frequency of each channel (3 words)
*                       $C85E   ; Scratch 'score' storage for Display_Option (7 bytes)
Vec_Expl_Flag   equ     $C867   ; Explosion_Snd initialization flag?
*               $C868...$C876   ; Unused?
Vec_Expl_Timer  equ     $C877   ; Used by Explosion_Snd
*                       $C878   ; Unused?
Vec_Num_Players equ     $C879   ; Number of players selected in Select_Game
Vec_Num_Game    equ     $C87A   ; Game number selected in Select_Game
Vec_Seed_Ptr    equ     $C87B   ; Pointer to 3-byte random number seed (=$C87D)
Vec_Random_Seed equ     $C87D   ; Default 3-byte random number seed

*       $C880 - $CBEA is user RAM

Vec_Default_Stk equ     $CBEA   ; Default top-of-stack
Vec_High_Score  equ     $CBEB   ; High score storage (7 bytes)
Vec_SWI3_Vector equ     $CBF2   ; SWI2/SWI3 interrupt vector (3 bytes)
Vec_SWI2_Vector equ     $CBF2   ; SWI2/SWI3 interrupt vector (3 bytes)
Vec_FIRQ_Vector equ     $CBF5   ; FIRQ interrupt vector (3 bytes)
Vec_IRQ_Vector  equ     $CBF8   ; IRQ interrupt vector (3 bytes)
Vec_SWI_Vector  equ     $CBFB   ; SWI/NMI interrupt vector (3 bytes)
Vec_NMI_Vector  equ     $CBFB   ; SWI/NMI interrupt vector (3 bytes)
Vec_Cold_Flag   equ     $CBFE   ; Cold start flag (warm start if = $7321)

VIA_port_b      equ     $D000   ; VIA port B data I/O register
*       0 sample/hold (0=enable mux 1=disable mux)
*       1 mux sel 0
*       2 mux sel 1
*       3 sound BC1
*       4 sound BDIR
*       5 comparator input
*       6 external device (slot pin 35) initialized to input
*       7 /RAMP
VIA_port_a      equ     $D001   ; VIA port A data I/O register (handshaking)
VIA_DDR_b       equ     $D002   ; VIA port B data direction register (0=input 1=output)
VIA_DDR_a       equ     $D003   ; VIA port A data direction register (0=input 1=output)
VIA_t1_cnt_lo   equ     $D004   ; VIA timer 1 count register lo (scale factor)
VIA_t1_cnt_hi   equ     $D005   ; VIA timer 1 count register hi
VIA_t1_lch_lo   equ     $D006   ; VIA timer 1 latch register lo
VIA_t1_lch_hi   equ     $D007   ; VIA timer 1 latch register hi
VIA_t2_lo       equ     $D008   ; VIA timer 2 count/latch register lo (refresh)
VIA_t2_hi       equ     $D009   ; VIA timer 2 count/latch register hi
VIA_shift_reg   equ     $D00A   ; VIA shift register
VIA_aux_cntl    equ     $D00B   ; VIA auxiliary control register
*       0 PA latch enable
*       1 PB latch enable
*       2 \                     110=output to CB2 under control of phase 2 clock
*       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
*       4 /
*       5 0=t2 one shot                 1=t2 free running
*       6 0=t1 one shot                 1=t1 free running
*       7 0=t1 disable PB7 output       1=t1 enable PB7 output
VIA_cntl        equ     $D00C   ; VIA control register
*       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
*       1 \
*       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
*       3 /
*       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
*       5 \
*       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
*       7 /
VIA_int_flags   equ     $D00D   ; VIA interrupt flags register
*               bit                             cleared by
*       0 CA2 interrupt flag            reading or writing port A I/O
*       1 CA1 interrupt flag            reading or writing port A I/O
*       2 shift register interrupt flag reading or writing shift register
*       3 CB2 interrupt flag            reading or writing port B I/O
*       4 CB1 interrupt flag            reading or writing port A I/O
*       5 timer 2 interrupt flag        read t2 low or write t2 high
*       6 timer 1 interrupt flag        read t1 count low or write t1 high
*       7 IRQ status flag               write logic 0 to IER or IFR bit
VIA_int_enable  equ     $D00E   ; VIA interrupt enable register
*       0 CA2 interrupt enable
*       1 CA1 interrupt enable
*       2 shift register interrupt enable
*       3 CB2 interrupt enable
*       4 CB1 interrupt enable
*       5 timer 2 interrupt enable
*       6 timer 1 interrupt enable
*       7 IER set/clear control
VIA_port_a_nohs equ     $D00F   ; VIA port A data I/O register (no handshaking)
