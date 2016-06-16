/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import be.tarsos.dsp.AudioDispatcher;
import be.tarsos.dsp.AudioEvent;
import be.tarsos.dsp.AudioProcessor;
import be.tarsos.dsp.GainProcessor;
import be.tarsos.dsp.WaveformSimilarityBasedOverlapAdd;
import be.tarsos.dsp.WaveformSimilarityBasedOverlapAdd.Parameters;
import be.tarsos.dsp.io.jvm.AudioDispatcherFactory;
import be.tarsos.dsp.resample.RateTransposer;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.sound.tinysound.Stream;
import de.malban.sound.tinysound.TinySound;
import de.malban.sound.tinysound.internal.MemSound;
import static de.malban.vide.vedi.sound.ibxm.IBXM.IBXM_MAXBUFFER;
import java.io.Serializable;
import java.util.Arrays;
import javax.sound.sampled.AudioFormat;

/* Examinig the VecVox driver routines from alex herbert following guesses are made:

- vecVox communicates via two different "lines":
  a) bit 5 of PSG PortA (this bit can be read as "usual" e.g. as a button state)
  b) bit 4 of PSG PortA, this bit is used to OUTPUT data to vecVox
- There is a init routine, which masks bit 4 as zero and all other bits 1 one
  for output of PSG port A
- it seems, that this state of "output portA" is kept internally in the PSG, regardless
  of what is done in "input mode" to portA, once portA is switched to output, that
  mask seems to be "restored" and used
- the routines of alex which do the serial communication (btw 8n1 9600 baud) SEEM
  to only use the enable register for porta (bit 6 of register 7)
- my guess is by ENABLING output of PortA a "zero" is sent to vecvox
- and by DISABLING output of PortA a "one" is sent to vecvox
- (if the "output button mask" which is set on initialization is intact)
- thus all communication is seemingly done by register 7 bit 6
- but all datasheets and schemetics indicate that there is NO direct connection to any joystick port
- to me, at the moment above guesses are the only explanation....


*/


/**
 *
 * @author malban
 */
public class VecSpeech implements PortAdapter, Serializable
{
    transient E8910 e8910;
    transient private static int UID_C = 0;
    
    transient static final int LINE_OFFLINE=0;
    transient static final int LINE_WAIT_FOR_START_BIT=1;
    transient static final int LINE_WAIT_FOR_START_BIT_END = 2;
    transient static final int LINE_RECEIVING_BITS=3;
    transient static final int LINE_READ_NEXT_BYTE_BIT = 4;
    transient static final int LINE_WAIT_FOR_STOP_BIT = 5;
    
    transient static final int BAUD_IN_CYCLES = 156; // 156 cycles = 9615 baud
    // get the data that is transfered not at the END of the time range, but in the middle!
    transient static final int MID_BAUD_IN_CYCLES = BAUD_IN_CYCLES/2; 

    private boolean SPO256AL2 = false;
    transient private final int UID = UID_C++;
    
    String deviceName = "VecVox";
    int lowLevelState = LINE_OFFLINE;
    long cycles = 0;
    long receiveCycleStart = 0;
    boolean dataLineInput = true; // false is 0, true is 1; bit 4 of snd_reg[14]
    boolean old_dataLineInput = true;
    
    int currentByteRead = 0;
    int bitsLoaded = 0;
    boolean inputMode = true;
    
    boolean midBaudSet = false;
    boolean midBaudValue = false;
    
    int VECSPEECH_PORT = 2;
    public static transient int STATUS_LINE_MASK_PORT2 = 0x20;
    public static transient int DATA_LINE_MASK_PORT2 = 0x10;
    
    transient Stream line=null;
    transient private static final int C_LEN = 64; // Speakjet command buffer

    int[] commands = null;
    int nextComandPoint = 0;
    int currentComandPoint = 0;
    long soundCycles = 0;
    long oldCycles =0;
    int currentSamplePos = -1;
    byte[] wavData = null;
    
    public static final int NO_COMMAND = -1;

    transient byte[] soundBytes = null;
    
    
    public void deinit()
    {
        if (line != null)
        {
            line.stop();
            line.unload();
            line = null;
        }
    }
    
    // only for cloning!
    private VecSpeech()
    {
    }
    
