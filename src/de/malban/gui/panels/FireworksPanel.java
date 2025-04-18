
/*
 * FireworksPanel.java
 * Taken from: http://hp.vector.co.jp/authors/VA012735/applet/applets_en.htm
 *
 * changed to use transparency, and removed text support
 *
 * Created on 08.03.2010, 19:48:20
 */

package de.malban.gui.panels;


import de.malban.sound.PlayClip;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.MemoryImageSource;
import java.io.File;
import java.util.Random;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 *
 * @author Malban
 */
public class FireworksPanel extends javax.swing.JPanel implements Runnable {
    private int fireworkProbability=30;
    private int explosionForce=50;
    int QA = fireworkProbability, QB = explosionForce;
    int[] pix;
    int[] pr, pg, pb, pa;
    int[][] s,c;
    float[][] vx, vy, x, y;
    int[] b;
    int[] rgb = new int[3];
    int[][] color = new int[QA][4];
    int wa = -1;
    int[][] iprgb = createPixels();
    MemoryImageSource source;
    int[] bx = new int[MAX], by = new int[MAX];
    int size = 0;
    int iw;
    int length, sh;
    int count = 0, mstate = 1;
    boolean deinit = false;
    private boolean drawPartTranslucent=true;
    int animDelay = 10;
    boolean isBlur = true;
    int randTimeBetweenFirework=1000;
    int gushFrequency =8; // 1 of x

    Thread animator = null;
    boolean doRun = false;
    int index=0;

    boolean isGush=true;
    private Dimension msize;

    private int w, h;
    private Image img = null;


    private static int backShade=0;
    private static final int MAX = 1024, MAG = 2, OX = 1, OY=1, ANGLE = 1024;
    private static final Random rnd = new Random();
    private static int opa=255;
    private static final int[][] CPAL={
             {255,255,255,opa}
            ,{255,255,100,opa}
            ,{148,248,198,opa}
            ,{20,255,255,opa}
            ,{255,128,192,opa}
            ,{255,235,165,opa}
            ,{255,128,255,opa}
            ,{128,158,255,opa}
            ,{255,128,0,opa}
            ,{133,222,20,opa}
            };
    private static final float[] SIN, COS;
    static
    {
        SIN = new float[ANGLE];
        COS = new float[ANGLE];
        for(int g = 0; g < ANGLE; g++){
            double r = Math.PI * g * 2 / ANGLE;
            SIN[g] = (float)Math.sin(r);
            COS[g] = (float)Math.cos(r);
        }
    }

    PlayClip startingFromGround  = new PlayClip("sound"+File.separator+"Bang2.wav",5);
    PlayClip explosionInAir = new PlayClip("sound"+File.separator+"Bang4.wav",3);

    /** Creates new form FireworksPanel */
    public FireworksPanel()
    {
        super.setVisible(false);
        initComponents();
        // setBackground(new Color(255,255,255,100));
    }
    public void deinit()
    {
        setVisible(false);

        removeAll();
        explosionInAir.deinit();
        startingFromGround.deinit();
        pix = null;
        pr = pg = pb = pa = null;
        s = c = null;
        vx = vy = x= y = null;
        b=null;
        rgb = null;
        color = null;
        iprgb = null;
        source = null;
        bx = null;
        by = null;

        animator = null;
        img = null;
        deinit = true;
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
        Dimension d = getSize();
        w = d.width;
        h = d.height;

        isGush = true;

        QA = fireworkProbability;
        QB = explosionForce;
        s=new int[QA][QB];
        vx=new float[QA][QB];
        vy=new float[QA][QB];
        x=new float[QA][QB];
        y=new float[QA][QB];
        c=new int[QA][4];
        b=new int[QA];
        for(int n = 0; n < QA; n++)
            b[n] = -1;
        wa = -1;

        color = new int[QA][4];
        iprgb = createPixels();
        pix = new int[w * h];
        pr = new int[w * h];
        pg = new int[w * h];
        pb = new int[w * h];
        pa = new int[w * h];
        source = new MemoryImageSource ( w, h , pix, 0, w);

        source.setAnimated(true);
        source.setFullBufferUpdates(true);
        img = createImage(source);

        bx = new int[MAX];
        by = new int[MAX];
        size = 0;
        iw = (int)(w * 0.2);
        length = w * h;
        sh = (int)(Math.sqrt(h) / 2);
        count = 0;
    }

