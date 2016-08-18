/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.VideConfig;
import de.malban.vide.vecx.VecX;
import static de.malban.vide.vecx.VecXPanel.DEVICE_IMAGER;
import static de.malban.vide.vecx.devices.ImagerWheel.NARROW_ESCAPE;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class Imager3dDevice extends AbstractDevice implements Serializable
{
    public static final boolean ONLY_OUTPUT_VALUES = false;

    long changeStartCycle = 0;

    public static int STATE_TRUE = 1;
    public static int STATE_FALSE = -1;
    public static int STATE_UNKOWN = 0;
    
    int oldState3Int = STATE_UNKOWN;


    // attention!
    // the hole size (inde hole) DOES matter
    // since the index hole triggers an interrupt from low to high
    // while handling the interrupt
    // a resetRef0 is called
    // which  resets VIA PCR to interrupt from high to low
    // thus at the "end" of the index another interrupt is called
    // if that happens at the wrong moment
    // the game you play will crash or behave weirdly!
    
    // actually...
    // things changed, I added an interrupt length
    // which should simulate
    // at what range the phototransitor reacts on the LED
    // that range is considerably smaller!
    // I don't know how small - but I use a small
    // value that just an interrupt is triggerd - nothing else
    // see Imager3dDevice
    // the value also must not be TOO
    // small, otherwise the spin up sequence (which polls CA1, and does not wait for an interrupt)
    // does not work anymore...
    public static final int TRANSISTOR_RANGE = 500; //cylces
    
    public static final int DEFAULT_TRANSISTOR_ANGLE = 339;
    
    WheelData currentWheel = NARROW_ESCAPE;
    
    long pulseLenCycles = -1;
    long waveLenCycles = -1;
    
    
    double imagerAngle = 0;
    double spinPerSecond = 0;
    long spinCycleCount = 0;
    double incPerCycle = 0;
    
    double playLeftEyeAngle = 90;
    double playRightEyeAngle = 270;
    
    boolean automaticMode = true;
    int indexInterruptCycles = 0;
    
    
    // 18 o clock = 0 degrees
    public static double photoReceiverAngleStart = DEFAULT_TRANSISTOR_ANGLE;
    public static double indexAngleWidth = 5;
    private boolean leftEnabled = true;
    private boolean rightEnabled = true;
    private boolean bwEnabled = false;

    int lastPulseChanges = 0;
    long lastCycles = 0;
    long lastIndexPulseCycles = 0;
    long reallylastIndexPulseCycles = 0; // for narrow escape e shorten the index pulse in emulation!
    long indexPulseStart = 0;
    boolean lastIndex = false;
    long indexReceivedCycleCount = 0;
        
    long waveStartCycle = 0;
    long waveLoadEndCycle = 0;
    double adjustFreq = 0;
    
    
        public void setIgnoreReset(boolean b)
    {
        resetResistent = b;
    }
    boolean resetResistent = false;
    void reset()
    {
        if (resetResistent) return;
        changeStartCycle = 0;
        oldState3Int = STATE_UNKOWN;
        pulseLenCycles = -1;
        waveLenCycles = -1;
        imagerAngle = 0;
        spinPerSecond = 0;
        spinCycleCount = 0;
        incPerCycle = 0;
        automaticMode = VideConfig.getConfig().imagerAutoOnDefault;
        indexInterruptCycles = 0;
        leftEnabled = true;
        rightEnabled = true;
        bwEnabled = false;
        lastPulseChanges = 0;
        lastCycles = 0;
        lastIndexPulseCycles = 0;
        reallylastIndexPulseCycles = 0; 
        indexPulseStart = 0;
        lastIndex = false;
        indexReceivedCycleCount = 0;
        waveStartCycle = 0;
        waveLoadEndCycle = 0;
        adjustFreq = 0;
    }
    public WheelData getWheel()
    {
        return currentWheel;
    }
    public void setWheel(WheelData w)
    {
        currentWheel = w;
        if (!automaticMode)
            forceSpinPerSecond(currentWheel.defaultFrequency);
    }
    public void setWheel(String wheel)
    {
        currentWheel = WheelData.getWheel(wheel);
        if (!automaticMode)
            forceSpinPerSecond(currentWheel.defaultFrequency);
    }
    public void setJoyport(VectrexJoyport j)
    {
        super.setJoyport(j);
        if (j!=null)
        {
            if (j.vecx!=null)
            {
                j.vecx.setImager(true);
            }
            
        }
    }
    public void deinit()
    {
        if (inDeinit) return;
        reset();
        if (joyport != null)
        {
            if (joyport.vecx!=null)
            {
                joyport.vecx.setImager(false);
            }
        }
        super.deinit();
    }
    public int getDeviceID()
    {
        return DEVICE_IMAGER;
    }
    public Imager3dDevice()
    {
    }

    public void setAuto(boolean a)
    {
        automaticMode = a;
    }
    public boolean isAuto()
    {
        return automaticMode;
    }

    @Override
    public void step()    
    {
        if (joyport == null) return;
        VecX vectrex = joyport.vecx;
        long c = vectrex.getCycles();
        long dif = c-lastCycles;
        lastCycles = c;
        double lastAngle = imagerAngle;
        
        
        
        // simulate the index hole
        // simulate index hole spinning
        // we are looking THRU the imager
        // the imager is than spinning counter clockwise
        imagerAngle = (imagerAngle- (((double)dif) * incPerCycle));
        if (imagerAngle<0) imagerAngle = imagerAngle+360;
        
        double indexAngle = (currentWheel.indexAngle+imagerAngle)%360;
        if (Math.abs(indexAngle-photoReceiverAngleStart)<indexAngleWidth)
        {
            if (indexInterruptCycles<TRANSISTOR_RANGE)
            {
                joyport.setButton4(true, true);
                if (lastIndex==false) 
                {
                    indexPulseStart = c;
                    reallylastIndexPulseCycles = 0;
                    indexReceivedCycleCount = c;
                }
            }
            else
            {
                joyport.setButton4(false, true);
                if (reallylastIndexPulseCycles == 0)    
                    reallylastIndexPulseCycles = c-indexPulseStart;
            }
            indexInterruptCycles++;
            lastIndex = true;
        }
        else
        {
            joyport.setButton4(false, true);
            if (lastIndex==true) 
            {
                lastIndexPulseCycles = c-indexPulseStart;
            }
            lastIndex = false;
            indexInterruptCycles = 0;
        }

        // figure out the wave and pulse length
        // to a) show it to the user
        // b) in automatic mode - calc the spin speeds
        boolean currentState3Boolean = joyport.isButton3(true);
        int currentState3Int;

        if ((ONLY_OUTPUT_VALUES) && (inputFromDeviceToVectrex))
        {
            currentState3Int = STATE_UNKOWN;
        }       
        else
        {
            if (currentState3Boolean)  currentState3Int = STATE_TRUE;
            else  currentState3Int = STATE_FALSE;
        }
        if (currentState3Int == oldState3Int) return;

        // a change in button 3 occured this round
        if (currentState3Int == STATE_UNKOWN) 
        {
            if (oldState3Int == STATE_FALSE)
            {
                if (waveLoadEndCycle == 0)
                    waveLoadEndCycle = c;
            }
            oldState3Int = currentState3Int;
            return;
        }
        else if (currentState3Int==STATE_TRUE) // state change low to high
        {
            if (waveLoadEndCycle == 0)
                waveLoadEndCycle = c;
            oldState3Int = currentState3Int;
            return;
        }
        else if (currentState3Int==STATE_FALSE) // state change high (or none) to low, lastwave endet, new wave starts
        {
            // wave was finished
            pulseLenCycles = waveLoadEndCycle-waveStartCycle;
            waveLenCycles = c-waveStartCycle;

            // new wave starts
            waveStartCycle = c;
            waveLoadEndCycle = 0;
            oldState3Int = currentState3Int;
        }
        
        if (automaticMode) 
            adjustSpeed(((double)waveLenCycles)/1500000.0, ((double)pulseLenCycles)/1500000.0);
    }
    

    // eye colors are
    // called from emulation to 
    // set the color to the vector which is drawn
    // allways both eyes are asked for
    // one eye is allways black (not drawn)
    // -1 indicated not drawn
    // -2 indicated BW mode
    // 0 is auto translated to -1 (0 is black)
    // positive numbers correspond to the color # in the wheel
    public int getRightColor()
    {
        if (!rightEnabled) return -1;
        double start = 0;
        double end = 0;
        // eye is at 90° +-10
        double cuurentAngle = imagerAngle; // for debugging, otherwise threads change the angle all the time!
        for (int i=0; i<currentWheel.startAngle.length; i++)
        {
            start = currentWheel.startAngle[i];
            end = currentWheel.startAngle[(i+1)%currentWheel.startAngle.length];
            
            double s1 = (start+cuurentAngle)%360;
            double e1 = (end+cuurentAngle)%360;
            
            if (s1>e1) e1 +=360;
            
            if ((s1<playRightEyeAngle) && (e1>playRightEyeAngle))
            {
                if (i==0) return 0;
                if (bwEnabled) return -2;
                return i;
            }
        }
        
        return -1;
    }
    public int getLeftColor()
    {
        if (!leftEnabled) return -1;
        double start = 0;
        double end = 0;
        // eye is at 90° +-10
        double cuurentAngle = imagerAngle; // for debugging, otherwise threads change the angle all the time!
        for (int i=0; i<currentWheel.startAngle.length; i++)
        {
            start = currentWheel.startAngle[i];
            end = currentWheel.startAngle[(i+1)%currentWheel.startAngle.length];
            
            double s1 = (start+cuurentAngle)%360;
            double e1 = (end+cuurentAngle)%360;
            
            if (s1>e1) s1 -=360;
            
            if ((s1<playLeftEyeAngle) && (e1>playLeftEyeAngle))
            {
                if (i==0) return 0;
                if (bwEnabled) return -2;
                return i;
            }
        }
        
        return -1;
    }
    
    public long getLastIndexPulse()
    {
        return lastIndexPulseCycles;
    }
    public long getReallyLastIndexPulse()
    {
        return reallylastIndexPulseCycles;
    }
    
    
    public long getPulseLen()
    {
        return pulseLenCycles;
    }
    public long getWaveLen()
    {
        return waveLenCycles;
    }
    
    
    public double getAnglePerCycle()
    {
        return incPerCycle;
    }
    public long getCyclePerSpin()
    {
        return spinCycleCount;
    }

    public void forceSpinPerSecond(double d)
    {
        spinPerSecond = d;
        adjustFreq = spinPerSecond;

        // 1 second = 1500000 cycles
        
        spinCycleCount =(int) (1500000/spinPerSecond);
        incPerCycle = 360.0 / (1500000.0/spinPerSecond);
    }
    
    public double getSpinPerSecond()
    {
        return spinPerSecond;
    }
    
    public double getAngle()
    {
        return imagerAngle;
    }
    
    public String toString()
    {
        return "Imager";
    }
    
    // if i== true
    // than input enabled
    // input mode enabled means
    // device can WRITE to the port
    // and vectrex (over PSG) can read port
    @Override
    public void setInputMode(boolean i)
    {
        inputFromDeviceToVectrex = i;
    }
    boolean inputFromDeviceToVectrex = true;

    /**
     * @return the leftEnabled
     */
    public boolean isLeftEnabled() {
        return leftEnabled;
    }

    /**
     * @param leftEnabled the leftEnabled to set
     */
    public void setLeftEnabled(boolean leftEnabled) {
        this.leftEnabled = leftEnabled;
    }

    /**
     * @return the rightEnabled
     */
    public boolean isRightEnabled() {
        return rightEnabled;
    }

    /**
     * @param rightEnabled the rightEnabled to set
     */
    public void setRightEnabled(boolean rightEnabled) {
        this.rightEnabled = rightEnabled;
    }

    /**
     * @return the bwEnabled
     */
    public boolean isBwEnabled() {
        return bwEnabled;
    }

    /**
     * @param bwEnabled the bwEnabled to set
     */
    public void setBwEnabled(boolean bwEnabled) {
        this.bwEnabled = bwEnabled;
    }
    
    
    

    // in automatic mode PWM is simulated
    // each cycle of one low + one hi sequence is taken as one
    // wavelength
    // the low time of the wavelength is taken as the LOAD of the PWM
    // the generated load is  a value between 0 ... 1 (a percentage of the total wavelength (1) )
    // the frequency (speed of the motor) must be derived from that load percentage
    void adjustSpeed(double waveLen, double pulseLen)
    {
        // following formula and parameters are a copy/paste from MAME/Mess
        // done by (c) Mathis Rosenhauer, BSD-3-Clause
        // MAME
            /*  The Vectrex sends a stream of pulses which control the speed of
                the motor using Pulse Width Modulation. Guessed parameters are MMI
                (mass moment of inertia) of the color wheel, DAMPC (damping coefficient)
                of the whole thing and some constants of the motor's torque/speed curve.
                pwl is the negative pulse width and wavel is the whole wavelength. 
            */
        
        double DAMPC = -0.2;
        double MMI  = 5.0;
        // 		ang_acc = (50.0 - 1.55 * m_imager_freq) / MMI;
	//		m_imager_freq += ang_acc * m_pwl + DAMPC * m_imager_freq / MMI * wavel;

        double ang_acc = (50.0 - 1.55 * adjustFreq) / MMI;
	adjustFreq += ang_acc * pulseLen + DAMPC * adjustFreq / MMI * waveLen;

        // and set the frequency!
        forceSpinPerSecond(adjustFreq);
    }
}         

