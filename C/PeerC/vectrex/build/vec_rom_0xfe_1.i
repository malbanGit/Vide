# 1 "source\\vec_rom_0xfe_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_0xfe_1.c"
# 17 "source\\vec_rom_0xfe_1.c"
__asm(
 ".bank page_fe (BASE=0xfe28,SIZE=0x0100)\n\t"
 ".area .dpfe (OVR,BANK=page_fe)\n\t"
);




const unsigned int Vec_ADSR_FADE1[0xb6-0x28] __attribute__((section(".dpfe"), used));
const unsigned int Vec_TWANG_VIBENL __attribute__((section(".dpfe"), used));
