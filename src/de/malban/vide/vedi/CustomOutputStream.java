/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import java.io.IOException;
import java.io.OutputStream;

/**
 *
 * @author malban
 */
public class CustomOutputStream  extends OutputStream 
{
    // see: http://www.codejava.net/java-se/swing/redirect-standard-output-streams-to-jtextarea
    StringBuffer allMessages = new StringBuffer();
    StringBuffer allSinceLastFlush = new StringBuffer();
    FlushListener listener;
    public CustomOutputStream() 
    {
    }

    @Override
     public void write(int b) throws IOException  
    {
        try
        {
            allSinceLastFlush.append((char)b);
            if (b == '\n') flush();
        }
        catch (Throwable e)
        {

        }
    }
    public void flush() throws IOException 
    {
        allMessages.append(allSinceLastFlush);
        listener.wasFlushed(new FlushEvent(allSinceLastFlush.toString()));
        allSinceLastFlush.delete(0, allSinceLastFlush.length());
    }
    // only ONE
    void setCallback(FlushListener l)
    {
        listener = l;
    }
    public String  getCompleteString()
    {
        return allMessages.toString();
    }
    public void reset()
    {
        allMessages = new StringBuffer();
        allSinceLastFlush = new StringBuffer();
    }
}        

