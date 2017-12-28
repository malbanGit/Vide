 .module YM_PRG.pre.s
 .bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)
 .area .cartridge (BANK=rom) 
 .area .text (BANK=rom)
 .area .text.hot (BANK=rom)
 .area .text.unlikely (BANK=rom)

 .bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
 .area .data  (BANK=ram)
 .area .bss   (BANK=ram)

 .area .text

; include line ->  include "vectrex.i"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains includes for vectrex BIOS functions and variables      ;
; it was written by Bruce Tomlin, slighte changed by Malban                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE_I = 1

Vec_Snd_Shadow  =     0xC800   ;Shadow of sound chip registers (15 bytes)
Vec_Btn_State   =     0xC80F   ;Current state of all joystick buttons
Vec_Prev_Btns   =     0xC810   ;Previous state of all joystick buttons
Vec_Buttons     =     0xC811   ;Current toggle state of all buttons
Vec_Button_1_1  =     0xC812   ;Current toggle state of stick 1 button 1
Vec_Button_1_2  =     0xC813   ;Current toggle state of stick 1 button 2
Vec_Button_1_3  =     0xC814   ;Current toggle state of stick 1 button 3
Vec_Button_1_4  =     0xC815   ;Current toggle state of stick 1 button 4
Vec_Button_2_1  =     0xC816   ;Current toggle state of stick 2 button 1
Vec_Button_2_2  =     0xC817   ;Current toggle state of stick 2 button 2
Vec_Button_2_3  =     0xC818   ;Current toggle state of stick 2 button 3
Vec_Button_2_4  =     0xC819   ;Current toggle state of stick 2 button 4
Vec_Joy_Resltn  =     0xC81A   ;Joystick A/D resolution (0x80=min 0x00=max)
Vec_Joy_1_X     =     0xC81B   ;Joystick 1 left/right
Vec_Joy_1_Y     =     0xC81C   ;Joystick 1 up/down
Vec_Joy_2_X     =     0xC81D   ;Joystick 2 left/right
Vec_Joy_2_Y     =     0xC81E   ;Joystick 2 up/down
Vec_Joy_Mux     =     0xC81F   ;Joystick enable/mux flags (4 bytes)
Vec_Joy_Mux_1_X =     0xC81F   ;Joystick 1 X enable/mux flag (=1)
Vec_Joy_Mux_1_Y =     0xC820   ;Joystick 1 Y enable/mux flag (=3)
Vec_Joy_Mux_2_X =     0xC821   ;Joystick 2 X enable/mux flag (=5)
Vec_Joy_Mux_2_Y =     0xC822   ;Joystick 2 Y enable/mux flag (=7)
Vec_Misc_Count  =     0xC823   ;Misc counter/flag byte, zero when not in use
Vec_0Ref_Enable =     0xC824   ;Check0Ref enable flag
Vec_Loop_Count  =     0xC825   ;Loop counter word (incremented in Wait_Recal)
Vec_Brightness  =     0xC827   ;Default brightness
Vec_Dot_Dwell   =     0xC828   ;Dot dwell time?
Vec_Pattern     =     0xC829   ;Dot pattern (bits)
Vec_Text_HW     =     0xC82A   ;Default text height and width
Vec_Text_Height =     0xC82A   ;Default text height
Vec_Text_Width  =     0xC82B   ;Default text width
Vec_Str_Ptr     =     0xC82C   ;Temporary string pointer for Print_Str
Vec_Counters    =     0xC82E   ;Six bytes of counters
Vec_Counter_1   =     0xC82E   ;First  counter byte
Vec_Counter_2   =     0xC82F   ;Second counter byte
Vec_Counter_3   =     0xC830   ;Third  counter byte
Vec_Counter_4   =     0xC831   ;Fourth counter byte
Vec_Counter_5   =     0xC832   ;Fifth  counter byte
Vec_Counter_6   =     0xC833   ;Sixth  counter byte
Vec_RiseRun_Tmp =     0xC834   ;Temp storage word for rise/run
Vec_Angle       =     0xC836   ;Angle for rise/run and rotation calculations
Vec_Run_Index   =     0xC837   ;Index pair for run
;                       0xC839   ;Pointer to copyright string during startup
Vec_Rise_Index  =     0xC839   ;Index pair for rise
;                       0xC83B   ;High score cold-start flag (=0 if valid)
Vec_RiseRun_Len =     0xC83B   ;length for rise/run
;                       0xC83C   ;temp byte
Vec_Rfrsh       =     0xC83D   ;Refresh time (divided by 1.5MHz)
Vec_Rfrsh_lo    =     0xC83D   ;Refresh time low byte
Vec_Rfrsh_hi    =     0xC83E   ;Refresh time high byte
Vec_Music_Work  =     0xC83F   ;Music work buffer (14 bytes, backwards?)
Vec_Music_Wk_A  =     0xC842   ;        register 10
;                       0xC843   ;        register 9
;                       0xC844   ;        register 8
Vec_Music_Wk_7  =     0xC845   ;        register 7
Vec_Music_Wk_6  =     0xC846   ;        register 6
Vec_Music_Wk_5  =     0xC847   ;        register 5
;                       0xC848   ;        register 4
;                       0xC849   ;        register 3
;                       0xC84A   ;        register 2
Vec_Music_Wk_1  =     0xC84B   ;        register 1
;                       0xC84C   ;        register 0
Vec_Freq_Table  =     0xC84D   ;Pointer to note-to-frequency table (normally 0xFC8D)
Vec_Max_Players =     0xC84F   ;Maximum number of players for Select_Game
Vec_Max_Games   =     0xC850   ;Maximum number of games for Select_Game
Vec_ADSR_Table  =     0xC84F   ;Storage for first music header word (ADSR table)
Vec_Twang_Table =     0xC851   ;Storage for second music header word ('twang' table)
Vec_Music_Ptr   =     0xC853   ;Music data pointer
Vec_Expl_ChanA  =     0xC853   ;Used by Explosion_Snd - bit for first channel used?
Vec_Expl_Chans  =     0xC854   ;Used by Explosion_Snd - bits for all channels used?
Vec_Music_Chan  =     0xC855   ;Current sound channel number for Init_Music
Vec_Music_Flag  =     0xC856   ;Music active flag (0x00=off 0x01=start 0x80=on)
Vec_Duration    =     0xC857   ;Duration counter for Init_Music
Vec_Music_Twang =     0xC858   ;3 word 'twang' table used by Init_Music
Vec_Expl_1      =     0xC858   ;Four bytes copied from Explosion_Snd's U-reg parameters
Vec_Expl_2      =     0xC859   ;
Vec_Expl_3      =     0xC85A   ;
Vec_Expl_4      =     0xC85B   ;
Vec_Expl_Chan   =     0xC85C   ;Used by Explosion_Snd - channel number in use?
Vec_Expl_ChanB  =     0xC85D   ;Used by Explosion_Snd - bit for second channel used?
Vec_ADSR_Timers =     0xC85E   ;ADSR timers for each sound channel (3 bytes)
Vec_Music_Freq  =     0xC861   ;Storage for base frequency of each channel (3 words)
;                       0xC85E   ;Scratch 'score' storage for Display_Option (7 bytes)
Vec_Expl_Flag   =     0xC867   ;Explosion_Snd initialization flag?
;               0xC868...0xC876   ;Unused?
Vec_Expl_Timer  =     0xC877   ;Used by Explosion_Snd
;                       0xC878   ;Unused?
Vec_Num_Players =     0xC879   ;Number of players selected in Select_Game
Vec_Num_Game    =     0xC87A   ;Game number selected in Select_Game
Vec_Seed_Ptr    =     0xC87B   ;Pointer to 3-byte random number seed (=0xC87D)
Vec_Random_Seed =     0xC87D   ;Default 3-byte random number seed
                                ;
