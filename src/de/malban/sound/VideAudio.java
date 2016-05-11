/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.sound;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;

/**
 *
 * @author malban
 */
public class VideAudio {
    
    public static VideAudio getAudio()
    {
        return new VideAudio();
    }
    private VideAudio()
    {
        
    }

    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    
    public transient byte[] soundBytes = new byte[882];
    SourceDataLine line = null;
    boolean init = false;
    public SourceDataLine getLine()
    {
        if (!init) init = initAudioLine();
        return line; // line might still be null, but we tried!
    }

    private boolean initAudioLine()
    {
        // https://docs.oracle.com/javase/tutorial/sound/playing.html
        if (line != null) return true;
        try
        {
            
            
            AudioFormat format = new AudioFormat(22050,8,1,false,true);
            line=null;
            DataLine.Info info = new DataLine.Info(SourceDataLine.class,  format); // format is an AudioFormat object
            if (!AudioSystem.isLineSupported(info)) 
            {
                // Handle the error.
            }
            try // Obtain and open the line.
            {
                line = (SourceDataLine) AudioSystem.getLine(info);
                line.open(format,soundBytes.length);
                line.start();
            } 
            catch (LineUnavailableException ex) 
            {
                // Handle the error.
                log.addLog(ex, WARN);
                line = null;
            }                       
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            line = null;
        }    
        return line != null;
    }
    public void deinit()
    {
        try
        {
            deinitAudioLine();
            
        }
        catch (Throwable ex)
        {
            ex.printStackTrace();
        }
    }
    private void deinitAudioLine()
    {
        if (!init) return;
        synchronized (line)
        {
            if (line != null)
            {
                line.drain();
                line.stop();
                line.close();
                line = null;
            }
        }
        init = false;
    }    
}
