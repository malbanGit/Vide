VIA_port_b                    EQU      $D000  ; DP accessed
VIA_port_a                    EQU      $D001  ; DP accessed
VIA_DDR_b                     EQU      $D002  ; DP accessed
VIA_DDR_a                     EQU      $D003  ; DP accessed
VIA_t1_cnt_lo                 EQU      $D004  ; DP accessed
VIA_t1_cnt_hi                 EQU      $D005  ; DP accessed
VIA_t1_lch_lo                 EQU      $D006  ; DP accessed
VIA_t2_lo                     EQU      $D008  ; DP accessed
VIA_t2_hi                     EQU      $D009  ; DP accessed
VIA_shift_reg                 EQU      $D00A  ; DP accessed
VIA_aux_cntl                  EQU      $D00B  ; DP accessed
VIA_cntl                      EQU      $D00C  ; DP accessed
VIA_int_flags                 EQU      $D00D  ; DP accessed
VIA_int_enable                EQU      $D00E  ; DP accessed
Vec_Snd_Shadow                EQU      $C800  ; DP accessed
AlexRCCounterLo               EQU      $C801  ; DP accessed
_C882                         EQU      $C882  ; DP accessed
JoyStatePort0ThisSide         EQU      $C805  ; DP accessed
JoyStatePort0OtherSide        EQU      $C806  ; DP accessed
jumper1                       EQU      $C807  ; DP accessed
jumper2                       EQU      $C809  ; DP accessed
SyncData5                     EQU      $C80C  ; DP accessed
SyncData4                     EQU      $C80D  ; DP accessed
Vec_Btn_State                 EQU      $C80F  ; DP accessed
Vec_Prev_Btns                 EQU      $C810  ; DP accessed
Vec_Buttons                   EQU      $C811  ; DP accessed
Vec_Button_1_1                EQU      $C812  ; DP accessed
Vec_Button_1_2                EQU      $C813  ; DP accessed
Vec_Button_1_3                EQU      $C814  ; DP accessed
Vec_Button_1_4                EQU      $C815  ; DP accessed
Vec_Button_2_1                EQU      $C816  ; DP accessed
Vec_Button_2_2                EQU      $C817  ; DP accessed
Vec_Button_2_3                EQU      $C818  ; DP accessed
Vec_Button_2_4                EQU      $C819  ; DP accessed
Vec_Joy_Resltn                EQU      $C81A  ; DP accessed
Vec_Joy_1_X                   EQU      $C81B  ; DP accessed
Vec_Joy_1_Y                   EQU      $C81C  ; DP accessed
Vec_Joy_2_X                   EQU      $C81D  ; DP accessed
Vec_Joy_2_Y                   EQU      $C81E  ; DP accessed
Vec_Joy_Mux_1_X               EQU      $C81F  ; DP accessed
Vec_Joy_Mux_1_Y               EQU      $C820  ; DP accessed
Vec_Joy_Mux_2_X               EQU      $C821  ; DP accessed
Vec_Joy_Mux_2_Y               EQU      $C822  ; DP accessed
Vec_Misc_Count                EQU      $C823  ; DP accessed
Vec_0Ref_Enable               EQU      $C824  ; DP accessed
Vec_Loop_Count                EQU      $C825  ; DP accessed
_C826                         EQU      $C826  ; DP accessed
Vec_Brightness                EQU      $C827  ; DP accessed
Vec_Dot_Dwell                 EQU      $C828  ; DP accessed
Vec_Pattern                   EQU      $C829  ; DP accessed
Vec_Text_Height               EQU      $C82A  ; DP accessed
Vec_Text_Width                EQU      $C82B  ; DP accessed
Vec_Str_Ptr                   EQU      $C82C  ; DP accessed
Vec_Counter_1                 EQU      $C82E  ; DP accessed
Vec_Counter_2                 EQU      $C82F  ; DP accessed
Vec_Counter_3                 EQU      $C830  ; DP accessed
Vec_Counter_4                 EQU      $C831  ; DP accessed
Vec_Counter_5                 EQU      $C832  ; DP accessed
Vec_Counter_6                 EQU      $C833  ; DP accessed
Vec_RiseRun_Tmp               EQU      $C834  ; DP accessed
Vec_Angle                     EQU      $C836  ; DP accessed
Vec_Run_Index                 EQU      $C837  ; DP accessed
SyncData1                     EQU      $C838  ; DP accessed
Vec_Rise_Index                EQU      $C839  ; DP accessed
SyncData3                     EQU      $C83A  ; DP accessed
Vec_RiseRun_Len               EQU      $C83B  ; DP accessed
Vec_Rfrsh_lo                  EQU      $C83D  ; DP accessed
Vec_Rfrsh_hi                  EQU      $C83E  ; DP accessed
Vec_Music_Work                EQU      $C83F  ; DP accessed
Vec_Music_Wk_A                EQU      $C842  ; DP accessed
YM_MainStatus                 EQU      $C844  ; DP accessed
Vec_Music_Wk_7                EQU      $C845  ; DP accessed
Vec_Music_Wk_6                EQU      $C846  ; DP accessed
Vec_Music_Wk_5                EQU      $C847  ; DP accessed
_C848                         EQU      $C848  ; DP accessed
Vec_Music_Wk_1                EQU      $C84B  ; DP accessed
Vec_Freq_Table                EQU      $C84D  ; DP accessed
Vec_ADSR_Table                EQU      $C84F  ; DP accessed
Vec_Max_Games                 EQU      $C850  ; DP accessed
Vec_Twang_Table               EQU      $C851  ; DP accessed
Vec_Expl_ChanA                EQU      $C853  ; DP accessed
Vec_Expl_Chans                EQU      $C854  ; DP accessed
Vec_Music_Chan                EQU      $C855  ; DP accessed
Vec_Music_Flag                EQU      $C856  ; DP accessed
Vec_Duration                  EQU      $C857  ; DP accessed
Vec_Expl_1                    EQU      $C858  ; DP accessed
Vec_Expl_2                    EQU      $C859  ; DP accessed
Vec_Expl_3                    EQU      $C85A  ; DP accessed
Vec_Expl_4                    EQU      $C85B  ; DP accessed
Vec_Expl_Chan                 EQU      $C85C  ; DP accessed
Vec_Expl_ChanB                EQU      $C85D  ; DP accessed
Vec_ADSR_Timers               EQU      $C85E  ; DP accessed
Vec_Music_Freq                EQU      $C861  ; DP accessed
Vec_Expl_Flag                 EQU      $C867  ; DP accessed
Vec_Default_Stk               EQU      $C8EA  ; DP accessed
Vec_High_Score                EQU      $C8EB  ; DP accessed
Vec_SWI2_Vector               EQU      $C8F2  ; DP accessed
Vec_FIRQ_Vector               EQU      $C8F5  ; DP accessed
Vec_Expl_Timer                EQU      $C877  ; DP accessed
Vec_IRQ_Vector                EQU      $C8F8  ; DP accessed
Vec_Num_Players               EQU      $C879  ; DP accessed
Vec_Num_Game                  EQU      $C87A  ; DP accessed
Vec_Seed_Ptr                  EQU      $C87B  ; DP accessed
Vec_NMI_Vector                EQU      $C8FB  ; DP accessed
Vec_Random_Seed               EQU      $C87D  ; DP accessed
Vec_Cold_Flag                 EQU      $C8FE  ; DP accessed
INCLUDE_I                     EQU      $0001
__6809__                      EQU      $0001
_0004                         EQU      $0004
_0008                         EQU      $0008
_0010                         EQU      $0010
_0051                         EQU      $0051
_0060                         EQU      $0060
_0070                         EQU      $0070
_007C                         EQU      $007C
_0080                         EQU      $0080
_0082                         EQU      $0082
_0086                         EQU      $0086
_00A0                         EQU      $00A0
_00C0                         EQU      $00C0
_00D8                         EQU      $00D8
_00E0                         EQU      $00E0
_00FE                         EQU      $00FE
_0239                         EQU      $0239
_03C8                         EQU      $03C8
_0407                         EQU      $0407
_040B                         EQU      $040B
_0607                         EQU      $0607
_0608                         EQU      $0608
_061F                         EQU      $061F
_0670                         EQU      $0670
_06C6                         EQU      $06C6
_06F0                         EQU      $06F0
_0800                         EQU      $0800
_0801                         EQU      $0801
_0808                         EQU      $0808
_0818                         EQU      $0818
_08E8                         EQU      $08E8
_08F0                         EQU      $08F0
_0A02                         EQU      $0A02
_0C88                         EQU      $0C88
_0E38                         EQU      $0E38
_0F80                         EQU      $0F80
_1010                         EQU      $1010
_1040                         EQU      $1040
_10FC                         EQU      $10FC
some_table                    EQU      $16BD
_1808                         EQU      $1808
_1810                         EQU      $1810
_1830                         EQU      $1830
_187F                         EQU      $187F
_18F0                         EQU      $18F0
_18FC                         EQU      $18FC
_18FF                         EQU      $18FF
_1C02                         EQU      $1C02
_1C70                         EQU      $1C70
_1E00                         EQU      $1E00
_2000                         EQU      $2000
_2018                         EQU      $2018
_207F                         EQU      $207F
_20F0                         EQU      $20F0
_218E                         EQU      $218E
_2203                         EQU      $2203
_2604                         EQU      $2604
_26CF                         EQU      $26CF
_2AD3                         EQU      $2AD3
_2B00                         EQU      $2B00
_2CAC                         EQU      $2CAC
_2CD7                         EQU      $2CD7
_2DBB                         EQU      $2DBB
_2E2B                         EQU      $2E2B
_3072                         EQU      $3072
_31BC                         EQU      $31BC
_31FC                         EQU      $31FC
_3850                         EQU      $3850
_3870                         EQU      $3870
_3880                         EQU      $3880
_38E0                         EQU      $38E0
_396D                         EQU      $396D
_39A5                         EQU      $39A5
_39CE                         EQU      $39CE
_39F0                         EQU      $39F0
_3B9C                         EQU      $3B9C
_3C2C                         EQU      $3C2C
_3C3C                         EQU      $3C3C
_3C5E                         EQU      $3C5E
_3C63                         EQU      $3C63
_3C66                         EQU      $3C66
_3C72                         EQU      $3C72
_3C76                         EQU      $3C76
_3C80                         EQU      $3C80
missile_flying_behind_vlist   EQU      $3CC8
missile_flying_right_vlist    EQU      $3CF8
missile_flying_left_vlist     EQU      $3D2C
_3D69                         EQU      $3D69
_3E3B                         EQU      $3E3B
_3E5F                         EQU      $3E5F
_3E83                         EQU      $3E83
_3E87                         EQU      $3E87
_3E93                         EQU      $3E93
_3EB7                         EQU      $3EB7
_3EBB                         EQU      $3EBB
_3ECB                         EQU      $3ECB
_3ECF                         EQU      $3ECF
_3ED2                         EQU      $3ED2
_3EF3                         EQU      $3EF3
_3EF7                         EQU      $3EF7
_4010                         EQU      $4010
_4015                         EQU      $4015
_4018                         EQU      $4018
_4040                         EQU      $4040
_40C0                         EQU      $40C0
_40F0                         EQU      $40F0
_462C                         EQU      $462C
_4634                         EQU      $4634
_4640                         EQU      $4640
_464F                         EQU      $464F
_4651                         EQU      $4651
_4655                         EQU      $4655
_4663                         EQU      $4663
_467C                         EQU      $467C
_468A                         EQU      $468A
_4690                         EQU      $4690
_4692                         EQU      $4692
_4693                         EQU      $4693
_4696                         EQU      $4696
_46A7                         EQU      $46A7
_46A8                         EQU      $46A8
_46B1                         EQU      $46B1
_46BE                         EQU      $46BE
_46BF                         EQU      $46BF
_46CF                         EQU      $46CF
_46D2                         EQU      $46D2
_46DE                         EQU      $46DE
_46DF                         EQU      $46DF
_46E0                         EQU      $46E0
_46F8                         EQU      $46F8
_46FF                         EQU      $46FF
_4705                         EQU      $4705
_470B                         EQU      $470B
_4723                         EQU      $4723
_4742                         EQU      $4742
_4751                         EQU      $4751
_4F30                         EQU      $4F30
_5030                         EQU      $5030
_5050                         EQU      $5050
_50D0                         EQU      $50D0
_5639                         EQU      $5639
_5730                         EQU      $5730
_64C5                         EQU      $64C5
_7020                         EQU      $7020
_72FF                         EQU      $72FF
_7777                         EQU      $7777
_77C8                         EQU      $77C8
_783F                         EQU      $783F
_78F8                         EQU      $78F8
_7C00                         EQU      $7C00
_7E00                         EQU      $7E00
_7EFC                         EQU      $7EFC
_7F20                         EQU      $7F20
_8000                         EQU      $8000
_8080                         EQU      $8080
_8181                         EQU      $8181
_819C                         EQU      $819C
_8280                         EQU      $8280
_8292                         EQU      $8292
_82AA                         EQU      $82AA
_83D8                         EQU      $83D8
_86D0                         EQU      $86D0
_8F87                         EQU      $8F87
_9020                         EQU      $9020
_A000                         EQU      $A000
_A07F                         EQU      $A07F
_A500                         EQU      $A500
_B0D0                         EQU      $B0D0
_B600                         EQU      $B600
_BC62                         EQU      $BC62
_BF00                         EQU      $BF00
_BFC0                         EQU      $BFC0
_C000                         EQU      $C000
_C00C                         EQU      $C00C
_C00E                         EQU      $C00E
_C00F                         EQU      $C00F
_C040                         EQU      $C040
_C088                         EQU      $C088
_C0C0                         EQU      $C0C0
_C0C4                         EQU      $C0C4
_C0D0                         EQU      $C0D0
_C0F0                         EQU      $C0F0
_C3BF                         EQU      $C3BF
_C3E0                         EQU      $C3E0
_C780                         EQU      $C780
AlexRCCounterHi               EQU      $C800
_C802                         EQU      $C802
CounterVar                    EQU      $C804
_C80B                         EQU      $C80B
_C80F                         EQU      $C80F
_C810                         EQU      $C810
_C816                         EQU      $C816
_C818                         EQU      $C818
_C81A                         EQU      $C81A
_C81C                         EQU      $C81C
_C81F                         EQU      $C81F
Vec_Joy_Mux                   EQU      $C81F
_C821                         EQU      $C821
_C822                         EQU      $C822
Vec_Text_HW                   EQU      $C82A
_C82C                         EQU      $C82C
_C82E                         EQU      $C82E
Vec_Counters                  EQU      $C82E
_C830                         EQU      $C830
_C831                         EQU      $C831
_C832                         EQU      $C832
_C834                         EQU      $C834
_C836                         EQU      $C836
_C837                         EQU      $C837
SyncData2                     EQU      $C839
_C83B                         EQU      $C83B
_C83D                         EQU      $C83D
Vec_Rfrsh                     EQU      $C83D
rowPos_YX                     EQU      $C83E
textIntensity                 EQU      $C840
textXSize                     EQU      $C841
currentStringStartStruct      EQU      $C842
YM_ListStatus                 EQU      $C845
YM_Pointer                    EQU      $C846
_C849                         EQU      $C849
_C84B                         EQU      $C84B
_C84D                         EQU      $C84D
_C84E                         EQU      $C84E
_C84F                         EQU      $C84F
Vec_Max_Players               EQU      $C84F
_C850                         EQU      $C850
_C851                         EQU      $C851
Vec_Music_Ptr                 EQU      $C853
Vec_Music_Twang               EQU      $C858
_C870                         EQU      $C870
_C880                         EQU      $C880
_C881                         EQU      $C881
_C886                         EQU      $C886
_C888                         EQU      $C888
_C88A                         EQU      $C88A
_C88D                         EQU      $C88D
_C88E                         EQU      $C88E
_C88F                         EQU      $C88F
_C890                         EQU      $C890
_C891                         EQU      $C891
_C892                         EQU      $C892
_C89B                         EQU      $C89B
_C8A2                         EQU      $C8A2
_C8B6                         EQU      $C8B6
_C8B7                         EQU      $C8B7
_C8BD                         EQU      $C8BD
_C8BE                         EQU      $C8BE
_C8C0                         EQU      $C8C0
_C8C8                         EQU      $C8C8
_C8CA                         EQU      $C8CA
_C8D9                         EQU      $C8D9
_C8DA                         EQU      $C8DA
_C8DB                         EQU      $C8DB
_C8DC                         EQU      $C8DC
_C8E7                         EQU      $C8E7
_C8EA                         EQU      $C8EA
_C8EB                         EQU      $C8EB
_C8EC                         EQU      $C8EC
_C8ED                         EQU      $C8ED
_C8EE                         EQU      $C8EE
_C8F2                         EQU      $C8F2
_C8F3                         EQU      $C8F3
_C8F4                         EQU      $C8F4
_C8F5                         EQU      $C8F5
_C8F6                         EQU      $C8F6
_C8F7                         EQU      $C8F7
_C8F8                         EQU      $C8F8
_C907                         EQU      $C907
_C909                         EQU      $C909
_CA58                         EQU      $CA58
_CA5A                         EQU      $CA5A
_CA5C                         EQU      $CA5C
Vec_SWI3_Vector               EQU      $CBF2
Vec_SWI_Vector                EQU      $CBFB
_CCCC                         EQU      $CCCC
_CCD8                         EQU      $CCD8
_CE7C                         EQU      $CE7C
_CEFE                         EQU      $CEFE
VIA_t1_lch_hi                 EQU      $D007
VIA_port_a_nohs               EQU      $D00F
_D018                         EQU      $D018
_D050                         EQU      $D050
_D058                         EQU      $D058
_D090                         EQU      $D090
_D0A8                         EQU      $D0A8
_D0B0                         EQU      $D0B0
_D8AF                         EQU      $D8AF
_D8D8                         EQU      $D8D8
_DF9C                         EQU      $DF9C
_E000                         EQU      $E000
_E019                         EQU      $E019
_E030                         EQU      $E030
_E031                         EQU      $E031
_E034                         EQU      $E034
_E03D                         EQU      $E03D
_E081                         EQU      $E081
_E09F                         EQU      $E09F
_E0A5                         EQU      $E0A5
_E0B8                         EQU      $E0B8
_E0D5                         EQU      $E0D5
_E0F9                         EQU      $E0F9
_E129                         EQU      $E129
_E14C                         EQU      $E14C
_E15C                         EQU      $E15C
_E18C                         EQU      $E18C
_E198                         EQU      $E198
_E1A4                         EQU      $E1A4
_E1B6                         EQU      $E1B6
_E1E6                         EQU      $E1E6
_E208                         EQU      $E208
_E214                         EQU      $E214
_E21A                         EQU      $E21A
_E220                         EQU      $E220
_E226                         EQU      $E226
_E239                         EQU      $E239
_E250                         EQU      $E250
_E262                         EQU      $E262
_E290                         EQU      $E290
_E2A0                         EQU      $E2A0
_E2AE                         EQU      $E2AE
_E2B0                         EQU      $E2B0
_E2C2                         EQU      $E2C2
_E2D4                         EQU      $E2D4
_E2EE                         EQU      $E2EE
_E2F2                         EQU      $E2F2
_E2F4                         EQU      $E2F4
_E2F7                         EQU      $E2F7
_E30A                         EQU      $E30A
_E30C                         EQU      $E30C
_E31B                         EQU      $E31B
_E330                         EQU      $E330
_E338                         EQU      $E338
_E34A                         EQU      $E34A
_E353                         EQU      $E353
_E383                         EQU      $E383
_E3A5                         EQU      $E3A5
_E3BE                         EQU      $E3BE
_E3C7                         EQU      $E3C7
_E3D3                         EQU      $E3D3
_E3F7                         EQU      $E3F7
_E3F9                         EQU      $E3F9
_E407                         EQU      $E407
_E430                         EQU      $E430
_E43B                         EQU      $E43B
_E447                         EQU      $E447
_E45A                         EQU      $E45A
_E481                         EQU      $E481
_E485                         EQU      $E485
_E488                         EQU      $E488
_E49C                         EQU      $E49C
_E4B1                         EQU      $E4B1
_E4B8                         EQU      $E4B8
_E4BE                         EQU      $E4BE
_E4C1                         EQU      $E4C1
_E4C6                         EQU      $E4C6
_E4DF                         EQU      $E4DF
_E4E3                         EQU      $E4E3
_E4E7                         EQU      $E4E7
_E4EB                         EQU      $E4EB
_E4EC                         EQU      $E4EC
_E51E                         EQU      $E51E
_E526                         EQU      $E526
_E52A                         EQU      $E52A
_E533                         EQU      $E533
_E58A                         EQU      $E58A
_E596                         EQU      $E596
_E5AB                         EQU      $E5AB
_E5CB                         EQU      $E5CB
_E5D3                         EQU      $E5D3
_E5E1                         EQU      $E5E1
_E5EC                         EQU      $E5EC
_E5FF                         EQU      $E5FF
_E61A                         EQU      $E61A
_E61D                         EQU      $E61D
_E624                         EQU      $E624
_E627                         EQU      $E627
_E644                         EQU      $E644
_E647                         EQU      $E647
_E657                         EQU      $E657
_E670                         EQU      $E670
_E686                         EQU      $E686
_E6B3                         EQU      $E6B3
_E6D7                         EQU      $E6D7
_E6EC                         EQU      $E6EC
_E6F1                         EQU      $E6F1
_E6F8                         EQU      $E6F8
_E6FE                         EQU      $E6FE
_E703                         EQU      $E703
_E711                         EQU      $E711
_E716                         EQU      $E716
_E727                         EQU      $E727
_E742                         EQU      $E742
_E764                         EQU      $E764
_E767                         EQU      $E767
_E76A                         EQU      $E76A
_E784                         EQU      $E784
_E78B                         EQU      $E78B
_E796                         EQU      $E796
_E7A1                         EQU      $E7A1
_E7B3                         EQU      $E7B3
_E7B5                         EQU      $E7B5
_E7D2                         EQU      $E7D2
_E7E4                         EQU      $E7E4
_E7FA                         EQU      $E7FA
_E808                         EQU      $E808
_E810                         EQU      $E810
_E837                         EQU      $E837
_E84C                         EQU      $E84C
_E866                         EQU      $E866
_E876                         EQU      $E876
_E87F                         EQU      $E87F
_E880                         EQU      $E880
_E884                         EQU      $E884
_E88D                         EQU      $E88D
_E88E                         EQU      $E88E
_E892                         EQU      $E892
_E89D                         EQU      $E89D
_E89E                         EQU      $E89E
_E8A2                         EQU      $E8A2
_E8AA                         EQU      $E8AA
_E8E3                         EQU      $E8E3
_E8F1                         EQU      $E8F1
_E8FD                         EQU      $E8FD
_E904                         EQU      $E904
_E90B                         EQU      $E90B
_E90D                         EQU      $E90D
_E915                         EQU      $E915
_E920                         EQU      $E920
_E94A                         EQU      $E94A
_E954                         EQU      $E954
_E95F                         EQU      $E95F
_E98A                         EQU      $E98A
_E991                         EQU      $E991
_E9A1                         EQU      $E9A1
_E9B0                         EQU      $E9B0
_E9BA                         EQU      $E9BA
_E9D5                         EQU      $E9D5
_EA13                         EQU      $EA13
_EA3C                         EQU      $EA3C
_EA3E                         EQU      $EA3E
_EA51                         EQU      $EA51
_EA57                         EQU      $EA57
_EA6D                         EQU      $EA6D
_EA7F                         EQU      $EA7F
_EA8D                         EQU      $EA8D
_EA9D                         EQU      $EA9D
_EAA8                         EQU      $EAA8
_EAB4                         EQU      $EAB4
_EACF                         EQU      $EACF
_EAEF                         EQU      $EAEF
_EAF0                         EQU      $EAF0
_EB1D                         EQU      $EB1D
_EB29                         EQU      $EB29
_EB35                         EQU      $EB35
_EB41                         EQU      $EB41
_EB43                         EQU      $EB43
_EB4F                         EQU      $EB4F
_EB53                         EQU      $EB53
_EB59                         EQU      $EB59
_EB5A                         EQU      $EB5A
_EB93                         EQU      $EB93
_EB9A                         EQU      $EB9A
_EBA0                         EQU      $EBA0
_EBA9                         EQU      $EBA9
_EC17                         EQU      $EC17
_EC20                         EQU      $EC20
_EC46                         EQU      $EC46
_EC56                         EQU      $EC56
_EC5C                         EQU      $EC5C
_EC63                         EQU      $EC63
_EC64                         EQU      $EC64
_EC95                         EQU      $EC95
_ECA4                         EQU      $ECA4
_ECB2                         EQU      $ECB2
_ECB3                         EQU      $ECB3
_ECC9                         EQU      $ECC9
_ECD6                         EQU      $ECD6
_ECE3                         EQU      $ECE3
_ECF0                         EQU      $ECF0
_ECF5                         EQU      $ECF5
_ED00                         EQU      $ED00
_ED07                         EQU      $ED07
_ED0A                         EQU      $ED0A
_ED1A                         EQU      $ED1A
_ED20                         EQU      $ED20
_ED30                         EQU      $ED30
_ED36                         EQU      $ED36
_ED80                         EQU      $ED80
_EDE3                         EQU      $EDE3
_EE39                         EQU      $EE39
_EE40                         EQU      $EE40
_EE70                         EQU      $EE70
_EE88                         EQU      $EE88
_EEDD                         EQU      $EEDD
_EF22                         EQU      $EF22
_EF25                         EQU      $EF25
Start                         EQU      $F000
_F008                         EQU      $F008
LF01C                         EQU      $F01C
LF029                         EQU      $F029
_F040                         EQU      $F040
_F048                         EQU      $F048
LF052                         EQU      $F052
LF058                         EQU      $F058
Warm_Start                    EQU      $F06C
LF084                         EQU      $F084
LF092                         EQU      $F092
LF097                         EQU      $F097
LF09E                         EQU      $F09E
LF0A4                         EQU      $F0A4
_F0B8                         EQU      $F0B8
_F0C0                         EQU      $F0C0
LF0D2                         EQU      $F0D2
Intro_Boxes                   EQU      $F0E9
_F0F8                         EQU      $F0F8
DF0FD                         EQU      $F0FD
Copyright_Str                 EQU      $F101
here__                        EQU      $F10C
Vec_Title                     EQU      $F10C
Vec_Title_2                   EQU      $F118
Init_VIA                      EQU      $F14C
Init_OS_RAM                   EQU      $F164
LF173                         EQU      $F173
Init_OS                       EQU      $F18B
Wait_Recal                    EQU      $F192
LF19E                         EQU      $F19E
Set_Refresh                   EQU      $F1A2
DP_to_D0                      EQU      $F1AA
DP_to_C8                      EQU      $F1AF
Read_Btns_Mask                EQU      $F1B4
Read_Btns                     EQU      $F1BA
LF1EA                         EQU      $F1EA
Joy_Analog                    EQU      $F1F5
Joy_Digital                   EQU      $F1F8
LF1FB                         EQU      $F1FB
LF1FF                         EQU      $F1FF
LF20B                         EQU      $F20B
LF213                         EQU      $F213
LF22D                         EQU      $F22D
LF235                         EQU      $F235
LF236                         EQU      $F236
LF23A                         EQU      $F23A
LF240                         EQU      $F240
LF24C                         EQU      $F24C
Sound_Byte                    EQU      $F256
Sound_Byte_x                  EQU      $F259
Sound_Byte_raw                EQU      $F25B
Clear_Sound                   EQU      $F272
LF275                         EQU      $F275
Sound_Bytes                   EQU      $F27D
LF282                         EQU      $F282
Sound_Bytes_x                 EQU      $F284
Do_Sound                      EQU      $F289
Do_Sound_x                    EQU      $F28C
LF291                         EQU      $F291
LF299                         EQU      $F299
Intensity_1F                  EQU      $F29D
Intensity_3F                  EQU      $F2A1
Intensity_5F                  EQU      $F2A5
Intensity_7F                  EQU      $F2A9
Intensity_a                   EQU      $F2AB
Dot_ix_b                      EQU      $F2BE
Dot_ix                        EQU      $F2C1
Dot_d                         EQU      $F2C3
Dot_here                      EQU      $F2C5
LF2CC                         EQU      $F2CC
LF2D2                         EQU      $F2D2
Dot_List                      EQU      $F2D5
Dot_List_Reset                EQU      $F2DE
Recalibrate                   EQU      $F2E6
Moveto_x_7F                   EQU      $F2F2
Moveto_d_7F                   EQU      $F2FC
Moveto_ix_FF                  EQU      $F308
Moveto_ix_7F                  EQU      $F30C
Moveto_ix_b                   EQU      $F30E
Moveto_ix                     EQU      $F310
Moveto_d                      EQU      $F312
LF318                         EQU      $F318
LF33B                         EQU      $F33B
LF33D                         EQU      $F33D
LF341                         EQU      $F341
LF345                         EQU      $F345
Reset0Ref_D0                  EQU      $F34A
Check0Ref                     EQU      $F34F
Reset0Ref                     EQU      $F354
Reset_Pen                     EQU      $F35B
LF36A_RTS                     EQU      $F36A
Reset0Int                     EQU      $F36B
Print_Str_hwyx                EQU      $F373
Print_Str_yx                  EQU      $F378
Print_Str_d                   EQU      $F37A
LF383                         EQU      $F383
Print_List_hw                 EQU      $F385
Print_List                    EQU      $F38A
Print_List_Chk                EQU      $F38C
Print_Ships_x                 EQU      $F391
Print_Ships                   EQU      $F393
LF3A3                         EQU      $F3A3
Mov_Draw_VLc_a                EQU      $F3AD
Mov_Draw_VL_b                 EQU      $F3B1
Mov_Draw_VLcs                 EQU      $F3B5
Mov_Draw_VL_ab                EQU      $F3B7
Mov_Draw_VL_a                 EQU      $F3B9
Mov_Draw_VL                   EQU      $F3BC
Mov_Draw_VL_d                 EQU      $F3BE
Draw_VLc                      EQU      $F3CE
Draw_VL_b                     EQU      $F3D2
Draw_VLcs                     EQU      $F3D6
Draw_VL_ab                    EQU      $F3D8
Draw_VL_a                     EQU      $F3DA
Draw_VL                       EQU      $F3DD
Draw_Line_d                   EQU      $F3DF
LF3ED                         EQU      $F3ED
LF3F4                         EQU      $F3F4
Draw_VLp_FF                   EQU      $F404
Draw_VLp_7F                   EQU      $F408
Draw_VLp_scale                EQU      $F40C
Draw_VLp_b                    EQU      $F40E
Draw_VLp                      EQU      $F410
LF425                         EQU      $F425
LF433                         EQU      $F433
Draw_Pat_VL_a                 EQU      $F434
Draw_Pat_VL                   EQU      $F437
Draw_Pat_VL_d                 EQU      $F439
LF459                         EQU      $F459
LF45C                         EQU      $F45C
Draw_VL_mode                  EQU      $F46E
LF476                         EQU      $F476
LF47E                         EQU      $F47E
LF485                         EQU      $F485
LF48D                         EQU      $F48D
Print_Str                     EQU      $F495
LF4A5                         EQU      $F4A5
LF4C7                         EQU      $F4C7
LF4CB                         EQU      $F4CB
LF4EB                         EQU      $F4EB
LF50A                         EQU      $F50A
Random_3                      EQU      $F511
Random                        EQU      $F517
LF51A                         EQU      $F51A
LF51D                         EQU      $F51D
Init_Music_Buf                EQU      $F533
Clear_x_b                     EQU      $F53F
Clear_C8_RAM                  EQU      $F542
Clear_x_256                   EQU      $F545
Clear_x_d                     EQU      $F548
Clear_x_b_80                  EQU      $F550
Clear_x_b_a                   EQU      $F552
Dec_3_Counters                EQU      $F55A
Dec_6_Counters                EQU      $F55E
LF560                         EQU      $F560
Dec_Counters                  EQU      $F563
LF569                         EQU      $F569
Delay_3                       EQU      $F56D
Delay_2                       EQU      $F571
Delay_1                       EQU      $F575
Delay_0                       EQU      $F579
Delay_b                       EQU      $F57A
Delay_RTS                     EQU      $F57D
Bitmask_a                     EQU      $F57E
Abs_a_b                       EQU      $F584
Abs_b                         EQU      $F58B
LF592                         EQU      $F592
Rise_Run_Angle                EQU      $F593
LF5B0                         EQU      $F5B0
LF5B2                         EQU      $F5B2
LF5D0                         EQU      $F5D0
LF5D3                         EQU      $F5D3
Get_Rise_Idx                  EQU      $F5D9
Get_Run_Idx                   EQU      $F5DB
LF5E5                         EQU      $F5E5
LF5EC                         EQU      $F5EC
Rise_Run_Idx                  EQU      $F5EF
Rise_Run_X                    EQU      $F5FF
Rise_Run_Y                    EQU      $F601
Rise_Run_Len                  EQU      $F603
Rot_VL_ab                     EQU      $F610
Rot_VL                        EQU      $F616
Rot_VL_Mode                   EQU      $F61F
Rot_VL_M_dft                  EQU      $F62B
LF635                         EQU      $F635
LF637                         EQU      $F637
Xform_Run_a                   EQU      $F65B
Xform_Run                     EQU      $F65D
Xform_Rise_a                  EQU      $F661
Xform_Rise                    EQU      $F663
LF665                         EQU      $F665
LF66F                         EQU      $F66F
LF676                         EQU      $F676
LF679                         EQU      $F679
LF67E                         EQU      $F67E
Move_Mem_a_1                  EQU      $F67F
Move_Mem_a                    EQU      $F683
LF686                         EQU      $F686
Init_Music_chk                EQU      $F687
Init_Music                    EQU      $F68D
Init_Music_dft                EQU      $F692
LF6B3                         EQU      $F6B3
LF6B8                         EQU      $F6B8
LF6C0                         EQU      $F6C0
LF6CA                         EQU      $F6CA
LF6D2                         EQU      $F6D2
LF6E3                         EQU      $F6E3
LF6EA                         EQU      $F6EA
LF6EC                         EQU      $F6EC
LF712                         EQU      $F712
LF735                         EQU      $F735
LF748                         EQU      $F748
LF74E                         EQU      $F74E
LF759                         EQU      $F759
LF766                         EQU      $F766
LF76D                         EQU      $F76D
LF778                         EQU      $F778
LF788                         EQU      $F788
LF78C                         EQU      $F78C
LF793_RTS                     EQU      $F793
Player_Str                    EQU      $F794
Game_Str                      EQU      $F79F
Select_Game                   EQU      $F7A9
LF7B1                         EQU      $F7B1
LF7B6                         EQU      $F7B6
LF7C5                         EQU      $F7C5
LF7F1                         EQU      $F7F1
_F800                         EQU      $F800
LF80C                         EQU      $F80C
LF810                         EQU      $F810
LF821                         EQU      $F821
LF82A                         EQU      $F82A
LF82C                         EQU      $F82C
Display_Option                EQU      $F835
LF84E                         EQU      $F84E
Clear_Score                   EQU      $F84F
Add_Score_a                   EQU      $F85E
LF861                         EQU      $F861
LF86D                         EQU      $F86D
LF878                         EQU      $F878
Add_Score_d                   EQU      $F87C
LF882                         EQU      $F882
LF88F                         EQU      $F88F
LF895                         EQU      $F895
LF897                         EQU      $F897
LF8A5                         EQU      $F8A5
LF8AE                         EQU      $F8AE
Strip_Zeros                   EQU      $F8B7
LF8C6                         EQU      $F8C6
Compare_Score                 EQU      $F8C7
LF8CA                         EQU      $F8CA
LF8D5                         EQU      $F8D5
LF8D6                         EQU      $F8D6
New_High_Score                EQU      $F8D8
LF8DE                         EQU      $F8DE
LF8E4                         EQU      $F8E4
Obj_Will_Hit_u                EQU      $F8E5
LF8EF                         EQU      $F8EF
Obj_Will_Hit                  EQU      $F8F3
Obj_Hit                       EQU      $F8FF
LF903                         EQU      $F903
LF906                         EQU      $F906
LF90F                         EQU      $F90F
LF91B                         EQU      $F91B
LF928                         EQU      $F928
LF92A                         EQU      $F92A
Explosion_Snd                 EQU      $F92E
LF95B                         EQU      $F95B
LF968                         EQU      $F968
LF97B                         EQU      $F97B
LF97D                         EQU      $F97D
LF987                         EQU      $F987
LF98F                         EQU      $F98F
LF991                         EQU      $F991
LF997                         EQU      $F997
LF99E                         EQU      $F99E
LF9BC                         EQU      $F9BC
LF9C2                         EQU      $F9C2
LF9C9_RTS                     EQU      $F9C9
LF9CA                         EQU      $F9CA
LF9CF                         EQU      $F9CF
LF9DB_RTS                     EQU      $F9DB
Bit_Masks                     EQU      $F9DC
Music_Table_1                 EQU      $F9E4
Music_Table_2                 EQU      $F9EA
Recal_Points                  EQU      $F9F0
Char_Table                    EQU      $F9F4
Char_Table_End                EQU      $FBD4
DFC24                         EQU      $FC24
DFC2C                         EQU      $FC2C
DFC6D                         EQU      $FC6D
Freq_Table                    EQU      $FC8D
music1                        EQU      $FD0D
Intro_Music                   EQU      $FD0D
DFD1D                         EQU      $FD1D
DFD69                         EQU      $FD69
DFD79                         EQU      $FD79
DFD81                         EQU      $FD81
DFDC3                         EQU      $FDC3
DFDD3                         EQU      $FDD3
DFE28                         EQU      $FE28
DFE38                         EQU      $FE38
DFE66                         EQU      $FE66
DFE76                         EQU      $FE76
DFEB2                         EQU      $FEB2
DFEB6                         EQU      $FEB6
DFEC6                         EQU      $FEC6
DFEE8                         EQU      $FEE8
DFEF8                         EQU      $FEF8
_FF08                         EQU      $FF08
DFF16                         EQU      $FF16
DFF26                         EQU      $FF26
DFF44                         EQU      $FF44
DFF62                         EQU      $FF62
DFF7A                         EQU      $FF7A
DFF8F                         EQU      $FF8F
Draw_Grid_VL                  EQU      $FF9F
LFFA3                         EQU      $FFA3
LFFAB                         EQU      $FFAB
LFFAE                         EQU      $FFAE
_FFB0                         EQU      $FFB0
_FFD8                         EQU      $FFD8
_FFF8                         EQU      $FFF8
                    bank 0
                    direct $FF
