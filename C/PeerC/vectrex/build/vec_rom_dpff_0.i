# 1 "source\\vec_rom_dpff_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_dpff_0.c"
# 17 "source\\vec_rom_dpff_0.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0x16] __attribute__((section("direct"), used));
const unsigned int dp_Vec_ADSR_FADE8[0x26-0x16] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_9[0x44-0x26] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_a[0x62-0x44] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_b[0x7a-0x62] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_c[0x8f-0x7a] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_d __attribute__((section("direct"), used));
