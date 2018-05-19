# 1 "source\\vec_rom_dpfc_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_dpfc_0.c"
# 17 "source\\vec_rom_dpfc_0.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0x6d] __attribute__((section("direct"), used));
const int dp_Vec_Sine_Table[0x7d-0x6d] __attribute__((section("direct"), used));
const int dp_Vec_Cosine_Table[0x8d-0x7d] __attribute__((section("direct"), used));
const int dp_Vec_Note_Table __attribute__((section("direct"), used));
