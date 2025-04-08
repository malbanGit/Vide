/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

/**
 *
 * @author salom
 */
public class GenerationParameters 
{
    boolean divideEqually = true;
    boolean doIntensities = false;
    int intensityMax = 0x7f;
    int intensityMin = 0x1f;
    int intensitySteps = 0x5;
    String factorStringNew = "";
    boolean useOldSmartlist = false;    // either one must be set
    boolean compileForVB = true;        // either one must be set
    int usedScale = 9;
    int currentIntensity;
    String functionPrefix = "SM_";
    boolean noShift = false;
    int MAX_EQUAL_TYPE = 7;
    boolean lastWasMove = true;
    boolean testLowY = true;
    boolean hiLoEnabled = true;
    int ythreshold = -100;
    int smartMax = 100;
    boolean disableCalibration = true;

    boolean useFactors = false;
    int actualFactor = 1;
    String factorName = "VL_BLOW_UP";
    int actualIntensity = 0x7f;
    int actualScale = 9;
    boolean useIntensity = false;
    String paraName = "";
    boolean doNoPositionMove = true;
    
    boolean rts2 = false;
}
