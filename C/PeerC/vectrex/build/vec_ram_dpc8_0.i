# 1 "source\\vec_ram_dpc8_0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\vec_ram_dpc8_0.c"
# 17 "source\\vec_ram_dpc8_0.c"
__asm(
 ".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
 ".area direct (OVR,BANK=page_00)\n\t"
);
# 30 "source\\vec_ram_dpc8_0.c"
int dp_Vec_Snd_shadow[15] __attribute__((section("direct"), used));
unsigned int dp_Vec_Btn_State __attribute__((section("direct"), used));
unsigned int dp_Vec_Prev_Btns __attribute__((section("direct"), used));
unsigned int dp_Vec_Buttons __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_1_1 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_1_2 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_1_3 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_1_4 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_2_1 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_2_2 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_2_3 __attribute__((section("direct"), used));
unsigned int dp_Vec_Button_2_4 __attribute__((section("direct"), used));
int dp_Vec_Joy_Resltn __attribute__((section("direct"), used));
int dp_Vec_Joy_1_X __attribute__((section("direct"), used));
int dp_Vec_Joy_1_Y __attribute__((section("direct"), used));
int dp_Vec_Joy_2_X __attribute__((section("direct"), used));
int dp_Vec_Joy_2_Y __attribute__((section("direct"), used));
int dp_Vec_Joy_mux[4] __attribute__((section("direct"), used));
unsigned int dp_Vec_Misc_Count __attribute__((section("direct"), used));
int dp_Vec_0Ref_Enable __attribute__((section("direct"), used));
unsigned long int dp_Vec_Loop_Count __attribute__((section("direct"), used));
int dp_Vec_Brightness __attribute__((section("direct"), used));
unsigned int dp_Vec_Dot_Dwell __attribute__((section("direct"), used));
unsigned int dp_Vec_Pattern __attribute__((section("direct"), used));
unsigned long int dp_Vec_Text_HW __attribute__((section("direct"), used));
int* dp_Vec_Str_Ptr __attribute__((section("direct"), used));
int dp_Vec_counters[6] __attribute__((section("direct"), used));
unsigned long int dp_Vec_RiseRun_Tmp __attribute__((section("direct"), used));
int dp_Vec_Angle __attribute__((section("direct"), used));
unsigned long int dp_Vec_Run_Index __attribute__((section("direct"), used));
unsigned long int dp_Vec_Rise_Index __attribute__((section("direct"), used));
int dp_Vec_RiseRun_Len __attribute__((section("direct"), used));
int dp_Vec_XXX_02 __attribute__((section("direct"), used));
unsigned long int dp_Vec_Rfrsh __attribute__((section("direct"), used));
int dp_Vec_Music_Work[3] __attribute__((section("direct"), used));
int dp_Vec_Music_Wk_A __attribute__((section("direct"), used));
int dp_Vec_XXX_03 __attribute__((section("direct"), used));
int dp_Vec_XXX_04 __attribute__((section("direct"), used));
int dp_Vec_Music_Wk_7 __attribute__((section("direct"), used));
int dp_Vec_Music_Wk_6 __attribute__((section("direct"), used));
int dp_Vec_Music_Wk_5 __attribute__((section("direct"), used));
int dp_Vec_XXX_05 __attribute__((section("direct"), used));
int dp_Vec_XXX_06 __attribute__((section("direct"), used));
int dp_Vec_XXX_07 __attribute__((section("direct"), used));
int dp_Vec_Music_Wk_1 __attribute__((section("direct"), used));
int dp_Vec_XXX_08 __attribute__((section("direct"), used));
int* dp_Vec_Freq_Table __attribute__((section("direct"), used));
long unsigned int dp_Vec_ADSR_Table __attribute__((section("direct"), used));
int* dp_Vec_Twang_Table __attribute__((section("direct"), used));
int* dp_Vec_Music_Ptr __attribute__((section("direct"), used));
int dp_Vec_Music_Chan __attribute__((section("direct"), used));
int dp_Vec_Music_Flag __attribute__((section("direct"), used));
int dp_Vec_Duration __attribute__((section("direct"), used));
int dp_Vec_Expl_1 __attribute__((section("direct"), used));
int dp_Vec_Expl_2 __attribute__((section("direct"), used));
int dp_Vec_Expl_3 __attribute__((section("direct"), used));
int dp_Vec_Expl_4 __attribute__((section("direct"), used));
int dp_Vec_Expl_Chan __attribute__((section("direct"), used));
int dp_Vec_Expl_ChanB __attribute__((section("direct"), used));
int dp_Vec_ADSR_timers[3] __attribute__((section("direct"), used));
unsigned long int dp_Vec_Music_freq[3] __attribute__((section("direct"), used));
unsigned int dp_Vec_Expl_Flag __attribute__((section("direct"), used));
int dp_Vec_XXX_10 __attribute__((section("direct"), used));
int dp_Vec_XXX_11 __attribute__((section("direct"), used));
int dp_Vec_XXX_12 __attribute__((section("direct"), used));
int dp_Vec_XXX_13 __attribute__((section("direct"), used));
int dp_Vec_XXX_14 __attribute__((section("direct"), used));
int dp_Vec_XXX_15 __attribute__((section("direct"), used));
int dp_Vec_XXX_16 __attribute__((section("direct"), used));
int dp_Vec_XXX_17 __attribute__((section("direct"), used));
int dp_Vec_XXX_18 __attribute__((section("direct"), used));
int dp_Vec_XXX_19 __attribute__((section("direct"), used));
int dp_Vec_XXX_20 __attribute__((section("direct"), used));
int dp_Vec_XXX_21 __attribute__((section("direct"), used));
int dp_Vec_XXX_22 __attribute__((section("direct"), used));
int dp_Vec_XXX_23 __attribute__((section("direct"), used));
int dp_Vec_XXX_24 __attribute__((section("direct"), used));
int dp_Vec_Expl_Timer __attribute__((section("direct"), used));
int dp_Vec_XXX_25 __attribute__((section("direct"), used));
unsigned int dp_Vec_Num_Players __attribute__((section("direct"), used));
unsigned int dp_Vec_Num_Game __attribute__((section("direct"), used));
unsigned int* dp_Vec_Seed_Ptr __attribute__((section("direct"), used));
unsigned int dp_Vec_Random_Seed0 __attribute__((section("direct"), used));
unsigned int dp_Vec_Random_Seed1 __attribute__((section("direct"), used));
unsigned int dp_Vec_Random_Seed2 __attribute__((section("direct"), used));