    @Override public void setVisible(boolean b)
    {
        if (deinit) return;
        if (b== isVisible()) return;
        super.setVisible(b);

        if ( b )
        {
            init();
            if (animator == null)
            {
                animator = new Thread(this);
                doRun = true;
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
    private int[][] createPixels()
    {
        int[] ipx;		
        int[] ipr, ipg, ipb, ipa;
        ipx = new int[w * h];
        ipr = new int[ipx.length];
        ipg = new int[ipx.length];
        ipb = new int[ipx.length];
        ipa = new int[ipx.length];
        return new int[][]{ipr, ipg, ipb, ipa};
    }

    // Run the animation thread.
    // First wait for the background image to fully load
    // and paint.  Then wait for all of the animation
    // frames to finish loading. Finally, loop and
    // increment the animation frame index.
    public void run()
    {
        if (deinit) return;
        while (doRun)
        {
            try
            {
                Thread.sleep(animDelay);
            }
            catch (InterruptedException e)
            {
                break;
            }
            synchronized (this)
            {
                try
                {
                    drawFirework();
                }
                catch(Throwable e) {}
            }
            repaint();
        }
    }

    private static final int ran(int max)
    {
        final int i = rnd.nextInt() % max;
        return i < 0 ? -i : i;
    }

    public void drawFirework()
    {
        if (deinit) return;
        for(int n = 0; n < QA; n++)
        {
            switch(b[n])
            {
                case -1:	
                {
                    x[n][0] = ran(w - iw) + iw / 2;
                    b[n] = 0;	
                    c[n][0] = ran(randTimeBetweenFirework);
                    c[n][2] = isGush ? ran(gushFrequency) : 1;
                    c[n][3] = 0;	

                    if(c[n][2] == 0)
                    {
                        s[n][0] = 0;
                        y[n][0] = h - 2;
                    }else
                    {
                        s[n][0] = ran(sh * 2 / 3) + sh;	
                        y[n][0] = h;
                    }

                    int d = ran(CPAL.length);
                    color[n][0] = CPAL[d][0];
                    color[n][1] = CPAL[d][1];
                    color[n][2] = CPAL[d][2];
                    color[n][3] = CPAL[d][3];
                    break;
                }
                case 0:		
                    c[n][0]--;
                    if(c[n][0] <= 0)
                    {
                        b[n] = 1;
startingFromGround.play();
//hyu.play();
                    }
                    break;
                case 1:		
                {
                    int d;
                    y[n][0] -= s[n][0];
                    if(c[n][1]++%3==0)
                            s[n][0]--;
                    if(s[n][0] > 1)
                            x[n][0] += rnd.nextInt() % 2;
                    if((d = (int)x[n][0] + (int)y[n][0] * w) >= 0)
                            pa[d] = pr[d] = pg[d] = pb[d] = 0xff;
                    if(s[n][0] <= 0)
                            b[n] = 2;
                    break;
                }
                case 2:		
                {
                    float k = rnd.nextFloat() * 2 + 0.4f;	
                    int	m, sm = ran(ANGLE / QB + 1);
                    float j;
                    if(c[n][2] != 0)
                    {
                        for(int i = 0; i < QB; i++)
                        {
                            y[n][i] = y[n][0];
                            x[n][i] = x[n][0];
                            m = (2 * ANGLE * i / QB + sm) % ANGLE;
                            j = rnd.nextFloat() * k;
                            vx[n][i] = j * COS[m];
                            vy[n][i] = j * SIN[m];
                        }
                    }else
                    {
                        for(int i = 0; i < QB; i++)
                        {
                            y[n][i] = y[n][0];
                            x[n][i] = x[n][0];
                            m = (ANGLE * i / QB / 8 + 11 * ANGLE / 16 + sm) % ANGLE;
                            j = rnd.nextFloat() * (k + 1);
                            vx[n][i] = j * COS[m];
                            vy[n][i] = j * SIN[m];
                        }
                    }

                    b[n] = 3;
                    c[n][1] = 0;
//ban.play();
explosionInAir.play();
                    break;
                }
                case 3:		
                {
                    int d;
                    int[] pal = color[n];

                    if(c[n][3] > 25)
                    {
                        pal[0] -= 8;
                        if(pal[0]<0) pal[0] = 0;
                        pal[1] -= 8;
                        if(pal[1]<0) pal[1] = 0;
                        pal[2] -= 8;
                        if(pal[2]<0) pal[2] = 0;
                        pal[3] -= 8;
                        if(pal[3]<0) pal[3] = 0;
                    }
                    c[n][3]++;
                    for(int i = 0; i < QB; i++)
                    {
                        x[n][i] += vx[n][i];
                        y[n][i] += vy[n][i];
                        if((d = (int)x[n][i] + (int)y[n][i] * w) >= 0 && d < length - w
                            && ran(2) == 0)
                        {
                            pr[d] += pal[0];
                            if(pr[d] > 255) pr[d] = 255;
                            pg[d] += pal[1];
                            if(pg[d] > 255) pg[d] = 255;
                            pb[d] += pal[2];
                            if(pb[d] > 255) pb[d] = 255;
                            pa[d] += pal[3];
                            if(pa[d] > 255) pa[d] = 255;
                        }
                    }
                    break;
                }
                default:
            }
            if(c[n][3] > 60)
                b[n] = -1;	
        }
        for(int j = w, k, m, c0, c1, c2, c3; j < length - w; j++)
        {
            pr[j] -= 6;
            if(pr[j] < 0) pr[j] = 0;
            m = iprgb[0][j] + pr[j];
            c0 = m > 255 ? 255 : m;

            pg[j] -= 6;
            if(pg[j] < 0) pg[j] = 0;
            m = iprgb[1][j] + pg[j];
            c1 = m > 255 ? 255 : m;

            pb[j] -= 6;
            if(pb[j] < 0) pb[j] = 0;
            m = iprgb[2][j] + pb[j];
            c2 = m > 255 ? 255 : m;

            pa[j] -= 6;
            if(pa[j] < 0) pa[j] = 0;
            m = iprgb[3][j] + pa[j];
            c3 = m > 255 ? 255 : m;

            if(isBlur)
            {
                pr[j] = (pr[j - 1] + pr[j + 1] + pr[j] + pr[j + w]) / 4;
                pg[j] = (pg[j - 1] + pg[j + 1] + pg[j] + pg[j + w]) / 4;
                pb[j] = (pb[j - 1] + pb[j + 1] + pb[j] + pb[j + w]) / 4;
                pa[j] = (pa[j - 1] + pa[j + 1] + pa[j] + pa[j + w]) / 4;
            }else
            {
                pr[j] -= 10;
                pg[j] -= 10;
                pb[j] -= 10;
                pa[j] -= 10;
            }

            c3 = c2+c1+c0;
            if (c3>255) c3 = 255;


            if (drawPartTranslucent)
            {
                if (c3<backShade) c3 = backShade;
                pix[j]=(c3 << 24) |(c0 << 16) | (c1 << 8) | c2;
            }

            else
            {
                if (c0+c1+c2!=0)
                    pix[j]=(255 << 24) |(c0 << 16) | (c1 << 8) | c2;
                else
                    pix[j]=0;

            }
        }
        source.newPixels();
        repaint();
    }

    @Override public void paintComponent(Graphics g)
    {
        if (deinit) return;
        if(img != null)
            g.drawImage(img,0,0,this);
    }
}