;    0xC880 - 0xCBEA is user RAM  ;
                                ;
Vec_Default_Stk =     0xCBEA   ;Default top-of-stack
Vec_High_Score  =     0xCBEB   ;High score storage (7 bytes)
Vec_SWI3_Vector =     0xCBF2   ;SWI2/SWI3 interrupt vector (3 bytes)
Vec_SWI2_Vector =     0xCBF2   ;SWI2/SWI3 interrupt vector (3 bytes)
Vec_FIRQ_Vector =     0xCBF5   ;FIRQ interrupt vector (3 bytes)
Vec_IRQ_Vector  =     0xCBF8   ;IRQ interrupt vector (3 bytes)
Vec_SWI_Vector  =     0xCBFB   ;SWI/NMI interrupt vector (3 bytes)
Vec_NMI_Vector  =     0xCBFB   ;SWI/NMI interrupt vector (3 bytes)
Vec_Cold_Flag   =     0xCBFE   ;Cold start flag (warm start if = 0x7321)
                                ;
VIA_port_b      =     0xD000   ;VIA port B data I/O register
;       0 sample/hold (0=enable  mux 1=disable mux)
;       1 mux sel 0
;       2 mux sel 1
;       3 sound BC1
;       4 sound BDIR
;       5 comparator input
;       6 external device (slot pin 35) initialized to input
;       7 /RAMP
VIA_port_a      =     0xD001   ;VIA port A data I/O register (handshaking)
VIA_DDR_b       =     0xD002   ;VIA port B data direction register (0=input 1=output)
VIA_DDR_a       =     0xD003   ;VIA port A data direction register (0=input 1=output)
VIA_t1_cnt_lo   =     0xD004   ;VIA timer 1 count register lo (scale factor)
VIA_t1_cnt_hi   =     0xD005   ;VIA timer 1 count register hi
VIA_t1_lch_lo   =     0xD006   ;VIA timer 1 latch register lo
VIA_t1_lch_hi   =     0xD007   ;VIA timer 1 latch register hi
VIA_t2_lo       =     0xD008   ;VIA timer 2 count/latch register lo (refresh)
VIA_t2_hi       =     0xD009   ;VIA timer 2 count/latch register hi
VIA_shift_reg   =     0xD00A   ;VIA shift register
VIA_aux_cntl    =     0xD00B   ;VIA auxiliary control register
;       0 PA latch enable
;       1 PB latch enable
;       2 \                     110=output to CB2 under control of phase 2 clock
;       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
;       4 /
;       5 0=t2 one shot                 1=t2 free running
;       6 0=t1 one shot                 1=t1 free running
;       7 0=t1 disable PB7 output       1=t1 enable PB7 output
VIA_cntl        =     0xD00C   ;VIA control register
;       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
;       1 \
;       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
;       3 /
;       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
;       5 \
;       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
;       7 /
VIA_int_flags   =     0xD00D   ;VIA interrupt flags register
;               bit                             cleared by
;       0 CA2 interrupt flag            reading or writing port A I/O
;       1 CA1 interrupt flag            reading or writing port A I/O
;       2 shift register interrupt flag reading or writing shift register
;       3 CB2 interrupt flag            reading or writing port B I/O
;       4 CB1 interrupt flag            reading or writing port A I/O
;       5 timer 2 interrupt flag        read t2 low or write t2 high
;       6 timer 1 interrupt flag        read t1 count low or write t1 high
;       7 IRQ status flag               write logic 0 to IER or IFR bit
VIA_int_enable  =     0xD00E   ;VIA interrupt enable register
;       0 CA2 interrupt enable
;       1 CA1 interrupt enable
;       2 shift register interrupt enable
;       3 CB2 interrupt enable
;       4 CB1 interrupt enable
;       5 timer 2 interrupt enable
;       6 timer 1 interrupt enable
;       7 IER set/clear control
VIA_port_a_nohs =     0xD00F   ;VIA port A data I/O register (no handshaking)

