package de.malban.vide.vecx;

// java does not know about "unsigned"

import de.malban.sound.tinysound.Stream;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.vecx.devices.VectrexJoyport;
import de.malban.vide.VideConfig;

// all data is kept as INT
// of smaller values are needed, they must be converted where USED!

/**
 *
 * @author Malban
 */
public class E8910 extends E8910State implements E8910Statics
{
    /***************************************************************************
      ay8910.c

      Emulation of the AY-3-8910 / YM2149 sound chip.

      Based on various code snippets by Ville Hallik, Michael Cuddy,
      Tatsuyuki Satoh, Fabrice Frances, Nicola Salmoria.
    ***************************************************************************/

    VideConfig config = VideConfig.getConfig();
    transient int MAX_DIGIT_BUFFER = 60000;
    transient int[] digitByte = new int[MAX_DIGIT_BUFFER];
    transient int digitByteCounter =0;       
    transient VectrexJoyport[] joyport;
    
    transient Stream line=null;
    transient byte[] soundBytes = new byte[0];
    
    
    static int OVERSAMPLE = 4096;
    int maxpsg = -1;
    
    public void reset()
    {
        joyport = null;
    }
    
    public void setVectrexJoyport(VectrexJoyport[] j)
    {
        joyport = j;
        if (joyport == null) return;
        if (joyport[0] != null) 
        {
            joyport[0].reset();
            joyport[0].setInputMode((snd_regs[AY_ENABLE] & 0x40 ) == 0);
            
        }
        if (joyport[1] != null)    
        {
            joyport[1].reset();
            joyport[1].setInputMode((snd_regs[AY_ENABLE] & 0x40 ) == 0);
        }
    }
    
    int reg14In = 0xff;
    int reg14Out = 0xff;
    // called from vectrex when
    // BCDIR, BC == 11
    // and a reg=14 is read from PSG
    private void readDataToPSGFromPortA()
    {
        int val = 0;
        // we let the adapter decide what bits to change in reg 14
        if (joyport[0] != null) 
        {
           if (joyport[0].isButton1(false)) val += 0x01;
           if (joyport[0].isButton2(false)) val += 0x02;
           if (joyport[0].isButton3(false)) val += 0x04;
           if (joyport[0].isButton4(false)) val += 0x08;
        }
        if (joyport[1] != null) 
        {
           if (joyport[1].isButton1(false)) val += 0x10;
           if (joyport[1].isButton2(false)) val += 0x20;
           if (joyport[1].isButton3(false)) val += 0x40;
           if (joyport[1].isButton4(false)) val += 0x80;
        }
        snd_regs[14] = val;
        reg14In = val;
    }

    private void writeDataFromPSGToPortA()
    {
        if (joyport == null) return;
        if (joyport[0] != null)
        {
            boolean b1 = (reg14Out&0x01)==0x01;
            boolean b2 = (reg14Out&0x02)==0x02;
            boolean b3 = (reg14Out&0x04)==0x04;
            boolean b4 = (reg14Out&0x08)==0x08;
            joyport[0].setButton1(b1, false);
            joyport[0].setButton2(b2, false);
            joyport[0].setButton3(b3, false);
            joyport[0].setButton4(b4, false);
        }
        if (joyport[1] != null)
        {
            boolean b1 = (reg14Out&0x10)==0x10;
            boolean b2 = (reg14Out&0x20)==0x20;
            boolean b3 = (reg14Out&0x40)==0x40;
            boolean b4 = (reg14Out&0x80)==0x80;
            joyport[1].setButton1(b1, false);
            joyport[1].setButton2(b2, false);
            joyport[1].setButton3(b3, false);
            joyport[1].setButton4(b4, false);
        }        
    }
    
    public int read(int reg)
    {
        if (reg != 14) return snd_regs[reg];
        readDataToPSGFromPortA();
    
        if  ((snd_regs[AY_ENABLE] & 0x40 ) ==  0x00)
        {
            // input mode
            return reg14In;//snd_regs[14];
        }
        // output mode
// att!
           return reg14In;//snd_regs[14];
//        return 0xff;
    }
    
