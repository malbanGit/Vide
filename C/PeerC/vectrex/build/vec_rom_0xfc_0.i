# 1 "source\\vec_rom_0xfc_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_rom_0xfc_0.c"
# 17 "source\\vec_rom_0xfc_0.c"
__asm(
 ".bank page_fc (BASE=0xfc6d,SIZE=0x0100)\n\t"
 ".area .dpfc (OVR,BANK=page_fc)\n\t"
);




const int Vec_Sine_Table[0x7d-0x6d] __attribute__((section(".dpfc"), used));
const int Vec_Cosine_Table[0x8d-0x7d] __attribute__((section(".dpfc"), used));
const int Vec_Note_Table __attribute__((section(".dpfc"), used));