; *                       $C83B   ;High score cold-start flag (=0 if valid)
; *                       $C83C   ;temp byte
; *                       $C843   ;        register 9
; *                       $C844   ;        register 8
; *                       $C848   ;        register 4
; *                       $C849   ;        register 3
; *                       $C84A   ;        register 2
; *                       $C84C   ;        register 0
; *                       $C85E   ;Scratch 'score' storage for Display_Option (7 bytes)
; *               $C868...$C876   ;Unused?
; *                       $C878   ;Unused?
; *    $C880 - $CBEA is user RAM  ;
; *       0 sample/hold (0=enable  mux 1=disable mux)
; *       1 mux sel 0
; *       2 mux sel 1
; *       3 sound BC1
; *       4 sound BDIR
; *       5 comparator input
; *       6 external device (slot pin 35) initialized to input
; *       7 /RAMP
; *       0 PA latch enable
; *       1 PB latch enable
; *       2 \                     110=output to CB2 under control of phase 2 clock
; *       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
; *       4 /
; *       5 0=t2 one shot                 1=t2 free running
; *       6 0=t1 one shot                 1=t1 free running
; *       7 0=t1 disable PB7 output       1=t1 enable PB7 output
; *       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
; *       1 \
; *       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
; *       3 /
; *       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
; *       5 \
; *       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
; *       7 /
; *               bit                             cleared by
; *       0 CA2 interrupt flag            reading or writing port A I/O
; *       1 CA1 interrupt flag            reading or writing port A I/O
; *       2 shift register interrupt flag reading or writing shift register
; *       3 CB2 interrupt flag            reading or writing port B I/O
; *       4 CB1 interrupt flag            reading or writing port A I/O
; *       5 timer 2 interrupt flag        read t2 low or write t2 high
; *       6 timer 1 interrupt flag        read t1 count low or write t1 high
; *       7 IRQ status flag               write logic 0 to IER or IFR bit
; *       0 CA2 interrupt enable
; *       1 CA1 interrupt enable
; *       2 shift register interrupt enable
; *       3 CB2 interrupt enable
; *       4 CB1 interrupt enable
; *       5 timer 2 interrupt enable
; *       6 timer 1 interrupt enable
; *       7 IER set/clear control
; GCS Copyright
; GCS Copyright
line:
assembler:
at:
                    DB       "g GCE     ", $80  ; *                       $C839   ;Pointer to copyright string during startup
; Start music pointer
Copyright_Len:
                    DW       $0013              ; Start music pointer
; end of header
                    DB       $00                ; end of header
; start of cartridge code!
start:
start:
                    ldu      #$478E             ; start of cartridge code!
                    pulu     a,b,dp,x,y,s,pc
                    neg      <$00
                    neg      <$00
                    neg      <$80
                    direct $D0
ResetIntegrators:
                    lda      #$CC               ; $cc means ZERO enabled, and BLANK enabled
                    sta      <VIA_cntl          ; VIA control register
                    ldd      #$0300
_0020:
                    std      <VIA_port_b        ; mux sel = integrator offsets, mux disabled
                    dec      <VIA_port_b        ; enable mux
                    nop                         ; delay
                    nop                         ; delay
                    dec      <VIA_port_b        ; disable mux
_0028:
                    rts      
; -)
AlexWaitRecal:
                    ldd      >AlexRCCounterHi   ; Recal Counter... probably used for blinking
                    addd     #$01
                    std      >AlexRCCounterHi
                    lda      #$D0               ; setup DP
                    tfr      a,dp
                    lda      #$20               ; load timer 2 bit mask
                    bita     <VIA_int_flags     ; check if timeout happend
                    bne      waitRecal50HzReached ; if yes -> branch
                    lda      #$30               ; check for t2 to be "reset" (latched to $30 if timeout happened)
timer2ReloadWait:
                    cmpa     <VIA_t2_hi         ; was t2 reloaded?
_0040:
                    blt      timer2ReloadWait   ; no - than wait for it
                    bsr      ResetIntegrators
; A = 0; B = $40
                    ldd      #$40               ; Below is the "typical" back and forth of a recalibration diagonal+$40 and -$40 for a certain time...
                    stb      <VIA_port_a        ; dac = $40
; x/y integrators = +$40
                    sta      <VIA_port_b        ; mux enabled, mux sel = 0
                    ldd      #$CE18             ; B = $18 T1 OneSHotMode WITHOUT Ramp control, Shift out under System clock, A = $ce means ZERO disabled, and BLANK enabled
                    sta      <VIA_cntl          ; set T1 to no ramp control (ORB bit 7 is manually controlled)
                    stb      <VIA_aux_cntl      ; zero off, blank on
                    ldd      #$BF00             ; T1 = $00BF (A= lowT1 BF, B = highT1 $00)
                    std      <VIA_t1_cnt_lo
timer1WaitLoop:
                    lda      #$40               ; interrupt bit 6 = T1
                    bita     <VIA_int_flags     ; check T1
                    beq      T1Running          ; if not timed out -> jump
                    neg      <VIA_port_a        ; dac = -$40
                    ldd      #$1F00             ; T1 = $001F (A= lowT1 1F, B = highT1 $00)
                    std      <VIA_t1_cnt_lo
T1Running:
                    lda      #$20               ; interrupt bit 5 = T2
                    bita     <VIA_int_flags     ; check T2
                    beq      timer1WaitLoop     ; if also not set, check T1 again
waitRecal50HzReached:
                    ldd      #$3075             ; reload T2 with 50Hz value; (A=$30, B=$75 -> T2 = 7530 = 30000 cycles
                    std      <VIA_t2_lo         ; set T2
                    ldd      #$0200             ; T1 = $0002 (A= lowT1 02, B = highT1 $00)
                    std      <VIA_t1_cnt_lo     ; set T1
                    ldd      #$0198             ; A= 1; B = $98
                    sta      <VIA_port_b        ; mux off
                    stb      <VIA_aux_cntl      ; T1 OneSHotMode WITH Ramp control, Shift out under System clock
                    bra      ResetIntegrators   ; done recalibrating
AlexMoveToD:
                    sta      <VIA_port_a        ; D filled with rowCounter, A = y, B = x, put Y value to DAC
                    clr      <VIA_port_b        ; muxel sel = 00 (y) enable Mux
                    lda      #$CE
                    sta      <VIA_cntl          ; $ce means ZERO disabled, and BLANK enabled
                    lda      #$01               ; 
                    std      <VIA_port_b        ; A -> disable mux ($1), b to via port A = B (DAC filled with X delta)
                    clr      <VIA_t1_cnt_hi     ; start Timer T1
                    lda      #$40               ; flag for T1 interrupt
AlexMoveToDT1Loop:
                    bita     <VIA_int_flags     ; testflag
                    beq      AlexMoveToDT1Loop  ; if not set, wait for it
                    rts                         ; back
                    sta      <VIA_port_a
                    clr      <VIA_port_b
                    lda      #$CE
                    sta      <VIA_cntl
                    lda      #$01
                    std      <VIA_port_b
                    ldd      #$7F00
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_00A5:
                    bita     <VIA_int_flags
                    beq      _00A5
                    rts      
AlexIntensity_A:
                    sta      <VIA_port_a        ; put A to via porta
                    direct $FF
                    lda      #$04               ; mux enabled, mux sel = 10 (intensity)
                    sta      <$00               ; to port B
                    nop                         ; delay
                    nop      
                    lda      #$01               ; mux disable
                    sta      <$00               ; to port B
                    rts                         ; done
                    direct $C8
init_C838_ff:
                    ldd      #$DEFA
                    std      >SyncData1
                    lda      #$CE
                    sta      >SyncData3
                    rts      
_00C3:
                    ldd      <SyncData1
                    aslb     
                    rola     
                    eora     <SyncData1
                    ldb      <Vec_Rise_Index
                    stb      <SyncData1
                    ldb      <SyncData3
                    stb      <Vec_Rise_Index
                    sta      <SyncData3
                    direct $FF
                    eora     #$40
                    rts      
init_c83b_ff:
                    ldd      #$DEFA
                    std      >_C83B
                    lda      #$CE
                    sta      >_C83D
                    rts      
_00E2:
                    ldd      <$3B
                    aslb     
                    rola     
                    eora     <$3B
                    ldb      <$3C
                    stb      <$3B
                    ldb      <$3D
                    stb      <$3C
                    sta      <$3D
                    eora     #$40
                    rts      
                    direct $D0
; the following draw/move routines are part of the vectorlists...
draw_vector:
                    sta      <VIA_port_a        ; 
                    clra     
                    sta      <VIA_port_b
_00FA:
                    nop      
                    nop      
                    inca     
                    std      <VIA_port_b
                    ldd      #$0F
                    stb      <VIA_shift_reg
                    sta      <VIA_t1_cnt_hi
                    ldd      #$40E0
_0109:
                    bita     <VIA_int_flags
                    beq      _0109
                    stb      <VIA_shift_reg
                    pulu     a,b,pc
draw_vector_final:
                    sta      <VIA_port_a
                    clra     
                    sta      <VIA_port_b
                    nop      
                    nop      
                    inca     
                    std      <VIA_port_b
                    ldd      #$0F
                    stb      <VIA_shift_reg
                    sta      <VIA_t1_cnt_hi
                    ldd      #$40E0
_0125:
                    bita     <VIA_int_flags
                    beq      _0125
                    stb      <VIA_shift_reg
                    rts      
move_vector:
                    sta      <VIA_port_a
                    clra     
                    sta      <VIA_port_b
                    nop      
                    nop      
                    inca     
                    std      <VIA_port_b
                    ldd      #$40
                    sta      <VIA_t1_cnt_hi
_013B:
                    bitb     <VIA_int_flags
                    beq      _013B
                    direct $FF
                    pulu     a,b,pc
                    sta      <$01
                    clra     
                    sta      <$00
                    nop      
                    nop      
                    inca     
                    std      <$00
                    pulu     a,b,pc
_014D:
                    lda      a,y
                    sta      <$01
                    lda      #$04
                    sta      <$00
                    nop      
                    nop      
                    lda      #$01
                    std      <$00
                    ldd      #$0F
                    stb      <$0A
                    sta      <$05
                    ldd      #$40E0
_0165:
                    bita     <$0D
                    beq      _0165
                    stb      <$0A
                    pulu     a,b,pc
                    lda      a,y
                    sta      <$01
                    lda      #$04
                    sta      <$00
                    nop      
                    nop      
                    lda      #$01
                    std      <$00
                    ldd      #$0F
                    stb      <$0A
                    sta      <$05
                    ldd      #$40E0
_0185:
                    bita     <$0D
                    beq      _0185
                    stb      <$0A
                    rts      
printString_isyx:
                    pulu     a,b,x              ; U pointer to structure, intensity, scale, ypos,xpos
                    std      >textIntensity
                    stx      >rowPos_YX
                    stu      >currentStringStartStruct
                    bsr      printString
                    cmpa     #$FF               ; text endmarker = $ff
                    bne      printString_isyx   ; end reached? no branch
                    rts                         ; done
printString_yx:
                    pulu     a,b
                    std      >rowPos_YX
                    stu      >currentStringStartStruct
                    direct $D0
printString:
                    lda      #$D0               ; setup DP
                    tfr      a,dp
                    ldd      >textIntensity     ; A= intensity, B = scale
                    aslb                        ; double scale?
                    stb      <VIA_t1_cnt_lo     ; to counter 1
                    jsr      >AlexIntensity_A
                    ldx      #FontRow1
                    bsr      printFontOneRow
                    dec      >rowPos_YX
                    ldx      #FontRow2
                    bsr      printFontOneRow
                    dec      >rowPos_YX
                    ldx      #FontRow3
                    bsr      printFontOneRow
                    dec      >rowPos_YX
                    ldx      #FontRow4
                    bsr      printFontOneRow
                    dec      >rowPos_YX
                    ldx      #FontRow5
                    bsr      printFontOneRow
                    dec      >rowPos_YX
                    ldx      #FontRow6
                    bsr      printFontOneRow
                    dec      >rowPos_YX
                    ldx      #FontRow7
printFontOneRow:
                    jsr      >ResetIntegrators  ; Font Pointer in X, rowCounter -> pos
                    ldd      >rowPos_YX
                    jsr      >AlexMoveToD
                    clra     
                    sta      <VIA_port_a        ; DAC = 0
                    sta      <VIA_port_b        ; mux sel = Y int, mux enabled
                    ldb      >textXSize
                    inca     
                    std      <VIA_port_b        ; disable mux, set via port A = b
                    ldu      >currentStringStartStruct ; T1 without ramp control
; T1 OneSHotMode WITHOUT Ramp control, Shift out under System clock
                    lda      #$18               ; $18
_01FF:
                    sta      <VIA_aux_cntl
                    bra      start_shiftout
continue_shiftout:
                    lda      a,x                ; use char as offset in font tab
                    direct $FF
                    sta      <$0A               ; and shift the current "row" of the font out
start_shiftout:
                    lda      ,u+
                    bpl      continue_shiftout  ; if positive, shift out next bitmap
                    ldb      #$98               ; otherwise "reset T1 ramp control"
; T1 OneSHotMode WITH Ramp control, Shift out under System clock
                    stb      <$0B               ; $98
                    rts                         ; and out
FontRow1:
                    DB       $FC, $10, $FC, $F8, $F8, $FC ; ; font length = 108x7
                    DB       $FC, $FC, $78, $FC, $78, $F8
                    DB       $FC, $F8, $FC, $FC, $00, $FE
                    DB       $FE, $FE, $FE, $00, $3F, $3F
                    DB       $3F, $FF, $FF, $FF, $FF, $F8
                    DB       $F8, $38, $00, $38, $6C, $00
                    DB       $10, $C4, $70, $30, $18, $30
                    DB       $00, $00, $00, $00, $00, $04
                    DB       $38, $18, $7C, $7E, $1C, $FC
                    DB       $3C, $FE, $78, $7C, $00, $00
                    DB       $0C, $00, $60, $3C, $38, $38
                    DB       $FC, $3C, $F8, $FE, $FE, $3E
                    DB       $C6, $7E, $06, $C6, $C0, $C6
                    DB       $C6, $7C, $FC, $7C, $FC, $78
                    DB       $7E, $C6, $C6, $C6, $C6, $66
                    DB       $FE, $3C, $80, $78, $10, $00
                    DB       $10, $38, $10, $10, $10, $FE
                    DB       $FE, $FE, $FE, $FE, $FE, $FE
FontRow2:
                    DB       $84, $10, $84, $08, $88, $80
                    DB       $84, $04, $48, $84, $48, $88
                    DB       $84, $84, $80, $80, $03, $01
                    DB       $01, $01, $01, $80, $20, $20
                    DB       $20, $00, $00, $00, $00, $08
                    DB       $08, $44, $00, $38, $6C, $6C
                    DB       $7C, $CC, $D8, $30, $30, $18
                    DB       $10, $10, $00, $00, $00, $0C
                    DB       $4C, $38, $C6, $0C, $3C, $C0
                    DB       $60, $C6, $C4, $C6, $30, $30
                    DB       $18, $00, $30, $66, $44, $6C
                    DB       $C6, $66, $CC, $C0, $C0, $60
                    DB       $C6, $18, $06, $CC, $C0, $EE
                    DB       $E6, $C6, $C6, $C6, $C6, $CC
                    DB       $18, $C6, $C6, $C6, $EE, $66
                    DB       $0E, $30, $C0, $18, $38, $00
                    DB       $38, $38, $30, $18, $38, $82
                    DB       $82, $FE, $EE, $BA, $92, $C6
FontRow3:
                    DB       $84, $10, $04, $1C, $88, $80
                    DB       $80, $04, $48, $84, $48, $88
                    DB       $80, $84, $80, $80, $0C, $44
                    DB       $7C, $38, $44, $60, $20, $2C
                    DB       $2D, $00, $60, $6C, $6D, $08
                    DB       $68, $9A, $00, $38, $48, $FE
                    DB       $D0, $18, $D8, $60, $60, $0C
                    DB       $54, $10, $00, $00, $00, $18
                    DB       $C6, $18, $0E, $18, $6C, $FC
                    DB       $C0, $0C, $E4, $C6, $30, $30
                    DB       $30, $7C, $18, $06, $9A, $C6
                    DB       $C6, $C0, $C6, $C0, $C0, $C0
                    DB       $C6, $18, $06, $D8, $C0, $FE
                    DB       $F6, $C6, $C6, $C6, $C6, $C0
                    DB       $18, $C6, $C6, $D6, $7C, $66
                    DB       $1C, $30, $60, $18, $6C, $00
                    DB       $7C, $38, $7E, $FC, $7C, $82
                    DB       $92, $EE, $C6, $EE, $BA, $92
FontRow4:
                    DB       $84, $30, $FC, $0C, $88, $FC
                    DB       $FC, $0C, $FC, $FC, $FC, $FC
                    DB       $C0, $C4, $FC, $FC, $10, $64
                    DB       $40, $40, $44, $10, $20, $2C
                    DB       $2D, $00, $60, $6C, $6D, $08
                    DB       $68, $A2, $00, $30, $00, $6C
                    DB       $7C, $30, $72, $00, $60, $0C
                    DB       $38, $7C, $00, $7C, $00, $30
                    DB       $C6, $18, $3C, $3C, $CC, $06
                    DB       $FC, $18, $78, $7E, $00, $00
                    DB       $60, $00, $0C, $0C, $AA, $C6
                    DB       $FC, $C0, $C6, $FC, $FC, $CE
                    DB       $FE, $18, $06, $F0, $C0, $FE
                    DB       $FE, $C6, $C6, $C6, $CE, $7C
                    DB       $18, $C6, $EE, $FE, $38, $3C
                    DB       $38, $30, $30, $18, $00, $00
                    DB       $FE, $FE, $FE, $FE, $00, $82
                    DB       $92, $EE, $92, $C6, $EE, $BA
FontRow5:
                    DB       $84, $30, $C0, $0C, $FC, $0C
                    DB       $8C, $0C, $8C, $0C, $C4, $C4
                    DB       $C0, $C4, $C0, $C0, $20, $54
                    DB       $78, $38, $54, $08, $20, $2C
                    DB       $2D, $00, $60, $6C, $6D, $08
                    DB       $68, $9A, $00, $30, $00, $FE
                    DB       $16, $60, $DE, $00, $60, $0C
                    DB       $54, $10, $30, $00, $00, $60
                    DB       $C6, $18, $78, $06, $FE, $06
                    DB       $C6, $30, $9E, $06, $30, $30
                    DB       $30, $7C, $18, $18, $9C, $FE
                    DB       $C6, $C0, $C6, $C0, $C0, $C6
_0408:
                    DB       $C6, $18, $06, $F8, $C0, $D6
                    DB       $DE, $C6, $FC, $DE, $F8, $06
                    DB       $18, $C6, $7C, $FE, $7C, $18
                    DB       $70, $30, $18, $18, $00, $00
                    DB       $38, $7C, $7E, $FC, $7C, $82
                    DB       $AA, $D6, $BA, $92, $C6, $EE
FontRow6:
                    DB       $8C, $30, $C0, $8C, $18, $8C
                    DB       $8C, $0C, $8C, $0C, $C4, $C4
                    DB       $C4, $C4, $C0, $C0, $50, $4C
                    DB       $40, $04, $6C, $14, $20, $20
                    DB       $20, $00, $00, $00, $00, $08
                    DB       $08, $44, $00, $00, $00, $6C
                    DB       $7C, $CC, $CC, $00, $30, $18
                    DB       $10, $10, $30, $00, $30, $C0
                    DB       $64, $18, $E0, $C6, $0C, $C6
                    DB       $C6, $30, $86, $0C, $30, $30
                    DB       $18, $00, $30, $00, $40, $C6
                    DB       $C6, $66, $CC, $C0, $C0, $66
                    DB       $C6, $18, $C6, $DC, $C0, $C6
                    DB       $CE, $C6, $C0, $CC, $DC, $C6
                    DB       $18, $C6, $38, $EE, $EE, $18
                    DB       $E0, $30, $0C, $18, $00, $00
                    DB       $38, $38, $30, $18, $38, $82
                    DB       $82, $FE, $EE, $BA, $92, $C6
