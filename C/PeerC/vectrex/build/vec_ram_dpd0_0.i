# 1 "source\\vec_ram_dpd0_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpd0_0.c"
# 17 "source\\vec_ram_dpd0_0.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);





volatile int dp_VIA_port_b __attribute__((section("direct"), used));
volatile int dp_VIA_port_a __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_DDR_b __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_DDR_a __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_t1_cnt_lo __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_t1_cnt_hi __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_t1_lch_lo __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_t1_lch_hi __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_t2_lo __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_t2_hi __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_shift_reg __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_aux_cntl __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_cntl __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_int_flags __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_int_enable __attribute__((section("direct"), used));
volatile unsigned int dp_VIA_port_a_nohs __attribute__((section("direct"), used));