Cold_Start      =     0xF000   ;
Warm_Start      =     0xF06C   ;
Init_VIA        =     0xF14C   ;
Init_OS_RAM     =     0xF164   ;
Init_OS         =     0xF18B   ;
Wait_Recal      =     0xF192   ;
Set_Refresh     =     0xF1A2   ;
DP_to_D0        =     0xF1AA   ;
DP_to_C8        =     0xF1AF   ;
Read_Btns_Mask  =     0xF1B4   ;
Read_Btns       =     0xF1BA   ;
Joy_Analog      =     0xF1F5   ;
Joy_Digital     =     0xF1F8   ;
Sound_Byte      =     0xF256   ;
Sound_Byte_x    =     0xF259   ;
Sound_Byte_raw  =     0xF25B   ;
Clear_Sound     =     0xF272   ;
Sound_Bytes     =     0xF27D   ;
Sound_Bytes_x   =     0xF284   ;
Do_Sound        =     0xF289   ;
Do_Sound_x      =     0xF28C   ;
Intensity_1F    =     0xF29D   ;
Intensity_3F    =     0xF2A1   ;
Intensity_5F    =     0xF2A5   ;
Intensity_7F    =     0xF2A9   ;
Intensity_a     =     0xF2AB   ;
Dot_ix_b        =     0xF2BE   ;
Dot_ix          =     0xF2C1   ;
Dot_d           =     0xF2C3   ;
Dot_here        =     0xF2C5   ;
Dot_List        =     0xF2D5   ;
Dot_List_Reset  =     0xF2DE   ;
Recalibrate     =     0xF2E6   ;
Moveto_x_7F     =     0xF2F2   ;
Moveto_d_7F     =     0xF2FC   ;
Moveto_ix_FF    =     0xF308   ;
Moveto_ix_7F    =     0xF30C   ;
Moveto_ix_b     =     0xF30E   ;
Moveto_ix       =     0xF310   ;
Moveto_d        =     0xF312   ;
Reset0Ref_D0    =     0xF34A   ;
Check0Ref       =     0xF34F   ;
Reset0Ref       =     0xF354   ;
Reset_Pen       =     0xF35B   ;
Reset0Int       =     0xF36B   ;
Print_Str_hwyx  =     0xF373   ;
Print_Str_yx    =     0xF378   ;
Print_Str_d     =     0xF37A   ;
Print_List_hw   =     0xF385   ;
Print_List      =     0xF38A   ;
Print_List_chk  =     0xF38C   ;
Print_Ships_x   =     0xF391   ;
Print_Ships     =     0xF393   ;
Mov_Draw_VLc_a  =     0xF3AD   ;count y x y x ...
Mov_Draw_VL_b   =     0xF3B1   ;y x y x ...
Mov_Draw_VLcs   =     0xF3B5   ;count scale y x y x ...
Mov_Draw_VL_ab  =     0xF3B7   ;y x y x ...
Mov_Draw_VL_a   =     0xF3B9   ;y x y x ...
Mov_Draw_VL     =     0xF3BC   ;y x y x ...
Mov_Draw_VL_d   =     0xF3BE   ;y x y x ...
Draw_VLc        =     0xF3CE   ;count y x y x ...
Draw_VL_b       =     0xF3D2   ;y x y x ...
Draw_VLcs       =     0xF3D6   ;count scale y x y x ...
Draw_VL_ab      =     0xF3D8   ;y x y x ...
Draw_VL_a       =     0xF3DA   ;y x y x ...
Draw_VL         =     0xF3DD   ;y x y x ...
Draw_Line_d     =     0xF3DF   ;y x y x ...
Draw_VLp_FF     =     0xF404   ;pattern y x pattern y x ... 0x01
Draw_VLp_7F     =     0xF408   ;pattern y x pattern y x ... 0x01
Draw_VLp_scale  =     0xF40C   ;scale pattern y x pattern y x ... 0x01
Draw_VLp_b      =     0xF40E   ;pattern y x pattern y x ... 0x01
Draw_VLp        =     0xF410   ;pattern y x pattern y x ... 0x01
Draw_Pat_VL_a   =     0xF434   ;y x y x ...
Draw_Pat_VL     =     0xF437   ;y x y x ...
Draw_Pat_VL_d   =     0xF439   ;y x y x ...
Draw_VL_mode    =     0xF46E   ;mode y x mode y x ... 0x01
Print_Str       =     0xF495   ;
Random_3        =     0xF511   ;
Random          =     0xF517   ;
Init_Music_Buf  =     0xF533   ;
Clear_x_b       =     0xF53F   ;
Clear_C8_RAM    =     0xF542   ;never used by GCE carts?
Clear_x_256     =     0xF545   ;
Clear_x_d       =     0xF548   ;
Clear_x_b_80    =     0xF550   ;
Clear_x_b_a     =     0xF552   ;
Dec_3_Counters  =     0xF55A   ;
Dec_6_Counters  =     0xF55E   ;
Dec_Counters    =     0xF563   ;
Delay_3         =     0xF56D   ;30 cycles
Delay_2         =     0xF571   ;25 cycles
Delay_1         =     0xF575   ;20 cycles
Delay_0         =     0xF579   ;12 cycles
Delay_b         =     0xF57A   ;5*B + 10 cycles
Delay_RTS       =     0xF57D   ;5 cycles
Bitmask_a       =     0xF57E   ;
Abs_a_b         =     0xF584   ;
Abs_b           =     0xF58B   ;
Rise_Run_Angle  =     0xF593   ;
Get_Rise_Idx    =     0xF5D9   ;
Get_Run_Idx     =     0xF5DB   ;
Get_Rise_Run    =     0xF5EF   ;
Rise_Run_X      =     0xF5FF   ;
Rise_Run_Y      =     0xF601   ;
Rise_Run_Len    =     0xF603   ;