FontRow7:
                    DB       $FC, $30, $FC, $FC, $18, $FC
                    DB       $FC, $0C, $FC, $0C, $C4, $FC
                    DB       $FC, $F8, $FC, $C0, $88, $44
                    DB       $7C, $38, $44, $22, $3F, $3F
                    DB       $3F, $FF, $FF, $FF, $FF, $F8
                    DB       $F8, $38, $00, $30, $00, $00
                    DB       $10, $8C, $76, $00, $18, $30
                    DB       $00, $00, $60, $00, $30, $80
                    DB       $38, $7E, $FE, $7C, $0C, $7C
                    DB       $7C, $30, $7C, $78, $00, $60
                    DB       $0C, $00, $60, $18, $38, $C6
                    DB       $FC, $3C, $F8, $FE, $C0, $3E
                    DB       $C6, $7E, $7C, $CE, $FE, $C6
                    DB       $C6, $7C, $C0, $7A, $CE, $7C
                    DB       $18, $7C, $10, $C6, $C6, $18
                    DB       $FE, $3C, $04, $78, $00, $FE
                    DB       $38, $10, $10, $10, $10, $FE
                    DB       $FE, $FE, $FE, $FE, $FE, $FE
                    direct $D0
printBerzerkArenaBitmap:
                    lda      #$D0               ; setup DP
                    tfr      a,dp
                    lda      #$48               ; A= $48
                    sta      <VIA_t1_cnt_lo     ; Set timer 1 to that
                    ldu      #bitmapBerzerkArena
                    lda      #$50               ; Bitmap Rows
                    sta      >rowPos_YX
                    ldx      #bitMapIntensityCycle
                    ldb      >AlexRCCounterLo
                    lsrb     
                    andb     #$0F
                    abx      
                    bsr      _052B
                    ldx      #bitMapIntensityCycle
                    ldb      >AlexRCCounterLo
                    lsrb     
                    comb     
                    andb     #$0F
                    abx      
_052B:
                    lda      #$13               ; bitmap Columns +1
                    sta      >CounterVar
_0530:
                    jsr      >ResetIntegrators
                    lda      ,x+
                    jsr      >AlexIntensity_A
                    lda      >rowPos_YX
                    ldb      #$C6
                    jsr      >AlexMoveToD
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    ldd      #move_vector
                    std      <VIA_port_b
                    lda      #$18
                    sta      <VIA_aux_cntl
                    ldb      #$0C
_0551:
                    brn      _0553
_0553:
                    lda      ,u+
                    sta      <VIA_shift_reg
                    decb     
                    bne      _0551
                    lda      #$98
                    sta      <VIA_aux_cntl
                    dec      >rowPos_YX
                    dec      >CounterVar
                    bne      _0530
                    direct $FF
                    rts      
bitMapIntensityCycle:
                    DB       $30, $34, $38, $3C, $40, $44, $48, $4C
                    DB       $50, $4C, $48, $44, $40, $3C, $38, $34
                    DB       $30, $34, $38, $3C, $40, $44, $48, $4C
                    DB       $50, $4C, $48, $44, $40, $3C, $38, $34
                    DB       $30, $34
bitmapBerzerkArena:
                    DB       %00111111, %11100000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
                    DB       %01111111, %11110000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
                    DB       %01111000, %00111000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %11000000, %00000000
                    DB       %01111000, %01011000, %11111101, %11000000, %00000000, %11111111, %11111011, %11110111, %00000000, %00000011, %11000000, %11000000
                    DB       %01110000, %00011000, %01111111, %11100011, %11000000, %01111111, %11111001, %11111111, %10001111, %00000011, %10000001, %11000000
                    DB       %01110000, %00111000, %11111111, %11100011, %11111100, %01111110, %11111011, %11111111, %10001111, %11110011, %10000010, %10000000
                    DB       %01110000, %01110000, %00100000, %00000011, %10111110, %10000000, %11111000, %10000000, %00001110, %11111011, %11000111, %10000000
                    DB       %01111011, %11110000, %00110000, %00000011, %10010110, %00000000, %11110000, %11000000, %00001110, %01011001, %11001110, %00000000
                    DB       %01111111, %11110000, %00111000, %00000011, %00000011, %00000001, %11100000, %11100000, %00001100, %00001101, %11011110, %00000000
                    DB       %00111111, %11111000, %00111111, %11111111, %00000101, %00000011, %11000000, %11111111, %11111100, %00010101, %11011100, %00000000
                    DB       %01111000, %01111000, %00111111, %11110111, %00000110, %00000111, %10000000, %11111111, %11011100, %00011001, %10111110, %00000000
                    DB       %01110000, %00011100, %01111111, %11111111, %00001110, %00001111, %00000001, %11111111, %11111100, %00111001, %11111110, %00000000
                    DB       %01110000, %00011100, %00111000, %00000111, %01111110, %00001110, %00000000, %11100000, %00011101, %11111001, %11101111, %00000000
                    DB       %01110000, %00001110, %00111000, %00001011, %11111100, %00011110, %00000000, %11100000, %00101111, %11110010, %11100111, %10000000
                    DB       %01110000, %00001110, %00111000, %00000111, %11110000, %00111100, %00000000, %11100000, %00011111, %11000010, %11000011, %10000000
                    DB       %01110000, %00001110, %00111111, %11110111, %00111000, %01010000, %00000000, %11111111, %11011100, %11100001, %11000010, %11000000
                    DB       %01110000, %00001110, %00111111, %11111110, %00011000, %11111111, %11111000, %11111111, %11111000, %01100001, %11000011, %10000000
                    DB       %01010000, %00001100, %00111111, %11111110, %00011000, %01111111, %11110000, %11111111, %11111000, %01100001, %11000001, %11100000
                    DB       %01110000, %00011100, %00000010, %00001110, %00011000, %11111100, %11110000, %00000000, %00111000, %01100001, %11000000, %01000000
                    DB       %00111000, %00011100, %00000111, %10001110, %00011100, %00000000, %00000000, %00000000, %00111000, %01110000, %00000000, %00000000
                    DB       %00000000, %00111000, %00001111, %10000100, %00001100, %00000000, %00000000, %00000000, %00010000, %00110000, %00000000, %00000000
                    DB       %01000000, %11110000, %00001111, %10000000, %00001110, %00000000, %00000000, %00000000, %00000000, %00111000, %00000000, %00000000
                    DB       %01111111, %11100000, %00001111, %11000000, %00001110, %01111110, %11100000, %00000001, %00000001, %10111000, %00000000, %00000000
                    DB       %01111111, %11000000, %00001111, %11000000, %11110110, %00111111, %11110001, %10000001, %10000001, %10011000, %00000000, %00000000
                    DB       %00010010, %00000000, %00001111, %11000000, %11111111, %01111111, %11110001, %11000000, %11000011, %11110000, %00000000, %00000000
                    DB       %00000000, %00000000, %00001110, %01000000, %11101111, %10010000, %00000000, %11100001, %11000011, %11101000, %00000000, %00000000
                    DB       %00000000, %00000000, %00001110, %01000000, %11100101, %10011000, %00000001, %11110001, %11000011, %11100000, %00000000, %00000000
                    DB       %00000000, %00000000, %00011100, %01000000, %11000000, %11011100, %00000001, %11110001, %11000011, %11100000, %00000000, %00000000
                    DB       %00000000, %00000000, %00011110, %01100001, %11000001, %01011111, %11111101, %11111011, %11000111, %10100000, %00000000, %00000000
                    DB       %00000000, %00000000, %00011111, %11100001, %11000001, %10011111, %11111001, %11011101, %10000111, %00100000, %00000000, %00000000
                    DB       %00000000, %00000000, %00111101, %11111001, %11000011, %10111111, %11111101, %10001111, %10000111, %00110000, %00000000, %00000000
                    DB       %00000000, %00000000, %01111011, %11111001, %11011111, %10011100, %00000011, %10000111, %10000111, %11110000, %00000000, %00000000
                    DB       %00000000, %00000000, %11111000, %01110010, %11111111, %00011100, %00000001, %10000111, %10011110, %11111000, %00000000, %00000000
                    DB       %00000000, %00000000, %11110000, %00110001, %11111100, %00011100, %00000001, %10000011, %10011101, %11111000, %00000000, %00000000
                    DB       %00000000, %00000000, %01110000, %00111001, %11001110, %00011111, %11111001, %10000001, %10011100, %00011000, %00000000, %00000000
                    DB       %00000000, %00000000, %10110000, %00111011, %10000110, %00011111, %11111101, %10000011, %11011000, %00011000, %00000000, %00000000
                    DB       %00000000, %00000000, %00000000, %00111011, %10000110, %00011111, %11111011, %00000011, %11001000, %00011000, %00000000, %00000000
                    DB       %00000000, %00000000, %00000000, %00011011, %10000110, %00000000, %00000000, %00000001, %11000000, %00011100, %00000000, %00000000
                    DB       %00000000, %00000000, %00000000, %00011111, %10000111, %00000000, %00000000, %00000001, %11000000, %00010000, %00000000, %00000000
                    DB       %00000000, %00000000, %00000000, %00011101, %00000011, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
                    direct $C8
_0769:
                    lda      ,u+
                    direct $FF
                    cmpa     <$44
                    bcs      _0779
                    ora      #$01
                    sta      <$44
                    lda      #$01
                    sta      <$45
                    stu      <$46
_0779:
                    rts      
writeYMRegListToPSG:
                    lda      >YM_MainStatus
                    beq      exit_ymWrite
                    dec      >YM_ListStatus
                    bne      exit_ymWrite
                    direct $D0
                    lda      #$D0               ; setup DP
                    tfr      a,dp
;  register, data
                    ldu      >YM_Pointer        ; U pointer to YM structure, first byte is register, if register is negative, than all done
                    ldb      ,u+
                    bpl      write_next_PSG
                    pulu     a,b
                    sta      >YM_MainStatus
                    beq      exit_ymWrite
write_next_PSG:
                    stb      <VIA_port_a        ; B to DAC
                    ldd      #$1901             ; A= $19, B = 01
                    sta      <VIA_port_b        ; mux disabled PSG latch
                    stb      <VIA_port_b        ; mux disabled, PSG inactive
                    lda      ,u+                ; A = data
                    sta      <VIA_port_a        ; to Via port A -> to PSG reg
                    lda      #$11               ; A = $11
                    sta      <VIA_port_b        ; mux disabled PSG write
                    direct $FF
                    stb      <$00               ; mux disabled, PSG inactive
                    ldb      ,u+
                    bpl      write_next_PSG
                    lda      ,u+
                    sta      >YM_ListStatus
                    stu      >YM_Pointer
exit_ymWrite:
                    rts      
                    DB       $FF, $0E, $FF, $07, $FF, $08, $00, $09 ; I think the following are YM, register change lists
                    DB       $00, $0A, $00, $FF, $01, $FF, $00, $01
                    DB       $00, $30, $01, $00, $08, $08, $07, $FE
                    DB       $FF, $01, $08, $00, $FF, $08, $08, $01
                    DB       $FF, $0C, $07, $FF, $FF, $01, $FF, $00
                    DB       $F1, $06, $00, $08, $0D, $07, $F7, $FF
                    DB       $01, $FF, $01, $07, $FF, $FF, $01, $FF
                    DB       $00, $41, $00, $00, $01, $01, $06, $07
                    DB       $08, $0B, $07, $F6, $FF, $01, $00, $40
                    DB       $06, $1B, $08, $0C, $FF, $01, $00, $80
                    DB       $06, $0F, $08, $0D, $FF, $01, $00, $C0
                    DB       $07, $FE, $FF, $01, $00, $00, $01, $02
                    DB       $08, $0C, $FF, $01, $00, $40, $FF, $01
                    DB       $00, $80, $08, $0B, $FF, $01, $00, $C0
                    DB       $FF, $01, $00, $00, $01, $03, $08, $0A
                    DB       $FF, $01, $00, $40, $FF, $01, $00, $80
                    DB       $08, $09, $FF, $01, $00, $C0, $FF, $01
                    DB       $00, $00, $01, $04, $08, $08, $FF, $01
                    DB       $00, $40, $FF, $01, $00, $80, $08, $07
                    DB       $FF, $01, $00, $C0, $FF, $01, $00, $00
                    DB       $01, $05, $08, $06, $FF, $01, $00, $40
                    DB       $FF, $01, $00, $80, $08, $05, $FF, $01
                    DB       $00, $C0, $FF, $01, $00, $00, $01, $06
                    DB       $08, $04, $FF, $01, $00, $40, $FF, $01
                    DB       $00, $80, $08, $03, $FF, $01, $00, $C0
                    DB       $FF, $01, $07, $FF, $FF, $01, $FF, $00
                    DB       $51, $00, $A3, $01, $00, $02, $B0, $03
                    DB       $00, $08, $0F, $09, $0F, $07, $FC, $FF
                    DB       $01, $08, $0E, $09, $0E, $FF, $01, $08
                    DB       $0D, $09, $0D, $FF, $01, $08, $0C, $09
                    DB       $0C, $FF, $01, $08, $0B, $09, $0B, $FF
                    DB       $01, $08, $0A, $09, $0A, $FF, $01, $08
                    DB       $09, $09, $09, $FF, $01, $08, $08, $09
                    DB       $08, $FF, $01, $08, $07, $09, $07, $FF
                    DB       $01, $08, $06, $09, $06, $FF, $01, $08
                    DB       $05, $09, $05, $FF, $01, $08, $04, $09
                    DB       $04, $FF, $01, $08, $03, $09, $03, $FF
                    DB       $01, $08, $02, $09, $02, $FF, $01, $08
                    DB       $01, $09, $01, $FF, $01, $07, $FF, $FF
                    DB       $01, $FF, $00, $51, $00, $AA, $01, $00
                    DB       $02, $B7, $03, $00, $08, $0F, $09, $0F
                    DB       $07, $FC, $FF, $01, $08, $0E, $09, $0E
                    DB       $FF, $01, $08, $0D, $09, $0D, $FF, $01
                    DB       $08, $0C, $09, $0C, $FF, $01, $08, $0B
                    DB       $09, $0B, $FF, $01, $08, $0A, $09, $0A
                    DB       $FF, $01, $08, $09, $09, $09, $FF, $01
                    DB       $08, $08, $09, $08, $FF, $01, $08, $07
                    DB       $09, $07, $FF, $01, $08, $06, $09, $06
                    DB       $FF, $01, $08, $05, $09, $05, $FF, $01
                    DB       $FF, $40, $08, $04, $09, $04, $FF, $01
                    DB       $08, $03, $09, $03, $FF, $01, $08, $02
                    DB       $09, $02, $FF, $01, $08, $01, $09, $01
                    DB       $FF, $01, $07, $FF, $FF, $01, $FF, $00
                    DB       $51, $00, $A7, $01, $00, $02, $B3, $03
                    DB       $00, $08, $0F, $09, $0F, $07, $FC, $FF
                    DB       $01, $08, $0E, $09, $0E, $FF, $01, $08
                    DB       $0D, $09, $0D, $FF, $01, $08, $0C, $09
                    DB       $0C, $FF, $01, $08, $0B, $09, $0B, $FF
                    DB       $01, $08, $0A, $09, $0A, $FF, $01, $08
                    DB       $09, $09, $09, $FF, $01, $08, $08, $09
                    DB       $08, $FF, $01, $08, $07, $09, $07, $FF
                    DB       $01, $08, $06, $09, $06, $FF, $01, $08
                    DB       $05, $09, $05, $FF, $01, $FF, $40, $08
                    DB       $04, $09, $04, $FF, $01, $08, $03, $09
                    DB       $03, $FF, $01, $08, $02, $09, $02, $FF
                    DB       $01, $08, $01, $09, $01, $FF, $01, $07
                    DB       $FF, $FF, $01, $FF, $00, $51, $00, $AE
                    DB       $01, $00, $02, $A1, $03, $00, $08, $0F
                    DB       $09, $0F, $07, $FC, $FF, $01, $08, $0E
                    DB       $09, $0E, $FF, $01, $08, $0D, $09, $0D
                    DB       $FF, $01, $08, $0C, $09, $0C, $FF, $01
                    DB       $08, $0B, $09, $0B, $FF, $01, $08, $0A
                    DB       $09, $0A, $FF, $01, $08, $09, $09, $09
                    DB       $FF, $01, $08, $08, $09, $08, $FF, $01
                    DB       $08, $07, $09, $07, $FF, $01, $08, $06
                    DB       $09, $06, $FF, $01, $08, $05, $09, $05
                    DB       $FF, $01, $FF, $40, $08, $04, $09, $04
                    DB       $FF, $01, $08, $03, $09, $03, $FF, $01
                    DB       $08, $02, $09, $02, $FF, $01, $08, $01
                    DB       $09, $01, $FF, $01, $07, $FF, $FF, $01
                    DB       $FF
                    DB       $00
                    DB       $51
gameStartSound:
                    DB       $00, $55           ; register and data
                    DB       $01, $00
                    DB       $02, $3C
                    DB       $03, $00
                    DB       $08, $01
                    DB       $09, $01
                    DB       $07, $FC
                    DB       $FF                ; end of ym-output
                    DB       $02                ; next list status
                    DB       $08, $02
                    DB       $09, $02
                    DB       $FF                ; end of list
                    DB       $02, $08, $03, $09, $03, $FF, $02, $08
                    DB       $04, $09, $04, $FF, $02, $08, $05, $09
                    DB       $05, $FF, $02, $08, $06, $09, $06, $FF
                    DB       $02, $08, $07, $09, $07, $FF, $02, $08
                    DB       $08, $09, $08, $FF, $02, $08, $09, $09
                    DB       $09, $FF, $02, $08, $0A, $09, $0A, $FF
                    DB       $02, $08, $0B, $09, $0B, $FF, $02, $08
                    DB       $0C, $09, $0C, $FF, $02, $08, $0D, $09
                    DB       $0D, $FF, $02, $08, $0E, $09, $0E, $FF
                    DB       $02, $08, $0F, $09, $0F, $FF, $03, $08
                    DB       $0E, $09, $0E, $FF, $03, $08, $0D, $09
                    DB       $0D, $FF, $03, $08, $0C, $09, $0C, $FF
                    DB       $03, $08, $0B, $09, $0B, $FF, $03, $08
                    DB       $0A, $09, $0A, $FF, $03, $08, $09, $09
                    DB       $09, $FF, $03, $08, $08, $09, $08, $FF
                    DB       $03, $FF, $40, $08, $07, $09, $07, $FF
                    DB       $03, $08, $06, $09, $06, $FF, $03, $08
                    DB       $05, $09, $05, $FF, $03, $08, $04, $09
                    DB       $04, $FF, $03, $08, $03, $09, $03, $FF
                    DB       $03, $08, $02, $09, $02, $FF, $03, $08
                    DB       $01, $09, $01, $FF, $03, $07, $FF, $FF
                    DB       $01, $FF, $00, $51, $07, $FF, $0B, $38
                    DB       $0C, $00, $0D, $0E, $08, $10, $FF, $01
                    DB       $0B, $34, $FF, $01, $0B, $30, $FF, $01
                    DB       $0B, $2C, $FF, $01, $0B, $28, $FF, $01
                    DB       $0B, $24, $FF, $01, $0B, $20, $FF, $01
                    DB       $0B, $1C, $FF, $01, $0B, $18, $FF, $01
                    DB       $0B, $14, $FF, $01, $0B, $10, $FF, $01
                    DB       $0B, $0C, $FF, $01, $0B, $08, $FF, $01
                    DB       $0B, $04, $FF, $01, $08, $00, $FF, $01
                    DB       $FF, $00, $43, $06, $01, $08, $02, $07
                    DB       $F7, $FF, $01, $06, $02, $08, $04, $FF
                    DB       $01, $06, $03, $08, $06, $FF, $01, $06
                    DB       $04, $08, $08, $FF, $01, $06, $05, $08
                    DB       $0A, $FF, $01, $06, $06, $08, $0C, $FF
                    DB       $02, $08, $0B, $FF, $02, $08, $0A, $FF
                    DB       $03, $08, $09, $FF, $04, $08, $08, $FF
                    DB       $05, $08, $07, $FF, $06, $08, $06, $FF
                    DB       $06, $08, $05, $FF, $06, $FF, $01, $08
                    DB       $04, $FF, $06, $08, $03, $FF, $06, $08
                    DB       $02, $FF, $06, $08, $01, $FF, $06, $07
                    DB       $FF, $FF, $01, $FF, $00, $51, $00, $4E
                    DB       $01, $01, $02, $60, $03, $01, $06, $1F
                    DB       $08, $0F, $09, $0F, $07, $E4, $FF, $04
                    DB       $08, $0E, $09, $0E, $FF, $04, $08, $0D
                    DB       $09, $0D, $FF, $04, $08, $0C, $09, $0C
                    DB       $FF, $04, $08, $0B, $09, $0B, $FF, $04
                    DB       $08, $0A, $09, $0A, $FF, $04, $08, $09
                    DB       $09, $09, $FF, $04, $08, $08, $09, $08
                    DB       $FF, $04, $08, $07, $09, $07, $FF, $04
                    DB       $08, $06, $09, $06, $FF, $04, $08, $05
                    DB       $09, $05, $FF, $04, $08, $04, $09, $04
                    DB       $FF, $04, $08, $03, $09, $03, $FF, $04
                    DB       $08, $02, $09, $02, $FF, $04, $08, $01
                    DB       $09, $01, $FF, $04, $07, $FF, $FF, $01
                    DB       $FF, $00, $51, $07, $FF, $0B, $06, $0C
                    DB       $00, $0D, $0E, $08, $10, $FF, $04, $0B
                    DB       $02, $FF, $04, $0B, $05, $FF, $04, $0B
                    DB       $07, $FF, $04, $0B, $03, $FF, $04, $0B
                    DB       $06, $FF, $04, $0B, $04, $FF, $04, $0B
                    DB       $02, $FF, $04, $08, $00, $FF, $01, $FF
                    DB       $00
_0C37:
                    lda      #$C8
                    tfr      a,dp
                    lda      <$48
                    ldx      #$0C42
                    jmp      [a,x]
                    inc      <$4A
                    tst      <$9B
                    jmp      <$EE
                    DB       $10, $3F
                    ldy      #$41CF
                    lda      <$4A
                    lsra     
                    lsra     
                    lsra     
                    leay     a,y
                    lda      <$4C
                    lsra     
                    nega     
                    sta      <$4D
                    adda     #$7F
                    sta      <$4E
                    clra     
                    sta      <$4F
                    sta      <$50
                    ldu      #$C852
                    ldx      <$10
                    ldb      <$4B
                    abx      
                    lda      <$49
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      #$0C
                    sta      <$04
                    lda      #$D0
                    tfr      a,dp
_0C7B:
                    lda      ,y
                    ldb      #$28
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      <<-$01,x
                    bmi      _0CC7
                    lda      >_C84F
_0C8C:
                    sta      <$10,u
                    lda      <-$21,x
                    bpl      _0CE2
                    lda      <-$20,x
                    bmi      _0C9C
                    jsr      >_1354
_0C9C:
                    lda      >_C84F
                    beq      _0CBD
                    deca     
                    suba     ,y
                    bcs      _0CE2
                    sta      >_C851
                    ldb      >_C84D
                    negb     
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _0CBD
                    jsr      >_1256
                    lda      ,y
                    sta      >_C84F
                    bra      _0CE2
_0CBD:
                    jsr      >_13D4
                    lda      ,y
                    sta      >_C84F
                    bra      _0CE2
_0CC7:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _0CE2
                    sta      >_C851
                    jsr      >_1190
                    lda      ,y
                    sta      >_C84F
                    lda      <-$21,x
                    bmi      _0CE2
                    jsr      >_1354
_0CE2:
                    lda      <<$01,x
                    bmi      _0D23
                    lda      >_C850
                    sta      <$20,u
                    lda      <-$1F,x
                    bpl      _0D3E
                    lda      <-$20,x
                    bmi      _0CF9
                    jsr      >_1394
_0CF9:
                    lda      >_C850
_0CFC:
                    beq      _0D19
                    deca     
                    suba     ,y
                    bcs      _0D3E
                    sta      >_C851
                    ldb      >_C84E
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _0D19
                    jsr      >_12D5
                    lda      ,y
                    sta      >_C850
                    bra      _0D3E
_0D19:
                    jsr      >_144B
                    lda      ,y
                    sta      >_C850
                    bra      _0D3E
_0D23:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _0D3E
                    sta      >_C851
                    jsr      >_11F3
                    lda      ,y
                    sta      >_C850
                    lda      <-$1F,x
                    bmi      _0D3E
                    jsr      >_1394
_0D3E:
                    clr      ,u+
                    lda      <-$20,x
                    bmi      _0D53
                    leax     <-$20,x
                    leay     <$20,y
                    dec      >CounterVar
                    lbne     _0C7B
                    rts      
_0D53:
                    lda      <<-$01,x
                    bmi      _0D5C
                    lda      <-$21,x
                    bmi      _0D5F
_0D5C:
                    jsr      >_1354
_0D5F:
                    lda      <<$01,x
                    bmi      _0D68
                    lda      <-$1F,x
                    bmi      _0D6B
_0D68:
                    jsr      >_1394
_0D6B:
                    jsr      >_14C2
_0D6E:
                    dec      >CounterVar
                    beq      _0D9A
                    leax     <-$20,x
                    lda      <<-$01,x
                    bpl      _0D7F
                    lda      #$01
                    sta      >_C84F
_0D7F:
                    lda      >_C84F
                    sta      <$10,u
                    lda      <<$01,x
                    bpl      _0D8E
                    lda      #$01
                    sta      >_C850
_0D8E:
                    lda      >_C850
                    sta      <$20,u
                    lda      ,y
                    sta      ,u+
                    bra      _0D6E
_0D9A:
                    rts      
                    ldy      #$41EF
                    lda      <$4C
                    lsra     
                    lsra     
                    lsra     
                    nega     
                    leay     a,y
                    lda      <$4A
                    lsra     
                    nega     
                    sta      <$4D
                    adda     #$7F
                    sta      <$4E
                    clra     
                    sta      <$4F
                    sta      <$50
                    ldu      #$C852
                    ldx      <$10
                    ldb      <$4B
                    abx      
                    lda      <$49
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      #$0C
                    sta      <$04
                    lda      #$D0
                    tfr      a,dp
_0DCD:
                    lda      ,y
                    ldb      #$28
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      <-$20,x
                    bmi      _0E19
                    lda      >_C84F
                    sta      <$10,u
                    lda      <-$1F,x
                    bpl      _0E34
                    lda      <<$01,x
                    bmi      _0DEE
                    jsr      >_1354
_0DEE:
                    lda      >_C84F
                    beq      _0E0F
                    deca     
                    suba     ,y
                    bcs      _0E34
                    sta      >_C851
                    ldb      >_C84D
                    negb     
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _0E0F
                    jsr      >_1256
                    lda      ,y
                    sta      >_C84F
                    bra      _0E34
_0E0F:
                    jsr      >_13D4
                    lda      ,y
                    sta      >_C84F
                    bra      _0E34
_0E19:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _0E34
                    sta      >_C851
                    jsr      >_1190
                    lda      ,y
                    sta      >_C84F
                    lda      <-$1F,x
                    bmi      _0E34
                    jsr      >_1354
_0E34:
                    lda      <$20,x
                    bmi      _0E75
                    lda      >_C850
                    sta      <$20,u
_0E3F:
                    lda      <$21,x
                    bpl      _0E90
                    lda      <<$01,x
                    bmi      _0E4B
                    jsr      >_1394
_0E4B:
                    lda      >_C850
                    beq      _0E6B
                    deca     
                    suba     ,y
                    bcs      _0E90
                    sta      >_C851
                    ldb      >_C84E
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _0E6B
                    jsr      >_12D5
                    lda      ,y
                    sta      >_C850
                    bra      _0E90
_0E6B:
                    jsr      >_144B
                    lda      ,y
                    sta      >_C850
                    bra      _0E90
_0E75:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _0E90
                    sta      >_C851
                    jsr      >_11F3
                    lda      ,y
                    sta      >_C850
                    lda      <$21,x
                    bmi      _0E90
                    jsr      >_1394
_0E90:
                    clr      ,u+
                    lda      <<$01,x
                    bmi      _0EA3
                    leax     <<$01,x
                    leay     <$20,y
                    dec      >CounterVar
                    lbne     _0DCD
                    rts      
_0EA3:
                    lda      <-$20,x
                    bmi      _0EAD
                    lda      <-$1F,x
                    bmi      _0EB0
_0EAD:
                    jsr      >_1354
_0EB0:
                    lda      <$20,x
                    bmi      _0EBA
                    lda      <$21,x
                    bmi      _0EBD
_0EBA:
                    jsr      >_1394
_0EBD:
                    jsr      >_14C2
