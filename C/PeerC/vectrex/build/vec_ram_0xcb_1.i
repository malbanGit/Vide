# 1 "source\\vec_ram_0xcb_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xcb_1.c"
# 17 "source\\vec_ram_0xcb_1.c"
__asm(
 ".bank page_cb (BASE=0xcbea,SIZE=0x0100)\n\t"
 ".area .dpcb (OVR,BANK=page_cb)\n\t"
);




int Vec_Default_Stk __attribute__((section(".dpcb"), used));
unsigned int Vec_High_score[7] __attribute__((section(".dpcb"), used));
int Vec_SWI3_vector[3] __attribute__((section(".dpcb"), used));
int Vec_FIRQ_vector[3] __attribute__((section(".dpcb"), used));
int Vec_IRQ_vector[3] __attribute__((section(".dpcb"), used));
int Vec_SWI_vector[3] __attribute__((section(".dpcb"), used));
