/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui.components;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * Very simple Button which supports 3 images, depressed, pressed and hover.
 * NO Border, or shadings are done by the button, it relies solo on images that are set.
 * 
 * Background is black with alpha 50 (see below to change) - whoch "darkens" the surroundings of the image)
 * 
 * @author malban
 */
public class ImageButton extends JButton
{
    ImageIcon depressedImageIcon = null;
    ImageIcon pressedImageIcon = null;
    ImageIcon hoverImageIcon = null;
    ImageIcon hoverPressedImageIcon = null;
    Image depressedImage = null;
    Image pressedImage = null;
    Image hoverPressedImage = null;
    Image hoverImage = null;
    String text = "";
    boolean stateNormal = true;
    static final int PRESSED = 1;
    static final int HOVER = 2;

    int state = 0;
    int backGroundOpacity=50;
    Color backColor = Color.BLACK;    
    public ImageButton (Image di)
    {
        super();
        depressedImage = di;
        depressedImageIcon = new ImageIcon(depressedImage);
        setIcon(depressedImageIcon);
        stateNormal = true;
    }
    public ImageButton (Image di, Image pi)
    {
        depressedImage = di;
        depressedImageIcon = new ImageIcon(depressedImage);
        
        hoverImage = depressedImage;
        hoverImageIcon = depressedImageIcon;

        pressedImage = pi;
        pressedImageIcon = new ImageIcon(pressedImage);
        
        hoverPressedImage = pressedImage;
        hoverPressedImageIcon = pressedImageIcon;

        setIcon(depressedImageIcon);
        stateNormal = false;
        setOpaque(false);
        backColor = new Color(0,0,0,backGroundOpacity);
        setBackground(backColor);
        addMouseListener(new MouseAdapter() 
                {

                    public void mousePressed(MouseEvent mouseevent)
                    {
                        state |= PRESSED;
                        repaint();
                    }

                    public void mouseReleased(MouseEvent mouseevent)
                    {
                        state &= (-1) ^ PRESSED;
                        repaint();
                    }
                    public void mouseEntered(MouseEvent mouseevent)
                    {
                        state |= HOVER;
                        repaint();
                    }
                    public void mouseExited(MouseEvent mouseevent)
                    {
                        state &= (-1) ^ HOVER;
                        repaint();
                    }
                });
        this.setBounds(0, 0, di.getWidth(null), di.getHeight(null));
    }
    public ImageButton (Image di, Image pi, Image hi)
    {
        this(di,pi);
        hoverImage = hi;
        hoverImageIcon = new ImageIcon(hoverImage);
    }
    public ImageButton (Image di, Image pi, Image hi, Image hip)
    {
        this(di,pi, hi);
        hoverPressedImage = hip;
        hoverPressedImageIcon = new ImageIcon(hoverPressedImage);
    }
    

    @Override public void paintComponent(Graphics g1)
    {
        
        
        if (stateNormal)
        {
            super.paintComponent(g1);
            return;
        }
        
        // do a "darkening" background!
        g1.setColor(backColor);
        g1.fillRect(0, 0, getWidth(), getHeight());
        
        if (state == 0)
            g1.drawImage(depressedImage, 0, 0, this);
        else if (state == PRESSED)
            g1.drawImage(pressedImage, 0, 0, this);
        else if (state == HOVER)
            g1.drawImage(hoverImage, 0, 0, this);
        else if (state == (HOVER|PRESSED))
            g1.drawImage(hoverPressedImage, 0, 0, this);
        
    }    
    
}
