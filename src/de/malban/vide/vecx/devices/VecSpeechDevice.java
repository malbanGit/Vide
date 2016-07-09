/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import be.tarsos.dsp.AudioDispatcher;
import be.tarsos.dsp.AudioEvent;
import be.tarsos.dsp.AudioProcessor;
import be.tarsos.dsp.WaveformSimilarityBasedOverlapAdd;
import be.tarsos.dsp.WaveformSimilarityBasedOverlapAdd.Parameters;
import be.tarsos.dsp.io.jvm.AudioDispatcherFactory;
import be.tarsos.dsp.resample.RateTransposer;
import de.malban.config.Configuration;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.sound.tinysound.Stream;
import de.malban.sound.tinysound.TinySound;
import de.malban.sound.tinysound.internal.MemSound;
import de.malban.vide.vecx.E8910;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vedi.sound.SampleJPanel;
import static de.malban.vide.vedi.sound.ibxm.IBXM.IBXM_MAXBUFFER;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;

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

    //https://github.com/JorenSix/TarsosDSP

*/


/**
 *
 * @author malban
 */
public class VecSpeechDevice implements JoyportDevice, Serializable
{
    // debuggy stuff
    public static boolean DEBUG_WAV_OUT = false;
    public static byte [] output = new byte[0];
    static int sampleCount = 0;
    public static boolean saveWave = false;
    
    // playground while emulator testing
    public static boolean enableCommands = true;
    public static boolean blendEnable = true;
    
    // "blending" of samples can occur, epending on pausing and "stopped" sounds
    public static final int BLEND_DEFAULT = 15;
    public static int blendLen = BLEND_DEFAULT; // in MilliSeconds
    public static boolean removeSilence = true; // in general, if false silence is never removed, if true - sometimes :-)
    public static int maxNoise = 5;             // abs(-32768 - + 32767) what is the range that a "nose" is still silence
    public static boolean alignBlendToAmplitude = true; // if blend is configured, should belnd be aligned to the phase of the wav?

    public static int amplitudeThreshold = 10;  // determine same phase only, silence is not effected by this!
    
    boolean doSampleBlending = false;           // per sample "decision" to do blending
    boolean removeSilenceFromSample = true;     // per sample "decicion" to remove silence is set by emulation
    boolean afterPause = true;                  // if directly after a pause, we do not remove silience!
    int lastCommand = -1;                       // last command that was "executed"
    boolean isVoiced = false;                   // VecVox, was the last sample "voiced", if not pitch change should not be done

    transient static byte[] nullBuffer = new byte[20];

    
    
    
    
//    transient E8910 e8910;                      // communication to joystick port goes thru PSG
    transient private static int UID_C = 0;     // generate unique ID for instance
    
    // state machine states
    transient static final int LINE_OFFLINE=0;
    transient static final int LINE_WAIT_FOR_START_BIT=1;
    transient static final int LINE_WAIT_FOR_START_BIT_END = 2;
    transient static final int LINE_RECEIVING_BITS=3;
    transient static final int LINE_READ_NEXT_BYTE_BIT = 4;
    transient static final int LINE_WAIT_FOR_STOP_BIT = 5;
    
    transient static final int BAUD_IN_CYCLES = 156; // 156 cycles = 9615 baud
    // get the data that is transfered not at the END of the time range, but in the middle!
    transient static final int MID_BAUD_IN_CYCLES = BAUD_IN_CYCLES/2; 

    // if false VecVox, if true VecVoice
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
    int currentSamplePos = -1;  // current position in in between buffer (sample -> wavData -> (wavDataLastEnd+) wavDataUsage -> soundbuffer -> line)
    byte[] wavData = null;      // buffer where samples go
    byte[] wavDataUsage = null; // buffer where sample, + lastEnd (blended or not) is combined, th 
    byte[] wavDataLastEnd = null; // buffer where the "end" of the last sample goes, needed for blending
    
    public static final int NO_COMMAND = -1;

    transient byte[] soundBytes = null; // buffer for input to TinySound line

    // "command" values for vecVox
    boolean spNextFast = false;
    boolean spNextSlow = false;
    boolean spCommandMode = false;
    double spVolume = ((double)(96)) / 127.0;
    int spCommand = 0;
    int spPitch = 88;
    int spTempo = 114;
    int spBend = 5;
    int spRepeat = 0;
    
