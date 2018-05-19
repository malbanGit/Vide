# 1 "source\\vec_ram_0xd0_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xd0_1.c"
# 19 "source\\vec_ram_0xd0_1.c"
__asm(
 ".bank page_d0 (BASE=0xd000,SIZE=0x0100)\n\t"
 ".area .dpd0 (OVR,BANK=page_d0)\n\t"
);





volatile int VIA_port_b[0x04] __attribute__((section(".dpd0"), used));
volatile unsigned long int VIA_t1_cnt __attribute__((section(".dpd0"), used));
volatile unsigned long int VIA_t1_lch __attribute__((section(".dpd0"), used));
volatile unsigned long int VIA_t2 __attribute__((section(".dpd0"), used));
