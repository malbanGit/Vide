# 1 "source\\vec_ram_0xc8_1.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xc8_1.c"
# 17 "source\\vec_ram_0xc8_1.c"
__asm(
 ".bank page_c8 (BASE=0xc800,SIZE=0x0080)\n\t"
 ".area .dpc8 (OVR,BANK=page_c8)\n\t"
);
# 30 "source\\vec_ram_0xc8_1.c"
int Vec_Snd_Shadow[0x1f-0x00] __attribute__((section(".dpc8"), used));
int Vec_Joy_Mux_1_X __attribute__((section(".dpc8"), used));
int Vec_Joy_Mux_1_Y __attribute__((section(".dpc8"), used));
int Vec_Joy_Mux_2_X __attribute__((section(".dpc8"), used));
int Vec_Joy_Mux_2_Y[0x25-0x22] __attribute__((section(".dpc8"), used));
unsigned int Vec_Loop_Count_hi __attribute__((section(".dpc8"), used));
unsigned int Vec_Loop_Count_lo[0x2a-0x26] __attribute__((section(".dpc8"), used));
int Vec_Text_Height __attribute__((section(".dpc8"), used));
int Vec_Text_Width[0x2e - 0x2b] __attribute__((section(".dpc8"), used));
int Vec_Counter_1 __attribute__((section(".dpc8"), used));
int Vec_Counter_2 __attribute__((section(".dpc8"), used));
int Vec_Counter_3 __attribute__((section(".dpc8"), used));
int Vec_Counter_4 __attribute__((section(".dpc8"), used));
int Vec_Counter_5 __attribute__((section(".dpc8"), used));
int Vec_Counter_6[0x39-0x33] __attribute__((section(".dpc8"), used));
unsigned long int Vec_XXX_00 __attribute__((section(".dpc8"), used));
int Vec_XXX_01[0x3d-0x3b] __attribute__((section(".dpc8"), used));
unsigned int Vec_Rfrsh_lo __attribute__((section(".dpc8"), used));
unsigned int Vec_Rfrsh_hi[0x4f-0x3e] __attribute__((section(".dpc8"), used));
int Vec_Max_Players __attribute__((section(".dpc8"), used));
int Vec_Max_Games[0x53-0x50] __attribute__((section(".dpc8"), used));
int Vec_Expl_ChanA __attribute__((section(".dpc8"), used));
int Vec_Expl_Chans[0x58-0x54] __attribute__((section(".dpc8"), used));
unsigned int Vec_Music_Twang[0x5e - 0x58] __attribute__((section(".dpc8"), used));
int Vec_ADSR_Timers[0x61-0x5e] __attribute__((section(".dpc8"), used));
unsigned int Vec_Music_Freq[0x7d-0x61] __attribute__((section(".dpc8"), used));
unsigned int Vec_Random_Seed __attribute__((section(".dpc8"), used));
