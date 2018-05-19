# 1 "source\\vec_ram_dpd0_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpd0_1.c"
# 17 "source\\vec_ram_dpd0_1.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);





volatile int dp_VIA_port_b[0x04] __attribute__((section("direct"), used));
volatile unsigned long int dp_VIA_t1_cnt __attribute__((section("direct"), used));
volatile unsigned long int dp_VIA_t1_lch __attribute__((section("direct"), used));
volatile unsigned long int dp_VIA_t2 __attribute__((section("direct"), used));
