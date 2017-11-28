// ***************************************************************************
// VECTREX EXECUTIVE BIOS CALL ADRESSES
// as described in the Vectrex Programmer's Manual Volume 2
// ***************************************************************************
// quick reference - do not use this file as header file
// use #include <vectrex.h> instead
// ***************************************************************************
// This file was developed by Prof. Dr. Peer Johannsen as part of the 
// "Retro-Programming" and "Advanced C Programming" class at
// Pforzheim University, Germany.
// 
// It can freely be used, but at one's own risk and for non-commercial
// purposes only. Please respect the copyright and credit the origin of
// this file.
//
// Feedback, suggestions and bug-reports are welcome and can be sent to:
// peer.johannsen@pforzheim-university.de
// ***************************************************************************
// The BIOS calls assume that the DP register is set up correctly,
// so you are responsible for doing that by using the BIOS calls
// DP_to_D0(...); or DP_to_C8(...); as apropriate
// ***************************************************************************

// 1. Calibration and Vector Reset Functions
// 2. Counter Handling Functions
// 3. Direct Page Register Functions
// 4. Delay Functions
// 5.1 Dot Drawing Routines
// 5.2 String Drawing Routines
// 5.3.1 'DIFFY' Style Drawing Routines
// 5.3.2. 'DUFFY' Style Drawing Routines
// 5.3.3. 'PACKET' Style Drawing Routines
// 6. Mathematical Functions
// 7.1 Memory Management - Memory Clear Functions
// 7.2 Memory Management - Memory Copy Functions
// 7.3 Memory Management - Memory Fill Functions
// 8. Controller / Joystick Routines
// 9. Player Option Functions
// 12. Sound Functions
// 13. Vector Beam Positioning Functions
// 14. Vector Brightness Functions
// 15.1 Object Collision Detection Functions
// 15.2 Rotate Routines

// ---------------------------------------------------------------------------
// 1. Calibration and Vector Reset Functions

// FRAM20 	0xF192 	FRWAIT 	Wait for frame boundary
// DEFLOK 	0xF2E6 	--- 	Overcome scan collapse circuitry
// ZERO.DP 	0xF34A 	ZERO.DP 	Zero integrators and set active ground
// ZEGO 	0xF34F 	ZEGO 	Zero integrators and set active ground
// ZEROIT 	0xF354 	ZEROIT 	Zero integrators and set active ground
// ZEREF 	0xF35B 	ZEREF 	Zero integrators and set active ground
// ZERO. 	0xF36B 	ZERO 	Zero integrators and set active ground

void Wait_Recal();  // 0xF192
void Recalibrate();  // 0xF2E6 
void Reset0Ref_D0();  // 0xF34A
void Check0Ref();  // 0xF34F 
void Reset0Ref();  // 0xF354 
void Reset_Pen();  // 0xF35B
void Reset0Int();  // 0xF36B
  
// ---------------------------------------------------------------------------
// 2. Counter Handling Functions

// DEKR3 	0xF55A 	D3TMR 	Decrement interval timers
// DEKR 	0xF55E 	DECTMR 	Decrement interval timers
// DEKRCNT	0xF563	---		Decrement counters, inofficial!

void Dec_3_Counters();  // 0xF55A
void Dec_6_Counters();  // 0xF55E
void Dec_Counters(unsigned int b, void* x);  // 0xF563

// ---------------------------------------------------------------------------
// 3. Direct Page Register Functions

// DPIO 	0xF1AA 	--- 	Set direct register
// DPRAM 	0xF1AF 	--- 	Set direct register

void DP_to_D0();  // 0xF1AA
void DP_to_C8();  // 0xF1AF

// ---------------------------------------------------------------------------
// 4. Delay Functions

// DEL38 	0xF56D 	--- 	Programmed delays
// DEL33 	0xF571 	--- 	Programmed delays
// DEL28 	0xF575 	--- 	Programmed delays
// DEL20 	0xF579 	--- 	Programmed delays
// DEL 		0xF57A 	--- 	Programmed delays
// DEL13 	0xF57D 	--- 	Programmed delays

void Delay_3();  // 0xF56D, 30 cycles
void Delay_2();  // 0xF571, 25 cycles
void Delay_1();  // 0xF575, 20 cycles
void Delay_0();  // 0xF579, 12 cycles
void Delay_b(unsigned int b);  // 0xF57A, 5*B + 10 cycles
void Delay_RTS();  // 0xF57D, 5 cycles

