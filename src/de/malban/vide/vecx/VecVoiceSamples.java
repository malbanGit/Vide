/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.sound.tinysound.TinySound;
import de.malban.sound.tinysound.internal.MemSound;
import java.io.File;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class VecVoiceSamples {
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    static SP0256AL[] allSamples;
    static HashMap<Integer, MemSound> playList;

    static
    {
        allSamples = null;
    }
    public static class SP0256AL
    {
        public int code = -1;
        public String phoneme="";
        public String sampleWords="";
        int timing=-1;
        MemSound sample=null;
        String filename="";

        SP0256AL(int c, String p, String sw, int t)
        {
            code = c;
            phoneme = p;
            sampleWords = sw;
            timing = t;
            String loadname;
            filename = phoneme;
            loadname = "samples"+File.separator+"SPO256AL2"+File.separator+filename+".wav";
                
            sample = (MemSound) TinySound.loadSound(new File(loadname), false);
            if (sample != null)
            {
                playList.put(code, sample);
            }
        }
    }
    public static SP0256AL[] getAllSamples()
    {
        return allSamples;
    }
    
    public static boolean loadSamples()
    {
        if (allSamples != null) return true;
        allSamples = new SP0256AL[64];
        playList = new HashMap<Integer, MemSound>();
        
        

        int s=0;

        
	allSamples[s++] = new SP0256AL( 0,"PA1", "PAUSE",10);   
        allSamples[s++] = new SP0256AL( 1,"PA2", "PAUSE",30);   
        allSamples[s++] = new SP0256AL( 2,"PA3", "PAUSE",50);   
        allSamples[s++] = new SP0256AL( 3,"PA4", "PAUSE",100);  
        allSamples[s++] = new SP0256AL( 4,"PA5", "PAUSE",200);  
        allSamples[s++] = new SP0256AL( 5,"OY",  "BOY",420);    
        allSamples[s++] = new SP0256AL( 6,"AY",  "Sky",260);    
        allSamples[s++] = new SP0256AL( 7,"EH",  "End",70);     
        allSamples[s++] = new SP0256AL( 8,"KK3", "Comb",120);   
        allSamples[s++] = new SP0256AL( 9,"PP",  "Pow",210);    
        allSamples[s++] = new SP0256AL(10,"JH",  "Dodge",140);  
        allSamples[s++] = new SP0256AL(11,"NN1", "Thin",140);   
        allSamples[s++] = new SP0256AL(12,"IH",  "Sit",70);     
        allSamples[s++] = new SP0256AL(13,"TT2", "To",140);     
        allSamples[s++] = new SP0256AL(14,"RR1", "Rural",170);  
        allSamples[s++] = new SP0256AL(15,"AX",  "Succeed",70); 
        allSamples[s++] = new SP0256AL(16,"MM",  "Milk",180);   
        allSamples[s++] = new SP0256AL(17,"TT1", "Part",100);   
        allSamples[s++] = new SP0256AL(18,"DH1", "They",290);   
        allSamples[s++] = new SP0256AL(19,"IY",  "See",250);    
        allSamples[s++] = new SP0256AL(20,"EY",  "Beige",280);  
        allSamples[s++] = new SP0256AL(21,"DD1", "Could",70);   
        allSamples[s++] = new SP0256AL(22,"UW1", "To",100);     
        allSamples[s++] = new SP0256AL(23,"AO",  "Aught",100);  
        allSamples[s++] = new SP0256AL(24,"AA",  "Hot",100);    
        allSamples[s++] = new SP0256AL(25,"YY2", "Yes",180);    
        allSamples[s++] = new SP0256AL(26,"AE",  "Hat",120);    
        allSamples[s++] = new SP0256AL(27,"HH1", "He",130);     
        allSamples[s++] = new SP0256AL(28,"BB1", "Business",80);
        allSamples[s++] = new SP0256AL(29,"TH",  "Thin",180);   
        allSamples[s++] = new SP0256AL(30,"UH",  "Book",100);   
        allSamples[s++] = new SP0256AL(31,"UW2", "Food",260);   
        allSamples[s++] = new SP0256AL(32,"AW",  "Out",370);    
        allSamples[s++] = new SP0256AL(33,"DD2", "Do",160);     
        allSamples[s++] = new SP0256AL(34,"GG3", "Wig",140);    
        allSamples[s++] = new SP0256AL(35,"VV",  "Vest",190);   
        allSamples[s++] = new SP0256AL(36,"GG1", "Got",80);     
        allSamples[s++] = new SP0256AL(37,"SH",  "Ship",160);   
        allSamples[s++] = new SP0256AL(38,"ZH",  "Azure",190);  
        allSamples[s++] = new SP0256AL(39,"RR2", "Brain",120);	
        allSamples[s++] = new SP0256AL(40,"FF",  "Food",150);   
        allSamples[s++] = new SP0256AL(41,"KK2", "Sky",190);    
        allSamples[s++] = new SP0256AL(42,"KK1", "Can't",160);	
        allSamples[s++] = new SP0256AL(43,"ZZ",  "Zoo",210);    
        allSamples[s++] = new SP0256AL(44,"NG",  "Anchor",220);	
        allSamples[s++] = new SP0256AL(45,"LL",  "Lake",110);   
        allSamples[s++] = new SP0256AL(46,"WW",  "Wool",180);   
        allSamples[s++] = new SP0256AL(47,"XR",  "Repair",360);	
        allSamples[s++] = new SP0256AL(48,"WH",  "Whig",200);   
        allSamples[s++] = new SP0256AL(49,"YY1", "Yes",130);    
        allSamples[s++] = new SP0256AL(50,"CH",  "Church",190);	
        allSamples[s++] = new SP0256AL(51,"ER1", "Fir",160);    
        allSamples[s++] = new SP0256AL(52,"ER2", "Fir",300);    
        allSamples[s++] = new SP0256AL(53,"OW",  "Beau",240);   
        allSamples[s++] = new SP0256AL(54,"DH2", "They",240);   
        allSamples[s++] = new SP0256AL(55,"SS",  "Vest",90);    
        allSamples[s++] = new SP0256AL(56,"NN2", "No",190);     
        allSamples[s++] = new SP0256AL(57,"HH2", "Hoe",180);    
        allSamples[s++] = new SP0256AL(58,"OR",  "Store",330);  
        allSamples[s++] = new SP0256AL(59,"AR",  "Alarm",290);  
        allSamples[s++] = new SP0256AL(60,"YR",  "Clear",350);  
        allSamples[s++] = new SP0256AL(61,"GG2", "Guest",40);   
        allSamples[s++] = new SP0256AL(62,"EL",  "Saddle",190);	
        allSamples[s++] = new SP0256AL(63,"BB2", "Business",50);

        
        
        ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: samples loaded.", INFO);
        return true;
    }

    
    public static MemSound getSample(int code)
    {
        if (playList == null) 
        {
            ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: samples not initialized", INFO);
            return null;
        }
        MemSound sample = playList.get(code);
        if (sample == null)
        {
            ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: sample for code: "+code+" not found", INFO);
            return null;
        }
        return sample;
    }
    public static MemSound playSample(int code)
    {
        MemSound sample = getSample(code);
        if (sample == null) return null;
        sample.play();
        ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: playing sample for code: "+code, INFO);
        return sample;
    }

}

