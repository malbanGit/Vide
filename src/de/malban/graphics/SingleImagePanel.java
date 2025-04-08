/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * SingleImagePanel.java
 *
 * Created on 05.05.2010, 12:37:37
 */

package de.malban.graphics;

import de.malban.config.Configuration;
import de.malban.event.EditMouseEvent;
import de.malban.gui.ImageCache;
import de.malban.gui.panels.LogPanel;
import de.malban.util.KeyboardListener;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import static java.awt.event.ActionEvent.ALT_MASK;
import static java.awt.event.ActionEvent.CTRL_MASK;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Vector;
import javax.imageio.ImageIO;

/**
 *
 * @author malban
 */
public class SingleImagePanel extends javax.swing.JPanel {

    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private Vector<MouseMovedListener> mMovedListener= new Vector<MouseMovedListener>();
    private Vector<MousePressedListener> mClickListener= new Vector<MousePressedListener>();

    private BufferedImage sourceImage = null;
    BufferedImage scaledImage = null;
    GridData grid = new GridData();
    Color crossColor = Color.ORANGE;

    int sourceHeight=0;
    int sourceWidth=0;

    boolean doOffset=false;

    int offsetX=0;
    int offsetY=0;
    int scaledOffsetX=0;
    int scaledOffsetY=0;
    boolean fixedScale = false;
    boolean isScale = false;
    int scaleW=0;
    int scaleH=0;

    boolean drawCheckers = true;

    int scaleHeight = 0;
    int scaleWidth = 0;
    double scaleX = 1.0;
    double scaleY = 1.0;
    int inSetting = 0;
    
    
    int mX=0;
    int mY=0;
    int mXPressStart = 0;
    int mYPressStart = 0;
    boolean shiftPressed = false;
    boolean pressed = false;
    boolean crossDrawn = true;
    boolean displayDragSelection = true;

    boolean noCross = true;
    boolean draging = false;
    boolean displayGrid=false;
    public int selWidth = 0;
    public int selHeight = 0;
    boolean selectionLock = false;
    boolean noMouseReaction = false;
    
    int R=0;
    int G=0;
    int B=0;
    int A=0;
    String orgName = "";


    int selX=-1;
    int selY=-1;
    int selW=-1;
    int selH=-1;
    boolean selectionSet = false;

    /** Creates new form SingleImagePanel */
    public SingleImagePanel() {
        initComponents();
    }

    public void deinit()
    {
        setVisible(false);
        mMovedListener.clear();
        mClickListener.clear();
        unsetImage();
    }
    
    public boolean saveSourceImage()
    {
        return saveSourceImage(orgName);
    }

    public String getOrgName()
    {
        return orgName;
    }
    public void setDrawCheckers(boolean dc)
    {
        drawCheckers = dc;
    }
    public void setCrossDrawn(boolean cd)
    {
        crossDrawn = cd;
    }
    public void setSelectionDrawn(boolean sd)
    {
        displayDragSelection = sd;
    }
    
    public void setNoMouseRection(boolean mr)
    {
        noMouseReaction = mr;
    }

    public boolean isShiftPressedOnClick()
    {
        return shiftPressed;
    }
    public int getSourceHeight() {
        return sourceHeight;
    }

    public int getSourceWidth() {
        return sourceWidth;
    }

    public boolean saveSourceImage(String path)
    {
        try
        {
            File outputfile = new File(path);
            ImageIO.write(sourceImage, "png", outputfile);
        }
        catch (IOException e)
        {
            return false;
        }
        return true;
    }
    public boolean saveScaledImage(String path)
    {
        try
        {
            File outputfile = new File(path);
            ImageIO.write(scaledImage, "png", outputfile);
        }
        catch (IOException e)
        {
            return false;
        }
        return true;
    }

    public boolean isImageSet()
    {
        return sourceImage != null;
    }
    
    public void sourceToAlpha()
    {
        sourceImage = ImageCache.getImageCache().toAlpha(sourceImage);
        correctScaleWithOffset();
    }

    public boolean isAlpha()
    {
        return sourceImage.getColorModel().hasAlpha();
    }

