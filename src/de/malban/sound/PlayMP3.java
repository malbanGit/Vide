/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.sound;

/*************************************************************************
 *  Compilation:  javac -classpath .:jl1.0.jar MP3.java         (OS X)
 *                javac -classpath .;jl1.0.jar MP3.java         (Windows)
 *  Execution:    java -classpath .:jl1.0.jar MP3 filename.mp3  (OS X / Linux)
 *                java -classpath .;jl1.0.jar MP3 filename.mp3  (Windows)
 *
 *  Plays an MP3 file using the JLayer MP3 library.
 *
 *  Reference:  http://www.javazoom.net/javalayer/sources.html
 *
 *
 *  To execute, get the file jl1.0.jar from the website above or from
 *
 *      http://www.cs.princeton.edu/introcs/24inout/jl1.0.jar
 *
 *  and put it in your working directory with this file MP3.java.
 *
 *************************************************************************/

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import javazoom.jl.player.Player;
/**
 *
 * @author Malban
 */
public class PlayMP3 implements AudioPlayable
{

    private String filename;
    private Player player;

    boolean loop = true;

    // constructor that takes the name of an MP3 file
    public PlayMP3(String f)
    {
        filename = de.malban.util.UtilityString.cleanFileString(f);
    }

    public void setLoop(boolean b)
    {
        loop = b;
    }
    public void close()
    {
        loop = false;
        if (player == null) return;
        synchronized (player)
        {
            if (player != null)
            {
                player.close();
                player = null;
            }
        }
    }
    
    @Override
    public void deinit()
    {
        close();
    }

    // play the MP3 file to the sound card
    @Override
    public boolean play()
    {
        loop = true;

        // run in new thread to play in background
        new Thread() {
            @Override
            public void run()
            {
                try 
                {
                    do
                    {
                        try {
                            FileInputStream fis     = new FileInputStream(filename);
                            BufferedInputStream bis = new BufferedInputStream(fis);
                            player = new Player(bis);
                            player.play();

                            if (player != null)
                                player.close();
                            player = null;
                        }
                        catch (Exception e) {
                            //System.out.println("Problem playing file " + filename);
                            //System.out.println(e);
                            // e.printStackTrace();
                            loop = false;
                        }
                    }
                    while (loop);
                }
                catch (Exception e) { System.out.println(e); }
            }
        }.start();
        return true;
    }
}
