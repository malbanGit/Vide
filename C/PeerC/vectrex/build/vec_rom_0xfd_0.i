# 1 "source\\vec_rom_0xfd_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_0xfd_0.c"
# 17 "source\\vec_rom_0xfd_0.c"
__asm(
 ".bank page_fd (BASE=0xfd0d,SIZE=0x0100)\n\t"
 ".area .dpfd (OVR,BANK=page_fd)\n\t"
);




const unsigned int Vec_Music_1[0x1d-0x0d] __attribute__((section(".dpfd"), used));
const unsigned int Vec_Music_2[0x69-0x1d] __attribute__((section(".dpfd"), used));
const unsigned int Vec_ADSR_FADE0[0x79-0x69] __attribute__((section(".dpfd"), used));
const unsigned int Vec_TWANG_VIBE0[0x81-0x79] __attribute__((section(".dpfd"), used));
const unsigned int Vec_Music_3[0xc3-0x81] __attribute__((section(".dpfd"), used));
const unsigned int Vec_ADSR_FADE12[0xd3-0xc3] __attribute__((section(".dpfd"), used));
const unsigned int Vec_Music_4 __attribute__((section(".dpfd"), used));