// ---------------------------------------------------------------------------
// 5.1 Dot Drawing Routines
 
// DOTTIM 	0xF2BE 	--- 	Draw one dot from 'DIFFY' style list
// DOTX 	0xF2C1 	--- 	Draw one dot from 'DIFFY' style list
// DOTAB 	0xF2C3 	--- 	Draw one dot from the contents of 'A' & 'B'
// DOT 		0xF2C5 	--- 	Turn on beam for dot
// DIFDOT 	0xF2D5 	--- 	Draw dots according to 'DIFFY' format
// DOTPAK 	0xF2DE 	DOTPCK 	Draw dots according to 'PACKET' format

void Dot_ix_b(unsigned int b, void* x);  // 0xF2BE 
void Dot_ix(void* x);  // 0xF2C1 
void Dot_d(int a, int b);  // 0xF2C3 
void Dot_dd(long int d);  // 0xF2C3 
void Dot_here();  // 0xF2C5
void Dot_List(void* x);  // 0xF2D5
void Dot_List_Reset(void* x);  // 0xF2DE

// ---------------------------------------------------------------------------
// 5.2 Raster Message Drawing Routines (Strings);
 
// SIZPRAS 	0xF373 	RSTSIZ 	Display raster message
// POSNRAS 	0xF378 	RSTPOS 	Display raster message
// POSDRAS 	0xF37A 	MSSPOS 	Display raster message
// TEXSIZ 	0xF385 	TXTSIZ 	Display raster message
// TEXPOS 	0xF38C 	TXTPOS 	Display raster message
// SHIPSAT 	0xF391 	SHIPX 	Display markers (count remaining);
// SHIPSHO 	0xF393 	DSHIP 	Display markers (count remaining);
// RASTUR 	0xF495 	RASTER 	Display raster string
// RASTER 	0xF498 	MRASTR 	Display raster string

void Print_Str_hwyx(void* u);  // 0xF373 
void Print_Str_yx(const void* u);  // 0xF378
void Print_Str_d(int a, int b, void* u);  // 0xF37A
void Print_Str_dd(long int d, void* u);  // 0xF37A
void Print_List_hw(void* u);  // 0xF385
void Print_List(void* u);  // 0xF38A, not official!
void Print_List_chk(void* u);  // 0xF38C 
void Print_Ships_x(unsigned int a, unsigned int b, void* x);  // 0xF391 
void Print_Ships(unsigned int a, unsigned int b, unsigned long int x);  // 0xF393 
void Print_Str(void* u);  // 0xF495
void Print_MRast();  // 0xF498

// ---------------------------------------------------------------------------
// 5.3.1 DIFFY Style Drawing Routines

// A DIFFY style list contains a counted collection of relative (Y:X); coordinate pairs. When
// processing one of these, the drawing functions will draw a line from the current pen position to
// the first point in the list. A line is then drawn to the next relative coordinate, until no more points
// remain.

// Depending upon the function processing the list, the first byte may be expected to contain the
// ‘Vector count –1’, or this value may need to be stored into RAM.

// Depending upon the function processing the list, the second byte may be expected to contain the
// scale factor to be used when processing the list, or this value may need to be stored into RAM.

// A sample DIFFY list might look like the following:
// byte 0 - Vector count – 1 [optional]
// byte 1 - Scale factor [optional]
// bytes 2 / 3 - ‘Y:X’ for coordinate 1
// bytes n / n+1 - ‘Y:X’ for coordinate ‘n’
 
// DIFFAX 	0xF3CE 	--- 	Draw from 'DIFFY' style list
// DIFTIM 	0xF3D2 	--- 	Draw from 'DIFFY' style list
// DIFLST 	0xF3D6 	--- 	Draw from 'DIFFY' style list
// DIFTLS 	0xF3DA 	LDIFFY 	Draw from 'DIFFY' style list
// DIFFX 	0xF3D8 	TDIFFY 	Draw from 'DIFFY' style list
// DIFFY 	0xF3DD 	--- 	Draw from 'DIFFY' style list
// DIFFAB 	0xF3DF 	--- 	Draw from 'DIFFY' style list
// DASHE 	0xF433 	DSHDF1 	Draw dashed lines from 'DIFFY' list
// DASHEL 	0xF434 	DSHDF 	Draw dashed lines from 'DIFFY' list
// DASHY 	0xF437 	DASHDF 	Draw dashed lines from 'DIFFY' list
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate
// DISROT 	0xF613 	BDROT 	'DIFFY' style rotate
// DIFROT 	0xF616 	ADROT 	'DIFFY' style rotate
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate

