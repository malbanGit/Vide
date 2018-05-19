/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.parts;

/** http://www.electronics-tutorials.ws/rc/rc_2.html
 * Vc = Vs (1-e^(-t/RC)) charging
 * Vc = Vs (e^(-t/RC)) discharging
 * @author malban
 */
public class Capacitorial 
{
    private double resistorOhm;
    private double capacitorFarad;
    
    private double currentVoltage=0;
    private double supplyVoltage=0;
    private double timeConstant;

    private double percentageDifChangePerCycle;

    // Perhaps
    // zero Offset: 10nF = 0.01uF
    //              75Ohm
    // Voltages respecitvly -> Tau about 1 cycle
    
    // Integrators "Hold" dito
    
    
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
            currentVoltage -= percentageDifChangePerCycle*dif;
        }
    }
    
    // -128 - +127
    public void setDigitalVoltage(int v)
    {
        if (v>=0)
        {
            supplyVoltage = (((double)v)/127.0)*5.0;
        }
        else
        {
            supplyVoltage = (((double)v)/128.0)*5.0;
        }
    }
}