    public void e8910_write(int r, int v)
    {
        int old;

        if (snd_regs == null) return;
        if (r == 14) // port A activity
        {
            // if bit 6 (Reg 7 ENABLE PORTA) is 0
            // than port A is in input mode, 
            // input mode means portAa wants to RECEIVE data from a connected device
            //
            // if bit 6 (Reg 7 ENABLE PORTA) is 1
            // than port A is in output mode, meaning
            // the register 14 receives data from vectrex via Reg14 (14 must be latched)
            //
            // thus reg 14 can only be written to when in output mode
            if  ((snd_regs[AY_ENABLE] & 0x40 ) ==  0x40)
            {
                // output mode
                reg14Out = v;
                writeDataFromPSGToPortA();
            }
            else
            {
                // input mode
                
                // portA outData can be written to psg even when in input mode... strange
                // but read SHOULD be 0xff (see above)
                reg14Out = v;
                writeDataFromPSGToPortA();
            }
            return;
        }
        
        
        // 255 dummy register for "path thru data to sound direct
        if ((r != 255) && (digitByteCounter != 0))
        {
            digitByteCounter = 0; // counter 0 == NO digitizing active
        }
        if (r == 255)
        {
            // sound sample is acive
            if (digitByteCounter>=MAX_DIGIT_BUFFER) return;
            if (digitByteCounter==-1) digitByteCounter =0; // -1 means digitizing active, but buffer was reset
            digitByte[digitByteCounter++] = v;
            return;
        }
        int oldReg = snd_regs[r];
        
        if (r<15)
        {
            if (oldReg != v)
                updateSound(); // update befor register data changes
        }
        
        snd_regs[r] = v;

        /* A note about the period of tones, noise and envelope: for speed reasons,*/
        /* we count down from the period to 0, but careful studies of the chip     */
        /* output prove that it instead counts up from 0 until the counter becomes */
        /* greater or equal to the period. This is an important difference when the*/
        /* program is rapidly changing the period to modulate the sound.           */
        /* To compensate for the difference, when the period is changed we adjust  */
        /* our internal counter.                                                   */
        /* Also, note that period = 0 is the same as period = 1. This is mentioned */
        /* in the YM2203 data sheets. However, this does NOT apply to the Envelope */
        /* period. In that case, period = 0 is half as period = 1. */
        switch( r )
        {
            case AY_AFINE:
            case AY_ACOARSE:
                snd_regs[AY_ACOARSE] &= 0x0f;
                old = PSG.PeriodA;
                PSG.PeriodA = (snd_regs[AY_AFINE] + 256 * snd_regs[AY_ACOARSE])*STEP3;
                if (PSG.PeriodA == 0) PSG.PeriodA =STEP3;
                PSG.CountA += PSG.PeriodA - old;
                if (PSG.CountA <= 0) PSG.CountA = 1;
                break;
            case AY_BFINE:
            case AY_BCOARSE:
                snd_regs[AY_BCOARSE] &= 0x0f;
                old = PSG.PeriodB;
                PSG.PeriodB = (snd_regs[AY_BFINE] + 256 * snd_regs[AY_BCOARSE])*STEP3;
                if (PSG.PeriodB == 0) PSG.PeriodB = STEP3;
                PSG.CountB += PSG.PeriodB - old;
                if (PSG.CountB <= 0) PSG.CountB = 1;
                break;
            case AY_CFINE:
            case AY_CCOARSE:
                snd_regs[AY_CCOARSE] &= 0x0f;
                old = PSG.PeriodC;
                PSG.PeriodC = (snd_regs[AY_CFINE] + 256 * snd_regs[AY_CCOARSE])*STEP3;
                if (PSG.PeriodC == 0) PSG.PeriodC = STEP3;
                PSG.CountC += PSG.PeriodC - old;
                if (PSG.CountC <= 0) PSG.CountC = 1;
                break;
            case AY_NOISEPER:
                snd_regs[AY_NOISEPER] &= 0x1f;
                old = PSG.PeriodN;
                PSG.PeriodN = snd_regs[AY_NOISEPER] * STEP3;
                if (PSG.PeriodN == 0) PSG.PeriodN = STEP3;
                PSG.CountN += PSG.PeriodN - old;
                if (PSG.CountN <= 0) PSG.CountN = 1;
                break;
            case AY_AVOL:
                snd_regs[AY_AVOL] &= 0x1f;
                PSG.EnvelopeA = snd_regs[AY_AVOL] & 0x10;
                PSG.VolA = (PSG.EnvelopeA!=0) ? PSG.VolE : VolTable[(snd_regs[AY_AVOL]!=0) ? snd_regs[AY_AVOL]*2 : 0];
                break;
            case AY_BVOL:
                snd_regs[AY_BVOL] &= 0x1f;
                PSG.EnvelopeB = snd_regs[AY_BVOL] & 0x10;
                PSG.VolB = (PSG.EnvelopeB!=0) ? PSG.VolE : VolTable[(snd_regs[AY_BVOL]!=0) ? snd_regs[AY_BVOL]*2 : 0];
                break;
            case AY_CVOL:
                snd_regs[AY_CVOL] &= 0x1f;
                PSG.EnvelopeC = snd_regs[AY_CVOL] & 0x10;
                PSG.VolC = (PSG.EnvelopeC!=0) ? PSG.VolE : VolTable[(snd_regs[AY_CVOL]!=0) ? snd_regs[AY_CVOL]*2 : 0];
                break;
            case AY_EFINE:
            case AY_ECOARSE:
                old = PSG.PeriodE;
                PSG.PeriodE = ((snd_regs[AY_EFINE] + 256 * snd_regs[AY_ECOARSE]))* STEP3;
                if (PSG.PeriodE == 0) PSG.PeriodE = STEP3/2;
                if (PSG.PeriodE == 0) PSG.PeriodE = 1;
                PSG.CountE += PSG.PeriodE - old;
                if (PSG.CountE <= 0) PSG.CountE = 1;
                break;
            case AY_ESHAPE:
                /* envelope shapes:
                 C AtAlH
                 0 0 x x  \___

                 0 1 x x  /___

                 1 0 0 0  \\\\

                 1 0 0 1  \___

                 1 0 1 0  \/\/
                 ___
                 1 0 1 1  \

                 1 1 0 0  ////
                 ___
                 1 1 0 1  /

                 1 1 1 0  /\/\

                 1 1 1 1  /___

                 The envelope counter on the AY-3-8910 has 16 steps. On the YM2149 it
                 has twice the steps, happening twice as fast. Since the end result is
                 just a smoother curve, we always use the YM2149 behaviour.
                 */
                snd_regs[AY_ESHAPE] &= 0x0f;
                PSG.CountEnv = 0x1f;
                PSG.CountE = PSG.PeriodE;
                PSG.Continue = 0;

                
                PSG.Attack = ((snd_regs[AY_ESHAPE] & 0x04)!=0) ? 0x1f : 0x00;

                if ((snd_regs[AY_ESHAPE] & 0x08) == 0)
                {
                    /* if Continue = 0, map the shape to the equivalent one which has Continue = 1 */
                    PSG.Hold = 1;
                    PSG.Alternate = PSG.Attack;
                }
                else
                {
                    PSG.Hold = snd_regs[AY_ESHAPE] & 0x01;
                    PSG.Alternate = snd_regs[AY_ESHAPE] & 0x02;
                }
                PSG.VolE = VolTable[PSG.CountEnv ^ PSG.Attack];
                if (PSG.EnvelopeA!=0) 
                    PSG.VolA = PSG.VolE;
                if (PSG.EnvelopeB!=0) 
                    PSG.VolB = PSG.VolE;
                if (PSG.EnvelopeC!=0) 
                    PSG.VolC = PSG.VolE;
                break;
            case AY_ENABLE:
            {
                if ((oldReg & 0x40) != (snd_regs[AY_ENABLE] & 0x40 ))
                {
                    // we are switching IO of port a from one state to the other
                    if (joyport[0] != null) joyport[0].setInputMode((snd_regs[AY_ENABLE] & 0x40 ) == 0);
                    if (joyport[1] != null) joyport[1].setInputMode((snd_regs[AY_ENABLE] & 0x40 ) == 0);

                    if  ((snd_regs[AY_ENABLE] & 0x40 ) == 0) // input mode
                    {
                        readDataToPSGFromPortA();
                    }
                    else // output mode
                    {
                        writeDataFromPSGToPortA();
                    }
                }
                break;
            }
            case AY_PORTA:
                break;
            case AY_PORTB:
                break;
        }
    }
    private void e8910_callback_8(byte[] stream, int length)
    {
        int outn;
        int memPointer = 0;
        int lengthOrg = length;
        /* hack to prevent us from hanging when starting filtered outputs */
        if (PSG.ready==0)
        {
            for (int i=0; i< length;i++)stream[i]=0;
            return;
        }
//        length = length * 2;

        /* The 8910 has three outputs, each output is the mix of one of the three */
        /* tone generators and of the (single) noise generator. The two are mixed */
        /* BEFORE going into the DAC. The formula to mix each channel is: */
        /* (ToneOn | ToneDisable) & (NoiseOn | NoiseDisable). */
        /* Note that this means that if both tone and noise are disabled, the output */
        /* is 1, not 0, and can be modulated changing the volume. */


        /* If the channels are disabled, set their output to 1, and increase the */
        /* counter, if necessary, so they will not be inverted during this update. */
        /* Setting the output to 1 is necessary because a disabled channel is locked */
        /* into the ON state (see above); and it has no effect if the volume is 0. */
        /* If the volume is 0, increase the counter, but don't touch the output. */
        if ((snd_regs[AY_ENABLE] & 0x01)!=0)
        {
            if (PSG.CountA <= length) PSG.CountA += length;
            PSG.OutputA = 1;
        }
        else if (snd_regs[AY_AVOL] == 0)
        {
            /* note that I do count += length, NOT count = length + 1. You might think */
            /* it's the same since the volume is 0, but doing the latter could cause */
            /* interferencies when the program is rapidly modulating the volume. */
            if (PSG.CountA <= length) 
                PSG.CountA += length;
        }
        if ((snd_regs[AY_ENABLE] & 0x02)!=0)
        {
            if (PSG.CountB <= length) PSG.CountB += length;
            PSG.OutputB = 1;
        }
        else if (snd_regs[AY_BVOL] == 0)
        {
            if (PSG.CountB <= length) PSG.CountB += length;
        }
        if ((snd_regs[AY_ENABLE] & 0x04)!=0)
        {
            if (PSG.CountC <= length) PSG.CountC += length;
            PSG.OutputC = 1;
        }
        else if (snd_regs[AY_CVOL] == 0)
        {
            if (PSG.CountC <= length) PSG.CountC += length;
        }

        /* for the noise channel we must not touch OutputN - it's also not necessary */
        /* since we use outn. */
        if ((snd_regs[AY_ENABLE] & 0x38) == 0x38)	/* all off */
            if (PSG.CountN <= length) PSG.CountN += length;

        outn = (PSG.OutputN | snd_regs[AY_ENABLE]);

        /* buffering loop */
        while (length > 0)
        {
            int vol;
            int left  = 2;
            /* vola, volb and volc keep track of how long each square wave stays */
            /* in the 1 position during the sample period. */

            int vola,volb,volc;
            vola = volb = volc = 0;

            do
            {
                int nextevent;

                if (PSG.CountN < left) nextevent = PSG.CountN;
                else nextevent = left;

                if ((outn & 0x08)!=0)
                {
                    if (PSG.OutputA!=0) 
                        vola += PSG.CountA;
                    PSG.CountA -= nextevent;
                    /* PeriodA is the half period of the square wave. Here, in each */
                    /* loop I add PeriodA twice, so that at the end of the loop the */
                    /* square wave is in the same status (0 or 1) it was at the start. */
                    /* vola is also incremented by PeriodA, since the wave has been 1 */
                    /* exactly half of the time, regardless of the initial position. */
                    /* If we exit the loop in the middle, OutputA has to be inverted */
                    /* and vola incremented only if the exit status of the square */
                    /* wave is 1. */
                    while (PSG.CountA <= 0)
                    {
                        PSG.CountA += PSG.PeriodA;
                        if (PSG.CountA > 0)
                        {
                            PSG.OutputA ^= 1;
                            if (PSG.OutputA!=0) 
                                vola += PSG.PeriodA;
                            break;
                        }
                        PSG.CountA += PSG.PeriodA;
                        vola += PSG.PeriodA;
                    }
                    if (PSG.OutputA!=0) 
                        vola -= PSG.CountA;
                }
                else
                {
                    PSG.CountA -= nextevent;
                    while (PSG.CountA <= 0)
                    {
                        PSG.CountA += PSG.PeriodA;
                        if (PSG.CountA > 0)
                        {
                            PSG.OutputA ^= 1;
                            break;
                        }
                        PSG.CountA += PSG.PeriodA;
                    }
                }

                if ((outn & 0x10)!=0)
                {
                    if (PSG.OutputB!=0) 
                        volb += PSG.CountB;
                    PSG.CountB -= nextevent;
                    while (PSG.CountB <= 0)
                    {
                        PSG.CountB += PSG.PeriodB;
                        if (PSG.CountB > 0)
                        {
                            PSG.OutputB ^= 1;
                            if (PSG.OutputB!=0) 
                                volb += PSG.PeriodB;
                            break;
                        }
                        PSG.CountB += PSG.PeriodB;
                        volb += PSG.PeriodB;
                    }
                    if (PSG.OutputB!=0) 
                        volb -= PSG.CountB;
                }
                else
                {
                    PSG.CountB -= nextevent;
                    while (PSG.CountB <= 0)
                    {
                        PSG.CountB += PSG.PeriodB;
                        if (PSG.CountB > 0)
                        {
                            PSG.OutputB ^= 1;
                            break;
                        }
                        PSG.CountB += PSG.PeriodB;
                    }
                }

                if ((outn & 0x20)!=0)
                {
                    if (PSG.OutputC!=0) 
                        volc += PSG.CountC;
                    PSG.CountC -= nextevent;
                    while (PSG.CountC <= 0)
                    {
                        PSG.CountC += PSG.PeriodC;
                        if (PSG.CountC > 0)
                        {
                            PSG.OutputC ^= 1;
                            if (PSG.OutputC!=0) 
                                volc += PSG.PeriodC;
                            break;
                        }
                        PSG.CountC += PSG.PeriodC;
                        volc += PSG.PeriodC;
                    }
                    if (PSG.OutputC!=0) 
                        volc -= PSG.CountC;
                }
                else
                {
                    PSG.CountC -= nextevent;
                    while (PSG.CountC <= 0)
                    {
                        PSG.CountC += PSG.PeriodC;
                        if (PSG.CountC > 0)
                        {
                            PSG.OutputC ^= 1;
                            break;
                        }
                        PSG.CountC += PSG.PeriodC;
                    }
                }

                PSG.CountN -= nextevent;
                if (PSG.CountN <= 0)
                {
                    /* Is noise output going to change? */
                    if (((PSG.RNG + 1) & 2)!=0)	/* (bit0^bit1)? */
                    {
                        PSG.OutputN = ~PSG.OutputN;
                        outn = (PSG.OutputN | snd_regs[AY_ENABLE]);
                    }

                    /* The Random Number Generator of the 8910 is a 17-bit shift */
                    /* register. The input to the shift register is bit0 XOR bit3 */
                    /* (bit0 is the output). This was verified on AY-3-8910 and YM2149 chips. */

                    /* The following is a fast way to compute bit17 = bit0^bit3. */
                    /* Instead of doing all the logic operations, we only check */
                    /* bit0, relying on the fact that after three shifts of the */
                    /* register, what now is bit3 will become bit0, and will */
                    /* invert, if necessary, bit14, which previously was bit17. */
                    if ((PSG.RNG & 1)!=0) PSG.RNG ^= 0x24000; /* This version is called the "Galois configuration". */
                    PSG.RNG >>= 1;
                    PSG.CountN += PSG.PeriodN;
                }

                left -= nextevent;
            } while (left > 0);

            /* update envelope */
            // this continue is NOT the PSG envelope flag continue
            // since the "real" continue is "changed" to reflect the corresponding other
            // attacks
            // this continue is a flag whether a continue state was REACHED
            if (PSG.Continue == 0)
            {
                PSG.CountE -= STEP;
                if (PSG.CountE <= 0)
                {
                    do
                    {
                        PSG.CountEnv--;
                        
                        PSG.CountE += PSG.PeriodE;
                    } while (PSG.CountE <= 0);

                    /* check envelope current position */
                    if (PSG.CountEnv < 0)
                    {
                        if (PSG.Hold!=0)
                        {
                            if (PSG.Alternate!=0)
                                PSG.Attack ^= 0x1f;
                            PSG.Continue = 1;
                            PSG.CountEnv = 0;
                        }
                        else
                        {
                            /* if CountEnv has looped an odd number of times (usually 1), */
                            /* invert the output. */
                            if ((PSG.Alternate!=0) && ((PSG.CountEnv & 0x20)!=0))
                                PSG.Attack ^= 0x1f;

                            PSG.CountEnv &= 0x1f;
                        }
                    }
                    PSG.VolE = VolTable[PSG.CountEnv ^ PSG.Attack];
                    /* reload volume */
                    if (PSG.EnvelopeA!=0) 
                        PSG.VolA = PSG.VolE;
                    if (PSG.EnvelopeB!=0) 
                        PSG.VolB = PSG.VolE;
                    if (PSG.EnvelopeC!=0) 
                        PSG.VolC = PSG.VolE;
                }
            }
//System.out.println("VolE: "+PSG.VolE);
            
            int enableA = 0;
            int enableB = 0;
            int enableC = 0;
            if ((((snd_regs[AY_ENABLE] & 0x01) == 0) || ( (snd_regs[AY_ENABLE] & 0x08) == 0) ))enableA = 1;
            if ((((snd_regs[AY_ENABLE] & 0x02) == 0) || ( (snd_regs[AY_ENABLE] & 0x10) == 0) ))enableB = 1;
            if ((((snd_regs[AY_ENABLE] & 0x04) == 0) || ( (snd_regs[AY_ENABLE] & 0x20) == 0) ))enableC = 1;
            
            
            vol = (vola*enableA * PSG.VolA + volb*enableB * PSG.VolB + volc*enableC * PSG.VolC) / (3*STEP);
//System.out.println("vola: "+vola+"*"+PSG.VolA +"="+(enableA*vola * PSG.VolA));            
            // vol is 12 bit positive volume! (max 4095)
            // PSG output is signed
            // but allways positive!
//            if ((--length & 1) !=0)
            if (--length !=0)
            {
                int vol8BitSigned = ((vol >> 5))&0xff;
                if (config.psgSound)
                    stream[memPointer++] = (byte)(vol8BitSigned);
                else
                    stream[memPointer++] = (byte)0;
            }
        }
        
        // small sample counts are ignored!
        if ((digitByteCounter>15) ) // are there any samples?
        {
            double sampleScale = ((double)digitByteCounter) / ((double) lengthOrg);
            int i=0;
            // we fill the needed sample buffer
            // with as many samples as we have
            // each sample may be "stretched" to fill the buffer
            // it is NOT considered how long (in cycles) a sample "stayed" for digital output
            // all samples are considered to have the same "length"
            double sampleCounter = 0;

            // samples come from the DAC (more or less)
            // therefor samples are signed 8bit samples, -128 - +127
            // output line is done in signed 8bit samples (PSG has signed output) [although the output is allways positive]
            // and our data here is ORer with
            // PSG out
            double volDigital = 1.0;
            if (config.generation==3) volDigital = 0.2;
            while (i<lengthOrg) 
            {
//                int signed8BitSample = digitByte[(int)sampleCounter];
                double signed8BitSampleVolumne = digitByte[(int)sampleCounter]*volDigital;
                byte sampleValueVolumne8BitSigned = (byte)(( ((byte ) signed8BitSampleVolumne)) & 0xff); // UNSIGNED
                sampleCounter += sampleScale;
                
                // for now a sample just overwrites PSG
                stream[i] = sampleValueVolumne8BitSigned;
                i++;
            }
        }
        digitByteCounter = -1;
    }
    public void e8910_callback(byte[] stream, int length)
    {
        if (!is16Bit) e8910_callback_8(stream, length);
        else e8910_callback_16(stream, length/2); // in word length instead of byte length
    }    

