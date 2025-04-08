/*
 * This should also be done for
a) zeroing
b) integrator s/h
c) integrators themselfs

 */
package de.malban.vide.vecx;

import java.io.Serializable;

/** http://www.electronics-tutorials.ws/rc/rc_2.html
 * Vc = Vs (1-e^(-t/RC)) charging
 * Vc = Vs (e^(-t/RC)) discharging
 * @author malban
 */
public class Capacitorial implements Serializable
{
    double resistorOhm;
    double capacitorFarad;
    
    double currentVoltage=0;
    double supplyVoltage=0;
    double timeConstant;

    
    double offsetUnloadValue;
    
    double percentageDifChangePerCycle;
    
    // Perhaps
    // zero Offset: 10nF = 0.01uF
    //              75Ohm
    // Voltages respecitvly -> Tau about 1 cycle
    
    // Integrators "Hold" "load" dito
    
    
    // Integrators
    // 10000 Ohm Tau about 150 cycles
    
    // Zeroing
    // zero Offset: 10nF = 0.01uF
    //              75Ohm + 220Ohm = 295 Ohm or 220 Ohm
    // Voltages respecitvly -> Tau about 4,5 cycle or 3 cycles
    
    // http://www.nhu.edu.tw/~chun/BE-Ch11-Capacitor%20Charging%20&%20Discharging.pdf
    // http://mustcalculate.com/electronics/capacitorchargeanddischarge.php
    // one step = 1/1500000 second, = 1 vectrex cycle
    // = 0,00000066 = 0,6µ = 666n
    private static double VECTREX_CYCLE_TIME = 1.0/1500000.0;
    public Capacitorial(double r, double c)
    {
        resistorOhm = r;
        capacitorFarad = c;
        timeConstant = r*c;
        
        percentageDifChangePerCycle = Math.exp(-VECTREX_CYCLE_TIME/timeConstant);
/*
        System.out.print("resistorOhm = " + resistorOhm+"\n");
        System.out.print("capacitorFarad = " + capacitorFarad+"\n");
        System.out.print("VECTREX_CYCLE_TIME = " + VECTREX_CYCLE_TIME+"\n");
        System.out.print("timeConstant = " + timeConstant+"\n");
        System.out.print("percentageDifChangePerCycle = " + percentageDifChangePerCycle+"\n");
*/
    }
    public int getIntVoltageValue()
    {
        return (int)currentVoltage;
    }
    public double getVoltageValue()
    {
        return currentVoltage;
    }
    public double getDigitalValue()
    {
        return currentVoltage/5.0*128.0;
    }
    public int getDigitalIntValue()
    {
        return (int)(((currentVoltage+offsetUnloadValue)/5.0*128.0));
    }
            
    public void doStep()
    {
        boolean charging = (Math.abs(currentVoltage) < Math.abs(supplyVoltage));
        double dif = supplyVoltage - currentVoltage;
        if (charging)
        {
            currentVoltage += percentageDifChangePerCycle*dif;
        }
        else
        {
            currentVoltage += percentageDifChangePerCycle*dif;
        }
    }
    public void doDischargeStep()
    {
        currentVoltage -=0.000000008;
    }
    // -128 - +127
    public void setDigitalVoltage(int v)
    {
        offsetUnloadValue=0;
        if (v<=127)
        {
            supplyVoltage = (((double)v)/127.0)*5.0;
        }
        else
        {
            supplyVoltage = (((double)v-256)/128.0)*5.0;
        }
    }
}