_0EC0:
                    dec      >CounterVar
                    beq      _0EED
                    leax     <<$01,x
                    lda      <-$20,x
                    bpl      _0ED1
                    lda      #$01
                    sta      >_C84F
_0ED1:
                    lda      >_C84F
                    sta      <$10,u
                    lda      <$20,x
                    bpl      _0EE1
                    lda      #$01
                    sta      >_C850
_0EE1:
                    lda      >_C850
                    sta      <$20,u
                    lda      ,y
                    sta      ,u+
                    bra      _0EC0
_0EED:
                    rts      
                    ldy      #$41EF
                    lda      <$4A
                    lsra     
                    lsra     
                    lsra     
                    nega     
                    leay     a,y
                    lda      <$4C
                    lsra     
                    sta      <$4E
_0EFF:
                    suba     #$7F
                    sta      <$4D
                    clra     
                    sta      <$4F
                    sta      <$50
                    ldu      #$C852
                    ldx      <$10
                    ldb      <$4B
                    abx      
                    lda      <$49
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      #$0C
                    sta      <$04
                    lda      #$D0
                    tfr      a,dp
_0F1F:
                    lda      ,y
                    ldb      #$28
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      <<$01,x
                    bmi      _0F6B
                    lda      >_C84F
                    sta      <$10,u
                    lda      <$21,x
                    bpl      _0F86
                    lda      <$20,x
                    bmi      _0F40
                    jsr      >_1354
_0F40:
                    lda      >_C84F
                    beq      _0F61
                    deca     
                    suba     ,y
                    bcs      _0F86
                    sta      >_C851
                    ldb      >_C84D
                    negb     
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _0F61
                    jsr      >_1256
                    lda      ,y
                    sta      >_C84F
                    bra      _0F86
_0F61:
                    jsr      >_13D4
                    lda      ,y
                    sta      >_C84F
                    bra      _0F86
_0F6B:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _0F86
                    sta      >_C851
                    jsr      >_1190
                    lda      ,y
                    sta      >_C84F
                    lda      <$21,x
                    bmi      _0F86
                    jsr      >_1354
_0F86:
                    lda      <<-$01,x
                    bmi      _0FC7
                    lda      >_C850
                    sta      <$20,u
                    lda      <$1F,x
                    bpl      _0FE2
                    lda      <$20,x
                    bmi      _0F9D
                    jsr      >_1394
_0F9D:
                    lda      >_C850
                    beq      _0FBD
                    deca     
                    suba     ,y
                    bcs      _0FE2
                    sta      >_C851
                    ldb      >_C84E
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _0FBD
                    jsr      >_12D5
                    lda      ,y
                    sta      >_C850
                    bra      _0FE2
_0FBD:
                    jsr      >_144B
                    lda      ,y
                    sta      >_C850
                    bra      _0FE2
_0FC7:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _0FE2
                    sta      >_C851
                    jsr      >_11F3
                    lda      ,y
                    sta      >_C850
                    lda      <$1F,x
                    bmi      _0FE2
                    jsr      >_1394
_0FE2:
                    clr      ,u+
                    lda      <$20,x
                    bmi      _0FF7
                    leax     <$20,x
                    leay     <$20,y
                    dec      >CounterVar
                    lbne     _0F1F
                    rts      
_0FF7:
                    lda      <<$01,x
                    bmi      _1000
                    lda      <$21,x
                    bmi      _1003
_1000:
                    jsr      >_1354
_1003:
                    lda      <<-$01,x
                    bmi      _100C
                    lda      <$1F,x
                    bmi      _100F
_100C:
                    jsr      >_1394
_100F:
                    jsr      >_14C2
_1012:
                    dec      >CounterVar
                    beq      _103E
                    leax     <$20,x
                    lda      <<$01,x
                    bpl      _1023
                    lda      #$01
                    sta      >_C84F
_1023:
                    lda      >_C84F
                    sta      <$10,u
                    lda      <<-$01,x
                    bpl      _1032
                    lda      #$01
                    sta      >_C850
_1032:
                    lda      >_C850
                    sta      <$20,u
                    lda      ,y
                    sta      ,u+
                    bra      _1012
_103E:
                    rts      
                    ldy      #$41CF
                    lda      <$4C
                    lsra     
                    lsra     
                    lsra     
                    leay     a,y
                    lda      <$4A
                    lsra     
                    sta      <$4E
_104F:
                    suba     #$7F
                    sta      <$4D
                    clra     
                    sta      <$4F
                    sta      <$50
                    ldu      #$C852
                    ldx      <$10
                    ldb      <$4B
                    abx      
                    lda      <$49
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      #$0C
                    sta      <$04
                    lda      #$D0
                    tfr      a,dp
_106F:
                    lda      ,y
                    ldb      #$28
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      <$20,x
                    bmi      _10BB
                    lda      >_C84F
                    sta      <$10,u
                    lda      <$1F,x
                    bpl      _10D6
                    lda      <<-$01,x
                    bmi      _1090
                    jsr      >_1354
_1090:
                    lda      >_C84F
                    beq      _10B1
                    deca     
                    suba     ,y
                    bcs      _10D6
                    sta      >_C851
                    ldb      >_C84D
_10A0:
                    negb     
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _10B1
                    jsr      >_1256
                    lda      ,y
                    sta      >_C84F
                    bra      _10D6
_10B1:
                    jsr      >_13D4
                    lda      ,y
                    sta      >_C84F
                    bra      _10D6
_10BB:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _10D6
                    sta      >_C851
                    jsr      >_1190
                    lda      ,y
                    sta      >_C84F
                    lda      <$1F,x
                    bmi      _10D6
                    jsr      >_1354
_10D6:
                    lda      <-$20,x
                    bmi      _1117
                    lda      >_C850
                    sta      <$20,u
                    lda      <-$21,x
                    bpl      _1132
                    lda      <<-$01,x
                    bmi      _10ED
                    jsr      >_1394
_10ED:
                    lda      >_C850
_10F0:
                    beq      _110D
                    deca     
                    suba     ,y
                    bcs      _1132
                    sta      >_C851
                    ldb      >_C84E
                    aslb     
                    mul      
                    cmpa     ,y
                    bcc      _110D
                    jsr      >_12D5
                    lda      ,y
                    sta      >_C850
                    bra      _1132
_110D:
                    jsr      >_144B
                    lda      ,y
                    sta      >_C850
                    bra      _1132
_1117:
                    lda      <-$20,y
                    deca     
                    suba     ,y
                    bcs      _1132
                    sta      >_C851
                    jsr      >_11F3
                    lda      ,y
                    sta      >_C850
                    lda      <-$21,x
                    bmi      _1132
                    jsr      >_1394
_1132:
                    clr      ,u+
                    lda      <<-$01,x
                    bmi      _1145
                    leax     <<-$01,x
                    leay     <$20,y
                    dec      >CounterVar
                    lbne     _106F
                    rts      
_1145:
                    lda      <$20,x
                    bmi      _114F
                    lda      <$1F,x
                    bmi      _1152
_114F:
                    jsr      >_1354
_1152:
                    lda      <-$20,x
                    bmi      _115C
                    lda      <-$21,x
                    bmi      _115F
_115C:
                    jsr      >_1394
_115F:
                    jsr      >_14C2
_1162:
                    dec      >CounterVar
                    beq      _118F
                    leax     <<-$01,x
                    lda      <$20,x
                    bpl      _1173
                    lda      #$01
                    sta      >_C84F
_1173:
                    lda      >_C84F
                    sta      <$10,u
                    lda      <-$20,x
                    bpl      _1183
                    lda      #$01
                    sta      >_C850
_1183:
                    lda      >_C850
                    sta      <$20,u
                    lda      ,y
                    sta      ,u+
                    bra      _1162
_118F:
                    rts      
_1190:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84D
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_11AB:
                    bita     <$0D
                    beq      _11AB
                    lda      #$01
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40E0
_11BB:
                    bita     <$0D
                    beq      _11BB
                    stb      <$0A
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84D
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_11DC:
                    bita     <$0D
                    beq      _11DC
                    lda      #$01
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40E0
_11EC:
                    bita     <$0D
                    beq      _11EC
                    stb      <$0A
                    rts      
_11F3:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84E
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_120E:
                    bita     <$0D
                    beq      _120E
                    lda      #$01
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40E0
_121E:
                    bita     <$0D
                    beq      _121E
                    stb      <$0A
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84E
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_123F:
                    bita     <$0D
                    beq      _123F
                    lda      #$01
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40E0
_124F:
                    bita     <$0D
                    beq      _124F
                    stb      <$0A
                    rts      
_1256:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84D
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_1271:
                    bita     <$0D
                    beq      _1271
                    clra     
                    sta      <$01
                    sta      <$00
                    nop      
                    lda      #$01
                    ldb      >_C84D
                    std      <$00
                    ldd      #$0300
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40C0
_128F:
                    bita     <$0D
                    beq      _128F
                    stb      <$0A
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84D
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_12B0:
                    bita     <$0D
                    beq      _12B0
                    clra     
                    sta      <$01
                    sta      <$00
                    nop      
                    lda      #$01
                    ldb      >_C84D
                    std      <$00
                    ldd      #$0300
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40C0
_12CE:
                    bita     <$0D
                    beq      _12CE
                    stb      <$0A
                    rts      
_12D5:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84E
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_12F0:
                    bita     <$0D
                    beq      _12F0
                    clra     
                    sta      <$01
                    sta      <$00
                    nop      
                    lda      #$01
                    ldb      >_C84E
                    std      <$00
                    ldd      #$0300
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40C0
_130E:
                    bita     <$0D
                    beq      _130E
                    stb      <$0A
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <$01
                    sta      <$00
                    ldd      #$01CE
                    stb      <$0C
                    ldb      >_C84E
                    std      <$00
                    lda      ,y
                    clrb     
                    std      <$04
                    lda      #$40
_132F:
                    bita     <$0D
                    beq      _132F
                    clra     
                    sta      <$01
                    sta      <$00
                    nop      
                    lda      #$01
                    ldb      >_C84E
                    std      <$00
                    ldd      #$0300
                    sta      <$0A
                    lda      >_C851
                    std      <$04
                    ldd      #$40C0
_134D:
                    bita     <$0D
                    beq      _134D
                    stb      <$0A
                    rts      
                    direct $D0
_1354:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84D
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    deca     
                    sta      <VIA_t1_cnt_lo
                    lda      #$40
_1372:
                    bita     <VIA_int_flags
                    beq      _1372
                    ldd      #$40
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    direct $FF
                    nop      
                    nop      
                    ldd      #$0100
                    std      <$00
                    lda      #$1F
                    sta      <$0A
                    stb      <$05
                    ldd      #$40F0
_138D:
                    bita     <$0D
                    beq      _138D
                    stb      <$0A
                    rts      
                    direct $D0
_1394:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84E
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    deca     
                    sta      <VIA_t1_cnt_lo
                    lda      #$40
_13B2:
                    bita     <VIA_int_flags
                    beq      _13B2
                    ldd      #$40
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    ldd      #$0100
                    std      <VIA_port_b
                    lda      #$1F
                    sta      <VIA_shift_reg
                    stb      <VIA_t1_cnt_hi
                    ldd      #$40F0
_13CD:
                    bita     <VIA_int_flags
                    beq      _13CD
                    stb      <VIA_shift_reg
                    rts      
_13D4:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84D
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_13EF:
                    bita     <VIA_int_flags
                    beq      _13EF
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    ldd      #$0181
                    std      <VIA_port_b
                    ldd      #$1F00
                    sta      <VIA_shift_reg
                    stb      <VIA_t1_cnt_hi
                    ldd      #$40C0
_1409:
                    bita     <VIA_int_flags
                    beq      _1409
                    stb      <VIA_shift_reg
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84D
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_142A:
                    bita     <VIA_int_flags
                    beq      _142A
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    ldd      #$0181
                    std      <VIA_port_b
                    ldd      #$1F00
                    sta      <VIA_shift_reg
                    stb      <VIA_t1_cnt_hi
                    ldd      #$40C0
_1444:
                    bita     <VIA_int_flags
                    beq      _1444
                    stb      <VIA_shift_reg
                    rts      
_144B:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84E
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_1466:
                    bita     <VIA_int_flags
                    beq      _1466
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    ldd      #$017F
                    std      <VIA_port_b
                    ldd      #$1F00
                    sta      <VIA_shift_reg
                    stb      <VIA_t1_cnt_hi
                    ldd      #$40C0
_1480:
                    bita     <VIA_int_flags
                    beq      _1480
                    stb      <VIA_shift_reg
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84E
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_14A1:
                    bita     <VIA_int_flags
                    beq      _14A1
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    ldd      #$017F
                    std      <VIA_port_b
                    ldd      #$1F00
                    sta      <VIA_shift_reg
                    stb      <VIA_t1_cnt_hi
                    ldd      #$40C0
_14BB:
                    bita     <VIA_int_flags
                    beq      _14BB
                    stb      <VIA_shift_reg
                    rts      
_14C2:
                    jsr      >ResetIntegrators
                    ldd      #$00E0
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84D
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_14DD:
                    bita     <VIA_int_flags
                    beq      _14DD
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    ldd      #$017F
                    std      <VIA_port_b
                    ldd      #$1F00
                    sta      <VIA_shift_reg
                    stb      <VIA_t1_cnt_hi
                    ldd      #$40E0
_14F7:
                    bita     <VIA_int_flags
                    beq      _14F7
                    stb      <VIA_shift_reg
                    jsr      >ResetIntegrators
                    ldd      #$20
                    stb      <VIA_port_a
                    sta      <VIA_port_b
                    ldd      #$01CE
                    stb      <VIA_cntl
                    ldb      >_C84D
                    std      <VIA_port_b
                    lda      ,y
                    clrb     
                    std      <VIA_t1_cnt_lo
                    lda      #$40
_1518:
                    bita     <VIA_int_flags
                    beq      _1518
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    nop      
                    direct $FF
                    ldd      #$017F
                    std      <$00
                    ldd      #$1F00
                    sta      <$0A
                    stb      <$05
                    ldd      #$40E0
_1532:
                    bita     <$0D
                    beq      _1532
                    stb      <$0A
                    rts      
                    direct $C8
init_c8f8_to_ca58:
                    ldu      #$CA58
                    ldd      #$00
                    ldx      #$00
                    ldy      #$00
_1546:
                    pshu     y,x,b,a
                    direct $FF
                    pshu     y,x,a
                    cmpu     #$C8F8
                    bne      _1546
                    std      >_C810
                    sta      >_C882
                    rts      
                    direct $D0
_1557:
                    lda      #$D0
                    tfr      a,dp
                    ldu      #$C8F8
                    lda      >_C882
                    anda     #$1F
                    ldb      #$0B
                    mul      
                    leau     d,u
                    ldd      #$7020
                    sta      >rowPos_YX
                    stb      >CounterVar
                    ldd      #$4748
                    stb      <VIA_t1_cnt_lo
                    jsr      >AlexIntensity_A
_1579:
                    jsr      >ResetIntegrators
                    lda      >rowPos_YX
                    suba     #$03
                    sta      >rowPos_YX
                    ldb      #$D2
                    jsr      >AlexMoveToD
                    clra     
                    sta      <VIA_port_a
                    sta      <VIA_port_b
                    nop      
                    ldd      #$0124
                    std      <VIA_port_b
                    lda      #$18
                    sta      <VIA_aux_cntl
                    ldb      #$0B
_159A:
                    brn      _159C
_159C:
                    lda      ,u+
                    sta      <VIA_shift_reg
                    direct $FF
                    decb     
                    bne      _159A
                    lda      #$98
                    sta      <$0B
                    cmpu     #$CA58
                    bne      _15B0
                    ldu      #$C8F8
_15B0:
                    dec      >CounterVar
                    bne      _1579
                    direct $C8
                    lda      #$C8
                    tfr      a,dp
                    ldy      <$0E
                    ldx      <<$02,y
                    cmpx     <Vec_Prev_Btns
                    beq      _15EA
                    lda      <_C882
                    beq      _15E1
                    deca     
                    sta      <_C882
                    ldu      #$C903
                    ldb      #$0B
                    mul      
                    leau     d,u
                    ldd      #$00
                    ldx      #$00
                    ldy      #$00
                    pshu     y,x,b,a
                    pshu     y,x,a
                    bra      _1625
_15E1:
                    stx      <Vec_Prev_Btns
                    ldx      <<$04,y
                    stx      <Vec_Button_1_1
                    stx      <Vec_Button_1_3
                    rts      
_15EA:
                    lda      <_C882
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      ,x
                    beq      _1621
                    ldu      #$C8F8
                    lda      <_C882
                    ldb      #$0B
                    mul      
                    leau     d,u
                    lda      #$0B
_1601:
                    clrb     
                    tst      ,x+
                    bpl      _1608
                    orb      #$60
_1608:
                    tst      ,x+
                    bpl      _160E
                    orb      #$0C
_160E:
                    deca     
                    beq      _161B
                    tst      ,x+
                    bpl      _1617
                    orb      #$01
_1617:
                    stb      ,u+
                    bra      _1601
_161B:
                    stb      ,u+
                    inc      <_C882
                    bra      _1625
_1621:
                    ldx      <<$04,y
                    stx      <Vec_Button_1_1
_1625:
                    lda      <AlexRCCounterLo
                    anda     #$0F
                    beq      _1630
                    cmpa     #$02
                    beq      _1656
                    rts      
_1630:
                    ldy      #$167B
                    ldx      <Vec_Button_1_1
                    stx      <Vec_Button_1_3
_1638:
                    lda      <<$01,x
                    cmpa     <_C882
                    bcc      _164F
                    ldu      #$C8F8
                    ldb      #$0B
                    mul      
                    leau     d,u
                    lda      <<$02,x
                    asla     
                    ldd      a,y
                    orb      a,u
                    stb      a,u
_164F:
                    leax     <<$03,x
                    lda      ,x
                    bpl      _1638
                    rts      
_1656:
                    ldy      #$167B
                    ldx      <Vec_Button_1_3
_165C:
                    lda      <<$01,x
                    cmpa     <_C882
                    bcc      _1674
                    ldu      #$C8F8
                    direct $FF
                    ldb      #$0B
                    mul      
                    leau     d,u
                    lda      <<$02,x
                    asla     
                    ldd      a,y
                    comb     
                    andb     a,u
                    stb      a,u
_1674:
                    leax     <<$03,x
                    lda      ,x
                    bpl      _165C
                    rts      
                    DB       $00, $60, $00, $0C, $00, $01, $01, $60, $01, $0C
                    DB       $01, $01, $02, $60, $02, $0C, $02, $01, $03, $60
                    DB       $03, $0C, $03, $01, $04, $60, $04, $0C, $04, $01
                    DB       $05, $60, $05, $0C, $05, $01, $06, $60, $06, $0C
                    DB       $06, $01, $07, $60, $07, $0C, $07, $01, $08, $60
                    DB       $08, $0C, $08, $01, $09, $60, $09, $0C, $09, $01
                    DB       $0A, $60, $0A, $0C, $00, $01, $46, $03, $16, $E7
                    DB       $18, $C8, $46, $15, $18, $E1, $1A, $E2, $46, $27
                    DB       $1A, $FB, $1E, $FC, $46, $39, $1A, $FB, $1F, $21
                    DB       $46, $4B, $1F, $67, $21, $48, $46, $5C, $1F, $67
                    DB       $21, $6D, $46, $6D, $21, $92, $22, $33, $2E, $2E
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $2E, $2E
                    DB       $2E, $2E, $80, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
                    DB       $2E, $2E, $2E, $2E, $80, $00, $80, $80, $80, $00
                    DB       $80, $80, $00, $80, $80, $80, $80, $80, $80, $00
                    DB       $80, $80, $80, $00, $80, $80, $80, $00, $80, $80
                    DB       $00, $80, $2E, $2E, $2E, $2E, $80, $00, $80, $00
                    DB       $00, $00, $00, $80, $00, $80, $80, $80, $80, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $80, $00
                    DB       $80, $80, $00, $80, $2E, $2E, $80, $80, $80, $00
                    DB       $80, $00, $80, $80, $00, $80, $00, $80, $80, $80
                    DB       $80, $80, $80, $00, $80, $80, $80, $00, $00, $00
                    DB       $00, $00, $80, $80, $00, $80, $80, $80, $80, $00
                    DB       $00, $00, $80, $00, $00, $00, $00, $80, $00, $80
                    DB       $80, $80, $80, $80, $80, $00, $00, $00, $80, $00
                    DB       $80, $80, $80, $80, $80, $80, $00, $00, $00, $80
                    DB       $80, $80, $80, $00, $80, $80, $80, $00, $80, $80
                    DB       $00, $80, $80, $00, $00, $00, $00, $00, $80, $00
                    DB       $80, $00, $80, $80, $80, $80, $80, $80, $00, $80
                    DB       $80, $80, $2E, $2E, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $80, $80, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $00, $80, $00, $00, $00, $00, $00
                    DB       $00, $80, $2E, $2E, $80, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $80, $00, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $00, $80, $00, $80, $00
                    DB       $80, $80, $00, $80, $80, $80, $80, $00, $00, $00
                    DB       $80, $80, $80, $80, $80, $80, $00, $80, $80, $00
                    DB       $00, $00, $80, $80, $80, $00, $80, $00, $80, $00
                    DB       $80, $00, $80, $80, $00, $00, $00, $80, $80, $80
                    DB       $80, $00, $80, $80, $80, $80, $80, $80, $00, $80
                    DB       $80, $80, $80, $00, $00, $00, $00, $00, $80, $00
                    DB       $80, $00, $80, $00, $00, $80, $00, $80, $80, $80
                    DB       $2E, $2E, $80, $00, $80, $80, $80, $80, $00, $00
                    DB       $00, $00, $00, $80, $80, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $00, $80, $80, $00, $80, $00, $80
                    DB       $2E, $2E, $2E, $2E, $80, $00, $80, $80, $80, $80
                    DB       $00, $80, $00, $80, $00, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $00, $80, $80, $00, $80
                    DB       $00, $80, $2E, $2E, $2E, $2E, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $80, $2E, $2E, $2E, $2E, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $2E, $2E, $00, $02
                    DB       $05, $01, $06, $09, $1E, $02, $09, $01, $06, $05
                    DB       $1E, $04, $01, $0A, $00, $0D, $15, $00, $0D, $0A
                    DB       $04, $01, $15, $FF, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $80, $80, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $80, $80, $00
                    DB       $80, $80, $80, $00, $80, $80, $00, $80, $80, $80
                    DB       $00, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $00, $80, $00, $80, $00, $80, $00, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $80, $00, $80, $80, $80, $80, $80, $00, $80
                    DB       $80, $80, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $80, $80, $00, $00, $00, $00, $00, $80, $80
                    DB       $00, $80, $80, $80, $00, $80, $80, $80, $80, $80
                    DB       $00, $80, $80, $80, $00, $80, $00, $80, $00, $80
                    DB       $00, $80, $00, $80, $80, $00, $80, $80, $80, $00
                    DB       $80, $80, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $00, $80
                    DB       $80, $80, $80, $80, $00, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $00, $80, $00, $80, $80, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $80, $00, $80, $80, $00
                    DB       $00, $00, $00, $00, $80, $80, $00, $80, $00, $80
                    DB       $80, $80, $80, $00, $80, $00, $80, $80, $80, $00
                    DB       $80, $80, $00, $80, $80, $80, $00, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $00, $80, $80, $80, $80, $00, $80, $00, $80, $80
                    DB       $80, $00, $80, $80, $00, $80, $80, $80, $00, $80
                    DB       $00, $00, $00, $00, $00, $80, $00, $00, $00, $00
                    DB       $00, $80, $00, $80, $80, $00, $00, $00, $80, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $80, $80, $80
                    DB       $00, $80, $80, $80, $80, $00, $80, $80, $80, $00
                    DB       $80, $80, $80, $80, $00, $80, $80, $00, $80, $00
                    DB       $80, $80, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $80, $00, $80, $80, $80, $80, $00, $80, $80
                    DB       $80, $00, $80, $00, $00, $00, $00, $80, $80, $00
                    DB       $80, $00, $00, $00, $00, $80, $80, $00, $80, $80
                    DB       $80, $80, $00, $00, $00, $00, $00, $00, $80, $00
                    DB       $00, $00, $00, $00, $80, $00, $80, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $80, $00, $80, $80, $00
                    DB       $80, $80, $80, $80, $80, $80, $00, $80, $80, $00
                    DB       $80, $80, $80, $80, $80, $80, $80, $00, $80, $80
                    DB       $00, $80, $80, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
                    DB       $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $00, $00, $05, $05
                    DB       $02, $09, $18, $02, $0C, $0E, $00, $0B, $0C, $06
                    DB       $09, $16, $02, $01, $13, $04, $03, $12, $06, $01
                    DB       $0F, $FF, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $2E, $2E, $2E, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $80, $80, $80, $80, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $80, $63, $80, $80, $32, $80
                    DB       $35, $00, $00, $00, $00, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $80, $2B, $80, $80, $00
                    DB       $80, $80, $00, $80, $80, $00, $80, $00, $00, $00
                    DB       $00, $80, $80, $00, $80, $80, $00, $80, $80, $00
                    DB       $00, $00, $00, $80, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $80, $80, $00, $80, $80, $00, $80, $00
                    DB       $80, $80, $00, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $00, $80, $80, $2B, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $00, $2B, $00, $80, $00
                    DB       $80, $00, $80, $80, $00, $80, $80, $00, $80, $80
                    DB       $00, $80, $80, $00, $80, $80, $00, $00, $00, $00
                    DB       $80, $00, $00, $00, $00, $00, $80, $00, $80, $00
                    DB       $80, $00, $80, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $80, $80, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $00, $80, $2B, $80, $00, $80, $00
                    DB       $80, $00, $80, $00, $80, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $80, $00, $80, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $80, $00, $80, $80, $80, $00
                    DB       $00, $00, $00, $00, $00, $00, $80, $00, $80, $80
                    DB       $00, $00, $00, $00, $80, $80, $00, $80, $80, $80
                    DB       $80, $80, $00, $80, $80, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $00
                    DB       $80, $80, $00, $80, $80, $00, $80, $80, $00, $80
                    DB       $2E, $2E, $2E, $80, $00, $2B, $80, $80, $80, $00
                    DB       $80, $37, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $80, $80, $00, $80, $80
                    DB       $00, $80, $2E, $2E, $80, $80, $00, $80, $80, $80
                    DB       $80, $00, $80, $80, $00, $80, $00, $80, $80, $80
                    DB       $80, $00, $80, $80, $80, $80, $00, $00, $00, $00
                    DB       $80, $80, $00, $80, $2E, $2E, $80, $2B, $00, $00
                    DB       $00, $00, $00, $00, $2B, $80, $00, $80, $00, $00
                    DB       $00, $00, $00, $00, $80, $80, $80, $80, $80, $80
                    DB       $80, $00, $80, $80, $00, $80, $2E, $2E, $80, $80
                    DB       $00, $80, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $80, $00, $80, $80, $80, $80, $64, $80, $34
                    DB       $80, $62, $80, $00, $80, $80, $00, $80, $2E, $2E
                    DB       $2E, $80, $00, $2B, $80, $80, $80, $00, $80, $31
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
                    DB       $80, $80, $80, $80, $00, $80, $80, $80, $80, $00
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $33, $80, $80, $00, $00, $00, $00, $00, $00, $00
                    DB       $80, $00, $80, $80, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $80, $00, $80, $80, $80, $00, $80, $80
                    DB       $00, $80, $80, $80, $80, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $00, $80, $2B, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $00, $00, $00, $00, $00
                    DB       $36, $80, $00, $80, $2E, $2E, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $00, $00, $00, $00, $00
                    DB       $80, $00, $00, $00, $00, $00, $80, $00, $80, $80
                    DB       $80, $00, $80, $80, $00, $80, $80, $80, $80, $00
                    DB       $00, $00, $2B, $00, $00, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $00, $80, $80, $80, $00, $80, $00
                    DB       $80, $80, $80, $00, $80, $80, $00, $80, $38, $80
                    DB       $80, $00, $80, $80, $00, $80, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $80, $00, $80, $2B, $00, $00
                    DB       $80, $00, $80, $80, $80, $00, $00, $00, $00, $00
                    DB       $00, $80, $80, $00, $80, $80, $00, $80, $80, $00
                    DB       $80, $80, $2B, $80, $80, $00, $80, $00, $80, $00
                    DB       $80, $00, $80, $00, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $00, $80, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $80, $80, $80, $80, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $80, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $65, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $00, $80, $80, $66
                    DB       $80, $80, $6E, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $80, $00, $80, $80, $80
                    DB       $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $80, $80, $00, $00, $00, $00, $00, $80, $00
                    DB       $00, $80, $80, $00, $80, $00, $00, $00, $00, $00
                    DB       $00, $80, $80, $61, $80, $80, $80, $00, $80, $80
                    DB       $80, $00, $80, $80, $80, $80, $80, $80, $80, $00
                    DB       $80, $00, $00, $80, $80, $00, $00, $00, $80, $80
                    DB       $80, $80, $00, $80, $80, $80, $80, $00, $00, $00
                    DB       $80, $80, $69, $00, $6D, $80, $80, $80, $80, $80
                    DB       $80, $00, $80, $80, $00, $00, $80, $00, $80, $00
                    DB       $80, $80, $80, $80, $00, $00, $00, $00, $80, $00
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $80, $00
                    DB       $00, $00, $00, $00, $80, $80, $00, $00, $80, $00
                    DB       $80, $00, $00, $00, $00, $00, $00, $80, $80, $00
                    DB       $00, $00, $80, $00, $80, $80, $6C, $00, $68, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $80, $80
                    DB       $80, $00, $80, $80, $80, $00, $80, $80, $80, $00
                    DB       $80, $80, $80, $6A, $80, $80, $39, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $80, $80
                    DB       $67, $00, $6B, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $00, $04, $02, $0A
                    DB       $00, $14, $0A, $02, $0B, $03, $00, $06, $0B, $04
                    DB       $10, $0B, $00, $04, $04, $04, $12, $04, $06, $0B
                    DB       $0A, $00, $04, $10, $04, $13, $11, $06, $09, $05
                    DB       $06, $0D, $05, $FF, $02, $0D, $0B, $04, $01, $18
                    DB       $00, $0E, $1E, $04, $0C, $17, $02, $01, $1A, $06
                    DB       $10, $1A, $02, $09, $0B, $04, $12, $1E, $02, $1E
                    DB       $04, $00, $19, $15, $04, $0C, $19, $04, $01, $15
                    DB       $04, $0C, $15, $04, $16, $0B, $04, $17, $01, $02
                    DB       $1E, $1C, $06, $1C, $1E, $02, $1A, $1C, $00, $1E
                    DB       $01, $06, $1E, $1E, $02, $1C, $1C, $06, $1A, $1E
                    DB       $02, $17, $04, $FF, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $80, $80, $00, $00, $31, $80, $80, $80, $36, $00
                    DB       $38, $80, $80, $80, $62, $00, $00, $80, $80, $00
                    DB       $80, $80, $37, $80, $80, $00, $80, $80, $61, $80
                    DB       $80, $00, $80, $80, $00, $80, $00, $80, $80, $80
                    DB       $00, $80, $00, $80, $80, $80, $00, $80, $00, $80
                    DB       $80, $00, $80, $80, $80, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $80, $61, $00, $00, $00
                    DB       $00, $00, $00, $80, $00, $00, $00, $00, $00, $00
                    DB       $34, $80, $80, $00, $31, $80, $00, $00, $00, $00
                    DB       $00, $00, $00, $80, $32, $00, $80, $80, $80, $80
                    DB       $00, $80, $00, $80, $00, $80, $00, $80, $00, $80
                    DB       $00, $80, $80, $80, $80, $00, $80, $80, $00, $80
                    DB       $80, $00, $80, $80, $00, $80, $80, $00, $80, $80
                    DB       $80, $80, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $80, $80, $00, $80, $80
                    DB       $00, $80, $00, $36, $00, $80, $00, $80, $80, $00
                    DB       $80, $80, $80, $80, $00, $80, $00, $80, $00, $80
                    DB       $00, $80, $00, $80, $00, $80, $00, $80, $80, $00
                    DB       $00, $00, $00, $00, $63, $80, $39, $00, $00, $00
                    DB       $00, $00, $80, $80, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
                    DB       $80, $00, $80, $80, $00, $80, $00, $33, $00, $80
                    DB       $00, $80, $80, $00, $80, $80, $00, $80, $00, $80
                    DB       $00, $80, $00, $80, $00, $80, $00, $80, $00, $80
                    DB       $80, $80, $80, $00, $80, $80, $00, $80, $80, $00
                    DB       $80, $80, $00, $80, $80, $00, $80, $80, $00, $00
                    DB       $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $80, $80, $80, $80, $00, $34, $80, $00, $00
                    DB       $00, $00, $00, $00, $00, $80, $35, $00, $80, $80
                    DB       $80, $80, $00, $80, $00, $80, $00, $80, $00, $80
                    DB       $00, $80, $00, $80, $80, $80, $80, $00, $80, $80
                    DB       $80, $80, $80, $00, $80, $80, $80, $80, $80, $00
                    DB       $80, $80, $33, $00, $00, $00, $00, $00, $00, $80
                    DB       $00, $00, $00, $00, $00, $00, $39, $80, $80, $00
                    DB       $80, $80, $38, $80, $80, $00, $80, $80, $62, $80
                    DB       $80, $00, $80, $80, $00, $80, $00, $80, $80, $80
                    DB       $00, $80, $00, $80, $80, $80, $00, $80, $00, $80
                    DB       $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    DB       $00, $00, $00, $00, $80, $80, $00, $00, $63, $80
                    DB       $80, $80, $37, $00, $35, $80, $80, $80, $32, $00
                    DB       $00, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $00, $06, $04, $02, $02, $04
                    DB       $0C, $04, $08, $07, $06, $0A, $02, $02, $0A, $0C
                    DB       $00, $06, $07, $00, $02, $04, $04, $0C, $04, $02
                    DB       $07, $08, $00, $02, $0A, $04, $0C, $0A, $06, $07
                    DB       $06, $FF, $04, $01, $12, $00, $0D, $1C, $02, $0B
                    DB       $10, $06, $03, $1E, $00, $0D, $18, $04, $01, $16
                    DB       $00, $0D, $16, $04, $01, $18, $06, $0B, $1E, $02
                    DB       $03, $10, $04, $01, $1C, $00, $0D, $12, $FF, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $00, $00, $00, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $00, $80, $00, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $00, $00, $00, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
                    DB       $80, $80, $80, $80, $80, $80, $80, $80, $80, $00
                    DB       $02, $01, $01, $06, $03, $03, $04, $01, $03, $00
                    DB       $03, $01, $02, $01, $02, $06, $03, $02, $04, $02
                    DB       $03, $00, $02, $01, $FF
                    direct $D0
