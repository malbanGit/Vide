# 1 "source\\vec_rom_0xfe_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_0xfe_0.c"
# 17 "source\\vec_rom_0xfe_0.c"
__asm(
 ".bank page_fe (BASE=0xfe28,SIZE=0x0100)\n\t"
 ".area .dpfe (OVR,BANK=page_fe)\n\t"
);




const unsigned int Vec_ADSR_FADE1[0x38-0x28] __attribute__((section(".dpfe"), used));
const unsigned int Vec_Music_5[0x66-0x38] __attribute__((section(".dpfe"), used));
const unsigned int Vec_ADSR_FADE2[0x76-0x66] __attribute__((section(".dpfe"), used));
const unsigned int Vec_Music_6[0xb2-0x76] __attribute__((section(".dpfe"), used));
const unsigned int Vec_ADSR_FADE3[0xb6-0xb2] __attribute__((section(".dpfe"), used));
const unsigned int Vec_TWANG_VIBEHL[0xc6-0xb6] __attribute__((section(".dpfe"), used));
const unsigned int Vec_Music_7[0xe8-0xc6] __attribute__((section(".dpfe"), used));
const unsigned int Vec_ADSR_FADE4[0xf8-0xe8] __attribute__((section(".dpfe"), used));
const unsigned int Vec_Music_8 __attribute__((section(".dpfe"), used));
