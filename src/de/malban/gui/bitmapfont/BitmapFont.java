/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui.bitmapfont;

import de.malban.gui.ImageCache;
import de.malban.gui.Scaler;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

/**
 *
 * @author salchr
 */
public class BitmapFont 
{
    int kerningPercent = 0;
    int mediumWidth = 0;
    int height = 0; // all heights are assumed equal - not checked!
    
    boolean specialKerning = false;
    public void setKerningPercent(int k)
    {
        kerningPercent = k;
        mediumWidth=0;
        Set entries = abc.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            BCharacterImage value = (BCharacterImage) entry.getValue();
            mediumWidth += value.image.getWidth();
        }
        mediumWidth = mediumWidth/abc.size();
    }
    class BCharacterImage
    {
        int basline=0; // height = 0
        int kerning = -1;
        String letter;
        BufferedImage image;
        BCharacterImage(String l, BufferedImage i, int b)
        {
            basline = b;
            letter = l;
            image = i;
        }
        BCharacterImage(String l, BufferedImage i, int b, int k)
        {
            basline = b;
            letter = l;
            image = i;
            kerning = k;
        }
    }
    
    HashMap<String, BCharacterImage> abc = new HashMap<String, BCharacterImage>();
    
    
    public BitmapFont getDerivat(int newHeight)
    {
        BitmapFont newFont = new BitmapFont();

        float scale = ((float)((float)newHeight)/((float)height));
        
        Set entries = abc.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            BCharacterImage value = (BCharacterImage) entry.getValue();

            int newWidth = Scaler.scaleFloatToInt(value.image.getWidth(), scale);
            
            BufferedImage newImage = ImageCache.getImageCache().getDerivatScale(value.image, newWidth, newHeight);
            int newKerning = -1;
            if (value.kerning != -1)
            {
                newKerning = Scaler.scaleFloatToInt(value.kerning, scale);
            }
            int newBaseline = 0;
            if (value.basline != -1)
            {
                newBaseline = Scaler.scaleFloatToInt(value.basline, scale);
            }
            
            
            newFont.addChar(value.letter,  newImage,  newBaseline,  newKerning);
        }
        
        newFont.setKerningPercent(kerningPercent);
        newFont.setSpecialKerning(specialKerning);
        
        return newFont;
    }
    
    public void addChar(String letter, BufferedImage image, int baseline)
    {
        // replaces an already got mapping!
        height = image.getHeight();
        abc.put(letter, new BCharacterImage(letter, image, baseline));
    }
    public void addChar(String letter, BufferedImage image, int baseline, int kerning)
    {
        // replaces an already got mapping!
        height = image.getHeight();
        abc.put(letter, new BCharacterImage(letter, image, baseline, kerning));
    }
    
    public void setSpecialKerning(boolean b)
    {
        specialKerning = b;
    }
    
    private int getLetterWidth(BCharacterImage li, String letter, String word, int posInWord)
    {
        int width = li.image.getWidth();
        // last letter in word -> no kerning!
        if (posInWord == word.length()-1 ) return width;

        // if a kerning especially for this letter exists - use that!
        if (li.kerning != -1)
        {
            return width - li.kerning;
        }
        
        if (specialKerning)
        {
            if (letter.equals("f"))
            {
                int k = ((width*35)/100);
                width-=k;
            }
            else
            {
                String nextChar = "";
                if (word.length()>=posInWord+2)
                    nextChar = word.substring(posInWord+1,posInWord+2);
                if (nextChar.equals("b"))
                {
                    int k = ((mediumWidth*10)/100);
                    width-=k;
                }
                if (nextChar.equals("h"))
                {
                    int k = ((mediumWidth*10)/100);
                    width-=k;
                }
                if (nextChar.equals("l"))
                {
                    int k = ((mediumWidth*10)/100);
                    width-=k;
                }
                if (nextChar.equals("t"))
                {
                    int k = ((mediumWidth*10)/100);
                    width-=k;
                }
                if (nextChar.equals("u"))
                {
                    int k = ((mediumWidth*7)/100);
                    width-=k;
                }
                if (nextChar.equals("n"))
                {
                    int k = ((mediumWidth*7)/100);
                    width-=k;
                }
                if (nextChar.equals("m"))
                {
                    int k = ((mediumWidth*7)/100);
                    width-=k;
                }
            }
        }
        
        if (kerningPercent>0)
        {
            int k = ((mediumWidth*kerningPercent)/100);
            if (specialKerning)
            {
                if (letter.equals("l"))
                    k = (((mediumWidth/2)*kerningPercent)/100);
                if (letter.equals("i"))
                    k = (((mediumWidth/2)*kerningPercent)/100);
            }            
            
            width-=k;
        }
        
        return width;
    }
    
    
    // maxWidth will be considered, 
    // resulting width CAN be larger than given, if a single word is larger!
    // height will be in relation to text size
    // if chars are only in upper or lower case, that case will be used
    // instead of the "maybe" other case
    // chars which can not be found are left out entirely!
    
    // baselines are not considered yet
    public BufferedImage drawText(String text, int maxWidth)
    {
        // words are recognised by spaces
        // linebreaks are done by words
        String[] words = text.split(" ");
        int textMaxHeight = 0; // not considered yet, all chars should have as of now same size!
        int textMaxWidth = 0; // not considered yet, all chars should have as of now same size!
        int wordPosX=0;
        int wordPosY=0;
        int textMaxUsedWidth = 0;
        Vector<BufferedImage> lineImages = new Vector<BufferedImage>();
        Vector<BufferedImage> wordImages = new Vector<BufferedImage>();

        // add a space after each word
        BCharacterImage SPACE =abc.get(" ");
        int spaceWidth = 10;
        if (SPACE != null) // not found!
        {
            spaceWidth = SPACE.image.getWidth();
        }
        
        int lineWidthPos = 0;
        boolean firstWord = true;

        for (int w = 0; w < words.length; w++) 
        {
            String word = words[w];
            BufferedImage wordImage;
            BCharacterImage wordCImage =abc.get(word);
            int wordBaseline = 0;
            if (wordCImage != null)
            {
                wordImage = wordCImage.image;
                wordBaseline = wordCImage.basline;
                if (textMaxHeight < wordCImage.image.getHeight())
                    textMaxHeight = wordCImage.image.getHeight();
            }
            else
            {
                int wordMaxHeight=0;
                int wordWidth=0;
                
                for (int c=0; c<word.length(); c++)
                {
                    String letter = word.substring(c, c+1);
                    BCharacterImage letterImage =abc.get(letter);
                    if (letterImage == null)
                        letterImage =abc.get(letter.toUpperCase());
                    if (letterImage == null)
                        letterImage =abc.get(letter.toLowerCase());
                    if (letterImage == null) continue; // not found!
                    wordWidth += getLetterWidth(letterImage, letter, word, c);
                    if (wordMaxHeight < letterImage.image.getHeight())
                        wordMaxHeight = letterImage.image.getHeight();
                }
                if (textMaxHeight < wordMaxHeight)
                    textMaxHeight = wordMaxHeight;
                wordImage = new BufferedImage(wordWidth, wordMaxHeight, BufferedImage.TYPE_INT_ARGB);
                Graphics2D g = wordImage.createGraphics();
            
                wordPosX = 0;
                for (int c=0; c<word.length(); c++)
                {
                    String letter = word.substring(c, c+1);
                    BCharacterImage letterImage =abc.get(letter);
                    if (letterImage == null)
                        letterImage =abc.get(letter.toUpperCase());
                    if (letterImage == null)
                        letterImage =abc.get(letter.toLowerCase());
                    if (letterImage == null) continue; // not found!
                    g.drawImage(letterImage.image, wordPosX, 0, null);
                    wordPosX += getLetterWidth(letterImage, letter, word, c);
                }
            }

            boolean newLine = false;
            if (lineWidthPos + spaceWidth + wordPosX >maxWidth)
            {
                firstWord = true;
                lineWidthPos = 0;
                int lineWidth = wordPosX;
                //if (lineWidth<maxWidth) lineWidth = maxWidth;
                if (textMaxWidth<lineWidth) textMaxWidth=lineWidth;
                
                // new Line
                BufferedImage lineImage = new BufferedImage(lineWidth, textMaxHeight, BufferedImage.TYPE_INT_ARGB);
                Graphics2D g = lineImage.createGraphics();
                int lineX=0;
                for (int l = 0; l < wordImages.size(); l++) 
                {
                    g.drawImage(wordImages.elementAt(l), lineX, 0, null);
                    lineX += wordImages.elementAt(l).getWidth();
                }
                lineImages.addElement(lineImage);

                wordPosX  = 0;
                wordPosY += textMaxHeight;
                wordImages.clear();
                newLine = true;
            }
            
            if (!firstWord)
            {
                lineWidthPos += spaceWidth;
                if (SPACE != null)
                {
                    wordImages.addElement(SPACE.image);
                }
            }
            wordImages.addElement(wordImage);
            lineWidthPos += wordImage.getWidth();
            firstWord = false;
        }
        if (wordImages.size()>0)
        {
            // add words from last line
            int lineWidth = lineWidthPos;
            //if (lineWidth<maxWidth) lineWidth = maxWidth;
            if (textMaxWidth<lineWidth) textMaxWidth=lineWidth;
            if (textMaxUsedWidth<textMaxWidth) textMaxUsedWidth=textMaxWidth;

            // new
            if (textMaxWidth<lineWidth) textMaxWidth=textMaxUsedWidth;

            // new Line
            // BufferedImage lineImage = new BufferedImage(lineWidth, textMaxHeight, BufferedImage.TYPE_INT_ARGB);
            BufferedImage lineImage = new BufferedImage(textMaxWidth, textMaxHeight, BufferedImage.TYPE_INT_ARGB);
            Graphics2D g = lineImage.createGraphics();
            int lineX=0;
            for (int l = 0; l < wordImages.size(); l++) 
            {
                g.drawImage(wordImages.elementAt(l), lineX, 0, null);
                lineX += wordImages.elementAt(l).getWidth();
            }
            lineImages.addElement(lineImage);
            wordPosY += textMaxHeight;
        }
        
        
        
        // now build complete image!
        BufferedImage allTextImage = new BufferedImage(textMaxWidth, textMaxHeight * lineImages.size(), BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = allTextImage.createGraphics();
        int lineY=0;
        for (int l = 0; l < lineImages.size(); l++) 
        {
            g.drawImage(lineImages.elementAt(l), 0, lineY, null);
            lineY += textMaxHeight;
        }
        return allTextImage;
    }
    
    
}
