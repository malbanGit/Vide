# 1 "source\\vec_rom_dpfd_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_dpfd_0.c"
# 17 "source\\vec_rom_dpfd_0.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0x0d] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_1[0x1d-0x0d] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_2[0x69-0x1d] __attribute__((section("direct"), used));
const unsigned int dp_Vec_ADSR_FADE0[0x79-0x69] __attribute__((section("direct"), used));
const unsigned int dp_Vec_TWANG_VIBE0[0x81-0x79] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_3[0xc3-0x81] __attribute__((section("direct"), used));
const unsigned int dp_Vec_ADSR_FADE12[0xd3-0xc3] __attribute__((section("direct"), used));
const unsigned int dp_Vec_Music_4 __attribute__((section("direct"), used));
