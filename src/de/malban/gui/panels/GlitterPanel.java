/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * FirePanel.java
 *
 * Created on 08.03.2010, 12:21:17
 */

package de.malban.gui.panels;


import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;

/**
 *
 * code adapted from: http://www.eigelb.at/HP/Links/SpecialEffects/Glitzer/Glitzer3.html
 */
public class GlitterPanel extends javax.swing.JPanel implements Runnable{

    public static final int RECORD_MODE=0;
    public static final int PLAY_MODE=1;
    // int mode = RECORD_MODE;
    int mode = PLAY_MODE;

    int playbackPos=0;
    int playBackData[] = {
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 174, 10, 0, 165, 36, 0, 158, 57, 0, 152, 78
        , 0, 148, 92, 0, 144, 101, 0, 143, 104, 0, 142, 105, 0, 142, 106, 0, 142, 106, 0, 143, 106, 0, 148, 104, 0, 151, 103, 1, 155, 101
        , 1, 163, 99, 1, 171, 96, 1, 181, 93, 1, 190, 92, 1, 203, 90, 1, 214, 89, 1, 225, 89, 1, 238, 89, 1, 255, 89, 1, 269, 89
        , 1, 285, 90, 1, 306, 91, 1, 320, 93, 1, 331, 97, 1, 342, 100, 1, 350, 104, 1, 359, 106, 1, 370, 109, 1, 383, 113, 1, 397, 118
        , 1, 416, 122, 1, 438, 123, 1, 461, 126, 1, 495, 128, 1, 521, 127, 1, 545, 122, 1, 557, 119, 1, 564, 116, 1, 568, 110, 1, 570, 105
        , 1, 570, 102, 1, 570, 98, 1, 567, 94, 1, 560, 87, 1, 553, 85, 1, 544, 84, 1, 536, 83, 1, 524, 83, 1, 512, 82, 1, 500, 80
        , 1, 489, 79, 1, 474, 79, 1, 456, 77, 1, 441, 77, 1, 424, 77, 1, 412, 77, 1, 400, 78, 1, 386, 78, 1, 371, 79, 1, 357, 80
        , 1, 342, 80, 1, 323, 79, 1, 304, 78, 1, 290, 78, 1, 273, 77, 1, 255, 77, 1, 241, 75, 1, 229, 73, 1, 217, 70, 1, 205, 67
        , 1, 199, 65, 1, 194, 62, 1, 189, 58, 1, 187, 56, 1, 186, 51, 1, 185, 45, 1, 185, 42, 1, 189, 39, 1, 196, 36, 1, 209, 33
        , 1, 221, 31, 1, 231, 31, 1, 240, 31, 1, 251, 32, 1, 264, 33, 1, 282, 34, 1, 301, 35, 1, 320, 37, 1, 339, 38, 1, 358, 40
        , 1, 377, 42, 1, 398, 43, 1, 420, 44, 1, 446, 44, 1, 474, 43, 1, 499, 44, 1, 523, 49, 1, 547, 55, 1, 569, 61, 1, 585, 68
        , 1, 597, 75, 1, 605, 82, 1, 608, 87, 1, 609, 97, 1, 608, 110, 1, 606, 121, 1, 601, 129, 1, 593, 135, 1, 586, 137, 1, 576, 138
        , 1, 563, 139, 1, 544, 138, 1, 522, 136, 1, 497, 133, 1, 472, 129, 1, 451, 126, 1, 433, 125, 1, 413, 124, 1, 397, 123, 1, 377, 123
        , 1, 355, 121, 1, 335, 119, 1, 312, 117, 1, 289, 114, 1, 266, 112, 1, 250, 109, 1, 236, 106, 1, 225, 103, 0, 214, 100, 0, 202, 93
        , 0, 193, 86, 0, 188, 79, 0, 185, 71, 0, 187, 60, 0, 199, 37, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5
        , 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5
        , 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5
        , 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5, 0, 221, 5
        , 0, 221, 5
    };


