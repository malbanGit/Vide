# 1 "source\\vec_ram_0xcb_2.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xcb_2.c"
# 17 "source\\vec_ram_0xcb_2.c"
__asm(
 ".bank page_cb (BASE=0xcbea,SIZE=0x0100)\n\t"
 ".area .dpcb (OVR,BANK=page_cb)\n\t"
);




int Vec_Default_Stk[0xf2-0xea] __attribute__((section(".dpcb"), used));
int Vec_SWI2_Vector[0xfb-0xf2] __attribute__((section(".dpcb"), used));
int Vec_NWI_Vector __attribute__((section(".dpcb"), used));