void Draw_Pat_VL_a(unsigned int a, void* x);  // 0xF434
void Draw_Pat_VL(void* x);  // 0xF437
void Draw_Line_d(int a, int b);  // 0xF3DF
void Draw_VLc(void* x);  // 0xF3CE, count y x y x ...
void Draw_VL_ab(unsigned int a, unsigned int b, void* x);  // 0xF3D8
void Draw_VL(void* x);  // 0xF3DD, y x y x ...
void Draw_VLcs(void* x);  // 0xF3D6, count scale y x y x ...
void Draw_VL_b(unsigned int b, void* x);  // 0xF3D2, x x y x ...
void Draw_VL_a(unsigned int a, void* x);  // 0xF3DA, y x y x ...

// ---------------------------------------------------------------------------
// 5.3.2. DUFFY Style Drawing Routines

// A DUFFY style list is identical to a DIFFY style list. The only difference appears to be in the way
// that it is processed. When processing one of these, the drawing functions will move to the first
// point in the list. It will then draw a line to the next relative coordinate, until no more points
// remain.

// DUFFAX 	0xF3AD 	--- 	Draw from 'DUFFY' style list
// DUFTIM	0xF3B1 	--- 	Draw from 'DUFFY' style list
// DUFLST 	0xF3B5 	DUFFX 	Draw from 'DUFFY' style list
// DUFTLS	0xF3B7  TDUFFY	Draw from 'DUFFY' style list
// DUFLSTAX	0xF3B9  LDUFFY	Draw from 'DUFFY' style list
// DUFFY 	0xF3BC 	--- 	Draw from 'DUFFY' style list
// DUFFAB 	0xF3BE 	--- 	Draw from 'DUFFY' style list

void Mov_Draw_VLc_a(void* x);  // 0xF3AD, count y x y x ...
void Mov_Draw_VL_b(unsigned int b, void* x);  // 0xF3B1, y x y x ...
void Mov_Draw_VLcs(void* x);  // 0xF3B5, count scale y x y x ...
void Mov_Draw_VL_ab(unsigned int a, unsigned int b, void* x);  // 0xF3B7
void Mov_Draw_VL_a(unsigned int a, void* x);  // 0xF3B9, y x y x ...
void Mov_Draw_VL(void* x);  // 0xF3BC, y x y x ...
void Mov_Draw_VL_d(int a, int b);  // 0xF3BE, y x

// ---------------------------------------------------------------------------
// 5.3.3 PACKET Style Drawing and Rotation Routines

// A PACKET style list is an uncounted list of (mode:Y:X); triplets. This type of packet is useful if
// you need to mix move and draw requests within the same list. The end of the list is indicated by
// the presence of a list terminator ($01);.

// Depending upon the function processing the list, the first byte may be expected to contain the
// scale factor to be used when processing tlist, or this value may need to be stored into RAM.

// A sample PACKET list might look like the following:
// byte 0 - Scale factor
// bytes 1 / 2 / 3 - ‘mode:Y:X’ for coordinate 1
// bytes n / n+1 / n+2 - ‘mode:Y:X’ for coordinate ‘n’
// $01 - packet terminator
// where ‘mode’ can assume one of the following values:
// $00 - Move to the specified point
// $FF - Draw a line to the specified point

// DASHY3 	0xF46E 	DASHPK 	Draw dashed lines from 'PACKET' list
// PAC1X 	0xF408 	PACK1X 	Draw from 'PACKET' style list
// PAC2X 	0xF404 	PACK2X 	Draw from 'PACKET' style list
// PACB 	0xF40E 	TPACK 	Draw from 'PACKET' list
// PACKET 	0xF410 	--- 	Draw from 'PACKET' list
// PACXX 	0xF40C 	LPACK 	Draw from 'PACKET' style list
// POTATA 	0xF61F 	PROT 	'PACKET' style rotate
// POTATE 	0xF622 	APROT 	'PACKET' style rotate