Rot_VL_ab       =     0xF610   ;
Rot_VL          =     0xF616   ;
Rot_VL_Mode   =     0xF61F   ;
Rot_VL_M_dft     =     0xF62B   ;
;Rot_VL_dft      EQU     0xF637   ;


;Rot_VL_ab       EQU     0xF610   ;
;Rot_VL          EQU     0xF616   ;
;Rot_VL_Mode_a   EQU     0xF61F   ;
;Rot_VL_Mode     EQU     0xF62B   ;
;Rot_VL_dft      EQU     0xF637   ;

Xform_Run_a     =     0xF65B   ;
Xform_Run       =     0xF65D   ;
Xform_Rise_a    =     0xF661   ;
Xform_Rise      =     0xF663   ;
Move_Mem_a_1    =     0xF67F   ;
Move_Mem_a      =     0xF683   ;
Init_Music_chk  =     0xF687   ;
Init_Music      =     0xF68D   ;
Init_Music_x    =     0xF692   ;
Select_Game     =     0xF7A9   ;
Clear_Score     =     0xF84F   ;
Add_Score_a     =     0xF85E   ;
Add_Score_d     =     0xF87C   ;
Strip_Zeros     =     0xF8B7   ;
Compare_Score   =     0xF8C7   ;
New_High_Score  =     0xF8D8   ;
Obj_Will_Hit_u  =     0xF8E5   ;
Obj_Will_Hit    =     0xF8F3   ;
Obj_Hit         =     0xF8FF   ;
Explosion_Snd   =     0xF92E   ;
Draw_Grid_VL    =     0xFF9F   ;
                                ;
