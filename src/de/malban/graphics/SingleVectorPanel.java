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

import de.malban.event.EditMouseEvent;
import static de.malban.graphics.SingleVectorPanel.SVP_SELECT_LINE;
import static de.malban.graphics.SingleVectorPanel.SVP_SELECT_POINT;
import de.malban.gui.Scaler;
import de.malban.util.KeyboardListener;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Stroke;
import java.awt.event.MouseEvent;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Vector;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author malban
 */
public class SingleVectorPanel extends javax.swing.JPanel 
{
    public static int ARR_SIZE = 10;
    private boolean usePrivateOffset = false;
    private boolean usePrivateScale = false;
    public void setUsePrivateOffset(boolean b)
    {
        usePrivateOffset = b;
    }
    public void setUsePrivateScale(boolean b)
    {
        usePrivateScale = b;
    }
    double scale = 1.0;
    int xOffset = 0;
    int yOffset = 0;
    
    public class SharedVars
    {
        ArrayList<SingleVectorPanel> siblings = new ArrayList<SingleVectorPanel>();
        Vector<MouseMovedListener> mMovedListener= new Vector<MouseMovedListener>();
        Vector<MousePressedListener> mPressedListener= new Vector<MousePressedListener>();
        Vector<MouseReleasedListener> mReleasedListener= new Vector<MouseReleasedListener>();
        
        Vector<VectorChangedListener> mVectorListener= new Vector<VectorChangedListener>();
        boolean shareRepaintEnabled = true;
        int gridWidth = 10;
        boolean displayGrid = true;
        boolean continueMode = false;
        Vertex continueStart = new Vertex();
        Vertex hightLightVPoint = null;
        ArrayList<Vertex> selectedVertexOrder = new ArrayList<Vertex>();
        GFXVector hightLightVector = null;
    
        int xOffset = 0;
        int yOffset = 0;
        
        int workingMode = SVP_SET;
        Color BACKGROUND_COLOR = Color.BLACK;
        Color CROSS_COLOR = Color.ORANGE;
        Color CROSS_DRAG_COLOR = Color.GREEN;
        Color GRID_COLOR = new Color(50,50,50,128);
        Color FRAME_COLOR = new Color(0,255,255,255);
        Color VECTOR_FOREGROUND_COLOR = new Color(50,50,50,128); // not used, vectors have "own" color
        Color VECTOR_BACKGROUND_COLOR = new Color(50,50,50,128);
        Color VECTOR_ENDPOINT_COLOR = Color.red;
        Color VECTOR_HIGHLIGHT_COLOR = new Color(255,50,255,255);
        Color VECTOR_SELECTED_COLOR = new Color(50,50,255,255);
        Color VECTOR_DRAG_COLOR = new Color(255,255,0,255);
        Color POINT_HIGHLIGHT_COLOR = new Color(255,50,255,255);
        Color POINT_SELECTED_COLOR = new Color(50,50,255,255);
        Color POS_COLOR = new Color(200,255,200,255);
        Color POINT_JOINED_COLOR = new Color(150,50,255,255);
        Color MOVE_COLOR = new Color(50,50,155,255);
        
        int POINT_HIGHLIGHT_RANGE = 10;
        int POINT_HIGHLIGHT_RADIUS = 5;
        int POINT_SELECTED_RADIUS = 7;

        int VECTOR_HIGHLIGHT_RANGE = 10;
        int VECTOR_HIGHLIGHT_RADIUS = 3;
        int VECTOR_SELECTED_RADIUS = 5;
        Color crossColor = CROSS_COLOR;
        boolean isScale = false;
        boolean crossDrawn = true;  // can be set by user
        boolean noMouseReaction = false;
        boolean drawArrows = false;
        boolean drawPositions = false;
        boolean drawMoves = false;
        boolean realyBigEnd = true;

        double scale = 1.0;
        GFXVectorList foregroundVectors = new GFXVectorList();
        GFXVectorList backgroundVectors = new GFXVectorList();
        int vectorWidth = 1;
     
        
        boolean shiftPressed = false;
        boolean pressed = false;
        boolean selecting = true;
        boolean dragging = false;
        boolean displayDragSelection = true;
        boolean drawByteFrame = true;
        MyTableModel dataModel = new MyTableModel();
        
        SharedVars(SingleVectorPanel svp)
        {
            siblings.add(svp);
        }
        
    }
    public void resetSharedVars()
    {
        SharedVars oldVars= vars;
        
        vars=new SharedVars(this);
        vars.gridWidth = oldVars.gridWidth;
        vars.displayGrid = oldVars.displayGrid;
        vars.workingMode = oldVars.workingMode;
        vars.CROSS_COLOR = oldVars.CROSS_COLOR;
        vars.CROSS_DRAG_COLOR = oldVars.CROSS_DRAG_COLOR;
        vars.GRID_COLOR = oldVars.GRID_COLOR;
        vars.VECTOR_FOREGROUND_COLOR = oldVars.VECTOR_FOREGROUND_COLOR;
        vars.VECTOR_BACKGROUND_COLOR = oldVars.VECTOR_BACKGROUND_COLOR;
        vars.VECTOR_ENDPOINT_COLOR = oldVars.VECTOR_ENDPOINT_COLOR;
        vars.VECTOR_HIGHLIGHT_COLOR = oldVars.VECTOR_HIGHLIGHT_COLOR;
        vars.VECTOR_SELECTED_COLOR = oldVars.VECTOR_SELECTED_COLOR;
        vars.VECTOR_DRAG_COLOR = oldVars.VECTOR_DRAG_COLOR;
        vars.POINT_HIGHLIGHT_COLOR = oldVars.POINT_HIGHLIGHT_COLOR;
        vars.POINT_SELECTED_COLOR = oldVars.POINT_SELECTED_COLOR;
        vars.VECTOR_SELECTED_RADIUS = oldVars.VECTOR_SELECTED_RADIUS;
        vars.VECTOR_HIGHLIGHT_RADIUS = oldVars.VECTOR_HIGHLIGHT_RADIUS;
        vars.VECTOR_HIGHLIGHT_RANGE = oldVars.VECTOR_HIGHLIGHT_RANGE;
        vars.POINT_SELECTED_RADIUS = oldVars.POINT_SELECTED_RADIUS;
        vars.POINT_HIGHLIGHT_RADIUS = oldVars.POINT_HIGHLIGHT_RADIUS;
        vars.POINT_HIGHLIGHT_RANGE = oldVars.POINT_HIGHLIGHT_RANGE;
        vars.crossColor = oldVars.crossColor;
        vars.isScale = oldVars.isScale;
        vars.crossDrawn = oldVars.crossDrawn;
        vars.noMouseReaction = oldVars.noMouseReaction;
        vars.drawArrows = oldVars.drawArrows;
        vars.realyBigEnd = oldVars.realyBigEnd;
        vars.scale = oldVars.scale;
        vars.vectorWidth = oldVars.vectorWidth;
        vars.drawByteFrame = oldVars.drawByteFrame;
        
    }
    int selWidth = 0;
    int selHeight = 0;
    
    public int getGridWidth()
    {
        return vars.gridWidth;
    }
    public void setSharedVars(SharedVars vv)
    {
        vars=vv;
    }
    public SharedVars getSharedVars()
    {
        return vars;
    }
    SharedVars vars = new SharedVars(this);
    // ALL even self!
    public void addSibbling(SingleVectorPanel s)
    {
        vars.siblings.add(s);
        s.setSharedVars(getSharedVars());
    }
    public void removeSibbling(SingleVectorPanel s)
    {
        vars.siblings.remove(s);
        s.resetSharedVars();
    }
    
    public void setDrawVectorEnds(boolean b)
    {
        vars.realyBigEnd = b;
        sharedRepaint();
    }
    public static final int SVP_SET = 0;
    public static final int SVP_SELECT_LINE = 1;
    public static final int SVP_SELECT_POINT = 2;
    public static final int SVP_DRAG_POINT = 3;

    public static final int HORIZONTAL_AXIS_X = 0;
    public static final int HORIZONTAL_AXIS_Y = 1;
    public static final int HORIZONTAL_AXIS_Z = 2;
    public static final int VERTICAL_AXIS_X = 0;
    public static final int VERTICAL_AXIS_Y = 1;
    public static final int VERTICAL_AXIS_Z = 2;

    int horizontalAxis = HORIZONTAL_AXIS_X;
    int verticalAxis = VERTICAL_AXIS_Y;
    int inSetting = 0;
    int mX=0;
    int mY=0;
    int mXPressStart = 0;
    int mYPressStart = 0;
    int lastCrossX = 0;
    int lastCrossY = 0;
    int mXRelease = 0;
    int mYRelease = 0;

    int mDragOriginX=0;
    int mDragOriginY=0;
    
    boolean noCross = true;     // auto set on form exit, that no cross is drawn (and no dragging vector)
    boolean mouseExited = false;
    