serial_output_ff:
                    lda      #$D0               ; write $FF to joystickport, enable output on joystick port
                    tfr      a,dp               ; setup DP
                    lda      #$0E               ; A= $E reg 14 of PSG,
                    sta      <VIA_port_a        ; Via Port A = 14
                    ldd      #$9981
                    sta      <VIA_port_b        ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    lda      #$FF               ; Write $FF to joystick port(s) / PSG Port A
; -)
                    sta      <VIA_port_a        ; Fill via port A with $ff to be written to PSG port A to be written to Jostick buttons...
                    lda      #$91
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    lda      #$07               ; 
                    sta      <VIA_port_a        ; prepare latch of Reg 7 to PSG
                    lda      #$99
                    sta      <VIA_port_b        ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    lda      #$FF               ; Write $FF to Reg 7 of PSG -> enabled output via port A of PSG
; -)
                    sta      <VIA_port_a        ; Fill via port A with $ff to be written to PSG port A to be written to Jostick buttons...
                    lda      #$91
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    rts                         ; done
; send value in A to joyport serial communication
serial_write_A:
                    ldb      #$04               ; number of "double bits" to send (4*2 = 8 -> complete byte), starting with least significant bit
                    pshs     dp,b,a             ; remember current DP, "$4" and A (push DP first, than b than a, s is pointing to the pushed copy of A)
                    lda      #$D0               ; setup DP
                    tfr      a,dp
; prepare output to joystic, latch 14 to psg...
                    ldd      #$0E99             ; A= $E (reg 14, port A of PSG), B = $99
                    sta      <VIA_port_a        ; Via Port A = 14
                    stb      <VIA_port_b        ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address)
                    ldd      #$1881             ; B = $81 mask for BDIR/BC inactive, A=$18 0001 1000 ->SHIFT mode = 110 - SHIFT out under control of system clock
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
; disable ramping, while we use T1 for timeout checking...
                    sta      <VIA_aux_cntl      ; SHIFT mode = 110 - SHIFT out under control of system clock, T1 does not control RAMP
; -), for the complete communication
                    ldd      #$FFFF             ; Realy long timer
                    std      <VIA_t1_cnt_lo     ; to T1
writeNextDoubleBit:
                    lda      #$EF               ; 1110 1111 port A default mask for bit set (bit 5), bit 4 = 0 indicates start of 2bit communication
                    lsr      ,s                 ; test lowest bit of (pushed copy) of A
                    bcs      outputBitMaskToPSG_start ; if the bit was set -> branch
                    lda      #$CF               ; 1100 1111 port A default mask for bit clear (bit 5), bit 4 = 0 indicates start of 2bit communication
outputBitMaskToPSG_start:
                    sta      <VIA_port_a        ; output current mask to psg 14
                    ldd      #$9181
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    clr      <VIA_DDR_a         ; set via port A to input
continueReadTry0:
                    ldd      #$8981             ; A = $89, B = $81
                    sta      <VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      <VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    bita     #$40               ; check if we received a bit (in bit 6)
                    beq      bit0SendSuccess    ; waiting to receive a 0 in bit 6 as acknowledgement of communication
                    lda      #$40               ; test for T1 timeout interrupt flag
                    bita     <VIA_int_flags     ; check
                    beq      continueReadTry0
                    bra      linkTimeout
bit0SendSuccess:
                    com      <VIA_DDR_a         ; switch Via port A to output
                    lda      #$FF               ; 1111 1111 port A default mask for bit set (bit 5), bit 4 = 1 indicates continue of 2bit communication
                    lsr      ,s
                    bcs      outputBitMaskToPSG_cont
                    lda      #$DF               ; 1101 1111 port A default mask for bit clear (bit 5), bit 4 = 1 indicates continue of 2bit communication
outputBitMaskToPSG_cont:
                    sta      <VIA_port_a        ; output current mask to psg 14
                    ldd      #$9181
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    clr      <VIA_DDR_a         ; set via port A to input
continueReadTryX:
                    ldd      #$8981             ; A = $89, B = $81
                    sta      <VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      <VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    bita     #$40               ; check if we received a bit (in bit 6)
                    bne      bitXSendSuccess    ; waiting to receive a 0 in bit 6 as acknowledgement of communication
                    lda      #$40               ; test for T1 timeout interrupt flag
                    bita     <VIA_int_flags     ; check
                    beq      continueReadTryX
                    bra      linkTimeout
bitXSendSuccess:
                    com      <VIA_DDR_a         ; switch Via port A to output
                    dec      <<$01,s            ; counter (4) reached 0?
                    bne      writeNextDoubleBit ; if not jump and do next
                    lda      #$FF               ; A = FF, 1111 1111
                    sta      <VIA_port_a        ; send a "full" byte (bit 4,5,6 set) as end of communication
                    ldd      #$9181
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    ldd      #$0200             ; A= 02, B = 0
                    std      <VIA_t1_cnt_lo     ; store a mini T1 timer
                    lda      #$98               ; restore T1, ramp on...1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock
                    sta      <VIA_aux_cntl
                    puls     a,b,dp,pc          ; remove used values, reset dp and return to caller
linkTimeout:
                    ldd      #$FF91             ; A = FF, 1111 1111
                    direct $FF
                    sta      <$03               ; Via port A to output
                    sta      <$01               ; send a "full" byte (bit 4,5,6 set) as end of communication
                    stb      <$00               ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    ldd      #$9881
                    stb      <$00               ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    sta      <$0B               ; restore T1, ramp on...1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock
                    puls     a,b,dp,pc          ; remove used values, reset dp and return to caller
serial_read_A_withTest:
                    lda      #$0E               ; A= $E (reg 14 of PSG)
                    sta      >VIA_port_a        ; to VIA port A
                    ldd      #$9981             ; A= $99, B = $81
                    sta      >VIA_port_b        ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address)
                    stb      >VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    clr      >VIA_DDR_a         ; port A as input
                    ldd      #$8981             ; A = $89, B = $81
                    sta      >VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      >VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      >VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    ldb      #$FF               ; B = $FF
                    stb      >VIA_DDR_a         ; set via port A as output
                    bita     #$10               ; test bit 4 of received data
                    beq      serial_read_A      ; if bit is 0 than a commnication request is issued from the other side
                    rts                         ; if not - return
                    direct $D0
serial_read_A:
                    ldb      #$04               ; load 4 double bits
                    pshs     dp,b,a             ; remember current DP, "$4" and A (push DP first, than b than a, s is pointing to the pushed copy of A)
                    lda      #$D0               ; 
                    tfr      a,dp               ; setup DP to d0
                    ldd      #$0E99             ; A= $E (reg 14 of PSG), B = $99
                    sta      <VIA_port_a        ; A to via port A, prepare latch of PSG reg 14
                    stb      <VIA_port_b        ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address)
                    ldd      #$1881             ; A= $18 (for Aux), and $81 for psg inactive
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
; disable ramping, while we use T1 for timeout checking...
                    sta      <VIA_aux_cntl      ; SHIFT mode = 110 - SHIFT out under control of system clock, T1 does not control RAMP
                    ldd      #$FFFF             ; set a huge timer for the complete commuication timeout
                    std      <VIA_t1_cnt_lo     ; store to timer lo and hi timer 1
readNextDoubleBit:
                    clr      <VIA_DDR_a         ; set via port A as input (clear DDRA)
tryReadingBitOne:
                    ldd      #$8981             ; A= 89, B 81
                    sta      <VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      <VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    bita     #$10               ; test bit 4, for two bit commication correctness - it must be 0, for the first of the 2 bit commucation
                    beq      bitOneComAck       ; if that is so - branch
                    lda      #$40               ; test bit for T1
                    bita     <VIA_int_flags     ; otherwise test for T1 timeout
                    beq      tryReadingBitOne   ; if not timeout - read again... perhaps with more luck
                    bra      linkTimeout        ; otherwise - jump to timeout
bitOneComAck:
                    ldd      #$8981             ; A= 89, B =81
                    sta      <VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      <VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    com      <VIA_DDR_a         ; set port A as output (all $ff now)
                    asla                        ; communication "data" bit is bit 5
                    asla                        ; doing 3 asls puts the data bit to carry
                    asla     
                    ror      ,s                 ; and a ror pushes the bit into the hi bit of our return data, this will be done 8 times so in the end the first received bit will be in place of the least significant bit
                    lda      #$BF               ; A = $BF, 1011 1111, load a with our "acceptance" bit cleared (bit 6)
                    sta      <VIA_port_a        ; store it to Via port A which will send it to port A of PSG -> to joystick port to other veccy
                    ldd      #$9181             ; A = $91, B = 81
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    clr      <VIA_DDR_a         ; prepare next read, and set via port A to input again
tryReadingBitTwo:
                    ldd      #$8981             ; A= 89, B =81
                    sta      <VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      <VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    bita     #$10               ; test bit 4, for two bit commication correctness - this time it must be 1 (second bit of 2 bit communication)
                    bne      bitTwoComAck       ; if that is so - branch
                    lda      #$40               ; test bit for T1
                    bita     <VIA_int_flags     ; otherwise test for T1 timeout
                    beq      tryReadingBitTwo   ; if not timeout - read again... perhaps with more luck
                    jmp      >linkTimeout       ; otherwise - jump to timeout
bitTwoComAck:
                    ldd      #$8981             ; A= 89, B 81
                    sta      <VIA_port_b        ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
; -)
                    lda      <VIA_port_a        ; get value from buttons -> PSG port A -> Via port A -> to register A
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    com      <VIA_DDR_a         ; set port A as output (all $ff now)
                    asla                        ; doing 3 asls puts the data bit to carry
                    asla     
                    asla     
                    ror      ,s                 ; and a ror pushes the bit into the hi bit of our return data, and all other bits one to the right
                    lda      #$FF               ; A = $FF, 1111 1111, load a with our "acceptance" bit set (bit 6)
                    sta      <VIA_port_a        ; store it to Via port A which will send it to port A of PSG -> to joystick port to other veccy
                    ldd      #$9181             ; A = $91, B = 81
                    sta      <VIA_port_b        ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG)
                    stb      <VIA_port_b        ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive)
                    direct $FF
                    dec      <<$01,s            ; do the above 4 times (2bits *2 = 8bit = 1 byte)
                    bne      readNextDoubleBit  ; if not done - read next to bits
                    ldd      #$0200             ; A= 02, B = 0
                    std      <$04               ; store a mini T1 timer
                    lda      #$98               ; 
                    sta      <$0B               ; restore T1, ramp on...1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock
                    puls     a,b,dp,pc          ; remove used values, reset dp and return to caller, result is "loaded" to reg A, B = 0!
_23D2:
                    ldd      #$23E0
                    std      <$07
                    lda      #$01
                    sta      <$83
                    sta      <$84
                    sta      <$85
                    rts      
                    direct $C8
                    lda      #$C8
                    tfr      a,dp
                    ldx      <jumper2
                    cmpx     #$297A
                    beq      _23F7
_23EB:
                    clr      <JoyStatePort0OtherSide
                    rts      
_23EE:
                    lda      <AlexRCCounterLo
                    bne      _23EB
                    lda      #$01
                    sta      <JoyStatePort0OtherSide
                    rts      
_23F7:
                    lda      >_C88D
                    cmpa     #$06
                    beq      _23EE
                    jsr      >_419B
                    bsr      _2471
                    ldx      <Vec_Prev_Btns
                    ldb      >_C891
                    abx      
                    lda      >_C88F
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      <JoyStatePort0OtherSide
                    anda     #$F0
                    sta      <JoyStatePort0OtherSide
                    dec      <$83
                    bne      _2432
                    jsr      >_00C3
                    anda     #$1F
                    adda     #$10
                    sta      <$83
                    lda      <JoyStatePort0OtherSide
                    anda     #$CF
                    sta      <JoyStatePort0OtherSide
                    lda      >_C88E
                    ldu      #$24C9
                    jsr      [a,u]
_2432:
                    dec      <$84
                    bne      _2454
                    jsr      >_00C3
                    anda     #$0F
                    adda     #$0C
                    sta      <$84
                    lda      <JoyStatePort0OtherSide
                    anda     #$3F
                    sta      <JoyStatePort0OtherSide
                    jsr      >_00C3
                    bita     #$01
                    bne      _2454
                    lda      >_C88E
                    ldu      #$25FD
                    jsr      [a,u]
_2454:
                    dec      <$85
                    bne      _2470
                    jsr      >_00C3
                    direct $FF
                    anda     #$07
                    adda     #$06
                    sta      <$85
                    lda      >_C886
                    cmpa     #$00
_2466:
                    bne      _2470
                    lda      >_C88E
                    ldu      #$2659
                    jsr      [a,u]
_2470:
                    rts      
_2471:
                    ldy      #$C886
                    lda      #$FF
                    sta      <$02
                    lda      >_C886
                    cmpa     #$00
                    bne      _248F
                    lda      >_C8F3
                    suba     >_C8EB
                    cmpa     #$FE
                    ble      _248F
                    ldx      #$C886
                    bsr      _24A4
_248F:
                    ldx      #$C8CC
                    bsr      _24A4
                    ldx      #$C8D3
                    bsr      _24A4
                    ldx      #$C8DA
_249C:
                    bsr      _24A4
                    ldx      #$C8E1
                    bsr      _24A4
                    rts      
_24A4:
                    lda      ,x
                    bmi      _24C8
                    lda      >_C891
                    suba     <<$04,x
                    bpl      _24B0
                    nega     
_24B0:
                    sta      <$03
                    lda      >_C88F
                    suba     <<$02,x
                    bpl      _24BA
                    nega     
_24BA:
                    cmpa     <$03
                    bcc      _24C0
                    lda      <$03
_24C0:
                    cmpa     <$02
                    bcc      _24C8
                    sta      <$02
                    leay     ,x
_24C8:
                    rts      
                    DB       $24, $D1, $25, $1D, $25, $67, $25, $B3
                    lda      >_C891
                    cmpa     <<$04,y
                    bcs      _24FB
                    bhi      _250C
                    lda      >_C88F
                    cmpa     <<$02,y
                    beq      _24EF
                    bcs      _24FB
                    lda      <-$20,x
                    bmi      _250C
_24E8:
                    lda      <$06
_24EA:
                    ora      #$10
                    sta      <$06
                    rts      
_24EF:
                    lda      <$20,x
                    bmi      _250C
                    lda      <$06
                    ora      #$20
                    sta      <$06
                    rts      
_24FB:
                    lda      <<$01,x
                    bpl      _2515
                    lda      <-$20,x
                    bpl      _24E8
_2504:
                    lda      <$06
                    ora      #$02
                    sta      <$06
                    bra      _24E8
_250C:
                    lda      <<-$01,x
                    bpl      _2504
                    lda      <-$20,x
                    bpl      _24E8
_2515:
                    lda      <$06
                    ora      #$08
                    sta      <$06
                    bra      _24E8
                    lda      >_C88F
                    cmpa     <<$02,y
                    bcs      _2556
                    bhi      _2545
                    lda      >_C891
                    cmpa     <<$04,y
                    beq      _253A
                    bhi      _2545
                    lda      <<$01,x
                    bmi      _2556
_2533:
                    lda      <$06
                    ora      #$10
                    sta      <$06
                    rts      
_253A:
                    lda      <<-$01,x
                    bmi      _2556
                    lda      <$06
                    ora      #$20
                    sta      <$06
                    rts      
_2545:
                    lda      <-$20,x
                    bpl      _255F
                    lda      <<$01,x
                    bpl      _2533
_254E:
                    lda      <$06
                    ora      #$08
                    sta      <$06
                    bra      _2533
_2556:
                    lda      <$20,x
                    bpl      _254E
                    lda      <<$01,x
                    bpl      _2533
_255F:
                    lda      <$06
                    ora      #$02
                    sta      <$06
                    bra      _2533
                    lda      >_C891
                    cmpa     <<$04,y
                    bcs      _2591
                    bhi      _25A2
                    lda      >_C88F
                    cmpa     <<$02,y
                    beq      _2585
                    bhi      _25A2
                    lda      <$20,x
                    bmi      _2591
_257E:
                    lda      <$06
                    ora      #$10
                    sta      <$06
                    rts      
_2585:
                    lda      <-$20,x
                    bmi      _2591
                    lda      <$06
                    ora      #$20
                    sta      <$06
                    rts      
_2591:
                    lda      <<$01,x
                    bpl      _25AB
                    lda      <$20,x
                    bpl      _257E
_259A:
                    lda      <$06
                    ora      #$08
                    sta      <$06
                    bra      _257E
_25A2:
                    lda      <<-$01,x
                    bpl      _259A
                    lda      <$20,x
                    bpl      _257E
_25AB:
                    lda      <$06
                    ora      #$02
                    sta      <$06
                    bra      _257E
                    lda      >_C88F
                    cmpa     <<$02,y
                    bcs      _25EC
                    bhi      _25DB
                    lda      >_C891
                    cmpa     <<$04,y
                    beq      _25D0
                    bcs      _25EC
                    lda      <<-$01,x
                    bmi      _25DB
_25C9:
                    lda      <$06
                    ora      #$10
                    sta      <$06
                    rts      
_25D0:
                    lda      <<$01,x
                    bmi      _25DB
                    lda      <$06
                    ora      #$20
                    sta      <$06
                    rts      
_25DB:
                    lda      <-$20,x
                    bpl      _25F5
                    lda      <<-$01,x
                    bpl      _25C9
_25E4:
                    lda      <$06
                    ora      #$02
                    sta      <$06
                    bra      _25C9
_25EC:
                    lda      <$20,x
                    bpl      _25E4
                    lda      <<-$01,x
                    bpl      _25C9
_25F5:
                    lda      <$06
                    ora      #$08
                    sta      <$06
                    bra      _25C9
                    bne      _2604
                    DB       $26, $1A, $26, $2F, $26, $44
                    lda      >_C892
                    cmpa     <<$05,y
                    bcs      _2613
                    lda      <$06
                    ora      #$40
                    sta      <$06
                    rts      
_2613:
                    lda      <$06
                    ora      #$80
                    sta      <$06
                    rts      
                    lda      >_C890
                    cmpa     <<$03,y
                    bcs      _2628
                    lda      <$06
                    ora      #$40
                    sta      <$06
                    rts      
_2628:
                    lda      <$06
                    ora      #$80
                    sta      <$06
                    rts      
                    lda      >_C892
                    cmpa     <<$05,y
                    bhi      _263D
                    lda      <$06
                    ora      #$40
                    sta      <$06
                    rts      
_263D:
                    lda      <$06
                    ora      #$80
                    sta      <$06
                    rts      
                    lda      >_C890
                    cmpa     <<$03,y
                    bhi      _2652
                    lda      <$06
                    ora      #$40
                    sta      <$06
                    rts      
_2652:
                    lda      <$06
                    ora      #$80
                    sta      <$06
                    rts      
                    bne      _26BC
                    bne      _26CF
                    DB       $26, $83, $26, $94
                    lda      >_C891
                    cmpa     >_C88A
                    bne      _2671
                    lda      >_C88F
                    cmpa     >_C888
                    bcc      _26A5
_2671:
                    rts      
                    lda      >_C88F
                    cmpa     >_C888
                    bne      _2682
                    lda      >_C891
                    cmpa     >_C88A
                    bls      _26A5
_2682:
                    rts      
                    lda      >_C891
                    cmpa     >_C88A
                    bne      _2693
                    lda      >_C88F
                    cmpa     >_C888
                    bls      _26A5
_2693:
                    rts      
                    lda      >_C88F
                    cmpa     >_C888
                    bne      _26A4
                    lda      >_C891
                    cmpa     >_C88A
                    bhi      _26A5
_26A4:
                    rts      
                    direct $D0
_26A5:
                    lda      >_C8F5
                    bne      _26B1
                    lda      <VIA_t1_lch_lo
                    ora      #$04
                    sta      <VIA_t1_lch_lo
                    rts      
_26B1:
                    lda      <VIA_t1_lch_lo
                    ora      #$01
                    sta      <VIA_t1_lch_lo
                    rts      
;  second line comment
cartrigde_start:
                    pshs     y,x                ; some comment
                    direct $C8
                    sta      <SyncData4         ; a=0, dp = $c8
_26BC:
                    stb      <SyncData5         ; b=3
; Write second
; Third line
                    jsr      >init_C838_ff      ; Cartridge initialization is done in this method
                    jsr      >init_c83b_ff
                    direct $FF
                    jsr      >init_c82b_ff
                    jsr      >init_c8f8_to_ca58
                    ldu      #$07B6
                    jsr      >_0769
                    jsr      >serial_output_ff
                    bsr      init_jumper_and_co
main_loop:
                    lda      #$C8
                    tfr      a,dp
                    jsr      >_00C3
                    jsr      >readJoyPort0
                    jsr      [>jumper1]
                    jsr      >AlexWaitRecal
                    jsr      >writeYMRegListToPSG
                    lda      #$C8
                    tfr      a,dp
                    jsr      >_445D
m:
                    jsr      [>jumper2]
                    bra      main_loop
                    direct $C8
init_jumper_and_co:
                    lda      #$C8
                    tfr      a,dp
                    ldd      #dummyJumper       ; 285c is a dummy jumper (only a RTS)
                    std      <jumper1
                    ldd      #jumper2_A         ; jumper2_A
                    std      <jumper2
                    lda      #$FF
                    sta      <$E8
                    sta      <$F0
                    ldd      #$C886
                    std      <Vec_Button_2_1
                    direct $FF
                    ldd      #$C8E8
                    std      <$18
                    ldd      #$C88D
                    std      <$1A
                    ldd      #$C8F0
                    std      <$1C
                    rts      
jumper2_A:
                    jsr      >serial_read_A_withTest ; read one serial byte (with connection test)
                    cmpd     #$4D00             ; if = $4d -> jump
                    lbeq     sync7ByteSerialRead
                    jsr      >printBerzerkArenaBitmap
                    ldu      #copyrightString_isyx
                    jsr      >printString_isyx
                    lda      >AlexRCCounterLo
                    bita     #$20               ; do the intensity cycle for game selection type
                    bne      noReverseIntensity
                    coma     
noReverseIntensity:
                    anda     #$1F
                    adda     #$30
                    ldb      #$28               ; tex site of menu text
                    std      >textIntensity
                    jsr      >printString_yx    ; U is still setup from copyright
; -)
                    jsr      >printString_yx    ; U keeps going to be set up right
                    lda      #$C8
                    tfr      a,dp               ; setup DP
                    direct $C8
                    lda      <$E9
                    bita     #$02
                    direct $FF
                    bne      linkGame
                    bita     #$01
                    lbne     soloGame
                    rts      
                    direct $C8
