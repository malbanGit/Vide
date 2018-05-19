# 1 "source\\vec_rom_0xff_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_0xff_0.c"
# 17 "source\\vec_rom_0xff_0.c"
__asm(
 ".bank page_ff(BASE=0xff16,SIZE=0x00A0)\n\t"
 ".area .dpff (OVR,BANK=page_ff)\n\t"
);




const unsigned int Vec_ADSR_FADE8[0x26-0x16] __attribute__((section(".dpff"), used));
const unsigned int Vec_Music_9[0x44-0x26] __attribute__((section(".dpff"), used));
const unsigned int Vec_Music_a[0x62-0x44] __attribute__((section(".dpff"), used));
const unsigned int Vec_Music_b[0x7a-0x62] __attribute__((section(".dpff"), used));
const unsigned int Vec_Music_c[0x8f-0x7a] __attribute__((section(".dpff"), used));
const unsigned int Vec_Music_d __attribute__((section(".dpff"), used));