music1  = 0xFD0D               ;
music2  = 0xFD1D               ;
music3  = 0xFD81               ;
music4  = 0xFDD3               ;
music5  = 0xFE38               ;
music6  = 0xFE76               ;
music7  = 0xFEC6               ;
music8  = 0xFEF8               ;
music9  = 0xFF26               ;
musica  = 0xFF44               ;
musicb  = 0xFF62               ;
musicc  = 0xFF7A               ;
musicd  = 0xFF8F               ;
Char_Table = 0xF9F4
Char_Table_End = 0xFBD4

 .area .bss
; include line ->  include "YM_VAR.I"
 .globl current_register
current_register:
                .byte 0
 .globl temp
temp:
                .byte 0
 .globl temp2
temp2:
                .byte 0
 .globl temp3
temp3:
                .byte 0
 .globl calc_coder
calc_coder:
                .byte 0
 .globl calc_bits
calc_bits:
                .byte 0
 .globl ym_data_len
ym_data_len:
                .word 0
 .globl ym_data_current
ym_data_current:
                .word 0
 .globl ym_name
ym_name:
                .word 0
 .globl ym_data_start
ym_data_start:
                .blkb (STRUCTURE_LENGTH*11)
 .area .text
; include line ->  include "YM_MAK.I"
;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
; include line ->                 INCLUDE "VECTREX.I" ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains includes for vectrex BIOS functions and variables      ;
; it was written by Bruce Tomlin, slighte changed by Malban                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INFO_START = 0
BYTE_POSITION = 0
BIT_POSITION = 2
CURRENT_BYTE = 3
CURRENT_UNPACKED_BYTE = 4
CURRENT_RLE_COUNTER = 5
CURRENT_RLE_MAPPER = 7
CURRENT_IS_PHRASE = 9
CURRENT_PHRASE_BYTE = 11
CURRENT_PHRASE_START = 12
INFO_END = 14
STRUCTURE_LENGTH = (INFO_END-INFO_START)
;***************************************************************************
 .globl do_ym_sound
