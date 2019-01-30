/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;


import de.malban.config.Configuration;
import de.malban.graphics.SingleVectorPanel;
import de.malban.gui.ImageCache;
import de.malban.gui.Scaler;
import de.malban.gui.panels.LogPanel;
import de.malban.vide.VideConfig;
import de.malban.vide.vecx.VecX.VectrexDisplayVectors;
import de.malban.vide.vecx.VecXState.vector_t;
import static de.malban.vide.vecx.VecXPanel.DEVICE_IMAGER;
import static de.malban.vide.vecx.VecXPanel.DEVICE_LIGHTPEN;
import de.malban.vide.vecx.spline.CardinalSpline;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.geom.GeneralPath;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.HashMap;
import de.malban.vide.vecx.spline.Pt;
import static java.awt.BasicStroke.CAP_ROUND;
import static java.awt.BasicStroke.JOIN_ROUND;
import java.awt.Rectangle;

/**
 *
 * @author malban
 */
public class VecxiPanel_JAVA extends javax.swing.JPanel implements DisplayPanelInterface
{
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    VecXPanel vpanel;
    int BASE_GLOW_OFFSET = 64;
    int SPEED_STRENGTH = 4;
    
    BufferedImage[] phosphor = new BufferedImage[2];
    int phosphorDraw = 0;
    int phosphorDisplay = 1;
    
    BufferedImage image;
    BufferedImage rotateImage;
    
    double scaleWidth = 0;
    double scaleHeight = 0;
    
    int vectrexDisplayWidth = 0;
    int vectrexDisplayHeight = 0;
    int orgVectrexDisplayWidth = 0;
    int orgVectrexDisplayHeight = 0;
    
    ArrayList<Point> spline = new ArrayList();
    HashMap<String, String> doubleCheck= new HashMap<String, String>();
    StringBuilder sh = new StringBuilder();
    boolean forcedRedraw = false;
    BufferedImage overlayImageScaled=null;
    vector_t directDrawVector = null;
    
    public static int ARR_SIZE = 10;
    int old_x1 = Integer.MAX_VALUE;
    int old_y1 = Integer.MAX_VALUE;
    
    
    private VecxiPanel_JAVA()
    {
    }
    
    public VecxiPanel_JAVA(VecXPanel vp)
    {
        vpanel = vp;
        init();
    }
    
    public void resetDirectdraw()
    {
        directDrawVector = null;
    }  
    
    public void stopGraphics()
    {
        if (image != null)
        {
            Graphics2D g2 = image.createGraphics();
            g2.clearRect(0, 0, image.getWidth(), image.getHeight());
        }
    }
    public void deinit()
    {
        if (vpanel != null)
        {
            // todo some deinit
        }
    }

    public void init()
    {
    }
    public void overlayChanged()
    {
        overlayImageScaled = null;
        if ((vpanel.getOverlayImageOrg() != null)&& (config.overlayEnabled))
        {
            overlayImageScaled = ImageCache.getImageCache().getDerivatScale(vpanel.getOverlayImageOrg(), vectrexDisplayWidth, vectrexDisplayHeight);
        }
    }
    
