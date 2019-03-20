/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import de.malban.graphics.Single3dDisplayPanel;
import static de.malban.graphics.VectorColors.VECCI_BACKGROUND_COLOR;
import de.malban.util.XMLSupport;
import java.awt.Color;

/**
 *
 * @author malban
 */
public class StoryboardElement extends Single3dDisplayPanel
{
    public int listScaleFrom = 80;
    public int listScaleTo = 80;

    public int listScaleStart = 80;
    public int listScaleDelay = 0;
    public int listScaleIncrease = 0;
    
    public int intensityFrom = 127;
    public int intensityTo = 127;

    public int intensityStart = 127;
    public int intensityDelay = 0;
    public int intensityIncrease = 0;
    
    public int moveScale = 80;

    public int positionXFrom = 0;
    public int positionYFrom = 0;
    public int positionXTo = 0;
    public int positionYTo = 0;

    public int positionXStart = 0;
    public int positionYStart = 0;
    public int positionXDelay = 0;
    public int positionYDelay = 0;
    public int positionXIncrease = 0;
    public int positionYIncrease = 0;
    
    public boolean disabled = false;
    public boolean loop = true;
    public boolean _goto = false;
    public boolean pause = false;
    public boolean manualRoundCount = false;
    public boolean animationLoop = true;
    
    public String drawType = "synced";
    public String listName = "";

    public int delay = 0;
    public int vectrexdelay = 3;
    public int loopCount = 0;
    public int resyncMax = 20;
    public int factor = 1;
    public int goto_value = 0;
    
    public int roundCount = 0;
    
    public int version = 1;

    public void calculateV2()
    {
        // calc delay and increase for V2
        if (roundCount == 0)
        {
            listScaleDelay = 0;
            listScaleIncrease = 0;
            intensityDelay = 0;
            intensityIncrease = 0;
            positionXDelay = 0;
            positionYDelay = 0;
            positionXIncrease = 0;
            positionYIncrease = 0;
            return;
        }
        double dif = listScaleTo - listScaleFrom;
        double perRound = dif/((double)roundCount);
        int round = 0;
        if (perRound>0)
            round = (int) (perRound+0.99999);
        else
            round = (int) (perRound-0.99999);
        if (dif == 0)
        {
            listScaleDelay = 0;
            listScaleIncrease = 0;
        }
        else
        {
            listScaleIncrease = round;
            if (Math.abs(perRound)>=1)
                listScaleDelay = 1;
            else
            {
                double inverse = (1/Math.abs(perRound))+1;
                listScaleDelay = (int)inverse;
            }
        }

        dif = intensityTo - intensityFrom;
        perRound = dif/((double)roundCount);
        if (perRound>0)
            round = (int) (perRound+0.99999);
        else
            round = (int) (perRound-0.99999);
        if (dif == 0)
        {
            intensityDelay = 0;
            intensityIncrease = 0;
        }
        else
        {
            intensityIncrease = round;
            if (Math.abs(perRound)>=1)
                intensityDelay = 1;
            else
            {
                double inverse = (1/Math.abs(perRound))+1;
                intensityDelay = (int)inverse;
            }
        }        
        
        dif = positionXTo - positionXFrom;
        perRound = dif/((double)roundCount);
        if (perRound>0)
            round = (int) (perRound+0.99999);
        else
            round = (int) (perRound-0.99999);
        if (dif == 0)
        {
            positionXDelay = 0;
            positionXIncrease = 0;
        }
        else
        {
            positionXIncrease = round;
            if (Math.abs(perRound)>=1)
                positionXDelay = 1;
            else
            {
                double inverse = (1/Math.abs(perRound))+1;
                positionXDelay = (int)inverse;
            }
        }        

        dif = positionYTo - positionYFrom;
        perRound = dif/((double)roundCount);
        if (perRound>0)
            round = (int) (perRound+0.99999);
        else
            round = (int) (perRound-0.99999);
        if (dif == 0)
        {
            positionYDelay = 0;
            positionYIncrease = 0;
        }
        else
        {
            positionYIncrease = round;
            if (Math.abs(perRound)>=1)
                positionYDelay = 1;
            else
            {
                double inverse = (1/Math.abs(perRound))+1;
                positionYDelay = (int)inverse;
            }
        }        
    }
    