    int x0Offset = 150;
    int y0Offset = 150;
    public SingleVectorPanel() {
        initComponents();
    }
    public void deinit()
    {
        setVisible(false);
        vars.mMovedListener.clear();
        vars.mPressedListener.clear();
        unsetImage();
    }
    public static boolean displayLen = true;
    public class MyTableModel extends AbstractTableModel
    {
        public final String[] NAMES = new String[] {"uid","x0", "y0", "z0", "x1", "y1", "z1","relativ","next", "previous", "order", "pattern", "intensity", 
            "x_len", "y_len", "z_len", 
            "factor", "R", "G", "B"};
        @Override
        public int getColumnCount() { if (displayLen) return 17+3-4;return 17+3-4-3;}
        @Override
        public int getRowCount() { return vars.foregroundVectors.size();}
        @Override
        public Object getValueAt(int row, int col) { 
          if (col == 0) return vars.foregroundVectors.get(row).uid;
          if (col == 1) return vars.foregroundVectors.get(row).start.x();
          if (col == 2) return vars.foregroundVectors.get(row).start.y();
          if (col == 3) return vars.foregroundVectors.get(row).start.z();
          if (col == 4) return vars.foregroundVectors.get(row).end.x();
          if (col == 5) return vars.foregroundVectors.get(row).end.y();
          if (col == 6) return vars.foregroundVectors.get(row).end.z();
          if (col == 7) return vars.foregroundVectors.get(row).isRelativ();
          if (col == 8) return vars.foregroundVectors.get(row).uid_end_connect;
          if (col == 9) return vars.foregroundVectors.get(row).uid_start_connect;
          if (col == 10) return vars.foregroundVectors.get(row).order;
          if (col == 11) return vars.foregroundVectors.get(row).pattern;
          if (col == 12) return vars.foregroundVectors.get(row).getIntensity();

          if (col == 13) return vars.foregroundVectors.get(row).end.x()-vars.foregroundVectors.get(row).start.x();
          if (col == 14) return vars.foregroundVectors.get(row).end.y()-vars.foregroundVectors.get(row).start.y();
          if (col == 15) return vars.foregroundVectors.get(row).end.z()-vars.foregroundVectors.get(row).start.z();
          
          
          if (col == 16) return vars.foregroundVectors.get(row).factor;
          if (col == 17) return vars.foregroundVectors.get(row).r;
          if (col == 18) return vars.foregroundVectors.get(row).g;
          if (col == 19) return vars.foregroundVectors.get(row).b;
          return "-";
        }
        
        @Override
        public boolean isCellEditable(int row, int col) {
            if (col == 0) return false;
            if (col == 7) return false;

            if (col == 13) return false;
            if (col == 14) return false;
            if (col == 15) return false;
            
            return true;
        }
        
        @Override
        public Class<?> getColumnClass(int col) 
        {
            if (col == 0) return Integer.class;
            if (col == 1) return Double.class;
            if (col == 2) return Double.class;
            if (col == 3) return Double.class;
            if (col == 4) return Double.class;
            if (col == 5) return Double.class;
            if (col == 6) return Double.class;
            if (col == 7) return Boolean.class;
            if (col == 8) return Integer.class;
            if (col == 9) return Integer.class;
            if (col == 10) return Integer.class;
            if (col == 11) return Integer.class;
            if (col == 12) return Integer.class;
            
            if (col == 13) return Double.class;
            if (col == 14) return Double.class;
            if (col == 15) return Double.class;
            
            if (col == 16) return Integer.class;
            if (col == 17) return Integer.class;
            if (col == 18) return Integer.class;
            if (col == 19) return Integer.class;
            return Object.class;
        }
        
        public void setValueAt(Object aValue, int row, int col)
        {
            fireVectorPreChange();
            if (col == 1) vars.foregroundVectors.get(row).start.x((Double)aValue);
            if (col == 2) vars.foregroundVectors.get(row).start.y((Double)aValue);
            if (col == 3) vars.foregroundVectors.get(row).start.z((Double)aValue);;
            if (col == 4) vars.foregroundVectors.get(row).end.x((Double)aValue);
            if (col == 5) vars.foregroundVectors.get(row).end.y((Double)aValue);
            if (col == 6) vars.foregroundVectors.get(row).end.z((Double)aValue);
//            if (col == 7) vars.foregroundVectors.get(row).end.z((double)aValue);
            if (col == 8) {vars.foregroundVectors.get(row).uid_end_connect = (Integer)aValue; fixRelativeByUID(row, (Integer)aValue);}
            if (col == 9) {vars.foregroundVectors.get(row).uid_start_connect= (Integer)aValue; fixRelativeByUID(row, (Integer)aValue);}
            if (col == 10) vars.foregroundVectors.get(row).order= (Integer)aValue;
            if (col == 11) vars.foregroundVectors.get(row).pattern= (Integer)aValue;
            if (col == 12) vars.foregroundVectors.get(row).setIntensity((Integer)aValue);

            if (col == 13) ;
            if (col == 14) ;
            if (col == 15) ;

            if (col == 16) vars.foregroundVectors.get(row).factor= (Integer)aValue;
            if (col == 17) vars.foregroundVectors.get(row).r= (Integer)aValue;
            if (col == 18) vars.foregroundVectors.get(row).g= (Integer)aValue;
            if (col == 19) vars.foregroundVectors.get(row).b= (Integer)aValue;
            fireVectorPostChange();
            fixRelatives();
            sharedRepaint();
        }
        
        public String getColumnName(int col) 
        {
          return NAMES[col];
        }
    };
    
    public MyTableModel getTableModel()
    {
        return vars.dataModel;
    }
    
    
    public void setDrawArrows(boolean a)
    {
        vars.drawArrows = a;
        sharedRepaint();
    }
    public void setDrawPosition(boolean p)
    {
        vars.drawPositions = p;
        sharedRepaint();
    }
    public void setMovesVisible(boolean m)
    {
        vars.drawMoves = m;
        sharedRepaint();
    }

    public int getHorizontalAxis()
    {
        return horizontalAxis;
    }
    public int getVerticalAxis()
    {
        return verticalAxis;
    }
    // sibblings not supported
    public void setXMain()
    {
        horizontalAxis = HORIZONTAL_AXIS_X;
        verticalAxis = VERTICAL_AXIS_Y;
    }
    // sibblings not supported
    public void setYMain()
    {
        horizontalAxis = HORIZONTAL_AXIS_Y;
        verticalAxis = VERTICAL_AXIS_Z;
    }
    // sibblings not supported
    public void setZMain()
    {
        horizontalAxis = HORIZONTAL_AXIS_Z;
        verticalAxis = VERTICAL_AXIS_X;
    }
    public void setMode(int m)
    {
        vars.workingMode = m;
        if (vars.hightLightVPoint != null)
        {
            vars.hightLightVPoint.highlight = false;
            vars.hightLightVPoint = null;
        }
        unselectAll();
    }
    public void setSharedRepaint(boolean doSharedRepaint)
    {
        vars.shareRepaintEnabled = doSharedRepaint;
        if (doSharedRepaint)
        {
            sharedRepaint();
        }
    }
    // repaint self and all siblings
    public void sharedRepaint()
    {
        if (!vars.shareRepaintEnabled) return;
        for (SingleVectorPanel svp: vars.siblings) 
            svp.updateAndRepaint();
    }
    public GFXVectorList getForegroundVectorList()
    {
        return vars.foregroundVectors;
    }
    public void clearForegroundVectorList()
    {
        vars.foregroundVectors.clear();
        clearSelectedVertice();
        sharedRepaint();
    }
    public void joinAllPointsAtHighlight()
    {
        if(vars.hightLightVPoint== null)
            return;
        
        for (GFXVector v: vars.foregroundVectors.list)
        {
            if (v.start.equals(vars.hightLightVPoint))
                v.start = vars.hightLightVPoint;
            if (v.end.equals(vars.hightLightVPoint))
                v.end = vars.hightLightVPoint;
        }
        fixRelatives();
        
        sharedRepaint();
    }
    