    public void replaceColorToBackground(int r, int g, int b, int a)
    {
        if (inSetting>0) return;
        inSetting++;

        if (!isAlpha())
        {
            sourceToAlpha();
        }


        int rgbaSeek = new Color(r,g,b,a).getRGB();
        int rgbaSet = new Color(r,g,b,0).getRGB();

        for(int y = 0; y < sourceImage.getHeight(); y++)
        {
            for(int x = 0; x < sourceImage.getWidth(); x++)
            {
                int rgba = sourceImage.getRGB(x, y);
                if (rgba == rgbaSeek)
                    sourceImage.setRGB(x, y,rgbaSet);
            }

        }

        ImageCache.getImageCache().invalidateDerivates(sourceImage);
        scaledImage = ImageCache.getImageCache().getDerivatScale(sourceImage, scaleWidth, scaleHeight);
        setSize(new Dimension(scaleWidth, scaleHeight));
        setPreferredSize(new Dimension(scaleWidth, scaleHeight));
        repaint();
        inSetting--;
    }
    

 public boolean setImageFromClipboard()  {
        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();

        try {
            // Check if clipboard has an image
            if (clipboard.isDataFlavorAvailable(DataFlavor.imageFlavor)) {
                // Get the image from the clipboard
                Image image = (Image) clipboard.getData(DataFlavor.imageFlavor);

                // Convert the image to a BufferedImage
                BufferedImage bufferedImage = new BufferedImage(
                        image.getWidth(null),
                        image.getHeight(null),
                        BufferedImage.TYPE_INT_ARGB
                );

                // Draw the image onto the BufferedImage
                bufferedImage.getGraphics().drawImage(image, 0, 0, null);
                
                sourceImage = bufferedImage;
                if (sourceImage==null) return false;
                sourceHeight=sourceImage.getHeight(null);
                sourceWidth=sourceImage.getWidth(null);
                setScale(1);
                return true;
                
            } else {
                log.addLog("No image available in clipboard.");
//                throw new IOException("No image available in clipboard.");
            }
        } catch (Exception e) {
//            throw new IOException("Failed to retrieve image from clipboard.", e);
                log.addLog("Failed to retrieve image from clipboard.");
        }
        return false;
    }    
        

    public boolean setImage(String path)
    {
        if (inSetting>0) return true;
        if (path.trim().length()==0) return false;

        orgName = path;
        sourceImage = ImageCache.getImageCache().getImage(path);
        if (sourceImage==null) return false;
        sourceHeight=sourceImage.getHeight(null);
        sourceWidth=sourceImage.getWidth(null);
        setScale(1);
        return true;
    }
    public boolean setImage(String path, boolean scaleToFit)
    {
        if (inSetting>0) return true;
        if (path.trim().length()==0) return false;

        orgName = path;
        sourceImage = ImageCache.getImageCache().getImage(path);
        if (sourceImage==null) return false;
        sourceHeight=sourceImage.getHeight(null);
        sourceWidth=sourceImage.getWidth(null);
        scaleToFit();
        return true;
    }

    public BufferedImage getImage()
    {
        return sourceImage;
    }
    public BufferedImage getScaledImage()
    {
        return scaledImage;
    }
    // without caching - or caching external!
    public boolean setImage(BufferedImage image)
    {
        
        if (inSetting>0) return true;
        inSetting++;
        orgName = "";
        sourceImage = image;

        sourceHeight=sourceImage.getHeight(null);
        sourceWidth=sourceImage.getWidth(null);
        inSetting--;
        setScale(1);
        return true;
    }

    void correctScaleWithOffset()
    {
        if (!isScale)
        {
            scaledOffsetY = offsetY;
            scaledOffsetX = offsetX;
            return;
        }
        if (fixedScale)
            setScale(scaleW, scaleH);
        else
            setScale(scaleX, scaleY);
    }