    public VecSpeech(E8910 e)
    {
        VecVoiceSamples.loadSamples();
        VecVoxSamples.loadSamples();
        commands = new int[C_LEN];
        soundBytes = new byte[IBXM_MAXBUFFER/2];
        e8910 = e;
        e8910.setPortAdapter(this);
        for (int i=0; i<C_LEN; i++) commands[i] = -1;
    }
    // commands
    // and current wave are NOT cloned
    // and current output data (commands)
    // are NOT cloned
    public VecSpeech clone()
    {
        VecSpeech vv = new VecSpeech();
        vv.currentByteRead = currentByteRead;
        vv.bitsLoaded = bitsLoaded;
        vv.inputMode = inputMode;
        vv.midBaudSet = midBaudSet;
        vv.midBaudValue = midBaudValue;
        vv.cycles = cycles;
        vv.dataLineInput = dataLineInput;
        vv.old_dataLineInput = old_dataLineInput;
        vv.receiveCycleStart = receiveCycleStart;
        vv.SPO256AL2= SPO256AL2;
        vv.VECSPEECH_PORT= VECSPEECH_PORT;
        vv.lowLevelState = lowLevelState;
        vv.deviceName = deviceName;
//        for (int i=0; i<C_LEN; i++) vv.commands[i] = commands[i];
        vv.nextComandPoint = 0;
        vv.currentComandPoint = 0;
        vv.soundCycles = soundCycles;
        vv.oldCycles = oldCycles;
        vv.wavData = null;
        vv.currentSamplePos = -1;
        return vv;
    }
    
    // following "intensive" data is not
    // initialized by cloning
    // it must be initialized if the clone is really "used"
    // (stepping back in emulator)
    void initClone(E8910 e)
    {
        VecVoiceSamples.loadSamples();
        VecVoxSamples.loadSamples();
        commands = new int[C_LEN];
        soundBytes = new byte[IBXM_MAXBUFFER/2];
        e8910 = e;
        e8910.setPortAdapter(this);
    }
    
    public void setVecVoice(boolean b)
    {
        SPO256AL2 = b;
        if (b)
        {
            deviceName = "VecVoice";
        }
        else
        {
            deviceName = "VecVox";
        }
    }

    // not used right now
    // in prepariation of using
    // SP0256AL from mame
    // we seperate speakjet and SP0 emulation
    // even with samples...
    int mapSPOToSpeakJet(int in)
    {
        // mappings which are done by VecVox to ensure VecVoice is correct
        if (in == 0) return 4; // PA4 
        if (in == 1) return 5; // PA5
        if (in == 2) return 6; // PA6
        if (in == 3) return 1; // PA1
        if (in == 4) return 2; // PA2
        if (in == 5) return 156; // OY - 
        if (in == 6) return 155; // AY - 
        if (in == 7) return 131; // EH - 
        if (in == 8) return 195; // KK3 - 
        if (in == 9) return 199; // PP - 
        if (in == 10)return 165; // JH - 
        if (in == 11)return 141; // NN1 - 
        if (in == 12)return 129; // IH - 
        if (in == 13)return 192; // TT2 - 
        if (in == 14)return 153; // RR1 - 
        if (in == 15)return 134; // AX - 
        if (in == 16)return 140; // MM -  
        if (in == 17)return 191; // TT1 - 
        if (in == 18)return 169; // DH1 -  
        if (in == 19)return 128; // IY -  
        if (in == 20)return 154; // EY - 
        if (in == 21)return 176; // DD1 -  
        if (in == 22)return 139; // UW1 - 
        if (in == 23)return 135; // AO -  
        if (in == 24)return 136; // AA - 
        if (in == 25)return 128; // YY2 -  
        if (in == 26)return 132; // AE - 
        if (in == 27)return 183; // HH1 - 
        if (in == 28)return 170; // BB1 - 
        if (in == 29)return 190; // TH - 
        if (in == 30)return 138; // UH - 
        if (in == 31)return 160; // UW2 - 
        if (in == 32)return 163; // AW -  
        if (in == 33)return 175; // DD2 - 
        if (in == 34)return 180; // GG3 - 
        if (in == 35)return 166; // VV - 
        if (in == 36)return 179; // GG1 - 
        if (in == 37)return 189; // SH - 
        if (in == 38)return 168; // ZH - 
        if (in == 39)return 148; // RR2 - 
        if (in == 40)return 186; // FF -  
        if (in == 41)return 194; // KK2 - 
        if (in == 42)return 194; // KK1 - 
        if (in == 43)return 167; // ZZ - 
        if (in == 44)return 144; // NG -  
        if (in == 45)return 145; // LL - 
        if (in == 46)return 147; // WW -  
        if (in == 47)return 150; // XR - 
        if (in == 48)return 185; // WH - 
        if (in == 49)return 128; // YY1 - 
        if (in == 50)return 182; // CH - 
        if (in == 51)return 133; // ER1 - 
        if (in == 52)return 151; // ER2 - 
        if (in == 53)return 164; // OW - 
        if (in == 54)return 169; // DH2 - 
        if (in == 55)return 187; // SS -  
        if (in == 56)return 142; // NN2 - 
        if (in == 57)return 184; // HH2 -
        if (in == 58)return 153; // OR -
        if (in == 59)return 152; // AR -
        if (in == 60)return 149; // YR -
        if (in == 61)return 178; // GG2 -
        if (in == 62)return 159; // EL -
        if (in == 63)return 170; // BB2 -          
        return 0; // pause, silence, whatever is default...
     }
    