do_ym_sound:
                ldd     ym_data_current
                beq     do_ym_sound_done
                subd    #1
                std     ym_data_current
                clra
                sta     current_register
                ldu     #ym_data_start
 .globl next_reg
next_reg:
                jsr    get_current_byte
                lda    current_register
                ; A PSG reg
                ; B data
                jsr Sound_Byte

                leau    STRUCTURE_LENGTH,u
                inc     current_register
                lda     current_register
                cmpa    #11
                bne     next_reg
 .globl do_ym_sound_done
do_ym_sound_done:
                RTS

 .globl no_valid_byte
no_valid_byte:
; no we must look at the bits
; a will be our bit register
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_1
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #0x80
                stb     BIT_POSITION,u
 .globl byte_ready_1
byte_ready_1:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
; zero flag show bit
; A is 1 or zero
                lbne     no_single_byte
 .globl single_byte
single_byte:
                ; must be zero
                ; 1 is allways only 8 bit...
                inc      CURRENT_RLE_COUNTER+1,u
 .globl dechifer
dechifer:
                clr       calc_bits
                clr       calc_coder
 .globl try_next_bit
try_next_bit:
                lsl       calc_coder
                inc       calc_bits    ; increase used bits
;;;;;;;;;;;; GET_BIT_START
                ldb     BIT_POSITION,u
                bne     byte_ready
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #0x80
                stb     BIT_POSITION,u
 .globl byte_ready
byte_ready:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     no_add     ; and if non zero
                inc     calc_coder
;;;;;;;;;;;; GET_BIT_END
 .globl no_add
no_add:
; we load one complete = of mapper index, bits, coder, map-value
                ldx       CURRENT_RLE_MAPPER,u
 .globl search_again
search_again:
                leax      3,x
                lda       ,x          ; load bits from map
                anda      #127         ; map out phrases
                cmpa      calc_bits      ; neu
                bgt       try_next_bit ; neu
                bne       search_again
                ldb       1,x          ; load coder-byte
                cmpb      calc_coder
                bne       search_again
                ldb       2,x           ; load current mapped byte!
; in b is the byte value we sought
; test for phrase
                lda       ,x          ; load bits from map
                anda     #128         ; map in phrases only
                beq      no_phrase_d
; if phrase, than in b the count of the phrase used
                ldx      CURRENT_PHRASE_START,u
                tstb
                beq     phrase_found
 .globl next_phrase
next_phrase:
                lda     ,x+
                leax    a,x
                decb
                bne     next_phrase
 .globl phrase_found
phrase_found:
                stx     CURRENT_IS_PHRASE,u
                clr     CURRENT_PHRASE_BYTE,u
                bra      out
 .globl no_phrase_d
no_phrase_d:
                clr      CURRENT_IS_PHRASE,u
                clr      CURRENT_IS_PHRASE+1,u
                stb      CURRENT_UNPACKED_BYTE,u
 .globl out