    private void setScale(double sx, double sy)
    {
        if (inSetting>0) return;
        if (sourceImage == null) return;
        inSetting++;
        isScale = true;
        scaleX = (double) sx;
        scaleY = (double) sy;
        scaledOffsetY = (int) ((double) (scaleY * ((double) offsetY) )  );
        scaledOffsetX = (int) ((double) (scaleX * ((double) offsetX) )  );

        scaleHeight = (int) ((double) (scaleY * ((double) sourceHeight) )  );
        scaleWidth = (int) ((double) (scaleX * ((double) sourceWidth) )  );



        scaledImage = ImageCache.getImageCache().getDerivatScale(sourceImage, scaleWidth, scaleHeight);

        setSize(new Dimension(scaleWidth, scaleHeight));
        setPreferredSize(new Dimension(scaleWidth, scaleHeight));
        repaint();
        scaleToFit = false;
        inSetting--;
    }

    // only upscale by multiply!
    public void setScale(int scale)
    {
        fixedScale = false;
        setScale((double) scale,(double) scale);
    }

    public void setScale(double scale)
    {
        fixedScale = false;
        setScale(scale, scale);
    }
    boolean scaleToFit=false;
    public void scaleToFit()
    {
        setScale(getWidth(), getHeight());
        scaleToFit=true;
    }

    // absolut scale
    public void setScale(int w, int h)
    {
        scaleToFit = false;
        isScale = true;
        fixedScale = true;
        scaleW = w;
        scaleH = h;
        scaleX = (double) (((double)w)/((double)(sourceWidth+offsetX)));
        scaleY = (((double)h)/((double)(sourceHeight+offsetY)));

        if (inSetting>0) return;
        if (sourceImage == null) return;
        inSetting++;

        scaledOffsetY = (int) ((double) (scaleY * ((double) offsetY) )  );
        scaledOffsetX = (int) ((double) (scaleX * ((double) offsetX) )  );

        scaleHeight = (int) ((double) (scaleY * ((double) sourceHeight) )  );
        scaleWidth = (int) ((double) (scaleX * ((double) sourceWidth) )  );
        scaledImage = ImageCache.getImageCache().getDerivatScale(sourceImage, scaleWidth, scaleHeight);


        setSize(new Dimension(scaleWidth, scaleHeight));
        setPreferredSize(new Dimension(scaleWidth, scaleHeight));
        invalidate();
        validate();
        repaint();
        inSetting--;
    }

    // width and height is here the width and height of
    // the SingleImagePanel
    // otherwise envelopoing scroll pane does not "reset"
    public void unsetScale(int w, int h)
    {
        if (inSetting>0) return;
        if (sourceImage == null) return;
        setScale(1.0);
        isScale = false;
        setSize(new Dimension(w, h));
        setPreferredSize(new Dimension(w, h));
        invalidate();
        validate();
        repaint();
    }