linkGame:
                    lda      #$C8
                    tfr      a,dp               ; dp = c8
                    lda      #$4D               ; send 4d as a sign that we are "primary" than we send first! 0100 1101
                    jsr      >serial_write_A    ; write it to putput
                    tstb                        ; only if 4 double byte counter is zero, there was a success
                    lbne     linkFailed_InitJumper ; branch if not successfull
                    jsr      >serial_read_A     ; Wait for other side to ackowledge our priority
                    cmpd     #$7300             ; A= $73 - 0111 0011 Jup, we areking of the hill (and B = 00)
                    lbne     linkFailed_InitJumper
                    lda      <Vec_Snd_Shadow    ; 
                    jsr      >serial_write_A    ; Sync WR Timer Hi
                    tstb     
                    lbne     linkFailed_InitJumper
                    lda      <AlexRCCounterLo
                    jsr      >serial_write_A    ; Sync WR Timer Lo
                    tstb     
                    lbne     linkFailed_InitJumper
                    lda      <SyncData1
                    jsr      >serial_write_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    lda      <Vec_Rise_Index
                    jsr      >serial_write_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    lda      <SyncData3
                    jsr      >serial_write_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    lda      <SyncData4
                    jsr      >serial_write_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    lda      <SyncData5
                    jsr      >serial_write_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    ldd      #linkPort0ExchangePrimary
                    std      <jumper1
                    ldd      #game_jumper2
                    std      <jumper2
                    lda      #$FF
                    sta      <$E8
                    sta      <$F0
                    ldd      #$C886
                    std      <Vec_Button_2_1
                    ldd      #$C8E8
                    std      <Vec_Button_2_3
                    ldd      #$C88D
                    std      <Vec_Joy_Resltn
                    ldd      #$C8F0
                    std      <Vec_Joy_1_Y
                    jmp      >guessing_playerStartPos
sync7ByteSerialRead:
                    lda      #$C8
                    tfr      a,dp               ; setup DP
                    lda      #$73               ; acknowledge we are secondary
                    jsr      >serial_write_A    ; send that
                    tstb     
                    lbne     linkFailed_InitJumper
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <Vec_Snd_Shadow    ; Sync WR Timer Hi
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <AlexRCCounterLo   ; Sync WR Timer Lo
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <SyncData1
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <Vec_Rise_Index
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <SyncData3
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <SyncData4
                    jsr      >serial_read_A
                    tstb     
                    lbne     linkFailed_InitJumper
                    sta      <SyncData5
                    ldd      #linkPort0ExchangeSecondary
                    std      <jumper1
                    ldd      #game_jumper2
                    std      <jumper2
                    lda      #$FF
                    sta      <$E8
                    sta      <$F0
                    ldd      #$C88D
                    std      <Vec_Button_2_1
                    ldd      #$C8F0
                    std      <Vec_Button_2_3
                    ldd      #$C886
                    direct $FF
                    std      <$1A
                    ldd      #$C8E8
                    std      <$1C
                    bra      guessing_playerStartPos
                    nop      
dummyJumper:
                    rts      
linkPort0ExchangePrimary:
                    lda      >JoyStatePort0ThisSide
                    jsr      >serial_write_A
                    tstb     
                    bne      linkFailed_InitJumper
                    jsr      >serial_read_A
                    tstb     
                    bne      linkFailed_InitJumper
                    sta      >JoyStatePort0OtherSide
                    rts      
linkPort0ExchangeSecondary:
                    jsr      >serial_read_A
                    tstb     
                    bne      linkFailed_InitJumper
                    sta      >JoyStatePort0OtherSide
                    lda      >JoyStatePort0ThisSide
                    jsr      >serial_write_A
_287F:
                    tstb     
                    bne      linkFailed_InitJumper
                    rts      
linkFailed_InitJumper:
                    ldd      #dummyJumper
                    std      >jumper1
                    ldd      #printNoLinkJumper
                    std      >jumper2
                    rts      
printNoLinkJumper:
                    ldu      #linkFailedStringStruct
                    jsr      >printString_isyx
                    direct $C8
                    lda      #$C8
                    tfr      a,dp
                    ldu      <Vec_Button_2_3
                    lda      <<$01,u
                    bita     #$01
                    lbne     init_jumper_and_co
                    rts      
soloGame:
                    lda      #$C8
                    tfr      a,dp
                    jsr      >_23D2
                    ldd      #game_jumper2
                    std      <jumper2
                    ldd      #$C886
                    std      <Vec_Button_2_1
                    ldd      #$C8E8
                    std      <Vec_Button_2_3
                    ldd      #$C88D
                    std      <Vec_Joy_Resltn
                    ldd      #$C8F0
                    std      <Vec_Joy_1_Y
                    clr      <JoyStatePort0ThisSide
                    bra      guessing_playerStartPos
                    nop      
guessing_playerStartPos:
                    lda      <SyncData4
_28CC:
                    ldx      #some_table
                    direct $FF
                    ldb      #$06
                    mul      
                    abx      
                    stx      <$0E
                    rts      
game_jumper2:
                    bsr      _2939
_28D8:
                    lda      #$C8
                    tfr      a,dp
                    lda      <$E9
                    ora      <$F1
                    bita     #$01
                    lbne     _29EA
                    bita     #$40
                    beq      _28FA
                    dec      <$0D
                    bpl      _28F2
                    lda      #$05
                    sta      <$0D
_28F2:
                    bsr      guessing_playerStartPos
                    ldu      #$07C5
                    jmp      >_0769
_28FA:
                    bita     #$80
                    beq      _2910
                    inc      <$0D
                    lda      <$0D
                    cmpa     #$06
                    bne      _2908
                    clr      <$0D
_2908:
                    bsr      guessing_playerStartPos
                    ldu      #$07C5
                    jmp      >_0769
_2910:
                    bita     #$10
                    beq      _2924
                    lda      <$0C
                    cmpa     #$09
                    beq      _2924
                    asla     
                    deca     
                    sta      <$0C
                    ldu      #$07C5
                    jmp      >_0769
_2924:
                    bita     #$20
                    beq      _2938
                    lda      <$0C
                    cmpa     #$03
                    beq      _2938
                    lsra     
                    inca     
                    sta      <$0C
                    ldu      #$07C5
                    jmp      >_0769
_2938:
                    rts      
_2939:
                    lda      >AlexRCCounterLo
                    bita     #$20
                    bne      _2941
                    coma     
_2941:
                    anda     #$1F
                    adda     #$30
                    ldb      #$30
                    std      >textIntensity
                    ldu      #$45B1
                    jsr      >printString_yx
                    jsr      >_1557
                    lda      #$3B
                    sta      >textIntensity
                    ldu      [>$C80E]
                    jsr      >printString_yx
                    lda      >SyncData5
                    cmpa     #$05
                    bcs      _2974
                    beq      _296E
                    ldu      #$45EE
                    jmp      >printString_yx
_296E:
                    ldu      #$45D9
                    jmp      >printString_yx
_2974:
                    ldu      #$45C4
                    jmp      >printString_yx
                    lda      #$C8
                    tfr      a,dp
                    jsr      >_2A97
                    jsr      >_2AD3
                    jsr      >_4130
                    jsr      >_4491
                    jsr      >_34F4
                    lda      #$C8
                    tfr      a,dp
                    lda      <$0C
                    ldu      <$18
                    cmpa     <<$02,u
                    beq      _29A0
                    ldu      <$1C
                    cmpa     <<$02,u
                    beq      _29AD
                    rts      
_29A0:
                    ldd      #dummyJumper
                    std      >jumper1
                    ldd      #$29BA
                    std      >jumper2
                    rts      
_29AD:
                    ldd      #dummyJumper
                    std      >jumper1
                    ldd      #$29D2
                    std      >jumper2
                    rts      
                    jsr      >_4491
                    ldu      #$467E
                    jsr      >printString_isyx
                    lda      #$C8
                    tfr      a,dp
                    ldu      <$18
                    lda      <<$01,u
                    bita     #$01
                    lbne     init_jumper_and_co
                    rts      
                    jsr      >_4491
                    ldu      #$468B
                    jsr      >printString_isyx
                    lda      #$C8
                    tfr      a,dp
                    ldu      <$18
                    lda      <<$01,u
                    bita     #$01
                    lbne     init_jumper_and_co
                    rts      
_29EA:
                    ldd      #$297A
                    std      <$09
                    ldd      #$06
                    std      <$EA
                    std      <$F2
                    ldd      #$00
                    std      <$EC
                    std      <$F4
                    sta      <$EE
                    sta      <$F6
_2A01:
                    ldx      <$0E
                    ldd      <<$02,x
                    std      <$10
                    ldd      <<$04,x
                    std      <$12
                    std      <$14
                    clr      <$37
                    ldd      #$01F4
                    std      <$20
                    bsr      _2A31
                    lda      #$0C
                    sta      <$EF
                    sta      <$F7
                    ldy      #$C886
                    lda      #$00
                    sta      ,y
                    bsr      _2A46
                    ldy      #$C88D
                    lda      #$02
                    sta      ,y
                    bra      _2A46
                    nop      
_2A31:
                    ldy      #$C886
                    lda      #$FF
_2A37:
                    sta      ,y
                    sta      <<$02,y
                    sta      <<$04,y
                    leay     <<$07,y
                    cmpy     #$C8E8
                    bne      _2A37
                    rts      
_2A46:
                    ldx      <$14
_2A48:
                    lda      <$88
                    ldb      <$8A
                    cmpd     <<$01,x
                    beq      _2A8D
                    lda      <$8F
                    ldb      <$91
                    cmpd     <<$01,x
                    beq      _2A8D
_2A5A:
                    ldu      #$C8CC
                    lda      #$04
                    sta      <$04
_2A61:
                    lda      ,u
                    bmi      _2A6E
                    lda      <<$02,u
                    ldb      <<$04,u
                    cmpd     <<$01,x
                    beq      _2A8D
_2A6E:
                    leau     <<$07,u
                    dec      <$04
                    bne      _2A61
                    lda      ,x+
                    sta      <<$01,y
                    lda      ,x+
                    ldb      #$80
                    std      <<$02,y
                    lda      ,x+
                    std      <<$04,y
                    clr      <<$06,y
                    lda      ,x
                    bpl      _2A8A
                    ldx      <$12
_2A8A:
                    stx      <$14
                    rts      
_2A8D:
                    leax     <<$03,x
                    lda      ,x
                    bpl      _2A48
_2A93:
                    ldx      <$12
                    bra      _2A48
_2A97:
                    ldd      <$20
                    subd     #$01
                    std      <$20
                    bne      _2AB4
                    ldd      #$01F4
                    std      <$20
                    ldy      #$C8CC
                    ldb      #$04
_2AAB:
                    lda      ,y
                    bmi      _2AB5
                    leay     <<$07,y
                    decb     
                    bne      _2AAB
_2AB4:
                    rts      
_2AB5:
                    ldx      #$2AC3
                    jsr      >_00C3
                    anda     #$0F
                    lda      a,x
                    sta      ,y
                    bra      _2A46
                    orcc     #$1C
                    DB       $1E
                    bra      _2AE2
                    DB       $1C, $1E, $20, $1A
                    andcc    #$1E
                    bra      _2AEA
                    DB       $1C, $1E
                    bhi      _2A5A
                    eorb     #$1F
                    adda     #$10
                    ldx      #$C886
_2ADB:
                    lda      ,y
                    bmi      _2AE4
                    ldu      #$2AED
_2AE2:
                    jsr      [a,u]
_2AE4:
                    leay     <<$07,y
                    cmpy     #$C8E8
_2AEA:
                    bne      _2ADB
                    rts      
                    bmi      _2B00
                    bmi      _2B69
                    DB       $2D, $7D
                    blt      _2A93
                    DB       $2D, $BF, $2D, $C4
                    leay     <<$09,u
                    DB       $31, $4E
                    leau     [,--x]
                    DB       $33, $AA, $2F, $96, $2F, $9F, $2F, $96
                    DB       $2F, $D9, $30, $40, $30, $99, $30, $F2
                    leau     a,u
                    ldu      #$C8E8
                    lda      <$8C
                    lbeq     _2BD9
                    bpl      _2B2E
                    lda      #$18
                    sta      <$EE
                    lda      #$12
                    sta      <$EF
                    clr      <$8C
                    lsr      <$EB
                    lbne     _2BD9
                    bra      _2B3F
_2B2E:
                    lda      <$EB
                    anda     #$03
                    asla     
                    adda     #$04
                    sta      <$EF
                    dec      <$8C
                    dec      <$EB
                    lbne     _2BD9
_2B3F:
                    inc      <$F2
                    ldd      #$0440
                    sta      <$86
                    stb      <$8C
                    ldd      #$1600
                    std      <$94
                    ldb      #$02
                    std      <$A2
                    ldb      #$04
                    std      <$B0
                    ldb      #$06
                    std      <$BE
                    ldd      <$88
                    std      <$96
                    std      <$A4
                    std      <$B2
                    std      <$C0
                    ldd      <$8A
                    std      <$98
                    std      <$A6
_2B69:
                    std      <$B4
                    std      <$C2
                    lda      #$30
                    sta      <$9A
                    sta      <$A8
                    sta      <$B6
                    sta      <$C4
                    rts      
                    ldu      #$C8F0
                    lda      <$93
                    beq      _2BD9
                    bpl      _2B91
                    lda      #$18
                    sta      <$F6
                    lda      #$12
                    sta      <$F7
                    clr      <$93
                    lsr      <$F3
                    bne      _2BD9
                    bra      _2BA0
_2B91:
                    lda      <$F3
                    anda     #$03
                    asla     
                    adda     #$04
                    sta      <$F7
                    dec      <$93
                    dec      <$F3
                    bne      _2BD9
_2BA0:
                    inc      <$EA
                    ldd      #$0640
                    sta      <$8D
                    stb      <$93
                    ldd      #$1600
                    std      <$9B
                    ldb      #$02
                    std      <$A9
                    ldb      #$04
                    std      <$B7
                    ldb      #$06
                    std      <$C5
                    ldd      <$8F
                    std      <$9D
                    std      <$AB
                    std      <$B9
                    std      <$C7
                    ldd      <$91
                    std      <$9F
                    std      <$AD
                    std      <$BB
                    std      <$C9
                    lda      #$30
                    sta      <$A1
                    sta      <$AF
                    sta      <$BD
                    sta      <$CB
                    rts      
_2BD9:
                    lda      <<$01,u
                    bita     #$02
                    beq      _2BE9
                    lda      <<$01,y
                    suba     #$02
                    anda     #$06
                    sta      <<$01,y
                    bra      _2BF5
_2BE9:
                    bita     #$08
                    beq      _2BF5
                    lda      <<$01,y
                    adda     #$02
                    anda     #$06
                    sta      <<$01,y
_2BF5:
                    ldd      #$00
                    std      <$1E
                    lda      <<$01,y
                    ldx      #$2CD1
                    jsr      [a,x]
                    ldb      <$1E
                    lda      <<$04,u
                    beq      _2C08
                    aslb     
_2C08:
                    sex      
                    addd     <<$02,y
                    std      <$02
                    tst      <$1E
                    bmi      _2C16
                    addd     #$18
                    bra      _2C19
_2C16:
                    subd     #$18
_2C19:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    ldb      #$20
                    mul      
                    lda      d,x
                    bmi      _2C29
                    ldd      <$02
                    std      <<$02,y
_2C29:
                    ldb      <$1F
                    lda      <<$04,u
                    beq      _2C32
                    dec      <<$04,u
                    aslb     
_2C32:
                    sex      
                    addd     <<$04,y
                    std      <$02
                    tst      <$1F
                    bmi      _2C40
                    addd     #$18
                    bra      _2C43
_2C40:
                    subd     #$18
_2C43:
                    ldx      <$10
                    leax     a,x
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    lda      d,x
                    bmi      _2C54
                    ldd      <$02
                    std      <<$04,y
_2C54:
                    lda      <<$01,u
                    bita     #$04
                    bne      _2C63
                    ldb      <<$05,u
                    beq      _2C62
                    bita     #$01
                    bne      _2C71
_2C62:
                    rts      
_2C63:
                    leax     <<$0E,y
                    ldb      #$04
_2C67:
                    lda      ,x
                    bmi      _2C7A
                    leax     <<$0E,x
                    decb     
                    bne      _2C67
                    rts      
_2C71:
                    leax     <<$0E,y
                    lda      ,x
                    cmpa     #$0C
                    blt      _2C8F
                    rts      
_2C7A:
                    ldd      ,y
                    adda     #$08
                    orb      #$08
                    std      ,x
                    ldd      <<$02,y
                    std      <<$02,x
                    ldd      <<$04,y
                    std      <<$04,x
                    lda      #$02
                    sta      <<$07,u
                    rts      
_2C8F:
                    dec      <<$05,u
                    ldd      ,y
                    adda     #$0C
                    std      ,x
                    adda     #$04
                    sta      <<$0E,x
                    sta      <$1C,x
                    sta      <$2A,x
                    ldd      <<$02,y
                    std      <<$02,x
                    std      <$10,x
                    std      <$1E,x
                    std      <$2C,x
                    ldd      <<$04,y
                    std      <<$04,x
                    std      <$12,x
                    std      <$20,x
                    std      <$2E,x
                    ldd      #$0509
                    sta      <<$06,x
                    stb      <$14,x
                    ldd      #$0603
                    sta      <$22,x
                    stb      <$30,x
                    lda      #$10
                    sta      <<$07,u
                    rts      
                    bge      _2CAC
                    blt      _2CD7
                    DB       $2D, $2B, $2D, $54
                    lda      ,u
                    bita     #$10
                    beq      _2CE5
                    lda      #$F8
                    sta      <$1E
                    bra      _2CED
_2CE5:
                    bita     #$20
                    beq      _2CED
                    lda      #$08
                    sta      <$1E
_2CED:
                    lda      ,u
                    bita     #$40
                    beq      _2CF9
                    lda      #$FA
                    sta      <$1F
                    bra      _2D01
_2CF9:
                    bita     #$80
                    beq      _2D01
                    lda      #$06
                    sta      <$1F
_2D01:
                    rts      
                    lda      ,u
                    bita     #$10
                    beq      _2D0E
                    lda      #$08
                    sta      <$1F
                    bra      _2D16
_2D0E:
                    bita     #$20
                    beq      _2D16
                    lda      #$F8
                    sta      <$1F
_2D16:
                    lda      ,u
                    bita     #$40
                    beq      _2D22
                    lda      #$FA
                    sta      <$1E
                    bra      _2D2A
_2D22:
                    bita     #$80
                    beq      _2D2A
                    lda      #$06
                    sta      <$1E
_2D2A:
                    rts      
                    lda      ,u
                    bita     #$10
                    beq      _2D37
                    lda      #$08
                    sta      <$1E
                    bra      _2D3F
_2D37:
                    bita     #$20
                    beq      _2D3F
                    lda      #$F8
                    sta      <$1E
_2D3F:
                    lda      ,u
                    bita     #$40
                    beq      _2D4B
                    lda      #$06
                    sta      <$1F
                    bra      _2D53
_2D4B:
                    bita     #$80
                    beq      _2D53
                    lda      #$FA
                    sta      <$1F
_2D53:
                    rts      
                    lda      ,u
                    bita     #$10
                    beq      _2D60
                    lda      #$F8
                    sta      <$1F
                    bra      _2D68
_2D60:
                    bita     #$20
                    beq      _2D68
                    lda      #$08
                    sta      <$1F
_2D68:
                    lda      ,u
                    bita     #$40
                    beq      _2D74
                    lda      #$06
                    sta      <$1E
                    bra      _2D7C
_2D74:
                    bita     #$80
                    beq      _2D7C
                    lda      #$FA
                    sta      <$1E
_2D7C:
                    rts      
                    lda      <$8C
                    bne      _2D9B
                    lda      <$E9
                    bita     #$01
                    beq      _2D9D
                    ldd      #$06
                    sta      <$86
                    stb      <$EB
                    clr      <$EC
                    clr      <$ED
                    clr      <$EE
                    lda      #$0C
                    sta      <$EF
                    jmp      >_2A46
_2D9B:
                    dec      <$8C
_2D9D:
                    rts      
                    lda      <$93
                    bne      _2DBC
                    lda      <$F1
                    bita     #$01
                    beq      _2DBE
                    ldd      #$0206
                    sta      <$8D
                    stb      <$F3
                    clr      <$F4
                    clr      <$F5
                    clr      <$F6
                    lda      #$0C
                    sta      <$F7
                    jmp      >_2A46
_2DBC:
                    dec      <$93
_2DBE:
                    rts      
                    ldu      #$C88D
                    bra      _2DC7
                    ldu      #$C886
_2DC7:
                    lda      <<$01,y
                    ldx      #$2DCE
                    jmp      [a,x]
                    blt      _2DBB
                    bgt      _2E2B
                    bgt      _2D9B
                    DB       $2F, $35, $2D, $DE, $2E, $4C, $2E, $BA
                    DB       $2F, $28
                    lda      #$00
                    sta      <<$01,y
                    ldd      <<$02,y
                    subd     #$01
                    std      <<$02,y
                    bra      _2DF2
                    ldd      <<$02,y
                    subd     #$60
                    std      <<$02,y
_2DF2:
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _2E2D
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$10
                    bgt      _2E2D
                    cmpd     #$FFF0
                    blt      _2E2D
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$40
                    bgt      _2E2D
                    cmpd     #$FFC0
                    blt      _2E2D
                    lda      #$14
                    sta      ,y
                    ldd      <<$02,u
                    addd     #$01
                    std      <<$02,y
                    ldd      #$0801
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_2E2D:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    lda      d,x
                    bmi      _2E3C
                    rts      
_2E3C:
                    lda      #$14
                    sta      ,y
                    lda      <<$02,y
                    inca     
                    ldb      #$01
                    std      <<$02,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
                    lda      #$02
                    sta      <<$01,y
                    ldd      <<$04,y
                    addd     #$01
                    std      <<$04,y
                    bra      _2E60
                    ldd      <<$04,y
                    addd     #$60
                    std      <<$04,y
_2E60:
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _2E9B
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$10
                    bgt      _2E9B
                    cmpd     #$FFF0
                    blt      _2E9B
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$40
                    bgt      _2E9B
                    cmpd     #$FFC0
                    blt      _2E9B
                    lda      #$14
                    sta      ,y
                    ldd      <<$04,u
                    subd     #$01
                    std      <<$04,y
                    ldd      #$0801
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_2E9B:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    lda      d,x
                    bmi      _2EAA
                    rts      
_2EAA:
                    lda      #$14
                    sta      ,y
                    lda      <<$04,y
                    deca     
                    ldb      #$FF
                    std      <<$04,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
                    lda      #$04
                    sta      <<$01,y
                    ldd      <<$02,y
                    addd     #$01
                    std      <<$02,y
                    bra      _2ECE
                    ldd      <<$02,y
                    addd     #$60
                    std      <<$02,y
_2ECE:
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _2F09
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$10
                    bgt      _2F09
                    cmpd     #$FFF0
                    blt      _2F09
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$40
                    bgt      _2F09
                    cmpd     #$FFC0
                    blt      _2F09
                    lda      #$14
                    sta      ,y
                    ldd      <<$02,u
                    subd     #$01
                    std      <<$02,y
                    ldd      #$0801
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_2F09:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    lda      d,x
                    bmi      _2F18
                    rts      
_2F18:
                    lda      #$14
                    sta      ,y
                    lda      <<$02,y
                    deca     
                    ldb      #$FF
                    std      <<$02,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
                    lda      #$06
                    sta      <<$01,y
                    ldd      <<$04,y
                    subd     #$01
                    std      <<$04,y
                    bra      _2F3C
                    ldd      <<$04,y
                    subd     #$60
                    std      <<$04,y
_2F3C:
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _2F77
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$10
                    bgt      _2F77
                    cmpd     #$FFF0
                    blt      _2F77
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$40
                    bgt      _2F77
_2F5E:
                    cmpd     #$FFC0
                    blt      _2F77
                    lda      #$14
                    sta      ,y
                    ldd      <<$04,u
_2F6A:
                    addd     #$01
                    std      <<$04,y
                    ldd      #$0801
                    sta      <<$06,y
                    stb      <<$06,u
_2F76:
                    rts      
_2F77:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    lda      d,x
                    bmi      _2F86
                    rts      
_2F86:
                    lda      #$14
                    sta      ,y
                    lda      <<$04,y
                    inca     
                    ldb      #$01
                    std      <<$04,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
                    dec      <<$06,y
                    bne      _2F9E
_2F9A:
                    lda      #$FF
                    sta      ,y
_2F9E:
                    rts      
                    dec      <<$06,y
                    beq      _2F9A
                    lda      <<$01,y
                    ldx      #$2FAA
                    jmp      [a,x]
                    ble      _2F5E
                    ble      _2F6A
                    ble      _2F76
                    DB       $2F, $D0
                    ldd      <<$02,y
                    subd     #$20
                    std      <<$02,y
                    jmp      >_2E2D
                    ldd      <<$04,y
                    addd     #$20
                    std      <<$04,y
                    jmp      >_2E9B
                    ldd      <<$02,y
                    addd     #$20
                    std      <<$02,y
                    jmp      >_2F09
                    ldd      <<$04,y
                    subd     #$20
                    std      <<$04,y
                    bra      _2F77
                    ldd      <<$02,y
                    subd     <$88
                    cmpd     #$30
                    bge      _300C
                    cmpd     #$FFD0
                    ble      _300C
                    ldd      <<$04,y
                    subd     <$8A
                    cmpd     #$30
                    bge      _300C
                    cmpd     #$FFD0
                    ble      _300C
                    lda      #$FF
                    sta      ,y
                    lda      #$0C
                    sta      <$EF
                    pshs     y
_3003:
                    ldy      #$C886
                    jsr      >_2A46
                    puls     y,pc
_300C:
                    ldd      <<$02,y
                    subd     <$8F
                    cmpd     #$30
                    bge      _303F
                    cmpd     #$FFD0
                    ble      _303F
                    ldd      <<$04,y
                    subd     <$91
                    cmpd     #$30
                    bge      _303F
                    cmpd     #$FFD0
                    ble      _303F
                    lda      #$FF
                    sta      ,y
                    lda      #$0C
                    sta      <$F7
                    pshs     y
                    ldy      #$C88D
                    jsr      >_2A46
                    puls     y,pc
_303F:
                    rts      
                    ldd      <<$02,y
                    subd     <$88
                    cmpd     #$30
                    bge      _306C
                    cmpd     #$FFD0
                    ble      _306C
_3050:
                    ldd      <<$04,y
                    subd     <$8A
                    cmpd     #$30
                    bge      _306C
                    cmpd     #$FFD0
                    ble      _306C
                    lda      #$FF
                    sta      ,y
                    ldd      #$060E
                    sta      <$EB
                    stb      <$EF
                    rts      
_306C:
                    ldd      <<$02,y
                    subd     <$8F
                    cmpd     #$30
                    bge      _3098
                    cmpd     #$FFD0
                    ble      _3098
_307C:
                    ldd      <<$04,y
                    subd     <$91
                    cmpd     #$30
                    bge      _3098
                    cmpd     #$FFD0
                    ble      _3098
                    lda      #$FF
                    sta      ,y
                    ldd      #$060E
                    sta      <$F3
                    stb      <$F7
                    rts      
_3098:
                    rts      
                    ldd      <<$02,y
                    subd     <$88
                    cmpd     #$30
                    bge      _30C5
                    cmpd     #$FFD0
                    ble      _30C5
                    ldd      <<$04,y
                    subd     <$8A
                    cmpd     #$30
                    bge      _30C5
                    cmpd     #$FFD0
                    ble      _30C5
                    lda      #$FF
                    sta      ,y
                    ldd      #$FA0E
                    sta      <$EC
                    stb      <$EF
                    rts      
_30C5:
                    ldd      <<$02,y
                    subd     <$8F
                    cmpd     #$30
                    bge      _30F1
                    cmpd     #$FFD0
                    ble      _30F1
                    ldd      <<$04,y
                    subd     <$91
                    cmpd     #$30
                    bge      _30F1
                    cmpd     #$FFD0
                    ble      _30F1
                    lda      #$FF
                    sta      ,y
                    ldd      #$FA0E
                    sta      <$F4
                    stb      <$F7
                    rts      
_30F1:
                    rts      
                    ldd      <<$02,y
                    subd     <$88
                    cmpd     #$30
                    bge      _311D
_30FC:
                    cmpd     #$FFD0
                    ble      _311D
                    ldd      <<$04,y
                    subd     <$8A
                    cmpd     #$30
                    bge      _311D
                    cmpd     #$FFD0
                    ble      _311D
                    lda      #$FF
                    sta      ,y
                    inc      <$ED
                    ldb      #$0E
                    stb      <$EF
                    rts      
_311D:
                    ldd      <<$02,y
                    subd     <$8F
                    cmpd     #$30
                    bge      _3148
                    cmpd     #$FFD0
                    ble      _3148
                    ldd      <<$04,y
                    subd     <$91
                    cmpd     #$30
                    bge      _3148
                    cmpd     #$FFD0
                    ble      _3148
                    lda      #$FF
                    sta      ,y
                    inc      <$F5
                    ldb      #$0E
                    stb      <$F7
                    rts      
_3148:
                    rts      
                    ldu      #$C88D
                    bra      _3151
                    ldu      #$C886
_3151:
                    ldb      <<$06,y
                    cmpb     #$34
                    bcc      _315A
                    incb     
                    stb      <<$06,y
_315A:
                    andb     #$7E
                    lda      <<$01,y
                    ldx      #$3163
                    jmp      [a,x]
                    leay     <<$0B,s
                    leas     <<-$0F,x
                    leas     [<$33,y]
                    bcs      _31BC
                    sex      
                    std      <$02
                    addd     <<$02,y
                    std      <<$02,y
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _31AD
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$20
                    bgt      _31AD
                    cmpd     #$FFE0
                    blt      _31AD
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$20
                    bgt      _31AD
                    cmpd     <$02
                    blt      _31AD
                    lda      #$18
                    sta      ,y
                    ldd      <<$02,u
                    addd     #$01
                    std      <<$02,y
                    ldd      #$1080
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_31AD:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      ,x
                    bmi      _31C6
                    ldd      <<$02,y
                    cmpd     <<$02,u
                    bcc      _31FE
                    bra      _31D6