    public void clearVectors()
    {
        vars.foregroundVectors.clear();
        clearSelectedVertice();
        sharedRepaint();
    }
    public void deleteHighlitedVector()
    {
        vars.foregroundVectors.remove(vars.hightLightVector);
        if (vars.hightLightVector.start_connect != null)
        {
            vars.hightLightVector.start_connect.end_connect = null;
            vars.hightLightVector.start_connect.uid_end_connect = -1;
            vars.hightLightVector.start_connect.setRelativ(false);
        }
        if (vars.hightLightVector.end_connect != null)
        {
            vars.hightLightVector.end_connect.start_connect = null;
            vars.hightLightVector.end_connect.uid_start_connect = -1;
            vars.hightLightVector.end_connect.setRelativ(false);
        }
        vars.hightLightVector = null;
        clearSelectedVertice();
        sharedRepaint();
    }
    
    
    public void deleteSelectedVector()
    {
        ArrayList<GFXVector> toDelete = new ArrayList<GFXVector>();
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                if (v.selected) toDelete.add(v);
            }
        }
        for (GFXVector v: toDelete)
        {
            if (v.start_connect != null)
            {
                v.start_connect.end_connect = null;
                v.start_connect.uid_end_connect = -1;
                v.start_connect.setRelativ(false);
            }
            if (v.end_connect != null)
            {
                v.end_connect.start_connect = null;
                v.end_connect.uid_start_connect = -1;
                v.end_connect.setRelativ(false);
            }
            vars.foregroundVectors.remove(v);
        }
        vars.foregroundVectors.remove(vars.hightLightVector);
        vars.hightLightVector = null;
        clearSelectedVertice();
        sharedRepaint();
    }
    public void deleteNotSelectedVector()
    {
        ArrayList<GFXVector> toDelete = new ArrayList<GFXVector>();
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                if (!v.selected) toDelete.add(v);
            }
        }
        for (GFXVector v: toDelete)
        {
            if (v.start_connect != null)
            {
                v.start_connect.end_connect = null;
                v.start_connect.uid_end_connect = -1;
                v.start_connect.setRelativ(false);
            }
            if (v.end_connect != null)
            {
                v.end_connect.start_connect = null;
                v.end_connect.uid_start_connect = -1;
                v.end_connect.setRelativ(false);
            }
            vars.foregroundVectors.remove(v);
        }
        sharedRepaint();
    }
    
    public void addForegroundVectorList(ArrayList<GFXVector> fv)
    {
        for (GFXVector v: fv)
            vars.foregroundVectors.add(v);
        sharedRepaint();
    }
    public void setForegroundVectorList(GFXVectorList fv)
    {
        vars.foregroundVectors.clear();
        clearSelectedVertice();
        addForegroundVectorList(fv.list);
    }
    public void addForegroundVectorList(GFXVectorList fv)
    {
        addForegroundVectorList(fv.list);
    }
    public void addForegroundVector(GFXVector v)
    {
        vars.foregroundVectors.add(v);
        sharedRepaint();
    }    
    public void clearBackgroundVectorList()
    {
        vars.backgroundVectors.clear();
        sharedRepaint();
    }
    public void addBackgroundVectorList(ArrayList<GFXVector> bv)
    {
        for (GFXVector v: bv)
            vars.backgroundVectors.add(v);
        sharedRepaint();
    }    
    public void addBackgroundVectorList(GFXVectorList fv)
    {
        addBackgroundVectorList(fv.list);
    }    
    public void addBackgroundVector(GFXVector v)
    {
        vars.backgroundVectors.add(v);
        sharedRepaint();
    }    
    public void setDrawCross(boolean cd)
    {
        vars.crossDrawn = cd;
        sharedRepaint();
    }
    public void setNoMouseRection(boolean mr)
    {
        vars.noMouseReaction = mr;
        sharedRepaint();
    }
    public boolean isShiftPressedOnClick()
    {
        return vars.shiftPressed;
    }
    
    public int getXOffset()
    {
        if (!usePrivateOffset) return vars.xOffset;
        return xOffset;
    }
    public int getYOffset()
    {
        if (!usePrivateOffset) return vars.yOffset;
        return yOffset;
    }
    public void setOffsets(int x, int y)
    {
        if (!usePrivateOffset)  
        {
            vars.xOffset = x;
            vars.yOffset = y;
            xOffset = x;
            yOffset = y;
            sharedRepaint();
            return;
        }
        xOffset = x;
        yOffset = y;
        repaint();
    }
    public double getScale()
    {
        if (!usePrivateScale) return vars.scale;
        return scale;
    }
    public void setScale(double s)
    {
        if (inSetting>0) return;
        inSetting++;
        vars.isScale = true;
        if (!usePrivateScale)
        {
            scale= (double) s;
            vars.scale = (double) s;
            sharedRepaint();
        }
        else
        {
            scale= (double) s;
            repaint();
        }
        inSetting--;
    }
    public void setGrid(boolean g, int w)
    {
        if (w<=0) w=1;
        vars.displayGrid=g;
        vars.gridWidth = w;
        sharedRepaint();
    }
    
    // in relation to foreground vectors
    public void scaleToFit()
    {
        double max = 0;
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                // reset old highlite
                if (Math.abs(v.start.x())>max) max = Math.abs(v.start.x());
                if (Math.abs(v.start.y())>max) max = Math.abs(v.start.y());
                if (Math.abs(v.start.z())>max) max = Math.abs(v.start.z());
                if (Math.abs(v.end.x())>max) max = Math.abs(v.end.x());
                if (Math.abs(v.end.y())>max) max = Math.abs(v.end.y());
                if (Math.abs(v.end.z())>max) max = Math.abs(v.end.z());
            }
        }
        double dif = max*2;
        if (dif == 0) return;
        double w = this.getWidth(); // assuming height and width is the same
        
        
        double s = w/dif;
        
        
        setScale(s);
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

    public static double  getDistancePointToVector(double x0,double y0, double x1,double y1, double x2,double y2)
    {
        // point is xg0
        // line segment defined by x1y1 and x2,y2
        double lineEndDistance = Math.pow((x1 - x2),2) + Math.pow((y1 - y2),2);
        if (lineEndDistance==0) return Math.pow((x0 - x1),2) + Math.pow((y0 - y1),2);
        double t = ((x0 - x1) * (x2 - x1) + (y0 - y1) * (y2 - y1)) / lineEndDistance;
        if (t < 0) return Math.pow((x0 - x1),2) + Math.pow((y0 - y1),2);
        if (t > 1) return Math.pow((x0 - x2),2) + Math.pow((y0 - y2),2); 
        
        double xt = x1+t*(x2-x1);
        double yt = y1+t*(y2-y1);
        double t2 = Math.pow((x0 - xt),2) + Math.pow((y0 - yt),2); 
        return Math.sqrt(t2);
    }
    
    private void formMouseMoved(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseMoved
        mX=evt.getX();
        mY=evt.getY();
        vars.crossColor = Color.ORANGE;

        
        // check for highliting
        if (vars.workingMode == SVP_SELECT_POINT)
        {
            double distance = Double.MAX_VALUE;
            if (vars.hightLightVPoint != null) 
            {
                vars.hightLightVPoint.highlight = false;
                vars.hightLightVPoint = null;
            }
            
           synchronized (vars.foregroundVectors.list)
           {
                for (GFXVector v: vars.foregroundVectors.list)
                {
                     Vertex p;
                     double x;
                     double y;
                     double d;
                     // reset old highlite
                     v.start.highlight = false;
                     v.end.highlight = false;

                     // all vector coordinates are in vectrex "form"
                     // to compare, we have to translate to view form
                     // start point
                     p = convertFromVectrex(v.start);               
                     x = p.coord()[horizontalAxis];
                     y = p.coord()[verticalAxis];
                     d = Math.sqrt((mX-x)*(mX-x)+(mY-y)*(mY-y));
                     if (d<distance) 
                     {
                         distance = d;
                         vars.hightLightVPoint = v.start;
                     }
                     // end point
                     p = convertFromVectrex(v.end);               
                     x = p.coord()[horizontalAxis];
                     y = p.coord()[verticalAxis];
                     d = Math.sqrt((mX-x)*(mX-x)+(mY-y)*(mY-y));
                     if (d<distance) 
                     {
                         distance = d;
                         vars.hightLightVPoint = v.end;
                     }
                     if (distance==0) break;
                 }
            }
            // distance muss wenigstens in der nähe sein!
            if (vars.hightLightVPoint != null)
            {
                if (distance<=vars.POINT_HIGHLIGHT_RANGE) // arround 5 Pixel
                {

                    vars.hightLightVPoint.highlight = true;
                }
                else
                {
                    vars.hightLightVPoint = null;
                }
            }
                
        }
        if (vars.workingMode == SVP_SELECT_LINE)
        {
            double distance = Double.MAX_VALUE;
            if (vars.hightLightVector != null) 
            {
                vars.hightLightVector.highlight = false;
                vars.hightLightVector = null;
            }
            
            synchronized (vars.foregroundVectors.list)
            {
                for (GFXVector v: vars.foregroundVectors.list)
                {
                    // reset old highlite
                    v.highlight = false;
                    Vertex p1;
                    Vertex p2;
                    double d;

                    double x1;
                    double y1;
                    double x2;
                    double y2;

                    // all vector coordinates are in vectrex "form"
                    // to compare, we have to translate to view form
                    // start point
                    p1 = convertFromVectrex(v.start);               
                    x1 = p1.coord()[horizontalAxis];
                    y1 = p1.coord()[verticalAxis];
                    p2 = convertFromVectrex(v.end);               
                    x2 = p2.coord()[horizontalAxis];
                    y2 = p2.coord()[verticalAxis];

                    // nice, but now that I think of it I need a line SEGMENT, not a line!
                    d = getDistancePointToVector((double)mX, (double)mY, x1,y1,x2,y2);
                    if (d<distance) 
                    {
                        distance = d;
                        vars.hightLightVector = v;
                    }
                    if (distance==0) break;
                }
            }
            // distance must be NEAR (in range)
            if (vars.hightLightVector != null)
            {
                if (distance<=vars.VECTOR_HIGHLIGHT_RANGE) // arround 5 Pixel
                {

                    vars.hightLightVector.highlight = true;
                }
                else
                {
                    vars.hightLightVector = null;
                }
            }
        }        
        
        sharedRepaint();
        fireMouseMoved(evt);
    }//GEN-LAST:event_formMouseMoved

    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
        if (vars.noMouseReaction) return;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            if (vars.continueMode)
            {
                // if in continues mode
                // mouse press should not
                // update any mouse coordinates
                // since the continue vector is drawn
                // with "last" mXPressStart
                vars.pressed = true;
                return;
            }
            vars.shiftPressed = false;
            vars.pressed = true;
            mXPressStart = evt.getX();
            mYPressStart = evt.getY();

            // ensure the cross!
            mXPressStart = lastCrossX;
            mYPressStart = lastCrossY;

            mDragOriginX = lastCrossX;
            mDragOriginY = lastCrossY;
            
            vars.shiftPressed = KeyboardListener.isShiftDown();
        }
        
                
        
        
        fireMousePressed(evt);
        vars.crossColor = vars.CROSS_DRAG_COLOR;
        sharedRepaint();
    }//GEN-LAST:event_formMousePressed

    private void formMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseReleased
        if (vars.noMouseReaction) return;
        mXRelease = lastCrossX;
        mYRelease = lastCrossY;
        vars.shiftPressed = KeyboardListener.isShiftDown();
        fireMouseReleased(evt);
        vars.pressed = false;
        vars.dragging = false;
        vars.selecting = true;
        vars.crossColor = Color.ORANGE;
        for (SingleVectorPanel svp: vars.siblings) svp.repaint();
    }//GEN-LAST:event_formMouseReleased

    private void formMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseExited
        if (vars.noMouseReaction) return;
        vars.pressed = false;
        noCross = true;
        mouseExited = true;
        fireMouseMoved(evt);
        mouseExited = false;
        sharedRepaint();
    }//GEN-LAST:event_formMouseExited

    public boolean isDragging()
    {
        return vars.pressed && vars.dragging;
    }
    
    // info: while dragging, mouse move is not called!
    private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged

        if (vars.noMouseReaction) return;
        mX=evt.getX();
        mY=evt.getY();

        // when vector for continuing is drawn, do't DRAG
        if (!vars.continueMode)
        {
            if (vars.pressed)  // than "dragged" by non MouseButton1
                vars.dragging = true;
            vars.crossColor = Color.GREEN;
        }
        
        if (vars.displayDragSelection) 
        {
            if ((vars.workingMode == SVP_SELECT_POINT) ||  (vars.workingMode == SVP_SELECT_LINE))
            {
                if ((vars.dragging) ||  (vars.pressed) )
                {
                    int x =  mXPressStart; 
                    int y =  mYPressStart; 
                    int w =  mX-mXPressStart; 
                    int h =  mY-mYPressStart; 

                    
                    if (mX<mXPressStart)
                    {
                        x = mX;
                        w =  mXPressStart-mX; 
                    }
                    if (mY<mYPressStart)
                    {
                        y = mY;
                        h =  mYPressStart-mY; 
                    }
                    selectAllInArea(x,y,w,h);
                }
            }
        }
        
        sharedRepaint();
        if (vars.pressed)  // than "dragged" by non MouseButton1
            fireMouseMoved(evt);
    }//GEN-LAST:event_formMouseDragged

    private void formMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseEntered
        if (vars.noMouseReaction) return;
        if (evt.getButton() == MouseEvent.BUTTON1)
            vars.pressed = true;
        noCross = false;
        sharedRepaint();
    }//GEN-LAST:event_formMouseEntered

    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
        x0Offset = getWidth()/2;
        y0Offset = getHeight()/2;
        repaint();
    }//GEN-LAST:event_formComponentResized
    // 0,0 is in center of screen
    // all coordinates are relative to 0,0
    // not scaled on entry!
    // start and endpoints are also drawn!
    // entry coordinate range from -150 to + 150
    int old_x1 = Integer.MAX_VALUE;
    int old_y1 = Integer.MAX_VALUE;
    

    final void drawVectrexScaledLine(Graphics g,int x0, int y0, int x1, int y1, boolean bigEnd, Stroke stroke, boolean drawArrows, boolean drawPositions, int pos, GFXVector v)
    {
        int x_0;
        int x_1;
        int y_0;
        int y_1;
        
        int usedxOff = usePrivateOffset?xOffset:vars.xOffset;
        int usedyOff = usePrivateOffset?yOffset:vars.yOffset;

        // offset is in vectrex coords
        x0 += usedxOff;
        x1 += usedxOff;
        y0 += usedyOff;
        y1 += usedyOff;
        
        
        if (vars.isScale)
        {
            double scaleUse = usePrivateScale?scale:vars.scale;
            x_0 = x0Offset+Scaler.scaleDoubleToInt(x0, scaleUse);
            x_1 = x0Offset+Scaler.scaleDoubleToInt(x1, scaleUse);
            y_0 = y0Offset+Scaler.scaleDoubleToInt(y0, scaleUse);
            y_1 = y0Offset+Scaler.scaleDoubleToInt(y1, scaleUse);
        }
        else
        {
            x_0 = x0Offset+x0;
            x_1 = x0Offset+x1;
            y_0 = y0Offset+y0;
            y_1 = y0Offset+y1;
        }
        
        if (!vars.realyBigEnd)
        {
            // cut end point
            // otherwise vectors may overlap and display a bright spot at the end
            if ((old_x1 == (int)x_0) && ( old_y1 == (int)y_0))
            {
                int SHORTEN = vars.vectorWidth;
                double dx = x_1 - x_0;
                double dy = y_1 - y_0;
                double length = Math.sqrt(dx * dx + dy * dy);
                if (length <= vars.vectorWidth) return;
                if (length > 0)
                {
                    dx /= length;
                    dy /= length;
                }
                dx *= length - SHORTEN;
                dy *= length - SHORTEN;

                // shortened by tw2
                x_0 = (int)(x_1 - dx);
                y_0 = (int)(y_1 - dy);
            }
        }
        old_x1 = (int)x_1;
        old_y1 = (int)y_1;
        
        
        if (stroke!=null)
        {
            Graphics2D g2 = (Graphics2D) g;
            Stroke saveStroke = g2.getStroke();
            g2.setStroke(stroke);
            if (drawArrows)
            {
                drawArrow(g2, x_0,  y_0,  x_1,  y_1);        
            }
            else
            {
                g.drawLine(x_0,  y_0,  x_1,  y_1);
            }
            g2.setStroke(saveStroke);
        }
        else
        {
            if (drawArrows)
            {
                drawArrow(g, x_0,  y_0,  x_1,  y_1);        
            }
            else
            {
                g.drawLine(x_0,  y_0,  x_1,  y_1);
            }
        }
        if (drawPositions)
        {
            
            g.setColor(vars.POS_COLOR);
            int xx = x_0 + (x_1-x_0)/2;
            int yy = y_0 + (y_1-y_0)/2;
            g.drawString(""+pos, xx,  yy);
        }
        if ((bigEnd) && (vars.realyBigEnd))
        {
            // draw "big" start and endpoints
            Color cstart =vars.VECTOR_ENDPOINT_COLOR;
            Color cend =vars.VECTOR_ENDPOINT_COLOR;
            if (v != null)
            {
                if (v.start_connect != null)
                {
                    cstart =vars.POINT_JOINED_COLOR;
                }
                if (v.end_connect != null)
                {
                    cend =vars.POINT_JOINED_COLOR;
                }
                
            }
            g.setColor(cstart);
            g.fillRect(x_0-1, y_0-1, 3, 3);
            g.setColor(cend);
            g.fillRect(x_1-1, y_1-1, 3, 3);
        }
    }
    
    // assumes coordinates as provided by a 
    // mouse event in relation to this panel in "p"
    public Vertex convertToVectrex(Vertex p)
    {
        double scaleUse = usePrivateScale?scale:vars.scale;
        Vertex np = new Vertex();

        np.coord()[horizontalAxis] = p.coords[horizontalAxis] - x0Offset;
        np.coord()[verticalAxis] = y0Offset - p.coords[verticalAxis];

        np.coord()[horizontalAxis] = Scaler.unscaleDoubleToDouble(np.coord()[horizontalAxis], scaleUse);
        np.coord()[verticalAxis] = Scaler.unscaleDoubleToDouble(np.coord()[verticalAxis], scaleUse);
        
        int usedxOff = usePrivateOffset?xOffset:vars.xOffset;
        int usedyOff = usePrivateOffset?yOffset:vars.yOffset;

        np.coord()[horizontalAxis] -= usedxOff;
        np.coord()[verticalAxis] += usedyOff;
        
        
        return np;
    }
    
    // assumes coordinates as provided by a vectrex list, (as set previously by this panel) 
    // return coordinates like a "mouse" on this panel!
    // 
    public Vertex convertFromVectrex(Vertex p)
    {
        double scaleUse = usePrivateScale?scale:vars.scale;
        Vertex np = new Vertex();
        
        int usedxOff = usePrivateOffset?xOffset:vars.xOffset;
        int usedyOff = usePrivateOffset?yOffset:vars.yOffset;
        
        np.coord()[horizontalAxis] = Scaler.scaleDoubleToInt(p.coord()[horizontalAxis]+usedxOff, scaleUse);
        np.coord()[verticalAxis] = Scaler.scaleDoubleToInt(p.coord()[verticalAxis]-usedyOff, scaleUse);

        np.coord()[horizontalAxis] = np.coords[horizontalAxis] + x0Offset;
        np.coord()[verticalAxis] = -np.coords[verticalAxis] + y0Offset;
        return np;
    }
    public double convertFromVectrexX(int x)
    {
        double scaleUse = usePrivateScale?scale:vars.scale;
        double newX = 0;
        newX = Scaler.scaleDoubleToInt(x, scaleUse);

        return newX;
    }
    public double convertFromVectrexY(int y)
    {
        double scaleUse = usePrivateScale?scale:vars.scale;
        double newY = 0;
        newY = Scaler.scaleDoubleToInt(y, scaleUse);

        return newY;
    }

    
    float[] getPattern(GFXVector v)
    {
        ArrayList<Float> pattern = new ArrayList<Float>();
        boolean visible = false;
        float current=0;
        if ((v.pattern & 1) == 1)
        {
            current +=1;
            visible = true;
        }
        else
        {
            current +=1;
            pattern.add(0F);
            visible = false;
        }
        
        int t = 2;
        while (t<=128)
        {
            if ((v.pattern & t) == t)
            {
                if (!visible)
                {
                    pattern.add(current);
                    current=1;
                    visible = true;
                }
                else
                {
                    current++;
                }
            }
            else
            {
                if (visible)
                {
                    pattern.add(current);
                    current=1;
                    visible = false;
                }
                else
                {
                    current++;
                }

            }
            t = t*2;
        }
        pattern.add(current);
        float[] ret = new float[pattern.size()];
        int i=0;
        for(Float f: pattern)
        {
            ret[i++] = f;
        }
        return ret;
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
    public void setByteFrame(boolean b)
    {
        vars.drawByteFrame = b;
        sharedRepaint();
    }
    
    @Override public void paintComponent(Graphics g)
    {
        doPaint((Graphics2D)g);
/*
        super.paintComponent(g);
        if (bufferUsed == -1)
        {
            updateAndRepaint();
            if (bufferUsed == -1)
            {
                return;
            }
        }
        
        g.drawImage(paintBufferImage[bufferUsed], 0, 0, null);
        */
    }


    public void setSelection(int x, int y, int w, int h)
    {
        repaint();
    }

    public void removeAllListeners()
    {
        vars.mMovedListener.clear();
        vars.mPressedListener.clear();
        vars.mReleasedListener.clear();
    }
    public void addMousePressedListener(MousePressedListener listener)
    {
        vars.mPressedListener.removeElement(listener);
        vars.mPressedListener.addElement(listener);
    }
    public void removeMousePressedListener(MousePressedListener listener)
    {
        vars.mPressedListener.removeElement(listener);
    }
    public void addMouseReleasedListener(MouseReleasedListener listener)
    {
        vars.mReleasedListener.removeElement(listener);
        vars.mReleasedListener.addElement(listener);
    }
    public void removeMouseReleasedListener(MouseReleasedListener listener)
    {
        vars.mReleasedListener.removeElement(listener);
    }
    public void addMouseMovedListener(MouseMovedListener listener)
    {
        vars.mMovedListener.removeElement(listener);
        vars.mMovedListener.addElement(listener);
    }
    public void removeMouseMovedListener(MouseMovedListener listener)
    {
        vars.mMovedListener.removeElement(listener);
    }
    
    public void addVectorChangeListener(VectorChangedListener listener)
    {
        vars.mVectorListener.removeElement(listener);
        vars.mVectorListener.addElement(listener);
    }
    public void removeVectorChangeListener(VectorChangedListener listener)
    {
        vars.mVectorListener.removeElement(listener);
    }
    public void fireVectorPreChange()
    {
        for (int i=0; i<vars.mVectorListener.size(); i++)
        {
            vars.mVectorListener.elementAt(i).preVectorChange();;
        }
    }
    public void fireVectorPostChange()
    {
        for (int i=0; i<vars.mVectorListener.size(); i++)
        {
            vars.mVectorListener.elementAt(i).postVectorChange();;
        }
    }
    
    public void fireMouseMoved(MouseEvent evt)
    {
        EditMouseEvent e = new EditMouseEvent();
        e.evt = evt;
        e.panel = this;
        e.mouseExited = mouseExited;
        e.dragging = vars.dragging;
        
        vars.pressed = true;
        if (vars.dragging)
        {
            e.dragOriginX = mDragOriginX;
            e.dragOriginY = mDragOriginY;
            e.dragNowX = lastCrossX;
            e.dragNowY = lastCrossY;
            mDragOriginX= lastCrossX;
            mDragOriginY = lastCrossY;
        }

        if ((!vars.dragging) && ( !vars.continueMode ))
        {
            mXPressStart = evt.getX();
            mYPressStart = evt.getY();

            // ensure the cross!
            mXPressStart = lastCrossX;
            mYPressStart = lastCrossY;
        }
        
        e.translocationInVectrexPoint = getDragTranslocation(e.dragOriginX, e.dragOriginY, e.dragNowX, e.dragNowY);

        e.currentVectrexPoint =  convertToVectrex(getCurrentPoint());
        
        e.highlightedPoint = vars.hightLightVPoint;
        e.highlightedVector = vars.hightLightVector;
        for (int i=0; i<vars.mMovedListener.size(); i++)
        {
            vars.mMovedListener.elementAt(i).moved(e);
        }
    }
    
    // input are like two mouse coordinates (cross)
    // the points are converted to Vertex points
    // and the differnce is given back
    private Vertex getDragTranslocation(int x0, int y0, int x1, int y1)
    {
        Vertex p1 = new Vertex();
        p1.coord()[horizontalAxis] = x0;
        p1.coord()[verticalAxis] = y0;

        Vertex p2 = new Vertex();
        p2.coord()[horizontalAxis] = x1;
        p2.coord()[verticalAxis] = y1;
        
        p1 = convertToVectrex( p1);
        p2 = convertToVectrex( p2);
        
        Vertex p3 = new Vertex();
        
        p3.coord()[horizontalAxis] = p1.coord()[horizontalAxis] - p2.coord()[horizontalAxis];
        p3.coord()[verticalAxis] = p1.coord()[verticalAxis] - p2.coord()[verticalAxis];
        return p3;
    }
    
    
    public void fireMousePressed(MouseEvent evt)
    {
        EditMouseEvent e = new EditMouseEvent();
        e.evt = evt;
        e.panel = this;
        e.shiftPressed = vars.shiftPressed;
        e.lastClickedVectrexPoint = convertToVectrex(getLastClickPoint());
        for (int i=0; i<vars.mPressedListener.size(); i++)
        {
            vars.mPressedListener.elementAt(i).pressed(e);
        }
    }
    public void fireMouseReleased(MouseEvent evt)
    {
        if (!vars.pressed) return;
        EditMouseEvent e = new EditMouseEvent();
        e.evt = evt;
        e.shiftPressed = vars.shiftPressed;
        e.panel = this;
        for (int i=0; i<vars.mReleasedListener.size(); i++)
        {
            vars.mReleasedListener.elementAt(i).released(e);
        }
    }
    public void unsetImage()
    {
        vars.scale = 1.0;
        scale= (double) 1.0;
        inSetting = 0;
        vars.crossColor = Color.ORANGE;
        mX=0;
        mY=0;
        mXPressStart = 0;
        mYPressStart = 0;
        vars.pressed = false;
        noCross = true;
        vars.dragging = false;
        vars.gridWidth = 10;
        vars.displayGrid=false;
        vars.noMouseReaction = false;
        vars.foregroundVectors.clear();
        vars.backgroundVectors.clear();
        sharedRepaint();
    }
    
    public Vertex getHighlightedVPoint()
    {
        return vars.hightLightVPoint;
    }
    public void setHighlightedVPoint(Vertex h)
    {
        vars.hightLightVPoint = h;
        vars.hightLightVPoint.highlight = true;
        sharedRepaint();
    }
    public boolean setHighlightedToSelectedVPoint()
    {
        unselectAll();
        if (vars.hightLightVPoint != null)
        {
            vars.hightLightVPoint.selected = true;
            sharedRepaint();
            vars.selecting = false;
            clearSelectedVertice();
            addVertexSelection(vars.hightLightVPoint);
           return true;
        }
        vars.selecting = true;
        sharedRepaint();
        return false;
    }
    // 
    public boolean addHighlightedToSelectedVPoint()
    {
        if (vars.hightLightVPoint != null)
        {
            vars.hightLightVPoint.selected = true;
            sharedRepaint();
            addVertexSelection(vars.hightLightVPoint);
            vars.selecting = false;
            return true;
        }
        vars.selecting = true;
        sharedRepaint();
        return false;
    }
    public boolean setToSelectedVPoint(Vertex point)
    {
        unselectAll();
        point.selected = true;
        vars.selecting = true;
        clearSelectedVertice();
        addVertexSelection(point);
        sharedRepaint();
        return false;
    }
    
    //
    public boolean addToSelectedVPoint(Vertex point)
    {
        point.selected = true;
        vars.selecting = true;
        addVertexSelection(point);
        sharedRepaint();
        return false;
    }
    public boolean removeToSelectedVPoint(Vertex point)
    {
        point.selected = false;
        vars.selecting = true;
        sharedRepaint();
        removeVertexSelection(point);
        return false;
    }
    
    // 
    public boolean removeHighlightedToSelectedVPoint()
    {
        if (vars.hightLightVPoint != null)
        {
            vars.hightLightVPoint.selected = false;
            removeVertexSelection(vars.hightLightVPoint);
        }
        sharedRepaint();
        return true;
    }
    
    public boolean setHighlightedToSelectedVector()
    {
        unselectAllVectors();
        if (vars.hightLightVector != null)
        {
            vars.hightLightVector.selected = true;
            sharedRepaint();
            vars.selecting = false;
           return true;
        }
        vars.selecting = true;
        sharedRepaint();
        return false;
    }
    public GFXVector getHighlightedVector()
    {
        return vars.hightLightVector;
    }
    
    public boolean addHighlightedToSelectedVector()
    {
        if (vars.hightLightVector != null)
        {
            vars.hightLightVector.selected = true;
            sharedRepaint();
            vars.selecting = false;
            return true;
        }
        vars.selecting = true;
        sharedRepaint();
        return false;
    }
    public void removeHighlightedToSelectedVector()
    {
        if (vars.hightLightVector != null)
        {
            vars.hightLightVector.selected = false;
        }
        sharedRepaint();
    }
    
    // where was the mouse last pressed
    // actually this does not return the last MOUSE
    // positon, but rather the last cross hair position!
    // this is "better", meaning more userfriendly,
    // since the user expects the corss hair posiition
    // the position is set in the original mouse event!
    public Vertex getLastClickPoint()
    {
        Vertex vp = new Vertex();

        vp.coord()[horizontalAxis] = mXPressStart;
        vp.coord()[verticalAxis] = mYPressStart;
        return vp;
    }
    
    
    // Where was the last cross painted
    // must not be EXACTLY the current mouse pointer position!
    public Vertex getCurrentPoint()
    {
        Vertex vp = new Vertex();

        vp.coord()[horizontalAxis] = lastCrossX;
        vp.coord()[verticalAxis] = lastCrossY;
        return vp;
    }
    // get the coordinates, the mouse was release last
    public Vertex getLastReleasePoint()
    {
        Vertex vp = new Vertex();

        vp.coord()[horizontalAxis] = mXRelease;
        vp.coord()[verticalAxis] = mYRelease;
        return vp;
    }
    
            
    // set a vector that will be continnued from
    // meaning, the yellow line will
    // be drawn with a starting point originating
    // from the start vector given here!
    public void continueVector(GFXVector old)
    {
        if (old==null)
        {
            vars.continueMode = false;
            mXPressStart = lastCrossX;
            mYPressStart = lastCrossY;
            return;
        }
        vars.continueMode = true;
        vars.continueStart = new Vertex(old.end);

        for (SingleVectorPanel svp: vars.siblings) 
        {
            Vertex p = svp.convertFromVectrex(vars.continueStart);
            svp.mXPressStart = (int) p.coord()[svp.horizontalAxis];
            svp.mYPressStart = (int) p.coord()[svp.verticalAxis];
        }
    }

    public ArrayList<GFXVector> getSelectedPointVectors()
    {
        ArrayList<GFXVector> vec = new ArrayList<GFXVector>();
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                if (v.start.selected) 
                {
                    vec.add(v);
                    continue;
                }
                if (v.end.selected) 
                {
                    vec.add(v);
                    continue;
                }
            }
        }
        
        return vec;
    }
    private void unselectAll()
    {
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                v.start.selected = false;
                v.end.selected = false;
                v.selected = false;
            }
            clearSelectedVertice();
        }
        sharedRepaint();
    }
    
    private void unselectAllVectors()
    {
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                v.selected = false;
            }
        }
        sharedRepaint();
    }
    public ArrayList<GFXVector> getSelectedVectors()
    {
        ArrayList<GFXVector> ret = new ArrayList<GFXVector>();
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                if (v.selected) ret.add(v);
            }
        }        
        return ret;
    }
    public GFXVectorList getSelectedVectorList()
    {
        // copy only selected
        // 1. copy all
        GFXVectorList ret = getForegroundVectorList().clone();
        
        // remove non selected!
        ArrayList<GFXVector> toRemove = new ArrayList<GFXVector>();
        
        // that way all relations are kept intact!
        for (int i=0; i<ret.size(); i++)
        {
            if (!ret.get(i).selected)
                toRemove.add(ret.get(i));
        }
        for (GFXVector v: toRemove)
            ret.remove(v);
        return ret;
    }
    
    
    private void fixRelativeByUID(int row, int uid)
    {
        GFXVector vector = vars.foregroundVectors.get(row);
        GFXVector other = null;
        for (int i=0; i< vars.foregroundVectors.size(); i++)
        {
            if (vars.foregroundVectors.get(i).uid == uid)
            {
                other = vars.foregroundVectors.get(i);
                break;
            }
        }
        if (other == null)
        {
            // error uid not known
            System.out.println("UID of other vector not known - cannot connect!");
            return;
        }
        if (vector.uid_start_connect == uid)
        {
            vector.start_connect = other;
        }
        else if (vector.uid_end_connect == uid)
        {
            vector.end_connect = other;
        }
        // if other vector has "free" connections, we also reverse the tie!
        if (other.uid_start_connect == -1)
        {
            other.uid_start_connect = vector.uid;
            other.start_connect = vector;
        }
        else if (other.uid_end_connect == -1)
        {
            other.uid_end_connect = vector.uid;
            other.end_connect = vector;
        }
        // shared repaint is done by table model
        // if this function is used elsewhere, a repaint must be initiated from there...
    }

    private void fixRelatives()
    {
        int i;
        int j;
        
        for (i=0; i< vars.foregroundVectors.size(); i++)
        {
            Vertex start = vars.foregroundVectors.get(i).start;
            Vertex end = vars.foregroundVectors.get(i).end;
            boolean foundStart = false;
            boolean foundEnd = false;
            vars.foregroundVectors.get(i).start_connect = null;
            vars.foregroundVectors.get(i).uid_start_connect = -1;
            vars.foregroundVectors.get(i).end_connect = null;
            vars.foregroundVectors.get(i).uid_end_connect = -1;
            for (j=0; j< vars.foregroundVectors.size(); j++)
            {
                if (j==i) continue;
                if (start.uid == vars.foregroundVectors.get(j).start.uid) // point uids
                {
                    vars.foregroundVectors.get(i).start_connect = vars.foregroundVectors.get(j); // vector uids
                    vars.foregroundVectors.get(i).uid_start_connect = vars.foregroundVectors.get(j).uid;
                    foundStart = true;
                }
                if (start.uid == vars.foregroundVectors.get(j).end.uid) // point uids
                {
                    vars.foregroundVectors.get(i).start_connect = vars.foregroundVectors.get(j); // vector uids
                    vars.foregroundVectors.get(i).uid_start_connect = vars.foregroundVectors.get(j).uid;
                    foundStart = true;
                }

                
                if (end.uid == vars.foregroundVectors.get(j).start.uid) // point uids
                {
                    vars.foregroundVectors.get(i).end_connect = vars.foregroundVectors.get(j);
                    vars.foregroundVectors.get(i).uid_end_connect = vars.foregroundVectors.get(j).uid;
                    foundEnd = true;
                }
                if (end.uid == vars.foregroundVectors.get(j).end.uid) // point uids
                {
                    vars.foregroundVectors.get(i).end_connect = vars.foregroundVectors.get(j);
                    vars.foregroundVectors.get(i).uid_end_connect = vars.foregroundVectors.get(j).uid;
                    foundEnd = true;
                }
            }
            if ((foundStart) && (foundEnd))
            {
                vars.foregroundVectors.get(i).setRelativ(true);
            }
            else
            {
                vars.foregroundVectors.get(i).setRelativ(false);
            }
        }
    }

    // if true, selecting via drag is possible
    // if false not
    // if a point/vector is selected, than no "drag" selection should be possible
    // if we are drag, selecting, vectors and points must not move at the same time!
    public boolean isSelecting()
    {
        return vars.selecting;
    }
    // coords in "mouse"
    void selectAllInArea(int x, int y, int w, int h)
    {
        if (!vars.selecting) return;
        
        Vertex startOrg = new Vertex();
        Vertex endOrg = new Vertex();
        startOrg.coord()[horizontalAxis] = x;
        startOrg.coord()[verticalAxis] = y;
        endOrg.coord()[horizontalAxis] = x+w;
        endOrg.coord()[verticalAxis] = y+h;
        
        Vertex startVec = convertToVectrex(startOrg);
        Vertex endVec = convertToVectrex(endOrg);
        
        double minX = startVec.coord()[horizontalAxis];
        double maxX = endVec.coord()[horizontalAxis];
        double maxY = startVec.coord()[verticalAxis]; // vectrex coordinates in Y switch min Max!
        double minY = endVec.coord()[verticalAxis];
        
        clearSelectedVertice();

        if (vars.workingMode == SVP_SELECT_POINT)
        {
            synchronized (vars.foregroundVectors.list)
            {
                for (GFXVector v :vars.foregroundVectors.list)
                {
                    if (((v.start.coord()[horizontalAxis]> minX) && (v.start.coord()[horizontalAxis]< maxX) ) && 
                         (v.start.coord()[verticalAxis]> minY) && (v.start.coord()[verticalAxis]< maxY) ) 
                    {
                        v.start.selected=true;
                        addVertexSelection(v.start);
                    }
                    else
                    {
                        v.start.selected=false;
                    }
                    if (((v.end.coord()[horizontalAxis]> minX) && (v.end.coord()[horizontalAxis]< maxX) ) && 
                         (v.end.coord()[verticalAxis]> minY) && (v.end.coord()[verticalAxis]< maxY) ) 
                    {
                        v.end.selected=true;
                        addVertexSelection(v.end);
                    }
                    else
                    {
                        v.end.selected=false;
                    }
                }
            }
        }   
        if (vars.workingMode == SVP_SELECT_LINE)
        {
            synchronized (vars.foregroundVectors.list)
            {
                for (GFXVector v :vars.foregroundVectors.list)
                {
                    boolean in = true;
                    if (((v.start.coord()[horizontalAxis]> minX) && (v.start.coord()[horizontalAxis]< maxX) ) && 
                         (v.start.coord()[verticalAxis]> minY) && (v.start.coord()[verticalAxis]< maxY) ) 
                    {
                        in=true;
                    }
                    else
                    {
                        in=false;
                    }
                    if (((v.end.coord()[horizontalAxis]> minX) && (v.end.coord()[horizontalAxis]< maxX) ) && 
                         (v.end.coord()[verticalAxis]> minY) && (v.end.coord()[verticalAxis]< maxY) ) 
                    {
                        in= in & true;
                    }
                    else
                    {
                        in=false;
                    }
                    v.selected = in;
                }
            }
        }
    }
    
    public void addYOffset(int v)    
    {
        if (usePrivateOffset)
        {
            yOffset+=v;
            repaint();
            return;
        }
        yOffset+=v;
        vars.yOffset+=v;
        sharedRepaint();
    }
    public void addXOffset(int v)    
    {
        if (usePrivateOffset)
        {
            xOffset+=v;
            repaint();
            return;
        }
        xOffset+=v;
        vars.xOffset+=v;
        sharedRepaint();
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables

    BufferedImage[] paintBufferImage = new BufferedImage[2];
    int bufferUsed = -1;
    
    // somehow - this does not work as expected...
    void updateAndRepaint()
    {
        int width = getWidth();
        int height = getHeight();
        
        int nextBuffer = (bufferUsed +1)%2;
        paintBufferImage[nextBuffer] = de.malban.util.UtilityImage.getNewImage(width, height);

        if ( paintBufferImage[nextBuffer] == null) return;
        
        Graphics2D g = paintBufferImage[nextBuffer].createGraphics();
        doPaint(g);
        bufferUsed = nextBuffer;
        repaint();
    }
    
    private void doPaint(Graphics2D g)
    {
        int usedxOff = usePrivateOffset?xOffset:vars.xOffset;
        int usedyOff = usePrivateOffset?yOffset:vars.yOffset;
        
        // save original color
        Color c = g.getColor();

        // clear to background!
        {
            g.setColor(vars.BACKGROUND_COLOR);
            g.fillRect(0, 0, getWidth(), getHeight());
        }
        
        if ((vars.workingMode == SVP_SELECT_POINT) ||  (vars.workingMode == SVP_SELECT_LINE))
        {
            if ((vars.displayDragSelection) && (vars.selecting))
            {
                if ((vars.dragging) ||  (vars.pressed) )
                {
                    Color dragArea = new Color(0,200,0,50);
                    g.setColor(dragArea);

                    
                    int x =  mXPressStart; 
                    int y =  mYPressStart; 
                    int w =  mX-mXPressStart; 
                    int h =  mY-mYPressStart; 

                    
                    if (mX<mXPressStart)
                    {
                        x = mX;
                        w =  mXPressStart-mX; 
                    }
                    if (mY<mYPressStart)
                    {
                        y = mY;
                        h =  mYPressStart-mY; 
                    }

                    g.fillRect(x, y, w, h);
                    selWidth = (int)(w);
                    selHeight = (int)(h);
                }
                else
                {
                    selWidth = 0;
                    selHeight = 0;
                }
            }
        }
        int potentialCrossX = 10000000;
        int potentialCrossY = 10000000;

        
        // draw the grid
        g.setColor(vars.GRID_COLOR);
        double scaleUse = usePrivateScale?scale:vars.scale;
        int xg0 = Scaler.unscaleDoubleToInt((x0Offset), scaleUse)-usedxOff;
        int xg1 = Scaler.unscaleDoubleToInt(-(x0Offset), scaleUse)-usedxOff;
        int yg0 = Scaler.unscaleDoubleToInt((y0Offset), scaleUse)-usedyOff;
        int yg1 = Scaler.unscaleDoubleToInt(-(y0Offset), scaleUse)-usedyOff;

        // befor vectors, so we can check against cross variables
        if (vars.displayGrid)
        {
            int counter = 0;
            int GRID_NOW = vars.gridWidth;
            
            // if gridlines would be displayed more than half of the time -> do not display it at all!
            do
            {
                int yPositive = y0Offset+Scaler.scaleDoubleToInt((+(counter*GRID_NOW))+usedyOff, scaleUse);
                if (Math.abs(yPositive - mY) < Math.abs(potentialCrossY)) 
                    potentialCrossY = yPositive- mY;
                counter++;
            } while (y0Offset + Scaler.scaleDoubleToInt((counter*GRID_NOW)+usedyOff, scaleUse)<getHeight());
            counter *=2; // above was only half grid width

            if (counter<getHeight()/2)
            {
                counter = 0;
                do
                {
                    int yPositive = y0Offset+Scaler.scaleDoubleToInt((+(counter*GRID_NOW))+usedyOff, scaleUse);

                    if (Math.abs(yPositive - mY) < Math.abs(potentialCrossY)) potentialCrossY = yPositive- mY;
                    // horizontal line
                    // y+
                    drawVectrexScaledLine(g,xg0, +(counter*GRID_NOW), xg1, +(counter*GRID_NOW), false, null, false, false, 0, null);
                    counter++;
                } while (y0Offset + Scaler.scaleDoubleToInt((counter*GRID_NOW)+usedyOff, scaleUse)<getHeight());
                counter = 0;
                do
                {
                    int yNegative = y0Offset - Scaler.scaleDoubleToInt((counter*GRID_NOW)-usedyOff, scaleUse);

                    if (Math.abs(yNegative - mY) < Math.abs(potentialCrossY)) potentialCrossY = yNegative- mY;
                    // horizontal line
                    // y-
                    drawVectrexScaledLine(g,xg0, -(counter*GRID_NOW), xg1, -(counter*GRID_NOW), false, null, false, false, 0, null);

                    counter++;
                } while (y0Offset - Scaler.scaleDoubleToInt((counter*GRID_NOW)-usedyOff, scaleUse)>0);

                counter = 0;
                do
                {
                    int xPositive = x0Offset + Scaler.scaleDoubleToInt((counter*GRID_NOW)+usedxOff, scaleUse);

                    if (Math.abs(xPositive - mX) < Math.abs(potentialCrossX)) potentialCrossX = xPositive- mX;
                    // vertical line
                    // x+
                    drawVectrexScaledLine(g,+(counter*GRID_NOW), yg0, +(counter*GRID_NOW), yg1, false, null, false, false, 0, null);

                    counter++;
                } while (x0Offset + Scaler.scaleDoubleToInt((counter*GRID_NOW)+usedxOff, scaleUse)<getWidth());            
                counter = 0;
                do
                {
                    int xNegative = x0Offset - Scaler.scaleDoubleToInt((counter*GRID_NOW)-usedxOff, scaleUse);

                    if (Math.abs(xNegative - mX) < Math.abs(potentialCrossX)) potentialCrossX = xNegative- mX;
                    // vertical line
                    // x-
                    drawVectrexScaledLine(g,-(counter*GRID_NOW), yg0, -(counter*GRID_NOW), yg1, false, null, false, false, 0, null);

                    counter++;
                } while (x0Offset - Scaler.scaleDoubleToInt((counter*GRID_NOW)-usedxOff, scaleUse)>0);            
            }
        }
        // Grid done
        
        if (vars.drawByteFrame)
        {
            g.setColor(vars.FRAME_COLOR);
            int x0 = -128;
            int x1 = 127;
            int y0 = -128;
            int y1 = 127;
            drawVectrexScaledLine(g,x0, y0, x1, y0, false, null, false, false, 0, null);
            drawVectrexScaledLine(g,x0, y0, x0, y1, false, null, false, false, 0, null);
            drawVectrexScaledLine(g,x1, y0, x1, y1, false, null, false, false, 0, null);
            drawVectrexScaledLine(g,x0, y1, x1, y1, false, null, false, false, 0, null);
        }

        potentialCrossX+=mX;
        potentialCrossY+=mY;
        
        // vectrex 0,0 is in the center
        for (GFXVector v: vars.backgroundVectors.list)
        {
            // todo - not done yet
        }

        synchronized (vars.foregroundVectors.list)
        {
            int pos = 0;
            for (GFXVector v: vars.foregroundVectors.list)
            {
                double x0,x1,y0,y1;
                // vectrex y coordinate has opposite "direction"

                x0=v.start.coord()[horizontalAxis];
                y0=(v.start.coord()[verticalAxis]*-1);
                x1=v.end.coord()[horizontalAxis];
                y1=(v.end.coord()[verticalAxis]*-1);

                g.setColor(new Color(v.r, v.g, v.b, v.a));
                if (v.pattern != 255)
                {
                    if ((v.pattern != 0) || (!vars.drawMoves))
                    {
                        if (v.pattern == 0)
                        {
                            g.setColor(vars.MOVE_COLOR);
                        }
                        float[] pattern = getPattern(v);
                        
                        Stroke dashed = new BasicStroke(0, BasicStroke.CAP_BUTT, BasicStroke.JOIN_BEVEL, 1, pattern, 0);
                        drawVectrexScaledLine(g,(int)x0, (int)y0, (int)x1, (int)y1, true, dashed, vars.drawArrows, vars.drawPositions, pos++, v);
                    }
                    else
                    {
                        g.setColor(vars.MOVE_COLOR);
                        drawVectrexScaledLine(g,(int)x0, (int)y0, (int)x1, (int)y1, true, null, vars.drawArrows, vars.drawPositions, pos++, v);
                    }
                }
                else
                {
                    drawVectrexScaledLine(g,(int)x0, (int)y0, (int)x1, (int)y1, true, null, vars.drawArrows, vars.drawPositions, pos++, v);
                }


            } // Foreground Vectors done
        }
        
        
        // draw highlighted points (mouse is on them)
        if (vars.hightLightVPoint != null) 
        {
            if (vars.hightLightVPoint.highlight)
            {
                double x0=vars.hightLightVPoint.coord()[horizontalAxis]+usedxOff;
                double y0=(vars.hightLightVPoint.coord()[verticalAxis]-usedyOff)*-1;

                if (vars.isScale)
                {
                    x0 = x0Offset+Scaler.scaleDoubleToInt(x0, scaleUse);
                    y0 = y0Offset+Scaler.scaleDoubleToInt(y0, scaleUse);
                }
                else
                {
                    x0 = x0Offset+x0;
                    y0 = x0Offset+y0;
                }
                g.setColor(vars.POINT_HIGHLIGHT_COLOR);
                g.drawOval((int)x0-vars.POINT_HIGHLIGHT_RADIUS, (int)y0-vars.POINT_HIGHLIGHT_RADIUS, vars.POINT_HIGHLIGHT_RADIUS*2, vars.POINT_HIGHLIGHT_RADIUS*2);
            }
        }

        // draw highlighted vector (mouse is on)
        if (vars.hightLightVector != null) 
        {
            if (vars.hightLightVector.highlight)
            {
                double x0=vars.hightLightVector.start.coord()[horizontalAxis]+usedxOff;
                double y0=(vars.hightLightVector.start.coord()[verticalAxis]-usedyOff)*-1;
                double x1=vars.hightLightVector.end.coord()[horizontalAxis]+usedxOff;
                double y1=(vars.hightLightVector.end.coord()[verticalAxis]-usedyOff)*-1;
                
                if (vars.isScale)
                {
                    x0 = x0Offset+Scaler.scaleDoubleToInt(x0, scaleUse);
                    y0 = y0Offset+Scaler.scaleDoubleToInt(y0, scaleUse);
                    x1 = x0Offset+Scaler.scaleDoubleToInt(x1, scaleUse);
                    y1 = y0Offset+Scaler.scaleDoubleToInt(y1, scaleUse);
                }
                else
                {
                    x0 = x0Offset+x0;
                    y0 = x0Offset+y0;
                    x1 = x0Offset+x1;
                    y1 = x0Offset+y1;
                }
                g.setColor(vars.VECTOR_HIGHLIGHT_COLOR);
                
                // construct a perpendicular vector for a 
                // paralle transition
                double py = x0-x1;
                double px = -(y0-y1);
                double l = Math.sqrt((Math.pow(py,2) + Math.pow(px,2)));
                
                double transition = vars.VECTOR_HIGHLIGHT_RADIUS;
                
                double px0 = x0 + (transition / l) * px;
                double py0 = y0 + (transition / l) * py;
                double px1 = x1 + (transition / l) * px;
                double py1 = y1 + (transition / l) * py;
                
                double transition2 = -vars.VECTOR_HIGHLIGHT_RADIUS;
                
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
        
        // draw selected vectors/ points 
        synchronized (vars.foregroundVectors.list)
        {
            for (GFXVector v: vars.foregroundVectors.list)
            {
                // draw selected vectors
                if (v.selected)
                {
                    
                    double x0=v.start.coord()[horizontalAxis]+usedxOff;
                    double y0=(v.start.coord()[verticalAxis]-usedyOff)*-1;
                    double x1=v.end.coord()[horizontalAxis]+usedxOff;
                    double y1=(v.end.coord()[verticalAxis]-usedyOff)*-1;

                    if (vars.isScale)
                    {
                        x0 = x0Offset+Scaler.scaleDoubleToInt(x0, scaleUse);
                        y0 = y0Offset+Scaler.scaleDoubleToInt(y0, scaleUse);
                        x1 = x0Offset+Scaler.scaleDoubleToInt(x1, scaleUse);
                        y1 = y0Offset+Scaler.scaleDoubleToInt(y1, scaleUse);
                    }
                    else
                    {
                        x0 = x0Offset+x0;
                        y0 = x0Offset+y0;
                        x1 = x0Offset+x1;
                        y1 = x0Offset+y1;
                    }
                    g.setColor(vars.VECTOR_SELECTED_COLOR);

                    // construct a perpendicular vector for a 
                    // paralle transition
                    double py = x0-x1;
                    double px = -(y0-y1);
                    double l = Math.sqrt((Math.pow(py,2) + Math.pow(px,2)));

                    double transition = vars.VECTOR_SELECTED_RADIUS;

                    double px0 = x0 + (transition / l) * px;
                    double py0 = y0 + (transition / l) * py;
                    double px1 = x1 + (transition / l) * px;
                    double py1 = y1 + (transition / l) * py;

                    double transition2 = -vars.VECTOR_SELECTED_RADIUS;

                    double px02 = x0 + (transition2 / l) * px;
                    double py02 = y0 + (transition2 / l) * py;
                    double px12 = x1 + (transition2 / l) * px;
                    double py12 = y1 + (transition2 / l) * py;

                    g.drawLine(((int) px0), ((int) py0), ((int) px1),((int) py1));
                    g.drawLine(((int) px02), ((int) py02), ((int) px12),((int) py12));

                    g.drawLine(((int) px0), ((int) py0), ((int) px02),((int) py02));
                    g.drawLine(((int) px1), ((int) py1), ((int) px12),((int) py12));
                }
                // draw selected point
                Vertex s = v.start;
                if (s.selected)
                {
                    double x0=s.coord()[horizontalAxis]+usedxOff;
                    double y0=(s.coord()[verticalAxis]-usedyOff)*-1;

                    if (vars.isScale)
                    {
                        x0 = x0Offset+Scaler.scaleDoubleToInt(x0, scaleUse);
                        y0 = y0Offset+Scaler.scaleDoubleToInt(y0, scaleUse);
                    }
                    else
                    {
                        x0 = x0Offset+x0;
                        y0 = x0Offset+y0;
                    }
                    g.setColor(vars.POINT_SELECTED_COLOR);
                    g.drawOval((int)x0-vars.POINT_SELECTED_RADIUS, (int)y0-vars.POINT_SELECTED_RADIUS, vars.POINT_SELECTED_RADIUS*2, vars.POINT_SELECTED_RADIUS*2);
                }
                s = v.end;
                if (s.selected)
                {
                    double x0=s.coord()[horizontalAxis]+usedxOff;
                    double y0=(s.coord()[verticalAxis]-usedyOff)*-1;

                    if (vars.isScale)
                    {
                        x0 = x0Offset+Scaler.scaleDoubleToInt(x0, scaleUse);
                        y0 = y0Offset+Scaler.scaleDoubleToInt(y0, scaleUse);
                    }
                    else
                    {
                        x0 = x0Offset+x0;
                        y0 = x0Offset+y0;
                    }
                    g.setColor(vars.POINT_SELECTED_COLOR);
                    g.drawOval((int)x0-vars.POINT_SELECTED_RADIUS, (int)y0-vars.POINT_SELECTED_RADIUS, vars.POINT_SELECTED_RADIUS*2, vars.POINT_SELECTED_RADIUS*2);
                }
            }
        }        
        
        // draw "cross" (if allowed)
        if ((!noCross) && (vars.crossDrawn))
        {
            // befor vectors, so we can check against cross variables
            lastCrossX = potentialCrossX;
            lastCrossY = potentialCrossY;
            g.setColor(vars.crossColor);
            g.drawLine(0, lastCrossY, getWidth(), lastCrossY);
            g.drawLine(lastCrossX, 0, lastCrossX, getHeight());
        }

        // draw a "dragged" vector (continous mode)
        // if no cross is drawn, than also don't draw "draggin" or "continue"
        if (!noCross)
        {
            // only draw a "dragging" if mode is SET
            if (vars.workingMode == SVP_SET)
            {
                if ((vars.dragging) || (vars.continueMode))
                {
                    g.setColor(vars.VECTOR_DRAG_COLOR);
                    g.drawLine(mXPressStart, mYPressStart, lastCrossX, lastCrossY);
                }
            }
        }

        // restore original color
        g.setColor(c);
        
    }
    
    void clearSelectedVertice()
    {
        vars.selectedVertexOrder.clear();
    }
    void addVertexSelection(Vertex v)
    {
        if (v == null) return;
        vars.selectedVertexOrder.remove(v); // allow doubles for a closed poligon?
        vars.selectedVertexOrder.add(v);
    }
    void removeVertexSelection(Vertex v)
    {
        if (v == null) return;
        vars.selectedVertexOrder.remove(v);
    }
    
    public ArrayList<Vertex> getPointSelectionOrder()
    {
        return vars.selectedVertexOrder;
    }
    public boolean isGrid()
    {
        return vars.displayGrid;
    }
}



