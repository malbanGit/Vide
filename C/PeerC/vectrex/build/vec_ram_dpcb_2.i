# 1 "source\\vec_ram_dpcb_2.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpcb_2.c"
# 17 "source\\vec_ram_dpcb_2.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0xf2] __attribute__((section("direct"), used));
int dp_Vec_SWI2_Vector[0xfb-0xf2] __attribute__((section("direct"), used));
int dp_Vec_NWI_Vector __attribute__((section("direct"), used));
