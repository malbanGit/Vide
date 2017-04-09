/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.libayemu;

import de.malban.vide.VideConfig;

/**
 *
 * @author Sashnov Alexander / Roman Scherbakov, Java port: malban
 */
    public class AY
    {
    VideConfig config = VideConfig.getConfig();
        // public enum ChipSpeedsByMachine
        public static int MSX = 1774000; // 1773400,
        public static int ZX = 1773400;
        public static int CPC = 1000000;
        public static int VECTERX = 1500000;


	public enum Stereo
	{
		Mono,
		ABC,
		ACB,
		BAC,
		BCA,
		CAB,
		CBA,
		StereoCustom
	}

	public static enum Chip
	{
		AY,			/*< default AY chip (lion17 for now) */
		YM,			/*< default YM chip (lion17 for now) */
		AY_Lion17,		/*< emulate AY with Lion17 table */
		YM_Lion17,		/*< emulate YM with Lion17 table */
		AY_Kay,			/*< emulate AY with HACKER KAY table */
		YM_Kay,			/*< emulate YM with HACKER KAY table */
		AY_Custom,		/*< use AY with custom table. */
		YM_Custom		/*< use YM with custom table. */
	}

    //public enum ChannelControl
        public static int NONE = 0;
        public static int TONE_A = 1;
        public static int TONE_B = 2;
        public static int TONE_C = 4;
        public static int NOISE_A = 8;
        public static int NOISE_B = 16;
        public static int NOISE_C = 32;
    
    
    
        /* emulator settings */
        // for easier acces from config
        // and switch in between from a central point
        private static double[] table = new double[32];    /* table of volumes for chip */

        // for easier access from config
        // and switch in between from a central point
        private static Chip type = Chip.AY;						    /* general chip type (\b AYEMU_AY or \b AYEMU_YM) */
        private int ChipFreq = VECTERX;					    /* chip emulator frequency */

        private double[] eq = new double[6];	/* volumes for channels.
										 		   Array contains 6 elements: 
												   A left, A right, B left, B right, C left and C right;
												   range 0..1 */

        RegData regs = new RegData();			/* parsed registers data */
        SndFmt sndfmt = new SndFmt();			/* output sound format */

        /* flags */
        private static boolean defaultChip;				/* =1 after init, resets in #ayemu_set_chip_type() */
        private boolean defaultStereo;				/* =1 after init, resets in #ayemu_set_stereo() */
        private boolean defaultSoundFormat;		/* =1 after init, resets in #ayemu_set_sound_format() */
        
        // for easier acces from config
        // and switch in between from a central point
        private static boolean dirty;						/* dirty flag. Sets if any emulator properties changed */

        private int bit_a;						/* state of channel A generator */
        private int bit_b;						/* state of channel B generator */
        private int bit_c;						/* state of channel C generator */
        private int bit_n;						/* current generator state */

        private int noiseSeed;

        private double cnt_a;						/* back counter of A */
        private double cnt_b;						/* back counter of B */
        private double cnt_c;						/* back counter of C */
        private double cnt_n;						/* back counter of noise generator */
        private double cnt_e;						/* back counter of envelop generator */

        private double[][] vols = vols = new double[6][32];	/* stereo type (channel volumes) and chip table.
												       This cache calculated by #table and #eq  */

        private double env_pos;					/* current position in envelop (0...127) */

        private double remainderMixL;
        private double remainderMixR;

        private final int MAX_AMP = Integer.MAX_VALUE;

        private boolean envGenInit = false;
        private int[][] envelope = new int[16][128];

        private final int INTERPOLATION_length = 3;

        /// <summary>
        /// 
        /// </summary>
        public AY()
        {
            
            this.genEnv();
            this.Init();
        }

        public RegData getRegs()
        {
            return regs; 
        }

        /// <summary>
        /// 
        /// </summary>
        public void Init()
        {
            ChipFreq = (int) VECTERX;

            defaultChip = true;
            defaultStereo = false;
            defaultSoundFormat = true;
            dirty = true;
            SetStereo(Stereo.Mono, null);
            
            Reset();
            VideConfig config = VideConfig.getConfig();

            
            if (config.useLibAYEmuTable.equals("AY_Kay"))
            {
                SetChipType(Chip.AY_Kay, null);
            }
            else if (config.useLibAYEmuTable.equals("YM_Kay"))
            {
                SetChipType(Chip.YM_Kay, null);
            }
            else if (config.useLibAYEmuTable.equals("AY_Lion17"))
            {
                SetChipType(Chip.AY_Lion17, null);
            }
            else if (config.useLibAYEmuTable.equals("YM_Lion17"))
            {
                SetChipType(Chip.YM_Lion17, null);
            }
        
        
        
        
        }

        /// <summary>
        /// 
        /// </summary>
        public void Reset()
        {
            cnt_a = cnt_b = cnt_c = cnt_n = cnt_e = 0;
            bit_a = bit_b = bit_c = bit_n = 0;
            env_pos = 0;
            noiseSeed = 0xffff;
            remainderMixL = 0.0;
            remainderMixR = 0.0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="chipType"></param>
        /// <param name="customTable"></param>
        public static boolean SetChipType(Chip chipType, double[] customTable)
        {
            if (!(chipType == Chip.AY_Custom || chipType == Chip.YM_Custom) && customTable != null)
            {
                return false;
//                throw new ArgumentException("For non-custom chip type 'customTable' parameter must be null.");
            }

            switch (chipType)
            {
                case AY:
                case AY_Lion17:
                    SetTableAY(LION17_AY_TABLE);
                    break;
                case YM:
                case YM_Lion17:
                    SetTableYM(LION17_YM_TABLE);
                    break;
                case AY_Kay:
                    SetTableAY(KAY_AY_TABLE);
                    break;
                case YM_Kay:
                    SetTableYM(KAY_YM_TABLE);
                    break;
                case AY_Custom:
                    SetTableAY(customTable);
                    break;
                case YM_Custom:
                    SetTableYM(customTable);
                    break;
                default:
                    return false;
//                    throw new ArgumentException("Incorrect chip type.");
            }
            type = chipType;
            defaultChip = false;
            dirty = true;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="chipFreq"></param>
        public void SetChipFreq(int chipFreq)
        {
            ChipFreq = chipFreq;
            dirty = true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stereoType"></param>
        /// <param name="customEQ"></param>
        public boolean SetStereo(Stereo stereoType, int[] customEQ)
        {
            int i;
            int chip;

            if (stereoType != Stereo.StereoCustom && customEQ != null)
            {
                return false;
//                throw new ArgumentException("If stereo type is not custom, 'customEQ' parameter must be null.");
            }

            chip = (type == Chip.AY) ? 0 : 1;

            switch (stereoType)
            {
               
                case Mono:
                case ABC:
                case ACB:
                case BAC:
                case BCA:
                case CAB:
                case CBA:
                    for (i = 0; i < 6; i++)
                        eq[i] = DEFAULT_LAYOUT[chip][(int)stereoType.ordinal()][i];
                    break;
                case StereoCustom:
                    for (i = 0; i < 6; i++)
                        eq[i] = customEQ[i];
                    break;
                default:
                    return false;
//                    throw new ArgumentException("Incorrect stereo type");
            }

            defaultStereo = false;
            dirty = true;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fmt"></param>
        public void SetSoundFormat(SndFmt fmt)
        {
            sndfmt.setChannels(fmt.getChannels());
            sndfmt.setFreq(fmt.getFreq());

            defaultSoundFormat = false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="freq"></param>
        /// <param name="chans"></param>
        /// <param name="bits"></param>
        public void SetSoundFormat(int freq, int chans)
        {
            SndFmt tmp = new SndFmt();

            tmp.setChannels(chans);
            tmp.setFreq(freq);

            SetSoundFormat(tmp);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regs"></param>
        public void SetRegs(int[] regs)
        {
            
            WarnIfRegisterGreaterThan(regs[1], 15, 1);
            WarnIfRegisterGreaterThan(regs[3], 15, 3);
            WarnIfRegisterGreaterThan(regs[5], 15, 3);
            WarnIfRegisterGreaterThan(regs[8], 31, 8);
            WarnIfRegisterGreaterThan(regs[9], 31, 9);
            WarnIfRegisterGreaterThan(regs[10], 31, 10);

            this.regs.setTone_a(regs[0] + ((regs[1] & 0x0f) << 8));
            this.regs.setTone_b( regs[2] + ((regs[3] & 0x0f) << 8));
            this.regs.setTone_c( regs[4] + ((regs[5] & 0x0f) << 8));

            this.regs.setNoise (regs[6] & 0x1f);

            this.regs.setR7_tone_a ((regs[7] & 0x01) == 0 ? 1 : 0);
            this.regs.setR7_tone_b ((regs[7] & 0x02) == 0 ? 1 : 0);
            this.regs.setR7_tone_c ((regs[7] & 0x04) == 0 ? 1 : 0);

            this.regs.setR7_noise_a ((regs[7] & 0x08) == 0 ? 1 : 0);
            this.regs.setR7_noise_b ((regs[7] & 0x10) == 0 ? 1 : 0);
            this.regs.setR7_noise_c ((regs[7] & 0x20) == 0 ? 1 : 0);

            this.regs.setVol_a (regs[8] & 0x0f);
            this.regs.setVol_b (regs[9] & 0x0f);
            this.regs.setVol_c (regs[10] & 0x0f);
            this.regs.setEnv_a ((regs[8] & 0x10));
            this.regs.setEnv_b ((regs[9] & 0x10));
            this.regs.setEnv_c ((regs[10] & 0x10));
            this.regs.setEnv_freq ( regs[11] + (regs[12] << 8));

            if (regs[13] != 0xff)
            {
                /* R13 = 255 means continue curent envelop */
                this.regs.setEnv_style(regs[13] & 0x0f);
                this.env_pos = this.cnt_e = 0;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regValue"></param>
        /// <param name="maxValue"></param>
        /// <param name="regOrder"></param>
        private void WarnIfRegisterGreaterThan(int regValue, int maxValue, int regOrder)
        {
            if (regValue > maxValue)
            {
                System.out.println("SetRegs: warning: possible bad register data R"+regOrder+" > "+maxValue);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="buffer"></param>
        /// <param name="bufSize"></param>
        /// <param name="bufPos"></param>
        /// <returns></returns>
        public int GenSound(double[] buffer, int bufSize, int bufPos)
        {
            prepareGeneration();

            int curPos = bufPos;

            double remaining = 0;

            double mixL, mixR;
            double tempMixL, tempMixR;

            double[] tmpBuf = new double[bufSize];

            double ticksPerSample = ((double)ChipFreq) / sndfmt.getFreq() / 8;            
            int snd_numcount = bufSize / (sndfmt.getChannels());

            double samplesUsed = 0;

            while(snd_numcount-- > 0)
            {
                samplesUsed = -remaining;

                remaining += ticksPerSample;
                mixL = remainderMixL;
                mixR = remainderMixR;

                tempMixL = tempMixR = 0;

                while (remaining > 0)
                {
                    updateCounters();

                    remaining--;
                    samplesUsed++;

                    int volIdx;
                    double lA, rA, lB, rB, lC, rC;
                    lA = lB = lC = rA = rB = rC = 0.0;

                    if (((bit_a | ((regs.getR7_tone_a() == 0) ? 1 : 0)) & (bit_n | ((regs.getR7_noise_a()== 0) ? 1 : 0))) != 0)
                    {
                        volIdx = (regs.getEnv_a() != 0) ? envelope[regs.getEnv_style()][(int)env_pos] : regs.getVol_a() * 2 + 1;
                        lA = vols[0][volIdx];
                        rA = vols[1][ volIdx];
                    }

                    if (((bit_b | ((regs.getR7_tone_b() == 0) ? 1 : 0)) & (bit_n | ((regs.getR7_noise_b()) == 0 ? 1 : 0))) != 0)
                    {
                        volIdx = (regs.getEnv_b() != 0) ? envelope[regs.getEnv_style()][(int)env_pos] : regs.getVol_b() * 2 + 1;
                        lB = vols[2][volIdx];
                        rB = vols[3][volIdx];
                    }

                    if (((bit_c | ((regs.getR7_tone_c() == 0) ? 1 : 0)) & (bit_n | ((regs.getR7_noise_c()) == 0 ? 1 : 0))) != 0)
                    {
                        volIdx = (regs.getEnv_c() != 0) ? envelope[regs.getEnv_style()][(int)env_pos] : regs.getVol_c() * 2 + 1;
                        lC = vols[4][volIdx];
                        rC = vols[5][volIdx];
                    }

                    tempMixL = (lA + lB + lC) / 3;
                    tempMixR = (rA + rB + rC) / 3;

                    if (remaining <= 0)
                    {
                        remainderMixL = (-remaining) * tempMixL;
                        remainderMixR = (-remaining) * tempMixR;

                        tempMixL = (1 + remaining) * tempMixL;
                        tempMixR = (1 + remaining) * tempMixR;

                        samplesUsed += remaining;
                    }

                    mixL += tempMixL;
                    mixR += tempMixR;
                }

                mixL /= samplesUsed;
                mixR /= samplesUsed;

                buffer[curPos++] = mixL;
                if (sndfmt.getChannels() != 1)
                {
                    buffer[curPos++] = mixR;
                }
            }

            return curPos;
        }

        public int GenSound(byte[] buffer, int bufSize, int bufPos)
        {
            prepareGeneration();

            int curPos = bufPos;

            double remaining = 0;

            double mixL, mixR;
            double tempMixL, tempMixR;

            double[] tmpBuf = new double[bufSize];

            double ticksPerSample = ((double)ChipFreq) / sndfmt.getFreq() / 8;            
            int snd_numcount = bufSize / (sndfmt.getChannels());

            double samplesUsed = 0;

            while(snd_numcount-- > 0)
            {
                samplesUsed = -remaining;

                remaining += ticksPerSample;
                mixL = remainderMixL;
                mixR = remainderMixR;

                tempMixL = tempMixR = 0;

                while (remaining > 0)
                {
                    updateCounters();

                    remaining--;
                    samplesUsed++;

                    int volIdx;
                    double lA, rA, lB, rB, lC, rC;
                    lA = lB = lC = rA = rB = rC = 0.0;

                    if (((bit_a | ((regs.getR7_tone_a() == 0) ? 1 : 0)) & (bit_n | ((regs.getR7_noise_a()== 0) ? 1 : 0))) != 0)
                    {
                        volIdx = (regs.getEnv_a() != 0) ? envelope[regs.getEnv_style()][(int)env_pos] : regs.getVol_a() * 2 + 1;
                        lA = vols[0][volIdx];
                        rA = vols[1][ volIdx];
                    }

                    if (((bit_b | ((regs.getR7_tone_b() == 0) ? 1 : 0)) & (bit_n | ((regs.getR7_noise_b()) == 0 ? 1 : 0))) != 0)
                    {
                        volIdx = (regs.getEnv_b() != 0) ? envelope[regs.getEnv_style()][(int)env_pos] : regs.getVol_b() * 2 + 1;
                        lB = vols[2][volIdx];
                        rB = vols[3][volIdx];
                    }

                    if (((bit_c | ((regs.getR7_tone_c() == 0) ? 1 : 0)) & (bit_n | ((regs.getR7_noise_c()) == 0 ? 1 : 0))) != 0)
                    {
                        volIdx = (regs.getEnv_c() != 0) ? envelope[regs.getEnv_style()][(int)env_pos] : regs.getVol_c() * 2 + 1;
                        lC = vols[4][volIdx];
                        rC = vols[5][volIdx];
                    }

                    tempMixL = (lA + lB + lC) / 3;
                    tempMixR = (rA + rB + rC) / 3;

                    if (remaining <= 0)
                    {
                        remainderMixL = (-remaining) * tempMixL;
                        remainderMixR = (-remaining) * tempMixR;

                        tempMixL = (1 + remaining) * tempMixL;
                        tempMixR = (1 + remaining) * tempMixR;

                        samplesUsed += remaining;
                    }

                    mixL += tempMixL;
                    mixR += tempMixR;
                }

                mixL /= samplesUsed;
                mixR /= samplesUsed;

                // how can it be that sound is more than 1.000???
                
                mixL *= 0.80;
                mixR *= 0.80;
                    
                if (!config.psgSound)
                {
                    mixL = 0;
                    mixR = 0;
                }
                
                
                int oneSample16Bit = (int)(mixL*32767);

                if (oneSample16Bit>32767) 
                {
                    System.out.println(":"+oneSample16Bit);
                    oneSample16Bit = 32767;
                    
                }
                if (oneSample16Bit<-32768) 
                {
                    System.out.println(":"+oneSample16Bit);
                    oneSample16Bit = -32768;
                }

                    
                    
                buffer[(curPos++)] = (byte)(oneSample16Bit&0xff);
                buffer[(curPos++)] = (byte)((oneSample16Bit>>8)&0xff);
                
                
                if (sndfmt.getChannels() != 1)
                {
                    oneSample16Bit = (int)(mixR*32767);
                    buffer[(curPos++)] = (byte)(oneSample16Bit&0xff);
                    buffer[(curPos++)] = (byte)((oneSample16Bit>>8)&0xff);
                }
            }

            return curPos;
        }
        private void updateCounters()
        {
            cnt_a++;
            if (cnt_a >= regs.getTone_a())
            {
                cnt_a = 0;
                bit_a ^= 1;
            }

            cnt_b++;
            if (cnt_b >= regs.getTone_b())
            {
                cnt_b = 0;
                bit_b ^= 1;
            }

            cnt_c++;
            if (cnt_c >= regs.getTone_c())
            {
                cnt_c = 0;
                bit_c ^= 1;
            }

            /* GenNoise (c) Hacker KAY & Sergey Bulba */
            cnt_n++;
            if (regs.getNoise() != 0 && cnt_n >= regs.getNoise())
            {
                cnt_n = 0;
                bit_n ^= (noiseSeed & 1);
                noiseSeed = ((noiseSeed >> 1)  + (((noiseSeed ^ (noiseSeed >> 3)) & 1) << 16)) & 0x01FFFF;
            }

            cnt_e++;
            if (cnt_e >= regs.getEnv_freq())
            {
                cnt_e = 0;
                if (++env_pos > 127)
                    env_pos = 64;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void prepareGeneration()
        {
            if (!dirty) return;

            if (!envGenInit) genEnv();

            if (defaultChip)
                SetChipType(Chip.AY, null);

            if (defaultStereo)
                SetStereo(Stereo.ABC, null);

            if (defaultSoundFormat)
                SetSoundFormat(44100, 1);

            /* GenVols */
            int n, m;

            for (n = 0; n < 32; n++)
            {
                for (m = 0; m < 6; m++)
                {
                    vols[m][n] = table[n] * eq[m];
                }
            }

            dirty = false;
        }

        /// <summary>
        /// Populate envelope tables. Should be executed only once.
        /// </summary>
        private void genEnv()
        {
            int env;
            int pos;
            boolean hold;
            int dir;
            int vol;

            for (env = 0; env < 16; env++)
            {
                hold = false;
                dir = ((env & 4) == 4) ? 1 : -1;
                vol = ((env & 4) == 4) ? -1 : 32;
                for (pos = 0; pos < 128; pos++)
                {
                    if (!hold)
                    {
                        vol += dir;
                        if (vol < 0 || vol >= 32)
                        {
                            if ((env & 8) == 8)
                            {
                                if ((env & 2) == 2) dir = -dir;

                                vol = (dir > 0) ? 0 : 31;

                                if ((env & 1) == 1)
                                {
                                    hold = true;
                                    vol = (dir > 0) ? 31 : 0;
                                }
                            }
                            else
                            {
                                vol = 0;
                                hold = true;
                            }
                        }
                    }
                    envelope[env][pos] = vol;
                }
            }

            envGenInit = true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tbl"></param>
        private static void SetTableAY(double[] tbl)
        {
            int n;
            for (n = 0; n < 32; n++)
                table[n] = tbl[n / 2];
            type = Chip.AY;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tbl"></param>
        private static void SetTableYM(double[] tbl)
        {
            int n;
            for (n = 0; n < 32; n++)
                table[n] = tbl[n];
            type = Chip.YM;
        }

        // Tables:
        /* AY volume table (c) by V_Soft and Lion 17 */
        public static double[] LION17_AY_TABLE = { 0, 0.007827878, 0.01263447, 0.018905928, 
                                                   0.029343099, 0.049408713, 0.075165942, 0.139009689, 
                                                   0.157839322, 0.272770275, 0.376623178, 0.464515145, 
                                                   0.592721447, 0.721293965, 0.860639353, 1};

        /* YM volume table (c) by V_Soft and Lion 17 */
        public static double[] LION17_YM_TABLE = { 0, 0, 0.002899214, 0.00436408, 
                                                   0.005722133, 0.00717174, 0.008545052, 0.010131991, 
                                                   0.013214313, 0.017242695, 0.023117418, 0.027512016, 
                                                   0.034378576, 0.043457694, 0.051132982, 0.058930343, 
                                                   0.073914702, 0.092439155, 0.11123827, 0.130601968, 
                                                   0.159822995, 0.196505684, 0.233417258, 0.271412222, 
                                                   0.328068971, 0.399359121, 0.47098497, 0.544380865, 
                                                   0.65101091, 0.77799649, 0.897871366, 1 };
        /* AY volume table (c) by Hacker KAY */
        public static double[] KAY_AY_TABLE = { 0, 0.012756542, 0.018493935, 0.027054246, 
                                                0.039963378, 0.05912871, 0.082352941, 0.13463035, 
                                                0.158571756, 0.25491722, 0.356130312, 0.446967269, 
                                                0.56411078, 0.708339055, 0.842221714, 1 };

        /* YM volume table (c) by Hacker KAY */
        public static double[] KAY_YM_TABLE = { 0, 0, 0.003784237, 0.00686656, 0.010223545, 0.012603952, 0.015411612, 
                                                0.018905928, 0.023682002, 0.029282063, 0.035309377, 0.040070192, 0.047775998,
                                                0.057648585, 0.067246509, 0.076768139, 0.091065843, 0.109269856, 0.128404669, 
                                                0.146822309, 0.174273289, 0.208880751, 0.243488212, 0.27893492, 0.332021057, 0.398992905,
                                                0.465751125, 0.532219425, 0.632242313, 0.753856718, 0.877271687, 1 };

        /* default equlaizer (layout) settings for AY and YM, 7 stereo types */
        public static double[][][] DEFAULT_LAYOUT = new double[][][] {
            new double [][] {
                /* A_l, A_r,  B_l, B_r,  C_l, C_r */
                /* for AY */
                new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },            // MONO
                new double[] { 1.0, 0.35, 0.7, 0.7, 0.35, 1.0 },    // ABC
                new double[] { 1.0, 0.35, 0.35, 1.0, 0.7, 0.7 },    // ACB
                new double[] { 0.7, 0.7, 1.0, 0.35, 0.35, 1.0 },    // BAC
                new double[] { 0.35, 1.0, 1.0, 0.35, 0.7, 0.7 },    // BCA
                new double[] { 0.7, 0.7, 0.35, 1.0, 1.0, 0.35 },    // CAB
                new double[] { 0.35, 1.0, 0.7, 0.7, 1.0, 0.35 }     // CBA
            },
            new double [][] {
                /* for YM */
                new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },      // MONO
                new double[] { 1.0, 0.5, 0.7, 0.7, 0.5, 1.0 },    // ABC
                new double[] { 1.0, 0.5, 0.5, 1.0, 0.7, 0.7 },    // ACB
                new double[] { 0.7, 0.7, 1.0, 0.5, 0.5, 1.0 },    // BAC
                new double[] { 0.5, 1.0, 1.0, 0.5, 0.7, 0.7 },    // BCA
                new double[] { 0.7, 0.7, 0.5, 1.0, 1.0, 0.5 },    // CAB
                new double[] { 0.5, 1.0, 0.7, 0.7, 1.0, 0.5 }     // CBA
            }
        };

    }