    public void e8910_init_sound()
    {
        PSG.RNG  = 1;
        PSG.OutputA = 0;
        PSG.OutputB = 0;
        PSG.OutputC = 0;
        PSG.OutputN = 0xff;
        PSG.ready = 1;
        PSG.PeriodA = 1;
        PSG.PeriodB = 1;
        PSG.PeriodC = 1;
        PSG.PeriodE = 1;
        PSG.PeriodN = 1;
        if (is16Bit)
            STEP3 = OVERSAMPLE * 44100 / (1500000/8);
        else
            STEP3 = 1;

        VolTable = new int[32];
        int i;
        double out;

        /* calculate the volume->voltage conversion table */
        /* The AY-3-8910 has 16 levels, in a logarithmic scale (3dB per STEP) */
        /* The YM2149 still has 16 levels for the tone generators, but 32 for */
        /* the envelope generator (1.5dB per STEP). */
        out = MAX_OUTPUT;
        for (i = 31;i > 0;i--)
        {
            VolTable[i] = (int) (out + 0.5);	/* round to nearest */
            out /= 1.188502227;	/* = 10 ^ (1.5/20) = 1.5dB */
        }
        VolTable[0] = 0;
        MAX_OUTPUT = is16Bit?0x7fff:0x0fff;
        
        e8910_done_sound();
        if (TinySound.isInitialized())
        {
            soundBytes = new byte[getSoundBufferSize()];
            line = getVectrexLine();
            line.start();
        }
    }