    // sending line information to the emulator (Joy)
    public int getWriteDataToPort(int portAOrg)
    {
        int value = portAOrg;
        if (!inputMode) return value;
        
        if (VECSPEECH_PORT == 2)
        {
            // button state is "inverse": 0 = ready
            if (!isReady())
            {
                value = value | STATUS_LINE_MASK_PORT2;
            }
            else
            {
                value = value & (0xff - STATUS_LINE_MASK_PORT2);
            }
            if (!dataLineInput)
            {
                value = value | DATA_LINE_MASK_PORT2;
            }
            else
            {
                value = value & (0xff - DATA_LINE_MASK_PORT2);
            }
        }

        return value;
    }
    public void valueChangedFromPSG()
    {
        if (inputMode) return;
        if (VECSPEECH_PORT == 2) 
            dataLineInput = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
    }
    
    // if i== true
    // than input enabled
    // input mode enabled means
    // vecvoice can WRITE to the port
    // and vectrex (over PSG) can read port
    public void setInputMode(boolean i)
    {
        if (inputMode == i) return;
        inputMode = i;
        if (!inputMode) 
        {
            // for alex herberts driver
            // due to only one input mask
            // this should always be false!
            dataLineInput = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
        }
        else
        {
            // it seems, that when PSG is in input mode
            // than the port "output" is allways $ff
            dataLineInput = true;
        }
    }

    // low level step
    // this is triggered with every cycle from the emulator
    // c is the current cylce counter of the vecx emulator, needed for timing
    // (since I don't trust that we are called each cycle :-) )
    public void step(long c)
    {
        // prepare and do output
        stepSound(c);
        
        // and do a state machine
        // for serial input to speech device
        // the state machine with current timings
        // realizes a 9600 baud 8n1 serial input!
        long dif = c - cycles;
        if (lowLevelState<=LINE_WAIT_FOR_START_BIT_END)
        {
            if (dataLineInput != old_dataLineInput)
            {
                // reset cycle count on line changes (which are triggered from the outside)
                cycles = c;
            }
        }

        switch (lowLevelState)
        {
            case LINE_OFFLINE:
            {
                lowLevelState = LINE_WAIT_FOR_START_BIT;
                cycles = c;
   
                Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": Offline -> wait for startbit ", INFO);
                break;
            }
            case LINE_WAIT_FOR_START_BIT:
            {
                // startbit MUST be 0
                if (!dataLineInput)
                {
                    
                    Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": Offline -> startbit started", INFO);
                    lowLevelState = LINE_WAIT_FOR_START_BIT_END;
                    if (old_dataLineInput)
                    {
                        cycles = c;
                    }
                    midBaudSet = false;
                }
                break;
            }
            
