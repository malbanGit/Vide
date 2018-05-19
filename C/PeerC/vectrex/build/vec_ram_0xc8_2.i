# 1 "source\\vec_ram_0xc8_2.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xc8_2.c"
# 17 "source\\vec_ram_0xc8_2.c"
__asm(
 ".bank page_c8 (BASE=0xc800,SIZE=0x0080)\n\t"
 ".area .dpc8 (OVR,BANK=page_c8)\n\t"
);
# 30 "source\\vec_ram_0xc8_2.c"
int Vec_Snd_shadow[0x1f] __attribute__((section(".dpc8"), used));
int Vec_Joy_Mux[0x2e - 0x1f] __attribute__((section(".dpc8"), used));
int Vec_Counters[0x5e - 0x2e] __attribute__((section(".dpc8"), used));
int Vec_XXX_09 __attribute__((section(".dpc8"), used));