    public void reset()
    {
        overlayImageScaled = null;
        if (vpanel.getWidth() == 0) return;
        if (vpanel.getHeight() == 0) return;
        
        Rectangle bounds = new Rectangle(0,vpanel.getYOffset()+1,vpanel.getWidth(),vpanel.getHeight()-(vpanel.getYOffset())+1);
        setBounds(bounds);
        
        
        image = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight());
        phosphor[0] = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight());
        phosphor[1] = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight());

        
        if (image == null) return;
        if (phosphor[0] == null) return;
        if (phosphor[1] == null) return;
        
        forcedRedraw = true;
        
        orgVectrexDisplayWidth = image.getWidth();
        orgVectrexDisplayHeight = image.getHeight();
        
        // build an image in the size of this component
        // with vectors on it
        // representing the vectrex vectors
        scaleWidth = ((double)orgVectrexDisplayWidth)/((double)config.ALG_MAX_X);
        scaleHeight = ((double)orgVectrexDisplayHeight)/((double)config.ALG_MAX_Y);

        setRotation(config.rotate);         
    }
    
    
    void drawCatmullRom(ArrayList<Point> spline, Graphics2D g2, int color, int speed, int left, int right)
    {
        synchronized (spline)
        {
            if (config.useQuads)
            {
                drawAsQuads(spline, g2,  color, speed, left, right);
                return;
            }

            Color c = vpanel.getColor(color, left, right, new Color(210,210,255,color));
            g2.setColor(c);
            
            if (spline.size() == 2)
            {
                drawAsQuads(spline, g2,  color, speed, left, right);
                return;
            }
            
            
            // if splines are to big different than there can be "loops"
            CardinalSpline cs = new CardinalSpline();
            Pt po= null;
            for (Point p: spline)
            {
                Pt pt = new Pt(p.x,p.y);

                if (po != null)
                {
                    double xDif = p.x-po.x;
                    double yDif = p.y-po.y;
                    double d = (int) Math.sqrt((xDif)*(xDif)+(yDif)*(yDif));
                    if (d>config.maxSplineSize)
                    {

                        double div = d/(config.maxSplineSize/2);
                        
                        for (int i=1;i<div;i++)
                        {
                            cs.addPoint(new Pt(po.x+i*(xDif/div),po.y+i*(yDif/div)));
                        }
                    }
                }
                po = pt;
                cs.addPoint(pt);
            }            
            
            cs.caculate();

            ArrayList<Pt> pts = cs.getPoints();
            ArrayList<Point> nP = new ArrayList<Point>();
            for (int i=0;i<pts.size(); i++)
            {
                nP.add(new Point(pts.get(i).ix(), pts.get(i).iy()));
            }
            if (nP.size()>0)
                drawAsQuads(nP, g2,  color, speed, left, right);
        }
      }

    void drawAsQuads(ArrayList<Point> spline, Graphics2D g2, int color, int speed, int left, int right)
    {
        synchronized (spline)
        {
            int counter = 0;
            GeneralPath path = new GeneralPath(GeneralPath.WIND_NON_ZERO);
        //    Color c = new Color(100,255,100,color );
            Color c = vpanel.getColor(color, left, right, new Color(210,210,255,color));
            g2.setColor(c);
            path.moveTo(Scaler.scaleDoubleToInt(spline.get(counter).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter).y, scaleHeight));
            counter++;
            boolean doIt = true;
            int circleX = 0;
            int circleY = 0;
            if (spline.size() == 2)
            {
                if (    (Scaler.scaleDoubleToInt(spline.get(0).x, scaleWidth) == Scaler.scaleDoubleToInt(spline.get(1).x, scaleWidth)) &&
                        (Scaler.scaleDoubleToInt(spline.get(0).y, scaleHeight) == Scaler.scaleDoubleToInt(spline.get(1).y, scaleHeight)))
                {
                    circleX = Scaler.scaleDoubleToInt(spline.get(0).x, scaleWidth);
                    circleY = Scaler.scaleDoubleToInt(spline.get(0).y, scaleHeight);
                    if (circleX<3)circleX=0;
                    if (circleY<3)circleY=0;
                }
            }
            while (doIt)
            {
                int remaining = spline.size()-counter; // 
                if (remaining == 1) // BAD  draw a simple line
                {
                    
                    path.lineTo(Scaler.scaleDoubleToInt(spline.get(counter).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter).y, scaleHeight));
                    break;
                }
                if (remaining == 2) // ok, draw a   quad
                {
                    path.quadTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                                Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight));
                    break;
                }
                if (remaining == 3) // ok, draw a curve
                {
                    path.curveTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                                 Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight),
                                 Scaler.scaleDoubleToInt(spline.get(counter+2).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+2).y, scaleHeight));
                    break;
                }
                if (remaining == 4) // ok, draw a curve
                {
                    path.quadTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                                Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight));
                    counter+=2;
                    continue;
                }
                path.curveTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                             Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight),
                             Scaler.scaleDoubleToInt(spline.get(counter+2).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+2).y, scaleHeight));
                counter+=3;
            }

            if (config.useGlow)
            {
                color = color <<2; // 7f is max color
                double speedFactor; 
                if (speed>128) // dot dwell
                {
                    speedFactor = ((double)speed)/128.0; 
                }
                else
                {
                    speedFactor = 1.0 - (((double)speed)/512.0);
                }
                color= (int) ((double)color *(speedFactor));

                double brightness = vpanel.getBrightness();
                color= (int) ((double)color *(brightness));
                color = color/3;
                int halo = color/BASE_GLOW_OFFSET;
                halo*=2;


                for (int i=0; i< halo; i++)
                {
                    int alpha = BASE_GLOW_OFFSET/(3*(halo-i));
                    int width = (halo-i)*config.lineWidth;
                    if (alpha == 0) continue;
                    g2.setStroke(new BasicStroke(width,  CAP_ROUND, JOIN_ROUND)) ;
                    if (alpha > 255) alpha = 255;
                    Color cc = vpanel.getColor(color, left, right, new Color(210,210,255,alpha));
                    g2.setColor(cc);
                    if ((circleX != 0) || (circleY != 0))
                    {
                        g2.drawLine(((int) circleX), ((int) circleY), ((int) circleX),((int) circleY));
                    }
                    else
                    {
                        g2.draw( path );            
                    }
                }
                g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));
                if (color>BASE_GLOW_OFFSET)
                    color=BASE_GLOW_OFFSET;
                Color cc = vpanel.getColor(color, left, right, new Color(210,210,255,color));
                g2.setColor(cc);
                if ((circleX != 0) || (circleY != 0))
                {
                    g2.drawLine(((int) circleX), ((int) circleY), ((int) circleX),((int) circleY));
                }
                else
                    g2.draw( path );            

                if ((config.lineWidth%2!=0) && (config.lineWidth!=1))
                {
                    g2.setStroke(new BasicStroke(config.lineWidth/2));
                    int col = color*2;
                    if (col > 255) col = 255;
                    cc = vpanel.getColor(color, left, right, new Color(210,210,255,color));
                    g2.setColor(cc);
                    if ((circleX != 0) || (circleY != 0))
                        g2.drawLine(((int) circleX), ((int) circleY), ((int) circleX),((int) circleY));
                    else
                        g2.draw( path );            
                }
            }
            else
            {
                g2.draw( path );            
            }
        }
    }
    public void switchDisplay()
    {
        phosphorDraw = (phosphorDraw+1)%2;
        phosphorDisplay = (phosphorDisplay+1)%2;

        if (phosphor[phosphorDraw] == null) return;
        Graphics2D g2 = phosphor[phosphorDraw].createGraphics();

        // "persist" old image
        g2.drawImage(phosphor[phosphorDisplay], 0, 0,null);
        
        // and "fade away with alpha
        Color cc = new Color(0,0,0,config.persistenceAlpha );
        g2.setColor(cc);
        g2.fillRect(0, 0, vectrexDisplayWidth, vectrexDisplayHeight);
        image = phosphor[phosphorDisplay];
    }
    public void updateDisplay()// from display interface, used by vecxi
    {
        if (!config.useRayGun)
            paintVectrex();
        repaint();
    }

    // paints all vectors to an image
    // the image will be painted to the component 
    // in paintComponent
    // expects coordinates that can be painted directly
    // meaning 0,0 is in the uper left corner
    // (scaling to panel size will be done though)
    synchronized private void paintVectrex()
    {
        if (image == null) return;
        doubleCheck.clear();
     
        VectrexDisplayVectors vList = vpanel.getDisplayList();
        
        Graphics2D g2 = image.createGraphics();

        if ((!forcedRedraw) && (vpanel.isPausing()))
        {
            Color c = new Color(255,0,0,255 );
            g2.setColor(Color.RED);
            g2.setFont(vpanel.getFont());
            g2.drawString("PAUSED", (image.getWidth()/2)-30, image.getHeight()/3);
            
            return;// don't redraw in pause unless gfx changed'
        }
        if (config.persistenceAlpha != 255)
        {
            Color cc = new Color(0,0,0,config.persistenceAlpha );
            g2.setColor(cc);
            g2.fillRect(0, 0, vectrexDisplayWidth, vectrexDisplayHeight);
        }
        else
        {
            Color cc = new Color(0,0,0,255);
            g2.setBackground(cc);
            g2.clearRect(0, 0, vectrexDisplayWidth, vectrexDisplayHeight);
        }
        if (vpanel.isPausing())
        {
            Color c = new Color(255,0,0,255 );
            g2.setColor(Color.RED);
            g2.setFont(this.getFont());
            g2.drawString("PAUSED", (image.getWidth()/2)-30, image.getHeight()/3);
        }
        if (vpanel.isDebuging())
        {
            Color c = new Color(255,0,0,255 );
            g2.setColor(Color.GREEN);
            g2.setFont(this.getFont());
            g2.drawString("Debug", (image.getWidth()/2)-20, image.getHeight()/3);
        }
        if(vpanel.getDeviceList().get(DEVICE_LIGHTPEN).isActive())
        {
            Color c = new Color(255,0,0,255 );
            if (vpanel.isMousePressed())
                g2.setColor(Color.ORANGE);
            else
                g2.setColor(Color.YELLOW);
            if (config.displayModeWriting)
            {
                g2.setFont(this.getFont());
                g2.drawString("Lightpen", (image.getWidth()/2)-20, image.getHeight()/3);
            }
                
        }
        if(vpanel.getDeviceList().get(DEVICE_IMAGER).isActive())
        {
            if (config.displayModeWriting)
            {
                Color c = new Color(255,0,0,255 );
                g2.setColor(Color.YELLOW);
                g2.setFont(this.getFont());
                g2.drawString("Goggle", (image.getWidth()/2)-20, image.getHeight()/3);
            }
        }
        
        RenderingHints rh;
        if (config.antialiazing)
        {
            HashMap<RenderingHints.Key,Object> m = new HashMap<RenderingHints.Key,Object>();
            m.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            m.put(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
            m.put(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_DISABLE);
            rh = new RenderingHints(m );                
        }
        else
        {
            HashMap<RenderingHints.Key,Object> m = new HashMap<RenderingHints.Key,Object>();
            m.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
            m.put(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
            m.put(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_DISABLE);
            rh = new RenderingHints(m );                
        }
        g2.setRenderingHints(rh);
        g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));

        boolean inSpline = false;
        int splineColor=0;
        
        
        old_x1 = Integer.MAX_VALUE;
        old_y1 = Integer.MAX_VALUE;
        
        
        for (int v = 0; v < vList.count; v++) 
        {
            if (config.useSplines)
            {
                synchronized(spline)
                {
                    if (!inSpline)
                    {
                        if (v != vList.count-1)
                        {
                            if ((vList.vectrexVectors[v+1].midChange) 
                                && (vList.vectrexVectors[v].x1 == vList.vectrexVectors[v+1].x0)
                                && (vList.vectrexVectors[v].y1 == vList.vectrexVectors[v+1].y0)
                                        )
                            {
                                // start Spline
                                spline.clear();
                                spline.add(new Point(vList.vectrexVectors[v].x0,vList.vectrexVectors[v].y0 ));
                                splineColor =vList.vectrexVectors[v].color; 
                                inSpline = true;
                                continue;
                                
                            }
                        }
                    }
                    else
                    {
                        if ((vList.vectrexVectors[v].midChange)
                                && (vList.vectrexVectors[v-1].x1 == vList.vectrexVectors[v].x0)
                                && (vList.vectrexVectors[v-1].y1 == vList.vectrexVectors[v].y0)
                                        )
                        {
                            // add point Spline
                            spline.add(new Point(vList.vectrexVectors[v].x0,vList.vectrexVectors[v].y0 ));
                            if (v == vList.count-1) // is end of current vector list? Than we MUST draw even if spline is not finished
                            {
                                // start Spline
                                spline.add(new Point(vList.vectrexVectors[v].x1,vList.vectrexVectors[v].y1 ));
                                drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v].speed, vList.vectrexVectors[v].imagerColorLeft, vList.vectrexVectors[v].imagerColorRight);
                                inSpline = false;
                                continue;
                            }

                        }
                        else if ((vList.vectrexVectors[v].midChange) && (( Math.abs(vList.vectrexVectors[v-1].x1 - vList.vectrexVectors[v].x0)<config.DRIFT_CURVE_THRESHOLD) &&  (Math.abs(vList.vectrexVectors[v-1].y1 - vList.vectrexVectors[v].y0)<config.DRIFT_CURVE_THRESHOLD)))
                        {
                            // add point Spline
                            spline.add(new Point(vList.vectrexVectors[v-1].x1,vList.vectrexVectors[v-1].y1 ));
                            if (v == vList.count-1) // is end of current vector list? Than we MUST draw even if spline is not finished
                            {
                                // start Spline
                                spline.add(new Point(vList.vectrexVectors[v].x1,vList.vectrexVectors[v].y1 ));
                                drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v].speed, vList.vectrexVectors[v].imagerColorLeft, vList.vectrexVectors[v].imagerColorRight);
                                inSpline = false;
                                continue;
                            }

                        }
                        else
                        {
                           // 0 -> 1 von -1 und aktuell als line
                            spline.add(new Point(vList.vectrexVectors[v-1].x1,vList.vectrexVectors[v-1].y1 ));
                            
                            drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v-1].speed, vList.vectrexVectors[v-1].imagerColorLeft, vList.vectrexVectors[v-1].imagerColorRight);
                            inSpline = false;
                            // check if next vector is again the beginning of a spline
                            if (v != vList.count-1)
                            {
                                if (vList.vectrexVectors[v+1].midChange)
                                {
                                    // start Spline
                                    spline.clear();
                                    spline.add(new Point(vList.vectrexVectors[v].x0,vList.vectrexVectors[v].y0 ));
                                    splineColor =vList.vectrexVectors[v].color; 
                                    inSpline = true;
                                    continue;

                                }
                            }
                        }
                    }
                }
            }

            if (inSpline) continue;

            drawOneLine(g2, vList.vectrexVectors[v]);
	} 
        g2.dispose();
        forcedRedraw = false;
    }
    private void drawOneLine(Graphics2D g2, vector_t v)
    {
        
        double x0 =Scaler.scaleDoubleToInt(v.x0, scaleWidth);
        double y0 =Scaler.scaleDoubleToInt(v.y0, scaleHeight);
        double x1 =Scaler.scaleDoubleToInt(v.x1, scaleWidth);
        double y1 =Scaler.scaleDoubleToInt(v.y1, scaleHeight);
        if (config.supressDoubleDraw)
        {
            if ((old_x1 == (int)x0) && ( old_y1 == (int)y0))
            {
                int SHORTEN = config.lineWidth;
                double dx = x1 - x0;
                double dy = y1 - y0;
                double length = Math.sqrt(dx * dx + dy * dy);
                if (length <= config.lineWidth) return;
                if (length > 0)
                {
                    dx /= length;
                    dy /= length;
                }
                dx *= length - SHORTEN;
                dy *= length - SHORTEN;

                // shortened by tw2
                x0 = x1 - dx;
                y0 = y1 - dy;
            }
        }
        old_x1 = (int)x1;
        old_y1 = (int)y1;
        sh.delete(0, sh.length());
        sh.append((int)x0);
        sh.append((int)x1);
        sh.append((int)y0);
        sh.append((int)y1);
        String key = sh.toString();

        if (doubleCheck.get(key) == null) 
        {
            doubleCheck.put(key, key);
            if (!config.vectorsAsArrows)
            {
                if (config.useGlow)
                {
                    int color = v.color;// <<2; // 7f is max color
                    double speedFactor; 
                    if (v.speed>128) // dot dwell
                    {
                        speedFactor = ((double)v.speed)/128.0; 
                    }
                    else
                    {
                        speedFactor = 1.0 - (((double)v.speed)/512.0);
                    }
                    color= (int) ((double)color *(speedFactor));

                    double brightness = vpanel.getBrightness();
                    color= (int) ((double)color *(brightness));
                    color = color/3;
                    int halo = color*2/BASE_GLOW_OFFSET;
                    halo*=2;

                    for (int i=0; i< halo; i++)
                    {
                        int alpha = BASE_GLOW_OFFSET/(3*(halo-i));
                        if (alpha == 0) continue;
                        int width = (halo-i)*config.lineWidth;
                        g2.setStroke(new BasicStroke(width,  CAP_ROUND, JOIN_ROUND));
                        Color c = vpanel.getColor(alpha, v.imagerColorLeft, v.imagerColorRight, new Color(210,210,255,alpha ));
                        
                        g2.setColor(c);
                        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    }
                    g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));
                    if (color>BASE_GLOW_OFFSET)
                        color=BASE_GLOW_OFFSET;
                    Color c = vpanel.getColor(color, v.imagerColorLeft, v.imagerColorRight, new Color(210,210,255,color ));
                    g2.setColor(c);
                    g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    //&if ((config.lineWidth%2!=0) && (config.lineWidth!=1))
                    if ( (config.lineWidth!=1))
                    {
                        g2.setStroke(new BasicStroke(config.lineWidth/2));
                        int col = color/2;//*2;
                        if (col > 255) col = 255;
                        c = vpanel.getColor(col, v.imagerColorLeft, v.imagerColorRight, new Color(210,210,255,col ));
                        g2.setColor(c);
                        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    }
                }
                else
                {
                    Color c = vpanel.getColor(v.color, v.imagerColorLeft, v.imagerColorRight, new Color(210,210,255,v.color ));
                    g2.setColor(c);
                    g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                }
            }
            else
            {
                Color c = vpanel.getColor(v.color, v.imagerColorLeft, v.imagerColorRight, new Color(210,210,255,v.color ));
                g2.setColor(c);
                drawArrow(g2, ((int) x0), ((int) y0), ((int) x1),((int) y1));
            }            
        }
    }

    public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        int offsetY = 0;//jPanel1.getHeight();
        Graphics gOrg=g;
        if (config.rotate != 0)
        {
            gOrg = g;
            if (rotateImage == null)
            {
                setRotation(config.rotate);
            }
            if (rotateImage != null)
                g = rotateImage.createGraphics();
            offsetY = 0;
        }
        
        if (image != null)
        {
            g.drawImage(image, 0, offsetY, null);
            if ((overlayImageScaled != null) && (config.overlayEnabled))
            {
                g.drawImage(overlayImageScaled, 0, offsetY,null);
            }
            if (config.paintIntegrators)
            {
                double x0=vpanel.getIntegratorX();
                double y0=vpanel.getIntegratorY();
                x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                y0 =Scaler.scaleDoubleToInt(y0, scaleHeight)+offsetY;

                int RADIUS = 3;
                g.setColor(Color.red);
                g.drawOval((int)x0-RADIUS, (int)y0-RADIUS, RADIUS*2, RADIUS*2);
                
            }
            
            if (vpanel.isMouseMode())
            {
                if (!vpanel.isCrossDisabled()) // out of bounds
                {
                    int width = image.getWidth();
                    int height = image.getHeight();
                    double scaleWidth = ((double)width)/((double)config.ALG_MAX_X);
                    double scaleHeight = ((double)height)/((double)config.ALG_MAX_Y);
                    
                    
                    double distance = Double.MAX_VALUE;
                    if (vpanel.getVinfi() != null)
                    {
                        int x = vpanel.getMouseX();
                        int y = vpanel.getMouseY()-offsetY;
                        
                        x =Scaler.unscaleDoubleToInt(x, scaleWidth);
                        y =Scaler.unscaleDoubleToInt(y, scaleHeight);
                        x -=config.ALG_MAX_X/2;
                        y -=config.ALG_MAX_Y/2;
                        y =-y;

                        vpanel.getVinfi().setMouseCoordinates( x,  y);
                    }
                    
                    
                    Color c = g.getColor();
                    {
                        int x = vpanel.getMouseX();
                        int y = vpanel.getMouseY();
                        g.setColor(vpanel.getCrossColor());
                        g.drawLine(0, y, width, y);
                        g.drawLine(x, 0+offsetY, x, height+offsetY);
                    }

                    // search a vector that is in range!
                    VectrexDisplayVectors vList = vpanel.getDisplayList();
                
  
                    for (int i = 0; i < vList.count; i++) 
                    {
                        vector_t v = vList.vectrexVectors[i];
                        
                        double x0=v.x0;
                        double y0=v.y0;
                        double x1=v.x1;
                        double y1=v.y1;
                        double d;

                        // vector coordinates in xy pos in relation to image!
                        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);
                
                        y0 += offsetY; // + image offset in panel
                        y1 += offsetY;
                
                        // nice, but now that I think of it I need a line SEGMENT, not a line!
                        d = SingleVectorPanel.getDistancePointToVector((double)vpanel.getMouseX(), (double)vpanel.getMouseY(), x0,y0,x1,y1);
                        if (d<distance) 
                        {
                            distance = d;
                            vpanel.setFound(v);
                        }
                        if (distance==0) break;
                    }
                    if (directDrawVector != null)
                    {
                        double x0=directDrawVector.x0;
                        double y0=directDrawVector.y0;
                        double x1=directDrawVector.x1;
                        double y1=directDrawVector.y1;
                        double d;

                        // vector coordinates in xy pos in relation to image!
                        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);
                
                        y0 += offsetY; // + image offset in panel
                        y1 += offsetY;
                
                        // nice, but now that I think of it I need a line SEGMENT, not a line!
                        d = SingleVectorPanel.getDistancePointToVector((double)vpanel.getMouseX(), (double)vpanel.getMouseY(), x0,y0,x1,y1);
                        if (d<distance) 
                        {
                            distance = d;
                            vpanel.setFound(directDrawVector);
                        }
                    }
                    
                    // distance must be NEAR (in range)
                    if (vpanel.getFound() != null)
                    {
                        if (distance<=5) // arround 5 Pixel
                        {
                        }
                        else
                        {
                            vpanel.setFound(null);
                        }
                    }        
                    if (vpanel.getFound() != null)
                    {
                        // select vector!
                        double x0=vpanel.getFound().x0;
                        double y0=vpanel.getFound().y0;
                        double x1=vpanel.getFound().x1;
                        double y1=vpanel.getFound().y1;

                        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);
                
                        y0 += offsetY; // + image offset in panel
                        y1 += offsetY;
                        
                        
                        g.setColor(Color.BLUE);

                        // construct a perpendicular vector for a 
                        // paralle transition
                        double py = x0-x1;
                        double px = -(y0-y1);
                        double l = Math.sqrt((Math.pow(py,2) + Math.pow(px,2)));

                        double transition = 3;

                        double px0 = x0 + (transition / l) * px;
                        double py0 = y0 + (transition / l) * py;
                        double px1 = x1 + (transition / l) * px;
                        double py1 = y1 + (transition / l) * py;

                        double transition2 = -3;

                        double px02 = x0 + (transition2 / l) * px;
                        double py02 = y0 + (transition2 / l) * py;
                        double px12 = x1 + (transition2 / l) * px;
                        double py12 = y1 + (transition2 / l) * py;

                        g.drawLine(((int) px0), ((int) py0), ((int) px1),((int) py1));
                        g.drawLine(((int) px02), ((int) py02), ((int) px12),((int) py12));

                        g.drawLine(((int) px0), ((int) py0), ((int) px02),((int) py02));
                        g.drawLine(((int) px1), ((int) py1), ((int) px12),((int) py12));
                    }
                }
            }
        }
        
        if (directDrawVector != null)
        {
            Color c = new Color(255,255,0,255 );
            g.setColor(c);
            double x0=directDrawVector.x0;
            double y0=directDrawVector.y0;
            double x1=directDrawVector.x1;
            double y1=directDrawVector.y1;

            x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
            y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
            x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
            y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

            g.drawLine(((int) x0), ((int) y0)+offsetY, ((int) x1),((int) y1)+offsetY);
            directDrawVector = null;
        }
        if (vpanel.isLEDState())
        {
            if (vpanel.isLEDDir())
            {
                for (int i=22; i>12;i-=2)
                {
                    int alpha = 250-((i-12)*20)-vpanel.getLEDStep()*2;
                    Color c = new Color(210,210,255,alpha);
                    g.setColor(c);
                    g.fillOval(this.getWidth()-30-i, this.getHeight()-30-i, (i-10)*2, (i-10)*2);
                }
                Color c = new Color(255,255,255,255);
                g.setColor(c);
                g.fillOval(this.getWidth()-30-12, this.getHeight()-30-12, 4, 4);
                 c = new Color(255,255,200,255-vpanel.getLEDStep());
                g.setColor(c);
                g.fillOval(this.getWidth()-30-11, this.getHeight()-30-11, 2, 2);
                vpanel.setLEDStep(vpanel.getLEDStep()+1);
                if (vpanel.getLEDStep() >= 15)vpanel.setLEDDir(false);
            }
            else if (!vpanel.isLEDDir())
            {
                for (int i=22; i>12;i-=2)
                {
                    int alpha = 250-((i-12)*20)-vpanel.getLEDStep()*2;
                    Color c = new Color(210,210,255,alpha);
                    g.setColor(c);
                    g.fillOval(this.getWidth()-30-i, this.getHeight()-30-i, (i-10)*2, (i-10)*2);
                }
                Color c = new Color(255,255,255,255-vpanel.getLEDStep());
                g.setColor(c);
                g.fillOval(this.getWidth()-30-12, this.getHeight()-30-12, 4, 4);
                 c = new Color(255,255,200,255);
                g.setColor(c);
                g.fillOval(this.getWidth()-30-11, this.getHeight()-30-11, 2, 2);
                vpanel.setLEDStep(vpanel.getLEDStep()-1);;
                if (vpanel.getLEDStep() <= 0)vpanel.setLEDDir(true);
            }
        }
        if (rotateImage != null)
        if (config.rotate != 0)
        {
            BufferedImage ri = getRotate(config.rotate);
            gOrg.drawImage(ri, 0, 0, null);
        }
    }
      
    public void setRotation(int angle)
    {
        if ((angle != 0) && (angle != 90)&& (angle != 180)&& (angle != 270))
            return;

        if ((angle ==90) || (angle == 270))
        {
            vectrexDisplayWidth = orgVectrexDisplayHeight;
            vectrexDisplayHeight = orgVectrexDisplayWidth;
        }
        else
        {
            vectrexDisplayWidth = orgVectrexDisplayWidth;
            vectrexDisplayHeight = orgVectrexDisplayHeight;
        }
        if (vectrexDisplayWidth == 0) return;
        if (vectrexDisplayHeight == 0) return;
        
        image = de.malban.util.UtilityImage.getNewImage(vectrexDisplayWidth, vectrexDisplayHeight);
        phosphor[0] = de.malban.util.UtilityImage.getNewImage(vectrexDisplayWidth, vectrexDisplayHeight);
        phosphor[1] = de.malban.util.UtilityImage.getNewImage(vectrexDisplayWidth, vectrexDisplayHeight);
        
        // build an image in the size of this component
        // with vectors on it
        // representing the vectrex vectors
        scaleWidth = ((double)vectrexDisplayWidth)/((double)config.ALG_MAX_X);
        scaleHeight = ((double)vectrexDisplayHeight)/((double)config.ALG_MAX_Y);

        overlayChanged();
        rotateImage = de.malban.util.UtilityImage.getNewImage(vectrexDisplayWidth, vectrexDisplayHeight);
    }    
    
    protected BufferedImage getRotate(int a)
    {
        int size;
        int h = rotateImage.getHeight();
        int w = rotateImage.getWidth();
        int type =  BufferedImage.TYPE_INT_ARGB;


        BufferedImage dimg = new BufferedImage(orgVectrexDisplayWidth, orgVectrexDisplayHeight, type);
        Graphics2D g = dimg.createGraphics();
        double sw = w;
        double sh = h;
        
        g.translate((orgVectrexDisplayWidth - w) / 2, (orgVectrexDisplayHeight - h) / 2);
        g.rotate(Math.toRadians(a), w/2, h/2);

        g.drawImage(rotateImage, null, 0, 0);
        return dimg;
    }      
    
    void drawArrow(Graphics g1, int x1, int y1, int x2, int y2) 
    {
        Graphics2D g = (Graphics2D) g1.create();

        double dx = x2 - x1, dy = y2 - y1;
        double angle = Math.atan2(dy, dx);
        int len = (int) Math.sqrt(dx*dx + dy*dy);
        AffineTransform at = AffineTransform.getTranslateInstance(x1, y1);
        at.concatenate(AffineTransform.getRotateInstance(angle));
        g.transform(at);

        // Draw horizontal arrow starting in (0, 0)
        g.drawLine(0, 0, len, 0);
        g.fillPolygon(new int[] {len, len-ARR_SIZE, len-ARR_SIZE, len},
                      new int[] {0, -ARR_SIZE/3, ARR_SIZE/3, 0}, 4);
    }    
    
    public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye)
    {
        if (phosphor[phosphorDraw]==null) return;
        Graphics2D g2 = phosphor[phosphorDraw].createGraphics();

        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

        Color c = vpanel.getColor(color, alg_leftEye, alg_rightEye, new Color(210,210,255,color ));
        g2.setColor(c);
        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
        g2.dispose();
    }
    
    public void setLightPen()
    {
        if (image == null) return;

        // coordinates on image of vectrex
        // the image represents the fill ALG_MAX_X*ALG_MAX_Y
        int x = vpanel.getMouseX();
        int y = vpanel.getMouseY();
        
        // try correct some rounding mistakes
        y-=4;
        x-=4;

        if (y<0) {vpanel.unsetLightPen();return;} // mouse not pressed on vectrex panel
        
        // in vectrex coordinates,
        // though 0,0 is as of yet not "center", but upper left corner
        int ux =Scaler.unscaleDoubleToInt(x, scaleWidth);
        int uy =Scaler.unscaleDoubleToInt(y, scaleHeight);
        
        vpanel.setLightPen(ux, uy);
    }    
    

    public void directDraw(vector_t v)
    {
        directDrawVector = v;
        repaint();
    }
    public void forceResize()
    {
        reset();
        paintVectrex();
        repaint();
    }
    public void internalReinit()
    {
        
    }
}




