# 1 "source\\vec_rom_dpfe_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_dpfe_1.c"
# 17 "source\\vec_rom_dpfe_1.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0xb6] __attribute__((section("direct"), used));
const unsigned int dp_Vec_TWANG_VIBENL __attribute__((section("direct"), used));
