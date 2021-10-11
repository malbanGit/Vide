// ***************************************************************************
// VECTREX EXECUTIVE ROM ADRESSES
// as described in the Vectrex Programmer's Manual Volume 1
// ***************************************************************************
// quick reference - do not use this file as header file
// use #include <vectrex.h> instead
// ***************************************************************************
//
// Disclaimer:
//
// This file is part of the Vectrex C programming setup developed by 
// Prof. Dr. rer. nat. Peer Johannsen. The setup is used as tool and as
// teaching material in the "Retro-Programming" and the "Advanced
// hardware-oriented C and Assembly Language Programming" classes at
// Pforzheim University, Germany.
// 
// Writing their own games for a vintage arcade game console in a programming
// course and seeing them run on a real Vectrex device has proved to greatly
// contribute to the motivation of the students.
//
// The C programming setup can freely be used by everyone for writing 
// Vectrex games and Vectrex programs in C, but at one's own risk. Please
// respect the copyright and credit the origin of these files.
//
// It would be truly fantastic if those who use this setup and/or these files
// to develop and produce their own Vectrex game cartridges, would support the
// educational approach and aim of these programming classes by donating a
// complimentary cartridge which will then be used as additional motivational
// content.
//
// Many thanks to all those out there who have already supported this course
// in various ways!
//
// Feedback, suggestions and bug-reports are always welcome and can be sent
// to the following contact address:
//
// peer.johannsen@pforzheim-university.de
//
// ***************************************************************************

// ---------------------------------------------------------------------------
// Frequency Table

extern const int Vec_Sine_Table	   // 0xFC6D, sine table
extern const int Vec_Cosine_Table  // 0xFC7D, cosine table
extern const int Vec_Note_Table	   // 0xFC8D, frequency table

// ---------------------------------------------------------------------------
// Built in Melodies

extern const unsigned int Vec_Music_0 // 0xED77, melody, minestorm
extern const unsigned int Vec_Music_1 // 0xFD0D, melody, vectrex opening tune
extern const unsigned int Vec_Music_2 // 0xFD1D, melody, berzerk
extern const unsigned int Vec_Music_3 // 0xFD81, melody, armor attack
extern const unsigned int Vec_Music_4 // 0xFDD3, melody, scramble
extern const unsigned int Vec_Music_5 // 0xFE38, melody, solar quest
extern const unsigned int Vec_Music_6 // 0xFE76, melody, clean sweep
extern const unsigned int Vec_Music_7 // 0xFEC6, melody, star trek
extern const unsigned int Vec_Music_8 // 0xFEF8, melody, fanfare 1
extern const unsigned int Vec_Music_9 // 0xFF26, melody, fanfare 2
extern const unsigned int Vec_Music_a // 0xFF44, melody, fanfare 3 (berzerk)
extern const unsigned int Vec_Music_b // 0xFF62, melody, fanfare 3a
extern const unsigned int Vec_Music_c // 0xFF7A, melody, fanfare 4
extern const unsigned int Vec_Music_d // 0xFF8F, melody, fanfare 5

// ---------------------------------------------------------------------------
// Adsr Tables

extern const unsigned int Vec_ADSR_FADE66 // 0xED8F, adsr table, minestorm
extern const unsigned int Vec_ADSR_FADE0  // 0xFD69, adsr table
extern const unsigned int Vec_ADSR_FADE1  // 0xFE28, adsr table
extern const unsigned int Vec_ADSR_FADE2  // 0xFE66, adsr table
extern const unsigned int Vec_ADSR_FADE3  // 0xFEB2, adsr table
extern const unsigned int Vec_ADSR_FADE4  // 0xFEE8, adsr table
extern const unsigned int Vec_ADSR_FADE8  // 0xFF16, adsr table
extern const unsigned int Vec_ADSR_FADE12 // 0xFDC3, adsr table

// ---------------------------------------------------------------------------
// Twang Tables

extern const unsigned int Vec_TWANG_VIBE0  // 0xFD79, twang table
extern const unsigned int Vec_TWANG_VIBEHL // 0xFEB6, twang table, minestorm
extern const unsigned int Vec_TWANG_VIBENL // 0xFEB6, twang table, minestorm

// ***************************************************************************
// end of file
// ***************************************************************************