    // Maximum Number of particles - default: 1000
    private static final int PARTIKEL_NO = 2000;
    //strength of random starting-Motion of particles - default: 30
    private static final int SPREADING = 30;
    // dynamic mouse-behaviour, "y" for on or "n" for off - default: true
    private static final boolean MOUSE_DYNAMIC = true;
    // How fast particles dissappear - default: 25
    private static final int AGING = 25;
    // How many particles appear per round - default: 20
    private static final int FREQUENCY = 40;
    // The power of Gravity (0=no gravity) - default: 10
    private static final int GRAVITY = 10;
    // Name of background-image (null if you do not use one)
    private static final String BACK_IMAGE = null;
    // Brightness of particles - default: 90
    private static final int BRIGHTNESS=90;


    int backShade =200;
    int animDelay = 30;

    boolean firstUpdate = true;
    Thread animator = null;
    boolean doRun = false;
    boolean deinit=false;
    int width = 200;
    int height = 200;
    Color backColor = new Color(0,0,0,backShade);

    public void setBackShade(int bs)
    {
        backShade = bs;
        backColor = new Color(0,0,0,backShade);
    }

    public GlitterPanel() {
        setOpaque(false);
        setDoubleBuffered(false);
        super.setVisible(false);
        initComponents();
    }

    public void setDelay(int d)
    {
        animDelay=d;
    }

    public void setPlaybackData(int[] d)
    {
        playBackData = d;
        playbackPos=0;
    }

    public void deinit()
    {
        setVisible(false);
        removeAll();
        x = null;
        y = null;
        partikelX = null;
        partikelY = null;
        p = null;
        partikelBrightness = null;
        partikelVisible = null;
        partikelA = null;
        colorMap = null;
    }
    @Override
    public void setBounds(int x, int y, int width, int height)
    {
        super.setBounds(x, y, width, height);
        this.width = width;
        this.height = height;
        workWidth = width;
        workHeigth = height;
    }

    @Override public void setVisible(boolean b)
    {
        if (deinit) return;
        if (b==isVisible()) return;
        super.setVisible(b);

        if ( b )
        {
            if (animator == null)
            {
                animator = new Thread(this);
                doRun = true;
                playbackPos=0;
                height=getHeight();
                width=getWidth();
            	init();

                animator.start();
            }
        }
        else
        {
            if (animator != null)
            {
                synchronized (this)
                {
                    doRun = false;
                    animator.interrupt();
                    animator = null;
                }
            }
        }
    }