_31C6:
                    lda      #$14
                    sta      ,y
                    lda      <<$02,y
                    inca     
                    ldb      #$01
                    std      <<$02,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
_31D6:
                    lda      <<$06,y
                    cmpa     #$1A
                    bls      _31FE
                    lda      <<$04,y
                    cmpa     <<$04,u
                    beq      _31FE
                    bhi      _31F1
                    lda      <<$01,x
                    bmi      _31FE
                    lda      #$02
                    sta      <<$01,y
                    lsr      <<$06,y
                    lsr      <<$06,y
                    rts      
_31F1:
                    lda      <<-$01,x
                    bmi      _31FE
                    lda      #$06
                    sta      <<$01,y
                    lsr      <<$06,y
                    lsr      <<$06,y
                    rts      
_31FE:
                    ldb      <<$05,y
                    cmpb     <<$05,u
                    bcs      _3207
                    bhi      _320C
                    rts      
_3207:
                    addb     #$02
                    stb      <<$05,y
                    rts      
_320C:
                    subb     #$02
                    stb      <<$05,y
                    rts      
                    sex      
                    std      <$02
                    addd     <<$04,y
                    std      <<$04,y
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _3252
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$20
                    bgt      _3252
                    cmpd     #$FFE0
                    blt      _3252
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     <$02
                    bgt      _3252
                    cmpd     #$FFE0
                    blt      _3252
                    lda      #$18
                    sta      ,y
                    ldd      <<$04,u
                    subd     #$01
                    std      <<$04,y
                    ldd      #$1080
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_3252:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      ,x
                    bmi      _326B
                    ldd      <<$04,y
                    cmpd     <<$04,u
                    bls      _32A5
                    bra      _327B
_326B:
                    lda      #$14
                    sta      ,y
                    lda      <<$04,y
                    deca     
                    ldb      #$FF
                    std      <<$04,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
_327B:
                    lda      <<$06,y
                    cmpa     #$1A
                    bls      _32A5
                    lda      <<$02,y
                    cmpa     <<$02,u
                    beq      _32A5
                    bcs      _3297
                    lda      <-$20,x
                    bmi      _32A5
                    lda      #$00
                    sta      <<$01,y
                    lsr      <<$06,y
                    lsr      <<$06,y
                    rts      
_3297:
                    lda      <$20,x
                    bmi      _32A5
                    lda      #$04
                    sta      <<$01,y
                    lsr      <<$06,y
                    lsr      <<$06,y
                    rts      
_32A5:
                    ldb      <<$03,y
                    cmpb     <<$03,u
                    bcs      _32B3
                    bhi      _32AE
                    rts      
_32AE:
                    subb     #$02
                    stb      <<$03,y
                    rts      
_32B3:
                    addb     #$02
                    stb      <<$03,y
                    rts      
                    sex      
                    std      <$02
                    addd     <<$02,y
                    std      <<$02,y
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _32F9
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$20
                    bgt      _32F9
                    cmpd     #$FFE0
                    blt      _32F9
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     <$02
                    bgt      _32F9
                    cmpd     #$FFE0
                    blt      _32F9
                    lda      #$18
                    sta      ,y
                    ldd      <<$02,u
                    subd     #$01
                    std      <<$02,y
                    ldd      #$1080
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_32F9:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      ,x
                    bmi      _3315
                    ldd      <<$02,y
                    cmpd     <<$02,u
                    lbls     _31FE
                    jmp      >_31D6
_3315:
                    lda      #$14
                    sta      ,y
                    lda      <<$02,y
                    deca     
                    ldb      #$FF
                    std      <<$02,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
                    negb     
                    sex      
                    std      <$02
                    addd     <<$04,y
                    std      <<$04,y
                    lda      ,u
                    anda     #$FC
                    cmpa     #$00
                    bne      _3367
                    ldd      <<$02,y
                    subd     <<$02,u
                    cmpd     #$20
                    bgt      _3367
                    cmpd     #$FFE0
                    blt      _3367
                    ldd      <<$04,y
                    subd     <<$04,u
                    cmpd     #$20
                    bgt      _3367
                    cmpd     <$02
                    blt      _3367
                    lda      #$18
                    sta      ,y
                    ldd      <<$04,u
                    addd     #$01
                    std      <<$04,y
                    ldd      #$1080
                    sta      <<$06,y
                    stb      <<$06,u
                    rts      
_3367:
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      ,x
                    bmi      _3383
                    ldd      <<$04,y
                    cmpd     <<$04,u
                    lbcc     _32A5
                    jmp      >_327B
_3383:
                    lda      #$14
                    sta      ,y
                    lda      <<$04,y
                    inca     
                    ldb      #$01
                    std      <<$04,y
                    lda      #$04
                    sta      <<$06,y
                    rts      
                    dec      <<$06,y
                    bpl      _33A9
                    lda      <$94
                    cmpa     #$0C
                    bne      _33C1
                    ldd      <$96
                    std      <<$02,y
                    ldd      <$98
                    std      <<$04,y
                    lda      #$09
                    sta      <<$06,y
_33A9:
                    rts      
                    dec      <<$06,y
                    bpl      _33C0
                    lda      <$9B
                    cmpa     #$0E
                    bne      _33C1
                    ldd      <$9D
                    std      <<$02,y
                    ldd      <$9F
                    std      <<$04,y
                    lda      #$09
                    sta      <<$06,y
_33C0:
                    rts      
_33C1:
                    lda      #$FF
                    sta      ,y
                    rts      
                    lda      <$86
                    ldb      <$8D
                    cmpd     #$02
                    bne      _33FB
                    ldd      <<$02,y
                    subd     <$88
                    cmpd     #$30
                    bge      _3400
                    cmpd     #$FFD0
                    ble      _3400
                    ldd      <<$04,y
                    subd     <$8A
                    cmpd     #$30
                    bge      _3400
                    cmpd     #$FFD0
                    ble      _3400
                    ldb      #$14
                    stb      <$EF
                    ldd      #$3EFE
                    std      <$09
                    clr      <$0B
_33FB:
                    lda      #$FF
                    sta      ,y
                    rts      
_3400:
                    ldd      <<$02,y
                    subd     <$8F
                    cmpd     #$30
                    bge      _342D
                    cmpd     #$FFD0
                    ble      _342D
                    ldd      <<$04,y
                    subd     <$91
                    cmpd     #$30
                    bge      _342D
                    cmpd     #$FFD0
                    ble      _342D
                    ldb      #$14
                    stb      <$F7
                    ldd      #$3EFE
                    std      <$09
                    clr      <$0B
                    bra      _33FB
_342D:
                    lda      <<$01,y
                    ldu      #$3434
                    jmp      [a,u]
                    pshs     y,x,dp,b
                    pshs     u,y,dp,a
                    pshs     pc,x,dp
                    pshs     pc,u,b,a
                    ldb      <<$03,y
                    cmpb     #$80
                    bne      _3457
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      <<-$01,x
                    bpl      _345F
                    lda      <-$20,x
                    bmi      _3465
_3457:
                    ldd      <<$02,y
                    subd     #$08
                    std      <<$02,y
                    rts      
_345F:
                    lda      #$06
                    sta      <<$01,y
                    bra      _34E1
_3465:
                    lda      #$02
                    sta      <<$01,y
                    rts      
                    ldb      <<$05,y
                    cmpb     #$80
                    bne      _3485
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      <-$20,x
                    bpl      _348D
                    lda      <<$01,x
                    bmi      _3493
_3485:
                    ldd      <<$04,y
                    addd     #$08
                    std      <<$04,y
                    rts      
_348D:
                    lda      #$00
                    sta      <<$01,y
                    bra      _3457
_3493:
                    lda      #$04
                    sta      <<$01,y
                    rts      
                    ldb      <<$03,y
                    cmpb     #$80
                    bne      _34B3
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      <<$01,x
                    bpl      _34BB
                    lda      <$20,x
                    bmi      _34C1
_34B3:
                    ldd      <<$02,y
                    addd     #$08
                    std      <<$02,y
                    rts      
_34BB:
                    lda      #$02
                    sta      <<$01,y
                    bra      _3485
_34C1:
                    lda      #$06
                    sta      <<$01,y
                    rts      
                    ldb      <<$05,y
                    cmpb     #$80
                    bne      _34E1
                    ldx      <$10
                    ldb      <<$04,y
                    abx      
                    lda      <<$02,y
                    ldb      #$20
                    mul      
                    leax     d,x
                    lda      <$20,x
                    bpl      _34E9
                    lda      <<-$01,x
                    bmi      _34EF
_34E1:
                    ldd      <<$04,y
                    subd     #$08
                    std      <<$04,y
                    rts      
_34E9:
                    lda      #$04
                    sta      <<$01,y
                    bra      _34B3
_34EF:
                    lda      #$00
                    sta      <<$01,y
                    rts      
_34F4:
                    ldy      >_C816
                    lda      ,y
                    anda     #$FC
                    cmpa     #$04
                    beq      _353B
                    ldu      >_C818
                    ldb      <<$06,u
                    beq      _3515
                    dec      <<$06,u
                    lda      >SyncData3
                    bita     #$30
                    beq      _353B
                    bitb     #$02
                    beq      _3515
                    negb     
_3515:
                    lda      <<$01,y
                    sta      >_C848
                    bita     #$02
                    bne      _352B
                    sex      
                    addd     <<$04,y
                    std      >_C84B
                    ldd      <<$02,y
                    std      >_C849
                    bra      _3536
_352B:
                    sex      
                    addd     <<$02,y
                    std      >_C849
                    ldd      <<$04,y
                    std      >_C84B
_3536:
                    jsr      >_0C37
                    bra      _3581
_353B:
                    lda      #$D0
                    tfr      a,dp
                    lda      #$7F
                    sta      <$04
                    lda      #$C8
                    tfr      a,dp
                    lda      #$28
                    sta      <$04
_354B:
                    lda      <$3D
                    anda     #$7F
                    suba     #$40
                    sta      <$02
                    jsr      >_00E2
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    lda      >CounterVar
                    adda     #$27
                    jsr      >AlexIntensity_A
                    lda      >_C802
                    ldb      >_C83D
                    jsr      >AlexMoveToD
                    lda      #$FE
                    sta      <$0A
                    lda      #$C8
                    tfr      a,dp
                    dec      <$04
                    bne      _354B
                    ldu      <$18
                    lda      #$00
                    sta      <<$07,u
                    rts      
_3581:
                    lda      #$C8
                    tfr      a,dp
                    ldy      #$C886
                    lda      <$48
                    ldu      #$3590
                    jmp      [a,u]
                    puls     dp,x,pc
                    pshu     s,b,cc
                    pshu     pc,s,y,x,a
                    DB       $37, $9F
_3598:
                    lda      ,y
                    bmi      _35DB
                    ldd      <$49
                    subd     <<$02,y
                    ble      _35DB
                    cmpd     #$0B80
                    bge      _35DB
                    asra     
                    rorb     
                    asra     
                    rorb     
                    asra     
                    rorb     
                    std      <$24
                    ldd      <<$04,y
                    subd     <$4B
                    cmpd     #$FF00
                    ble      _35DB
                    tsta     
                    bgt      _35DB
                    asra     
                    rorb     
                    stb      <$26
                    lda      <<$04,y
                    cmpa     <$4B
                    bcs      _35E4
                    bhi      _3616
                    ldx      #$C852
                    lda      <$49
                    suba     <<$02,y
                    lda      a,x
                    bne      _35DB
_35D4:
                    jsr      >_384C
                    lda      #$C8
                    tfr      a,dp
_35DB:
                    leay     <<$07,y
                    cmpy     #$C8E8
                    bne      _3598
                    rts      
_35E4:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    negb     
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <$49
                    subb     <<$02,y
                    abx      
                    lda      <$10,x
                    beq      _3607
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bls      _35DB
_3607:
                    lda      ,x
                    beq      _35D4
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bcs      _35D4
                    bra      _35DB
_3616:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <$49
                    subb     <<$02,y
                    abx      
                    lda      <$20,x
                    beq      _3637
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bls      _35DB
_3637:
                    lda      ,x
                    beq      _35D4
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bcs      _35D4
                    bra      _35DB
_3645:
                    lda      ,y
                    bmi      _3688
                    ldd      <<$04,y
                    subd     <$4B
                    ble      _3688
                    cmpd     #$0B80
                    bge      _3688
                    asra     
                    rorb     
                    asra     
                    rorb     
                    asra     
                    rorb     
                    std      <$24
                    ldd      <<$02,y
                    subd     <$49
                    cmpd     #$FF00
                    ble      _3688
                    tsta     
                    bgt      _3688
                    asra     
                    rorb     
                    stb      <$26
                    lda      <<$02,y
                    cmpa     <$49
                    bcs      _3691
                    bhi      _36C3
                    ldx      #$C852
                    lda      <<$04,y
                    suba     <$4B
                    lda      a,x
                    bne      _3688
_3681:
                    jsr      >_384C
                    lda      #$C8
                    tfr      a,dp
_3688:
                    leay     <<$07,y
                    cmpy     #$C8E8
                    bne      _3645
                    rts      
_3691:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    negb     
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <<$04,y
                    subb     <$4B
                    abx      
                    lda      <$10,x
                    beq      _36B4
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bls      _3688
_36B4:
                    lda      ,x
                    beq      _3681
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bcs      _3681
                    bra      _3688
_36C3:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <<$04,y
                    subb     <$4B
                    abx      
                    lda      <$20,x
                    beq      _36E4
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bls      _3688
_36E4:
                    lda      ,x
                    beq      _3681
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bcs      _3681
                    bra      _3688
_36F2:
                    lda      ,y
                    bmi      _3735
                    ldd      <<$02,y
                    subd     <$49
                    ble      _3735
                    cmpd     #$0B80
                    bge      _3735
                    asra     
                    rorb     
                    asra     
                    rorb     
                    asra     
                    rorb     
                    std      <$24
                    ldd      <$4B
                    subd     <<$04,y
                    cmpd     #$FF00
                    ble      _3735
                    tsta     
                    bgt      _3735
                    asra     
                    rorb     
                    stb      <$26
                    lda      <$4B
                    cmpa     <<$04,y
                    bcs      _373E
                    bhi      _3770
                    ldx      #$C852
                    lda      <<$02,y
                    suba     <$49
                    lda      a,x
                    bne      _3735
_372E:
                    jsr      >_384C
                    lda      #$C8
                    tfr      a,dp
_3735:
                    leay     <<$07,y
                    cmpy     #$C8E8
                    bne      _36F2
                    rts      
_373E:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    negb     
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <<$02,y
                    subb     <$49
                    abx      
                    lda      <$10,x
                    beq      _3761
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bls      _3735
_3761:
                    lda      ,x
                    beq      _372E
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bcs      _372E
                    bra      _3735
_3770:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <<$02,y
                    subb     <$49
                    abx      
                    lda      <$20,x
                    beq      _3791
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bls      _3735
_3791:
                    lda      ,x
                    beq      _372E
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bcs      _372E
                    bra      _3735
_379F:
                    lda      ,y
                    bmi      _37E2
                    ldd      <$4B
                    subd     <<$04,y
                    ble      _37E2
                    cmpd     #$0B80
                    bge      _37E2
                    asra     
                    rorb     
                    asra     
                    rorb     
                    asra     
                    rorb     
                    std      <$24
                    ldd      <$49
                    subd     <<$02,y
                    cmpd     #$FF00
                    ble      _37E2
                    tsta     
                    bgt      _37E2
                    asra     
                    rorb     
                    stb      <$26
                    lda      <$49
                    cmpa     <<$02,y
                    bcs      _37EB
                    bhi      _381D
                    ldx      #$C852
                    lda      <$4B
                    suba     <<$04,y
                    lda      a,x
                    bne      _37E2
_37DB:
                    jsr      >_384C
                    lda      #$C8
                    tfr      a,dp
_37E2:
                    leay     <<$07,y
                    cmpy     #$C8E8
                    bne      _379F
                    rts      
_37EB:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    negb     
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <$4B
                    subb     <<$04,y
                    abx      
_3800:
                    lda      <$10,x
_3803:
                    beq      _380E
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bls      _37E2
_380E:
                    lda      ,x
                    beq      _37DB
                    ldb      <$4D
                    negb     
                    mul      
                    cmpd     <$02
                    bcs      _37DB
                    bra      _37E2
_381D:
                    ldu      #$41CF
                    ldd      <$24
                    lda      d,u
                    ldb      <$26
                    mul      
                    std      <$02
                    ldx      #$C852
                    ldb      <$4B
                    subb     <<$04,y
                    abx      
                    lda      <$20,x
                    beq      _383E
                    ldb      <$4E
                    mul      
                    cmpd     <$02
_383C:
                    bls      _37E2
_383E:
                    lda      ,x
                    beq      _37DB
                    ldb      <$4E
                    mul      
                    cmpd     <$02
                    bcs      _37DB
                    bra      _37E2
_384C:
                    lda      ,y
                    ldu      #jumpTable
                    jmp      [a,u]
jumpTable:
                    DW       $3877
                    DW       $3877
                    DW       $39A4
                    DW       $39A4
                    DW       $3962
                    DW       $3962
                    DW       $3C89
                    DW       $3C89
                    DW       $3D60
                    DW       $3D60
                    DW       $39AD
                    DW       $39AD
                    DW       $3D9A
                    DW       $3A25
                    DW       $3B64
                    DW       $3BCB
                    DW       $3C1E
                    DW       $3DCE
                    direct $D0
_3877:
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$30
                    mul      
                    adda     #$28
                    ldb      <<$06,y
                    beq      _3898
                    asla     
                    bpl      _3898
                    lda      #$7F
_3898:
                    jsr      >AlexIntensity_A
                    lda      #$E0
                    ldb      >_C826
                    direct $FF
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    sta      <$04
                    lda      <<$01,y
                    suba     >_C848
                    anda     #$06
                    ldu      #$38B6
                    ldu      a,u
                    pulu     a,b,pc
                    DW       $38BE              ; vlist looking back
                    DW       $38DA              ; vlist looking right
                    DW       $3906              ; vlist looking straight
                    DW       $3936              ; vlist looking left
player_non_looking_vlist:
                    DB       $38, $F0, $00, $F5 ; vectorlist in form of a jump table, y,x, vectorDrawRoutine
                    DB       $00, $20, $00, $F5
                    DB       $C8, $F0, $00, $F5
                    DB       $38, $F6, $01, $2C
                    DB       $0F, $06, $00, $F5
                    DB       $00, $08, $00, $F5
                    DB       $F1, $06, $01, $11
player_lookingRight_vlist:
                    DB       $38, $F0, $00, $F5 ; vectorlist in form of a jump table, y,x, vectorDrawRoutine
                    DB       $00, $20, $00, $F5
                    DB       $C8, $F0, $00, $F5
                    DB       $38, $F6, $01, $2C
                    DB       $0F, $06, $00, $F5
                    DB       $00, $08, $00, $F5
                    DB       $F1, $06, $00, $F5
                    DB       $05, $FE, $01, $2C
                    DB       $00, $FA, $00, $F5
                    DB       $05, $00, $00, $F5
                    DB       $00, $04, $01, $11
player_lookingStraight_vlist:
                    DB       $38, $F0, $00, $F5 ; vectorlist in form of a jump table, y,x, vectorDrawRoutine
                    DB       $00, $20, $00, $F5
                    DB       $C8, $F0, $00, $F5
                    DB       $38, $F6, $01, $2C
                    DB       $0F, $06, $00, $F5
                    DB       $00, $08, $00, $F5
                    DB       $F1, $06, $00, $F5
                    DB       $05, $FB, $01, $2C
                    DB       $00, $F6, $00, $F5
                    DB       $05, $02, $00, $F5
                    DB       $00, $06, $00, $F5
                    DB       $FB, $02, $01, $11
player_lookingLeft_vlist:
                    DB       $38, $F0, $00, $F5 ; vectorlist in form of a jump table, y,x, vectorDrawRoutine
                    DB       $00, $20, $00, $F5
                    DB       $C8, $F0, $00, $F5
                    DB       $38, $0A, $01, $2C
                    DB       $0F, $FA, $00, $F5
                    DB       $00, $F8, $00, $F5
                    DB       $F1, $FA, $00, $F5
                    DB       $05, $02, $01, $2C
                    DB       $00, $06, $00, $F5
                    DB       $05, $00, $00, $F5
                    DB       $00, $FC, $01, $11
                    direct $D0
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$38
                    mul      
                    adda     #$28
                    direct $FF
                    jsr      >AlexIntensity_A
                    lda      #$F8
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    lsra     
                    sta      <$04
                    ldu      #$3990
                    pulu     a,b,pc
diamond_vlist:
                    DB       $F0, $00, $01, $2C ; vectorlist in form of a jump table, y,x, vectorDrawRoutine
                    DB       $10, $F0, $00, $F5
                    DB       $10, $10, $00, $F5
                    DB       $F0, $10, $00, $F5
                    DB       $F0, $F0, $01, $11
                    lda      <<$06,y
                    cmpa     #$20
                    lbgt     _3D9A
                    rts      
                    direct $D0
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$40
                    mul      
                    adda     #$2C
                    jsr      >AlexIntensity_A
                    lda      #$F8
                    ldb      >_C826
                    direct $FF
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    ldb      <<$06,y
                    bitb     #$02
                    beq      _39DA
                    lsra     
_39DA:
                    sta      <$04
                    ldu      #$39E1
                    pulu     a,b,pc
Shot_vlist:
                    DB       $EC, $00, $01, $2C ; vectorlist in form of a jump table, y,x, vectorDrawRoutine
                    DB       $0A, $FC, $00, $F5
                    DB       $FC, $F6, $00, $F5
                    DB       $0A, $04, $00, $F5
                    DB       $04, $F6, $00, $F5
                    DB       $04, $0A, $00, $F5
                    DB       $0A, $FC, $00, $F5
                    DB       $FC, $0A, $00, $F5
                    DB       $0A, $04, $00, $F5
                    DB       $F6, $04, $00, $F5
                    DB       $04, $0A, $00, $F5
                    DB       $F6, $FC, $00, $F5
                    DB       $FC, $0A, $00, $F5
                    DB       $FC, $F6, $00, $F5
                    DB       $F6, $04, $00, $F5
                    DB       $04, $F6, $00, $F5
                    DB       $F6, $FC, $01, $11
                    direct $D0
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$48
                    mul      
                    adda     #$34
                    jsr      >AlexIntensity_A
                    direct $FF
                    clra     
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    ldu      #$3A54
                    lda      >AlexRCCounterLo
                    anda     #$07
                    asla     
                    ldu      a,u
                    pulu     a,b,pc
                    DB       $3A, $64, $3A, $84, $3A, $A4, $3A, $C4
                    DB       $3A, $E4, $3B, $04, $3B, $24, $3B, $44
; following are 32 vectorlists just one vector "clock"
vectorONE_list:
                    DB       $20, $00, $01, $2C, $00, $00, $00, $F5 ; 
                    DB       $E0, $20, $01, $2C, $00, $00, $00, $F5
                    DB       $E0, $E0, $01, $2C, $00, $00, $00, $F5
                    DB       $20, $E0, $01, $2C, $00, $00, $01, $11
                    DB       $1F, $06, $01, $2C, $00, $00, $00, $F5
                    DB       $DB, $19, $01, $2C, $00, $00, $00, $F5
                    DB       $E7, $DB, $01, $2C, $00, $00, $00, $F5
                    DB       $25, $E7, $01, $2C, $00, $00, $01, $11
                    DB       $1E, $0C, $01, $2C, $00, $00, $00, $F5
                    DB       $D6, $12, $01, $2C, $00, $00, $00, $F5
                    DB       $EE, $D6, $01, $2C, $00, $00, $00, $F5
                    DB       $2A, $EE, $01, $2C, $00, $00, $01, $11
                    DB       $1B, $12, $01, $2C, $00, $00, $00, $F5
                    DB       $D3, $09, $01, $2C, $00, $00, $00, $F5
                    DB       $F7, $D3, $01, $2C, $00, $00, $00, $F5
                    DB       $2D, $F7, $01, $2C, $00, $00, $01, $11
                    DB       $17, $17, $01, $2C, $00, $00, $00, $F5
                    DB       $D2, $00, $01, $2C, $00, $00, $00, $F5
                    DB       $00, $D2, $01, $2C, $00, $00, $00, $F5
                    DB       $2E, $00, $01, $2C, $00, $00, $01, $11
                    DB       $12, $1B, $01, $2C, $00, $00, $00, $F5
                    DB       $D3, $F7, $01, $2C, $00, $00, $00, $F5
                    DB       $09, $D3, $01, $2C, $00, $00, $00, $F5
                    DB       $2D, $09, $01, $2C, $00, $00, $01, $11
                    DB       $0C, $1E, $01, $2C, $00, $00, $00, $F5
                    DB       $D6, $EE, $01, $2C, $00, $00, $00, $F5
                    DB       $12, $D6, $01, $2C, $00, $00, $00, $F5
                    DB       $2A, $12, $01, $2C, $00, $00, $01, $11
                    DB       $06, $1F, $01, $2C, $00, $00, $00, $F5
                    DB       $DB, $E7, $01, $2C, $00, $00, $00, $F5
                    DB       $19, $DB, $01, $2C, $00, $00, $00, $F5
                    DB       $25, $19, $01, $2C, $00, $00, $01, $11
                    direct $D0
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      >AlexRCCounterLo
                    andb     #$10
                    eorb     #$38
                    mul      
                    adda     #$28
                    direct $FF
                    jsr      >AlexIntensity_A
                    lda      #$E0
_3B86:
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    lsra     
                    sta      <$04
                    ldu      #$3B97
                    pulu     a,b,pc
healthPack_vlist:
                    DB       $00, $0C           ; y,x,wordPointer_draw
                    DW       $012C
                    DB       $00, $E8
                    DW       $00F5
                    DB       $18, $00
                    DW       $00F5
                    DB       $00, $E8
                    DW       $00F5
                    DB       $18, $00
                    DW       $00F5
                    DB       $00, $18
                    DW       $00F5
                    DB       $18, $00
                    DW       $00F5
                    DB       $00, $18
                    DW       $00F5
                    DB       $E8, $00
                    DW       $00F5
                    DB       $00, $18
                    DW       $00F5
                    DB       $E8, $00
                    DW       $00F5
                    DB       $00, $E8
                    DW       $00F5
                    DB       $E8, $00
                    DW       $0111              ; end of healthpack
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <$04
                    ldb      >AlexRCCounterLo
                    andb     #$10
                    eorb     #$38
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      #$E0
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    lsra     
                    sta      <$04
                    ldu      #$3BFE
                    pulu     a,b,pc
                    neg      <$24
                    DB       $01
                    bge      _3C03
_3C03:
                    eora     >draw_vector
                    bcc      _3C2C
_3C08:
                    neg      <$F5
                    ldd      <$24
                    neg      <$F5
                    bcc      _3C10
_3C10:
                    DB       $01
                    bge      _3C13
_3C13:
                    eora     >draw_vector
                    bcc      _3C3C
                    neg      <$F5
                    ldd      <$24
                    DB       $01, $11
                    direct $D0
someVectorOutput:
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      >AlexRCCounterLo
                    andb     #$10
                    eorb     #$38
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      #$E0
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    lsra     
                    sta      <VIA_t1_cnt_lo
                    ldu      #$3C51
                    direct $FF
                    pulu     a,b,pc
missile_vlist:
                    DB       $08, $00, $01, $2C ; y,x,wordPointer_draw
                    DB       $10, $00, $00, $F5
                    DB       $E8, $08, $01, $2C
                    DB       $00, $F0, $00, $F5
                    DB       $28, $00, $00, $F5
                    DB       $10, $08, $00, $F5
                    DB       $F0, $08, $00, $F5
                    DB       $D8, $00, $00, $F5
                    DB       $08, $F0, $01, $2C
                    DB       $00, $F0, $00, $F5
                    DB       $10, $10, $00, $F5
                    DB       $00, $10, $01, $2C
                    DB       $F0, $10, $00, $F5
                    DB       $00, $F0, $01, $11 ; end of missile
                    DB       $86, $D0, $1F, $8B
                    DB       $BD, $00, $19, $CE
                    DB       $41, $CF, $FC, $C8
                    DB       $24, $33, $CB, $A6
                    DB       $C4, $97, $04, $C6
                    DB       $30, $3D, $8B, $28
                    DB       $BD, $00, $AA, $86
                    DB       $F8, $F6, $C8, $26
                    DB       $BD, $00, $7D, $A6
                    DB       $C4, $44, $44, $97
                    DB       $04, $A6, $21, $B0
                    DB       $C8, $48, $84, $06
                    DB       $CE, $3C, $C0, $EE
                    DB       $C6, $37, $86, $3C
_3CC1:
                    DB       $C8, $3C, $F8, $3C
                    DB       $C8, $3D, $2C, $F8
                    DB       $00, $01, $2C, $08
                    DB       $F8, $00, $F5, $00
                    DB       $F8, $00, $F5, $00