    public void unsetScale()
    {
        if (inSetting>0) return;
        if (sourceImage == null) return;
        setScale(1.0);
        isScale = false;
    }
    public double getScaleX()
    {
        return scaleX;
    }
    public double getScaleY()
    {
        return scaleY;
    }


    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseMoved(java.awt.event.MouseEvent evt) {
                formMouseMoved(evt);
            }
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                formMouseDragged(evt);
            }
        });
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                formMouseReleased(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                formMouseExited(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                formMouseEntered(evt);
            }
        });
        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });

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

    private void formMouseMoved(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseMoved
        mX=evt.getX();
        mY=evt.getY();
        crossColor = Color.ORANGE;
        repaint();
        
        fireMouseMoved(evt);
    }//GEN-LAST:event_formMouseMoved

    void setGrid(boolean g)
    {
        displayGrid=g;
        repaint();
    }

    void setGrid(GridData g)
    {
        grid = g;
        repaint();
    }


    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
        if (noMouseReaction) return;

        shiftPressed = false;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            selectionSet = false;
            pressed = true;
            mXPressStart = evt.getX();
            mYPressStart = evt.getY();
            if (evt != null)
                shiftPressed = ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK);
        }
        fillRGBA(mXPressStart, mYPressStart);

        fireClicked(evt);
        crossColor = Color.GREEN;
        repaint();

    }//GEN-LAST:event_formMousePressed

    public int getPressedStartX()
    {
        return mXPressStart;
    }
    public int getPressedStartY()
    {
        return mYPressStart;
    }
    
    private void formMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseReleased
        if (noMouseReaction) return;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            pressed = false;
            draging = false;
        }
        crossColor = Color.ORANGE;
        repaint();

    }//GEN-LAST:event_formMouseReleased

    private void formMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseExited
        if (noMouseReaction) return;
        pressed = false;
        noCross = true;
        repaint();
    }//GEN-LAST:event_formMouseExited

    private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged

        if (noMouseReaction) return;
        if (selectionLock)
        {
            mXPressStart = evt.getX();
            mYPressStart = evt.getY();
        }
        mX=evt.getX();
        mY=evt.getY();
        draging = true;
        crossColor = Color.GREEN;
        fireMouseMoved(evt);
        
        repaint();
    }//GEN-LAST:event_formMouseDragged

    private void formMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseEntered
        if (noMouseReaction) return;
        if (evt.getButton() == MouseEvent.BUTTON1)
            pressed = true;
        noCross = false;
    }//GEN-LAST:event_formMouseEntered

    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
        if (scaleToFit) scaleToFit();

    }//GEN-LAST:event_formComponentResized

    @Override public void paintComponent(Graphics g)
    {
        int clearWidth = scaleWidth;
        int clearHeight = scaleHeight;

        if (scaleWidth < getWidth()) clearWidth = getWidth();
        if (scaleHeight < getHeight()) clearHeight = getHeight();

        g.clearRect(0, 0, clearWidth, clearHeight);

        if (drawCheckers)
        {
            int SIZE = 10;
            int y = 0;
            int x;

            boolean first = true;

            while (y<clearHeight)
            {
                x = 0;
                while (x<clearWidth)
                {
                    if(first)
                    {
                        g.setColor(Color.lightGray);
                        g.fillRect(x, y, SIZE, SIZE);
                        x+=SIZE;
                        g.setColor(Color.GRAY);
                        g.fillRect(x, y, SIZE, SIZE);
                        x+=SIZE;
                    }
                    else
                    {
                        g.setColor(Color.GRAY);
                        g.fillRect(x, y, SIZE, SIZE);
                        x+=SIZE;
                        g.setColor(Color.lightGray);
                        g.fillRect(x, y, SIZE, SIZE);
                        x+=SIZE;
                    }
                }
                first = !first;
                y+=SIZE;
            }
        }

        if (scaledImage != null)
        {
            g.drawImage(scaledImage, scaledOffsetX, scaledOffsetY, null);
        }
        Color c = g.getColor();
        if ((!noCross) && (crossDrawn))
        {
            int x = (int)((int) ((int) (mX/scaleX)) * (scaleX));
            int y = (int)((int) ((int) (mY/scaleY)) * (scaleY));
            g.setColor(crossColor);
            g.drawLine(0, y, clearWidth, y);
            g.drawLine(x, 0, x, clearHeight);
        }
        if (displayGrid)
        {
            Color gridColor = Color.PINK;
            g.setColor(gridColor);

            for (int xc = 0; xc<grid.gridWidth; xc++)
            {
                for (int yc = 0; yc<grid.gridHeight; yc++)
                {
                    int x = grid.startX + xc*(grid.gapX+grid.singleWidth);
                    int y = grid.startY + yc*(grid.gapY+grid.singleHeight);

                    x = (int)((int) ((int) (x/1)) * (scaleX));
                    y = (int)((int) ((int) (y/1)) * (scaleY));

                    int w = grid.singleWidth;
                    int h = grid.singleHeight;

                    w = (int)((int) ((int) (w/1)) * (scaleX));
                    h = (int)((int) ((int) (h/1)) * (scaleY));
                    g.drawRect(x, y, w, h);
                }
            }
        }

        if (displayDragSelection)
        {
            if ((draging) || ((selectionLock)&& (pressed)) )
            {
                Color dragArea = new Color(0,200,0,50);
                g.setColor(dragArea);


                int x = (int)((int) ((int) ((mXPressStart+scaleX/2)/scaleX)) * (scaleX));
                int y = (int)((int) ((int) ((mYPressStart+scaleY/2)/scaleY)) * (scaleY));

                int w = (int)((int) ((int) ((mX-mXPressStart+scaleX/2)/scaleX)) * (scaleX));
                int h = (int)((int) ((int) ((mY-mYPressStart+scaleY/2)/scaleY)) * (scaleY));

                if (selectionLock)
                {
                    w = (int)((int) ((int) ((selWidth+scaleX/2)/scaleX)) * (scaleX));
                    h = (int)((int) ((int) ((selHeight+scaleY/2)/scaleY)) * (scaleY));
                    w = (int) (w * (scaleX));
                    h = (int) (h * (scaleY));
                }

                g.fillRect(x, y, w, h);
                if (!selectionLock)
                {
                    selWidth = (int)(w/scaleX);
                    selHeight = (int)(h/scaleY);
                }
            }
            else
            {
                if (!selectionLock)
                {
                    selWidth = 0;
                    selHeight = 0;
                }
            }
        }


        if (selX != -1)
        {
            g.setColor(Color.blue);
            g.drawRect((int)(selX*scaleX), (int)(selY*scaleY), (int)(selW*scaleX), (int)(selH*scaleY));

        }
        g.setColor(c);
    }

    public boolean isLocked()
    {
        return selectionLock;
    }
    public Dimension getSelectionLock()    
    {
        if (!selectionLock) return new Dimension(-1,-1);
        return new Dimension(selWidth,selHeight);
    }
    
    public void setSelectionLock(boolean lock, int w, int h)
    {
        selectionLock = lock;
        selHeight = h;
        selWidth = w;
    }

    public BaseImageData getSelection(int x,int y, int w, int h)
    {
        BaseImageData tile = new BaseImageData();
        tile.fileName = orgName;
        tile.x = x;
        tile.y = y;
        tile.w = w;
        tile.h = h;

        if (tile.w<0)
        {
            tile.w=tile.w*-1;
            tile.x-=tile.w;
        }
        if (tile.h<0)
        {
            tile.h=tile.h*-1;
            tile.y-=tile.h;
        }

        if (tile.x<0) tile.x=0;
        if (tile.y<0) tile.y=0;
        if (tile.x+tile.w > sourceWidth) tile.w = sourceWidth-tile.x;
        if (tile.y+tile.h > sourceHeight) tile.h = sourceHeight-tile.y;

        if ((tile.w<=0) || (tile.h<=0) || (sourceImage==null))
            tile.image = null;
        else
            tile.image = sourceImage.getSubimage(tile.x, tile.y, tile.w, tile.h);

        tile.cx = 0;
        tile.cy = 0;
        tile.cw = w;
        tile.ch = h;

        return tile;
    }
    
    public void fillRGBA(int X, int Y)
    {
        if (sourceImage == null) return;
        int x = (int)((int) ((int) ((X+scaleX/2)/scaleX)) * (scaleX));
        int y = (int)((int) ((int) ((Y+scaleY/2)/scaleY)) * (scaleY));

        x = (int) (x / scaleX);
        y = (int) (y / scaleY);

        if (x>=sourceImage.getWidth()) return;
        if (y>=sourceImage.getHeight()) return;
        if (x<0) return;
        if (y<0) return;

        int rgba =sourceImage.getRGB(x, y);
        Color c = new Color(rgba);
        A = (rgba >> 24) & 0xFF;
        R = c.getRed();
        G = c.getGreen();
        B = c.getBlue();
    }

    public void setSelection(int x, int y, int w, int h)
    {
        selX=x;
        selY=y;
        selW=w;
        selH=h;
       // mXPressStart =selX;
       // mYPressStart =selY;
        //mX =mXPressStart+selW;
        //mY =mYPressStart+selH;

        repaint();
    }
    public BaseImageData getSelection()
    {
        BaseImageData tile = new BaseImageData();
        tile.fileName = orgName;

        int x = (int)((int) ((int) ((mXPressStart+scaleX/2)/scaleX)) * (scaleX));
        int y = (int)((int) ((int) ((mYPressStart+scaleY/2)/scaleY)) * (scaleY));

        int w = (int)((int) ((int) ((mX-mXPressStart+scaleX/2)/scaleX)) * (scaleX));
        int h = (int)((int) ((int) ((mY-mYPressStart+scaleY/2)/scaleY)) * (scaleY));

        if (selectionLock)
        {
            w = (int)((int) ((int) ((selWidth+scaleX/2)/scaleX)) * (scaleX));
            h = (int)((int) ((int) ((selHeight+scaleY/2)/scaleY)) * (scaleY));
            w = (int) (w * (scaleX));
            h = (int) (h * (scaleY));
        }


        return getSelection((int)(x/scaleX),(int)(y/scaleY),(int)(w/scaleX),(int)(h/scaleY));
    }

    public void setBaseImage(BufferedImage image, int w, int h)
    {
        noCross = true;
        noMouseReaction = true;
        if (image==null)
        {
            sourceImage = null;
            return;
        }
        sourceImage = image;
        sourceWidth = sourceImage.getWidth();
        sourceHeight = sourceImage.getHeight();
        setScale(w,h);
        setVisible(true);

    }
    public void bakeScale()
    {
        setBaseImage(scaledImage);
    }

    // for example this might be a selection of an larger image
    public void setBaseImage(BufferedImage image)
    {
        noCross = true;
        noMouseReaction = true;
        if (image==null)
        {
            sourceImage = null;
            return;
        }

        sourceImage = image;
        sourceWidth = sourceImage.getWidth();
        sourceHeight = sourceImage.getHeight();

        unsetScale();
    }

    public int getR()
    {
        return R;
    }
    public int getG()
    {
        return G;
    }
    public int getB()
    {
        return B;
    }
    public int getA()
    {
        return A;
    }

    public void removeAllListeners()
    {
        mMovedListener.clear();
        mClickListener.clear();
    }
    public void addClickListener(MousePressedListener listener)
    {
        mClickListener.removeElement(listener);
        mClickListener.addElement(listener);
    }
    public void removeClickListener(MousePressedListener listener)
    {
        mClickListener.removeElement(listener);
    }
    public void addMouseMovedListener(MouseMovedListener listener)
    {
        mMovedListener.removeElement(listener);
        mMovedListener.addElement(listener);
    }
    public void removeMouseMovedListener(MouseMovedListener listener)
    {
        mMovedListener.removeElement(listener);
    }
    public void fireMouseMoved(MouseEvent evt)
    {
        EditMouseEvent e = new EditMouseEvent();
        e.evt = evt;
        e.dragging = draging;
        e.panel = this;
        for (int i=0; i<mMovedListener.size(); i++)
        {
            mMovedListener.elementAt(i).moved(e);
        }
    }
    public void fireClicked(MouseEvent evt)
    {
        EditMouseEvent e = new EditMouseEvent();
        e.evt = evt;
        e.panel = this;
        for (int i=0; i<mClickListener.size(); i++)
        {
            mClickListener.elementAt(i).pressed(e);
        }
    }
    public void unsetImage()
    {
        sourceImage = null;
        scaledImage = null;
        sourceHeight=0;
        sourceWidth=0;

        scaleHeight = 0;
        scaleWidth = 0;
        scaleX = 1.0;
        scaleY = 1.0;
        inSetting = 0;
        crossColor = Color.ORANGE;
        mX=0;
        mY=0;
        mXPressStart = 0;
        mYPressStart = 0;
        pressed = false;
        noCross = true;
        draging = false;
        grid = new GridData();
        displayGrid=false;
        selWidth = 0;
        selHeight = 0;
        selectionLock = false;
        //absScaleX=0;
        //absScaleY=0;
        noMouseReaction = false;
        selectionSet = false;
        R=0;
        G=0;
        B=0;
        A=0;
        orgName = "";
        offsetX=0;
        offsetY=0;
        scaledOffsetX=0;
        scaledOffsetY=0;
        repaint();
    }

    public void setOffset(int x, int y, boolean ds)
    {
        doOffset = ds;
        if (doOffset)
        {
            offsetX=x;
            offsetY=y;
        }
        else
        {
            offsetX=0;
            offsetY=0;
        }
        correctScaleWithOffset();
        repaint();
    }


    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
}