void Draw_VL_mode(const void* x);  // 0xF46E
void Draw_VLp_7F(void* x);  // 0xF408, pattern y x pattern y x ... 0x01
void Draw_VLp_FF(void* x);  // 0xF404, pattern y x pattern y x ... 0x01
void Draw_VLp_b(unsigned int b, void* x);  // 0xF40E, scale pattern y x pattern y x ... 0x01
void Draw_VLp(void* x);  // 0xF410, pattern y x pattern y x ... 0x01
void Draw_VLp_scale(void* x);  // 0xF40C, scale pattern y x pattern y x ... 0x01
void Rot_VL_Mode_a(unsigned int a, void* x, void* u);  // 0xF61F 
void Rot_VL_Pack(void* x, void* u);  // 0xF622

// ---------------------------------------------------------------------------
// 6. Mathematical Functions

// RAND3 	0xF511 	--- 	Calculate new random number
// RANDOM 	0xF517 	--- 	Calculate new random number

// BITE 	0xF57E 	DECBIT 	Decode bit position

// ABSVAL 	0xF584 	ABSAB 	Form absolute value for 'A' & 'B' registers
// AOK 		0xF58B 	ABSB 	Form absolute value for 'B' register

// COMPAS 	0xF593 	CMPASS 	Return angle for given delta 'Y:X'
// COSGET 	0xF5D9 	COSINE 	Calculate the cosine of 'A'
// SINGET 	0xF5DB 	SINE 	Calculate the sine of 'A'
// SINCOS 	0xF5EF 	--- 	Calculate the sine and cosine of 'ANGLE'

// RSINA 	0xF65B 	MSINE 	Multiply 'A' by previous sine value
// RSIN 	0xF65D 	LSINE 	Multiply 'LEG' by previous sine value
// RCOSA 	0xF661 	MCSINE 	Multiply 'A' by previous cosine value
// RCOS 	0xF663 	LCSINE 	Multiply 'LEG' by previous cosine value

unsigned int Random_3();  // 0xF511 
unsigned int Random();  // 0xF517

unsigned int Bitmask_a(unsigned int a);  // 0xF57E

long unsigned int Abs_a_b(int a, int b);  // 0xF584
unsigned int Abs_b(int b);  // 0xF58B

long unsigned int Rise_Run_Angle(int a, int b);  // 0xF593
long unsigned int Get_Rise_Idx(int a);  // 0xF5D9
int Xform_Sin(int a);  // 0xF5DB
long unsigned int Get_Rise_Run();  // 0xF5EF

int Xform_Run_a(int a);  // 0xF65B 
int Xform_Run();  // 0xF65D 
int Xform_Rise_a(int a);  // 0xF661 
int Xform_Rise();  // 0xF663 

// ---------------------------------------------------------------------------
// 7.1 Memory Management - Memory Clear Functions

// CLRSON 	0xF53F 	BCLR 	Clear 'B' bytes
// CLRMEM 	0xF542 	CLREX 	Clear 256 bytes starting at 0xC800
// CLR256 	0xF545 	---6 	Set-up to clear 256 bytes
// GILL 	0xF548 	CLRBLK 	Clear a block of memory

void Clear_x_b(unsigned int b, void* x);  // 0xF53F
void Clear_C8_RAM();  // 0xF542, never used by GCE carts?
void Clear_x_256(void* x);  // 0xF545
void Clear_x_d(long unsigned int d, void* x);  // 0xF548

// ---------------------------------------------------------------------------
// 7.2 Memory Management - Memory Copy Functions

// BAGAUX 	0xF67F 	BLKMV1 	Xfer bytes source to destination buffer
// STFAUX 	0xF683 	BLKMOV 	Xfer bytes source to destination buffer

void Move_Mem_a_1(unsigned int a, void* x, void* u);  // 0xF67F 
void Move_Mem_a(unsigned int a, void* x, void* u);  // 0xF683

// ---------------------------------------------------------------------------
// 7.3 Memory Management - Memory Fill Functions

// NEGSOM 	0xF550 	CLR80 	Set a block of memory to $80
// FILL 	0xF552 	BLKFIL 	Set a block of memory

void Clear_x_b_80(int b, void* x);  // 0xF550
void Clear_x_b_a(unsigned int a, unsigned int b, void* x);  // 0xF552

// ---------------------------------------------------------------------------
// 8. Controller / Joystick Routines