    // Run the animation thread.
    // First wait for the background image to fully load
    // and paint.  Then wait for all of the animation
    // frames to finish loading. Finally, loop and
    // increment the animation frame index.
    @Override
    public void run()
    {
        if (deinit) return;
        while (doRun)
        {
            try
            {
                Thread.sleep(animDelay);
                update();
            }
            catch (InterruptedException e)
            {
                break;
            }
            synchronized (this)
            {
            }
            repaint();
        }
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setOpaque(false);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables


    public void init()
    {
        if (deinit) return;

        u = true;
        imageLoadState = 0;
        noUpdateNeeded = false;
        mouseButtonPressed = false;
        linkCursorSet = false;
        lastXMousePos = 0;
        lastYMousePos = 0;
        xMotionEvent = 0;
        yMotionEvent = 0;
        oldLastXMousePos = 0;
        oldLastYMousePos = 0;
        q = 0.0D;
        b = 0.050000000000000003D;
        colorCount = 256;
        colorNo = 0;
        partikelNo = 2000;
        hasMouseDynamic = true;
        spreading = 35D;
        aging = 0.96999999999999997D;
        frequency = 20;
        gravity = 1.0D;

        workWidth = width;
        workHeigth = height;
        partikelNo = PARTIKEL_NO;
        spreading = SPREADING;
        hasMouseDynamic = MOUSE_DYNAMIC;
        aging = 1.0D - 0.001D * (double)AGING;
        frequency = FREQUENCY;
        gravity = 0.10000000000000001D * (double)GRAVITY;
        bgImageName = BACK_IMAGE;
        brightness = 0.029999999999999999D * (double)BRIGHTNESS;
        x = new double[partikelNo];
        y = new double[partikelNo];
        partikelX = new double[partikelNo];
        partikelY = new double[partikelNo];
        p = new double[partikelNo];
        partikelBrightness = new double[partikelNo];
        partikelVisible = new boolean[partikelNo];
        partikelA = new int[partikelNo];
        for(int i1 = 0; i1 < partikelNo; i1++)
            partikelVisible[i1] = false;

        colorMap = new Color[colorCount];
        for(int j1 = 0; j1 < colorCount; j1++)
        {
            int i2 = j1;
            if(i2 > 255)
                i2 = 255;
            int l1 = (int)(2D * (double)j1);
            if(l1 > 255)
                l1 = 255;
            int k1 = (int)(4D * (double)j1);
            if(k1 > 255)
                k1 = 255;
            colorMap[j1] = new Color(k1, l1, i2);
        }

        if (mode == RECORD_MODE)
        {
            addMouseListener(new GlitterMouseListener());
            addMouseMotionListener(new GlitterMouseMotionListener());
        }

        firstUpdate = true;
    }

    int row = 0;
    private void update()
    {
        if (firstUpdate)
        {
            imageLoadState = 1;
            imageLoadState = 2;
            firstUpdate = false;
        }

        if (mode == RECORD_MODE)
        {
            if (!mouseButtonPressed)
                System.out.print(", "+0);
            else
                System.out.print(", "+1);

            System.out.print(", "+xMotionEvent+", "+yMotionEvent);
            row++;
            if (row == 10)
            {
                System.out.println();
                row = 0;
            }
        }
        if (mode == PLAY_MODE)
        {
            mouseButtonPressed = playBackData[playbackPos+0]==1;
            xMotionEvent = playBackData[playbackPos+1];
            yMotionEvent = playBackData[playbackPos+2];
            playbackPos +=3;
            if (playbackPos >= playBackData.length) playbackPos =0;
        }
        q += b;
        int partikelDepth = 0;
        if(!noUpdateNeeded || mouseButtonPressed)
        {
            noUpdateNeeded = true;
            for(int partikel = 0; partikel < partikelNo; partikel++)
            {
                if(partikelDepth < frequency && !partikelVisible[partikel] && mouseButtonPressed)
                {
                    double d1 = (1.0D * (double)partikelDepth) / (double)frequency;
                    x[partikel] = oldLastXMousePos + (int)(d1 * (double)(lastXMousePos - oldLastXMousePos)) + (int)(0.10000000000000001D * spreading * (Math.random() - 0.5D));
                    y[partikel] = oldLastYMousePos + (int)(d1 * (double)(lastYMousePos - oldLastYMousePos)) + (int)(0.10000000000000001D * spreading * (Math.random() - 0.5D));
                    partikelX[partikel] = spreading * (Math.random() - 0.5D);
                    partikelY[partikel] = spreading * (Math.random() - 0.5D);
                    if(hasMouseDynamic)
                    {
                        partikelX[partikel] += 3 * (lastXMousePos - oldLastXMousePos);
                        partikelY[partikel] += 3 * (lastYMousePos - oldLastYMousePos);
                    }
                    partikelBrightness[partikel] = brightness * (0.25D + Math.random());
                    p[partikel] = 15D * Math.random();
                    partikelA[partikel] = (int)(1.5D * Math.random());
                    partikelVisible[partikel] = true;
                    partikelDepth++;
                    noUpdateNeeded = false;
                } 
                else if (partikelVisible[partikel])
                {
                    noUpdateNeeded = false;
                    partikelY[partikel] += gravity;
                    partikelX[partikel] *= 0.96999999999999997D;
                    partikelY[partikel] *= 0.96999999999999997D;
                    x[partikel] += b * partikelX[partikel];
                    y[partikel] += b * partikelY[partikel];
                    partikelBrightness[partikel] *= aging;
                    if(y[partikel] > (double)workHeigth || x[partikel] < 0.0D || x[partikel] > (double)workWidth || partikelBrightness[partikel] < 0.40000000000000002D)
                        partikelVisible[partikel] = false;
                }
            }
        }
        oldLastXMousePos = lastXMousePos;
        oldLastYMousePos = lastYMousePos;
        lastXMousePos = xMotionEvent;
        lastYMousePos = yMotionEvent;
        repaint();
    }

    @Override public void paintComponent(Graphics g1)
    {
        if (deinit) return;
        if(imageLoadState == 2)
        {
            g1.setColor(backColor);
            g1.fillRect(0, 0, workWidth, workHeigth);

            if (!noUpdateNeeded)
            {
                for(int partikel = 0; partikel < partikelNo; partikel++)
                {
                    if(partikelVisible[partikel])
                    {
                        double partikelTailLengthDouble = partikelBrightness[partikel] * (1.5D + Math.sin(q * p[partikel]));
                        int currentX = (int)x[partikel];
                        int currentY = (int)y[partikel];
                        if(partikelTailLengthDouble > 1.5D)
                        {
                            int partikelTailLengthInt = (int)(partikelTailLengthDouble - 0.5D);
                            colorNo = (int)(40D * partikelTailLengthDouble);
                            if(colorNo >= colorCount)
                                colorNo = colorCount - 1;
                            g1.setColor(colorMap[colorNo]);
                            if(partikelA[partikel] == 0)
                            {
                                g1.fillRect(currentX - partikelTailLengthInt, currentY, 2 * partikelTailLengthInt, 1);
                                g1.fillRect(currentX, currentY - partikelTailLengthInt, 1, 2 * partikelTailLengthInt);
                            } else
                            {
                                g1.drawLine(currentX - partikelTailLengthInt, currentY - partikelTailLengthInt, currentX + partikelTailLengthInt, currentY + partikelTailLengthInt);
                                g1.drawLine(currentX + partikelTailLengthInt, currentY - partikelTailLengthInt, currentX - partikelTailLengthInt, currentY + partikelTailLengthInt);
                            }
                        }
                        colorNo = (int)(100D * partikelTailLengthDouble);
                        if(colorNo >= colorCount)
                            colorNo = colorCount - 1;
                        g1.setColor(colorMap[colorNo]);
                        g1.fillRect(currentX, currentY, 1, 1);
                    }
                }
            }
        }
    }
    int workWidth;
    int workHeigth;
    int z;
    boolean u;
    int imageLoadState;
    boolean noUpdateNeeded;
    boolean mouseButtonPressed;
    boolean linkCursorSet;
    int lastXMousePos;
    int lastYMousePos;
    int xMotionEvent;
    int yMotionEvent;
    int oldLastXMousePos;
    int oldLastYMousePos;
    double q;
    double b;
    double x[];
    double y[];
    double partikelX[];
    double partikelY[];
    double partikelBrightness[];
    double p[];
    boolean partikelVisible[];
    int partikelA[];
    Color colorMap[];
    int colorCount;
    int colorNo;
    int partikelNo;
    boolean hasMouseDynamic;
    double spreading;
    double aging;
    int frequency;
    double gravity;
    String bgImageName;
    double brightness;

    class GlitterMouseMotionListener extends MouseMotionAdapter
    {

        @Override
        public void mouseMoved(MouseEvent mouseevent)
        {
            mouseDragged(mouseevent);
        }

        @Override
        public void mouseDragged(MouseEvent mouseevent)
        {
            xMotionEvent = mouseevent.getX();
            yMotionEvent = mouseevent.getY();
        }

        GlitterMouseMotionListener()
        {
        }
    }

    class GlitterMouseListener extends MouseAdapter
    {

        @Override
        public void mousePressed(MouseEvent mouseevent)
        {
            mouseButtonPressed = true;
        }

        @Override
        public void mouseReleased(MouseEvent mouseevent)
        {
            mouseButtonPressed = false;
        }

        GlitterMouseListener()
        {
        }
    }
}