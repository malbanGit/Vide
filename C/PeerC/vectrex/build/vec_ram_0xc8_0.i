# 1 "source\\vec_ram_0xc8_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_0xc8_0.c"
# 17 "source\\vec_ram_0xc8_0.c"
__asm(
 ".bank page_c8 (BASE=0xc800,SIZE=0x0080)\n\t"
 ".area .dpc8 (OVR,BANK=page_c8)\n\t"
);
# 30 "source\\vec_ram_0xc8_0.c"
int Vec_Snd_shadow[15] __attribute__((section(".dpc8"), used));
unsigned int Vec_Btn_State __attribute__((section(".dpc8"), used));
unsigned int Vec_Prev_Btns __attribute__((section(".dpc8"), used));
unsigned int Vec_Buttons __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_1_1 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_1_2 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_1_3 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_1_4 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_2_1 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_2_2 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_2_3 __attribute__((section(".dpc8"), used));
unsigned int Vec_Button_2_4 __attribute__((section(".dpc8"), used));
int Vec_Joy_Resltn __attribute__((section(".dpc8"), used));
int Vec_Joy_1_X __attribute__((section(".dpc8"), used));
int Vec_Joy_1_Y __attribute__((section(".dpc8"), used));
int Vec_Joy_2_X __attribute__((section(".dpc8"), used));
int Vec_Joy_2_Y __attribute__((section(".dpc8"), used));
int Vec_Joy_mux[4] __attribute__((section(".dpc8"), used));
unsigned int Vec_Misc_Count __attribute__((section(".dpc8"), used));
int Vec_0Ref_Enable __attribute__((section(".dpc8"), used));
unsigned long int Vec_Loop_Count __attribute__((section(".dpc8"), used));
int Vec_Brightness __attribute__((section(".dpc8"), used));
unsigned int Vec_Dot_Dwell __attribute__((section(".dpc8"), used));
unsigned int Vec_Pattern __attribute__((section(".dpc8"), used));
unsigned long int Vec_Text_HW __attribute__((section(".dpc8"), used));
int* Vec_Str_Ptr __attribute__((section(".dpc8"), used));
int Vec_counters[6] __attribute__((section(".dpc8"), used));
unsigned long int Vec_RiseRun_Tmp __attribute__((section(".dpc8"), used));
int Vec_Angle __attribute__((section(".dpc8"), used));
unsigned long int Vec_Run_Index __attribute__((section(".dpc8"), used));
unsigned long int Vec_Rise_Index __attribute__((section(".dpc8"), used));
int Vec_RiseRun_Len __attribute__((section(".dpc8"), used));
int Vec_XXX_02 __attribute__((section(".dpc8"), used));
unsigned long int Vec_Rfrsh __attribute__((section(".dpc8"), used));
int Vec_Music_Work[3] __attribute__((section(".dpc8"), used));
int Vec_Music_Wk_A __attribute__((section(".dpc8"), used));
int Vec_XXX_03 __attribute__((section(".dpc8"), used));
int Vec_XXX_04 __attribute__((section(".dpc8"), used));
int Vec_Music_Wk_7 __attribute__((section(".dpc8"), used));
int Vec_Music_Wk_6 __attribute__((section(".dpc8"), used));
int Vec_Music_Wk_5 __attribute__((section(".dpc8"), used));
int Vec_XXX_05 __attribute__((section(".dpc8"), used));
int Vec_XXX_06 __attribute__((section(".dpc8"), used));
int Vec_XXX_07 __attribute__((section(".dpc8"), used));
int Vec_Music_Wk_1 __attribute__((section(".dpc8"), used));
int Vec_XXX_08 __attribute__((section(".dpc8"), used));
int* Vec_Freq_Table __attribute__((section(".dpc8"), used));
long unsigned int Vec_ADSR_Table __attribute__((section(".dpc8"), used));
int* Vec_Twang_Table __attribute__((section(".dpc8"), used));
int* Vec_Music_Ptr __attribute__((section(".dpc8"), used));
int Vec_Music_Chan __attribute__((section(".dpc8"), used));
int Vec_Music_Flag __attribute__((section(".dpc8"), used));
int Vec_Duration __attribute__((section(".dpc8"), used));
int Vec_Expl_1 __attribute__((section(".dpc8"), used));
int Vec_Expl_2 __attribute__((section(".dpc8"), used));
int Vec_Expl_3 __attribute__((section(".dpc8"), used));
int Vec_Expl_4 __attribute__((section(".dpc8"), used));
int Vec_Expl_Chan __attribute__((section(".dpc8"), used));
int Vec_Expl_ChanB __attribute__((section(".dpc8"), used));
int Vec_ADSR_timers[3] __attribute__((section(".dpc8"), used));
unsigned long int Vec_Music_freq[3] __attribute__((section(".dpc8"), used));
unsigned int Vec_Expl_Flag __attribute__((section(".dpc8"), used));
int Vec_XXX_10 __attribute__((section(".dpc8"), used));
int Vec_XXX_11 __attribute__((section(".dpc8"), used));
int Vec_XXX_12 __attribute__((section(".dpc8"), used));
int Vec_XXX_13 __attribute__((section(".dpc8"), used));
int Vec_XXX_14 __attribute__((section(".dpc8"), used));
int Vec_XXX_15 __attribute__((section(".dpc8"), used));
int Vec_XXX_16 __attribute__((section(".dpc8"), used));
int Vec_XXX_17 __attribute__((section(".dpc8"), used));
int Vec_XXX_18 __attribute__((section(".dpc8"), used));
int Vec_XXX_19 __attribute__((section(".dpc8"), used));
int Vec_XXX_20 __attribute__((section(".dpc8"), used));
int Vec_XXX_21 __attribute__((section(".dpc8"), used));
int Vec_XXX_22 __attribute__((section(".dpc8"), used));
int Vec_XXX_23 __attribute__((section(".dpc8"), used));
int Vec_XXX_24 __attribute__((section(".dpc8"), used));
int Vec_Expl_Timer __attribute__((section(".dpc8"), used));
int Vec_XXX_25 __attribute__((section(".dpc8"), used));
unsigned int Vec_Num_Players __attribute__((section(".dpc8"), used));
unsigned int Vec_Num_Game __attribute__((section(".dpc8"), used));
unsigned int* Vec_Seed_Ptr __attribute__((section(".dpc8"), used));
unsigned int Vec_Random_Seed0 __attribute__((section(".dpc8"), used));
unsigned int Vec_Random_Seed1 __attribute__((section(".dpc8"), used));
unsigned int Vec_Random_Seed2 __attribute__((section(".dpc8"), used));