// ENPUT 	0xF1B4 	DBNCE 	Read controller buttones
// INPUT 	0xF1BA 	--- 	Read controller buttones
// PBANG4 	0xF1F5 	JOYSTK 	Read joystick
// PANG 	0xF1F8 	JOYBIT 	Read joystick

void Read_Btns_Mask(unsigned int a);  // 0xF1B4
void Read_Btns();  // 0xF1BA
void Joy_Analog();  //0xF1F5
void Joy_Digital();  // 0xF1F8

// ---------------------------------------------------------------------------
// 9. Player Option Functions

// OPTION 	0xF7A9 	SELOPT 	Fetch game options
// DISOPT	0xF835	------	Display game option, inofficial!

void Select_Game(unsigned int a, unsigned int b);  // 0xF7A9
void Display_Option(unsigned int a, void* y);  // 0xF835 - inofficial!

// ---------------------------------------------------------------------------
// 10. Reset and Initialization Routines

// POWER 	0xF000 	PWRUP 	Power-up handler
// INITPIA 	0xF14C 	INTPIA 	Initialize PIA
// INITMSC 	0xF164 	INTMSC 	Initialize misc. parameters
// INITALL 	0xF18B 	INTALL 	Full Vectrex initialization
// INITPSG 	0xF272 	INTPSG 	Initialize sound generator
// IREQ 	0xF533 	INTREQ 	Initialize the 'REQZ' area

void Reset();  // 0xF000
void Init_VIA();  // 0xF14C
void Init_OS_RAM();  // 0xF164
void Init_OS();  // 0xF18B
void Init_Music_Buf();  // 0xF533

// ---------------------------------------------------------------------------
// 11. Score / Highscore Routines

// SCLR 	0xF84F 	--- 	Clear indicated score
// SHADD 	0xF85E 	BYTADD 	Add contents of 'A' to indicated score
// SADD 	0xF87C 	SCRADD 	Add contents of 'B' to indicated score
// WINNER 	0xF8C7 	--- 	Determine highest score
// HIGHSCR 	0xF8D8 	HISCR 	Calculate high score and save for logo

void Clear_Score(void* x);  //0xF84F
void Add_Score_a(unsigned int a, void* x);  // 0xF85E
void Add_Score_d(long unsigned int d, void* x);  // 0xF87C
unsigned int Compare_Score(void* x, void* u);  // 0xF8C7
void New_High_Score(void* x, void* u);  //0xF8D8

// ---------------------------------------------------------------------------
// 12. Sound Functions
 
// PSGX 	0xF256 	WRREG 	Write to PSG
// PSG 		0xF259 	WRPSG 	Write to PSG
// INITPSG 	0xF272 	INTPSG 	Initialize sound generator
// PSGLUP 	0xF27D 	PSGLST 	Send sound string to PSG
// PSGULP 	0xF284 	PSGMIR 	Send sound string to PSG
// REQOUT 	0xF289 	--- 	Send 'REQX' to PSG and mirror
// REPLAY 	0xF687 	--- 	Set 'REQX' for given tune
// SPLAY 	0xF68D 	--- 	Set 'REQX' for given tune
// SOPLAY 	0xF690 	ASPLAY 	Set 'REQX' for given tune
// YOPLAY 	0xF692 	TPLAY 	Set 'REQX' for given tune
// XPLAY 	0xF742 	--- 	Set 'REQX' for given tune
// AXE 		0xF92E 	EXPLOD 	Complex explosion sound effect
// LOUDIN 	0xF9CA 	SETAMP 	Complex explosion sound effect

void Sound_Byte(unsigned int a, unsigned int b);  // 0xF256
void Sound_Byte_x(unsigned int a, unsigned int b, void* x);  // 0xF259 
void Clear_Sound();  // 0xF272 
void Sound_Bytes(void* u);  // 0xF27D 
void Sound_Bytes_x(void* x, void* u);  // 0xF284
void Do_Sound();  // 0xF289
void Init_Music_chk(const void* u);  // 0xF687
void Init_Music(void* u);  // 0xF68D 
void Init_Music_a(void* x, void* u);  // 0xF690 
void Init_Music_x(void* u);  // 0xF692 
void Stop_Sound();  // 0xF742
void Explosion_Snd(const void* u);  // 0xF92E 
void Set_Amp(unsigned int b);  // 0xF9CA