            case LINE_WAIT_FOR_START_BIT_END:
            {
                if (dif >MID_BAUD_IN_CYCLES)
                {
                    if (!midBaudSet)
                    {
                        midBaudSet = true;
                        midBaudValue = dataLineInput;
                    }
                }
                
                if (dif >=BAUD_IN_CYCLES)
                {
                    // got a bit 0 as startbit in a correct timeframe
                    if (!midBaudValue)
                    {
                        Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": startbit received, waiting for byte data ", INFO);
                        midBaudSet = false;
                        bitsLoaded = 0;
                        currentByteRead = 0;
                        lowLevelState = LINE_READ_NEXT_BYTE_BIT;
                        cycles = c;
                    }
                    else
                    {
                        midBaudSet = false;
                        lowLevelState = LINE_WAIT_FOR_START_BIT;
                        Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": startbit broken, waiting again ", INFO);
                    }
                    
                }
                break;
            }
            case LINE_READ_NEXT_BYTE_BIT:
            {
                if (dif >MID_BAUD_IN_CYCLES)
                {
                    if (!midBaudSet)
                    {
                        midBaudSet = true;
                        midBaudValue = dataLineInput;
                    }
                }
                if (dif >=BAUD_IN_CYCLES)
                {
                    // LSB first
                    currentByteRead = currentByteRead>>1;
                    if (midBaudValue)
                    {
                        currentByteRead +=128;
                        Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": Byte receiving (bit: "+bitsLoaded+" = "+1+")", INFO);
                    }
                    else
                    {
                        Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": Byte receiving (bit: "+bitsLoaded+" = "+0+")", INFO);
                    }
                    bitsLoaded++;
                    cycles = c;
                    midBaudSet = false;
                    if (bitsLoaded == 8)
                    {
                        midBaudSet = false;
                        lowLevelState = LINE_WAIT_FOR_STOP_BIT;
                        Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": Byte received, waiting for stop bit", INFO);
                    }
                }
                break;
            }
            case LINE_WAIT_FOR_STOP_BIT:
            {
                midBaudSet = false;
                if (dataLineInput)
                {
                    lowLevelState = LINE_OFFLINE;
                    cycles = c;
                    Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": stop bit received", INFO);
                    Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": completely received: "+currentByteRead+" (going offline)", INFO);
                    finalizeByteRead();
                }
                else if (dif >=BAUD_IN_CYCLES)
                {
                    lowLevelState = LINE_OFFLINE;
                    cycles = c;
                    Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": stop bit not received (going offline)", INFO);
                }
                break;
            }
            default:
            {
                break;
            }
        }
        old_dataLineInput = dataLineInput;
    }
    
    boolean isReady()
    {
        boolean ret = false;
        int nc = (nextComandPoint + 1) % C_LEN;
        if (nc == currentComandPoint) return false; // buffer is full
        return true;
    }
    
    void finalizeByteRead()
    {
        Configuration.getConfiguration().getDebugEntity().addLog(deviceName+": byte received: " + currentByteRead, INFO);
        addCommand(currentByteRead);
    }

    // todo
    // a) fill buffer with commands
    // b) build a vecVoice stream
    // c) execute commands on to be played samples (conversion)
    // d) add to stream all samples/pauses
    void addCommand(int c)
    {
        commands[nextComandPoint] = c;
        nextComandPoint = (nextComandPoint + 1) % C_LEN;
    }

    int getNextCommand()
    {
        if (nextComandPoint == currentComandPoint) return NO_COMMAND; // no command

        // set old command = nothing
        commands[(currentComandPoint+C_LEN-1)% C_LEN] = -1;
        
        int command = commands[currentComandPoint];
        currentComandPoint = (currentComandPoint + 1) % C_LEN;

        // if no command, than this is an error, nonetheless - do nothing
        if (command == -1) return NO_COMMAND;
        return command;
    }
    
    // 44khz 1 channel 16bit signed little endian
    // sound data is written to stream
    // tiny sound stream makes 2 channels by doubling data
    private void stepSound(long cycles)
    {
        soundCycles -= (cycles - oldCycles);
        oldCycles = cycles;

        // sound stream buffer is updated with 30Hz
        // Fill buffer and call core to update sound
        if (soundCycles<=0)
        {
            soundCycles = 50000;
            if (line == null)
            {
                line = TinySound.getOutStream();
                if (line == null) return;
                line.start();
                if (!SPO256AL2)
                {
                    line.setVolume(spVolume);
                }
            }
            synchronized (line)
            {
                int soundLength = line.available();
                soundLength = fillSoundBuffer(soundLength);
                soundLength = soundLength >soundBytes.length ? soundBytes.length : soundLength;
                if (soundLength>=0)
                {
                    line.write(soundBytes, 0, soundLength);
                }
            }
        }        
    }    
    
    static byte[] nullBuffer = new byte[20];
    int fillSoundBuffer(int maxSoundLength)
    {
        // start new sample
        int outBufferPos = 0;
        
        int restBuffer = maxSoundLength;
        int size = 0;
        // fill out buffer
        
        
        // the while loop fills the buffer "soundBytes" with sample data
        // it will try to fill data up to maxSoundLength
        // in the loop commands from the SpeechBuffer will be loaded (64 byte cache)
        // if it is a "direct" sample, the sample will be loaded in a 
        // second buffer "wavData", that data is than put into soundBytes
        // if wavData is larger than soundBytes, only the needed length is copied and the buffer position remembered
        // if maxSoundLength is larger than waDataLength, the next speech command
        // is fetched and it all starts from anew
        while (true)
        {
            boolean enableCommands = true;
            // current samplePos != allways means "wavData" contains still data we can copy
            // there is a sample already loaded where we can get data from
            if (currentSamplePos != -1)
            {
                if (!SPO256AL2)
                {
                    if (enableCommands)
                    {
                        speakjetPreprocessWavWithCommand();
                    }
                }

                // 
                int rest = wavData.length - currentSamplePos;
                if (rest > restBuffer)
                {
                    System.arraycopy(wavData, currentSamplePos, soundBytes, outBufferPos, restBuffer);
                    currentSamplePos+=restBuffer;
                    size = maxSoundLength;
                    outBufferPos += restBuffer; 
                    restBuffer = 0;
                    // out buffer for line ist completely filled
                    // so we break the loop and go back
                    break;
                }
                else
                {
                    System.arraycopy(wavData, currentSamplePos, soundBytes, outBufferPos, rest);
                    outBufferPos += rest; 
                    currentSamplePos = -1;
                    wavData = null;
                    restBuffer -= rest;
                    size = size + rest;
                    // wavData Buffer is now "empty"
                    // we can continue - or do nothing since by doing nothing we would also
                    // go to the next command fetch ...
                    continue;
                }
            }
            
            // a new sample must be loaded
            int command = getNextCommand();
            if (command == NO_COMMAND) break; // no command -> we can do nothing queue is empty
            
            System.out.println("SpeechCommand: "+command);
            // now lets get a new sample
            MemSound sample=null;
            if (SPO256AL2) // old chip?
            {
                // than just load sample data - and be done with
                if (command >63) continue; 
                sample = VecVoiceSamples.getSample(command);  
            }
            else // speakjet
            {
                // continuing and looking for a parameter of a command?
                if (spCommandMode)
                {
                    // we are "in" a command and expect a parameter
                    int param = command;
                    speakJetdoCommandWithParameter(param);
                    continue; 
                }
                else if (command <128) // < 128 are all comands
                {
                    if (enableCommands)
                        speakJetAcceptCommand(command);
                    continue;
                }
                if (command == 189)
                    System.out.println("s");
                // other wise load a "simple" sample
                // preprocessing samples is done "while" the outbound buffer is filled
                sample = VecVoxSamples.getSample(command);  
            }
            if (sample == null)
            {
                // error!
                // try next command
                continue;
            }
            // put sample data to buffer
            // and reset position
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
            // sample was loaded, will be filled in next round of loop
        }   
        return size;
    }
    
    // idea - not done
    // spare the last X byte of sample data
    // and use them to "blend" with next sample data
    // this might lead to smoother transitions between samples
    // but whta probably must be done is: align to frequency window of
    // both samples, otherwise the interference might negate data, that is NOT what we want!
    
    
    // preprocessing
    // changes wav data in "wavData"
    // according to command
    // wavData must be filled and position 0
    void speakjetPreprocessWavWithCommand()
    {
        // only preprocess "fresh" data
        if (currentSamplePos != 0) return;
        
        if (spBend > 5) // default 5
        {
            // http://philippseifried.com/blog/2011/10/20/dynamic-audio-in-as3-part-3-robot-voice/
            try
            {
                int shift = spBend-5;
                shift = 360/shift;

                double freqShiftPhase = 0; // phase of the sine wave used for frequency shifting 
                double freqShiftDeltaPhase = shift*2*Math.PI/44100; // phase increase per sample 

                for (int i=0; i< wavData.length; i+=2)
                {
                    int lo = wavData[i]&0xff;
                    int hi = wavData[i+1]&0xff;
                    int sampleI = lo + (hi<<8);
                    if (sampleI>Short.MAX_VALUE) sampleI -= 65536;

                    double sampled = ((double)sampleI) / ((double)Short.MAX_VALUE);
                    freqShiftPhase += freqShiftDeltaPhase; 
                    double newSample = sampled *Math.sin(freqShiftPhase);                         

                    sampleI = (int) (newSample*Short.MAX_VALUE);
                    wavData[i+1] = (byte)((sampleI>>8)&0xff);
                    wavData[i+0] = (byte)(sampleI & 0xff);
                }


            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
        }               
        boolean doTarsos = false;
        double currentFactor = 1.0;
        RateTransposer rateTransposer = null;
        
        if (spPitch != 88) // default 88
        {
            try
            {
                doTarsos = true;
                currentFactor *= ((double)spPitch)/88.0;
                rateTransposer = new RateTransposer(currentFactor);
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
        }
        if (spTempo != 114) // default 114
        {
            currentFactor *= ((double)spTempo)/114.0;
            doTarsos = true;
        }                
        if (nextSlow)
        {
            nextSlow = false;
            currentFactor *= 0.5;
            doTarsos = true;
        }
        if (nextFast)
        {
            nextFast = false;
            currentFactor *= 2;
            doTarsos = true;
        }     
        if (doTarsos)
        {
            try
            {
                WaveformSimilarityBasedOverlapAdd wsola;
                GainProcessor gain;
                TarsosReceiver receiver = new TarsosReceiver();
                gain = new GainProcessor(1.0);
                Parameters wparam = new Parameters(currentFactor,44100,20, 15,10);
                wsola = new WaveformSimilarityBasedOverlapAdd(wparam);
                AudioDispatcher dispatcher = AudioDispatcherFactory.fromByteArray(wavData, audioFormat,wsola.getInputBufferSize(),wsola.getOverlap());
                wsola.setDispatcher(dispatcher);
                dispatcher.addAudioProcessor(wsola); 
                if (rateTransposer != null)
                    dispatcher.addAudioProcessor(rateTransposer); 
                dispatcher.addAudioProcessor(gain);
                dispatcher.addAudioProcessor(receiver);
                dispatcher.run();
                wavData = receiver.finalBuffer;
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
            
        }
        
        
        
        if (spRepeat >1)
        {
            byte[] dummy = new byte[0];
            for (int i=0; i<spRepeat; i++)
            {
                dummy = concat(dummy, wavData);
            }
            wavData = dummy;
            spRepeat = 0;
        }
    }
    void speakJetdoCommandWithParameter (int param)
    {
        spCommandMode = false;
        if (spCommand == 20) // master volume
        {
            spVolume = ((double)(param & 0x7f)) / 127.0;
            line.setVolume(spVolume);
        }
        else if (spCommand == 21) // tempo 
        {
            spTempo = param;
        }                        
        else if (spCommand == 22) // master volume
        {
            spPitch = param;
        }
        else if (spCommand == 23) // bend
        {
            spBend = param;
        }
        else if (spCommand == 26) // repeat
        {
            spRepeat = param;
        }
        else if (spCommand == 30) // delay
        {
            // delay in 10ms
            int delay = param;

            // 10 ms = 441 samples
            int delaySamples = delay * 441;

            byte[] delayBuffer = new byte[delaySamples*2]; // 16 bit -> * 2

            wavData = delayBuffer;
            currentSamplePos = 0;
        }                      
    }
    
    // if neccesary sets wavDat to new byte array
    // sets currentSamplePos
    // if command needs parameter
    // sets spCommand = current comand and "spCommandMode" as indicator, 
    // that parameter must be fetched
    void speakJetAcceptCommand(int command)
    {
        if (command == 0) // pause 0ms
        {
        }
        else if (command == 1) // pause 100ms, with ramping after last command
        {
            // 100ms = 4410 samples 
            // how many should we "ramp up and down?"

            // for a first start
            // we do not ramp
            // we guess 20ms down
            // 20 up
            // the rest silent, so we pause 60 ms :-)
            MemSound sample = VecVoxSamples.getPauseSample(5);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
        }
        else if (command == 2) // pause 200ms, with ramping after last command
        {
            // 200ms = 8820 samples 
            // how many should we "ramp up and down?"

            // for a first start
            // we do not ramp
            // we guess 50ms down
            // 50 up
            // the rest silent, so we pause 100 ms :-)
            MemSound sample = VecVoxSamples.getPauseSample(1);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
        }
        else if (command == 3) // pause 700ms, with ramping after last command
        {
            // 700ms = 30870 samples 
            // how many should we "ramp up and down?"

            // for a first start
            // we do not ramp
            // the rest silent, so we pause 700 ms :-)
            MemSound sample = VecVoxSamples.getPauseSample(3);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
        }
        else if (command == 4) // pause 30ms after last command
        {
            MemSound sample = VecVoxSamples.getPauseSample(4);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
        }
        else if (command == 5) // pause 60ms after last command
        {
            MemSound sample = VecVoxSamples.getPauseSample(5);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
        }
        else if (command == 6) // pause 90ms after last command
        {
            MemSound sample = VecVoxSamples.getPauseSample(6);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
        }
        else if (command == 7) // fast play in double time
        {
            nextFast = true;
        }
        else if (command == 8) // slow play in 1,5 time
        {
            nextSlow = true;
        }
        else if (command == 20) // master volume
        {
            spCommandMode = true;
            spCommand = 20;
        }
        else if (command == 21) // tempo
        {
            spCommandMode = true;
            spCommand = 21;
        }
        else if (command == 22) // pitch
        {
            spCommandMode = true;
            spCommand = 22;
        }
        else if (command == 23) // bend
        {
            spCommandMode = true;
            spCommand = 23;
        }
        else if (command == 26) // repeat x
        {
            spCommandMode = true;
            spCommand = 26;
        }
        else if (command == 30) // delay x
        {
            spCommandMode = true;
            spCommand = 30;
        }
        else if (command == 31) // reset
        {
            spVolume = ((double)(96)) / 127.0;
            spPitch = 88;
            spTempo = 114;
            spBend = 5;
            line.setVolume(spVolume);
        }
    }    
    
    
    boolean spCommandMode = false;
    int spCommand = 0;
    double spVolume = ((double)(96)) / 127.0;
    int spPitch = 88;
    int spTempo = 114;
    int spBend = 5;
    boolean nextFast = false;
    boolean nextSlow = false;
    int spRepeat = 0;
    
    // tinyAudio Format for one channel only
    static final AudioFormat audioFormat = new AudioFormat(
                    AudioFormat.Encoding.PCM_SIGNED, //linear signed PCM
                    44100, //44.1kHz sampling rate
                    16, //16-bit
                    1, //2 channels fool
                    2, //frame size 4 bytes (16-bit, 2 channel)
                    44100,//44100, //same as sampling rate
                    false //little-endian
                    );        
    
    public static byte[] concat(byte[] a, byte[] b) 
    {
       int aLen = a.length;
       int bLen = b.length;
       byte[] c= new byte[aLen+bLen];
       System.arraycopy(a, 0, c, 0, aLen);
       System.arraycopy(b, 0, c, aLen, bLen);
       return c;
    }	
    class TarsosReceiver implements AudioProcessor 
    {
	
	/**
	 * Creates a new audio player.
	 * 
	 * @param format
	 *            The AudioFormat of the buffer.
	 * @throws LineUnavailableException
	 *             If no output LineWavelet is available.
	 */
	public TarsosReceiver()
        {
	}
	byte[] finalBuffer = new byte[0];
	@Override
	public boolean process(AudioEvent audioEvent) 
        {
            finalBuffer = concat(finalBuffer, audioEvent.getByteBuffer());
            return true;
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see be.tarsos.util.RealTimeAudioProcessor.AudioProcessor#
	 * processingFinished()
	 */
	public void processingFinished() 
        {
		// cleanup
	}
    }
}

    //https://github.com/JorenSix/TarsosDSP

