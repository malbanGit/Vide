/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;
import de.malban.util.XMLSupport;
import java.io.File;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class AKS 
{
    class SpecialTrack
    {
        // max height of a track 127 
        public int[] effect = new int[127]; // 1 = speed, 2 = digidrum, 0 = stay the same
        public int[] value = new int[127];
        public SpecialTrack()
        {
        }
    }
    class Pattern
    {
        public int track1No = 0; 
        public int track2No = 0; 
        public int track3No = 0;
        public int transposition1 = 0;
        public int transposition2 = 0;
        public int transposition3 = 0;
        public int height = 0;
        public int specialTrackNo = 0;
        
        public Pattern()
        {
        }
        public Pattern(int t1, int t2, int t3, int tr1, int tr2, int tr3, int h, int s)
        {
            track1No = t1;
            track2No = t2;
            track3No = t3;
            transposition1 = tr1;
            transposition2 = tr2;
            transposition3 = tr3;
            height = h;
            specialTrackNo = s;
        }
    }
    ArrayList<SpecialTrack> specialTracks = new ArrayList<SpecialTrack>(); // max [256]
    ArrayList<Pattern> patterns = new ArrayList<Pattern>(); // max [256]
    
    public boolean loadAKS(String filename)
    {
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (filename));
        boolean ok = fromXML(new StringBuilder(xml), new XMLSupport());
        return ok;
    }
    public boolean fromXML(StringBuilder aksXML, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        int currentSpeed = xmlSupport.getIntElement("BeginningSpeed", aksXML);errorCode|=xmlSupport.errorCode;
        
        
        StringBuilder specialTracksArray  = xmlSupport.removeTag("SpecialTracksArray", aksXML);
        if (specialTracksArray != null) 
        {
            StringBuilder specialTrack  = xmlSupport.removeTag("SpecialTrack", specialTracksArray);
            int effectCounter = 0;
            while (specialTrack != null)
            {
                SpecialTrack st = new SpecialTrack();
                specialTracks.add(st);
                StringBuilder specialCells  = xmlSupport.removeTag("SpecialCells", specialTrack);

                st.effect[effectCounter] = xmlSupport.getIntElement("Effect", specialCells);errorCode|=xmlSupport.errorCode;
                if (st.effect[effectCounter] == 0)
                {
                    st.effect[effectCounter] = 1;
                    st.value[effectCounter] = currentSpeed;
                }
                else
                {
                    currentSpeed = xmlSupport.getIntElement("Value", specialCells);errorCode|=xmlSupport.errorCode;
                    st.value[effectCounter] = currentSpeed;
                }
                effectCounter++;
            }
        }
        
        
        StringBuilder patternList  = xmlSupport.removeTag("PatternsList", aksXML);
        if (patternList != null) 
        {
            StringBuilder pattern  = xmlSupport.removeTag("Pattern", patternList);
            while (pattern != null)
            {
                Pattern p = new Pattern();
                patterns.add(p);

                p.track1No = xmlSupport.getIntElement("Track1Number", pattern);errorCode|=xmlSupport.errorCode;
                p.track2No = xmlSupport.getIntElement("Track2Number", pattern);errorCode|=xmlSupport.errorCode;
                p.track3No = xmlSupport.getIntElement("Track3Number", pattern);errorCode|=xmlSupport.errorCode;

                p.transposition1 = xmlSupport.getIntElement("Transposition1", pattern);errorCode|=xmlSupport.errorCode;
                p.transposition2 = xmlSupport.getIntElement("Transposition2", pattern);errorCode|=xmlSupport.errorCode;
                p.transposition3 = xmlSupport.getIntElement("Transposition3", pattern);errorCode|=xmlSupport.errorCode;

                p.height = xmlSupport.getIntElement("Height", pattern);errorCode|=xmlSupport.errorCode;
                p.specialTrackNo = xmlSupport.getIntElement("SpecialTrackNumber", pattern);errorCode|=xmlSupport.errorCode;
            }
        }
        

        if (errorCode!= 0) return false;
        return true;
    }
    
}
