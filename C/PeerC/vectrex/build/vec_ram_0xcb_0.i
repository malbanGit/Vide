# 1 "source\\vec_ram_0xcb_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xcb_0.c"
# 17 "source\\vec_ram_0xcb_0.c"
__asm(
 ".bank page_cb (BASE=0xcbea,SIZE=0x0100)\n\t"
 ".area .dpcb (OVR,BANK=page_cb)\n\t"
);




int Vec_Default_Stk __attribute__((section(".dpcb"), used));
unsigned int Vec_High_Score[0xf2-0xeb] __attribute__((section(".dpcb"), used));
int Vec_SWI3_Vector[0xf5-0xf2] __attribute__((section(".dpcb"), used));
int Vec_FIRQ_Vector[0xf8-0xf5] __attribute__((section(".dpcb"), used));
int Vec_IRQ_Vector[0xfb-0xf8] __attribute__((section(".dpcb"), used));
int Vec_SWI_Vector[0xfe - 0xfb] __attribute__((section(".dpcb"), used));
long unsigned int Vec_Cold_Flag __attribute__((section(".dpcb"), used));
