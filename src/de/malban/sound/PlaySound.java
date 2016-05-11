/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.sound;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;


/**
 * new PlaySound("test.wav").start();

http://www.anyexample.com/programming/java/java_play_wav_sound_file.xml
 *  	wav, 44100Hz, 2822kbps, 32 bit, Stereo -> https://gervill.dev.java.net/
 *
 * What audio formats does Java Sound support?

Java Sound supports the following audio file formats: AIFF, AU and WAV. It also supports the following MIDI based song
 * file formats: SMF type 0 (Standard MIDI File, aka .mid files), SMF type 1 and RMF.

The Java Sound engine can render 8 or 16 bit audio data, in mono or stereo, with sample rates from 8KHz to 48KHz,
 * that might be found in streaming audio or any of the supported file formats.
 *
 * @author Malban
 */

public class PlaySound implements AudioPlayable, Runnable
{
    private String filename;
    private Position curPosition;
    private final int EXTERNAL_BUFFER_SIZE = 524288; // 128Kb

    public enum Position {
        LEFT, RIGHT, NORMAL
    };

    public PlaySound()
    {
        
    }
    
    public PlaySound(String wavfile) {
        filename = wavfile;
        curPosition = Position.NORMAL;
    }

    public PlaySound(String wavfile, Position p) {
        filename = wavfile;
        curPosition = p;
    }
    public boolean play()
    {
        Thread player = new Thread(this);
        player.start();
        return true;
    }

    public void deinit()
    {
        if (player != null)
        {
            player.interrupt();
            player = null;
        }
        if (auline != null)
        {
            auline.drain();
            auline.close();
            auline = null;
        }

    }

    public void playVectrex(byte[] data)
    {
        ByteArrayInputStream bis = new ByteArrayInputStream(data);
        AudioInputStream audioInputStream;
        try {

            audioInputStream = AudioSystem.getAudioInputStream(bis);
        } catch (UnsupportedAudioFileException e1) {
            e1.printStackTrace();
            return;
        } catch (IOException e1) {
            e1.printStackTrace();
            return;
        }

        AudioFormat format = audioInputStream.getFormat();
        DataLine.Info info = new DataLine.Info(SourceDataLine.class, format);

        try {
            auline = (SourceDataLine) AudioSystem.getLine(info);
            auline.open(format);
        } catch (LineUnavailableException e) {
            //e.printStackTrace();
            auline = null;
            return;
        } catch (Exception e) {
            //e.printStackTrace();
            auline = null;
            return;
        }

        if (auline.isControlSupported(FloatControl.Type.PAN)) {
            FloatControl pan = (FloatControl) auline
                    .getControl(FloatControl.Type.PAN);
            if (curPosition == Position.RIGHT)
                pan.setValue(1.0f);
            else if (curPosition == Position.LEFT)
                pan.setValue(-1.0f);
        }

        auline.start();
        int nBytesRead = 0;
        byte[] abData = new byte[EXTERNAL_BUFFER_SIZE];

        try {
            while (nBytesRead != -1) {
                nBytesRead = audioInputStream.read(abData, 0, abData.length);

                if (nBytesRead >= 0)
                    auline.write(abData, 0, nBytesRead);
            }
        } catch (IOException e) {
            //e.printStackTrace();
            return;
        } finally {
            auline.drain();
            auline.close();
            auline = null;
        }        
    }
    
    Thread player = null;
    SourceDataLine auline = null;
    public void run() {

        File soundFile = new File(filename);
        if (!soundFile.exists()) {
            //System.err.println("Wave file not found: " + filename);
            return;
        }

        AudioInputStream audioInputStream = null;
        try {

            audioInputStream = AudioSystem.getAudioInputStream(soundFile);
        } catch (UnsupportedAudioFileException e1) {
            //e1.printStackTrace();
            return;
        } catch (IOException e1) {
            //e1.printStackTrace();
            return;
        }


        AudioFormat format = audioInputStream.getFormat();
        DataLine.Info info = new DataLine.Info(SourceDataLine.class, format);

        try {
            auline = (SourceDataLine) AudioSystem.getLine(info);
            auline.open(format);
        } catch (LineUnavailableException e) {
            //e.printStackTrace();
            auline = null;
            return;
        } catch (Exception e) {
            //e.printStackTrace();
            auline = null;
            return;
        }

        if (auline.isControlSupported(FloatControl.Type.PAN)) {
            FloatControl pan = (FloatControl) auline
                    .getControl(FloatControl.Type.PAN);
            if (curPosition == Position.RIGHT)
                pan.setValue(1.0f);
            else if (curPosition == Position.LEFT)
                pan.setValue(-1.0f);
        }

        auline.start();
        int nBytesRead = 0;
        byte[] abData = new byte[EXTERNAL_BUFFER_SIZE];

        try {
            while (nBytesRead != -1) {
                nBytesRead = audioInputStream.read(abData, 0, abData.length);

                if (nBytesRead >= 0)
                    auline.write(abData, 0, nBytesRead);
            }
        } catch (IOException e) {
            //e.printStackTrace();
            return;
        } finally {
            auline.drain();
            auline.close();
            auline = null;
        }
    }
}
