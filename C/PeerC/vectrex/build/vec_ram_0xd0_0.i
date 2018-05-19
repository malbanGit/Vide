# 1 "source\\vec_ram_0xd0_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xd0_0.c"
# 19 "source\\vec_ram_0xd0_0.c"
__asm(
 ".bank page_d0 (BASE=0xd000,SIZE=0x0100)\n\t"
 ".area .dpd0 (OVR,BANK=page_d0)\n\t"
);





volatile int VIA_port_b __attribute__((section(".dpd0"), used));
volatile int VIA_port_a __attribute__((section(".dpd0"), used));
# 38 "source\\vec_ram_0xd0_0.c"
volatile unsigned int VIA_DDR_b __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_DDR_a __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_t1_cnt_lo __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_t1_cnt_hi __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_t1_lch_lo __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_t1_lch_hi __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_t2_lo __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_t2_hi __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_shift_reg __attribute__((section(".dpd0"), used));
volatile unsigned int VIA_aux_cntl __attribute__((section(".dpd0"), used));
# 56 "source\\vec_ram_0xd0_0.c"
volatile unsigned int VIA_cntl __attribute__((section(".dpd0"), used));
# 65 "source\\vec_ram_0xd0_0.c"
volatile unsigned int VIA_int_flags __attribute__((section(".dpd0"), used));
# 75 "source\\vec_ram_0xd0_0.c"
volatile unsigned int VIA_int_enable __attribute__((section(".dpd0"), used));
# 84 "source\\vec_ram_0xd0_0.c"
volatile unsigned int VIA_port_a_nohs __attribute__((section(".dpd0"), used));
