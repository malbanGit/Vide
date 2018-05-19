# 1 "source\\vec_rom_0xed_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_0xed_0.c"
# 17 "source\\vec_rom_0xed_0.c"
__asm(
 ".bank page_ed (BASE=0xed77,SIZE=0x0100)\n\t"
 ".area .dped (OVR,BANK=page_ed)\n\t"
);




const unsigned int Vec_Music_0[0x8f-0x77] __attribute__((section(".dped"), used));
const unsigned int Vec_ADSR_FADE66 __attribute__((section(".dped"), used));
