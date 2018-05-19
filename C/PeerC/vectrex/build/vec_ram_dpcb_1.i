# 1 "source\\vec_ram_dpcb_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpcb_1.c"
# 17 "source\\vec_ram_dpcb_1.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);




int dp_Vec_Snd_shadow[0xeb] __attribute__((section("direct"), used));
unsigned int dp_Vec_High_score[7] __attribute__((section("direct"), used));
int dp_Vec_SWI3_vector[3] __attribute__((section("direct"), used));
int dp_Vec_FIRQ_vector[3] __attribute__((section("direct"), used));
int dp_Vec_IRQ_vector[3] __attribute__((section("direct"), used));
int dp_Vec_SWI_vector[3] __attribute__((section("direct"), used));