out:

; U pointer to data structure
; A number of register
 .globl get_current_byte
get_current_byte:
; do we have a byte that is valid?
                ldd      CURRENT_RLE_COUNTER,u
                beq      no_valid_byte
; yep... use current byte
                ldx       CURRENT_IS_PHRASE,u
                beq       no_phrase
                lda       ,x+ ; length of phrase
                ldb       CURRENT_PHRASE_BYTE,u
                ldb       b,x ; this is the current byte
                stb       CURRENT_UNPACKED_BYTE,u
                inc       CURRENT_PHRASE_BYTE,u
                cmpa      CURRENT_PHRASE_BYTE,u
                bne       counter_not_minus_one
                clr       CURRENT_PHRASE_BYTE,u
                ldd       CURRENT_RLE_COUNTER,u
 .globl no_phrase
no_phrase:
                subd      #1
                std       CURRENT_RLE_COUNTER,u
 .globl counter_not_minus_one
counter_not_minus_one:
                ldb       CURRENT_UNPACKED_BYTE,u
                rts

 .globl no_single_byte
no_single_byte:
; non single byte here... must decode
; first we look for how many bits the RLE counter spreads

                ; we already encountered a 1
                ; and we allways use + 2
                lda     #2
                sta     temp
 .globl more_bits
more_bits:
                inc     temp
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_2
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #0x80
                stb     BIT_POSITION,u
 .globl byte_ready_2
byte_ready_2:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
                bne     more_bits
; in temp is the # of bits for the counter
; the following '#temp' bits represent the RLE count
; lsb first
                incb            ; we start at 1, since zero is an
                                ; 'own' 'subroutine',
                                ; which doesn't manipulate the temps
                stb     temp2   ; bit counter for shifting
                stb     temp3   ; bit counter for shifting
 .globl go_on
go_on:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_3
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #0x80
                stb     BIT_POSITION,u
 .globl byte_ready_3
byte_ready_3:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     end_here_3
; return 1
                ldb     #1
 .globl end_here_3
end_here_3:
;;;;;;;;;;;;;;;;;;; GET_BIT END
; in D now one bit at the right position for the RLE counter
                stb     CURRENT_RLE_COUNTER+1,u
; the first 3 (here only the first one) rounds
; we need not check for temp, since it is at least 3...
 .globl go_on_2
go_on_2:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_4
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #0x80
                stb     BIT_POSITION,u
 .globl byte_ready_4
byte_ready_4:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     end_here_4
; return 1
                ldb     #1
 .globl end_here_4
end_here_4:
                clra
 .globl shifting_not_yet_done
shifting_not_yet_done:
                      LSLA               ; LSR A
                      LSLB               ; LSR B
                      BCC no_carry       ; if no carry, than exit
                      ORA #1             ; otherwise underflow from A to 7bit of B
 .globl no_carry
no_carry:
                dec     temp3
                bne     shifting_not_yet_done
 .globl shifting_done
shifting_done:
; in D now one bit at the right position for the RLE counter
                addd    CURRENT_RLE_COUNTER,u
                std     CURRENT_RLE_COUNTER,u

                inc     temp2
                lda     temp2
                sta     temp3
                cmpa    temp
                bne     go_on_2
; now the current counter should be set

; we still need to dechifer the following byte...
                jmp       dechifer

 .globl init_ym_sound
init_ym_sound:
                ldx     #ym_data_start
                ldd     #(STRUCTURE_LENGTH*11)
                jsr     Clear_x_d

                ldy     ,u++
                ldd     ,y
                std     ym_data_len
                std     ym_data_current
                ldb     #11
 .globl next_reg_init
next_reg_init:
                ldy     ,u++
                sty     CURRENT_RLE_MAPPER,x
                ldy     ,u++
                sty     CURRENT_PHRASE_START,x
                ldy     ,u++
                sty     BYTE_POSITION,x
                leax    STRUCTURE_LENGTH,x
                decb
                bne     next_reg_init
                stu     ym_name
                RTS
