/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.sound.tinysound.Stream;
import de.malban.sound.tinysound.TinySound;


import resid.ISIDDefs;
import resid.SID;
import resid.ISIDDefs.sampling_method;
/**
 *
 * @author malban
 */
public class VSID {
  public static final int MOS6581=0;
  public static final int MOS8580=1;
    int SID_ADDRESS = 0x8000;
    
    
  static final int SAMPLE_RATE = 44100;
    static int UPDATE_PER_SECOND = 1000/25; // tinysound updates each 25ms 

  int BUFFER_SIZE = 256;
//  byte[] buffer = new byte[BUFFER_SIZE * 2];
//  byte[] buffer = new byte[4416];
  byte[] buffer = new byte[(SAMPLE_RATE/UPDATE_PER_SECOND+2)*4];// *2 because of 16 bit

  SID sid;
//  int CPUFrq = 985248; //1500000;// 985248;
  int SIDFRQ = 985248;
  int VECFREQ =   1500000;
  
  int clocksPerSample = VECFREQ / SAMPLE_RATE ;
  int clocksPerSampleRest = 0;
  long nextSample = 0;
  long lastCycles = 0;
  private int nextRest = 0;
  private int pos = 0;
  transient Stream line=null;
  VecX vecx;

  
  // update frequency of vectrex 
  // 30000 clock = 20ms = 50Hz
  // 1 ms = 1500 cycles
  // 25 ms = 30000+7500 = 37500 cycles [25ms = update freqeuncy of tinysound]
  
  // 44100 sample rate = 44100 samples per second
  // 44100 * 0,025 = samples per update (each 37500)
  // = 1102,5 = 1103 samples per upate
  
  // that means if we update each time an update is needed, that we must update every:
  // 37500 / 1102,5 cycles
  // 34,01 clocks
  
  public VSID(VecX v) {
    // Assume 44 Khz sample rate for now... later this must be handled...
    vecx = v;
    line = TinySound.getOutStream();
      
    sid = new SID();
    lastCycles = vecx.getCycles();
    nextSample = vecx.getCycles()+5;
//SAMPLE_FAST
//SAMPLE_RESAMPLE_INTERPOLATE
    sid.set_sampling_parameters(SIDFRQ, sampling_method.SAMPLE_RESAMPLE_INTERPOLATE, SAMPLE_RATE, -1, 0.97);

    clocksPerSampleRest = (int) ((VECFREQ * 1000L) / SAMPLE_RATE);
    clocksPerSampleRest -= clocksPerSample * 1000;
//    System.out.println("ClocksPer Sample: " + clocksPerSample + "." + clocksPerSampleRest);
    line.start();
  }

    public void clock(long cycles) 
    { 
        if (nextSample==0) return; // be quiet!
        if (nextSample<=cycles)
        {
                
            // do output
            nextSample +=clocksPerSample-1;
            nextRest += clocksPerSampleRest;
            if (nextRest > 1000) 
            {
                nextRest -= 1000;
                nextSample++;
            }
            double sidfactor = 1.0/((double) (((double)VECFREQ)/((double)SIDFRQ)));
            // translate 50Hz vectrex cycles to 50Hz SID cycles
//            double sidCycles = ((double)cycles) *sidfactor;

            // translate 50Hz vectrex cycles to 50Hz SID cycles
            double sidCycles = ((double)cycles) *sidfactor;
            if (sidCycles-lastCycles>5000) lastCycles = (long)sidCycles-100; // probably some sort of SID switch on/off
            
            // Clock resid!
            while(lastCycles < (long)sidCycles)//cycles) 
            {
                sid.clock();
                lastCycles++;
            }
            // and take the sample!
            int sample = sid.output();
            if (pos < buffer.length)
            {
                buffer[pos++] = (byte) (sample & 0xff);
                buffer[pos++] = (byte) ((sample >> 8));
            }
            if (pos == buffer.length) 
            {
            //   writeSamples();
            }
        }
    }

    public void doSamples() 
    {
        if (line == null) return;
        synchronized (line)
        {
            double v =  1;//((double) config.psgVolume)/(double)255.0;                            
            line.setVolume(v);
            int soundLength = line.available(); // in bytes
            int bufLength = pos;//buffer.length; // in bytes
            if (lastsl != soundLength)
            {
System.out.println(""+soundLength+"/"+pos);
                lastsl = soundLength;
            }
            soundLength = soundLength >bufLength ? bufLength : soundLength;
            soundLength = soundLength >pos ? pos : soundLength;
            if (soundLength>0)
            {
                line.write(buffer, 0, soundLength);
            }
        }
        pos = 0;
    }    
    
    int lastsl=0;


    private void writeSamples() 
    {
        if (line == null) return;
        synchronized (line)
        {
            double v =  1;//((double) config.psgVolume)/(double)255.0;                            
            line.setVolume(v);
            int soundLength = line.available(); // in bytes
            int bufLength = buffer.length; // in bytes
            soundLength = soundLength >bufLength ? bufLength : soundLength;
            if (lastsl != soundLength)
            {
System.out.println(""+soundLength);
                lastsl = soundLength;
            }
            if (soundLength>0)
            {
                line.write(buffer, 0, soundLength);
            }
        }
        pos = 0;
    }

  public int performRead(int address, long cycles) {
    return sid.read(address - SID_ADDRESS);
  }

    public void performWrite(int address, int data, long cycles) {
    sid.write(address - SID_ADDRESS, data);
  }

  public void reset() {
    nextSample = vecx.getCycles() + 10;
    lastCycles = vecx.getCycles();
    sid.reset();
  }

  public void stop() {
    // Called from any thread!
      nextSample =0;
  }
  public void setChipVersion(int version) {
    if (version == MOS6581)
      sid.set_chip_model(ISIDDefs.chip_model.MOS6581);
    else
      sid.set_chip_model(ISIDDefs.chip_model.MOS8580);
  }
}