    public boolean toXML(StringBuilder s, String tag)
    {
        
        s.append("<").append(tag).append(">\n");
        boolean ok = true;

        ok = ok & XMLSupport.addElement(s, "version", version);
        if (version == 1)
        {
            ok = ok & XMLSupport.addElement(s, "listScaleStart", listScaleStart);
            ok = ok & XMLSupport.addElement(s, "listScaleIncAtStep", listScaleDelay);
            ok = ok & XMLSupport.addElement(s, "listScaleInc", listScaleIncrease);

            ok = ok & XMLSupport.addElement(s, "intensityStart", intensityStart);
            ok = ok & XMLSupport.addElement(s, "intensityIncAtStep", intensityDelay);
            ok = ok & XMLSupport.addElement(s, "intensityInc", intensityIncrease);

            ok = ok & XMLSupport.addElement(s, "moveScale", moveScale);

            ok = ok & XMLSupport.addElement(s, "positionXStart", positionXStart);
            ok = ok & XMLSupport.addElement(s, "positionYStart", positionYStart);
            ok = ok & XMLSupport.addElement(s, "positionXIncAtStep", positionXDelay);
            ok = ok & XMLSupport.addElement(s, "positionYIncAtStep", positionYDelay);
            ok = ok & XMLSupport.addElement(s, "positionXInc", positionXIncrease);
            ok = ok & XMLSupport.addElement(s, "positionYInc", positionYIncrease);
            ok = ok & XMLSupport.addElement(s, "goto_value", goto_value);

            ok = ok & XMLSupport.addElement(s, "loop", loop);
            ok = ok & XMLSupport.addElement(s, "_goto", _goto);
            ok = ok & XMLSupport.addElement(s, "pause", pause);

            ok = ok & XMLSupport.addElement(s, "drawType", drawType);
            ok = ok & XMLSupport.addElement(s, "listName", de.malban.util.Utility.makeVideRelative(listName));
            ok = ok & XMLSupport.addElement(s, "delay", delay);

            ok = ok & XMLSupport.addElement(s, "vectrexdelay", vectrexdelay);
            ok = ok & XMLSupport.addElement(s, "loopCount", loopCount);
            ok = ok & XMLSupport.addElement(s, "resyncMax", resyncMax);
            ok = ok & XMLSupport.addElement(s, "factor", factor);
            ok = ok & XMLSupport.addElement(s, "manualRoundCount", manualRoundCount);
            ok = ok & XMLSupport.addElement(s, "roundCount", roundCount);
        }
        else if (version == 2)
        {
            ok = ok & XMLSupport.addElement(s, "animationLoop", animationLoop);
            ok = ok & XMLSupport.addElement(s, "listScaleFrom", listScaleFrom);
            ok = ok & XMLSupport.addElement(s, "listScaleTo", listScaleTo);

            ok = ok & XMLSupport.addElement(s, "intensityFrom", intensityFrom);
            ok = ok & XMLSupport.addElement(s, "intensityTo", intensityTo);

            ok = ok & XMLSupport.addElement(s, "moveScale", moveScale);

            ok = ok & XMLSupport.addElement(s, "positionXFrom", positionXFrom);
            ok = ok & XMLSupport.addElement(s, "positionYFrom", positionYFrom);
            ok = ok & XMLSupport.addElement(s, "positionXTo", positionXTo);
            ok = ok & XMLSupport.addElement(s, "positionYTo", positionYTo);

            ok = ok & XMLSupport.addElement(s, "pause", pause);

            ok = ok & XMLSupport.addElement(s, "drawType", drawType);
            ok = ok & XMLSupport.addElement(s, "listName", listName);
            ok = ok & XMLSupport.addElement(s, "delay", delay);

            ok = ok & XMLSupport.addElement(s, "vectrexdelay", vectrexdelay);
            ok = ok & XMLSupport.addElement(s, "resyncMax", resyncMax);
            ok = ok & XMLSupport.addElement(s, "factor", factor);
            ok = ok & XMLSupport.addElement(s, "roundCount", roundCount);
        }

        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    
    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        version = xmlSupport.getIntElement("version", xml); // version  might be missing, than version = 1
        if (xmlSupport.errorCode != 0) version = 1;
        if (version == 1)
        {
            listScaleStart = xmlSupport.getIntElement("listScaleStart", xml);errorCode|=xmlSupport.errorCode;
            listScaleDelay = xmlSupport.getIntElement("listScaleIncAtStep", xml);errorCode|=xmlSupport.errorCode;
            listScaleIncrease = xmlSupport.getIntElement("listScaleInc", xml);errorCode|=xmlSupport.errorCode;
            intensityStart = xmlSupport.getIntElement("intensityStart", xml);errorCode|=xmlSupport.errorCode;
            intensityDelay = xmlSupport.getIntElement("intensityIncAtStep", xml);errorCode|=xmlSupport.errorCode;
            intensityIncrease = xmlSupport.getIntElement("intensityInc", xml);errorCode|=xmlSupport.errorCode;

            moveScale = xmlSupport.getIntElement("moveScale", xml);errorCode|=xmlSupport.errorCode;

            positionXStart = xmlSupport.getIntElement("positionXStart", xml);errorCode|=xmlSupport.errorCode;
            positionYStart= xmlSupport.getIntElement("positionYStart", xml);errorCode|=xmlSupport.errorCode;
            positionXDelay = xmlSupport.getIntElement("positionXIncAtStep", xml);errorCode|=xmlSupport.errorCode;
            positionYDelay= xmlSupport.getIntElement("positionYIncAtStep", xml);errorCode|=xmlSupport.errorCode;
            positionXIncrease = xmlSupport.getIntElement("positionXInc", xml);errorCode|=xmlSupport.errorCode;
            positionYIncrease= xmlSupport.getIntElement("positionYInc", xml);errorCode|=xmlSupport.errorCode;
            goto_value= xmlSupport.getIntElement("goto_value", xml);errorCode|=xmlSupport.errorCode;

            loop = xmlSupport.getBooleanElement("loop", xml);errorCode|=xmlSupport.errorCode;
            _goto = xmlSupport.getBooleanElement("_goto", xml);errorCode|=xmlSupport.errorCode;
            pause = xmlSupport.getBooleanElement("pause", xml);errorCode|=xmlSupport.errorCode;
            manualRoundCount = xmlSupport.getBooleanElement("manualRoundCount", xml);errorCode|=xmlSupport.errorCode;

            drawType= xmlSupport.getStringElement("drawType", xml);errorCode|=xmlSupport.errorCode;
            listName= xmlSupport.getStringElement("listName", xml);errorCode|=xmlSupport.errorCode;
            listName = de.malban.util.UtilityFiles.convertSeperator(listName);
            
            delay= xmlSupport.getIntElement("delay", xml);errorCode|=xmlSupport.errorCode;
            vectrexdelay= xmlSupport.getIntElement("vectrexdelay", xml);errorCode|=xmlSupport.errorCode;
            loopCount= xmlSupport.getIntElement("loopCount", xml);errorCode|=xmlSupport.errorCode;
            resyncMax= xmlSupport.getIntElement("resyncMax", xml);errorCode|=xmlSupport.errorCode;
            factor= xmlSupport.getIntElement("factor", xml);errorCode|=xmlSupport.errorCode;
            roundCount= xmlSupport.getIntElement("roundCount", xml);errorCode|=xmlSupport.errorCode;
        }
        else if (version == 2)
        {
            
            animationLoop = xmlSupport.getBooleanElement("animationLoop", xml);errorCode|=xmlSupport.errorCode;
            listScaleFrom = xmlSupport.getIntElement("listScaleFrom", xml);errorCode|=xmlSupport.errorCode;
            listScaleTo = xmlSupport.getIntElement("listScaleTo", xml);errorCode|=xmlSupport.errorCode;

            intensityFrom = xmlSupport.getIntElement("intensityFrom", xml);errorCode|=xmlSupport.errorCode;
            intensityTo = xmlSupport.getIntElement("intensityTo", xml);errorCode|=xmlSupport.errorCode;

            moveScale = xmlSupport.getIntElement("moveScale", xml);errorCode|=xmlSupport.errorCode;

            positionXFrom = xmlSupport.getIntElement("positionXFrom", xml);errorCode|=xmlSupport.errorCode;
            positionYFrom= xmlSupport.getIntElement("positionYFrom", xml);errorCode|=xmlSupport.errorCode;
            positionXTo = xmlSupport.getIntElement("positionXTo", xml);errorCode|=xmlSupport.errorCode;
            positionYTo= xmlSupport.getIntElement("positionYTo", xml);errorCode|=xmlSupport.errorCode;

            pause = xmlSupport.getBooleanElement("pause", xml);errorCode|=xmlSupport.errorCode;

            drawType= xmlSupport.getStringElement("drawType", xml);errorCode|=xmlSupport.errorCode;
            listName= xmlSupport.getStringElement("listName", xml);errorCode|=xmlSupport.errorCode;
            listName = de.malban.util.UtilityFiles.convertSeperator(listName);
            delay= xmlSupport.getIntElement("delay", xml);errorCode|=xmlSupport.errorCode;
            vectrexdelay= xmlSupport.getIntElement("vectrexdelay", xml);errorCode|=xmlSupport.errorCode;
            resyncMax= xmlSupport.getIntElement("resyncMax", xml);errorCode|=xmlSupport.errorCode;
            factor= xmlSupport.getIntElement("factor", xml);errorCode|=xmlSupport.errorCode;
            roundCount= xmlSupport.getIntElement("roundCount", xml);errorCode|=xmlSupport.errorCode;
        }
        if (errorCode!= 0) return false;
        return true;

    }        
    
    void setElementSelected(boolean b)
    {
        if (b)
            setVectorBackground(new Color( ((VECCI_BACKGROUND_COLOR.getRed()+30)%255), ((VECCI_BACKGROUND_COLOR.getGreen()+30)%255), ((VECCI_BACKGROUND_COLOR.getBlue()+30)%255), 255 ));
        else
            setVectorBackground(VECCI_BACKGROUND_COLOR);
        continueRepaint();
    }
}