    // tinyAudio Format for one channel only
    transient static final AudioFormat audioFormat = new AudioFormat(
                    AudioFormat.Encoding.PCM_SIGNED, //linear signed PCM
                    44100, //44.1kHz sampling rate
                    16, //16-bit
                    1, //1 channels fool
                    2, //frame size 2 bytes (16-bit, 1 channel)
                    44100,//44100, //same as sampling rate
                    false //little-endian
                    );        
    
    
    public void deinit()
    {
        if (line != null)
        {
            line.stop();
            line.unload();
            line = null;
        }
    }
    
    VectrexJoyport joyport;

    public void setJoyport(VectrexJoyport j)
    {
        joyport = j;
    }
    
    
    // only for cloning!
    private VecSpeechDevice()
    {
    }
    
    public VecSpeechDevice(E8910 e)
    {
        VecVoiceSamples.loadSamples();
        commands = new int[C_LEN];
        soundBytes = new byte[IBXM_MAXBUFFER/2];
//        e8910 = e;
//        e8910.setPortAdapter(this);
        for (int i=0; i<C_LEN; i++) commands[i] = -1;
    }
    // commands
    // and current wave are NOT cloned
    // and current output data (commands)
    // are NOT cloned
    public VecSpeechDevice clone()
    {
        VecSpeechDevice vv = new VecSpeechDevice();
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
        vv.nextComandPoint = 0;
        vv.currentComandPoint = 0;
        vv.soundCycles = soundCycles;
        vv.oldCycles = oldCycles;
        vv.wavData = null;
        vv.currentSamplePos = -1;
        
        vv.spNextFast = spNextFast;
        vv.spNextSlow = spNextSlow;
        vv.spCommandMode = spCommandMode;
        vv.spVolume = spVolume;
        vv.spCommand = spCommand;
        vv.spPitch = spPitch;
        vv.spTempo = spTempo;
        vv.spBend = spBend;
        vv.spRepeat = spRepeat;
        return vv;
    }
    
