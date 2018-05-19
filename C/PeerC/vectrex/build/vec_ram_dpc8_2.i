# 1 "source\\vec_ram_dpc8_2.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpc8_2.c"
# 17 "source\\vec_ram_dpc8_2.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);
# 30 "source\\vec_ram_dpc8_2.c"
int dp_Vec_Snd_shadow[0x1f] __attribute__((section("direct"), used));
int dp_Vec_Joy_Mux[0x2e - 0x1f] __attribute__((section("direct"), used));
int dp_Vec_Counters[0x5e - 0x2e] __attribute__((section("direct"), used));
int dp_Vec_XXX_09 __attribute__((section("direct"), used));
