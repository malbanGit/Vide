/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;
import static de.malban.vide.vecx.VecXPanel.DEVICE_IMAGER;
import static de.malban.vide.vecx.devices.ImagerWheel.NARROW_ESCAPE;

/**
 *
 * @author malban
 */
public class Imager3dDevice extends AbstractDevice
{
    public static final boolean ONLY_OUTPUT_VALUES = false;

    long changeStartCycle = 0;

    public static int STATE_TRUE = 1;
    public static int STATE_FALSE = -1;
    public static int STATE_UNKOWN = 0;
    
    int oldState3 = STATE_UNKOWN;
    
    long cycleCountInputLow = -1;
    long cycleCountInputHigh = -1;
    
    
    double imagerAngle = 0;
    double spinPerSecond = 0;
    long spinCycleCount = 0;
    double incPerCycle = 0;
    
    double playLeftEyeAngle = 90;
    double playRightEyeAngle = 270;
    
    // attention!
    // the whole size DOES matter
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
    public static final int TRANSISTOR_RANGE = 500; //cylces
    int indexInterruptCycles = 0;
    
    WheelData currentWheel = NARROW_ESCAPE;
    
    public static final int DEFAULT_TRANSISTOR_ANGLE = 339;
    // 18 o clock = 0 degrees
    public static double photoReceiverAngleStart = DEFAULT_TRANSISTOR_ANGLE;
    double indexAngleWidth = 5;
    private boolean leftEnabled = true;
    private boolean rightEnabled = true;
    private boolean bwEnabled = true;
    
    public WheelData getWheel()
    {
        return currentWheel;
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
        forceSpinPerSecond(10);
    }

    int pulseChanges = 0;
    int lastPulseChanges = 0;
    
    long lastCycles = 0;
    long lastIndexPulseCycles = 0;
    long reallylastIndexPulseCycles = 0; // for narrow escape e shorten the index pulse in emulation!
    long indexPulseStart = 0;
    boolean lastIndex = false;
    @Override
    public void step()    
    {
        if (joyport == null) return;
        VecX vectrex = joyport.vecx;
        long c = vectrex.getCycles();
        long dif = c-lastCycles;
        lastCycles = c;
        double lastAngle = imagerAngle;

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
//                    System.out.println("INDEX TRIGGERED");
                    lastPulseChanges = pulseChanges;
                    pulseChanges = 0;
                    indexPulseStart = c;
                    reallylastIndexPulseCycles = 0;
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
        
        // read, assuming button 3 is the relevant input button to the goggles
        // only use states which are generated from REAL output
        boolean currentState3_ = joyport.isButton3(true);
        int currentState3;
        if (ONLY_OUTPUT_VALUES)
        {
            currentState3 = STATE_UNKOWN;
            if (!inputFromDeviceToVectrex)
            {
                if (currentState3_) currentState3 = STATE_TRUE;
                else currentState3 = STATE_FALSE;

                if (currentState3 != oldState3)
                {
                    long changeDif = c-changeStartCycle;
                    if (oldState3 == STATE_FALSE) 
                    {
                        cycleCountInputLow = changeDif;
                    }
                    else if (oldState3 == STATE_TRUE) 
                        cycleCountInputHigh = changeDif;
                    changeStartCycle = c;
                }
            }
        }
        else
        {
            currentState3 = STATE_UNKOWN;
            if (currentState3_) 
                currentState3 = STATE_TRUE;
            else 
                currentState3 = STATE_FALSE;

            if (currentState3 != oldState3)
            {
                long changeDif = c-changeStartCycle;
                if (oldState3 == STATE_FALSE) 
                {
//                    System.out.println("low->high (low endured: "+changeDif+")");
                    pulseChanges++;
                    cycleCountInputLow = changeDif;
                }
                else if (oldState3 == STATE_TRUE) 
                {
//                    System.out.println("high->lo (high endured: "+changeDif+")");
                    pulseChanges++;
                    cycleCountInputHigh = changeDif;
                }
                changeStartCycle = c;
            }
        }
        oldState3 = currentState3;
    }

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
    
    
    public int getLastPulseChanges()
    {
        return lastPulseChanges;
    }
    public long getLastIndexPulse()
    {
        return lastIndexPulseCycles;
    }
    public long getReallyLastIndexPulse()
    {
        return reallylastIndexPulseCycles;
    }
    
    
    public long getLowPulse()
    {
        return cycleCountInputLow;
    }
    public long getHighPulse()
    {
        return cycleCountInputHigh;
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
    // vecvoice can WRITE to the port
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

}