_3CD5:
                    DB       $08, $01, $2C, $08
                    DB       $08, $00, $F5, $08
_3CDD:
                    DB       $00, $00, $F5, $F8
_3CE1:
                    DB       $00, $01, $2C, $F8
                    DB       $08, $00, $F5, $00
_3CE9:
                    DB       $08, $00, $F5, $00
                    DB       $F8, $01, $2C, $F8
_3CF1:
                    DB       $F8, $00, $F5, $F8
                    DB       $00, $01, $11, $00
                    DB       $10, $00, $F5, $08
                    DB       $E8, $01, $2C, $F0
                    DB       $00, $00, $F5, $00
                    DB       $28, $00, $F5, $08
_3D09:
                    DB       $10, $00, $F5, $08
                    DB       $F0, $00, $F5, $00
                    DB       $D8, $00, $F5, $F0
                    DB       $08, $01, $2C, $F0
                    DB       $00, $00, $F5, $10
                    DB       $10, $00, $F5, $10
                    DB       $00, $01, $2C, $10
_3D25:
                    DB       $F0, $00, $F5, $F0
                    DB       $00, $01, $11, $00
                    DB       $F0, $00, $F5, $08
                    DB       $18, $01, $2C, $F0
_3D35:
                    DB       $00, $00, $F5, $00
                    DB       $D8, $00, $F5, $08
_3D3D:
                    DB       $F0, $00, $F5, $08
                    DB       $10, $00, $F5, $00
                    DB       $28, $00, $F5, $F0
                    DB       $F8, $01, $2C, $F0
                    DB       $00, $00, $F5, $10
                    DB       $F0, $00, $F5, $10
                    DB       $00, $01, $2C, $10
                    DB       $10, $00, $F5, $F0
                    DB       $00, $01, $11
                    direct $D0
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$30
                    mul      
                    adda     #$2C
                    jsr      >AlexIntensity_A
                    lda      #$F8
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      ,u
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    sta      <VIA_t1_cnt_lo
                    ldu      #$3A54
                    lda      >SyncData3
                    adda     <<$06,y
                    anda     #$07
                    asla     
                    ldu      a,u
                    pulu     a,b,pc
_3D9A:
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$40
                    mul      
                    adda     #$2C
                    jsr      >AlexIntensity_A
                    lda      #$F8
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      ,u
                    ldb      >SyncData3
                    bitb     #$02
                    beq      _3DC7
                    lsra     
_3DC7:
                    sta      <VIA_t1_cnt_lo
                    ldu      #$39E1
                    pulu     a,b,pc
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    ldu      #$41CF
                    ldd      >Vec_0Ref_Enable
                    leau     d,u
                    lda      ,u
                    sta      <VIA_t1_cnt_lo
                    ldb      #$28
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      <<$03,y
                    adda     <<$05,y
                    bpl      _3DF0
                    nega     
_3DF0:
                    lsra     
                    lsra     
                    ldx      #$3E0D
                    lda      a,x
                    direct $FF
                    adda     #$E0
                    ldb      >_C826
                    jsr      >AlexMoveToD
                    lda      <<$01,y
                    suba     >_C848
                    anda     #$06
                    ldu      #$3E2E
                    ldu      a,u
                    pulu     a,b,pc
                    DB       $00, $02, $03, $05, $06, $08, $09, $0B
                    DB       $0C, $0E, $0F, $10, $12, $13, $14, $15
                    DB       $17, $18, $19, $1A, $1B, $1B, $1C, $1D
                    DB       $1E, $1E, $1F, $1F, $1F, $20, $20, $20
                    DB       $20, $3E, $36, $3E, $5A, $3E, $8E, $3E
                    DB       $CA, $00, $04, $01, $2C, $00, $F8, $00
                    DB       $F5, $08, $F8, $00, $F5, $08, $00, $00
                    DB       $F5, $08, $08, $00, $F5, $00, $08, $00
_3E4D:
                    DB       $F5, $F8, $08, $00, $F5, $F8, $00, $00
                    DB       $F5, $F8, $F8, $01, $11, $00, $04, $01
                    DB       $2C, $00, $F8, $00, $F5, $08, $F8, $00
                    DB       $F5, $08, $00, $00, $F5, $08, $08, $00
_3E6D:
                    DB       $F5, $00, $08, $00, $F5, $F8, $08, $00
                    DB       $F5, $F8, $00, $00, $F5, $F8, $F8, $00
                    DB       $F5, $08, $08, $01, $2C, $00, $FA, $00
                    DB       $F5, $0A, $FE, $01, $2C, $FC, $04, $01
                    DB       $11, $00, $04, $01, $2C, $00, $F8, $00
                    DB       $F5, $08, $F8, $00, $F5, $08, $00, $00
                    DB       $F5, $08, $08, $00, $F5, $00, $08, $00
                    DB       $F5, $F8, $08, $00, $F5, $F8, $00, $00
                    DB       $F5, $F8, $F8, $00, $F5, $08, $00, $01
                    DB       $2C, $00, $F8, $00, $F5, $0A, $FE, $01
                    DB       $2C, $FC, $04, $00, $F5, $00, $04, $01
                    DB       $2C, $04, $04, $01, $11, $00, $04, $01
                    DB       $2C, $00, $F8, $00, $F5, $08, $F8, $00
                    DB       $F5, $08, $00, $00, $F5, $08, $08, $00
                    DB       $F5, $00, $08, $00, $F5, $F8, $08, $00
                    DB       $F5, $F8, $00, $00, $F5, $F8, $F8, $00
                    DB       $F5, $08, $F0, $01, $2C, $00, $06, $00
                    DB       $F5, $0A, $02, $01
                    bge      _3EF7
                    ldd      >draw_vector_final
                    jsr      >_4019
                    lda      >_C80B
                    cmpa     #$0F
                    bcs      _3F11
                    jsr      >_3FD0
                    ldu      #$46A9
                    jsr      >printString_isyx
_3F11:
                    jsr      >_4491
                    lda      #$C8
                    tfr      a,dp
                    inc      <$0B
                    bmi      _3F1D
                    rts      
_3F1D:
                    ldd      #$3FAF
                    std      <$09
                    jsr      >_00C3
                    ldb      #$03
                    mul      
                    asla     
                    ldu      #$3F2E
                    jmp      [a,u]
                    swi      
                    pshu     y,x,dp,b,a,cc
                    inca     
                    swi      
                    aslb     
                    swi      
                    ldx      <$CC
                    rora     
                    subb     #$DD
                    bhi      _3ED2
                    addb     [,x++]
                    addd     >_2203
                    bcs      _3F49
                    rts      
                    lda      <$F3
                    sta      <$EB
                    rts      
_3F49:
                    sta      <$F3
                    rts      
                    ldd      #$46D3
                    std      <$22
                    lda      #$01
                    sta      <$EB
                    sta      <$F3
                    rts      
                    ldd      #$46E6
                    std      <$22
                    ldy      #$C886
_3F61:
                    lda      ,y
                    ldb      <<$07,y
                    cmpa     #$14
                    bcc      _3F6B
                    eora     #$02
_3F6B:
                    cmpb     #$14
                    bcc      _3F71
                    eorb     #$02
_3F71:
                    stb      ,y
                    sta      <<$07,y
                    lda      <<$01,y
                    ldb      <<$08,y
                    stb      <<$01,y
                    sta      <<$08,y
                    ldd      <<$02,y
                    ldx      <<$09,y
                    stx      <<$02,y
                    std      <<$09,y
                    ldd      <<$04,y
                    ldx      <<$0B,y
                    stx      <<$04,y
                    std      <<$0B,y
                    lda      <<$06,y
                    ldb      <<$0D,y
                    stb      <<$06,y
                    sta      <<$0D,y
                    leay     <<$0E,y
                    cmpy     #$C8CC
                    bcs      _3F61
                    rts      
                    ldd      #$46F9
                    std      <$22
                    jsr      >_00C3
                    ldb      #$06
                    mul      
                    jsr      >_28CC
                    jmp      >_2A01
                    jsr      >_4019
                    lda      >_C80B
                    cmpa     #$0F
                    bcs      _3FBF
                    ldu      >_C822
                    jsr      >printString_isyx
_3FBF:
                    jsr      >_4491
                    lda      #$C8
                    tfr      a,dp
                    dec      <$0B
                    bpl      _3FCF
                    ldd      #$297A
                    std      <$09
_3FCF:
                    rts      
_3FD0:
                    ldx      #$3E0D
                    ldy      #$41D7
                    ldu      #$3E8E
                    lda      #$08
                    sta      >CounterVar
_3FDF:
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    lda      ,y
                    sta      <$04
                    ldb      #$28
                    mul      
                    adda     #$28
                    jsr      >AlexIntensity_A
                    lda      >CounterVar
                    adda     >AlexRCCounterLo
                    asla     
                    asla     
                    asla     
                    asla     
                    bpl      _3FFF
                    nega     
_3FFF:
                    lsra     
                    lsra     
                    lda      a,x
                    adda     #$E8
                    ldb      #$D0
                    jsr      >AlexMoveToD
                    bsr      _4017
                    ldu      #$3E36
                    leay     <<$0C,y
                    dec      >CounterVar
                    bne      _3FDF
                    rts      
_4017:
                    pulu     a,b,pc
_4019:
                    lda      >_C80B
                    bne      _401F
                    rts      
_401F:
                    cmpa     #$0E
                    bls      _4025
                    lda      #$0E
_4025:
                    pshs     a
                    lda      #$D0
                    tfr      a,dp
                    jsr      >ResetIntegrators
                    lda      ,s
                    asla     
                    asla     
                    asla     
                    sta      <$04
                    ldd      #$C080
                    jsr      >AlexMoveToD
                    ldy      #$4121
                    lda      >AlexRCCounterLo
                    lsra     
                    anda     #$07
                    leay     a,y
                    puls     a
                    deca     
                    sta      <$04
                    ldu      #somedata
                    pulu     a,b,pc
somedata:
                    DB       $7C, $00, $01, $41, $07, $00, $01, $4D
                    DB       $06, $00, $01, $4D, $05, $00, $01, $4D
                    DB       $04, $00, $01, $4D, $03, $00, $01, $4D
                    DB       $02, $00, $01, $4D, $01, $00, $01, $4D
                    DB       $00, $00, $01, $4D, $00, $00, $01, $41
                    DB       $07, $7C, $01, $4D, $06, $7C, $01, $4D
                    DB       $05, $7C, $01, $4D, $04, $7C, $01, $4D
                    DB       $03, $7C, $01, $4D, $02, $7C, $01, $4D
                    DB       $01, $7C, $01, $4D, $00, $7C, $01, $4D
                    DB       $07, $7C, $01, $4D, $06, $7C, $01, $4D
                    DB       $05, $7C, $01, $4D, $04, $7C, $01, $4D
                    DB       $03, $7C, $01, $4D, $02, $7C, $01, $4D
                    DB       $01, $7C, $01, $4D, $00, $7C, $01, $4D
                    DB       $84, $00, $01, $41, $07, $00, $01, $4D
                    DB       $06, $00, $01, $4D, $05, $00, $01, $4D
                    DB       $04, $00, $01, $4D, $03, $00, $01, $4D
                    DB       $02, $00, $01, $4D, $01, $00, $01, $4D
                    DB       $00, $00, $01, $4D, $00, $00, $01, $41
                    DB       $07, $84, $01, $4D, $06, $84, $01, $4D
                    DB       $05, $84, $01, $4D, $04, $84, $01, $4D
                    DB       $03, $84, $01, $4D, $02, $84, $01, $4D
                    DB       $01, $84, $01, $4D, $00, $84, $01, $4D
                    DB       $07, $84, $01, $4D, $06, $84, $01, $4D
                    DB       $05, $84, $01, $4D, $04, $84, $01, $4D
                    DB       $03, $84, $01, $4D, $02, $84, $01, $4D
                    DB       $01, $84, $01, $4D, $00, $84, $01, $6D
                    DB       $68, $60, $58, $50, $48, $40, $38, $30
                    DB       $68, $60, $58, $50, $48, $40, $38
_4130:
                    bsr      _415B
                    ldu      <$18
                    lda      <<$07,u
                    bmi      _4144
                    ldb      #$FF
                    stb      <<$07,u
                    ldu      #$4145
                    ldu      a,u
                    jmp      >_0769
_4144:
                    rts      
                    asr      <$DE
                    asr      <$EF
                    DB       $08, $86, $08, $F1, $09, $5E, $09, $CB
                    DB       $0A, $38, $0A, $F9, $0B, $40, $0B, $9B
                    inc      <$08
_415B:
                    lda      <$86
                    cmpa     #$00
                    bne      _419A
                    lda      <$8D
                    cmpa     #$02
                    bne      _419A
                    inc      <$37
                    ldd      <$88
                    subd     <$8F
                    bpl      _4174
                    coma     
                    comb     
                    addd     #$01
_4174:
                    std      <$02
                    ldd      <$8A
                    subd     <$91
                    bpl      _4181
                    coma     
                    comb     
                    addd     #$01
_4181:
                    cmpd     <$02
                    bcc      _4188
                    ldd      <$02
_4188:
                    aslb     
                    rola     
                    aslb     
                    rola     
                    adda     #$03
                    cmpa     <$37
                    bhi      _419A
                    clr      <$37
                    ldu      #$07C5
                    jmp      >_0769
_419A:
                    rts      
_419B:
                    ldu      >_C81C
                    lda      <<$07,u
                    bmi      _41AE
                    ldb      #$FF
                    stb      <<$07,u
                    ldu      #$4145
                    ldu      a,u
                    jmp      >_0769
_41AE:
                    rts      
                    DB       $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                    DB       $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                    DB       $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                    DB       $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                    DB       $FF, $F0, $E2, $D6, $CC, $C2, $B9, $B1
                    DB       $AA, $A3, $9C, $97, $91, $8C, $88, $83
                    DB       $7F, $7B, $78, $74, $71, $6E, $6B, $68
                    DB       $66, $63, $61, $5E, $5C, $5A, $58, $56
                    DB       $55, $53, $51, $50, $4E, $4C, $4B, $4A
                    DB       $48, $47, $46, $45, $44, $42, $41, $40
                    DB       $3F, $3E, $3D, $3C, $3C, $3B, $3A, $39
                    DB       $38, $37, $37, $36, $35, $34, $34, $33
                    DB       $33, $32, $31, $31, $30, $30, $2F, $2E
                    DB       $2E, $2D, $2D, $2C, $2C, $2B, $2B, $2A
                    DB       $2A, $2A, $29, $29, $28, $28, $28, $27
                    DB       $27, $26, $26, $26, $25, $25, $25, $24
                    DB       $24, $24, $23, $23, $23, $22, $22, $22
                    DB       $22, $21, $21, $21, $20, $20, $20, $20
                    DB       $1F, $1F, $1F, $1F, $1E, $1E, $1E, $1E
                    DB       $1E, $1D, $1D, $1D, $1D, $1C, $1C, $1C
                    DB       $1C, $1C, $1B, $1B, $1B, $1B, $1B, $1B
                    DB       $1A, $1A, $1A, $1A, $1A, $19, $19, $19
                    DB       $19, $19, $19, $19, $18, $18, $18, $18
                    DB       $18, $18, $18, $17, $17, $17, $17, $17
                    DB       $17, $17, $16, $16, $16, $16, $16, $16
                    DB       $16, $16, $15, $15, $15, $15, $15, $15
                    DB       $15, $15, $15, $14, $14, $14, $14, $14
                    DB       $14, $14, $14, $14, $14, $13, $13, $13
                    DB       $13, $13, $13, $13, $13, $13, $13, $12
                    DB       $12, $12, $12, $12, $12, $12, $12, $12
                    DB       $12, $12, $12, $11, $11, $11, $11, $11
                    DB       $11, $11, $11, $11, $11, $11, $11, $11
                    DB       $11, $10, $10, $10, $10, $10, $10, $10
                    DB       $10, $10, $10, $10, $10, $10, $10, $10
                    DB       $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
                    DB       $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
                    DB       $0F, $0E, $0E, $0E, $0E, $0E, $0E, $0E
                    DB       $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
                    DB       $0E, $0E, $0E, $0E, $0D, $0D, $0D, $0D
                    DB       $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
                    DB       $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
                    DB       $0D, $0D, $0C, $0C, $0C, $0C, $0C, $0C
                    DB       $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
                    DB       $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
                    DB       $0C, $0C, $0C, $0C, $0C, $0B, $0B, $0B
                    DB       $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
                    DB       $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
                    DB       $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
                    DB       $0B, $0B, $0B, $0A, $0A, $0A, $0A, $0A
                    DB       $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                    DB       $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                    DB       $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                    DB       $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                    DB       $0A, $09, $09, $09, $09, $09, $09, $09
                    DB       $09, $09, $09, $09, $09, $09, $09, $09
                    DB       $09, $09, $09, $09, $09, $09, $09, $09
                    DB       $09, $09, $09, $09, $09, $09, $09, $09
                    DB       $09, $09, $09, $09, $09, $09, $09, $09
                    DB       $09, $09, $09, $09, $09, $09, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $08
                    DB       $08, $08, $08, $08, $08, $08, $08, $07
                    DB       $07, $07, $07, $07, $07, $07, $07, $07
                    DB       $07, $07, $07, $07, $07, $07, $07, $07
                    direct $D0
; RLDU
; reads buttons and joystick, result in $c805, lower nibble contains buttons stae, upper nibble reads y and x +-+- values (if bit is set, than + or netaive, if not set, than 0
readJoyPort0:
                    lda      #$D0               ; upper nibble (D=down, U = Up, L=Left, R = Right)
                    tfr      a,dp               ; setup DP
                    ldd      #$190E             ; A= $19, B = $0e
                    stb      <VIA_port_a        ; va port A = 14 (PSG reg 14)
                    sta      <VIA_port_b        ; VIA Port B = 19, mux disabled, RAMP enabled(no), BC1/BDIR = 11 (Latch address)
                    ldd      #$01               ; A=0, B=1
                    stb      <VIA_port_b        ; VIA Port B = 01, mux disabled, RAMP enabled(no), BC1/BDIR = 00 (PSG inactive)
                    sta      <VIA_DDR_a         ; Via port A = input
                    lda      #$09               ; A=09
                    sta      <VIA_port_b        ; VIA Port B = 09, mux disabled, RAMP enabled(no), BC1/BDIR = 01 (Read from PSG)
                    nop                         ; delay
                    lda      <VIA_port_a        ; get value from via A <- PSG A <- Joystick port
                    stb      <VIA_port_b        ; VIA Port B = 01, mux disabled, RAMP enabled(no), BC1/BDIR = 00 (PSG inactive)
                    ldb      #$FF               ; B=ff
                    stb      <VIA_DDR_a         ; Via port A as output
                    coma                        ; whatever we got from A is inverted
                    anda     #$0F               ; and only the lower nibble used
                    sta      >JoyStatePort0ThisSide ; save the button state
                    ldd      #$0300             ; A= 03, B = 0
                    std      <VIA_port_b        ; mux sel = 01, port 0 vertical joystick
                    dec      <VIA_port_b        ; enable mux
                    ldb      #$10               ; wait for pos to gather for 16 loops
readVerticalPort0Loop:
                    decb     
                    bne      readVerticalPort0Loop
                    sta      <VIA_port_b        ; disable mux
                    ldd      #$4020             ; A=$40, B = $20
                    sta      <VIA_port_a        ; Store compare value $40 to DAC (test for Up)
                    nop                         ; delay
                    nop      
                    bitb     <VIA_port_b        ; check compare bit
                    bne      JoyUp              ; value in DAC was smaller than pot _> compare bit is set, that means joystick was moved up ->
                    neg      <VIA_port_a        ; A=-$40, test for down
                    nop                         ; delay
                    nop      
                    bitb     <VIA_port_b        ; check compare bit
                    beq      JoyDown            ; value in DAC was greater than pot -> compare bit is not set, that means joystick was moved down ->
testHorizontal:
                    ldd      #$0100             ; A= 01, B = 0
                    std      <VIA_port_b        ; Via port B mux sel = 00, mux disabled, port 0 horizontal joystick, Via port A = 0
                    stb      <VIA_port_b        ; enable mux
                    ldb      #$10               ; wait for pos to gather for 16 loops
readHorizontalPort0Loop:
                    decb     
                    bne      readHorizontalPort0Loop
                    direct $FF
                    sta      <$00               ; disable mux
                    ldd      #$4020             ; A=$40, B = $20
                    sta      <$01               ; Store compare value $40 to DAC (test for Right)
                    nop                         ; delay
                    nop      
                    bitb     <$00               ; check compare bit
                    bne      JoyRight           ; value in DAC was greater than pot -> compare bit is not set, that means joystick was moved right ->
                    neg      <$01               ; A=-$40, test for left
                    nop                         ; delay
                    nop      
                    bitb     <$00               ; check compare bit
                    beq      JoyLeft            ; value in DAC was greater than pot -> compare bit is not set, that means joystick was moved left ->
                    rts                         ; done
JoyUp:
                    lda      >JoyStatePort0ThisSide
                    ora      #$10
                    sta      >JoyStatePort0ThisSide
                    bra      testHorizontal
JoyDown:
                    lda      >JoyStatePort0ThisSide
                    ora      #$20
                    sta      >JoyStatePort0ThisSide
                    bra      testHorizontal
JoyLeft:
                    lda      >JoyStatePort0ThisSide
                    ora      #$40
                    sta      >JoyStatePort0ThisSide
                    rts                         ; done
JoyRight:
                    lda      >JoyStatePort0ThisSide
                    ora      #$80
                    sta      >JoyStatePort0ThisSide
                    rts                         ; done
                    direct $C8
_445D:
                    ldu      >_C818
                    lda      ,u
                    coma     
                    anda     >JoyStatePort0ThisSide
                    sta      <<$01,u
                    lda      >JoyStatePort0ThisSide
                    sta      ,u
                    ldu      >_C81C
                    lda      ,u
                    coma     
                    anda     >JoyStatePort0OtherSide
                    sta      <<$01,u
                    lda      >JoyStatePort0OtherSide
                    sta      ,u
                    rts      
init_c82b_ff:
                    ldd      #$2020
                    direct $FF
                    std      <$2B
                    std      <$30
                    ldd      #$1015
                    sta      <$2D
                    stb      <$2F
                    lda      #$80
                    sta      <$36
                    rts      
_4491:
                    ldy      >_C816
                    ldu      >_C818
                    ldb      <<$03,u
                    bpl      _449D
                    clrb     
_449D:
                    aslb     
                    aslb     
                    ldx      #$455F
                    abx      
                    lda      >AlexRCCounterLo
                    bita     ,x
                    beq      _44AD
                    ldx      #$455F
_44AD:
                    lda      <<$02,u
                    adda     #$30
                    ldb      >AlexRCCounterLo
                    comb     
                    bitb     #$30
                    bne      _44BB
                    lda      #$20
_44BB:
                    ldb      <<$01,x
                    std      >Vec_Brightness
                    ldd      <<$02,x
                    std      >Vec_Pattern
                    lda      #$65
                    ldb      <<$05,u
                    beq      _44CD
                    lda      #$66
_44CD:
                    ldb      <<$04,u
                    bitb     #$C8
                    beq      _44DA
                    lda      <<$04,u
                    lsra     
                    anda     #$03
                    adda     #$68
_44DA:
                    ldb      >AlexRCCounterLo
                    bitb     #$08
                    beq      _44EB
                    ldb      <<$0E,y
                    andb     #$FC
                    cmpb     #$0C
                    bne      _44EB
                    lda      #$67
_44EB:
                    sta      >Vec_Text_Width
                    lda      >_C848
                    lsra     
                    adda     #$11
                    sta      >_C82E
                    ldy      >_C81A
                    ldu      >_C81C
                    ldb      <<$03,u
                    bpl      _4503
                    clrb     
_4503:
                    aslb     
                    aslb     
                    ldx      #$455F
                    abx      
                    lda      >AlexRCCounterLo
                    bita     ,x
                    beq      _4513
                    ldx      #$455F
_4513:
                    ldd      <<$01,x
                    std      >_C832
                    lda      <<$03,x
                    ldb      <<$02,u
                    addb     #$30
                    std      >_C834
                    lda      #$65
                    ldb      <<$05,u
                    beq      _4529
                    lda      #$66
_4529:
                    ldb      <<$04,u
                    bitb     #$C8
                    beq      _4536
                    lda      <<$04,u
                    lsra     
                    anda     #$03
                    adda     #$68
_4536:
                    ldb      >AlexRCCounterLo
                    bitb     #$08
                    beq      _4547
                    ldb      <<$0E,y
                    andb     #$FC
                    cmpb     #$0C
                    bne      _4547
                    lda      #$67
_4547:
                    sta      >_C831
                    ldd      #$90BD
                    std      >rowPos_YX
                    ldd      #$3F30
                    std      >textIntensity
                    ldu      #$C827
                    stu      >currentStringStartStruct
                    jmp      >printString
                    DB       $00, $16, $19, $1D
                    DB       $08, $17, $19, $1D
                    DB       $10, $18, $19, $1D
                    DB       $00, $18, $1A, $1D
                    DB       $00, $18, $1B, $1D
                    DB       $00, $18, $1C, $1D
                    DB       $00, $18, $1C, $1E ; 
copyrightString_isyx:
                    DB       $37, $20, $0C, $AD ; intensity, scale, ypos, xpos
                    DB       $1F, $20           ; $1f is copyright, $ is space
                    DB       "ALEX HERBERT 2005", $FF, $C0
                    DB       $C9
sologame_yx:
                    DB       "1. SOLO GAME", $FF
                    DB       $B0, $C9
linkgame_yx:
                    DB       "2. LINK GAME", $FF
                    DB       $A8, $B8
                    DB       "PRESS 1 TO START", $FF, $D8
                    DB       $AF
                    DB       "` 3 KILLS TO WIN `", $FF, $D8
                    DB       $AF
                    DB       "d 5 KILLS TO WIN d", $FF, $D8
                    DB       $AF
                    DB       "a 9 KILLS TO WIN a", $FF, $F8
                    DB       $BC
                    DB       "b TE"
                    DB       $53, $54
                    DB       " MAZE 1 c", $FF, $F8
                    DB       $BC
                    DB       "b TEST MAZE 2 c", $FF, $F8
                    DB       $BC
                    DB       "b TEST MAZE 3 c", $FF, $F8
_463A:
                    DB       $BC
                    DB       "b TEST MAZE 4 c", $FF, $F8
                    DB       $C0
                    DB       "b CORE ARENA c", $FF, $F8
                    DB       $C0
                    DB       "b GRID ARENA c", $FF, $F8
                    DB       $C0
                    DB       "b ?????????? c", $FF
                    DB       "O0", $DC
                    DB       "YOU WIN!", $FF
                    DB       "O0"
                    DB       $10, $D7
                    DB       "YOU LOSE!", $FF
linkFailedStringStruct:
                    DB       $4F, $40, $20, $CE
                    DB       "LINK FAILED", $FF
                    DB       $47, $30, $1C, $10
_46AD:
                    DB       "OH NO,", $80
                    DB       "W0", $FC
                    DB       $10
                    DB       "OTTO!!!", $FF
                    DB       "W0", $C1
                    DB       " EQUAL HEALTH ", $FF
                    DB       "W0", $C1
                    DB       "  NEAR DEATH  ", $FF
                    DB       "W0", $C1
                    DB       "SWITCH PLACES!", $FF
                    DB       "W0", $C1
                    DB       "TO A NEW MAZE"
                    DB       $21, $FF
                    pshs     b,a
                    ldd      #$7F80
                    std      >rowPos_YX
_4714:
                    ldd      #$3F20
                    std      >textIntensity
                    ldd      #$CA58
                    std      >currentStringStartStruct
                    puls     a,b,pc
                    pshs     u,x,dp,b,a
                    tfr      d,x
                    tfr      a,b
_4728:
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    andb     #$0F
                    std      >_CA58
                    tfr      x,d
                    tfr      b,a
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    andb     #$0F
                    std      >_CA5A
                    lda      #$80
                    sta      >_CA5C
                    lda      >rowPos_YX
                    suba     #$06
                    sta      >rowPos_YX
                    jsr      >printString
                    puls     a,b,dp,x,u,pc
                    pshs     u,x,dp,b,a
                    tfr      a,b
_4754:
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    andb     #$0F
                    std      >_CA58
                    lda      #$80
                    sta      >_CA5A
                    lda      >rowPos_YX
                    suba     #$06
                    sta      >rowPos_YX
                    jsr      >printString
                    puls     a,b,dp,x,u,pc
                    pshs     u,x,dp,b,a
                    tfr      b,a
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    andb     #$0F
                    std      >_CA58
                    lda      #$80
                    sta      >_CA5A
                    lda      >rowPos_YX
                    suba     #$06
                    sta      >rowPos_YX
                    jsr      >printString
                    puls     a,b,dp,x,u,pc
                    DB       $00, $03, $C8, $20, $20, $20, $FF, $CB ; Stack a,b, dp, x, y, s, pc
; Thus, game start at $26B8
                    DB       $EF, $26, $B8      ; 

