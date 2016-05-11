/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.sound;

import de.malban.config.Configuration;
import java.io.*;
import java.util.*;

import javax.sound.sampled.*;

/**
 *
 * @author Malban
 */
public class PlayClip  implements AudioPlayable
{
    public static final int MAX_LINES_DEFAULT = 1;
    final int maxLines;
    boolean autoClose=false;
    Clip[] clips = null;
    AudioInputStream sound = null;
    int nextClip=0;

    public static HashMap<String, PlayClip> mClipMap = new HashMap<String, PlayClip>();
    public static void resetCache()
    {
        Set entries = mClipMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
                Map.Entry entry = (Map.Entry) it.next();
                PlayClip playClip = (PlayClip) entry.getValue();
                playClip.deinit();
        }
        mClipMap = new HashMap<String, PlayClip>();
    }

    public static void playClip(String name)
    {
        if (Configuration.getConfiguration().isSoundQuiet())
        {
            return;
        }
        PlayClip p = mClipMap.get(name);
        if (p==null)
        {
            p = new PlayClip(name);
            if (p!= null)
                mClipMap.put(name,p);
        }
        if (p!=null) p.play();
    }

    public PlayClip(String name, boolean autoClose)
    {
        this(name, MAX_LINES_DEFAULT, autoClose);
    }


    public PlayClip(String name)
    {
        this(name, MAX_LINES_DEFAULT, false);
    }

    public PlayClip(String name, int ml)
    {
        this(name, ml, false);
    }
        
    public PlayClip(String name, int ml,  boolean autoClose)
    {
        maxLines = ml;
        clips = new Clip[maxLines];
        if (Configuration.getConfiguration().isSoundQuiet())
        {
            return;
        }
        // specify the sound to play
        // (assuming the sound can be played by the audio system)
        File soundFile = new File(name);
        try
        {
            //sound = AudioSystem.getAudioInputStream(soundFile);
            // load the sound into memory (a Clip)

            for (int i = 0; i < clips.length; i++)
            {
                sound = AudioSystem.getAudioInputStream(soundFile);
                DataLine.Info info = new DataLine.Info(Clip.class, sound.getFormat());
                clips[i]  = (Clip) AudioSystem.getLine(info);
                clips[i].open(sound);
                if (autoClose)
                clips[i].addLineListener(new LineListener()
                {
                    @Override
                  public void update(LineEvent event)
                  {
                    if (event.getType() == LineEvent.Type.STOP)
                    {
                      event.getLine().close();
                      deinit();
                    }
                  }
                });
            }
        }
        catch (Throwable e)
        {
            if (!soundNotAvailable)
                Configuration.getConfiguration().getDebugEntity().addLog(""+e,1);
            soundNotAvailable = true;
            deinit();
        }
    }
    static boolean soundNotAvailable=false;

    @Override
    public final void deinit()
    {
        for (int i = 0; i < clips.length; i++)
        {
            Clip clip = clips[i];
            if (clip != null)
            {
                clip.close();
                clips[i] = null;
            }
        }
        sound = null;
    }

    @Override
    synchronized public boolean play()
    {
        if (clips == null) return false;
        if (clips[nextClip] == null) return false;
        // play the sound clip
        clips[nextClip].setFramePosition(0);
        clips[nextClip].start();
        nextClip = (nextClip+1) % maxLines;
        return true;
    }
}
