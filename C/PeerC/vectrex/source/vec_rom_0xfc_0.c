// ***************************************************************************
// VECTREX EXECUTIVE ROM ADRESSES
// as described in the Vectrex Programmer's Manual Volume 1
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
// ---------------------------------------------------------------------------

__asm(
	".bank page_fc (BASE=0xfc6d,SIZE=0x0100)\n\t"
	".area .dpfc (OVR,BANK=page_fc)\n\t"
);

// ---------------------------------------------------------------------------
// page 0xFC00

const int	Vec_Sine_Table[0x7d-0x6d]	__attribute__((section(".dpfc"), used)); // 0xFC6D, sine table
const int	Vec_Cosine_Table[0x8d-0x7d] __attribute__((section(".dpfc"), used)); // 0xFC7D, cosine table
const int	Vec_Note_Table				__attribute__((section(".dpfc"), used)); // 0xFC8D, frequency table

// ***************************************************************************
// end of file
// ***************************************************************************