    // following "intensive" data is not
    // initialized by cloning
    // it must be initialized if the clone is really "used"
    // (stepping back in emulator)
    public void initClone(E8910 e)
    {
        VecVoiceSamples.loadSamples();
        commands = new int[C_LEN];
        soundBytes = new byte[IBXM_MAXBUFFER/2];
//        e8910 = e;
//        e8910.setPortAdapter(this);
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
    // in preparation of using
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
    public void updateInputDataFromDevice()
    {
        if (!inputMode) return;
        
        if (VECSPEECH_PORT == 2)
        {
            // button state is "inverse": 0 = ready
            if (!isReady())
            {
                joyport.setButton2(true, true);
                
//                value = value | STATUS_LINE_MASK_PORT2;
            }
            else
            {
                joyport.setButton2(false, true);
//                value = value & (0xff - STATUS_LINE_MASK_PORT2);
            }
            if (!dataLineInput)
            {
                joyport.setButton1(true, true);
//                value = value | DATA_LINE_MASK_PORT2;
            }
            else
            {
                joyport.setButton1(false, true);
//                value = value & (0xff - DATA_LINE_MASK_PORT2);
            }
        }
    }
    @Override
    public void updateDeviceWithDataFromVectrex()
    {
        if (inputMode) return;
        if (VECSPEECH_PORT == 2) 
            dataLineInput = joyport.isButton1(true);
//            dataLineInput = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
    }
    
    // if i== true
    // than input enabled
    // input mode enabled means
    // vecvoice can WRITE to the port
    // and vectrex (over PSG) can read port
    @Override
    public void setInputMode(boolean i)
    {
        if (inputMode == i) return;
        inputMode = i;
        if (!inputMode) 
        {
            // for alex herberts driver
            // due to only one input mask
            // this should always be false!
            dataLineInput = joyport.isButton1(true);
//            dataLineInput = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
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
    public void step(VecX vectrex)
    {
        long c = vectrex.getCycles();
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
    
    // is VecVox enabled to receive more data (input buffer = 64 byte)
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
//                int lineWant = soundLength;
                soundLength = fillSoundBuffer(soundLength);
                soundLength = soundLength >soundBytes.length ? soundBytes.length : soundLength;

//System.out.println("Line wants: "+lineWant+", line got: "+soundLength);                
                if (soundLength>=0)
                {
// debug                    output = concat(output, soundBytes, soundLength);
                    line.write(soundBytes, 0, soundLength);
                }
                /* all debug
                // saving wave file makes sense if length = 0, 
                // this usually means we just finished playing a seqeunce of 
                // speech commands
                if (soundLength==0)
                {
                    saveWaveCollector();
                    resetWaveCollector();

// DEBUG                    ((StreamStreamWav1Channel)line).writeCollection();
                }
                */
            }
        }        
    }    
    
    // with the wav collector 
    // output data to line can be "collected"
    // and saved as a wav file
    // so we can examine out output more closely
    // using e.g. audacity
    
    // reset output
    public static void resetWaveCollector()
    {
         output = new byte[0];
    }

    // save a given byte sequence
    // as a wav file
    // using n as name combined with a static counter
    public static void saveWaveCollector(byte[] out, String n)
    {
        if (!DEBUG_WAV_OUT) return;
        String name = n+(sampleCount++)+".wav";
        try
        {
            byte[] orgData16Bit2Channel  = out;
            AudioFormat tinyformat = audioFormat;
            AudioInputStream audioStream = new AudioInputStream( new ByteArrayInputStream(orgData16Bit2Channel) ,tinyformat, orgData16Bit2Channel.length/2 );
            AudioFileFormat.Type targetType = SampleJPanel.findTargetType("wav");
            AudioSystem.write(audioStream,  targetType, new File(name));
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getDebugEntity().addLog(e, WARN);
        }
    }
    // saves the collected data,
    // usually a "complete" speech sequence
    public static void saveWaveCollector()
    {
        if (output.length > 0)
        saveWaveCollector(output, "Sample");
    }
    
    // returns  backwards position in samples
    // the last amplitude phase step from negative to positive
    // if no such change was found, than the
    // given "search" maximum (that was given in ms)
    // is returned
    int getLastPreviousNegativeToPositivePass(byte[] data, int ms) // 10 ms backwards
    {
        int sampleStartSearch = ms *44; // one millisecond worth of samples = 44,1
        sampleStartSearch *= 2; //16 bit
        int backPos = data.length - sampleStartSearch;
        
        if (backPos<0) return -1;

        if ((backPos%2) == 1) backPos--; // bit align 16 bit
        
        int posFound = backPos;
        
        
        // find the next position, where the samples pass from minus to positive
        int lastValue = 1;
        while (posFound < data.length)
        {
            int newValue = bit16(data, posFound);
            if (Math.abs(newValue)<amplitudeThreshold) newValue = 0;
            
            if ((lastValue <= 0) && ( newValue>0)) break;
            lastValue = newValue;
            posFound+=2;
        }
        if (posFound == data.length) 
        {
            // blend on ms
            return backPos;
        }
        
        return posFound;
    }
    
    // return position of first byte where the data in data[] steps from -0 to +
    // maxSearch given in samples, not in MS!
    int getNextPreviousNegativeToPositivePass(byte[] data, int maxSearch) 
    {
        int posFound = 0;
        maxSearch = maxSearch/2;
        maxSearch *= 2; // align
        
        // find the next position, where the samples pass from zero/minus to positive
        int lastValue = 1;
        while (posFound < data.length)
        {
            int val = bit16(data, posFound);

            if (Math.abs(val)<amplitudeThreshold) val = 0;
            
            if ((lastValue <= 0) && (val >0)) break;
            lastValue = val;
            posFound+=2;
        }
        if (posFound == data.length) return -1;
        if (posFound >maxSearch) posFound = maxSearch;
        
        return posFound;
    }
    
    // signed
    int bit16(byte[] loHi, int pos)
    {
        int lo= loHi[pos]&0xff;
        int hi= (loHi[pos+1]&0xff)*256;
        int val = lo+hi;
        if (val > Short.MAX_VALUE) val -= 65536;
        return val;
    }
    
    // the small array is
    // blend into the beginning of "large" array
    // in largeArray the first pass from - to + is searched and used for starting location
    // this also means that
    // silence is discarded
    byte[] blendWavStartFrequence(byte[] smallArray, byte[] largeArray, boolean seekStartWave)
    {
        int pos = 0;

        
//saveWaveCollector(smallArray, "smallArray");        
//saveWaveCollector(largeArray, "largeArray");        
        
        if (seekStartWave)
            pos = getNextPreviousNegativeToPositivePass(largeArray, smallArray.length);
        if (pos == -1) return concat(smallArray, largeArray);
    
        byte[] newArray = Arrays.copyOfRange(largeArray, pos, largeArray.length);

//saveWaveCollector(newArray, "largeArrayAlign");        
        
        int i = 0;
        while ((i+1 < smallArray.length) && (i+1 < newArray.length))
        {
            int val1 = bit16(newArray, i);
            int val2 = bit16(smallArray, i);
            int val = (val1+val2)/2;
            newArray[i] = (byte) (val & 0xff);
            newArray[i+1] = (byte) ((val>>8) & 0xff);
            i+=2;
        }
//saveWaveCollector(newArray, "largeArrayBlend");        
        return newArray;
    }
    
    // returns an array
    // truncated on both sides 
    // if values are |absolut| smaller/equal - maxNoise
    byte[] removeSilence(byte[] data, int maximumNoise)
    {
        int start = 0;
        int end = (data.length-2);
        
        if ((end%2) == 1) end--; // align
        int value = 0;
        while (start<end) 
        {
            // 16 bit signed
            value = bit16(data, start);


            if (Math.abs(value) > maximumNoise) break;
            start+=2;
        }
        // find - to + 
        if (value <0)
        {
            while (start > 0)
            {
                value = bit16(data, start);
                
                if (value >=0) break;
                start -=2;
            }
        }
        while (start > 0)
        {
            value = bit16(data, start);
            if (value <0) break;
            start -=2;
        }
        // start is now a wave start going from 0 to positive
        // with its larged peak going over MaxNoise
        
        
        
        
        while (end>start) 
        {
            // 16 bit signed
            value = bit16(data, end);

            if (Math.abs(value) > maximumNoise) break;
            end-=2;
            
        }
        // looking for next - to +
        if (value > 0)
        {
            while (end < data.length)
            {
                value = bit16(data, end);
                if (value <=0) break;
                end +=2;
            }
        }
        while (end < data.length)
        {
            value = bit16(data, end);
            if (value >0) break;
            end +=2;
        }
        
        byte[] outArray = Arrays.copyOfRange(data, start, end);
//saveWaveCollector(outArray, "Cut");
        
        return outArray;
    }
    
/*    
    
    
    Not Done:
    
Stress can be accomplished in two ways. One is to cause
vowels to play for a longer period of time. For example, in the
word "extent" use the "Fast" command in front of the "EH" in the
first syllable, which is unstressed and a "SLOW" command, or
and additional "EH" in front of the "EH" in the second syllable
which is stressed. A second way is to preceded the allophone
with the "STRESS" and RELAX commands. The STRESS
command duplicates the affect of slightly contracting the
muscles of the mouth and the relax command duplicates the
affects of slightly relaxing the muscles of the mouth. For
example; "STRESS, IH" sounds more like (but not quite) the
"IY" sound. Likewise, "RELAX, IY" sounds more like (but not
quite) an "IH" sound. Note that if you elect to use the
"STRESS" or "RELAX" command in combination with a
phoneme that has been doubled, then two command will be
needed, one in front of each of the phonemes.    
*/
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
            // current samplePos != -1 allways means "wavData" contains still data we can copy
            // there is a sample already loaded where we can get data from
            if (currentSamplePos != -1)
            {
                // all sample altering stuff is only done on a position 0 sample
                if (currentSamplePos == 0)
                {
                    if (removeSilence)
                    {
                        if (!afterPause)
                            if (removeSilenceFromSample)
                                wavData = removeSilence(wavData, maxNoise);
                    }
                    if (lastCommand>=128)
                        afterPause = false; // only reset pauseMode after a real sample
                }
                
                if (!SPO256AL2)
                {
                    if (enableCommands)
                    {
                        // only done when (currentSamplePos == 0)
                        speakjetPreprocessWavWithCommand();
                    }
                }

                // first time in this sample...
                // buffer is filled with preprocessed wave data
                if (currentSamplePos == 0)
                {
                    if (!blendEnable)
                    {
                        wavDataUsage = wavData;
                        wavDataLastEnd = new byte[0];
                        doSampleBlending = false;
                    }
                    else
                    {
                        // get a "good" position 
                        // that we can use for blending
                        // within the current sample
                        int pos = getLastPreviousNegativeToPositivePass(wavData, blendLen); // 10 ms backwards
                        if (lastCommand >= 128)
                            blendLen = BLEND_DEFAULT;
                        if (pos == -1)
                        {
                            wavDataUsage = wavData;
                            // if data can not blend, than we must copy it, so we do not lose the data
                            if (wavDataLastEnd != null)
                                wavDataUsage = concat(wavDataLastEnd, wavDataUsage);
                            wavDataLastEnd = null;
                            doSampleBlending = false;
                        }
                        else
                        {
                            wavDataUsage = new byte[pos];
                            System.arraycopy(wavData, 0, wavDataUsage, 0, pos);

                            // last blend is defined 
                            // a) if a pause or word and was reached than false
                            // b) if a phoneme ends with a "pause" than is false
                            // else (if defined at all) true

                            if (doSampleBlending) 
                            {
                                wavDataUsage = blendWavStartFrequence(wavDataLastEnd, wavDataUsage, alignBlendToAmplitude);
                            }
                            else
                            {
                                // if data should not blend, than we must copy it, so we do not lose the data
                                if (wavDataLastEnd != null)
                                    wavDataUsage = concat(wavDataLastEnd, wavDataUsage);
                            }
                            // remember the current (meaning NEXT) possible blending data
                            wavDataLastEnd = new byte[wavData.length-pos];
                            doSampleBlending = true;
                            System.arraycopy(wavData, pos, wavDataLastEnd, 0, wavData.length-pos);                        
                        }
                    }
                    // default is to remove silence
                    removeSilenceFromSample = true;
                }

                // 
                int rest = wavDataUsage.length - currentSamplePos;
                if (rest > restBuffer)
                {
                    System.arraycopy(wavDataUsage, currentSamplePos, soundBytes, outBufferPos, restBuffer);
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
                    System.arraycopy(wavDataUsage, currentSamplePos, soundBytes, outBufferPos, rest);
                    outBufferPos += rest; 
                    currentSamplePos = -1;
                    wavDataUsage = null;
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

            lastCommand = command;
            if (command == NO_COMMAND)
            {
                // check if there are lose ends from blending
                if (doSampleBlending)
                {
                    doSampleBlending = false;
                    wavDataUsage = wavDataLastEnd;
                    
                    currentSamplePos = 0;
                    // 
                    int rest = wavDataUsage.length - currentSamplePos;
                    if (rest > restBuffer)
                    {
                        System.arraycopy(wavDataUsage, currentSamplePos, soundBytes, outBufferPos, restBuffer);
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
                        System.arraycopy(wavDataUsage, currentSamplePos, soundBytes, outBufferPos, rest);
                        outBufferPos += rest; 
                        currentSamplePos = -1;
                        wavDataUsage = null;
                        restBuffer -= rest;
                        size = size + rest;
                        // wavData Buffer is now "empty"
                        // we can continue - or do nothing since by doing nothing we would also
                        // go to the next command fetch ...
                        continue;
                    }

                }
                
                
                break; // no command -> we can do nothing queue is empty
            }
            
            // System.out.println("SpeechCommand: "+command);
            // now lets get a new sample
            MemSound sample=null;
            if (SPO256AL2) // old chip
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
                    {
                        speakJetAcceptCommand(command);
                    }
                    continue;
                }
                // other wise load a "simple" sample
                // preprocessing samples is done "while" the outbound buffer is filled
                sample = VecVoxSamples.getSample(command);

                if (command >= 128)
                {
                    if (command < 255)
                    {
                        VecVoxSamples.SpeakJetMSA sp = VecVoxSamples.allSamples[command-128];
                        if (!afterPause)
                            if (sp.stoppedSound)
                                removeSilenceFromSample = false;
                        isVoiced = (command<182); // datasheet lists all voices allophones... look there...
                    }
                    else
                    {
                        isVoiced = false;
                    }
                }
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
    
    // spare the last X byte of sample data
    // and use them to "blend" with next sample data
    // this might lead to smoother transitions between samples
    // but what should must be done is: align to frequency window of
    // both samples, otherwise the interference might negate data, that is NOT what we want!
    
    // preprocessing
    // changes wav data in "wavData"
    // according to command
    // wavData must be filled and position 0
    void speakjetPreprocessWavWithCommand()
    {
        // only preprocess "fresh" data
        if (currentSamplePos != 0) return;
        
        boolean enabled = false;
        
//if (enabled)
        if (spBend > 5) // default 5
        {
            // http://philippseifried.com/blog/2011/10/20/dynamic-audio-in-as3-part-3-robot-voice/
            
            // the shift value below has no foundational background what so ever
            // I don't know if this kind of shifting is ment by "bending" nor
            // would I know what the correct "angle" would be
            // this is pure guess work
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
        boolean doTarsos = false;
        double currentFactor = 1.0;
        RateTransposer rateTransposer = null;
        
// many cracks        
//if (enabled)
        if ((spPitch != 88) && (isVoiced))// default 88
        {
            doTarsos = true;
            
            double tmp = 1.0/(((double)spPitch)/88.0);
            // doing the full percentage is (listing to the real thing)
            // way to much, below cutting of the factor is again pure
            //  guessing...
            
            tmp = tmp -1;
            tmp = tmp/5;
            tmp = tmp +1;

            doTarsos = true;
            
            
            currentFactor *=  tmp;
            currentFactor *= tmp;
            
            // tarsos hardcoded restrictions
            if (currentFactor<0.1) currentFactor = 0.1;
            if (currentFactor>4.0) currentFactor = 4.0;
            
            rateTransposer = new RateTransposer(currentFactor);
            
        }

// some cracks
//if (enabled)
        if (spTempo != 114) // default 114
        {
            double tmp = (((double)spTempo)/114.0);
            
            // tmp is again modified by purse guessing
            if (tmp <1.0) tmp *= 0.9;
            if (tmp >1.0) tmp *= 1.1;
            currentFactor *=  tmp;
            doTarsos = true;
        }       
// ok
        if (spNextSlow)
        {
            // doc says half, but half seems much
            spNextSlow = false;
            currentFactor *= 0.8;
            doTarsos = true;
        }
// ok
        if (spNextFast)
        {
            // doc says 2, but that seems much
            spNextFast = false;
            currentFactor *= 1.2;//2;
            doTarsos = true;
        }     
        if (doTarsos)
        {
            try
            {
                WaveformSimilarityBasedOverlapAdd wsola;
                TarsosReceiver receiver = new TarsosReceiver();

                int sampleRate = 44100;
                int sequenceWindowInMS = 20; // slower -> should be bigger, faster -> should be smaller
                int overlapSeekingWindowsSizeInMS = 15; 
                int overlapLength = 10;
                
                
                if (currentFactor<1) 
                {
                    sequenceWindowInMS = 30;
                    overlapSeekingWindowsSizeInMS = 15;
                    overlapLength = 5;
                    
                }
                if (currentFactor>1) 
                {
                    sequenceWindowInMS = 15;
                    overlapSeekingWindowsSizeInMS = 8;
                    overlapLength = 4;
                }
                
                Parameters wparam = new Parameters(currentFactor,sampleRate,sequenceWindowInMS, overlapSeekingWindowsSizeInMS, overlapLength);
                wsola = new WaveformSimilarityBasedOverlapAdd(wparam);
                AudioDispatcher dispatcher = AudioDispatcherFactory.fromByteArray(wavData, audioFormat,wsola.getInputBufferSize(),wsola.getOverlap());
                wsola.setDispatcher(dispatcher);

//is there a difference in what order wsola nd rate transponder is done?                
                if (rateTransposer != null)
                    dispatcher.addAudioProcessor(rateTransposer); 
                dispatcher.addAudioProcessor(wsola); 
                

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
            isVoiced = false;
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
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = false;
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
            MemSound sample = VecVoxSamples.getPauseSample(1);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = true;
            blendLen = 30;
            isVoiced = false;
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
            MemSound sample = VecVoxSamples.getPauseSample(2);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = true;
            blendLen = 60;
            isVoiced = false;
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
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = true;       
            blendLen = 200;
            isVoiced = false;
        }

        // the documentation of Speakjet says
        // for the next pauses there should be no "blending"
        //
        // looking at the wav files thru a "microscope" tells me
        // differently, therefor I DO blend here as well, although a little shorter
        else if (command == 4) // pause 30ms after last command
        {
            MemSound sample = VecVoxSamples.getPauseSample(4);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = true;
            blendLen = 30/3;
            isVoiced = false;
        }
        else if (command == 5) // pause 60ms after last command
        {
            MemSound sample = VecVoxSamples.getPauseSample(5);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = true;
            blendLen = 60/3;
            isVoiced = false;
        }
        else if (command == 6) // pause 90ms after last command
        {
            MemSound sample = VecVoxSamples.getPauseSample(6);  
            wavData = Arrays.copyOf(sample.getLeftData(), sample.getLeftData().length);
            currentSamplePos = 0;
            removeSilenceFromSample = false; // pause should aknowledege silence
            afterPause = true;
            blendEnable = true;
            blendLen = 90/3;
            isVoiced = false;
        }
        else if (command == 7) // fast play in double time
        {
            spNextFast = true;
        }
        else if (command == 8) // slow play in 1,5 time
        {
            spNextSlow = true;
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
            blendEnable = true;
            afterPause = true;
            blendLen = BLEND_DEFAULT;
            isVoiced = false;
        }
    }    
    public static byte[] concat(byte[] a, byte[] b) 
    {
       int aLen = a.length;
       int bLen = b.length;
       byte[] c= new byte[aLen+bLen];
       System.arraycopy(a, 0, c, 0, aLen);
       System.arraycopy(b, 0, c, aLen, bLen);
       return c;
    }	
    public static byte[] concat(byte[] a, byte[] b, int bMax) 
    {
       int aLen = a.length;
       int bLen = bMax;
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

    // "dummy" player used by Speech panel
    static Thread speaker = null;
    static boolean stop = false;
    static boolean running = false;
    public static void speak(final ArrayList<Integer> commands, final boolean isVecVoice)
    {
        stopSpeaking();
        if (speaker != null) return;
        if (running) return;
        running = true;
        
        speaker = new Thread() 
        {
            public void run() 
            {
                VecSpeechDevice vecSpeech = new VecSpeechDevice();
                vecSpeech.commands = new int[C_LEN];
                vecSpeech.soundBytes = new byte[IBXM_MAXBUFFER/2];
                for (int i=0; i<C_LEN; i++) vecSpeech.commands[i] = -1;
                
                vecSpeech.setVecVoice(isVecVoice);
                int commandPointer = 0;
                long cycles = 0;
                
                try 
                {
                    Thread.sleep(10);
                    try
                    {
                        int overloop =0;
                        while (running)
                        {
                            if (commandPointer < commands.size())
                            {
                                if (vecSpeech.isReady())
                                {
                                    vecSpeech.addCommand(commands.get(commandPointer++));
                                }
                            }
                            vecSpeech.stepSound(cycles);      
                            
                            // x cycles = 1 ms
                            // 1500000 = 1s
                            // 150000 = 0,1s
                            // 15000 = 0,01s
                            // 1500 = 0,001s
                            
                            
                            Thread.sleep(5);
                            cycles = cycles + (5*1500);
                            
                            if (commandPointer == commands.size())
                            {
                                if (vecSpeech.nextComandPoint == vecSpeech.currentComandPoint)  // no command
                                {
                                    overloop++;
                                    
                                    if (overloop == 50)
                                    {
                                        Thread.sleep(500);
                                        running = false;
                                    }
                                }
                            }
                        }
                        
                                       
                    }
                    catch (final Throwable e)
                    {
                        e.printStackTrace();
                    }
                } 
                catch(InterruptedException v) 
                {
                }

                if (saveWave)
                    VecSpeechDevice.saveWaveCollector();
                speaker = null;
                running = false;
            }  
        };
        speaker.setName("SpeakJet speaker...");
        speaker.start();               
    }
    public static void stopSpeaking()
    {
        if (speaker==null) return;
        running = false;
        try
        {
            while (speaker!=null) Thread.sleep(10);
        }
        catch (Throwable e)
        {
        }
    }
}