    public void updateSound()
    {
        if (line == null) return;
        synchronized (line)
        {
            double v =  ((double) config.psgVolume)/(double)255.0;                            
            line.setVolume(v);
            int soundLength = line.available(); // in bytes
            int bufLength = soundBytes.length; // in bytes
            soundLength = soundLength >bufLength ? bufLength : soundLength;
            if (soundLength>0)
            {
                e8910_callback(soundBytes, soundLength);
                line.write(soundBytes, 0, soundLength);
            }
        }
    }
    
    
    public void e8910_done_sound()
    {
        if (line != null)
            line.unload();
        line = null;
    }
    
    
    static int SAMPLERATE = 44100;
    static int UPDATE_PER_SECOND = 1000/25; // tinysound updates each 25ms 
    
    public int getSoundBufferSize()
    {
        if (!is16Bit)
        {
            int SOUNDBUFFER_SIZE = 882*4;
            return SOUNDBUFFER_SIZE;
        }
        int SOUNDBUFFER_SIZE = de.malban.vide.vedi.sound.ibxm.IBXM.IBXM_MAXBUFFER;
        
        int size = SAMPLERATE/UPDATE_PER_SECOND+2;
        
        return size*4; // because of 16 bit
    }
    public Stream getVectrexLine()
    {
        if (!is16Bit)
        {
            return TinySound.getOutStreamVectrex();
        }
        return TinySound.getOutStream();
    }
    
    
    
    
    private void e8910_callback_16(byte[] stream, int length)
    {
//System.out.println(""+length);
        int lengthOrg = length;
  	int positionInOutputArray = 0;
        int maxSampleLength = length * OVERSAMPLE;
        int sampleDivider = 3*OVERSAMPLE;
        int volaEnableMul = 1;
        int volbEnableMul = 1;
        int volcEnableMul = 1;
        /*
        if (this.muteChannelA)
        {
          volaEnableMul = 0;
          n -= OVERSAMPLE;
        }
        if (this.muteChannelB)
        {
          volbEnableMul = 0;
          n -= OVERSAMPLE;
        }
        if (this.muteChannelC)
        {
          volcEnableMul = 0;
          n -= OVERSAMPLE;
        }
                */
        if (sampleDivider == 0) 
        {
            sampleDivider = 1;
        }
        
        if (((snd_regs[AY_AFINE] | snd_regs[AY_ACOARSE]) == 0) && ((snd_regs[AY_AVOL] & 0x10) == 0) && ((snd_regs[AY_ENABLE] & 0x9) == 8)) 
        {
            volaEnableMul = 0;
        }
        if (((snd_regs[AY_BFINE] | snd_regs[AY_BCOARSE]) == 0) && ((snd_regs[AY_BVOL] & 0x10) == 0) && ((snd_regs[AY_ENABLE] & 0x12) == 16)) 
        {
            volbEnableMul = 0;
        }
        if (((snd_regs[AY_CFINE] | snd_regs[AY_CCOARSE]) == 0) && ((snd_regs[AY_CVOL] & 0x10) == 0) && ((snd_regs[AY_ENABLE] & 0x24) == 32)) 
        {
            volcEnableMul = 0;
        }
        int volaPSG = PSG.VolA * volaEnableMul; // 
        int volbPSG = PSG.VolB * volbEnableMul; // 
        int volcPSG = PSG.VolC * volcEnableMul; // 
        if ((snd_regs[AY_ENABLE] & 0x1) != 0)
        {
            if (PSG.CountA <= maxSampleLength) 
            {
                PSG.CountA += maxSampleLength;
            }
            PSG.OutputA = 1;
        }
        else if ((snd_regs[AY_AVOL] == 0) && (PSG.CountA <= maxSampleLength))
        {
            PSG.CountA += maxSampleLength;
        }
        if ((snd_regs[AY_ENABLE] & 0x2) != 0)
        {
            if (PSG.CountB <= maxSampleLength) 
            {
                PSG.CountB += maxSampleLength;
            }
            PSG.OutputB = 1;
        }
        else if ((snd_regs[AY_BVOL] == 0) && (PSG.CountB <= maxSampleLength))
        {
            PSG.CountB += maxSampleLength;
        }
        if ((snd_regs[AY_ENABLE] & 0x4) != 0)
        {
            if (PSG.CountC <= maxSampleLength) 
            {
                PSG.CountC += maxSampleLength;
            }
            PSG.OutputC = 1;
        }
        else if ((snd_regs[AY_CVOL] == 0) && (PSG.CountC <= maxSampleLength))
        {
            PSG.CountC += maxSampleLength;
        }
        if (((snd_regs[AY_ENABLE] & 0x38) == 56) && (PSG.CountN <= maxSampleLength)) 
        {
            PSG.CountN += maxSampleLength;
        }
        int outn = PSG.OutputN | snd_regs[AY_ENABLE];
        while (length > 0)
        {
            int volASamples = 0;
            int volBSamples = 0;
            int volCSamples = 0;
            int left = OVERSAMPLE;
            do
            {
                int nextEvent = PSG.CountN < left ? PSG.CountN : left; // 

                if ((outn & 0x08)!=0)
                { 
                    if (PSG.OutputA!=0) 
                        volASamples += PSG.CountA;
                    PSG.CountA -= nextEvent;

                    /* PeriodA is the half period of the square wave. Here, in each */
                    /* loop I add PeriodA twice, so that at the end of the loop the */
                    /* square wave is in the same status (0 or 1) it was at the start. */
                    /* vola is also incremented by PeriodA, since the wave has been 1 */
                    /* exactly half of the time, regardless of the initial position. */
                    /* If we exit the loop in the middle, OutputA has to be inverted */
                    /* and vola incremented only if the exit status of the square */
                    /* wave is 1. */
                    while (PSG.CountA <= 0)
                    {
                        PSG.CountA += PSG.PeriodA;
                        if (PSG.CountA > 0)
                        {
                            PSG.OutputA ^= 1;
                            if (PSG.OutputA!=0) 
                                volASamples += PSG.PeriodA;
                            break;
                        }
                        PSG.CountA += PSG.PeriodA;
                        volASamples += PSG.PeriodA;
                    }
                    if (PSG.OutputA!=0) 
                        volASamples -= PSG.CountA;
                }
                else
                {
                    PSG.CountA -= nextEvent;
                    while (PSG.CountA <= 0)
                    {
                        PSG.CountA += PSG.PeriodA;
                        if (PSG.CountA > 0)
                        {
                            PSG.OutputA ^= 1;
                            break;
                        }
                        PSG.CountA += PSG.PeriodA;
                    }
                }

                if ((outn & 0x10)!=0)
                {
                    if (PSG.OutputB!=0) 
                        volBSamples += PSG.CountB;
                    PSG.CountB -= nextEvent;
                    while (PSG.CountB <= 0)
                    {
                        PSG.CountB += PSG.PeriodB;
                        if (PSG.CountB > 0)
                        {
                            PSG.OutputB ^= 1;
                            if (PSG.OutputB!=0) 
                                volBSamples += PSG.PeriodB;
                            break;
                        }
                        PSG.CountB += PSG.PeriodB;
                        volBSamples += PSG.PeriodB;
                    }
                    if (PSG.OutputB!=0) 
                        volBSamples -= PSG.CountB;
                }
                else
                {
                    PSG.CountB -= nextEvent;
                    while (PSG.CountB <= 0)
                    {
                        PSG.CountB += PSG.PeriodB;
                        if (PSG.CountB > 0)
                        {
                            PSG.OutputB ^= 1;
                            break;
                        }
                        PSG.CountB += PSG.PeriodB;
                    }
                }

                if ((outn & 0x20)!=0)
                {
                    if (PSG.OutputC!=0) 
                        volCSamples += PSG.CountC;
                    PSG.CountC -= nextEvent;
                    while (PSG.CountC <= 0)
                    {
                        PSG.CountC += PSG.PeriodC;
                        if (PSG.CountC > 0)
                        {
                            PSG.OutputC ^= 1;
                            if (PSG.OutputC!=0) 
                                volCSamples += PSG.PeriodC;
                            break;
                        }
                        PSG.CountC += PSG.PeriodC;
                        volCSamples += PSG.PeriodC;
                    }
                    if (PSG.OutputC!=0) 
                        volCSamples -= PSG.CountC;
                }
                else
                {
                    PSG.CountC -= nextEvent;
                    while (PSG.CountC <= 0)
                    {
                        PSG.CountC += PSG.PeriodC;
                        if (PSG.CountC > 0)
                        {
                            PSG.OutputC ^= 1;
                            break;
                        }
                        PSG.CountC += PSG.PeriodC;
                    }
                }        
                PSG.CountN -= nextEvent;
                if (PSG.CountN <= 0)
                {
                    /* Is noise output going to change? */
                    if (((PSG.RNG + 1) & 2)!=0)	/* (bit0^bit1)? */
                    {
                        PSG.OutputN = ~PSG.OutputN;
                        outn = (PSG.OutputN | snd_regs[AY_ENABLE]);
                    }

                    /* The Random Number Generator of the 8910 is a 17-bit shift */
                    /* register. The input to the shift register is bit0 XOR bit3 */
                    /* (bit0 is the output). This was verified on AY-3-8910 and YM2149 chips. */

                    /* The following is a fast way to compute bit17 = bit0^bit3. */
                    /* Instead of doing all the logic operations, we only check */
                    /* bit0, relying on the fact that after three shifts of the */
                    /* register, what now is bit3 will become bit0, and will */
                    /* invert, if necessary, bit14, which previously was bit17. */
                    if ((PSG.RNG & 1)!=0) 
                        PSG.RNG ^= 0x24000; /* This version is called the "Galois configuration". */
                    PSG.RNG >>= 1;
                    PSG.CountN += PSG.PeriodN;
                }
                left -= nextEvent;
            } while (left > 0);

            if (PSG.Continue==0)
            {
                PSG.CountE -= OVERSAMPLE;
                if (PSG.CountE <= 0)
                {
                    do
                    {
                        PSG.CountEnv -= 1;
                        PSG.CountE += PSG.PeriodE;
                    } while (PSG.CountE <= 0);

                    /* check envelope current position */
                    if (PSG.CountEnv < 0)
                    {
                        if (PSG.Hold!=0)
                        {
                            if (PSG.Alternate!=0)
                                PSG.Attack ^= 0x1f;
                            PSG.Continue = 1;
                            PSG.CountEnv = 0;
                        }
                        else
                        {
                            /* if CountEnv has looped an odd number of times (usually 1), */
                            /* invert the output. */
                            if ((PSG.Alternate!=0) && ((PSG.CountEnv & 0x20)!=0))
                                PSG.Attack ^= 0x1f;

                            PSG.CountEnv &= 0x1f;
                        }
                    }
        // DIF
                    PSG.VolE = VolTable[PSG.CountEnv ^ PSG.Attack]; // org
        //          PSG.VolE = PSG.VolTable[PSG.CountEnv]; // para
                            /* check envelope current position */
                    if (PSG.EnvelopeA != 0)
                    {
                        PSG.VolA = PSG.VolE;
                        volaPSG = PSG.VolE * volaEnableMul;
                    }
                    if (PSG.EnvelopeB != 0)
                    {
                        PSG.VolB = PSG.VolE;
                        volbPSG = PSG.VolE * volbEnableMul;
                    }
                    if (PSG.EnvelopeC != 0)
                    {
                        PSG.VolC = PSG.VolE;
                        volcPSG = PSG.VolE * volcEnableMul;
                    }
                }
            }

            int oneSample16Bit = (volASamples * volaPSG + volBSamples * volbPSG + volCSamples * volcPSG) / sampleDivider;
            
            stream[(positionInOutputArray++)] = (byte)(oneSample16Bit&0xff);
            stream[(positionInOutputArray++)] = (byte)((oneSample16Bit>>8)&0xff);

            length--;
        }
        // small sample counts are ignored!
        if ((digitByteCounter>15) ) // are there any samples?
        {
            double sampleScale = (((double)digitByteCounter) / ((double) lengthOrg)); // 2 because 16 bit
            int i=0;
            // we fill the needed sample buffer
            // with as many samples as we have
            // each sample may be "stretched" to fill the buffer
            // it is NOT considered how long (in cycles) a sample "stayed" for digital output
            // all samples are considered to have the same "length"
            double sampleCounter = 0;

            // samples come from the DAC (more or less)
            // therefor samples are signed 8bit samples, -128 - +127
            // output line is done in signed 8bit samples (PSG has signed output) [although the output is allways positive]
            // and our data here is ORer with
            // PSG out
            double volDigital = 1.0;
            if (config.generation==3) volDigital = 0.2;
            while (i/2<lengthOrg) 
            {
                double signed8BitSampleVolumne = digitByte[(int)sampleCounter]*volDigital*256;
                sampleCounter += sampleScale; // 
                int oneSample16Bit = (int)signed8BitSampleVolumne;
                stream[(i++)] = (byte)(oneSample16Bit&0xff);
                stream[(i++)] = (byte)((oneSample16Bit>>8)&0xff);
            }
        }
        digitByteCounter = -1;
    }
}