// ---------------------------------------------------------------------------
// 13. Vector Beam Positioning Functions

// POSWID 	0xF2F2 	--- 	Position relative vector
// POSITD 	0xF2FC 	--- 	Position relative vector
// POSIT2 	0xF308 	--- 	Position relative vector
// POSIT1 	0xF30C 	--- 	Position relative vector
// POSITB 	0xF30E 	--- 	Position relative vector
// POSITX 	0xF310 	--- 	Position relative vector
// POSITN 	0xF312 	--- 	Position relative vector

void Moveto_x_7F(void* x);  // 0xF2F2
void Moveto_d_7F(int a, int b);  // 0xF2FC
void Moveto_dd_7F(long int d);  // 0xF2FC
void Moveto_ix_FF(void* x);  // 0xF308 
void Moveto_ix_7F(void* x);  // 0xF30C 
void Moveto_ix_b(unsigned int b, void* x);  // 0xF30E 
void Moveto_ix(void* x);  // 0xF310 
void Moveto_d(int a, int b);  // 0xF312

// ---------------------------------------------------------------------------
// 14. Vector Brightness Functions

// INT1Q 	0xF29D 	--- 	Set beam intensity
// INTMID 	0xF2A1 	INT2Q 	Set beam intensity
// INT3Q 	0xF2A5 	--- 	Set beam intensity
// INTMAX 	0xF2A9 	--- 	Set beam intensity
// INTENS 	0xF2AB 	--- 	Set beam intensity

void Intensity_1F();  // 0xF29D
void Intensity_3F();  // 0xF2A1 
void Intensity_5F();  // 0xF2A5 
void Intensity_7F();  // 0xF2A9 
void Intensity_a(unsigned int a);  // 0xF2AB

// ---------------------------------------------------------------------------
// 15.1 Object Collision Detection Functions

// OFF1BOX 	0xF8E5 	OFF1BX 	Symmetric collison test
// OFF2BOX 	0xF8F3 	OFF2BX 	Symmetric collison test
// FINDBOX 	0xF8FF 	BXTEST 	Symmetric collison test

unsigned int Obj_Will_Hit_u(int a, int b, long int x, long int y, long int u);  // 0xF8E5
unsigned int Obj_Will_Hit(int a, int b, long int x, long int y, long int* u);  // 0xF8F3
unsigned int Obj_Hit(int a, int b, long int x, long int y);  // 0xF8FF

// ---------------------------------------------------------------------------
// 15.2 Rotate Routines

// RATOT 	0xF5FF 	LROT90 	Rotate a single line
// ROTOR 	0xF601 	LNROT 	Rotate a single line
// ROTAR 	0xF603 	ALNROT 	Rotate a single line
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate
// DISROT 	0xF613 	BDROT 	'DIFFY' style rotate
// DIFROT 	0xF616 	ADROT 	'DIFFY' style rotate
// POTATA 	0xF61F 	PROT 	'PACKET' style rotate
// POTATE 	0xF622 	APROT 	'PACKET' style rotate

long unsigned int Rise_Run_X(int a, int b);  // 0xF5FF
long unsigned int Rise_Run_Y(int a, int b);  // 0xF601
int Rise_Run_Len(int a);  // 0xF603
void Rot_VL_ab(unsigned int a, unsigned int b, void* x, void* u);   // 0xF610
void Rot_VL_Diff(unsigned int b, void* x, void* u);  // 0xF613
void Rot_VL(void* x, void* u);  // 0xF616 

// ---------------------------------------------------------------------------
// MINESTORM

void Dot_y(long int y);  // 0xEA5D
void Dot_py(void* y);  // 0xEA6D

void Draw_Pack(unsigned int b, void* x, long int y);  // 0xEA7F
void Draw_Pack_py(unsigned int b, void* x, void* y);  // 0xEA8D

void Print_Msg(void* y, void* u);  // 0xEAA8
unsigned int Rnd_Cone();  // 0xEA3E

long unsigned int Displ8_xy(unsigned int a, unsigned int b);  // 0xE7B5
long unsigned int Displ16_xy(unsigned int a, unsigned int b); // 0xE7B5

long unsigned int Ranpos();  // 0xE98A
void Draw_Scores();  // 0xEACF
void Draw_Score();  // 0xEAB4
void Wait_Bound();  // 0xEAF0

// ***************************************************************************
// end of file
// ***************************************************************************
