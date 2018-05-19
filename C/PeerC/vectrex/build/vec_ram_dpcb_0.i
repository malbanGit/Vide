# 1 "source\\vec_ram_dpcb_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpcb_0.c"
# 17 "source\\vec_ram_dpcb_0.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0xea] __attribute__((section("direct"), used));
int dp_Vec_Default_Stk __attribute__((section("direct"), used));
unsigned int dp_Vec_High_Score[0xf2-0xeb] __attribute__((section("direct"), used));
int dp_Vec_SWI3_Vector[0xf5-0xf2] __attribute__((section("direct"), used));
int dp_Vec_FIRQ_Vector[0xf8-0xf5] __attribute__((section("direct"), used));
int dp_Vec_IRQ_Vector[0xfb-0xf8] __attribute__((section("direct"), used));
int dp_Vec_SWI_Vector[0xfe - 0xfb] __attribute__((section("direct"), used));
long unsigned int dp_Vec_Cold_Flag __attribute__((section("direct"), used));
